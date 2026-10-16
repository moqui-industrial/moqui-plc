from __future__ import annotations

import sys
import unittest
from pathlib import Path

SCRIPTS = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(SCRIPTS))

import codesys_namespaces as cn  # noqa: E402
import moqui_plc_config as config  # noqa: E402
from ax_port.transforms import convert_text  # noqa: E402


class CodesysNamespaceTests(unittest.TestCase):
    def test_qualified_symbols_become_vendor_neutral(self) -> None:
        source = (
            "VAR\n"
            "\tpower : SM3_Basic.MC_Power;\n"
            "\taxis : REFERENCE TO SM3_Basic.AXIS_REF_SM3;\n"
            "\tgroup : SM3_Robotics.AXIS_GROUP_REF_SM3;\n"
            "\tmode : SM3_Basic.MC_BUFFER_MODE := SM3_Basic.MC_BUFFER_MODE.aborting;\n"
            "END_VAR\n"
        )
        text, unknown = cn.to_canonical(source)
        self.assertEqual(set(), unknown)
        self.assertIn("\tpower : MC_Power;\n", text)
        self.assertIn("\taxis : REFERENCE TO AXIS_REF;\n", text)
        self.assertIn("\tgroup : AXES_GROUP_REF;\n", text)
        self.assertIn("\tmode : MC_BUFFER_MODE := MC_BUFFER_MODE.aborting;\n", text)
        self.assertNotIn("SM3_", text)

    def test_canonical_to_codesys_round_trip_is_exact(self) -> None:
        canonical = (
            "\tpower : MC_Power;\n"
            "\taxis : REFERENCE TO AXIS_REF;\n"
            "\tgroup : AXES_GROUP_REF;\n"
            "\tdirection : MC_Direction := MC_DIRECTION.positive;\n"
        )
        codesys = cn.to_codesys(canonical)
        self.assertIn("SM3_Basic.MC_Power", codesys)
        self.assertIn("SM3_Basic.AXIS_REF_SM3", codesys)
        self.assertIn("SM3_Robotics.AXIS_GROUP_REF_SM3", codesys)
        self.assertIn("SM3_Basic.MC_Direction := SM3_Basic.MC_DIRECTION.positive", codesys)
        self.assertEqual(canonical, cn.to_canonical(codesys)[0])

    def test_comments_pragmas_and_strings_are_untouched(self) -> None:
        source = (
            "(* SM3_Basic.MC_Power (* nested SM3_Basic.MC_Stop *) still comment *)\n"
            "// SM3_Robotics.MC_GroupEnable\n"
            "/* SM3_Basic.MC_Home */\n"
            "{attribute 'SM3_Basic.MC_Jog'}\n"
            "msg := 'SM3_Basic.MC_Reset';\n"
            "x : SM3_Basic.MC_Halt;\n"
        )
        text, _unknown = cn.to_canonical(source)
        self.assertEqual(source.replace("x : SM3_Basic.MC_Halt;", "x : MC_Halt;"), text)
        self.assertEqual("(* MC_Power *)\nmsg := 'MC_Power';\n", cn.to_codesys("(* MC_Power *)\nmsg := 'MC_Power';\n"))

    def test_member_access_and_longer_identifiers_are_not_matched(self) -> None:
        canonical = "a := fb.MC_Power; b := MC_PowerExtra; c := myMC_Power;\n"
        self.assertEqual(canonical, cn.to_codesys(canonical))

    def test_unknown_symbol_is_left_qualified_and_reported(self) -> None:
        text, unknown = cn.to_canonical("x : SM3_Basic.MC_NotInTable;\n")
        self.assertEqual("x : SM3_Basic.MC_NotInTable;\n", text)
        self.assertEqual({"SM3_Basic.MC_NotInTable"}, unknown)

    def test_every_renamed_symbol_is_in_a_library(self) -> None:
        all_symbols = {s for symbols in config.CODESYS_LIBRARY_SYMBOLS.values() for s in symbols}
        self.assertTrue(set(config.CODESYS_RENAMED_SYMBOLS) <= all_symbols)
        self.assertTrue(set(config.CODESYS_VENDOR_EXTENSION_SYMBOLS) <= all_symbols)

    def test_canonical_iec_tree_has_no_codesys_qualifiers(self) -> None:
        iec_root = Path(config.IEC61131_ROOT)
        for path in iec_root.rglob("*.st"):
            text = path.read_text(encoding="utf-8")
            self.assertEqual(set(), cn.remaining_qualified(text), str(path))
            self.assertEqual(text, cn.to_canonical(cn.to_codesys(text))[0], str(path))


class AxMotionTransformTests(unittest.TestCase):
    def test_canonical_and_qualified_motion_names_convert_the_same(self) -> None:
        canonical = "\tgroup : AXES_GROUP_REF;\n\tendPoint : SMC_POS_REF;\n\tmode : MC_BUFFER_MODE;\n"
        qualified = cn.to_codesys(canonical)
        expected = "\tgroup : TO_Kinematics;\n\tendPoint : CoordMotion.SMC_POS_REF;\n\tmode : Motion.MC_BUFFER_MODE;\n"
        self.assertEqual(expected, convert_text(Path("Trajectory.st"), canonical, set()).text)
        self.assertEqual(expected, convert_text(Path("Trajectory.st"), qualified, set()).text)


if __name__ == "__main__":
    unittest.main()
