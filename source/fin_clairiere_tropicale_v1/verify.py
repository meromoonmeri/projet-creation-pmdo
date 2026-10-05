#!/usr/bin/env python3
"""Vérifications indépendantes FTL1; ne lance pas le moteur PMDO.
Usage : .venv/bin/python source/fin_clairiere_tropicale_v1/verify.py
"""
from __future__ import annotations

import importlib.util
import json
import subprocess
import sys
import tempfile
import zipfile
from pathlib import Path
from xml.etree import ElementTree as ET

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
OUT = ROOT / "renders/fin_clairiere_tropicale_v1"
STAGE = ROOT / ".cache/fin_clairiere_tropicale_v1/fin_clairiere_tropicale"


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"Module introuvable: {path}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def main() -> None:
    manifest_path = OUT / "manifest.json"
    if not manifest_path.is_file():
        subprocess.run([sys.executable, str(HERE / "build.py")], cwd=ROOT, check=True)
    subprocess.run([sys.executable, "-m", "unittest",
                    "source.fin_clairiere_tropicale_v1.test_build", "-v"], cwd=ROOT, check=True)
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    assert manifest["size_px"] == [768, 576]
    assert manifest["grid_cells"] == [96, 72]
    assert manifest["pmdo"]["version"] == "0.8.12.0"
    assert manifest["pmdo"]["runtime_tested"] is False
    assert manifest["pmdo"]["warp"] == "aucun"
    assert manifest["pmdo"]["exit"] == "aucune"
    assert manifest["normalization"]["grass_fidelity_estimate"]["distance_to_recorded_rip_mean"] < 35

    ora_path = ROOT / ".cache/fin_clairiere_tropicale_v1/FTL1_calques.ora"
    with zipfile.ZipFile(ora_path) as archive:
        assert archive.read("mimetype") == b"image/openraster"
        assert {"stack.xml", "mergedimage.png", "Thumbnails/thumbnail.png"} <= set(archive.namelist())
        ET.fromstring(archive.read("stack.xml"))

    mod_xml = ET.parse(STAGE / "Mod.xml").getroot()
    assert mod_xml.findtext("Namespace") == manifest["namespace"]
    assert mod_xml.findtext("GameVersion") == "0.8.12.0"

    temp_root = ROOT / ".cache"
    temp_root.mkdir(parents=True, exist_ok=True)
    installer = load_module("installer_ftl1_verify", STAGE / "INSTALLER.py")
    with tempfile.TemporaryDirectory(prefix="ftl1_install_dry_run_", dir=temp_root) as temporary:
        target = Path(temporary)
        (target / "Mod.xml").write_bytes((STAGE / "Mod.xml").read_bytes())
        installer.install(STAGE, target, dry_run=True, namespace=manifest["namespace"])
        assert (target / "Mod.xml").is_file()
        assert not (target / "Content").exists()
        assert not (target / "Data").exists()

    print("PASS — calques, palettes, segmentation auto, accès 16x16, ORA, Ground/.tile et installateur dry-run vérifiés.")
    print("NOTE — aucune validation graphique ou de gameplay dans PMDO n'a été exécutée.")


if __name__ == "__main__":
    main()
