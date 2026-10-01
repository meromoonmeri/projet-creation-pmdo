# Entrée Zone Zéro — grotte de cristal (EAZ1), PMDO 0.8.12

Dernière map du **réseau de la Zone Zéro** : l'entrée du donjon Zone Zéro (Pokémon Paradoxe).

1. **RAZ1**, la lèvre du cratère ;
2. **RAZ2**, les terrasses aux cascades ;
3. **RAZ3**, le fond cristallin ;
4. **EAZ1**, l'entrée, une grotte de cristal (cette map).

Format 4:3 : 768 × 576 px, soit 96 × 72 cases de 8 px.

- **Référence** : `D17P11A`, l'entrée de la grotte de cristal dans PMD Explorers of Sky, rendue directement depuis la ROM par `source/outil_maps_pmdsky`.
- **Décor** : un rendu généré à partir d'une petite découpe de textures de la référence (×2). Le cristal géant a été laissé hors de la découpe pour ne pas recopier sa composition. Le layout est nouveau et asymétrique. **Ce ne sont pas des tuiles natives.**
  - Premier rendu (`decor_v0_couleurs_derivees.png`) : bon layout, mais couleurs trop claires et trop vertes.
  - Édition 1 (« recolorer à la palette de la référence ») : encore trop claire. Une 2e édition, plus sombre, était terne ; elle a été jetée.
  - `decor.png` : édition de l'édition 1 (« baisser d'environ 20 % en gardant les lueurs »). Corrélation des contours avec v0 : 0,905.
- **Fidélité** : la même règle d'extraction des matières est appliquée à D17P11A et à la scène rendue (seuil 35).

  | Matière | Distance |
  |---|---|
  | Sol | 8,1 |
  | Cristaux | 17,0 |
  | Parois | 17,1 |
  | Sol complet | 12,4 |

- **Layout** :
  - arrivée au sud par une brèche (`entrance`) ;
  - des pas japonais sinueux mènent à une **géode fendue** au nord-est, dont le cœur est le **tunnel du donjon** (`donjon`) ;
  - à l'ouest, une corniche hérissée de flèches de cristal (inaccessible) ;
  - à l'est, une plage lumineuse cerclée de rochers (`cercle`).
  - Aucune sortie latérale, aucun warp.

## Calques (du bas vers le haut)

| # | Calque | Animation |
|---|---|---|
| 00 | sol_complet | fixe |
| 01 | sol | fixe, seule zone praticable |
| 02 | parois | fixe |
| 03 | cristaux | 18 × 10 ticks. **Loi relevée dans la ROM sur D17P11A** : animation de palette des petits amas (le cristal géant est fixe). Chaque ton gagne 8 par canal et par niveau, plafonné à 231 ; niveaux 0 0 0 1 2 2 3 3 4 4 4 3 3 2 2 1 1 1 |
| 04 | geode | fixe |
| 05 | portail | 18 × 10 ticks : le tunnel du donjon respire avec la même loi, en phase |
| 06 | lucioles | 18 × 10 ticks : 26 lueurs aux teintes téra du réseau, qui montent de 2 px par pas depuis le tunnel et la plage |
| 07 | scintillements | 12 × 5 ticks : 40 éclats sur la géode et les cristaux |
| 08 | Top (vide) | à vous |

La scène boucle en 180 ticks (3 s).

## Installation

Lancez `python INSTALLER.py <dossier PMDO>`. Le script fusionne l'index des tuiles au lieu de l'écraser.

**Non testé dans PMDO.** Le manifeste indique `runtime_tested: false` et `art_approved: false`. Les raccords RAZ3 → EAZ1 → donjon restent à scripter.

## Fichiers

- `calques/` et `animation/cristaux`, `animation/portail`, `animation/lucioles`, `animation/scintillements` : les calques et les images des animations (`fNN`).
- `masques/` : les masques des matières.
- `review/` : scène t000, scène animée en WebP, collisions et marqueurs, zoom de la géode.
- `EAZ1_entree_zone_zero_calques.ora` : les calques dans un seul fichier.
- `manifest.json` : empreintes des bruts et de la référence, éditions, fidélité, lois, accès et banques.
- `EAZ1_projet_pmdo_0812.zip` : le projet PMDO. `EAZ1_calques_png_8px.zip` : les calques en PNG, avec la référence.

Source : `source/zone_zero_v1/eaz1/`. On lance `build.py`, puis `package.py`, qui joue d'abord les tests.
