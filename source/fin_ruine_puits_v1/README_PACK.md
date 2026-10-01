# Fin Ruine — fosse de Sealed Ruin (FRP1), PMDO 0.8.12

Troisième zone de **fin de donjon** de la série des entrées. Elle fait suite à l'entrée Ruine (ERN1).

- Format 4:3 : 768 × 576 px, soit 96 × 72 cases de 8 px.
- Référence : `Sealed_Ruin_pit_TDS.png`, la vraie fin de Sealed Ruin dans le jeu. Le décor, le sol et la pierre sont des rendus générés avec cette capture en référence. **Ce ne sont pas des tuiles natives.**
- Layout :
  - arrivée au sud, entre deux rochers plats (marqueur `entrance`) ;
  - arène de grands blocs gris (marqueur `boss`) ;
  - au nord, dans la niche, la Clé de voûte étrange (marqueur `cle_de_voute`, devant la pierre). Dans le jeu, c'est elle qui se révèle être Spiritomb.
  - Aucune sortie, aucun warp.

## Calques (du bas vers le haut)

| # | Calque | Animation |
|---|---|---|
| 00 | sol_complet | fixe |
| 01 | ombre_parois | fixe |
| 02 | aura | 6 × 10 ticks : voile violet au sol autour de la pierre |
| 03 | tourbillons | 8 × 5 ticks, tourbillons de poussière de l'entrée Ruine, recolorés en gris |
| 04 | parois | fixe |
| 05 | cle_de_voute | fixe |
| 06 | fissure | 6 × 10 ticks : la fissure de la pierre pulse en violet |
| 07 | feux_follets | 24 × 5 ticks : trois feux follets montent de la pierre, à tour de rôle |
| 08 | Top (vide) | à vous |

La boucle complète de la scène dure 120 ticks (2 s).

## Installation

Lancez `python INSTALLER.py <dossier PMDO>`. Le script fusionne l'index des tuiles au lieu de l'écraser.

**Non testé dans PMDO.** Le manifeste indique `runtime_tested: false` et `art_approved: false`.
