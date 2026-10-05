#!/usr/bin/env python3
"""Tests et verifie EOC1, puis cree les deux livrables ZIP deterministes."""
from __future__ import annotations

import subprocess
import sys
import zipfile
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
OUT = ROOT / "renders/entree_canyon_cuivre_sud_nord_v1"
STAGE = ROOT / ".cache/entree_canyon_cuivre_sud_nord_v1/entree_canyon_cuivre"
ORA = ROOT / ".cache/entree_canyon_cuivre_sud_nord_v1/EOC1_calques.ora"


def zip_files(destination: Path, files: list[tuple[Path, str]]) -> None:
    destination.parent.mkdir(parents=True, exist_ok=True)
    with zipfile.ZipFile(destination, "w", compression=zipfile.ZIP_DEFLATED,
                         compresslevel=9, strict_timestamps=True) as archive:
        for source, arcname in sorted(files, key=lambda pair: pair[1]):
            info = zipfile.ZipInfo(arcname, date_time=(2020, 1, 1, 0, 0, 0))
            info.compress_type = zipfile.ZIP_DEFLATED
            info.external_attr = 0o100644 << 16
            archive.writestr(info, source.read_bytes(), compress_type=zipfile.ZIP_DEFLATED, compresslevel=9)


def standalone_preview() -> Path:
    """Create a root-level preview whose image URLs remain relative to the repository."""
    page = (HERE / "preview.html").read_text(encoding="utf-8")
    prefix = "renders/entree_canyon_cuivre_sud_nord_v1/"
    for old, new in (("../calques/", prefix + "calques/"),
                     ("../animation/", prefix + "animation/"),
                     ("../review/", prefix + "review/")):
        page = page.replace(old, new)
    destination = ROOT / "apercu_entree_canyon_cuivre_v1.html"
    destination.write_text(page, encoding="utf-8")
    return destination


def main() -> None:
    if not (OUT / "manifest.json").exists() or not (STAGE / "Mod.xml").exists():
        subprocess.run([sys.executable, str(HERE / "build.py")], cwd=ROOT, check=True)
    subprocess.run([sys.executable, str(HERE / "verify.py")], cwd=ROOT, check=True)

    project_files = []
    for source in sorted(STAGE.rglob("*")):
        if source.is_file():
            project_files.append((source, "entree_canyon_cuivre/" + source.relative_to(STAGE).as_posix()))
    project_zip = OUT / "EOC1_projet_pmdo_0812.zip"
    zip_files(project_zip, project_files)
    preview = standalone_preview()

    art_files: list[tuple[Path, str]] = []
    for folder in ("calques", "animation", "masques", "review"):
        for source in sorted((OUT / folder).rglob("*")):
            if source.is_file():
                art_files.append((source, source.relative_to(OUT).as_posix()))
    art_files.extend([
        (ORA, "EOC1_calques.ora"),
        (OUT / "manifest.json", "manifest.json"),
        (OUT / "README.md", "README.md"),
        (HERE / "generation.json", "generation.json"),
        (HERE / "WORKFLOW.md", "WORKFLOW.md"),
        (HERE / "bruts/decor.png", "bruts/decor.png"),
        (HERE / "bruts/sol_complet.png", "bruts/sol_complet.png"),
    ])
    art_zip = OUT / "EOC1_calques_png_8px.zip"
    zip_files(art_zip, art_files)

    # Ensure the archives are readable and self-consistent before returning success.
    for archive_path in (project_zip, art_zip):
        with zipfile.ZipFile(archive_path) as archive:
            bad = archive.testzip()
            if bad:
                raise RuntimeError(f"Archive corrompue : {archive_path} / {bad}")
    print("Paquets EOC1 créés :")
    for path in (project_zip, art_zip, preview):
        print(f"  {path.relative_to(ROOT)} — {path.stat().st_size / 1_000_000:.2f} Mo")
    print("Les rendus et archives de build restent dans renders/ et .cache/ (non versionnés).")


if __name__ == "__main__":
    main()
