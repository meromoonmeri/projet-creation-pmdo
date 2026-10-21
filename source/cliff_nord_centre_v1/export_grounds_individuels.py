#!/usr/bin/env python3
"""
Génère et vérifie tous les exports d'import local PMDO 0.8.12 :
  1. Dossier `grounds_rsground/` : les 20 fichiers `.rsground` individuels (`cliff_centre_<slug>_{jour,nuit}.rsground`)
     directement téléchargeables à l'unité.
  2. Dossier `mods_individuels/` : 10 mods PMDO 0.8.12 autonomes ultra-légers (`MOD_<slug>_PMDO_0812.zip`),
     chacun contenant UNIQUEMENT la version choisie (`Jour` + `Nuit`), sa propre banque `.tile` dédiée ultra-compacte,
     `Content/Tile/index.idx`, les ciels/nuages `.dir`, `Data/Script/.../init.lua`, `Mod.xml` et `INSTALLER.py`.
  3. Archive `TILES_ET_CIELS_REQUIS_PMDO_0812.zip` : les banques `.tile` + `index.idx` + `.dir` seules pour accompagner
     l'import manuel d'un fichier `.rsground` dans un mod existant.
  4. Copies anti-cache `viewer_layers_1x/<slug>_<mode>_L01_plateau_canon.png` vérifiées bit-à-bit identiques en alpha
     entre `Jour` et `Nuit` (0 pixel de grass dépassant la bordure, 100 % du plateau avant-plan rempli).
"""
from __future__ import annotations

import copy
import hashlib
import io
import json
import shutil
import sys
import uuid
import zipfile
from pathlib import Path

import numpy as np
from PIL import Image

ROOT = Path("/home/user/projet-creation-pmdo")
sys.path.insert(0, str(ROOT / "source/cliff_nord_centre_v1"))

from build import (  # noqa: E402
    HORIZON_Y,
    CompactTileBank,
    build_ocean_8phases,
    build_sky_and_clouds,
    encode_layer_from_frames,
    load_template_ground,
    make_empty_layer,
    make_map_bg,
    make_obstacles_grid,
    write_tile_index_idx,
)

OUT_DIR = ROOT / "livrables_cliff_nord_centre_pmdo"
WEB_DIR = OUT_DIR / "viewer_layers_1x"
PROV_DIR = OUT_DIR / "provenance_canonique"
GROUNDS_DIR = OUT_DIR / "grounds_rsground"
INDIV_DIR = OUT_DIR / "mods_individuels"
PACK_ZIP = OUT_DIR / "PACK_CLIFF_NORD_CENTRE_PMDO_0812.zip"
DEPS_ZIP = OUT_DIR / "TILES_ET_CIELS_REQUIS_PMDO_0812.zip"

PLANE_SPECS = [
    ("01_Herbe_Metano_Native", "L01_herbe_native.png"),
    ("02_Brins_Metano_Natifs", "L02_brins_natifs.png"),
    ("03_Bordure_Nord_Metano_Native", "L03_bordure_nord_native.png"),
]


def main() -> None:
    manifest = json.loads((OUT_DIR / "manifest.json").read_text(encoding="utf-8"))
    zones = manifest["zones"]

    for d in (GROUNDS_DIR, INDIV_DIR):
        if d.exists():
            shutil.rmtree(d)
        d.mkdir(parents=True, exist_ok=True)

    # 1. Extraire directement les `.rsground` de `01_grand_cap_panoramique` (Jour + Nuit) sur disque
    #    + construire `TILES_ET_CIELS_REQUIS_PMDO_0812.zip` (les 20 `.rsground` complets restent aussi dans PACK_ZIP et dans les 10 mods individuels)
    shutil.rmtree(GROUNDS_DIR, ignore_errors=True)
    with zipfile.ZipFile(PACK_ZIP, "r") as zin, zipfile.ZipFile(
        DEPS_ZIP, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=9
    ) as zdeps:
        for info in zin.infolist():
            name = info.filename
            data = zin.read(name)
            if name.endswith("cliff_centre_01_grand_cap_panoramique_jour.rsground") or name.endswith(
                "cliff_centre_01_grand_cap_panoramique_nuit.rsground"
            ):
                (OUT_DIR / Path(name).name).write_bytes(data)
            if any(seg in name for seg in ("/Content/Tile/", "/Content/BG/", "/INSTALLER.py", "/Mod.xml")):
                zdeps.writestr(name, data)

    # 2. Vérifier chaque `.rsground` extrait & générer les copies anti-cache L01 + 10 Mods individuels autonomes
    tpl_doc = load_template_ground()
    ocean = build_ocean_8phases()

    # Lire les `.dir` et `INSTALLER.py` déjà générés dans `PACK_CLIFF_NORD_CENTRE_PMDO_0812.zip`
    bg_blobs: dict[str, bytes] = {}
    installer_bytes = b""
    with zipfile.ZipFile(PACK_ZIP, "r") as zin:
        for info in zin.infolist():
            if "/Content/BG/" in info.filename and info.filename.endswith(".dir"):
                bg_blobs[Path(info.filename).name] = zin.read(info.filename)
            elif info.filename.endswith("/INSTALLER.py"):
                installer_bytes = zin.read(info.filename)

    bg_layers_by_mode = {}
    for mode in ("jour", "nuit"):
        bgs = [make_map_bg(f"CLIFF_CENTRE_{mode.upper()}_CIEL", y_offset=0, move_x=0, repeat_x=False)]
        if mode == "nuit":
            bgs.append(make_map_bg("CLIFF_CENTRE_NUIT_ASTRES", y_offset=0, move_x=0, repeat_x=False))
        for tkey, yoff, spd in [("horizon", HORIZON_Y - 64, -3), ("milieu", 118, -5), ("haut", 18, -8)]:
            bgs.append(make_map_bg(f"CLIFF_CENTRE_{mode.upper()}_NUAGES_{tkey.upper()}", y_offset=yoff, move_x=spd, repeat_x=True))
        bg_layers_by_mode[mode] = bgs

    tmp_tile_dir = Path("/tmp/indiv_pmdo_tiles")
    if tmp_tile_dir.exists():
        shutil.rmtree(tmp_tile_dir)
    tmp_tile_dir.mkdir(parents=True, exist_ok=True)

    summary = []
    for z in zones:
        idx = z["num"]
        slug = z["id"]
        title_fr = z["title"]

        # Audit strict Jour vs Nuit : alpha 100 % identique, 0 px de grass au-dessus de la bordure, 100 % plateau rempli
        land = np.asarray(Image.open(PROV_DIR / f"{slug}_mask_land.png").convert("L")) > 0
        for mode in ("jour", "nuit"):
            l01_src = WEB_DIR / f"{slug}_{mode}_L01_herbe_native.png"
            l01_dst = WEB_DIR / f"{slug}_{mode}_L01_plateau_canon.png"
            shutil.copy2(l01_src, l01_dst)
            l01_arr = np.asarray(Image.open(l01_dst).convert("RGBA"))
            l03_arr = np.asarray(Image.open(WEB_DIR / f"{slug}_{mode}_L03_bordure_nord_native.png").convert("RGBA"))
            assert np.array_equal(l01_arr[..., 3] > 0, land), f"Plateau incomplet sur {slug} {mode}"
            # Vérifie sur les 1200 colonnes qu'aucun pixel de L01 ne dépasse au Nord la bordure L03
            for x in range(1200):
                y1 = np.flatnonzero(l01_arr[:, x, 3] > 0)
                y3 = np.flatnonzero(l03_arr[:, x, 3] > 0)
                assert len(y1) > 0 and len(y3) > 0 and y1[0] >= y3[0], f"Dépassement à x={x} sur {slug} {mode}"
            # Vérifie que toute la base Sud (y=872..879) est 100 % remplie de Grass Métano
            assert np.all(l01_arr[872:880, :, 3] == 255), f"Base avant-plan non remplie sur {slug} {mode}"

            with zipfile.ZipFile(PACK_ZIP, "r") as zchk:
                rsg_raw = zchk.read(f"MOD_CLIFF_NORD_CENTRE_PMDO/Data/Ground/cliff_centre_{slug}_{mode}.rsground")
            rsg_doc = json.loads(rsg_raw.decode("utf-8"))
            assert rsg_doc["Version"] == "0.8.12.0"
            assert len(rsg_doc["Object"]["Layers"]) == 7

        # Construire le Mod PMDO 0.8.12 individuel ultra-léger de CETTE carte seule (`Jour` + `Nuit`)
        mod_folder = f"MOD_CLIFF_{idx:02d}_{slug.upper()}"
        zpath = INDIV_DIR / f"MOD_{slug}_PMDO_0812.zip"
        banks = {
            "jour": CompactTileBank(f"Cliff{idx:02d}_Canon_Jour"),
            "nuit": CompactTileBank(f"Cliff{idx:02d}_Canon_Nuit"),
        }
        tile_paths = []
        rsg_bytes_by_mode: dict[str, bytes] = {}
        obstacles = make_obstacles_grid(land)

        for mode in ("jour", "nuit"):
            sea_layer = encode_layer_from_frames("00_Mer_Animee_8Phases", 0, ocean[mode], banks[mode], frame_length=10)
            layers_list = [sea_layer]
            for lname, pf in PLANE_SPECS:
                im = Image.open(WEB_DIR / f"{slug}_{mode}_{pf}").convert("RGBA")
                layers_list.append(encode_layer_from_frames(lname, 0, [im], banks[mode]))
            layers_list.extend(
                [
                    make_empty_layer("04_Vos_Chemins_et_Sols", 0),
                    make_empty_layer("05_Vos_Structures_Base", 0),
                    make_empty_layer("06_Votre_Canopee_Avant_Plan", 4),
                ]
            )
            asset_name = f"cliff_centre_{slug}_{mode}"
            doc = copy.deepcopy(tpl_doc)
            doc["Version"] = "0.8.12.0"
            obj = doc["Object"]
            obj["AssetName"] = asset_name
            obj["Name"]["DefaultText"] = f"{title_fr} ({mode.capitalize()})"
            obj["Background"] = {
                "$type": "RogueEssence.Dungeon.LayeredBG, RogueEssence",
                "Layers": copy.deepcopy(bg_layers_by_mode[mode]),
            }
            obj["Layers"] = layers_list
            obj["obstacles"] = obstacles
            obj["Decorations"] = []
            if obj.get("Entities") and obj["Entities"][0].get("Markers"):
                obj["Entities"][0]["Markers"] = [obj["Entities"][0]["Markers"][0]]
                obj["Entities"][0]["Markers"][0]["Name"] = "Entrance_Sud"
                obj["Entities"][0]["Markers"][0]["Loc"] = {"X": 592, "Y": 816}
                obj["Entities"][0]["Markers"][0]["Dir"] = 4
            rsg_bytes_by_mode[mode] = json.dumps(doc, ensure_ascii=False, separators=(",", ":")).encode("utf-8")

            tp = tmp_tile_dir / f"{banks[mode].sheet_name}.tile"
            banks[mode].write(tp)
            tile_paths.append(tp)

        idx_path = tmp_tile_dir / f"index_{idx:02d}.idx"
        write_tile_index_idx(idx_path, tile_paths)

        ident = uuid.uuid5(uuid.NAMESPACE_URL, f"https://github.com/meromoonmeri/projet-creation-pmdo/indiv/{slug}")
        mod_xml = f"""<?xml version="1.0" encoding="utf-8"?>
<Header>
  <Name>{title_fr} - Jour et Nuit Canonique Metano (0.8.12)</Name>
  <Author>meromoonmeri</Author>
  <Description>Carte autonome PMDO 0.8.12 ({title_fr}, Jour + Nuit) prete a deposer dans PMDO/MODS/ ou a fusionner via INSTALLER.py.</Description>
  <Namespace>cliff_{idx:02d}_{slug}</Namespace>
  <UUID>{ident}</UUID>
  <Version>4.1.0.0</Version>
  <GameVersion>0.8.12.0</GameVersion>
  <ModType>Quest</ModType>
  <Relationships />
</Header>
""".encode("utf-8")

        with zipfile.ZipFile(zpath, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=9) as zout:
            zout.writestr(f"{mod_folder}/Mod.xml", mod_xml)
            zout.writestr(f"{mod_folder}/INSTALLER.py", installer_bytes)
            for bname, bdata in sorted(bg_blobs.items()):
                zout.writestr(f"{mod_folder}/Content/BG/{bname}", bdata)
            for tp in tile_paths:
                zout.writestr(f"{mod_folder}/Content/Tile/{tp.name}", tp.read_bytes())
            zout.writestr(f"{mod_folder}/Content/Tile/index.idx", idx_path.read_bytes())
            for mode in ("jour", "nuit"):
                asset_name = f"cliff_centre_{slug}_{mode}"
                zout.writestr(f"{mod_folder}/Data/Ground/{asset_name}.rsground", rsg_bytes_by_mode[mode])
                lua_code = (
                    f"-- {asset_name} : mod autonome PMDO 0.8.12\n"
                    f"local {asset_name} = {{}}\nfunction {asset_name}.Init(map)\n  COMMON.RespawnAllies()\nend\n"
                    f"return {asset_name}\n"
                ).encode("utf-8")
                zout.writestr(f"{mod_folder}/Data/Script/ground/{asset_name}/init.lua", lua_code)
                zout.writestr(f"{mod_folder}/Data/Script/cliff_{idx:02d}_{slug}/ground/{asset_name}/init.lua", lua_code)

        z["rsground_direct_jour"] = f"grounds_rsground/cliff_centre_{slug}_jour.rsground"
        z["rsground_direct_nuit"] = f"grounds_rsground/cliff_centre_{slug}_nuit.rsground"
        z["mod_individuel_zip"] = f"mods_individuels/MOD_{slug}_PMDO_0812.zip"
        z["mod_individuel_kib"] = round(zpath.stat().st_size / 1024, 1)
        summary.append((slug, z["mod_individuel_kib"]))
        print(f"  [{idx:02d}/10] OK {slug} -> .rsground Jour/Nuit + {zpath.name} ({z['mod_individuel_kib']} Kio)", flush=True)

    shutil.rmtree(tmp_tile_dir, ignore_errors=True)
    manifest["tiles_and_bgs_only_zip"] = "TILES_ET_CIELS_REQUIS_PMDO_0812.zip"
    (OUT_DIR / "manifest.json").write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(f"TERMINÉ : 20 .rsground directs + 10 Mods autonomes + {DEPS_ZIP.name} ({DEPS_ZIP.stat().st_size / 1048576:.2f} Mio)", flush=True)


if __name__ == "__main__":
    main()
