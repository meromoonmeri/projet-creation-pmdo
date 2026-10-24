#!/usr/bin/env python3
"""Moteur partagé pixel-art 1x Chunsoft / Halcyon PMDO 0.8.12.0 pour les duos
légendaires d'Unys (Zekrom & Reshiram) :

1. Entrées Montagne + Clairière Tiny Woods / Sky Peak Prairie + Rivière Metano Town :
   - Décodage natif sans perte des banques `.tile` de Metano Town (`Metano_Town_River_Animation_1..4`,
     `Metano_Town_River_Sparkles`, `Metano_Town_Animation_Tileset`, `Metano_Town_Base`, `Metano_Town_Objects`).
   - Rivière turquoise animée 4 phases + courant harmonique impair + cascades à rondins 4 phases + reflets
     scintillants (`Sparkles`) + fleurs animées Sky Peak Prairie / Metano Town.
   - Ciel d'horizon montagneux animé (orage électrique Zekrom / aurore de flamme blanche Reshiram).

2. Sommets naturels style Mt. Thunder Summit au cœur d'un Cyclone Cylindrique 3D 360° :
   - Géométrie cylindrique creuse 3D vue en perspective 3/4 PMD (`cx = 384`, `R_cyl`, inclinaison caméra) :
     * Paroi interne arrière concave défilant de Gauche -> Droite avec raccourci perspectif sur les flancs,
     * Colonnes tangentielles Ouest & Est refermant le cylindre verticalement autour du pic rocheux,
     * Gouffre elliptique au fond de l'œil sous la montagne,
     * Rubans hélicoïdaux d'énergie + éclairs ramifiés (`zekrom_electric`) ou Flamme Blanche / Flamme Bleue
       + braises matérielles GBA `W04` / `H19P01` (`reshiram_white_flame`),
     * Lèvre supérieure et coins avant en surplomb (`DrawLayer.Top`) défilant en sens inverse (Droite -> Gauche)
       pour créer la parallaxe cylindrique 3D tout en laissant le plateau central 100 % dégagé.

Contraintes strictes :
- Zéro dégradé flou : quantification par palettes étagées Chunsoft + matrice de Bayer 4x4.
- Alpha strictement binaire `{0, 255}`.
- Zéro fuite magenta `#FF00FF` (`min(R, B) - G < 35` garanti partout).
- Harmoniques temporelles impaires (`w in {1, 3}`) sur 24 poses (`pose 0 != pose 12`, boucle `23 -> 0` continue).
"""
from __future__ import annotations

import io
import math
import struct
from pathlib import Path

import numpy as np
from PIL import Image
from scipy import ndimage

from source.moteur_gba_pmd_red_natif import build_gba_weather_overlay_frames

REPO_ROOT = Path(__file__).resolve().parents[1]

W, H = 768, 576
N_POSES = 24
FRAME_LEN = 5  # 24 * 5 = 120 ticks = 2.0 s @ 60 FPS

BAYER_4X4 = (
    np.array(
        [
            [0, 8, 2, 10],
            [12, 4, 14, 6],
            [3, 11, 1, 9],
            [15, 7, 13, 5],
        ],
        dtype=np.float32,
    )
    / 16.0
    - 0.5
)


def decode_pmdo_tile(path: Path) -> Image.Image:
    """Décode sans perte un fichier `.tile` PMDO 8x8 en image RGBA."""
    raw = path.read_bytes()
    size, n = struct.unpack_from("<II", raw, 0)
    if size != 8:
        raise ValueError(f"Taille de tuile inattendue {size} dans {path}")
    records = [struct.unpack_from("<IIQ", raw, 8 + 16 * i) for i in range(n)]
    width = (max(x for x, _, _ in records) + 1) * 8
    height = (max(y for _, y, _ in records) + 1) * 8
    im = Image.new("RGBA", (width, height), (0, 0, 0, 0))
    cache: dict[int, Image.Image] = {}
    for x, y, offset in records:
        tile = cache.get(offset)
        if tile is None:
            length = struct.unpack_from("<q", raw, offset)[0]
            tile = Image.open(io.BytesIO(raw[offset + 8 : offset + 8 + length])).convert("RGBA")
            # Convertir toute pré-multiplication éventuelle en RGBA franc binaire
            arr = np.array(tile, dtype=np.uint8)
            a = arr[:, :, 3]
            partial = (a > 0) & (a < 255)
            if np.any(partial):
                af = a[partial].astype(np.float32)
                for c in range(3):
                    arr[:, :, c][partial] = np.clip(
                        np.round(arr[:, :, c][partial].astype(np.float32) * 255.0 / af), 0, 255
                    ).astype(np.uint8)
            arr[:, :, 3] = np.where(a >= 128, 255, 0).astype(np.uint8)
            arr[arr[:, :, 3] == 0] = 0
            tile = Image.fromarray(arr)
            cache[offset] = tile
        im.paste(tile, (x * 8, y * 8))
    return im


def sanitize_rgba_binary(rgba: np.ndarray) -> np.ndarray:
    """Force l'alpha binaire `{0, 255}` et neutralise tout pixel proche de `#FF00FF`."""
    out = rgba.astype(np.uint8, copy=True)
    opaque = out[:, :, 3] >= 128
    out[:, :, 3] = np.where(opaque, 255, 0).astype(np.uint8)
    out[~opaque] = 0
    r = out[:, :, 0].astype(np.int16)
    g = out[:, :, 1].astype(np.int16)
    b = out[:, :, 2].astype(np.int16)
    gap = np.minimum(r, b) - g
    risky = opaque & (gap >= 34)
    if np.any(risky):
        boost = ((gap - 30) // 2 + 4).clip(4, 120)
        out[:, :, 1] = np.where(risky, np.clip(g + boost, 0, 255), g).astype(np.uint8)
        r2 = out[:, :, 0].astype(np.int16)
        g2 = out[:, :, 1].astype(np.int16)
        b2 = out[:, :, 2].astype(np.int16)
        still = opaque & ((np.minimum(r2, b2) - g2) >= 34)
        if np.any(still):
            out[:, :, 0] = np.where(still, np.minimum(r2, g2 + 24), r2).astype(np.uint8)
    return out


def palette_lookup_dithered(
    val: np.ndarray,
    palette_rgb: list[tuple[int, int, int]],
    bayer_grid: np.ndarray,
    dither_strength: float = 0.68,
) -> np.ndarray:
    """Quantifie un champ `[0..1]` sur une rampe Chunsoft discrète avec tramage Bayer."""
    n = len(palette_rgb)
    pal = np.asarray(palette_rgb, dtype=np.uint8)
    scaled = np.clip(val, 0.0, 1.0) * (n - 1) + bayer_grid * dither_strength
    idx = np.clip(np.rint(scaled).astype(np.int32), 0, n - 1)
    return pal[idx]


def draw_pixel_bolt_rgba(
    canvas: np.ndarray,
    pts: list[tuple[int, int]],
    core_rgb: tuple[int, int, int],
    halo_rgb: tuple[int, int, int],
    core_half_w: int = 1,
    halo_half_w: int = 2,
) -> None:
    """Trace un éclair ou filament énergétique pixel-art franc (coeur + halo binaire)."""
    h, w = canvas.shape[:2]
    for (x0, y0), (x1, y1) in zip(pts[:-1], pts[1:]):
        steps = max(abs(x1 - x0), abs(y1 - y0), 1)
        xs = np.round(np.linspace(x0, x1, steps + 1)).astype(np.int32)
        ys = np.round(np.linspace(y0, y1, steps + 1)).astype(np.int32)
        for px, py in zip(xs, ys):
            if py + halo_half_w < 0 or py - halo_half_w >= h or px + halo_half_w < 0 or px - halo_half_w >= w:
                continue
            y_lo, y_hi = max(0, int(py) - halo_half_w), min(h, int(py) + halo_half_w + 1)
            x_lo, x_hi = max(0, int(px) - halo_half_w), min(w, int(px) + halo_half_w + 1)
            if y_hi <= y_lo or x_hi <= x_lo:
                continue
            sub = canvas[y_lo:y_hi, x_lo:x_hi]
            empty = sub[:, :, 3] == 0
            sub[empty, 0] = halo_rgb[0]
            sub[empty, 1] = halo_rgb[1]
            sub[empty, 2] = halo_rgb[2]
            sub[empty, 3] = 255
        for px, py in zip(xs, ys):
            if py + core_half_w < 0 or py - core_half_w >= h or px + core_half_w < 0 or px - core_half_w >= w:
                continue
            y_lo, y_hi = max(0, int(py) - core_half_w), min(h, int(py) + core_half_w + 1)
            x_lo, x_hi = max(0, int(px) - core_half_w), min(w, int(px) + core_half_w + 1)
            if y_hi <= y_lo or x_hi <= x_lo:
                continue
            canvas[y_lo:y_hi, x_lo:x_hi, 0] = core_rgb[0]
            canvas[y_lo:y_hi, x_lo:x_hi, 1] = core_rgb[1]
            canvas[y_lo:y_hi, x_lo:x_hi, 2] = core_rgb[2]
            canvas[y_lo:y_hi, x_lo:x_hi, 3] = 255


# ============================================================================
# 1. ENTRÉES : RIVIÈRE METANO TOWN + FLEURS SKY PEAK + CIEL D'HORIZON MONTAGNE
# ============================================================================


def extract_metano_water_and_flower_assets() -> dict[str, object]:
    """Extrait à l'échelle 1x native le rideau de cascade périodique, l'écume de pied de cascade,
    les grappes `Metano_Town_River_Sparkles` (4 phases) et les fleurs de Metano Town & Sky Peak."""
    eau_dir = REPO_ROOT / "source" / "eau_metano" / "natifs"
    anim_sheet = np.array(decode_pmdo_tile(eau_dir / "Metano_Town_Animation_Tileset.tile"))
    sparkles_sheet = np.array(decode_pmdo_tile(eau_dir / "Metano_Town_River_Sparkles.tile"))

    # 1. Quatre frames natives de la cascade Metano Town (64 x 136 px chacune) + rideau périodique fluide (48 x 48 px)
    cascades = []
    for i in range(4):
        crop = anim_sheet[496:632, 8 + 72 * i : 72 + 72 * i].copy()
        cascades.append(sanitize_rgba_binary(crop))

    # Rideau d'eau vive continu sans buse en bois (lignes 36..132, colonnes 8..56) rendu périodique sur FALL_P=48 px
    c1_sub = cascades[1][36:132, 8:56]
    c1_rgb = c1_sub[:, :, :3].astype(np.float32)
    casc_pal = np.unique(c1_sub[c1_sub[:, :, 3] > 0][:, :3], axis=0).astype(np.float32)
    fall_p, fall_b = 48, 16
    t_strip = c1_rgb[0:fall_p].copy()
    for k in range(fall_b):
        w_b = k / float(fall_b)
        t_strip[k] = (1.0 - w_b) * c1_rgb[fall_p + k] + w_b * t_strip[k]
    cascade_fluid_strip = casc_pal[
        ((t_strip[:, :, None, :] - casc_pal[None, None, :, :]) ** 2).sum(-1).argmin(-1)
    ].astype(np.uint8)

    # 2. Écume officielle de pied de cascade Metano Town (3 frames dans Metano_Town_Animation_Tileset y=378..434)
    # Réduction exacte par blocs 2x2 vers l'échelle 1x (51 x 28 px) recalée sur la palette native 8 couleurs d'écume
    foam_raws = [
        anim_sheet[378:434, 18:120],
        anim_sheet[378:434, 178:280],
        anim_sheet[378:434, 320:422],
    ]
    foam_pal = np.unique(foam_raws[0][foam_raws[0][:, :, 3] > 0][:, :3], axis=0).astype(np.float32)
    metano_cascade_foam_3: list[np.ndarray] = []
    for fr in foam_raws:
        cov = (fr[:, :, 3] > 0).reshape(28, 2, 51, 2).mean((1, 3))
        rgb_sum = (fr[:, :, :3].astype(np.float32) * (fr[:, :, 3:4] > 0)).reshape(28, 2, 51, 2, 3).sum((1, 3))
        cnt = np.maximum((fr[:, :, 3:4] > 0).reshape(28, 2, 51, 2, 1).sum((1, 3)), 1.0)
        avg = rgb_sum / cnt
        f_out = np.zeros((28, 51, 4), dtype=np.uint8)
        keep_f = cov >= 0.5
        f_out[keep_f, :3] = foam_pal[
            ((avg[:, :, None, :] - foam_pal[None, None, :, :]) ** 2).sum(-1).argmin(-1)
        ][keep_f].astype(np.uint8)
        f_out[keep_f, 3] = 255
        metano_cascade_foam_3.append(sanitize_rgba_binary(f_out))

    # 3. Grappes natives `Metano_Town_River_Sparkles.tile` (4 phases @ 10 ticks dans `metano_town.rsground`)
    m_surface = np.array([131, 218, 230], dtype=np.int16)

    def _sparkle_cluster(cols: list[int], rows: list[int], step: int) -> list[np.ndarray]:
        seq: list[np.ndarray] = []
        for k in range(4):
            a = np.zeros((len(rows) * 8, len(cols) * 8, 4), dtype=np.uint8)
            for j, r_idx in enumerate(rows):
                for i, c_idx in enumerate(cols):
                    sy, sx = (r_idx + step * k) * 8, c_idx * 8
                    a[j * 8 : (j + 1) * 8, i * 8 : (i + 1) * 8] = sparkles_sheet[sy : sy + 8, sx : sx + 8]
            # Retirer uniquement l'aplat turquoise de surface pour isoler les scintillements natifs Metano
            keep_sp = (a[:, :, 3] == 255) & (
                np.abs(a[:, :, :3].astype(np.int16) - m_surface[None, None, :]).sum(axis=2) > 6
            )
            a[~keep_sp] = 0
            seq.append(sanitize_rgba_binary(a))
        return seq

    sparkle_clusters = [
        _sparkle_cluster([0, 1], [0, 1, 2], 3),      # A_16x24
        _sparkle_cluster([2, 3, 4], [0, 1], 2),      # B_24x16
        _sparkle_cluster([0, 1], [12, 13, 14, 15], 4),  # C_16x32
    ]

    # 4. Fleurs animées 3 phases de Metano_Town_Animation_Tileset (touffes colorées & blanches)
    metano_flowers_color = [
        sanitize_rgba_binary(anim_sheet[32:56, 8 + 40 * i : 32 + 40 * i].copy())
        for i in range(3)
    ]
    metano_flowers_white = [
        sanitize_rgba_binary(anim_sheet[96:128, 8 + 40 * i : 32 + 40 * i].copy())
        for i in range(3)
    ]

    # 5. Fleurs corail 1x de Sky Peak Prairie (`skypeak_decoupe_x2.png[::2, ::2]`)
    sk_1x = np.array(
        Image.open(REPO_ROOT / "source" / "zone_zero_v2" / "reference" / "skypeak_decoupe_x2.png").convert("RGBA")
    )[::2, ::2]
    patch = sk_1x[12:44, 94:122].copy()
    r, g, b = patch[:, :, 0].astype(np.int16), patch[:, :, 1].astype(np.int16), patch[:, :, 2].astype(np.int16)
    petal = (r > 175) & (r > b + 15)
    stem = ndimage.binary_dilation(petal, iterations=1) & (g < 210)
    keep = petal | stem
    base_sk_flower = np.zeros_like(patch)
    base_sk_flower[keep] = patch[keep]
    base_sk_flower[keep, 3] = 255
    base_sk_flower = sanitize_rgba_binary(base_sk_flower)
    skypeak_flower_4 = []
    for dx in (0, 1, 0, -1):
        shifted = np.zeros_like(base_sk_flower)
        if dx == 0:
            shifted[:] = base_sk_flower
        elif dx > 0:
            shifted[:, dx:] = base_sk_flower[:, :-dx]
        else:
            shifted[:, :dx] = base_sk_flower[:, -dx:]
        skypeak_flower_4.append(shifted)

    return {
        "cascades_4": cascades,
        "cascade_fluid_strip": cascade_fluid_strip,
        "metano_cascade_foam_3": metano_cascade_foam_3,
        "sparkle_clusters": sparkle_clusters,
        "metano_flowers_color_4": [
            metano_flowers_color[0],
            metano_flowers_color[1],
            metano_flowers_color[2],
            metano_flowers_color[1],
        ],
        "metano_flowers_white_4": [
            metano_flowers_white[0],
            metano_flowers_white[1],
            metano_flowers_white[2],
            metano_flowers_white[1],
        ],
        "skypeak_flower_4": skypeak_flower_4,
    }


def build_metano_river_and_skypeak_layers(
    water_mask: np.ndarray,
    cascade_origins: list[tuple[int, int]],
    flower_sites: list[tuple[int, int, str, int]],
    bridge_mask: np.ndarray | None = None,
    generated_flower_rgba: np.ndarray | None = None,
) -> tuple[list[Image.Image], list[Image.Image], list[Image.Image]]:
    """Construit les 3 calques animés 24 poses de la clairière & rivière Metano Town :
    - `river_frames` : animation exacte de la rivière de Metano Town (4 phases @ 10 ticks, palette exacte
      `Metano_Town_River_Animation_1..4` SANS aucune écume sur la rivière ni les berges) + rideaux de
      cascades fluides défilant en continu à chaque pose (24 poses @ 5 ticks).
    - `sparkle_frames` : grappes scintillantes natives `Metano_Town_River_Sparkles` (4 phases @ 10 ticks)
      sur la rivière ouverte uniquement (zéro écume sur la rivière).
    - `flower_frames` : uniquement l'écume officielle Metano Town en bas des cascades (`Metano_Town_Animation_Tileset`)
      + fleurs Sky Peak Prairie ondulant dans la brise.
    """
    assets = extract_metano_water_and_flower_assets()
    cascade_strip: np.ndarray = assets["cascade_fluid_strip"]  # type: ignore[assignment]
    foam_3: list[np.ndarray] = assets["metano_cascade_foam_3"]  # type: ignore[assignment]
    sp_clusters: list[list[np.ndarray]] = assets["sparkle_clusters"]  # type: ignore[assignment]

    yy, xx = np.mgrid[0:H, 0:W].astype(np.float32)

    visible_water = water_mask.copy()
    if bridge_mask is not None:
        visible_water_open = water_mask & (~bridge_mask)
    else:
        visible_water_open = water_mask

    # Distance aux rives ouvertes + champ organique reproductible pour l'animation 4 phases de Metano Town
    # (exactement la formulation canonique sans `clair`, donc ZÉRO trait blanc d'écume contre les rives !)
    river_only_open = visible_water_open & (yy >= 175)
    dist_bank = ndimage.distance_transform_edt(visible_water_open)
    jag_raw = ndimage.gaussian_filter(np.random.default_rng(9).random((H, W)), 1.0)
    jag = (jag_raw - jag_raw.min()) / max(float(np.ptp(jag_raw)), 1e-6)

    # Palette exacte mesurée sur `Metano_Town_River_Animation_1..4.tile` (sans `clair` d'écume)
    pal_surface = (131, 218, 230, 255)
    pal_bande = (87, 135, 191, 255)
    pal_inter = (95, 183, 207, 255)
    pal_accent = (111, 207, 231, 255)

    # Profil de vitesse continu du rideau de cascade Metano (période 48 px -> raccord 23->0 exact) :
    # rubans centraux à 4 px/pose (48 px/s) et rubans latéraux à 2 px/pose (24 px/s, harmonique impaire w=1)
    fall_p = cascade_strip.shape[0]
    cw = cascade_strip.shape[1]
    ch = 110
    cols_idx = np.arange(cw, dtype=np.int32)
    rib_idx = cols_idx // 3
    speed_col = np.where(np.abs(cols_idx - (cw // 2)) <= 9, 4, 2).astype(np.int32)
    phase_col = ((rib_idx * 6) % fall_p).astype(np.int32)
    rows_rel = np.arange(ch, dtype=np.int32)[:, None]

    # Placement déterministe sans chevauchement des grappes natives `Metano_Town_River_Sparkles`
    # sur le lit calme de la rivière (hors berges et hors vasques de pied de cascade)
    cascade_centers_x = [cx0 + (cw // 2) for cx0, _ in cascade_origins]
    taken_sp = np.zeros((H, W), dtype=bool)
    sparkle_sites: list[tuple[int, int, int, int]] = []
    rng_sp = np.random.default_rng(42)
    cands_sp = [(sy, sx) for sy in range(184, 268, 8) for sx in range(16, W - 32, 8)]
    rng_sp.shuffle(cands_sp)
    for sy, sx in cands_sp:
        fam_idx = len(sparkle_sites) % len(sp_clusters)
        sh_h, sh_w = sp_clusters[fam_idx][0].shape[:2]
        if sy + sh_h > H - 8 or sx + sh_w > W - 8:
            continue
        cx_sp = sx + sh_w // 2
        if any(abs(cx_sp - gx) < 38 and sy < 210 for gx in cascade_centers_x):
            continue
        if (
            river_only_open[sy : sy + sh_h, sx : sx + sh_w].all()
            and float(dist_bank[sy : sy + sh_h, sx : sx + sh_w].min()) >= 6.5
            and not taken_sp[max(0, sy - 6) : sy + sh_h + 6, max(0, sx - 8) : sx + sh_w + 8].any()
        ):
            taken_sp[sy : sy + sh_h, sx : sx + sh_w] = True
            sparkle_sites.append((sx, sy, fam_idx, len(sparkle_sites) % 4))
            if len(sparkle_sites) >= 22:
                break

    river_out: list[Image.Image] = []
    sparkle_out: list[Image.Image] = []
    flower_out: list[Image.Image] = []

    for pose in range(N_POSES):
        theta = 2.0 * math.pi * pose / N_POSES
        # Cadence exacte de `metano_town.rsground` : 4 phases x 10 ticks (= 2 poses de 5 ticks, w=3 sur 120 ticks)
        r_phase = (pose // 2) % 4
        ph = 2.0 * math.pi * r_phase / 4.0

        # --- Calque A : Rivière Metano Town (sans écume) + Cascades fluides (progression à chaque pose) ---
        n_wave = 0.6 * np.sin(yy * 0.23 + xx * 0.08 - ph) + 0.4 * np.sin(yy * 0.09 - xx * 0.19 + 1.3 - ph)
        t_bevel = 4.5 + 1.1 * n_wave
        jr = np.roll(jag, r_phase * 2, axis=0)
        fringe = t_bevel + 0.6 + 2.6 * jr

        riv = np.zeros((H, W, 4), dtype=np.uint8)
        riv[visible_water] = pal_surface
        riv[visible_water & (dist_bank <= fringe)] = pal_inter
        riv[visible_water & (dist_bank <= fringe) & (jr > 0.62)] = pal_accent
        riv[visible_water & (dist_bank <= t_bevel)] = pal_inter
        riv[visible_water & (dist_bank <= t_bevel - 1.0)] = pal_bande
        riv[visible_water & (~visible_water_open)] = pal_bande

        # Rideau d'eau fluide Metano défilant vers le bas à chaque pose dans les 2 gorges rocheuses
        y_lookup = (rows_rel - pose * speed_col[None, :] + phase_col[None, :]) % fall_p
        curtain_rgb = cascade_strip[y_lookup, cols_idx[None, :]]
        for cx0, cy0 in cascade_origins:
            use_h = min(ch, H - cy0)
            use_w = min(cw, W - cx0)
            sub_vis = visible_water[cy0 : cy0 + use_h, cx0 : cx0 + use_w]
            dst = riv[cy0 : cy0 + use_h, cx0 : cx0 + use_w]
            dst[sub_vis, :3] = curtain_rgb[:use_h, :use_w][sub_vis]
            dst[sub_vis, 3] = 255

        river_out.append(Image.fromarray(sanitize_rgba_binary(riv)))

        # --- Calque B : Uniquement les grappes natives `Metano_Town_River_Sparkles` (zéro écume sur la rivière) ---
        spk = np.zeros((H, W, 4), dtype=np.uint8)
        for sx, sy, fam_idx, ph_off in sparkle_sites:
            sp_frame = (r_phase + ph_off) % 4
            sp_img = sp_clusters[fam_idx][sp_frame]
            sh_h, sh_w = sp_img.shape[:2]
            sub_vis = river_only_open[sy : sy + sh_h, sx : sx + sh_w]
            m = (sp_img[:, :, 3] > 0) & sub_vis
            dst = spk[sy : sy + sh_h, sx : sx + sh_w]
            dst[m] = sp_img[m]

        sparkle_out.append(Image.fromarray(sanitize_rgba_binary(spk)))

        # --- Calque C : Écume officielle Metano Town uniquement en bas des cascades + Fleurs Sky Peak ---
        flw = np.zeros((H, W, 4), dtype=np.uint8)
        for k_c, (cx0, cy0) in enumerate(cascade_origins):
            foam_idx = [0, 1, 2, 1][(r_phase + k_c) % 4]
            f_spr = foam_3[foam_idx]
            fh_s, fw_s = f_spr.shape[:2]
            fx0 = cx0 + (cw // 2) - (fw_s // 2)
            fy0 = cy0 + 95
            if 0 <= fx0 and fx0 + fw_s <= W and 0 <= fy0 and fy0 + fh_s <= H:
                mf = f_spr[:, :, 3] > 0
                flw[fy0 : fy0 + fh_s, fx0 : fx0 + fw_s][mf] = f_spr[mf]

        if generated_flower_rgba is not None:
            # Ondulation douce 1 px par bandes spatiales (harmonique impaire w=1 -> pose 0 != pose 12)
            sway_l = int(round(math.sin(theta)))
            sway_r = int(round(math.sin(theta + 1.6)))
            src_f = generated_flower_rgba
            for half_mask_x, dx_s in [((slice(None), slice(0, 384)), sway_l), ((slice(None), slice(384, W)), sway_r)]:
                sub_src = src_f[half_mask_x]
                if dx_s == 0:
                    sub_shifted = sub_src
                elif dx_s > 0:
                    sub_shifted = np.zeros_like(sub_src)
                    sub_shifted[:, dx_s:] = sub_src[:, :-dx_s]
                else:
                    sub_shifted = np.zeros_like(sub_src)
                    sub_shifted[:, :dx_s] = sub_src[:, -dx_s:]
                mf_gen = sub_shifted[:, :, 3] > 0
                flw[half_mask_x][mf_gen] = sub_shifted[mf_gen]

        for fx, fy, kind, phase_off in flower_sites:
            f_phase = ((pose + phase_off * 3) // 6) % 4
            bank = assets[kind]  # type: ignore[index]
            spr: np.ndarray = bank[f_phase]  # type: ignore[index]
            fh, fw = spr.shape[:2]
            if 0 <= fx and fx + fw <= W and 0 <= fy and fy + fh <= H:
                m = spr[:, :, 3] > 0
                dst = flw[fy : fy + fh, fx : fx + fw]
                dst[m] = spr[m]
        flower_out.append(Image.fromarray(sanitize_rgba_binary(flw)))

    return river_out, sparkle_out, flower_out


def _filter_small_ember_sparks(rgba_list: list[Image.Image], max_area: int = 56) -> list[np.ndarray]:
    """Isole uniquement les vraies flammèches/braises GBA `1×` de `W041.bpa` en supprimant les colonnes de rayons solaires."""
    from scipy import ndimage as _ndi

    cleaned: list[np.ndarray] = []
    tpal = np.array(
        [[214, 78, 28], [246, 152, 48], [255, 224, 128], [255, 250, 232]],
        dtype=np.uint8,
    )
    for im in rgba_list:
        arr = np.array(im.convert("RGBA"), dtype=np.uint8)
        mask = arr[:, :, 3] > 0
        lbl, n_comp = _ndi.label(mask)
        if n_comp > 0:
            areas = _ndi.sum(mask, lbl, range(1, n_comp + 1))
            keep_ids = np.where((areas >= 1) & (areas <= max_area))[0] + 1
            keep_mask = np.isin(lbl, keep_ids)
            arr[~keep_mask] = 0
            if np.any(keep_mask):
                lum = arr[keep_mask, :3].max(axis=1).astype(np.int32)
                bins = np.clip((lum * len(tpal)) // 256, 0, len(tpal) - 1)
                arr[keep_mask, :3] = tpal[bins]
                arr[keep_mask, 3] = 255
        cleaned.append(arr)
    return cleaned


def _load_generated_friend_area_sky_and_fx(mode: str) -> dict[str, object]:
    """Charge, détoure (`key()` #FF00FF) et quantifie sans tramage les ciels, éclairs et rayons
    générés style Friend Area PMD Red (`H17P01` Thunder Meadow / `H05P02` Rainbow Peak)."""
    if mode == "zekrom_electric":
        sky_path = REPO_ROOT / "source" / "zekrom_montagne_entree_v1" / "bruts" / "ciel_orageux_pmd_red_genere.png"
        bolt_path = (
            REPO_ROOT / "source" / "zekrom_montagne_entree_v1" / "bruts" / "eclairs_friend_area_pmd_red_magenta.png"
        )
        sky_raw = Image.open(sky_path).convert("RGB")
        # Bande isotrope 1:1 des cumulonimbus d'orage festonnés style H17P01 -> 768x76 MEDIANCUT 20 couleurs
        sky_iso = sky_raw.crop((0, 286, sky_raw.width, 454)).resize((W, 76), Image.Resampling.BOX)
        sky_arr = np.array(
            sky_iso.quantize(colors=20, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE).convert("RGB"),
            dtype=np.uint8,
        )
        # Période horizontale sans couture de 384 px (= 24 poses * 16 px/pose, harmonique impaire w=1)
        sky_pal = np.unique(sky_arr.reshape(-1, 3), axis=0).astype(np.float32)
        half_w = W // 2
        half_strip = sky_arr[:, :half_w].astype(np.float32).copy()
        blend_w = 40
        for k in range(blend_w):
            wk = k / float(blend_w)
            bl = (1.0 - wk) * sky_arr[:, half_w - blend_w + k].astype(np.float32) + wk * sky_arr[:, k].astype(np.float32)
            half_strip[:, k] = bl
            half_strip[:, half_w - blend_w + k] = (
                (1.0 - wk) * sky_arr[:, half_w - blend_w + k].astype(np.float32) + wk * bl
            )
        half_q = sky_pal[((half_strip[:, :, None, :] - sky_pal[None, None, :, :]) ** 2).sum(-1).argmin(-1)].astype(
            np.uint8
        )
        sky_tileable = np.concatenate([half_q, half_q], axis=1)

        # Détourage `key()` #FF00FF de l'éclair ramifié généré style Friend Area PMD Red
        b_raw = np.array(Image.open(bolt_path).convert("RGB"), dtype=np.uint8)
        br, bg_, bb = b_raw[:, :, 0].astype(np.float32), b_raw[:, :, 1].astype(np.float32), b_raw[:, :, 2].astype(np.float32)
        b_mag = (br > 70.0) & (bb > 70.0) & (br > bg_ * 1.45) & (bb > bg_ * 1.45)
        b_fg = ~(b_mag | (ndimage.binary_dilation(b_mag, iterations=2) & (br > bg_ * 1.08) & (bb > bg_ * 1.08)))
        bys, bxs = np.where(b_fg)
        b_mask = b_fg[bys.min() : bys.max() + 1, bxs.min() : bxs.max() + 1]
        b_branches = ndimage.binary_erosion(b_mask, iterations=1)
        hb_src = b_mask.shape[0]
        top_z = np.arange(hb_src)[:, None] < int(0.45 * hb_src)
        b_comb = np.where(
            top_z,
            ndimage.binary_erosion(b_mask, iterations=5)
            | (b_branches & (~ndimage.binary_dilation(ndimage.binary_erosion(b_mask, iterations=9), iterations=5))),
            b_branches,
        )

        def _mk_bolt(target_h: int, flip_x: bool = False, afterglow: bool = False) -> np.ndarray:
            sh_b, sw_b = b_comb.shape[:2]
            tw_b = max(16, int(round(sw_b * target_h / float(sh_b))))
            m_im = Image.fromarray((b_comb * 255).astype(np.uint8)).resize((tw_b, target_h), Image.Resampling.BILINEAR)
            m_s = np.array(m_im) >= (92 if afterglow else 78)
            if flip_x:
                m_s = m_s[:, ::-1]
            core = ndimage.binary_erosion(m_s, iterations=1)
            white = ndimage.binary_erosion(m_s, iterations=2)
            out_b = np.zeros((target_h, tw_b, 4), dtype=np.uint8)
            if afterglow:
                out_b[m_s] = (24, 138, 226, 255)
                out_b[core] = (96, 224, 255, 255)
                out_b[white] = (212, 250, 255, 255)
            else:
                out_b[m_s] = (32, 198, 255, 255)
                out_b[core] = (255, 250, 140, 255)
                out_b[white] = (255, 255, 255, 255)
            return sanitize_rgba_binary(out_b)

        return {
            "sky_strip": sky_tileable,
            "bolt_fg_l": (_mk_bolt(94, False, False), _mk_bolt(94, False, True)),
            "bolt_fg_r": (_mk_bolt(90, True, False), _mk_bolt(90, True, True)),
            "bolt_mid_l": (_mk_bolt(72, False, False), _mk_bolt(72, False, True)),
            "bolt_sky_l": (_mk_bolt(66, False, False), _mk_bolt(66, False, True)),
            "bolt_sky_r": (_mk_bolt(66, True, False), _mk_bolt(66, True, True)),
        }

    sky_path = REPO_ROOT / "source" / "reshiram_montagne_entree_v1" / "bruts" / "ciel_celeste_pmd_red_genere.png"
    ray_path = (
        REPO_ROOT / "source" / "reshiram_montagne_entree_v1" / "bruts" / "rayons_lumiere_friend_area_pmd_red_magenta.png"
    )
    sky_raw = Image.open(sky_path).convert("RGB")
    sky_iso = sky_raw.crop((0, 120, sky_raw.width, 378)).resize((W, 76), Image.Resampling.BOX)
    sky_arr = np.array(
        sky_iso.quantize(colors=24, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE).convert("RGB"),
        dtype=np.uint8,
    )

    ray_raw = np.array(Image.open(ray_path).convert("RGB"), dtype=np.uint8)
    rr, rg, rb = ray_raw[:, :, 0].astype(np.float32), ray_raw[:, :, 1].astype(np.float32), ray_raw[:, :, 2].astype(np.float32)
    ray_mag = (rr > 70.0) & (rb > 70.0) & (rr > rg * 1.35) & (rb > rg * 1.35)
    ray_fg = ~(ray_mag | (ndimage.binary_dilation(ray_mag, iterations=2) & (rr > rg * 1.05) & (rb > rg * 1.05)))
    # Section basse-médiane (y=365..815) où les 5 faisceaux obliques Friend Area sont nettement séparés dès y=0 !
    ray_sub = ray_fg[365:815, 290:1035]
    cov_264 = (
        np.array(
            Image.fromarray((ray_sub * 255).astype(np.uint8)).resize((264, 166), Image.Resampling.BOX),
            dtype=np.float32,
        )
        / 255.0
    )
    return {
        "sky_strip": sky_arr,
        "ray_cov": cov_264,
    }


def build_mountain_horizon_sky_layers(
    mode: str,
    sky_mask: np.ndarray,
    base_rgb: np.ndarray | None = None,
) -> tuple[list[Image.Image], list[Image.Image], list[Image.Image]]:
    """Construit les 3 calques atmosphériques 24 poses à partir des ciels, éclairs et rayons de lumière
    générés style Friend Area PMD Red (`H17P01` orageux pour Zekrom / `H05P02` céleste pour Reshiram)."""
    if mode not in ("zekrom_electric", "reshiram_white_flame"):
        raise ValueError(f"Mode inconnu : {mode}")

    yy, xx = np.mgrid[0:H, 0:W].astype(np.float32)
    bayer01 = BAYER_4X4[np.arange(H)[:, None] % 4, np.arange(W)[None, :] % 4] + 0.5  # dans [0..1]

    # Masque élargi de 4 px sous la crête pour éviter tout interstice sur le ciel
    active_sky = ndimage.binary_dilation(sky_mask, iterations=4)
    ys_sky = np.where(active_sky)[0]
    y_max_sky = min(76, int(ys_sky.max()) + 1 if len(ys_sky) else 72)

    gen = _load_generated_friend_area_sky_and_fx(mode)
    sky_strip: np.ndarray = gen["sky_strip"]  # type: ignore[assignment]

    w04_overlays: list[np.ndarray] = []
    if mode == "reshiram_white_flame":
        raw_w04 = build_gba_weather_overlay_frames(
            "W04",
            W,
            H,
            N_POSES,
            scroll_dx_per_loop=48,
            scroll_dy_per_loop=-48,
        )
        w04_overlays = _filter_small_ember_sparks(raw_w04, max_area=44)

    def _paste_rgba(dst: np.ndarray, spr: np.ndarray, x0: int, y0: int, clip_mask: np.ndarray | None = None) -> None:
        sh_s, sw_s = spr.shape[:2]
        x_lo, y_lo = max(0, x0), max(0, y0)
        x_hi, y_hi = min(W, x0 + sw_s), min(H, y0 + sh_s)
        if x_hi <= x_lo or y_hi <= y_lo:
            return
        sub_s = spr[y_lo - y0 : y_hi - y0, x_lo - x0 : x_hi - x0]
        m = sub_s[:, :, 3] > 0
        if clip_mask is not None:
            m = m & clip_mask[y_lo:y_hi, x_lo:x_hi]
        dst[y_lo:y_hi, x_lo:x_hi][m] = sub_s[m]

    sky_frames: list[Image.Image] = []
    plume_frames: list[Image.Image] = []
    ridge_top_frames: list[Image.Image] = []

    sub_mask = active_sky[:y_max_sky, :]
    sub_xx = xx[:y_max_sky, :]
    sub_yy = yy[:y_max_sky, :]

    for pose in range(N_POSES):
        theta = 2.0 * math.pi * pose / N_POSES

        if mode == "zekrom_electric":
            # --- Calque 0 : Ciel orageux généré style Friend Area H17P01 en défilement continu (16 px/pose, période 384 px) ---
            shift_x = (pose * 16) % (W // 2)
            scrolled_sky = np.roll(sky_strip[:y_max_sky, :], -shift_x, axis=1).copy()

            # Illumination radiale des ourlets cyan des nuages d'orage synchronisée avec les impacts d'éclairs
            flash_centers: list[tuple[float, float]] = []
            if pose in (0, 1, 2):
                flash_centers.extend([(102.0, 1.0 if pose < 2 else 0.5), (636.0, 0.75 if pose < 2 else 0.35)])
            elif pose in (8, 9, 10):
                flash_centers.extend([(652.0, 1.0 if pose < 10 else 0.5), (156.0, 0.75 if pose < 10 else 0.35)])
            elif pose in (16, 17, 18):
                flash_centers.extend([(214.0, 0.85 if pose < 18 else 0.4), (568.0, 0.85 if pose < 18 else 0.4)])

            if flash_centers:
                s_float = scrolled_sky.astype(np.float32)
                rim_px = scrolled_sky[:, :, 2] >= 92
                for fcx, f_str in flash_centers:
                    d2 = (sub_xx - fcx) ** 2 + (sub_yy - 22.0) ** 2
                    falloff = np.clip(1.0 - d2 / (145.0 * 145.0), 0.0, 1.0) * f_str
                    boost_m = rim_px & (falloff > 0.08)
                    s_float[boost_m, 0] = np.clip(s_float[boost_m, 0] + 34.0 * falloff[boost_m], 0, 255)
                    s_float[boost_m, 1] = np.clip(s_float[boost_m, 1] + 56.0 * falloff[boost_m], 0, 255)
                    s_float[boost_m, 2] = np.clip(s_float[boost_m, 2] + 78.0 * falloff[boost_m], 0, 255)
                scrolled_sky = (np.round(s_float / 4.0) * 4.0).clip(0, 255).astype(np.uint8)

            sky = np.zeros((H, W, 4), dtype=np.uint8)
            sky[:y_max_sky, :][sub_mask, :3] = scrolled_sky[sub_mask]
            sky[:y_max_sky, :][sub_mask, 3] = 255
            sky_frames.append(Image.fromarray(sanitize_rgba_binary(sky)))

            # --- Calque 1 (`BG`) : Éclairs ramifiés lointains Friend Area derrière les crêtes ---
            plume = np.zeros((H, W, 4), dtype=np.uint8)
            b_sky_l_main, b_sky_l_glow = gen["bolt_sky_l"]  # type: ignore[misc]
            b_sky_r_main, b_sky_r_glow = gen["bolt_sky_r"]  # type: ignore[misc]
            if pose in (0, 1, 2):
                _paste_rgba(plume, b_sky_r_main if pose < 2 else b_sky_r_glow, 610, 0, clip_mask=active_sky)
            elif pose in (8, 9, 10):
                _paste_rgba(plume, b_sky_l_main if pose < 10 else b_sky_l_glow, 132, 0, clip_mask=active_sky)
            elif pose in (16, 17, 18):
                _paste_rgba(plume, b_sky_l_main if pose < 18 else b_sky_l_glow, 192, 0, clip_mask=active_sky)
                _paste_rgba(plume, b_sky_r_main if pose < 18 else b_sky_r_glow, 542, 0, clip_mask=active_sky)
            plume_frames.append(Image.fromarray(sanitize_rgba_binary(plume)))

            # --- Calque 9 (`Top`) : Grands éclairs ramifiés Friend Area PMD Red frappant les crêtes + étincelles ---
            top_fx = np.zeros((H, W, 4), dtype=np.uint8)
            b_fg_l_main, b_fg_l_glow = gen["bolt_fg_l"]  # type: ignore[misc]
            b_fg_r_main, b_fg_r_glow = gen["bolt_fg_r"]  # type: ignore[misc]
            b_mid_l_main, b_mid_l_glow = gen["bolt_mid_l"]  # type: ignore[misc]
            if pose in (0, 1, 2):
                _paste_rgba(top_fx, b_fg_l_main if pose < 2 else b_fg_l_glow, 68, 0)
            elif pose in (8, 9, 10):
                _paste_rgba(top_fx, b_fg_r_main if pose < 10 else b_fg_r_glow, 624, 0)
            elif pose in (17, 18):
                _paste_rgba(top_fx, b_mid_l_main if pose == 17 else b_mid_l_glow, 224, 0)

            rng = np.random.default_rng(9100)
            base_sparks = rng.integers(0, [W, 136], size=(18, 2))
            for k, (sx0, sy0) in enumerate(base_sparks):
                px = int((sx0 + round(pose * 4 + 5 * math.sin(theta + k))) % W)
                py = int(8 + (sy0 - pose * 3 + k * 7) % 124)
                if 0 <= py < H - 2 and 0 <= px < W - 2:
                    top_fx[py : py + 2, px : px + 2] = (
                        (236, 252, 255, 255) if (k + pose) % 2 == 0 else (72, 198, 255, 255)
                    )
            ridge_top_frames.append(Image.fromarray(sanitize_rgba_binary(top_fx)))

        else:
            # --- Mode `reshiram_white_flame` : Ciel céleste H05P02 + Rayons de lumière style Friend Area PMD Red ---
            # Brise céleste douce (+/- 7 px en cos(theta)) + pulsation BPL dorée-azur (w=1 -> pose 0 != pose 12 franc)
            breeze_dx = int(round(7.0 * math.cos(theta)))
            xs_clamped = np.clip(np.arange(W, dtype=np.int32) - breeze_dx, 0, W - 1)
            cel_sky = sky_strip[:y_max_sky, xs_clamped].astype(np.float32)
            bpl_wave = 14.0 * np.cos(theta - 0.008 * sub_xx) + 4.0 * np.sin(3.0 * theta + 0.04 * sub_yy)
            cel_sky[:, :, 0] = np.clip(cel_sky[:, :, 0] + bpl_wave * 1.15, 0, 255)
            cel_sky[:, :, 1] = np.clip(cel_sky[:, :, 1] + bpl_wave * 0.95, 0, 255)
            cel_sky[:, :, 2] = np.clip(cel_sky[:, :, 2] + bpl_wave * 0.55, 0, 255)
            cel_sky_q = (np.round(cel_sky / 8.0) * 8.0).clip(0, 255).astype(np.uint8)

            sky = np.zeros((H, W, 4), dtype=np.uint8)
            sky[:y_max_sky, :][sub_mask, :3] = cel_sky_q[sub_mask]
            sky[:y_max_sky, :][sub_mask, 3] = 255
            sky_frames.append(Image.fromarray(sanitize_rgba_binary(sky)))

            # --- Calques 1 (`BG` ciel) & 9 (`Top` montagne) : Faisceaux obliques générés style Friend Area PMD Red ---
            ray_cov: np.ndarray = gen["ray_cov"]  # type: ignore[assignment]
            rh_f, rw_f = ray_cov.shape[:2]
            taper_y = np.clip(1.22 - np.arange(rh_f, dtype=np.float32)[:, None] / float(rh_f), 0.0, 1.0)
            breath = 0.96 + 0.14 * math.cos(theta)
            sweep_dx = int(round(12.0 * math.cos(theta)))

            plume = np.zeros((H, W, 4), dtype=np.uint8)
            top_fx = np.zeros((H, W, 4), dtype=np.uint8)

            # Deux éventails symétriques de 5 rayons obliques séparés laissant voir l'azur et les nuages célestes entre chaque rayon !
            for base_rx0 in (8, 492):
                rx0 = max(0, min(W - rw_f, base_rx0 + sweep_dx))
                inten = ray_cov * taper_y * breath
                by_sub = bayer01[0:rh_f, rx0 : rx0 + rw_f]
                in_sky_sub = active_sky[0:rh_f, rx0 : rx0 + rw_f]

                # 1) Dans le ciel (`Layer 01 BG`) : rehaussement additif GBA BLDCNT sur les nuages & l'azur céleste
                sky_h = min(y_max_sky, rh_f)
                in_s = in_sky_sub[:sky_h]
                int_s = inten[:sky_h]
                by_s = by_sub[:sky_h]
                sky_core = in_s & (int_s > 0.42)
                sky_mid = in_s & (~sky_core) & (int_s > 0.20)
                sky_edge = in_s & (~sky_core) & (~sky_mid) & (int_s > 0.10) & ((int_s * 3.0) > by_s)
                base_s = cel_sky_q[:sky_h, rx0 : rx0 + rw_f].astype(np.float32)
                lit_s = base_s.copy()
                lit_s[sky_core] = np.clip(base_s[sky_core] * 0.46 + np.array([255.0, 250.0, 216.0]) * 0.54, 0, 255)
                lit_s[sky_mid] = np.clip(base_s[sky_mid] * 0.68 + np.array([254.0, 243.0, 194.0]) * 0.32, 0, 255)
                lit_s[sky_edge] = np.clip(base_s[sky_edge] * 0.82 + np.array([252.0, 236.0, 180.0]) * 0.18, 0, 255)
                lit_s_q = (np.round(lit_s / 8.0) * 8.0).clip(0, 255).astype(np.uint8)
                hit_s = sky_core | sky_mid | sky_edge
                sub_p = plume[:sky_h, rx0 : rx0 + rw_f]
                sub_p[hit_s, :3] = lit_s_q[hit_s]
                sub_p[hit_s, 3] = 255

                # 2) Devant la montagne (`Layer 09 Top`, y < 166) : éclaircissement additif GBA BLDCNT sans damier gris
                if base_rgb is not None:
                    solid_mtn = (~sky_mask[0:rh_f, rx0 : rx0 + rw_f]) & (
                        ~(
                            (base_rgb[0:rh_f, rx0 : rx0 + rw_f, 0] >= 245)
                            & (base_rgb[0:rh_f, rx0 : rx0 + rw_f, 1] <= 12)
                            & (base_rgb[0:rh_f, rx0 : rx0 + rw_f, 2] >= 245)
                        )
                    )
                    mtn_t2 = solid_mtn & (inten > 0.50)
                    mtn_t1 = solid_mtn & (~mtn_t2) & (inten > 0.23)
                    mtn_tip = solid_mtn & (~mtn_t2) & (~mtn_t1) & (inten > 0.10) & ((inten * 3.2) > by_sub)
                    src_mtn = base_rgb[0:rh_f, rx0 : rx0 + rw_f].astype(np.float32)
                    lit_mtn = src_mtn.copy()
                    lit_mtn[mtn_t2] = np.clip(src_mtn[mtn_t2] + np.array([56.0, 46.0, 24.0]), 0, 255)
                    lit_mtn[mtn_t1] = np.clip(src_mtn[mtn_t1] + np.array([32.0, 26.0, 13.0]), 0, 255)
                    lit_mtn[mtn_tip] = np.clip(src_mtn[mtn_tip] + np.array([18.0, 15.0, 7.0]), 0, 255)
                    lit_q = (np.round(lit_mtn / 8.0) * 8.0).clip(0, 255).astype(np.uint8)
                    any_hit = mtn_t2 | mtn_t1 | mtn_tip
                    sub_t = top_fx[0:rh_f, rx0 : rx0 + rw_f]
                    sub_t[any_hit, :3] = lit_q[any_hit]
                    sub_t[any_hit, 3] = 255

            # Particules de lumière dorée céleste GBA W04 flottant doucement près des crêtes
            ov = w04_overlays[pose][:164, :]
            em = ov[:, :, 3] > 0
            lum_e = ov[:, :, 0].astype(np.int16)
            sub_em = top_fx[:164, :]
            sub_em[em & (lum_e < 210)] = (252, 218, 124, 255)
            sub_em[em & (lum_e >= 210)] = (255, 252, 232, 255)

            plume[~active_sky] = 0
            plume_frames.append(Image.fromarray(sanitize_rgba_binary(plume)))
            ridge_top_frames.append(Image.fromarray(sanitize_rgba_binary(top_fx)))

    return sky_frames, plume_frames, ridge_top_frames


# ============================================================================
# 2. SOMMETS : CYCLONE CYLINDRIQUE 3D 360° AUTOUR DE MT. THUNDER SUMMIT
# ============================================================================


def build_cylindrical_cyclone_layers(
    mode: str,
    opaque_terrain_mask: np.ndarray,
    arena_safe_mask: np.ndarray,
    rim_glow_mask: np.ndarray,
) -> dict[str, list[Image.Image]]:
    """Construit les 8 calques animés 24 poses du Cyclone Cylindrique 3D 360° :
    - `00_gouffre` (`Ground`) : anneaux elliptiques au fond de l'œil cylindrique
    - `01_paroi_arriere` (`Ground`) : paroi interne arrière concave du cylindre (défilement G -> D)
    - `02_colonnes_laterales` (`Ground`) : parois tangentielles Ouest/Est & fermeture Sud autour du pont
    - `03_rubans_helicoidaux` (`Ground`) : anneaux/hélices de plasma électrique ou Flamme Blanche
    - `04_decharges_ou_braises` (`Ground`) : éclairs ramifiés (Zekrom) ou braises GBA W04/H19P01 + langues de feu (Reshiram)
    - `07_reflets_rebords` (`Ground`) : lueur ionisée / incandescente sur les crêtes & pitons rocheux
    - `08_levre_avant_top` (`Top`) : lèvre supérieure & coins avant du cylindre (défilement inverse D -> G !)
    - `09_arcs_avant_top` (`Top`) : éclairs / flammèches rapides en premier plan (`Top`, D -> G)
    """
    if mode not in ("zekrom_electric", "reshiram_white_flame"):
        raise ValueError(f"Mode cyclone inconnu : {mode}")

    # Érosion de sécurité de 3 px sur le terrain statique : tout pixel strictement caché sous le
    # rocher opaque à 1 pose est aplati en couleur constante sur les calques de fond 00..02
    # afin de réduire drastiquement le nombre de tuiles 8x8 uniques dans `.tile` (< 24 000) !
    hidden_under_rock = ndimage.binary_erosion(opaque_terrain_mask, iterations=3)

    # Grille de calcul pixel-art 2x2 (384 x 288 -> upscalée NEAREST x2 vers 768 x 576) pour les masses
    # nuageuses/flammes du cylindre : grain pixel-art franc ET empreinte `.tile` ultra-compacte !
    gw, gh = W // 2, H // 2
    gy, gx = np.mgrid[0:gh, 0:gw].astype(np.float32)
    px_x = gx * 2.0 + 0.5
    px_y = gy * 2.0 + 0.5
    bayer_g = BAYER_4X4[np.arange(gh)[:, None] % 4, np.arange(gw)[None, :] % 4]
    bayer_full = BAYER_4X4[np.arange(H)[:, None] % 4, np.arange(W)[None, :] % 4]

    # Paramètres géométriques CONTINUS du cylindre vertical creux 360° centré sur Mt. Thunder Summit
    # Zéro clamp sur les bords (`r_cyl = 448 > 384`), zéro coupure horizontale, vrais rubans courbes continus !
    cx, cy_eye = 384.0, 290.0
    r_cyl = 448.0  # > W/2 : couvre tout l'écran 768 px sans aucune bande plate sur les côtés !
    sin_tilt = 0.46  # Inclinaison caméra 3/4 PMD

    dx = px_x - cx
    dy = px_y - cy_eye
    u_cyl = dx / r_cyl  # in [-0.857, +0.857] partout -> cos_phi >= 0.515, zéro singularité !

    # Angle azimutal continu sur la paroi arrière concave du cylindre
    phi_back = np.arcsin(u_cyl)
    cos_phi = np.sqrt(1.0 - u_cyl * u_cyl)

    # Coordonnées cylindriques 360° vue en 3/4 autour de l'axe vertical de l'œil :
    # En combinant l'azimut elliptique 360° `ang_360` (qui fait tout le tour du sommet : Ouest -> Nord -> Est -> Sud !)
    # et l'élévation hélicoïdale `z_cyl`, on obtient un vrai cylindre creux continu sans couture !
    ry_persp = dy / sin_tilt
    r_ell = np.hypot(dx, ry_persp)
    # `ang_360` tourne dans le sens horaire vu de dessus : Nord (-pi/2) va de Gauche -> Droite, Sud (+pi/2) de Droite -> Gauche !
    ang_360 = np.arctan2(ry_persp, dx)

    # Hauteur sur la paroi interne du cylindre (courbure concave en haut, plongée dans l'abîme au centre)
    z_back = px_y + 165.0 * cos_phi
    z_front = px_y - 165.0 * cos_phi

    # Densité radiale de la paroi cylindrique : calme sombre au fond de l'œil central (r_ell < 155),
    # mur cyclonique dense tout autour du plateau (r_ell >= 165) sur 360° !
    eye_wall_factor = np.clip((r_ell - 135.0) / 145.0, 0.0, 1.0)
    side_wall_weight = np.clip((np.abs(dx) - 185.0) / 155.0, 0.0, 1.0)

    if mode == "zekrom_electric":
        pal_abyss = [
            (6, 9, 18),
            (10, 15, 28),
            (15, 23, 42),
            (22, 34, 60),
            (32, 50, 86),
        ]
        pal_back_wall = [
            (8, 12, 22),
            (13, 19, 34),
            (19, 29, 50),
            (27, 42, 72),
            (38, 62, 102),
            (54, 92, 144),
            (82, 140, 202),
        ]
        pal_side_col = [
            (10, 16, 30),
            (18, 28, 50),
            (28, 46, 80),
            (44, 74, 122),
            (68, 120, 184),
            (126, 194, 244),
        ]
        pal_front_lip = [
            (12, 20, 38),
            (22, 38, 68),
            (42, 74, 124),
            (82, 146, 214),
            (184, 234, 255),
        ]
        bg_hidden_rgb = (8, 12, 22)
    else:
        pal_abyss = [
            (22, 10, 14),
            (38, 15, 18),
            (62, 24, 22),
            (94, 36, 26),
            (132, 54, 32),
        ]
        pal_back_wall = [
            (26, 11, 15),
            (46, 18, 20),
            (74, 28, 24),
            (108, 44, 28),
            (144, 64, 34),
            (186, 98, 44),
            (234, 164, 74),
        ]
        pal_side_col = [
            (34, 13, 16),
            (62, 22, 20),
            (102, 38, 24),
            (152, 66, 30),
            (212, 124, 48),
            (252, 224, 162),
        ]
        pal_front_lip = [
            (44, 16, 18),
            (86, 32, 22),
            (146, 62, 28),
            (218, 134, 52),
            (255, 240, 204),
        ]
        bg_hidden_rgb = (22, 10, 14)

    # Préparer deux nappes contrarotatives de vraies flammèches GBA W04 (filtrées 1x) pour Reshiram
    w04_frames: list[np.ndarray] = []
    h19_frames: list[np.ndarray] = []
    if mode == "reshiram_white_flame":
        w04_frames = _filter_small_ember_sparks(
            build_gba_weather_overlay_frames(
                "W04",
                W,
                H,
                N_POSES,
                scroll_dx_per_loop=64,
                scroll_dy_per_loop=-96,
            ),
            max_area=52,
        )
        h19_frames = _filter_small_ember_sparks(
            build_gba_weather_overlay_frames(
                "W04",
                W,
                H,
                N_POSES,
                scroll_dx_per_loop=-48,
                scroll_dy_per_loop=-64,
            ),
            max_area=36,
        )

    # Masque de sécurité élargi autour du plateau d'arène pour que les calques `Top` 08 & 09
    # laissent le sommet Mt. Thunder Summit parfaitement lisible au centre de l'œil !
    arena_clear_top = ndimage.binary_dilation(arena_safe_mask, iterations=10)
    arena_clear_top_g = arena_clear_top[::2, ::2]

    out: dict[str, list[Image.Image]] = {
        "00_gouffre": [],
        "01_paroi_arriere": [],
        "02_colonnes_laterales": [],
        "03_rubans_helicoidaux": [],
        "04_decharges_ou_braises": [],
        "07_reflets_rebords": [],
        "08_levre_avant_top": [],
        "09_arcs_avant_top": [],
    }

    for pose in range(N_POSES):
        theta = 2.0 * math.pi * pose / N_POSES

        # =====================================================================
        # CALQUE 00 : Gouffre elliptique 360° au fond de l'œil cylindrique (opaque)
        # =====================================================================
        # Rubans spiraux continus sans quadrillage (une seule phase maîtresse modulée en douceur)
        ab_spiral = 2.0 * ang_360 - theta - 0.022 * r_ell + 0.35 * np.sin(ang_360 - 3.0 * theta)
        ab_val = np.clip(
            0.36
            + 0.28 * np.sin(ab_spiral)
            + 0.26 * eye_wall_factor,
            0.0,
            1.0,
        )
        ab_rgb_g = palette_lookup_dithered(ab_val, pal_abyss, bayer_g, dither_strength=0.58)
        ab_rgba = np.zeros((H, W, 4), dtype=np.uint8)
        ab_rgba[:, :, :3] = np.repeat(np.repeat(ab_rgb_g, 2, axis=0), 2, axis=1)
        ab_rgba[:, :, 3] = 255
        ab_rgba[hidden_under_rock, :3] = bg_hidden_rgb
        out["00_gouffre"].append(Image.fromarray(sanitize_rgba_binary(ab_rgba)))

        # =====================================================================
        # CALQUE 01 : Paroi cylindrique 360° continue (concave au Nord G->D, enveloppante Ouest/Est/Sud !)
        # =====================================================================
        # Longs sillons hélicoïdaux continus le long du mur d'œil cylindrique 360° (zéro taches ovales !)
        cyl_stream_1 = 3.0 * ang_360 - theta - 0.018 * r_ell + 0.016 * z_back
        cyl_stream_2 = 5.0 * ang_360 - 3.0 * theta - 0.012 * r_ell - 0.010 * z_back
        wall_intensity = (
            0.34
            + 0.32 * np.sin(cyl_stream_1 + 0.35 * np.sin(cyl_stream_2))
            + 0.24 * eye_wall_factor
            + 0.10 * side_wall_weight
        )
        # Transition douce autour de l'œil central (zéro rectangle ou ligne horizontale sous la falaise !)
        back_wall_mask_g = (eye_wall_factor + 0.22 * np.sin(cyl_stream_1) + bayer_g * 0.22) > 0.24
        bw_rgb_g = palette_lookup_dithered(
            np.clip(wall_intensity, 0.0, 1.0), pal_back_wall, bayer_g, dither_strength=0.62
        )
        bw_rgba_g = np.zeros((gh, gw, 4), dtype=np.uint8)
        bw_rgba_g[back_wall_mask_g, :3] = bw_rgb_g[back_wall_mask_g]
        bw_rgba_g[back_wall_mask_g, 3] = 255
        bw_rgba = np.repeat(np.repeat(bw_rgba_g, 2, axis=0), 2, axis=1)
        bw_rgba[hidden_under_rock] = 0
        out["01_paroi_arriere"].append(Image.fromarray(sanitize_rgba_binary(bw_rgba)))

        # =====================================================================
        # CALQUE 02 : Strates verticales de la paroi tangentielle du cylindre (Ouest, Nord & Est)
        # =====================================================================
        # Anneaux concaves étagés verticalement sur le mur du cylindre : donnent tout le volume cylindrique !
        ring_phase = 0.048 * z_back + 2.0 * (phi_back - theta) + 0.30 * np.cos(3.0 * ang_360 - 3.0 * theta)
        col_wave = 0.50 + 0.50 * np.sin(ring_phase)
        col_mask_g = (eye_wall_factor * 0.68 + 0.34 * (col_wave - 0.50) + bayer_g * 0.20) > 0.60
        col_rgb_g = palette_lookup_dithered(
            np.clip(0.24 + 0.48 * col_wave + 0.16 * side_wall_weight, 0.0, 1.0),
            pal_side_col,
            bayer_g,
            dither_strength=0.58,
        )
        col_rgba_g = np.zeros((gh, gw, 4), dtype=np.uint8)
        col_rgba_g[col_mask_g, :3] = col_rgb_g[col_mask_g]
        col_rgba_g[col_mask_g, 3] = 255
        col_rgba = np.repeat(np.repeat(col_rgba_g, 2, axis=0), 2, axis=1)
        col_rgba[hidden_under_rock] = 0
        out["02_colonnes_laterales"].append(Image.fromarray(sanitize_rgba_binary(col_rgba)))

        # =====================================================================
        # CALQUE 03 : Rubans hélicoïdaux fins d'énergie pure autour du cylindre 360°
        # =====================================================================
        rib_stream = np.sin(3.0 * ang_360 - theta - 0.024 * r_ell + 0.012 * z_back)
        rib_fine = np.sin(6.0 * ang_360 - 3.0 * theta - 0.016 * r_ell)
        in_outer_cyl = eye_wall_factor > 0.32
        rib_rgba_g = np.zeros((gh, gw, 4), dtype=np.uint8)

        if mode == "zekrom_electric":
            band_halo = in_outer_cyl & ((rib_stream + 0.25 * rib_fine + bayer_g * 0.18) > 0.94)
            band_core = in_outer_cyl & ((rib_stream + 0.25 * rib_fine + bayer_g * 0.10) > 1.12)
            rib_rgba_g[band_halo] = (52, 146, 234, 255)
            rib_rgba_g[band_core] = (216, 246, 255, 255)
        else:
            flame_halo = in_outer_cyl & ((rib_stream + 0.30 * rib_fine + bayer_g * 0.20) > 0.90)
            flame_gold = in_outer_cyl & ((rib_stream + 0.30 * rib_fine + bayer_g * 0.14) > 1.06)
            flame_white = in_outer_cyl & ((rib_stream + 0.30 * rib_fine + bayer_g * 0.10) > 1.18)
            rib_rgba_g[flame_halo] = (226, 98, 28, 255)
            rib_rgba_g[flame_gold] = (252, 196, 76, 255)
            rib_rgba_g[flame_white] = (255, 252, 238, 255)

        rib_rgba = np.repeat(np.repeat(rib_rgba_g, 2, axis=0), 2, axis=1)
        rib_rgba[opaque_terrain_mask] = 0
        out["03_rubans_helicoidaux"].append(Image.fromarray(sanitize_rgba_binary(rib_rgba)))

        # =====================================================================
        # CALQUE 04 : Éclairs cylindriques ramifiés (Zekrom) / Braises GBA W04+H19 (Reshiram)
        # =====================================================================
        dis_rgba = np.zeros((H, W, 4), dtype=np.uint8)
        if mode == "zekrom_electric":
            # 1) Grands arcs électriques horizontaux/hélicoïdaux qui courent le long de la paroi concave !
            for k_arc, (z_lvl, p_off) in enumerate([(148.0, 0), (236.0, 8), (328.0, 16)]):
                rel = (pose + p_off) % N_POSES
                if rel < 9:
                    phi_center = -1.15 + 2.30 * (rel / 8.0)
                    pts_arc = []
                    for s in range(9):
                        ph = np.clip(phi_center + (s - 4) * 0.14, -1.42, 1.42)
                        ax = int(round(cx + 312.0 * math.sin(ph)))
                        jitter = (7 if (s + pose + k_arc) % 2 == 0 else -7) if 0 < s < 8 else 0
                        ay = int(round(z_lvl - 312.0 * sin_tilt * math.cos(ph) + jitter))
                        pts_arc.append((ax, ay))
                    draw_pixel_bolt_rgba(
                        dis_rgba,
                        pts_arc,
                        core_rgb=(236, 252, 255) if rel % 2 == 0 else (156, 226, 255),
                        halo_rgb=(48, 146, 242),
                        core_half_w=1,
                        halo_half_w=2,
                    )
            # 2) Colonnes d'éclairs verticaux sur les flancs Ouest & Est du cylindre
            side_bolts = [
                (96, 18, 128, 286, 2),
                (672, 24, 640, 294, 14),
                (148, 240, 188, 520, 19),
                (620, 232, 580, 528, 7),
            ]
            for bx0, by0, bx1, by1, p_trig in side_bolts:
                rel = (pose - p_trig) % N_POSES
                if rel < 5:
                    pts_v = []
                    for s in range(8):
                        ts = s / 7.0
                        jx = (12 if s % 2 == 1 else -10) if 0 < s < 7 else 0
                        pts_v.append(
                            (int(round(bx0 + (bx1 - bx0) * ts + jx)), int(round(by0 + (by1 - by0) * ts)))
                        )
                    draw_pixel_bolt_rgba(
                        dis_rgba,
                        pts_v,
                        core_rgb=(242, 252, 255),
                        halo_rgb=(64, 168, 248),
                        core_half_w=1 if rel < 3 else 0,
                        halo_half_w=2,
                    )
        else:
            # Braises sacrées matérielles GBA W04 + H19P01 dans le cylindre de Reshiram
            ov_w04 = w04_frames[pose]
            ov_h19 = h19_frames[pose]
            m_w04 = (ov_w04[:, :, 3] > 0) & (~opaque_terrain_mask)
            m_h19 = (ov_h19[:, :, 3] > 0) & (~opaque_terrain_mask)
            # Coloration sacrée : braises dorées chaudes + étincelles blanches & bleues de Reshiram
            dis_rgba[m_h19] = (244, 152, 52, 255)
            bright_w04 = m_w04 & (ov_w04[:, :, 0] >= 208)
            warm_w04 = m_w04 & (ov_w04[:, :, 0] < 208)
            dis_rgba[warm_w04] = (252, 196, 78, 255)
            dis_rgba[bright_w04] = (255, 250, 232, 255)

            # Nuée ascendante de braises sacrées 1x le long de la paroi hélicoïdale 360°
            rng_emb = np.random.default_rng(7741)
            emb_seeds = rng_emb.uniform(0.0, 1.0, size=(36, 3))
            for idx_e, (u_ang, u_rad, u_z) in enumerate(emb_seeds):
                ang_e = u_ang * 2.0 * math.pi + theta
                rad_e = 190.0 + 190.0 * u_rad
                ex = int(round(cx + rad_e * math.cos(ang_e)))
                ey = int((u_z * H - pose * (H / N_POSES)) % H)
                if 2 <= ex < W - 3 and 2 <= ey < H - 3 and not opaque_terrain_mask[ey, ex]:
                    is_white = (idx_e + pose) % 3 == 0
                    dis_rgba[ey : ey + 2, ex : ex + 2] = (
                        (255, 252, 238, 255) if is_white else (250, 178, 58, 255)
                    )
                    if is_white and not opaque_terrain_mask[ey + 2, ex]:
                        dis_rgba[ey + 2, ex : ex + 2] = (232, 108, 34, 255)

            # Filaments ardents de Flamme Blanche sacrée remontant les parois concaves du cylindre
            for k_f, (phi_base, z_start) in enumerate([(-1.20, 468.0), (-0.52, 260.0), (0.52, 250.0), (1.20, 476.0)]):
                ph_now = ((phi_base + pose * 0.11 + 1.45) % 2.90) - 1.45
                pts_f = []
                for s in range(7):
                    ph_s = np.clip(ph_now + s * 0.06, -1.42, 1.42)
                    jitter = (5 if (s + pose + k_f) % 2 == 0 else -5) if 0 < s < 6 else 0
                    fx = int(round(cx + 298.0 * math.sin(ph_s) + jitter))
                    fy = int(round(z_start - s * 26.0 - 298.0 * sin_tilt * math.cos(ph_s)))
                    pts_f.append((fx, fy))
                draw_pixel_bolt_rgba(
                    dis_rgba,
                    pts_f,
                    core_rgb=(255, 253, 240),
                    halo_rgb=(248, 156, 46),
                    core_half_w=1,
                    halo_half_w=2,
                )

        dis_rgba[opaque_terrain_mask] = 0
        out["04_decharges_ou_braises"].append(Image.fromarray(sanitize_rgba_binary(dis_rgba)))

        # =====================================================================
        # CALQUE 07 : Reflets énergétiques sur le rebord rocheux & pitons de Mt. Thunder Summit
        # =====================================================================
        rim_rgba = np.zeros((H, W, 4), dtype=np.uint8)
        yy_f, xx_f = np.mgrid[0:H, 0:W].astype(np.float32)
        rim_ang = np.arctan2(yy_f - cy_eye, xx_f - cx)
        rim_pulse = np.sin(3.0 * rim_ang - theta) + 0.5 * np.cos(5.0 * rim_ang + 3.0 * theta)
        lit_rim = rim_glow_mask & ((rim_pulse + bayer_full * 0.45) > 0.45)
        hot_rim = rim_glow_mask & ((rim_pulse + bayer_full * 0.30) > 1.02)
        if mode == "zekrom_electric":
            rim_rgba[lit_rim] = (76, 174, 246, 255)
            rim_rgba[hot_rim] = (224, 248, 255, 255)
        else:
            rim_rgba[lit_rim] = (248, 178, 68, 255)
            rim_rgba[hot_rim] = (255, 248, 224, 255)
        out["07_reflets_rebords"].append(Image.fromarray(sanitize_rgba_binary(rim_rgba)))

        # =====================================================================
        # CALQUE 08 (`Top`) : Lèvre avant du cylindre en surplomb (Droite -> Gauche !)
        # `phi_back + theta` défile de DROITE vers la GAUCHE (inverse exact de la paroi arrière !)
        # =====================================================================
        front_helix = np.sin(4.0 * (phi_back + theta) - 0.036 * z_front) + 0.35 * np.cos(
            7.0 * (phi_back + theta) + 0.028 * z_front - 3.0 * theta
        )
        # Zone géométrique de la lèvre avant : couronne haute (y < 54 au-dessus du sommet y=60) et coins Sud-Ouest / Sud-Est
        in_top_rim = px_y < (24.0 + 30.0 * (1.0 - cos_phi))
        in_bot_corners = (px_y > (534.0 - 94.0 * side_wall_weight)) & (np.abs(dx) > 106.0)
        front_zone_g = (in_top_rim | in_bot_corners) & (~arena_clear_top_g)

        front_mask_g = front_zone_g & ((front_helix + bayer_g * 0.45) > 0.34)
        front_val_g = np.clip(0.50 + 0.38 * front_helix, 0.0, 1.0)
        front_rgb_g = palette_lookup_dithered(front_val_g, pal_front_lip, bayer_g, dither_strength=0.65)
        front_rgba_g = np.zeros((gh, gw, 4), dtype=np.uint8)
        front_rgba_g[front_mask_g, :3] = front_rgb_g[front_mask_g]
        front_rgba_g[front_mask_g, 3] = 255
        front_rgba = np.repeat(np.repeat(front_rgba_g, 2, axis=0), 2, axis=1)
        out["08_levre_avant_top"].append(Image.fromarray(sanitize_rgba_binary(front_rgba)))

        # =====================================================================
        # CALQUE 09 (`Top`) : Éclairs / Flammèches d'avant-plan (Droite -> Gauche !)
        # =====================================================================
        fg_rgba = np.zeros((H, W, 4), dtype=np.uint8)
        # Trois rubans rapides qui balayent l'arc supérieur et les coins inférieurs de Droite à Gauche
        for k_fg in range(4):
            ph_fg = 1.38 - ((pose * 0.24 + k_fg * 0.72) % 2.76)
            is_upper = k_fg < 2
            pts_fg = []
            for s in range(6):
                ph_s = np.clip(ph_fg - s * 0.09, -1.42, 1.42)
                fx = int(round(cx + 318.0 * math.sin(ph_s)))
                if is_upper:
                    fy = int(round(18.0 + 28.0 * (1.0 - math.cos(ph_s)) + (4 if s % 2 else -3)))
                else:
                    fy = int(round(472.0 + 78.0 * math.cos(ph_s) + (5 if s % 2 else -4)))
                pts_fg.append((fx, fy))
            # Éviter le pont Sud sur les arcs bas
            if (not is_upper) and any(292 <= x <= 476 for x, _ in pts_fg):
                continue
            if mode == "zekrom_electric":
                draw_pixel_bolt_rgba(
                    fg_rgba,
                    pts_fg,
                    core_rgb=(236, 252, 255),
                    halo_rgb=(64, 172, 250),
                    core_half_w=1,
                    halo_half_w=2,
                )
            else:
                draw_pixel_bolt_rgba(
                    fg_rgba,
                    pts_fg,
                    core_rgb=(255, 252, 238),
                    halo_rgb=(248, 162, 48),
                    core_half_w=1,
                    halo_half_w=2,
                )

        fg_rgba[arena_clear_top] = 0
        out["09_arcs_avant_top"].append(Image.fromarray(sanitize_rgba_binary(fg_rgba)))

    return out
