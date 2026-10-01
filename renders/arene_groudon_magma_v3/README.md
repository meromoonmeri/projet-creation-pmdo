# Arène de Groudon V3 — colonnes de magma générées (AGM3), PMDO 0.8.12

Troisième version de l'arène de boss sur le lac de magma. **Un seul changement** par rapport à AGM2 (AGM1 et AGM2 sont conservées) : les quatre colonnes de magma ne sont plus calculées, **leurs pixels viennent du générateur d'images**.

Tout le reste est repris d'AGM2 sans changement : le décor, le sol, le magma visqueux, le Ω de Primo-Groudon qui pulse directement sur le sol et les braises.

- Format 4:3 : 768 × 576 px, soit 96 × 72 cases de 8 px.
- Référence des colonnes : une découpe de la lave de `Dark_Crater_Pit_TDS.png` agrandie ×2 (`reference/Dark_Crater_Pit_lave_decoupe_x2.png`), passée en image au générateur.
  - Brut retenu : `bruts/colonne_magenta.png`, 848 × 1264 sur fond magenta. On y voit une colonne organique aux flancs bombés, un cœur blanc-jaune, de la croûte, une gerbe d'éclaboussures et des gouttes.
  - Brut rejeté, gardé en trace : `bruts/colonne_v0_fond_lave.png`. La colonne était rectiligne et peinte sur un fond de lave au lieu du magenta.
  - **Ce ne sont pas des tuiles natives** : ce sont des pixels générés, découpés, réduits et animés. La palette des colonnes compte 32 tons, tous tirés du brut.
- Quatre colonnes, deux de chaque côté. Celles de droite sont en miroir.
  - Au fond, le corps fait environ 58 px de large et la bouche est à y ≈ 204.
  - Devant, le corps fait environ 88 px de large et la bouche est à y ≈ 433.
  - Chaque colonne touche le bord haut à toutes les phases : **on n'en voit jamais le sommet**.
- Layout identique à AGM2 : arrivée au sud (`entrance`), `boss` au centre du Ω, `heros` juste au sud de l'anneau. Aucune sortie, aucun warp.

## Animation des colonnes (calque 07, 48 × 5 ticks)

- **Corps.** Une bande du brut rendue périodique : on fond 20 % de sa longueur, puis on re-quantifie et on remet le contour de 1 px. Période de 149 px au fond et de 223 px devant.
  - La bande monte d'une période par boucle, avec deux poussées : décalage(u) = P (u − 0,6 sin 4πu / 4π). La fonction est croissante, donc le magma ne recule jamais.
- **Gerbe.** La couronne d'éclaboussures du brut est ancrée sur la bouche. Ses tons clairs bouillonnent par décalage de rang de luminance.
  - Sous la bouche, le brut est coupé net ; on n'en garde qu'une ellipse à bord ondulé, qui se fond dans le lac.
- **Gouttes.** 23 gouttes par colonne, découpées dans le brut, font deux vols paraboliques par boucle.
- **Placement.** La gerbe et les gouttes ne se dessinent que sur le lac visible, jamais sur la roche. Les quatre colonnes sont décalées dans le temps, et celles de devant recouvrent celles du fond.

## Calques (du bas vers le haut)

| # | Calque | Animation |
|---|---|---|
| 00 | magma | 32 × 15 ticks, magma visqueux (AGM2) |
| 01 | sol_complet | fixe |
| 02 | sol_arene | fixe, seule zone praticable, signe compris |
| 03 | rebord | fixe |
| 04 | pitons | fixe |
| 05 | symbole_groudon | 12 × 10 ticks, le Ω pulse du rouge au jaune vif, halo sur la pierre |
| 06 | braises | 6 × 10 ticks |
| 07 | colonnes | 48 × 5 ticks, colonnes générées (voir plus haut) |
| 08 | Top (vide) | à vous |

La scène boucle en 480 ticks (8 s).

## Installation

Lancez `python INSTALLER.py <dossier PMDO>`. Le script fusionne l'index des tuiles au lieu de l'écraser.

**Non testé dans PMDO.** Le manifeste indique `runtime_tested: false` et `art_approved: false`.

## Fichiers

- `calques/` : calques fixes (`AGM3_NN_nom.png`).
- `animation/magma`, `animation/symbole_groudon`, `animation/braises`, `animation/colonnes` : images des animations, `fNN`.
- `masques/` : lave, sol, rebord, pitons, symbole.
- `review/` : scène t000, scène animée en WebP, collisions et marqueurs, pulsation du symbole.
- `AGM3_arene_groudon_magma_calques.ora` : les calques dans un seul fichier.
- `manifest.json` : empreintes des bruts (décor AGM2 et colonnes), fidélité, chronologies, loi des colonnes et palette, accès et banques.
- `AGM3_projet_pmdo_0812.zip` : le projet PMDO. `AGM3_calques_png_8px.zip` : les calques en PNG.

Source : `source/arene_groudon_magma_v3/` (colonnes : `colonnes_generees.py`), `source/arene_groudon_magma_v2/` et `source/magma_visqueux/`. On lance `build.py`, puis `package.py`, qui joue d'abord les tests.
