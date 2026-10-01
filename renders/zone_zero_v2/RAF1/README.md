# Route Zone Zéro 1 fleurie — lèvre du cratère (RAF1), PMDO 0.8.12

Nouvelle version de **RAZ1**, qui reste disponible telle quelle. La demande était la suivante :
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
  - la loi et la palette des cascades viennent de `P03P01A`, comme pour RAZ1.
- **Décor** : un rendu généré. Le générateur a reçu le brut de RAZ1, une découpe Sky Peak ×2 et une découpe d'arbres Apple Woods ×2, avec le gouffre en magenta.
  - Une deuxième édition (`decor_magenta_b.png`) ajoute des arbres et des fleurs.
  - **Ce ne sont pas des tuiles natives.**
- **Gouffres** : une édition du décor. Seuls les pixels situés dans le masque magenta sont gardés ; le reste de l'édition, qui refaisait la prairie, est jeté.
- **Arbres** : des feuillages entiers découpés dans les bruts de décor. Il y a 4 modèles, plus leurs miroirs, soit 8 sprites. Ils sont plantés en lisière et sur les massifs.
  - Deux planches d'arbres générées à part ont été **rejetées** : v0, vert émeraude, à une distance de 56 d'Apple Woods ; v1, kaki, à une distance de 51.
- **Fidélité** (seuil 35) :

  | Matière | Distance | Statut |
  |---|---|---|
  | Herbe, contre Sky Peak | 12,1 (aplat HQ au ton dominant du GIF) | seuillée |
  | Arbres, contre les cœurs de feuillage d'Apple Woods | 8,5 | seuillée |
  | Falaises | 32,4 | signalée, non seuillée |

  Le générateur a fait les falaises plus sombres que celles de Sky Peak. Elles sont signalées comme matière secondaire, selon le précédent de RAZ3.
- **Layout** :
  - arrivée au sud (`entrance`) ;
  - un chemin monte dans la prairie fleurie vers l'arête qui sépare les deux gouffres, jusqu'au bord nord (`sortie`, vers RAF2) ;
  - `belvedere` au bord du gouffre de gauche ;
  - six cascades tombent des falaises dans des bassins ;
  - aucune sortie latérale, aucun warp.

## Passe haute qualité (septembre 2026)

Demande : « faut que les zone route area zero soit magnifique avec la verdure sky peak hight qualité less fleur avec plein de couleur des cascade de la brume etc ». La réduction ×0,64 rendait l'herbe floue et les fleurs baveuses. La passe est calculée (`source/zone_zero_v2/haute_qualite.py`), pas des tuiles natives ; seuls les tons viennent du GIF Sky Peak.

- **Herbe** : l'herbe claire du sol devient un aplat franc au ton dominant du GIF Sky Peak (119 252 px). Seuls les pixels à moins de 40 du ton dominant du lot sont concernés, donc le chemin clair reste.
- **Nettoyage** : 1 367 px de restes flous et 2 368 px de tiges maigres redeviennent de l'herbe.
- **Massifs repris** : 0 px de massifs flous restés dans le sol et 0 px de massifs classés falaises (boîtes `massifs_falaise` de la config) sont redessinés nets et deviennent praticables.
- **Touffes** : 66 étoiles de 6 brins qui se balancent en A B A C, comme toute la prairie du GIF.
- **Fleurs** : 141 fleurs nettes en huit couleurs. Les massifs d'origine gardent leur couleur et d'autres massifs s'ajoutent sur l'herbe franche.
- **Embruns** au pied des cascades, et **papillons**.
- **Sol et buissons** : le sol est quantifié seul sur 128 couleurs, sinon les buissons ronds du sol tombaient en olive plat. Les falaises et les buissons passent à 96 couleurs.

Contrôles : 13 tests (dont `test_haute_qualite` ; le test des cristaux vérifie qu'il n'y en a pas ici), et 23 mutations toutes détectées (`source/zone_zero_v2/mutations.py raf1`).

## Calques (du bas vers le haut)

| # | Calque | Animation |
|---|---|---|
| 00 | sol_complet | fixe (herbe propagée sous tout le sol) |
| 01 | abime | fixe : le gouffre généré, avec un **dégradé de profondeur** qui tire vers le bleu nuit (45 % au fond) |
| 02 | brume_profonde | 24 × 20 ticks : bruit périodique de 96 px, +4 px par phase, trame de Bayer. Plus dense vers le fond |
| 03 | brume_haute | 24 × 10 ticks : voiles clairs, −8 px par phase. Sens opposé et plus rapide : effet de **parallaxe** |
| 04 | lueurs | 24 × 10 ticks : 34 éclats lointains, seulement là où la profondeur dépasse 0,7 |
| 05 | eau | 3 × 10 ticks : des rides s'éloignent de l'écume |
| 06 | sol | fixe : herbe Sky Peak en **aplat franc** (135,247,119, ton dominant du GIF) et chemin |
| 07 | falaises | fixe |
| 08 | herbes | 4 × 12 ticks, A B A C : 66 **touffes en étoile** nettes (tons relevés sur Sky Peak) ; en B et C les brins du haut penchent de ±1 px |
| 09 | fleurs | 4 × 12 ticks, loi du GIF Sky Peak (A B A C) : en B et C chaque fleur descend de 1 px et penche de ±1 px. 141 **fleurs nettes de 7 px** (4 pétales, reflet, cœur, ombre verte) en **huit couleurs** : corail, rouge, rose, orange, jaune, blanc, bleu, violet |
| 10 | buissons | fixe |
| 11 | arbres | fixe : 59 arbres PMD, avec leur ombre tramée |
| 12 | cascades | 3 × 10 ticks : loi de P03P01A, un motif de 96 px qui descend de 32 px par image |
| 13 | ecume | 3 × 10 ticks |
| 14 | embruns | 24 × 10 ticks : 234 gouttelettes partent du haut de l'écume de chaque cascade, montent de 34 px en ondulant et s'effacent (trame de Bayer) |
| 15 | papillons | 48 × 10 ticks : 8 papillons de couleurs différentes sur des boucles fermées (Lissajous) au-dessus de la prairie ; ailes ouvertes et fermées une phase sur deux |
| 16 | Top (vide) | à vous |

La scène boucle en 480 ticks (8 s).

**Collisions** : le sol, les fleurs et les massifs sont praticables. La lisière, la végétation, les troncs et les arbres sont bloquants. On compte 5 235 cases bloquées sur 6 912.

## Installation

Lancez `python INSTALLER.py <dossier PMDO>`. Le script fusionne l'index des tuiles.

**Non testé dans PMDO.** Le manifeste indique `runtime_tested: false` et `art_approved: false`. Les raccords (RAF1 → RAF2) restent à scripter.

## Fichiers

- `calques/`, `animation/<calque>/` (`fNN`) et `masques/` : dans ce dernier, sol, vide, falaises, végétation, eau, cascades, fleurs, lisière, troncs, **praticable** et **profondeur**.
- `review/` : scène t000, scène animée en WebP, collisions et marqueurs, **zoom du gouffre** à 4 instants.
- `RAF1_route_fleurie_calques.ora` et `manifest.json` : ce dernier contient les empreintes, la fidélité, les planches rejetées, les lois, l'accès et les banques.
- `RAF1_projet_pmdo_0812.zip` et `RAF1_calques_png_8px.zip`.

Source : `source/zone_zero_v2/`. On lance `build.py raf1`, puis `package.py raf1`, qui joue d'abord les tests de `raf1/test_build.py`.
