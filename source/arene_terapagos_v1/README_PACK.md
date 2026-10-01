# Arène de Terapagos, cristal prismatique (ATP1), PMDO 0.8.12

Une arène pour **Terapagos**, au bout du réseau de la Zone Zéro (après EAZ1). C'est une caverne ronde de **cristal de verre** dont les facettes renvoient le spectre des couleurs. Au sol, l'emblème Téracristal et ses runes pulsent. Map 4:3 générée avec les textures de PMD Explorers of Sky.

- Format 4:3 : 768 × 576 px, soit 96 × 72 cases de 8 px.
- **Références**, rendues depuis la ROM par `source/outil_maps_pmdsky` (`rom --only D17,D42`) :
  - `D17P45A` : champ de cristaux bleus, sol lumineux à dalles hexagonales ;
  - `D42P42A` : arène ronde de cristal, étoile au sol et scintillements animés. Son animation (`reference/D42P42A_anim.webp`, 27 images) fournit les formes et la loi des scintillements.
  - Les noms de lieu ne sont pas affirmés : le préfixe `dNN` n'est pas le `DUNGEON_ID`, seuls les codes comptent.
- **Brut généré** : `bruts/decor_vert.png` (1200 × 896), rendu à partir d'une découpe ×2 de chaque référence. Premier rendu gardé sans édition.
  - L'emblème (étoile à 12 branches en facettes hexagonales dans un anneau) et les runes y sont gravés en **vert pur**. Ces pixels verts sont ensuite remplacés par des calques calculés.
  - Le prompt demandait 12 runes ; le générateur en a peint **14**, et on les garde toutes.
  - **Ce ne sont pas des tuiles natives.** Les 60 tons du spectre (12 teintes × 5 niveaux, arrondis aux tons 5 bits de la NDS) sont **calculés**, pas relevés dans la ROM. Seules les formes et la loi des scintillements viennent de D42P42A.
- **Fidélité** (seuil 35), avec la même règle appliquée à D17P45A entière et à la scène : sol 29,3, cristaux 23,1.
  - Règle du sol : plus grande zone lisse (écart-type local 9 × 9 < 16) et claire, sans les gravures qui pulsent.
  - Règle des cristaux : le reste, à plus de 4 px du sol.
  - Notre sol est un peu plus cyan que la référence (rouge moyen 86 contre 115). C'est l'écart principal, et il reste sous le seuil.
- **Layout** :
  - arrivée au sud par un couloir de cristal (marqueur `entrance`) ;
  - le sol lumineux s'ouvre en forme de cœur, fermé tout autour par des amas de cristaux ;
  - l'emblème Téracristal est gravé **à plat dans le sol**, au centre, et se traverse. Terapagos est posé dessus (marqueur `boss`) ;
  - 14 runes forment un cercle autour de l'anneau ;
  - l'équipe s'arrête au sud de l'anneau (marqueur `heros`). Aucune autre sortie, aucun warp.

## Calques (du bas vers le haut)

| # | Calque | Animation |
|---|---|---|
| 00 | sol_complet | fixe : plage de sol du brut, sans gravure, en miroir sur toute la carte |
| 01 | sol | fixe, seule zone praticable. Sous les gravures, on prend le pixel de sol non gravé le plus proche |
| 02 | cristaux | fixe, 64 couleurs |
| 03 | reflets | 54 × 10 ticks. Deux bandes arc-en-ciel balaient en diagonale le quartile le plus clair des facettes. Le niveau suit la luminance. Quand la 1re bande arrive à la place de la 2e, celle-ci est sortie : le raccord est exact |
| 04 | embleme | 36 × 5 ticks. Une onde part du centre, I = 0,5 − 0,5 cos(2π(t/36 − 0,5 r/R)). Le spectre tourne d'une teinte tous les 3 pas, soit un tour par boucle. Halo de 1 px au niveau 3 et de 2 px au niveau 4 |
| 05 | runes | 36 × 5 ticks. La rune k (sens horaire depuis le nord) s'allume au pas round(36 (k − 1) / 14), puis s'éteint en 12 pas. Chaque rune a sa teinte et reste lisible au repos |
| 06 | scintillements | 54 × 10 ticks. 44 étoiles sur les facettes claires, formes ROM : grande étoile de 17 px, petite croix de 5 px. Loi ROM : éclat, puis décroissance linéaire. Périodes ROM 16 et 11 images, ramenées ici à 18 et 9 pour boucler |
| 07 | Top (vide) | à vous |

La scène boucle en 540 ticks (9 s).

## Installation

Lancez `python INSTALLER.py <dossier PMDO>`. Le script fusionne l'index des tuiles au lieu de l'écraser.

**Non testé dans PMDO.** Le manifeste indique `runtime_tested: false` et `art_approved: false`.

## Fichiers

- `calques/` : calques fixes (`ATP1_NN_nom.png`).
- `animation/reflets`, `animation/embleme`, `animation/runes`, `animation/scintillements` (`fNN`) : images des animations.
- `masques/` : sol, cristaux, emblème, runes, et les étiquettes des runes (valeur = 18 × numéro).
- `review/` : scène t000, scène animée en WebP, collisions et marqueurs, pulsation de l'emblème en 6 instants, nuancier du spectre.
- `ATP1_arene_terapagos_calques.ora` : les calques dans un seul fichier.
- `manifest.json` : empreintes du brut et des références, fidélité, segmentation, spectre, lois animées, accès et banques.
- `ATP1_projet_pmdo_0812.zip` : le projet PMDO. `ATP1_calques_png_8px.zip` : les calques en PNG.

Source : `source/arene_terapagos_v1/`. On lance `build.py`, puis `package.py`, qui joue d'abord les tests.
