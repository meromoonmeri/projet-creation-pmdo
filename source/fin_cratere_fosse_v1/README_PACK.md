# Fin Cratère — fosse de Dark Crater (FCF1), PMDO 0.8.12

Deuxième zone de **fin de donjon** de la série des entrées. Elle fait suite à l'entrée Cratère (ECN1).

- Format 4:3 : 768 × 576 px, soit 96 × 72 cases de 8 px.
- Référence : `Dark_Crater_Pit_TDS.png`, la vraie fin de Dark Crater dans le jeu. Le décor est un rendu généré avec cette capture en référence. **Ce ne sont pas des tuiles natives**, sauf les éclats : ce sont des pixels de `Metano_Town_River_Sparkles`, recolorés en tons de lave.
- Layout :
  - arrivée au sud, par la pointe du plateau (marqueur `entrance`) ;
  - grand plateau de pierre au milieu de la lave (marqueur `boss`) ;
  - au nord, l'emblème de feu sur le rebord (marqueur `embleme`).
  - Aucune sortie, aucun warp.

## Calques (du bas vers le haut)

| # | Calque | Animation |
|---|---|---|
| 00 | lave | 4 × 10 ticks, lave de l'entrée Cratère (structure de la rivière de Métano) |
| 01 | eclats | 4 × 10 ticks, éclats de Métano recolorés |
| 02 | bulles | 24 × 5 ticks, bulles de lave de l'entrée Cratère |
| 03 | sol_complet | fixe |
| 04 | sol_plateau | fixe |
| 05 | rebord | fixe |
| 06 | pitons | fixe |
| 07 | embleme | fixe |
| 08 | lueur | 6 × 10 ticks : l'emblème et les braises du rebord pulsent |
| 09 | Top (vide) | à vous |

La boucle complète de la scène dure 120 ticks (2 s).

## Installation

Lancez `python INSTALLER.py <dossier PMDO>`. Le script fusionne l'index des tuiles au lieu de l'écraser.

**Non testé dans PMDO.** Le manifeste indique `runtime_tested: false` et `art_approved: false`.
