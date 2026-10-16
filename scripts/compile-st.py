#!/usr/bin/env python3
"""Compile the canonical iec61131 tree with an open-source ST compiler.

Targets:
  rusty    RuSTy (https://github.com/PLC-lang/rusty), ST -> LLVM -> native code
  ironplc  IronPLC (https://github.com/ironplc/ironplc), ST -> bytecode VM

The canonical tree targets CODESYS: it calls CODESYS libraries (SoftMotion,
MQTT, JSON, recipes, device diagnosis) and uses CODESYS syntax extensions.
Neither compiler ships those libraries. This script:

1. copies iec61131/ to codegen/target/<target>/src/ and rewrites the CODESYS
   dialect (scripts/st_dialect.py), leaving iec61131/ untouched;
2. adds the interface declarations under rust-plc/interfaces/: signatures of
   every external block, type and function the code uses, with no
   implementation;
3. runs the compiler and writes codegen/target/<target>/report.json plus a
   summary that separates problems in moqui-plc code from problems in the
   interface declarations.

A clean check means moqui-plc type-checks against the declared interfaces.
It does not make a running PLC: a runtime that hosts the code must implement
every interface (motion, MQTT, JSON, recipes, device tree) and provide the
scan loop and the I/O. See rust-plc/README.md.

Examples:
  python3 scripts/compile-st.py --target rusty
  python3 scripts/compile-st.py --target ironplc --compiler ~/ironplc/target/release/ironplcc
  python3 scripts/compile-st.py --target rusty --build      # object file for linking
"""
from __future__ import annotations

import argparse
import json
import re
import shutil
import subprocess
import sys
from collections import Counter
from pathlib import Path

SCRIPTS = Path(__file__).resolve().parent
sys.path.insert(0, str(SCRIPTS))

import moqui_plc_config as config  # noqa: E402
from st_dialect import DialectRewriter, enumeration_types, global_variable_lists  # noqa: E402

RUSTY_DIAGNOSTIC_RE = re.compile(r"^(?P<path>[^\s:][^:]*\.st):(?P<line>\d+):(?P<col>\d+):\{[^}]*\}: (?P<level>error|warning)\[(?P<code>E\d+)\]: (?P<msg>.*)$")
IRONPLC_HEAD_RE = re.compile(r"^(?P<level>error|warning)\[(?P<code>[A-Z0-9]+)\]: (?P<msg>[^\n]*)")
ANSI_RE = re.compile(r"\x1b\[[0-9;]*m")
IRONPLC_LOC_RE = re.compile(r"┌─ (?P<path>\S+?):(?P<line>\d+):(?P<col>\d+)")


def parse_args(argv: list[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--target", required=True, choices=config.COMPILE_ST_TARGETS)
    parser.add_argument("--compiler", help="compiler executable (default from moqui_plc_config.COMPILE_ST_COMMANDS)")
    parser.add_argument("--source", default=config.IEC61131_ROOT, help="canonical tree (default: iec61131/)")
    parser.add_argument("--interfaces", default=config.RUST_PLC_INTERFACES_ROOT, help="interface declarations")
    parser.add_argument("--no-interfaces", action="store_true", help="compile without interface declarations")
    parser.add_argument("--out", help="output directory (default: codegen/target/<target>)")
    parser.add_argument("--rusty-stdlib", default=config.RUSTY_STDLIB_ST_ROOT, help="RuSTy libs/stdlib/iec61131-st directory")
    parser.add_argument("--build", action="store_true", help="rusty: emit an object file instead of only checking")
    parser.add_argument("--prepare-only", action="store_true", help="write the rewritten tree, do not run the compiler")
    parser.add_argument("--max-lines", type=int, default=25, help="diagnostic groups shown in the summary")
    return parser.parse_args(argv)


def prepare(args: argparse.Namespace, out: Path) -> tuple[Path, list[Path], list[Path], Counter]:
    source = Path(args.source)
    src_out = out / "src"
    if src_out.exists():
        shutil.rmtree(src_out)
    excluded = set(config.COMPILE_ST_EXCLUDED_FILES.get(args.target, ()))
    sources = {p: p.read_text(encoding="utf-8") for p in sorted(source.rglob("*.st")) if p.relative_to(source).as_posix() not in excluded}
    interfaces = {}
    if not args.no_interfaces:
        iroot = Path(args.interfaces)
        interfaces = {p: p.read_text(encoding="utf-8") for p in sorted(iroot.rglob("*.st"))}
    rewriter = DialectRewriter(
        target=args.target,
        namespaces=config.EXTERNAL_LIBRARY_NAMESPACES,
        renamed=config.EXTERNAL_LIBRARY_RENAMED_SYMBOLS,
        parameter_lists=config.EXTERNAL_LIBRARY_PARAMETER_LISTS,
        global_lists=global_variable_lists(sources),
        enumerations=enumeration_types(list(sources.values()) + list(interfaces.values())),
    )
    written = []
    for path, text in sources.items():
        dest = src_out / path.relative_to(source)
        dest.parent.mkdir(parents=True, exist_ok=True)
        dest.write_text(rewriter.rewrite(text, path.name), encoding="utf-8")
        written.append(dest)
    iface_written = []
    for path, text in interfaces.items():
        dest = out / "interfaces" / path.relative_to(Path(args.interfaces))
        dest.parent.mkdir(parents=True, exist_ok=True)
        # interfaces use plain IEC syntax; only the IronPLC enum rewrite applies
        dest.write_text(rewriter.rewrite(text, path.name) if args.target == "ironplc" else text, encoding="utf-8")
        iface_written.append(dest)
    if (out / "interfaces").exists() and args.no_interfaces:
        shutil.rmtree(out / "interfaces")
    return src_out, written, iface_written, rewriter.counts


def run_rusty(args, compiler, out, sources, interfaces):
    cmd = [compiler, "--error-format", "clang"]
    if args.build:
        cmd += ["-c", "-o", str(out / "moqui-plc.o")]
    else:
        cmd += ["--check"]
    cmd += [str(p) for p in sources]
    for p in interfaces:
        cmd += ["-i", str(p)]
    if args.rusty_stdlib:
        for p in sorted(Path(args.rusty_stdlib).glob("*.st")):
            cmd += ["-i", str(p)]
    proc = subprocess.run(cmd, capture_output=True, text=True)
    output = proc.stdout + proc.stderr
    diags = []
    for line in output.splitlines():
        m = RUSTY_DIAGNOSTIC_RE.match(line)
        if m:
            diags.append({k: m.group(k) for k in ("path", "level", "code", "msg")} | {"line": int(m.group("line"))})
    return proc.returncode, output, diags


def run_ironplc(args, compiler, out, sources, interfaces):
    cmd = [compiler, "check", "--dialect", "codesys", "--allow-top-level-var-global", "--allow-c-style-comments"]
    cmd += [str(p) for p in sources + interfaces]
    proc = subprocess.run(cmd, capture_output=True, text=True)
    output = ANSI_RE.sub("", proc.stdout + proc.stderr)
    diags = []
    for block in re.split(r"\n(?=(?:error|warning)\[)", output):
        head = IRONPLC_HEAD_RE.match(block.strip())
        if not head:
            continue
        loc = IRONPLC_LOC_RE.search(block)
        diags.append(
            {
                "path": loc.group("path") if loc else "",
                "line": int(loc.group("line")) if loc else 0,
                "level": head.group("level"),
                "code": head.group("code"),
                "msg": head.group("msg").strip(),
            }
        )
    return proc.returncode, output, diags


def summarize(target, out, rc, diags, counts, args):
    src_prefix = str(out / "src")
    iface_prefix = str(out / "interfaces")
    for d in diags:
        d["origin"] = "interfaces" if d["path"].startswith(iface_prefix) else "moqui-plc" if d["path"].startswith(src_prefix) else "other"
        d["path"] = d["path"].replace(str(out) + "/", "")
    report = {
        "target": target,
        "exit_code": rc,
        "rewrites": dict(counts),
        "errors": sum(1 for d in diags if d["level"] == "error"),
        "warnings": sum(1 for d in diags if d["level"] == "warning"),
        "diagnostics": diags,
    }
    (out / "report.json").write_text(json.dumps(report, indent=1), encoding="utf-8")
    print(f"target: {target}  exit code: {rc}  errors: {report['errors']}  warnings: {report['warnings']}")
    for key, n in sorted(counts.items()):
        print(f"  rewrite: {key}: {n}")
    for origin in ("moqui-plc", "interfaces", "other"):
        group = [d for d in diags if d["origin"] == origin]
        if not group:
            continue
        files = len({d["path"] for d in group})
        print(f"\n{origin}: {len(group)} diagnostics in {files} files")
        msgs = Counter((d["level"], d["code"], re.sub(r"\b\d+\b", "N", d["msg"])) for d in group)
        for (level, code, msg), n in msgs.most_common(args.max_lines):
            print(f"  {n:5} {level} {code} {msg}")
    print(f"\nfull report: {out / 'report.json'}")


def main(argv: list[str]) -> int:
    args = parse_args(argv)
    out = (Path(args.out) if args.out else Path(config.COMPILE_ST_TARGET_ROOT) / args.target).resolve()
    out.mkdir(parents=True, exist_ok=True)
    _src, sources, interfaces, counts = prepare(args, out)
    print(f"rewrote {len(sources)} files and {len(interfaces)} interface files into {out}")
    if args.prepare_only:
        return 0
    compiler = args.compiler or config.COMPILE_ST_COMMANDS[args.target]
    if not shutil.which(compiler) and not Path(compiler).exists():
        print(f"compiler not found: {compiler} (set --compiler or MOQUI_PLC_{args.target.upper()})", file=sys.stderr)
        return 2
    if args.target == "rusty" and not args.rusty_stdlib:
        print("warning: no RuSTy standard library headers (--rusty-stdlib or MOQUI_PLC_RUSTY_STDLIB)", file=sys.stderr)
    runner = run_rusty if args.target == "rusty" else run_ironplc
    rc, output, diags = runner(args, compiler, out, sources, interfaces)
    (out / "compiler-output.txt").write_text(output, encoding="utf-8")
    summarize(args.target, out, rc, diags, counts, args)
    return 0 if rc == 0 else 1


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
