# Route Zone Zéro 1 — lèvre du cratère (RAZ1), PMDO 0.8.12

Première map du **réseau de routes de la Zone Zéro**. On descend dans le cratère, façon Pokémon Écarlate et Violet, jusqu'à l'entrée du donjon Zone Zéro (Pokémon Paradoxe). Le réseau prévu est le suivant :

1. **RAZ1**, la lèvre du cratère (cette map) ;
2. **RAZ2**, les terrasses aux cascades ;
3. **RAZ3**, le fond cristallin ;
4. **EAZ1**, l'entrée, une grotte de cristal.

Format 4:3 : 768 × 576 px, soit 96 × 72 cases de 8 px.

- **Référence** : `P03P01A`, la zone des cascades de la jungle dans PMD Explorers of Sky. La capture `junglewaterfallzonepmdsky.png` a été identifiée au pixel près par `source/outil_maps_pmdsky`. Elle donne les falaises ocre, les cascades, les bassins, l'écume et la prairie.
- **Décor** : un rendu généré à partir d'une découpe de style de la référence (×2), avec l'abîme en magenta. **Ce ne sont pas des tuiles natives.**
  - Le premier rendu laissait la pelouse toucher le bord gauche, ce qui faisait une sortie latérale. Il a été corrigé par une édition à un seul changement : une bande de buissons. L'écart hors de la zone éditée est de 12,3 (somme RVB moyenne), avec 0,75 % de pixels à plus de 60.
- **Sol complet** : une plage de prairie du brut, recopiée en miroir. Les deux sols générés ont été écartés : le premier était trop saturé, puis le générateur n'a plus rien renvoyé.
- **Fidélité** (seuil 35) :

  | Matière | Distance |
  |---|---|
  | Prairie | 5,2 |
  | Sol complet | 4,6 |
  | Falaises | 11,3 |

  Le chemin d'herbe rase claire est un ton absent de P03P01A : il est gardé comme matière à part et n'est pas soumis au seuil.
- **Layout** :
  - arrivée au sud (`entrance`) ;
  - prairie avec buissons ;
  - chemin qui monte vers la corniche ;
  - au nord, deux pans d'abîme séparés par la corniche, qui mène au bord haut (`sortie`, vers RAZ2) ;
  - `belvedere` au bord du vide ;
  - à gauche et à droite, des falaises et six cascades qui tombent dans des bassins.
  - Aucune sortie latérale, aucun warp.

## Calques (du bas vers le haut)

| # | Calque | Animation |
|---|---|---|
| 00 | abime | 24 × 10 ticks : vide du cratère, profondeur, brume qui ondule, 36 éclats de cristal lointains qui scintillent |
| 01 | sol_complet | fixe |
| 02 | eau | 3 × 10 ticks : des rides s'éloignent de l'écume |
| 03 | sol | fixe, seule zone praticable |
| 04 | falaises | fixe |
| 05 | buissons | fixe |
| 06 | cascades | 3 × 10 ticks. Loi relevée sur P03P01A dans la ROM : un motif de 96 px qui descend de 32 px par image. Motif recalculé avec les 14 tons de la cascade native |
| 07 | ecume | 3 × 10 ticks : les bouillons gonflent, glissent et changent de forme |
| 08 | Top (vide) | à vous |

La scène boucle en 240 ticks (4 s). Les lois sont dans `source/zone_zero_v1/commun.py`, partagé par tout le réseau.

## Installation

Lancez `python INSTALLER.py <dossier PMDO>`. Le script fusionne l'index des tuiles au lieu de l'écraser.

**Non testé dans PMDO.** Le manifeste indique `runtime_tested: false` et `art_approved: false`. Le raccord avec RAZ2 reste à scripter.

## Fichiers

- `calques/`, `animation/abime`, `animation/eau`, `animation/cascades`, `animation/ecume` : les calques et les images des animations (`fNN`).
- `masques/` : abîme, cascades, écume, eau, sol, buissons, falaises.
- `review/` : scène t000, scène animée en WebP, collisions et marqueurs, zoom d'une cascade sur ses 3 phases.
- `RAZ1_route_zone_zero_calques.ora` : les calques dans un seul fichier.
- `manifest.json` : empreintes des bruts et de la référence, édition, fidélité, lois, accès et banques.
- `RAZ1_projet_pmdo_0812.zip` : le projet PMDO. `RAZ1_calques_png_8px.zip` : les calques en PNG.

Source : `source/zone_zero_v1/raz1/`. On lance `build.py`, puis `package.py`, qui joue d'abord les tests.
