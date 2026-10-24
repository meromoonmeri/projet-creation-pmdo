#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Constructeur PMDO `0.8.12.0` — `DST1` & Pack Écran-Titre / Base Fangame
**Pokémon Mystery Dungeon : Destiny** (architecture unifiée *Halcyon* / *town02*).

Construit :
  1. `Content/BG/Title_Screen_Background.dir` (`320 × 240`, `24` poses animées en boucle sans logo,
     transition fluide **Crépuscule Doré ──▶ Heure Bleue ──▶ Soir & Nuit Étoilée Scintillante**).
  2. `Content/UI/Title.png` (`320 × 240` RGBA) + `Logo_PMD_Destiny_HD.png` (style *Super Mystery Dungeon*)
     + `Content/UI/Enter.png` (`74 × 11` RGBA).
  3. Carte Ground / Studio `DST1` (`pmd_destiny_menu_titre`, `768 × 576`, `10` calques séparés `00..09`,
     `< 24 000` tuiles `8×8` uniques par banque).
  4. Architecture Quest Halcyon / `town02` (`Mod.xml`, `Content/ContentParams.xml`,
     `Data/Script/halcyon/services/destiny_title_anim/init.lua`, `.zip` téléchargeables).
"""
from __future__ import annotations

import json
import shutil
import sys
import zipfile
from pathlib import Path
from typing import List, Tuple

import numpy as np
from PIL import Image

SOURCE_DIR = Path(__file__).resolve().parent.parent
REPO_ROOT = SOURCE_DIR.parent
for p in (str(REPO_ROOT), str(SOURCE_DIR)):
    if p not in sys.path:
        sys.path.insert(0, p)

from source.moteur_pmd_destiny_fangame import (
    DESTINY_MOD_XML,
    DESTINY_TITLE_ANIM_SERVICE_LUA,
    FRAME_TICKS_MENU,
    H_CANON as H_NAT,
    N_POSES,
    W_CANON as W_NAT,
    build_destiny_multilayer_scene_768x576,
    build_enter_ui_png_74x11,
    build_title_ui_png_320x240,
    decode_pmdo_dir_sheet,
    encode_pmdo_dir_sheet,
    extract_destiny_logo_hd,
)
from tour_celeste_moteur_nuages import H_CANON, W_CANON, LayerEntry, build_rsground_package  # type: ignore

MAP_ID = "DST1"
MAP_TITLE = "Pokémon Mystery Dungeon : Destiny — Écran-Titre Multicalque Crépuscule ──▶ Nuit Étoilée"
GROUND_ID = "pmd_destiny_menu_titre"

HERE = Path(__file__).resolve().parent
CANON_REF = HERE / "references" / "ref_canon_pmd_destiny_menu_titre.png"
RENDERS_DIR = REPO_ROOT / "renders" / "pmd_destiny_fangame_v1"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / f"{MAP_ID}_PMDO_0.8.12.zip"
PACK_DESTINY_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / "PACK_MENU_ET_BASE_PMD_DESTINY_0.8.12.zip"
STUDIO_MENU_CACHE = REPO_ROOT / ".cache" / "studio_layers" / "DST1_MENU"

CONTENT_PARAMS_XML = """<?xml version="1.0" encoding="utf-8"?>
<root>
<Sounds>
  <Hunger>Battle/DUN_Hunger</Hunger>
  <NullDmg>Battle/DUN_Miss_2</NullDmg>
  <Cursed>Battle/DUN_Sticky</Cursed>
  <Pickup>Battle/DUN_Pick_Up</Pickup>
  <PickupFoe>Battle/DUN_Pick_Up_Foe</PickupFoe>
  <Replace>Battle/EVT_CH02_Box_Open</Replace>
  <Place>Battle/EVT_CH02_Item_Place</Place>
  <Equip>Battle/DUN_Equip</Equip>
  <Money>Battle/DUN_Money</Money>
  <Leader>Battle/DUN_Leader_Change</Leader>
  <Revive>Battle/EVT_Title_Intro</Revive>
</Sounds>
<TitleBG>Title_Screen_Background</TitleBG>
<TitleBGM>Top Menu Theme.ogg</TitleBGM>
<MonsterBGM>Monster House!.ogg</MonsterBGM>
</root>
"""


def _resize_frames(frames: List[Image.Image], w: int, h: int) -> List[Image.Image]:
    if (w, h) == (W_NAT, H_NAT):
        return frames
    return [im.resize((w, h), Image.Resampling.NEAREST) for im in frames]


def _write_halcyon_ground_script(pkg_dir: Path, ground_id: str) -> None:
    hdir = pkg_dir / "Data" / "Script" / "halcyon" / "ground" / ground_id
    hdir.mkdir(parents=True, exist_ok=True)
    (hdir / "init.lua").write_text(
        f"require 'origin.common'\n"
        f"local {ground_id} = {{}}\n"
        f"function {ground_id}.Init(map) DEBUG.EnableDbgCoro() end\n"
        f"function {ground_id}.Enter(map)\n"
        f"  UI:WaitShowBG('Title_Screen_Background', {FRAME_TICKS_MENU}, 20)\n"
        f"  GAME:FadeIn(20)\n"
        f"end\n"
        f"function {ground_id}.Exit(map) end\n"
        f"function {ground_id}.Update(map) end\n"
        f"function {ground_id}.GameSave(map) end\n"
        f"function {ground_id}.GameLoad(map) GAME:FadeIn(20) end\n"
        f"return {ground_id}\n",
        encoding="utf-8",
    )


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray]:
    scene = build_destiny_multilayer_scene_768x576()
    raw_layers = scene["layers_768"]

    # Sauvegarde la référence canonique (pose 0 avec logo) si absente
    if not CANON_REF.is_file():
        CANON_REF.parent.mkdir(parents=True, exist_ok=True)
        comp0 = scene["bg_composites_768"][0].copy()
        comp0.alpha_composite(raw_layers[-1][3][0])
        comp0.convert("RGB").save(CANON_REF, format="PNG", optimize=True)

    layers: List[LayerEntry] = []
    for lid, label, kind, frames_list, flen in raw_layers:
        layers.append(
            LayerEntry(
                lid,
                label,
                kind,
                _resize_frames(frames_list, w, h),
                frame_length=flen,
            )
        )

    # Scène contemplative d'écran-titre : zone centrale basse praticable si chargée comme GroundMap
    gw, gh = w // 8, h // 8
    walk_grid = np.zeros((gh, gw), dtype=np.uint8)
    walk_grid[gh // 2 - 4 : gh // 2 + 4, gw // 2 - 8 : gw // 2 + 8] = 1
    return layers, walk_grid


def export_destiny_menu_and_fangame_pack(out_root: Path) -> dict:
    """Exporte `Content/BG/Title_Screen_Background.dir`, `Content/UI/{Title,Enter}.png`,
    la base Quest Halcyon/`town02` et le bundle `.zip` téléchargeable."""
    scene = build_destiny_multilayer_scene_768x576()
    bg_320_list: List[Image.Image] = scene["bg_frames_320x240"]  # type: ignore[assignment]
    bg_768_list: List[Image.Image] = scene["bg_composites_768"]  # type: ignore[assignment]
    logo_768: Image.Image = scene["layers_768"][-1][3][0]  # type: ignore[index]

    fangame_root = out_root / "fangame_base"
    if fangame_root.exists():
        shutil.rmtree(fangame_root)
    (fangame_root / "Content" / "BG").mkdir(parents=True, exist_ok=True)
    (fangame_root / "Content" / "UI").mkdir(parents=True, exist_ok=True)
    (fangame_root / "Data" / "Script" / "halcyon" / "services" / "destiny_title_anim").mkdir(parents=True, exist_ok=True)
    (fangame_root / "Strings").mkdir(parents=True, exist_ok=True)

    # 1. Mod.xml + ContentParams.xml + Service Lua temps réel TopMenu
    (fangame_root / "Mod.xml").write_text(DESTINY_MOD_XML, encoding="utf-8")
    (fangame_root / "Content" / "ContentParams.xml").write_text(CONTENT_PARAMS_XML, encoding="utf-8")
    (fangame_root / "Data" / "Script" / "halcyon" / "services" / "destiny_title_anim" / "init.lua").write_text(
        DESTINY_TITLE_ANIM_SERVICE_LUA,
        encoding="utf-8",
    )

    # 2. Content/BG/Title_Screen_Background.dir (320x240, 24 poses, 100 % SANS logo)
    dir_path = fangame_root / "Content" / "BG" / "Title_Screen_Background.dir"
    dir_info = encode_pmdo_dir_sheet(bg_320_list, dir_path, cols=6, rotate_type=0)
    atlas_decoded, trailer = decode_pmdo_dir_sheet(dir_path)
    assert trailer == (320, 240, 0, N_POSES), f"Trailer .dir inattendu : {trailer}"

    # 3. Content/UI/Title.png (320x240) + Enter.png (74x11) + Logo HD
    title_ui = build_title_ui_png_320x240()
    enter_ui = build_enter_ui_png_74x11()
    logo_hd = extract_destiny_logo_hd()

    title_ui.save(fangame_root / "Content" / "UI" / "Title.png", format="PNG", optimize=True)
    enter_ui.save(fangame_root / "Content" / "UI" / "Enter.png", format="PNG", optimize=True)

    # 4. Aperçus visuels & cache léger pour le simulateur interactif 60 FPS
    apercus_dir = out_root / "apercus_menu"
    apercus_dir.mkdir(parents=True, exist_ok=True)
    STUDIO_MENU_CACHE.mkdir(parents=True, exist_ok=True)

    logo_hd.save(apercus_dir / "Logo_PMD_Destiny_HD.png", format="PNG", optimize=True)
    title_ui.save(apercus_dir / "Title_320x240.png", format="PNG", optimize=True)
    enter_ui.save(apercus_dir / "Enter_74x11.png", format="PNG", optimize=True)

    atlas_decoded.save(STUDIO_MENU_CACHE / "Title_Screen_Background_atlas_6x4.png", format="PNG", optimize=True)
    title_ui.save(STUDIO_MENU_CACHE / "Title_320x240.png", format="PNG", optimize=True)
    enter_ui.save(STUDIO_MENU_CACHE / "Enter_74x11.png", format="PNG", optimize=True)
    logo_hd.save(STUDIO_MENU_CACHE / "Logo_PMD_Destiny_HD.png", format="PNG", optimize=True)

    bg_320_list[0].save(apercus_dir / "pose_00_crepuscule_dore_sans_logo_320x240.png", format="PNG", optimize=True)
    bg_320_list[6].save(apercus_dir / "pose_06_heure_bleue_sans_logo_320x240.png", format="PNG", optimize=True)
    bg_320_list[12].save(apercus_dir / "pose_12_nuit_etoilee_sans_logo_320x240.png", format="PNG", optimize=True)
    bg_320_list[13].save(apercus_dir / "pose_13_etoile_filante_sans_logo_320x240.png", format="PNG", optimize=True)

    for tag, p_idx, show_enter in (
        ("ecran_titre_complet_crepuscule_320x240.png", 0, True),
        ("ecran_titre_complet_nuit_etoilee_320x240.png", 12, True),
    ):
        scr = bg_320_list[p_idx].copy()
        scr.alpha_composite(title_ui, (0, 0))
        if show_enter:
            scr.alpha_composite(enter_ui, ((320 - enter_ui.width) // 2, 180))
        scr.save(apercus_dir / tag, format="PNG", optimize=True)

    hd_dusk_logo = bg_768_list[0].copy()
    hd_dusk_logo.alpha_composite(logo_768)
    hd_dusk_logo.save(apercus_dir / "scene_768x576_crepuscule_avec_logo.png", format="PNG", optimize=True)
    bg_768_list[12].save(apercus_dir / "scene_768x576_nuit_etoilee_sans_logo.png", format="PNG", optimize=True)
    hd_night_logo = bg_768_list[12].copy()
    hd_night_logo.alpha_composite(logo_768)
    hd_night_logo.save(apercus_dir / "scene_768x576_nuit_etoilee_avec_logo.png", format="PNG", optimize=True)

    # 5. Archive ZIP prête à déposer dans MODS/Pokemon_Mystery_Dungeon_Destiny/
    #    (inclut fangame_base + Content/Tile & Data/Ground de package sans dupliquer 45 Mo sur disque !)
    PACK_DESTINY_ZIP.parent.mkdir(parents=True, exist_ok=True)
    pkg_dir = out_root / "package"
    with zipfile.ZipFile(PACK_DESTINY_ZIP, "w", compression=zipfile.ZIP_DEFLATED) as zf:
        seen_arc: set[str] = set()
        for fpath in sorted(fangame_root.rglob("*")):
            if fpath.is_file():
                rel = fpath.relative_to(fangame_root).as_posix()
                arc = f"Pokemon_Mystery_Dungeon_Destiny/{rel}"
                zf.write(fpath, arcname=arc)
                seen_arc.add(arc)
        if pkg_dir.is_dir():
            for rel_sub in ("Content/Tile", "Data/Ground", "Data/Script/halcyon/ground"):
                src_sub = pkg_dir / rel_sub
                if src_sub.is_dir():
                    for fpath in sorted(src_sub.rglob("*")):
                        if fpath.is_file():
                            rel = fpath.relative_to(pkg_dir).as_posix()
                            arc = f"Pokemon_Mystery_Dungeon_Destiny/{rel}"
                            if arc not in seen_arc:
                                zf.write(fpath, arcname=arc)
                                seen_arc.add(arc)
        sh_script = REPO_ROOT / "CREER_FANGAME_PMD_DESTINY.sh"
        if sh_script.is_file():
            zf.write(sh_script, arcname="CREER_FANGAME_PMD_DESTINY.sh")

    return {
        "dir_info": dir_info,
        "logo_hd_size": list(logo_hd.size),
        "title_ui_size": list(title_ui.size),
        "enter_ui_size": list(enter_ui.size),
        "star_count": scene["star_count"],
        "pack_zip_bytes": PACK_DESTINY_ZIP.stat().st_size,
    }


def build(scale: float = 1.0, output_override: Path | None = None) -> dict:
    w = max(64, int(round(W_CANON * scale / 8)) * 8)
    h = max(64, int(round(H_CANON * scale / 8)) * 8)
    out_dir = output_override if output_override is not None else RENDERS_DIR
    vzip = (out_dir / f"{MAP_ID}_PMDO_0.8.12.zip") if output_override is not None else VIRTUAL_ZIP
    VIRTUAL_ZIP.parent.mkdir(parents=True, exist_ok=True)

    layers, walk_grid = build_layers_for_size(w, h)
    meta = build_rsground_package(
        map_id=MAP_ID,
        map_title=MAP_TITLE,
        layers=layers,
        walk_grid=walk_grid,
        renders_dir=out_dir,
        virtual_zip_path=vzip,
        canonical_ref_for_fidelity=CANON_REF,
        max_fidelity_distance=35.0,
        max_unique_tiles_per_bank=24000,
        namespace_override="pmd_destiny_dst1",
        asset_name_override=GROUND_ID,
    )
    _write_halcyon_ground_script(out_dir / "package", GROUND_ID)
    menu_info = export_destiny_menu_and_fangame_pack(out_dir)
    meta["width"] = w
    meta["height"] = h
    meta["destiny_menu"] = menu_info
    if output_override is None:
        (RENDERS_DIR / "metadata.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8")
    return meta


if __name__ == "__main__":
    info = build()
    print(json.dumps(info, indent=2, ensure_ascii=False))
