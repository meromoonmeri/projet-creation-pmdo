#!/usr/bin/env python3
"""Vérifications indépendantes FCV3; ne lance pas le runtime PMDO.
Usage : .venv/bin/python source/fin_couloir_violet_v3/verify.py
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
OUT = ROOT / "renders/fin_couloir_violet_v3"
STAGE = ROOT / ".cache/fin_couloir_violet_v3/fin_couloir_violet_v3"


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"Module introuvable : {path}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def main() -> None:
    manifest_path = OUT / "manifest.json"
    if not manifest_path.exists() or not (STAGE / "Mod.xml").exists():
        subprocess.run([sys.executable, str(HERE / "build.py")], cwd=ROOT, check=True)
    subprocess.run([sys.executable, "-m", "unittest",
                    "source.fin_couloir_violet_v3.test_build", "-v"], cwd=ROOT, check=True)

    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    assert manifest["size_px"] == [768, 576]
    assert manifest["grid_cells"] == [96, 72]
    assert manifest["pmdo"]["version"] == "0.8.12.0"
    assert manifest["pmdo"]["runtime_tested"] is False
    assert manifest["pmdo"]["warp"] == "aucun"
    assert manifest["pmdo"]["exit"] == "aucune"
    assert manifest["agent_choices"]["prefix"] == "FCV3"
    assert manifest["agent_choices"]["reference"].startswith("rip rendu de l'entrée S05P03A")

    ora_path = ROOT / ".cache/fin_couloir_violet_v3/FCV3_calques.ora"
    with zipfile.ZipFile(ora_path) as archive:
        assert archive.read("mimetype") == b"image/openraster"
        assert {"stack.xml", "mergedimage.png", "Thumbnails/thumbnail.png"} <= set(archive.namelist())
        ET.fromstring(archive.read("stack.xml"))

    mod_xml = ET.parse(STAGE / "Mod.xml").getroot()
    assert mod_xml.findtext("Namespace") == manifest["namespace"]
    assert mod_xml.findtext("GameVersion") == "0.8.12.0"

    # Dry-run de l'installeur dans un dossier jetable, sans écriture de Content/Data.
    temp_root = ROOT / ".cache"
    temp_root.mkdir(parents=True, exist_ok=True)
    installer = load_module("installer_fcv3_verify", STAGE / "INSTALLER.py")
    with tempfile.TemporaryDirectory(prefix="fcv3_install_dry_run_", dir=temp_root) as temporary:
        target = Path(temporary)
        (target / "Mod.xml").write_bytes((STAGE / "Mod.xml").read_bytes())
        installer.install(STAGE, target, dry_run=True, namespace=manifest["namespace"])
        assert (target / "Mod.xml").is_file()
        assert not (target / "Content").exists(), "dry-run ne doit rien écrire"
        assert not (target / "Data").exists(), "dry-run ne doit rien écrire"

    print("PASS — provenance, couleur, calques, collisions, accès 16x16, ORA, Ground/.tile et installeur dry-run vérifiés.")
    print("NOTE — aucun moteur PMDO, rendu GPU ni test de gameplay en jeu n'a été exécuté.")


if __name__ == "__main__":
    main()
