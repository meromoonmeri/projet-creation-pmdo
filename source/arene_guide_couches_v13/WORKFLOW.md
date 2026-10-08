# WORKFLOW — `arene_guide_couches_v13`

Chantier de la **série sud → nord / arènes / zones**. Procédure de session :
[WORKFLOW.md](../../WORKFLOW.md) · méthode de série : [methode_serie_sud_nord/](../methode_serie_sud_nord/).

## Identité

- **Type** : arène
- **Référence** : `voir README_PACK.md / GEN`
- **Méthode** : rendu généré référencé (pas des tuiles natives), sauf mention contraire dans README_PACK.

## Relancer

Les **bruts** (`source/arene_guide_couches_v13/bruts/`) et le **rip** ne sont pas dans cette extraction.
Les récupérer depuis `meromoonmeri/projet-pmdo` (voir `MANIFESTE_EXTRACTION.md`) avant le build.

```sh
python3 -m venv .venv
.venv/bin/pip install Pillow==12.3.0 numpy==2.4.0 scipy==1.17.0
.venv/bin/python source/arene_guide_couches_v13/build.py
.venv/bin/python -m unittest source.arene_guide_couches_v13.test_build -v
.venv/bin/python source/arene_guide_couches_v13/package.py
```

Un rebuild réécrit l'ORA (horodatages ZIP) : restaurer le fichier s'il n'a pas d'autre changement.
Les tests relisent `.cache/arene_guide_couches_v13/` : lancer `build.py` avant `test_build`.

## Bruts attendus (`GEN`)

- *(liste `GEN` absente du builder — voir la docstring)*

## Fichiers de méthode ici

`STATUS.md`, `WORKFLOW.md`, `build.py`, `package.py`, `test_build.py`, `viewer.html`

## Non extraits

PNG de `bruts/`, rendus de `renders/arene_guide_couches_v13/` (hors `README.md` / `manifest.json`),
aperçu HTML racine, ZIP PMDO. Récupération : `OUTILS/extraire_depuis_projet-pmdo.py --seulement source/arene_guide_couches_v13 --avec-media`.

## Notes du builder

V13 : rebase sur le layout_guide.png de la V1 - scene en plusieurs calques separes, aurore animee INDEPENDANTE du ciel par palette cycling (rameaux = vraies couleurs du guide). Calques : ciel (fixe) / etoiles (fixes) / aurore (8 frames palette cycling) / terrain (fixe). Frame 0 = guide exact : composite(frame 0) == layout_guide.png (test exact).

Pas de `README_PACK.md` dans ce chantier. État : `STATUS.md`.
