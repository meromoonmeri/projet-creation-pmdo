#!/usr/bin/env python3
"""
Ajoute les 16 planches-palettes `.rsground` 100 % natives `meromoonmeri/town02` (`Jour` + `Nuit`, sans aucun `.tile` ni `.dir` externe)
pour l'intégralité des 8 packs de bâtiments & mobilier `livrables_*` du dépôt, portant `TOUTES_MAPS_TOWN02_RSGROUND.zip`
à **78 cartes `.rsground` autonomes couvrant 100 % des livrables du projet** !
"""
from __future__ import annotations

import json
import sys
import zipfile
from pathlib import Path
from typing import Dict, List, Tuple

import numpy as np
from PIL import Image

sys.path.insert(0, "/home/user/projet-creation-pmdo")
from source.compat_town02.build_all_town02_grounds import (
    ROOT,
    empty_autotile,
    load_town02_atlas,
    make_clean_base_doc,
    make_empty_map_layer,
)


def single_autotile(s: str, tx: int, ty: int) -> dict:
    return {
        "AutoTileset": "",
        "Associates": [],
        "Layers": [{"Frames": [{"Sheet": s, "TexLoc": {"X": int(tx), "Y": int(ty)}}], "FrameLength": 60}],
        "NeighborCode": -1,
    }


def stack_images(paths: List[Path], pad: int = 16) -> Image.Image:
    ims = [Image.open(p).convert("RGBA") for p in paths]
    w = max(im.width for im in ims)
    w = ((w + 7) // 8) * 8
    total_h = sum(((im.height + 7) // 8) * 8 for im in ims) + pad * max(0, len(ims) - 1)
    total_h = ((total_h + 7) // 8) * 8
    out = Image.new("RGBA", (w, total_h), (0, 0, 0, 0))
    y = 0
    for im in ims:
        out.alpha_composite(im, (0, y))
        y += ((im.height + 7) // 8) * 8 + pad
    return out


def pack_rows(paths: List[Path], max_row_w: int = 1280, pad: int = 16) -> Image.Image:
    ims = [Image.open(p).convert("RGBA") for p in paths]
    rows: List[List[Image.Image]] = []
    cur: List[Image.Image] = []
    cw = 0
    for im in ims:
        iw = ((im.width + 7) // 8) * 8
        if cur and cw + iw > max_row_w:
            rows.append(cur)
            cur = [im]
            cw = iw + pad
        else:
            cur.append(im)
            cw += iw + pad
    if cur:
        rows.append(cur)
    total_w = max(sum(((im.width + 7) // 8) * 8 for im in r) + pad * (len(r) - 1) for r in rows)
    total_w = ((total_w + 7) // 8) * 8
    row_hs = [max(((im.height + 7) // 8) * 8 for im in r) for r in rows]
    total_h = sum(row_hs) + pad * max(0, len(rows) - 1)
    out = Image.new("RGBA", (total_w, total_h), (0, 0, 0, 0))
    y = 0
    for r, rh in zip(rows, row_hs):
        x = 0
        for im in r:
            out.alpha_composite(im, (x, y))
            x += ((im.width + 7) // 8) * 8 + pad
        y += rh + pad
    return out


def main() -> None:
    match_blocks = load_town02_atlas()[3]
    tpl_doc = json.loads((ROOT / "cliffdaytest.rsground").read_bytes().decode("utf-8-sig"))

    boards: List[Tuple[str, str, Image.Image]] = [
        (
            "palette_guilde_jardin_secret_sky_peak_jour",
            "Palette Bâtiments Guilde Jardin Secret & Sky Peak (Jour — town02)",
            Image.open(ROOT / "livrables_guilde_jardin_secret_sky_peak_pmdo/1x_PMDO_8px_sans_fond/00_Planche_Complete_Jour_JardinSecret_SkyPeak.png").convert("RGBA"),
        ),
        (
            "palette_guilde_jardin_secret_sky_peak_nuit",
            "Palette Bâtiments Guilde Jardin Secret & Sky Peak (Nuit — town02)",
            Image.open(ROOT / "livrables_guilde_jardin_secret_sky_peak_pmdo/1x_PMDO_8px_sans_fond/00_Planche_Complete_Nuit_JardinSecret_SkyPeak.png").convert("RGBA"),
        ),
        (
            "palette_guilde_sans_escalier_jour",
            "Palette Bâtiments Guilde Sans Escalier Jardin & Sky Peak (Jour — town02)",
            Image.open(ROOT / "livrables_guilde_sans_escalier_pmdo/1x_PMDO_8px_sans_fond/00_Planche_Complete_Jour_SansEscalier_Jardin_SkyPeak.png").convert("RGBA"),
        ),
        (
            "palette_guilde_sans_escalier_nuit",
            "Palette Bâtiments Guilde Sans Escalier Jardin & Sky Peak (Nuit — town02)",
            Image.open(ROOT / "livrables_guilde_sans_escalier_pmdo/1x_PMDO_8px_sans_fond/00_Planche_Complete_Nuit_SansEscalier_Jardin_SkyPeak.png").convert("RGBA"),
        ),
        (
            "palette_treehouses_guilde_jour",
            "Palette 9 Cabanes & QG Guilde Treehouses (Jour — town02)",
            pack_rows(sorted((ROOT / "livrables_treehouses_guilde_pmdo/1x_PMDO_8px_sans_fond").glob("*_1x_complet.png"))),
        ),
        (
            "palette_treehouses_guilde_nuit",
            "Palette 9 Cabanes & QG Guilde Treehouses (Nuit — town02)",
            pack_rows(sorted((ROOT / "livrables_treehouses_guilde_pmdo/1x_PMDO_8px_sans_fond").glob("*_1x_nuit.png"))),
        ),
        (
            "palette_spinda_cafe_dojo_jour",
            "Palette 8 Bâtiments Spinda Café Style Dojo (Jour — town02)",
            Image.open(ROOT / "livrables_spinda_cafe_dojo_pmdo/1x_PMDO_8px_sans_fond/Planche_Complete_Spinda_Cafe_Dojo_PMDO_1x_Jour.png").convert("RGBA"),
        ),
        (
            "palette_spinda_cafe_dojo_nuit",
            "Palette 8 Bâtiments Spinda Café Style Dojo (Nuit — town02)",
            Image.open(ROOT / "livrables_spinda_cafe_dojo_pmdo/1x_PMDO_8px_sans_fond/Planche_Complete_Spinda_Cafe_Dojo_PMDO_1x_Nuit.png").convert("RGBA"),
        ),
        (
            "palette_maison_forgelina_kangourex_jour",
            "Palette 6 Maisons Forgelina Style Kangourex (Jour — town02)",
            Image.open(ROOT / "livrables_maison_forgelina_pmdo/1x_PMDO_8px_sans_fond/Planche_Complete_Maison_Forgelina_Kangourex_1x_Jour.png").convert("RGBA"),
        ),
        (
            "palette_maison_forgelina_kangourex_nuit",
            "Palette 6 Maisons Forgelina Style Kangourex (Nuit — town02)",
            Image.open(ROOT / "livrables_maison_forgelina_pmdo/1x_PMDO_8px_sans_fond/Planche_Complete_Maison_Forgelina_Kangourex_1x_Nuit.png").convert("RGBA"),
        ),
        (
            "palette_forgelina_tentes_huttes_jour",
            "Palette 11 Tentes, Huttes & Comptoirs Forgelina (Jour — town02)",
            Image.open(ROOT / "livrables_forgelina_pmdo/1x_PMDO_8px_sans_fond/Planche_Complete_Forgelina_Hut_Tileset_1x_Jour.png").convert("RGBA"),
        ),
        (
            "palette_forgelina_tentes_huttes_nuit",
            "Palette 11 Tentes, Huttes & Comptoirs Forgelina (Nuit — town02)",
            Image.open(ROOT / "livrables_forgelina_pmdo/1x_PMDO_8px_sans_fond/Planche_Complete_Forgelina_Hut_Tileset_1x_Nuit.png").convert("RGBA"),
        ),
        (
            "palette_evoli_tentes_bourg_tresor_jour",
            "Palette 6 Tentes & Bannières Évoli Bourg-Trésor (Jour — town02)",
            Image.open(ROOT / "livrables_tente_evoli_pmdo/1x_PMDO_8px_sans_fond/Planche_Complete_Tentes_Evoli_PMDO_1x_Jour.png").convert("RGBA"),
        ),
        (
            "palette_evoli_tentes_bourg_tresor_nuit",
            "Palette 6 Tentes & Bannières Évoli Bourg-Trésor (Nuit — town02)",
            Image.open(ROOT / "livrables_tente_evoli_pmdo/1x_PMDO_8px_sans_fond/Planche_Complete_Tentes_Evoli_PMDO_1x_Nuit.png").convert("RGBA"),
        ),
        (
            "palette_mobilier_spinda_kirlia_cabaret_jour",
            "Palette Comptoirs, Scène & Mobilier Spinda / Kirlia / Cabaret (Jour — town02)",
            stack_images(
                [
                    ROOT / "livrables_pmdo_sans_fond/tilesheets_import_pmdo_8px/Planche_00_Scene_et_Rideaux_Spinda_Troubadour_Jour_8px.png",
                    ROOT / "livrables_pmdo_sans_fond/tilesheets_import_pmdo_8px/Planche_01_Spinda_Qulbutoke_Sucreine_Jour_8px.png",
                    ROOT / "livrables_pmdo_sans_fond/tilesheets_import_pmdo_8px/Planche_02_Scene_Kirlia_Charmilly_Cabaret_Jour_8px.png",
                    ROOT / "livrables_pmdo_sans_fond/tilesheets_import_pmdo_8px/Planche_03_Piano_Jukebox_Table_Banquette_Jour_8px.png",
                    ROOT / "livrables_pmdo_sans_fond/tilesheets_import_pmdo_8px/Planche_04_Kiosque_Kirlia_Guichet_Jour_8px.png",
                ]
            ),
        ),
        (
            "palette_mobilier_spinda_kirlia_cabaret_nuit",
            "Palette Comptoirs, Scène & Mobilier Spinda / Kirlia / Cabaret (Nuit — town02)",
            stack_images(
                [
                    ROOT / "livrables_pmdo_sans_fond/tilesheets_import_pmdo_8px/Planche_00_Scene_et_Rideaux_Spinda_Troubadour_Nuit_8px.png",
                    ROOT / "livrables_pmdo_sans_fond/tilesheets_import_pmdo_8px/Planche_01_Spinda_Qulbutoke_Sucreine_Nuit_8px.png",
                    ROOT / "livrables_pmdo_sans_fond/tilesheets_import_pmdo_8px/Planche_02_Scene_Kirlia_Charmilly_Cabaret_Nuit_8px.png",
                ]
            ),
        ),
    ]

    added: Dict[str, bytes] = {}
    for asset_name, title, im in boards:
        w = (im.width // 8) * 8
        h = (im.height // 8) * 8
        arr = np.asarray(im.crop((0, 0, w, h)), dtype=np.uint8)
        gw, gh = w // 8, h // 8
        blocks = arr.reshape(gh, 8, gw, 8, 4).transpose(0, 2, 1, 3, 4).reshape(-1, 8, 8, 4)
        non_empty = np.any(blocks[..., 3] > 24, axis=(1, 2))
        q_idx = np.flatnonzero(non_empty)
        matched = match_blocks(blocks[q_idx])
        grid = [[None for _ in range(gh)] for _ in range(gw)]
        for k, flat_i in enumerate(q_idx):
            cy, cx = int(flat_i // gw), int(flat_i % gw)
            grid[cx][cy] = matched[k]
        doc = make_clean_base_doc(
            tpl_doc=tpl_doc,
            asset_name=asset_name,
            title=title,
            comment="Planche-palette `.rsground` 100 % native `meromoonmeri/town02` : ouvrez et copiez-collez directement n'importe quel bâtiment/meuble vers vos maps sans installer aucun `.tile` !",
            gw=gw,
            gh=gh,
            entry_px=(max(16, (w // 2) - 8), max(16, h - 32)),
        )
        doc["Object"]["Layers"] = [
            make_empty_map_layer("00_Sol_Fond_Vide", gw, gh, 0),
            {
                "Name": "01_Palette_Batiments_Et_Meubles_Base",
                "Layer": 0,
                "Visible": True,
                "Tiles": [
                    [single_autotile(*grid[cx][cy]) if grid[cx][cy] is not None else empty_autotile() for cy in range(gh)]
                    for cx in range(gw)
                ],
            },
            make_empty_map_layer("02_Avant_Plan_Over", gw, gh, 4),
        ]
        doc["Object"]["obstacles"] = [
            [{"Bounds": {"X": cx * 8, "Y": cy * 8, "Width": 8, "Height": 8}, "Tags": 0} for cy in range(gh)]
            for cx in range(gw)
        ]
        added[f"Data/Ground/{asset_name}.rsground"] = json.dumps(doc, ensure_ascii=False, separators=(",", ":")).encode("utf-8")

    zpath = ROOT / "livrables_cliff_nord_centre_pmdo/TOUTES_MAPS_TOWN02_RSGROUND.zip"
    items: Dict[str, bytes] = {}
    with zipfile.ZipFile(zpath, "r") as zin:
        for n in zin.namelist():
            items[n] = zin.read(n)
    items.update(added)

    readme = """# PACK UNIVERSEL `TOUTES_MAPS_TOWN02_RSGROUND.zip` — 78 CARTES `.rsground` 100 % COMPATIBLES `meromoonmeri/town02`

## Zéro fichier `.tile` à copier · Zéro fichier `.dir` à copier · Zéro crash de désérialisation !

Les **78 fichiers `.rsground`** contenus dans `Data/Ground/` utilisent **exclusivement** les banques de tuiles `Content/Tile/*.tile` déjà présentes dans `meromoonmeri/town02` :
1. **40 cartes `cliff_centre_<01..10>_<nuit|aube|crepuscule|jour>.rsground`** : les **10 falaises côtières au premier plan** (`Grass Métano` sans roche) dans les **4 ambiances animées de La Scène du Réveil** (`Nuit Pleine Lune + étoiles + reflet lunaire 12 phases`, `Aube`, `Crépuscule`, `Jour V24P04A`) avec les **nuages Chunsoft à 3 plans de l'ancienne version**.
2. **13 cartes `guilde_vide_*.rsground` & `cliff_north.rsground`** : tout le réseau de salles de Guilde vides en bois Métano + `cliff_north`.
3. **5 cartes `metano_gen_{accueil,cafe,casino,salon_bas,salon_haut}.rsground`** : les 5 salles intérieures du réseau Métano.
4. **4 cartes `cliffdaytest.rsground`, `cliffdaytest_nuit.rsground`, `cliffnordouesttest1.rsground`, `cliffnordouesttest1_nuit.rsground`** : réparées à 100 % sur `town02`.
5. **16 planches-palettes `palette_*_{jour,nuit}.rsground`** : tous les bâtiments & meubles du projet (`Treehouses Guilde`, `Arbres Jardin Secret & Sky Peak`, `Arbres Sans Escalier`, `Spinda Café Dojo`, `Maisons Forgelina Kangourex`, `Tentes & Huttes Forgelina`, `Tentes Évoli Bourg-Trésor`, `Comptoirs & Scène Spinda/Kirlia/Cabaret`) prêts à copier-coller directement entre cartes dans le Ground Editor !

---

## ⚠️ RÈGLE CRITIQUE PMDO 0.8.12 POUR ÉVITER `NullReferenceException` À L'ÉCRAN-TITRE !

Dans le code source officiel de **RogueEssence 0.8.12** (`GroundEditViewModel.cs`, lignes `306` et `314`), `mnuOpen_Click -> DoLoad(mapName)` lit **`ZoneManager.Instance.CurrentZone`**.
Or **sur l'écran-titre** (juste après `ExampleSvc: Deinit..` / `LuaEngine.OnGraphicsUnload()..`), **`CurrentZone` vaut `null`** — ce qui provoque `System.NullReferenceException` **sur absolument n'importe quel `.rsground`** si aucune partie / zone n'est active !

### Procédure en 2 clics (100 % garantie sans crash) :
1. Copiez les fichiers `.rsground` souhaités (ou tout le dossier `Data/Ground/` de cette archive) dans :
   `town02/Data/Ground/`
2. Lancez `RogueEssence.exe -dev`, puis **AVANT de cliquer sur `Edit -> Edit Ground`** :
   - **Soit** chargez votre sauvegarde sur le jeu principal ;
   - **Soit** dans la fenêtre **Dev** -> onglet **`Player`** ou **`Dev`** -> choisissez n'importe quelle Zone existante (ex. **`master_zone`** ou **`metano_town`**) -> cliquez sur **`Travel`**.
3. Cliquez maintenant sur **`Edit` -> `Edit Ground` -> `File` -> `Open`** et ouvrez **n'importe laquelle des 78 cartes `.rsground`** !
"""
    items["LISEZ_MOI_IMPORTANT_TOWN02.md"] = readme.encode("utf-8")

    with zipfile.ZipFile(zpath, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=9) as zout:
        for n in sorted(items.keys()):
            zout.writestr(n, items[n])
    print(f"Ajouté 16 planches-palettes -> {sum(k.endswith('.rsground') for k in items)} cartes `.rsground` dans TOUTES_MAPS_TOWN02_RSGROUND.zip ({zpath.stat().st_size / 1048576:.2f} MiB) !")


if __name__ == "__main__":
    main()
