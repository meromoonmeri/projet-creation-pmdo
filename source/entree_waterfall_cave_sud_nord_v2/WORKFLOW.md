# WORKFLOW — `entree_waterfall_cave_sud_nord_v2`

Chantier de la **série sud → nord / arènes / zones**. Procédure de session :
[WORKFLOW.md](../../WORKFLOW.md) · méthode de série : [methode_serie_sud_nord/](../methode_serie_sud_nord/).

## Identité

- **Préfixe** : `EWC2`
- **Namespace** : `entree_waterfall_cave_v2`
- **Asset Ground** : `ewc2_entree_waterfall_cave`
- **Type** : entrée sud → nord
- **Référence** : `entrancecascade.png`
- **Méthode** : rendu généré référencé (pas des tuiles natives), sauf mention contraire dans README_PACK.

## Relancer

Les **bruts** (`source/entree_waterfall_cave_sud_nord_v2/bruts/`) et le **rip** ne sont pas dans cette extraction.
Les récupérer depuis `meromoonmeri/projet-pmdo` (voir `MANIFESTE_EXTRACTION.md`) avant le build.

```sh
python3 -m venv .venv
.venv/bin/pip install Pillow==12.3.0 numpy==2.4.0 scipy==1.17.0
.venv/bin/python source/entree_waterfall_cave_sud_nord_v2/build.py
.venv/bin/python -m unittest source.entree_waterfall_cave_sud_nord_v2.test_build -v
.venv/bin/python source/entree_waterfall_cave_sud_nord_v2/package.py
```

Un rebuild réécrit l'ORA (horodatages ZIP) : restaurer le fichier s'il n'a pas d'autre changement.
Les tests relisent `.cache/entree_waterfall_cave_sud_nord_v2/` : lancer `build.py` avant `test_build`.

## Bruts attendus (`GEN`)

- `entrancecascade.png`

## Fichiers de méthode ici

`README_PACK.md`, `WORKFLOW.md`, `build.py`, `package.py`, `test_build.py`, `viewer_template.html`

## Non extraits

PNG de `bruts/`, rendus de `renders/entree_waterfall_cave_sud_nord_v2/` (hors `README.md` / `manifest.json`),
aperçu HTML racine, ZIP PMDO. Récupération : `OUTILS/extraire_depuis_projet-pmdo.py --seulement source/entree_waterfall_cave_sud_nord_v2 --avec-media`.

## Notes du builder

Entrée Waterfall Cave sud -> nord V2 (EWC2) — format 4:3 vaste (768 x 576 px, 96 x 72 cases).

Notice livrée : `README_PACK.md`. Pas de `STATUS.md` : `art_approved: false`, `runtime_tested: false` par défaut de série.
