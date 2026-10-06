#!/usr/bin/env python3
"""Vérifie, empaquette FCV2 et produit un aperçu autonome avec calques interactifs."""
from __future__ import annotations

import base64
import json
import subprocess
import sys
import zipfile
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
OUT = ROOT / "renders/fin_couloir_violet_v2"
STAGE = ROOT / ".cache/fin_couloir_violet_v2/fin_couloir_violet"
PFX = "FCV2"


def zip_files(destination: Path, files: list[tuple[Path, str]]) -> None:
    destination.parent.mkdir(parents=True, exist_ok=True)
    with zipfile.ZipFile(destination, "w", compression=zipfile.ZIP_DEFLATED,
                         compresslevel=9, strict_timestamps=True) as archive:
        for source, arcname in sorted(files, key=lambda pair: pair[1]):
            info = zipfile.ZipInfo(arcname, date_time=(2020, 1, 1, 0, 0, 0))
            info.compress_type = zipfile.ZIP_DEFLATED
            info.external_attr = 0o100644 << 16
            archive.writestr(info, source.read_bytes(), compress_type=zipfile.ZIP_DEFLATED,
                             compresslevel=9)


def image_uri(path: Path) -> str:
    return "data:image/png;base64," + base64.b64encode(path.read_bytes()).decode("ascii")


def make_preview(manifest: dict) -> Path:
    stack = []
    for layer in manifest["layers"]:
        label = layer["name"].split("_", 1)[-1].replace("_", " ").title()
        stack.append({
            "id": layer["name"],
            "label": f"{layer['order']:02d} · {label}",
            "uri": image_uri(OUT / layer["file"]),
        })
    access = manifest["access"]
    data = {
        "layers": stack,
        "collisions": image_uri(OUT / f"review/{PFX}_collisions_marqueurs.png"),
        "access": {
            "entry": access["entry_px"],
            "boss": access["boss_px"],
            "objective": access["objective_px"],
        },
    }
    template = (HERE / "viewer_template.html").read_text(encoding="utf-8")
    if template.count("__DATA__") != 1:
        raise ValueError("Le gabarit d'aperçu doit avoir un unique emplacement __DATA__")
    page = template.replace("__DATA__", json.dumps(data, ensure_ascii=False, separators=(",", ":")))
    destination = ROOT / "apercu_fin_couloir_violet_v2.html"
    destination.write_text(page, encoding="utf-8")
    (OUT / "review/index.html").write_text(page, encoding="utf-8")
    return destination


def main() -> None:
    if not (OUT / "manifest.json").is_file() or not (STAGE / "Mod.xml").is_file():
        subprocess.run([sys.executable, str(HERE / "build.py")], cwd=ROOT, check=True)
    subprocess.run([sys.executable, str(HERE / "verify.py")], cwd=ROOT, check=True)
    manifest = json.loads((OUT / "manifest.json").read_text(encoding="utf-8"))
    preview = make_preview(manifest)

    project = OUT / f"{PFX}_projet_pmdo_0812.zip"
    project_files = [(path, "fin_couloir_violet/" + path.relative_to(STAGE).as_posix())
                     for path in sorted(STAGE.rglob("*")) if path.is_file()]
    zip_files(project, project_files)

    art_files = []
    for folder in ("calques", "masques", "review"):
        art_files.extend((path, path.relative_to(OUT).as_posix())
                         for path in sorted((OUT / folder).rglob("*")) if path.is_file())
    art_files.extend([
        (ROOT / ".cache/fin_couloir_violet_v2/FCV2_calques.ora", "FCV2_calques.ora"),
        (OUT / "manifest.json", "manifest.json"),
        (OUT / "README.md", "README.md"),
        (HERE / "generation.json", "generation.json"),
        (HERE / "viewer_template.html", "viewer_template.html"),
        (HERE / "bruts/decor.png", "bruts/decor.png"),
        (HERE / "bruts/sol_complet.png", "bruts/sol_complet.png"),
        (HERE / "reference/S05P03A.png", "reference/S05P03A.png"),
        (preview, preview.name),
    ])
    artwork = OUT / f"{PFX}_calques_png_8px.zip"
    zip_files(artwork, art_files)

    for archive_path in (project, artwork):
        with zipfile.ZipFile(archive_path) as archive:
            bad = archive.testzip()
            if bad:
                raise RuntimeError(f"Archive corrompue : {archive_path} / {bad}")
    print("Paquets FCV2 créés :")
    for path in (project, artwork, preview):
        print(f"  {path.relative_to(ROOT)} — {path.stat().st_size / 1_000_000:.2f} Mo")
    print("Le runtime PMDO n'est pas installé ici; les validations du moteur restent à faire en jeu.")


if __name__ == "__main__":
    main()
