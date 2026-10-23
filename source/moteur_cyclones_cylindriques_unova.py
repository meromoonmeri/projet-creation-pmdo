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
    """Extrait à l'échelle 1x native les cascades, sparkles et fleurs de Metano Town & Sky Peak."""
    eau_dir = REPO_ROOT / "source" / "eau_metano" / "natifs"
    anim_sheet = np.array(decode_pmdo_tile(eau_dir / "Metano_Town_Animation_Tileset.tile"))
    sparkles_sheet = np.array(decode_pmdo_tile(eau_dir / "Metano_Town_River_Sparkles.tile"))

    # 1. Quatre frames natives de la cascade à rondins Metano Town (64 x 136 px chacune)
    cascades = []
    for i in range(4):
        crop = anim_sheet[496:632, 8 + 72 * i : 72 + 72 * i].copy()
        cascades.append(sanitize_rgba_binary(crop))

    # 2. Séquence de sparkles sur l'eau de Metano Town (cellules 16x16 dans la colonne x=0..16)
    sparkle_frames = []
    for row in range(6):
        sp = sparkles_sheet[row * 16 : (row + 1) * 16, 0:16].copy()
        # Ne garder que les pixels blancs/cyan brillants de reflet (pas le fond turquoise)
        bright = (sp[:, :, 3] > 0) & (
            (sp[:, :, 0] > 180) & (sp[:, :, 1] > 235) & (sp[:, :, 2] > 240)
        )
        out = np.zeros_like(sp)
        out[bright] = sp[bright]
        out[bright, 3] = 255
        sparkle_frames.append(sanitize_rgba_binary(out))

    # 3. Fleurs animées 3 phases de Metano_Town_Animation_Tileset (touffes colorées & blanches)
    # Ligne y=32..56 : x=8..32, 48..72, 88..112 (fleurs colorées 24x24)
    metano_flowers_color = [
        sanitize_rgba_binary(anim_sheet[32:56, 8 + 40 * i : 32 + 40 * i].copy())
        for i in range(3)
    ]
    # Ligne y=96..128 : x=8..32, 48..72, 88..112 (fleurs blanches hautes 24x32)
    metano_flowers_white = [
        sanitize_rgba_binary(anim_sheet[96:128, 8 + 40 * i : 32 + 40 * i].copy())
        for i in range(3)
    ]

    # 4. Fleurs corail 1x de Sky Peak Prairie (`skypeak_decoupe_x2.png[::2, ::2]`)
    sk_1x = np.array(
        Image.open(REPO_ROOT / "source" / "zone_zero_v2" / "reference" / "skypeak_decoupe_x2.png").convert("RGBA")
    )[::2, ::2]
    # Extraire un bouquet isolé de fleurs roses Sky Peak (autour de x=96..120, y=14..42 en 1x)
    patch = sk_1x[12:44, 94:122].copy()
    r, g, b = patch[:, :, 0].astype(np.int16), patch[:, :, 1].astype(np.int16), patch[:, :, 2].astype(np.int16)
    # Isoler les pétales corail/blancs et leur couronne vert foncé immédiate
    petal = (r > 175) & (r > b + 15)
    stem = ndimage.binary_dilation(petal, iterations=1) & (g < 210)
    keep = petal | stem
    base_sk_flower = np.zeros_like(patch)
    base_sk_flower[keep] = patch[keep]
    base_sk_flower[keep, 3] = 255
    base_sk_flower = sanitize_rgba_binary(base_sk_flower)
    # 4 phases d'ondulation douce 1 px pixel-art (0, +1x, 0, -1x sur les pétales hauts)
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
        "sparkle_frames": sparkle_frames,
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
) -> tuple[list[Image.Image], list[Image.Image], list[Image.Image]]:
    """Construit les 3 calques animés 24 poses de la clairière & rivière Metano Town :
    - `river_frames` : courant turquoise Metano 4 phases + dérive harmonique + cascades 4 phases
    - `sparkle_frames` : reflets scintillants `Metano_Town_River_Sparkles` + écume de pied de cascade
    - `flower_frames` : fleurs Sky Peak Prairie & Metano Town ondulant dans la brise
    """
    assets = extract_metano_water_and_flower_assets()
    cascades_4: list[np.ndarray] = assets["cascades_4"]  # type: ignore[assignment]
    sp_bank: list[np.ndarray] = assets["sparkle_frames"]  # type: ignore[assignment]

    yy, xx = np.mgrid[0:H, 0:W].astype(np.float32)
    bayer = BAYER_4X4[np.arange(H)[:, None] % 4, np.arange(W)[None, :] % 4]

    # Distance aux berges de la rivière pour reproduire exactement le biseau turquoise de Metano Town
    dist_bank = ndimage.distance_transform_edt(water_mask)
    visible_water = water_mask.copy()
    if bridge_mask is not None:
        visible_water_open = water_mask & (~bridge_mask)
    else:
        visible_water_open = water_mask

    # Palette exacte relevée dans Metano_Town_River_Animation_1..4.tile
    c_edge_dark = np.array([53, 132, 188], dtype=np.uint8)
    c_edge_mid = np.array([86, 178, 214], dtype=np.uint8)
    c_body = np.array([124, 218, 232], dtype=np.uint8)
    c_body_light = np.array([150, 230, 241], dtype=np.uint8)
    c_ripple = np.array([208, 248, 255], dtype=np.uint8)

    # Sites de sparkles le long du lit ouvert de la rivière
    sparkle_sites: list[tuple[int, int, int]] = []
    for sy in range(280, 460, 26):
        for sx in range(88, 680, 44):
            jx = sx + ((sy * 7) % 19) - 9
            jy = sy + ((sx * 5) % 13) - 6
            if 16 <= jx < W - 24 and 16 <= jy < H - 24:
                sub = visible_water_open[jy : jy + 16, jx : jx + 16]
                if sub.all() and dist_bank[jy + 8, jx + 8] >= 6.5:
                    sparkle_sites.append((jx, jy, len(sparkle_sites)))

    river_out: list[Image.Image] = []
    sparkle_out: list[Image.Image] = []
    flower_out: list[Image.Image] = []

    for pose in range(N_POSES):
        theta = 2.0 * math.pi * pose / N_POSES
        phase4 = (pose // 6) % 4  # 4 phases Metano Town calées sur la boucle de 24 poses

        # --- Calque A : Rivière Metano Town + Cascades 4 phases ---
        riv = np.zeros((H, W, 4), dtype=np.uint8)
        riv[visible_water, :3] = c_body
        riv[visible_water, 3] = 255

        # Ondes douces de courant le long du chenal (w=1 et w=3 -> pose 0 != pose 12)
        flow_phase = (
            0.055 * np.abs(xx - 384.0)
            - 0.045 * yy
            - 1.0 * theta
            + 0.35 * np.sin(0.04 * xx + 3.0 * theta)
        )
        light_band = visible_water & (dist_bank > 5.0) & ((np.sin(flow_phase) + bayer * 0.45) > 0.58)
        riv[light_band, :3] = c_body_light

        # Biseau de berge exact style Metano Town (sombre 1..2 px, moyen 2..4 px, vaguelette animée 4..6 px)
        edge1 = visible_water & (dist_bank <= 2.0)
        edge2 = visible_water & (dist_bank > 2.0) & (dist_bank <= 4.2)
        shore_wave = np.sin(0.16 * xx + 0.14 * yy - 0.5 * math.pi * phase4 - theta)
        edge_rip = visible_water & (dist_bank > 3.6) & (dist_bank <= 6.2) & (shore_wave > 0.38)
        riv[edge2, :3] = c_edge_mid
        riv[edge1, :3] = c_edge_dark
        riv[edge_rip, :3] = c_ripple

        # Plaquer les cascades natives 4 phases de Metano Town aux embouchures de la montagne
        casc_sprite = cascades_4[phase4]
        ch, cw = casc_sprite.shape[:2]
        for cx0, cy0 in cascade_origins:
            # Garder une hauteur propre (96 px) pour tomber pile dans la rivière
            use_h = min(96, ch, H - cy0)
            sub_c = casc_sprite[:use_h, :]
            mask_c = sub_c[:, :, 3] > 0
            dst = riv[cy0 : cy0 + use_h, cx0 : cx0 + cw]
            dst[mask_c] = sub_c[mask_c]

        river_out.append(Image.fromarray(sanitize_rgba_binary(riv)))

        # --- Calque B : Reflets Sparkles Metano + Écume vivante au pied des cascades ---
        spk = np.zeros((H, W, 4), dtype=np.uint8)
        for sx, sy, idx in sparkle_sites:
            # Allumage progressif décalé sur harmonique impaire w=1
            local_p = (pose + idx * 5) % N_POSES
            if local_p < 12:
                sp_img = sp_bank[(local_p // 2) % len(sp_bank)]
                m = sp_img[:, :, 3] > 0
                dst = spk[sy : sy + 16, sx : sx + 16]
                dst[m] = sp_img[m]

        # Bouillonnement d'écume pixel-art au pied de chaque cascade Metano
        for k_c, (cx0, cy0) in enumerate(cascade_origins):
            foam_y = cy0 + 92
            for fx in range(cx0 + 4, cx0 + cw - 4, 4):
                bob = int(round(2.2 * math.sin(theta + 0.35 * fx + k_c)))
                fy = foam_y + bob
                if 0 <= fy < H - 4 and 0 <= fx < W - 4:
                    spk[fy : fy + 3, fx : fx + 4] = (238, 252, 255, 255)
                    if ((fx // 4 + pose) % 3) == 0:
                        spk[fy + 3 : fy + 5, fx + 1 : fx + 3] = (176, 238, 248, 255)

        sparkle_out.append(Image.fromarray(sanitize_rgba_binary(spk)))

        # --- Calque C : Fleurs animées Sky Peak Prairie & Metano Town ---
        flw = np.zeros((H, W, 4), dtype=np.uint8)
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


def build_mountain_horizon_sky_layers(
    mode: str,
    sky_mask: np.ndarray,
) -> tuple[list[Image.Image], list[Image.Image], list[Image.Image]]:
    """Construit les 3 calques atmosphériques (2 fond `Ground` + 1 crêtes `Top`)
    au-dessus de la montagne de l'Entrée (`zekrom_electric` ou `reshiram_white_flame`)."""
    yy, xx = np.mgrid[0:H, 0:W].astype(np.float32)
    bayer = BAYER_4X4[np.arange(H)[:, None] % 4, np.arange(W)[None, :] % 4]

    # Masque élargi de 4 px sous la crête pour éviter tout interstice sur le ciel
    active_sky = ndimage.binary_dilation(sky_mask, iterations=4)
    ys_sky = np.where(active_sky)[0]
    y_max_sky = int(ys_sky.max()) + 1 if len(ys_sky) else 160

    if mode == "zekrom_electric":
        pal_sky = [
            (8, 12, 26),
            (14, 22, 44),
            (22, 36, 68),
            (34, 56, 98),
            (52, 86, 138),
            (78, 126, 184),
        ]
        bolt_core = (232, 250, 255)
        bolt_halo = (66, 168, 246)
    elif mode == "reshiram_white_flame":
        pal_sky = [
            (26, 10, 14),
            (54, 18, 22),
            (96, 32, 24),
            (156, 62, 28),
            (218, 118, 42),
            (248, 192, 92),
            (255, 242, 212),
        ]
        bolt_core = (255, 250, 232)
        bolt_halo = (246, 152, 52)
    else:
        raise ValueError(f"Mode inconnu : {mode}")

    # Braises matérielles GBA W04 filtrées (flammèches 1x pures sans colonnes solaires) pour Reshiram
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
        w04_overlays = _filter_small_ember_sparks(raw_w04, max_area=52)

    sky_frames: list[Image.Image] = []
    plume_frames: list[Image.Image] = []
    ridge_top_frames: list[Image.Image] = []

    sub_yy = yy[:y_max_sky, :]
    sub_xx = xx[:y_max_sky, :]
    sub_bayer = bayer[:y_max_sky, :]
    sub_mask = active_sky[:y_max_sky, :]

    for pose in range(N_POSES):
        theta = 2.0 * math.pi * pose / N_POSES

        # --- Calque 0 : Ciel d'orage / Aurore ardente ---
        sky = np.zeros((H, W, 4), dtype=np.uint8)
        grad = np.clip(sub_yy / max(float(y_max_sky), 1.0), 0.0, 1.0)
        clouds = (
            0.5
            + 0.28 * np.sin(0.018 * sub_xx - theta + 0.03 * sub_yy)
            + 0.16 * np.cos(0.034 * sub_xx + 3.0 * theta - 0.04 * sub_yy)
        )
        val = np.clip(0.55 * grad + 0.45 * clouds, 0.0, 1.0)
        rgb = palette_lookup_dithered(val, pal_sky, sub_bayer, dither_strength=0.62)
        sub_out = sky[:y_max_sky, :]
        sub_out[sub_mask, :3] = rgb[sub_mask]
        sub_out[sub_mask, 3] = 255
        sky_frames.append(Image.fromarray(sanitize_rgba_binary(sky)))

        # --- Calque 1 : Éclairs lointains (Zekrom) ou Volutes de Flamme Blanche (Reshiram) ---
        plume = np.zeros((H, W, 4), dtype=np.uint8)
        if mode == "zekrom_electric":
            # Trois foyers d'éclairs décalés au-dessus des crêtes montagneuses
            anchors = [(190, 6, 224, 112, 0), (384, 4, 368, 96, 8), (576, 8, 548, 116, 16)]
            for ax0, ay0, ax1, ay1, p_start in anchors:
                rel = (pose - p_start) % N_POSES
                if rel < 5:
                    pts = []
                    for s in range(7):
                        t_s = s / 6.0
                        bx = int(round(ax0 + (ax1 - ax0) * t_s + (11 if s % 2 == 1 else -9) * (0 < s < 6)))
                        by = int(round(ay0 + (ay1 - ay0) * t_s))
                        pts.append((bx, by))
                    draw_pixel_bolt_rgba(
                        plume,
                        pts,
                        core_rgb=bolt_core if rel < 3 else (130, 214, 255),
                        halo_rgb=bolt_halo,
                        core_half_w=1 if rel < 2 else 0,
                        halo_half_w=2 if rel < 3 else 1,
                    )
        else:
            # Rubans ascendants de Flamme Blanche sacrée & Or solaire derrière le pic central
            dx_c = (sub_xx - 384.0) / 290.0
            rib = np.sin(5.0 * dx_c + 0.075 * sub_yy + theta) + 0.5 * np.cos(
                9.0 * dx_c + 0.11 * sub_yy + 3.0 * theta
            )
            env = np.exp(-1.6 * dx_c * dx_c) * np.clip(1.15 - 0.35 * grad, 0.2, 1.0)
            warm = sub_mask & ((rib * env + sub_bayer * 0.35) > 0.58)
            hot = sub_mask & ((rib * env + sub_bayer * 0.28) > 0.80)
            core = sub_mask & ((rib * env + sub_bayer * 0.20) > 1.02)
            sub_p = plume[:y_max_sky, :]
            sub_p[warm] = (232, 118, 38, 255)
            sub_p[hot] = (252, 202, 86, 255)
            sub_p[core] = (255, 252, 238, 255)

        plume[~active_sky] = 0
        plume_frames.append(Image.fromarray(sanitize_rgba_binary(plume)))

        # --- Calque 9 (`Top`) : Étincelles de crête (Zekrom) ou Braises sacrées GBA W04 (Reshiram) ---
        top_fx = np.zeros((H, W, 4), dtype=np.uint8)
        if mode == "zekrom_electric":
            rng = np.random.default_rng(9100)
            base_sparks = rng.integers(0, [W, 180], size=(28, 2))
            for k, (sx0, sy0) in enumerate(base_sparks):
                px = int((sx0 + round(pose * 4 + 6 * math.sin(theta + k))) % W)
                py = int(12 + (sy0 - pose * 3 + k * 7) % 148)
                if 0 <= py < H - 2 and 0 <= px < W - 2:
                    top_fx[py : py + 2, px : px + 2] = (
                        (226, 248, 255, 255) if (k + pose) % 2 == 0 else (92, 192, 252, 255)
                    )
        else:
            # Braises GBA W04 recolorées en blanc-or sacré dans le tiers nord (y < 196)
            ov = w04_overlays[pose][:196, :]
            em = ov[:, :, 3] > 0
            # Rehausser vers l'or blanc sacré de Reshiram
            lum = ov[:, :, 0].astype(np.int16)
            sub_t = top_fx[:196, :]
            bright_e = em & (lum >= 210)
            warm_e = em & (lum < 210)
            sub_t[warm_e] = (248, 182, 68, 255)
            sub_t[bright_e] = (255, 248, 226, 255)

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
        # Zone géométrique de la lèvre avant : couronne haute courbe et coins Sud-Ouest / Sud-Est
        in_top_rim = px_y < (34.0 + 44.0 * (1.0 - cos_phi))
        in_bot_corners = (px_y > (538.0 - 84.0 * side_wall_weight)) & (np.abs(dx) > 96.0)
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
