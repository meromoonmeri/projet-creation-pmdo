# ZRV1 — Zone de réveil : prairie de Sky Peak face à l'océan (jour, aube, nuit), format 4:3

- **Demande** (27 septembre) : la zone de départ, où le Pokémon se réveille.
  - Une grande prairie à la Sky Peak qui donne sur un paysage.
  - En contrebas, la mer, **« comme la mer animée dans PMD Sky »**, avec l'**effet de bulles de la mer qui arrive**.
  - À l'horizon, des cimes et une mer de nuages, avec **des nuages qui passent**.
  - Une **« falaise sans relief »** et une **entrée immersive**.
  - « Le paysage doit être magnifique, c'est la première scène du jeu. »
- **Choix faits avec toi** (questions posées avant de construire) :
  - un **promontoire** ;
  - un réveil au bord nord, face à l'océan, et une sortie au sud ;
  - des ambiances **jour et nuit**. Tu avais aussi répondu « les deux » (jour et aube) : **l'aube a donc été ajoutée**, soit trois Grounds.
- **Taille** : 768 × 576 px, soit 96 × 72 cases de 8 px.
- **Préfixes** : `ZRV1` pour les fichiers ; `ZRV1J_`, `ZRV1A_` et `ZRV1N_` pour les banques.

Fichiers :

- Aperçu : `apercu_zone_reveil_prairie_horizon_v1.html` (racine), qui rejoue les calques à la cadence du moteur, ou `review/ZRV1_{jour,aube,nuit}_scene_animee.webp`.
- Pack PMDO 0.8.12 : `ZRV1_projet_pmdo_0812.zip`. Il contient trois Grounds : `zrv1_zone_reveil_jour`, `zrv1_zone_reveil_aube` et `zrv1_zone_reveil_nuit`.
- Calques PNG 8 px : `ZRV1_calques_png_8px.zip`, avec les calques fixes et les images de chaque animation. Il y a aussi un ORA par ambiance.
- Source : `source/zone_reveil_prairie_horizon_v1/`, 12 tests.
- Base : branche de session.
  - Utilitaires repris d'EWC1 et d'ESN1 (BFS) ; `write_ora` et `ground_project` repris d'ECV1.
  - Palettes de mer reprises de l'étude des animations (`renders/etude_animations_canoniques_sky_v1/rapport.json`).
  - Rien n'est repris des branches sœurs.

## Méthode : rendu généré référencé et mer du jeu

Les bruts ont été générés avec les captures passées en images de référence. Chaque brut est **conforme au premier essai**. Les prompts complets sont dans `manifest.json` → `generation`.

| Brut | Références | Rôle |
|---|---|---|
| `bruts/decor_jour.png` (1200 × 896) | frame 0 du GIF Sky Peak, `232233.png` (cimes), mer de s01p02a | prairie, bord plat, mer, horizon |
| `bruts/decor_nuit.png` | le décor de jour, la nuit native de PMD Ciel | même scène de nuit, pleine lune |
| `bruts/decor_aube.png` | le décor de jour | même scène à l'aube, soleil levant |
| `bruts/nuages_sprites.png` | nuit native, `232233.png` | six nuages isolés sur magenta, pour les nuages qui passent |

**Fidélité**, mesurée avec le même classifieur sur la frame 0 du GIF (y ≥ 150) et sur le brut de jour, seuil 35 :

| Matière | Capture | Brut | Distance | Calque final | Distance |
|---|---|---|---|---|---|
| Herbe | (131,241,115) | (133,239,108) | 8,1 | (131,237,107) | 9,2 |
| Fleurs | (247,167,143) | (234,157,134) | 18,5 | (233,156,130) | 22,4 |

Les bruts d'aube et de nuit sont des éditions du brut de jour. Recalage mesuré sur la prairie (écart des gradients de luminance) :

- nuit : 0,69, contre 0,92 avec un décalage de 1 px ;
- aube : 0,59, contre 0,79 avec un décalage de 1 px.

Les trois ambiances partagent donc les mêmes masques et les mêmes collisions.

**Segmentation** (détail dans `manifest.json` → `segmentation`) :

- **L'horizon** est la première rangée bleu mer.
- **La prairie** est la plus grande composante verte sous l'horizon.
- **La mer** est le reste sous l'horizon.
- **Le panorama** est tout ce qui est au-dessus : ciel, cimes et mer de nuages forment **un seul calque**. Le bas du ciel (81,186,251) a presque la couleur de la neige des cimes (130,194,246), donc toute séparation par couleur serait arbitraire.
- **Dans la prairie** : herbe, chemin de sable, fleurs (roses et jaunes), rochers gris-bleu et buissons.
- On compte 64 massifs de fleurs, 7 rochers et 6 buissons.

## La mer : celle de PMD Ciel

La mer n'est **pas** la mer du brut repeinte au plus proche : cette voie est une impasse. La rampe du jeu n'est pas monotone, et les index 2 et 8 ont la même couleur. La mer est donc **reconstruite avec la mécanique du jeu** :

- **Couleurs et cadence exactes** de la carte s01p02a, relevées dans la ROM par l'étude des animations :
  - palette 7 pour la mer, palette 8 pour l'écume ;
  - 10 crans de 10 ticks, soit une boucle de 100 ticks.
- **Loi** : couleur(cran s, index k) = palette[s][k].
  - L'index croît de 0 à 9 vers la prairie, donc la crête blanche avance vers le rivage, comme dans le jeu.
  - La largeur de chaque index suit le profil mesuré dans s01p02a : [7890, 7654, 7915, 7416, 4904, 3799, 3395, 2677, 2861, 3418] px.
- **Perspective** : la période des bandes passe de 16 px à l'horizon à 44 px au pied de la prairie (courbure 1,2).
  - Toutes les rangées ondulent **en phase** : amplitude 0,12 période, longueur d'onde 3,2 périodes, plus une harmonique.
  - Ce motif des bandes est **dessiné par nous**. Seules les couleurs et la cadence sont natives.
- **Écume**, au pied de la prairie, avec la palette 8 :
  - index 9 au bord, 8 au milieu, 4 à 6 pour l'écume éclatée du rendu ;
  - en bandes de 2, 4 et 16 px.
  - Elle clignote blanche comme dans le jeu.
  - **C'est l'exception que tu as demandée** à la règle « pas de liseré blanc au bord de l'eau » : ici, c'est de l'écume animée au pied du promontoire, pas un trait fixe.
- **Aube et nuit** : couleurs transposées depuis les bruts, selon la médiane des pixels de mer de même luminance de jour. Le reflet de l'astre a sa propre palette :
  - aube : une colonne lissée sous le soleil, 17 155 px ;
  - nuit : une colonne argentée sous la lune, 5 752 px.
  - Le tracé de la colonne suit le 90ᵉ percentile de la demi-largeur des pixels clairs, rangée par rangée, puis il est lissé.

## Les autres animations

Toutes les animations sont des boucles fermées et testées.

| Calque | Cadence | Loi |
|---|---|---|
| Bulles | 24 × 5 ticks | 16 bulles le long de l'écume, jamais sur la prairie ; elles naissent, gonflent et éclatent, décalées dans le temps. Couleurs de la palette 8, ou transposées. |
| Scintillements | 24 × 5 ticks | **Jour** : 12 reflets sur la mer. **Aube** : 92 paillettes dans le reflet du soleil. **Nuit** : 9 étoiles du brut ; le bord de la lune et les bords de nuages sont exclus, le test l'impose. Plein aux phases 4 à 11, cœur seul aux phases 2-3 et 12-13, éteint sinon. |
| Nuages qui passent | 192 × 8 ticks = 25,6 s | Deux rangées en parallaxe. Rangée haute : période 768 px, 4 px par phase, 4 nuages. Rangée basse : période 384 px, 2 px par phase, 2 nuages. Chaque rangée revient exactement à son point de départ en 192 phases. **Nuit** : recolorés par rang de luminance sur les 48 couleurs de nuages de la nuit native. **Aube** : recolorés sur les tons clairs du panorama d'aube. |

## Accès et marqueurs

- `entrance` est en (384, 560), au bord sud, sur le chemin : c'est la sortie de la zone.
- `reveil` est en (376, 240), au bord nord de la prairie, au centre, tourné vers l'océan.
- Un chemin 16 × 16 relie les deux, trouvé par BFS.
- Sur 6 912 cases de 8 px : 3 467 praticables et 3 445 bloquées (mer, écume, panorama, rochers, buissons).
- Il n'y a **aucun warp** : c'est une base d'édition.

## Tests

`source/zone_reveil_prairie_horizon_v1/test_build.py`, 12 tests. Ils vérifient :

- les bruts et les références (sha256) ;
- la fidélité ;
- le recalage ;
- que la mer suit exactement la loi de palette du jeu ;
- que l'écume et les bulles restent dans leur bande ;
- les boucles des scintillements ;
- les 192 phases des nuages ;
- les calques et les ORA ;
- les Grounds (dimensions, marqueurs, obstacles) ;
- l'accès.

Cinq mutations sont détectées :

1. un pixel de mer hors palette ;
2. les nuages décalés à une phase. Au premier essai, cette mutation passait inaperçue ; le test compare maintenant les 192 phases ;
3. une bulle posée sur la prairie ;
4. une couleur de la palette 7 altérée ;
5. une case de mer rendue praticable.

## Limites

- Le terrain, le panorama et les nuages sont des **pixels générés**, pas des tuiles natives certifiées.
- Il reste à valider l'art et à tester dans PMDO : `art_approved:false`, `runtime_tested:false`.
- Le calque de mer fait environ 16 400 tuiles par ambiance, et chaque rsground pèse environ 20 Mo : à surveiller dans l'éditeur.
