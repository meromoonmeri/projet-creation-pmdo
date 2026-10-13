# Entrée Colonnes Lances, sentier de la montagne, sud → nord (ECL1), PMDO 0.8.12

Le sentier de pèlerins qui monte vers le sommet de **CLR2**. Entrée de donjon de la série sud → nord, 4:3 : 768 × 576 px, soit 96 × 72 cases de 8 px. Map générée avec les textures de PMD Explorers of Sky.

- **Références** : `D30P42A` (briques, colonnes cannelées, vitrail vert, nuages dorés) et `D28P33A` (escalier), relues dans `source/colonnes_lances_v1/reference/`. Style de texture seulement. Le décor de CLR2 sert aussi de référence de style au générateur. **Aucune référence de montagne** : roche et neige sont une création du générateur, non mesurées contre le rip. Les noms de lieu ne sont pas affirmés.
- **Bruts générés** : `bruts/decor_magenta.png` (décor, ciel en magenta pur, premier rendu gardé sans édition). Nuages : la bande de CLR1, relue par chemin. **Ce ne sont pas des tuiles natives.** Seuls viennent de la ROM le ton du ciel (183, 167, 87) et la loi de palette du vitrail (22 tons).
- **Fidélité** (seuil 35) : briques 26,2, piliers 25,0, nuages 7,3. **Escalier 35,0, hors seuil** : l'escalier rose-beige du décor n'est pas la matière de l'escalier gris à balustres de D28P33A ; la mesure est donnée à titre d'information.
- **Layout** : arrivée au sud par un escalier de pierre (`entrance`) ; sentier de briques en trois lacets, deux escaliers diagonaux aux virages, colonnes brisées ou couchées en bordure ; au nord, un portique de deux colonnes à emblème vert, et l'escalier qui monte vers le ciel (`donjon_seuil` à son pied). Aucun warp.
- **Obstacles et sol** : la roche a le ton des briques. Le sol est donc limité à trois zones mesurées du sentier, quatre escaliers et deux goulots mesurés à la main ; les colonnes (fût et socle) et les colonnes couchées (capsules) sont mesurées à la main. Les deux goulots (environ 15 px entre un éboulis et une colonne couchée, moins que les 16 px du personnage) sont élargis de quelques pixels sur l'éboulis : sans cela, le sentier serait coupé.

## Calques (du bas vers le haut)

| # | Calque | Animation |
|---|---|---|
| 00 | ciel | fixe, ton uni de la ROM |
| 01 | nuages | 120 × 10 ticks, bandes périodiques de 480 px qui dérivent vers l'ouest, dessinées là où le ciel se voit |
| 02 | sol | fixe, seule zone praticable |
| 03 | montagne | fixe : pentes, neige, colonnes, portique, rebords |
| 04 | rochers | 30 × 20 ticks, 9 rochers qui montent et descendent de 1 ou 2 px |
| 05 | vitrail | 12 × 10 ticks, loi de palette de D30P42A (2 rampes de 12 tons) sur l'emblème vert du portique (38 + 38 px) |
| 06 | eclats | 60 × 10 ticks : 18 éclats de lumière qui montent de l'emblème |
| 07 | Top (vide) | à vous |

La scène boucle en 1200 ticks (20 s).

## Installation

Lancez `python INSTALLER.py <dossier PMDO>`. Le script fusionne l'index des tuiles au lieu de l'écraser. **Non testé dans PMDO** : `runtime_tested: false`, `art_approved: false`.

## Fichiers

- `calques/`, `animation/` (`nuages` en `fNNN`, les autres en `fNN`), `masques/` (sol, montagne, rochers, vide, vitrail, ciel visible, colonnes, colonnes couchées, portique, escaliers).
- `review/` : scène t000, scène animée en WebP, collisions et marqueurs, zoom sur le portique.
- `ECL1_colonnes_lances_calques.ora`, `manifest.json`, `ECL1_projet_pmdo_0812.zip`, `ECL1_calques_png_8px.zip`.

Source : `source/entree_colonnes_lances_sud_nord_v1/`. On lance `build.py`, puis `package.py`, qui joue d'abord les tests.
