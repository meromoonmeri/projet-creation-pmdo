# Route Zone Zéro 2 — terrasses aux cascades (RAZ2), PMDO 0.8.12

Deuxième map du **réseau de routes de la Zone Zéro**. On descend dans le cratère, façon Pokémon Écarlate et Violet, jusqu'à l'entrée du donjon Zone Zéro (Pokémon Paradoxe) :

1. **RAZ1**, la lèvre du cratère ;
2. **RAZ2**, les terrasses aux cascades (cette map) ;
3. **RAZ3**, le fond cristallin ;
4. **EAZ1**, l'entrée, une grotte de cristal.

Format 4:3 : 768 × 576 px, soit 96 × 72 cases de 8 px.

- **Référence** : `P03P01A`, la zone des cascades de la jungle dans PMD Explorers of Sky, vérifiée au pixel près par `source/outil_maps_pmdsky`. C'est la même référence que RAZ1.
- **Décor** : un rendu généré à partir de la découpe de style (×2), avec l'abîme en magenta. **Ce ne sont pas des tuiles natives.**
  - Le premier rendu laissait la prairie toucher le bord gauche à deux endroits. Il a été corrigé par une édition à un seul changement : une bande continue de buissons. L'écart hors zone est de 10,7 (somme RVB moyenne), avec 0,4 % de pixels à plus de 60.
- **Escaliers** : la pierre ocre a la couleur des falaises. L'escalier du milieu et les marches de sortie sont donc comptés comme sol, par des rectangles mesurés sur le brut, et reçoivent leur propre palette de 16 couleurs (la palette commune les verdissait).
- **Sol complet** : une plage de prairie du brut, recopiée en miroir.
- **Fidélité** (seuil 35) :

  | Matière | Distance |
  |---|---|
  | Prairie | 4,5 |
  | Sol complet | 6,2 |
  | Falaises | 6,0 |

  Le chemin d'herbe claire n'est pas soumis au seuil, comme dans RAZ1.
- **Layout** :
  - arrivée au sud (`entrance`), sur la terrasse basse ;
  - l'escalier taillé dans la falaise du milieu est le seul passage vers la terrasse haute ;
  - une corniche longe l'abîme, à l'est, jusqu'aux marches du bord haut (`sortie`, vers RAZ3) ;
  - `belvedere` au bord du vide, sur la terrasse basse ;
  - trois cascades tombent du bord haut dans les bassins de la terrasse haute, deux chutes passent par-dessus la falaise du milieu, et une bande de buissons longe le bord gauche.
  - Aucune sortie latérale, aucun warp.

## Calques (du bas vers le haut)

| # | Calque | Animation |
|---|---|---|
| 00 | abime | 24 × 10 ticks : vide du cratère, brume qui ondule, 36 éclats de cristal lointains |
| 01 | sol_complet | fixe |
| 02 | eau | 3 × 10 ticks : des rides s'éloignent de l'écume |
| 03 | sol | fixe, seule zone praticable, escaliers compris |
| 04 | falaises | fixe |
| 05 | buissons | fixe |
| 06 | cascades | 3 × 10 ticks, loi de P03P01A : motif de 96 px qui descend de 32 px par image. Trois chutes partent du bord haut, deux du haut de la falaise du milieu (`y0`) |
| 07 | ecume | 3 × 10 ticks : 247 bouillons qui gonflent, glissent et changent de forme |
| 08 | Top (vide) | à vous |

La scène boucle en 240 ticks (4 s). Les lois sont dans `source/zone_zero_v1/commun.py`.

## Installation

Lancez `python INSTALLER.py <dossier PMDO>`. Le script fusionne l'index des tuiles au lieu de l'écraser.

**Non testé dans PMDO.** Le manifeste indique `runtime_tested: false` et `art_approved: false`. Les raccords RAZ1 → RAZ2 → RAZ3 restent à scripter.

## Fichiers

- `calques/`, `animation/abime`, `animation/eau`, `animation/cascades`, `animation/ecume` : les calques et les images des animations (`fNN`).
- `masques/` : abîme, cascades, écume, eau, sol, buissons, falaises, escaliers.
- `review/` : scène t000, scène animée en WebP, collisions et marqueurs, zoom d'une cascade.
- `RAZ2_route_zone_zero_calques.ora` : les calques dans un seul fichier.
- `manifest.json` : empreintes des bruts et de la référence, édition, fidélité, lois, accès et banques.
- `RAZ2_projet_pmdo_0812.zip` : le projet PMDO. `RAZ2_calques_png_8px.zip` : les calques en PNG.

Source : `source/zone_zero_v1/raz2/`. On lance `build.py`, puis `package.py`, qui joue d'abord les tests.
