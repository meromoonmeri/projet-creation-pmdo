# WORKFLOW — `zone_zero_v2`

Chantier de la **série sud → nord / arènes / zones**. Procédure de session :
[WORKFLOW.md](../../WORKFLOW.md) · méthode de série : [methode_serie_sud_nord/](../methode_serie_sud_nord/).

## Identité

- **Format** : 768 × 576 px
- **Type** : zone
- **Référence** : `voir README_PACK.md / GEN`
- **Méthode** : rendu généré référencé (pas des tuiles natives), sauf mention contraire dans README_PACK.

## Relancer

Les **bruts** (`source/zone_zero_v2/bruts/`) et le **rip** ne sont pas dans cette extraction.
Les récupérer depuis `meromoonmeri/projet-pmdo` (voir `MANIFESTE_EXTRACTION.md`) avant le build.

```sh
python3 -m venv .venv
.venv/bin/pip install Pillow==12.3.0 numpy==2.4.0 scipy==1.17.0
.venv/bin/python source/zone_zero_v2/build.py
.venv/bin/python source/zone_zero_v2/package.py
```

Un rebuild réécrit l'ORA (horodatages ZIP) : restaurer le fichier s'il n'a pas d'autre changement.
Les tests relisent `.cache/zone_zero_v2/` : lancer `build.py` avant `test_build`.

## Bruts attendus (`GEN`)

- *(liste `GEN` absente du builder — voir la docstring)*

## Fichiers de méthode ici

`WORKFLOW.md`, `build.py`, `haute_qualite.py`, `mutations.py`, `package.py`, `tests_communs.py`, `viewer_template.html`

## Non extraits

PNG de `bruts/`, rendus de `renders/zone_zero_v2/` (hors `README.md` / `manifest.json`),
aperçu HTML racine, ZIP PMDO. Récupération : `OUTILS/extraire_depuis_projet-pmdo.py --seulement source/zone_zero_v2 --avec-media`.

## Notes du builder

Réseau Zone Zéro V2, routes fleuries (RAF1, RAF2) — 4:3 (768 x 576).

Pas de `README_PACK.md` dans ce chantier. Pas de `STATUS.md` : `art_approved: false`, `runtime_tested: false` par défaut de série.
