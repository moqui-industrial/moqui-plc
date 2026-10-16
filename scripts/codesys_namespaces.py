# -*- coding: utf-8 -*-
"""Map CODESYS library namespaces to vendor-neutral names and back.

CODESYS -> canonical:  SM3_Basic.MC_Power        -> MC_Power
                       SM3_Basic.AXIS_REF_SM3    -> AXIS_REF
canonical -> CODESYS:  MC_Power                  -> SM3_Basic.MC_Power
                       AXES_GROUP_REF            -> SM3_Robotics.AXIS_GROUP_REF_SM3

The symbol table lives in moqui_plc_config.py. Only code is transformed:
comments ((* *) nested, /* */, //), pragmas ({ }) and string literals are
copied unchanged, so the two directions are exact inverses.

Compatible with CPython 3 and IronPython 2.7 (export-codesys.py runs inside
CODESYS).

Command line (CPython 3):
    python3 scripts/codesys_namespaces.py to-canonical PATH...
    python3 scripts/codesys_namespaces.py to-codesys PATH...
    python3 scripts/codesys_namespaces.py check PATH...
PATH is a .st file or a directory searched for .st files.
"""
from __future__ import print_function

import io
import os
import re
import sys

_HERE = os.path.dirname(os.path.abspath(__file__))
if _HERE not in sys.path:
    sys.path.insert(0, _HERE)

import moqui_plc_config as config  # noqa: E402

_IDENTIFIER = r"[A-Za-z_][A-Za-z0-9_]*"


def _build_tables():
    to_canonical = {}
    to_codesys = {}
    for library, symbols in config.CODESYS_LIBRARY_SYMBOLS.items():
        for symbol in symbols:
            canonical = config.CODESYS_RENAMED_SYMBOLS.get(symbol, symbol)
            qualified = library + "." + symbol
            if canonical in to_codesys and to_codesys[canonical] != qualified:
                raise ValueError("Ambiguous canonical name %s: %s and %s" % (canonical, to_codesys[canonical], qualified))
            to_canonical[qualified] = canonical
            to_codesys[canonical] = qualified
    return to_canonical, to_codesys


TO_CANONICAL, TO_CODESYS = _build_tables()

_QUALIFIED_RE = re.compile(
    r"(?<![A-Za-z0-9_.])(" + "|".join(sorted(re.escape(l) for l in config.CODESYS_LIBRARY_SYMBOLS)) + r")\.(" + _IDENTIFIER + r")\b"
)
_CANONICAL_RE = re.compile(
    r"(?<![A-Za-z0-9_.])(" + "|".join(sorted((re.escape(n) for n in TO_CODESYS), key=len, reverse=True)) + r")\b"
)


def split_code(text):
    """Yield (is_code, segment) pairs covering text exactly."""
    i = 0
    n = len(text)
    start = 0
    while i < n:
        c = text[i]
        pair = text[i:i + 2]
        end = None
        if pair == "(*":
            depth = 0
            j = i
            while j < n:
                p = text[j:j + 2]
                if p == "(*":
                    depth += 1
                    j += 2
                elif p == "*)":
                    depth -= 1
                    j += 2
                    if depth == 0:
                        break
                else:
                    j += 1
            end = j
        elif pair == "/*":
            j = text.find("*/", i + 2)
            end = n if j < 0 else j + 2
        elif pair == "//":
            j = text.find("\n", i + 2)
            end = n if j < 0 else j
        elif c == "{":
            j = text.find("}", i + 1)
            end = n if j < 0 else j + 1
        elif c == "'" or c == '"':
            j = i + 1
            while j < n:
                if text[j] == "$":
                    j += 2
                    continue
                if text[j] == c:
                    j += 1
                    break
                j += 1
            end = j
        if end is None:
            i += 1
            continue
        if i > start:
            yield True, text[start:i]
        yield False, text[i:end]
        i = end
        start = end
    if start < n:
        yield True, text[start:]


def to_canonical(text):
    """Return (text, unknown) where unknown is the set of qualified symbols not in the table."""
    unknown = set()

    def repl(match):
        qualified = match.group(0)
        canonical = TO_CANONICAL.get(qualified)
        if canonical is None:
            unknown.add(qualified)
            return qualified
        return canonical

    parts = []
    for is_code, segment in split_code(text):
        parts.append(_QUALIFIED_RE.sub(repl, segment) if is_code else segment)
    return "".join(parts), unknown


def to_codesys(text):
    parts = []
    for is_code, segment in split_code(text):
        parts.append(_CANONICAL_RE.sub(lambda m: TO_CODESYS[m.group(1)], segment) if is_code else segment)
    return "".join(parts)


def remaining_qualified(text):
    """Qualified library symbols still present in code."""
    found = set()
    for is_code, segment in split_code(text):
        if is_code:
            found.update(m.group(0) for m in _QUALIFIED_RE.finditer(segment))
    return found


def _iter_st_files(paths):
    for path in paths:
        if os.path.isdir(path):
            for root, _dirs, files in os.walk(path):
                for name in sorted(files):
                    if name.lower().endswith(".st"):
                        yield os.path.join(root, name)
        else:
            yield path


def _read(path):
    with io.open(path, "r", encoding="utf-8", newline="") as handle:
        return handle.read()


def _write(path, text):
    with io.open(path, "w", encoding="utf-8", newline="") as handle:
        handle.write(text)


def main(argv):
    if len(argv) < 2 or argv[0] not in ("to-canonical", "to-codesys", "check"):
        print(__doc__)
        return 2
    command, paths = argv[0], argv[1:]
    changed = 0
    problems = 0
    for path in _iter_st_files(paths):
        original = _read(path)
        if command == "to-canonical":
            text, unknown = to_canonical(original)
            for symbol in sorted(unknown):
                problems += 1
                print("unknown symbol %s in %s: add it to moqui_plc_config.py" % (symbol, path))
        elif command == "to-codesys":
            text = to_codesys(original)
        else:
            text = original
            leftover = remaining_qualified(original)
            if leftover:
                problems += 1
                print("qualified symbols left in %s: %s" % (path, ", ".join(sorted(leftover))))
            if to_canonical(to_codesys(original))[0] != original:
                problems += 1
                print("round trip changes %s" % path)
        if text != original:
            _write(path, text)
            changed += 1
    print("%s: %d file(s) changed, %d problem(s)" % (command, changed, problems))
    return 1 if problems else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
