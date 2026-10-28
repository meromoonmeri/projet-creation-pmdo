# Galerie exhaustive des maps — `apercu_galerie_maps.html`

Recense **toutes** les maps du projet dans une **seule page autonome, sans zip**, avec une
vignette PNG/WebP par map, un filtre par famille, une recherche et une visionneuse.

Page : **[`apercu_galerie_maps.html`](../../apercu_galerie_maps.html)** (racine du dépôt).
Vignettes : `apercus/galerie_maps/` (**232 images**, ~20 Mo, dimensionnées ≤ 640 px).

## Périmètre recensé — 290 maps

| Source | Unité de map | Count | Ce qui est montré |
|---|---|---:|---|
| `renders/` du dépôt `projet-pmdo` @ `6cca4a0` | lot ou sous-map (`zone_zero_v1/RAZ1`…) | 171 | une composition par map (`*_scene_t000.png` en priorité, sinon `composite`, `composition`, planche, vue d'ensemble) |
| cette branche, lots absents du dépôt source | lot | 107 | voir la hiérarchie ci-dessous |
| `kit.json` (`salles/`) | salle de la guilde | 12 | `salle_jour.png` (la variante nuit existe) |
| **total** | | **290** | **232 avec vignette, 58 sans image versionnée** |

Les 58 lots sans vignette ne sont **pas** omis : ils apparaissent avec le badge « sans image »
et la raison (« aucune image versionnée sur la branche — rendus dans le dépôt source
`projet-pmdo` »). Le filtre « masquer les lots sans image » permet de ne voir que les 232
maps illustrées.

## Hiérarchie de choix de l'image (branche)

1. **aperçu autonome local** — `apercu_<lot>.html` embarque son manifeste `const D={…}` avec les
   calques en data-URI : on recompose le **calque 0 de chaque étage de `D.stack`**, alpha compris
   (ex. `fin_caverne_cristal_v1`, 11 calques → 768 × 576). C'est la vraie composition livrée.
2. **calques versionnés** — `renders/<lot>/layers/*.png` réellement commités
   (`mont_lointain_*`, `mont_foudre_*`, `mont_brasier_*`, `mine_magma_*`, `foret_givree_*`),
   recomposés du bas vers le haut.
3. **bruts du lot** — `source/<lot>/bruts/base_*.png`, puis `decor_*.png`, puis
   `references/ref_canon_*.png` : badge **rendu** ou **référence** selon le cas, pour ne jamais
   faire passer une référence canonique pour notre livraison.

**Garde-fou magenta** : un brut dont le fond est encore magenta/violet vif (plus de 1 % des
pixels) est **refusé** — la galerie ne montre jamais un décor non détouré comme une map.

## Maps physiquement dans la branche — `maps/`

Les familles **entrée / fin / arène / zone / guilde** (83 maps, 51,6 Mo), **donjon** (31 maps, 14,6 Mo) et **cotes** (23 maps, 19,6 Mo) sont rapatriées **octet pour octet** — 137 maps, 85,7 Mo —
dans `maps/` (voir [`maps/README.md`](../../maps/README.md)) : `rapatrier.py` vérifie le **sha1 git
du blob** avant écriture et consigne le sha256 dans `maps/MANIFESTE_MAPS.json`. La galerie lie
chaque carte au fichier natif (« ▶ PNG natif ») et propose la case *« seulement les fichiers natifs
de la branche »*. Le reste (`divers` 9,8 Mo, `monde` 29 Mo) se rapatrie par
`--categories divers,monde` ou `--tout`.

## Compression

Réduction LANCZOS à **640 px** de large au plus, puis **palette 255 couleurs** si l'écart RVB
moyen ≤ 2,5/255 (fidèle, fichier 4 à 6 × plus léger qu'un PNG RGBA), sinon **WebP q92** (cas
des vignettes pleines de dégradés). Aucune image n'est agrandie, aucune n'est retouchée.

## Reproductible

```sh
python3 -m venv .venv && .venv/bin/pip install Pillow      # Pillow 12/13
.venv/bin/python source/galerie_maps/preparer.py           # 171 lots du dépôt source (~2 min)
.venv/bin/python source/galerie_maps/preparer_branche.py   # 107 lots de la branche (~15 s)
.venv/bin/python source/galerie_maps/preparer_salles.py    # 12 salles de kit.json
.venv/bin/python source/galerie_maps/build_galerie.py      # apercu_galerie_maps.html
NODE_PATH=/tmp/nc/node_modules node source/galerie_maps/test_galerie.js   # 28 contrôles
```

`preparer.py` lit l'arbre du dépôt source via `gh api` (cache local `arbre_renders.json`,
**non versionné**) et télécharge un seul blob par map ; les autres ne refont rien
(`--force` pour tout reprendre). Les trois sorties JSON (`galerie.json`,
`galerie_branche.json`, `galerie_salles.json`) sont versionnées : ce sont les métadonnées
exactes utilisées par la page.

## Contrôle

`test_galerie.js` rejoue la page dans jsdom (DOM réel, scripts exécutés) et vérifie 28 points :
une carte par map, familles, absence de chargement d'image par défaut, chargement différé,
présence des 232 vignettes sur le disque, filtre par famille, recherches, masquage, filtre
« sans image », badges de nature, visionneuse et lien vers l'image d'origine sur GitHub.

## Limites — ce que cette galerie ne prouve pas

- Une vignette est **une composition 2D** : elle ne montre ni les collisions, ni les marqueurs,
  ni le rendu moteur PMDO. `art_approved = false`, aucun test runtime PMDO.
- Les lots hérités montrent **une** image représentative, pas leurs calques ni leurs animations ;
  ceux-ci restent dans le dépôt source (`renders/`, 4,6 Go).
- Une référence canonique (badge « référence ») illustre un lot dont le rendu final n'est pas
  versionné : ce n'est pas notre livraison.
- La galerie **documente l'existant** : elle ne corrige, ne régénère et n'approuve aucun lot.
