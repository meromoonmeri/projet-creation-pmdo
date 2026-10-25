#!/usr/bin/env python3
"""Ressources du combat « Mega Evolution » : extrait les planches PMD Rouge (météore, soleil, rayons)
et les animations de sprites supplémentaires (SpriteCollab) vers combat_bruts/ (suivi par git)."""
import json
import shutil
import sys
import xml.etree.ElementTree as ET
from pathlib import Path

import numpy as np
from PIL import Image
from scipy import ndimage as ndi

ROOT = Path(__file__).resolve().parent.parent
RRT = ROOT / "source/pmd_destiny_fangame_v1/ressources_rrt"
OUT = ROOT / "source/pmd_destiny_fangame_v1/combat_bruts"
SC = ROOT / ".cache/spritecollab/sprite"

WANT = {  # uniquement les animations employées par le combat (les autres sont déjà dans les pages)
    "0447": ["Hurt", "Pain", "Attack", "Strike"],
    "0448": ["Charge"],
    # Méga-Lucario = forme 0001 du dossier 0448
    "9448": ["Idle", "Charge", "Attack", "RearUp"],
}
SRC_DIR = {"9448": "0448/0001"}


def key_bg(im, bgs):
    a = np.asarray(im.convert("RGBA")).copy()
    for bg in bgs:
        m = (np.abs(a[..., :3].astype(int) - np.array(bg)).sum(2) <= 3)
        a[m] = (0, 0, 0, 0)
    return Image.fromarray(a, "RGBA")


def rrt_assets():
    OUT.mkdir(parents=True, exist_ok=True)
    # --- météore : 9 images, fond bleu (24,64,168)
    im = Image.open(RRT / "rrt_meteor.png").convert("RGB")
    a = np.asarray(im).astype(int)
    m = ~((a[..., 0] <= 40) & (a[..., 1] == 64) & (a[..., 2] >= 160))
    boxes = [(0, 0), (177, 0), (352, 0), (517, 0), (684, 0), (4, 168), (174, 168), (339, 168), (502, 168)]
    FW, FH = 166, 168
    strip = Image.new("RGBA", (FW * len(boxes), FH), (0, 0, 0, 0))
    k = key_bg(im, [(24, 64, 168), (16, 64, 168), (40, 64, 160), (32, 64, 168), (136, 128, 120)])
    for i, (x, y) in enumerate(boxes):
        sub = m[y:y + FH, x:x + FW]
        # recadre sur le contenu pour aligner les images sur leur centre
        ys, xs = np.where(sub)
        cx, cy = (xs.min() + xs.max()) // 2, (ys.min() + ys.max()) // 2
        tile = k.crop((x, y, x + FW, y + FH))
        strip.alpha_composite(tile, (i * FW + FW // 2 - cx, FH // 2 - cy))
    strip.save(OUT / "fx_rrmet.png", optimize=True)
    # --- soleil : 12 images de 240×112 (fond (90,90,120)) en bande
    sun = Image.open(RRT / "rrt_sunny.png").convert("RGB")
    cells = [(8 + 248 * c, 8 + 120 * r) for r in range(4) for c in range(3)]
    bgs = [(90, 90, 120), (75, 75, 105), (60, 60, 90)]
    strip = Image.new("RGBA", (240 * 12, 112), (0, 0, 0, 0))
    for i, (x, y) in enumerate(cells):
        strip.alpha_composite(key_bg(sun.crop((x, y, x + 240, y + 112)), bgs), (i * 240, 0))
    strip.save(OUT / "fx_sunfl.png", optimize=True)
    # --- éléments isolés (anneau, orbe vert, boules, points)
    for name, box in {"sunRing": (259, 495, 106, 106), "sunBallA": (375, 495, 34, 34), "sunBallB": (421, 501, 22, 22),
                      "sunOrb": (382, 542, 52, 52), "sunDot": (447, 535, 10, 10)}.items():
        x, y, w, h = box
        key_bg(sun.crop((x, y, x + w, y + h)), bgs).save(OUT / f"{name}.png", optimize=True)
    shutil.copy2(RRT / "rrt_rayons.png", OUT / "rrRays.png")
    return {"rrmet": {"fw": FW, "fh": FH, "n": 9, "fps": 12, "loop": True},
            "sunfl": {"fw": 240, "fh": 112, "n": 12, "fps": 8, "loop": True}}


def sprite_assets():
    cat = {}
    for pid, anims in WANT.items():
        src = SC / SRC_DIR.get(pid, pid)
        if not src.is_dir():
            print("absent", src, file=sys.stderr)
            continue
        raw = {e.findtext("Name"): e for e in ET.parse(src / "AnimData.xml").getroot().findall("./Anims/Anim")}
        dst = OUT / "sprites" / pid
        dst.mkdir(parents=True, exist_ok=True)
        meta = {}
        for req in anims:
            if req not in raw:
                continue
            el, tgt = raw[req], req
            while el.findtext("CopyOf"):
                tgt = el.findtext("CopyOf"); el = raw[tgt]
            png = src / f"{tgt}-Anim.png"
            if not png.is_file():
                continue
            shutil.copy2(png, dst / f"{tgt}-Anim.png")
            im = Image.open(png)
            fw, fh = int(el.findtext("FrameWidth") or im.width), int(el.findtext("FrameHeight") or im.height)
            durs = [int(d.text or "4") for d in el.findall("./Durations/Duration")]
            cols = max(1, im.width // fw)
            meta[req] = {"file": f"{pid}/{tgt}-Anim.png", "fw": fw, "fh": fh, "cols": cols, "rows": max(1, im.height // fh),
                         "durations": durs or [4] * cols,
                         "hit": int(el.findtext("HitFrame")) if el.findtext("HitFrame") is not None else -1,
                         "rush": int(el.findtext("RushFrame")) if el.findtext("RushFrame") is not None else -1}
        cat[pid] = meta
        print(pid, sorted(meta))
    (OUT / "sprites_catalog.json").write_text(json.dumps(cat, indent=1))
    return cat


if __name__ == "__main__":
    vfx = rrt_assets()
    (OUT / "vfx_catalog.json").write_text(json.dumps(vfx, indent=1))
    sprite_assets()
