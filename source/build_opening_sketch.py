#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Constructeur de l'Opening « STUDIO SKETCH » de `Pokémon Mystery Dungeon : Destiny` — durée exacte `02:33` (`153,00 s`).

Même montage, mêmes assets et même musique que l'opening ULTIME ; chaque image est redessinée comme sur une feuille de studio d'animation 2D
(`opening_sketch_engine.js` : traits au crayon coloré qui bouillonnent, animation « on twos » à 12 images/s, aplats gouachés décalés du trait,
hachures croisées dans les ombres, papier à grain).

Sortie : `apercu_fangame_pmd_destiny_sketch.html` autonome (tout en `data:` URI, 0 requête externe).
"""
from __future__ import annotations

import json
import sys
from pathlib import Path

SOURCE_DIR = Path(__file__).resolve().parent
REPO_ROOT = SOURCE_DIR.parent
for p in (str(REPO_ROOT), str(SOURCE_DIR)):
    if p not in sys.path:
        sys.path.insert(0, p)

from source import build_opening_ultime as ULT  # type: ignore

SKETCH_ENGINE = SOURCE_DIR / "opening_sketch_engine.js"
OUT_HTML = REPO_ROOT / "apercu_fangame_pmd_destiny_sketch.html"
OUT_DIR = REPO_ROOT / "renders" / "pmd_destiny_fangame_v1" / "opening_sketch"
DURATION_S = 153.0


def template() -> str:
    tpl = ULT.TEMPLATE.read_text(encoding="utf-8")
    reps = [
        ("Opening ULTIME (02:33)", "Opening STUDIO SKETCH (02:33)"),
        ("Opening ULTIME — de l'abysse à la course lunaire, puis la chute", "Opening STUDIO SKETCH — la version crayonnée, dessinée image par image"),
        ("PMDDestinyUltime.create", "PMDDestinySketch.create"),
        ('<a href="index.html">← Galerie Studio</a>', '<a href="index.html">← Galerie Studio</a>\n    <a href="apercu_fangame_pmd_destiny_ultime.html">Opening ULTIME (version couleur)</a>'),
    ]
    for a, b in reps:
        assert a in tpl, f"gabarit : « {a} » introuvable"
        tpl = tpl.replace(a, b, 1)
    return tpl


def build_html() -> Path:
    assets = ULT.build_assets()
    tpl = template()
    assert "/*__ENGINE__*/" in tpl and "/*__ASSETS__*/" in tpl
    engine = ULT.engine_source() + "\n" + SKETCH_ENGINE.read_text(encoding="utf-8")
    html = tpl.replace("/*__ENGINE__*/", engine).replace("/*__ASSETS__*/", json.dumps(assets, ensure_ascii=False, separators=(",", ":")))
    OUT_HTML.write_text(html, encoding="utf-8")
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    meta = {
        "duration_seconds": DURATION_S, "base": "opening ULTIME (même montage)", "style": "studio d'animation 2D — sketch (crayon coloré, on twos 12 i/s, hachures, papier)",
        "resolution": [1280, 720], "fps_dessin": 12, "html_bytes": OUT_HTML.stat().st_size,
    }
    (OUT_DIR / "metadata.json").write_text(json.dumps(meta, ensure_ascii=False, indent=2), encoding="utf-8")
    return OUT_HTML


if __name__ == "__main__":
    out = build_html()
    print(out, out.stat().st_size // 1024, "Ko")
