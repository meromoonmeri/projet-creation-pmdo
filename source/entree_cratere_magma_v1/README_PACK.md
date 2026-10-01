# Entrée Cratère magma — Dark Crater V2 (ECM1), PMDO 0.8.12

Nouvelle version de l'entrée de Dark Crater, avec **cascades de lave**, **colonnes de magma** et **magma visqueux**. L'entrée Cratère V1 (ECN1) reste intacte.

- Format 4:3 : 768 × 576 px, soit 96 × 72 cases de 8 px.
- Références :
  - `Dark_Crater_entrance_TDS.png` (entrée de Dark Crater, PMD Sky) : textures, palette et style du décor ;
  - `Dark_Crater_Pit_TDS.png` (fosse de Dark Crater) : la rampe de 11 tons du magma, relevée sur sa lave.
- Le décor est un rendu généré avec la première référence. **Ce ne sont pas des tuiles natives.**
  - Le magma, les cascades et les colonnes sont calculés par le module partagé `source/magma_visqueux/magma.py`.
- Layout :
  - arrivée au sud, sur le chemin de cendre (marqueur `entrance`) ;
  - la bouche de la grotte au nord (marqueur `donjon_seuil`) ;
  - de chaque côté de la grotte, une cascade de lave tombe de la falaise dans une mare de magma qui longe le chemin ;
  - quatre colonnes de magma jaillissent des mares, décalées.
  - Aucun warp.

## Magma visqueux

- Motif cellulaire de la lave de la fosse : cœurs rouges, masse orange, fines fissures jaunes, cellules étirées à l'horizontale.
- Dérive lente vers le sud : une période de texture (96 px) par boucle, soit 3 px par phase.
- Pliage : deux ondes lentes déforment la matière, qui s'étire puis se tasse.
- Gonflements : des bosses lentes éclaircissent la surface, puis retombent.
- Plaques de croûte sombre qui voyagent avec la matière. Elles fondent au pied des cascades et figent près des rives.
- Rides concentriques qui s'éloignent du pied de chaque cascade.

## Calques (du bas vers le haut)

| # | Calque | Animation |
|---|---|---|
| 00 | magma | 32 × 15 ticks, magma visqueux (aussi sous les cascades) |
| 01 | sol_complet | fixe |
| 02 | cendre | fixe, seule zone praticable |
| 03 | falaises | fixe (roche regarnie en miroir derrière les cascades) |
| 04 | bouche_grotte | fixe |
| 05 | cascades | 32 × 15 ticks, une lame qui serpente et descend de 7,5 px par phase |
| 06 | braises | 6 × 10 ticks, braises des falaises pulsées (méthode ECN1) |
| 07 | colonnes | 48 × 5 ticks : bouche qui palpite, jaillissement, colonne, retombée en gouttes, anneau |
| 08 | Top (vide) | à vous |

La boucle complète de la scène dure 480 ticks (8 s). Le calque magma est lourd : environ 69 000 tuiles, pour 32 phases.

## Installation

Lancez `python INSTALLER.py <dossier PMDO>`. Le script fusionne l'index des tuiles au lieu de l'écraser.

**Non testé dans PMDO.** Le manifeste indique `runtime_tested: false` et `art_approved: false`.
