#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Genere quest_pmd_destiny/ : la quest PMDO Destiny 0.8.12 contenant TOUTES
les maps Ground de la bibliotheque, declarees COMME DANS town02.

Modele town02 (meromoonmeri/town02 — quest « New Era : Abyss to Ascension ») :
- Data/Zone/<zone>.json = ZoneData « zone conteneur » : "Segments": [] et
  "GroundMaps": [...noms d'AssetName...] (schema sky_hub_zone / master_zone) ;
- Data/Ground/<map>.rsground = les maps ;
- Data/Script/ground/<map>/init.lua ;
- Content/Tile/ + Content/BG/ (+ index.idx) ;
- Data/Zone/index.idx = registre Dictionary<string, ZoneEntrySummary> avec le
  champ "Grounds" listant les maps de chaque zone.

Usage :
    python3 OUTILS/construire_quest_destiny.py            # construit
    python3 OUTILS/construire_quest_destiny.py --dry-run  # analyse seule

La quest est generee depuis bibliotheque_ground/lots/ (construit si absent par
OUTILS/construire_bibliotheque_ground.py). Mod.xml est repris à l'IDENTIQUE de
la base Destiny (Namespace/UUID jamais modifies).
"""
from __future__ import annotations

import argparse
import json
import os
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BIB = ROOT / "bibliotheque_ground"
LOTS = BIB / "lots"
QUEST = ROOT / "quest_pmd_destiny"

MOD_XML_PATH = "renders/pmd_destiny_fangame_v1/fangame_base/Mod.xml"
MOD_XML_BRANCH = "origin/arena/e39626d2-projet-creation-pmdo"

# Libelles francais des lots (zones conteneurs)
ZONE_LABELS = {
    "cote_metano_dix_zones_lot2_pmdo": "Cote de Meta — Dix Zones (Lot 2)",
    "cote_metano_dix_zones_pmdo": "Cote de Meta — Dix Zones",
    "cote_metano_v2_pmdo": "Cote de Meta V2",
    "cotes_metano_abyss_0812_pmdo": "Cotes de Meta Abyss (0.8.12)",
    "cotes_v2_0812_pmdo": "Cotes V2 (0.8.12)",
    "mod_metano_expeditions_pmdo_0812": "Meta Expeditions (0.8.12)",
    "maps_branches": "Maps des branches (lot mixte)",
    "destiny_cliff_tests": "Destiny — falaises Cliff (tests)",
    "entree_falaise_trempee_sud_nord_v1": "Entree Falaise Trempee (sud-nord)",
    "entree_promontoire_nuages_sud_nord_v1": "Entree Promontoire aux Nuages",
    "entree_tourbiere_piliers_sud_nord_v1": "Entree Tourbiere aux Piliers",
    "fin_falaise_trempee_source_v1": "Fin Falaise Trempee (source)",
    "fin_promontoire_nuages_clairiere_v1": "Fin Promontoire aux Nuages (clairiere)",
    "reseau_metano_normal_v1": "Reseau Meta Normal V1",
    "references_dumpasset": "References PMDO / DumpAsset",
    "references_halcyon": "References Halcyon",
    "references_metano": "References Meta",
    "packages_destiny": "Packages Destiny (liens non resolus)",
}

ZONE_JSON_TEMPLATE = {
    "Version": "0.8.12.0",
    "Object": {
        "$type": "RogueEssence.Data.ZoneData, RogueEssence",
        "Name": {"DefaultText": "", "LocalTexts": {"fr": ""}},
        "Released": True,
        "Comment": "",
        "NoEXP": False,
        "ExpPercent": 100,
        "Level": -1,
        "LevelCap": False,
        "KeepSkills": False,
        "TeamRestrict": False,
        "TeamSize": -1,
        "MoneyRestrict": False,
        "BagRestrict": -1,
        "KeepTreasure": False,
        "BagSize": -1,
        "Persistent": False,
        "Rescues": 0,
        "Rogue": 0,
        "Segments": [],
        "GroundMaps": [],
    },
}

IDX_ENTRY_TEMPLATE = {
    "$type": "RogueEssence.Data.ZoneEntrySummary, RogueEssence",
    "ExpPercent": 100,
    "Level": -1,
    "LevelCap": False,
    "KeepSkills": False,
    "TeamRestrict": False,
    "TeamSize": -1,
    "MoneyRestrict": False,
    "BagRestrict": -1,
    "KeepTreasure": False,
    "BagSize": -1,
    "Rescues": 0,
    "CountedFloors": 0,
    "Rogue": 0,
    "Grounds": [],
    "Maps": [],
    "Name": {"DefaultText": "", "LocalTexts": {"fr": ""}},
    "Released": True,
    "Comment": "",
    "SortOrder": 0,
}

IDX_TYPE = ("System.Collections.Generic.Dictionary`2[[System.String, System.Private.CoreLib],"
            "[RogueEssence.Data.EntrySummary, RogueEssence]], System.Private.CoreLib")


def link_or_copy(src: Path, dst: Path) -> None:
    dst.parent.mkdir(parents=True, exist_ok=True)
    if dst.exists():
        dst.unlink()
    try:
        os.link(src, dst)
    except OSError:
        import shutil
        shutil.copy2(src, dst)


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--dry-run", action="store_true")
    args = ap.parse_args()

    # 1. bibliotheque prete ?
    if not LOTS.is_dir():
        print("bibliotheque_ground/lots/ absent — construction de la bibliotheque...")
        subprocess.run([sys.executable, str(ROOT / "OUTILS" / "construire_bibliotheque_ground.py")],
                       cwd=ROOT, check=True)
    if not LOTS.is_dir():
        print("ERREUR : impossible de construire la bibliotheque (ZIP a la racine manquants ? "
              "lancer d'abord python3 OUTILS/restaurer_apercus.py --fetch)")
        return 1

    # 2. Mod.xml de la quest (identique, jamais modifie)
    mod_xml = None
    for cand in (ROOT / MOD_XML_PATH,):
        if cand.is_file():
            mod_xml = cand.read_bytes()
            break
    if mod_xml is None:
        r = subprocess.run(["git", "show", f"{MOD_XML_BRANCH}:{MOD_XML_PATH}"],
                           cwd=ROOT, capture_output=True)
        if r.returncode == 0 and r.stdout.strip():
            mod_xml = r.stdout
    if mod_xml is None:
        print("ERREUR : Mod.xml introuvable (worktree et branche)")
        return 1

    # 3. lots -> quest
    zones: dict[str, dict] = {}
    taken: set[str] = set()
    total_maps = 0
    renames: list[str] = []

    for lotdir in sorted(LOTS.iterdir()):
        if not lotdir.is_dir():
            continue
        lot = lotdir.name
        maps_dir = lotdir / "Data" / "Ground"
        if not maps_dir.is_dir():
            continue
        names = sorted(p.name for p in maps_dir.glob("*.rsground"))
        if not names:
            continue
        zone_id = lot
        label = ZONE_LABELS.get(lot, lot)
        ground_names = []
        for n in names:
            final = n
            if final in taken:
                final = f"{lot}__{n}"
                renames.append(f"{n} -> {final}")
            taken.add(final)
            ground_names.append(final[:-len(".rsground")])
            if not args.dry_run:
                link_or_copy(maps_dir / n, QUEST / "Data" / "Ground" / final)
        # Content + scripts du lot
        if not args.dry_run:
            for sub in ("Content", "Data/Script"):
                src = lotdir / sub
                if src.is_dir():
                    for p in src.rglob("*"):
                        if p.is_file():
                            link_or_copy(p, QUEST / p.relative_to(lotdir))
        comment = (f"Zone conteneur des maps du lot {lot} — bibliotheque clampee "
                   f"({len(ground_names)} maps ; schema town02/sky_hub_zone). "
                   f"Source : {meta_source(lotdir)}")
        zj = json.loads(json.dumps(ZONE_JSON_TEMPLATE))
        zj["Object"]["Name"]["DefaultText"] = label
        zj["Object"]["Name"]["LocalTexts"]["fr"] = label
        zj["Object"]["Comment"] = comment
        zj["Object"]["GroundMaps"] = ground_names
        zones[zone_id] = {"zone": zj, "grounds": ground_names,
                          "label": label, "comment": comment}
        total_maps += len(ground_names)

    # 4. zones + index.idx
    if not args.dry_run:
        for sort_order, (zone_id, z) in enumerate(zones.items()):
            p = QUEST / "Data" / "Zone" / f"{zone_id}.json"
            p.parent.mkdir(parents=True, exist_ok=True)
            p.write_text(json.dumps(z["zone"], ensure_ascii=False, indent=1),
                         encoding="utf-8")
        idx = {"Version": "0.8.12.0", "Object": {"$type": IDX_TYPE}}
        for sort_order, (zone_id, z) in enumerate(zones.items()):
            e = json.loads(json.dumps(IDX_ENTRY_TEMPLATE))
            e["Grounds"] = z["grounds"]
            e["Name"]["DefaultText"] = z["label"]
            e["Name"]["LocalTexts"]["fr"] = z["label"]
            e["Comment"] = z["comment"]
            e["SortOrder"] = sort_order
            idx["Object"][zone_id] = e
        (QUEST / "Data" / "Zone" / "index.idx").write_text(
            json.dumps(idx, ensure_ascii=False, indent=1), encoding="utf-8-sig")
        (QUEST / "Mod.xml").write_bytes(mod_xml)

    print(f"quest_pmd_destiny : {len(zones)} zones conteneurs, {total_maps} maps declarees")
    if renames:
        print(f"{len(renames)} renommages d'homonymes :")
        for r in renames[:10]:
            print("  ", r)

    # 5. controle : GroundMaps == fichiers sur disque
    if not args.dry_run:
        on_disk = {p.name[:-len(".rsground")] for p in (QUEST / "Data" / "Ground").glob("*.rsground")}
        declared = {g for z in zones.values() for g in z["grounds"]}
        print(f"sur disque : {len(on_disk)} — declares : {len(declared)} — "
              f"ecart : {sorted(on_disk ^ declared)[:5] or 'aucun'}")
    return 0


def meta_source(lotdir: Path) -> str:
    lot = lotdir / "lot.json"
    if lot.is_file():
        try:
            return json.loads(lot.read_text(encoding="utf-8")).get("source", "?")
        except Exception:
            pass
    return "?"


if __name__ == "__main__":
    sys.exit(main())
