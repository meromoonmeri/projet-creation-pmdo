# Fin Givre — Frosty Grotto (FGG1), PMDO 0.8.12

Quatrième zone de **fin de donjon** de la série des entrées. Elle fait suite à l'entrée Givre (EGN1), dont la grotte s'ouvre au nord.

- Format 4:3 : 768 × 576 px, soit 96 × 72 cases de 8 px.
- Références :
  - la vraie fin, la salle où Articuno attend les héros (étage 5 de Frosty Grotto), n'existe ici qu'en vignette de 120 px (`reference/`). Elle donne la palette : sol de glace bleu pâle ;
  - textures : `pmdskyicearena.png`, l'arène de glace de PMD Sky.
  - Le décor est un rendu généré avec ces références. **Ce ne sont pas des tuiles natives**, sauf les reflets : ce sont des pixels de `Metano_Town_River_Sparkles`, recolorés en blanc bleuté.
- Layout :
  - arrivée au sud, par le couloir de glace (marqueur `entrance`) ;
  - grande arène de glace, avec un bassin d'eau glacée de chaque côté (marqueur `boss`) ;
  - au nord, un grand cristal de glace sur un monticule de neige (marqueur `cristal`, devant le monticule).
  - Aucune sortie, aucun warp.

## Calques (du bas vers le haut)

| # | Calque | Animation |
|---|---|---|
| 00 | eau_glacee | 4 × 10 ticks, eau glacée de l'entrée Givre (structure de la rivière de Métano) |
| 01 | reflets | 4 × 10 ticks, scintillements de Métano recolorés |
| 02 | sol_complet | fixe |
| 03 | sol_glace | fixe |
| 04 | parois | fixe |
| 05 | cristal | fixe |
| 06 | lueur_cristal | 6 × 10 ticks : les facettes du cristal pulsent |
| 07 | flocons | 48 × 5 ticks, flocons générés de l'entrée Givre |
| 08 | Top (vide) | à vous |

La boucle complète de la scène dure 240 ticks (4 s).

## Installation

Lancez `python INSTALLER.py <dossier PMDO>`. Le script fusionne l'index des tuiles au lieu de l'écraser.

**Non testé dans PMDO.** Le manifeste indique `runtime_tested: false` et `art_approved: false`.
