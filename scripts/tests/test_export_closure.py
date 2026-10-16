from __future__ import annotations

import importlib.util
import unittest
from pathlib import Path

SCRIPT = Path(__file__).resolve().parents[1] / "export-codesys.py"
spec = importlib.util.spec_from_file_location("export_codesys", SCRIPT)
export_codesys = importlib.util.module_from_spec(spec)
spec.loader.exec_module(export_codesys)


class TextualClosureTests(unittest.TestCase):
    def test_nested_header_comment_still_detects_function_block(self) -> None:
        declaration = "(* Usage:\n   (* nested example *)\n   x(signal := y);\n *)\nFUNCTION_BLOCK Filter\nVAR_INPUT\nEND_VAR\n"
        self.assertEqual("END_FUNCTION_BLOCK", export_codesys.detect_textual_closing_keyword(declaration))
        self.assertEqual("x := 1;\nEND_FUNCTION_BLOCK", export_codesys.ensure_textual_closure(declaration, "x := 1;\n"))

    def test_pragmas_and_line_comments_are_skipped(self) -> None:
        declaration = "{attribute 'qualified_only'}\n// header\n/* note */\nFUNCTION Scale : REAL\n"
        self.assertEqual("END_FUNCTION", export_codesys.detect_textual_closing_keyword(declaration))

    def test_commented_out_pou_is_not_a_header(self) -> None:
        declaration = "(* FUNCTION_BLOCK Old\nEND_FUNCTION_BLOCK *)\nPROGRAM Main\n"
        self.assertEqual("END_PROGRAM", export_codesys.detect_textual_closing_keyword(declaration))

    def test_existing_closure_is_not_duplicated(self) -> None:
        declaration = "FUNCTION_BLOCK A\n"
        self.assertEqual("x := 1;\nEND_FUNCTION_BLOCK", export_codesys.ensure_textual_closure(declaration, "x := 1;\nEND_FUNCTION_BLOCK"))


if __name__ == "__main__":
    unittest.main()
