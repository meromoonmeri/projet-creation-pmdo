#!/usr/bin/env python3
"""Moteur partagé multi-calques pour la suite inédite de l'aventure `PMD : Destiny` (Chapitre II) :
- `DSF2` : Sentier du Sous-Bois Mycelien (`H07P05` Forêt Champignon + `H07P06` Healing Forest)
- `DSS2` : Clairière de la Source Lumineuse (`P14P01A` Luminous Spring, Explorers of Sky)
- `DSM2` : Gorge Basaltique des Sources Brûlantes — 2e Donjon Entrée (`D09P01` Mt. Blaze + `H26P01` Magma)
- `DSB2` : Caldeira du Cœur Solaire — 2e Donjon Boss (`D09P01` / `Dark Crater` + `H26P01` Magma + `W04`)

Garanties techniques PMDO `0.8.12.0` :
- `768 × 576` (`96 × 72` tuiles `8×8`), `0 %` ciel (vue `3/4` PMD pure), `10` calques (`BG` + `Top`) ;
- Détection/purge intégrale `#FF00FF` (`0` pixel magenta résiduel) et alpha binaire `{0, 255}` ;
- Liquides 100 % canoniques animés :
  * Eau forestière `1×` `Metano_Town_River` + Eau sacrée émeraude-turquoise `P14P01A` (`4 × 10 ticks`),
  * Cascades `1×` `P03P01A` (`3 × 10 ticks`),
  * Magma en fusion `1×` `H26P01` par palette cycling matériel GBA + colonnes de lave cylindriques `H26P01` (`8 × 4 ticks`) + rives visqueuses incandescentes ;
- VFX multi-frames pixel-art (`16` à `24` frames) : spores bioluminescentes, rayon sacré d'évolution, braises matérielles GBA `W04` (`16 × 7 ticks`), sceau solaire incandescent et vortex igné.
"""

from __future__ import annotations

import math
import sys
from pathlib import Path
from typing import List, Sequence, Tuple

import numpy as np
from PIL import Image
from scipy import ndimage

SOURCE_DIR = Path(__file__).resolve().parent
REPO_ROOT = SOURCE_DIR.parent
for p in (
    str(REPO_ROOT),
    str(SOURCE_DIR),
    str(SOURCE_DIR / "dungeon_biomes_v1"),
):
    if p not in sys.path:
        sys.path.insert(0, p)

from source.moteur_cyclones_cylindriques_unova import sanitize_rgba_binary  # type: ignore
from source.moteur_destiny_chapitre1_maps import (  # type: ignore
    DESTINY_WATER_PALS,
    H_CANON,
    PURE_MAGENTA,
    TILE_SIZE,
    W_CANON,
    _downsample_non_mixing,
    _sanitize_rgb_no_magenta,
    build_canonical_metano_liquid_layers,
    build_placed_p03p01a_cascades,
    build_vast_steppe_flowers_layer,
    quantize_non_magenta_mediancut,
)
from source.moteur_magma_canonique_pmd_red import (  # type: ignore
    build_canonical_h26p01_magma_frames,
    build_canonical_w04_embers_frames,
    build_h26p01_rim_glow_frames,
    render_extended_canonical_pillars,
    render_viscous_shoreline_border,
)
from tour_celeste_moteur_nuages import LayerEntry, build_rsground_package  # type: ignore

# Ajoute les palettes d'eau sylvestre et d'eau sacrée émeraude `P14P01A` à `DESTINY_WATER_PALS`
DESTINY_WATER_PALS["sylvan_stream"] = {
    "surface": (26, 138, 168),
    "bande": (16, 94, 128),
    "inter": (48, 168, 192),
    "accent": (96, 212, 224),
    "clair": (212, 252, 246),
    "spark_mid": (132, 234, 238),
    "spark_hi": (244, 255, 252),
}
DESTINY_WATER_PALS["luminous_emerald"] = {
    "surface": (28, 136, 120),
    "bande": (16, 92, 86),
    "inter": (52, 168, 144),
    "accent": (96, 212, 182),
    "clair": (214, 254, 238),
    "spark_mid": (146, 238, 214),
    "spark_hi": (244, 255, 250),
}


def resize_frames_nn(frames: List[Image.Image], w: int, h: int) -> List[Image.Image]:
    if (w, h) == (W_CANON, H_CANON):
        return frames
    return [im.resize((w, h), Image.Resampling.NEAREST) for im in frames]


def snap_frame_binary(im: Image.Image) -> Image.Image:
    arr = np.asarray(im.convert("RGBA"), dtype=np.uint8)
    return Image.fromarray(sanitize_rgba_binary(arr), mode="RGBA")


def mk_static_layer_im(rgb_nat: np.ndarray, mask_nat: np.ndarray, w: int, h: int) -> Image.Image:
    rgba = np.zeros((H_CANON, W_CANON, 4), dtype=np.uint8)
    rgba[mask_nat, :3] = rgb_nat[mask_nat]
    rgba[mask_nat, 3] = 255
    im = Image.fromarray(sanitize_rgba_binary(rgba), mode="RGBA")
    if (w, h) != (W_CANON, H_CANON):
        im = im.resize((w, h), Image.Resampling.NEAREST)
    return im


def write_halcyon_ground_script(pkg_dir: Path, ground_id: str) -> None:
    hdir = pkg_dir / "Data" / "Script" / "halcyon" / "ground" / ground_id
    hdir.mkdir(parents=True, exist_ok=True)
    (hdir / "init.lua").write_text(
        f"require 'origin.common'\n"
        f"local {ground_id} = {{}}\n"
        f"function {ground_id}.Init(map) DEBUG.EnableDbgCoro(); COMMON.RespawnAllies() end\n"
        f"function {ground_id}.Enter(map) GAME:FadeIn(20) end\n"
        f"function {ground_id}.Exit(map) end\n"
        f"function {ground_id}.Update(map) end\n"
        f"function {ground_id}.GameSave(map) end\n"
        f"function {ground_id}.GameLoad(map) GAME:FadeIn(20) end\n"
        f"return {ground_id}\n",
        encoding="utf-8",
    )


def clean_and_downsample_chapitre2_plate(
    raw_path: Path,
    out_w: int = W_CANON,
    out_h: int = H_CANON,
    top_guard_y: int = 44,
) -> Tuple[np.ndarray, np.ndarray]:
    """Détoure proprement le fond `#FF00FF` en préservant :
    - les bassins hauts (`DSS2` dès `y=103`, `DSF2` dès `y=147`, `DSB2` dès `y=170`) ;
    - les chapeaux violets royaux des champignons `H07P05` (`DSF2`) hors bordure `#FF00FF` ;
    - les cristaux rubis-ambre (`DSM2` / `DSB2`) et la stèle cyan (`DSS2`)."""
    src = np.asarray(Image.open(raw_path).convert("RGB"), dtype=np.uint8).copy()
    r = src[:, :, 0].astype(np.int16)
    g = src[:, :, 1].astype(np.int16)
    b = src[:, :, 2].astype(np.int16)

    is_mag = (r >= 205) & (b >= 195) & (g <= 75) & ((r - g) >= 135) & ((b - g) >= 125)
    fg = ~is_mag

    near_mag = ndimage.binary_dilation(is_mag, iterations=5) & fg
    fringe = (
        (fg & (r >= 210) & (b >= 195) & (g <= 95))
        | (near_mag & ((r - g >= 24) & (b - g >= 24)))
    )
    valid_fg = fg & (~fringe)
    if np.any(fringe) and np.any(valid_fg):
        _, idx = ndimage.distance_transform_edt(~valid_fg, return_indices=True)
        src[fringe] = src[idx[0][fringe], idx[1][fringe]]

    rgb_ds, fg_ds = _downsample_non_mixing(src, fg, out_w=out_w, out_h=out_h)

    lbl, n_cc = ndimage.label(fg_ds)
    if n_cc > 1:
        sizes = np.bincount(lbl.ravel())
        keep = sizes >= 28
        keep[0] = False
        fg_ds = keep[lbl]

    yy, _ = np.mgrid[0:out_h, 0:out_w]
    top_hole = (~fg_ds) & (yy < top_guard_y)
    if np.any(top_hole):
        _, n_idx = ndimage.distance_transform_edt(~fg_ds, return_indices=True)
        hy, hx = np.where(top_hole)
        rgb_ds[hy, hx] = rgb_ds[n_idx[0, hy, hx], n_idx[1, hy, hx]]
        fg_ds[top_hole] = True

    quant = quantize_non_magenta_mediancut(rgb_ds, ~fg_ds, n_colors=84)
    mag_final = (quant[:, :, 0] == 255) & (quant[:, :, 1] == 0) & (quant[:, :, 2] == 255)
    solid_final = ~mag_final

    r_d = rgb_ds[:, :, 0].astype(np.int16)
    g_d = rgb_ds[:, :, 1].astype(np.int16)
    b_d = rgb_ds[:, :, 2].astype(np.int16)

    # Préserve les cristaux cyan / stèle sacrée
    vivid_cyan = solid_final & ((b_d - r_d) >= 48) & (g_d >= 135) & (b_d >= 170)
    if np.any(vivid_cyan):
        hi_c = vivid_cyan & (g_d >= 215) & (b_d >= 232)
        mid_c = vivid_cyan & (~hi_c) & (b_d >= 200)
        lo_c = vivid_cyan & (~hi_c) & (~mid_c)
        quant[lo_c] = (38, 158, 204)
        quant[mid_c] = (72, 214, 240)
        quant[hi_c] = (182, 250, 252)

    # Préserve les cristaux ignés rubis, vermillon et or-ambre (`DSM2` & `DSB2`)
    vivid_igneous = solid_final & (r_d >= 170) & (g_d >= 36) & (b_d <= 72) & ((r_d - b_d) >= 105)
    if np.any(vivid_igneous):
        hi_gold = vivid_igneous & (g_d >= 175)
        mid_amber = vivid_igneous & (~hi_gold) & (g_d >= 105)
        lo_ruby = vivid_igneous & (~hi_gold) & (~mid_amber)
        quant[lo_ruby] = (198, 54, 26)
        quant[mid_amber] = (238, 134, 28)
        quant[hi_gold] = (255, 212, 72)

    quant[solid_final] = _sanitize_rgb_no_magenta(quant, solid_final)[solid_final]
    quant[mag_final] = PURE_MAGENTA
    return quant, solid_final


def assemble_chapitre2_brut_and_ref(
    raw_sheet: Path,
    out_brut: Path,
    out_ref_canon: Path,
    liquid_fill_rgb: Tuple[int, int, int],
    top_guard_y: int = 44,
) -> Tuple[np.ndarray, np.ndarray]:
    """Détoure `#FF00FF`, quantifie proprement avec conservation des accents vifs, et enregistre
    `out_brut` (décor sec) et `out_ref_canon` (référence de fidélité canonique)."""
    quant, solid = clean_and_downsample_chapitre2_plate(
        raw_sheet, W_CANON, H_CANON, top_guard_y=top_guard_y
    )
    preview = quant.copy()
    preview[~solid] = liquid_fill_rgb
    out_brut.parent.mkdir(parents=True, exist_ok=True)
    out_ref_canon.parent.mkdir(parents=True, exist_ok=True)
    Image.fromarray(quant, mode="RGB").save(out_brut)
    Image.fromarray(preview, mode="RGB").save(out_ref_canon)
    return quant, solid


# ==============================================================================
# 1. ONDES CONCENTRIQUES DE LA SOURCE LUMINEUSE (`DSS2` — 16 FRAMES)
# ==============================================================================
def build_sacred_spring_concentric_ripples(
    water_mask: np.ndarray,
    center_xy: Tuple[int, int] = (383, 206),
    n_frames: int = 16,
) -> List[Image.Image]:
    """Anneaux concentriques d'onde lumineuse sacrée (`16` frames pixel-art à alpha binaire `{0, 255}`)
    se propageant dans le bassin de la Source Lumineuse `P14P01A`."""
    h, w = water_mask.shape
    yy, xx = np.mgrid[:h, :w]
    cx, cy = center_xy
    xq = (xx // 2) * 2
    yq = (yy // 2) * 2
    r_ell = np.sqrt(((xq - cx) / 1.18) ** 2 + ((yq - cy) / 0.86) ** 2)
    interior = ndimage.binary_erosion(water_mask, iterations=4)

    frames: List[Image.Image] = []
    for f in range(n_frames):
        phase = f / float(n_frames)
        rgba = np.zeros((h, w, 4), dtype=np.uint8)
        core_r = 21.0 + 3.0 * math.sin(2.0 * math.pi * phase)
        core_m = interior & (r_ell <= core_r)
        halo_m = interior & (r_ell > core_r) & (r_ell <= core_r + 10.0)
        rgba[halo_m] = np.array([138, 242, 218, 255], dtype=np.uint8)
        rgba[core_m] = np.array([228, 255, 246, 255], dtype=np.uint8)

        for ring_i in range(3):
            u = (phase + ring_i / 3.0) % 1.0
            rad = 26.0 + u * 92.0
            band = np.abs(r_ell - rad) <= 1.65
            ang_hash = ((xq // 2) * 7 + (yq // 2) * 13 + ring_i * 5) % 8
            keep_thresh = 7 if u < 0.45 else (5 if u < 0.78 else 3)
            m = interior & band & (ang_hash < keep_thresh)
            col = (
                np.array([212, 255, 242, 255], dtype=np.uint8)
                if u < 0.5
                else np.array([104, 226, 198, 255], dtype=np.uint8)
            )
            rgba[m] = col
        frames.append(Image.fromarray(sanitize_rgba_binary(rgba), mode="RGBA"))
    return frames


# ==============================================================================
# 2. BIOLUMINESCENCE FONGIQUE & SPORES MYCÉLIENNES (`DSF2` — 16 & 24 FRAMES)
# ==============================================================================
def build_mushroom_cap_bioluminescence_frames(
    q_rgb: np.ndarray,
    land_mask: np.ndarray,
    n_frames: int = 16,
) -> List[Image.Image]:
    """Fait pulser doucement en pixel-art (`16` frames) les taches claires et rebords bioluminescents
    des grands champignons canoniques `H07P05`."""
    h, w, _ = q_rgb.shape
    r = q_rgb[:, :, 0].astype(np.int16)
    g = q_rgb[:, :, 1].astype(np.int16)
    b = q_rgb[:, :, 2].astype(np.int16)

    cyan_spots = land_mask & (g >= 180) & (b >= 160) & ((g - r) >= 30)
    lilac_spots = land_mask & (b >= 190) & (r >= 130) & ((b - g) >= 35)
    warm_spots = land_mask & (r >= 220) & (g >= 110) & (b >= 110) & ((r - g) >= 40)
    all_spots = cyan_spots | lilac_spots | warm_spots

    lbl, n_lbl = ndimage.label(all_spots)
    if n_lbl > 0:
        sizes = np.bincount(lbl.ravel())
        valid = (sizes >= 6) & (sizes <= 2600)
        valid[0] = False
        all_spots = valid[lbl]

    rim = ndimage.binary_dilation(all_spots, iterations=1) & (~all_spots) & land_mask
    yy, xx = np.mgrid[:h, :w]
    phase_map = ((xx // 24) * 3 + (yy // 24) * 5) % 4

    frames: List[Image.Image] = []
    for f in range(n_frames):
        rgba = np.zeros((h, w, 4), dtype=np.uint8)
        for p_group in range(4):
            s = 0.5 + 0.5 * math.sin(2.0 * math.pi * (f / float(n_frames) + p_group * 0.25))
            if s < 0.42:
                continue
            grp_spots = all_spots & (phase_map == p_group)
            if int(grp_spots.sum()) == 0:
                continue
            boost = int(round(14 + 28 * s))
            sub = np.clip(q_rgb[grp_spots].astype(np.int16) + boost, 0, 255).astype(np.uint8)
            rgba[grp_spots, :3] = sub
            rgba[grp_spots, 3] = 255
            if s > 0.76:
                grp_rim = rim & (phase_map == p_group) & (((xx + yy + f) % 2) == 0)
                rim_rgb = np.clip(q_rgb[grp_rim].astype(np.int16) + 22, 0, 255).astype(np.uint8)
                rgba[grp_rim, :3] = rim_rgb
                rgba[grp_rim, 3] = 255
        frames.append(Image.fromarray(sanitize_rgba_binary(rgba), mode="RGBA"))
    return frames


def _stamp_pixel_sprite(
    canvas: np.ndarray,
    cx: int,
    cy: int,
    kind: str,
    core_rgba: Tuple[int, int, int, int],
    halo_rgba: Tuple[int, int, int, int],
) -> None:
    h, w, _ = canvas.shape

    def put(px: int, py: int, col: Tuple[int, int, int, int]) -> None:
        if 0 <= px < w and 0 <= py < h:
            canvas[py, px] = col

    if kind == "dot":
        put(cx, cy, core_rgba)
    elif kind == "spore":
        for dx, dy in [(-1, 0), (1, 0), (0, -1), (0, 1)]:
            put(cx + dx, cy + dy, halo_rgba)
        put(cx, cy, core_rgba)
    elif kind == "star":
        for dx, dy in [(-2, 0), (2, 0), (0, -2), (0, 2), (-1, -1), (1, -1), (-1, 1), (1, 1)]:
            put(cx + dx, cy + dy, halo_rgba)
        for dx, dy in [(-1, 0), (1, 0), (0, -1), (0, 1), (0, 0)]:
            put(cx + dx, cy + dy, core_rgba)
    elif kind == "ember":
        put(cx, cy + 1, halo_rgba)
        put(cx, cy, core_rgba)
        put(cx, cy - 1, core_rgba)
        put(cx - 1, cy, halo_rgba)
        put(cx + 1, cy, halo_rgba)


def build_mycelium_spores_vfx_frames(
    top_canopy_rgba: np.ndarray | None = None,
    n_frames: int = 24,
    seed: int = 201,
) -> List[Image.Image]:
    """24 frames pixel-art de spores bioluminescentes pastel (cyan, lilas, or-vert) et lucioles
    flottant au-dessus du Sentier du Sous-Bois Mycelien (`DSF2`), combinables avec la canopée `Top`."""
    rng = np.random.default_rng(seed)
    palettes = [
        ((232, 255, 246, 255), (86, 224, 198, 255)),
        ((248, 226, 255, 255), (186, 118, 244, 255)),
        ((255, 252, 206, 255), (168, 232, 92, 255)),
        ((220, 244, 255, 255), (96, 178, 250, 255)),
    ]
    anchors = [
        (132, 255), (176, 330), (235, 195), (275, 420), (345, 290),
        (425, 315), (510, 210), (585, 275), (620, 365), (485, 435),
        (295, 135), (465, 130), (384, 175), (150, 435), (615, 445),
        (225, 290), (545, 310), (365, 445), (415, 230), (320, 365),
        (195, 145), (575, 150), (115, 355), (650, 295), (390, 98),
        (260, 250), (515, 375), (445, 175),
    ]
    particles = []
    for idx, (ax, ay) in enumerate(anchors):
        jx = int(rng.integers(-18, 19))
        jy = int(rng.integers(-14, 15))
        core, halo = palettes[idx % len(palettes)]
        particles.append((ax + jx, ay + jy, float(idx % n_frames) / n_frames, core, halo, idx % 3))

    frames: List[Image.Image] = []
    for f in range(n_frames):
        canvas = (
            top_canopy_rgba.copy()
            if top_canopy_rgba is not None
            else np.zeros((H_CANON, W_CANON, 4), dtype=np.uint8)
        )
        t = f / float(n_frames)
        for bx, by, p0, core, halo, style_i in particles:
            u = (t + p0) % 1.0
            ang = 2.0 * math.pi * u
            px = int(round(bx + 7.0 * math.sin(ang)))
            py = int(round(by - 16.0 * u + 3.0 * math.cos(2.0 * ang)))
            env = math.sin(math.pi * u)
            if env < 0.16:
                continue
            kind = "dot" if env < 0.42 else ("star" if (env > 0.82 and style_i == 0) else "spore")
            _stamp_pixel_sprite(canvas, px, py, kind, core, halo)
        frames.append(Image.fromarray(sanitize_rgba_binary(canvas), mode="RGBA"))
    return frames


# ==============================================================================
# 3. RAYON SACRÉ ZÉNITHAL & PARTICULES D'ÉVOLUTION (`DSS2` — 24 FRAMES)
# ==============================================================================
def build_luminous_spring_zenith_ray_vfx(
    center_xy: Tuple[int, int] = (383, 206),
    n_frames: int = 24,
    seed: int = 202,
) -> List[Image.Image]:
    """Rayon sacré d'évolution `P14P01A` en pixel-art tramé à alpha binaire `{0, 255}` (laissant
    la stèle cristalline nord parfaitement lisible) + étincelles cristallines montantes (`24` frames)."""
    rng = np.random.default_rng(seed)
    cx, cy = center_xy
    yy, xx = np.mgrid[:H_CANON, :W_CANON]

    bayer4 = np.array(
        [
            [0, 8, 2, 10],
            [12, 4, 14, 6],
            [3, 11, 1, 9],
            [15, 7, 13, 5],
        ],
        dtype=np.float32,
    ) / 16.0

    motes = []
    for i in range(34):
        if i < 20:
            mx = cx + int(rng.integers(-58, 59))
            my = cy + int(rng.integers(-8, 42))
            rise = int(rng.integers(68, 145))
        else:
            mx = int(rng.integers(235, 535))
            my = int(rng.integers(295, 515))
            rise = int(rng.integers(22, 42))
        motes.append((mx, my, rise, float(i) / 34.0, i % 3))

    frames: List[Image.Image] = []
    for f in range(n_frames):
        canvas = np.zeros((H_CANON, W_CANON, 4), dtype=np.uint8)
        t = f / float(n_frames)
        pulse = 0.5 + 0.5 * math.sin(2.0 * math.pi * t)

        # Le faisceau sacré part de la pointe du cristal d'évolution (y=62) et s'évase vers le cœur de la source (cy=206)
        in_vert = (yy >= 62) & (yy <= cy + 6)
        prog = np.clip((yy - 62.0) / max(1.0, float(cy - 62)), 0.0, 1.0)
        beam_half_w = 10.0 + 22.0 * prog + 3.0 * pulse
        dx_norm = np.abs(xx - cx) / np.maximum(1.0, beam_half_w)
        stele_att = np.where(yy < 108, 0.32 + 0.68 * np.clip((yy - 62.0) / 46.0, 0.0, 1.0), 1.0)
        beam_density = np.where(
            in_vert & (dx_norm < 1.0),
            (1.0 - dx_norm**1.6) * (0.26 + 0.10 * pulse) * stele_att,
            0.0,
        )
        bayer_anim = bayer4[((yy + f * 2) // 2) % 4, (xx // 2) % 4]
        beam_px = beam_density > (bayer_anim + 0.05)
        inner_px = beam_px & (dx_norm < 0.42)
        canvas[beam_px] = np.array([108, 242, 220, 255], dtype=np.uint8)
        canvas[inner_px] = np.array([224, 255, 248, 255], dtype=np.uint8)

        for mx, my, rise, p0, kind_i in motes:
            u = (t + p0) % 1.0
            px = int(round(mx + 5.0 * math.sin(2.0 * math.pi * u + p0 * 6.0)))
            py = int(round(my - rise * u))
            env = math.sin(math.pi * u)
            if env < 0.18:
                continue
            core = (238, 255, 252, 255) if kind_i != 2 else (210, 255, 196, 255)
            halo = (84, 232, 208, 255) if kind_i != 2 else (112, 224, 136, 255)
            shape = "star" if env > 0.78 else ("spore" if env > 0.42 else "dot")
            _stamp_pixel_sprite(canvas, px, py, shape, core, halo)

        frames.append(Image.fromarray(sanitize_rgba_binary(canvas), mode="RGBA"))
    return frames


# ==============================================================================
# 4. CRISTAUX IGNÉS, SCEAU SOLAIRE & MAGMA CANONIQUE `H26P01` (`DSM2` & `DSB2`)
# ==============================================================================
def build_igneous_crystal_pulse_frames(
    q_rgb: np.ndarray,
    land_mask: np.ndarray,
    n_frames: int = 16,
) -> List[Image.Image]:
    """Fait pulser sur `16` frames les cristaux ignés ambre-rubis sertis dans le basalte (`DSM2` & `DSB2`)."""
    h, w, _ = q_rgb.shape
    r = q_rgb[:, :, 0].astype(np.int16)
    g = q_rgb[:, :, 1].astype(np.int16)
    b = q_rgb[:, :, 2].astype(np.int16)
    cryst = land_mask & (r >= 165) & (g >= 38) & (b <= 85) & ((r - b) >= 95)
    lbl, n_lbl = ndimage.label(cryst)
    if n_lbl > 0:
        sizes = np.bincount(lbl.ravel())
        keep = sizes >= 8
        keep[0] = False
        cryst = keep[lbl]
    halo = ndimage.binary_dilation(cryst, iterations=1) & (~cryst) & land_mask
    yy, xx = np.mgrid[:h, :w]

    frames: List[Image.Image] = []
    for f in range(n_frames):
        s = 0.5 + 0.5 * math.sin(2.0 * math.pi * f / float(n_frames))
        rgba = np.zeros((h, w, 4), dtype=np.uint8)
        if s >= 0.25 and int(cryst.sum()) > 0:
            add_r = int(round(12 + 34 * s))
            add_g = int(round(10 + 42 * s))
            add_b = int(round(4 + 18 * s))
            src = q_rgb[cryst].astype(np.int16)
            rgba[cryst, 0] = np.clip(src[:, 0] + add_r, 0, 255).astype(np.uint8)
            rgba[cryst, 1] = np.clip(src[:, 1] + add_g, 0, 255).astype(np.uint8)
            rgba[cryst, 2] = np.clip(src[:, 2] + add_b, 0, 255).astype(np.uint8)
            rgba[cryst, 3] = 255
            if s > 0.65:
                hm = halo & (((xx + yy + f) % 2) == 0)
                rgba[hm] = np.array([255, 148, 36, 255], dtype=np.uint8)
        frames.append(Image.fromarray(sanitize_rgba_binary(rgba), mode="RGBA"))
    return frames


def build_solar_seal_floor_glow_frames(
    q_rgb: np.ndarray,
    land_mask: np.ndarray,
    seal_center: Tuple[int, int] = (383, 291),
    n_frames: int = 16,
) -> List[Image.Image]:
    """Illumine d'or incandescent les sillons gravés du Sceau Solaire octogonal au centre de `DSB2`
    exactement le long des rainures sculptées dans la dalle de basalte, plus le cristal d'autel nord."""
    h, w, _ = q_rgb.shape
    yy, xx = np.mgrid[:h, :w]
    cx, cy = seal_center
    rad = np.sqrt(((xx - cx) / 1.08) ** 2 + ((yy - cy) / 0.88) ** 2)

    lum = (
        0.30 * q_rgb[:, :, 0].astype(np.float32)
        + 0.50 * q_rgb[:, :, 1].astype(np.float32)
        + 0.20 * q_rgb[:, :, 2].astype(np.float32)
    )
    local_mean = ndimage.uniform_filter(lum, size=9)
    grooves = land_mask & (rad <= 92.0) & ((local_mean - lum) >= 7.5) & (lum <= 68.0)

    cryst_frames = build_igneous_crystal_pulse_frames(q_rgb, land_mask, n_frames=n_frames)
    solar_ramp = np.array(
        [
            [148, 44, 14],
            [196, 74, 18],
            [236, 122, 24],
            [255, 178, 42],
            [255, 228, 112],
        ],
        dtype=np.uint8,
    )

    frames: List[Image.Image] = []
    for f in range(n_frames):
        rgba = np.asarray(cryst_frames[f], dtype=np.uint8).copy()
        phase = f / float(n_frames)
        wave = 0.5 + 0.5 * np.sin(2.0 * math.pi * (phase - rad / 64.0))
        idx = np.clip(np.floor(wave * len(solar_ramp)).astype(np.int32), 0, len(solar_ramp) - 1)
        active = grooves & (wave >= 0.22)
        rgba[active, :3] = solar_ramp[idx[active]]
        rgba[active, 3] = 255
        frames.append(Image.fromarray(sanitize_rgba_binary(rgba), mode="RGBA"))
    return frames


def build_volcanic_sparks_vfx_frames(
    lava_mask: np.ndarray,
    extra_emitters: Sequence[Tuple[int, int]] = (),
    n_frames: int = 24,
    seed: int = 203,
) -> List[Image.Image]:
    """24 frames pixel-art d'étincelles volcaniques ardentes, flammèches et éclats solaires (`Top`)."""
    h, w = lava_mask.shape
    rng = np.random.default_rng(seed)
    ys, xs = np.where(ndimage.binary_erosion(lava_mask, iterations=4))

    emitters: List[Tuple[int, int, int]] = []
    if len(xs) > 0:
        picks = rng.choice(len(xs), size=min(28, len(xs)), replace=False)
        for p in picks:
            emitters.append((int(xs[p]), int(ys[p]), int(rng.integers(36, 78))))
    for ex, ey in extra_emitters:
        emitters.append((ex, ey, int(rng.integers(28, 54))))

    fire_pals = [
        ((255, 250, 184, 255), (255, 142, 28, 255)),
        ((255, 214, 92, 255), (228, 68, 16, 255)),
        ((255, 236, 140, 255), (246, 104, 22, 255)),
    ]

    frames: List[Image.Image] = []
    for f in range(n_frames):
        canvas = np.zeros((h, w, 4), dtype=np.uint8)
        t = f / float(n_frames)
        for i, (bx, by, rise) in enumerate(emitters):
            p0 = (i * 0.137) % 1.0
            u = (t + p0) % 1.0
            px = int(round(bx + 6.0 * math.sin(2.0 * math.pi * u + i)))
            py = int(round(by - rise * u))
            env = math.sin(math.pi * u)
            if env < 0.15:
                continue
            core, halo = fire_pals[i % len(fire_pals)]
            kind = "star" if (env > 0.80 and i % 4 == 0) else ("ember" if env > 0.42 else "dot")
            _stamp_pixel_sprite(canvas, px, py, kind, core, halo)
        frames.append(Image.fromarray(sanitize_rgba_binary(canvas), mode="RGBA"))
    return frames


def subsample_magma_frames(
    lava_mask: np.ndarray,
    n_phases: int = 12,
    phase_offset: int = 0,
) -> List[Image.Image]:
    """Échantillonne régulièrement le cycle matériel GBA `H26P01` (`31` phases `1×` natives)
    en `n_phases` frames fluides pour rester largement sous le plafond PMDO `< 24 000` tuiles."""
    full_31 = build_canonical_h26p01_magma_frames(
        W_CANON, H_CANON, mask=lava_mask, phase_offset=phase_offset, pure_molten_only=True
    )
    idxs = [int(round(k * 31.0 / n_phases)) % 31 for k in range(n_phases)]
    return [snap_frame_binary(full_31[i]) for i in idxs]


def build_placed_lava_cascades(
    w: int,
    h: int,
    specs: Sequence[dict],
    fg_rgb_mut: np.ndarray | None = None,
    solid_mask: np.ndarray | None = None,
) -> List[Image.Image]:
    """Place des colonnes/cascades cylindriques de lave `1×` `H26P01` (`8` frames × `4` ticks)
    avec bouche volcanique sombre creusée dans la paroi rocheuse en `(cx, top_y)` et fût complet."""
    yy_c, xx_c = np.mgrid[:H_CANON, :W_CANON]
    if fg_rgb_mut is not None and solid_mask is not None and fg_rgb_mut.shape[:2] == (H_CANON, W_CANON):
        for sp in specs:
            cx = int(sp["cx"])
            ty = int(sp["top_y"])
            vname = str(sp.get("variant", "medium"))
            rx = 15.0 if vname == "medium" else (22.0 if vname == "large" else 11.0)
            ry = 8.0
            mouth = (
                solid_mask
                & (yy_c >= max(0, int(ty - ry)))
                & (yy_c <= int(ty + 6))
                & ((((xx_c - float(cx)) / rx) ** 2 + ((yy_c - float(ty)) / ry) ** 2) <= 1.0)
            )
            rim_m = ndimage.binary_dilation(mouth, iterations=2) & (~mouth) & solid_mask
            fg_rgb_mut[rim_m] = (74, 26, 18)
            fg_rgb_mut[mouth] = (28, 10, 10)

    raw_8 = render_extended_canonical_pillars(w, h, specs=specs, open_magma_mask=None)
    # Arrondit le bord supérieur de chaque jet sur 5 px pour qu'il sorte de la bouche volcanique sans rectangle plat
    out_8: List[Image.Image] = []
    yy_w, xx_w = np.mgrid[:h, :w]
    sx_scale = w / float(W_CANON)
    sy_scale = h / float(H_CANON)
    for im in raw_8:
        arr = np.asarray(im, dtype=np.uint8).copy()
        for sp in specs:
            cx_s = float(sp["cx"]) * sx_scale
            ty_s = float(sp["top_y"]) * sy_scale
            vname = str(sp.get("variant", "medium"))
            hw = (16.0 if vname == "medium" else 14.0) * sx_scale
            in_head = (yy_w >= int(ty_s)) & (yy_w <= int(ty_s + 7 * sy_scale)) & (np.abs(xx_w - cx_s) <= hw + 4)
            u_x = np.clip((xx_w - cx_s) / max(1.0, hw * 0.72), -1.0, 1.0)
            arch_y = ty_s + (5.0 * sy_scale) * (1.0 - np.sqrt(np.maximum(0.0, 1.0 - u_x**2)))
            arr[in_head & (yy_w < arch_y)] = 0
        out_8.append(snap_frame_binary(Image.fromarray(arr, mode="RGBA")))
    return out_8


def build_clean_lava_rim_layers(
    lava_mask: np.ndarray,
    q_rock_rgb: np.ndarray,
) -> Tuple[List[Image.Image], List[Image.Image]]:
    """Construit la bordure visqueuse incandescente (`8` frames) et la lueur pulsante des parois
    rocheuses bordant la lave (`8` frames) en échantillonnant le cycle `H26P01` à alpha binaire."""
    land_mask = ~lava_mask
    rock_rgba = np.zeros((q_rock_rgb.shape[0], q_rock_rgb.shape[1], 4), dtype=np.uint8)
    rock_rgba[land_mask, :3] = q_rock_rgb[land_mask]
    rock_rgba[land_mask, 3] = 255

    visc_8_raw = render_viscous_shoreline_border(lava_mask, n_frames=8, band_px=18.0)
    glow_15 = build_h26p01_rim_glow_frames(rock_rgba, lava_mask)
    visc_8 = [snap_frame_binary(im) for im in visc_8_raw]
    glow_8 = [snap_frame_binary(glow_15[int(round(k * 15.0 / 8.0)) % 15]) for k in range(8)]
    return visc_8, glow_8
