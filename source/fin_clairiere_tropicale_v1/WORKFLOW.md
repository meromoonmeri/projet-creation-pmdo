# WORKFLOW — Fin Clairière tropicale (FCT1)

**Carte suivante** de la série après FST1. Biome et portée choisis d’après l’ordre du
mod (jumeau de ETC1). **À confirmer.** Aucun PNG n’a encore été généré dans ce dépôt.

Procédure : [../../WORKFLOW.md](../../WORKFLOW.md) · série : [../methode_serie_sud_nord/](../methode_serie_sud_nord/).

## Identité

- **Préfixe** : `FCT1` — **`FTC1` est pris** (repère de branche sœur, 29 sept.)
- **Slug** : `fin_clairiere_tropicale_v1`
- **Namespace / asset** : `fin_clairiere_tropicale` / `fct1_fin_clairiere_tropicale`
- **Format** : 768 × 576 (96 × 72), brut 1200 × 896
- **Référence** : `large.S01P03A.png.84e22fb77c4061e77b0f546545fed2c7.png` (même rip que ETC1)
- **Méthode** : rendu généré référencé. Pas de tuiles natives.

## Layout (fin, pas entrée)

Ne **pas** reprendre mer, ponton, rive ni bouche sombre d’ETC1.

- Sud : sentier d’herbe / dalles de sable qui débouchent dans la clairière (`entrance`).
- Centre : grande clairière praticable, hibiscus et palmiers en périphérie (`boss`).
- Nord : tertre de fleurs / grand palmier, pas d’alcôve sombre (`objectif`).
- Bords : jungle dense sur les quatre côtés (arène fermée). Canopée éventuelle au premier plan (comme FJS1).
- Aucune sortie, aucun warp, pas de `donjon_seuil`.

## Bruts à générer (`GEN`)

Rip en `images=` à chaque appel. Consigne `WIDE LANDSCAPE 4:3, zoomed out`.

1. **`decor.png`** — clairière tropicale fermée, herbe jaune-vert **mutée** du rip
   (pas l’herbe acide écartée d’ETC1, distance 69,8). Palmiers, hibiscus rouge / jaune /
   cyan / rose, dalles tan, cailloux gris, jungle sombre en bordure.
   **Pas de mer, pas de magenta, pas de grotte, pas de perso.**
   Écarter tout 2:1 et toute herbe hors seuil 35.
2. **`sol_complet.png`** — édition du décor : uniquement l’herbe de clairière,
   même texture, partout. Recalage (0, 0).
3. **`temoin_sans_objets.png`** — décor sans palmiers, fleurs, touffes, cailloux
   (différence = calques d’objets, comme ETC1).
4. **`papillons_poses.png`** — **ne pas régénérer** : copier
   `source/entree_clairiere_tropicale_sud_nord_v1/bruts/papillons_poses.png`
   (même SHA-256, mêmes `POSE_WIN`).

Fidélité à mesurer sur herbe, jungle, dalles (seuils ETC1 : herbe 20,4 · jungle 32,0 · dalles 25,1).

## Calques proposés (bas → haut)

| # | Calque | Animation |
|---|---|---|
| 00 | sol complet | fixe |
| 01 | herbe praticable | fixe |
| 02 | ombres au pied de la jungle | fixe |
| 03 | dalles de sable | fixe |
| 04 | touffes et cailloux | fixe |
| 05 | fleurs (hibiscus) | fixe, ou 24 × 5 si balancement |
| 06 | jungle dense | fixe |
| 07 | palmiers | fixe |
| 08 | canopée premier plan (si le brut en a une) | fixe |
| 09 | papillons (planche ETC1, vols en huit) | 24 × 5 ticks |
| 10 | Top vide `Layer=4` | — |

Scène : 120 ticks (2 s). Pas d’alpha intermédiaire.

Collisions : herbe, ombres, dalles, touffes reliées = praticable. Jungle, palmiers,
fleurs, canopée = bloqués. Papillons visuels. Chemin 16 × 16 sud → boss → objectif.

## Relancer (quand les bruts seront là)

```sh
.venv/bin/python source/fin_clairiere_tropicale_v1/build.py
.venv/bin/python -m unittest source.fin_clairiere_tropicale_v1.test_build -v
.venv/bin/python source/fin_clairiere_tropicale_v1/package.py
```

Builder / tests / paquet : **à écrire au moment de la génération des bruts**,
en copiant `fin_jungle_sud_v1` + segmentation / papillons d’ETC1. Ne pas inventer
des seuils `classify` avant d’avoir mesuré le brut.

## Limites

- Méthode ouverte le 8 oct. 2026 dans `projet-creation-pmdo` : pas de rendu, pas de Ground.
- `art_approved: false` · `runtime_tested: false`
- Biome à confirmer.
