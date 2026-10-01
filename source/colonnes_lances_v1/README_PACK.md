# Colonnes Lances, ruines (CLR1), PMDO 0.8.12

Un sommet en ruine à la façon des **Colonnes Lances**, qui flotte dans une mer de nuages. Map 4:3 générée avec les textures de PMD Explorers of Sky.

- Format 4:3 : 768 × 576 px, soit 96 × 72 cases de 8 px.
- **Références**, rendues depuis la ROM par `source/outil_maps_pmdsky` (`rom --only D28,D29,D30`) :
  - `D30P42A` : sommet intact, avec dallage de briques, colonnes cannelées, autel à vitrail vert, rochers en lévitation et mer de nuages dorée ;
  - `D28P33A` : grand escalier à balustres.
  - Les noms de lieu ne sont pas affirmés : le préfixe `dNN` n'est pas le `DUNGEON_ID`, seuls les codes comptent. La variante rouge et fendue `D30P34A` sert déjà à RZD1.
- **Bruts générés** :
  - `bruts/decor_magenta.png` : le décor, rendu à partir d'une découpe ×2 de chaque référence. Le ciel est peint en magenta pur. Premier rendu gardé sans édition.
  - `bruts/nuages_magenta.png` : 4 bandes de nuages festonnés sur magenta, rendues à partir d'une découpe ×3 des nuages de D30P42A.
  - **Ce ne sont pas des tuiles natives.** Seuls viennent de la ROM le ton du ciel (183, 167, 87) et la loi de palette du vitrail avec ses 22 tons.
- **Fidélité** (seuil 35) : briques 8,1, piliers 7,2, escalier 7,0, nuages 8,8.
- **Layout** :
  - arrivée au sud par le grand escalier à balustres (marqueur `entrance`) ; seul l'escalier central est praticable ;
  - grande esplanade de briques entourée d'un cercle de **huit colonnes**, debout ou brisées, avec **trois colonnes couchées** (marqueur `centre` au milieu du cercle) ;
  - au nord, l'**autel à vitrail** sur une terrasse haute (marqueur `autel` devant ses marches) ;
  - tout autour, la mer de nuages et 8 rochers en lévitation. Aucune sortie, aucun warp.
- Obstacles : les colonnes (fût et socle), les colonnes couchées (capsules) et le bloc de l'autel sont mesurés à la main sur le brut, car ils ont les tons des briques. La terrasse haute, les balustres, les bords rocheux et le ciel bloquent aussi.

## Calques (du bas vers le haut)

| # | Calque | Animation |
|---|---|---|
| 00 | ciel | fixe, ton uni de la ROM, couvre toute la carte |
| 01 | nuages | 120 × 10 ticks. Chaque bande est rendue périodique (480 px) et dérive vers l'ouest de 4 px par pas, soit une période par boucle. Cinq rangées. Les nuages ne sont dessinés que dans les cases où le ciel se voit |
| 02 | sol | fixe, seule zone praticable |
| 03 | ruines | fixe : colonnes, autel, terrasse haute, balustres, bords, corbeaux |
| 04 | rochers | 30 × 20 ticks, 8 rochers qui montent et descendent de 1 ou 2 px |
| 05 | vitrail | 12 × 10 ticks, loi de palette de D30P42A : 2 rampes de 12 tons (vert → cyan → vert), tons ROM. Les verts du rendu sont classés par rang de luminance : le tiers sombre reste fixe, le tiers moyen suit la rampe a, le tiers clair la rampe b |
| 06 | eclats | 60 × 10 ticks : 18 éclats de lumière aux tons du vitrail montent de l'autel et s'éteignent |
| 07 | Top (vide) | à vous |

La scène boucle en 1200 ticks (20 s).

## Installation

Lancez `python INSTALLER.py <dossier PMDO>`. Le script fusionne l'index des tuiles au lieu de l'écraser.

**Non testé dans PMDO.** Le manifeste indique `runtime_tested: false` et `art_approved: false`.

## Fichiers

- `calques/` : calques fixes (`CLR1_NN_nom.png`).
- `animation/nuages` (`fNNN`), `animation/rochers`, `animation/vitrail`, `animation/eclats` (`fNN`) : images des animations.
- `masques/` : sol, ruines, rochers, vide, vitrail, ciel visible, colonnes, colonnes couchées, autel, escalier.
- `review/` : scène t000, scène animée en WebP, collisions et marqueurs, zoom sur l'autel.
- `CLR1_colonnes_lances_calques.ora` : les calques dans un seul fichier.
- `manifest.json` : empreintes des bruts et des références, fidélité, segmentation, obstacles mesurés, lois animées, accès et banques.
- `CLR1_projet_pmdo_0812.zip` : le projet PMDO. `CLR1_calques_png_8px.zip` : les calques en PNG.

Source : `source/colonnes_lances_v1/`. On lance `build.py`, puis `package.py`, qui joue d'abord les tests.
