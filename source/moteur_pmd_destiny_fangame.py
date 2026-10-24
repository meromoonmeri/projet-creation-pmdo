#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Moteur multicalque PMDO `0.8.12.0` — **Pokémon Mystery Dungeon : Destiny**
(Fonds **JOUR** et **NUIT** séparés + Mer pixel-art générée + Logo **Œuf & Deux Ailes de chaque côté**
plus petit et centré + Animation d'apparition **Opening d'Anime en une seule fois**).

Architecture fidèle à *Palikadude/Halcyon* et *meromoonmeri/town02* :
  1. **Deux fonds `.dir` séparés (`320 × 240`, `24` poses en boucle, `100 %` sans logo)** :
     - `Content/BG/Title_Screen_Background_Jour.dir` (& `Title_Screen_Background.dir` par défaut) :
       Ciel azur radieux, faisceau solaire, nuages cathédrale immaculés et **mer diurne pixel-art générée**
       (`mer_pixelart_jour_magenta.png`) animée en houle perspective + éclats d'écume et reflets dorés.
     - `Content/BG/Title_Screen_Background_Nuit.dir` :
       Voûte nocturne étoilée (~105 étoiles scintillantes + étoile filante), rayon astral, nuages argentés
       et **mer nocturne pixel-art générée** (`mer_pixelart_nuit_magenta.png`) animée en reflets lunaires.
  2. **Logo Blason « Œuf + Deux Ailes de chaque côté » plus petit & centré (`Content/UI/Title.png`)** :
     - Détouré `0 px` `#FF00FF` (anneaux dorés de l'Œuf 100 % ajourés) depuis
       `logo_pmd_destiny_oeuf_ailes_magenta.png`.
     - **Plus petit et centré** : `176 × 91 px` centré en `(72, 66)` sur `320 × 240` (`420 × 218 px` centré
       en `(174, 161)` sur `768 × 576`), laissant respirer les nuages cathédrale tout autour et toute la mer
       en contrebas.
  3. **Animation d'Apparition Unique façon Opening d'Anime (`arrive en une seule fois`)** :
     - Plan d'établissement ciel/mer vivants ──▶ Éclat horizontal anamorphique & étoile centrale ──▶
       Impact unique du logo complet (`easeOutBack` `1.42× → 0.985× → 1.00×` + fondu silhouette blanc-or →
       couleurs pleines + plumes de lumière radiales) ──▶ Reflet métallique diagonal unique (« Shing! ») ──▶
       Maintien fixe définitif au centre sur le fond Jour ou Nuit en boucle !
  4. **Deux cartes Ground / Studio 10 calques séparées (`DSTJ` Jour & `DSTN` Nuit, `< 24 000` tuiles/banque)**.
"""
from __future__ import annotations

import io
import math
import struct
from functools import lru_cache
from pathlib import Path
from typing import Dict, List, Literal, Tuple

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage

from source.moteur_cyclones_cylindriques_unova import sanitize_rgba_binary

REPO_ROOT = Path(__file__).resolve().parent.parent
DESTINY_DIR = REPO_ROOT / "source" / "pmd_destiny_fangame_v1"

LOGO_WINGED_EGG_RAW_PATH = DESTINY_DIR / "bruts" / "logo_pmd_destiny_oeuf_ailes_magenta.png"
CLOUDS_RAW_PATH = DESTINY_DIR / "bruts" / "nuages_cathedrale_magenta.png"
SEA_DAY_RAW_PATH = DESTINY_DIR / "bruts" / "mer_pixelart_jour_magenta.png"
SEA_NIGHT_RAW_PATH = DESTINY_DIR / "bruts" / "mer_pixelart_nuit_magenta.png"

W_CANON = 768
H_CANON = 576
HORIZON_Y = 384  # 48*8 = 384 (2/3 de 576) -> y = 160 (20*8) en 320x240 !

W_MENU = 320
H_MENU = 240
HORIZON_MENU_Y = 160

# Dimensions & centrage exacts du logo « plus petit et centré » (Blason Œuf+Ailes PMD façon Friends of Honor)
LOGO_W_320 = 166   # ~51.9 % de 320 px (compact, centré dans l'arche céleste)
LOGO_Y_320 = 58    # Centré (y = 58..158) au-dessus de l'horizon (y=160) et de Enter (y=188)
LOGO_W_768 = 398   # ~51.8 % de 768 px (185 px d'ouverture nuages à gauche et à droite !)
LOGO_Y_768 = 136   # Centré (y = 136..378, juste au-dessus de l'horizon marin PMD Sky y = 384)

N_POSES = 24
FRAME_TICKS_MENU = 10  # 10 ticks @ 60 FPS = 6 FPS fluides

BAYER_8X8 = (
    np.array(
        [
            [0, 32, 8, 40, 2, 34, 10, 42],
            [48, 16, 56, 24, 50, 18, 58, 26],
            [12, 44, 4, 36, 14, 46, 6, 38],
            [60, 28, 52, 20, 62, 30, 54, 22],
            [3, 35, 11, 43, 1, 33, 9, 41],
            [51, 19, 59, 27, 49, 17, 57, 25],
            [15, 47, 7, 39, 13, 45, 5, 37],
            [63, 31, 55, 23, 61, 29, 53, 21],
        ],
        dtype=np.float32,
    )
    + 0.5
) / 64.0

ModeKind = Literal["jour", "nuit"]


# ============================================================================
# 1. GARDE ANTI-MAGENTA & SÉRIALISEUR `.dir` (`RogueEssence.Content.DirSheet`)
# ============================================================================

def clamp_bg_non_magenta(rgb: np.ndarray, max_rb_over_g: int = 26) -> np.ndarray:
    """Garantit `min(R, B) - G <= max_rb_over_g < 38` sur tous les calques (0 px magenta)."""
    out = rgb.copy()
    r = out[:, :, 0].astype(np.int16)
    g = out[:, :, 1].astype(np.int16)
    b = out[:, :, 2].astype(np.int16)
    excess = np.minimum(r, b) - g - max_rb_over_g
    bad = excess > 0
    if np.any(bad):
        r_new = np.clip(r - ((excess + 1) // 2), 0, 255)
        g_new = np.clip(g + (excess // 2) + 1, 0, 255)
        out[:, :, 0] = np.where(bad, r_new, r).astype(np.uint8)
        out[:, :, 1] = np.where(bad, g_new, g).astype(np.uint8)
    return out


def encode_pmdo_dir_sheet(
    frames_list: List[Image.Image],
    out_dir_path: Path,
    cols: int = 6,
    rotate_type: int = 0,
) -> Dict[str, int]:
    """Encode une séquence d'images au format exact `DirSheet.Save` de RogueEssence :
    `[int64 png_len][PNG atlas RGBA][int32 tileW][int32 tileH][int32 rotateType][int32 totalFrames]`."""
    assert len(frames_list) >= 1
    tw, th = frames_list[0].size
    total = len(frames_list)
    cols_eff = min(cols, total)
    rows_eff = int(math.ceil(total / float(cols_eff)))
    atlas = Image.new("RGBA", (cols_eff * tw, rows_eff * th), (0, 0, 0, 0))
    for idx, im in enumerate(frames_list):
        assert im.size == (tw, th), f"Frame {idx} taille invalide {im.size} != {(tw, th)}"
        cx = (idx % cols_eff) * tw
        cy = (idx // cols_eff) * th
        atlas.paste(im.convert("RGBA"), (cx, cy))

    buf = io.BytesIO()
    atlas.save(buf, format="PNG", optimize=True)
    png_bytes = buf.getvalue()

    out_dir_path.parent.mkdir(parents=True, exist_ok=True)
    with out_dir_path.open("wb") as f:
        f.write(struct.pack("<q", len(png_bytes)))
        f.write(png_bytes)
        f.write(struct.pack("<iiii", tw, th, int(rotate_type), total))

    return {
        "tile_width": tw,
        "tile_height": th,
        "atlas_width": atlas.width,
        "atlas_height": atlas.height,
        "rotate_type": int(rotate_type),
        "total_frames": total,
        "png_bytes": len(png_bytes),
        "file_bytes": out_dir_path.stat().st_size,
    }


def decode_pmdo_dir_sheet(dir_path: Path) -> Tuple[Image.Image, Tuple[int, int, int, int]]:
    """Relit et vérifie un fichier `.dir` PMDO `0.8.12`."""
    raw = dir_path.read_bytes()
    (png_len,) = struct.unpack_from("<q", raw, 0)
    png_bytes = raw[8 : 8 + png_len]
    trailer = struct.unpack_from("<iiii", raw, 8 + png_len)
    assert 8 + png_len + 16 == len(raw), "Taille binaire .dir incohérente"
    atlas = Image.open(io.BytesIO(png_bytes)).convert("RGBA")
    tw, th, _rot, total = trailer
    assert atlas.width % tw == 0 and atlas.height % th == 0
    assert (atlas.width // tw) * (atlas.height // th) >= total
    return atlas, trailer


# ============================================================================
# 2. DÉTOURAGE DU BLASON « ŒUF + DEUX AILES DE CHAQUE CÔTÉ » (`0 px` `#FF00FF`)
# ============================================================================

@lru_cache(maxsize=2)
def extract_destiny_logo_hd() -> Image.Image:
    """Détoure `logo_pmd_destiny_oeuf_ailes_magenta.png` par flood-fill strict depuis les 4 bords
    extérieurs : `0 px` `#FF00FF`, contour sticker blanc net façon *Friends of Honor*, et partie
    basse rose-corail canonique du badge Œuf+Ailes PMD préservée à `100 %` d'opacité."""
    raw = np.asarray(Image.open(LOGO_WINGED_EGG_RAW_PATH).convert("RGB"), dtype=np.uint8)
    r = raw[:, :, 0].astype(np.int16)
    g = raw[:, :, 1].astype(np.int16)
    b = raw[:, :, 2].astype(np.int16)
    diff = np.minimum(r, b) - g

    # Flood-fill strict depuis les 4 bords extérieurs sur le fond #FF00FF :
    # garantit que 100 % de l'intérieur du blason (dont le bas rose-corail de l'Œuf PMD !) reste intact.
    mag_cand = (diff >= 52) & (r >= 165) & (b >= 165) & (g <= 145)
    lbl_bg, _ = ndimage.label(mag_cand)
    border_ids = (
        set(lbl_bg[0, :].tolist())
        | set(lbl_bg[-1, :].tolist())
        | set(lbl_bg[:, 0].tolist())
        | set(lbl_bg[:, -1].tolist())
    )
    border_ids.discard(0)
    bg_mask = np.isin(lbl_bg, list(border_ids))
    fg_mask = ~bg_mask

    # Supprime toute poussière extérieure isolée < 48 px
    lbl, n_comp = ndimage.label(fg_mask)
    if n_comp > 0:
        sizes = ndimage.sum(fg_mask, lbl, range(1, n_comp + 1))
        keep_ids = [i + 1 for i, sz in enumerate(sizes) if sz >= 48]
        fg_mask = np.isin(lbl, keep_ids)

    dist = ndimage.distance_transform_edt(fg_mask)
    outer_spill = fg_mask & (dist <= 1.5) & (diff >= 26)
    fg_mask = fg_mask & (~outer_spill)

    dist2 = ndimage.distance_transform_edt(fg_mask)
    fringe = fg_mask & (dist2 <= 4.0) & (diff >= 12)
    clean_donors = fg_mask & (~fringe) & (diff < 12)
    _, nearest = ndimage.distance_transform_edt(~clean_donors, return_indices=True)

    rgb_clean = raw.copy()
    rgb_clean[fringe] = raw[nearest[0][fringe], nearest[1][fringe]]
    rgb_clean = clamp_bg_non_magenta(rgb_clean, max_rb_over_g=20)

    ys, xs = np.where(fg_mask)
    y0, y1 = int(ys.min()), int(ys.max()) + 1
    x0, x1 = int(xs.min()), int(xs.max()) + 1

    out = np.zeros((y1 - y0, x1 - x0, 4), dtype=np.uint8)
    sub_fg = fg_mask[y0:y1, x0:x1]
    out[sub_fg, :3] = rgb_clean[y0:y1, x0:x1][sub_fg]
    out[sub_fg, 3] = 255
    return Image.fromarray(out, mode="RGBA")


def scale_cutout_clean(
    cutout_rgba: Image.Image,
    target_w: int,
    target_h: int,
    binary_alpha: bool = True,
) -> Image.Image:
    """Redimensionne le blason Œuf+Ailes en dilatant ses couleurs vers l'extérieur avant LANCZOS
    (0 liseré sombre, 0 pixel magenta)."""
    arr = np.asarray(cutout_rgba.convert("RGBA"), dtype=np.uint8)
    fg = arr[:, :, 3] >= 128
    _, nearest = ndimage.distance_transform_edt(~fg, return_indices=True)
    rgb_dilated = arr[:, :, :3].copy()
    rgb_dilated[~fg] = arr[:, :, :3][nearest[0][~fg], nearest[1][~fg]]

    rgb_scaled = np.asarray(
        Image.fromarray(rgb_dilated, mode="RGB").resize((target_w, target_h), Image.Resampling.LANCZOS),
        dtype=np.uint8,
    )
    rgb_scaled = clamp_bg_non_magenta(rgb_scaled, max_rb_over_g=22)
    a_scaled = np.asarray(
        Image.fromarray(arr[:, :, 3], mode="L").resize((target_w, target_h), Image.Resampling.LANCZOS),
        dtype=np.uint8,
    )

    out = np.zeros((target_h, target_w, 4), dtype=np.uint8)
    if binary_alpha:
        mask = a_scaled >= 116
        out[mask, :3] = rgb_scaled[mask]
        out[mask, 3] = 255
    else:
        mask = a_scaled >= 16
        out[mask, :3] = rgb_scaled[mask]
        out[mask, 3] = a_scaled[mask]
    return Image.fromarray(out, mode="RGBA")


def build_title_ui_png_320x240() -> Image.Image:
    """Construit `Content/UI/Title.png` (`320 × 240` RGBA) avec le blason **plus petit et centré**."""
    hd = extract_destiny_logo_hd()
    logo_w = LOGO_W_320
    logo_h = int(round(logo_w * hd.height / float(hd.width)))
    scaled = scale_cutout_clean(hd, logo_w, logo_h, binary_alpha=False)
    canvas = Image.new("RGBA", (W_MENU, H_MENU), (0, 0, 0, 0))
    ox = (W_MENU - logo_w) // 2
    oy = LOGO_Y_320
    canvas.paste(scaled, (ox, oy), scaled)
    return canvas


def build_logo_ground_layer_768x576() -> Image.Image:
    """Construit le calque `09_logo_oeuf_ailes_centre` (`768 × 576`, plus petit & centré, `<= 84` couleurs)."""
    hd = extract_destiny_logo_hd()
    logo_w = LOGO_W_768
    logo_h = int(round(logo_w * hd.height / float(hd.width)))
    scaled = scale_cutout_clean(hd, logo_w, logo_h, binary_alpha=True)
    canvas = Image.new("RGBA", (W_CANON, H_CANON), (0, 0, 0, 0))
    ox = (W_CANON - logo_w) // 2
    oy = LOGO_Y_768
    canvas.paste(scaled, (ox, oy), scaled)

    arr = np.asarray(canvas, dtype=np.uint8)
    mask = arr[:, :, 3] == 255
    _, nearest = ndimage.distance_transform_edt(~mask, return_indices=True)
    rgb_solid = arr[:, :, :3].copy()
    rgb_solid[~mask] = arr[:, :, :3][nearest[0][~mask], nearest[1][~mask]]
    q_im = Image.fromarray(rgb_solid, mode="RGB").quantize(colors=84, method=Image.Quantize.FASTOCTREE).convert("RGB")
    q_rgb = clamp_bg_non_magenta(np.asarray(q_im, dtype=np.uint8), max_rb_over_g=22)
    out = np.zeros((H_CANON, W_CANON, 4), dtype=np.uint8)
    out[mask, :3] = q_rgb[mask]
    out[mask, 3] = 255
    return Image.fromarray(sanitize_rgba_binary(out), mode="RGBA")


def build_enter_ui_png_74x11() -> Image.Image:
    """Construit `Content/UI/Enter.png` (`74 × 11` RGBA) pixel-art `PRESS ENTER`."""
    glyphs: Dict[str, List[str]] = {
        "P": ["11110", "10001", "10001", "11110", "10000", "10000", "10000"],
        "R": ["11110", "10001", "10001", "11110", "10100", "10010", "10001"],
        "E": ["11111", "10000", "10000", "11110", "10000", "10000", "11111"],
        "S": ["01111", "10000", "10000", "01110", "00001", "00001", "11110"],
        "N": ["10001", "11001", "10101", "10011", "10001", "10001", "10001"],
        "T": ["11111", "00100", "00100", "00100", "00100", "00100", "00100"],
        " ": ["000", "000", "000", "000", "000", "000", "000"],
    }
    text = "PRESS ENTER"
    w, h = 74, 11
    mask_fg = np.zeros((h, w), dtype=bool)
    cx = 5
    for ch in text:
        pat = glyphs[ch]
        gw = len(pat[0])
        for gy, row in enumerate(pat):
            for gx, bit in enumerate(row):
                if bit == "1" and 0 <= cx + gx < w:
                    mask_fg[2 + gy, cx + gx] = True
        cx += gw + 1

    outline = ndimage.binary_dilation(mask_fg, structure=np.ones((3, 3), dtype=bool)) & (~mask_fg)
    arr = np.zeros((h, w, 4), dtype=np.uint8)
    arr[outline] = (10, 18, 48, 240)
    for y in range(2, 9):
        t = (y - 2) / 6.0
        col = (
            int(round(255 - 10 * t)),
            int(round(250 - 38 * t)),
            int(round(230 - 84 * t)),
            255,
        )
        arr[y, mask_fg[y]] = col
    return Image.fromarray(arr, mode="RGBA")


# ============================================================================
# 3. NUAGES CATHÉDRALE & MER PIXEL-ART GÉNÉRÉE (`JOUR` ET `NUIT` SÉPARÉS)
# ============================================================================

@lru_cache(maxsize=2)
def _prepare_cloud_masks_and_shades_768x576() -> Dict[str, np.ndarray]:
    """Aligne `nuages_cathedrale_magenta.png` sur l'horizon `y = 384` et indexe 6 teintes cel-shadées."""
    raw = np.asarray(Image.open(CLOUDS_RAW_PATH).convert("RGB"), dtype=np.uint8)
    rh, _rw = raw.shape[:2]
    r0, g0, b0 = raw[:, :, 0].astype(np.int16), raw[:, :, 1].astype(np.int16), raw[:, :, 2].astype(np.int16)
    mag0 = (r0 >= 205) & (g0 <= 62) & (b0 >= 205) & ((np.minimum(r0, b0) - g0) >= 135)

    row_mag = mag0.mean(axis=1)
    sea_rows = np.where(row_mag > 0.995)[0]
    raw_horizon = int(sea_rows[0]) if len(sea_rows) > 0 else int(round(rh * 0.702))

    fg0 = ~mag0
    dist0 = ndimage.distance_transform_edt(fg0)
    fg0 = fg0 & (~(fg0 & (dist0 <= 1.5) & ((np.minimum(r0, b0) - g0) >= 65)))
    dist1 = ndimage.distance_transform_edt(fg0)
    fringe0 = fg0 & (dist1 <= 2.5) & ((np.minimum(r0, b0) - g0) >= 28)
    donors0 = fg0 & (~fringe0)
    _, near0 = ndimage.distance_transform_edt(~donors0, return_indices=True)
    clean_rgb0 = raw.copy()
    clean_rgb0[fringe0] = raw[near0[0][fringe0], near0[1][fringe0]]

    sky_rgb = np.asarray(
        Image.fromarray(clean_rgb0[:raw_horizon], mode="RGB").resize(
            (W_CANON, HORIZON_Y), Image.Resampling.NEAREST
        ),
        dtype=np.uint8,
    )
    sky_fg = (
        np.asarray(
            Image.fromarray((fg0[:raw_horizon].astype(np.uint8) * 255), mode="L").resize(
                (W_CANON, HORIZON_Y), Image.Resampling.NEAREST
            ),
            dtype=np.uint8,
        )
        >= 128
    )

    fg_full = np.zeros((H_CANON, W_CANON), dtype=bool)
    fg_full[:HORIZON_Y] = sky_fg

    lum = (
        0.299 * sky_rgb[:, :, 0].astype(np.float32)
        + 0.587 * sky_rgb[:, :, 1].astype(np.float32)
        + 0.114 * sky_rgb[:, :, 2].astype(np.float32)
    )
    shades_sky = np.zeros((HORIZON_Y, W_CANON), dtype=np.uint8)
    shades_sky[lum >= 148.0] = 1
    shades_sky[lum >= 178.0] = 2
    shades_sky[lum >= 206.0] = 3
    shades_sky[lum >= 232.0] = 4
    shades_sky[lum >= 246.0] = 5

    shades_full = np.zeros((H_CANON, W_CANON), dtype=np.uint8)
    shades_full[:HORIZON_Y] = shades_sky

    yy, xx = np.mgrid[0:H_CANON, 0:W_CANON]
    horizon_band = fg_full & (
        (yy >= 344) | ((yy >= 312) & (xx >= 216) & (xx < 552) & (shades_full >= 2))
    )
    left_cathedral = fg_full & (~horizon_band) & (xx < (W_CANON // 2))
    right_cathedral = fg_full & (~horizon_band) & (xx >= (W_CANON // 2))

    sky_opening = (~fg_full) & (yy < HORIZON_Y)
    dist_to_opening = ndimage.distance_transform_edt(~sky_opening)
    inner_rim = fg_full & (dist_to_opening <= 3.2) & (shades_full >= 4) & (yy < 368)

    return {
        "fg_full": fg_full,
        "shades_full": shades_full,
        "horizon_mask": horizon_band,
        "left_mask": left_cathedral,
        "right_mask": right_cathedral,
        "inner_rim": inner_rim,
        "sky_opening": sky_opening,
    }


@lru_cache(maxsize=4)
def _load_generated_sea_768x192(mode: ModeKind) -> np.ndarray:
    """Extrait la mer pixel-art générée façon *PMD Explorers of Sky* (`H01P99A`/`Sub_v01p03a` Jour
    et `H01P99C` Nuit) sous la ligne d'horizon `#FF00FF`, quantifiée proprement à `<= 44` couleurs
    pixel-art DS sans aucun pixel magenta."""
    raw_path = SEA_DAY_RAW_PATH if mode == "jour" else SEA_NIGHT_RAW_PATH
    raw = np.asarray(Image.open(raw_path).convert("RGB"), dtype=np.uint8)
    r0, g0, b0 = raw[:, :, 0].astype(np.int16), raw[:, :, 1].astype(np.int16), raw[:, :, 2].astype(np.int16)
    diff_row = (np.minimum(r0, b0) - g0).mean(axis=1)
    mag0 = (r0 >= 200) & (g0 <= 65) & (b0 >= 200)
    water_rows = np.where((mag0.mean(axis=1) < 0.01) & (diff_row < 5.0))[0]
    y_start = int(water_rows[0]) if len(water_rows) > 0 else int(raw.shape[0] * 0.505)

    sea_crop = raw[y_start:, :, :]
    sea_h = H_CANON - HORIZON_Y  # 192 px
    sea_resized = Image.fromarray(sea_crop, mode="RGB").resize((W_CANON, sea_h), Image.Resampling.NEAREST)
    sea_quant = sea_resized.quantize(colors=44, method=Image.Quantize.FASTOCTREE).convert("RGB")
    sea_u8 = clamp_bg_non_magenta(np.asarray(sea_quant, dtype=np.uint8), max_rb_over_g=22)
    return sea_u8


def _build_generated_sea_layers_24(mode: ModeKind) -> Tuple[List[Image.Image], List[Image.Image]]:
    """Construit à partir de la mer générée (`Jour` ou `Nuit`) :
    - `03_mer_pixelart_<mode>` (`BG`, `24p` sur `7` états d'ondulation perspective -> `<= 16 128 << 24 000` tuiles)
    - `04_ecume_et_reflets_mer_<mode>` (`BG`, `24p` distinctes d'éclats d'écume et de reflets scintillants)."""
    sea_base = _load_generated_sea_768x192(mode)
    sea_h = H_CANON - HORIZON_Y
    z_rows = np.linspace(0.0, 1.0, sea_h, dtype=np.float32)

    # 7 états harmoniques symétriques mappés sur les 24 poses : boucle parfaite pose 23 -> pose 0
    # et garantie mathématique <= 7 * 2304 = 16 128 tuiles 8x8 uniques (<< 24 000) !
    step_seq = [0, 1, 2, 3, 4, 5, 6, 6, 5, 4, 3, 2, 1, 0, 1, 2, 3, 4, 5, 6, 5, 4, 3, 1]
    sway_cache: Dict[int, Image.Image] = {}
    for st in set(step_seq):
        offset_norm = (st - 3.0) / 3.0  # [-1.0 .. +1.0]
        swayed = np.empty_like(sea_base)
        for ry in range(sea_h):
            zr = float(z_rows[ry])
            # 0 px à l'horizon (ry=0..3) pour garder une ligne d'horizon irréprochable,
            # ondulation latérale douce ±1..3 px dans les courants marins intermédiaires et proches
            if ry < 4:
                shift = 0
            else:
                wave_band = math.sin(2.0 * math.pi * (zr ** 0.72) * 2.5)
                shift = int(round(offset_norm * (0.8 + 2.4 * zr) * wave_band))
            if shift == 0:
                swayed[ry] = sea_base[ry]
            elif shift > 0:
                swayed[ry, shift:] = sea_base[ry, :-shift]
                swayed[ry, :shift] = sea_base[ry, shift : 2 * shift][::-1]
            else:
                s = -shift
                swayed[ry, :-s] = sea_base[ry, s:]
                swayed[ry, -s:] = sea_base[ry, -2 * s : -s][::-1]

        arr03 = np.zeros((H_CANON, W_CANON, 4), dtype=np.uint8)
        arr03[HORIZON_Y:, :, :3] = swayed
        arr03[HORIZON_Y:, :, 3] = 255
        sway_cache[st] = Image.fromarray(sanitize_rgba_binary(arr03), mode="RGBA")

    layer03_24 = [sway_cache[step_seq[f]] for f in range(N_POSES)]

    # Calque 04 : Extraction stricte des éclats locaux & crêtes festonnées PMD Sky (0 bande diagonale !)
    lum = (
        0.299 * sea_base[:, :, 0].astype(np.float32)
        + 0.587 * sea_base[:, :, 1].astype(np.float32)
        + 0.114 * sea_base[:, :, 2].astype(np.float32)
    )
    row_med = np.median(lum, axis=1, keepdims=True)
    hi_mask = (lum - row_med) >= (18.0 if mode == "jour" else 14.0)

    yy_s, xx_s = np.mgrid[0:sea_h, 0:W_CANON]
    rng = np.random.default_rng(202610 if mode == "jour" else 202699)
    glints = [
        (
            int(rng.integers(44, W_CANON - 44)),
            int(rng.integers(6, sea_h - 10)),
            float(rng.uniform(0.0, 2.0 * math.pi)),
            int(rng.choice([1, 2])),
        )
        for _ in range(36)
    ]

    if mode == "jour":
        c_gleam_hi = (238, 254, 255)
        c_gleam_mid = (156, 242, 255)
    else:
        c_gleam_hi = (224, 246, 255)
        c_gleam_mid = (118, 178, 232)

    layer04_24: List[Image.Image] = []
    for f in range(N_POSES):
        t_anim = 2.0 * math.pi * f / float(N_POSES)
        arr04 = np.zeros((H_CANON, W_CANON, 4), dtype=np.uint8)
        sub_rgb = np.zeros((sea_h, W_CANON, 3), dtype=np.uint8)
        sub_m = np.zeros((sea_h, W_CANON), dtype=bool)

        # Onde horizontale douce façon PMD Explorers of Sky sur les éclats locaux & crêtes festonnées
        shimmer_wave = np.sin(0.24 * yy_s - 2.0 * t_anim + 0.65 * np.sin(0.045 * xx_s))
        active_hi = hi_mask & (shimmer_wave > 0.18)
        bright_core = hi_mask & (shimmer_wave > 0.72)
        sub_rgb[active_hi] = sea_base[active_hi]
        sub_rgb[bright_core] = c_gleam_hi
        sub_m |= active_hi

        # Étoiles d'écume / reflets stellaires pixel-art à phases indépendantes
        for gx, gy, gph, gfreq in glints:
            twk = 0.5 + 0.5 * math.sin(gfreq * t_anim + gph)
            if twk > 0.64:
                arm = 3 if twk > 0.86 else 1
                for dx_g in range(-arm, arm + 1):
                    if 0 <= gx + dx_g < W_CANON:
                        sub_rgb[gy, gx + dx_g] = c_gleam_hi if abs(dx_g) <= 1 else c_gleam_mid
                        sub_m[gy, gx + dx_g] = True
                if arm >= 3:
                    for dy_g in (-1, 1):
                        if 0 <= gy + dy_g < sea_h:
                            sub_rgb[gy + dy_g, gx] = c_gleam_mid
                            sub_m[gy + dy_g, gx] = True

        sub_rgb = clamp_bg_non_magenta(sub_rgb, max_rb_over_g=22)
        arr04[HORIZON_Y:][sub_m, :3] = sub_rgb[sub_m]
        arr04[HORIZON_Y:][sub_m, 3] = 255
        layer04_24.append(Image.fromarray(sanitize_rgba_binary(arr04), mode="RGBA"))

    return layer03_24, layer04_24


# ============================================================================
# 4. CALQUES CÉLESTES SÉPARÉS : JOUR (`DSTJ`) VS NUIT (`DSTN`)
# ============================================================================

def _build_sky_separate_24(mode: ModeKind) -> List[Image.Image]:
    """`00_ciel` séparé Jour (azur lumineux) ou Nuit (cosmos étoilé profond)."""
    bayer_tile = np.tile(BAYER_8X8, (H_CANON // 8, W_CANON // 8))
    y_norm = np.linspace(0.0, 1.0, HORIZON_Y, dtype=np.float32)

    if mode == "jour":
        stops_y = np.array([0.0, 0.38, 0.72, 1.0], dtype=np.float32)
        stops_rgb = np.array(
            [
                (28, 108, 214),   # Zénith bleu azur franc
                (68, 156, 240),   # Ciel moyen céruléen vif
                (132, 206, 252),  # Azur clair lumineux
                (212, 246, 255),  # Horizon marin baigné de soleil
            ],
            dtype=np.float32,
        )
        sea_fallback = (22, 138, 212)
    else:
        stops_y = np.array([0.0, 0.40, 0.76, 1.0], dtype=np.float32)
        stops_rgb = np.array(
            [
                (7, 12, 38),      # Zénith cosmos nocturne
                (14, 26, 68),     # Bleu nuit profond
                (24, 46, 98),     # Voûte marine étoilée
                (48, 84, 132),    # Lueur lunaire rasante sur l'horizon
            ],
            dtype=np.float32,
        )
        sea_fallback = (12, 28, 62)

    sky_f = np.zeros((HORIZON_Y, W_CANON, 3), dtype=np.float32)
    for c in range(3):
        sky_f[:, :, c] = np.interp(y_norm, stops_y, stops_rgb[:, c])[:, None]

    sky_q = np.clip(np.floor(sky_f / 4.0 + bayer_tile[:HORIZON_Y, :, None]) * 4.0, 0.0, 255.0).astype(np.uint8)
    sky_q = clamp_bg_non_magenta(sky_q, max_rb_over_g=22)

    full = np.zeros((H_CANON, W_CANON, 4), dtype=np.uint8)
    full[:HORIZON_Y, :, :3] = sky_q
    full[HORIZON_Y:, :, :3] = sea_fallback
    full[:, :, 3] = 255
    im_static = Image.fromarray(full, mode="RGBA")
    return [im_static for _ in range(N_POSES)]


def _build_beam_separate_24(mode: ModeKind, sky_opening: np.ndarray) -> List[Image.Image]:
    """`01_faisceau` : Colonne solaire dorée respirante (Jour) ou rayon astral argenté (Nuit)."""
    yy, xx = np.mgrid[0:HORIZON_Y, 0:W_CANON]
    dx = np.abs(xx.astype(np.float32) - (W_CANON * 0.5))
    vy = (HORIZON_Y - yy).astype(np.float32) / float(HORIZON_Y)
    core_w = 20.0 + 28.0 * (1.0 - vy) ** 1.6
    halo_w = 62.0 + 84.0 * (1.0 - vy) ** 2.0
    intensity = (
        0.66 * np.exp(-((dx / core_w) ** 2)) * ((1.0 - vy * 0.58) ** 1.2)
        + 0.42 * np.exp(-((dx / halo_w) ** 2)) * ((1.0 - vy) ** 2.0)
    )
    bayer_sky = np.tile(BAYER_8X8, (HORIZON_Y // 8, W_CANON // 8))

    if mode == "jour":
        cols = ((168, 228, 255), (224, 248, 255), (255, 254, 232))
    else:
        cols = ((44, 78, 134), (82, 134, 192), (156, 212, 242))

    # 5 paliers respirants symétriques (<= 3 500 tuiles uniques !)
    pulse_steps = [0, 1, 2, 3, 4, 4, 3, 2, 1, 0, 1, 2, 3, 4, 4, 3, 2, 1, 0, 1, 2, 3, 2, 1]
    cache: Dict[int, Image.Image] = {}
    for st in set(pulse_steps):
        amp = 0.88 + 0.05 * st
        lvl = np.floor(intensity * amp * 4.8 + bayer_sky * 0.65).astype(np.int32)
        active = (lvl >= 1) & sky_opening[:HORIZON_Y]
        arr = np.zeros((H_CANON, W_CANON, 4), dtype=np.uint8)
        rgb_s = np.zeros((HORIZON_Y, W_CANON, 3), dtype=np.uint8)
        for lv_min, col in ((1, cols[0]), (2, cols[1]), (3, cols[2])):
            rgb_s[active & (lvl >= lv_min)] = col
        arr[:HORIZON_Y][active, :3] = clamp_bg_non_magenta(rgb_s, max_rb_over_g=22)[active]
        arr[:HORIZON_Y][active, 3] = 255
        cache[st] = Image.fromarray(sanitize_rgba_binary(arr), mode="RGBA")
    return [cache[pulse_steps[f]] for f in range(N_POSES)]


def _draw_pixel_star(
    arr: np.ndarray,
    sx: int,
    sy: int,
    stage: int,
    core_col: Tuple[int, int, int],
    halo_col: Tuple[int, int, int],
) -> None:
    h, w = arr.shape[:2]

    def put(px: int, py: int, col: Tuple[int, int, int]) -> None:
        if 0 <= px < w and 0 <= py < HORIZON_Y and py < h:
            arr[py, px, :3] = col
            arr[py, px, 3] = 255

    if stage <= 0:
        return
    if stage == 1:
        for dy in (0, 1):
            for dx in (0, 1):
                put(sx + dx, sy + dy, halo_col)
        return
    if stage == 2:
        for dy in (-1, 0, 1):
            for dx in (-1, 0, 1):
                put(sx + dx, sy + dy, core_col if (dx == 0 or dy == 0) else halo_col)
        return
    arm = 3 if stage == 3 else 5
    for d in range(-arm, arm + 1):
        put(sx + d, sy, core_col if abs(d) <= 1 else halo_col)
        put(sx, sy + d, core_col if abs(d) <= 1 else halo_col)
    for dy in (-1, 0, 1):
        for dx in (-1, 0, 1):
            put(sx + dx, sy + dy, core_col)


def _build_celestial_sky_details_24(mode: ModeKind, sky_opening: np.ndarray) -> List[Image.Image]:
    """`02_details_ciel` :
    - En **JOUR** : oiseaux marins blancs lointains planant en douceur + éclats solaires cristallins.
    - En **NUIT** : ~105 étoiles pixel-art scintillantes à phases indépendantes + étoile filante (`poses 11..15`)."""
    dist_open = ndimage.distance_transform_edt(sky_opening[:HORIZON_Y])
    frames: List[Image.Image] = []

    if mode == "jour":
        # 5 oiseaux marins blancs lointains en vol plané périodique + 18 éclats de lumière solaire
        birds = [
            (296, 86, 0.0, 1),
            (318, 98, 0.8, 0),
            (468, 112, 2.1, 1),
            (490, 124, 2.9, 0),
            (378, 66, 4.2, 1),
        ]
        rng_d = np.random.default_rng(120812)
        sun_glints = []
        while len(sun_glints) < 22:
            gx = int(rng_d.integers(140, W_CANON - 140))
            gy = int(rng_d.integers(24, HORIZON_Y - 64))
            if dist_open[gy, gx] >= 6.0:
                sun_glints.append((gx, gy, float(rng_d.uniform(0.0, 2.0 * math.pi))))

        for f in range(N_POSES):
            theta = 2.0 * math.pi * f / float(N_POSES)
            arr = np.zeros((H_CANON, W_CANON, 4), dtype=np.uint8)
            for bx0, by0, bph, bsz in birds:
                bx = int(round(bx0 + 10.0 * math.sin(theta + bph)))
                by = int(round(by0 + 4.0 * math.cos(theta + bph)))
                flap = int(round(math.sin(2.0 * theta + bph)))
                wing_span = 4 + bsz * 2
                for dx_b in range(-wing_span, wing_span + 1):
                    wy = by - abs(dx_b) // 2 * flap
                    if 0 <= bx + dx_b < W_CANON and 0 <= wy < HORIZON_Y and sky_opening[wy, bx + dx_b]:
                        arr[wy, bx + dx_b] = (255, 255, 252, 255)
                        if abs(dx_b) <= 1 and wy + 1 < HORIZON_Y:
                            arr[wy + 1, bx + dx_b] = (196, 232, 255, 255)

            for gx, gy, gph in sun_glints:
                tw = 0.5 + 0.5 * math.sin(2.0 * theta + gph)
                if tw > 0.72:
                    _draw_pixel_star(arr, gx, gy, 2 if tw < 0.90 else 3, (255, 255, 242), (182, 234, 255))
            frames.append(Image.fromarray(sanitize_rgba_binary(arr), mode="RGBA"))
        return frames

    # Mode NUIT : ~105 étoiles scintillantes toute la nuit + étoile filante !
    rng = np.random.default_rng(20260812)
    stars: List[Tuple[int, int, int, float, int, int]] = [
        (384, 58, 4, 0.0, 2, 0),
        (308, 108, 4, 1.7, 2, 1),
        (462, 98, 4, 3.4, 2, 2),
    ]
    occupied = np.zeros((HORIZON_Y, W_CANON), dtype=bool)
    for sx0, sy0, *_ in stars:
        occupied[max(0, sy0 - 13) : min(HORIZON_Y, sy0 + 14), max(0, sx0 - 13) : min(W_CANON, sx0 + 14)] = True

    attempts = 0
    while len(stars) < 105 and attempts < 7000:
        attempts += 1
        sx = int(rng.integers(16, W_CANON - 16))
        sy = int(12 + (HORIZON_Y - 46) * (rng.random() ** 1.2))
        if dist_open[sy, sx] < 4.5 or occupied[sy, sx]:
            continue
        occupied[max(0, sy - 10) : min(HORIZON_Y, sy + 11), max(0, sx - 10) : min(W_CANON, sx + 11)] = True
        max_st = int(rng.choice([2, 2, 3, 3, 4], p=[0.28, 0.25, 0.27, 0.12, 0.08]))
        stars.append(
            (
                sx,
                sy,
                max_st,
                float(rng.uniform(0.0, 2.0 * math.pi)),
                int(rng.choice([1, 2, 3], p=[0.25, 0.55, 0.20])),
                int(rng.choice([0, 1, 2], p=[0.50, 0.32, 0.18])),
            )
        )

    tints_core = [(248, 252, 255), (210, 238, 255), (255, 244, 206)]
    tints_halo = [(128, 174, 236), (94, 148, 224), (196, 182, 148)]

    for f in range(N_POSES):
        arr = np.zeros((H_CANON, W_CANON, 4), dtype=np.uint8)
        for sx, sy, max_st, ph, freq, tid in stars:
            twinkle = 0.5 + 0.5 * math.sin(2.0 * math.pi * freq * (f / float(N_POSES)) + ph)
            st = max(1, int(round((0.42 + 0.58 * twinkle) * max_st)))
            _draw_pixel_star(arr, sx, sy, min(st, max_st), tints_core[tid], tints_halo[tid])

        if 11 <= f <= 15:
            prog = (f - 11) / 4.0
            hx = int(round(476 - 152 * prog))
            hy = int(round(56 + 88 * prog))
            for tail in range(0, 28):
                tx = hx + int(round(tail * 1.45))
                ty = hy - int(round(tail * 0.92))
                if 0 <= tx < W_CANON and 0 <= ty < HORIZON_Y and sky_opening[ty, tx]:
                    arr[ty, tx, :3] = (252, 254, 255) if tail < 5 else ((172, 220, 252) if tail < 15 else (88, 138, 208))
                    arr[ty, tx, 3] = 255
                    if tail < 8 and ty + 1 < HORIZON_Y:
                        arr[ty + 1, tx] = (172, 220, 252, 255)

        arr[:, :, :3] = clamp_bg_non_magenta(arr[:, :, :3], max_rb_over_g=22)
        frames.append(Image.fromarray(sanitize_rgba_binary(arr), mode="RGBA"))
    return frames


def _build_cloud_subset_separate(mode: ModeKind, mask: np.ndarray, shades: np.ndarray) -> List[Image.Image]:
    """Palette cel-shadée dédiée Jour (blanc immaculé & azur doux) ou Nuit (argent lunaire & indigo)."""
    if mode == "jour":
        pal = np.array(
            [
                (86, 134, 206),   # 0 : ombre fraîche d'azur
                (122, 168, 228),  # 1 : ombre douce pervenche-ciel
                (172, 208, 246),  # 2 : brume claire diurne
                (224, 240, 255),  # 3 : volume cotonneux lumineux
                (248, 251, 246),  # 4 : dôme blanc ensoleillé
                (255, 255, 244),  # 5 : crête éclatante au soleil
            ],
            dtype=np.uint8,
        )
    else:
        pal = np.array(
            [
                (16, 26, 62),     # 0 : ombre nocturne profonde
                (28, 46, 94),     # 1 : saphir sombre
                (48, 76, 132),    # 2 : brume d'ardoise lunaire
                (84, 122, 178),   # 3 : revers bleuté astral
                (142, 182, 226),  # 4 : dôme baigné de lune
                (206, 232, 252),  # 5 : liseré d'argent stellaire
            ],
            dtype=np.uint8,
        )

    arr = np.zeros((H_CANON, W_CANON, 4), dtype=np.uint8)
    arr[mask, :3] = pal[shades[mask]]
    arr[mask, 3] = 255
    im_static = Image.fromarray(sanitize_rgba_binary(arr), mode="RGBA")
    return [im_static for _ in range(N_POSES)]


def _build_rim_and_breeze_separate_24(mode: ModeKind, inner_rim: np.ndarray, sky_opening: np.ndarray) -> List[Image.Image]:
    """`08_franges_et_brise` : Frange lumineuse des nuages + particules aériennes (plumes dorées Jour / poussière astrale Nuit)."""
    rng = np.random.default_rng(770812 if mode == "jour" else 990812)
    motes = [
        (
            int(rng.integers(88, W_CANON - 88)),
            int(rng.integers(56, HORIZON_Y - 24)),
            float(rng.uniform(0.0, 1.0)),
            int(rng.choice([2, 3])),
        )
        for _ in range(22)
    ]
    if mode == "jour":
        rim_col = (255, 255, 236)
        mc, mh = (255, 252, 214), (176, 232, 255)
    else:
        rim_col = (218, 240, 255)
        mc, mh = (208, 238, 255), (98, 158, 224)

    frames: List[Image.Image] = []
    for f in range(N_POSES):
        t_norm = f / float(N_POSES)
        pulse = 0.5 + 0.5 * math.sin(2.0 * math.pi * t_norm)
        arr = np.zeros((H_CANON, W_CANON, 4), dtype=np.uint8)
        arr[inner_rim, :3] = rim_col
        arr[inner_rim, 3] = 255

        for mx0, my0, ph0, sz in motes:
            prog = (t_norm + ph0) % 1.0
            mx = int(round(mx0 + 10.0 * math.sin(2.0 * math.pi * prog + ph0 * 6.0)))
            my = int(round(my0 - 16.0 * math.sin(2.0 * math.pi * prog)))
            if 2 <= mx < W_CANON - 2 and 2 <= my < HORIZON_Y - 2 and sky_opening[my, mx]:
                arr[my, mx] = (*mc, 255)
                if sz >= 3 or pulse > 0.5:
                    for dx_m, dy_m in ((-1, 0), (1, 0), (0, -1), (0, 1)):
                        arr[my + dy_m, mx + dx_m] = (*mh, 255)
        frames.append(Image.fromarray(sanitize_rgba_binary(arr), mode="RGBA"))
    return frames


@lru_cache(maxsize=4)
def build_destiny_separate_scene(mode: ModeKind) -> Dict[str, object]:
    """Construit la scène 10 calques `768×576` ET les `24` poses `.dir` `320×240` SANS logo
    pour `mode == 'jour'` ou `mode == 'nuit'`."""
    cloud_data = _prepare_cloud_masks_and_shades_768x576()
    sky_opening = cloud_data["sky_opening"]
    shades = cloud_data["shades_full"]

    l00_sky = _build_sky_separate_24(mode)
    l01_beam = _build_beam_separate_24(mode, sky_opening)
    l02_sky_fx = _build_celestial_sky_details_24(mode, sky_opening)
    l03_sea, l04_sea_fx = _build_generated_sea_layers_24(mode)
    l05_hor = _build_cloud_subset_separate(mode, cloud_data["horizon_mask"], shades)
    l06_left = _build_cloud_subset_separate(mode, cloud_data["left_mask"], shades)
    l07_right = _build_cloud_subset_separate(mode, cloud_data["right_mask"], shades)
    l08_breeze = _build_rim_and_breeze_separate_24(mode, cloud_data["inner_rim"], sky_opening)
    l09_logo = [build_logo_ground_layer_768x576()]

    bg_layers = [l00_sky, l01_beam, l02_sky_fx, l03_sea, l04_sea_fx, l05_hor, l06_left, l07_right, l08_breeze]

    bg_composites_768: List[Image.Image] = []
    bg_frames_320x240: List[Image.Image] = []
    for f in range(N_POSES):
        comp = Image.new("RGBA", (W_CANON, H_CANON), (0, 0, 0, 255))
        for lay in bg_layers:
            comp.alpha_composite(lay[f % len(lay)])
        bg_composites_768.append(comp)

        # Réduction fidèle vers 320x240 (ciel & faisceau en BILINEAR, mer pixel-art, nuages & étoiles en NEAREST !)
        base_under = Image.new("RGBA", (W_CANON, H_CANON), (0, 0, 0, 255))
        base_under.alpha_composite(l00_sky[f])
        base_under.alpha_composite(l01_beam[f])
        under_320 = base_under.convert("RGB").resize((W_MENU, H_MENU), Image.Resampling.BILINEAR).convert("RGBA")

        for crisp_lay in (l02_sky_fx[f], l03_sea[f], l04_sea_fx[f], l05_hor[f], l06_left[f], l07_right[f], l08_breeze[f]):
            under_320.alpha_composite(crisp_lay.resize((W_MENU, H_MENU), Image.Resampling.NEAREST))

        arr320 = clamp_bg_non_magenta(np.asarray(under_320.convert("RGB"), dtype=np.uint8), max_rb_over_g=24)
        bg_frames_320x240.append(
            Image.fromarray(np.dstack([arr320, np.full((H_MENU, W_MENU), 255, dtype=np.uint8)]), mode="RGBA")
        )

    tag_fr = "Jour" if mode == "jour" else "Nuit"
    sky_desc = (
        "Ciel Azur Ensoleillé Statique (1p)" if mode == "jour" else "Voûte Nocturne Cosmos Profond (1p)"
    )
    beam_desc = (
        "Faisceau Solaire Zénithal Respirant" if mode == "jour" else "Colonne Astrale Argentée Nocturne"
    )
    fx_desc = (
        "Oiseaux Marins Lointains & Éclats Solaires" if mode == "jour" else "~105 Étoiles Scintillantes & Étoile Filante"
    )
    sea_desc = (
        "Mer Pixel-Art Générée Diurne (Houle Perspective)" if mode == "jour" else "Mer Pixel-Art Générée Nocturne (Houle Lunaire)"
    )
    refl_desc = (
        "Écume Scintillante & Reflets Solaires sur la Mer" if mode == "jour" else "Crêtes Argentées & Reflets d'Étoiles sur la Mer"
    )

    return {
        "mode": mode,
        "layers_768": [
            (f"00_ciel_{mode}", sky_desc, "BG", l00_sky[:1], FRAME_TICKS_MENU),
            (f"01_faisceau_{mode}", beam_desc, "BG", l01_beam, FRAME_TICKS_MENU),
            (f"02_ciel_anime_{mode}", fx_desc, "BG", l02_sky_fx, FRAME_TICKS_MENU),
            (f"03_mer_pixelart_{mode}", sea_desc, "BG", l03_sea, FRAME_TICKS_MENU),
            (f"04_reflets_mer_{mode}", refl_desc, "BG", l04_sea_fx, FRAME_TICKS_MENU),
            (f"05_nuages_horizon_{mode}", f"Bancs de Nuages d'Horizon ({tag_fr})", "BG", l05_hor[:1], FRAME_TICKS_MENU),
            (f"06_nuages_gauche_{mode}", f"Cumulus Cathédrale Gauche ({tag_fr})", "BG", l06_left[:1], FRAME_TICKS_MENU),
            (f"07_nuages_droite_{mode}", f"Cumulus Cathédrale Droite ({tag_fr})", "BG", l07_right[:1], FRAME_TICKS_MENU),
            (f"08_brise_celeste_{mode}", f"Franges Lumineuses & Brise Céleste ({tag_fr})", "BG", l08_breeze, FRAME_TICKS_MENU),
            ("09_logo_oeuf_ailes_centre", "Blason Pokémon Mystery Dungeon : Destiny (Œuf & 2 Ailes/Côté, Centré)", "Top", l09_logo, FRAME_TICKS_MENU),
        ],
        "bg_composites_768": bg_composites_768,
        "bg_frames_320x240": bg_frames_320x240,
    }


# ============================================================================
# 5. ANIMATION D'OPENING D'ANIME EN UNE SEULE FOIS (`arrive en une seule fois`)
# ============================================================================

def render_anime_opening_logo_sequence(
    canvas_w: int = W_MENU,
    canvas_h: int = H_MENU,
    n_frames: int = 24,
) -> List[Image.Image]:
    """Génère les `n_frames` poses RGBA (fond transparent) de l'**apparition unique façon Opening d'Anime**
    du blason Œuf + Ailes `Pokémon Mystery Dungeon : DESTINY` :
      - `frames 0..3`  : Ciel & mer seuls (anticipation d'opening)
      - `frames 4..6`  : Éclat lumineux horizontal anamorphique + croix céleste au centre
      - `frames 7..14` : Arrivée du logo EN UNE SEULE FOIS (`scale 1.40× → 0.985× → 1.00×` easeOutBack
                         + fondu de silhouette blanc-doré vers couleurs pleines + halo & plumes radiales)
      - `frames 15..20`: Reflet métallique diagonal (« Shing! ») balayant une fois le blason stabilisé
      - `frames 21..23`: Logo centré 100 % fixe et net !"""
    hd = extract_destiny_logo_hd()
    base_w = LOGO_W_320 if canvas_w == W_MENU else int(round(LOGO_W_768 * (canvas_w / float(W_CANON))))
    base_h = int(round(base_w * hd.height / float(hd.width)))
    cx = canvas_w // 2
    base_top = LOGO_Y_320 if canvas_w == W_MENU else int(round(LOGO_Y_768 * (canvas_h / float(H_CANON))))
    cy = base_top + base_h // 2

    logo_1x = scale_cutout_clean(hd, base_w, base_h, binary_alpha=False)
    arr_1x = np.asarray(logo_1x, dtype=np.uint8)

    rng = np.random.default_rng(777)
    feathers = [
        (
            float(rng.uniform(0.0, 2.0 * math.pi)),
            float(rng.uniform(0.32, 0.68)) * base_w,
        )
        for _ in range(14)
    ]

    seq: List[Image.Image] = []
    for f in range(n_frames):
        frame = Image.new("RGBA", (canvas_w, canvas_h), (0, 0, 0, 0))
        draw = ImageDraw.Draw(frame)

        # Phase B (frames 4..8) : Éclat horizontal anamorphique d'opening d'anime
        if 4 <= f <= 8:
            flare_u = (f - 4) / 4.0
            flare_env = math.sin(math.pi * flare_u)
            half_len = int(round(canvas_w * (0.18 + 0.30 * flare_u)))
            flare_h = max(2, int(round((6.0 if canvas_w == W_MENU else 14.0) * flare_env)))
            a_fl = int(round(235 * flare_env))
            draw.ellipse(
                [cx - half_len, cy - flare_h, cx + half_len, cy + flare_h],
                fill=(255, 250, 214, a_fl),
            )
            r_star = max(4, int(round((14.0 if canvas_w == W_MENU else 32.0) * flare_env)))
            draw.ellipse(
                [cx - r_star, cy - r_star, cx + r_star, cy + r_star],
                fill=(255, 255, 244, min(255, int(a_fl * 1.1))),
            )

        # Phase C..E (frames 6..23) : Apparition en UNE SEULE FOIS + stabilisation + reflet diagonal
        if f >= 6:
            if f <= 13:
                u = (f - 6) / 7.0
                # Courbe easeOutBack d'impact anime : 1.40 -> 0.985 -> 1.000
                c1 = 1.70158
                c3 = c1 + 1.0
                ease = 1.0 + c3 * ((u - 1.0) ** 3) + c1 * ((u - 1.0) ** 2)
                scale = 1.40 + (1.00 - 1.40) * ease
                alpha_mul = min(1.0, (f - 5) / 2.5)
                white_flash = max(0.0, 1.0 - (f - 6) / 4.2)
            else:
                scale = 1.0
                alpha_mul = 1.0
                white_flash = 0.0

            cur_w = max(16, int(round(base_w * scale)))
            cur_h = max(16, int(round(base_h * scale)))
            scaled_im = logo_1x if (cur_w, cur_h) == (base_w, base_h) else scale_cutout_clean(hd, cur_w, cur_h, binary_alpha=False)
            s_arr = np.asarray(scaled_im, dtype=np.uint8).copy()

            # Silhouette blanc-or au moment de l'impact qui révèle les vraies couleurs
            if white_flash > 0.01:
                flash_col = np.array([255.0, 250.0, 224.0], dtype=np.float32)
                s_arr[:, :, :3] = np.clip(
                    s_arr[:, :, :3].astype(np.float32) * (1.0 - white_flash) + flash_col * white_flash,
                    0.0,
                    255.0,
                ).astype(np.uint8)

            # Reflet métallique diagonal unique (« Shing! », frames 15..20)
            if 15 <= f <= 20 and (cur_w, cur_h) == (base_w, base_h):
                sh_u = (f - 15) / 5.0
                yy_l, xx_l = np.mgrid[0:cur_h, 0:cur_w]
                diag = (xx_l.astype(np.float32) + 0.55 * yy_l.astype(np.float32)) / (cur_w + 0.55 * cur_h)
                band = np.abs(diag - sh_u)
                sheen = np.clip(1.0 - band / 0.11, 0.0, 1.0) * 0.72
                s_arr[:, :, :3] = np.clip(
                    s_arr[:, :, :3].astype(np.float32) + sheen[:, :, None] * 120.0,
                    0.0,
                    255.0,
                ).astype(np.uint8)

            s_arr[:, :, :3] = clamp_bg_non_magenta(s_arr[:, :, :3], max_rb_over_g=22)
            if alpha_mul < 0.999:
                s_arr[:, :, 3] = np.clip(s_arr[:, :, 3].astype(np.float32) * alpha_mul, 0.0, 255.0).astype(np.uint8)

            ox = cx - cur_w // 2
            oy = cy - cur_h // 2
            logo_pose = Image.fromarray(s_arr, mode="RGBA")
            frame.alpha_composite(logo_pose, (ox, oy))

            # Particules d'impact radiales (frames 7..14) qui s'estompent une seule fois
            if 7 <= f <= 14:
                pu = (f - 7) / 7.0
                pa = int(round(220 * (1.0 - pu)))
                for ang, dist_max in feathers:
                    r_cur = (0.35 + 0.65 * pu) * dist_max
                    px = int(round(cx + math.cos(ang) * r_cur))
                    py = int(round(cy + math.sin(ang) * r_cur * 0.62))
                    rad = 1 if canvas_w == W_MENU else 2
                    draw.ellipse([px - rad, py - rad, px + rad, py + rad], fill=(255, 252, 224, pa))

        seq.append(frame)
    return seq


# ============================================================================
# 6. MÉTADONNÉES QUEST & SERVICE LUA JOUR / NUIT + OPENING (`PMDO 0.8.12`)
# ============================================================================

DESTINY_MOD_XML = """<?xml version="1.0" encoding="utf-8"?>
<Header>
  <Name>Pokemon Mystery Dungeon: Destiny</Name>
  <Author>Pokemon Mystery Dungeon: Destiny</Author>
  <Description>Fangame Quest complet pour PMDO 0.8.12 structure sur l'architecture Halcyon / town02, avec fonds Jour &amp; Nuit separes, mer pixel-art generee et blason Oeuf Aile centre.</Description>
  <Namespace>halcyon</Namespace>
  <UUID>D571E9A0-4C8B-4F2D-9E61-8A3B5C7D0812</UUID>
  <Version>0.8.12</Version>
  <GameVersion>0.8.12.0</GameVersion>
  <ModType>Quest</ModType>
  <Relationships />
</Header>
"""

DESTINY_TITLE_ANIM_SERVICE_LUA = """--[[
  destiny_title_anim/init.lua
  Service persistant pour Pokemon Mystery Dungeon : Destiny (PMDO 0.8.12).

  Fonctionnalites :
  1) Fonds separes JOUR (`Title_Screen_Background_Jour.dir`) et NUIT (`Title_Screen_Background_Nuit.dir`)
     avec selection automatique selon l'heure locale (06h-19h = Jour, 19h-06h = Nuit) ou forcage manuel
     via `DestinyTitleAnim.ForceMode = 'jour' | 'nuit'`.
  2) Animation en direct des 24 poses sous `TopMenu` via `LowerSummaryMenus` + `MenuDirTex(TexType.BG)`.
  3) Helper `DestinyTitleAnim.PlayAnimeOpening(mode)` pour jouer en scene d'ouverture l'apparition
     unique du blason Oeuf Aile (`Destiny_Logo_Anime_Opening`) sur le fond Jour ou Nuit.
]]--
require 'origin.common'
require 'origin.services.baseservice'

local DestinyTitleAnim = Class('DestinyTitleAnim', BaseService)
DestinyTitleAnim.ForceMode = nil -- nil = auto Jour/Nuit selon l'heure locale, ou 'jour' / 'nuit'

function DestinyTitleAnim:GetActiveBGName()
  if self.ForceMode == 'jour' then
    return 'Title_Screen_Background_Jour'
  elseif self.ForceMode == 'nuit' then
    return 'Title_Screen_Background_Nuit'
  end
  local ok, hr = pcall(function() return tonumber(os.date('%H')) end)
  if ok and hr ~= nil and (hr < 6 or hr >= 19) then
    return 'Title_Screen_Background_Nuit'
  end
  return 'Title_Screen_Background_Jour'
end

function DestinyTitleAnim:initialize()
  BaseService.initialize(self)
  if PrintInfo then
    PrintInfo('[PMD:Destiny] Service destiny_title_anim (Jour & Nuit separes + Opening) initialise.')
  end
end

function DestinyTitleAnim:OnAddMenu(menu)
  if menu == nil then
    return
  end
  pcall(function()
    if menu.Label == RogueEssence.Menu.MenuLabel.TOP_MENU then
      local bg_name = self:GetActiveBGName()
      local bg_summary = RogueEssence.Menu.SummaryMenu(
        "DESTINY_TITLE_BG_SUMMARY",
        RogueElements.Rect(-16, -16, 352, 272)
      )
      local anim = RogueEssence.Content.AnimData(bg_name, 10)
      local dir_tex = RogueEssence.Menu.MenuDirTex(
        "DESTINY_TITLE_BG_TEX",
        RogueElements.Loc(16, 16),
        RogueEssence.Menu.MenuDirTex.TexType.BG,
        anim
      )
      bg_summary.Elements:Add(dir_tex)
      menu.LowerSummaryMenus:Insert(0, bg_summary)
    end
  end)
end

function DestinyTitleAnim:Subscribe(med)
  med:Subscribe("DestinyTitleAnim", EngineServiceEvents.AddMenu, function(_, args)
    if args ~= nil then
      self:OnAddMenu(args[0])
    end
  end)
end

function DestinyTitleAnim:UnSubscribe(med)
end

local instance = DestinyTitleAnim:new()
SCRIPT:AddService("DestinyTitleAnim", instance)
return instance
"""
