#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Constructeur des **5 Maps d'Opening PMD en vue 3/4 Pixel-Art** (`576 × 320` = `72 × 40` tuiles `8×8`,
caméra PMDO `320 × 240`) + **13 acteurs sprites PMD multi-poses 8 directions** (`PMDCollab`)
suivant le schéma chorégraphique & la musique de `Simple and Clean -Ray of Hope MIX-` (`2aafI3XvKxo`).

Cohérence 100 % logique POV / échelle PMD (`Explorers of Sky` / PMDO `0.8.12.0`) :
  - `opm1_plage_cristal.png`       (576×320, <= 96 couleurs) : Plage Cristal & Lagon Turquoise
  - `opm2_abysse_vitrail.png`      (576×320, <= 96 couleurs) : Temple Marin Abyssal + Rosace Vitrail 3/4 incrustée
  - `opm3_arene_eau_miroir.png`    (576×320, <= 96 couleurs) : Arène Eau-Miroir des Ténèbres (16 piliers runiques)
  - `opm4_ciel_astral.png`         (576×320, <= 96 couleurs) : Plateforme Mosaïque Astrale & Nuages Célestes
  - `opm5_falaise_promontoire.png` (576×320, <= 96 couleurs) : Promontoire Fleuri & Mer Scintillante
"""
from __future__ import annotations

import json
import math
import shutil
import xml.etree.ElementTree as ET
from pathlib import Path
from typing import Dict, List, Tuple

import numpy as np
from PIL import Image, ImageDraw

SOURCE_DIR = Path(__file__).resolve().parent
REPO_ROOT = SOURCE_DIR.parent
BRUTS_DIR = SOURCE_DIR / "pmd_destiny_fangame_v1" / "opening_bruts"
SPRITECOLLAB_DIR = REPO_ROOT / ".cache" / "spritecollab"
OUT_DIR = REPO_ROOT / "renders" / "pmd_destiny_fangame_v1" / "opening_assets"
MAPS_OUT_DIR = OUT_DIR / "maps"
PMD_OUT_DIR = OUT_DIR / "pmd_sprites"

MAP_W = 576  # 72 tuiles 8x8 PMDO (256 px de débattement caméra 320x240)
MAP_H = 320  # 40 tuiles 8x8 PMDO (80 px de débattement caméra 320x240)


def quantize_pmd_map(im: Image.Image, n_colors: int = 96) -> Image.Image:
    """Redimensionne proprement et quantifie une map en pixel-art NDS/PMDO (`<= 96` couleurs)."""
    rgb = im.convert("RGB")
    # Légère réduction LANCZOS vers 576x320 puis quantification palette NDS nette sans tramage baveux
    resized = rgb.resize((MAP_W, MAP_H), Image.Resampling.LANCZOS)
    q = resized.quantize(colors=n_colors, method=Image.Quantize.FASTOCTREE, dither=Image.Dither.NONE)
    return q.convert("RGBA")


def extract_vitrail_circle_magenta(path: Path, target_size: int = 240) -> Image.Image:
    """Extrait la rosace vitrail circulaire PMD sur fond `#FF00FF` (`0 px` magenta)."""
    src = Image.open(path).convert("RGBA")
    arr = np.asarray(src, dtype=np.uint8)
    h, w, _ = arr.shape
    r = arr[:, :, 0].astype(np.int16)
    g = arr[:, :, 1].astype(np.int16)
    b = arr[:, :, 2].astype(np.int16)
    diff_m = np.minimum(r, b) - g

    fg_raw = ~((diff_m >= 58) & (r >= 165) & (b >= 165))
    ys, xs = np.where(fg_raw)
    cx = 0.5 * (float(xs.min()) + float(xs.max()))
    cy = 0.5 * (float(ys.min()) + float(ys.max()))
    rad = 0.5 * min(float(xs.max() - xs.min()), float(ys.max() - ys.min())) - 3.0

    yy, xx = np.mgrid[0:h, 0:w]
    d_center = np.hypot(xx - cx, yy - cy)
    mask = d_center <= rad

    out = arr.copy()
    rim = (d_center >= rad - 8.0) & mask & (diff_m >= 32)
    out[rim, 1] = np.minimum(255, out[rim, 1].astype(np.int16) + diff_m[rim] // 2).astype(np.uint8)
    out[:, :, 3] = np.where(mask, 255, 0).astype(np.uint8)
    out[~mask, :3] = 0

    x0, x1 = max(0, int(round(cx - rad))), min(w, int(round(cx + rad)))
    y0, y1 = max(0, int(round(cy - rad))), min(h, int(round(cy + rad)))
    cropped = Image.fromarray(out[y0:y1, x0:x1], mode="RGBA")
    small = cropped.resize((target_size, target_size), Image.Resampling.LANCZOS)

    # Pixelisation palette NDS <= 64 couleurs avec alpha binaire net
    s_arr = np.asarray(small, dtype=np.uint8)
    fg = s_arr[:, :, 3] >= 128
    q_rgb = Image.fromarray(s_arr[:, :, :3], mode="RGB").quantize(
        colors=64, method=Image.Quantize.FASTOCTREE, dither=Image.Dither.NONE
    ).convert("RGB")
    q_arr = np.asarray(q_rgb, dtype=np.uint8)
    res = np.zeros((target_size, target_size, 4), dtype=np.uint8)
    res[fg, :3] = q_arr[fg]
    res[fg, 3] = 255
    return Image.fromarray(res, mode="RGBA")


def build_wayfinder_badge_pixelart(gem_rgb: Tuple[int, int, int], rim_rgb: Tuple[int, int, int]) -> Image.Image:
    """Crée un charme étoile Œuf-Ailé *Wayfinder* `28×28` à l'échelle exacte des sprites PMD `32×48`."""
    hi = 84
    im = Image.new("RGBA", (hi, hi), (0, 0, 0, 0))
    draw = ImageDraw.Draw(im)
    cx, cy = hi / 2.0, hi / 2.0
    pts: List[Tuple[float, float]] = []
    for i in range(10):
        ang = -math.pi / 2.0 + i * (math.pi / 5.0)
        rad = (hi * 0.44 if i % 2 == 0 else hi * 0.21)
        pts.append((cx + math.cos(ang) * rad, cy + math.sin(ang) * rad))
    draw.polygon(pts, fill=(32, 22, 10, 255))
    pts_m = [(cx + (x - cx) * 0.86, cy + (y - cy) * 0.86) for x, y in pts]
    draw.polygon(pts_m, fill=rim_rgb + (255,))
    pts_i = [(cx + (x - cx) * 0.68, cy + (y - cy) * 0.68) for x, y in pts]
    draw.polygon(pts_i, fill=gem_rgb + (255,))
    # Mini Œuf PMD au centre
    ew, eh = hi * 0.14, hi * 0.18
    draw.ellipse([cx - ew * 2.0, cy - eh * 0.5, cx + ew * 2.0, cy + eh * 0.4], fill=(255, 248, 204, 255))
    draw.ellipse([cx - ew, cy - eh, cx + ew, cy + eh], fill=(252, 250, 246, 255), outline=(56, 32, 20, 255))
    draw.pieslice([cx - ew, cy - eh, cx + ew, cy + eh], start=10, end=170, fill=(240, 124, 114, 255))

    small = im.resize((28, 28), Image.Resampling.NEAREST)
    arr = np.asarray(small, dtype=np.uint8).copy()
    arr[:, :, 3] = np.where(arr[:, :, 3] >= 110, 255, 0).astype(np.uint8)
    arr[arr[:, :, 3] == 0, :3] = 0
    return Image.fromarray(arr, mode="RGBA")


def make_shadow_corrupted_sheet(src_im: Image.Image) -> Image.Image:
    """Variante 'Ombre Corrompue' PMD (silhouette indigo-obsidienne + yeux/griffes ambre lumineux)."""
    arr = np.asarray(src_im.convert("RGBA"), dtype=np.uint8).copy()
    fg = arr[:, :, 3] > 0
    r = arr[:, :, 0].astype(np.float32)
    g = arr[:, :, 1].astype(np.float32)
    b = arr[:, :, 2].astype(np.float32)
    lum = 0.299 * r + 0.587 * g + 0.114 * b

    warm_eye = fg & (((r > 165) & (r > b + 35)) | (lum > 225))
    nr = np.clip(lum * 0.26 + 24.0, 0, 255)
    ng = np.clip(lum * 0.16 + 10.0, 0, 255)
    nb = np.clip(lum * 0.52 + 58.0, 0, 255)

    dark_edge = fg & (lum < 55)
    nr[dark_edge], ng[dark_edge], nb[dark_edge] = 96, 28, 158
    nr[warm_eye], ng[warm_eye], nb[warm_eye] = 255, 196, 38

    arr[:, :, 0] = nr.astype(np.uint8)
    arr[:, :, 1] = ng.astype(np.uint8)
    arr[:, :, 2] = nb.astype(np.uint8)
    return Image.fromarray(arr, mode="RGBA")


def load_credit_map() -> Dict[str, str]:
    cmap: Dict[str, str] = {}
    p = SPRITECOLLAB_DIR / "credit_names.txt"
    if p.is_file():
        for line in p.read_text(encoding="utf-8", errors="ignore").splitlines():
            parts = line.split("\t")
            if len(parts) >= 2 and parts[1].strip():
                cmap[parts[1].strip()] = parts[0].strip()
    return cmap


def resolve_credits_file(cpath: Path, cmap: Dict[str, str]) -> List[str]:
    names: List[str] = []
    if not cpath.is_file():
        return names
    for line in cpath.read_text(encoding="utf-8", errors="ignore").splitlines():
        for tok in line.split("\t")[1:]:
            tok = tok.strip()
            if tok and (tok.startswith("0x") or tok in cmap):
                nm = cmap.get(tok, tok)
                if nm not in names:
                    names.append(nm)
    return names[:8]


POKEMON_SPECS: List[Tuple[str, str, List[str], List[str]]] = [
    (
        "0447",
        "Riolu",
        ["Idle", "Walk", "Attack", "Strike", "QuickStrike", "Double", "Swing", "RearUp", "Charge", "Hop", "LeapForth", "Rotate", "Float", "Sink", "Hurt", "Pain", "TumbleBack", "Wake", "LookUp", "Pose", "Pull"],
        ["Normal", "Determined", "Shouting", "Surprised", "Inspired", "Joyous", "Teary-Eyed", "Pain", "Sad", "Worried"],
    ),
    (
        "0448",
        "Lucario",
        ["Idle", "Walk", "Attack", "Strike", "QuickStrike", "Double", "Swing", "RearUp", "Charge", "Hop", "LeapForth", "Rotate", "Float", "Sink", "EventSleep", "Hurt", "Pain", "TumbleBack", "HitGround", "Wake", "LookUp", "Pose", "Pull", "DeepBreath"],
        ["Normal", "Determined", "Shouting", "Surprised", "Inspired", "Joyous", "Sad", "Pain", "Sigh"],
    ),
    (
        "0133",
        "Evoli",
        ["Idle", "Walk", "Attack", "Double", "Swing", "Shoot", "TailWhip", "Charge", "Hop", "LeapForth", "Rotate", "Float", "Sink", "Hurt", "Pain", "Wake", "LookUp", "Pose", "Pull"],
        ["Normal", "Determined", "Shouting", "Surprised", "Inspired", "Joyous", "Teary-Eyed", "Worried", "Sad"],
    ),
    (
        "0393",
        "Tiplouf",
        ["Idle", "Walk", "Attack", "Double", "Swing", "Shoot", "Hover", "Hop", "Rotate", "Float", "Sink", "Hurt", "Pose", "LookUp"],
        ["Normal", "Joyous", "Surprised", "Inspired", "Worried", "Determined", "Sad"],
    ),
    (
        "0253",
        "Massko",
        ["Idle", "Walk", "Attack", "Strike", "Double", "Swing", "Shoot", "Charge", "Hop", "Rotate", "Float", "Sink", "Hurt", "Pain", "Pose", "LookUp"],
        ["Normal", "Determined", "Surprised", "Joyous", "Pain", "Sad"],
    ),
    (
        "0251",
        "Celebi",
        ["Idle", "Walk", "Attack", "Double", "Swing", "Shoot", "Twirl", "Hop", "Rotate", "Float", "Sink", "Hurt", "Pose"],
        ["Normal", "Joyous", "Surprised", "Stunned", "Inspired", "Determined"],
    ),
    (
        "0490",
        "Manaphy",
        ["Idle", "Walk", "Double", "RearUp", "Hop", "Rotate", "Float", "Pose", "Hurt", "Sleep", "Shoot", "Attack"],
        ["Normal", "Joyous", "Inspired", "Surprised", "Sad"],
    ),
    ("0380", "Latias", ["Idle", "Walk", "Attack", "Shoot", "Hop", "Rotate"], []),
    ("0381", "Latios", ["Idle", "Walk", "Attack", "Shoot", "Hop", "Rotate"], []),
    ("0571", "Zoroark", ["Idle", "Walk", "Attack", "Double", "Swing", "Shoot", "Charge", "Hop", "Rotate", "Hurt"], []),
    ("0492", "Shaymin (Sky)", ["Idle", "Walk", "Float", "Hop", "Rotate", "Pose", "Appeal", "Hurt", "Sleep", "Eat", "Shoot", "Attack", "Sit", "Wake", "Nod", "LookUp", "Pull", "Pain", "Laying"], ["Normal", "Sad", "Teary-Eyed", "Worried", "Joyous", "Determined"]),
    ("0151", "Mew", ["Idle", "Walk", "Float", "Hop", "Rotate", "Pose", "Twirl", "Charge", "Double", "Nod", "LookUp", "Hurt", "Sleep", "Shoot", "Attack"], ["Normal", "Joyous", "Determined", "Surprised"]),
    ("0278", "Goélise", ["Idle", "Walk", "Hover", "Sleep", "Hurt", "Shoot", "Attack", "Swing", "Hop", "Rotate"], []),
    ("0279", "Bekipan", ["Idle", "Walk", "Sleep", "Hurt", "Shoot", "SpAttack", "Attack", "Swing", "Hop", "Rotate"], []),
    # Guilde de Grodoudou (Explorers), Gardevoir et anciens héros de PMD (Rescue Team) : apparitions de l'Opening « Last Moment »
    ("0282", "Gardevoir", ["Idle", "Appeal"], []),
    ("0040", "Grodoudou", ["Idle", "Hop"], []),
    ("0441", "Perroquel", ["Idle", "Float"], []),
    ("0294", "Chuchmur", ["Idle"], []),
    ("0050", "Taupiqueur", ["Idle"], []),
    ("0051", "Triopikeur", ["Idle"], []),
    ("0399", "Keunotor", ["Idle"], []),
    ("0341", "Écrapince", ["Idle"], []),
    ("0453", "Cradopaud", ["Idle"], []),
    ("0192", "Héliatronc", ["Idle"], []),
    ("0025", "Pikachu", ["Idle"], []),
    ("0004", "Salamèche", ["Idle"], []),
    ("0007", "Carapuce", ["Idle"], []),
    ("0001", "Bulbizarre", ["Idle"], []),
    ("0052", "Miaouss", ["Idle"], []),
    ("0054", "Psykokwak", ["Idle"], []),
    ("0491", "Darkrai", ["Idle", "Walk", "Attack", "QuickStrike", "Double", "Swing", "Shoot", "RearUp", "Charge", "Rotate", "Hurt"], []),
]


SUBFORMS = {"0492": "0492/0001"}  # Shaymin forme Céleste


def export_pmd_sprites_and_manifest() -> dict:
    if PMD_OUT_DIR.exists():
        shutil.rmtree(PMD_OUT_DIR)
    PMD_OUT_DIR.mkdir(parents=True, exist_ok=True)
    cmap = load_credit_map()
    catalog: dict = {"pokemon": {}, "credits_summary": []}

    for pid, label, wanted_anims, wanted_portraits in POKEMON_SPECS:
        src_sp = SPRITECOLLAB_DIR / "sprite" / SUBFORMS.get(pid, pid)
        src_pt = SPRITECOLLAB_DIR / "portrait" / pid
        dst_sp = PMD_OUT_DIR / pid
        dst_sp.mkdir(parents=True, exist_ok=True)

        root = ET.parse(src_sp / "AnimData.xml").getroot()
        raw_anims: Dict[str, ET.Element] = {
            a.findtext("Name"): a for a in root.findall("./Anims/Anim") if a.findtext("Name")
        }

        anim_meta: dict = {}
        for req in wanted_anims:
            if req not in raw_anims:
                continue
            el = raw_anims[req]
            target_name = req
            while el.findtext("CopyOf"):
                target_name = el.findtext("CopyOf") or target_name
                el = raw_anims[target_name]

            png_src = src_sp / f"{target_name}-Anim.png"
            if not png_src.is_file():
                continue
            png_dst = dst_sp / f"{target_name}-Anim.png"
            if not png_dst.is_file():
                shutil.copy2(png_src, png_dst)

            im = Image.open(png_dst)
            fw = int(el.findtext("FrameWidth") or im.width)
            fh = int(el.findtext("FrameHeight") or im.height)
            durs = [int(d.text or "4") for d in el.findall("./Durations/Duration")]
            cols = max(1, im.width // fw)
            rows = max(1, im.height // fh)
            anim_meta[req] = {
                "file": f"{pid}/{target_name}-Anim.png",
                "fw": fw,
                "fh": fh,
                "cols": cols,
                "rows": rows,
                "durations": durs if durs else [4] * cols,
                "hit": int(el.findtext("HitFrame")) if el.findtext("HitFrame") is not None else -1,
                "rush": int(el.findtext("RushFrame")) if el.findtext("RushFrame") is not None else -1,
            }

        pt_meta: Dict[str, str] = {}
        if src_pt.is_dir():
            for emo in wanted_portraits:
                p_in = src_pt / f"{emo}.png"
                if p_in.is_file():
                    p_out = dst_sp / f"pt_{emo}.png"
                    shutil.copy2(p_in, p_out)
                    pt_meta[emo] = f"{pid}/pt_{emo}.png"

        sp_authors = resolve_credits_file(src_sp / "credits.txt", cmap)
        pt_authors = resolve_credits_file(src_pt / "credits.txt", cmap) if src_pt.is_dir() else []
        authors = list(dict.fromkeys(sp_authors + pt_authors))
        catalog["credits_summary"].append({"id": pid, "name": label, "authors": authors})
        catalog["pokemon"][pid] = {"name": label, "anims": anim_meta, "portraits": pt_meta, "authors": authors}

        if pid in ("0253", "0571", "0447", "0393"):
            sh_id = f"shadow_{pid}"
            dst_sh = PMD_OUT_DIR / sh_id
            dst_sh.mkdir(parents=True, exist_ok=True)
            sh_anims: dict = {}
            for aname, info in anim_meta.items():
                orig_im = Image.open(PMD_OUT_DIR / info["file"])
                sh_im = make_shadow_corrupted_sheet(orig_im)
                sh_fn = Path(info["file"]).name
                sh_im.save(dst_sh / sh_fn, format="PNG", optimize=True)
                sh_info = dict(info)
                sh_info["file"] = f"{sh_id}/{sh_fn}"
                sh_anims[aname] = sh_info
            catalog["pokemon"][sh_id] = {
                "name": f"{label} (Ombre)",
                "anims": sh_anims,
                "portraits": {},
                "authors": authors,
            }

    return catalog


def build_opening_assets() -> dict:
    if OUT_DIR.exists():
        shutil.rmtree(OUT_DIR)
    MAPS_OUT_DIR.mkdir(parents=True, exist_ok=True)

    manifest: dict = {"maps": {}, "props": {}}

    # 1. Les 5 Maps d'Opening PMD en vue 3/4 Pixel-Art (576 x 320, <= 96 couleurs)
    map_specs = [
        ("op_pmdmap_01_plage.png", "opm1_plage_cristal.png"),
        ("op_pmdmap_02_abysse_vitrail.png", "opm2_abysse_vitrail.png"),
        ("op_pmdmap_03_arene_eau_miroir.png", "opm3_arene_eau_miroir.png"),
        ("op_pmdmap_05_ciel_astral_fracture.png", "opm4_ciel_astral.png"),
        ("op_pmdmap_04_falaise_promontoire.png", "opm5_falaise_promontoire.png"),
    ]
    for src_fn, dst_fn in map_specs:
        q_map = quantize_pmd_map(Image.open(BRUTS_DIR / src_fn), n_colors=96)
        out_p = MAPS_OUT_DIR / dst_fn
        q_map.save(out_p, format="PNG", optimize=True)
        n_cols = len(np.unique(np.asarray(q_map)[:, :, :3].reshape(-1, 3), axis=0))
        assert n_cols <= 96, f"Trop de couleurs sur {dst_fn}: {n_cols}"
        manifest["maps"][dst_fn] = {"size": [MAP_W, MAP_H], "colors": int(n_cols), "bytes": out_p.stat().st_size}

    # 2. Rosace Vitrail Pixel-Art 3/4 (légèrement aplatie en 3/4 RPG 196x174 pour s'incruster dans la dalle ronde d'OPM2 & le portail d'OPM3 !)
    vitrail_sq = extract_vitrail_circle_magenta(BRUTS_DIR / "op_vitrail_destin_pmd_magenta.png", target_size=196)
    vitrail_34 = vitrail_sq.resize((192, 174), Image.Resampling.NEAREST)
    vp = OUT_DIR / "vitrail_dais_pmd_pixel.png"
    vitrail_34.save(vp, format="PNG", optimize=True)
    manifest["props"]["vitrail_dais_pmd_pixel.png"] = {"size": list(vitrail_34.size), "bytes": vp.stat().st_size}

    # 3. 3 Badges Étoiles Œuf-Ailé Pixel-Art 28x28
    for w_name, gem, rim in (
        ("wayfinder_cyan.png", (38, 198, 248), (248, 214, 112)),
        ("wayfinder_emerald.png", (42, 218, 142), (242, 206, 98)),
        ("wayfinder_amber.png", (252, 168, 56), (255, 226, 132)),
    ):
        wf = build_wayfinder_badge_pixelart(gem, rim)
        wp = OUT_DIR / w_name
        wf.save(wp, format="PNG", optimize=True)
        manifest["props"][w_name] = {"size": list(wf.size), "bytes": wp.stat().st_size}

    # 4. Catalogue complet des sprites multi-poses 8 directions + ombres corrompues
    manifest["pmd_catalog"] = export_pmd_sprites_and_manifest()

    (OUT_DIR / "manifest.json").write_text(json.dumps(manifest, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    total_mb = sum(p.stat().st_size for p in OUT_DIR.rglob("*") if p.is_file()) / (1024 * 1024)
    print(f"OK — 5 Maps Opening PMD 3/4 (576x320 <=96c) + 13 Acteurs Multi-Poses exportés ({total_mb:.2f} Mo)")
    return manifest


if __name__ == "__main__":
    build_opening_assets()
