#!/usr/bin/env python3
"""Resynchronise les hashes declares des manifests de saison rmvillage.

Pourquoi
--------
Le plan de transformation x0,125 prevoyait explicitement l'etape
« Regeneration des 13 manifests et 5 resumes ». Elle n'a jamais ete faite. Puis
le remplacement des maisons NNV par les batiments PMU a modifie une seconde
fois les memes artefacts. Etat mesure avant cet outil :

    spring  season_layers STALE   tile STALE
    summer  ground STALE          tile STALE   runtime_report STALE
    autumn  season_layers STALE   tile STALE
    winter  season_layers STALE   tile STALE

Un hash declare qui ne correspond plus au fichier ne protege plus rien : il
bloque les outils honnetes et ne detecte aucune alteration reelle.

Ce que fait cet outil, et rien de plus
--------------------------------------
Il recalcule le SHA-256 des fichiers REELLEMENT presents et met a jour la
valeur declaree. Il ne touche aucun octet des artefacts eux-memes, ne relance
aucune conversion, ne change aucun statut de certification.

Il DEGRADE en revanche les statuts runtime devenus mensongers : la geometrie a
change (TexSize 8 -> 1, monde 4992 -> 624 px) et six batiments ont ete poses
depuis la derniere execution PMDO. Un `RUNTIME_TESTED_PASS` herite de l'ancienne
geometrie est faux. Il devient `OBSOLETE_MUST_RETEST`.

Fail-closed : aucun statut n'est eleve, jamais. `conversion_status`,
`certification_status` et `promotion_allowed` sont laisses tels quels.
"""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
GEN = ROOT / "generated/rmvillage"
SEASONS = ("spring", "summer", "autumn", "winter")

OBSOLETE_REASON = (
    "normalisation x0.125 (TexSize 8->1, monde 4992->624 px) puis pose de 6 batiments "
    "PMU : la derniere execution PMDO 0.8.12 porte sur une geometrie qui n'existe plus"
)


def sha256_file(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def resync_manifest(season: str, apply: bool) -> dict:
    path = GEN / season / "manifest.json"
    manifest = json.loads(path.read_text())
    outputs = manifest.get("outputs", {})
    changes = []

    for key in sorted(k for k in outputs if not k.endswith("_sha256")):
        hash_key = f"{key}_sha256"
        if hash_key not in outputs:
            continue
        target = GEN / season / outputs[key]
        if not target.is_file():
            changes.append({"output": key, "state": "MISSING", "path": outputs[key]})
            continue
        actual = sha256_file(target)
        if actual != outputs[hash_key]:
            changes.append({
                "output": key, "state": "RESYNCED",
                "declared": outputs[hash_key], "actual": actual,
            })
            if apply:
                outputs[hash_key] = actual

    runtime_before = manifest.get("runtime_status")
    if runtime_before == "RUNTIME_TESTED_PASS":
        changes.append({"output": "runtime_status", "state": "DEGRADED",
                        "declared": runtime_before, "actual": "OBSOLETE_MUST_RETEST"})
        if apply:
            manifest["runtime_status"] = "OBSOLETE_MUST_RETEST"
            manifest["runtime_obsolete_reason"] = OBSOLETE_REASON

    if apply and changes:
        # Le hash semantique du manifest se recalcule sur le manifest prive de
        # son propre champ, sinon il se referencerait lui-meme.
        if "manifest_semantic_sha256" in manifest:
            canonical = {k: v for k, v in manifest.items() if k != "manifest_semantic_sha256"}
            manifest["manifest_semantic_sha256"] = hashlib.sha256(
                json.dumps(canonical, ensure_ascii=False, sort_keys=True,
                           separators=(",", ":")).encode()).hexdigest()
        path.write_text(json.dumps(manifest, indent=2, sort_keys=True, ensure_ascii=False) + "\n")

    return {"season": season, "changes": changes}


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--apply", action="store_true",
                        help="ecrit les manifests ; sans ce drapeau, simple rapport")
    args = parser.parse_args()

    results = [resync_manifest(season, args.apply) for season in SEASONS]
    total = sum(len(r["changes"]) for r in results)
    summary = {
        "schema": "new-era.nnv-season-manifest-resync.v1",
        "applied": args.apply,
        "rule": "hashes recalcules sur les fichiers reels ; aucun statut eleve ; "
                "runtime herite d'une geometrie disparue degrade en OBSOLETE_MUST_RETEST",
        "total_changes": total,
        "seasons": results,
    }
    print(json.dumps(summary, indent=2, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
