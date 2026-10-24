#!/usr/bin/env python3
"""Récupère et indexe toutes les maps de référence natives GBA de *PMD Red Rescue Team* (`pret/pmd-red`).

Équivalent PMD Red de `source/outil_maps_pmdsky/recuperer_maps.py` :
- Clone partiel (`sparse-checkout`) de `https://github.com/pret/pmd-red.git` dans `.cache/pmd-red` (non versionné) ;
- Lit les tables officielles Chunsoft (`src/map_files_table.c`, `src/ground_map_conversion_table.c`, `include/constants/ground_map.h`) ;
- Rend chaque `MAP_BG` (`BPL` + `BPC` + `BMA` + `BPA`) à sa résolution `1×` exacte via `moteur_gba_pmd_red_natif.py` dans `.cache/maps_pmdred/png/<CODE>.png` (et WebP animé si `BPL`/`BPA` animé) ;
- Génère `source/outil_maps_pmdred/index_rom.json` et la planche contact `source/outil_maps_pmdred/planches/planche_donjons_et_forets.jpg` (versionnés et légers).

Usage :
  .venv/bin/python source/outil_maps_pmdred/recuperer_maps.py rom [--only D01,D04,H07]
  .venv/bin/python source/outil_maps_pmdred/recuperer_maps.py cherche sinister
"""

from __future__ import annotations

import argparse
import json
import re
import subprocess
import sys
from pathlib import Path
from typing import Dict, List

from PIL import Image, ImageDraw

HERE = Path(__file__).resolve().parent
REPO_ROOT = HERE.parents[1]
if str(REPO_ROOT / "source") not in sys.path:
    sys.path.insert(0, str(REPO_ROOT / "source"))

import moteur_gba_pmd_red_natif as gba  # type: ignore

CACHE = REPO_ROOT / ".cache"
CLONE = CACHE / "pmd-red"
OUT = CACHE / "maps_pmdred"
PMD_RED_REPO = "https://github.com/pret/pmd-red.git"


def _git(*args: str, cwd: Path | None = None) -> str:
    return subprocess.run(["git", *args], cwd=cwd, check=True, capture_output=True, text=True).stdout


def ensure_clone() -> Path:
    paths = [
        "data/map_bg",
        "include/constants/ground_map.h",
        "src/map_files_table.c",
        "src/ground_map_conversion_table.c",
    ]
    CACHE.mkdir(parents=True, exist_ok=True)
    if not (CLONE / ".git").exists():
        _git("clone", "-q", "--filter=blob:none", "--no-checkout", PMD_RED_REPO, str(CLONE))
    _git("sparse-checkout", "set", "--no-cone", *paths, cwd=CLONE)
    _git("checkout", "-q", cwd=CLONE)
    return CLONE / "data" / "map_bg"


def parse_official_entries() -> List[Dict[str, object]]:
    mft_text = (CLONE / "src" / "map_files_table.c").read_text(encoding="utf-8")
    conv_text = (CLONE / "src" / "ground_map_conversion_table.c").read_text(encoding="utf-8")

    fid_to_map_names: Dict[str, List[str]] = {}
    for m in re.finditer(r"\[(MAP_\w+)\]\s*=\s*\{[^}]*?\.mapFileTableId\s*=\s*(MAP_FILE_ID_\w+)", conv_text, re.S):
        map_enum, fid = m.groups()
        fid_to_map_names.setdefault(fid, []).append(map_enum)

    out: List[Dict[str, object]] = []
    pat = re.compile(
        r"\[(MAP_FILE_ID_\w+)\]\s*=\s*\{\s*"
        r"\.bplFileName\s*=\s*\"([^\"]+)\",\s*"
        r"\.bpcFileName\s*=\s*\"([^\"]+)\",\s*"
        r"\.bmaFileName\s*=\s*\"([^\"]+)\",\s*"
        r"\.bpaFileNames\s*=\s*\{([^}]+)\}",
        re.S,
    )
    for m in pat.finditer(mft_text):
        fid, bpl, bpc, bma, bpas_raw = m.groups()
        bpas = re.findall(r"\"([^\"]+)\"", bpas_raw)
        out.append(
            {
                "file_id": fid,
                "code": bpl,
                "bpl": bpl,
                "bpc": bpc,
                "bma": bma,
                "bpa": bpas,
                "ground_maps": fid_to_map_names.get(fid, []),
            }
        )
    return out


def render_entry(map_bg: Path, ent: Dict[str, object]) -> tuple[Image.Image, List[Image.Image], Dict[str, object]]:
    bpl_path = map_bg / f"{ent['bpl']}.bpl"
    bpc_path = map_bg / f"{ent['bpc']}.bpc"
    bma_path = map_bg / f"{ent['bma']}.bma"
    bpas = ent["bpa"]
    bpa_path = (map_bg / f"{bpas[0]}.bpa") if bpas else (map_bg / "__none__.bpa")

    base_pals, _specs, anim_by_slot = gba.parse_bpl_full(bpl_path)
    cw, chh, base_tiles, chunks = gba.parse_bpc_fast(bpc_path)
    wt, ht, wc, hc, layers = gba.decode_bma_fast(bma_path)
    tpf, n_bpa, bpa_frames = gba.parse_bpa_fast(bpa_path)

    layer_grids = []
    for lay in reversed(layers):
        ti_grid = gba.np.zeros((ht, wt), dtype=gba.np.int32)
        hf_grid = gba.np.zeros((ht, wt), dtype=bool)
        vf_grid = gba.np.zeros((ht, wt), dtype=bool)
        pi_grid = gba.np.zeros((ht, wt), dtype=gba.np.int32)
        for cy in range(hc):
            for cx in range(wc):
                cid = lay[cy * 64 + cx]
                if cid <= 0 or cid >= len(chunks):
                    continue
                for i, cell in enumerate(chunks[cid]):
                    ti = int(cell) & 0x3FF
                    if ti == 0:
                        continue
                    tx, ty = cx * cw + (i % cw), cy * chh + (i // cw)
                    if tx < wt and ty < ht:
                        ti_grid[ty, tx] = ti
                        hf_grid[ty, tx] = bool((int(cell) >> 10) & 1)
                        vf_grid[ty, tx] = bool((int(cell) >> 11) & 1)
                        pi_grid[ty, tx] = (int(cell) >> 12) & 0xF
        layer_grids.append((ti_grid, hf_grid, vf_grid, pi_grid))

    def _draw_frame(phase: float | None, bf_idx: int) -> Image.Image:
        n_pals = len(base_pals)
        cur_pals = base_pals.copy()
        if phase is not None:
            for s_idx, frs in anim_by_slot.items():
                cnt = len(frs)
                cur_pals[s_idx] = frs[int(gba.np.floor((phase % 1.0) * cnt)) % cnt]
        if n_bpa > 0:
            all_t = gba.np.concatenate([base_tiles, bpa_frames[bf_idx % n_bpa]], axis=0)
        else:
            all_t = base_tiles
        out_rgba = gba.np.zeros((ht * 8, wt * 8, 4), dtype=gba.np.uint8)
        out_rgba[:, :, 3] = 255
        for ti_g, hf_g, vf_g, pi_g in layer_grids:
            valid = (ti_g > 0) & (ti_g < len(all_t))
            safe_ti = gba.np.where(valid, ti_g, 0)
            patches = all_t[safe_ti].copy()
            if gba.np.any(hf_g):
                patches[hf_g] = patches[hf_g][:, :, ::-1]
            if gba.np.any(vf_g):
                patches[vf_g] = patches[vf_g][:, ::-1, :]
            patches[~valid] = 0
            pal_lut = cur_pals[pi_g % n_pals]
            colored = gba.np.take_along_axis(pal_lut, patches.reshape(ht, wt, 64, 1), axis=2).reshape(ht, wt, 8, 8, 4)
            img = colored.transpose(0, 2, 1, 3, 4).reshape(ht * 8, wt * 8, 4)
            nz = img[:, :, 3] > 0
            out_rgba[nz] = img[nz]
        return Image.fromarray(out_rgba, mode="RGBA")

    f0 = _draw_frame(None, 0)
    anim_imgs: List[Image.Image] = []
    if anim_by_slot or n_bpa > 0:
        n_steps = max(8, n_bpa)
        for k in range(n_steps):
            anim_imgs.append(_draw_frame(k / float(n_steps), k))

    info = {
        "taille_px": [wt * 8, ht * 8],
        "couches_bma": len(layers),
        "bpl_slots_animes": sorted(anim_by_slot.keys()),
        "bpa_frames": int(n_bpa),
    }
    return f0, anim_imgs, info


def build_contact_sheet(rendered: List[tuple[Dict[str, object], Image.Image]]) -> None:
    planches_dir = HERE / "planches"
    planches_dir.mkdir(parents=True, exist_ok=True)
    # Sélectionne les entrées de donjons D01..D13 + les 8 Friend Areas Forêts H07P01..H07P08
    focus_prefixes = (
        "D01P01", "D02P01", "D03P01", "D03P02", "D04P01", "D05P01",
        "D06P01", "D07P01", "D07P02", "D08P01", "D09P01", "D10P01",
        "D11P01", "D11P03", "D12P01", "D13P01",
        "H07P01", "H07P02", "H07P03", "H07P04", "H07P05", "H07P06", "H07P07", "H07P08",
    )
    picked = [(e, im) for e, im in rendered if str(e["code"]) in focus_prefixes]
    if not picked:
        return
    cols = 4
    rows = (len(picked) + cols - 1) // cols
    tw, th = 320, 240
    sheet = Image.new("RGB", (cols * tw, rows * th), (14, 18, 24))
    for idx, (e, im) in enumerate(picked):
        thumb = im.convert("RGB").resize((tw, th), Image.Resampling.NEAREST)
        d = ImageDraw.Draw(thumb)
        label = str(e["file_id"]).replace("MAP_FILE_ID_", "").replace("FRIEND_AREA_", "FA_")
        d.rectangle([0, 0, tw, 20], fill=(0, 0, 0))
        d.text((5, 4), f"{e['code']} · {label[:34]}", fill=(255, 244, 130))
        sheet.paste(thumb, ((idx % cols) * tw, (idx // cols) * th))
    sheet.save(planches_dir / "planche_donjons_et_forets.jpg", quality=92, optimize=True)


def cmd_rom(args: argparse.Namespace) -> None:
    map_bg = ensure_clone()
    (OUT / "png").mkdir(parents=True, exist_ok=True)
    (OUT / "anim").mkdir(parents=True, exist_ok=True)
    entries = parse_official_entries()
    if args.only:
        prefixes = tuple(s.strip().upper() for s in args.only.split(",") if s.strip())
        entries = [e for e in entries if str(e["code"]).upper().startswith(prefixes)]

    catalog: List[Dict[str, object]] = []
    rendered_for_sheet: List[tuple[Dict[str, object], Image.Image]] = []
    for e in entries:
        code = str(e["code"])
        fid = str(e["file_id"]).replace("MAP_FILE_ID_", "").lower()
        stem = f"{code}_{fid}"
        try:
            f0, anims, info = render_entry(map_bg, e)
            f0.save(OUT / "png" / f"{stem}.png", optimize=True)
            if anims:
                anims[0].save(
                    OUT / "anim" / f"{stem}.webp",
                    save_all=True,
                    append_images=anims[1:],
                    duration=150,
                    loop=0,
                    lossless=True,
                )
            rec = {**e, **info, "png_cache": f".cache/maps_pmdred/png/{stem}.png", "erreur": None}
            rendered_for_sheet.append((rec, f0))
        except Exception as exc:
            rec = {**e, "erreur": f"{type(exc).__name__}: {exc}"}
        catalog.append(rec)

    commit_sha = _git("rev-parse", "HEAD", cwd=CLONE).strip()
    payload = {
        "source": {
            "depot": PMD_RED_REPO,
            "commit": commit_sha,
            "tables": ["src/map_files_table.c", "src/ground_map_conversion_table.c"],
            "decodeur": "source/moteur_gba_pmd_red_natif.py (1x bit-exact)",
        },
        "total": len(catalog),
        "maps": catalog,
    }
    (HERE / "index_rom.json").write_text(json.dumps(payload, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    build_contact_sheet(rendered_for_sheet)
    ok = sum(1 for r in catalog if not r.get("erreur"))
    print(f"[outil_maps_pmdred] {ok}/{len(catalog)} maps rendues -> {OUT} & index_rom.json")


def cmd_cherche(args: argparse.Namespace) -> None:
    idx_path = HERE / "index_rom.json"
    if not idx_path.is_file():
        raise SystemExit("Lancez d'abord : recuperer_maps.py rom")
    data = json.loads(idx_path.read_text(encoding="utf-8"))
    q = args.terme.lower()
    for m in data["maps"]:
        hay = " ".join([str(m.get("code", "")), str(m.get("file_id", "")), " ".join(m.get("ground_maps", []))]).lower()
        if q in hay:
            print(f"{m['code']:8s} | {m['file_id']:40s} | {m.get('taille_px')} | bpl_anim={m.get('bpl_slots_animes')}")


def main() -> None:
    ap = argparse.ArgumentParser(description="Extraction des maps de référence natives de PMD Red Rescue Team")
    sub = ap.add_subparsers(dest="cmd", required=True)
    p_rom = sub.add_parser("rom")
    p_rom.add_argument("--only", default="", help="Préfixes séparés par virgules, ex: D01,D04,H07")
    p_ch = sub.add_parser("cherche")
    p_ch.add_argument("terme")
    args = ap.parse_args()
    if args.cmd == "rom":
        cmd_rom(args)
    else:
        cmd_cherche(args)


if __name__ == "__main__":
    main()
