#!/usr/bin/env python3
"""Tests et verifie EFM1, puis cree les deux livrables ZIP deterministes."""
from __future__ import annotations

import base64
import json
import subprocess
import sys
import zipfile
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
OUT = ROOT / "renders/entree_foret_mousse_sud_nord_v1"
STAGE = ROOT / ".cache/entree_foret_mousse_sud_nord_v1/entree_foret_mousse"
ORA = ROOT / ".cache/entree_foret_mousse_sud_nord_v1/EFM1_calques.ora"


def zip_files(destination: Path, files: list[tuple[Path, str]]) -> None:
    destination.parent.mkdir(parents=True, exist_ok=True)
    with zipfile.ZipFile(destination, "w", compression=zipfile.ZIP_DEFLATED,
                         compresslevel=9, strict_timestamps=True) as archive:
        for source, arcname in sorted(files, key=lambda pair: pair[1]):
            info = zipfile.ZipInfo(arcname, date_time=(2020, 1, 1, 0, 0, 0))
            info.compress_type = zipfile.ZIP_DEFLATED
            info.external_attr = 0o100644 << 16
            archive.writestr(info, source.read_bytes(), compress_type=zipfile.ZIP_DEFLATED, compresslevel=9)


PFX = "EFM1"


def image_uri(path: Path) -> str:
    if not path.is_file():
        raise FileNotFoundError(f"Image de l'aperçu introuvable : {path}")
    return "data:image/png;base64," + base64.b64encode(path.read_bytes()).decode("ascii")


def standalone_preview() -> Path:
    """Create offline root and package-review previews, independent of ignored render files."""
    manifest = json.loads((OUT / "manifest.json").read_text(encoding="utf-8"))
    page = (HERE / "preview.html").read_text(encoding="utf-8")

    def replace_asset(reference: str, path: Path, expected_count: int = 1) -> None:
        nonlocal page
        if page.count(reference) != expected_count:
            raise ValueError(f"Nombre inattendu de références {reference}: {page.count(reference)}")
        page = page.replace(reference, image_uri(path))

    for layer in manifest["layers"]:
        if layer["phases"] > 1:
            # animation layer (spores)
            # preview contains a JS Array.from expression for this animation; replace it with embedded data URIs
            # find the placeholder for this layer by its file pattern
            ph=len([p for p in (OUT / "animation/spores").glob(f"{PFX}_08_spores_f*.png")])
            # the preview uses a JS expression with length 24 and path animation/spores/EFM1_08_spores_f
            refs = "frames:Array.from({length:24},(_,i)=>`../animation/spores/EFM1_08_spores_f${String(i).padStart(2,'0')}.png`)"
            frames = [
                image_uri(OUT / f"animation/spores/{PFX}_08_spores_f{phase:02d}.png")
                for phase in range(manifest["animation"]["phases"])
            ]
            if page.count(refs) != 1:
                raise ValueError("Référence de frames de spores absente ou dupliquée dans le gabarit")
            page = page.replace(refs, "frames:" + json.dumps(frames, separators=(",", ":")))
        else:
            replace_asset("../" + layer["file"], OUT / layer["file"])

    replace_asset(f"../review/{PFX}_collisions_marqueurs.png",
                  OUT / f"review/{PFX}_collisions_marqueurs.png")
    if any(prefix in page for prefix in ("../calques/", "../animation/", "../review/")):
        raise ValueError("Le gabarit contient encore des liens vers les rendus locaux")

    destination = ROOT / "apercu_entree_foret_mousse_v1.html"
    destination.write_text(page, encoding="utf-8")
    (OUT / "review/index.html").write_text(page, encoding="utf-8")
    return destination


def main() -> None:
    if not (OUT / "manifest.json").exists() or not (STAGE / "Mod.xml").exists():
        subprocess.run([sys.executable, str(HERE / "build.py")], cwd=ROOT, check=True)
    subprocess.run([sys.executable, str(HERE / "verify.py")], cwd=ROOT, check=True)

    project_files = []
    for source in sorted(STAGE.rglob("*")):
        if source.is_file():
            project_files.append((source, "entree_foret_mousse/" + source.relative_to(STAGE).as_posix()))
    project_zip = OUT / "EFM1_projet_pmdo_0812.zip"
    zip_files(project_zip, project_files)
    preview = standalone_preview()

    art_files: list[tuple[Path, str]] = []
    for folder in ("calques", "animation", "masques", "review"):
        for source in sorted((OUT / folder).rglob("*")):
            if source.is_file():
                art_files.append((source, source.relative_to(OUT).as_posix()))
    extra = [
        (ORA, "EFM1_calques.ora"),
        (OUT / "manifest.json", "manifest.json"),
        (OUT / "README.md", "README.md"),
        (HERE / "generation.json", "generation.json"),
        (HERE / "WORKFLOW.md", "WORKFLOW.md"),
        (HERE / "bruts/decor.png", "bruts/decor.png"),
        (HERE / "bruts/sol_complet.png", "bruts/sol_complet.png"),
    ]
    for src, arc in extra:
        if src.exists():
            art_files.append((src, arc))
    art_zip = OUT / "EFM1_calques_png_8px.zip"
    zip_files(art_zip, art_files)

    # Ensure the archives are readable and self-consistent before returning success.
    for archive_path in (project_zip, art_zip):
        with zipfile.ZipFile(archive_path) as archive:
            bad = archive.testzip()
            if bad:
                raise RuntimeError(f"Archive corrompue : {archive_path} / {bad}")
    print("Paquets EFM1 créés :")
    for path in (project_zip, art_zip, preview):
        print(f"  {path.relative_to(ROOT)} — {path.stat().st_size / 1_000_000:.2f} Mo")
    print("Les rendus et archives de build restent dans renders/ et .cache/ (non versionnés).")


if __name__ == "__main__":
    main()
