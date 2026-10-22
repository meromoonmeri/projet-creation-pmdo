#!/usr/bin/env python3
from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import subprocess
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
EVIDENCE = ROOT / "docs/canonical_journeys/primitive_adapter_runtime"
MODULE = ROOT / "Data/Script/halcyon/pmdred_eu/CanonicalPrimitiveAdapters.lua"


def sha(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


class PrimitiveAdapterRuntimeTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.pmdo = Path(PMDO).resolve()

    def test_published_evidence_revalidates_byte_for_byte(self):
        with tempfile.TemporaryDirectory(dir=ROOT / ".runtime-cache") as temp:
            output = Path(temp) / "validation.json"
            subprocess.run([
                "python3", str(ROOT / "tools/validate_pmdred_primitive_adapter_runtime.py"),
                "--events", str(EVIDENCE / "events.jsonl"),
                "--index-log", str(EVIDENCE / "index.log"),
                "--runtime-log", str(EVIDENCE / "runtime.log"),
                "--fixture-manifest", str(EVIDENCE / "fixture_manifest.json"),
                "--module", str(MODULE),
                "--pmdo", str(self.pmdo),
                "--output", str(output),
            ], cwd=ROOT, check=True, capture_output=True)
            self.assertEqual(output.read_bytes(), (EVIDENCE / "validation.json").read_bytes())
        result = json.loads((EVIDENCE / "validation.json").read_text())
        self.assertEqual(result["result"], "PASS_EXACT_PMDO_0_8_12")
        self.assertFalse(result["scope"]["certified_ground_revalidated"])
        self.assertFalse(result["scope"]["production_route_written"])
        self.assertEqual(result["scope"]["runtime_ready_asset_count"], 0)

    def test_evidence_hash_manifest_is_complete(self):
        rows = {}
        for line in (EVIDENCE / "evidence_hashes.sha256").read_text().splitlines():
            digest, name = line.split("  ", 1)
            rows[name] = digest
        expected = {"events.jsonl", "index.log", "runtime.log", "fixture_manifest.json", "validation.json"}
        self.assertEqual(set(rows), expected)
        for name, digest in rows.items():
            self.assertEqual(sha(EVIDENCE / name), digest)

    def test_fixture_scripts_match_the_published_manifest(self):
        spec = importlib.util.spec_from_file_location(
            "primitive_fixture_builder", ROOT / "tools/build_pmdred_primitive_adapter_runtime_fixture.py"
        )
        module = importlib.util.module_from_spec(spec)
        assert spec.loader is not None
        spec.loader.exec_module(module)
        manifest = json.loads((EVIDENCE / "fixture_manifest.json").read_text())
        self.assertEqual(hashlib.sha256(module.SERVICE.encode()).hexdigest(), manifest["validator_service_sha256"])
        self.assertEqual(hashlib.sha256(module.SINK.encode()).hexdigest(), manifest["sink_script_sha256"])
        self.assertEqual(sha(MODULE), manifest["production_module_sha256"])
        self.assertFalse(manifest["base_fixture_candidate_loaded"])
        self.assertFalse(manifest["certified_ground_revalidated"])
        self.assertFalse(manifest["production_route_written"])


if __name__ == "__main__":
    parser = argparse.ArgumentParser(add_help=False)
    parser.add_argument("--pmdo", required=True)
    args, remaining = parser.parse_known_args()
    PMDO = args.pmdo
    unittest.main(argv=[__file__, *remaining], verbosity=2)
