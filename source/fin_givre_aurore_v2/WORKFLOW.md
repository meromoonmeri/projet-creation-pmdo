# WORKFLOW — `fin_givre_aurore_v2`

Chantier de la **série sud → nord / arènes / zones**. Procédure de session :
[WORKFLOW.md](../../WORKFLOW.md) · méthode de série : [methode_serie_sud_nord/](../methode_serie_sud_nord/).

## Identité

- **Préfixe** : `FGG2`
- **Namespace** : `fin_givre_aurore`
- **Asset Ground** : `fgg2_fin_givre_aurore`
- **Format** : 768 × 576 px
- **Type** : fin de donjon / arène
- **Référence** : `pmdskyicearena.png`
- **Méthode** : rendu généré référencé (pas des tuiles natives), sauf mention contraire dans README_PACK.

## Relancer

Les **bruts** (`source/fin_givre_aurore_v2/bruts/`) et le **rip** ne sont pas dans cette extraction.
Les récupérer depuis `meromoonmeri/projet-pmdo` (voir `MANIFESTE_EXTRACTION.md`) avant le build.

```sh
python3 -m venv .venv
.venv/bin/pip install Pillow==12.3.0 numpy==2.4.0 scipy==1.17.0
.venv/bin/python source/fin_givre_aurore_v2/build.py
.venv/bin/python -m unittest source.fin_givre_aurore_v2.test_build -v
.venv/bin/python source/fin_givre_aurore_v2/package.py
```

Un rebuild réécrit l'ORA (horodatages ZIP) : restaurer le fichier s'il n'a pas d'autre changement.
Les tests relisent `.cache/fin_givre_aurore_v2/` : lancer `build.py` avant `test_build`.

## Bruts attendus (`GEN`)

- *(liste `GEN` absente du builder — voir la docstring)*

## Fichiers de méthode ici

`README_PACK.md`, `WORKFLOW.md`, `build.py`, `package.py`, `test_build.py`, `viewer_template.html`

## Non extraits

PNG de `bruts/`, rendus de `renders/fin_givre_aurore_v2/` (hors `README.md` / `manifest.json`),
aperçu HTML racine, ZIP PMDO. Récupération : `OUTILS/extraire_depuis_projet-pmdo.py --seulement source/fin_givre_aurore_v2 --avec-media`.

## Notes du builder

Fin Givre V2 (FGG2) — fin de Frosty Grotto 4:3 sans cristal, ouverte au nord sur des aurores boréales.

Notice livrée : `README_PACK.md`. Pas de `STATUS.md` : `art_approved: false`, `runtime_tested: false` par défaut de série.
