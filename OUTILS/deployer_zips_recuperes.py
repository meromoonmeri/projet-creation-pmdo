#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Décompresse les 23 ZIP récupérés (.cache/zips_recuperes/ : 13 à la racine de projet-pmdo
+ 10 branches de projet-creation-pmdo) et déploie leur contenu PMDO dans quest_pmd_destiny/.

Mêmes règles que OUTILS/deployer_zips_dans_quest.py (réutilisées telles quelles) :
- Content/** -> quest/Content/** ; Data/Ground/** -> quest/Data/Ground/ ;
  Data/Script/<ns>/**.lua -> quest/Data/Script/<ns>/ (namespace halcyon exclu) ;
  index.idx non copié (régénéré).
- Fichier identique déjà présent : ignoré. Fichier différent déjà présent : conservé, signalé.
- SHA-256 listé dans PLACEHOLDERS_HALCYON.json : non importé.
- Le reste de l'archive -> renders/zips_recuperes/<nom de l'archive>/ (sans écraser).

Usage : python3 OUTILS/deployer_zips_recuperes.py [--dry-run]
"""
from __future__ import annotations

import argparse
import importlib.util
import json
import sys
import zipfile
from pathlib import Path, PurePosixPath

ROOT = Path(__file__).resolve().parents[1]
QUEST = ROOT / "quest_pmd_destiny"
RENDERS = ROOT / "renders" / "zips_recuperes"
SOURCE = ROOT / ".cache" / "zips_recuperes"
RAPPORT = QUEST / "RAPPORT_ZIPS_RECUPERES.json"


def _charge(nom: str, fichier: str):
    spec = importlib.util.spec_from_file_location(nom, ROOT / "OUTILS" / fichier)
    m = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(m)
    return m


dep = _charge("dep_zips", "deployer_zips_dans_quest.py")
sha = dep.sha
racine_pmdo = dep.racine_pmdo
charge_placeholders = dep.charge_placeholders


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--dry-run", action="store_true")
    a = ap.parse_args()

    halcyon = charge_placeholders()
    tuiles_ajoutees: list[str] = []
    rapport = {"archives": [], "copies": 0, "identiques": 0, "conflits": [], "halcyon_exclus": [],
               "renders_extraits": 0, "renders_existants": 0, "octets_copies": 0, "erreurs": []}

    for local in sorted(SOURCE.glob("*.zip")):
        nom_zip = local.name
        dossier = local.stem
        try:
            z = zipfile.ZipFile(local)
            if z.testzip() is not None:
                raise ValueError("CRC invalide")
        except Exception as e:  # noqa: BLE001
            rapport["erreurs"].append({"zip": nom_zip, "erreur": str(e)})
            continue

        noms = [i.filename for i in z.infolist() if not i.is_dir()]
        racine = racine_pmdo(noms)
        pmdo_copies = 0
        for info in z.infolist():
            if info.is_dir():
                continue
            nom = info.filename
            rel_pmdo = None
            if racine is not None:
                pre = (racine + "/") if racine else ""
                if nom.startswith(pre):
                    rel = nom[len(pre):]
                    if rel.startswith(("Content/", "Data/")) and not rel.endswith("/index.idx"):
                        rel_pmdo = rel
            if rel_pmdo is not None:
                if rel_pmdo.startswith("Data/Script/"):
                    if not rel_pmdo.endswith(".lua"):
                        continue
                    if rel_pmdo.startswith("Data/Script/halcyon/"):
                        rapport["halcyon_exclus"].append(f"{nom_zip}:{rel_pmdo}")
                        continue
                elif rel_pmdo.startswith("Data/") and not rel_pmdo.startswith("Data/Ground/"):
                    continue
                data = z.read(info)
                h = sha(data)
                if h in halcyon:
                    rapport["halcyon_exclus"].append(f"{nom_zip}:{rel_pmdo}")
                    continue
                dst = QUEST / rel_pmdo
                if dst.exists():
                    if sha(dst.read_bytes()) == h:
                        rapport["identiques"] += 1
                    else:
                        rapport["conflits"].append({"zip": nom_zip, "fichier": rel_pmdo})
                    continue
                pmdo_copies += 1
                rapport["copies"] += 1
                tuiles_ajoutees.append(rel_pmdo)
                rapport["octets_copies"] += len(data)
                if not a.dry_run:
                    dst.parent.mkdir(parents=True, exist_ok=True)
                    dst.write_bytes(data)
            else:
                rel = nom[len(racine) + 1:] if (racine and nom.startswith(racine + "/")) else nom
                dst = RENDERS / dossier / rel
                if dst.exists():
                    rapport["renders_existants"] += 1
                    continue
                rapport["renders_extraits"] += 1
                if not a.dry_run:
                    dst.parent.mkdir(parents=True, exist_ok=True)
                    dst.write_bytes(z.read(info))
        rapport["archives"].append({"zip": nom_zip, "pmdo": racine is not None, "copies_pmdo": pmdo_copies})

    if not a.dry_run:
        if any(p.endswith(".tile") for p in tuiles_ajoutees):
            imp = _charge("imp_tiles", "importer_tiles_town02.py")
            nodes, echecs = {}, []
            for t in sorted((QUEST / "Content" / "Tile").glob("*.tile")):
                try:
                    with t.open("rb") as f:
                        nodes[t.stem] = imp.read_node(f)
                except ValueError as ex:
                    echecs.append({"fichier": t.name, "erreur": str(ex)})
            (QUEST / "Content" / "Tile" / "index.idx").write_bytes(imp.encode_index(nodes))
            rapport["index_tuiles"] = len(nodes)
            rapport["tuiles_illisibles"] = echecs
        else:
            rapport["index_tuiles"] = "inchangé (aucune tuile ajoutée)"
        RAPPORT.write_text(json.dumps(rapport, ensure_ascii=False, indent=1), encoding="utf-8")

    resume = {k: (len(v) if isinstance(v, list) else v) for k, v in rapport.items() if k != "archives"}
    print(json.dumps(resume, ensure_ascii=False, indent=1))
    return 0


if __name__ == "__main__":
    sys.exit(main())
