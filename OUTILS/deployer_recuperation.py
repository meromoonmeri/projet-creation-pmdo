#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Déploie les contenus récupérés (.cache/recuperation/manifest.json) dans quest_pmd_destiny/.

Règles :
- ZIP et fichiers isolés : seuls les membres utiles au moteur sont extraits :
    Content/** (tuiles, .dir, .png de Content), Data/Ground/*.rsground, Data/Zone/*.json de type ZoneData,
    Data/Script/**/*.lua ; Content/Tile/index.idx est régénéré, jamais copié.
- Un chemin est ignoré si un segment vaut « references », « refs », « dump » (copies de référence / remakes)
  ou si c'est un script de l'espace de noms « halcyon ».
- Un fichier dont le SHA-256 figure dans PLACEHOLDERS_HALCYON.json n'est jamais copié.
- Aucun fichier existant n'est écrasé : identique -> ignoré ; différent -> conflit consigné.
- Les autres membres de ZIP (calques .png/.ora/.aseprite, .md, .tmj…) ne sont PAS extraits :
  leur liste est écrite dans renders/recuperes/LISTE_CONTENU_ZIP.json (les ZIP restent dans .cache).
- Les Data/Zone/*.json copiés ne sont PAS ajoutés à Data/Zone/index.idx (aucun registre modifié).

Usage : python3 OUTILS/deployer_recuperation.py [--dry-run]
"""
from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import sys
import zipfile
from pathlib import PurePosixPath
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
QUEST = ROOT / "quest_pmd_destiny"
CACHE = ROOT / ".cache" / "recuperation"
RENDERS_REC = ROOT / "renders" / "recuperes"
RAPPORT = QUEST / "RAPPORT_RECUPERATION_DEPOTS.json"
EXCLUS_SEGMENTS = {"references", "refs", "dump"}


def sha(b: bytes) -> str:
    return hashlib.sha256(b).hexdigest()


def placeholders() -> set[str]:
    d = json.loads((QUEST / "PLACEHOLDERS_HALCYON.json").read_text(encoding="utf-8-sig"))
    return {f["sha256_original"] for f in d.get("fichiers", []) if f.get("sha256_original")}


def cible_pmdo(chemin: str) -> str | None:
    """Chemin relatif dans la quest si le membre est utile au moteur, sinon None."""
    parts = PurePosixPath(chemin).parts
    if any(p.lower() in EXCLUS_SEGMENTS for p in parts):
        return None
    for i, seg in enumerate(parts):
        if seg in ("Data", "Content") and i + 1 < len(parts):
            rel = PurePosixPath(*parts[i:])
            s = str(rel)
            low = s.lower()
            if s.startswith("Content/"):
                if low.endswith("/index.idx") or low.endswith(".idx"):
                    return None
                if low.endswith((".tile", ".dir", ".png", ".ogg")):
                    return s
                return None
            if s.startswith("Data/Ground/") and low.endswith(".rsground"):
                return s
            if s.startswith("Data/Zone/") and low.endswith(".json") and not low.endswith("index.idx"):
                return s
            if s.startswith("Data/Script/") and low.endswith(".lua"):
                if s.startswith("Data/Script/halcyon/"):
                    return None
                return s
            return None
    return None


def est_zonedata(data: bytes) -> bool:
    try:
        d = json.loads(data.decode("utf-8-sig"))
    except Exception:  # noqa: BLE001
        return False
    return "ZoneData" in json.dumps(d.get("Object", {}).get("$type", ""))


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--dry-run", action="store_true")
    a = ap.parse_args()

    manifest = json.loads((CACHE / "manifest.json").read_text(encoding="utf-8"))
    halcyon = placeholders()
    rapport = {"copies": [], "identiques": 0, "conflits": [], "halcyon_exclus": 0,
               "ignores_non_moteur": 0, "erreurs": [], "zip_listes": 0}
    liste_zip: dict[str, list[str]] = {}
    vu: dict[str, str] = {}  # rel quest -> sha déjà posé pendant ce passage

    def traite(rel: str, data: bytes, origine: str) -> None:
        h = sha(data)
        if h in halcyon:
            rapport["halcyon_exclus"] += 1
            return
        if rel.startswith("Data/Zone/") and not est_zonedata(data):
            rapport["ignores_non_moteur"] += 1
            return
        dst = QUEST / rel
        if rel in vu:
            if vu[rel] != h:
                rapport["conflits"].append({"fichier": rel, "origine": origine, "raison": "contenu différent dans le passage"})
            else:
                rapport["identiques"] += 1
            return
        vu[rel] = h
        if dst.exists():
            if sha(dst.read_bytes()) == h:
                rapport["identiques"] += 1
            else:
                rapport["conflits"].append({"fichier": rel, "origine": origine, "raison": "existe déjà, différent"})
            return
        rapport["copies"].append({"fichier": rel, "origine": origine})
        if not a.dry_run:
            dst.parent.mkdir(parents=True, exist_ok=True)
            dst.write_bytes(data)

    for e in manifest:
        local = CACHE / e["fichier"]
        origine = f'{e["repo"]}:{e["branche"]}:{e["chemin"]}'
        if not local.is_file():
            rapport["erreurs"].append({"origine": origine, "erreur": "fichier local absent"})
            continue
        if e["chemin"].lower().endswith(".zip"):
            try:
                z = zipfile.ZipFile(local)
            except Exception as ex:  # noqa: BLE001
                rapport["erreurs"].append({"origine": origine, "erreur": str(ex)})
                continue
            autres = []
            for info in z.infolist():
                if info.is_dir():
                    continue
                rel = cible_pmdo(info.filename)
                if rel is None:
                    autres.append(info.filename)
                    continue
                traite(rel, z.read(info), f"{origine}!{info.filename}")
            liste_zip[origine] = autres
            rapport["zip_listes"] += len(autres)
        else:
            rel = cible_pmdo(e["chemin"])
            if rel is None:
                rapport["ignores_non_moteur"] += 1
                continue
            traite(rel, local.read_bytes(), origine)

    if not a.dry_run:
        RENDERS_REC.mkdir(parents=True, exist_ok=True)
        (RENDERS_REC / "LISTE_CONTENU_ZIP.json").write_text(
            json.dumps(liste_zip, ensure_ascii=False, indent=1), encoding="utf-8")
        imp_spec = importlib.util.spec_from_file_location("imp_tiles", ROOT / "OUTILS" / "importer_tiles_town02.py")
        imp = importlib.util.module_from_spec(imp_spec)
        imp_spec.loader.exec_module(imp)
        nodes, echecs = {}, []
        for t in sorted((QUEST / "Content" / "Tile").glob("*.tile")):
            try:
                with t.open("rb") as f:
                    nodes[t.stem] = imp.read_node(f)
            except Exception as ex:  # noqa: BLE001
                echecs.append({"fichier": t.name, "erreur": str(ex)})
        (QUEST / "Content" / "Tile" / "index.idx").write_bytes(imp.encode_index(nodes))
        rapport["index_tuiles"] = len(nodes)
        rapport["tuiles_illisibles"] = echecs
        rapport["copies_total"] = len(rapport["copies"])
        RAPPORT.write_text(json.dumps(rapport, ensure_ascii=False, indent=1), encoding="utf-8")

    res = {k: (len(v) if isinstance(v, list) else v) for k, v in rapport.items()}
    print(json.dumps(res, ensure_ascii=False, indent=1))
    return 0


if __name__ == "__main__":
    sys.exit(main())
