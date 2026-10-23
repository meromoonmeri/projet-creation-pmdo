#!/usr/bin/env python3
"""Génère le brut multicalque `1×` de `ZKE1` (Entrée de la Montagne & Grotte de Zekrom).

Le brut est assemblé exclusivement à partir de références natives Chunsoft `1×` :
  - `P14P01A` (PMD Sky — Luminous Spring / Tiny Meadow) pour la clairière, la forêt de pins,
    les buissons et les rochers moussus, à l'échelle pixel `1×` stricte (aucun agrandissement).
  - `D06P01` (PMD Red — Mt. Thunder) pour le grain de sable du sentier.
  - `H26P01` (PMD Red — roche basaltique noire) pour le grain minéral de la montagne.
  - `legacy_mont_foudre_entree_d00b1b3.png` : sculpture du relief (montagne, grotte, marches,
    pont de pierre) reprise comme volume, puis re-texturée au grain `1×` des références.

Sorties (`bruts/`) :
  - `base_zekrom_montagne_entree.png` : ciel d'orage & rivière en `#FF00FF`,
    clairière/forêt `1×`, montagne basaltique & grotte noire sculptées.

Tous les bords (lisière de forêt, pied de montagne, berges, rive du sentier) sont
traités en tramage ordonné Bayer 4×4 sur palettes discrètes : zéro flou, zéro dégradé.
"""

from __future__ import annotations

from pathlib import Path

import numpy as np
from PIL import Image
from scipy import ndimage

HERE = Path(__file__).resolve().parent
REFS = HERE / "references"
BRUTS = HERE / "bruts"
W, H = 768, 576

BAYER4 = (
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
)


def bayer4(h: int, w: int, phase: int = 0) -> np.ndarray:
    tile = np.roll(BAYER4, phase, axis=(0, 1))
    return np.tile(tile, ((h + 3) // 4, (w + 3) // 4))[:h, :w]


def hash_noise(h: int, w: int, seed: int = 20261023) -> np.ndarray:
    rng = np.random.default_rng(seed)
    return rng.random((h, w), dtype=np.float32)


def build_meadow() -> np.ndarray:
    """Clairière & forêt `1×` : sol herbeux tuilé sans couture + panneaux de pins natifs à lisière tramée."""
    p14 = np.asarray(Image.open(REFS / "p14p01a_luminous_meadow_spring_native.png").convert("RGB"), dtype=np.uint8)
    grass = p14[368:572, 234:366].copy()  # (204, 132) herbe `1×` pure, sans arbre ni eau
    gh, gw = grass.shape[:2]
    canvas = np.zeros((H, W, 3), dtype=np.uint8)
    for y0 in range(0, H, gh):
        for x0 in range(0, W, gw):
            blk = grass[:, ::-1] if ((x0 // gw) % 2 == 1) else grass
            blk = blk[::-1, :] if ((y0 // gh) % 2 == 1) else blk
            ry, rx = min(gh, H - y0), min(gw, W - x0)
            canvas[y0 : y0 + ry, x0 : x0 + rx] = blk[:ry, :rx]

    # Panneaux de forêt natifs (pins, racines, sous-bois) collés avec lisière organique tramée.
    panels = (
        (p14[236:600, 0:250], 0),
        (p14[236:600, 350:500][:, ::-1], W - 150),  # miroir du bord droit natif -> lisière gauche du panneau
        (p14[236:600, 350:600], W - 250),
    )
    y_place = 236
    for panel, x0 in panels:
        ph, pw = panel.shape[:2]
        ar = panel.astype(np.float32)
        lum = 0.299 * ar[:, :, 0] + 0.587 * ar[:, :, 1] + 0.114 * ar[:, :, 2]
        mask = lum < 114.0  # les pins/sous-bois P14P01A sont nettement plus sombres que l'herbe au soleil
        mask = ndimage.binary_closing(mask, iterations=1)
        mask = ndimage.binary_fill_holes(mask)
        mask = ndimage.binary_opening(mask, iterations=1)

        # Lisière tramée : on dissout progressivement le bord du masque en Bayer 4×4 (zéro flou).
        inner = ndimage.binary_erosion(mask, iterations=2)
        edge = mask & (~inner)
        yy_l, xx_l = np.mgrid[0:ph, 0:pw]
        depth = np.zeros((ph, pw), dtype=np.float32)
        depth[edge] = 1.0
        depth = ndimage.grey_dilation(depth, size=(5, 5))
        keep = inner | (edge & ((bayer4(ph, pw, phase=1) + depth * 0.35) > 0.34))
        keep = ndimage.binary_closing(keep, iterations=1)

        # Ombre de canopée tramée qui assoit la forêt sur la clairière (juste sous la lisière).
        halo = ndimage.binary_dilation(keep, iterations=4) & (~keep)
        y0 = y_place if y_place + ph <= H else H - ph
        dst = canvas[y0 : y0 + ph, x0 : x0 + pw]
        halo_d = halo & ((bayer4(ph, pw, phase=2) - 0.5) > -0.12)
        dst[halo_d] = np.clip(dst[halo_d].astype(np.int32) * 78 // 100, 16, 255).astype(np.uint8)
        dst[keep] = panel[keep]

    return canvas


def main() -> None:
    BRUTS.mkdir(parents=True, exist_ok=True)
    legacy = np.asarray(Image.open(REFS / "legacy_mont_foudre_entree_d00b1b3.png").convert("RGB"), dtype=np.uint8)
    p14 = np.asarray(Image.open(REFS / "p14p01a_luminous_meadow_spring_native.png").convert("RGB"), dtype=np.uint8)
    d06 = np.asarray(Image.open(HERE.parent / "mont_foudre_entree_v1" / "references" / "d06p01_mt_thunder_native.png").convert("RGB"), dtype=np.uint8)
    h26 = np.asarray(Image.open(HERE.parent / "mine_magma_entree_v1" / "references" / "native_h26p01_roche_noire_ref.png").convert("RGB"), dtype=np.uint8)

    yy, xx = np.mgrid[0:H, 0:W]
    lr, lg, lb = legacy[:, :, 0].astype(np.int32), legacy[:, :, 1].astype(np.int32), legacy[:, :, 2].astype(np.int32)
    mag = (lr >= 215) & (lg <= 50) & (lb >= 215)

    meadow = build_meadow()

    # --- 1. Sculpture : montagne, grotte, marches, sentier & pont ---
    sculpt = legacy.copy()
    # Les 2 arbres « sucettes » de l'ancien brut sont remplacés par le relief rocheux surplombant.
    round_tree = (~mag) & (yy >= 244) & (yy <= 346) & (
        (((xx >= 205) & (xx <= 292)) | ((xx >= 475) & (xx <= 562)))
    ) & ((lg > lr + 12) | ((lr > lb + 28) & (yy >= 300)))
    up_tree = round_tree & (yy <= 322)
    ys, xs = np.where(up_tree)
    sculpt[ys, xs] = sculpt[np.clip(ys - 96, 0, H - 1), xs]

    sr, sg, sb = sculpt[:, :, 0].astype(np.int32), sculpt[:, :, 1].astype(np.int32), sculpt[:, :, 2].astype(np.int32)

    # Silhouette pleine du massif : roche = bleu-gris neutre (le basalte a b >= g), la mousse/teinte
    # verte (g > b) est un simple placage que l'on refermera, jamais un trou dans la falaise.
    rockish = (~mag) & (yy <= 340) & ((sg - sb) < 8)
    rock_close = ndimage.binary_closing(rockish, iterations=4)
    rock_close = ndimage.binary_fill_holes(rock_close)
    lbl, n = ndimage.label(rock_close)
    sizes = ndimage.sum(rock_close, lbl, range(1, n + 1))
    mountain = lbl == (int(np.argmax(sizes)) + 1)
    mountain = ndimage.binary_closing(mountain, iterations=2) & (~mag)
    mountain = ndimage.binary_fill_holes(mountain)

    is_green = (sg > sr + 16) & (~mag)
    is_path = (~mag) & (np.abs(xx - W // 2) <= 62) & (yy >= 316) & (~is_green) & (~mountain)

    # --- 2. Re-texturage `1×` : grain de sable D06P01 & grain basaltique H26P01 ---
    sand = d06[175:255, 165:255].astype(np.float32)
    sand_grain = sand - sand.mean(axis=(0, 1), keepdims=True)
    rock_tile = h26[40:168, 40:168].astype(np.float32)
    rock_grain = rock_tile[:, :, 1] - ndimage.uniform_filter(rock_tile[:, :, 1], size=9)

    def tile_to(h: int, w: int, arr: np.ndarray) -> np.ndarray:
        reps = ((h + arr.shape[0] - 1) // arr.shape[0], (w + arr.shape[1] - 1) // arr.shape[1])
        reps = reps + (1,) if arr.ndim == 3 else reps
        return np.tile(arr, reps)[:h, :w]

    sg_map = tile_to(H, W, sand_grain)
    rg_map = tile_to(H, W, rock_grain)

    sculpt_f = sculpt.astype(np.float32)
    sculpt_f[is_path, 0] = np.clip(sculpt_f[is_path, 0] * 0.72 + 26.0 + sg_map[is_path, 0] * 0.65, 40, 215)
    sculpt_f[is_path, 1] = np.clip(sculpt_f[is_path, 1] * 0.74 + 24.0 + sg_map[is_path, 1] * 0.65, 38, 198)
    sculpt_f[is_path, 2] = np.clip(sculpt_f[is_path, 2] * 0.78 + 30.0 + sg_map[is_path, 2] * 0.65, 35, 168)

    # Le basalte garde ses arêtes noires ; on ajoute le grain minéral `1×` sur les faces éclairées.
    lit = mountain & ((sr + sg + sb) >= 55) & ((sg - sb) < 8)
    for ch, w_ch in enumerate((0.40, 0.42, 0.46)):
        sculpt_f[lit, ch] = np.clip(sculpt_f[lit, ch] + rg_map[lit] * w_ch, 6, 210)

    # --- 3. Composition clairière + massif ---
    out = meadow.copy()
    out[mountain] = np.rint(sculpt_f[mountain]).astype(np.uint8)
    out[is_path] = np.rint(sculpt_f[is_path]).astype(np.uint8)

    # --- 4. Mousse : remplacement par ardoise neutre issue de la luminance (zéro tache verte sur la roche) ---
    lum = 0.299 * out[:, :, 0].astype(np.float32) + 0.587 * out[:, :, 1].astype(np.float32) + 0.114 * out[:, :, 2].astype(np.float32)
    moss = mountain & ((out[:, :, 1].astype(np.int32) - out[:, :, 2].astype(np.int32)) >= 4)
    moss = ndimage.binary_dilation(moss, iterations=1) & mountain
    slate = np.stack(
        [np.clip(lum * 0.90, 12, 196), np.clip(lum * 1.00, 14, 206), np.clip(lum * 1.12, 18, 214)], axis=2
    )
    out[moss] = np.rint(slate[moss]).astype(np.uint8)

    # --- 4 bis. Désurchauffe des placages verts résiduels (escalier, corniches) : ardoise pure ---
    green_excess = mountain & (
        (out[:, :, 1].astype(np.int32) - np.maximum(out[:, :, 0].astype(np.int32), out[:, :, 2].astype(np.int32))) > 4
    )
    green_excess = ndimage.binary_dilation(green_excess, iterations=1) & mountain
    out[green_excess] = np.rint(slate[green_excess]).astype(np.uint8)

    # --- 4 ter. Escalier de la grotte : dalles lisibles dans la pénombre (lift tramé, zéro flou) ---
    stair = mountain & (xx >= W // 2 - 74) & (xx <= W // 2 + 74) & (yy >= 214) & (yy <= 332)
    stair_lum = 0.299 * out[:, :, 0].astype(np.float32) + 0.587 * out[:, :, 1].astype(np.float32) + 0.114 * out[:, :, 2].astype(np.float32)
    step_tread = stair & (stair_lum >= 18.0)
    lift = ndimage.uniform_filter(step_tread.astype(np.float32), size=(3, 3)) > 0.35
    tread = stair & lift
    tread_f = out.astype(np.float32)
    tread_f[tread, 0] = np.clip(tread_f[tread, 0] * 1.10 + 14.0, 16, 132)
    tread_f[tread, 1] = np.clip(tread_f[tread, 1] * 1.12 + 15.0, 18, 140)
    tread_f[tread, 2] = np.clip(tread_f[tread, 2] * 1.14 + 17.0, 24, 152)
    out[tread] = np.rint(tread_f[tread]).astype(np.uint8)

    # --- 5. Pied de falaise : ombre de contact tramée + éboulis pixel-art progénéré (aucun patch rectangulaire) ---
    foot = (~mag) & (~mountain) & (~is_path) & ndimage.binary_dilation(mountain, iterations=2) & (yy >= 286)
    out[foot] = np.clip(out[foot].astype(np.int32) * 58 // 100, 12, 255).astype(np.uint8)

    grass_dither = (~mag) & (~mountain) & (~is_path) & ndimage.binary_dilation(mountain, iterations=9) & (~ndimage.binary_dilation(mountain, iterations=3))
    gsel = grass_dither & ((bayer4(H, W, phase=2) - 0.5) > 0.10)
    out[gsel] = np.clip(out[gsel].astype(np.int32) * 80 // 100, 20, 255).astype(np.uint8)

    rng = np.random.default_rng(20261023)
    for _ in range(26):
        px = int(rng.integers(200, W - 200))
        py = int(rng.integers(292, 330))
        if mountain[py, px] or mag[py, px] or is_path[py, px]:
            continue
        rr = int(rng.integers(4, 10))
        y0, y1 = py - rr // 2, py + rr // 2 + 1
        x0, x1 = px - rr, px + rr + 1
        if y0 < 0 or x0 < 0 or y1 > H or x1 > W:
            continue
        sub = out[y0:y1, x0:x1]
        sub_f = sub.astype(np.float32)
        yy2, xx2 = np.mgrid[0 : sub.shape[0], 0 : sub.shape[1]]
        ell = ((xx2 - sub.shape[1] / 2) / max(1.0, rr * 0.9)) ** 2 + ((yy2 - sub.shape[0] / 2) / max(1.0, rr * 0.5)) ** 2
        body = ell <= 1.0
        base_lum = np.array([46.0, 56.0, 78.0], dtype=np.float32) * (0.85 + 0.3 * rng.random())
        shade = (0.72 + 0.42 * (1.0 - np.clip(yy2 / max(1.0, sub.shape[0] - 1), 0, 1)))[:, :, None]
        pebble = np.clip(base_lum[None, None, :] * shade, 18, 168)
        sub_f[body] = pebble[body]
        sub[:] = np.rint(sub_f).astype(np.uint8)
        # contact shadow sous le caillou, tramé
        y_sh = y1
        if y_sh < H and x0 >= 0 and x1 <= W:
            row = out[y_sh, x0:x1].astype(np.int32)
            sh_mask = (bayer4(1, x1 - x0)[0] - 0.5) > -0.05
            row[sh_mask] = np.clip(row[sh_mask] * 66 // 100, 10, 255)
            out[y_sh, x0:x1] = row.astype(np.uint8)

    # --- 7. Restauration intégrale du #FF00FF (ciel d'orage + rivière) ---
    out[mag] = (255, 0, 255)
    Image.fromarray(out, mode="RGB").save(BRUTS / "base_zekrom_montagne_entree.png")
    print("[ZKE1] brut écrit :", BRUTS / "base_zekrom_montagne_entree.png")


if __name__ == "__main__":
    main()
