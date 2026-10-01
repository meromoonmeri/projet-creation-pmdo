# Arène de Groudon V2 — signe au sol, colonnes géantes (AGM2), PMDO 0.8.12

Deuxième version de l'arène de boss sur le lac de magma. Deux changements par rapport à AGM1, qui est conservée :

- le **Ω de Primo-Groudon pulse directement sur le sol** de l'arène : il n'y a plus d'estrade ;
- quatre **colonnes de magma géantes** montent du lac jusqu'au bord de la carte, et **on n'en voit jamais le sommet**.

Le **magma visqueux** est inchangé. L'arène va avec l'entrée Cratère magma (ECM1).

- Format 4:3 : 768 × 576 px, soit 96 × 72 cases de 8 px.
- Référence : `Dark_Crater_Pit_TDS.png`, la fosse de Dark Crater dans PMD Sky, par l'intermédiaire du brut AGM1. Le brut AGM2 est une **édition générée du brut AGM1** qui ne change qu'une chose : le dais disparaît et le signe est gravé dans la pierre du sol.
  - Écart mesuré hors du signe : 10,6 de somme RVB moyenne, et 0,12 % de pixels qui s'écartent de plus de 60. Les tests exigent moins de 20 et moins de 1 %.
  - **Ce ne sont pas des tuiles natives.** Le magma vient de `source/magma_visqueux/magma.py`, les colonnes de `source/magma_visqueux/colonnes_geantes.py`.
- Fidélité du sol : distance 13,7 pour un seuil de 35. Elle monte par rapport à AGM1 (4,6) parce que la lueur rouge du signe compte maintenant dans le sol praticable. Fidélité du magma : 10,1 pour un seuil de 12.
- Layout :
  - arrivée au sud, par le chemin de pierre (marqueur `entrance`) ;
  - grande arène de pierre, avec au centre le Ω dans son anneau, Ø ≈ 250 px, sur lequel on marche ;
  - le marqueur `boss` est au centre du Ω, le marqueur `heros` juste au sud de l'anneau ;
  - quatre colonnes, deux de chaque côté : celles du fond font 40 px de large et leur bouche est à y ≈ 205 ; celles de devant font 56 px et leur bouche est à y ≈ 433.
  - Aucune sortie, aucun warp.

## Calques (du bas vers le haut)

| # | Calque | Animation |
|---|---|---|
| 00 | magma | 32 × 15 ticks, magma visqueux ; des rides s'éloignent du pied des colonnes |
| 01 | sol_complet | fixe |
| 02 | sol_arene | fixe, seule zone praticable, signe compris |
| 03 | rebord | fixe |
| 04 | pitons | fixe |
| 05 | symbole_groudon | 12 × 10 ticks : les lignes du Ω et de l'anneau montent du rouge au jaune vif puis redescendent. Un halo gagne la pierre : 1 px à partir du niveau 3, 3 px au pic |
| 06 | braises | 6 × 10 ticks, braises du rebord et des pitons |
| 07 | colonnes | 48 × 5 ticks : la matière monte d'environ 12 px par phase, avec un cœur jaune, des filets, des plaques de croûte, deux poussées par cycle et un contour sombre. Au pied, une gerbe bouillonnante, 14 gouttes et des ondes. Les quatre colonnes sont décalées |
| 08 | Top (vide) | à vous |

La scène boucle en 480 ticks (8 s). Les colonnes du fond sont dessinées sous celles de devant.

## Installation

Lancez `python INSTALLER.py <dossier PMDO>`. Le script fusionne l'index des tuiles au lieu de l'écraser.

**Non testé dans PMDO.** Le manifeste indique `runtime_tested: false` et `art_approved: false`.

## Fichiers

- `calques/` : calques fixes (`AGM2_NN_nom.png`).
- `animation/magma`, `animation/symbole_groudon`, `animation/braises`, `animation/colonnes` : images des animations, `fNN`.
- `masques/` : lave, sol, rebord, pitons, symbole.
- `review/` : scène t000, scène animée en WebP, collisions et marqueurs, pulsation du symbole.
- `AGM2_arene_groudon_magma_calques.ora` : les calques dans un seul fichier.
- `manifest.json` : empreintes des bruts, écart au brut AGM1, fidélité, chronologies, colonnes, accès et banques.
- `AGM2_projet_pmdo_0812.zip` : le projet PMDO. `AGM2_calques_png_8px.zip` : les calques en PNG.

Source : `source/arene_groudon_magma_v2/` et `source/magma_visqueux/`. On lance `build.py`, puis `package.py`, qui joue d'abord les tests.
