import unittest

from py import commons


class TestCommons(unittest.TestCase):
    def test_change_ext_to_txt(self):
        self.assertEqual(commons.change_ext_to_txt("file.txt"), "file.txt")
        self.assertEqual(commons.change_ext_to_txt("file.doc"), "file.txt")
        self.assertEqual(commons.change_ext_to_txt("file.docx"), "file.txt")
        self.assertEqual(commons.change_ext_to_txt("file.pdf"), "file.txt")
        self.assertEqual(commons.change_ext_to_txt("file"), "file.txt")
        self.assertEqual(commons.change_ext_to_txt("file."), "file.txt")


if __name__ == "__main__":
    unittest.main()
