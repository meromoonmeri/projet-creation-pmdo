#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Moteur multicalque PMDO `0.8.12.0` pour l'écran-titre et le fangame
**Pokémon Mystery Dungeon : Destiny** (architecture unifiée *Halcyon* / *town02*).

Produits générés :
1. **Assets UI officiels de l'écran-titre (`Content/UI/`)** :
   - `Content/UI/Title.png` (`320 × 240` RGBA) : Logo style *Pokémon Super Mystery Dungeon*
     (`Pokémon` arqué jaune/bleu + soleil rayonnant doré + `Mystery Dungeon` dégradé cyan→lavande
     + blason métallique `DESTINY`), détouré `0 px` `#FF00FF` depuis `logo_pmd_destiny_magenta.png`.
   - `Logo_PMD_Destiny_HD.png` (`RGBA` haute définition détouré `0 px` `#FF00FF`).
   - `Content/UI/Enter.png` (`74 × 11` RGBA) : Invite pixel-art `PRESS ENTER` bordée marine/or.

2. **Fond animé de menu `.dir` séparé du logo (`Content/BG/Title_Screen_Background.dir`)** :
   - `320 × 240`, `24` poses en boucle parfaite (`12 ticks/pose` = cycle complet `4,8 s`),
     encodé au format binaire exact `RogueEssence.Content.DirSheet` (`<q png_len` + PNG RGBA
     `1920 × 960` `6 × 4` + `<iiii (320, 240, 0, 24)`), **100 % sans texte ni logo** (identique
     à la séparation `Title_Screen_Background.dir` / `Title.png` de *Halcyon* et *Abyss to Ascension*).
   - `Pose 0` (`(0, 0)`) = Keyframe **Crépuscule Doré & Corail** affichée par `TitleScene.Draw`
     avant appui sur Entrée, suivie du cycle complet **Crépuscule ──▶ Heure Bleue ──▶ Soir &
     Nuit Étoilée Scintillante (étoiles animées + étoile filante + reflets nocturnes sur la mer)
     ──▶ Retour crépusculaire sans couture**.

3. **Scène Ground & Studio 10 calques `DST1` (`pmd_destiny_menu_titre`, `768 × 576`, `< 24 000` tuiles/banque)** :
   - `00_ciel_crepuscule_soir` (`BG`, `24p`) : Voûte céleste du crépuscule doré au soir étoilé
   - `01_colonne_solaire_lunaire` (`BG`, `24p`) : Colonne lumineuse centrale (pilier solaire ──▶ rayon astral)
   - `02_etoiles_scintillantes` (`BG`, `24p`) : ~96 étoiles scintillantes à phases décalées + étoile filante
   - `03_mer_crepuscule_soir` (`BG`, `24p`) : Vaste océan en contrebas passant du saphir doré au bleu nuit
   - `04_reflets_mer_crepuscule_etoiles` (`BG`, `24p`) : Pont de reflets solaires/stellaires & éclats d'eau 1×
   - `05_nuages_horizon_lointains` (`BG`, `24p`) : Bancs de cumulus lointains sur la ligne d'horizon (`y=384`)
   - `06_nuages_cathedrale_gauche` (`BG`, `24p`) : Cumulus cathédrale gauche ré-éclairés crépuscule→nuit
   - `07_nuages_cathedrale_droite` (`BG`, `24p`) : Cumulus cathédrale droite ré-éclairés crépuscule→nuit
   - `08_franges_lumiere_et_brise` (`BG`, `24p`) : Franges dorées/lunaires des nuages & particules célestes
   - `09_logo_pmd_destiny_super` (`FG`, `1p`) : Logo *Pokémon Mystery Dungeon : Destiny* commutable

4. **Service Lua temps réel `destiny_title_anim` (`Data/Script/halcyon/services/destiny_title_anim/init.lua`)** :
   - Souscrit à `EngineServiceEvents.AddMenu` pour injecter sous `TopMenu` un `SummaryMenu` hors-cadre
     portant `MenuDirTex("DESTINY_BG_ANIM", Loc(16, 16), MenuDirTex.TexType.BG, AnimData("Title_Screen_Background", 12))`,
     animant les `24` poses en direct derrière le menu principal et ses sous-menus dans PMDO `0.8.12`.
"""
from __future__ import annotations

import io
import math
import struct
from functools import lru_cache
from pathlib import Path
from typing import Dict, List, Tuple

import numpy as np
from PIL import Image
from scipy import ndimage

from source.assembleur_bruts_unova_1x import quantize_non_magenta_mediancut
from source.moteur_cyclones_cylindriques_unova import decode_pmdo_tile, sanitize_rgba_binary

REPO_ROOT = Path(__file__).resolve().parent.parent
DESTINY_DIR = REPO_ROOT / "source" / "pmd_destiny_fangame_v1"
LOGO_RAW_PATH = DESTINY_DIR / "bruts" / "logo_pmd_destiny_magenta.png"
CLOUDS_RAW_PATH = DESTINY_DIR / "bruts" / "nuages_cathedrale_magenta.png"

W_CANON = 768
H_CANON = 576
HORIZON_Y = 384  # Multiple exact de 8 px : 48*8=384 (2/3 de 576) -> y=160 (20*8) en 320x240 !

W_MENU = 320
H_MENU = 240
HORIZON_MENU_Y = 160

N_POSES = 24
FRAME_TICKS_MENU = 12  # 12 ticks @ 60 FPS = 200 ms/pose -> 4,8 s par cycle complet

# Matrice de Bayer 8x8 normalisée [0..1) périodique modulo 8 px (garantit <= 50 tuiles uniques/pose pour le ciel !)
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


# ============================================================================
# 1. GARDE ANTI-MAGENTA & ENCODEUR BINAIRE `.dir` (`RogueEssence.Content.DirSheet`)
# ============================================================================

def clamp_bg_non_magenta(rgb: np.ndarray, max_rb_over_g: int = 28) -> np.ndarray:
    """Garantit `min(R, B) - G <= max_rb_over_g < 38` sur tous les calques de décor (0 px magenta)."""
    out = rgb.copy()
    r = out[:, :, 0].astype(np.int16)
    g = out[:, :, 1].astype(np.int16)
    b = out[:, :, 2].astype(np.int16)
    excess = np.minimum(r, b) - g - max_rb_over_g
    bad = excess > 0
    if np.any(bad):
        # Pousse légèrement le canal vert / réduit le rouge pour rester dans un indigo-violet naturel
        r_new = np.clip(r - ((excess + 1) // 2), 0, 255)
        g_new = np.clip(g + (excess // 2) + 1, 0, 255)
        out[:, :, 0] = np.where(bad, r_new, r).astype(np.uint8)
        out[:, :, 1] = np.where(bad, g_new, g).astype(np.uint8)
    return out


def encode_pmdo_dir_sheet(
    frames_320x240: List[Image.Image],
    out_dir_path: Path,
    cols: int = 6,
    rotate_type: int = 0,
) -> Dict[str, int]:
    """Encode une séquence d'images `320x240` au format exact `DirSheet.Save` de RogueEssence :
    `[int64 png_len][PNG atlas RGBA][int32 tileW][int32 tileH][int32 rotateType][int32 totalFrames]`."""
    assert len(frames_320x240) >= 1
    tw, th = frames_320x240[0].size
    total = len(frames_320x240)
    cols_eff = min(cols, total)
    rows_eff = int(math.ceil(total / float(cols_eff)))
    atlas = Image.new("RGBA", (cols_eff * tw, rows_eff * th), (0, 0, 0, 0))
    for idx, im in enumerate(frames_320x240):
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
# 2. DÉTOURAGE DU LOGO *POKÉMON SUPER MYSTERY DUNGEON : DESTINY* (`0 px` `#FF00FF`)
# ============================================================================

@lru_cache(maxsize=2)
def extract_destiny_logo_hd() -> Image.Image:
    """Détoure `logo_pmd_destiny_magenta.png` par inondation depuis le bord `#FF00FF` :
    préserve `100 %` du dégradé cyan→lavande intérieur de `Mystery Dungeon` tout en éliminant
    `100 %` du halo magenta externe (`0 px` néon `#FF00FF`)."""
    raw = np.asarray(Image.open(LOGO_RAW_PATH).convert("RGB"), dtype=np.uint8)
    h, w = raw.shape[:2]
    r = raw[:, :, 0].astype(np.int16)
    g = raw[:, :, 1].astype(np.int16)
    b = raw[:, :, 2].astype(np.int16)

    is_mag_key = (r >= 200) & (g <= 62) & (b >= 200) & ((np.minimum(r, b) - g) >= 145)
    lbl, n_comp = ndimage.label(is_mag_key)
    border_ids = set(
        np.unique(np.concatenate([lbl[0, :], lbl[-1, :], lbl[:, 0], lbl[:, -1]]))
    ) - {0}
    bg_mask = np.isin(lbl, list(border_ids))

    # Trous fermés purement `#FF00FF` éventuels entre les pointes du soleil et les lettres
    for cid in range(1, n_comp + 1):
        if cid in border_ids:
            continue
        comp = lbl == cid
        if np.median(r[comp]) > 244 and np.median(g[comp]) < 16 and np.median(b[comp]) > 244:
            bg_mask |= comp

    fg_mask = ~bg_mask
    dist1 = ndimage.distance_transform_edt(fg_mask)
    # Érode le liseré d'anti-aliasing 1 px purement magenta sur la frontière externe
    outer_spill = fg_mask & (dist1 <= 1.8) & ((np.minimum(r, b) - g) >= 82)
    fg_mask = fg_mask & (~outer_spill)

    # Supprime aussi tout pixel résiduel à vert très bas et fort excès R/B (ex: les 14 px de frange)
    residual_neon = fg_mask & (g <= 64) & ((np.minimum(r, b) - g) >= 66)
    fg_mask = fg_mask & (~residual_neon)

    dist2 = ndimage.distance_transform_edt(fg_mask)
    fringe = fg_mask & (dist2 <= 3.2) & ((np.minimum(r, b) - g) >= 34)
    clean_donors = fg_mask & (~fringe)
    _, nearest = ndimage.distance_transform_edt(~clean_donors, return_indices=True)

    rgb_clean = raw.copy()
    rgb_clean[fringe] = raw[nearest[0][fringe], nearest[1][fringe]]

    ys, xs = np.where(fg_mask)
    y0, y1 = int(ys.min()), int(ys.max()) + 1
    x0, x1 = int(xs.min()), int(xs.max()) + 1

    out = np.zeros((y1 - y0, x1 - x0, 4), dtype=np.uint8)
    sub_fg = fg_mask[y0:y1, x0:x1]
    out[sub_fg, :3] = rgb_clean[y0:y1, x0:x1][sub_fg]
    out[sub_fg, 3] = 255
    return Image.fromarray(out, mode="RGBA")


def _scale_cutout_clean(
    cutout_rgba: Image.Image,
    target_w: int,
    target_h: int,
    binary_alpha: bool = True,
    clamp_ground_magenta: bool = False,
) -> Image.Image:
    """Redimensionne un cutout RGBA en dilatant ses couleurs vers l'extérieur avant LANCZOS
    afin d'éviter tout liseré sombre ou magenta sur les contours."""
    arr = np.asarray(cutout_rgba.convert("RGBA"), dtype=np.uint8)
    fg = arr[:, :, 3] >= 128
    _, nearest = ndimage.distance_transform_edt(~fg, return_indices=True)
    rgb_dilated = arr[:, :, :3].copy()
    rgb_dilated[~fg] = arr[:, :, :3][nearest[0][~fg], nearest[1][~fg]]

    rgb_scaled = np.asarray(
        Image.fromarray(rgb_dilated, mode="RGB").resize((target_w, target_h), Image.Resampling.LANCZOS),
        dtype=np.uint8,
    )
    a_scaled = np.asarray(
        Image.fromarray(arr[:, :, 3], mode="L").resize((target_w, target_h), Image.Resampling.LANCZOS),
        dtype=np.uint8,
    )

    # Élimine tout pixel néon résiduel (G bas + R/B élevés)
    r = rgb_scaled[:, :, 0].astype(np.int16)
    g = rgb_scaled[:, :, 1].astype(np.int16)
    b = rgb_scaled[:, :, 2].astype(np.int16)
    neon = (g <= 68) & ((np.minimum(r, b) - g) >= 65)
    if np.any(neon):
        rgb_scaled[neon, 1] = np.clip(np.minimum(r[neon], b[neon]) - 40, 0, 255).astype(np.uint8)

    if clamp_ground_magenta:
        # Pour le calque 09 Ground `.tile`, adoucit la lavande vers min(R,B)-G <= 34 tout en gardant la teinte lilas
        rgb_scaled = clamp_bg_non_magenta(rgb_scaled, max_rb_over_g=34)

    out = np.zeros((target_h, target_w, 4), dtype=np.uint8)
    if binary_alpha:
        mask = a_scaled >= 120
        out[mask, :3] = rgb_scaled[mask]
        out[mask, 3] = 255
    else:
        mask = a_scaled >= 18
        out[mask, :3] = rgb_scaled[mask]
        out[mask, 3] = a_scaled[mask]
    return Image.fromarray(out, mode="RGBA")


def build_title_ui_png_320x240() -> Image.Image:
    """Construit `Content/UI/Title.png` (`320 × 240` RGBA) pour `TitleScene.Draw`."""
    hd = extract_destiny_logo_hd()
    # Sur 320x240, largeur 286 px -> hauteur proportionnelle ~157 px, placé à y=6..163 (au-dessus de Enter.png à y=180)
    logo_w = 286
    logo_h = int(round(logo_w * hd.height / float(hd.width)))
    scaled = _scale_cutout_clean(hd, logo_w, logo_h, binary_alpha=False, clamp_ground_magenta=False)
    canvas = Image.new("RGBA", (W_MENU, H_MENU), (0, 0, 0, 0))
    ox = (W_MENU - logo_w) // 2
    oy = 6
    canvas.paste(scaled, (ox, oy), scaled)
    return canvas


def build_logo_ground_layer_768x576() -> Image.Image:
    """Construit le calque `09_logo_pmd_destiny_super` (`768 × 576`, alpha binaire `{0,255}`, `<= 96` couleurs)."""
    hd = extract_destiny_logo_hd()
    logo_w = 664
    logo_h = int(round(logo_w * hd.height / float(hd.width)))
    scaled = _scale_cutout_clean(hd, logo_w, logo_h, binary_alpha=True, clamp_ground_magenta=True)
    canvas = Image.new("RGBA", (W_CANON, H_CANON), (0, 0, 0, 0))
    ox = (W_CANON - logo_w) // 2
    oy = 16
    canvas.paste(scaled, (ox, oy), scaled)

    arr = np.asarray(canvas, dtype=np.uint8)
    mask = arr[:, :, 3] == 255
    # Dilate les couleurs du logo dans la zone transparente avant FASTOCTREE (zéro pixel #FF00FF factice !)
    _, nearest = ndimage.distance_transform_edt(~mask, return_indices=True)
    rgb_solid = arr[:, :, :3].copy()
    rgb_solid[~mask] = arr[:, :, :3][nearest[0][~mask], nearest[1][~mask]]
    q_im = Image.fromarray(rgb_solid, mode="RGB").quantize(colors=84, method=Image.Quantize.FASTOCTREE).convert("RGB")
    q_rgb = clamp_bg_non_magenta(np.asarray(q_im, dtype=np.uint8), max_rb_over_g=34)
    out = np.zeros((H_CANON, W_CANON, 4), dtype=np.uint8)
    out[mask, :3] = q_rgb[mask]
    out[mask, 3] = 255
    return Image.fromarray(sanitize_rgba_binary(out), mode="RGBA")


def build_enter_ui_png_74x11() -> Image.Image:
    """Construit `Content/UI/Enter.png` (`74 × 11` RGBA) pixel-art `PRESS ENTER` doré-ivoire bordé nuit."""
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
    arr[outline] = (14, 22, 54, 235)
    for y in range(2, 9):
        t = (y - 2) / 6.0
        col = (
            int(round(255 - 12 * t)),
            int(round(248 - 44 * t)),
            int(round(224 - 92 * t)),
            255,
        )
        row_m = mask_fg[y]
        arr[y, row_m] = col
    return Image.fromarray(arr, mode="RGBA")


# ============================================================================
# 3. PRÉPARATION DES NUAGES CATHÉDRALE INDEXÉS (`nuages_cathedrale_magenta.png`)
# ============================================================================

@lru_cache(maxsize=2)
def _prepare_cloud_masks_and_shades_768x576() -> Dict[str, np.ndarray]:
    """Aligne `nuages_cathedrale_magenta.png` pour que sa ligne d'horizon plate tombe pile sur
    `y = HORIZON_Y = 384` (`48 × 8` en `768×576`, soit `y = 160 = 20 × 8` en `320×240`),
    et indexe les nuages en `6` bandes cel-shadées pixel-art nettes."""
    raw = np.asarray(Image.open(CLOUDS_RAW_PATH).convert("RGB"), dtype=np.uint8)
    rh, rw = raw.shape[:2]
    r0 = raw[:, :, 0].astype(np.int16)
    g0 = raw[:, :, 1].astype(np.int16)
    b0 = raw[:, :, 2].astype(np.int16)
    mag0 = (r0 >= 205) & (g0 <= 62) & (b0 >= 205) & ((np.minimum(r0, b0) - g0) >= 135)

    # Ligne d'horizon native (~629 sur 896) -> redimensionne la partie ciel [0:629] vers [0:384] en NEAREST !
    row_mag = mag0.mean(axis=1)
    sea_rows = np.where(row_mag > 0.995)[0]
    raw_horizon = int(sea_rows[0]) if len(sea_rows) > 0 else int(round(rh * 0.702))

    # Nettoie la frange magenta sur la résolution native avant redimensionnement NEAREST
    fg0 = ~mag0
    dist0 = ndimage.distance_transform_edt(fg0)
    halo0 = fg0 & (dist0 <= 1.5) & ((np.minimum(r0, b0) - g0) >= 65)
    fg0 = fg0 & (~halo0)
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
    # Séparation propre en 3 calques de nuages pour l'inspecteur Studio et le budget < 24 000 tuiles :
    # - 05 : Bancs de nuages bas d'horizon (bande centrale basse + liseré d'horizon y >= 332)
    # - 06 : Cumulus cathédrale gauche (x < 384 hors horizon bas)
    # - 07 : Cumulus cathédrale droite (x >= 384 hors horizon bas)
    horizon_band = fg_full & (
        (yy >= 344) | ((yy >= 312) & (xx >= 216) & (xx < 552) & (shades_full >= 2))
    )
    left_cathedral = fg_full & (~horizon_band) & (xx < (W_CANON // 2))
    right_cathedral = fg_full & (~horizon_band) & (xx >= (W_CANON // 2))

    # Frange interne face à la colonne lumineuse centrale (pour le calque 08 d'éclat doré / lunaire)
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


# ============================================================================
# 4. COURBES D'ÉCLAIRAGE CRÉPUSCULE ──▶ HEURE BLEUE ──▶ SOIR & NUIT ÉTOILÉE
# ============================================================================

def _cycle_weights(pose_idx: int) -> Tuple[float, float, float, int]:
    """Calcule pour la pose `pose_idx in 0..23` :
    - `night_t in [0..1]` : `0.0` au Crépuscule Doré (`pose 0`), `1.0` au cœur de la Nuit Étoilée (`pose 12`),
      quantifié sur `13` paliers symétriques pour les nuages tout en gardant un cycle périodique parfait.
    - `twilight_t` : pic à l'Heure Bleue / Crépuscule avancé (`poses 5..7` et `17..19`).
    - `star_vis in [0..1]` : visibilité des étoiles (absentes au plein couchant doré `pose 0`, apparaissent dès
      le crépuscule `pose 3`, éclat maximal dans le soir et la nuit `poses 7..17`, s'estompent vers `pose 22`).
    - `light_step in 0..12` : index symétrique `min(f, 24 - f)` garantissant `<= 13` états de palette sur les nuages.
    """
    light_step = min(pose_idx, N_POSES - pose_idx)  # 0..12
    u = light_step / 12.0  # 0.0 (Crépuscule Doré) -> 1.0 (Minuit Étoilé)
    # Courbe en cloche lisse : crépuscule généreux, transition riche, plateau nocturne étoilé
    night_t = 0.5 - 0.5 * math.cos(math.pi * u)
    twilight_t = math.sin(math.pi * u) ** 1.35
    star_vis = float(np.clip((night_t - 0.14) / 0.52, 0.0, 1.0))
    return night_t, twilight_t, star_vis, light_step


def _lerp_rgb(
    c_dusk: Tuple[int, int, int],
    c_twilight: Tuple[int, int, int],
    c_night: Tuple[int, int, int],
    u: float,
) -> Tuple[float, float, float]:
    """Interpolation 3-clés lisse : `u=0` (Crépuscule Doré) -> `u=0.45` (Heure Bleue) -> `u=1.0` (Nuit Étoilée)."""
    if u <= 0.45:
        t = u / 0.45
        t_s = t * t * (3.0 - 2.0 * t)
        return (
            c_dusk[0] + (c_twilight[0] - c_dusk[0]) * t_s,
            c_dusk[1] + (c_twilight[1] - c_dusk[1]) * t_s,
            c_dusk[2] + (c_twilight[2] - c_dusk[2]) * t_s,
        )
    t = (u - 0.45) / 0.55
    t_s = t * t * (3.0 - 2.0 * t)
    return (
        c_twilight[0] + (c_night[0] - c_twilight[0]) * t_s,
        c_twilight[1] + (c_night[1] - c_twilight[1]) * t_s,
        c_twilight[2] + (c_night[2] - c_twilight[2]) * t_s,
    )


def _cloud_palette_for_step(light_step: int) -> np.ndarray:
    """Retourne la table `(6, 3)` uint8 des 6 bandes cel-shadées de nuages pour `light_step in 0..12`."""
    u = light_step / 12.0
    # 6 rampes pixel-art : (Crépuscule Doré, Heure Bleue / Soir Naissant, Nuit Étoilée Lunaire)
    ramps = [
        ((56, 78, 138), (34, 48, 98), (18, 28, 66)),       # 0 : ombre profonde externe
        ((90, 110, 168), (54, 72, 128), (30, 46, 94)),     # 1 : ombre moyenne bleutée
        ((156, 146, 174), (96, 108, 158), (52, 76, 132)),  # 2 : brume intermédiaire
        ((234, 168, 134), (156, 142, 164), (88, 120, 178)),# 3 : revers corail -> lilas -> pervenche astral
        ((252, 212, 148), (206, 188, 196), (144, 176, 224)),# 4 : crête dorée -> nacre du soir -> argent
        ((255, 244, 202), (234, 228, 236), (204, 226, 250)),# 5 : liseré incandescent -> clair d'étoiles
    ]
    pal = np.zeros((6, 3), dtype=np.uint8)
    for idx, (cd, ct, cn) in enumerate(ramps):
        rf, gf, bf = _lerp_rgb(cd, ct, cn, u)
        pal[idx] = (int(round(rf)), int(round(gf)), int(round(bf)))
    pal_img = clamp_bg_non_magenta(pal.reshape(1, 6, 3), max_rb_over_g=26).reshape(6, 3)
    return pal_img


# ============================================================================
# 5. GÉNÉRATION DES 10 CALQUES MULTICALQUES (`768 × 576`, `24` POSES)
# ============================================================================

def _build_sky_layer_24() -> List[Image.Image]:
    """`00_ciel_crepuscule_soir` : Dégradé céleste 5-stops avec tramage Bayer `8×8` périodique en X
    (`<= 1 200` tuiles `8×8` uniques sur l'ensemble des 24 poses !)."""
    # 5 stops verticaux : y_norm = [0.00 (zénith), 0.34, 0.64, 0.86, 1.00 (horizon y=384)]
    stops_y = np.array([0.0, 0.34, 0.64, 0.86, 1.0], dtype=np.float32)
    dusk_stops = [
        (32, 66, 146),    # Zénith bleu cobalt royal
        (68, 114, 190),   # Ciel moyen céruléen lumineux
        (164, 144, 172),  # Transition pêche-lavande douce
        (238, 152, 116),  # Bande corail-ambre du couchant
        (254, 214, 134),  # Horizon incandescent doré
    ]
    twilight_stops = [
        (16, 26, 74),     # Zénith bleu-nuit naissant
        (34, 52, 114),    # Bleu crépusculaire profond
        (74, 78, 136),    # Violet-ardoise de l'heure bleue
        (168, 104, 102),  # Braise cuivrée crépusculaire
        (218, 148, 112),  # Lueur ambrée tardive sur la mer
    ]
    night_stops = [
        (8, 14, 42),      # Zénith cosmos nocturne
        (14, 24, 64),     # Voûte étoilée saphir sombre
        (22, 38, 88),     # Ciel moyen nocturne
        (32, 54, 112),    # Brume marine étoilée
        (46, 74, 136),    # Horizon clair-de-lune sur l'océan
    ]

    bayer_tile = np.tile(BAYER_8X8, (H_CANON // 8, W_CANON // 8))
    y_norm = np.linspace(0.0, 1.0, HORIZON_Y, dtype=np.float32)[:, None]

    # Cache par light_step (0..12) pour symétrie parfaite et économie de tuiles
    step_cache: Dict[int, Image.Image] = {}
    frames: List[Image.Image] = []
    for f in range(N_POSES):
        _nt, _tw, _sv, step = _cycle_weights(f)
        if step not in step_cache:
            u = step / 12.0
            cur_stops = np.array(
                [_lerp_rgb(dusk_stops[i], twilight_stops[i], night_stops[i], u) for i in range(5)],
                dtype=np.float32,
            )
            sky_f = np.zeros((HORIZON_Y, W_CANON, 3), dtype=np.float32)
            for c in range(3):
                sky_f[:, :, c] = np.interp(y_norm[:, 0], stops_y, cur_stops[:, c])[:, None]

            # Quantification pixel-art par pas de 4 avec tramage Bayer 8x8 périodique en X
            sky_q = np.clip(
                np.floor(sky_f / 4.0 + bayer_tile[:HORIZON_Y, :, None]) * 4.0, 0.0, 255.0
            ).astype(np.uint8)
            sky_q = clamp_bg_non_magenta(sky_q, max_rb_over_g=24)

            # Fond marin de sécurité sous y >= 384 (recouvert par `03_mer_crepuscule_soir`, garantit 0 trou transparent)
            sea_base_rgb = _lerp_rgb((22, 72, 132), (14, 42, 92), (8, 18, 48), u)
            full = np.zeros((H_CANON, W_CANON, 4), dtype=np.uint8)
            full[:HORIZON_Y, :, :3] = sky_q
            full[HORIZON_Y:, :, 0] = int(round(sea_base_rgb[0]))
            full[HORIZON_Y:, :, 1] = int(round(sea_base_rgb[1]))
            full[HORIZON_Y:, :, 2] = int(round(sea_base_rgb[2]))
            full[:, :, 3] = 255
            step_cache[step] = Image.fromarray(full, mode="RGBA")
        frames.append(step_cache[step])
    return frames


def _build_celestial_pillar_24(sky_opening: np.ndarray) -> List[Image.Image]:
    """`01_colonne_solaire_lunaire` : Colonne lumineuse verticale au centre de l'horizon (`x = 384`),
    fidèle au faisceau central de `image-2.png` (or solaire au crépuscule ──▶ rayon astral argenté la nuit)."""
    yy, xx = np.mgrid[0:HORIZON_Y, 0:W_CANON]
    dx = np.abs(xx.astype(np.float32) - (W_CANON * 0.5))
    vy = (HORIZON_Y - yy).astype(np.float32) / float(HORIZON_Y)  # 0 à l'horizon -> 1 au zénith

    # Largeur du faisceau plus ample près de l'horizon + cœur vertical étroit (comme image-2.png)
    core_w = 18.0 + 26.0 * (1.0 - vy) ** 1.6
    halo_w = 56.0 + 78.0 * (1.0 - vy) ** 2.0
    intensity = (
        0.68 * np.exp(-((dx / core_w) ** 2)) * ((1.0 - vy * 0.62) ** 1.2)
        + 0.42 * np.exp(-((dx / halo_w) ** 2)) * ((1.0 - vy) ** 2.1)
    )
    # Quantification spatiale sur blocs 2x2 + Bayer 8x8 pour limiter les tuiles uniques
    bayer_sky = np.tile(BAYER_8X8, (HORIZON_Y // 8, W_CANON // 8))

    step_cache: Dict[int, Image.Image] = {}
    frames: List[Image.Image] = []
    for f in range(N_POSES):
        _nt, _tw, _sv, step = _cycle_weights(f)
        if step not in step_cache:
            u = step / 12.0
            # Intensité un peu plus douce la nuit (rayon astral subtil) et éclatante au crépuscule
            amp = 1.0 - 0.32 * u
            lvl = np.floor(intensity * amp * 5.0 + bayer_sky * 0.65).astype(np.int32)
            active = (lvl >= 1) & sky_opening[:HORIZON_Y]

            c_outer = _lerp_rgb((248, 178, 118), (186, 134, 138), (58, 92, 154), u)
            c_mid = _lerp_rgb((254, 218, 148), (218, 176, 168), (96, 142, 204), u)
            c_core = _lerp_rgb((255, 246, 206), (242, 224, 218), (158, 202, 244), u)

            arr = np.zeros((H_CANON, W_CANON, 4), dtype=np.uint8)
            rgb_s = np.zeros((HORIZON_Y, W_CANON, 3), dtype=np.uint8)
            for lv_min, col in ((1, c_outer), (2, c_mid), (3, c_core)):
                m = active & (lvl >= lv_min)
                rgb_s[m] = (int(round(col[0])), int(round(col[1])), int(round(col[2])))
            rgb_s = clamp_bg_non_magenta(rgb_s, max_rb_over_g=24)
            arr[:HORIZON_Y][active, :3] = rgb_s[active]
            arr[:HORIZON_Y][active, 3] = 255
            step_cache[step] = Image.fromarray(sanitize_rgba_binary(arr), mode="RGBA")
        frames.append(step_cache[step])
    return frames


def _draw_pixel_star(
    arr: np.ndarray,
    sx: int,
    sy: int,
    stage: int,
    core_col: Tuple[int, int, int],
    halo_col: Tuple[int, int, int],
) -> None:
    """Dessine une étoile pixel-art nette (alignée pour rester lisible en `768×576` ET en `320×240`) :
    - `stage == 0` : éteinte
    - `stage == 1` : point `2×2` doux (`halo_col`)
    - `stage == 2` : point `3×3` brillant (`core_col` + coins `halo_col`)
    - `stage == 3` : étoile en croix `5×5` lumineuse
    - `stage >= 4` : grande étoile diamant `7×7` scintillante (type *Étoile du Berger* / Sirius).
    """
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
    # stage >= 3 : croix brillante (lisible après réduction 2.4x vers 320x240)
    arm = 3 if stage == 3 else 5
    for d in range(-arm, arm + 1):
        c = core_col if abs(d) <= 1 else halo_col
        put(sx + d, sy, c)
        put(sx, sy + d, c)
    for dy in (-1, 0, 1):
        for dx in (-1, 0, 1):
            put(sx + dx, sy + dy, core_col)
    if stage >= 4:
        for dx, dy in ((-2, -2), (2, -2), (-2, 2), (2, 2)):
            put(sx + dx, sy + dy, halo_col)


def _build_twinkling_stars_24(sky_opening: np.ndarray) -> Tuple[List[Image.Image], List[Tuple[int, int, int, float]]]:
    """`02_etoiles_scintillantes` : ~96 étoiles pixel-art animées à phases indépendantes qui
    s'allument progressivement du crépuscule au soir, scintillent toute la nuit, avec une
    **étoile filante diagonale** traversant la voûte nocturne aux poses `11..15`."""
    rng = np.random.default_rng(20260812)
    dist_open = ndimage.distance_transform_edt(sky_opening[:HORIZON_Y])

    stars: List[Tuple[int, int, int, float, int, int]] = []
    # 1) L'Étoile du Berger (Vénus) : brille tôt dès le crépuscule au-dessus du faisceau central !
    stars.append((384, 76, 4, 0.0, 2, 0))
    # 2) Grande croix stellaire jumelle (Sirius & Véga) encadrant la cathédrale de nuages
    stars.append((314, 118, 4, 1.7, 2, 1))
    stars.append((458, 104, 4, 3.4, 2, 2))

    attempts = 0
    occupied = np.zeros((HORIZON_Y, W_CANON), dtype=bool)
    for sx0, sy0, *_ in stars:
        occupied[max(0, sy0 - 14) : min(HORIZON_Y, sy0 + 15), max(0, sx0 - 14) : min(W_CANON, sx0 + 15)] = True

    while len(stars) < 96 and attempts < 6000:
        attempts += 1
        sx = int(rng.integers(18, W_CANON - 18))
        # Plus dense dans la moitié haute de la voûte céleste (y = 14..324)
        sy = int(14 + (HORIZON_Y - 62) * (rng.random() ** 1.28))
        if dist_open[sy, sx] < 5.0 or occupied[sy, sx]:
            continue
        occupied[max(0, sy - 11) : min(HORIZON_Y, sy + 12), max(0, sx - 11) : min(W_CANON, sx + 12)] = True
        max_stage = int(rng.choice([2, 2, 3, 3, 4], p=[0.30, 0.25, 0.25, 0.12, 0.08]))
        phase = float(rng.uniform(0.0, 2.0 * math.pi))
        freq = int(rng.choice([1, 2, 3], p=[0.25, 0.55, 0.20]))  # nombre de scintillements par cycle de 24 poses
        tint = int(rng.choice([0, 1, 2], p=[0.50, 0.30, 0.20]))   # 0=blanc-diamant, 1=bleu-saphir, 2=or-pâle
        stars.append((sx, sy, max_stage, phase, freq, tint))

    tints_core = [
        (248, 252, 255),  # Diamant polaire
        (214, 238, 255),  # Saphir céleste
        (255, 244, 206),  # Or stellaire
    ]
    tints_halo = [
        (132, 176, 236),
        (98, 148, 224),
        (196, 182, 148),
    ]

    frames: List[Image.Image] = []
    for f in range(N_POSES):
        night_t, _tw, star_vis, _step = _cycle_weights(f)
        arr = np.zeros((H_CANON, W_CANON, 4), dtype=np.uint8)

        for idx, (sx, sy, max_st, ph, freq, tint_id) in enumerate(stars):
            # L'Étoile du Berger (idx == 0) apparaît plus tôt dans le crépuscule
            vis = float(np.clip((night_t - 0.06) / 0.35, 0.0, 1.0)) if idx == 0 else star_vis
            # Les étoiles basses près de l'horizon n'apparaissent qu'une fois la nuit bien tombée
            alt_factor = 1.0 - 0.45 * (sy / float(HORIZON_Y))
            eff_vis = vis * alt_factor
            if eff_vis <= 0.08:
                continue

            twinkle = 0.5 + 0.5 * math.sin(2.0 * math.pi * freq * (f / float(N_POSES)) + ph)
            st = int(round(eff_vis * (0.45 + 0.55 * twinkle) * max_st))
            if idx == 0 and vis > 0.35:
                st = max(st, 2)
            if st >= 1:
                _draw_pixel_star(arr, sx, sy, min(st, max_st), tints_core[tint_id], tints_halo[tint_id])

        # Étoile filante poétique traversant l'ouverture céleste au cœur de la nuit (poses 11..15)
        if 11 <= f <= 15:
            prog = (f - 11) / 4.0
            hx = int(round(472 - 148 * prog))
            hy = int(round(66 + 96 * prog))
            for tail in range(0, 26):
                tx = hx + int(round(tail * 1.45))
                ty = hy - int(round(tail * 0.95))
                if 0 <= tx < W_CANON and 0 <= ty < HORIZON_Y and sky_opening[ty, tx]:
                    col = (252, 254, 255) if tail < 5 else ((176, 218, 252) if tail < 14 else (92, 138, 208))
                    arr[ty, tx, :3] = col
                    arr[ty, tx, 3] = 255
                    if tail < 8 and ty + 1 < HORIZON_Y:
                        arr[ty + 1, tx, :3] = (176, 218, 252)
                        arr[ty + 1, tx, 3] = 255

        arr[:, :, :3] = clamp_bg_non_magenta(arr[:, :, :3], max_rb_over_g=24)
        frames.append(Image.fromarray(sanitize_rgba_binary(arr), mode="RGBA"))

    star_summary = [(s[0], s[1], s[2], s[3]) for s in stars]
    return frames, star_summary


def _build_sea_layer_24() -> List[Image.Image]:
    """`03_mer_crepuscule_soir` : Vaste océan en contrebas (`y = 384..575`) façon *Explorateurs du Ciel* /
    `image-2.png`, à crêtes de houle **purement horizontales** en perspective 3D (fines près de l'horizon,
    amples au premier plan), passant du turquoise-saphir crépusculaire au bleu nuit abyssal.
    Périodique modulo `64 px` (`8` tuiles) en `X` -> `<= 4 608` tuiles `8×8` uniques sur 24 poses !"""
    sea_h = H_CANON - HORIZON_Y  # 192 px (24 rangées de tuiles)
    yy_s, xx_s = np.mgrid[0:sea_h, 0:W_CANON]
    z = yy_s.astype(np.float32) / float(sea_h - 1)
    bayer_sea = np.tile(BAYER_8X8, (sea_h // 8, W_CANON // 8))

    # Couleurs de mer (Horizon, Milieu, Premier plan, Crête d'onde claire, Creux d'onde sombre)
    sea_dusk = (
        (52, 128, 186),  # Horizon marin baigné de ciel doré-azur
        (28, 90, 152),   # Mer moyenne saphir-turquoise
        (16, 56, 110),   # Premier plan marin profond
        (88, 158, 208),  # Fine crête horizontale éclairée
        (18, 66, 122),   # Sillon d'ombre sous la crête
    )
    sea_twilight = (
        (36, 72, 134),
        (20, 48, 102),
        (11, 28, 70),
        (64, 104, 162),
        (14, 34, 80),
    )
    sea_night = (
        (20, 40, 88),    # Horizon marin sous les étoiles
        (11, 24, 62),    # Mer nocturne saphir sombre
        (6, 14, 40),     # Abîme marin de premier plan
        (38, 68, 124),   # Fine ondulation argentée nocturne
        (7, 16, 46),     # Sillon nocturne
    )

    x_mod = (xx_s[0] % 64).astype(np.float32)
    kx64 = 2.0 * math.pi * x_mod / 64.0
    kx32 = 2.0 * math.pi * (xx_s[0] % 32).astype(np.float32) / 32.0

    n_waves = 18
    frames: List[Image.Image] = []
    for f in range(N_POSES):
        _nt, _tw, _sv, step = _cycle_weights(f)
        u = step / 12.0
        t_frac = f / float(N_POSES)

        c_hor = _lerp_rgb(sea_dusk[0], sea_twilight[0], sea_night[0], u)
        c_mid = _lerp_rgb(sea_dusk[1], sea_twilight[1], sea_night[1], u)
        c_fg = _lerp_rgb(sea_dusk[2], sea_twilight[2], sea_night[2], u)
        c_crest = _lerp_rgb(sea_dusk[3], sea_twilight[3], sea_night[3], u)
        c_trough = _lerp_rgb(sea_dusk[4], sea_twilight[4], sea_night[4], u)

        stops_z = np.array([0.0, 0.40, 1.0], dtype=np.float32)
        base_sea = np.zeros((sea_h, W_CANON, 3), dtype=np.float32)
        for ch in range(3):
            vals = np.array([c_hor[ch], c_mid[ch], c_fg[ch]], dtype=np.float32)
            base_sea[:, :, ch] = np.interp(z[:, 0], stops_z, vals)[:, None]

        # 18 lignes de houle PUREMENT HORIZONTALES qui avancent vers le spectateur en boucle parfaite :
        # quand f passe de 0 à 24, l'onde k rejoint exactement la position initiale de l'onde k+1 !
        for k in range(n_waves):
            uk = ((k + t_frac) / float(n_waves)) % 1.0
            zk = uk ** 1.68
            wy = int(round(3.0 + zk * (sea_h - 6.0)))
            if wy < 3 or wy >= sea_h - 2:
                continue
            fade = math.sin(math.pi * uk) ** 0.75
            # Découpe horizontale organique en longs filets plats (périodique 64 px, zéro dent verticale !)
            ph_x = (k % 4) * (0.5 * math.pi) + 2.0 * math.pi * t_frac * (1 if k % 2 == 0 else -1)
            horiz_pat = 0.62 * np.sin(kx64 + ph_x) + 0.38 * np.cos(kx32 - ph_x * 0.5)
            seg_mask = horiz_pat > (-0.12 + 0.25 * (1.0 - zk))
            thick = 1 if zk < 0.38 else (2 if zk < 0.78 else 3)

            for dy_w in range(thick):
                ry = wy + dy_w
                if 0 <= ry < sea_h:
                    w_blend = 0.52 * fade * (1.0 if dy_w == 0 else 0.55)
                    for ch in range(3):
                        row_v = base_sea[ry, :, ch]
                        base_sea[ry, :, ch] = np.where(
                            seg_mask,
                            row_v * (1.0 - w_blend) + c_crest[ch] * w_blend,
                            row_v,
                        )
            # Léger sillon sombre 1 px juste sous la crête au premier plan
            if zk >= 0.30 and wy + thick < sea_h:
                t_blend = 0.38 * fade
                for ch in range(3):
                    row_t = base_sea[wy + thick, :, ch]
                    base_sea[wy + thick, :, ch] = np.where(
                        seg_mask,
                        row_t * (1.0 - t_blend) + c_trough[ch] * t_blend,
                        row_t,
                    )

        # Fine ligne d'horizon lumineuse nette à y = HORIZON_Y (1..2 px)
        horizon_rim = _lerp_rgb((246, 204, 144), (168, 130, 138), (68, 106, 168), u)
        base_sea[0, :, :] = horizon_rim
        base_sea[1, :, :] = 0.50 * np.array(horizon_rim) + 0.50 * base_sea[1, :, :]

        sea_q = np.clip(np.floor(base_sea / 4.0 + bayer_sea[:, :, None]) * 4.0, 0.0, 255.0).astype(np.uint8)
        sea_q = clamp_bg_non_magenta(sea_q, max_rb_over_g=24)

        arr = np.zeros((H_CANON, W_CANON, 4), dtype=np.uint8)
        arr[HORIZON_Y:, :, :3] = sea_q
        arr[HORIZON_Y:, :, 3] = 255
        frames.append(Image.fromarray(sanitize_rgba_binary(arr), mode="RGBA"))
    return frames


def _draw_water_sparkle(
    sea_rgb: np.ndarray,
    sea_m: np.ndarray,
    sx: int,
    ry: int,
    stage: int,
    col_hi: Tuple[int, int, int],
    col_mid: Tuple[int, int, int],
) -> None:
    """Dessine un éclat de mer pixel-art horizontal façon *Explorateurs du Ciel* (zéro carré `24×24` !) :
    - `stage == 1` : tiret horizontal `3×1`
    - `stage == 2` : losange marin plat `5×3`
    - `stage >= 3` : croix d'écume scintillante horizontale `9×5`."""
    sh, sw = sea_m.shape

    def put_s(px: int, py: int, col: Tuple[int, int, int]) -> None:
        if 0 <= px < sw and 0 <= py < sh:
            sea_rgb[py, px] = col
            sea_m[py, px] = True

    if stage <= 0:
        return
    if stage == 1:
        for dx_s in (-1, 0, 1):
            put_s(sx + dx_s, ry, col_mid if dx_s != 0 else col_hi)
        return
    if stage == 2:
        for dx_s in (-2, -1, 0, 1, 2):
            put_s(sx + dx_s, ry, col_hi if abs(dx_s) <= 1 else col_mid)
        put_s(sx, ry - 1, col_mid)
        put_s(sx, ry + 1, col_mid)
        return
    for dx_s in range(-4, 5):
        put_s(sx + dx_s, ry, col_hi if abs(dx_s) <= 1 else col_mid)
    for dy_s in (-2, -1, 1, 2):
        put_s(sx, ry + dy_s, col_hi if abs(dy_s) == 1 else col_mid)


def _build_sea_reflections_24() -> List[Image.Image]:
    """`04_reflets_mer_crepuscule_etoiles` : Pont de lumière **100 % horizontal** en barres brisées
    dansant sur les vagues centrales (or & corail couchant ──▶ argent & reflets d'étoiles nocturnes)
    + scintillements marins pixel-art façon *Explorateurs du Ciel*."""
    sea_h = H_CANON - HORIZON_Y
    cx_mid = W_CANON // 2

    # 34 rangées perspectives de barres de reflet horizontales du ras de l'horizon jusqu'au bas
    refl_rows: List[Tuple[int, float, float, float]] = []
    rng_r = np.random.default_rng(40812)
    for idx_r in range(34):
        ur = (idx_r + 0.35) / 34.0
        zr = ur ** 1.48
        ry = int(round(1 + zr * (sea_h - 4)))
        ph1 = float(rng_r.uniform(0.0, 2.0 * math.pi))
        ph2 = float(rng_r.uniform(0.0, 2.0 * math.pi))
        refl_rows.append((ry, zr, ph1, ph2))

    # 32 scintillements d'eau répartis de part et d'autre du pont de lumière + reflets d'étoiles la nuit
    sparkle_sites: List[Tuple[int, int, float, int, bool]] = []
    for i in range(36):
        zr_s = ((i + 0.5) / 36.0) ** 1.25
        ry_s = int(round(6 + zr_s * (sea_h - 14)))
        # Plus concentrés vers le tiers central au crépuscule, plus larges sous les étoiles la nuit
        night_only = (i % 3 == 2)
        max_x_off = int(260 if night_only else (75 + 145 * zr_s))
        side = -1 if (i % 2 == 0) else 1
        sx_s = cx_mid + side * int(rng_r.integers(28, max(36, max_x_off)))
        sx_s = int(np.clip(sx_s, 36, W_CANON - 36))
        ph_s = float(rng_r.uniform(0.0, 2.0 * math.pi))
        freq_s = int(rng_r.choice([1, 2], p=[0.45, 0.55]))
        sparkle_sites.append((sx_s, ry_s, ph_s, freq_s, night_only))

    frames: List[Image.Image] = []
    for f in range(N_POSES):
        _nt, _tw, star_vis, step = _cycle_weights(f)
        u = step / 12.0
        t_anim = 2.0 * math.pi * f / float(N_POSES)

        arr = np.zeros((H_CANON, W_CANON, 4), dtype=np.uint8)
        sea_rgb = np.zeros((sea_h, W_CANON, 3), dtype=np.uint8)
        sea_m = np.zeros((sea_h, W_CANON), dtype=bool)

        col_outer = _lerp_rgb((236, 146, 102), (164, 118, 132), (52, 92, 160), u)
        col_mid = _lerp_rgb((254, 206, 132), (206, 172, 174), (108, 162, 226), u)
        col_core = _lerp_rgb((255, 246, 202), (240, 224, 222), (206, 234, 255), u)
        c_out_u8 = (int(round(col_outer[0])), int(round(col_outer[1])), int(round(col_outer[2])))
        c_mid_u8 = (int(round(col_mid[0])), int(round(col_mid[1])), int(round(col_mid[2])))
        c_cor_u8 = (int(round(col_core[0])), int(round(col_core[1])), int(round(col_core[2])))

        width_scale = 1.0 - 0.30 * u  # Colonne solaire ample au couchant -> fin sillage lunaire la nuit

        for idx_r, (ry, zr, ph1, ph2) in enumerate(refl_rows):
            if ry < 0 or ry >= sea_h:
                continue
            # Oscillation horizontale douce (±5 px, quantifiée à 2 px) et pulsation de largeur
            drift = int(round(2.5 * (0.25 + 0.75 * zr) * math.sin(t_anim + ph1))) * 2
            breath = 0.72 + 0.28 * math.sin(2.0 * t_anim + ph2)
            half_w = max(4, int(round((12.0 + 62.0 * (zr ** 0.88)) * width_scale * breath / 2.0)) * 2)
            thick = 1 if zr < 0.28 else (2 if zr < 0.72 else 3)

            cx_row = cx_mid + drift
            x0_out = max(0, cx_row - half_w)
            x1_out = min(W_CANON, cx_row + half_w)
            x0_mid = max(0, cx_row - int(half_w * 0.66))
            x1_mid = min(W_CANON, cx_row + int(half_w * 0.66))
            x0_cor = max(0, cx_row - max(2, int(half_w * 0.34)))
            x1_cor = min(W_CANON, cx_row + max(2, int(half_w * 0.34)))

            for dy_b in range(thick):
                yy_b = ry + dy_b
                if yy_b >= sea_h:
                    break
                sea_rgb[yy_b, x0_out:x1_out] = c_out_u8
                sea_rgb[yy_b, x0_mid:x1_mid] = c_mid_u8
                if dy_b == 0 or thick == 3:
                    sea_rgb[yy_b, x0_cor:x1_cor] = c_cor_u8
                sea_m[yy_b, x0_out:x1_out] = True

                # Petites coupures d'eau sombres asymétriques sur les bords du reflet pour un rendu organique
                if half_w >= 18:
                    gap_l = cx_row - int(half_w * 0.76)
                    gap_r = cx_row + int(half_w * 0.72)
                    gw = max(2, int(half_w * 0.12))
                    sea_m[yy_b, max(0, gap_l - gw) : min(W_CANON, gap_l + gw)] = False
                    sea_m[yy_b, max(0, gap_r - gw) : min(W_CANON, gap_r + gw)] = False

            # Éclats latéraux détachés de part et d'autre de la barre principale
            if idx_r % 2 == 0 and half_w >= 14:
                wing_off = half_w + 8 + int(12 * zr)
                wing_w = max(2, int(4 + 8 * zr))
                if math.sin(t_anim + ph2) > -0.2:
                    sea_rgb[ry, max(0, cx_row - wing_off - wing_w) : max(0, cx_row - wing_off)] = c_mid_u8
                    sea_m[ry, max(0, cx_row - wing_off - wing_w) : max(0, cx_row - wing_off)] = True
                if math.cos(t_anim + ph1) > -0.2:
                    sea_rgb[ry, min(W_CANON, cx_row + wing_off) : min(W_CANON, cx_row + wing_off + wing_w)] = c_mid_u8
                    sea_m[ry, min(W_CANON, cx_row + wing_off) : min(W_CANON, cx_row + wing_off + wing_w)] = True

        # Scintillements d'eau pixel-art (or couchant -> diamant étoilé la nuit)
        sp_hi = _lerp_rgb((255, 250, 216), (238, 232, 240), (226, 244, 255), u)
        sp_md = _lerp_rgb((248, 192, 122), (176, 162, 188), (104, 158, 226), u)
        sp_hi_u8 = (int(round(sp_hi[0])), int(round(sp_hi[1])), int(round(sp_hi[2])))
        sp_md_u8 = (int(round(sp_md[0])), int(round(sp_md[1])), int(round(sp_md[2])))

        for sx_s, ry_s, ph_s, freq_s, night_only in sparkle_sites:
            if night_only and star_vis < 0.25:
                continue
            twk = 0.5 + 0.5 * math.sin(freq_s * t_anim + ph_s)
            amp_vis = star_vis if night_only else 1.0
            val = twk * amp_vis
            st = 3 if val > 0.88 else (2 if val > 0.70 else (1 if val > 0.50 else 0))
            if st >= 1:
                _draw_water_sparkle(sea_rgb, sea_m, sx_s, ry_s, st, sp_hi_u8, sp_md_u8)

        sea_rgb = clamp_bg_non_magenta(sea_rgb, max_rb_over_g=24)
        arr[HORIZON_Y:][sea_m, :3] = sea_rgb[sea_m]
        arr[HORIZON_Y:][sea_m, 3] = 255
        frames.append(Image.fromarray(sanitize_rgba_binary(arr), mode="RGBA"))
    return frames


def _build_cloud_subset_24(mask: np.ndarray, shades: np.ndarray) -> List[Image.Image]:
    """Construit 24 poses ré-éclairées (`<= 13` états symétriques -> `< 14 000` tuiles uniques/banque)
    pour un sous-ensemble de nuages (`horizon`, `cathedrale_gauche`, `cathedrale_droite`)."""
    step_cache: Dict[int, Image.Image] = {}
    frames: List[Image.Image] = []
    for f in range(N_POSES):
        _nt, _tw, _sv, step = _cycle_weights(f)
        if step not in step_cache:
            pal = _cloud_palette_for_step(step)
            arr = np.zeros((H_CANON, W_CANON, 4), dtype=np.uint8)
            arr[mask, :3] = pal[shades[mask]]
            arr[mask, 3] = 255
            step_cache[step] = Image.fromarray(sanitize_rgba_binary(arr), mode="RGBA")
        frames.append(step_cache[step])
    return frames


def _build_rimlight_and_breeze_24(inner_rim: np.ndarray, sky_opening: np.ndarray) -> List[Image.Image]:
    """`08_franges_lumiere_et_brise` : Frange lumineuse sur la crête interne des nuages
    + particules célestes ascendantes animées (poussière d'or au crépuscule ──▶ poussière d'étoiles la nuit)."""
    rng = np.random.default_rng(770812)
    motes = [
        (
            int(rng.integers(96, W_CANON - 96)),
            int(rng.integers(64, HORIZON_Y - 24)),
            float(rng.uniform(0.0, 1.0)),
            int(rng.choice([2, 3])),
        )
        for _ in range(22)
    ]

    frames: List[Image.Image] = []
    for f in range(N_POSES):
        _nt, _tw, _sv, step = _cycle_weights(f)
        u = step / 12.0
        t_norm = f / float(N_POSES)
        pulse = 0.5 + 0.5 * math.sin(2.0 * math.pi * t_norm)

        arr = np.zeros((H_CANON, W_CANON, 4), dtype=np.uint8)
        rim_col = _lerp_rgb((255, 248, 214), (238, 224, 232), (214, 234, 255), u)
        arr[inner_rim, :3] = (int(round(rim_col[0])), int(round(rim_col[1])), int(round(rim_col[2])))
        arr[inner_rim, 3] = 255

        mote_core = _lerp_rgb((255, 244, 196), (234, 218, 228), (198, 232, 255), u)
        mote_halo = _lerp_rgb((244, 188, 124), (168, 152, 188), (102, 154, 224), u)
        mc = (int(round(mote_core[0])), int(round(mote_core[1])), int(round(mote_core[2])))
        mh = (int(round(mote_halo[0])), int(round(mote_halo[1])), int(round(mote_halo[2])))

        for mx0, my0, ph0, sz in motes:
            prog = (t_norm + ph0) % 1.0
            mx = int(round(mx0 + 10.0 * math.sin(2.0 * math.pi * prog + ph0 * 6.0)))
            # Trajectoire périodique fermée en boucle (aucun saut entre pose 23 et pose 0 !)
            my = int(round(my0 - 18.0 * math.sin(2.0 * math.pi * prog)))
            if 2 <= mx < W_CANON - 2 and 2 <= my < HORIZON_Y - 2 and sky_opening[my, mx]:
                arr[my, mx, :3] = mc
                arr[my, mx, 3] = 255
                if sz >= 3 or pulse > 0.5:
                    for dx_m, dy_m in ((-1, 0), (1, 0), (0, -1), (0, 1)):
                        arr[my + dy_m, mx + dx_m, :3] = mh
                        arr[my + dy_m, mx + dx_m, 3] = 255

        arr[:, :, :3] = clamp_bg_non_magenta(arr[:, :, :3], max_rb_over_g=24)
        frames.append(Image.fromarray(sanitize_rgba_binary(arr), mode="RGBA"))
    return frames


@lru_cache(maxsize=2)
def build_destiny_multilayer_scene_768x576() -> Dict[str, object]:
    """Assemble et met en cache les 10 calques `768 × 576` + la séquence composite sans logo."""
    cloud_data = _prepare_cloud_masks_and_shades_768x576()
    sky_opening = cloud_data["sky_opening"]
    shades = cloud_data["shades_full"]

    l00_sky = _build_sky_layer_24()
    l01_pillar = _build_celestial_pillar_24(sky_opening)
    l02_stars, star_summary = _build_twinkling_stars_24(sky_opening)
    l03_sea = _build_sea_layer_24()
    l04_refl = _build_sea_reflections_24()
    l05_hor_clouds = _build_cloud_subset_24(cloud_data["horizon_mask"], shades)
    l06_left_clouds = _build_cloud_subset_24(cloud_data["left_mask"], shades)
    l07_right_clouds = _build_cloud_subset_24(cloud_data["right_mask"], shades)
    l08_rim_breeze = _build_rimlight_and_breeze_24(cloud_data["inner_rim"], sky_opening)
    l09_logo = [build_logo_ground_layer_768x576()]

    bg_layers_24 = [
        l00_sky,
        l01_pillar,
        l02_stars,
        l03_sea,
        l04_refl,
        l05_hor_clouds,
        l06_left_clouds,
        l07_right_clouds,
        l08_rim_breeze,
    ]

    # Composite purement décor (calques 00..08 SANS logo) pour `Title_Screen_Background.dir` !
    bg_composites_768: List[Image.Image] = []
    bg_frames_320x240: List[Image.Image] = []
    for f in range(N_POSES):
        comp = Image.new("RGBA", (W_CANON, H_CANON), (0, 0, 0, 255))
        for lay in bg_layers_24:
            pose_im = lay[f % len(lay)]
            comp.alpha_composite(pose_im)
        bg_composites_768.append(comp)

        # Réduction pixel-art propre vers 320x240 (ratio exact 2.4x, horizon 384 -> 160 !)
        # On réduit le ciel/mer en BILINEAR doux puis on superpose les étoiles & nuages en NEAREST franc
        # pour conserver 100 % du piqué pixel-art des étoiles scintillantes et des crêtes de nuages !
        base_under = Image.new("RGBA", (W_CANON, H_CANON), (0, 0, 0, 255))
        base_under.alpha_composite(l00_sky[f])
        base_under.alpha_composite(l01_pillar[f])
        base_under.alpha_composite(l03_sea[f])
        under_320 = base_under.convert("RGB").resize((W_MENU, H_MENU), Image.Resampling.BILINEAR).convert("RGBA")

        for crisp_lay in (l02_stars[f], l04_refl[f], l05_hor_clouds[f], l06_left_clouds[f], l07_right_clouds[f], l08_rim_breeze[f]):
            crisp_320 = crisp_lay.resize((W_MENU, H_MENU), Image.Resampling.NEAREST)
            under_320.alpha_composite(crisp_320)

        arr320 = np.asarray(under_320.convert("RGB"), dtype=np.uint8)
        arr320 = clamp_bg_non_magenta(arr320, max_rb_over_g=26)
        rgba320 = np.dstack([arr320, np.full((H_MENU, W_MENU), 255, dtype=np.uint8)])
        bg_frames_320x240.append(Image.fromarray(rgba320, mode="RGBA"))

    return {
        "layers_768": [
            ("00_ciel_crepuscule_soir", "Voûte Céleste Animée (Crépuscule Doré ──▶ Heure Bleue ──▶ Nuit)", "BG", l00_sky, FRAME_TICKS_MENU),
            ("01_colonne_solaire_lunaire", "Colonne Lumineuse d'Horizon (Pilier Solaire ──▶ Rayon Astral)", "BG", l01_pillar, FRAME_TICKS_MENU),
            ("02_etoiles_scintillantes", "Voûte d'Étoiles Scintillantes & Étoile Filante Nocturne", "BG", l02_stars, FRAME_TICKS_MENU),
            ("03_mer_crepuscule_soir", "Vaste Mer en Contrebas (Saphir Crépusculaire ──▶ Abîme Nocturne)", "BG", l03_sea, FRAME_TICKS_MENU),
            ("04_reflets_mer_crepuscule_etoiles", "Pont de Reflets Solaires/Stellaires & Éclats d'Eau Metano 1×", "BG", l04_refl, FRAME_TICKS_MENU),
            ("05_nuages_horizon_lointains", "Bancs de Nuages Lointains sur l'Horizon Marin (y = 384)", "BG", l05_hor_clouds, FRAME_TICKS_MENU),
            ("06_nuages_cathedrale_gauche", "Cumulus Cathédrale Gauche (Couchant Doré ──▶ Clair d'Étoiles)", "BG", l06_left_clouds, FRAME_TICKS_MENU),
            ("07_nuages_cathedrale_droite", "Cumulus Cathédrale Droite (Couchant Doré ──▶ Clair d'Étoiles)", "BG", l07_right_clouds, FRAME_TICKS_MENU),
            ("08_franges_lumiere_et_brise", "Franges Lumineuses des Nuages & Brise Astrale Ascendante", "BG", l08_rim_breeze, FRAME_TICKS_MENU),
            ("09_logo_pmd_destiny_super", "Logo Officiel Pokémon Mystery Dungeon : Destiny (Style Super PMD, Top)", "Top", l09_logo, FRAME_TICKS_MENU),
        ],
        "bg_composites_768": bg_composites_768,
        "bg_frames_320x240": bg_frames_320x240,
        "star_count": len(star_summary),
    }


# ============================================================================
# 6. FICHIERS LUA & MÉTADONNÉES FANGAME `POKÉMON MYSTERY DUNGEON : DESTINY`
# ============================================================================

DESTINY_MOD_XML = """<?xml version="1.0" encoding="utf-8"?>
<Header>
  <Name>Pokemon Mystery Dungeon: Destiny</Name>
  <Author>Pokemon Mystery Dungeon: Destiny</Author>
  <Description>Fangame Quest complet pour PMDO 0.8.12 structure sur l'architecture Halcyon / town02, avec ecran-titre multicalque anime Crepuscule -&gt; Soir Etoile et 122 cartes additionnelles.</Description>
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

  Anime en boucle temps reel les 24 poses de Content/BG/Title_Screen_Background.dir
  (Crepuscule Dore -> Heure Bleue -> Soir & Nuit Etoilee Scintillante -> Retour)
  sous TopMenu et tous ses sous-menus via LowerSummaryMenus + MenuDirTex(TexType.BG).
]]--
require 'origin.common'
require 'origin.services.baseservice'

local DestinyTitleAnim = Class('DestinyTitleAnim', BaseService)

function DestinyTitleAnim:initialize()
  BaseService.initialize(self)
  if PrintInfo then
    PrintInfo('[PMD:Destiny] Service destiny_title_anim initialise (24p x 12t).')
  end
end

function DestinyTitleAnim:OnAddMenu(menu)
  if menu == nil then
    return
  end
  pcall(function()
    if menu.Label == RogueEssence.Menu.MenuLabel.TOP_MENU then
      -- Cadre hors-ecran (-16,-16,352,272) masquant la bordure MenuBG tout en dessinant (16,16)->(0,0) !
      local bg_summary = RogueEssence.Menu.SummaryMenu(
        "DESTINY_TITLE_BG_SUMMARY",
        RogueElements.Rect(-16, -16, 352, 272)
      )
      local anim = RogueEssence.Content.AnimData("Title_Screen_Background", 12)
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

SCRIPT:AddService("DestinyTitleAnim", DestinyTitleAnim:new())
return DestinyTitleAnim
"""
