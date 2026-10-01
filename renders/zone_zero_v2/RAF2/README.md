# Route Zone Zéro 2 fleurie — terrasses aux cascades (RAF2), PMDO 0.8.12

Nouvelle version de **RAZ2**, qui reste disponible telle quelle. La demande était la suivante :
- la texture de Sky Peak ;
- des fleurs de différentes couleurs ;
- des arbres PMD ;
- les cascades gardées ;
- chaque élément sur son propre calque ;
- des trous qui donnent vraiment un effet de profondeur.

Format 4:3 : 768 × 576 px, soit 96 × 72 cases de 8 px.

- **Références** :
  - **Sky Peak** (`2cwdrrs469f61.gif`, image 0) pour l'herbe, les falaises gris-bleu et les fleurs ;
  - **Apple Woods** (`Apple_Woods_entrance_TDS.png`) pour les arbres ;
  - la loi et la palette des cascades viennent de `P03P01A`.
- **Décor** : un rendu généré. Le générateur a reçu le brut de RAZ2, une découpe Sky Peak ×2 et une découpe d'arbres Apple Woods ×2, avec le gouffre en magenta. **Ce ne sont pas des tuiles natives.**
- **Gouffre** : une édition du décor. Seuls les pixels situés dans le masque magenta sont gardés.
- **Arbres** : les mêmes 8 sprites que RAF1, soit des feuillages découpés dans les bruts de décor. Les deux planches générées à part ont été rejetées (voir RAF1).
- **Fidélité** (seuil 35) :

  | Matière | Distance | Statut |
  |---|---|---|
  | Herbe | 10,4 (aplat HQ au ton dominant du GIF) | seuillée |
  | Arbres | 8,5 | seuillée |
  | Falaises | 21,5 | signalée |

- **Layout** :
  - arrivée au sud (`entrance`), sur un chemin beige ;
  - on monte l'**escalier de pierre**, entre deux cascades, vers la terrasse haute ;
  - le chemin de corniche longe le gouffre jusqu'aux marches du nord-est (`sortie`) ;
  - trois cascades sur la terrasse haute, deux sur la basse, chacune avec son bassin ;
  - `belvedere` près du bord du gouffre, qui occupe tout l'est ;
  - aucune sortie latérale, aucun warp.

## Passe haute qualité (septembre 2026)

Demande : « faut que les zone route area zero soit magnifique avec la verdure sky peak hight qualité less fleur avec plein de couleur des cascade de la brume etc ». La réduction ×0,64 rendait l'herbe floue et les fleurs baveuses. La passe est calculée (`source/zone_zero_v2/haute_qualite.py`), pas des tuiles natives ; seuls les tons viennent du GIF Sky Peak.

- **Herbe** : l'herbe claire du sol devient un aplat franc au ton dominant du GIF Sky Peak (134 304 px). Seuls les pixels à moins de 40 du ton dominant du lot sont concernés, donc le chemin clair reste.
- **Nettoyage** : 1 200 px de restes flous et 3 298 px de tiges maigres redeviennent de l'herbe.
- **Massifs repris** : 596 px de massifs flous restés dans le sol et 1 015 px de massifs classés falaises (boîtes `massifs_falaise` de la config) sont redessinés nets et deviennent praticables.
- **Touffes** : 51 étoiles de 6 brins qui se balancent en A B A C, comme toute la prairie du GIF.
- **Fleurs** : 217 fleurs nettes en huit couleurs. Les massifs d'origine gardent leur couleur et d'autres massifs s'ajoutent sur l'herbe franche.
- **Embruns** au pied des cascades, et **papillons**.
- **Sol et buissons** : le sol est quantifié seul sur 128 couleurs, sinon les buissons ronds du sol tombaient en olive plat. Les falaises et les buissons passent à 96 couleurs.

Contrôles : 13 tests (dont `test_haute_qualite` ; le test des cristaux vérifie qu'il n'y en a pas ici), et 23 mutations toutes détectées (`source/zone_zero_v2/mutations.py raf2`).

## Calques (du bas vers le haut)

| # | Calque | Animation |
|---|---|---|
| 00 | sol_complet | fixe |
| 01 | abime | fixe : le gouffre généré avec un **dégradé de profondeur** vers le bleu nuit |
| 02 | brume_profonde | 24 × 20 ticks : +4 px par phase, trame de Bayer, plus dense vers le fond |
| 03 | brume_haute | 24 × 10 ticks : −8 px par phase, effet de **parallaxe** |
| 04 | lueurs | 24 × 10 ticks : 34 éclats lointains |
| 05 | eau | 3 × 10 ticks : rides |
| 06 | sol | fixe : herbe Sky Peak en **aplat franc** (135,247,119, ton dominant du GIF) et chemin |
| 07 | falaises | fixe |
| 08 | herbes | 4 × 12 ticks, A B A C : 51 **touffes en étoile** nettes (tons relevés sur Sky Peak) ; en B et C les brins du haut penchent de ±1 px |
| 09 | fleurs | 4 × 12 ticks, loi du GIF Sky Peak (A B A C) : en B et C chaque fleur descend de 1 px et penche de ±1 px. 217 **fleurs nettes de 7 px** (4 pétales, reflet, cœur, ombre verte) en **huit couleurs** : corail, rouge, rose, orange, jaune, blanc, bleu, violet |
| 10 | buissons | fixe |
| 11 | arbres | fixe : 51 arbres PMD |
| 12 | cascades | 3 × 10 ticks : loi de P03P01A |
| 13 | ecume | 3 × 10 ticks |
| 14 | embruns | 24 × 10 ticks : 201 gouttelettes partent du haut de l'écume de chaque cascade, montent de 34 px en ondulant et s'effacent (trame de Bayer) |
| 15 | papillons | 48 × 10 ticks : 5 papillons de couleurs différentes sur des boucles fermées (Lissajous) au-dessus de la prairie ; ailes ouvertes et fermées une phase sur deux |
| 16 | Top (vide) | à vous |

La scène boucle en 480 ticks (8 s).

**Collisions** : le sol, les chemins, l'escalier, les fleurs et les massifs sont praticables. On compte 5 195 cases bloquées sur 6 912.

Les reflets clairs des marches passaient la règle de l'eau, et les massifs de fleurs bleues aussi. Les deux sont maintenant exclus, et un test le vérifie.

## Installation

Lancez `python INSTALLER.py <dossier PMDO>`.

**Non testé dans PMDO** : `runtime_tested: false`, `art_approved: false`. Les raccords restent à scripter.

## Fichiers

Même organisation que RAF1, avec le préfixe `RAF2_`.

Source : `source/zone_zero_v2/`. On lance `build.py raf2`, puis `package.py raf2`.
