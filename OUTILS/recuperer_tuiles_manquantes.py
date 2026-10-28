#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Récupère dans quest_pmd_destiny/Content/Tile/ les tuiles référencées par les maps Ground mais absentes.

- Source : blobs Git exacts, retrouvés dans .cache/inventaire/fichiers.tsv, téléchargés via gh api
  et vérifiés par empreinte Git SHA-1 (« blob <taille>\\0 » + contenu).
- Renommage « reverie » : les tuiles RVT*_NUIT_ANIM manquantes sont des copies, à l'identique
  (même empreinte), de RVT_NE_NUIT_ANIM.tile (= export reverie_town v1/v2).
- Aucun fichier existant n'est écrasé. Les tuiles sans source unique ne sont pas touchées.
- Régénère Content/Tile/index.idx si au moins une tuile est ajoutée (tuiles illisibles ignorées, signalées).

Usage : python3 OUTILS/recuperer_tuiles_manquantes.py
"""
from __future__ import annotations

import base64
import hashlib
import importlib.util
import json
import shutil
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
TILES = ROOT / "quest_pmd_destiny" / "Content" / "Tile"
INV = ROOT / ".cache" / "inventaire" / "fichiers.tsv"
RAPPORT = ROOT / "quest_pmd_destiny" / "RAPPORT_TUILES_MANQUANTES.json"

# nom -> (dépôt, empreinte Git complète) ; choix explicites quand plusieurs versions existent
SOURCES = {
    "Metano_Town_Base": ("meromoonmeri/guilde-treehouse-pmd", "d4fc7ff9a5ac7e83233b9584d620c2fed1735354"),  # pmd_petal_clearing (export natif)
    "Metano_Town_Base_Night": None,   # rempli depuis l'inventaire (version unique)
    "Metano_Town_Cliffs": None,
    "Metano_Town_Cliffs_Night": None,
    "Metano_Town_Objects": None,
    "Metano_Town_Animation_Tileset": None,
    "Metano_Town_Animated": None,
    "Altere_Pond_Cliffs": None,
    "Altere_Pond_Objects": None,
    "Altere_Pond_Objects_Under": None,
}
# copies à l'identique (renommage reverie) : nom cible <- nom source déjà dans la quest
COPIES = {
    "RVT2_NE_NUIT_ANIM": "RVT_NE_NUIT_ANIM",
    "RVT2_NO_NUIT_ANIM": "RVT_NE_NUIT_ANIM",
    "RVT_NO_NUIT_ANIM": "RVT_NE_NUIT_ANIM",
}


def git_sha(data: bytes) -> str:
    return hashlib.sha1(b"blob %d\0" % len(data) + data).hexdigest()


def sources_inventaire() -> dict[str, list[tuple[str, str]]]:
    """nom de tuile -> [(dépôt, empreinte)] (une entrée par empreinte distincte)."""
    res: dict[str, dict[str, str]] = {}
    with INV.open(encoding="utf-8", errors="replace") as f:
        for line in f:
            parts = line.rstrip("\n").split("\t")
            if len(parts) < 6:
                continue
            base = parts[3].rsplit("/", 1)[-1]
            if base.lower().endswith(".tile"):
                res.setdefault(base[:-5], {}).setdefault(parts[4], parts[0])
    return {k: [(repo, blob) for blob, repo in v.items()] for k, v in res.items()}


def telecharge(repo: str, sha: str) -> bytes:
    out = subprocess.run(["gh", "api", f"repos/{repo}/git/blobs/{sha}", "--jq", ".content"],
                         capture_output=True, text=True, timeout=300, check=True).stdout
    return base64.b64decode("".join(out.split()))


def charge_index_module():
    spec = importlib.util.spec_from_file_location("imp_tiles", ROOT / "OUTILS" / "importer_tiles_town02.py")
    m = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(m)
    return m


def main() -> int:
    inv = sources_inventaire()
    rapport = {"ajoutees": [], "deja_presentes": [], "sans_source": [], "erreurs": [], "index_tuiles": None,
               "tuiles_illisibles": []}

    for nom, src in SOURCES.items():
        cible = TILES / f"{nom}.tile"
        if cible.exists():
            rapport["deja_presentes"].append(nom)
            continue
        if src is None:
            cands = inv.get(nom, [])
            if len(cands) != 1:
                rapport["sans_source"].append({"nom": nom, "versions_distinctes": len(cands)})
                continue
            repo, sha = cands[0][0], cands[0][1]
        else:
            repo, sha = src
        try:
            data = telecharge(repo, sha)
            if git_sha(data) != sha:
                raise ValueError("empreinte différente")
            cible.write_bytes(data)
            rapport["ajoutees"].append({"nom": nom, "source": repo, "blob": sha[:10], "octets": len(data)})
        except Exception as e:  # noqa: BLE001
            rapport["erreurs"].append({"nom": nom, "erreur": str(e)})

    for nom, origine in COPIES.items():
        cible = TILES / f"{nom}.tile"
        if cible.exists():
            rapport["deja_presentes"].append(nom)
            continue
        src_f = TILES / f"{origine}.tile"
        if not src_f.exists():
            rapport["erreurs"].append({"nom": nom, "erreur": f"source {origine} absente"})
            continue
        shutil.copyfile(src_f, cible)
        rapport["ajoutees"].append({"nom": nom, "copie_de": origine, "octets": cible.stat().st_size})

    if rapport["ajoutees"]:
        imp = charge_index_module()
        nodes, echecs = {}, []
        for t in sorted(TILES.glob("*.tile")):
            try:
                with t.open("rb") as f:
                    nodes[t.stem] = imp.read_node(f)
            except ValueError as ex:
                echecs.append({"fichier": t.name, "erreur": str(ex)})
        (TILES / "index.idx").write_bytes(imp.encode_index(nodes))
        rapport["index_tuiles"] = len(nodes)
        rapport["tuiles_illisibles"] = echecs
    RAPPORT.write_text(json.dumps(rapport, ensure_ascii=False, indent=1), encoding="utf-8")
    print(json.dumps({k: (len(v) if isinstance(v, list) else v) for k, v in rapport.items()},
                     ensure_ascii=False, indent=1))
    return 0


if __name__ == "__main__":
    sys.exit(main())
