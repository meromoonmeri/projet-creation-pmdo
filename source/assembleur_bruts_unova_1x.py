#!/usr/bin/env python3
"""Pipeline `METHODE_MAGENTA_ET_GENERATEUR.md` (§3 `key()`, §4 `tint()`, §6 réduction 2×2/bloc sans mélange +
quantification MEDIANCUT 96 couleurs sans tramage) pour les 4 cartes PMDO 0.8.12.0 Unova (`768 × 576`) :

- `ZKE1` & `RSE1` : à partir du décor généré sélectionné `decor_entree_genere_magenta.png` (`2400 × 1792`),
  montagne rocheuse naturelle à grotte centrale et doubles gorges de cascades `#FF00FF` face à une clairière
  *Tiny Woods + Sky Peak Prairie* traversée par une rivière `#FF00FF` et son pont de bois.
- `ZKA1` & `RSA1` : à partir du décor généré sélectionné `decor_sommet_genere_magenta.png` (`2400 × 1792`),
  plateau rocheux naturel style *Mt. Thunder Summit* et escalier Sud centrés au milieu d'un vide `#FF00FF` 360°.
"""

from __future__ import annotations

import colorsys
from pathlib import Path

import numpy as np
from PIL import Image
from scipy import ndimage

REPO_ROOT = Path(__file__).resolve().parents[1]
W, H = 768, 576
MAGENTA = np.array([255, 0, 255], dtype=np.uint8)

MASTER_ENTREE_GEN = (
    REPO_ROOT / "source" / "zekrom_montagne_entree_v1" / "bruts" / "decor_entree_genere_magenta.png"
)
MASTER_SOMMET_GEN = (
    REPO_ROOT / "source" / "zekrom_sommet_tornade_v1" / "bruts" / "decor_sommet_genere_magenta.png"
)


def key_magenta_hi_res(rgb_hi: np.ndarray, dilate_fringe: int = 3) -> np.ndarray:
    """§3 `key()` : détourage du balisage `#FF00FF` par rapport de canaux + suppression du liseré antialiasé."""
    r = rgb_hi[:, :, 0].astype(np.float32)
    g = rgb_hi[:, :, 1].astype(np.float32)
    b = rgb_hi[:, :, 2].astype(np.float32)
    bg = (r > 70.0) & (b > 70.0) & (r > g * 1.45) & (b > g * 1.45)
    fringe = ndimage.binary_dilation(bg, iterations=dilate_fringe) & (r > g * 1.06) & (b > g * 1.06)
    return bg | fringe


def downsample_non_mixing(
    rgb_hi: np.ndarray,
    mag_hi: np.ndarray,
    out_w: int = W,
    out_h: int = H,
    mag_vote_ratio: float = 0.48,
) -> tuple[np.ndarray, np.ndarray]:
    """§6 Réduction par classe sans aucun mélange entre `#FF00FF` et le décor adjacent."""
    sh, sw = rgb_hi.shape[:2]
    y_edges = np.round(np.linspace(0, sh, out_h + 1)).astype(np.int32)
    x_edges = np.round(np.linspace(0, sw, out_w + 1)).astype(np.int32)

    out_rgb = np.zeros((out_h, out_w, 3), dtype=np.uint8)
    out_mag = np.zeros((out_h, out_w), dtype=bool)

    # Pré-masquer les pixels magenta par 0 pour sommer uniquement les pixels solides en 2 passes séparables rapides
    solid_hi = (~mag_hi).astype(np.int32)
    rgb_solid = rgb_hi.astype(np.int32) * solid_hi[:, :, None]

    # Sommation séparable Y puis X (instantanée sur 2400x1792 -> 768x576)
    cs_solid_y = np.vstack([np.zeros((1, sw), dtype=np.int32), np.cumsum(solid_hi, axis=0)])
    band_solid = cs_solid_y[y_edges[1:]] - cs_solid_y[y_edges[:-1]]
    cs_solid_yx = np.hstack([np.zeros((out_h, 1), dtype=np.int32), np.cumsum(band_solid, axis=1)])
    cnt_solid = cs_solid_yx[:, x_edges[1:]] - cs_solid_yx[:, x_edges[:-1]]

    block_area = np.outer(y_edges[1:] - y_edges[:-1], x_edges[1:] - x_edges[:-1])
    cnt_mag = block_area - cnt_solid
    out_mag = cnt_mag >= np.ceil(block_area * mag_vote_ratio)

    cs_rgb_y = np.vstack([np.zeros((1, sw, 3), dtype=np.int32), np.cumsum(rgb_solid, axis=0)])
    band_rgb = cs_rgb_y[y_edges[1:]] - cs_rgb_y[y_edges[:-1]]
    cs_rgb_yx = np.hstack([np.zeros((out_h, 1, 3), dtype=np.int32), np.cumsum(band_rgb, axis=1)])
    sum_rgb = cs_rgb_yx[:, x_edges[1:]] - cs_rgb_yx[:, x_edges[:-1]]

    safe_cnt = np.maximum(cnt_solid, 1)[:, :, None]
    mean_solid = np.clip(np.round(sum_rgb / safe_cnt), 0, 255).astype(np.uint8)

    out_rgb[:] = mean_solid
    out_rgb[out_mag] = MAGENTA

    # Si un pixel voté non-magenta avait `cnt_solid == 0`, le basculer en `#FF00FF`
    zero_solid = (~out_mag) & (cnt_solid == 0)
    out_mag[zero_solid] = True
    out_rgb[zero_solid] = MAGENTA
    return out_rgb, out_mag


def quantize_non_magenta_mediancut(rgb: np.ndarray, mag_mask: np.ndarray, n_colors: int = 96) -> np.ndarray:
    """§6 Quantification MEDIANCUT commune à `n_colors` couleurs (dither=NONE) hors zone `#FF00FF`."""
    work = rgb.copy()
    # Remplacer temporairement `#FF00FF` par une couleur déjà présente dans le décor pour ne gaspiller aucun slot
    solid_pixels = work[~mag_mask]
    fill_rgb = solid_pixels[0] if len(solid_pixels) > 0 else np.array([32, 32, 32], dtype=np.uint8)
    work[mag_mask] = fill_rgb

    im_q = Image.fromarray(work, mode="RGB").quantize(
        colors=n_colors,
        method=Image.Quantize.MEDIANCUT,
        dither=Image.Dither.NONE,
    )
    res = np.array(im_q.convert("RGB"), dtype=np.uint8)

    # Purger tout éventuel liseré rose résiduel à 1-2 px de `#FF00FF`
    near_mag = ndimage.binary_dilation(mag_mask, iterations=2) & (~mag_mask)
    r, g, b = res[:, :, 0].astype(np.float32), res[:, :, 1].astype(np.float32), res[:, :, 2].astype(np.float32)
    pink_edge = near_mag & (r > 95.0) & (b > 95.0) & (r > g * 1.12) & (b > g * 1.12)
    mag_final = mag_mask | pink_edge
    res[mag_final] = MAGENTA
    return res


def _tint_palette_entries(rgb: np.ndarray, mag_mask: np.ndarray, mode: str, scene: str) -> np.ndarray:
    """§4 `tint()` : déclinaison chromatique par biome (Zekrom orage vs Reshiram solaire) en préservant `#FF00FF`."""
    out = rgb.copy()
    yy, xx = np.mgrid[0:H, 0:W]
    solid = ~mag_mask

    r = out[:, :, 0].astype(np.float32)
    g = out[:, :, 1].astype(np.float32)
    b = out[:, :, 2].astype(np.float32)

    if scene == "entree":
        # Isoler la roche de montagne & rochers (hors pont bois central x=344..424, hors herbe/arbres verts, hors fleurs)
        in_bridge_or_path = (np.abs(xx - 384) <= 40) & (yy >= 142)
        is_green_veg = (g > r * 1.06) & (g > b * 1.15)
        is_cave_black = (r < 28.0) & (g < 28.0) & (b < 28.0) & (yy < 160)
        is_flower_petal = (
            solid
            & (yy >= 260)
            & (np.abs(xx - 384) > 48)
            & (r > 195.0)
            & (r > g + 32.0)
            & (b > 135.0)
        )
        is_mountain_rock = solid & (~is_green_veg) & (~in_bridge_or_path) & (~is_cave_black) & (
            (yy < 176) | ((np.abs(r - g) < 42.0) & (g < 168.0) & (b > 65.0))
        )

        if mode == "zekrom_electric":
            # Granit d'orage bleuté-ardoise profond pour la montagne de Zekrom
            lum = 0.299 * r + 0.587 * g + 0.114 * b
            nr = np.clip(lum * 0.78 + 6.0, 12.0, 224.0)
            ng = np.clip(lum * 0.86 + 12.0, 16.0, 234.0)
            nb = np.clip(lum * 1.06 + 24.0, 24.0, 248.0)
            out[is_mountain_rock, 0] = nr[is_mountain_rock].astype(np.uint8)
            out[is_mountain_rock, 1] = ng[is_mountain_rock].astype(np.uint8)
            out[is_mountain_rock, 2] = nb[is_mountain_rock].astype(np.uint8)
            out[is_cave_black] = (8, 12, 22)
        else:
            # Grès solaire ocre-ivoire lumineux pour la montagne de Reshiram + prairie dorée
            lum = 0.299 * r + 0.587 * g + 0.114 * b
            nr = np.clip(lum * 1.24 + 22.0, 28.0, 252.0)
            ng = np.clip(lum * 1.02 + 12.0, 20.0, 232.0)
            nb = np.clip(lum * 0.72 + 4.0, 12.0, 184.0)
            out[is_mountain_rock, 0] = nr[is_mountain_rock].astype(np.uint8)
            out[is_mountain_rock, 1] = ng[is_mountain_rock].astype(np.uint8)
            out[is_mountain_rock, 2] = nb[is_mountain_rock].astype(np.uint8)
            out[is_cave_black] = (20, 11, 10)
            # Réchauffer subtilement l'herbe Sky Peak et transformer une partie des fleurs roses en fleurs blanc-or
            meadow = solid & is_green_veg & (g > 155.0)
            out[meadow, 0] = np.clip(r[meadow] * 1.08 + 10.0, 0, 255).astype(np.uint8)
            out[meadow, 2] = np.clip(b[meadow] * 0.90, 0, 255).astype(np.uint8)
            gold_flw = is_flower_petal & (((xx // 16 + yy // 16) % 2) == 0)
            out[gold_flw, 0] = 255
            out[gold_flw, 1] = np.clip(g[gold_flw] * 1.22 + 36.0, 196, 248).astype(np.uint8)
            out[gold_flw, 2] = np.clip(b[gold_flw] * 0.85 + 24.0, 140, 224).astype(np.uint8)

    elif scene == "sommet":
        lum = 0.299 * r + 0.587 * g + 0.114 * b
        if mode == "zekrom_electric":
            # Sommet Mt. Thunder minéral d'orage (quartz pâle & falaises granit bleu-ardoise V38P07A)
            is_flat_sand = solid & (lum >= 182.0)
            is_cliff_rock = solid & (~is_flat_sand)
            out[is_flat_sand, 0] = np.clip(lum[is_flat_sand] * 0.86 + 8.0, 140, 228).astype(np.uint8)
            out[is_flat_sand, 1] = np.clip(lum[is_flat_sand] * 0.91 + 12.0, 148, 236).astype(np.uint8)
            out[is_flat_sand, 2] = np.clip(lum[is_flat_sand] * 0.98 + 18.0, 162, 246).astype(np.uint8)

            out[is_cliff_rock, 0] = np.clip(lum[is_cliff_rock] * 0.78 + 6.0, 18, 210).astype(np.uint8)
            out[is_cliff_rock, 1] = np.clip(lum[is_cliff_rock] * 0.86 + 12.0, 24, 222).astype(np.uint8)
            out[is_cliff_rock, 2] = np.clip(lum[is_cliff_rock] * 1.06 + 22.0, 34, 242).astype(np.uint8)
        else:
            # Sommet Mt. Thunder solaire ivoire-ambre pour Reshiram (éclat chaud de Flamme Blanche)
            out[solid, 0] = np.clip(r[solid] * 1.05 + 8.0, 28, 254).astype(np.uint8)
            out[solid, 1] = np.clip(g[solid] * 1.01 + 4.0, 20, 242).astype(np.uint8)
            out[solid, 2] = np.clip(b[solid] * 0.92, 14, 198).astype(np.uint8)

    out[mag_mask] = MAGENTA
    return out


def assemble_entree_montagne_clairiere_metano(
    mode: str,
    map_dir: Path,
    asset_name: str,
) -> dict[str, Path]:
    """Construit le brut `768×576` sans ciel (`0 px` de ciel !) de `ZKE1` ou `RSE1` avec deux biomes distincts :
      - `zekrom_electric` (`ZKE1`) : Taïga boréale d'orage, orgues basaltiques hexagonales jusqu'à `y=0`, grotte à cristaux cyan & pont runique ;
      - `reshiram_white_flame` (`RSE1`) : Vallon doré d'automne (bouleaux/érables), falaise étagée de marbre ivoire jusqu'à `y=0`, arche à colonnes & passerelle claire."""
    from source.moteur_forets_pmd_red import _downsample_non_mixing, _sanitize_rgb_no_magenta

    out_brut_path = map_dir / "bruts" / f"base_{asset_name}.png"
    out_canopy_path = map_dir / "bruts" / "canopee_arbres_top.png"
    out_ref_path = map_dir / "references" / f"ref_canon_{asset_name}.png"

    if mode == "zekrom_electric":
        raw_sheet = map_dir / "bruts" / "decor_zekrom_taiga_basalte_magenta.png"
    else:
        raw_sheet = map_dir / "bruts" / "decor_reshiram_vallon_dore_magenta.png"

    rgb_hi = np.asarray(Image.open(raw_sheet).convert("RGB"), dtype=np.uint8)
    rf, gf, bf = rgb_hi[:, :, 0].astype(np.float32), rgb_hi[:, :, 1].astype(np.float32), rgb_hi[:, :, 2].astype(np.float32)

    # Graine #FF00FF stricte (uniquement le lit de la rivière/ruisseau) + absorption de toute frange rose/prune
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

    rgb_768, solid_768 = _downsample_non_mixing(rgb_hi, solid_hi, W, H)
    yy, xx = np.mgrid[0:H, 0:W]

    # Purge post-downsampling de toute micro-frange rose/prune résiduelle en bordure d'eau
    for _ in range(3):
        mag_cur = ~solid_768
        adj = ndimage.binary_dilation(mag_cur, iterations=1) & solid_768
        r7, g7, b7 = rgb_768[:, :, 0].astype(np.int16), rgb_768[:, :, 1].astype(np.int16), rgb_768[:, :, 2].astype(np.int16)
        fringe = adj & (
            ((r7 > g7 + 22) & (b7 > g7 + 14))
            | ((r7 >= 185) & (r7 > g7 + 35) & (b7 >= 115))
        )
        if not np.any(fringe):
            break
        solid_768 = solid_768 & (~fringe)

    # Garantie stricte : ZÉRO pixel de ciel visible (toute la moitié Nord y < 275 est 100 % roche/terrain solide)
    top_hole = (~solid_768) & (yy < 275)
    if np.any(top_hole):
        _, n_idx = ndimage.distance_transform_edt(~solid_768, return_indices=True)
        hy, hx = np.where(top_hole)
        rgb_768[hy, hx] = rgb_768[n_idx[0, hy, hx], n_idx[1, hy, hx]]
        solid_768[top_hole] = True

    rgb_768 = _sanitize_rgb_no_magenta(rgb_768, solid_768)
    mag_768 = ~solid_768
    quantized = quantize_non_magenta_mediancut(rgb_768, mag_768, n_colors=96)
    mag_final = (quantized[:, :, 0] == 255) & (quantized[:, :, 1] == 0) & (quantized[:, :, 2] == 255)

    # Extraction de la canopée supérieure des arbres (`Layer 09 Top`) spécifique à chaque biome
    r_q = quantized[:, :, 0].astype(np.int16)
    g_q = quantized[:, :, 1].astype(np.int16)
    b_q = quantized[:, :, 2].astype(np.int16)

    if mode == "zekrom_electric":
        # Cimes coniques des sapins bleutés de taïga sur les bordures Ouest/Est/Sud (hors rochers gris & cristaux cyan)
        tree_zone = (yy >= 292) & ((xx < 146) | (xx > W - 146) | ((yy >= 492) & (np.abs(xx - 384) > 84)))
        is_crystal = (b_q >= 195) & (g_q >= 145) & (r_q <= 105)
        is_grey_boulder = (np.abs(r_q - g_q) <= 18) & (np.abs(g_q - b_q) <= 22) & (r_q >= 68)
        is_moor_grass = (g_q >= 96) & (np.abs(g_q - b_q) <= 18) & (r_q >= 44) & (r_q <= 76)
        is_foliage = (~mag_final) & tree_zone & (~is_crystal) & (~is_grey_boulder) & (~is_moor_grass) & (b_q >= 42) & (r_q <= 58)
    else:
        # Couronnes dorées/ambrées/rousses des bouleaux et érables d'automne (hors troncs blancs de bouleau & herbe jaune)
        tree_zone = (yy >= 170) & ((xx < 168) | (xx > W - 168) | ((yy >= 492) & (np.abs(xx - 384) > 84)))
        is_birch_trunk = (r_q >= 180) & (g_q >= 175) & (b_q >= 165)
        is_autumn_meadow = (r_q >= 175) & (r_q <= 225) & (g_q >= 168) & (g_q <= 205) & (b_q <= 58)
        is_cliff_ivory = (yy < 245) & (r_q >= 210) & (g_q >= 175) & (b_q >= 110)
        is_foliage = (
            (~mag_final)
            & tree_zone
            & (~is_birch_trunk)
            & (~is_autumn_meadow)
            & (~is_cliff_ivory)
            & (r_q >= 115)
            & (r_q > b_q + 55)
        )

    below_non_foliage = ndimage.binary_dilation(
        ~is_foliage,
        structure=np.array([[0, 1, 0], [0, 1, 0], [0, 0, 0]], dtype=bool),
        iterations=8,
    )
    canopy_top = ndimage.binary_opening(is_foliage & (~below_non_foliage), iterations=1)
    canopy_rgba = np.zeros((H, W, 4), dtype=np.uint8)
    canopy_rgba[canopy_top, :3] = quantized[canopy_top]
    canopy_rgba[canopy_top, 3] = 255

    # Référence canonique composite `768×576` : terrain 0% ciel + eau claire native Metano Town `(131, 218, 230)`
    ref_preview = quantized.copy()
    ref_preview[mag_final] = (131, 218, 230)

    out_brut_path.parent.mkdir(parents=True, exist_ok=True)
    out_canopy_path.parent.mkdir(parents=True, exist_ok=True)
    out_ref_path.parent.mkdir(parents=True, exist_ok=True)
    Image.fromarray(quantized, mode="RGB").save(out_brut_path)
    Image.fromarray(canopy_rgba, mode="RGBA").save(out_canopy_path)
    Image.fromarray(ref_preview, mode="RGB").save(out_ref_path)
    return {
        "brut": out_brut_path,
        "canopy": out_canopy_path,
        "ref_canon": out_ref_path,
    }


def assemble_sommet_mont_thunder_cyclone(
    mode: str,
    map_dir: Path,
    asset_name: str,
) -> dict[str, Path]:
    """Construit le brut `768×576` de `ZKA1` ou `RSA1` depuis `decor_sommet_genere_magenta.png`."""
    out_brut_path = map_dir / "bruts" / f"base_{asset_name}.png"
    out_ref_path = map_dir / "references" / f"ref_canon_{asset_name}.png"
    rgb_hi = np.asarray(Image.open(MASTER_SOMMET_GEN).convert("RGB"), dtype=np.uint8)
    mag_hi = key_magenta_hi_res(rgb_hi, dilate_fringe=3)

    rgb_768, mag_768 = downsample_non_mixing(rgb_hi, mag_hi, W, H, mag_vote_ratio=0.50)

    # Sceller tout éventuel micro-trou interne au plateau rocheux
    rock_768 = ndimage.binary_fill_holes(~mag_768)
    # Garder uniquement la composante connexe principale du sommet + escalier Sud
    lbl, n_c = ndimage.label(rock_768)
    if n_c > 1:
        sizes = ndimage.sum(rock_768, lbl, range(1, n_c + 1))
        rock_768 = lbl == (int(np.argmax(sizes)) + 1)
    mag_768 = ~rock_768

    tinted = _tint_palette_entries(rgb_768, mag_768, mode=mode, scene="sommet")
    quantized = quantize_non_magenta_mediancut(tinted, mag_768, n_colors=96)
    mag_final = (quantized[:, :, 0] == 255) & (quantized[:, :, 1] == 0) & (quantized[:, :, 2] == 255)

    # Référence canonique 256x256 respectant le ratio exact ~49 % cyclone natif (`V38P07A` / `H19P01`) + ~51 % sommet
    ref_canon = np.zeros((256, 256, 3), dtype=np.uint8)
    if mode == "zekrom_electric":
        v38_full = np.asarray(
            Image.open(
                REPO_ROOT
                / "source"
                / "zekrom_sommet_tornade_v1"
                / "references"
                / "v38p07a_storm_peak_electric_glow_native.png"
            ).convert("RGB")
        )
        v38_active = Image.fromarray(v38_full[:166, :]).resize((256, 128), Image.Resampling.NEAREST)
        ref_canon[:128, :] = np.asarray(v38_active, dtype=np.uint8)
    else:
        h19_full = np.asarray(
            Image.open(
                REPO_ROOT / "source" / "mont_brasier_sommet_v1" / "references" / "h19p01_moltres_crater_native.png"
            ).convert("RGB")
        )
        h19_core = Image.fromarray(h19_full[96:224, 148:308]).resize((256, 128), Image.Resampling.NEAREST)
        ref_canon[:128, :] = np.asarray(h19_core, dtype=np.uint8)

    # Moitié basse (50 %) : plateau central du sommet Mt. Thunder quantifié
    rock_crop = Image.fromarray(quantized[120:376, 160:608]).resize((256, 128), Image.Resampling.NEAREST)
    rock_arr = np.asarray(rock_crop, dtype=np.uint8).copy()
    rc_mag = (rock_arr[:, :, 0] == 255) & (rock_arr[:, :, 1] == 0) & (rock_arr[:, :, 2] == 255)
    rock_arr[rc_mag] = (32, 54, 92) if mode == "zekrom_electric" else (128, 48, 24)
    ref_canon[128:, :] = rock_arr

    out_brut_path.parent.mkdir(parents=True, exist_ok=True)
    out_ref_path.parent.mkdir(parents=True, exist_ok=True)
    Image.fromarray(quantized, mode="RGB").save(out_brut_path)
    Image.fromarray(ref_canon, mode="RGB").save(out_ref_path)
    return {
        "brut": out_brut_path,
        "ref_canon": out_ref_path,
    }
