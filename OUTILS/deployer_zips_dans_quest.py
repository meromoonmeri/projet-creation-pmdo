#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Décompresse TOUTES les archives ZIP de maps (renders/*/*.zip du dépôt meromoonmeri/projet-pmdo)
et déploie leur contenu dans la quest `quest_pmd_destiny/`.

Règles (sans jamais écraser un fichier existant de la quest) :
1. Archives PMDO (contiennent Data/ ou Content/ sous une racine) :
   - Content/** (.tile, .dir, Object/, BG/…) -> quest_pmd_destiny/Content/** ;
   - Data/Ground/*.rsground -> quest_pmd_destiny/Data/Ground/ ;
   - Data/Script/**/init.lua -> quest_pmd_destiny/Data/Script/<espace de noms d'origine>/
     (sauf l'espace de noms « halcyon », exclu : scripts tiers) ;
   - Content/Tile/index.idx n'est PAS copié : il est régénéré à partir des .tile présents.
2. Fichier identique (même SHA-256) déjà présent : ignoré. Fichier DIFFÉRENT déjà présent :
   conservé tel quel et signalé (aucun remplacement de contenu validé).
3. Fichier dont le SHA-256 figure dans quest_pmd_destiny/PLACEHOLDERS_HALCYON.json (original Halcyon) :
   NON importé (aucun pixel Halcyon redistribué).
4. Tout le reste de l'archive (calques .png/.ora, manifest, README, vérifications, scripts .py…)
   -> renders/<dossier>/ (même convention que les autres sources de maps du dépôt, ignoré par Git),
   sans écraser les fichiers existants.

Les archives sont téléchargées une fois dans .cache/zips_projet_pmdo/ (ignoré par Git).

Usage : python3 OUTILS/deployer_zips_dans_quest.py [--dry-run] [--sans-telechargement]
"""
from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import re
import subprocess
import sys
import zipfile
from pathlib import Path, PurePosixPath

ROOT = Path(__file__).resolve().parents[1]
QUEST = ROOT / "quest_pmd_destiny"
RENDERS = ROOT / "renders"
CACHE = ROOT / ".cache" / "zips_projet_pmdo"
REMOTE = "meromoonmeri/projet-pmdo"
REMOTE_SHA = "6cca4a09380211e510ab1bea454a1b1926ef4b5a"
RAPPORT = QUEST / "RAPPORT_DEPLOIEMENT_ZIPS.json"


def sha(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def liste_zips() -> list[tuple[str, int]]:
    out = subprocess.run(
        ["gh", "api", f"repos/{REMOTE}/git/trees/{REMOTE_SHA}?recursive=1", "--jq",
         '.tree[] | select(.type=="blob") | select(.path|test("^renders/[^/]+/[^/]+\\\\.zip$")) | "\\(.path)\\t\\(.size)"'],
        capture_output=True, text=True, timeout=120, check=True).stdout
    res = []
    for line in out.splitlines():
        p, s = line.split("\t")
        res.append((p, int(s)))
    return res


def telecharge(remote_path: str) -> Path:
    dst = CACHE / remote_path.replace("/", "_")
    if dst.is_file() and dst.stat().st_size > 0:
        return dst
    CACHE.mkdir(parents=True, exist_ok=True)
    data = subprocess.run(
        ["gh", "api", f"repos/{REMOTE}/contents/{remote_path}?ref={REMOTE_SHA}",
         "-H", "Accept: application/vnd.github.raw"],
        capture_output=True, timeout=600, check=True).stdout
    dst.write_bytes(data)
    return dst


def charge_placeholders() -> set[str]:
    p = QUEST / "PLACEHOLDERS_HALCYON.json"
    d = json.loads(p.read_text(encoding="utf-8-sig"))
    return {f.get("sha256_original", "") for f in d.get("fichiers", []) if f.get("sha256_original")}


def racine_pmdo(noms: list[str]) -> str | None:
    """Préfixe d'archive précédant Data/ ou Content/ ('' si à la racine), None si pas PMDO."""
    for n in noms:
        parts = PurePosixPath(n).parts
        for i, seg in enumerate(parts):
            if seg in ("Data", "Content") and i + 1 < len(parts):
                return "/".join(parts[:i])
    return None


def charge_index_module():
    spec = importlib.util.spec_from_file_location("imp_tiles", ROOT / "OUTILS" / "importer_tiles_town02.py")
    m = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(m)
    return m


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--dry-run", action="store_true")
    ap.add_argument("--sans-telechargement", action="store_true",
                    help="n'utilise que les ZIP déjà présents dans .cache/zips_projet_pmdo/")
    a = ap.parse_args()

    halcyon = charge_placeholders()
    rapport = {"archives": [], "copies": 0, "identiques": 0, "conflits": [], "halcyon_exclus": [],
               "renders_extraits": 0, "renders_existants": 0, "erreurs": []}

    entrees = liste_zips()
    for remote_path, _size in entrees:
        dossier = PurePosixPath(remote_path).parent.name
        try:
            if a.sans_telechargement:
                local = CACHE / remote_path.replace("/", "_")
                if not local.is_file():
                    rapport["archives"].append({"zip": remote_path, "statut": "absent du cache"})
                    continue
            else:
                local = telecharge(remote_path)
            z = zipfile.ZipFile(local)
        except Exception as e:  # noqa: BLE001
            rapport["erreurs"].append({"zip": remote_path, "erreur": str(e)})
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
                        # espace de noms Halcyon (scripts tiers) : jamais déployé dans la quest
                        rapport["halcyon_exclus"].append(f"{remote_path}:{rel_pmdo}")
                        continue
                elif rel_pmdo.startswith("Data/") and not rel_pmdo.startswith("Data/Ground/"):
                    continue  # pas de Data/Zone, Data/AutoTile etc. dans les ZIP : rien à déployer
                data = z.read(info)
                h = sha(data)
                if h in halcyon:
                    rapport["halcyon_exclus"].append(f"{remote_path}:{rel_pmdo}")
                    continue
                dst = QUEST / rel_pmdo
                if dst.exists():
                    if sha(dst.read_bytes()) == h:
                        rapport["identiques"] += 1
                    else:
                        rapport["conflits"].append({"zip": remote_path, "fichier": rel_pmdo})
                    continue
                pmdo_copies += 1
                rapport["copies"] += 1
                if not a.dry_run:
                    dst.parent.mkdir(parents=True, exist_ok=True)
                    dst.write_bytes(data)
            else:
                # le reste : calques, manifestes, scripts d'outillage -> renders/<dossier>/
                rel = nom[len(racine) + 1:] if (racine and nom.startswith(racine + "/")) else nom
                dst = RENDERS / dossier / rel
                if dst.exists():
                    rapport["renders_existants"] += 1
                    continue
                rapport["renders_extraits"] += 1
                if not a.dry_run:
                    dst.parent.mkdir(parents=True, exist_ok=True)
                    dst.write_bytes(z.read(info))
        rapport["archives"].append({"zip": remote_path, "pmdo": racine is not None, "copies_pmdo": pmdo_copies})

    # index des tuiles : régénéré à partir des .tile présents (même format que le reste de la quest)
    if not a.dry_run:
        imp = charge_index_module()
        tiles = sorted((QUEST / "Content" / "Tile").glob("*.tile"))
        nodes = {}
        for t in tiles:
            with t.open("rb") as f:
                nodes[t.stem] = imp.read_node(f)
        (QUEST / "Content" / "Tile" / "index.idx").write_bytes(imp.encode_index(nodes))
        rapport["index_tuiles"] = len(nodes)
        RAPPORT.write_text(json.dumps(rapport, ensure_ascii=False, indent=1), encoding="utf-8")

    print(json.dumps({k: (v if not isinstance(v, list) else len(v)) for k, v in rapport.items()},
                     ensure_ascii=False, indent=1))
    return 0


if __name__ == "__main__":
    sys.exit(main())
