#!/usr/bin/env python3
"""Regression tests for the ROM-backed PMD Red EU personality-quiz core."""

from __future__ import annotations

import hashlib
import json
import subprocess
import tempfile
import unittest
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
AUTHORITY = ROOT / "docs/pmdred_eu/narrative_migration/personality_quiz_fr_eu.json"
LUA_DATA = ROOT / "Data/Script/halcyon/ground/personality_test/pmdred_quiz_data.lua"
LUA_ENGINE = ROOT / "Data/Script/halcyon/ground/personality_test/pmdred_quiz_engine.lua"
RUNTIME = ROOT / "docs/pmdred_eu/narrative_migration/personality_quiz/runtime_core"
ROM = ROOT / ".runtime-cache/downloads/pmdred-eu.gba"
PRET = ROOT / ".runtime-cache/pmd-red-reference"
ROM_SHA256 = "0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd"
PRET_COMMIT = "bf0092d0e34fd8e49b859a0b5f96f00740faa42d"
PERSONALITIES = [
    "hardy", "docile", "brave", "jolly", "impish", "naive", "timid",
    "hasty", "sassy", "calm", "relaxed", "lonely", "quirky",
]
EXPECTED_SELECTED = [
    "hardy_1", "docile_1", "brave_1", "jolly_1",
    "impish_1", "naive_1", "timid_1", "hasty_1",
]


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def all_text_payloads(document: dict) -> list[dict]:
    result = []
    for question in document["questions"]:
        result.append(question["question"])
        result.extend(answer["text"] for answer in question["answers"])
    result.append(document["gender"]["question"])
    result.extend(document["gender"]["answers"])
    result.extend(document["eu_confirmation"].values())
    result.extend(document["presentation_text"].values())
    result.extend(document["descriptions"].values())
    return result


class PersonalityQuizCoreTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.document = json.loads(AUTHORITY.read_text())
        cls.questions = cls.document["questions"]
        cls.by_id = {row["id"]: row for row in cls.questions}

    def test_locked_authority_and_exact_inventory(self) -> None:
        authority = self.document["authority"]
        rules = self.document["rules"]
        self.assertEqual(self.document["schema"], "new-era.pmdred-eu-personality-quiz-authority.v1")
        self.assertEqual(self.document["classification"], "PMD_RED_EU_CANON")
        self.assertEqual(authority["rom_sha256"], ROM_SHA256)
        self.assertEqual(authority["pret_commit"], PRET_COMMIT)
        self.assertEqual(authority["record_count"], 219)
        self.assertEqual(rules["selectable_question_count"], 55)
        self.assertEqual(rules["branch_question_count"], 1)
        self.assertEqual(rules["asked_question_count"], 8)
        self.assertEqual(rules["personality_order"], PERSONALITIES)
        self.assertEqual(len(self.questions), 56)
        self.assertEqual([row["pointer_index"] for row in self.questions], list(range(56)))
        self.assertEqual(len(self.by_id), 56)

    def test_category_selection_order_and_branch_graph(self) -> None:
        selectable = [row for row in self.questions if row["selectable"]]
        branch_only = [row for row in self.questions if not row["selectable"]]
        self.assertEqual(len(selectable), 55)
        self.assertEqual(len(branch_only), 1)
        self.assertEqual(selectable[0]["id"], "hardy_1")
        self.assertEqual(selectable[-1]["id"], "misc_3")
        self.assertEqual(branch_only[0]["id"], "brave_2b")
        self.assertEqual(branch_only[0]["pointer_index"], 55)
        self.assertEqual(
            Counter(row["category"] for row in selectable),
            Counter({**{name: 4 for name in PERSONALITIES}, "misc": 3}),
        )
        trigger_answers = [
            (row["id"], index, answer)
            for row in self.questions
            for index, answer in enumerate(row["answers"], 1)
            if answer["value"] == 99
        ]
        self.assertEqual(len(trigger_answers), 1)
        question_id, answer_index, answer = trigger_answers[0]
        self.assertEqual((question_id, answer_index), ("brave_2a", 1))
        self.assertEqual(answer["effects"], {})
        self.assertEqual(
            [answer["effects"] for answer in self.by_id["brave_2b"]["answers"]],
            [{"sassy": 1, "relaxed": 1}, {"brave": 4}],
        )

    def test_french_records_are_byte_reversible_and_anchored(self) -> None:
        payloads = all_text_payloads(self.document)
        self.assertEqual(len(payloads), 219)
        self.assertEqual(len({row["macro"] for row in payloads}), 219)
        self.assertEqual(len({row["rom_record_address"] for row in payloads}), 219)
        for payload in payloads:
            self.assertEqual(
                bytes.fromhex(payload["raw_hex"]).decode("cp1252"),
                payload["rom_encoded_text"],
            )
            self.assertTrue(payload["segments"])
            self.assertTrue(all("text" in segment and "after" in segment for segment in payload["segments"]))
        hardy = self.by_id["hardy_1"]
        self.assertEqual(hardy["question"]["rom_text_address"], "0x0810E47A")
        self.assertEqual(
            hardy["question"]["display_text"],
            "Un contrôle va avoir lieu bientôt.\nComment le préparez-vous?",
        )
        self.assertEqual(hardy["answers"][0]["text"]["rom_text_address"], "0x0810E43C")
        self.assertEqual(hardy["answers"][0]["text"]["display_text"], "J'étudie beaucoup.")
        self.assertEqual(self.document["gender"]["question"]["rom_text_address"], "0x0810FD00")
        self.assertEqual(
            self.document["gender"]["question"]["display_text"],
            "Etes-vous un garçon ou une fille?",
        )

    def test_effects_and_generated_runtime_modules(self) -> None:
        allowed = set(PERSONALITIES)
        for question in self.questions:
            self.assertEqual(question["classification"], "PMD_RED_EU_CANON")
            self.assertGreaterEqual(len(question["answers"]), 2)
            for answer in question["answers"]:
                self.assertLessEqual(set(answer["effects"]), allowed)
                self.assertTrue(all(isinstance(value, int) and value >= 0 for value in answer["effects"].values()))
        self.assertEqual(
            [answer["effects"] for answer in self.by_id["hardy_1"]["answers"]],
            [{"hardy": 2}, {"relaxed": 2}, {"impish": 2}],
        )
        data_text = LUA_DATA.read_text()
        engine_text = LUA_ENGINE.read_text()
        self.assertIn("PMD_RED_EU_CANON", data_text)
        self.assertIn(ROM_SHA256, data_text)
        self.assertIn('branch_question = "brave_2b"', data_text)
        self.assertIn("function QuizEngine.SelectQuestions(next_int)", engine_text)
        self.assertIn("function QuizEngine.ApplyAnswer(state, question_id, answer_index)", engine_text)
        self.assertIn("function QuizEngine.ResolvePersonality(state, tie_start)", engine_text)
        self.assertNotIn("math.random", engine_text)

    def test_extractor_reproduces_tracked_outputs_when_locked_inputs_exist(self) -> None:
        if not ROM.is_file() or not (PRET / ".git").is_dir():
            self.skipTest("ignored locked ROM/pret inputs are not restored")
        self.assertEqual(sha256(ROM), ROM_SHA256)
        commit = subprocess.run(
            ["git", "-C", str(PRET), "rev-parse", "HEAD"],
            check=True,
            capture_output=True,
            text=True,
        ).stdout.strip()
        self.assertEqual(commit, PRET_COMMIT)
        with tempfile.TemporaryDirectory(dir=ROOT / ".runtime-cache") as temp:
            temp_path = Path(temp)
            subprocess.run(
                [
                    "python3", str(ROOT / "tools/extract_pmdred_eu_personality_quiz.py"),
                    "--rom", str(ROM),
                    "--pret-root", str(PRET),
                    "--json-output", str(temp_path / "authority.json"),
                    "--lua-output", str(temp_path / "data.lua"),
                ],
                check=True,
                cwd=ROOT,
                capture_output=True,
                text=True,
            )
            self.assertEqual((temp_path / "authority.json").read_bytes(), AUTHORITY.read_bytes())
            self.assertEqual((temp_path / "data.lua").read_bytes(), LUA_DATA.read_bytes())

    def test_archived_runtime_evidence_is_partial_and_integral(self) -> None:
        validation = json.loads((RUNTIME / "validation.json").read_text())
        self.assertEqual(validation["result"], "CORE_PASS_NOT_PRODUCTION_ROUTED")
        self.assertFalse(validation["full_quiz_integrated"])
        self.assertIn("FORBIDDEN_UNTIL", validation["promotion"])
        self.assertEqual(validation["pmdo"]["event_count"], 33)
        self.assertEqual(validation["selection_replay"]["selected_questions"], EXPECTED_SELECTED)
        self.assertEqual(validation["selection_replay"]["result"], "naive")
        self.assertGreater(validation["parallax"]["changed_rgb_pixels"], 0)
        manifest_rows = (RUNTIME / "evidence_hashes.sha256").read_text().splitlines()
        self.assertEqual(len(manifest_rows), 8)
        for row in manifest_rows:
            expected, relative = row.split("  ", 1)
            self.assertEqual(sha256(RUNTIME / relative), expected)


if __name__ == "__main__":
    unittest.main(verbosity=2)
