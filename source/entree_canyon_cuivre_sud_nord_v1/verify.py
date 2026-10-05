#!/usr/bin/env python3
"""Verification independante EOC1. Cela ne lance pas le moteur PMDO.
Usage: .venv/bin/python source/entree_canyon_cuivre_sud_nord_v1/verify.py
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
OUT = ROOT / "renders/entree_canyon_cuivre_sud_nord_v1"
STAGE = ROOT / ".cache/entree_canyon_cuivre_sud_nord_v1/entree_canyon_cuivre"


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"Module introuvable : {path}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def main() -> None:
    manifest_path = OUT / "manifest.json"
    if not manifest_path.exists():
        subprocess.run([sys.executable, str(HERE / "build.py")], cwd=ROOT, check=True)
    subprocess.run([sys.executable, "-m", "unittest",
                    "source.entree_canyon_cuivre_sud_nord_v1.test_build", "-v"], cwd=ROOT, check=True)

    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    assert manifest["size_px"] == [768, 576]
    assert manifest["grid_cells"] == [96, 72]
    assert manifest["pmdo"]["version"] == "0.8.12.0"
    assert manifest["pmdo"]["runtime_tested"] is False
    assert manifest["art_approved"] is False
    assert manifest["pmdo"]["warp"] is None

    # Independent OpenRaster container check.
    ora_path = ROOT / ".cache/entree_canyon_cuivre_sud_nord_v1/EOC1_calques.ora"
    with zipfile.ZipFile(ora_path) as archive:
        assert archive.read("mimetype") == b"image/openraster"
        assert {"stack.xml", "mergedimage.png", "Thumbnails/thumbnail.png"} <= set(archive.namelist())
        ET.fromstring(archive.read("stack.xml"))

    # Installer dry-run against a disposable mod root: parse every .tile and ensure
    # the packaged index is merged without overwriting an existing mod index.
    temp_root = ROOT / ".cache"
    temp_root.mkdir(parents=True, exist_ok=True)
    installer = load_module("installer_eoc1_verify", STAGE / "INSTALLER.py")
    with tempfile.TemporaryDirectory(prefix="eoc1_install_dry_run_", dir=temp_root) as temp:
        target = Path(temp)
        (target / "Mod.xml").write_bytes((STAGE / "Mod.xml").read_bytes())
        installer.install(STAGE, target, dry_run=True, namespace=manifest["namespace"])
        assert (target / "Mod.xml").exists()
        assert not (target / "Content").exists(), "dry-run ne doit rien écrire"
        assert not (target / "Data").exists(), "dry-run ne doit rien écrire"

    print("PASS — images, partition des calques, boucle, accès 16x16, ORA, Ground/.tile et installateur dry-run vérifiés.")
    print("NOTE — aucune validation graphique ou de gameplay dans PMDO n'a été exécutée.")


if __name__ == "__main__":
    main()
