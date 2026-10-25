#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Constructeur de l'Opening « SPRITES PMDO animés image par image + caméra immersive » de
`Pokémon Mystery Dungeon : Destiny` — durée exacte `02:33` (`153,00 s`), calée sur la vidéo de référence
`Simple and Clean -Ray of Hope MIX-` (`2aafI3XvKxo`).

Entrées  : `renders/pmd_destiny_fangame_v1/opening_assets/` (régénéré par `build_opening_ray_of_hope_pokemon.py`
           depuis le clone sparse `.cache/spritecollab`), blason articulé 3 pièces, mers Jour/Nuit du titre.
Sortie   : `apercu_fangame_pmd_destiny.html` autonome (tout en `data:` URI, 0 requête externe).
"""
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
from source.build_opening_sky_layers import build_layers  # type: ignore
from source.build_opening_vfx_sprites import build_vfx  # type: ignore
from source.build_logo_rig_clean import build as build_rig  # type: ignore

RENDERS = REPO_ROOT / "renders" / "pmd_destiny_fangame_v1"
ASSETS_DIR = RENDERS / "opening_assets"
APERCUS_MENU = RENDERS / "apercus_menu"
BG_DIR = RENDERS / "fangame_base" / "Content" / "BG"
OUT_DIR = RENDERS / "opening_sprite_cine"
TEMPLATE = SOURCE_DIR / "opening_sprite_template.html"
ENGINE = SOURCE_DIR / "opening_sprite_engine.js"
OUT_HTML = REPO_ROOT / "apercu_fangame_pmd_destiny.html"
DURATION_S = 153.0
VFX_DIR = REPO_ROOT / "renders" / "pmd_destiny_fangame_v1" / "opening_vfx"
VFX_DIR.mkdir(parents=True, exist_ok=True)

# Acteurs et animations réellement utilisés par la chorégraphie
ACTORS = {
    "0447": ["Idle", "Walk", "Hop", "LookUp", "Pose", "Pull", "Rotate", "Float", "Sink", "Charge", "LeapForth"],
    "0133": ["Idle", "Walk", "Hop", "LookUp", "Pose", "Hurt", "Pain", "Attack", "Double", "Swing", "Shoot", "Float", "Sink", "Wake"],
    "0393": ["Idle", "Walk", "Hop", "Swing", "Rotate", "Float", "Attack", "Shoot", "Hurt", "Pain"],
    "shadow_0447": ["Idle", "Walk", "Attack", "Strike", "Double", "Charge", "Hurt", "Pain", "Rotate"],
    "shadow_0393": ["Idle", "Walk", "Swing", "Attack", "Shoot", "Hurt", "Pain", "Rotate"],
    "0448": ["Idle", "Walk", "LeapForth", "Hop", "Strike", "Swing", "QuickStrike", "Pose", "Hurt"],
    "0491": ["Idle", "Charge", "Attack", "Shoot", "Swing", "Hurt"],
    "0490": ["Idle", "Walk"],
    "0251": ["Idle", "Float"],
    "0492": ["Idle", "Walk", "Float", "Hop", "Rotate", "Pose", "Appeal"],  # Shaymin (forme Ciel) — vrai sprite PMDO
    "0380": ["Idle"],
    "0381": ["Idle"],
}
MAPS = {
    "opm1": "opm1_plage_cristal.png", "opm2": "opm2_abysse_vitrail.png", "opm3": "opm3_arene_eau_miroir.png",
    "opm4": "opm4_ciel_astral.png", "opm5": "opm5_falaise_promontoire.png",
}
PROPS = {"vitrail": "vitrail_dais_pmd_pixel.png"}  # les 3 badges étoile sont désormais générés (fx_badge_*)


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
    for k, f in MAPS.items():
        imgs[k] = uri_png(ASSETS_DIR / "maps" / f)
    for k, f in PROPS.items():
        imgs[k] = uri_png(ASSETS_DIR / f)
    rig = build_rig()  # découpe propre du logo (segmentation par couleur), pleine définition
    for key, name in (("rigCore", "core_body"), ("rigLW", "left_wing"), ("rigRW", "right_wing"), ("rigBack", "back_fill")):
        imgs[key] = uri_im(rig[name], "WEBP", lossless=True)
    imgs["enterUI"] = uri_im(Image.open(APERCUS_MENU / "Enter_74x11.png").convert("RGBA"), "WEBP", lossless=True)
    aj, _ = decode_pmdo_dir_sheet(BG_DIR / "Title_Screen_Background_Jour.dir")
    an, _ = decode_pmdo_dir_sheet(BG_DIR / "Title_Screen_Background_Nuit.dir")
    imgs["daySeaAtlas"] = uri_im(aj.convert("RGB"), "WEBP", quality=86)
    imgs["nightSeaAtlas"] = uri_im(an.convert("RGB"), "WEBP", quality=86)
    # Couches « PMD Explorers of Sky » (méthode d'intro de la série) : parallaxe, tunnel, orage, mer en tuile…
    L = build_layers()
    lossless = {"ttSky", "moonBg", "moonFg", "plainsFar", "plainsTree", "skyPeak", "skyPeakFront", "laprasSky", "laprasSea", "anticWall"}
    for k, v in L.items():
        if k in ("anticPos", "shaymin"):  # le Shaymin « ripé » est remplacé par le vrai sprite PMDO 0492
            continue
        if isinstance(v, list):
            pref = {"shaymin": "sh", "lapras": "lap", "anticItems": "it", "timeTravel": "tm", "thunder": "th"}[k]
            for i, im in enumerate(v):
                if k == "thunder":
                    imgs[f"{pref}{i}"] = uri_im(im.convert("RGB"), "WEBP", quality=80)
                elif k == "timeTravel":
                    imgs[f"{pref}{i}"] = uri_im(im, "WEBP", quality=82, method=6)
                else:
                    imgs[f"{pref}{i}"] = uri_im(im, "WEBP", lossless=True)
        elif k in lossless:
            imgs[k] = uri_im(v, "WEBP", lossless=True)
    # Sprites d'effets animés (planches générées : pétales, scintillements, bulles, impacts, flammes, éclaboussures…)
    vfx_meta: Dict[str, dict] = {}
    for name, v in build_vfx().items():
        imgs[f"fx_{name}"] = uri_im(v["sheet"], "WEBP", lossless=True)
        vfx_meta[name] = {k: v[k] for k in v if k != "sheet"}
        v["sheet"].save(VFX_DIR / f"fx_{name}.png")
    for key, col in (("wfCyan", "cyan"), ("wfEmerald", "emerald"), ("wfAmber", "amber")):
        imgs[key] = imgs[f"fx_badge_{col}"]  # badge étoile généré
    portal = Image.open(SOURCE_DIR / "pmd_destiny_fangame_v1" / "cinema_aaa_bruts" / "portail_nuages_nuit.png").convert("RGB").resize((1280, 698), Image.Resampling.LANCZOS)
    imgs["cloudPortal"] = uri_im(portal, "WEBP", quality=84, method=6)
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
    return {"imgs": imgs, "sheets": sheets, "catalog": {"pokemon": catalog, "antic": L["anticPos"], "vfx": vfx_meta}}


def build_html() -> Path:
    assets = build_assets()
    tpl = TEMPLATE.read_text(encoding="utf-8")
    eng = ENGINE.read_text(encoding="utf-8")
    assert "/*__ENGINE__*/" in tpl and "/*__ASSETS__*/" in tpl
    html = tpl.replace("/*__ENGINE__*/", eng).replace("/*__ASSETS__*/", json.dumps(assets, ensure_ascii=False, separators=(",", ":")))
    OUT_HTML.write_text(html, encoding="utf-8")
    meta = {
        "duration_seconds": DURATION_S, "reference_video": "2aafI3XvKxo (Simple and Clean -Ray of Hope MIX-, 02:33)",
        "resolution": [1280, 720], "fps": 60, "engine": "sprites PMDO image par image + caméra Catmull-Rom",
        "actors": sorted(ACTORS), "sheets": len(assets["sheets"]), "html_bytes": OUT_HTML.stat().st_size,
    }
    (OUT_DIR / "metadata.json").write_text(json.dumps(meta, ensure_ascii=False, indent=2), encoding="utf-8")
    return OUT_HTML


if __name__ == "__main__":
    out = build_html()
    print(f"[Opening Sprites] {out.name} : {out.stat().st_size / 1024:.0f} Ko — durée {DURATION_S:.2f}s (02:33)")
