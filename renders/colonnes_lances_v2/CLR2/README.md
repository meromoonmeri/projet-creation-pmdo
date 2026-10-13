# Colonnes Lances, sommet de la montagne (CLR2), PMDO 0.8.12

La terrasse des colonnes, à la façon des **Colonnes Lances**, au sommet d'une vraie montagne de roche brune. Map 4:3 générée avec les textures de PMD Explorers of Sky. **CLR2 (ruines flottantes dans les nuages) est conservée** : CLR2 est une carte à part.

- Format 4:3 : 768 × 576 px, soit 96 × 72 cases de 8 px.
- **Références** (les mêmes que CLR2, relues dans `source/colonnes_lances_v1/reference/`) : `D30P42A` (briques, colonnes cannelées, autel à vitrail vert, nuages dorés) et `D28P33A` (escalier). Style de texture seulement. **Aucune référence de montagne** : la roche et la neige sont une création du générateur, non mesurées contre le rip. Les noms de lieu ne sont pas affirmés.
- **Bruts générés** :
  - `bruts/decor_magenta.png` : le décor, rendu à partir d'une découpe ×2 de D30P42A. Le ciel est peint en magenta pur. Second essai gardé sans édition ; le premier (`bruts/ecartes/`) recopiait la composition de CLR2 : écarté.
  - Nuages : la bande `nuages_magenta.png` de CLR2, relue par chemin (non copiée).
  - **Ce ne sont pas des tuiles natives.** Seuls viennent de la ROM le ton du ciel (183, 167, 87) et la loi de palette du vitrail avec ses 22 tons.
- **Fidélité** (seuil 35) : briques 9,8, piliers 10,3, nuages 8,0, **escalier 28,9** (l'escalier taillé dans la roche s'écarte de l'escalier à balustres de D28P33A : sous le seuil, mais loin de CLR2).
- **Layout** :
  - arrivée au sud par l'escalier taillé dans la roche (marqueur `entrance`) ; seuls cet escalier et la terrasse sont praticables ;
  - terrasse ovale de briques au sommet, avec **cinq colonnes** (trois brisées) et **deux colonnes couchées** (marqueur `centre`) ;
  - au nord, le **dais à vitrail** (marqueur `autel` devant ses marches) ;
  - tout autour, les pentes rocheuses et la neige ; en haut, le ciel doré, les nuages et 3 rochers en lévitation. Aucune sortie, aucun warp.
- Obstacles : les colonnes (fût et socle), les colonnes couchées (capsules) et le bloc du dais sont mesurés à la main sur le brut. **La roche de la montagne a le ton des briques** : le sol est limité à une superellipse mesurée sur la terrasse, plus l'escalier central. Les pentes et le ciel bloquent.

## Calques (du bas vers le haut)

| # | Calque | Animation |
|---|---|---|
| 00 | ciel | fixe, ton uni de la ROM, couvre toute la carte |
| 01 | nuages | 120 × 10 ticks. Chaque bande est rendue périodique (480 px) et dérive vers l'ouest de 4 px par pas, soit une période par boucle. Cinq rangées. Les nuages ne sont dessinés que dans les cases où le ciel se voit |
| 02 | sol | fixe, seule zone praticable |
| 03 | montagne | fixe : pentes rocheuses, neige, colonnes, dais, rebord de la terrasse |
| 04 | rochers | 30 × 20 ticks, 3 rochers qui montent et descendent de 1 ou 2 px |
| 05 | vitrail | 12 × 10 ticks, loi de palette de D30P42A : 2 rampes de 12 tons (vert → cyan → vert), tons ROM. Les verts du rendu sont classés par rang de luminance : le tiers sombre reste fixe, le tiers moyen suit la rampe a, le tiers clair la rampe b |
| 06 | eclats | 60 × 10 ticks : 18 éclats de lumière aux tons du vitrail montent du dais et s'éteignent |
| 07 | Top (vide) | à vous |

La scène boucle en 1200 ticks (20 s).

## Installation

Lancez `python INSTALLER.py <dossier PMDO>`. Le script fusionne l'index des tuiles au lieu de l'écraser.

**Non testé dans PMDO.** Le manifeste indique `runtime_tested: false` et `art_approved: false`.

## Fichiers

- `calques/` : calques fixes (`CLR2_NN_nom.png`).
- `animation/nuages` (`fNNN`), `animation/rochers`, `animation/vitrail`, `animation/eclats` (`fNN`) : images des animations.
- `masques/` : sol, montagne, rochers, vide, vitrail, ciel visible, colonnes, colonnes couchées, autel, escalier.
- `review/` : scène t000, scène animée en WebP, collisions et marqueurs, zoom sur le dais.
- `CLR2_colonnes_lances_calques.ora` : les calques dans un seul fichier.
- `manifest.json` : empreintes des bruts et des références, fidélité, segmentation, obstacles mesurés, lois animées, accès et banques.
- `CLR2_projet_pmdo_0812.zip` : le projet PMDO. `CLR2_calques_png_8px.zip` : les calques en PNG.

Source : `source/colonnes_lances_v2/`. On lance `build.py`, puis `package.py`, qui joue d'abord les tests.
