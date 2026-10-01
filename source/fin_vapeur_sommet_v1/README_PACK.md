# Fin Vapeur — sommet de Steam Cave (FVS1), PMDO 0.8.12

Première zone de **fin de donjon** de la série des entrées. Elle fait suite aux entrées Vapeur (ESN1, ESN2).

- Format 4:3 : 768 × 576 px, soit 96 × 72 cases de 8 px.
- Référence : `Steam_Cave_Peak_TDS.png`, la vraie fin de Steam Cave dans le jeu. Le décor est un rendu généré avec cette capture en référence. **Ce ne sont pas des tuiles natives.**
- Layout :
  - arrivée au sud, par le couloir qui sort du donjon (marqueur `entrance`) ;
  - grande arène entourée de stalagmites (marqueur `boss`) ;
  - au nord, une source chaude qui bouillonne (marqueur `source`).
  - Aucune sortie, aucun warp.

## Calques (du bas vers le haut)

| # | Calque | Animation |
|---|---|---|
| 00 | eau_source | 4 × 10 ticks, eau de l'entrée Vapeur V2 (structure de la rivière de Métano) |
| 01 | bulles | 24 × 5 ticks, bulles de l'entrée Vapeur V2 |
| 02 | sol_complet | fixe |
| 03 | sol_arene | fixe |
| 04 | margelle | fixe |
| 05 | events | fixe |
| 06 | stalagmites | fixe |
| 07 | vapeur | 24 × 5 ticks : panaches des 3 évents et volutes de la source, poses générées |
| 08 | Top (vide) | à vous |

La boucle complète de la scène dure 120 ticks (2 s).

## Installation

Lancez `python INSTALLER.py <dossier PMDO>`. Le script fusionne l'index des tuiles au lieu de l'écraser.

**Non testé dans PMDO.** Le manifeste indique `runtime_tested: false` et `art_approved: false`.
