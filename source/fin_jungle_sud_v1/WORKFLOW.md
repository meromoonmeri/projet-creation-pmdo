# WORKFLOW — `fin_jungle_sud_v1`

Chantier de la **série sud → nord / arènes / zones**. Procédure de session :
[WORKFLOW.md](../../WORKFLOW.md) · méthode de série : [methode_serie_sud_nord/](../methode_serie_sud_nord/).

## Identité

- **Préfixe** : `FJS1`
- **Namespace** : `fin_jungle_sud`
- **Asset Ground** : `fjs1_fin_jungle_sud`
- **Format** : 768 × 576 px
- **Type** : fin de donjon / arène
- **Référence** : `Southern_Jungle_exit_S.png`
- **Méthode** : rendu généré référencé (pas des tuiles natives), sauf mention contraire dans README_PACK.

## Relancer

Les **bruts** (`source/fin_jungle_sud_v1/bruts/`) et le **rip** ne sont pas dans cette extraction.
Les récupérer depuis `meromoonmeri/projet-pmdo` (voir `MANIFESTE_EXTRACTION.md`) avant le build.

```sh
python3 -m venv .venv
.venv/bin/pip install Pillow==12.3.0 numpy==2.4.0 scipy==1.17.0
.venv/bin/python source/fin_jungle_sud_v1/build.py
.venv/bin/python -m unittest source.fin_jungle_sud_v1.test_build -v
.venv/bin/python source/fin_jungle_sud_v1/package.py
```

Un rebuild réécrit l'ORA (horodatages ZIP) : restaurer le fichier s'il n'a pas d'autre changement.
Les tests relisent `.cache/fin_jungle_sud_v1/` : lancer `build.py` avant `test_build`.

## Bruts attendus (`GEN`)

- *(liste `GEN` absente du builder — voir la docstring)*

## Fichiers de méthode ici

`README_PACK.md`, `WORKFLOW.md`, `build.py`, `package.py`, `test_build.py`, `viewer_template.html`

## Non extraits

PNG de `bruts/`, rendus de `renders/fin_jungle_sud_v1/` (hors `README.md` / `manifest.json`),
aperçu HTML racine, ZIP PMDO. Récupération : `OUTILS/extraire_depuis_projet-pmdo.py --seulement source/fin_jungle_sud_v1 --avec-media`.

## Notes du builder

Fin Jungle (FJS1) — sixième zone de fin de donjon de la série des entrées : fond de Southern Jungle, 4:3 (768 x 576).

Notice livrée : `README_PACK.md`. Pas de `STATUS.md` : `art_approved: false`, `runtime_tested: false` par défaut de série.
