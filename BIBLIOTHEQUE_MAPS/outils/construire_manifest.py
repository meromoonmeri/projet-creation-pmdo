#!/usr/bin/env python3
"""Régénère BIBLIOTHEQUE_MAPS/manifest.json : catalogue factuel des cartes.

Pour chaque .rsground candidat (bibliothèque + dépôt), le manifest croise :
  - l'analyse structurelle (rsground.analyser) : tailles, EdgeView, calques,
    marqueurs, tilesets référencés par section ;
  - l'audit clamp (clamp_rsground.auditer) avec contrôle TexLoc quand le
    fichier .tile est présent dans le dépôt ;
  - le verdict de provenance (../provenance_maps.json, maintenu à la main) ;
  - l'inventaire des .tile du dépôt (basename -> chemins) : présent/missing
    pour chaque tileset, et collisions de basename entre cartes livrées.

Aucun fichier de carte n'est modifié. Usage :
    python construire_manifest.py            # écrit ../manifest.json
    python construire_manifest.py --sec      # affiche seulement le résumé
"""
import argparse
import hashlib
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import clamp_rsground  # noqa: E402
import rsground  # noqa: E402

BIBLIO = Path(__file__).resolve().parents[1]
RACINE = BIBLIO.parent


def sha256(chemin):
    return hashlib.sha256(Path(chemin).read_bytes()).hexdigest()


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--sec", action="store_true", help="ne pas écrire le manifest")
    args = parser.parse_args(argv)

    verdicts = json.loads((BIBLIO / "provenance_maps.json").read_text(encoding="utf-8"))

    # Inventaire des tilesets du dépôt (hors bibliothèque : on veut les sources).
    inventaire = {}
    for fichier in sorted(RACINE.rglob("*.tile")):
        if BIBLIO in fichier.parents:
            continue
        relatif = str(fichier.relative_to(RACINE))
        entree = inventaire.setdefault(fichier.stem, {"chemins": [], "grille": None})
        entree["chemins"].append(relatif)
        if entree["grille"] is None:
            try:
                entree["grille"] = clamp_rsground.grille_tile(fichier)
            except ValueError:
                entree["grille"] = set()

    # Cartes livrées par la bibliothèque (déjà clampées) puis candidates du dépôt.
    livrees = {p.stem: p for p in sorted((BIBLIO / "grounds").glob("*.rsground"))}
    candidates = []
    for chemin in sorted(RACINE.rglob("*.rsground")):
        if BIBLIO in chemin.parents or (RACINE / "quest_pmdo_0812") in chemin.parents:
            continue
        candidates.append(chemin)

    entrees = []
    for chemin in candidates:
        relatif = str(chemin.relative_to(RACINE))
        verdict = verdicts.get(relatif, {})
        donnees, _bom = rsground.charger(chemin)
        objet = donnees["Object"]
        info = rsground.analyser(donnees)
        grilles = {nom: inv["grille"] for nom, inv in inventaire.items()}
        audit = clamp_rsground.auditer(objet, grilles)

        tilesets = []
        for nom, nb in sorted(info["tilesets"].get("tuiles", {}).items()):
            inv = inventaire.get(nom)
            tilesets.append({
                "nom": nom,
                "tuiles_peintes": nb,
                "tile_dans_depot": bool(inv),
                "tile_chemins": inv["chemins"] if inv else [],
            })

        id_biblio = verdict.get("id_bibliotheque", chemin.stem)
        livree = livrees.get(id_biblio)
        entree = {
            "id": id_biblio,
            "source_depot": relatif,
            "sha256_source": sha256(chemin),
            "provenance": verdict.get("origine", "À VÉRIFIER"),
            "auteur": verdict.get("auteur", "inconnu"),
            "licence": verdict.get("licence", "À VÉRIFIER"),
            "statut_provenance": verdict.get("statut", "a_verifier"),
            "note_provenance": verdict.get("note", ""),
            "nom_affiche": info["nom_affiche"],
            "version_conteneur": info["version_conteneur"],
            "TexSize": info["TexSize"],
            "taille_cases": info["taille_cases"],
            "taille_px": info["taille_px"],
            "EdgeView_source": info["EdgeView_nom"],
            "nb_calques": len(info["calques"]),
            "nb_personnages": info["nb_personnages"],
            "nb_objets": info["nb_objets"],
            "marqueurs": [m["nom"] for m in info["marqueurs"]],
            "Musique": info["Musique"],
            "tilesets_tuiles": tilesets,
            "autres_references_sheets": {
                s: sorted(n) for s, n in info["tilesets"].items() if s != "tuiles"},
            "audit_clamp_source": {
                "problemes": [p["message"] for p in audit["problemes"]],
                "avertissements": audit["avertissements"],
            },
            "livree_en_bibliotheque": None,
        }
        if livree is not None:
            d_liv, _ = rsground.charger(livree)
            audit_liv = clamp_rsground.auditer(d_liv["Object"], grilles)
            entree["livree_en_bibliotheque"] = {
                "fichier": f"grounds/{livree.name}",
                "sha256": sha256(livree),
                "EdgeView": rsground.analyser(d_liv)["EdgeView_nom"],
                "problemes_restants": [p["message"] for p in audit_liv["problemes"]],
            }
        entrees.append(entree)

    # Collisions de basename entre cartes importables/livrées (l'import écrase).
    basenames = {}
    for e in entrees:
        basenames.setdefault(e["id"], []).append(e["source_depot"])
    collisions = {k: v for k, v in basenames.items() if len(v) > 1}

    manifest = {
        "bibliotheque": "Bibliothèque de Ground/maps PMDO 0.8.12 — toutes les cartes livrées sont en EdgeView=Clamp et bornées (voir outils/clamp_rsground.py).",
        "genere_par": "outils/construire_manifest.py",
        "regles": {
            "importable": "copie clampée dans grounds/ + déclaration GroundMaps générée",
            "en_attente_accord": "cataloguée, NON copiée : accord de l'auteur requis (Étape 0.4)",
            "exclu": "cataloguée pour traçabilité, ne jamais importer (Étape 0.3)",
        },
        "collisions_basename": collisions,
        "cartes": entrees,
    }

    if not args.sec:
        (BIBLIO / "manifest.json").write_text(
            json.dumps(manifest, ensure_ascii=False, indent=1) + "\n", encoding="utf-8")
        print(f"manifest.json écrit ({len(entrees)} cartes).")

    print(f"{'CARTE':<34} {'STATUT':<18} {'TAILLE':<10} {'EDGE':<6} CLAMP")
    for e in entrees:
        taille = f"{e['taille_cases'][0]}×{e['taille_cases'][1]}"
        nb_p = len(e["audit_clamp_source"]["problemes"])
        liv = "livrée" if e["livree_en_bibliotheque"] else "—"
        print(f"{e['id']:<34} {e['statut_provenance']:<18} {taille:<10} "
              f"{e['EdgeView_source']:<6} {nb_p} pb source · {liv}")
    if collisions:
        print("Collisions de basename :", collisions)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
