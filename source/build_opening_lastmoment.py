#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Constructeur de l'Opening « LAST MOMENT » de `Pokémon Mystery Dungeon : Destiny` — mêmes plans que l'ED 25 de Bleach
(« Last Moment », SPYAIR, vidéo `cRdYidq7d8g`, 01:36) transposés dans l'univers PMD ; durée exacte `96,00 s`.

Entrées  : `renders/pmd_destiny_fangame_v1/opening_assets/` (sprites + portraits PMDCollab, régénéré par
           `build_opening_ray_of_hope_pokemon.py`), textures canoniques des intros de PMD Sky (`build_opening_lastmoment_layers.py`),
           blason articulé 3 pièces, mers Jour/Nuit du titre.
Sortie   : `apercu_fangame_pmd_destiny_last_moment.html` autonome (tout en `data:` URI, 0 requête externe)."""
from __future__ import annotations

import base64
import io
import json
import sys
from pathlib import Path
from typing import Dict

from PIL import Image

SOURCE_DIR = Path(__file__).resolve().parent
REPO_ROOT = SOURCE_DIR.parent
for p in (str(REPO_ROOT), str(SOURCE_DIR)):
    if p not in sys.path:
        sys.path.insert(0, p)

from source.moteur_pmd_destiny_fangame import decode_pmdo_dir_sheet  # type: ignore
from source.build_opening_lastmoment_layers import build_lastmoment_layers  # type: ignore
from source.build_opening_vfx_sprites import build_vfx  # type: ignore
from source.build_logo_rig_clean import build as build_rig  # type: ignore

RENDERS = REPO_ROOT / "renders" / "pmd_destiny_fangame_v1"
ASSETS_DIR = RENDERS / "opening_assets"
APERCUS_MENU = RENDERS / "apercus_menu"
BG_DIR = RENDERS / "fangame_base" / "Content" / "BG"
OUT_DIR = RENDERS / "opening_last_moment"
TEMPLATE = SOURCE_DIR / "opening_lastmoment_template.html"
ENGINE = SOURCE_DIR / "opening_lastmoment_engine.js"
OUT_HTML = REPO_ROOT / "apercu_fangame_pmd_destiny_last_moment.html"
DURATION_S = 96.0
VFX_DIR = REPO_ROOT / "renders" / "pmd_destiny_fangame_v1" / "opening_vfx"
VFX_DIR.mkdir(parents=True, exist_ok=True)

# Acteurs et animations réellement utilisés par la chorégraphie
ACTORS = {
    "0447": ["Idle", "Walk", "Pose"],  # Riolu, le héros
    "0393": ["Idle"], "0253": ["Idle"], "0133": ["Idle", "Hop"], "0448": ["Idle"], "0571": ["Idle"], "0491": ["Idle"],
    "0151": ["Float"], "0490": ["Float"], "0251": ["Float"], "0492": ["Sit"],
    "0279": ["Walk"],  # Bekipan (vue de profil : directions 2 / 6)
    # Guilde de Grodoudou + Gardevoir + anciens héros de PMD
    "0282": ["Idle", "Appeal"], "0040": ["Idle", "Hop"], "0441": ["Idle", "Float"], "0294": ["Idle"], "0050": ["Idle"], "0051": ["Idle"],
    "0399": ["Idle"], "0341": ["Idle"], "0453": ["Idle"], "0192": ["Idle"], "0025": ["Idle"], "0004": ["Idle"], "0007": ["Idle"],
    "0001": ["Idle"], "0052": ["Idle"], "0054": ["Idle"],
}

def uri_png(path: Path) -> str:
    return "data:image/png;base64," + base64.b64encode(path.read_bytes()).decode("ascii")


def uri_im(im: Image.Image, fmt: str = "WEBP", **kw) -> str:
    b = io.BytesIO()
    im.save(b, format=fmt, **kw)
    return f"data:image/{fmt.lower()};base64," + base64.b64encode(b.getvalue()).decode("ascii")


def build_assets() -> Dict[str, object]:
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    manifest = json.loads((ASSETS_DIR / "manifest.json").read_text(encoding="utf-8"))
    cat = manifest["pmd_catalog"]["pokemon"]
    imgs: Dict[str, str] = {}
    rig = build_rig()  # découpe propre du logo (segmentation par couleur), pleine définition
    for key, name in (("rigCore", "core_body"), ("rigLW", "left_wing"), ("rigRW", "right_wing"), ("rigBack", "back_fill")):
        imgs[key] = uri_im(rig[name], "WEBP", lossless=True)
    imgs["enterUI"] = uri_im(Image.open(APERCUS_MENU / "Enter_74x11.png").convert("RGBA"), "WEBP", lossless=True)
    aj, _ = decode_pmdo_dir_sheet(BG_DIR / "Title_Screen_Background_Jour.dir")
    an, _ = decode_pmdo_dir_sheet(BG_DIR / "Title_Screen_Background_Nuit.dir")
    imgs["daySeaAtlas"] = uri_im(aj.convert("RGB"), "WEBP", quality=86)
    imgs["nightSeaAtlas"] = uri_im(an.convert("RGB"), "WEBP", quality=86)
    # Décors = textures canoniques des intros de PMD Sky (Plains, Moonlight, Sky Peak) + mer / soleil / canyon générés
    for k, v in build_lastmoment_layers().items():
        imgs[k] = uri_im(v, "WEBP", lossless=True)
    # Sprites d'effets animés (planches générées : pétales, scintillements, bulles, impacts, flammes, éclaboussures…)
    vfx_meta: Dict[str, dict] = {}
    for name, v in build_vfx().items():
        imgs[f"fx_{name}"] = uri_im(v["sheet"], "WEBP", lossless=True)
        vfx_meta[name] = {k: v[k] for k in v if k != "sheet"}
        v["sheet"].save(VFX_DIR / f"fx_{name}.png")
    for key, col in (("wfCyan", "cyan"), ("wfEmerald", "emerald"), ("wfAmber", "amber")):
        imgs[key] = imgs[f"fx_badge_{col}"]  # badge étoile généré
    sheets: Dict[str, str] = {}
    catalog: Dict[str, dict] = {}
    for pid, names in ACTORS.items():
        P = cat[pid]
        catalog[pid] = {"name": P.get("name", pid), "anims": {}}
        for n in names:
            if n not in P["anims"]:
                continue
            a = P["anims"][n]
            sheets[a["file"]] = uri_png(ASSETS_DIR / "pmd_sprites" / a["file"])
            catalog[pid]["anims"][n] = {k: a[k] for k in ("file", "fw", "fh", "cols", "rows", "durations")}
    return {"imgs": imgs, "sheets": sheets, "catalog": {"pokemon": catalog, "vfx": vfx_meta}}


def build_html() -> Path:
    assets = build_assets()
    tpl = TEMPLATE.read_text(encoding="utf-8")
    eng = ENGINE.read_text(encoding="utf-8")
    assert "/*__ENGINE__*/" in tpl and "/*__ASSETS__*/" in tpl
    html = tpl.replace("/*__ENGINE__*/", eng).replace("/*__ASSETS__*/", json.dumps(assets, ensure_ascii=False, separators=(",", ":")))
    OUT_HTML.write_text(html, encoding="utf-8")
    meta = {
        "duration_seconds": DURATION_S, "reference_video": "cRdYidq7d8g (BLEACH ED25 Last Moment, SPYAIR, 01:36)",
        "resolution": [1280, 720], "fps": 60, "engine": "textures canoniques PMD Sky en parallaxe + sprites/portraits PMDO",
        "actors": sorted(ACTORS), "sheets": len(assets["sheets"]), "html_bytes": OUT_HTML.stat().st_size,
    }
    (OUT_DIR / "metadata.json").write_text(json.dumps(meta, ensure_ascii=False, indent=2), encoding="utf-8")
    return OUT_HTML


if __name__ == "__main__":
    out = build_html()
    print(f"[Opening Last Moment] {out.name} : {out.stat().st_size / 1024:.0f} Ko — durée {DURATION_S:.2f}s (01:36)")
