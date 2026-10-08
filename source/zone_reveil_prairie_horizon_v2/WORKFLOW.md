# WORKFLOW — `zone_reveil_prairie_horizon_v2`

Chantier de la **série sud → nord / arènes / zones**. Procédure de session :
[WORKFLOW.md](../../WORKFLOW.md) · méthode de série : [methode_serie_sud_nord/](../methode_serie_sud_nord/).

## Identité

- **Préfixe** : `ZRV2`
- **Namespace** : `zone_reveil_prairie_horizon_v2`
- **Format** : 768 × 576 px
- **Type** : zone
- **Référence** : `voir README_PACK.md / GEN`
- **Méthode** : rendu généré référencé (pas des tuiles natives), sauf mention contraire dans README_PACK.

## Relancer

Les **bruts** (`source/zone_reveil_prairie_horizon_v2/bruts/`) et le **rip** ne sont pas dans cette extraction.
Les récupérer depuis `meromoonmeri/projet-pmdo` (voir `MANIFESTE_EXTRACTION.md`) avant le build.

```sh
python3 -m venv .venv
.venv/bin/pip install Pillow==12.3.0 numpy==2.4.0 scipy==1.17.0
.venv/bin/python source/zone_reveil_prairie_horizon_v2/build.py
.venv/bin/python -m unittest source.zone_reveil_prairie_horizon_v2.test_build -v
.venv/bin/python source/zone_reveil_prairie_horizon_v2/package.py
```

Un rebuild réécrit l'ORA (horodatages ZIP) : restaurer le fichier s'il n'a pas d'autre changement.
Les tests relisent `.cache/zone_reveil_prairie_horizon_v2/` : lancer `build.py` avant `test_build`.

## Bruts attendus (`GEN`)

- `ciel_mer_jour.png`
- `cretes_jour.png`
- `banc_nuages_jour.png`
- `banc_nuages_jour_c.png`
- `banc_nuages_jour_b.png`
- `reflets_astres.png`
- `decor_crepuscule_zrv1.png`
- `montagne_jour.png`
- `astres.png`

## Fichiers de méthode ici

`README_PACK.md`, `WORKFLOW.md`, `build.py`, `package.py`, `test_build.py`, `viewer_template.html`

## Non extraits

PNG de `bruts/`, rendus de `renders/zone_reveil_prairie_horizon_v2/` (hors `README.md` / `manifest.json`),
aperçu HTML racine, ZIP PMDO. Récupération : `OUTILS/extraire_depuis_projet-pmdo.py --seulement source/zone_reveil_prairie_horizon_v2 --avec-media`.

## Notes du builder

Zone de réveil V2 (ZRV2) — même prairie que ZRV1, mer et fond refaits. 768 x 576 px, jour / aube / nuit.

Notice livrée : `README_PACK.md`. Pas de `STATUS.md` : `art_approved: false`, `runtime_tested: false` par défaut de série.
