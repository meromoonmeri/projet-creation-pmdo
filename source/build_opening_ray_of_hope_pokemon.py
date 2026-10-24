#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Constructeur des assets studio-anime 100 % Pokémon de l'Opening
« Simple and Clean -Ray of Hope MIX- » (`2aafI3XvKxo`) pour
**Pokémon Mystery Dungeon : Destiny** (`renders/pmd_destiny_fangame_v1/opening_assets/`).

Zéro humain, zéro débordement `#00FF00` / `#FF00FF` :
  - 4 décors d'animation studio (`ocean_profondeurs`, `falaise_aventure`,
    `donjon_cristal_ruines`, `promontoire_horizon`)
  - 1 rosace vitrail circulaire *Dive to the Heart* PMD (Œuf Ailé + Riolu + Évoli + Tiplouf)
  - 8 découpes RGBA Pokémon nettes et décontaminées :
      * `riolu_abysse.png`, `evoli_abysse.png` (flottement en apesanteur sous l'océan)
      * `tiplouf_ocean.png`, `manaphy_ocean.png` (remontée dans les bulles vers la surface)
      * `riolu_course.png` (orienté vers la droite), `evoli_course.png` (sprint sur la falaise)
      * `latias_latios_ciel.png` (envol céleste du refrain *Ray of Hope*)
      * `equipe_dos_horizon.png` (Riolu & Évoli de dos face au Rayon d'Espoir sur l'océan)
"""
from __future__ import annotations

import json
from collections import deque
from pathlib import Path
from typing import Tuple

import numpy as np
from PIL import Image
from scipy import ndimage

SOURCE_DIR = Path(__file__).resolve().parent
REPO_ROOT = SOURCE_DIR.parent
BRUTS_DIR = SOURCE_DIR / "pmd_destiny_fangame_v1" / "opening_bruts"
OUT_DIR = REPO_ROOT / "renders" / "pmd_destiny_fangame_v1" / "opening_assets"


def extract_green_cutout(
    arr: np.ndarray,
    box: Tuple[int, int, int, int],
    max_h: int = 440,
    flip_x: bool = False,
) -> Image.Image:
    """Extrait et décontamine à 100 % (`0 px` `#00FF00`) un sprite Pokémon sur fond vert."""
    x0, y0, x1, y1 = box
    sub = arr[y0:y1, x0:x1].copy()
    h, w, _ = sub.shape
    r = sub[:, :, 0].astype(np.int16)
    g = sub[:, :, 1].astype(np.int16)
    b = sub[:, :, 2].astype(np.int16)

    diff_g = g - np.maximum(r, b)
    cand_bg = (diff_g >= 36) & (g >= 105)
    visited = np.zeros((h, w), dtype=bool)
    q: deque[Tuple[int, int]] = deque()

    for x in range(w):
        for y in (0, h - 1):
            if cand_bg[y, x] and not visited[y, x]:
                visited[y, x] = True
                q.append((y, x))
    for y in range(h):
        for x in (0, w - 1):
            if cand_bg[y, x] and not visited[y, x]:
                visited[y, x] = True
                q.append((y, x))

    while q:
        cy, cx = q.popleft()
        for ny, nx in ((cy - 1, cx), (cy + 1, cx), (cy, cx - 1), (cy, cx + 1)):
            if 0 <= ny < h and 0 <= nx < w and not visited[ny, nx] and cand_bg[ny, nx]:
                visited[ny, nx] = True
                q.append((ny, nx))

    enclosed_neon = (diff_g >= 68) & (g >= 165) & (r <= 115) & (b <= 115)
    bg = visited | enclosed_neon
    fg = ~bg
    fg = ndimage.binary_opening(fg, iterations=1)

    # Garde toutes les composantes significatives (> 1200 px)
    lbl, n_c = ndimage.label(fg)
    keep = np.zeros_like(fg)
    for i in range(1, n_c + 1):
        m = lbl == i
        if int(m.sum()) >= 1200:
            keep |= m
    fg = keep

    # Décontamination anti-frange verte sur la bordure (dist <= 4.5 px)
    dist = ndimage.distance_transform_edt(fg)
    core = fg & (dist > 3.2) & (diff_g < 18)
    if not np.any(core):
        core = fg & (diff_g < 25)
    _, nearest = ndimage.distance_transform_edt(~core, return_indices=True)

    out = np.zeros((h, w, 4), dtype=np.uint8)
    out[:, :, :3] = sub[:, :, :3]

    fringe = fg & (dist <= 4.5) & (diff_g >= 10)
    ny_idx = nearest[0][fringe]
    nx_idx = nearest[1][fringe]
    out[fringe, 0] = sub[ny_idx, nx_idx, 0]
    out[fringe, 1] = sub[ny_idx, nx_idx, 1]
    out[fringe, 2] = sub[ny_idx, nx_idx, 2]

    # Sécurité finale : suppression totale de tout pixel néon vert résiduel
    rem_g = out[:, :, 1].astype(np.int16) - np.maximum(out[:, :, 0].astype(np.int16), out[:, :, 2].astype(np.int16))
    fg = fg & ~(rem_g >= 48)

    # Alpha doux anti-aliasé sur le dernier 1.4 px du contour anime
    alpha_f = np.clip((dist - 0.35) / 1.25, 0.0, 1.0)
    alpha_u8 = (alpha_f * 255.0).round().astype(np.uint8)
    alpha_u8[~fg] = 0
    out[:, :, 3] = alpha_u8
    out[~fg, :3] = 0

    ys, xs = np.where(out[:, :, 3] >= 16)
    pad = 6
    cy0, cy1 = max(0, int(ys.min()) - pad), min(h, int(ys.max()) + pad + 1)
    cx0, cx1 = max(0, int(xs.min()) - pad), min(w, int(xs.max()) + pad + 1)
    im = Image.fromarray(out[cy0:cy1, cx0:cx1], mode="RGBA")
    if flip_x:
        im = im.transpose(Image.Transpose.FLIP_LEFT_RIGHT)

    if im.height > max_h:
        nw = max(16, int(round(im.width * (max_h / float(im.height)))))
        im = downsample_rgba_premul(im, nw, max_h)
    return im


def extract_vitrail_circle_magenta(path: Path, target_size: int = 560) -> Image.Image:
    """Extrait la rosace vitrail circulaire PMD sur fond `#FF00FF` avec masque circulaire net."""
    src = Image.open(path).convert("RGBA")
    arr = np.asarray(src, dtype=np.uint8)
    h, w, _ = arr.shape
    r = arr[:, :, 0].astype(np.int16)
    g = arr[:, :, 1].astype(np.int16)
    b = arr[:, :, 2].astype(np.int16)
    diff_m = np.minimum(r, b) - g

    fg_raw = ~((diff_m >= 58) & (r >= 165) & (b >= 165))
    ys, xs = np.where(fg_raw)
    cx = 0.5 * (float(xs.min()) + float(xs.max()))
    cy = 0.5 * (float(ys.min()) + float(ys.max()))
    rad = 0.5 * min(float(xs.max() - xs.min()), float(ys.max() - ys.min())) - 3.0

    yy, xx = np.mgrid[0:h, 0:w]
    d_center = np.hypot(xx - cx, yy - cy)
    alpha = np.clip((rad - d_center) / 2.2, 0.0, 1.0)

    out = arr.copy()
    # Neutralise toute frange magenta au bord externe du plomb doré
    rim = (d_center >= rad - 8.0) & (d_center <= rad + 2.0) & (diff_m >= 32)
    out[rim, 1] = np.minimum(255, out[rim, 1].astype(np.int16) + diff_m[rim] // 2).astype(np.uint8)
    out[:, :, 3] = (alpha * 255.0).round().astype(np.uint8)
    out[out[:, :, 3] == 0, :3] = 0

    pad = 6
    x0 = max(0, int(round(cx - rad)) - pad)
    x1 = min(w, int(round(cx + rad)) + pad)
    y0 = max(0, int(round(cy - rad)) - pad)
    y1 = min(h, int(round(cy + rad)) + pad)
    cropped = Image.fromarray(out[y0:y1, x0:x1], mode="RGBA")
    return downsample_rgba_premul(cropped, target_size, target_size)


def downsample_rgba_premul(im: Image.Image, tw: int, th: int) -> Image.Image:
    """Redimensionnement prémultiplié haute fidélité sans halo sombre ni frange."""
    a = np.asarray(im, dtype=np.float32) / 255.0
    rgb_p = a[:, :, :3] * a[:, :, 3:4]
    p_im = Image.fromarray(np.clip(rgb_p * 255.0, 0, 255).astype(np.uint8), mode="RGB").resize(
        (tw, th), Image.Resampling.LANCZOS
    )
    a_im = Image.fromarray(np.clip(a[:, :, 3] * 255.0, 0, 255).astype(np.uint8), mode="L").resize(
        (tw, th), Image.Resampling.LANCZOS
    )
    p_arr = np.asarray(p_im, dtype=np.float32) / 255.0
    a_arr = np.asarray(a_im, dtype=np.float32) / 255.0
    out = np.zeros((th, tw, 4), dtype=np.uint8)
    nz = a_arr > 0.02
    out[nz, :3] = np.clip((p_arr[nz] / a_arr[nz, None]) * 255.0, 0, 255).round().astype(np.uint8)
    out[nz, 3] = np.clip(a_arr[nz] * 255.0, 0, 255).round().astype(np.uint8)
    return Image.fromarray(out, mode="RGBA")


def build_opening_assets() -> dict:
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    manifest: dict = {"backgrounds": {}, "sprites": {}}

    # 1. Décors d'animation studio (optimisés JPEG qualité 92 pour chargement instantané < 1.8 Mo)
    bg_specs = [
        ("op_bg_ocean_profondeurs.png", "bg_ocean_profondeurs.jpg", (896, 1200)),
        ("op_bg_falaise_aventure.png", "bg_falaise_aventure.jpg", (1280, 720)),
        ("op_bg_donjon_cristal_ruines.png", "bg_donjon_cristal_ruines.jpg", (1280, 720)),
        ("op_bg_promontoire_horizon.png", "bg_promontoire_horizon.jpg", (1280, 720)),
    ]
    for src_name, dst_name, target_wh in bg_specs:
        im = Image.open(BRUTS_DIR / src_name).convert("RGB")
        if im.size != target_wh:
            im = im.resize(target_wh, Image.Resampling.LANCZOS)
        dst = OUT_DIR / dst_name
        im.save(dst, format="JPEG", quality=92, optimize=True)
        manifest["backgrounds"][dst_name] = {"size": list(im.size), "bytes": dst.stat().st_size}

    # 2. Rosace Vitrail Circulaire Dive to the Heart PMD
    vitrail = extract_vitrail_circle_magenta(BRUTS_DIR / "op_vitrail_destin_pmd_magenta.png", target_size=540)
    vitrail_p = OUT_DIR / "vitrail_destin_pmd.png"
    vitrail.save(vitrail_p, format="PNG", optimize=True)
    manifest["sprites"]["vitrail_destin_pmd.png"] = {"size": list(vitrail.size), "bytes": vitrail_p.stat().st_size}

    # 3. Découpes Pokémon RGBA 0 px #00FF00
    abysse_arr = np.asarray(Image.open(BRUTS_DIR / "op_sprites_plongee_abysse_green.png").convert("RGBA"), dtype=np.uint8)
    ocean_arr = np.asarray(Image.open(BRUTS_DIR / "op_sprites_ocean_pokemon_green.png").convert("RGBA"), dtype=np.uint8)
    course_arr = np.asarray(Image.open(BRUTS_DIR / "op_sprites_equipe_course_green.png").convert("RGBA"), dtype=np.uint8)
    latias_arr = np.asarray(Image.open(BRUTS_DIR / "op_sprites_latias_et_dos_green.png").convert("RGBA"), dtype=np.uint8)

    sprite_jobs = [
        ("riolu_abysse.png", abysse_arr, (60, 40, 700, 740), 420, False),
        ("evoli_abysse.png", abysse_arr, (720, 30, 1360, 720), 420, False),
        ("tiplouf_ocean.png", ocean_arr, (70, 60, 665, 720), 390, False),
        ("manaphy_ocean.png", ocean_arr, (685, 110, 1380, 690), 380, False),
        ("riolu_course.png", course_arr, (110, 50, 745, 700), 390, True),   # Retourné -> sprinte vers la droite avec Évoli !
        ("evoli_course.png", course_arr, (745, 80, 1365, 660), 360, False),
        ("latias_latios_ciel.png", latias_arr, (25, 35, 760, 735), 430, False),
        ("equipe_dos_horizon.png", latias_arr, (775, 230, 1385, 715), 420, False),
    ]

    for dst_name, src_arr, box, max_h, flip_x in sprite_jobs:
        sp = extract_green_cutout(src_arr, box=box, max_h=max_h, flip_x=flip_x)
        # Vérification stricte 0 px #00FF00 néon
        a = np.asarray(sp, dtype=np.uint8)
        fg = a[:, :, 3] >= 32
        neon_g = fg & ((a[:, :, 1].astype(np.int16) - np.maximum(a[:, :, 0].astype(np.int16), a[:, :, 2].astype(np.int16))) >= 52)
        assert int(neon_g.sum()) == 0, f"Fuite verte sur {dst_name}: {int(neon_g.sum())}"

        dst = OUT_DIR / dst_name
        sp.save(dst, format="PNG", optimize=True)
        manifest["sprites"][dst_name] = {"size": list(sp.size), "bytes": dst.stat().st_size}

    (OUT_DIR / "manifest.json").write_text(json.dumps(manifest, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    total_mb = sum(p.stat().st_size for p in OUT_DIR.iterdir() if p.is_file()) / (1024 * 1024)
    print(f"OK — Assets Opening Pokémon Ray of Hope MIX exportés ({total_mb:.2f} Mo dans {OUT_DIR})")
    return manifest


if __name__ == "__main__":
    build_opening_assets()
