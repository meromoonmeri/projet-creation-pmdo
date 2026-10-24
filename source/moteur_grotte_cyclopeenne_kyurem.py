#!/usr/bin/env python3
"""Moteur partagé multicalque PMDO `0.8.12.0` pour le duo **Unys · Kyurem (Grotte Cyclopéenne / Giant Chasm)** :

1. **`KYE1` (`kyurem_cratere_entree_v1`)** — *Cratère Boisé Gelé & Eau Metano Glacée (`0 %` ciel)* :
   - Rempart circulaire du cratère météoritique et corniches de glace vive jusqu'à `y = 0` (`0 px` de ciel),
   - Bouche caverneuse Nord sertie de cristaux de givre cyan et d'éclats cryo-ambrés de Kyurem,
   - Chenal glaciaire incurvé (`#FF00FF`) rempli d'**eau native *Metano Town* gelée**
     (`Metano_Town_River_Animation_1..4.tile` + `Metano_Town_River_Sparkles.tile` refroidies en palette
     glaciaire `GLACIAL_METANO_PAL`, `4 poses @ 10 ticks`), franchi Sud→Nord par un pont de pierre et glace,
   - Sapins enneigés façon *Frosty Forest* (`D10P01`), fleurs hivernales natives *Metano Town* givrées et
     chute de neige matérielle GBA `W03P03` (`1×`).

2. **`KYA1` (`kyurem_sanctuaire_glace_v1`)** — *Sanctuaire de Glace Noire, Douve Metano Gelée & Blizzard Cyclonique 360°* :
   - Arène octogonale-ovale **100 % simple et nue (`0` objet sur le sol de combat)** en pierre météoritique
     sombre et glace noire craquelée, reliée au Sud par un escalier-chaussée droit Sud→Nord,
   - **Douve annulaire intérieure (`#FF00FF` enclos)** remplie d'**eau native *Metano Town* gelée**
     (`4 poses @ 10 ticks`) cernée par une couronne météoritique hérissée de pitons de glace noire cyan,
   - **Blizzard Cyclonique Cylindrique 3D 360° (`Ère Glaciaire`, `#FF00FF` extérieur)** enveloppant le
     sanctuaire (`paroi arrière concave G→D` + `colonnes tangentielles` + `rubans cryo` + `lèvre avant Top D→G`
     + neige matérielle GBA `W03P03` `1×`, `24 poses @ 5 ticks`).

Contraintes strictes :
- Alpha strictement binaire `{0, 255}`,
- Zéro fuite `#FF00FF` (`min(R, B) - G < 34` garanti partout),
- Quantification `MEDIANCUT` `<= 92` couleurs (`dither=NONE`) sur les bruts,
- Toutes les banques `.tile` strictement `< 24 000` tuiles `8×8` uniques.
"""

from __future__ import annotations

import math
from functools import lru_cache
from pathlib import Path
from typing import Dict, List, Optional, Tuple

import numpy as np
from PIL import Image
from scipy import ndimage

from source.assembleur_bruts_unova_1x import quantize_non_magenta_mediancut
from source.moteur_cyclones_cylindriques_unova import (
    BAYER_4X4,
    N_POSES,
    decode_pmdo_tile,
    draw_pixel_bolt_rgba,
    palette_lookup_dithered,
    sanitize_rgba_binary,
)
from source.moteur_forets_pmd_red import (
    _downsample_non_mixing,
    _sanitize_rgb_no_magenta,
    extract_metano_water_and_flower_assets,
)
from source.moteur_gba_pmd_red_natif import (
    PURE_MAGENTA,
    build_gba_weather_overlay_frames,
    render_gba_native,
)

REPO_ROOT = Path(__file__).resolve().parent.parent
W_CANON = 768
H_CANON = 576
TILE_SIZE = 8

# Palette officielle de l'eau native Metano Town refroidie en Eau Métano Gelée (Grotte Cyclopéenne)
GLACIAL_METANO_PAL: Dict[str, Tuple[int, int, int]] = {
    "surface": (38, 102, 162),     # Surface Metano refroidie en bleu-ardoise glaciaire limpide
    "bande": (20, 56, 108),        # Crevasse sombre de berge Metano sous la glace
    "inter": (30, 82, 138),        # Onde intermédiaire froide Metano
    "accent": (68, 148, 208),      # Crête d'onde cyan glacé Metano
    "clair": (196, 240, 255),      # Liseré de frasil / givre de rive Metano
    "spark_mid": (118, 202, 244),  # Reflet cristallin intermédiaire Metano_Town_River_Sparkles
    "spark_hi": (238, 252, 255),   # Éclat diamant de glace Metano_Town_River_Sparkles
}


# ============================================================================
# 1. ASSEMBLAGE DES BRUTS `#FF00FF` (`KYE1` & `KYA1`) SELON `METHODE_MAGENTA`
# ============================================================================

def _clean_and_downsample_magenta_sheet(
    raw_sheet_path: Path,
    out_w: int = W_CANON,
    out_h: int = H_CANON,
) -> Tuple[np.ndarray, np.ndarray]:
    """Détoure la graine `#FF00FF` haute résolution, absorbe les franges roses/prunes et réduit
    sans aucun mélange entre `#FF00FF` et le décor adjacent."""
    rgb_hi = np.asarray(Image.open(raw_sheet_path).convert("RGB"), dtype=np.uint8)
    rf = rgb_hi[:, :, 0].astype(np.float32)
    gf = rgb_hi[:, :, 1].astype(np.float32)
    bf = rgb_hi[:, :, 2].astype(np.float32)

    core = (rf >= 218.0) & (gf <= 52.0) & (bf >= 215.0)
    lbl_c, _ = ndimage.label(core)
    sizes = np.bincount(lbl_c.ravel())
    keep_c = sizes >= 300
    keep_c[0] = False
    seed_mag = keep_c[lbl_c]

    near_mag = ndimage.binary_dilation(seed_mag, iterations=12)
    plum_rim = near_mag & (
        ((rf > gf + 22.0) & (bf > gf + 12.0))
        | ((rf >= 185.0) & (rf > gf + 35.0) & (bf >= 115.0))
        | ((rf >= 110.0) & (rf > gf + 45.0) & (bf >= 55.0) & (gf < 95.0))
    )
    solid_hi = ~(seed_mag | plum_rim)

    rgb_ds, solid_ds = _downsample_non_mixing(rgb_hi, solid_hi, out_w, out_h)

    for _ in range(3):
        mag_cur = ~solid_ds
        adj = ndimage.binary_dilation(mag_cur, iterations=1) & solid_ds
        r7 = rgb_ds[:, :, 0].astype(np.int16)
        g7 = rgb_ds[:, :, 1].astype(np.int16)
        b7 = rgb_ds[:, :, 2].astype(np.int16)
        fringe = adj & (
            ((r7 > g7 + 22) & (b7 > g7 + 14))
            | ((r7 >= 185) & (r7 > g7 + 35) & (b7 >= 115))
        )
        if not np.any(fringe):
            break
        solid_ds = solid_ds & (~fringe)

    rgb_ds = _sanitize_rgb_no_magenta(rgb_ds, solid_ds)
    return rgb_ds, solid_ds


def assemble_kyurem_cratere_entree_brut(map_dir: Path) -> Dict[str, Path]:
    """Assemble le brut quantifié `768 × 576` (`0 %` ciel, `<= 92` couleurs `MEDIANCUT`), la canopée `Top`
    des sapins enneigés et les références natives GBA `1×` (`D11P01`, `D10P01`) pour `KYE1`."""
    raw_sheet = map_dir / "bruts" / "decor_kyurem_cratere_glace_magenta.png"
    out_brut = map_dir / "bruts" / "base_kyurem_cratere_entree.png"
    out_canopy = map_dir / "bruts" / "canopee_arbres_top.png"
    ref_dir = map_dir / "references"
    out_ref_canon = ref_dir / "ref_canon_kyurem_cratere_entree.png"
    out_d10_ref = ref_dir / "d10p01_frosty_forest_entry_native.png"

    rgb_768, solid_768 = _clean_and_downsample_magenta_sheet(raw_sheet, W_CANON, H_CANON)
    yy, xx = np.mgrid[0:H_CANON, 0:W_CANON]

    # Garantie stricte 0 % ciel : toute la paroi Nord du cratère (y < 234) est 100 % roche/glace solide
    top_hole = (~solid_768) & (yy < 234)
    if np.any(top_hole):
        _, n_idx = ndimage.distance_transform_edt(~solid_768, return_indices=True)
        hy, hx = np.where(top_hole)
        rgb_768[hy, hx] = rgb_768[n_idx[0, hy, hx], n_idx[1, hy, hx]]
        solid_768[top_hole] = True

    quantized = quantize_non_magenta_mediancut(rgb_768, ~solid_768, n_colors=92)
    mag_final = (quantized[:, :, 0] == 255) & (quantized[:, :, 1] == 0) & (quantized[:, :, 2] == 255)
    solid_final = ~mag_final
    quantized[solid_final] = _sanitize_rgb_no_magenta(quantized, solid_final)[solid_final]
    quantized[mag_final] = PURE_MAGENTA

    # Extraction de la canopée supérieure des sapins enneigés (`DrawLayer.Top`) sur les flancs Ouest/Est/Sud
    r_q = quantized[:, :, 0].astype(np.int16)
    g_q = quantized[:, :, 1].astype(np.int16)
    b_q = quantized[:, :, 2].astype(np.int16)
    is_flat_snow = (r_q >= 236) & (g_q >= 236) & (b_q >= 246) & (np.abs(r_q - g_q) <= 8)
    is_dark_boulder = (r_q <= 105) & (g_q <= 115) & (b_q <= 135) & (np.abs(r_q - g_q) <= 18)
    tree_zone = (yy >= 286) & ((xx < 156) | (xx > W_CANON - 156) | ((yy >= 492) & (np.abs(xx - 384) > 84)))
    is_pine_crown = solid_final & tree_zone & (~is_flat_snow) & (~is_dark_boulder) & (b_q >= 145)

    below_non_pine = ndimage.binary_dilation(
        ~is_pine_crown,
        structure=np.array([[0, 1, 0], [0, 1, 0], [0, 0, 0]], dtype=bool),
        iterations=7,
    )
    canopy_top = ndimage.binary_opening(is_pine_crown & (~below_non_pine), iterations=1)
    canopy_rgba = np.zeros((H_CANON, W_CANON, 4), dtype=np.uint8)
    canopy_rgba[canopy_top, :3] = quantized[canopy_top]
    canopy_rgba[canopy_top, 3] = 255

    # Références natives GBA 1x + aperçu de référence composite avec l'eau Metano gelée
    ref_dir.mkdir(parents=True, exist_ok=True)
    if not out_d10_ref.is_file():
        d10_rgba, _, _ = render_gba_native("D10P01", phase=None, bpa_frame=0)
        Image.fromarray(d10_rgba[:, :, :3], mode="RGB").save(out_d10_ref)

    ref_preview = quantized.copy()
    ref_preview[mag_final] = GLACIAL_METANO_PAL["surface"]

    out_brut.parent.mkdir(parents=True, exist_ok=True)
    Image.fromarray(quantized, mode="RGB").save(out_brut)
    Image.fromarray(canopy_rgba, mode="RGBA").save(out_canopy)
    Image.fromarray(ref_preview, mode="RGB").save(out_ref_canon)
    return {
        "brut": out_brut,
        "canopy": out_canopy,
        "ref_canon": out_ref_canon,
        "ref_d10p01": out_d10_ref,
    }


def assemble_kyurem_sanctuaire_glace_brut(map_dir: Path) -> Dict[str, Path]:
    """Assemble le brut quantifié `768 × 576` (`<= 92` couleurs `MEDIANCUT`) de `KYA1` avec :
      - le vide extérieur `#FF00FF` (touchant les bords) pour le Blizzard Cyclonique 360°,
      - la douve annulaire intérieure `#FF00FF` (100 % enclose) pour l'Eau Métano Gelée,
      - l'arène centrale simple et nue de glace noire + couronne météoritique à pitons cyan."""
    raw_sheet = map_dir / "bruts" / "decor_kyurem_sanctuaire_glace_magenta.png"
    out_brut = map_dir / "bruts" / "base_kyurem_sanctuaire_glace.png"
    ref_dir = map_dir / "references"
    out_ref_canon = ref_dir / "ref_canon_kyurem_sanctuaire_glace.png"
    out_a03_ref = ref_dir / "a03p01_fugitives_snow_road_native.png"
    out_h24_ref = ref_dir / "h24p01_frigid_cavern_native.png"

    rgb_768, solid_768 = _clean_and_downsample_magenta_sheet(raw_sheet, W_CANON, H_CANON)

    # Nettoyer uniquement les micro-poussières isolées (< 64 px) sans combler la douve annulaire !
    lbl_s, n_s = ndimage.label(solid_768)
    if n_s > 1:
        sizes_s = np.bincount(lbl_s.ravel())
        keep_s = sizes_s >= 64
        keep_s[0] = False
        solid_768 = keep_s[lbl_s]

    quantized = quantize_non_magenta_mediancut(rgb_768, ~solid_768, n_colors=92)
    mag_final = (quantized[:, :, 0] == 255) & (quantized[:, :, 1] == 0) & (quantized[:, :, 2] == 255)
    solid_final = ~mag_final
    quantized[solid_final] = _sanitize_rgb_no_magenta(quantized, solid_final)[solid_final]
    quantized[mag_final] = PURE_MAGENTA

    # Séparer vide extérieur (touchant le bord) vs douve intérieure (enclose) pour la référence canonique
    outer_vortex, inner_moat = split_sanctuary_outer_vortex_and_inner_moat(mag_final)

    ref_dir.mkdir(parents=True, exist_ok=True)
    if not out_a03_ref.is_file():
        a03_rgba, _, _ = render_gba_native("A03P01", phase=None, bpa_frame=0)
        Image.fromarray(a03_rgba[:, :, :3], mode="RGB").save(out_a03_ref)
    if not out_h24_ref.is_file():
        h24_rgba, _, _ = render_gba_native("H24P01", phase=None, bpa_frame=0)
        Image.fromarray(h24_rgba[:, :, :3], mode="RGB").save(out_h24_ref)

    h24_rgb = np.asarray(Image.open(out_h24_ref).convert("RGB"), dtype=np.uint8)
    nh, nw = h24_rgb.shape[:2]
    h24_tiled = np.tile(h24_rgb, (H_CANON // nh + 2, W_CANON // nw + 2, 1))[:H_CANON, :W_CANON]

    ref_preview = quantized.copy()
    ref_preview[inner_moat] = GLACIAL_METANO_PAL["surface"]
    ref_preview[outer_vortex] = h24_tiled[outer_vortex]

    out_brut.parent.mkdir(parents=True, exist_ok=True)
    Image.fromarray(quantized, mode="RGB").save(out_brut)
    Image.fromarray(ref_preview, mode="RGB").save(out_ref_canon)
    return {
        "brut": out_brut,
        "ref_canon": out_ref_canon,
        "ref_a03p01": out_a03_ref,
        "ref_h24p01": out_h24_ref,
    }


def split_sanctuary_outer_vortex_and_inner_moat(mag_mask: np.ndarray) -> Tuple[np.ndarray, np.ndarray]:
    """Sépare topologiquement les zones `#FF00FF` de `KYA1` :
      - `outer_vortex` : composantes `#FF00FF` touchant le bord extérieur du canevas (Blizzard 360°),
      - `inner_moat`   : composantes `#FF00FF` encloses à l'intérieur du rempart météoritique (Eau Métano Gelée)."""
    lbl, n_comp = ndimage.label(mag_mask)
    h, w = mag_mask.shape
    outer_vortex = np.zeros_like(mag_mask, dtype=bool)
    inner_moat = np.zeros_like(mag_mask, dtype=bool)
    for cid in range(1, n_comp + 1):
        comp = lbl == cid
        if int(comp.sum()) == 0:
            continue
        ys, xs = np.where(comp)
        touches_border = (ys.min() == 0) or (ys.max() == h - 1) or (xs.min() == 0) or (xs.max() == w - 1)
        if touches_border:
            outer_vortex |= comp
        else:
            inner_moat |= comp
    return outer_vortex, inner_moat


# ============================================================================
# 2. EAU MÉTANO GELÉE AUTHENTIQUE (`Metano_Town_River_Animation_1..4` + `Sparkles`)
# ============================================================================

@lru_cache(maxsize=1)
def _load_glacial_metano_sparkle_and_wave_families() -> Dict[str, List[np.ndarray]]:
    """Extrait à l'échelle `1×` native les 3 familles officielles `4 × 10 ticks` de
    `Metano_Town_River_Sparkles.tile` (`A_16x24`, `B_24x16`, `C_16x32`) ainsi que les
    2 rubans d'onde pleine eau `8×32` de `Metano_Town_River_Animation_1..4.tile`,
    refroidis exactement dans la palette **Eau Métano Gelée** (`GLACIAL_METANO_PAL`)."""
    eau_dir = REPO_ROOT / "source" / "eau_metano" / "natifs"
    sp_sheet = np.asarray(decode_pmdo_tile(eau_dir / "Metano_Town_River_Sparkles.tile"), dtype=np.uint8)
    m_surf = np.array([131, 218, 230], dtype=np.int32)

    def _extract_cluster(cols: List[int], rows: List[int], step: int) -> List[np.ndarray]:
        seq: List[np.ndarray] = []
        ch, cw = len(rows) * 8, len(cols) * 8
        for k in range(4):
            raw = np.zeros((ch, cw, 4), dtype=np.uint8)
            for jr, r_idx in enumerate(rows):
                for ic, c_idx in enumerate(cols):
                    ty, tx = (r_idx + step * k) * 8, c_idx * 8
                    raw[jr * 8 : (jr + 1) * 8, ic * 8 : (ic + 1) * 8] = sp_sheet[ty : ty + 8, tx : tx + 8]
            diff = np.abs(raw[:, :, :3].astype(np.int32) - m_surf).sum(axis=2)
            keep = (raw[:, :, 3] == 255) & (diff > 6)
            out = np.zeros((ch, cw, 4), dtype=np.uint8)
            hi = keep & (raw[:, :, 0] >= 220)
            mid = keep & (~hi)
            out[mid] = (*GLACIAL_METANO_PAL["spark_mid"], 255)
            out[hi] = (*GLACIAL_METANO_PAL["spark_hi"], 255)
            seq.append(out)
        return seq

    families: Dict[str, List[np.ndarray]] = {
        "A_16x24": _extract_cluster([0, 1], [0, 1, 2], 3),
        "B_24x16": _extract_cluster([2, 3, 4], [0, 1], 2),
        "C_16x32": _extract_cluster([0, 1], [12, 13, 14, 15], 4),
    }

    riv_sheets = [
        np.asarray(decode_pmdo_tile(eau_dir / f"Metano_Town_River_Animation_{i}.tile"), dtype=np.uint8)
        for i in range(1, 5)
    ]
    for tag, x0, y0 in (("R1_8x32", 984, 184), ("R2_8x32", 1072, 184)):
        seq_r: List[np.ndarray] = []
        for k in range(4):
            crop = riv_sheets[k][y0 : y0 + 32, x0 : x0 + 8]
            diff = np.abs(crop[:, :, :3].astype(np.int32) - m_surf).sum(axis=2)
            keep = (crop[:, :, 3] == 255) & (diff > 6)
            out = np.zeros((32, 8, 4), dtype=np.uint8)
            brighter = keep & (crop[:, :, 1] >= 200)
            darker = keep & (~brighter)
            out[darker] = (*GLACIAL_METANO_PAL["inter"], 255)
            out[brighter] = (*GLACIAL_METANO_PAL["accent"], 255)
            seq_r.append(out)
        families[tag] = seq_r

    return families


def build_glacial_metano_water_layers(
    w: int,
    h: int,
    water_mask: np.ndarray,
    bridge_mask: Optional[np.ndarray] = None,
    seed: int = 26101,
) -> Tuple[List[Image.Image], List[Image.Image]]:
    """Construit les 2 calques `4 poses @ 10 ticks` d'**Eau Métano Gelée** dans `water_mask` :
      1. `water_4_frames` (`4 poses @ 10 ticks`) : surface glaciaire `GLACIAL_METANO_PAL['surface']`
         + ondes concentriques de rive `Metano_Town_River_Animation_1..4` + frange de frasil glacé,
      2. `sparkle_4_frames` (`4 poses @ 10 ticks`) : grappes `1×` natives `Metano_Town_River_Sparkles.tile`
         (`A_16x24`, `B_24x16`, `C_16x32`) + rubans d'onde pleine eau `Metano_Town_River_Animation_1..4.tile`.
    """
    visible_water = water_mask.copy()
    if bridge_mask is not None:
        visible_water = visible_water & (~bridge_mask)

    # Distance à la vraie berge (sans créer de faux liseré d'écume contre le tablier du pont !)
    dist = ndimage.distance_transform_edt(water_mask)
    yy, xx = np.mgrid[:h, :w]
    jag = ndimage.gaussian_filter(np.random.default_rng(17).random((h, w)), 1.0)
    ptp = float(np.ptp(jag))
    jag = (jag - float(jag.min())) / (ptp if ptp > 1e-6 else 1.0)

    scale_band = max(0.65, min(1.15, w / float(W_CANON)))
    water_4_frames: List[Image.Image] = []
    for t in range(4):
        ph = 2.0 * math.pi * t / 4.0
        n_wave = 0.60 * np.sin(yy * 0.20 + xx * 0.09 - ph) + 0.40 * np.sin(yy * 0.08 - xx * 0.17 + 1.1 - ph)
        t_inner = (6.6 + 1.50 * n_wave) * scale_band
        jr = np.roll(jag, shift=t * 2, axis=0)
        fringe = t_inner + (1.8 + 4.2 * jr) * scale_band

        a = np.zeros((h, w, 4), dtype=np.uint8)
        a[visible_water] = (*GLACIAL_METANO_PAL["surface"], 255)

        m_fringe = visible_water & (dist > 0.0) & (dist <= fringe)
        a[m_fringe] = (*GLACIAL_METANO_PAL["inter"], 255)
        m_accent = m_fringe & (jr > 0.50)
        a[m_accent] = (*GLACIAL_METANO_PAL["accent"], 255)
        m_t = visible_water & (dist > 0.0) & (dist <= t_inner)
        a[m_t] = (*GLACIAL_METANO_PAL["inter"], 255)
        m_bande = visible_water & (dist > 0.0) & (dist <= np.maximum(1.8, t_inner - 2.2 * scale_band))
        a[m_bande] = (*GLACIAL_METANO_PAL["bande"], 255)
        # Fine bordure de frasil / glace vive le long des berges gelées
        m_clair = visible_water & (dist > 0.0) & (dist <= 1.75) & (np.sin(xx * 0.26 + yy * 0.40 - ph) > -0.45)
        a[m_clair] = (*GLACIAL_METANO_PAL["clair"], 255)
        water_4_frames.append(Image.fromarray(sanitize_rgba_binary(a)))

    # Placement sans chevauchement des vraies grappes 1x Metano_Town_River_Sparkles + rubans d'onde Metano
    fams = _load_glacial_metano_sparkle_and_wave_families()
    rng = np.random.default_rng(seed)
    safe_open = ndimage.binary_erosion(visible_water, iterations=max(4, int(round(6 * scale_band))))
    occupied = np.zeros((h, w), dtype=bool)
    placements: List[Tuple[str, int, int, int]] = []

    ys_open, xs_open = np.where(safe_open)
    if len(ys_open) > 0:
        order = rng.permutation(len(ys_open))
        fam_keys = ["A_16x24", "B_24x16", "C_16x32", "R1_8x32", "R2_8x32"]
        target_count = min(56, max(16, int(visible_water.sum()) // 950))
        for idx in order:
            if len(placements) >= target_count:
                break
            cy, cx = int(ys_open[idx]), int(xs_open[idx])
            fk = fam_keys[len(placements) % len(fam_keys)]
            sh, sw = fams[fk][0].shape[:2]
            x0 = (cx // 8) * 8
            y0 = (cy // 8) * 8
            if x0 < 8 or y0 < 8 or x0 + sw >= w - 8 or y0 + sh >= h - 8:
                continue
            if not safe_open[y0 : y0 + sh, x0 : x0 + sw].all():
                continue
            pad_y0, pad_y1 = max(0, y0 - 12), min(h, y0 + sh + 12)
            pad_x0, pad_x1 = max(0, x0 - 12), min(w, x0 + sw + 12)
            if occupied[pad_y0:pad_y1, pad_x0:pad_x1].any():
                continue
            occupied[y0 : y0 + sh, x0 : x0 + sw] = True
            placements.append((fk, x0, y0, int(rng.integers(0, 4))))

    sparkle_4_frames: List[Image.Image] = []
    for t in range(4):
        sp_canvas = np.zeros((h, w, 4), dtype=np.uint8)
        for fk, x0, y0, ph0 in placements:
            patch = fams[fk][(t + ph0) % 4]
            sh, sw = patch.shape[:2]
            nz = (patch[:, :, 3] == 255) & visible_water[y0 : y0 + sh, x0 : x0 + sw]
            if np.any(nz):
                sub = sp_canvas[y0 : y0 + sh, x0 : x0 + sw]
                sub[nz] = patch[nz]
        sparkle_4_frames.append(Image.fromarray(sanitize_rgba_binary(sp_canvas)))

    return water_4_frames, sparkle_4_frames


# ============================================================================
# 3. FLEURS HIVERNALES METANO & CRISTAUX CRYO (`KYE1`)
# ============================================================================

def tint_metano_flowers_to_frost(frames_4: List[np.ndarray]) -> List[np.ndarray]:
    """Convertit les fleurs animées de `Metano_Town_Animation_Tileset.tile` en fleurs de givre boréales
    (feuillage gris-bleu enneigé & pétales cristal cyan/blanc, zéro pixel vert/jaune chaud sur la neige)."""
    out_list: List[np.ndarray] = []
    for sp in frames_4:
        arr = sp.copy()
        r = arr[:, :, 0].astype(np.float32)
        g = arr[:, :, 1].astype(np.float32)
        b = arr[:, :, 2].astype(np.float32)
        op = arr[:, :, 3] == 255
        lum = 0.299 * r + 0.587 * g + 0.114 * b
        is_bright_petal = op & (lum >= 198.0)
        is_foliage_base = op & (~is_bright_petal)

        arr[is_foliage_base, 0] = np.clip(lum[is_foliage_base] * 0.72 + 54.0, 96.0, 196.0).astype(np.uint8)
        arr[is_foliage_base, 1] = np.clip(lum[is_foliage_base] * 0.84 + 66.0, 118.0, 218.0).astype(np.uint8)
        arr[is_foliage_base, 2] = np.clip(lum[is_foliage_base] * 0.96 + 88.0, 154.0, 244.0).astype(np.uint8)

        arr[is_bright_petal, 0] = np.clip(lum[is_bright_petal] * 0.88 + 26.0, 196.0, 248.0).astype(np.uint8)
        arr[is_bright_petal, 1] = np.clip(lum[is_bright_petal] * 0.96 + 18.0, 224.0, 254.0).astype(np.uint8)
        arr[is_bright_petal, 2] = 255
        out_list.append(sanitize_rgba_binary(arr))
    return out_list


def build_kyurem_entree_crystals_and_snow_top(
    rgb_nat: np.ndarray,
    solid_nat: np.ndarray,
    snow_meadow_mask: np.ndarray,
    canopy_nat: np.ndarray,
) -> Tuple[List[Image.Image], List[Image.Image]]:
    """Construit `(cryo_crystals_and_frost_flowers_24, frosted_canopy_and_w03p03_snow_top_24)` pour `KYE1`."""
    yy, xx = np.mgrid[0:H_CANON, 0:W_CANON]
    r_c = rgb_nat[:, :, 0].astype(np.int16)
    g_c = rgb_nat[:, :, 1].astype(np.int16)
    b_c = rgb_nat[:, :, 2].astype(np.int16)

    # Cristaux cyan de givre et gemmes cryo-ambrées encadrant la bouche de la Grotte Cyclopéenne
    in_cave_frame = solid_nat & (yy < 286) & (np.abs(xx - 384) <= 138)
    cyan_crystals = in_cave_frame & (g_c >= 205) & (b_c >= 220) & ((b_c - r_c) >= 52)
    amber_gems = in_cave_frame & (r_c >= 196) & (g_c >= 116) & (b_c <= 98) & ((r_c - b_c) >= 110)

    # Fleurs hivernales natives Metano_Town_Animation_Tileset.tile sur la toundra enneigée
    assets = extract_metano_water_and_flower_assets()
    fl_wht_4 = tint_metano_flowers_to_frost(assets["metano_flowers_white_4"])  # type: ignore[arg-type]
    fl_col_4 = tint_metano_flowers_to_frost(assets["metano_flowers_color_4"])  # type: ignore[arg-type]

    fh, fw = fl_wht_4[0].shape[:2]
    dist_snow = ndimage.distance_transform_edt(snow_meadow_mask)
    taken = np.zeros((H_CANON, W_CANON), dtype=bool)
    flower_sites: List[Tuple[int, int, str, int]] = []
    rng = np.random.default_rng(1912)
    cands = [(sy, sx) for sy in range(392, H_CANON - fh - 16, 12) for sx in range(136, W_CANON - fw - 136, 12)]
    rng.shuffle(cands)
    for sy, sx in cands:
        if abs((sx + fw // 2) - 384) < 66:
            continue
        if dist_snow[sy : sy + fh, sx : sx + fw].min() >= 8.0 and not taken[
            max(0, sy - 20) : sy + fh + 20, max(0, sx - 20) : sx + fw + 20
        ].any():
            taken[sy : sy + fh, sx : sx + fw] = True
            kind = "white" if (len(flower_sites) % 3 != 0) else "color"
            flower_sites.append((sx, sy, kind, len(flower_sites) % 4))
            if len(flower_sites) >= 7:
                break

    # Chute de neige matérielle GBA 1x W03P03 (PMD Red) sur 24 poses cycliques continues
    snow_w03_frames = [
        np.asarray(im, dtype=np.uint8)
        for im in build_gba_weather_overlay_frames(
            "W03P03",
            W_CANON,
            H_CANON,
            N_POSES,
            scroll_dx_per_loop=-48,
            scroll_dy_per_loop=96,
            tint_palette=[
                (156, 206, 244),
                (204, 236, 255),
                (244, 252, 255),
            ],
            subsample_keep_mod=1,
        )
    ]

    # Ancres de poussière de diamant cryo autour de l'arche de Kyurem
    cryo_sparks = [
        (314, 152, 0),
        (454, 148, 1),
        (292, 212, 2),
        (476, 208, 3),
        (356, 108, 1),
        (412, 108, 3),
    ]

    can_op = canopy_nat[:, :, 3] >= 128
    lay8_frames: List[Image.Image] = []
    top9_frames: List[Image.Image] = []

    for f in range(N_POSES):
        theta = 2.0 * math.pi * f / float(N_POSES)
        fl_phase = (f // 2) % 4
        pulse_cyan = 0.5 + 0.5 * math.sin(theta)
        pulse_gold = 0.5 + 0.5 * math.cos(theta - 0.6)

        # Calque 08 : Résonance des cristaux cyan & gemmes ambrées de Kyurem + fleurs givrées Metano
        arr8 = np.zeros((H_CANON, W_CANON, 4), dtype=np.uint8)
        glow_rgb = rgb_nat.astype(np.float32)

        glow_rgb[cyan_crystals, 0] = np.clip(glow_rgb[cyan_crystals, 0] + 44.0 * pulse_cyan, 0.0, 244.0)
        glow_rgb[cyan_crystals, 1] = np.clip(glow_rgb[cyan_crystals, 1] + 24.0 * pulse_cyan, 0.0, 255.0)
        glow_rgb[cyan_crystals, 2] = np.clip(glow_rgb[cyan_crystals, 2] + 14.0 * pulse_cyan, 0.0, 255.0)

        glow_rgb[amber_gems, 0] = np.clip(glow_rgb[amber_gems, 0] + 26.0 * pulse_gold, 0.0, 255.0)
        glow_rgb[amber_gems, 1] = np.clip(glow_rgb[amber_gems, 1] + 38.0 * pulse_gold, 0.0, 248.0)
        glow_rgb[amber_gems, 2] = np.clip(glow_rgb[amber_gems, 2] + 32.0 * pulse_gold, 0.0, 196.0)

        active_crys = cyan_crystals | amber_gems
        glow_u8 = _sanitize_rgb_no_magenta((np.round(glow_rgb / 4.0) * 4.0).clip(0, 255).astype(np.uint8), active_crys)
        arr8[active_crys, :3] = glow_u8[active_crys]
        arr8[active_crys, 3] = 255

        for sx, sy, kind, ph0 in flower_sites:
            patch = (fl_wht_4 if kind == "white" else fl_col_4)[(fl_phase + ph0) % 4]
            ph_h, ph_w = patch.shape[:2]
            nz = patch[:, :, 3] == 255
            sub = arr8[sy : sy + ph_h, sx : sx + ph_w]
            sub[nz] = patch[nz]

        lay8_frames.append(Image.fromarray(sanitize_rgba_binary(arr8), mode="RGBA"))

        # Calque 09 Top : Cimes des sapins enneigés + Neige GBA W03P03 1x + poussière de diamant cryo
        arr9 = np.zeros((H_CANON, W_CANON, 4), dtype=np.uint8)
        arr9[can_op] = canopy_nat[can_op]

        sn = snow_w03_frames[f]
        sn_m = sn[:, :, 3] == 255
        arr9[sn_m] = sn[sn_m]

        for ax0, ay0, ph_s in cryo_sparks:
            ph_ang = theta + ph_s * (math.pi * 0.5)
            sx_p = int(round(ax0 + 4.0 * math.sin(ph_ang)))
            sy_p = int(round(ay0 - 3.0 * math.cos(ph_ang)))
            if 4 <= sx_p < W_CANON - 4 and 4 <= sy_p < H_CANON - 4:
                arr9[sy_p, sx_p] = (242, 253, 255, 255)
                if math.sin(2.0 * theta + ph_s) > 0.20:
                    for dy_s, dx_s in ((-1, 0), (1, 0), (0, -1), (0, 1)):
                        arr9[sy_p + dy_s, sx_p + dx_s] = (116, 218, 252, 255)

        top9_frames.append(Image.fromarray(sanitize_rgba_binary(arr9), mode="RGBA"))

    return lay8_frames, top9_frames


# ============================================================================
# 4. BLIZZARD CYCLONIQUE CYLINDRIQUE 3D 360° (`Ère Glaciaire` — `KYA1`)
# ============================================================================

def build_kyurem_cylindrical_blizzard_layers(
    opaque_interior_mask: np.ndarray,
    solid_rock_mask: np.ndarray,
    arena_safe_mask: np.ndarray,
    rim_spire_glow_mask: np.ndarray,
) -> Dict[str, List[Image.Image]]:
    """Construit le **Cyclone Cylindrique 3D 360° de Blizzard Glaciaire (`Ère Glaciaire`)** autour
    du Sanctuaire de Glace Noire de Kyurem (`24 poses @ 5 ticks` = `120` ticks) :
      - `00_paroi_et_gouffre` (`BG`) : gouffre polaire + paroi interne arrière concave (`Gauche → Droite`),
      - `01_colonnes_et_rubans` (`BG`) : colonnes tangentielles Ouest/Est + rubans hélicoïdaux cryo & or pâle,
      - `08_eclats_et_reflets_bg` (`BG`) : éclats de glace tournoyants, arcs cryo, reflets de givre sur les
        pitons cyan & poudreuse GBA `W03P03` d'arrière-plan,
      - `09_levre_blizzard_et_neige_top` (`Top`) : lèvre avant en surplomb (`Droite → Gauche`) + bourrasques
        de neige `W03P03` `1×` en premier plan (laissant l'arène centrale parfaitement lisible).
    """
    hidden_under_interior = ndimage.binary_erosion(opaque_interior_mask, iterations=3)

    gw, gh = W_CANON // 2, H_CANON // 2
    gy, gx = np.mgrid[0:gh, 0:gw].astype(np.float32)
    px_x = gx * 2.0 + 0.5
    px_y = gy * 2.0 + 0.5
    bayer_g = BAYER_4X4[np.arange(gh)[:, None] % 4, np.arange(gw)[None, :] % 4]
    bayer_full = BAYER_4X4[np.arange(H_CANON)[:, None] % 4, np.arange(W_CANON)[None, :] % 4]

    cx, cy_eye = 384.0, 290.0
    r_cyl = 452.0
    sin_tilt = 0.46

    dx = px_x - cx
    dy = px_y - cy_eye
    u_cyl = dx / r_cyl
    phi_back = np.arcsin(u_cyl)
    cos_phi = np.sqrt(1.0 - u_cyl * u_cyl)

    ry_persp = dy / sin_tilt
    r_ell = np.hypot(dx, ry_persp)
    ang_360 = np.arctan2(ry_persp, dx)

    z_back = px_y + 165.0 * cos_phi
    z_front = px_y - 165.0 * cos_phi

    eye_wall_factor = np.clip((r_ell - 175.0) / 145.0, 0.0, 1.0)
    side_wall_weight = np.clip((np.abs(dx) - 210.0) / 145.0, 0.0, 1.0)

    pal_abyss = [
        (8, 16, 30),
        (13, 27, 48),
        (20, 42, 72),
        (30, 62, 102),
        (46, 92, 142),
    ]
    pal_back_wall = [
        (10, 20, 38),
        (16, 34, 60),
        (26, 54, 90),
        (40, 82, 128),
        (64, 122, 174),
        (104, 174, 218),
        (168, 224, 248),
    ]
    pal_side_col = [
        (14, 28, 52),
        (26, 52, 88),
        (44, 86, 134),
        (76, 138, 190),
        (132, 198, 236),
        (214, 244, 255),
    ]
    pal_front_lip = [
        (68, 132, 188),
        (104, 174, 224),
        (148, 212, 246),
        (202, 238, 254),
        (242, 252, 255),
    ]
    bg_hidden_rgb = (10, 20, 38)

    # Neige matérielle GBA 1x W03P03 (arrière-plan G->D + premier plan D->G contrarotatif)
    snow_bg_24 = [
        np.asarray(im, dtype=np.uint8)
        for im in build_gba_weather_overlay_frames(
            "W03P03",
            W_CANON,
            H_CANON,
            N_POSES,
            scroll_dx_per_loop=96,
            scroll_dy_per_loop=96,
            tint_palette=[(116, 184, 232), (184, 230, 252), (238, 250, 255)],
            subsample_keep_mod=2,
        )
    ]
    snow_fg_24 = [
        np.asarray(im, dtype=np.uint8)
        for im in build_gba_weather_overlay_frames(
            "W03P03",
            W_CANON,
            H_CANON,
            N_POSES,
            scroll_dx_per_loop=-96,
            scroll_dy_per_loop=96,
            tint_palette=[(168, 220, 248), (222, 246, 255), (250, 254, 255)],
            subsample_keep_mod=3,
        )
    ]

    arena_clear_top = ndimage.binary_dilation(arena_safe_mask, iterations=8)
    arena_clear_top_g = arena_clear_top[::2, ::2]

    rng_shards = np.random.default_rng(6460)
    shard_seeds = rng_shards.uniform(0.0, 1.0, size=(42, 3))

    out: Dict[str, List[Image.Image]] = {
        "00_paroi_et_gouffre": [],
        "01_colonnes_et_rubans": [],
        "08_eclats_et_reflets_bg": [],
        "09_levre_blizzard_et_neige_top": [],
    }

    yy_f, xx_f = np.mgrid[0:H_CANON, 0:W_CANON].astype(np.float32)
    rim_ang = np.arctan2(yy_f - cy_eye, xx_f - cx)

    for pose in range(N_POSES):
        theta = 2.0 * math.pi * pose / float(N_POSES)

        # -----------------------------------------------------------------
        # CALQUE 00 : Gouffre polaire + Paroi arrière concave 360° (G -> D)
        # -----------------------------------------------------------------
        ab_spiral = 2.0 * ang_360 - theta - 0.022 * r_ell + 0.35 * np.sin(ang_360 - 3.0 * theta)
        ab_val = np.clip(0.34 + 0.28 * np.sin(ab_spiral) + 0.28 * eye_wall_factor, 0.0, 1.0)
        ab_rgb_g = palette_lookup_dithered(ab_val, pal_abyss, bayer_g, dither_strength=0.58)

        cyl_stream_1 = 3.0 * ang_360 - theta - 0.018 * r_ell + 0.016 * z_back
        cyl_stream_2 = 5.0 * ang_360 - 3.0 * theta - 0.012 * r_ell - 0.010 * z_back
        wall_intensity = (
            0.34
            + 0.32 * np.sin(cyl_stream_1 + 0.35 * np.sin(cyl_stream_2))
            + 0.24 * eye_wall_factor
            + 0.10 * side_wall_weight
        )
        back_wall_mask_g = (eye_wall_factor + 0.22 * np.sin(cyl_stream_1) + bayer_g * 0.22) > 0.22
        bw_rgb_g = palette_lookup_dithered(
            np.clip(wall_intensity, 0.0, 1.0), pal_back_wall, bayer_g, dither_strength=0.62
        )

        comb0_g = ab_rgb_g.copy()
        comb0_g[back_wall_mask_g] = bw_rgb_g[back_wall_mask_g]
        l0_rgba = np.zeros((H_CANON, W_CANON, 4), dtype=np.uint8)
        l0_rgba[:, :, :3] = np.repeat(np.repeat(comb0_g, 2, axis=0), 2, axis=1)
        l0_rgba[:, :, 3] = 255
        l0_rgba[hidden_under_interior, :3] = bg_hidden_rgb
        out["00_paroi_et_gouffre"].append(Image.fromarray(sanitize_rgba_binary(l0_rgba)))

        # -----------------------------------------------------------------
        # CALQUE 01 : Colonnes tangentielles Ouest/Est + Rubans Ère Glaciaire
        # -----------------------------------------------------------------
        ring_phase = 0.048 * z_back + 2.0 * (phi_back - theta) + 0.30 * np.cos(3.0 * ang_360 - 3.0 * theta)
        col_wave = 0.50 + 0.50 * np.sin(ring_phase)
        col_mask_g = (eye_wall_factor * 0.68 + 0.34 * (col_wave - 0.50) + bayer_g * 0.20) > 0.58
        col_rgb_g = palette_lookup_dithered(
            np.clip(0.24 + 0.48 * col_wave + 0.16 * side_wall_weight, 0.0, 1.0),
            pal_side_col,
            bayer_g,
            dither_strength=0.58,
        )

        rib_stream = np.sin(3.0 * ang_360 - theta - 0.024 * r_ell + 0.012 * z_back)
        rib_fine = np.sin(6.0 * ang_360 - 3.0 * theta - 0.016 * r_ell)
        in_outer_cyl = eye_wall_factor > 0.28

        l1_rgba_g = np.zeros((gh, gw, 4), dtype=np.uint8)
        l1_rgba_g[col_mask_g, :3] = col_rgb_g[col_mask_g]
        l1_rgba_g[col_mask_g, 3] = 255

        cryo_halo = in_outer_cyl & ((rib_stream + 0.26 * rib_fine + bayer_g * 0.18) > 0.90)
        cryo_cyan = in_outer_cyl & ((rib_stream + 0.26 * rib_fine + bayer_g * 0.12) > 1.06)
        cryo_white = in_outer_cyl & ((rib_stream + 0.26 * rib_fine + bayer_g * 0.08) > 1.18)
        l1_rgba_g[cryo_halo] = (72, 168, 228, 255)
        l1_rgba_g[cryo_cyan] = (176, 236, 255, 255)
        l1_rgba_g[cryo_white] = (244, 253, 255, 255)

        l1_rgba = np.repeat(np.repeat(l1_rgba_g, 2, axis=0), 2, axis=1)
        l1_rgba[opaque_interior_mask] = 0
        out["01_colonnes_et_rubans"].append(Image.fromarray(sanitize_rgba_binary(l1_rgba)))

        # -----------------------------------------------------------------
        # CALQUE 08 : Éclats de glace, Arcs Cryo, Reflets des pitons & Neige BG
        # -----------------------------------------------------------------
        l8_rgba = np.zeros((H_CANON, W_CANON, 4), dtype=np.uint8)

        # Poudreuse GBA W03P03 dans le vortex extérieur
        sn_bg = snow_bg_24[pose]
        m_sn_bg = (sn_bg[:, :, 3] == 255) & (~opaque_interior_mask)
        l8_rgba[m_sn_bg] = sn_bg[m_sn_bg]

        # Cristaux / éclats de glace vive emportés dans l'hélice 360° (+ rares éclats ambrés de Kyurem)
        for idx_s, (u_ang, u_rad, u_z) in enumerate(shard_seeds):
            ang_s = u_ang * 2.0 * math.pi + theta
            rad_s = 235.0 + 165.0 * u_rad
            sx = int(round(cx + rad_s * math.cos(ang_s)))
            sy = int((u_z * H_CANON + pose * (H_CANON / N_POSES)) % H_CANON)
            if 3 <= sx < W_CANON - 4 and 3 <= sy < H_CANON - 4 and not opaque_interior_mask[sy, sx]:
                is_amber = (idx_s % 9) == 0
                if is_amber:
                    l8_rgba[sy : sy + 2, sx : sx + 2] = (248, 206, 88, 255)
                else:
                    l8_rgba[sy : sy + 2, sx : sx + 3] = (236, 250, 255, 255)
                    l8_rgba[sy + 2, sx + 1 : sx + 3] = (96, 196, 244, 255)

        # Sillages glacés Ère Glaciaire sur les flancs concaves hors du rempart
        for k_arc, (z_lvl, p_off) in enumerate([(88.0, 0), (196.0, 8), (448.0, 16)]):
            rel = (pose + p_off) % N_POSES
            if rel < 8:
                phi_center = -1.22 + 2.44 * (rel / 7.0)
                pts_arc = []
                for s in range(7):
                    ph = float(np.clip(phi_center + (s - 3) * 0.13, -1.44, 1.44))
                    ax = int(round(cx + 344.0 * math.sin(ph)))
                    jitter = (4 if (s + pose + k_arc) % 2 == 0 else -4) if 0 < s < 6 else 0
                    ay = int(round(z_lvl - 140.0 * sin_tilt * math.cos(ph) + jitter))
                    pts_arc.append((ax, ay))
                draw_pixel_bolt_rgba(
                    l8_rgba,
                    pts_arc,
                    core_rgb=(242, 253, 255),
                    halo_rgb=(84, 192, 246),
                    core_half_w=1,
                    halo_half_w=2,
                )
        l8_rgba[opaque_interior_mask] = 0

        # Reflets cristallins sur les pitons de glace noire de la couronne (par-dessus solid_rock_mask)
        rim_pulse = np.sin(3.0 * rim_ang - theta) + 0.5 * np.cos(5.0 * rim_ang + 3.0 * theta)
        lit_rim = rim_spire_glow_mask & ((rim_pulse + bayer_full * 0.42) > 0.48)
        hot_rim = rim_spire_glow_mask & ((rim_pulse + bayer_full * 0.28) > 1.04)
        l8_rgba[lit_rim] = (118, 214, 250, 255)
        l8_rgba[hot_rim] = (242, 253, 255, 255)

        out["08_eclats_et_reflets_bg"].append(Image.fromarray(sanitize_rgba_binary(l8_rgba)))

        # -----------------------------------------------------------------
        # CALQUE 09 (`Top`) : Lèvre avant du Blizzard (D -> G !) + Neige W03P03
        # -----------------------------------------------------------------
        front_helix = np.sin(4.0 * (phi_back + theta) - 0.036 * z_front) + 0.35 * np.cos(
            7.0 * (phi_back + theta) + 0.028 * z_front - 3.0 * theta
        )
        in_top_rim = px_y < (20.0 + 26.0 * (1.0 - cos_phi))
        in_bot_corners = (
            (px_y > (536.0 - 92.0 * side_wall_weight))
            & (np.abs(dx) > 112.0)
            & (~opaque_interior_mask[::2, ::2])
        )
        front_zone_g = (in_top_rim | in_bot_corners) & (~arena_clear_top_g)

        front_mask_g = front_zone_g & ((front_helix + bayer_g * 0.45) > 0.34)
        front_val_g = np.clip(0.50 + 0.38 * front_helix, 0.0, 1.0)
        front_rgb_g = palette_lookup_dithered(front_val_g, pal_front_lip, bayer_g, dither_strength=0.65)
        front_rgba_g = np.zeros((gh, gw, 4), dtype=np.uint8)
        front_rgba_g[front_mask_g, :3] = front_rgb_g[front_mask_g]
        front_rgba_g[front_mask_g, 3] = 255
        l9_rgba = np.repeat(np.repeat(front_rgba_g, 2, axis=0), 2, axis=1)

        # Flocons GBA W03P03 1x en léger voile de premier plan hors du cœur de l'arène
        sn_fg = snow_fg_24[pose]
        m_sn_fg = (sn_fg[:, :, 3] == 255) & (~arena_clear_top)
        l9_rgba[m_sn_fg] = sn_fg[m_sn_fg]

        out["09_levre_blizzard_et_neige_top"].append(Image.fromarray(sanitize_rgba_binary(l9_rgba)))

    return out
