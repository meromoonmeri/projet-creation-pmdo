#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Télécharge TOUS les aperçus HTML distincts (blobs uniques) des dépôts de création dans
.cache/apercus/ pour qu'ils soient servis localement par le serveur d'aperçus (port 8000).
Le nom local = <sha8 du blob>_<nom d'origine>. Manifest : .cache/apercus/manifest.json.
Usage : python3 OUTILS/telecharger_apercus.py
"""
from __future__ import annotations

import concurrent.futures as cf
import json
import re
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
INV = ROOT / ".cache" / "inventaire" / "fichiers.tsv"
DEST = ROOT / ".cache" / "apercus"
RE_APERCU = re.compile(r"(^|/)apercu[^/]*\.html$|(^|/)viewer[^/]*\.html$", re.I)


def selection() -> list[dict]:
    vus: dict[str, dict] = {}
    for l in INV.read_text(encoding="utf-8").splitlines():
        repo, br, csha, rest = l.split("\t", 3)
        chemin, blob, taille = rest.rsplit("\t", 2)
        if blob in vus or not RE_APERCU.search(chemin):
            continue
        vus[blob] = {"repo": repo, "branche": br, "commit": csha, "chemin": chemin,
                     "blob": blob, "taille": int(taille)}
    return list(vus.values())


def telecharge(e: dict) -> dict:
    nom = f'{e["blob"][:8]}_{Path(e["chemin"]).name}'
    out = DEST / nom
    e = {**e, "fichier": nom}
    if out.is_file() and out.stat().st_size == e["taille"]:
        return {**e, "statut": "déjà présent"}
    r = subprocess.run(["gh", "api", f"repos/{e['repo']}/git/blobs/{e['blob']}",
                        "-H", "Accept: application/vnd.github.raw"], capture_output=True, timeout=900)
    if r.returncode != 0:
        return {**e, "statut": "ECHEC"}
    out.write_bytes(r.stdout)
    return {**e, "statut": "ok" if out.stat().st_size == e["taille"] else "taille différente"}


def main() -> int:
    DEST.mkdir(parents=True, exist_ok=True)
    items = selection()
    print(f"aperçus distincts : {len(items)} ({sum(i['taille'] for i in items)/1e9:.2f} Go)", flush=True)
    res = []
    with cf.ThreadPoolExecutor(max_workers=8) as ex:
        for i, r in enumerate(ex.map(telecharge, items), 1):
            res.append(r)
            if i % 50 == 0 or r["statut"] not in ("ok", "déjà présent"):
                print(i, r["statut"], r["chemin"], flush=True)
    (DEST / "manifest.json").write_text(json.dumps(res, ensure_ascii=False, indent=1), encoding="utf-8")
    bilan: dict[str, int] = {}
    for r in res:
        bilan[r["statut"]] = bilan.get(r["statut"], 0) + 1
    print("bilan", bilan, flush=True)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
