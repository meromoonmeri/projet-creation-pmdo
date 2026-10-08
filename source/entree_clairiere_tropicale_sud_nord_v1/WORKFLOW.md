# WORKFLOW — `entree_clairiere_tropicale_sud_nord_v1`

Chantier de la **série sud → nord / arènes / zones**. Procédure de session :
[WORKFLOW.md](../../WORKFLOW.md) · méthode de série : [methode_serie_sud_nord/](../methode_serie_sud_nord/).

## Identité

- **Préfixe** : `ETC1`
- **Namespace** : `entree_clairiere_tropicale_sud_nord`
- **Asset Ground** : `etc1_entree_clairiere_tropicale`
- **Format** : 768 × 576 px
- **Type** : entrée sud → nord
- **Référence** : `large.S01P03A.png.84e22fb77c4061e77b0f546545fed2c7.png`
- **Méthode** : rendu généré référencé (pas des tuiles natives), sauf mention contraire dans README_PACK.

## Relancer

Les **bruts** (`source/entree_clairiere_tropicale_sud_nord_v1/bruts/`) et le **rip** ne sont pas dans cette extraction.
Les récupérer depuis `meromoonmeri/projet-pmdo` (voir `MANIFESTE_EXTRACTION.md`) avant le build.

```sh
python3 -m venv .venv
.venv/bin/pip install Pillow==12.3.0 numpy==2.4.0 scipy==1.17.0
.venv/bin/python source/entree_clairiere_tropicale_sud_nord_v1/build.py
.venv/bin/python -m unittest source.entree_clairiere_tropicale_sud_nord_v1.test_build -v
.venv/bin/python source/entree_clairiere_tropicale_sud_nord_v1/package.py
```

Un rebuild réécrit l'ORA (horodatages ZIP) : restaurer le fichier s'il n'a pas d'autre changement.
Les tests relisent `.cache/entree_clairiere_tropicale_sud_nord_v1/` : lancer `build.py` avant `test_build`.

## Bruts attendus (`GEN`)

- `ecartes/decor_magenta_essai1_herbe_acide.png`
- `decor_magenta.png`
- `sol_complet.png`
- `temoin_sans_objets.png`
- `papillons_poses.png`

## Fichiers de méthode ici

`README_PACK.md`, `WORKFLOW.md`, `build.py`, `package.py`, `test_build.py`, `viewer_template.html`

## Non extraits

PNG de `bruts/`, rendus de `renders/entree_clairiere_tropicale_sud_nord_v1/` (hors `README.md` / `manifest.json`),
aperçu HTML racine, ZIP PMDO. Récupération : `OUTILS/extraire_depuis_projet-pmdo.py --seulement source/entree_clairiere_tropicale_sud_nord_v1 --avec-media`.

## Notes du builder

Entrée Clairière tropicale sud -> nord V1 (ETC1) — format 4:3 vaste (768 x 576 px, 96 x 72 cases).

Notice livrée : `README_PACK.md`. Pas de `STATUS.md` : `art_approved: false`, `runtime_tested: false` par défaut de série.
