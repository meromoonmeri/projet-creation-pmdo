# Ruines Zarbi — déchirures dans la réalité (RZD1), PMDO 0.8.12

Fin de zone : un fragment de ruine que la réalité déchire, et d'où sortent les **Zarbi** (Unown).

Format 4:3 : 768 × 576 px, soit 96 × 72 cases de 8 px.

- **Références** : deux maps de PMD Explorers of Sky, rendues directement depuis la ROM par `source/outil_maps_pmdsky` (`recuperer_maps.py rom --only D28,D30`).
  - `D28P44A` : ruines de dalles grises, terre ocre, linteaux sur piliers. Elle donne les matières de la ruine.
  - `D30P34A` : sommet d'une tour en ruine, avec un dallage de briques fendu, des colonnes brisées, des rochers en lévitation et un ciel rouge. Elle donne la réalité qui se désagrège.
  - Les noms de lieu ne sont **pas** affirmés : le préfixe `dNN` n'est pas le `DUNGEON_ID`, donc seuls les codes comptent.
- **Décor** : un rendu généré à partir de deux petites découpes de style (×2), sans les compositions entières, sur un nouveau layout. **Ce ne sont pas des tuiles natives.**
  - Le brut peint en magenta pur le vide autour du fragment et les cinq failles. Tout le magenta est remplacé par des calques calculés.
  - Premier rendu gardé tel quel, sans édition.
- **Fidélité** : seuil 35.
  - Briques, dalles et linteaux : boîtes de même matière mesurées à la main dans la référence et dans la scène t000.
  - Terre : même règle de couleur appliquée à D28P44A entière et à la scène. La première boîte de référence tombait sur des gravillons gris et donnait 45.

  | Matière | Référence | Distance |
  |---|---|---|
  | Briques (matière principale) | D30P34A | 12,1 |
  | Dalles | D28P44A | 19,6 |
  | Linteaux | D28P44A | 12,3 |
  | Terre | D28P44A | 15,2 |
  | Sol complet | D30P34A | 13,9 |

- **Layout** :
  - arrivée au sud par un chemin de dalles (`entrance`) ;
  - une esplanade de briques fendue de **cinq failles**, avec un marqueur `faille` devant la faille centrale ;
  - à l'ouest et à l'est, des bandes de terre ocre et des rangées de linteaux sur piliers, avec des colonnes renversées ;
  - au nord, un dais devant un mur de tablettes à glyphes (`autel`) ;
  - tout autour, le fragment se brise dans le vide de la distorsion, où flottent des rochers.
  - Aucune sortie latérale, aucun warp.

## Calques (du bas vers le haut)

| # | Calque | Animation |
|---|---|---|
| 00 | sol_complet | fixe |
| 01 | vide | 7 × 30 ticks : bandes violettes qui coulent, avec des fréquences temporelles entières. 90 étoiles s'allument 3 pas sur 7. Trois des tons sont ceux de la ROM, les trois plus sombres en sont dérivés. |
| 02 | sol | fixe, seule zone praticable |
| 03 | ruines | fixe : colonnes, linteaux, piliers, mur de tablettes, falaises, crevasses |
| 04 | rochers | 21 × 10 ticks : 24 rochers du brut montent et descendent de 1 à 2 px, chacun avec sa phase |
| 05 | failles | 21 × 10 ticks. **Loi relevée dans la ROM sur D30P34A** : seul le vitrail s'y anime, par une animation de palette de 3 rampes de 7 tons (rouge vif → violet sombre → retour) en 7 pas de 10 ticks. Elle est appliquée avec les 21 tons natifs. Voir le détail ci-dessous. |
| 06 | debris | 21 × 10 ticks : 30 éclats de pierre aspirés en spirale dans les failles ; ils prennent le ton ROM vif sur les 7 derniers pas |
| 07 | zarbi | 84 × 5 ticks : Z A R B I ! ? (le mot « ZARBI », plus ! et ?), sprites calculés de 24 px. Voir le détail ci-dessous. |
| 08 | Top (vide) | à vous |

**Calque failles** :
- le bord interne suit la rampe vive, le 2e rang la rampe moyenne ;
- la lueur externe suit la rampe sombre ; elle fait 2 px au pic, sinon 1 ;
- l'intérieur tourbillonne sur 21 pas ;
- les crevasses peintes à moins de 30 px d'une faille se rallument en rampe moyenne, avec un pas de retard tous les 6 px : l'énergie court le long des fissures.

**Calque zarbi** :
- Le sprite a un contour, un corps noir bleuté, un reflet et un œil blanc à pupille.
- Chaque Zarbi suit un cycle de 84 pas :
  1. il sort de sa faille en 10 pas, en grandissant (1/3 → 2/3 → 1), avec un halo en rampe moyenne ;
  2. il en fait le tour en 64 pas, sur une ellipse, en flottant de 1,5 px, avec son ombre au sol ;
  3. il y rentre en 8 pas ;
  4. il reste caché 2 pas.
- Deux Zarbi d'une même faille tournent dans le même sens, à une demi-boucle d'écart.

La scène boucle en 420 ticks (7 s).

## Installation

Lancez `python INSTALLER.py <dossier PMDO>`. Le script fusionne l'index des tuiles au lieu de l'écraser.

**Non testé dans PMDO.** Le manifeste indique `runtime_tested: false` et `art_approved: false`. L'événement de l'autel et les raccords restent à scripter.

## Fichiers

- `calques/` et `animation/vide`, `animation/rochers`, `animation/failles`, `animation/debris`, `animation/zarbi` : les calques et les images des animations (`fNN`).
- `masques/` : les masques des matières, dont `fissures` (les crevasses qui s'allument).
- `review/` : scène t000, scène animée en WebP, collisions et marqueurs, zoom de la faille centrale.
- `RZD1_ruines_zarbi_calques.ora` : les calques dans un seul fichier.
- `manifest.json` : empreintes du brut et des références, fidélité, loi ROM, failles, rochers, Zarbi, accès et banques.
- `RZD1_projet_pmdo_0812.zip` : le projet PMDO. `RZD1_calques_png_8px.zip` : les calques en PNG, avec les références.

Source : `source/ruines_zarbi_v1/`. On lance `build.py`, puis `package.py`, qui joue d'abord les tests. Les sprites des Zarbi sont dans `zarbi.py`.
