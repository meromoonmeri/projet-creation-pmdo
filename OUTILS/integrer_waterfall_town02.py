#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Intègre les 2 maps WaterfallVillage de town02 (fichiers Git LFS) dans la quest.

Les maps `WaterfallVillageCapital.rsground` (233 Mo) et `waterfall_cave_1.rsground`
sont stockées en **Git LFS** dans meromoonmeri/town02 : le sandbox ne peut pas
télécharger les objets LFS (hébergeur bloqué). Depuis une machine qui dispose
du vrai contenu (votre clone local de town02 après `git lfs pull`), ce script :

1. lit les deux `.rsground` (chemins passés en argument ou auto-détectés) ;
2. les clampe comme la bibliothèque (frontière, hors-zone) ;
3. les écrit dans `bibliotheque_ground/lots/town02_waterfallvillage/` ;
4. recopie les scripts Data/Script/halcyon/ground/WaterfallVillageCapital
   et les refs Content manquantes si présentes à côté ;
5. relance `OUTILS/construire_quest_destiny.py` et régénère l'index des tuiles.

Usage :
    python3 OUTILS/integrer_waterfall_town02.py --depuis /chemin/vers/town02
    python3 OUTILS/integrer_waterfall_town02.py --fichiers WVC.rsground wc1.rsground
"""
from __future__ import annotations

import argparse
import importlib.util
import json
import shutil
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BIB_LOTS = ROOT / "bibliotheque_ground" / "lots"
QUEST = ROOT / "quest_pmd_destiny"
LOT = "town02_waterfallvillage"
VENV_PY = ROOT / ".venv" / "bin" / "python"


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(m)
    return m


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--depuis", type=Path, help="clone local de meromoonmeri/town02")
    ap.add_argument("--fichiers", nargs=2, type=Path,
                    help="chemins des deux .rsground (WaterfallVillageCapital puis waterfall_cave_1)")
    args = ap.parse_args()

    srcs: list[Path] = []
    if args.fichiers:
        srcs = list(args.fichiers)
    elif args.depuis:
        d = args.depuis / "Data" / "Ground"
        srcs = [d / "WaterfallVillageCapital.rsground", d / "waterfall_cave_1.rsground"]
    else:
        raise SystemExit("préciser --depuis <clone town02> ou --fichiers <a.rsground> <b.rsground>")

    for p in srcs:
        if not p.is_file():
            raise SystemExit(f"fichier absent : {p}")
        head = p.read_bytes()[:64]
        if head.startswith(b"version https://git-lfs"):
            raise SystemExit(f"{p.name} est encore un pointeur LFS — lancer "
                             f"`git lfs pull` dans le clone town02 d'abord")

    bib = load_module("cbg", ROOT / "OUTILS" / "construire_bibliotheque_ground.py")
    lot_dir = BIB_LOTS / LOT
    gdir = lot_dir / "Data" / "Ground"
    if gdir.is_dir():
        shutil.rmtree(gdir)
    gdir.mkdir(parents=True, exist_ok=True)

    rapport = []
    for p in srcs:
        doc = json.loads(p.read_bytes().lstrip(b"\xef\xbb\xbf").decode("utf-8-sig"))
        stats, doc = bib.clamp_map(doc)
        ouvertes, fr = bib.cellules_bord_ouvertes(doc)
        out = json.dumps(doc, ensure_ascii=False, separators=(",", ":")).encode("utf-8")
        (gdir / p.name).write_bytes(out)
        rapport.append({"map": p.name, "clamp": stats, "frontiere": fr,
                        "chevauchements_entites": bib.chevauchements(doc)})
        print(f"{p.name}: clampé ({stats}), {fr}")

    # scripts liés s'ils existent à côté du clone
    if args.depuis:
        for rel in ("Data/Script/halcyon/ground/WaterfallVillageCapital",
                    "Data/Script/halcyon/zone/waterfall_pond",
                    "Data/Script/halcyon/zone/waterfall_cave"):
            s = args.depuis / rel
            if s.is_dir():
                d = lot_dir / rel
                if d.exists():
                    shutil.rmtree(d)
                shutil.copytree(s, d)

    (lot_dir / "lot.json").write_text(json.dumps({
        "source": "meromoonmeri/town02 (New Era : Abyss to Ascension) — maps LFS récupérées localement",
        "lot": LOT}, ensure_ascii=False, indent=1), encoding="utf-8")
    (lot_dir / "rapport_waterfall.json").write_text(
        json.dumps(rapport, ensure_ascii=False, indent=1), encoding="utf-8")

    # labels de zone
    qb = ROOT / "OUTILS" / "construire_quest_destiny.py"
    txt = qb.read_text(encoding="utf-8")
    if '"town02_waterfallvillage"' not in txt:
        txt = txt.replace('"packages_destiny": "Packages Destiny (liens non resolus)",',
                          '"packages_destiny": "Packages Destiny (liens non resolus)",\n'
                          f'    "{LOT}": "Waterfall Village (town02)",')
        qb.write_text(txt, encoding="utf-8")
        print("libellé de zone ajouté au constructeur")

    r = subprocess.run([str(VENV_PY), str(qb)], cwd=ROOT, capture_output=True, text=True)
    print(r.stdout)
    if r.returncode != 0:
        print(r.stderr)
        return 1

    imp = load_module("imp", ROOT / "OUTILS" / "importer_tiles_town02.py")
    nodes = {}
    for tile in sorted((QUEST / "Content" / "Tile").glob("*.tile")):
        with tile.open("rb") as f:
            nodes[tile.stem] = imp.read_node(f)
    (QUEST / "Content" / "Tile" / "index.idx").write_bytes(imp.encode_index(nodes))
    print(f"index tuiles régénéré : {len(nodes)} tilesets")
    print("Intégration terminée — lancer le jeu pour tester l'ouverture des maps.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
