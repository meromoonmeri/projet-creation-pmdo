#!/usr/bin/env python3
"""Reconstruction « légère » des openings sprites avec le NOUVEAU COMBAT (arène animée, Méga-Évolution de Lucario,
explosion), la météorite / le soleil / les rayons de PMD Rouge.

Les builders complets (`build_opening_ultime.py`, `build_opening_sprite_cinematique_destiny.py`) exigent des ressources de menu
non suivies par git. Ici on part donc des ASSETS déjà présents dans les pages livrées, on y ajoute les nouvelles ressources
(`combat_bruts/`, produites par `build_combat_resources.py` + `build_combat_arene.py`) et on réinjecte le moteur courant.

    python3 source/build_opening_combat.py [ultime|sprite|all]
"""
from __future__ import annotations

import base64
import io
import json
import sys
from pathlib import Path

import numpy as np
from PIL import Image

SOURCE_DIR = Path(__file__).resolve().parent
ROOT = SOURCE_DIR.parent
for p in (str(ROOT), str(SOURCE_DIR)):
    if p not in sys.path:
        sys.path.insert(0, p)

BR = SOURCE_DIR / "pmd_destiny_fangame_v1" / "combat_bruts"

PAGES = {
    "ultime": (ROOT / "apercu_fangame_pmd_destiny_ultime.html", SOURCE_DIR / "opening_ultime_template.html"),
    "sprite": (ROOT / "apercu_fangame_pmd_destiny.html", SOURCE_DIR / "opening_sprite_template.html"),
}


def uri(path: Path, mime: str = "image/png") -> str:
    return f"data:{mime};base64," + base64.b64encode(path.read_bytes()).decode()


def read_assets(page: Path, tpl: Path):
    pre, rest = tpl.read_text(encoding="utf-8").split("/*__ENGINE__*/")
    mid, post = rest.split("/*__ASSETS__*/")
    html = page.read_text(encoding="utf-8")
    assert html.startswith(pre), "page inattendue (préfixe du gabarit)"
    pos = html.index(mid, len(pre)) + len(mid)
    assets, _ = json.JSONDecoder().raw_decode(html[pos:])
    return assets, (pre, mid, post)


def new_resources():
    imgs = {
        "arVortex": uri(BR / "arVortex.jpg", "image/jpeg"), "arDais": uri(BR / "arDais.png"), "arRocks": uri(BR / "arRocks.png"),
        "arMist": uri(BR / "arMist.png"), "fx_rrmet": uri(BR / "fx_rrmet.png"), "fx_sunfl": uri(BR / "fx_sunfl.png"),
        "rrRays": uri(BR / "rrRays.png"),
    }
    for k in ("sunRing", "sunOrb", "sunBallA", "sunBallB"):
        imgs[k] = uri(BR / f"{k}.png")
    # décor de la chute (plaques peintes générées) : stratosphère étoilée → mer de nuages → portail de nuages
    for key, src in (("skyStrato", "skyStrato_raw.png"), ("skyDeck", "skyCloudDeck_raw.png"), ("cloudPortal", "cloudPortalNew_raw.png")):
        buf = io.BytesIO(); Image.open(SOURCE_DIR / "pmd_destiny_fangame_v1" / "decors_peints" / src).convert("RGB").save(buf, "JPEG", quality=84, optimize=True)
        imgs[key] = "data:image/jpeg;base64," + base64.b64encode(buf.getvalue()).decode()
    vfx = json.loads((BR / "vfx_catalog.json").read_text())
    arena = json.loads((BR / "arena_meta.json").read_text())
    cat = json.loads((BR / "sprites_catalog.json").read_text())
    sheets: dict = {}
    from source.build_opening_ray_of_hope_pokemon import make_shadow_corrupted_sheet as shadow  # type: ignore
    for pid, anims in list(cat.items()):
        for name, meta in anims.items():
            f = BR / "sprites" / meta["file"]
            sheets[meta["file"]] = uri(f)
            if pid in ("0447", "0133", "0393", "0302"):  # ombres corrompues (possédés par Darkrai, Ténéfix)
                sh = shadow(Image.open(f).convert("RGBA"))
                if pid != "0447":  # possédés : yeux et éclats rouge sang au lieu d'ambre
                    arr = np.asarray(sh).copy(); m = (arr[..., 0] == 255) & (arr[..., 1] == 196) & (arr[..., 2] == 38) & (arr[..., 3] > 0)
                    arr[m] = (255, 36, 64, 255); sh = Image.fromarray(arr, "RGBA")
                buf = io.BytesIO(); sh.save(buf, "PNG", optimize=True)
                sid = f"shadow_{pid}"; fn = Path(meta["file"]).name
                sheets[f"{sid}/{fn}"] = "data:image/png;base64," + base64.b64encode(buf.getvalue()).decode()
                sm = dict(meta); sm["file"] = f"{sid}/{fn}"
                cat.setdefault(sid, {})[name] = sm
    return imgs, sheets, vfx, arena, cat


def merge(A: dict) -> dict:
    imgs, sheets, vfx, arena, cat = new_resources()
    A["imgs"].update(imgs)
    A["imgs"].pop("meteor", None)  # remplacée par l'animation du météore de PMD Rouge (fx_rrmet)
    A["sheets"].update({k: v for k, v in sheets.items()})
    A["catalog"].setdefault("vfx", {}).update(vfx)
    A["catalog"]["arena"] = arena
    P = A["catalog"]["pokemon"]
    for pid, anims in cat.items():
        ent = P.setdefault(pid, {"name": {"9448": "Méga-Lucario"}.get(pid, pid), "anims": {}, "portraits": {}, "authors": []})
        for name, meta in anims.items():
            ent["anims"][name] = meta  # les clés nouvelles complètent / remplacent à l'identique
    return A


def build(which: str) -> Path:
    page, tpl = PAGES[which]
    A, (pre, mid, post) = read_assets(page, tpl)
    A = merge(A)
    if which == "ultime":
        from source.build_opening_ultime import engine_source  # type: ignore
        eng = engine_source()
    else:
        eng = (SOURCE_DIR / "opening_sprite_engine.js").read_text(encoding="utf-8")
    html = pre + eng + mid + json.dumps(A, ensure_ascii=False, separators=(",", ":")) + post
    page.write_text(html, encoding="utf-8")
    print(f"[{which}] {page.name}: {page.stat().st_size / 1024:.0f} Ko")
    return page


if __name__ == "__main__":
    w = sys.argv[1] if len(sys.argv) > 1 else "all"
    for k in (["ultime", "sprite"] if w == "all" else [w]):
        build(k)
