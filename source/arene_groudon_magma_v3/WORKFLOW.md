# WORKFLOW — `arene_groudon_magma_v3`

Chantier de la **série sud → nord / arènes / zones**. Procédure de session :
[WORKFLOW.md](../../WORKFLOW.md) · méthode de série : [methode_serie_sud_nord/](../methode_serie_sud_nord/).

## Identité

- **Préfixe** : `AGM3`
- **Namespace** : `arene_groudon_magma_v3`
- **Asset Ground** : `agm3_arene_groudon_magma`
- **Type** : arène
- **Référence** : `Dark_Crater_Pit_TDS.png`
- **Méthode** : rendu généré référencé (pas des tuiles natives), sauf mention contraire dans README_PACK.

## Relancer

Les **bruts** (`source/arene_groudon_magma_v3/bruts/`) et le **rip** ne sont pas dans cette extraction.
Les récupérer depuis `meromoonmeri/projet-pmdo` (voir `MANIFESTE_EXTRACTION.md`) avant le build.

```sh
python3 -m venv .venv
.venv/bin/pip install Pillow==12.3.0 numpy==2.4.0 scipy==1.17.0
.venv/bin/python source/arene_groudon_magma_v3/build.py
.venv/bin/python -m unittest source.arene_groudon_magma_v3.test_build -v
.venv/bin/python source/arene_groudon_magma_v3/package.py
```

Un rebuild réécrit l'ORA (horodatages ZIP) : restaurer le fichier s'il n'a pas d'autre changement.
Les tests relisent `.cache/arene_groudon_magma_v3/` : lancer `build.py` avant `test_build`.

## Bruts attendus (`GEN`)

- *(liste `GEN` absente du builder — voir la docstring)*

## Fichiers de méthode ici

`README_PACK.md`, `WORKFLOW.md`, `build.py`, `colonnes_generees.py`, `package.py`, `test_build.py`, `viewer_template.html`

## Non extraits

PNG de `bruts/`, rendus de `renders/arene_groudon_magma_v3/` (hors `README.md` / `manifest.json`),
aperçu HTML racine, ZIP PMDO. Récupération : `OUTILS/extraire_depuis_projet-pmdo.py --seulement source/arene_groudon_magma_v3 --avec-media`.

## Notes du builder

Arène de Groudon magma V3 (AGM3) — AGM2 avec des colonnes de magma GÉNÉRÉES par le générateur d'images. 4:3.

Notice livrée : `README_PACK.md`. Pas de `STATUS.md` : `art_approved: false`, `runtime_tested: false` par défaut de série.
