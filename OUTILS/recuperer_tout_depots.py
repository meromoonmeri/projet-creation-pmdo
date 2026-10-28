#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Récupère TOUS les contenus distincts utiles à PMDO depuis les dépôts de création :
  - meromoonmeri/projet-creation-pmdo (24 branches), meromoonmeri/guilde-treehouse-pmd (81 branches),
    meromoonmeri/projet-pmdo (15 branches) ;
  - seulement les blobs uniques (dédoublonnés par SHA) de type ZIP, .rsground, .tile, .dir, .tmj,
    ou situés sous Content/ , Data/Ground, Data/Zone, Data/Script (liste : inventaire TSV).

Les aperçus HTML et les PNG de calques ne sont PAS téléchargés : ils restent référencés
par commit dans apercu_toutes_les_maps.html.

Sorties (ignorées par Git) : .cache/recuperation/<sha12>_<nom>  + .cache/recuperation/manifest.json
Usage : python3 OUTILS/recuperer_tout_depots.py --inventaire .cache/inventaire/fichiers.tsv
"""
from __future__ import annotations

import argparse
import concurrent.futures as cf
import json
import re
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DEST = ROOT / ".cache" / "recuperation"
RE_UTILE = re.compile(r"\.(zip|rsground|tile|dir|tmj)$|(^|/)(Content|Data/Ground|Data/Zone|Data/Script)/", re.I)


def selection(inventaire: Path) -> dict[str, dict]:
    """blob_sha -> {repo, branche, chemin, taille} (première occurrence, branche la plus récente d'abord)."""
    res: dict[str, dict] = {}
    for l in inventaire.read_text(encoding="utf-8").splitlines():
        repo, br, _csha, rest = l.split("\t", 3)
        chemin, blob, taille = rest.rsplit("\t", 2)
        if blob in res or not RE_UTILE.search(chemin):
            continue
        res[blob] = {"repo": repo, "branche": br, "chemin": chemin, "taille": int(taille)}
    return res


def telecharge(item: tuple[str, dict]) -> dict:
    blob, info = item
    nom = Path(info["chemin"]).name
    out = DEST / f"{blob[:12]}_{nom}"
    if out.is_file() and out.stat().st_size == info["taille"]:
        return {**info, "blob": blob, "fichier": out.name, "statut": "déjà présent"}
    r = subprocess.run(["gh", "api", f"repos/{info['repo']}/git/blobs/{blob}",
                        "-H", "Accept: application/vnd.github.raw"],
                       capture_output=True, timeout=900)
    if r.returncode != 0:
        return {**info, "blob": blob, "statut": "ECHEC", "erreur": r.stderr.decode(errors="replace")[:300]}
    out.write_bytes(r.stdout)
    ok = out.stat().st_size == info["taille"]
    return {**info, "blob": blob, "fichier": out.name, "statut": "ok" if ok else "taille différente"}


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--inventaire", type=Path, default=ROOT / ".cache" / "inventaire" / "fichiers.tsv")
    ap.add_argument("--max", type=int, default=0, help="limiter (test)")
    a = ap.parse_args()
    DEST.mkdir(parents=True, exist_ok=True)
    sel = selection(a.inventaire)
    items = sorted(sel.items(), key=lambda kv: kv[1]["taille"])
    if a.max:
        items = items[: a.max]
    print(f"à récupérer : {len(items)} contenus, {sum(v['taille'] for _, v in items)/1e9:.2f} Go", flush=True)
    resultats = []
    with cf.ThreadPoolExecutor(max_workers=8) as ex:
        for i, r in enumerate(ex.map(telecharge, items), 1):
            resultats.append(r)
            if i % 100 == 0 or r["statut"] not in ("ok", "déjà présent"):
                print(i, r["statut"], r["chemin"], flush=True)
    (DEST / "manifest.json").write_text(json.dumps(resultats, ensure_ascii=False, indent=1), encoding="utf-8")
    bilan = {}
    for r in resultats:
        bilan[r["statut"]] = bilan.get(r["statut"], 0) + 1
    print("bilan", bilan, flush=True)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
