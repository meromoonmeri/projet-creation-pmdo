#!/usr/bin/env python3
"""Unit tests for the Destiny title-screen component and safe Quest integration."""
from __future__ import annotations

import json
from pathlib import Path
import tempfile
import unittest
import xml.etree.ElementTree as ET

from source.pmdo_cote.integrate_destiny_title_screen import (
    COMPONENT_ROOT,
    QUEST_UUID,
    integrate_destiny_title_screen,
    validate_component,
    validate_installed_title_screen,
)


def make_mod_xml(namespace: str = "destiny", uuid: str = QUEST_UUID) -> bytes:
    return (
        '<?xml version="1.0" encoding="utf-8"?>\n'
        '<Header><Name>PMD Destiny — test</Name><Namespace>' + namespace + '</Namespace>'
        '<UUID>' + uuid + '</UUID><Version>1.0.0.0</Version>'
        '<GameVersion>0.8.12.0</GameVersion><ModType>Quest</ModType></Header>\n'
    ).encode("utf-8")


class DestinyTitleScreenIntegrationTests(unittest.TestCase):
    def test_component_headers_hashes_and_references(self) -> None:
        result = validate_component(COMPONENT_ROOT)
        self.assertEqual(len(result["files"]), 8)
        self.assertEqual(
            result["dirSheets"]["Content/BG/Destiny_Title_Screen_Background_Jour.dir"]["frames"],
            24,
        )
        self.assertEqual(
            result["dirSheets"]["Content/BG/Destiny_Title_Screen_Background_Nuit.dir"]["frames"],
            24,
        )

    def test_merge_preserves_mod_xml_and_other_content_settings(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            quest = Path(tmp)
            mod = make_mod_xml()
            (quest / "Mod.xml").write_bytes(mod)
            (quest / "README.md").write_text("# Test Destiny\n", encoding="utf-8")
            (quest / "Documentation").mkdir()
            (quest / "Documentation/QUEST_BUILD.json").write_text(
                json.dumps({"name": "PMD Destiny", "uuid": QUEST_UUID}, indent=2) + "\n",
                encoding="utf-8",
            )
            params = (
                '<?xml version="1.0"?><root><TitleBG>Old_Background</TitleBG>'
                '<TitleBGM>Preserved_Custom.ogg</TitleBGM><!-- keep this comment -->'
                '<KeepMe>yes</KeepMe></root>'
            ).encode("utf-8")
            (quest / "Content").mkdir()
            (quest / "Content/ContentParams.xml").write_bytes(params)

            first = integrate_destiny_title_screen(quest)
            self.assertTrue(first["integrated"])
            self.assertEqual(
                (quest / "Documentation/destiny_title_screen_manifest.json").read_bytes(),
                (COMPONENT_ROOT / "manifest.json").read_bytes(),
            )
            self.assertEqual((quest / "Mod.xml").read_bytes(), mod)
            installed = validate_installed_title_screen(quest)
            self.assertEqual(installed["status"], "PASS")
            root = ET.parse(quest / "Content/ContentParams.xml").getroot()
            self.assertEqual(root.findtext("TitleBG"), "Destiny_Title_Screen_Background")
            self.assertEqual(root.findtext("TitleBGM"), "Preserved_Custom.ogg")
            self.assertEqual(root.findtext("KeepMe"), "yes")
            self.assertIn(b"<!-- keep this comment -->", (quest / "Content/ContentParams.xml").read_bytes())
            build = json.loads((quest / "Documentation/QUEST_BUILD.json").read_text(encoding="utf-8"))
            self.assertTrue(build["titleScreen"]["integrated"])

            report_before = (quest / "Documentation/DESTINY_TITLE_SCREEN.json").read_bytes()
            second = integrate_destiny_title_screen(quest)
            report_after = (quest / "Documentation/DESTINY_TITLE_SCREEN.json").read_bytes()
            self.assertEqual(report_before, report_after)
            self.assertEqual(second["filesAddedOrUpdated"], 0)
            self.assertEqual((quest / "Mod.xml").read_bytes(), mod)

    def test_fresh_quest_gets_source_content_params_without_mod_xml_replacement(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            quest = Path(tmp)
            mod = make_mod_xml()
            (quest / "Mod.xml").write_bytes(mod)
            integrate_destiny_title_screen(quest)
            self.assertEqual((quest / "Mod.xml").read_bytes(), mod)
            root = ET.parse(quest / "Content/ContentParams.xml").getroot()
            self.assertEqual(root.findtext("TitleBG"), "Destiny_Title_Screen_Background")
            self.assertIsNotNone(root.find("Sounds"))
            self.assertEqual(root.findtext("TitleBGM"), "Top Menu Theme.ogg")
            self.assertEqual(root.findtext("MonsterBGM"), "Monster House!.ogg")
            validate_installed_title_screen(quest)

    def test_missing_titlebg_is_inserted_without_rewriting_other_xml(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            quest = Path(tmp)
            (quest / "Mod.xml").write_bytes(make_mod_xml())
            original = (
                '<?xml version="1.0" encoding="utf-8"?>\n'
                '<root>\n  <!-- preserve exactly -->\n  <CustomSetting value="keep" />\n</root>\n'
            ).encode("utf-8")
            (quest / "Content").mkdir()
            (quest / "Content/ContentParams.xml").write_bytes(original)
            integrate_destiny_title_screen(quest)
            merged = (quest / "Content/ContentParams.xml").read_bytes()
            self.assertIn(b"<!-- preserve exactly -->", merged)
            self.assertIn(b'<CustomSetting value="keep" />', merged)
            self.assertIn(b"<TitleBG>Destiny_Title_Screen_Background</TitleBG>", merged)
            self.assertEqual(merged.replace(b"<TitleBG>Destiny_Title_Screen_Background</TitleBG>\n", b""), original)

    def test_conflicting_asset_aborts_before_any_write(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            quest = Path(tmp)
            (quest / "Mod.xml").write_bytes(make_mod_xml())
            conflict = quest / "Content/UI/Title.png"
            conflict.parent.mkdir(parents=True)
            conflict.write_bytes(b"different title art")
            with self.assertRaisesRegex(ValueError, "Conflit de ressource"):
                integrate_destiny_title_screen(quest)
            self.assertEqual(conflict.read_bytes(), b"different title art")
            self.assertFalse((quest / "Content/ContentParams.xml").exists())
            self.assertFalse((quest / "Content/BG").exists())
            self.assertFalse((quest / "Documentation").exists())

    def test_non_destiny_identity_is_rejected(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            quest = Path(tmp)
            (quest / "Mod.xml").write_bytes(make_mod_xml(namespace="halcyon"))
            with self.assertRaisesRegex(ValueError, "Mod.xml cible refusé"):
                integrate_destiny_title_screen(quest)
            self.assertEqual(list(quest.iterdir()), [quest / "Mod.xml"])


if __name__ == "__main__":
    unittest.main()
