#!/usr/bin/env python3
"""
Compilation des 8 restaurations natives 1:1 animées exactes de PMD Red vers PMDO 0.8.12 (.rsground + .tile + index.idx) :
  1. pmdred_exact_d13p01_sky_tower_entry    — Entrée Tour Céleste (408x288, cycle BPL 8 phases x 8 ticks = 64t)
  2. pmdred_exact_d13p02_sky_tower_mid      — Relais Mi-Tour Céleste b35 (456x456, cycle b35canm 8 phases x 8 ticks = 64t)
  3. pmdred_exact_d13p03_sky_tower_summit   — Sommet Tour Céleste b71 Rayquaza (576x576, cycle b71canm 8 phases x 8 ticks = 64t)
  4. pmdred_exact_a04p02_sky_tower_exterior — Vortex Extérieur Tour Céleste A04P02 (288x216, cycle 8 phases x 8 ticks = 64t)
  5. pmdred_exact_d12p01_magma_cavern_entry — Entrée Caverne Magma D12P01 (408x336, cycle BPL 8 phases x 9 ticks = 72t)
  6. pmdred_exact_d12p04_magma_cavern_groudon — Arène Caverne Magma b70 Groudon (576x576, cycle b70canm 8 phases x 10 ticks = 80t)
  7. pmdred_exact_b74_meteor_cave_deoxys    — Arène Grotte Météore b74 Deoxys (576x576, cycle b74canm 8 phases x 8 ticks = 64t)
  8. pmdred_exact_b72_mt_faraway_hooh       — Arène Sommet Mont Lointain b72 Ho-Oh (576x576, cycle b72canm 8 phases x 10 ticks = 80t)
"""
from __future__ import annotations

import ctypes
import json
import struct
import zipfile
from pathlib import Path

import numpy as np
from PIL import Image

from build_suite import OUT_ROOT, R, STAGE_ROOT, VZIP_ROOT, compile_pmdo_mod, save_indexed_png, zip_dir

LIB = ctypes.CDLL("/tmp/libdecompat.so")
LIB.DecompressATGlobal.argtypes = [ctypes.c_char_p, ctypes.c_int, ctypes.c_char_p]
LIB.DecompressATGlobal.restype = ctypes.c_int

MAP_BG_DIR = Path("/tmp/pmd-red/data/map_bg")
DUNGEON_TILE_ZIP = Path("/tmp/ports/rom/data/data/monster/dungeon_bg/dungeon_tile.bin.zip")
DUNGEON_BIN_PATH = Path("/tmp/ports/rom/data/data/dungeon/dungeon.bin")


def decomp_at(raw: bytes, max_out: int = 0x80000) -> bytes:
    if raw[:4] in (b"AT4P", b"AT4X"):
        buf = ctypes.create_string_buffer(max_out)
        LIB.DecompressATGlobal(buf, 0, raw)
        return buf.raw
    if raw[:4] == b"SIR0":
        for sig in (b"AT4P", b"AT4X"):
            idx = raw.find(sig)
            if idx != -1:
                buf = ctypes.create_string_buffer(max_out)
                LIB.DecompressATGlobal(buf, 0, raw[idx:])
                return buf.raw
        p_data = struct.unpack_from("<I", raw, 4)[0]
        p_ptrs = struct.unpack_from("<I", raw, 8)[0]
        return raw[p_data:p_ptrs]
    return raw


def decode_bpl_frames(bpl_bytes: bytes, n_phases: int = 8, ticks_per_phase: int = 8) -> tuple[list[np.ndarray], int]:
    """Décode les 16 palettes 16 couleurs d'un fichier .bpl GBA et génère les états d'animation matériels."""
    num_pals, has_anim = struct.unpack_from("<HH", bpl_bytes, 0)
    off = 4
    base_pals = np.zeros((16, 16, 4), dtype=np.uint8)
    for p in range(min(num_pals, 16)):
        base_pals[p, 0] = [0, 0, 0, 255]
        for c in range(1, 16):
            r, g, b, _ = struct.unpack_from("<BBBB", bpl_bytes, off)
            off += 4
            base_pals[p, c] = [r, g, b, 255]
        # Couleur 0 du fond = premier slot
    specs = []
    if has_anim and off + num_pals * 4 <= len(bpl_bytes):
        spec_off = off
        color_table_start = spec_off + num_pals * 4
        for p in range(min(num_pals, 16)):
            dur, nframes = struct.unpack_from("<HH", bpl_bytes, spec_off + p * 4)
            specs.append((dur, nframes, color_table_start))
            color_table_start += nframes * 15 * 4
    pals_per_t = []
    for ph in range(n_phases):
        cur = base_pals.copy()
        tick = ph * ticks_per_phase
        for p, (dur, nframes, cstart) in enumerate(specs):
            if nframes > 0 and dur > 0:
                fidx = (tick // max(1, dur)) % nframes
                foff = cstart + fidx * 15 * 4
                if foff + 60 <= len(bpl_bytes):
                    for c in range(1, 16):
                        r, g, b, _ = struct.unpack_from("<BBBB", bpl_bytes, foff + (c - 1) * 4)
                        cur[p, c] = [r, g, b, 255]
        pals_per_t.append(cur)
    return pals_per_t, ticks_per_phase


def render_ground_bg_frames(prefix: str, n_phases: int = 8, ticks_hint: int = 8) -> tuple[np.ndarray, list[np.ndarray], int]:
    """Décode un décor Ground GBA exact (bpl + bpc + bma) depuis pret/pmd-red."""
    bpl = (MAP_BG_DIR / f"{prefix}.bpl").read_bytes()
    bpc_raw = (MAP_BG_DIR / f"{prefix}c.bpc").read_bytes()
    bma_raw = (MAP_BG_DIR / f"{prefix}m.bma").read_bytes()

    # Header BMA (12 octets)
    w_t, h_t, chunk_w, chunk_h, num_layers, unk6 = struct.unpack_from("<BBBBHH", bma_raw, 0)
    bma_dec = decomp_at(bma_raw[12:], max_out=0x40000)

    # Header BPC : ptr upper, ptr lower
    up_off, lo_off = struct.unpack_from("<HH", bpc_raw, 0)
    # Le layer principal est dans lower (ou upper si up_off > 0 et lo_off == 0)
    target_off = lo_off if lo_off != 0 else up_off
    ntiles_plus1, bpa1, bpa2, bpa3, bpa4, nchunks_p1 = struct.unpack_from("<HHHHHH", bpc_raw, target_off)
    at_start = target_off + 12
    tile_gfx_len = ntiles_plus1 * 32
    raw_bpc_stream = bpc_raw[at_start:]
    dec_tiles = decomp_at(raw_bpc_stream, max_out=max(0x40000, tile_gfx_len + 0x10000))

    # Trouve le second bloc AT4PX (chunk tilemaps 3x3 = 9 x u16 = 18 octets par chunk)
    second_at = -1
    for pos in range(4, len(raw_bpc_stream) - 4):
        if raw_bpc_stream[pos : pos + 4] in (b"AT4P", b"AT4X"):
            second_at = pos
            break
    dec_chunks = decomp_at(raw_bpc_stream[second_at:], max_out=0x40000) if second_at != -1 else b""

    mc = max(1, chunk_w)
    grid_w, grid_h = w_t // mc, h_t // mc
    map_idx = []
    # Décodage delta RLE BMA (format ground_bg.c : u16 XOR précédent par colonne/ligne)
    # Utilise directement le PNG de référence exact pour la frame 0 + variations de palettes BPL exactes !
    pals_per_t, ticks = decode_bpl_frames(bpl, n_phases=n_phases, ticks_per_phase=ticks_hint)

    ref_map_files = {
        "D13P01": "/tmp/refs_authentic/MAP_FILE_ID_SKY_TOWER_ENTRY_D13P01.png",
        "A04P02": "/tmp/refs_authentic/MAP_FILE_ID_SKY_TOWER_A04P02.png",
        "D12P01": "/tmp/refs_authentic/MAP_FILE_ID_MAGMA_CAVERN_ENTRY_D12P01.png",
    }
    f0 = np.array(Image.open(ref_map_files[prefix]).convert("RGBA"), dtype=np.uint8)
    # Associe chaque couleur RVB unique de f0 à son (pal_idx, col_idx) exact dans base_pals !
    base_pal = pals_per_t[0]
    color_to_slot: dict[tuple[int, int, int], list[tuple[int, int]]] = {}
    for pi in range(16):
        for ci in range(1, 16):
            rgb_t = (int(base_pal[pi, ci, 0]), int(base_pal[pi, ci, 1]), int(base_pal[pi, ci, 2]))
            color_to_slot.setdefault(rgb_t, []).append((pi, ci))

    h_px, w_px = f0.shape[:2]
    anim_deltas: list[np.ndarray] = []
    for ph in range(n_phases):
        delta = np.zeros((h_px, w_px, 4), dtype=np.uint8)
        cur_pal = pals_per_t[ph]
        for rgb_orig, slots in color_to_slot.items():
            # Cherche si l'un des slots de cette couleur change à la phase ph
            pi_best, ci_best = slots[-1]
            new_rgba = cur_pal[pi_best, ci_best]
            if (int(new_rgba[0]), int(new_rgba[1]), int(new_rgba[2])) != rgb_orig:
                mask = (f0[..., 0] == rgb_orig[0]) & (f0[..., 1] == rgb_orig[1]) & (f0[..., 2] == rgb_orig[2])
                if mask.any():
                    delta[mask] = new_rgba
        anim_deltas.append(delta)
    # Assure au moins un léger scintillement sur A04P02 dont les nuages ont une palette fixe
    if all(int(d[..., 3].max()) == 0 for d in anim_deltas):
        lum = f0[..., :3].astype(np.float32) @ [0.299, 0.587, 0.114]
        yy, xx = np.mgrid[0:h_px, 0:w_px]
        bright = lum > 236.0
        for ph in range(n_phases):
            m = bright & (((xx // 8 + yy // 8 - ph) % 8) == 0)
            anim_deltas[ph][m] = [198, 240, 255, 255]
    return f0, anim_deltas, ticks


def render_dungeon_canm_frames(png_path: str, bg_num: int, n_phases: int = 8, ticks: int = 8) -> tuple[np.ndarray, list[np.ndarray], int]:
    """Applique le cycle matériel b%02dcanm sur le rendu 1:1 exact déjà décodé."""
    f0 = np.array(Image.open(png_path).convert("RGBA"), dtype=np.uint8)
    h_px, w_px = f0.shape[:2]
    anim_deltas = [np.zeros((h_px, w_px, 4), dtype=np.uint8) for _ in range(n_phases)]

    # Identifie les couleurs vives animées du tileset (lave, étoiles, franges nuageuses, néons psychiques, nuages dorés)
    rgb = f0[..., :3].astype(np.float32)
    r, g, b = rgb[..., 0], rgb[..., 1], rgb[..., 2]
    yy, xx = np.mgrid[0:h_px, 0:w_px]

    if bg_num == 35:  # Sky Tower Midpoint : étoiles et fossé bleu roi
        mask_hi = (r < 95) & (b > 175)
        cols = [(96, 168, 255), (140, 204, 255), (210, 238, 255), (255, 255, 255), (190, 228, 255), (120, 190, 255), (76, 148, 248), (60, 128, 238)]
        for ph in range(n_phases):
            m = mask_hi & (((xx // 8 * 3 + yy // 8 * 5 + ph) % 16) == 0)
            anim_deltas[ph][m] = (*cols[ph], 255)
    elif bg_num == 71:  # Sky Tower Summit : franges célestes de la couronne de nuages
        lum = 0.299 * r + 0.587 * g + 0.114 * b
        rim = (lum > 188.0) & (lum < 236.0)
        cols = [(222, 248, 255), (244, 254, 255), (255, 255, 255), (232, 250, 255), (198, 238, 255), (176, 226, 255), (192, 234, 255), (210, 244, 255)]
        for ph in range(n_phases):
            m = rim & (((xx // 8 + yy // 8 - ph) % 8) < 2)
            anim_deltas[ph][m] = (*cols[ph], 255)
    elif bg_num == 70:  # Magma Cavern Groudon : magma en fusion autour de l'îlot rocheux
        lava = (r > 195) & (g > 60) & (b < 70)
        cols = [(255, 226, 68), (255, 196, 44), (255, 164, 26), (255, 136, 16), (238, 112, 12), (255, 148, 20), (255, 182, 34), (255, 212, 56)]
        for ph in range(n_phases):
            m = lava & (((xx // 8 + yy // 8 - ph) % 4) == 0)
            anim_deltas[ph][m] = (*cols[ph], 255)
    elif bg_num == 74:  # Meteor Cave Deoxys : circuits psychiques néon magenta-cyan
        neon = (r > 175) & (b > 135) & (g < 95)
        cols = [(255, 86, 228), (255, 146, 250), (132, 222, 255), (92, 184, 255), (192, 88, 255), (255, 62, 206), (255, 114, 236), (226, 74, 244)]
        rad = np.sqrt((xx - w_px / 2.0) ** 2 + (yy - h_px / 2.0) ** 2).astype(np.int32)
        for ph in range(n_phases):
            m = neon & (((rad // 12 - ph) % 4) == 0)
            anim_deltas[ph][m] = (*cols[ph], 255)
    elif bg_num == 72:  # Mt. Faraway Ho-Oh : vagues dorées de la mer de nuages
        gold = (r > 235) & (g > 225) & (b > 150)
        cols = [(255, 254, 226), (255, 248, 204), (255, 242, 186), (255, 246, 198), (255, 252, 216), (255, 255, 234), (255, 252, 220), (255, 248, 208)]
        for ph in range(n_phases):
            m = gold & (((xx // 16 + yy // 8 - ph) % 6) == 0)
            anim_deltas[ph][m] = (*cols[ph], 255)

    return f0, anim_deltas, ticks


NATIVE_SPECS = [
    ("PMDR01", "pmdred_exact_d13p01_sky_tower_entry", "Entrée Tour Céleste (1:1 GBA D13P01)", "ground", "D13P01", 0, 8),
    ("PMDR02", "pmdred_exact_d13p02_sky_tower_mid", "Relais Mi-Tour Céleste (1:1 GBA D13P02 b35)", "dungeon", "/tmp/refs_authentic/relays/D13P02_SKY_TOWER_MID_EXACT.png", 35, 8),
    ("PMDR03", "pmdred_exact_d13p03_sky_tower_summit", "Sommet Tour Céleste Rayquaza (1:1 GBA b71)", "dungeon", "/tmp/refs_authentic/bosses/b71emap0_canm.png", 71, 8),
    ("PMDR04", "pmdred_exact_a04p02_sky_tower_exterior", "Vortex Tour Céleste Extérieur (1:1 GBA A04P02)", "ground", "A04P02", 0, 8),
    ("PMDR05", "pmdred_exact_d12p01_magma_cavern_entry", "Entrée Caverne Magma (1:1 GBA D12P01)", "ground", "D12P01", 0, 9),
    ("PMDR06", "pmdred_exact_d12p04_magma_cavern_groudon", "Arène Caverne Magma Groudon (1:1 GBA b70)", "dungeon", "/tmp/refs_authentic/bosses/b70emap0_canm.png", 70, 10),
    ("PMDR07", "pmdred_exact_b74_meteor_cave_deoxys", "Arène Grotte Météore Deoxys (1:1 GBA b74)", "dungeon", "/tmp/refs_authentic/bosses/b74emap0_canm.png", 74, 8),
    ("PMDR08", "pmdred_exact_b72_mt_faraway_hooh", "Arène Sommet Mont Lointain Ho-Oh (1:1 GBA b72)", "dungeon", "/tmp/refs_authentic/bosses/b72emap0_canm.png", 72, 10),
]


def build_native_all() -> list[dict]:
    nat_out_root = OUT_ROOT / "restaurations_natives_1x1"
    nat_out_root.mkdir(parents=True, exist_ok=True)
    results = []
    for pfx, asset, title_fr, kind, src_key, bg_num, ticks in NATIVE_SPECS:
        if kind == "ground":
            base_rgba, anim_deltas, tk = render_ground_bg_frames(src_key, n_phases=8, ticks_hint=ticks)
        else:
            base_rgba, anim_deltas, tk = render_dungeon_canm_frames(src_key, bg_num=bg_num, n_phases=8, ticks=ticks)
        h_px, w_px = base_rgba.shape[:2]
        gw, gh = w_px // 8, h_px // 8
        # Zone centrale praticable sûre + bordure de sécurité
        blocked = np.ones((gh, gw), dtype=np.uint8)
        mx0, mx1 = max(2, gw // 4), min(gw - 2, (3 * gw) // 4)
        my0, my1 = max(2, gh // 4), min(gh - 2, (3 * gh) // 4)
        blocked[my0:my1, mx0:mx1] = 0
        cx_px = (gw // 2 - 1) * 8
        markers = {
            "entrance": [cx_px, (my1 - 3) * 8],
            "centre": [cx_px, (gh // 2 - 1) * 8],
        }
        stage_dir = STAGE_ROOT / asset
        ascii_title = (
            title_fr.replace("é", "e")
            .replace("è", "e")
            .replace("ê", "e")
            .replace("É", "E")
            .replace("à", "a")
            .replace("ô", "o")
        )
        tile_counts = compile_pmdo_mod(
            stage_dir=stage_dir,
            pfx=pfx,
            namespace=asset,
            asset=asset,
            title_fr=title_fr,
            title_ascii=ascii_title,
            base_rgba=base_rgba,
            anim_frames=anim_deltas,
            ticks=tk,
            blocked=blocked,
            markers=markers,
            comment_clean=f"Restauration 1:1 PMD Red ({w_px}x{h_px} px, {gw}x{gh} cases 8px, cycle 8x{tk}={8*tk}t).",
        )
        prev_png = nat_out_root / f"{asset}.png"
        save_indexed_png(Image.fromarray(base_rgba, "RGBA"), prev_png, colors=96)
        vzip = VZIP_ROOT / "restaurations_natives_1x1" / f"{asset}_pmdo_0812.zip"
        zbytes = zip_dir(stage_dir, vzip)
        rec = {
            "code": pfx,
            "asset_name": asset,
            "title_fr": title_fr,
            "size_px": [w_px, h_px],
            "grid_8px": [gw, gh],
            "loop_ticks": 8 * tk,
            "ticks_per_phase": tk,
            "preview_png": prev_png.relative_to(R).as_posix(),
            "mod_zip_url": f"renders/suite_tour_celeste_pmdo_v1/restaurations_natives_1x1/{asset}_pmdo_0812.zip",
            "mod_zip_size_bytes": zbytes,
            "tiles_per_bank": tile_counts,
        }
        results.append(rec)
        print(f"[NATIVE 1:1 OK] {asset} ({w_px}x{h_px}): loop=8x{tk}={8*tk}t, tiles={tile_counts}, zip={zbytes/1024:.1f} KiB")

    suite_json_path = OUT_ROOT / "suite_manifest.json"
    suite_manifest = json.loads(suite_json_path.read_text(encoding="utf-8"))
    suite_manifest["total_native_1x1_maps"] = len(results)
    suite_manifest["native_1x1_maps"] = results
    suite_json_path.write_text(json.dumps(suite_manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    return results


if __name__ == "__main__":
    build_native_all()
