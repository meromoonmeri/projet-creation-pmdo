#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Constructeur de l'Opening « ULTIME » de `Pokémon Mystery Dungeon : Destiny` — durée exacte `02:33` (`153,00 s`), calée sur
`Simple and Clean -Ray of Hope MIX-` (`2aafI3XvKxo`).

Assemblage (même musique, mêmes repères temporels que l'opening sprites) :
  0 → 31 s    : opening VOYAGE (abysse de bulles → surface)                          [moteur `opening_voyage_engine.js`]
  31 → 46 s   : COURSE LUNAIRE (Riolu / Évoli / Tiplouf, décor Moonlight de PMD Sky) + personnages en gros plan [`opening_ultime_engine.js`]
  46 → 153 s  : opening sprites (passage 46 s → 1:08 conservé, mêlée, chute, remontée, écran-titre) [moteur `opening_sprite_engine.js`]

Sortie : `apercu_fangame_pmd_destiny_ultime.html` autonome (tout en `data:` URI, 0 requête externe).
"""
from __future__ import annotations

import json
import sys
from pathlib import Path
from typing import Dict

SOURCE_DIR = Path(__file__).resolve().parent
REPO_ROOT = SOURCE_DIR.parent
for p in (str(REPO_ROOT), str(SOURCE_DIR)):
    if p not in sys.path:
        sys.path.insert(0, p)

from source import build_opening_sprite_cinematique_destiny as SPR  # type: ignore
from source import build_opening_voyage as VOY  # type: ignore

RENDERS = REPO_ROOT / "renders" / "pmd_destiny_fangame_v1"
ASSETS_DIR = RENDERS / "opening_assets"
OUT_DIR = RENDERS / "opening_ultime"
TEMPLATE = SOURCE_DIR / "opening_ultime_template.html"
ENGINES = [SOURCE_DIR / "opening_voyage_engine.js", SOURCE_DIR / "opening_sprite_engine.js", SOURCE_DIR / "opening_ultime_engine.js"]
OUT_HTML = REPO_ROOT / "apercu_fangame_pmd_destiny_ultime.html"
DURATION_S = 153.0

# Personnages de l'histoire (gros plans de la course lunaire) : animations réellement utilisées
EXTRA_ACTORS = {
    "0447": ["Walk"], "0133": ["Walk"], "0393": ["Walk"],
    "0151": ["Twirl"], "0251": ["Twirl"], "0490": ["Idle"],
    "0448": ["Pose"], "0571": ["Idle"], "0491": ["Idle"],
    "0380": ["Idle"], "0381": ["Idle"], "0492": ["Appeal"],
    "0282": ["Appeal"], "0040": ["Hop"], "0253": ["Pose"], "0441": ["Float"],
}
# Calques du clip « sprites » que la nouvelle ligne de temps ne montre plus (plans avant 46 s) : retirés pour alléger la page
PRUNE = {"anticWall", "ttSky", "opm1", "opm5", "plainsFar", "skyPeakFront", "forestFar", "forestMid", "forestRoad", "forestFg"}
PRUNE_PREFIX = ("it", "sh", "tm")


def build_assets() -> Dict[str, object]:
    a = SPR.build_assets()
    b = VOY.build_assets()
    imgs: Dict[str, str] = dict(a["imgs"])
    for k, v in b["imgs"].items():
        if k in imgs and imgs[k] != v:
            raise SystemExit(f"collision de clé image : {k}")
        imgs[k] = v
    for k in list(imgs):
        if k in PRUNE or (k[:2] in PRUNE_PREFIX and k[2:].isdigit()):
            del imgs[k]
    sheets = dict(a["sheets"])
    sheets.update(b["sheets"])
    manifest = json.loads((ASSETS_DIR / "manifest.json").read_text(encoding="utf-8"))
    cat_all = manifest["pmd_catalog"]["pokemon"]
    pokemon: Dict[str, dict] = {}
    for src in (a["catalog"]["pokemon"], b["catalog"]["pokemon"]):
        for pid, P in src.items():
            q = pokemon.setdefault(pid, {"name": P["name"], "anims": {}})
            q["anims"].update(P["anims"])
    for pid, names in EXTRA_ACTORS.items():
        q = pokemon.setdefault(pid, {"name": cat_all[pid].get("name", pid), "anims": {}})
        for n in names:
            if n in q["anims"] or n not in cat_all[pid]["anims"]:
                continue
            m = cat_all[pid]["anims"][n]
            sheets[m["file"]] = SPR.uri_png(ASSETS_DIR / "pmd_sprites" / m["file"])
            q["anims"][n] = {k: m[k] for k in ("file", "fw", "fh", "cols", "rows", "durations")}
    cat = {"pokemon": pokemon, "antic": a["catalog"]["antic"], "vfx": a["catalog"]["vfx"]}
    return {"imgs": imgs, "sheets": sheets, "catalog": cat}


def engine_source() -> str:
    voy, spr, ult = (p.read_text(encoding="utf-8") for p in ENGINES)
    old = "OC: 0.8,"
    assert old in spr, "XF.OC introuvable dans le moteur sprites"
    spr = spr.replace(old, "OC: 0,", 1)  # plus de fondu depuis le plan « chute » (supprimé) : l'océan arrive après le flash blanc de la course lunaire
    return "\n".join((voy, spr, ult))


def build_html() -> Path:
    assets = build_assets()
    tpl = TEMPLATE.read_text(encoding="utf-8")
    assert "/*__ENGINE__*/" in tpl and "/*__ASSETS__*/" in tpl
    html = tpl.replace("/*__ENGINE__*/", engine_source()).replace("/*__ASSETS__*/", json.dumps(assets, ensure_ascii=False, separators=(",", ":")))
    OUT_HTML.write_text(html, encoding="utf-8")
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    meta = {
        "duration_seconds": DURATION_S, "reference_video": "2aafI3XvKxo (Simple and Clean -Ray of Hope MIX-, 02:33)",
        "resolution": [1280, 720], "fps": 60,
        "timeline": {"voyage": [0, 31], "course_lunaire": [31, 46], "opening_sprites": [46, 153]},
        "sprites_clip_kept": [46.0, 68.0], "actors": sorted(set(SPR.ACTORS) | set(VOY.ACTORS) | set(EXTRA_ACTORS)),
        "sheets": len(assets["sheets"]), "html_bytes": OUT_HTML.stat().st_size,
    }
    (OUT_DIR / "metadata.json").write_text(json.dumps(meta, ensure_ascii=False, indent=2), encoding="utf-8")
    return OUT_HTML


if __name__ == "__main__":
    out = build_html()
    print(f"[Opening Ultime] {out.name} : {out.stat().st_size / 1024:.0f} Ko — durée {DURATION_S:.2f}s (02:33)")
