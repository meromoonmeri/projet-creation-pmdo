# Route Zone Zéro 3 — fond cristallin (RAZ3), PMDO 0.8.12

Troisième et dernière route du **réseau de routes de la Zone Zéro**. On descend dans le cratère, façon Pokémon Écarlate et Violet, jusqu'à l'entrée du donjon Zone Zéro (Pokémon Paradoxe) :

1. **RAZ1**, la lèvre du cratère ;
2. **RAZ2**, les terrasses aux cascades ;
3. **RAZ3**, le fond cristallin (cette map) ;
4. **EAZ1**, l'entrée, une grotte de cristal.

Format 4:3 : 768 × 576 px, soit 96 × 72 cases de 8 px.

- **Références composées**, toutes vérifiées au pixel près par `source/outil_maps_pmdsky` :
  - `D17P34A`, le lac de cristal de PMD Explorers of Sky : sol hexagonal lumineux, cristaux et eau. C'est la matière principale et la loi de l'eau.
  - `P03P01A`, les cascades de la jungle, comme pour RAZ1 et RAZ2 : la loi et la palette des chutes.
  - `D17P11A`, l'entrée de la grotte de cristal : comparaison de la roche, et référence réservée pour EAZ1.
- **Décor** : un rendu généré à partir des deux découpes de style (×2) de D17P34A et P03P01A, avec le lac en magenta. **Ce ne sont pas des tuiles natives.** La roche du cratère est un bleu sombre incrusté de cristaux.
- **Dalles** : la rangée de dalles hexagonales plates entre la place et le chemin nord est aussi claire que les cristaux. Elle est donc comptée comme sol par un rectangle mesuré sur le brut ; sans lui, le chemin nord serait coupé de la place.
- **Sol complet** : une plage de sol hexagonal du brut, recopiée en miroir.
- **Fidélité** (seuil 35) :

  | Matière | Référence | Distance |
  |---|---|---|
  | Sol hexagonal | D17P34A | 10,9 |
  | Sol complet | D17P34A | 9,5 |
  | Cristaux (pixels clairs) | D17P34A | 31,6 |
  | Roche du cratère | D17P11A | 62,2, signalée et non seuillée |

  D17P34A n'a pas de matière équivalente à la roche. Celle de D17P11A est plus grise (≈ 39, 58, 71) que notre bleu (≈ 33, 82, 127).
- **Layout** :
  - le lac remplit le cratère ;
  - arrivée au sud (`entrance`), sur un chemin de sol hexagonal bordé de piliers de cristal ;
  - le chemin s'ouvre sur une grande place de cristal (`place`), puis se resserre par une rangée de dalles jusqu'au tunnel sombre de la paroi nord (`sortie`, vers EAZ1) ;
  - deux cascades tombent de la paroi dans le lac, et des îlots de cristal émergent de l'eau.
  - Aucune sortie latérale, aucun warp.

## Calques (du bas vers le haut)

| # | Calque | Animation |
|---|---|---|
| 00 | eau | 4 × 10 ticks, loi de D17P34A : un réseau de reflets qui ondule sur place, cycle 0-1-2-3 sans aller-retour ni défilement, avec les 12 tons exacts de l'eau native. Les cellules de Worley arrondies (52 × 24 px) sont calculées dans un domaine déformé par des sinus fixes, et chaque centre fait un tour de son petit cercle en 4 phases |
| 01 | rides | 3 × 10 ticks : des anneaux s'éloignent du pied des chutes |
| 02 | sol_complet | fixe |
| 03 | sol | fixe, seule zone praticable, dalles comprises |
| 04 | parois | fixe, roche et tunnel |
| 05 | cristaux | fixe |
| 06 | cascades | 3 × 10 ticks, loi de P03P01A : un motif de 96 px qui descend de 32 px par image |
| 07 | ecume | 3 × 10 ticks : 51 bouillons au pied des deux chutes |
| 08 | scintillements | 12 × 5 ticks : 90 éclats sur les cristaux, aux 4 teintes téra du réseau |
| 09 | Top (vide) | à vous |

La scène boucle en 240 ticks (4 s). Les lois de la cascade, de l'écume, des rides et des teintes sont dans `source/zone_zero_v1/commun.py`. Celle de l'eau est dans `build.py`.

## Installation

Lancez `python INSTALLER.py <dossier PMDO>`. Le script fusionne l'index des tuiles au lieu de l'écraser.

**Non testé dans PMDO.** Le manifeste indique `runtime_tested: false` et `art_approved: false`. Les raccords RAZ2 → RAZ3 → EAZ1 restent à scripter.

## Fichiers

- `calques/` et `animation/eau`, `animation/rides`, `animation/cascades`, `animation/ecume`, `animation/scintillements` : les calques et les images des animations (`fNN`).
- `masques/` : lac, cascades, écume, sol, tunnel, cristaux, parois, eau.
- `review/` : scène t000, scène animée en WebP, collisions et marqueurs, zoom de l'eau sur 4 phases.
- `RAZ3_route_zone_zero_calques.ora` : les calques dans un seul fichier.
- `manifest.json` : empreintes des bruts et des références, fidélité, lois, accès et banques.
- `RAZ3_projet_pmdo_0812.zip` : le projet PMDO. `RAZ3_calques_png_8px.zip` : les calques en PNG, avec les trois références.

Source : `source/zone_zero_v1/raz3/`. On lance `build.py`, puis `package.py`, qui joue d'abord les tests.
