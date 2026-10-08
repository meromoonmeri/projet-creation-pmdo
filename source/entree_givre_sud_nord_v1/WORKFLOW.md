# WORKFLOW — `entree_givre_sud_nord_v1`

Chantier de la **série sud → nord / arènes / zones**. Procédure de session :
[WORKFLOW.md](../../WORKFLOW.md) · méthode de série : [methode_serie_sud_nord/](../methode_serie_sud_nord/).

## Identité

- **Préfixe** : `EGN1`
- **Namespace** : `entree_givre_sud_nord`
- **Asset Ground** : `egn1_entree_givre`
- **Format** : 424 × 632 px
- **Type** : entrée sud → nord
- **Référence** : `voir README_PACK.md / GEN`
- **Méthode** : rendu généré référencé (pas des tuiles natives), sauf mention contraire dans README_PACK.

## Relancer

Les **bruts** (`source/entree_givre_sud_nord_v1/bruts/`) et le **rip** ne sont pas dans cette extraction.
Les récupérer depuis `meromoonmeri/projet-pmdo` (voir `MANIFESTE_EXTRACTION.md`) avant le build.

```sh
python3 -m venv .venv
.venv/bin/pip install Pillow==12.3.0 numpy==2.4.0 scipy==1.17.0
.venv/bin/python source/entree_givre_sud_nord_v1/build.py
.venv/bin/python -m unittest source.entree_givre_sud_nord_v1.test_build -v
.venv/bin/python source/entree_givre_sud_nord_v1/package.py
```

Un rebuild réécrit l'ORA (horodatages ZIP) : restaurer le fichier s'il n'a pas d'autre changement.
Les tests relisent `.cache/entree_givre_sud_nord_v1/` : lancer `build.py` avant `test_build`.

## Bruts attendus (`GEN`)

- `source/entree_givre_sud_nord_v1/reference/Frosty_Forest_Entrance_RT_mysterydungeonwiki.png`

## Fichiers de méthode ici

`README_PACK.md`, `WORKFLOW.md`, `build.py`, `package.py`, `test_build.py`, `viewer_template.html`

## Non extraits

PNG de `bruts/`, rendus de `renders/entree_givre_sud_nord_v1/` (hors `README.md` / `manifest.json`),
aperçu HTML racine, ZIP PMDO. Récupération : `OUTILS/extraire_depuis_projet-pmdo.py --seulement source/entree_givre_sud_nord_v1 --avec-media`.

## Notes du builder

Entrée Givre sud -> nord V1 — rendu généré, référence Frosty Forest (reference/).

Notice livrée : `README_PACK.md`. Pas de `STATUS.md` : `art_approved: false`, `runtime_tested: false` par défaut de série.
