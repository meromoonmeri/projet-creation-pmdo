# Arène de Groudon — lac de magma (AGM1), PMDO 0.8.12

Arène de boss sur un lac de magma, **symbole de Groudon qui pulse** au centre, **colonnes de magma** qui jaillissent à côté de l'arène, **magma visqueux**. Elle va avec l'entrée Cratère magma (ECM1).

- Format 4:3 : 768 × 576 px, soit 96 × 72 cases de 8 px.
- Référence : `Dark_Crater_Pit_TDS.png`, la fosse de Dark Crater dans PMD Sky. Elle donne les textures du décor et la rampe de 11 tons du magma.
- Le décor, dais et symbole compris, est un rendu généré avec cette référence. **Ce ne sont pas des tuiles natives.**
  - Le magma et les colonnes sont calculés par le module partagé `source/magma_visqueux/magma.py`. Ce sont les mêmes que dans l'entrée ECM1.
- Note : dans PMD Explorers of Sky, Groudon se combat au sommet de Steam Cave. L'association avec le magma de Dark Crater est un choix de la demande.
- Layout :
  - arrivée au sud, par le chemin de pierre (marqueur `entrance`) ;
  - grande arène de pierre sur le magma ;
  - au centre, un dais rond surélevé, gravé du Ω de Primo-Groudon dans un anneau. Le marqueur `boss` est sur le Ω, le marqueur `heros` devant le dais ;
  - quatre colonnes de magma dans le lac, deux de chaque côté de l'arène, à hauteur du dais, en alternance.
  - Aucune sortie, aucun warp.

## Calques (du bas vers le haut)

| # | Calque | Animation |
|---|---|---|
| 00 | magma | 32 × 15 ticks, magma visqueux ; des rides s'éloignent des évents |
| 01 | sol_complet | fixe |
| 02 | sol_arene | fixe, seule zone praticable |
| 03 | rebord | fixe |
| 04 | pitons | fixe |
| 05 | dais | fixe (bloquant) |
| 06 | symbole_groudon | 12 × 10 ticks : les lignes du Ω et de l'anneau montent du rouge au jaune vif, puis redescendent ; halo de 2 px au pic |
| 07 | braises | 6 × 10 ticks, braises du rebord et des pitons (méthode ECN1) |
| 08 | colonnes | 48 × 5 ticks : bouche qui palpite, jaillissement, colonne, retombée en gouttes, anneau |
| 09 | Top (vide) | à vous |

La boucle complète de la scène dure 480 ticks (8 s). Le calque magma est lourd : 113585 tuiles, pour 32 phases.

## Installation

Lancez `python INSTALLER.py <dossier PMDO>`. Le script fusionne l'index des tuiles au lieu de l'écraser.

**Non testé dans PMDO.** Le manifeste indique `runtime_tested: false` et `art_approved: false`.
