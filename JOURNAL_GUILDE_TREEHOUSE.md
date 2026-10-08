# Journal du projet Guilde Treehouse

> Fichier d'origine : `README.md` de `meromoonmeri/projet-pmdo`. Renommé lors de l'extraction des méthodes ;
> le contenu ci-dessous est intact (journal chronologique des livraisons).

---

# Guilde Treehouse — passages ouverts PMD

## Fin Mt. Thunder : plateau fermé, FTM1 (8 octobre 2026)

**Demande** : « oui go enchaines » (après FVL1). Jumeau de EMT1.
Préfixe **FTM1** (`FMT1` pris sur une sœur).

- Sorties : `renders/fin_mt_thunder_v1/`, aperçu `apercu_fin_mt_thunder_v1.html`,
  build `source/fin_mt_thunder_v1/build.py`.
- **Méthode** : rendu généré référencé sur la planche Mt. Thunder (Red Rescue Team). Pas de grotte.
- **Layout** : crête de sable au sud (`entrance`), plateau (`boss`), piton/alcôve au nord (`objectif`). Nuages tout autour.
- **Calques** : sol complet, sable, cailloux, pics, falaise, piton, ciel, nuages, lueurs + éclairs (sprites exacts, 48 × 5), Top vide.
- **Fidélité** (seuil 35) : sable 2,9 · roche 10,3 · ciel 5,4 · nuages sombres 3,0 · nuages clairs 20,6.
- **Contrôles** : 10 tests PASS. 2 726 cases praticables. Pas de runtime, `art_approved: false`.
- Fins restantes ici : Jardin secret.

## Fin Couloir violet : arène fermée, FVL1 (8 octobre 2026)

**Demande** : « bon travail continuons » (après FCT1). Jumeau de ECV1.
Préfixe **FVL1** (`FCV1` pris sur une sœur).

- Sorties : `renders/fin_couloir_violet_v1/`, aperçu `apercu_fin_couloir_violet_v1.html`,
  build `source/fin_couloir_violet_v1/build.py`.
- **Méthode** : rendu généré référencé sur `large.S05P03A…png`. Pas de tunnel, pas de bouche.
- **Layout** : couloir au sud (`entrance`), grande salle (`boss`), alcôve de rochers au nord (`objectif`). Murs fermés.
- **Calques** : sol complet, sol, ombres, gravillons, blocs, rochers, vide, éboulis (gravillons exacts du rip), poussière (planche ECV1, 24 × 5), Top vide.
- **Fidélité** (seuil 35) : sol 2,7 · roche 11,9. Calques : sol 5,1 · rochers 11,6 · blocs 7,8.
- **Contrôles** : 12 tests PASS. 2 721 cases praticables. Pas de runtime, `art_approved: false`.
- Fins restantes ici (à cette date) : Mt. Thunder, Jardin secret.

## Fin Clairière tropicale : arène fermée, FCT1 (8 octobre 2026)

**Demande** : « Vasy genere la prochaine map » (après ouverture de la méthode). Jumeau de ETC1.
Préfixe **FCT1** (`FTC1` pris sur une sœur).

- Sorties : `renders/fin_clairiere_tropicale_v1/`, aperçu `apercu_fin_clairiere_tropicale_v1.html`,
  build `source/fin_clairiere_tropicale_v1/build.py`.
- **Méthode** : rendu généré référencé sur `large.S01P03A…png`. Pas de mer, pas de ponton, pas de bouche.
- **Layout** : sentier de dalles au sud (`entrance`), grande clairière (`boss`), tertre de hibiscus + palmier au nord (`objectif`). Jungle sur les quatre bords.
- **Calques** : sol complet, herbe, ombres, dalles, touffes, fleurs, jungle, palmiers, papillons (planche ETC1, 24 × 5), Top vide.
- **Fidélité** (seuil 35) : herbe 11,1 · jungle 26,6 · dalles 14,8.
- **Contrôles** : 11 tests PASS. Recalage (0, 0). 2 777 cases praticables. Pas de runtime, `art_approved: false`.
- Fins restantes ici (à cette date) : Couloir violet, Mt. Thunder, Jardin secret.

## Méthodes de création : WORKFLOW, série sud→nord, FCT1 ouvert (8 octobre 2026)

**Demande** : « Regarde le projet on va poursuivre les map et les méthodes de création read me workflow etc »
dans `projet-creation-pmdo` (extraction sans PNG de rendu).

- **WORKFLOW.md** racine : ouverture de session, gabarit Jungle, génération des bruts, segmentation,
  tests, paquet, pièges, récupération des rips via `gh api`.
- **`source/methode_serie_sud_nord/`** : README, WORKFLOW de relance, STATUS (tables entrées/fins,
  préfixes pris, carte suivante).
- **`WORKFLOW.md` par lot** de la série (47 chantiers + gabarit Jungle à la main + `zone_zero_v1`),
  outil `OUTILS/ecrire_workflows_lots.py`. Chaque fiche donne PFX, namespace, commandes, liste `GEN`,
  ce qui n’est pas extrait.
- **Carte suivante** : Fin Clairière tropicale, préfixe **FCT1** (jumeau ETC1). Layout de fin
  (pas de mer/ponton/bouche), papillons ETC1 à réutiliser, calques listés, seuils de fidélité
  rappelés. **Aucun brut généré** — `build.py` / tests / paquet à écrire avec les pixels.
- Index, README, GUIDE, REPRISE mis à jour. `art_approved: false`, pas de runtime.

## Fin Star Cave : arène de cristal, FST1 (29 septembre 2026)

**Demande** : « bon travail continue la suite ! » (après FSM1). Suite de la série des fins de donjon dans l'ordre du mod : **FST1** prolonge l'entrée ESC1 (Star Cave). Biome et portée choisis par l'agent, **à confirmer**.

- Sorties : `renders/fin_star_cave_v1/`, aperçu `apercu_fin_star_cave_v1.html`, build `source/fin_star_cave_v1/build.py`.
- **Méthode « textures canoniques »** = rendu généré référencé sur `starcavepmdsky.png`. Ce ne sont pas des tuiles natives.
- **Layout** : arrivée au sud par un couloir, caverne ronde de cristal, deux amas de rochers de chaque côté, alcôve de cristal au nord. Marqueurs `entrance`, `boss` (centre), `objectif` (pied de l'alcôve) ; aucune sortie, aucun warp.
- **Calques** : sol complet, sol, ombres, parois, blocs, reflets, étoiles, poussière d'étoile (24 × 5 ticks), plus un Top vide. Pas de calque de profondeur : la fin n'a pas de bouche sombre.
- **Cohérence avec l'entrée** : reflets, étoiles (4 formes du rip) et planche de poussière d'ESC1 réutilisés. Le premier décor généré est sorti en 2:1 (1440 × 720) et a été écarté.
- **Fidélité** (seuil 35) : sol 6,8, cristal 30,8 (parois 32,1 : cristaux plus cyan que le rip, limite).
- **Contrôles** : 13 tests PASS, 5 mutations détectées. Pas de runtime, `art_approved: false`.
- Fins restantes : Clairière tropicale, Couloir violet, Mt. Thunder, Jardin secret. Préfixe **FST1** (FSC1 est pris par un repère d'une branche sœur).

## Fin Sables mouvants : arène du désert, FSM1 (29 septembre 2026)

**Demande** : « Poursuis le projet », après lecture de `README.md`, `AGENTS.md`, `REPRISE_MAPS.md`, `MANUEL_METHODE_PMDO.md` et du README de l'outil maps PMD Sky. Suite de la série des fins de donjon dans l'ordre du mod : **FSM1** prolonge l'entrée EQS1 (Sables mouvants). Biome et portée choisis par l'agent, **à confirmer**.

- Sorties : `renders/fin_sables_mouvants_v1/`, aperçu `apercu_fin_sables_mouvants_v1.html`, build `source/fin_sables_mouvants_v1/build.py`.
- **Méthode « textures canoniques »** = rendu généré référencé sur `witheringdesert.png` (Furnace Desert). Ce ne sont pas des tuiles natives.
- **Layout** : arrivée au sud, arène ronde fermée par des falaises, grande fosse de sable mouvant au centre, couronne de sable autour, deux chutes de sable et une estrade de pierre au nord. Marqueurs `entrance`, `boss`, `objectif` ; aucune sortie, aucun warp.
- **Calques** : fosse (12 × 10), sol complet, sable, ombres, bord de la fosse, roches, pierres, chutes (24 × 5), poussière et tourbillons (24 × 5), plus un Top vide. Pas de rayons : l'arène n'a pas de ciel.
- **Cohérence avec l'entrée** : fosse, chutes et poussière reprennent les fonctions, les couleurs exactes du rip et la planche de poussière d'EQS1 (un test compare les constantes et les octets de la planche).
- **Fidélité** (seuil 35) : sable 19,9, roche 22,9.
- **Contrôles** : 15 tests PASS, 5 mutations détectées. Pas de runtime, `art_approved: false`.
- **Branches sœurs** (non fusionnées, rien repris) : `arena/01a0ea8f` a déjà une Fin Underground Lake (FUL1) et une arène de Terapagos fleurie (ATF1) ; `arena/01a0eaca` a FUL1 (autre version), FMF1/FMF2 (Mystifying Forest), six repères de fins (FCV1, FJS3, FMT1, FQS1, FSC1, FTC1) et BZF1. FSM1 est donc un préfixe distinct de FQS1.

## Cristaux Zone Zéro : blancs à reflets arc-en-ciel, RAF3 et EAF1 (29 septembre 2026)

**Demande** : « je veux que les cristal et des reflet et que ce soit comme area zero blanc de base a reflet arc en ciel qui change de couleur rouge mauve etc ». Les deux maps à cristaux du réseau fleuri, **RAF3** (piliers, couronnes) et **EAF1** (plateau, géode), ont deux calques de plus, juste au-dessus de `falaises` (19 calques au lieu de 17).

- **`cristaux`** (fixe) : les cristaux menthe deviennent **blancs**, en 5 tons blanc-lavande pris sur la luminance d'origine pour garder les facettes, avec un contour indigo. Surfaces : RAF3 32,447 px, EAF1 57,437 px.
- **`reflets`** (24 × 10 ticks, boucle fermée sur 480 ticks) :
  - une bande **arc-en-ciel** nacrée balaie les cristaux en diagonale, de 4 px par phase ;
  - elle porte 8 teintes : rouge, orange, jaune, vert, cyan, bleu, mauve, rose ;
  - la teinte d'un même pixel tourne toutes les 3 phases, si bien qu'un cristal passe du rouge au mauve ;
  - 36 éclats en étoile scintillent.
- **Sélection** : règle de couleur menthe, puis une composante n'est gardée que si au moins 5 % de ses pixels sont des facettes très claires. Sans ce filtre, les reflets turquoise de la roche au bord des gouffres étaient pris. Les bases menthe des piliers, peintes dans le sol, sont rattachées.
- Code : `crystal_pass` dans `source/zone_zero_v2/haute_qualite.py`, activé par `cristaux=True` dans la `CFG` du lot.
- Contrôles :
  - nouveau test `test_cristaux_blancs_reflets_arc_en_ciel` : base blanche peu saturée, reflets dans les cristaux, 8 teintes à chaque phase, au moins 4 teintes vues au même pixel, boucle fermée ;
  - 13 tests PASS sur les 4 lots ;
  - `mutations.py` trouve désormais les calques par leur nom, et compte 5 mutations cristaux de plus : 28/28 détectées pour RAF3 et EAF1, 23/23 pour RAF1.
- Paquets PMDO 0.8.12, calques PNG et aperçus refaits pour RAF1-3 et EAF1. Pixels calculés (recoloration du rendu généré), pas des tuiles natives. Aucun test en jeu.

## EAF1 — Entrée Zone Zéro fleurie : la géode du donjon (29 septembre 2026)

**Demande** : « la suite ! », après la passe haute qualité des routes. Le maillon suivant du réseau fleuri est l'entrée du donjon. **EAF1** remplace EAZ1 dans ce réseau ; EAZ1, une grotte de cristal sombre de l'ancienne série, est gardée. Le réseau devient : RAF1 → RAF2 → RAF3 → **EAF1** → ATP1.

- Sorties : `renders/zone_zero_v2/EAF1/`, aperçu `apercu_entree_zone_zero_fleurie.html`. Même build que les RAF (`source/zone_zero_v2/build.py eaf1`), passe haute qualité comprise.
- **Bruts générés**, dans l'ordre :
  1. le décor EAZ1 repeint au style RAF3 et Sky Peak ;
  2. une édition qui élargit le magenta ;
  3. l'édition « gouffre » : le générateur a refait le layout, avec deux grands gouffres qui encadrent une chaussée fleurie montant vers la géode. Ce layout, plus beau, a été gardé ;
  4. ce layout avec le fond des gouffres en magenta pur, qui sert de décor. Le gouffre n'est pris dans l'édition que sous ce masque.
- **Pas japonais** : ce sont des dalles vert sauge, traitées comme un chemin (`dalles` dans la config).
- **Contenu** : 16 calques ; 234 fleurs nettes en 7 couleurs ; 51 touffes ; 2 cascades avec 70 gouttelettes d'embruns ; 5 papillons ; 13 arbres plantés.
- **Fidélité** : herbe 3,4 et arbres 8,5, seuillées ; falaises 32,3, signalées.
- 12 tests PASS ; 23 mutations détectées.
- Paquets : `EAF1_projet_pmdo_0812.zip` (1,2 Mo) et `EAF1_calques_png_8px.zip` (7,2 Mo).
- Pas de runtime, pas de warp. Les raccords (RAF3 → EAF1 → donjon) restent à scripter.

## RAF1, RAF2, RAF3 — passe « haute qualité » (28 septembre 2026)

**Demande** : « faut que les zone route area zero soit magnifique avec la verdure sky peak hight qualité less fleur avec plein de couleur des cascade de la brume etc ».

Les trois routes fleuries sont refaites **en place** : mêmes préfixes, l'ancien état reste dans l'historique git. RAZ1-3 et EAZ1 ne sont pas touchées.

**Constat** : à Sky Peak, l'herbe est un aplat franc semé de touffes en étoile et de fleurs rondes nettes, et toute la prairie se balance en A B A C. Chez nous, la réduction ×0,64 donnait une herbe floue et des fleurs baveuses.

La nouvelle passe `source/zone_zero_v2/haute_qualite.py` est appelée par `build.py` après `make_all`. **Tout y est calculé** ; seuls les tons sont relevés sur le GIF :
- **Herbe** : aplat au ton dominant de Sky Peak (135,247,119), à moins de 40 du ton du lot, donc le chemin clair reste.
- **Nettoyage** : les restes flous et les tiges maigres redeviennent de l'herbe.
- **Massifs flous repris** :
  - ceux du sol, automatiquement ;
  - ceux classés falaises, par boîtes `massifs_falaise` (RAF2 : 2, RAF3 : 6), qui deviennent praticables.
- **Nouveau calque `herbes`** : touffes en étoile, 4 × 12 ticks en A B A C.
- **Fleurs** : sprites nets de 7 px (4 pétales, reflet, cœur, ombre verte) en **8 couleurs**, plus des massifs en plus. Même loi A B A C.
- **Nouveau calque `embruns`** : 24 × 10 ticks. Des gouttelettes partent du haut de l'écume de chaque cascade et montent de 34 px.
- **Nouveau calque `papillons`** : 48 × 10 ticks, boucles de Lissajous fermées, pas ≤ 4 px.
- **Quantification** : le sol est quantifié seul sur 128 couleurs, sinon les buissons ronds tombaient en olive plat. Les falaises et les buissons passent à 96 couleurs.

Résultats :

| Lot | Calques | Fleurs | Touffes | Papillons | Herbe | Arbres | Falaises |
|---|---|---|---|---|---|---|---|
| RAF1 | 16 | 141 | 66 | 8 | 12,1 | 8,5 | 32,4 |
| RAF2 | 16 | 217 | 51 | 5 | 10,4 | 8,5 | 21,5 |
| RAF3 | 16 | 270 | 55 | 8 | 10,7 | 8,5 | 44,8 (signalée) |

- Le seuil strict de l'herbe passe de 12 à 15, car l'aplat au ton dominant est à 11,4 de la moyenne de la règle d'herbe du GIF.
- **Tests** : 12/12 par lot, dont le nouveau `test_haute_qualite`.
- **Mutations** : 23/23 détectées par lot (8 nouvelles pour la passe HQ).
- Paquets PMDO 0.8.12 et ZIP de calques refaits : RAF1 1,3 / 8,0 Mo, RAF2 1,3 / 8,2 Mo, RAF3 1,3 / 7,5 Mo.
- Pas de runtime, pas de warp.

## RAF3 — Zone Zéro fleurie : fond du cratère et tunnel (28 septembre 2026)

**Demande** (renvoyée telle quelle) : « pour les zone arena faut la texture sky peak et les fleur de différente couleur et les arbre pmd et les cascade garde les doit avoir leurs propre calque les trou faut que genere vraiment cette effet de profondeur ». RAF1 et RAF2 couvraient déjà RAZ1 et RAZ2 ; **RAF3** fait la même chose pour **RAZ3**, qui est gardée. EAZ1, un intérieur de grotte, n'est pas retouchée.

- Sorties : `renders/zone_zero_v2/RAF3/`, aperçu `apercu_route_zone_zero_fleurie_3.html`. Même build que RAF1/RAF2 (`source/zone_zero_v2/build.py raf3`).
- **Brut généré** à partir du brut RAZ3 (layout), du décor RAF2 (style de la série) et d'une découpe Sky Peak ×2 :
  - le lac magenta devient deux gouffres ;
  - la chaussée de cristal devient une prairie fleurie ;
  - les cascades tombent dans des bassins sur la terrasse haute ;
  - le tunnel nord mène à EAZ1.
- Le gouffre est une édition du décor, gardée seulement dans le masque magenta.
- 13 calques ; 127 têtes de fleurs en 5 familles de couleurs ; 23 arbres plantés ; 2 cascades.
- **Fidélité** : herbe 7,7, arbres 8,5. Les falaises sont à **42,8**, au-dessus du seuil : la couronne rocheuse est sarcelle. Elles sont signalées, non seuillées.
- **Réglages propres au décor** :
  - chutes limitées aux colonnes peintes (les cristaux clairs passaient la règle des cascades) ;
  - eau limitée aux bassins sous l'écume (les falaises sombres passaient la règle de l'eau) ;
  - éclats de cristal exclus des fleurs ;
  - pavage entre les piliers déclaré praticable.
- 11 tests PASS ; 15 mutations détectées (`source/zone_zero_v2/mutations.py`, désormais versionné).
- Paquets : `RAF3_projet_pmdo_0812.zip` (1,6 Mo) et `RAF3_calques_png_8px.zip` (7,7 Mo). Pas de runtime, pas de warp.

## RAF1 et RAF2 — Zone Zéro fleurie : Sky Peak, fleurs, arbres PMD, gouffres profonds (28 septembre 2026)

**Demande** : « pour les zone area faut la texture sky peak et les fleur de differente couleur et les arbre pmd et les cascade garde les doit avoir leurs propre calque les trou faut que genere vraiment cette effet de profondeur ».

- Nouveaux lots **RAF1** (lèvre du cratère, nouvelle version de RAZ1) et **RAF2** (terrasses aux cascades, nouvelle version de RAZ2). RAZ1 et RAZ2 sont gardées ; RAZ3 et EAZ1 (cristal) ne sont pas touchées.
  - Sorties : `renders/zone_zero_v2/RAF1|RAF2/`.
  - Aperçus : `apercu_route_zone_zero_fleurie_1.html` et `apercu_route_zone_zero_fleurie_2.html`.
  - Un seul `build.py` et un seul `package.py` pour les deux, dans `source/zone_zero_v2/`.
- **Références** :
  - Sky Peak (`2cwdrrs469f61.gif`, image 0) pour l'herbe, les falaises et les fleurs ;
  - Apple Woods (`Apple_Woods_entrance_TDS.png`) pour les arbres ;
  - P03P01A pour la loi et la palette des cascades.
- **Bruts générés** : le décor (brut RAZ, avec des découpes Sky Peak et Apple Woods ×2, gouffre en magenta) et le gouffre (édition du décor, gardée **seulement** dans le masque magenta).
- **13 calques**, un par élément : sol complet, abîme, brume profonde, brume haute, lueurs, eau, sol, falaises, **fleurs**, buissons, **arbres**, **cascades**, écume.
- **Profondeur des trous** :
  - dégradé du gouffre vers le bleu nuit, selon une carte de profondeur ;
  - brume du fond tramée, plus dense vers le bas (+4 px par phase) ;
  - voiles clairs en sens opposé, plus rapides (−8 px par phase), pour la parallaxe ;
  - 34 éclats lointains au fond.
- **Fleurs** : loi du GIF Sky Peak (A B A C, 4 × 12 ticks). RAF1 a 61 têtes en 4 couleurs ; RAF2 en a 281 en 5 couleurs.
- **Arbres PMD** : des feuillages entiers découpés dans les bruts de décor (8 sprites), plantés en lisière (59 dans RAF1, 51 dans RAF2). Deux planches d'arbres générées à part ont été **rejetées** pour leur couleur (distance à Apple Woods de 56 et 51).
- **Fidélité** (seuil 35) :

  | Lot | Herbe | Arbres | Falaises (signalées, non seuillées) |
  |---|---|---|---|
  | RAF1 | 9,7 | 8,5 | 32,2 |
  | RAF2 | 5,2 | 8,5 | 20,5 |

- **Collisions** : on marche sur les fleurs, les chemins et l'escalier de RAF2. Les troncs et les arbres bloquent.
- 11 tests PASS par lot, et 28 mutations détectées (14 par lot).
- Paquets : `RAF1_projet_pmdo_0812.zip` (1,5 Mo) et `RAF1_calques_png_8px.zip` (8,2 Mo) ; `RAF2_projet_pmdo_0812.zip` (1,6 Mo) et `RAF2_calques_png_8px.zip` (8,4 Mo).
- Boucle de 480 ticks. Pas de runtime, pas de warp.

## ATP1 — Arène de Terapagos : cristal prismatique (28 septembre 2026)

**Demande** : « Fait une zone de crystal de verre qui reflette les spectre de couleur une arene pour terragos […] avec des rune et signe qui pulse etc ».

- `renders/arene_terapagos_v1/ATP1/` (préfixe `ATP1`, aperçu `apercu_arene_terapagos.html`). Map 4:3, arrivée au sud. C'est l'arène au bout du réseau Zone Zéro, après EAZ1.
- **Références**, rendues depuis la ROM (`rom --only D17,D42`) :
  - `D17P45A` : champ de cristaux, sol lumineux à dalles hexagonales ;
  - `D42P42A` : arène ronde, étoile au sol, scintillements animés.
  - Les noms de lieu ne sont pas affirmés.
- **Brut généré** : `bruts/decor_vert.png`, à partir de deux découpes ×2, gardé sans édition. L'emblème Téracristal et les runes y sont gravés en vert pur, puis remplacés par des calques calculés. 12 runes étaient demandées ; le générateur en a peint 14, toutes gardées.
- **Layout** :
  - couloir de cristal au sud (`entrance`) ;
  - sol lumineux en cœur, fermé par des amas de cristal ;
  - emblème gravé à plat au centre, sur lequel se tient Terapagos (`boss`), entouré de 14 runes ;
  - l'équipe s'arrête au sud de l'anneau (`heros`).
- **Animations** (boucle de 540 ticks), toutes aux 60 tons d'un **spectre calculé** (12 teintes × 5 niveaux, tons 5 bits NDS, pas des tons de la ROM) :
  - **emblème** : onde de lumière qui part du centre pendant que le spectre fait un tour, 36 × 5 ticks ;
  - **runes** : elles s'allument l'une après l'autre dans le sens horaire, chacune dans sa teinte, 36 × 5 ticks ;
  - **reflets** : deux bandes arc-en-ciel balaient les facettes claires des cristaux, 54 × 10 ticks ;
  - **scintillements** : 44 étoiles avec les formes et la loi « éclat puis décroissance » de D42P42A, 54 × 10 ticks.
- Fidélité (seuil 35), même règle sur D17P45A et sur la scène : sol 29,3, cristaux 23,1. Notre sol est un peu plus cyan que la référence.
- 10 tests PASS, 11 mutations détectées. Paquets : `ATP1_projet_pmdo_0812.zip` (3,4 Mo) et `ATP1_calques_png_8px.zip` (12,1 Mo). Pas de runtime, pas de warp.

## CLR1 — Colonnes Lances : ruines du sommet dans les nuages (28 septembre 2026)

**Demande** : « une map style colonne lance ruin etc avec les texture pmd ».

- `renders/colonnes_lances_v1/CLR1/` (préfixe `CLR1`, aperçu `apercu_colonnes_lances.html`). Map 4:3, arrivée au sud.
- **Références**, rendues depuis la ROM (`rom --only D28,D29,D30`) :
  - `D30P42A` : sommet intact, avec briques, colonnes cannelées, autel à vitrail vert, rochers en lévitation et mer de nuages dorée ; c'est l'analogue PMD le plus proche des Colonnes Lances ;
  - `D28P33A` : grand escalier à balustres.
  - Les noms de lieu ne sont pas affirmés.
- **Bruts générés** : le décor (deux découpes ×2, ciel en magenta pur, gardé sans édition) et une feuille de 4 bandes de nuages (découpe ×3 des nuages de D30P42A).
- **Layout** :
  - grand escalier au sud (`entrance`) ;
  - esplanade de briques dans un cercle de huit colonnes, debout ou brisées, avec trois colonnes couchées (`centre`) ;
  - autel à vitrail au nord sur une terrasse haute (`autel`) ;
  - mer de nuages et rochers en lévitation tout autour.
  - Colonnes et autel ont les tons des briques : leurs obstacles sont mesurés à la main sur le brut.
- **Animations** (boucle de 1200 ticks) :
  - **vitrail** : loi de palette ROM de D30P42A, 2 rampes de 12 tons vert → cyan, 22 tons natifs ;
  - **nuages** : bandes rendues périodiques (480 px) qui dérivent de 4 px par pas, 120 × 10 ticks ; le ciel garde le ton uni de la ROM ;
  - **rochers** qui flottent ;
  - **éclats de lumière** qui montent de l'autel.
- Fidélité (seuil 35) : briques 8,1, piliers 7,2, escalier 7,0, nuages 8,8.
- 8 tests PASS, 9 mutations détectées. Paquets : `CLR1_projet_pmdo_0812.zip` (1,4 Mo) et `CLR1_calques_png_8px.zip` (11,8 Mo). Pas de runtime, pas de warp.

## AGM3 — Arène de Groudon V3 : colonnes de magma générées (28 septembre 2026)

**Demande** : « je veux que tu génères les colonnes de magma ». Les colonnes d'AGM2 étaient calculées ; en AGM3, **leurs pixels viennent du générateur d'images**. AGM1 et AGM2 sont gardées.

- `renders/arene_groudon_magma_v3/` (préfixe `AGM3`, aperçu `apercu_arene_groudon_magma_v3.html`). Le reste est repris d'AGM2 sans changement : décor, magma visqueux, Ω qui pulse à même le sol, braises. Le build charge celui d'AGM2 et n'en remplace que les colonnes.
- **Brut** : `bruts/colonne_magenta.png` (848 × 1264), généré à partir d'une découpe ×2 de la lave de `Dark_Crater_Pit_TDS.png`. On y voit une colonne organique aux flancs bombés, un cœur blanc-jaune, de la croûte, une gerbe d'éclaboussures et des gouttes, sur fond magenta.
  - Premier essai rejeté et gardé en trace (`colonne_v0_fond_lave.png`) : colonne rectiligne sur fond de lave.
- **Colonnes** : quatre, plus grosses qu'AGM2 (corps d'environ 58 px au fond et 88 px devant). Celles de droite sont en miroir. Elles sortent toujours par le haut de la carte.
- **Animation** (`colonnes_generees.py`, 48 × 5 ticks) :
  - le corps, rendu périodique, monte d'une période par boucle en deux poussées, sans jamais reculer ;
  - la gerbe générée bouillonne par rang de luminance ;
  - les gouttes découpées dans le brut font des vols paraboliques ;
  - la gerbe et les gouttes restent sur le lac, jamais sur la roche.
  - La palette des colonnes compte 32 tons, tous tirés du brut.
- 10 tests PASS, 8 mutations détectées. Paquets : `AGM3_projet_pmdo_0812.zip` (8,5 Mo) et `AGM3_calques_png_8px.zip` (19,3 Mo). Pas de runtime, pas de warp.

## RZD1 — Ruines Zarbi : déchirures dans la réalité (28 septembre 2026)

**Demande** : « une zone de ruine avec des Zarbi qui sortent de déchirures / failles dans la réalité, etc », avec toutes les options recommandées et les références choisies par l'agent.

- `renders/ruines_zarbi_v1/RZD1/` (préfixe `RZD1`, aperçu `apercu_ruines_zarbi.html`). Fin de zone 4:3, arrivée au sud.
- **Références** repérées sur les planches de l'outil maps, puis rendues depuis la ROM (`rom --only D28,D30`) :
  - `D28P44A` donne les matières de la ruine : dalles grises, terre ocre, linteaux sur piliers ;
  - `D30P34A` donne la réalité qui se désagrège : dallage de briques fendu, colonnes brisées, rochers en lévitation.
  - Les noms de lieu ne sont pas affirmés, seuls les codes comptent.
  - Sealed Ruin (D20/D21) avait déjà servi à ERN1 et FRP1.
- **Brut** : un seul rendu, à partir des deux découpes de style ×2, gardé sans édition. Le magenta pur y peint le vide autour du fragment et les cinq failles ; il est remplacé par des calques calculés.
- **Layout** :
  - chemin de dalles depuis le bord sud ;
  - esplanade de briques fendue de cinq failles (`faille`) ;
  - bandes de terre et linteaux à l'ouest et à l'est ;
  - dais et mur de tablettes à glyphes au nord (`autel`) ;
  - tout autour, le vide de la distorsion, où flottent 24 rochers.
- **Loi de la ROM** relevée sur D30P34A : seul le vitrail s'anime, par une animation de palette de 3 rampes de 7 tons (rouge vif → violet sombre → retour), 7 pas de 10 ticks. Appliquée avec les 21 tons natifs :
  - au bord des failles : rampe vive dedans, rampe moyenne au 2e rang, rampe sombre dehors, lueur plus large au pic ;
  - aux crevasses peintes autour : elles se rallument avec un pas de retard tous les 6 px, ce qui fait courir l'énergie.
- **Autres animations** : intérieur des failles en tourbillon (21 pas), vide qui coule avec des étoiles (7 × 30), rochers qui flottent (21 × 10), 30 débris aspirés en spirale (21 × 10).
- **Zarbi** Z A R B I ! ? calculés (`zarbi.py`, 24 px, œil blanc) : chacun sort petit de sa faille avec un halo, en fait le tour avec son ombre, puis y rentre (84 × 5 ticks). La boucle de la scène dure 420 ticks (7 s).
- Fidélité (seuil 35) : briques 12,1, dalles 19,6, linteaux 12,3, terre 15,2, sol complet 13,9.
- 9 tests PASS, 8 mutations détectées. Paquets : `RZD1_projet_pmdo_0812.zip` (2,1 Mo) et `RZD1_calques_png_8px.zip` (6,8 Mo). Pas de runtime, pas de warp.

## EAZ1 — Entrée Zone Zéro : grotte de cristal, fin du réseau (28 septembre 2026)

**Demande** : suite des options recommandées ; map d'entrée du donjon Zone Zéro (Pokémon Paradoxe) au bout du réseau RAZ1 → RAZ2 → RAZ3 → **EAZ1**.

- `renders/zone_zero_v1/EAZ1/` (préfixe `EAZ1`, aperçu `apercu_entree_zone_zero.html`). Référence : `D17P11A`, l'entrée de la grotte de cristal, rendue depuis la ROM par l'outil maps.
- **Layout** : on entre au sud par une brèche ; des pas japonais sinueux mènent à une **géode fendue** au nord-est, dont le cœur est le tunnel du donjon (`donjon`). À l'ouest, une corniche aux flèches de cristal, inaccessible ; à l'est, une plage lumineuse cerclée de rochers (`cercle`).
- **Brut** : premier rendu aux couleurs trop claires et vertes, puis deux éditions de palette. La version gardée a une corrélation des contours de 0,905 avec le premier rendu ; une édition trop terne a été jetée.
- **Loi de la ROM** relevée sur D17P11A : animation de palette des petits amas de cristal (+ 8 par canal et par niveau, plafond 231, 18 pas de 10 ticks). Le tunnel du donjon respire avec la même loi, en phase. S'y ajoutent 26 lucioles aux teintes téra et 40 scintillements. La boucle dure 180 ticks.
- Fidélité (même extraction sur la référence et sur la scène) : sol 8,1, cristaux 17,0, parois 17,1, sol complet 12,4 (seuil 35).
- 7 tests PASS, 7 mutations détectées. Paquets : `EAZ1_projet_pmdo_0812.zip` (1,3 Mo) et `EAZ1_calques_png_8px.zip` (5,1 Mo). Pas de runtime ; les warps du réseau restent à scripter.

## RAZ3 — Réseau Zone Zéro, route 3 : fond cristallin (28 septembre 2026)

**Demande** : « je choisis toutes les options recommandées + 3 routes, choisis les textures de référence pour composer cette zone inédite », dernière route du réseau (RAZ1 → RAZ2 → **RAZ3** → EAZ1).

- `renders/zone_zero_v1/RAZ3/` (préfixe `RAZ3`, aperçu `apercu_route_zone_zero_3.html`).
- **Références composées** (choix de l'agent), toutes vérifiées au pixel près :
  - `D17P34A`, le lac de cristal : matière et loi de l'eau ;
  - `P03P01A` : la loi et la palette des cascades ;
  - `D17P11A`, l'entrée de la grotte de cristal : comparaison de la roche, et référence gardée pour EAZ1.
- Le brut est généré à partir des deux découpes de style ×2, en une seule passe.
- **Layout** :
  - un lac remplit le cratère ;
  - un chemin de sol hexagonal lumineux part du sud et s'ouvre sur une grande place de cristal (`place`) ;
  - le chemin se resserre ensuite par une rangée de dalles plates jusqu'au **tunnel sombre de la paroi nord** (`sortie`, vers EAZ1) ;
  - deux cascades tombent de la paroi de roche bleue dans le lac.
- **Écarts au plan annoncé** : les parois sont en roche bleue incrustée de cristaux, pas en ocre. La sortie est le tunnel de la paroi nord, pas le bord haut.
- **Eau à la loi de la ROM** (relevée sur le rendu animé de D17P34A) : 4 images de 10 ticks, toutes différentes, cycle 0-1-2-3, sans aller-retour ni défilement, 11 à 17 % des pixels changent à chaque image.
  - Recalculée avec les 12 tons exacts de l'eau native : cellules de Worley arrondies q = F1/F2 de 52 × 24 px, dans un domaine déformé par des sinus fixes pour onduler les traits.
  - Chaque centre fait un tour de son petit cercle en 4 phases.
- Les dalles hexagonales plates sont aussi claires que les cristaux : elles sont comptées comme sol par un rectangle mesuré sur le brut, sinon le chemin nord est coupé de la place.
- Fidélité (seuil 35) : sol 10,9, sol complet 9,5, cristaux 31,6. La roche (62,2 contre D17P11A, plus grise) est signalée et non seuillée.
- Scintillements : 90 éclats aux teintes téra sur les cristaux, 12 × 5 ticks.
- 9 tests PASS : tons exacts de la ROM, boucle sans aller-retour ni défilement, décalage exact de 32 px des cascades, un seul sol continu, sortie devant le tunnel. 7 mutations détectées.
- Paquets : `RAZ3_projet_pmdo_0812.zip` (1,6 Mo) et `RAZ3_calques_png_8px.zip` (6,0 Mo). Pas de runtime, pas de warp.
- Suivants : **EAZ1**, l'entrée de la grotte de cristal (D17P11A), puis une **zone de ruines** où des Zarbi sortent de déchirures de la réalité.

## RAZ2 — Réseau Zone Zéro, route 2 : terrasses aux cascades (28 septembre 2026)

**Demande** : « la suite !! », deuxième map du réseau Zone Zéro (RAZ1 → **RAZ2** → RAZ3 → EAZ1).

- `renders/zone_zero_v1/RAZ2/` (préfixe `RAZ2`, aperçu `apercu_route_zone_zero_2.html`). Même référence que RAZ1 : P03P01A, vérifiée au pixel près.
- **Layout** :
  - deux terrasses de prairie séparées par une bande de falaise ocre ; l'**escalier taillé** au centre est le seul passage entre elles ;
  - trois cascades tombent du bord haut dans les bassins de la terrasse haute, et **deux chutes passent par-dessus la falaise du milieu** ;
  - l'abîme occupe le tiers est ; une corniche longe le vide jusqu'aux marches du bord haut (`sortie`, vers RAZ3) ;
  - `belvedere` au bord du vide.
- Le premier rendu laissait la prairie toucher le bord gauche. Il a été corrigé par une édition à un seul changement (bande de buissons) : écart hors zone 10,7, et 0,4 % de pixels à plus de 60.
- `commun.py` : `cascade_frames` accepte maintenant un `y0` (chute qui part du milieu de la carte), toujours à la loi de P03P01A (96 px, 32 px par image, 3 × 10). RAZ1 est inchangée.
- La détection des chutes marche partout, pas seulement au bord haut : eau de chute (bleu vif ou blanc ; les bassins ont B < 100), courses verticales d'au moins 90 px, une composante par chute.
- L'escalier est en pierre ocre : il est compté comme sol par des rectangles mesurés sur le brut et reçoit sa propre palette (la palette commune le verdissait).
- Fidélité : prairie 4,5, sol complet 6,2, falaises 6,0 (seuil 35).
- 10 tests PASS : chutes du milieu qui passent la falaise, décalage exact de 32 px, escalier seul passage (coupé, la sortie devient inaccessible), escalier non verdi, abîme à l'est. 7 mutations détectées.
- Paquets : `RAZ2_projet_pmdo_0812.zip` (2,4 Mo) et `RAZ2_calques_png_8px.zip` (5,6 Mo). Pas de runtime, pas de warp.

## RAZ1 — Réseau Zone Zéro, route 1 : lèvre du cratère (28 septembre 2026)

**Demande** (reprise sur « la suite !! ») : un réseau de routes dans un abîme façon Zone Zéro, avec des cascades, jusqu'à la map d'entrée du donjon Zone Zéro (Pokémon Paradoxe).

- Réseau choisi par défaut, les questions de cadrage étant restées sans réponse : **RAZ1** lèvre du cratère → **RAZ2** terrasses aux cascades → **RAZ3** fond cristallin → **EAZ1** entrée (grotte de cristal). Format 4:3, arrivée au sud, sortie au nord.
- Dossier `source/zone_zero_v1/` : `commun.py` (lois partagées), `reference/` (P03P01A et D17P34A, toutes deux vérifiées au pixel près par l'outil maps), un sous-dossier par map.
- **RAZ1** (`renders/zone_zero_v1/RAZ1/`, préfixe `RAZ1`, aperçu `apercu_route_zone_zero_1.html`) :
  - rendu généré à partir de P03P01A (zone des cascades) ;
  - deux pans d'abîme séparés par une corniche qui descend au nord (`sortie`) ;
  - six cascades dans des bassins, prairie et chemin au sud, `belvedere` au bord du vide ;
  - une édition à un seul changement (bande de buissons) a fermé une sortie latérale : écart hors zone 12,3, 0,75 % de pixels à plus de 60.
- **Cascades à la loi de la ROM** : mesurée sur le rendu animé de P03P01A, avec un motif de 96 px qui descend de 32 px par image, 3 × 10 ticks. Le motif « ikat » est recalculé avec les 14 tons natifs, sans pixels natifs. L'écume (bouillons) et les rides suivent aussi 3 × 10. L'abîme est calculé : brume qui ondule et éclats de cristal lointains, 24 × 10.
- Fidélité : prairie 5,2, sol complet 4,6, falaises 11,3 (seuil 35). Le chemin d'herbe claire est un ton absent de la référence : il est signalé et n'est pas soumis au seuil.
- 10 tests PASS, dont un décalage exact de 32 px entre images, période 96, raccord compris. 7 mutations détectées.
- Paquets : `RAZ1_projet_pmdo_0812.zip` (2,2 Mo) et `RAZ1_calques_png_8px.zip` (5,7 Mo). Pas de runtime, pas de warp (raccord avec RAZ2 à scripter).

## AGM2 — Arène de Groudon V2 : signe à même le sol, colonnes de magma géantes (28 septembre 2026)

**Demande** : « le signe doit pulser directement sur le sol de l'arene pas sur un estrade genere de nouvelle colonne de magma elle doit etre plus grande qu'on en voit pas le bout sur la map et plus impressionnante ».

- Nouveau lot `renders/arene_groudon_magma_v2/` (préfixe `AGM2`, aperçu `apercu_arene_groudon_magma_v2.html`). AGM1 est conservée.
- **Signe au sol** : le brut AGM1 a été édité par le générateur (brut AGM1 en image). Seul changement : le dais disparaît et le Ω, dans son anneau, est gravé à plat dans la pierre, Ø ≈ 250 px contre ≈ 135 px pour AGM1. Écart hors signe : 10,6 de somme RVB moyenne, et 0,12 % de pixels à plus de 60.
  - Le signe fait partie du sol praticable, et le boss se tient au centre du Ω.
  - La pulsation est la même qu'AGM1 (12 × 10 ticks, rouge → jaune vif), mais le halo s'étend sur la pierre : 1 px à partir du niveau 3, 3 px au pic.
- **Colonnes géantes** : nouveau module `source/magma_visqueux/colonnes_geantes.py`. Quatre colonnes de 40 à 56 px de large montent du lac jusqu'au bord haut de la carte : leur sommet n'est jamais visible.
  - La matière monte d'environ 12 px par phase, sur 48 × 5 ticks, et les quatre colonnes sont décalées.
  - Chaque colonne a un cœur jaune, des filets dans l'axe, des plaques de croûte qui montent, des flancs rouge sombre, un contour sombre de 2 px et deux poussées par cycle.
  - Au pied : une gerbe bouillonnante, 14 gouttes avec leurs anneaux d'impact, et des ondes sur le lac.
- Fidélité : sol 13,7, qui monte avec la lueur du signe (seuil 35) ; magma 10,1 (seuil 12).
- 10 tests PASS : signe sur le sol et praticable, halo qui s'étend, chaque colonne touche y = 0 à chaque phase, montée de la matière avec raccord 47 → 0, rien sur la roche sous les bouches, boss atteignable. Les 7 mutations sont détectées.
- Paquets : `AGM2_projet_pmdo_0812.zip` (9,9 Mo) et `AGM2_calques_png_8px.zip` (13,4 Mo). Pixels générés ou calculés, pas de tuiles natives, aucun test dans PMDO.

## FOC1 — Fin Océan : arène de Kyogre sous la mer (28 septembre 2026)

**Demande** : « fait une zone de fin donjon sous l'ocean avec des motif sur toute la zone et des nuance deau des effet de bulle etc une zone ou y'aura kyogre apres etc elle doit etre magnifique ».

- **Référence canonique** : `D42P41A`, rendue par le nouvel outil `source/outil_maps_pmdsky` (copie dans `source/fin_ocean_kyogre_v1/reference/`). C'est un fond marin bleu gravé d'anneaux de bulles et de fissures de corail, avec un anneau de roche bleue et des scintillements multicolores. Aucune map sous-marine jouable n'existe dans PMD Sky ; c'est la plus proche (choix de l'agent).
- Layout : arrivée au sud (`entrance`), grande arène ovale, **sceau de Kyogre** gravé au centre (`sceau`), **fosse abyssale** au nord entourée de corniches en gradins non praticables (`kyogre`, au bord sud de la fosse). Algues et coraux sur les parois. Aucune autre sortie, aucun warp.
- Rendu généré référencé, fosse en magenta (découpe de style ×3 de la référence) ; sol complet généré depuis une découpe du sol (×4).
- Calques, du bas vers le haut : sol complet, abysse, sol, nuances d'eau, motifs lumineux, parois, coraux, algues, bulles, scintillements.
- Animations, toutes fermées sur 240 ticks :
  - **abysse** : tourbillon à 3 bras, 7 tons sombres, 24 × 10 ;
  - **nuances d'eau** : caustiques fines ondulées (F2 − F1, domaine déformé, traits discontinus) + nappes de lumière et d'ombre, 16 × 15 ;
  - **motifs lumineux** : le sceau s'allume, puis une onde part du sceau et parcourt les 13 841 pixels gravés du sol, 24 × 10 ;
  - **algues** : 29 touffes, cisaillement depuis la base fixe, 12 × 20 ;
  - **bulles** : 69 bulles de 18 sources (fosse, évents gravés, algues), naissent, montent en oscillant, éclatent, 48 × 5 ;
  - **scintillements** : 80 étoiles aux 4 teintes de la référence, 12 × 5.
- Fidélité : sol 12.2, sol complet 4.03, parois 30.1 (seuil 35).
- 12 tests PASS. Mutations détectées : couleur étrangère dans l'abysse, bulles figées, base d'algue qui glisse, phase des motifs éteinte, sol au bord nord.
- Aperçu : `apercu_fin_ocean_kyogre_v1.html`. Paquets : `FOC1_projet_pmdo_0812.zip` (2.67 Mo) et `FOC1_calques_png_8px.zip` (7.44 Mo).
- Pixels générés ou calculés, pas de tuiles natives. Kyogre n'est pas placé (marqueur seul). Pas de runtime. Pas dans le mod unique.

## Outil maps PMD Sky — toutes les maps et BG d'Explorers of Sky (28 septembre 2026)

- `source/outil_maps_pmdsky/recuperer_maps.py` (README dans le dossier) :
  - `rom` : les 473 entrées de `bg_list.dat` (pret/pmd-sky épinglé), 468 rendues avec skytemple-files, dont 154 animées (PNG + WebP dans `.cache/maps_pmdsky/rom/`) ;
  - `galerie` : la galerie projectpokemon, catégorie 12. Non testable ici : la sandbox coupe le TLS vers projectpokemon.org ;
  - `identifie` : rattache les captures nommées du dépôt aux codes (26 au pixel près, 4 probables) ;
  - `cherche`.
- **Vérifié** : le préfixe `dNN` n'est **pas** le `DUNGEON_ID` (D04 = Waterfall Cave, D54 = Southern Jungle…). Seules les identifications par capture donnent un nom.
- Versionnés : `index_rom.json`, planches contact JPEG par lettre et `planches/references_zone_zero.jpg`.
- Le réseau de routes Zone Zéro demandé avant FOC1 est commencé depuis (RAZ1, voir plus haut).

## FWC1 — Fin Waterfall Cave : salle du joyau, septième zone de fin de donjon (28 septembre 2026)

**Demande** : « continue ! » après FJS1. La série des fins reprend dans l'ordre du mod : **Waterfall Cave** (entrées EWC1 à EWC3).

- Vraie fin : `Waterfall_Cave_gem_TDS.png`. On y voit un chemin de galets bleus semé de cristaux entre deux bassins, des stalactites sur un fond bordeaux, et un joyau géant au nord. Dans le jeu, il n'y a pas de boss : pousser le joyau déclenche une vague qui emporte les héros jusqu'aux sources chaudes (Bulbapedia, Explorers of Sky, chapitre 5).
- Layout : arrivée au sud par un chemin sombre (`entrance`), chemin de galets et cristaux (`arene`), joyau au nord (`joyau`, à son pied). Les cristaux du sol sont praticables ; le joyau bloque. Aucune autre sortie, aucun warp.
- Rendu généré référencé, eau en magenta, en deux étapes :
  1. décor 4:3 avec la capture : les bassins sortaient en galets (`bruts/decor_magenta.png`, gardé, non utilisé) ;
  2. édition à un seul changement : les bassins gauche et droit passent en magenta (`bruts/decor_magenta_v2.png`).
- Sol complet : galets seuls générés depuis une découpe propre du sol de la capture.
- Calques, du bas vers le haut : sol complet, eau, sol, parois, cristaux, joyau, lueur du joyau, scintillements.
- Animations :
  - **eau** : le réseau de reflets de la capture est calculé. Ce sont des cellules de Worley arrondies (q = F1 / F2, cercles d'Apollonius) et étirées, dans 9 tons exacts de l'eau de la capture. Chaque centre de cellule tourne sur un petit cercle, donc le réseau ondule sur place sans défiler, 24 × 10. La part de traits clairs est celle de la capture (31 % au-dessus de 80 de luminance). Aucun liseré sur les rives.
  - **joyau** : les facettes pulsent vers le rose clair, 24 × 10 ; le contour reste fixe.
  - **cristaux** : 61 étoiles déphasées, 12 × 5.
  - La scène boucle en 4 s.
- Fidélité : galets 17.53, chemin sombre 20.13, sol complet 10.86 (seuil 35) ; eau 3.88 (seuil 15).
- 9 tests PASS. 7 mutations détectées : eau figée une phase, liseré clair, défilement, joyau figé, étoiles éteintes, marqueur loin du joyau, praticable dans l'eau.
- Aperçu : `apercu_fin_waterfall_cave_v1.html`. Paquets : `FWC1_projet_pmdo_0812.zip` (2.21 Mo) et `FWC1_calques_png_8px.zip` (4.53 Mo).
- Pixels générés ou calculés, pas de tuiles natives. Pas de runtime. Pas dans le mod unique.

## FJS1 — Fin Jungle : fond de Southern Jungle, sixième zone de fin de donjon (28 septembre 2026)

**Demande** : « poursuis ! » après FBS1. La série des fins reprend dans l'ordre du mod : **Jungle** (après l'entrée EJN1).

- Vraie fin : `Southern_Jungle_exit_S.png` (PMD Sky, épisode spécial 4 « Here Comes Team Charm! »). On y voit une clairière de sable jaune olive, une pelouse à gauche, un rocher gris au fond, des fougères et des palmes, et une canopée très sombre au premier plan. Le combat de fin n'est pas nommé, car les sources consultées ne s'accordent pas.
- Layout : arrivée au sud par un chemin de sable (`entrance`), grande clairière pour le combat (`boss`), objectif devant le rocher gris au nord (`objectif`). Aucune autre sortie, aucun warp.
- Rendu généré référencé, en trois étapes, toutes avec la capture :
  1. décor 4:3 (sable rose et pelouse fluo, couleurs écartées) ;
  2. recoloration vers le sable et l'herbe de la capture (`bruts/decor_etape_recolore.png`) ;
  3. bord gauche fermé par des buissons, parce que la pelouse touchait le bord et faisait une sortie (`bruts/decor.png`).
- Sol complet : sable seul généré depuis une découpe propre du sable de la capture.
- Calques, du bas vers le haut : sol complet, sable, pelouse, feuilles, rocher, jungle, papillons, canopée.
- Animations :
  - **feuilles** : 14 feuilles tombent de la jungle en se balançant, se posent sur le sable puis s'effacent, 48 × 5. Chaque feuille refait la même chute, donc la boucle est exacte. Elles restent sur le sable (vert sur la pelouse, elles seraient invisibles).
  - **papillons** : poses générées de l'entrée Jungle, 6 vols en huit fermés, 48 × 5.
  - La scène boucle en 4 s.
- Fidélité : sable 19.15 et pelouse 16.82 (seuil 35), mesurées contre la capture.
- Le rocher a sa propre palette de 16 couleurs : dans la palette commune, ses gris viraient à l'olive du sable.
- 9 tests PASS. 7 mutations détectées : rocher olive, feuille sur la pelouse, papillons figés, trou dans la pelouse, objectif loin du rocher, ouverture au nord, loi des feuilles.
- Aperçu : `apercu_fin_jungle_sud_v1.html`. Paquets : `FJS1_projet_pmdo_0812.zip` (1.37 Mo) et `FJS1_calques_png_8px.zip` (4.08 Mo).
- Pixels générés ou calculés, pas de tuiles natives. Pas de runtime. Pas dans le mod unique.

## FBS1 — Fin Bristle : sommet de Mt. Bristle, cinquième zone de fin de donjon (28 septembre 2026)

**Demande** : « continue ! » après FGG2. La série des fins reprend dans l'ordre du mod : **Bristle**.

- Vraie fin : Mt. Bristle Peak, où les héros battent Drowzee pour sauver Azurill (Bulbapedia). La salle n'est disponible qu'en vignette de 110 × 120 px (`source/fin_bristle_sommet_v1/reference/`) : une clairière de sable carrée, fermée de rochers gris en pointes. Elle donne la composition ; les textures viennent de `Mt_Bristle_entrance_TD.png`.
- Layout : arrivée au sud par un couloir de sable entre deux aiguilles (`entrance`), grande clairière pour le boss (`boss`), Azurill au fond nord (`azurill`). Les blocs bruns bloquent. Aucune autre sortie, aucun warp.
- Rendu généré référencé, sans liquide. Deux bruts écartés :
  - la vignette agrandie donnait des rochers flous ;
  - un premier essai au rip seul sortait en 1376 × 768, avec un chemin ouvert au nord.
- Sol complet : sable seul généré depuis une découpe propre du sable du rip.
- Calques, du bas vers le haut : sol complet, sable, rafales, rochers, touffes, falaises.
- Animations :
  - **touffes au vent** : poses et cycle de l'entrée Bristle, 12 × 10, rafale d'ouest ;
  - **rafales de sable** : 44 traînées claires qui naissent, filent vers l'est et s'éteignent, 24 × 5. Chaque traînée refait le même trajet, donc la boucle est exacte.
  - La scène boucle en 2 s.
- Fidélité : sable 13.25 (seuil 35), roche grise 14.75 (seuil 25). Vignette : 35.76, garde-fou large à 45, car elle est floue et désaturée.
- 8 tests PASS. 6 mutations détectées : rafales figées, rafales sur la roche, rafales invisibles, touffes figées, ouverture au nord, Azurill loin du fond.
- Aperçu : `apercu_fin_bristle_sommet_v1.html`. Paquets : `FBS1_projet_pmdo_0812.zip` (1.4 Mo) et `FBS1_calques_png_8px.zip` (4.26 Mo).
- Pixels générés ou calculés, pas de tuiles natives. Pas de runtime. Pas dans le mod unique.

## FGG2 — Fin Givre V2 : sans cristal, aurores boréales au nord (28 septembre 2026)

**Demande** : « Il faut pas de cristal stp et on aurait aimé voir les aurore boreal dans le design texture canonique de la référence adapté a notre layout ». FGG1 est gardée à côté.

- **Layout de FGG1** : couloir au sud (`entrance`), arène (`boss`), deux bassins d'eau glacée. Le cristal et son monticule sont retirés : le sol et le rebord continuent.
  - Le nord s'ouvre sur un ciel de nuit derrière une rangée de pics sombres. Le marqueur `belvedere` est au bord nord de l'arène, face aux aurores. Aucun warp.
- **Décor** : brut de FGG1 édité par le générateur, avec `aurorepmdsky.png` en seconde image. Le ciel est en vert pur (clé), le magenta restant les bassins. Le liseré verdâtre au bord des pics est dé-teinté (G et B échangés).
- **Aurores** : rendu généré référencé. Les rideaux de `aurorepmdsky.png` (y 0–144, ×3) sont régénérés en panorama 2048 × 512, sur le marine même du ciel de la référence, puis réduits à 768 px avec une palette propre de 48 couleurs.
  - Un essai sur fond magenta a été écarté : le magenta des rideaux se confondait avec la clé.
  - Calque propre, 12 phases × 10 ticks, boucle exacte. **Une seule géométrie** : onde verticale des colonnes (3 px, 256 px) qui court le long du ruban, et bande de rayons qui s'allume en glissant (rang +1/+2 dans la rampe de chaque famille de couleur, seuil décalé par colonne).
  - Pas de défilement, pas de poses déphasées, pas de cycle de palette global. L'aurore n'est visible que dans le ciel.
- **Ciel** (fixe, 3 couleurs relevées dans la référence, tramage 2 × 2) et **étoiles** (36, pixel (247, 255, 255) et halo de la référence, 12 × 10) sur des calques séparés.
- Eau glacée, reflets et flocons : ceux de FGG1 (entrée Givre).
- Fidélité : sol 2.26 (seuil 35) ; aurore entière 12.34 à la référence (seuil 30), part vert-cyan 0.58 contre 0.55. La partie visible est plus magenta (0.44), car les franges cyan passent sous les pics.
- 13 tests PASS. 5 mutations détectées : aurore figée, qui défile, qui déborde sur le terrain, boucle ouverte, cristal de FGG1 recollé.
- Aperçu : `apercu_fin_givre_aurore_v2.html`. Rendus : `renders/fin_givre_aurore_v2/`. Source : `source/fin_givre_aurore_v2/`.
- Paquets : `FGG2_projet_pmdo_0812.zip` (1.78 Mo, préfixe `FGG2`) et `FGG2_calques_png_8px.zip` (5.93 Mo).
- Pixels générés, pas de tuiles natives (sauf les reflets de Métano recolorés). Pas de runtime. Pas dans le mod unique.

## ZRV2 — correction des nuages et des lignes figées de la mer (28 septembre 2026)

**Demande** : « corrige les nuage et regarde la mer y'a deja des mouvement statique que tu dois animée ».

- **Nuages** : trois bancs générés différents sont raccordés bout à bout sur 768 px. Aucun nuage ne revient à l'écran, les sommets sont arrondis, et aucun nuage n'est rogné. Ils défilent derrière la montagne : période 768, pas de 2 px, 16 ticks, 384 phases.
- **Ondes** : les lignes de houle et les plaques claires peintes dans la mer ont leur propre calque (13 629 px, 137 motifs). Chacune suit l'orbite de l'eau au rythme de la houle ; la mer de fond est rebouchée avec son grain.
- Soleil couchant remonté à (560, 44).
- PNG de phases indexés (`save_png`) : le pack PNG passe d'environ 150 Mo à 44 Mo.
- **18 tests PASS**. 6 mutations détectées : ondes figées, mer non rebouchée, bande de 256 px répétée, `CLOUD_PERIOD` à 256, orbite nulle, banc A non coupé.
- Paquets : PMDO 11.51 Mo, PNG 44.25 Mo, aperçu 7.16 Mo.

## ECM1 + AGM1 — Entrée Cratère magma (Dark Crater V2) et arène de Groudon, magma visqueux (28 septembre 2026)

**Demande** : « Je veux un entrée de map avec magma dark crater des cascade de lave / et une arène avec des colonne de lave magma qui jaillis à côté de l'arène au centre avec le symbole de groudon qui pulse sur l'arène », puis « faut que le magma de la sone bouge de manière visqueuse ». La série des fins (Bristle) est en pause.

- **Module partagé** `source/magma_visqueux/` : `magma.py` (magma, cascades, colonnes) et `ground.py` (Ground 0.8.12 paramétrable). Les deux cartes bougent de la même façon.
  - **Magma visqueux** (32 × 15 ticks, 8 s) : bruit de Worley périodique, étiré à l'horizontale comme la lave de `Dark_Crater_Pit_TDS.png`. La rampe de 11 tons est relevée sur cette lave, plus deux croûtes de ECN1.
  - La matière dérive lentement : une période de 96 px vers le sud par boucle, soit 3 px par phase. Elle se plie (deux ondes lentes) et gonfle (bosses qui éclaircissent).
  - Des plaques de croûte sombre voyagent avec elle. Elles fondent près des cascades et figent près des rives. Des rides s'éloignent des pieds de cascade et des évents.
  - **Cascades** (32 × 15) : la même matière, étirée ×2,5, descend de 7,5 px par phase. La lame serpente, bordée d'une croûte qui roule.
  - **Colonnes** (48 × 5) : jet procédural (bouche qui palpite, jaillissement, colonne, couronne, gouttes, anneau). Les évents sont décalés.
- **ECM1 — Entrée Cratère magma** (`renders/entree_cratere_magma_v1/`, aperçu `apercu_entree_cratere_magma_v1.html`). L'entrée Cratère V1 (ECN1) reste intacte.
  - Décor généré avec `Dark_Crater_entrance_TDS.png` en référence : mares en magenta, cascades en vert pur.
  - Une cascade de chaque côté de la grotte nourrit une mare le long du chemin de cendre. Quatre colonnes jaillissent des mares.
  - Derrière chaque cascade, la roche est regarnie en miroir de la falaise voisine, dans le calque non praticable.
  - Marqueurs `entrance` et `donjon_seuil`. Fidélité : cendre 9.28 (seuil 35), magma 8.89 (seuil 12).
- **AGM1 — Arène de Groudon** (`renders/arene_groudon_magma_v1/`, aperçu `apercu_arene_groudon_magma_v1.html`).
  - Décor généré avec `Dark_Crater_Pit_TDS.png` en référence, lave en magenta. Dais rond au centre, gravé du **Ω de Primo-Groudon**.
  - Les lignes du symbole pulsent du rouge au jaune vif (12 × 10), avec un halo au pic. Quatre colonnes jaillissent de part et d'autre de l'arène, à hauteur du dais, en alternance.
  - Marqueurs `entrance`, `boss` (sur le Ω) et `heros` (devant le dais). Le dais est bloquant. Fidélité : sol 4.64, magma 9.7.
  - Dans Explorers of Sky, Groudon se combat au sommet de Steam Cave : l'association avec Dark Crater est un choix de la demande.
- Tests : 10 PASS par lot. Mutations : 6 détectées sur ECM1, 7 sur AGM1.
- Paquets : `ECM1_projet_pmdo_0812.zip`, `AGM1_projet_pmdo_0812.zip`, plus les ZIP de calques. Le calque magma est lourd : 69355 et 113585 tuiles pour 32 phases.
- Pixels générés ou calculés, aucune tuile native. Pas de runtime. Pas encore dans le mod unique.

## FGG1 — Fin Givre : Frosty Grotto, quatrième zone de fin de donjon (28 septembre 2026)

**Demande** : « Parfait lance toi ! » après FRP1. Quatrième fin de la série, dans l'ordre du mod : **Givre**.

- Vraie fin : Articuno attend les héros à l'étage 5 de Frosty Grotto, la grotte dont l'entrée Givre (EGN1) montre la bouche au nord. Cette salle n'est disponible qu'en vignette de 120 px (`source/fin_givre_grotte_v1/reference/`, mysterydungeonwiki) : elle donne la palette. Les textures viennent de l'arène de glace de PMD Sky (`pmdskyicearena.png`).
- Layout : arrivée au sud par le couloir de glace (`entrance`), grande arène de glace avec un bassin d'eau glacée de chaque côté (`boss`), grand cristal de glace au nord (`cristal`). Aucune sortie, aucun warp.
- Rendu généré référencé : décor sur magenta (les bassins) ; sol seul généré à partir d'une découpe du sol de l'arène de PMD Sky.
- Calques, du bas vers le haut : eau glacée, reflets ; sol complet, sol de glace, parois, cristal ; lueur du cristal, flocons.
- L'eau glacée (4 × 10 ticks), les reflets de Métano recolorés (4 × 10) et les flocons générés (48 × 5, 64 émetteurs) reprennent les fonctions et les poses de l'entrée Givre. Les facettes du cristal pulsent (6 × 10). La scène boucle en 4 s.
- Fidélité du sol : 1.5 à l'arène de PMD Sky, 31.12 à la vignette de la vraie salle (seuil 35).
- Aperçu : `apercu_fin_givre_grotte_v1.html`. Rendus : `renders/fin_givre_grotte_v1/`. Source : `source/fin_givre_grotte_v1/`.
- 10 tests PASS, 6 mutations vérifiées.
- Paquet : `FGG1_projet_pmdo_0812.zip` (Ground 0.8.12, préfixe `FGG1`) et `FGG1_calques_png_8px.zip`.
- Pixels générés, pas de tuiles natives (sauf les reflets, pixels de Métano recolorés). Pas de runtime. Pas encore dans le mod unique.
- Fin suivante : Bristle.

## FRP1 — Fin Ruine : fosse de Sealed Ruin, troisième zone de fin de donjon (28 septembre 2026)

**Demande** : « Choisis ! » après FCF1. L'agent a poursuivi la série dans l'ordre du mod : **Ruine**, d'après la vraie fin du jeu, `Sealed_Ruin_pit_TDS.png`.

- Layout : arrivée au sud entre deux rochers plats (`entrance`), arène de grands blocs gris (`boss`), **Clé de voûte étrange** dans la niche nord (`cle_de_voute`, devant la pierre). Dans le jeu, les héros la trouvent au fond de Sealed Ruin et elle se révèle être Spiritomb. Aucune sortie, aucun warp : la pierre ferme la niche (testé sur la grille de collision).
- Rendu généré référencé : blocs sur sol magenta, clé de voûte sur magenta. Le sol seul est revenu vide deux fois avec la capture entière ; il a été généré à partir d'une découpe serrée du sol de la capture (coordonnées dans le manifeste).
- Calques, du bas vers le haut : sol complet, ombre des parois ; aura, tourbillons ; parois, clé de voûte ; fissure, feux follets.
- La fissure pulse en violet et une aura tramée respire au sol (6 × 10 ticks, pulsation des braises de ECN1). Trois feux follets montent de la pierre à tour de rôle (24 × 5). Les tourbillons de poussière reprennent les poses de l'entrée Ruine (ERN1), recolorées en gris (8 × 5). La scène boucle en 2 s.
- Fidélité à la capture : sol 10.44, parois 0.75 (seuil 35).
- Aperçu : `apercu_fin_ruine_puits_v1.html`. Rendus : `renders/fin_ruine_puits_v1/`. Source : `source/fin_ruine_puits_v1/`.
- 10 tests PASS, 6 mutations vérifiées.
- Paquet : `FRP1_projet_pmdo_0812.zip` (Ground 0.8.12, préfixe `FRP1`) et `FRP1_calques_png_8px.zip`.
- Pixels générés ou dessinés par programme, aucune tuile native. Pas de runtime. Pas encore dans le mod unique.
- Fin suivante : Givre.

## FCF1 — Fin Cratère : fosse de Dark Crater, deuxième zone de fin de donjon (28 septembre 2026)

**Demande** : « passons à la suite » après FVS1. Deuxième fin de la série, dans l'ordre du mod : **Cratère**, d'après la vraie fin du jeu, `Dark_Crater_Pit_TDS.png`.

- Layout : arrivée au sud par la pointe du plateau (`entrance`), grand plateau de pierre au milieu de la lave (`boss`), emblème de feu sur le rebord nord (`embleme`). Aucune sortie, aucun warp.
- Rendu généré référencé : décor sur magenta (la lave). Le générateur a renvoyé deux réponses vides pour le sol seul : `sol_complet` est donc une plage de sol du décor répétée en miroir (documentée dans le manifeste et testée).
- Calques, du bas vers le haut : lave, éclats, bulles ; sol complet, sol du plateau, rebord, pitons, emblème ; lueur.
- La lave (4 × 10 ticks), les éclats de Métano recolorés (4 × 10) et les bulles de lave (24 × 5) reprennent les fonctions et les poses de l'entrée Cratère (ECN1). La lueur fait pulser les jaunes de l'emblème et les braises du rebord (6 × 10 ticks, méthode des braises de ECN1). Les anneaux rouges de l'emblème restent fixes. La scène boucle en 2 s.
- Fidélité du sol à la capture : 2.18 (seuil 35).
- Aperçu : `apercu_fin_cratere_fosse_v1.html`. Rendus : `renders/fin_cratere_fosse_v1/`. Source : `source/fin_cratere_fosse_v1/`.
- 9 tests PASS, 5 mutations vérifiées.
- Paquet : `FCF1_projet_pmdo_0812.zip` (Ground 0.8.12, préfixe `FCF1`) et `FCF1_calques_png_8px.zip`.
- Pixels générés, pas de tuiles natives (sauf les éclats, pixels de Métano recolorés). Pas de runtime. Pas encore dans le mod unique.
- Fin suivante : Ruine (`Sealed_Ruin_pit_TDS.png`).

## FVS1 — Fin Vapeur : sommet de Steam Cave, première zone de fin de donjon (28 septembre 2026)

**Demande** : « Fait des zone fin de donjon multicalque de la série entrée on passe au fin », puis « Lance toi ». Les questions sur la portée, le layout et la référence sont restées sans réponse, donc l'agent a choisi :

- une fin par biome de la série, dans l'ordre du mod, **Vapeur d'abord** ;
- la référence est la **vraie fin du jeu**, `Steam_Cave_Peak_TDS.png`, jamais prise dans la série ;
- layout : arrivée au sud par le couloir qui sort du donjon, grande arène (marqueur `boss`), source chaude au nord (marqueur `source`), sans sortie ni warp.

Rendu généré référencé : décor sur magenta (la source), sol seul, planche de 7 poses de vapeur. Calques, du bas vers le haut :

- eau de la source, bulles ;
- sol complet, sol de l'arène, margelle, évents, stalagmites ;
- vapeur.

L'eau (4 × 10 ticks) et les bulles (24 × 5) reprennent les fonctions et les poses de l'entrée Vapeur V2 : la fin ressemble à son entrée. Les trois évents crachent à tour de rôle des panaches d'environ 100 px, et des volutes montent de la source (24 × 5 ticks). La scène boucle en 2 s.

- Fidélité du sol à la capture : 7.05 (seuil 35).
- Aperçu : `apercu_fin_vapeur_sommet_v1.html`. Rendus : `renders/fin_vapeur_sommet_v1/`. Source : `source/fin_vapeur_sommet_v1/`.
- 9 tests PASS, 5 mutations vérifiées.
- Paquet : `FVS1_projet_pmdo_0812.zip` (Ground 0.8.12, préfixe `FVS1`) et `FVS1_calques_png_8px.zip`.
- Pixels générés, pas de tuiles natives. Pas de runtime. Pas encore dans le mod unique.
- Fins suivantes prévues, dans l'ordre du mod : Cratère (`Dark_Crater_Pit_TDS.png`), Ruine (`Sealed_Ruin_pit_TDS.png`), Givre, Bristle, Jungle (`Southern_Jungle_exit_S.png`), Waterfall Cave, Underground Lake, Mystifying Forest, Sables mouvants, Star Cave, Clairière tropicale, Couloir violet, Mt. Thunder, Jardin secret.

## ZRV2 — Zone de réveil V2 : la mer de V24P04A, montagne et nuages sur leurs propres calques (27 septembre 2026)

- Aperçu : `apercu_zone_reveil_prairie_horizon_v2.html`. Boutons jour, aube, crépuscule et nuit, rejoué à 60 ticks/s, avec collisions et zoom sur l'horizon.
- Lot : `renders/zone_reveil_prairie_horizon_v2/`. Il contient `ZRV2_projet_pmdo_0812.zip` (quatre Grounds), `ZRV2_calques_png_8px.zip` et un README détaillé.
- Source : `source/zone_reveil_prairie_horizon_v2/`, 17 tests PASS, 5 mutations vérifiées.

**Demande de l'utilisateur** :

- « regarde l'animation de la mer V24P04A et des nuages, c'est ce que je te demandais pour la zone réveil » ;
- zone multicalque : la mer sur son propre calque, le ciel, les nuages et la montagne séparés ;
- montagne « raccordée logiquement à l'horizon » ;
- animer les nuages déjà présents, sans en ajouter ;
- fleurs animées comme à Sky Peak ;
- reflet de la lune sur la mer, animé logiquement.

Puis : « garder le layout de la v1, juste corriger la mer et le background, laisser la montagne, mais les nuages derrière la montagne : la mer ⇒ montagne ⇒ nuage ».

**Réponses aux questions** : la mer est générée avec V24P04A en référence ; c'est une nouvelle version, et ZRV1 est gardée.

- **Layout de ZRV1, inchangé** (test) : prairie, masque de mer, collisions, `reveil` (376, 240), `entrance` (384, 560).
- **17 calques**, avec la profondeur demandée :
  - ciel, puis étoiles, puis lune ou soleil ;
  - ensuite les **nuages**, puis la **montagne**, puis la **mer** ;
  - puis scintillement, houle, reflet et écume ;
  - enfin la prairie (herbe, chemin, fleurs, rochers, buissons) et le Top.
- **Bruts générés** avec V24P04A en référence : ciel et mer, planche de crêtes, banc de nuages, astres. La montagne de ZRV1 a été redessinée seule, à partir de son recadrage.
- **Lois de V24P04A** relevées dans la ROM :
  - houle en 12 crans de 10 ticks : les crêtes naissent en houle sombre à 40 px sous l'horizon, grandissent en descendant selon `y(u) = 156 + 40u + 4u²` et suivent un motif de 96 px ;
  - scintillement de l'horizon en 16 crans de 4 ticks.
- **Nuages** : banc de 256 px posé sur l'horizon, qui glisse de 1 px par cran (256 × 8 ticks), toujours derrière la montagne (test).
- **Montagne** : ses flancs sont prolongés en pente jusqu'à l'horizon, sans bord vertical (test). Les petits pics sombres de ZRV1 ne sont pas repris.
- **Reflet** : colonne de traits sous la lune (nuit) ou le soleil (aube), qui ondule au rythme de la houle. Les crêtes qui la traversent prennent la couleur de l'astre. La lune se lève derrière le sommet.
- **Fleurs** : cycle A B A C du GIF Sky Peak, en 4 phases de 12 ticks.
- **Aube et nuit** : couleurs reprises des bruts de ZRV1. À l'aube, le ciel suit le dégradé de ZRV1 ligne par ligne.
- Pixels générés, pas de tuiles natives. Pas de runtime. **Pas dans le mod unique.**

**Ajustements après validation de l'ensemble** : « faut que tu passes le reflet de la lune et crépuscule au générateur », « que les nuages soient pas crop », « les mouvements des vagues, y'a des interstices entre elles, faut quelque chose de plus logique », « faut aussi un crépuscule », « les écume et bulle de la v1 sont bien », puis « les nuages doivent être arrondis en haut, y'a des crops de nuage ! … et faut le mouvement de la mer de PMD ».

- **Quatrième ambiance, crépuscule** (banques `ZRV2C_`).
  - La prairie vient d'une édition générée du décor de ZRV1, recalée au pixel près (meilleur décalage (0, 0)).
  - Ciel du violet à l'orange, soleil couchant à demi derrière le banc, reflet rouge orangé.
- **Reflets générés** : une planche de trois colonnes (lune, aube, crépuscule). Chaque trait est replacé sous l'astre et ondule avec la houle.
- **Nuages sans rognure** : nouveau banc généré, entier. Le seul sommet plat que le générateur avait coupé (70 px) est arrondi en dôme parabolique.
  - La coupe de la boucle se fait là où les silhouettes se raccordent, avec un fondu des teintes seules.
  - Des tests vérifient l'absence de plateau de plus de 10 px et de colonne isolée.
- **Mouvement de la mer de PMD** : les 12 images de la houle de V24P04A ont été décodées depuis `pret/pmd-sky` (BMA, BPC, BPL, BPA) : `references/v24p04a_12_crans_bpa.png`.
  - Une crête y avance d'une rangée en 6 crans (5 à 8 px par cran), sans décalage horizontal.
  - Elle naît en ligne sombre sous l'horizon, puis devient une double bosse blanche. ZRV2 suit cette cadence.
- **Vagues sans interstices** : crêtes de 78 px sur un motif de 96 px (comme V24P04A), plus une ligne de houle continue de 1 px sous chaque rangée.
- **Écume et bulles de ZRV1** reprises telles quelles ; au crépuscule, même méthode.
- Montagne gardée à sa taille.

## ZRV1 — Zone de réveil : la prairie de Sky Peak face à l'océan, jour, aube et nuit (27 septembre 2026)

- Aperçu : `apercu_zone_reveil_prairie_horizon_v1.html`. Boutons jour, aube et nuit, rejoué à 60 ticks/s, avec collisions et zoom.
- Lot : `renders/zone_reveil_prairie_horizon_v1/`. Il contient `ZRV1_projet_pmdo_0812.zip` (trois Grounds), `ZRV1_calques_png_8px.zip` et un README détaillé.
- Source : `source/zone_reveil_prairie_horizon_v1/`, 12 tests PASS.

**Demande de l'utilisateur** : la zone de départ où le Pokémon se réveille.

- Une grande prairie à la Sky Peak, une « falaise sans relief » et une « entrée immersive » sur l'océan en contrebas, « comme la mer animée dans PMD Sky ».
- L'écume et les bulles de la mer qui arrive au pied de la prairie.
- Les cimes et la mer de nuages à l'horizon, avec des nuages qui passent.
- Le jour et la nuit.
- « C'est la première scène du jeu. »

**Réponses aux questions** : promontoire ; réveil au bord face à l'océan et sortie au sud ; jour, aube et nuit (**l'aube est un ajout**).

- **Trois bruts de décor**, générés avec la frame 0 du GIF Sky Peak, `232233.png` et la mer de s01p02a en référence. La nuit et l'aube sont des éditions du jour, recalées au pixel près, donc mêmes masques et mêmes collisions. Distance au rip : herbe 9,2, fleurs 22,4.
- **Mer de PMD Ciel** : couleurs et cadence exactes de s01p02a (palettes 7 et 8, 10 crans de 10 ticks).
  - La crête blanche avance vers la prairie.
  - Les bandes vont de 16 px à l'horizon à 44 px au rivage. Ce motif est le nôtre ; les couleurs et la cadence sont natives.
  - À l'aube et la nuit, les couleurs sont transposées, avec le reflet lissé du soleil ou de la lune.
- **Écume et bulles animées** au pied du promontoire : c'est l'exception demandée à la règle « pas de liseré blanc ».
  - Scintillements : 12 reflets le jour, 92 paillettes à l'aube, 9 étoiles la nuit.
  - Nuages qui passent : deux rangées en parallaxe, boucle de 192 × 8 ticks.
- `reveil` en (376, 240), face au nord ; `entrance` en (384, 560). Aucun warp.
- Pixels générés, pas de tuiles natives, sauf les couleurs de la mer et de l'écume. 5 mutations vérifiées. Pas de runtime. **Pas encore dans le mod unique.**

## EJS2 — Jardin secret V2 : le temple miniature de Celebi sur la souche (27 septembre 2026)

- Aperçu : `apercu_entree_jardin_secret_sud_nord_v2.html`.
- Lot : `renders/entree_jardin_secret_sud_nord_v2/` (`EJS2_projet_pmdo_0812.zip`, `EJS2_calques_png_8px.zip`, README détaillé).
- Source : `source/entree_jardin_secret_sud_nord_v2/`, 13 tests PASS.

**Demande de l'utilisateur** : « Je veux un petit temple miniature qui tiens sur la buche celebi gardien secret », puis « lance la suite ! ». **Choix de l'agent, à confirmer** (les questions ont été passées) : nouvelle version (EJS1 intacte) ; la porte du temple devient l'entrée du donjon ; Celebi est un emblème lumineux sur le fronton, pas un sprite.

- **Un seul brut nouveau** : `decor_temple.png`, généré avec le décor d'EJS1 **et** la capture `secretgarden.png` en référence. Seule la zone du temple (9227 px autour de la souche) est collée ; ailleurs, le décor est celui d'EJS1 au pixel près (test).
- **Temple** : toit vert, piliers de bois, socle de pierre posé sur la souche. Sa porte sombre est bloquée, et `donjon_seuil` (376, 120) est sur le parvis juste dessous. Les marches de la souche y mènent depuis la prairie.
- **Emblème de Celebi animé** : il s'éclaire de 3 crans jusqu'au blanc sur la rampe exacte du rayon de la capture, puis revient. Boucle de 24 × 5 ticks, symétrique et fermée (test). Le rayon et les lucioles sont ceux d'EJS1 ; deux lucioles qui tombaient sur le toit ont été déplacées.
- Les distances au rip des calques finaux sont toutes sous 35. Ce sont des pixels générés, pas des tuiles natives. 4 mutations vérifiées. **EJS2 est ajoutée au mod unique (19 cartes)**, marquée « à confirmer ».

## Mod PMDO unique — les entrées de donjon sud → nord (27 septembre 2026)

- Mod : `renders/mod_guilde_entrees_v1/guilde_entrees_sud_nord_pmdo_0812.zip` (27 Mo, version 1.1.0.0 depuis l'ajout d'EJS2), namespace `guilde_entrees_sud_nord`.
- Galerie : `apercu_mod_guilde_entrees_v1.html` (une vignette par carte, lien vers son aperçu animé) ; planche `renders/mod_guilde_entrees_v1/planche_cartes.png`.
- Source : `source/mod_guilde_entrees_v1/` (`build_mod.py`, `test_mod.py`).

**Demande de l'utilisateur** : « BEAU TRAVAIL JE VALIDE PREPARELE MOD AVEC TOUTE CES CARTE ET LANCE LA SUITE ! ». La série est **validée par l'utilisateur** (sur les aperçus ; toujours aucun test en jeu).

Le mod regroupe les 18 Grounds de la série (ESN1, ESN2, ECN1, ERN1, EGN1, EBN1 en portrait 424 × 632 ; EJN1, EWC1-3, EUL1, EMF1, EQS1, ESC1, ETC1, ECV1, EMT1, EJS1 en 4:3 768 × 576). Les 219 banques `.tile` et les Grounds sont copiés **octet pour octet** depuis les ZIP projets versionnés des lots ; l'index des tuiles est fusionné ; les scripts de carte passent sous le namespace commun, sans changement. ZIP reproductible (horodatages fixes). Depuis, **EJS2** a été ajoutée : 19 cartes, 235 banques, EJS2 notée « à confirmer » dans le manifeste. 6 tests PASS, dont une installation complète dans un mod existant (simulation, installation, réinstallation sans effet, carte éditée protégée) ; 3 mutations vérifiées.

## Étude — animations canoniques d'eau et de magma (PMD Ciel) et leur portage PMDO (27 septembre 2026)

- Aperçu : `apercu_etude_animations_canoniques_sky_v1.html` : piste exacte et piste du port rejouées côte à côte, avec la formule du moteur.
- Lot : `renders/etude_animations_canoniques_sky_v1/` (rapport, inventaire des 110 cartes à palette animée, WebP à la vraie vitesse, cycles de palette, audits).
- Source : `source/etude_animations_canoniques_sky_v1/`. **Étude, pas une carte de la série.**

**Demande de l'utilisateur** : « regarde les animations canoniques des maps magma / de l'eau, par exemple sur la map S01P02A » (`meromoonmeri/PMD-SKY-PMDO-PORT`).

- **Mécanique**, lue dans les fichiers de la ROM (`pret/pmd-sky`) : l'eau et la lave sont des **rotations de palette**. Les pixels restent fixes, 15 couleurs tournent par crans, chaque palette avec sa durée en frames. Les tuiles animées (BPA) ont leurs propres durées.
  - s01p02a : mer 10 crans × 10 frames, fleurs en BPA 4 crans × 12.
  - Magma d41p41a : 13 crans × 10.
  - Magma v03p08a : 10 × 12, dont un aller-retour, et 20 × 8.
- **Moteur** : RogueEssence joue `totalTick / FrameLength % frames`, à 60 i/s comme la DS. Une piste est donc exacte si `FrameLength` = durée NDS et si ses frames gardent leurs répétitions.
- **Audit du port** : ses pistes sont l'aperçu skytemple à pas égaux, dédoublonné case par case, avec `FrameLength` 10 partout (prouvé par test). Résultats :
  - mer de s01p02a juste à 97 %, mais fleurs fausses 65 % du temps ;
  - lave de d41p41a fausse **89 %** du temps ;
  - lave de v03p08a fausse **72 %** du temps.

  Les pistes exactes, recalculées case par case, sont vérifiées tick par tick.
- **Pour nos cartes** : s01p03a, la capture d'ETC1, a la même animation de palette que s01p02a. La mer d'ETC1 n'est donc pas l'animation canonique.

9 tests PASS ; 4 mutations vérifiées. Pas de test dans PMDO.

## Entrée Jardin secret — 4:3, prairie fleurie, souche à marches sous un rayon de lumière (27 septembre 2026)

- Aperçu : `apercu_entree_jardin_secret_sud_nord_v1.html`, listé en tête par le serveur d'aperçus (`python3 source/serveur_apercus/serve.py`, port 8000).
- Lot : `renders/entree_jardin_secret_sud_nord_v1/` (`EJS1_projet_pmdo_0812.zip`, `EJS1_calques_png_8px.zip`, ORA, WebP animé, planche de la rampe).
- Source : `source/entree_jardin_secret_sud_nord_v1/`.

**Demande de l'utilisateur** : « Lance la suite ! ». Carte suivante de la série ; l'agent a choisi le biome **jardin secret** (`secretgarden.png`), **à confirmer**. Cette capture n'avait jamais servi à une entrée de la série, seulement à d'anciens lots sur `01a0d315` et `01a0d4b6`, dont rien n'est repris. Après EJS1, seule `oldcastlepmd` (un intérieur) reste libre partout.

Méthode des textures canoniques = **rendu généré référencé**, la capture en référence : décor complet (premier essai, conforme), témoin sans objets édité depuis le décor (segmentation seulement), sol d'herbe complet édité depuis le témoin (troisième essai ; deux essais écartés à 43,2 et 45,7, gardés dans `bruts/ecartes/`).

L'arrivée est au sud, par une allée entre deux haies. Elle ouvre sur une grande prairie fleurie semée d'arbres et de rochers, bordée de haies, jusqu'aux marches d'une souche dorée, au nord, sous un rayon de lumière verte.

14 calques : sol complet, prairie, herbe, ombres, fleurs, rochers, arbres, haies, souche, marches, profondeur, fond, rayon, lucioles. Deux animations de 24 × 5 ticks (2 s) :

- **rayon** : chaque pixel du faisceau généré prend le cran le plus proche sur la **rampe exacte des 22 verts du rayon de la capture**, puis « respire » de ± 2 crans ; bords sombres atténués ;
- **lucioles** : 10 points aux couleurs exactes du rayon qui montent en ondulant, surtout dans le faisceau.

Boucles fermées (testé). Fidélité au rip : fond 9,9, herbe claire 8,7, herbe 8,5, roche 20,1 sur le brut ; calques finaux ≤ 30,5 (prairie, la plus jaune ; seuil 35). 11 tests PASS ; 8 mutations vérifiées. Pas de test PMDO en jeu.

## Entrée Mt. Thunder — 4:3, sommet d'orage au-dessus des nuages, éclairs de la planche (27 septembre 2026)

- Aperçu : `apercu_entree_mt_thunder_sud_nord_v1.html`, listé en tête par le serveur d'aperçus (`python3 source/serveur_apercus/serve.py`, port 8000).
- Lot : `renders/entree_mt_thunder_sud_nord_v1/` (`EMT1_projet_pmdo_0812.zip`, `EMT1_calques_png_8px.zip`, ORA, WebP animé, planche des sprites).
- Source : `source/entree_mt_thunder_sud_nord_v1/`.

**Demande de l'utilisateur** : « Continue ! Très bon travail ». Carte suivante de la série ; l'agent a choisi le biome **sommet d'orage (Mt. Thunder)**, **à confirmer**. Relevé sur les 97 images de la racine : plus aucune n'est libre partout, sauf `oldcastlepmd` (un intérieur). La planche de Mt. Thunder (*Red Rescue Team*) n'a jamais servi à une entrée de la série. Elle n'a servi qu'au lot hors série `mt_thunder_orage_v1`, sur trois anciennes branches, dont rien n'est repris.

Méthode des textures canoniques = **rendu généré référencé**, la planche en référence : décor complet (premier essai, conforme) et sol de sable complet. Les nuages sont mesurés **par ton**, parce qu'une moyenne unique de tons discrets dépendait des proportions (41,3, mesure écartée et gardée dans le manifeste).

L'arrivée est au sud, sur une crête de sable qui sort des nuages. Elle monte vers un grand plateau bordé de falaises, coupé par un gradin ouvert au centre, jusqu'à la grotte d'un piton rocheux au nord. Mer de nuages d'orage autour.

12 calques : sol complet, sable, cailloux, pics, falaise, piton, seuil, profondeur, ciel, nuages, lueurs, éclairs. Deux animations de 48 × 5 ticks (4 s) :

- **éclairs** : les 4 éclairs **copiés pixel par pixel de la planche**, en « Normal » (240,240,0) pendant 2 phases puis en « Fading » (160,152,32) pendant 2 phases. Six frappes par boucle ; l'éclair 1 à gauche seulement, les éclairs 2 à 4 aussi en miroir à droite, comme l'indique la planche ;
- **lueurs** : l'arc « Flash » exact de la planche s'allume sur les nuages au pied de chaque éclair.

Boucles fermées (testé). Fidélité au rip : sable 4,0, roche 6,8, ciel 7,4, nuages sombres 19,5, nuages clairs 13,5 sur le brut ; tous les calques finaux ≤ 16,6 (seuil 35). 10 tests PASS ; 6 mutations vérifiées. Pas de test PMDO en jeu.

## Entrée Couloir violet — 4:3, couloir rocheux qui s'ouvre sur une grande salle (27 septembre 2026)

- Aperçu : `apercu_entree_couloir_violet_sud_nord_v1.html`, listé en tête par le serveur d'aperçus (`python3 source/serveur_apercus/serve.py`, port 8000).
- Lot : `renders/entree_couloir_violet_sud_nord_v1/` (`ECV1_projet_pmdo_0812.zip`, `ECV1_calques_png_8px.zip`, ORA, WebP animé, planche des poses).
- Source : `source/entree_couloir_violet_sud_nord_v1/`.

**Demande de l'utilisateur** : « Push et passe a la prochaine ! ». ETC1 était déjà poussé ; carte suivante de la série. L'agent a choisi le biome **couloir rocheux violet**, **à confirmer**. La capture `large.S05P03A…png` (sol mauve marbré, rochers empilés bleu-violet, falaises striées ; jeu et scène non confirmés) n'est citée par aucun lot : 0 occurrence sur les 72 branches (`git grep -F`, inventaires exclus).

Méthode des textures canoniques = **rendu généré référencé**, la capture en référence pour les trois bruts : décor complet (premier essai, conforme), sol complet, planche de nuages de poussière.

L'arrivée est au sud, par un couloir étroit entre deux parois de rochers. Il s'ouvre sur une grande salle semée de huit amas de rochers, jusqu'à un tunnel sombre sous une arche de rochers, au nord. Falaises striées au fond.

11 calques : sol complet, sol, ombres (au pied des parois et des blocs), gravillons, blocs, rochers, falaise, vide, profondeur, éboulis, poussière. Deux animations de 24 × 5 ticks :

- **éboulis** : trois gravillons **relevés pixel par pixel sur la capture** tombent du pied des parois (chute accélérée), rebondissent, roulent de 4 px et restent au sol ; 4 chutes décalées de 6 phases ;
- **poussière** : 4 poses générées, un nuage qui s'élève à chaque impact.

Boucles fermées (testé). Fidélité au rip : sol 6,5 et roche 6,3 sur le brut ; sol 8,9, rochers 4,5, blocs 25,6 sur les calques (seuil 35). 12 tests PASS ; 5 mutations vérifiées. Pas de test PMDO en jeu.

## Entrée Clairière tropicale — 4:3, arrivée par un ponton, clairière de palmiers (27 septembre 2026)

- Aperçu : `apercu_entree_clairiere_tropicale_sud_nord_v1.html`, listé en tête par le serveur d'aperçus (`python3 source/serveur_apercus/serve.py`, port 8000).
- Lot : `renders/entree_clairiere_tropicale_sud_nord_v1/` (`ETC1_projet_pmdo_0812.zip`, `ETC1_calques_png_8px.zip`, ORA, WebP animé, planche des poses).
- Source : `source/entree_clairiere_tropicale_sud_nord_v1/`.

**Demande de l'utilisateur** : « continue ! ». Carte suivante de la série ; l'agent a choisi le biome **clairière tropicale**, **à confirmer**. La capture `large.S01P03A…png` (palmiers, hibiscus, dalles de sable, rive, ponton, mer à vagues ; jeu et scène non confirmés) n'était la source d'aucun lot sur les 72 branches ni sur main.

**Correction** : le relevé d'ESC1 donnait à tort `roadundergound` et `rockgeyserlike` comme libres partout. Ils ont servi de relayouts natifs sur d'anciennes branches, et les geysers sont déjà un motif de notre base. Détail dans `REPRISE_MAPS.md`.

Méthode des textures canoniques = **rendu généré référencé**. Un premier décor à l'herbe acide (distance 69,8 au rip, seuil 35) a été **écarté**, pas retouché. Le décor retenu est une nouvelle génération avec la capture en référence, mer en magenta. Trois autres bruts : herbe complète et **témoin sans objets** (édités depuis le décor ; l'écart décor − témoin isole palmiers, fleurs et touffes), planche de papillons.

L'arrivée est au sud, sur un long ponton au-dessus de la mer. Un chemin de dalles traverse une grande clairière bordée de jungle, de palmiers et d'hibiscus jusqu'au seuil de terre d'une entrée sombre, dans un tertre au nord.

15 calques : sol complet, herbe, ombres (au pied du tertre), dalles, touffes, fleurs, jungle, palmiers, tertre, seuil, profondeur, rive, ponton, mer, papillons. Deux animations de 24 × 5 ticks :

- **mer** : profil de 48 px, crête et 9 bleus **relevés pixel par pixel sur la capture** ; les vagues montent de 2 px par phase vers la rive. Contre la terre, seule la bande sombre de la capture : **aucun liseré clair** ;
- **papillons** : 4 papillons générés, battement de 8 phases, vol en huit fermé.

Boucles fermées (testé). Fidélité au rip : herbe 20,4, jungle 33,5, dalles 13,3 (seuil 35). 13 tests PASS ; 5 mutations vérifiées. Pas de test PMDO en jeu.

## Entrée Star Cave — 4:3, grotte de cristaux étoilée, réf. Star Cave (27 septembre 2026)

- Aperçu : `apercu_entree_star_cave_sud_nord_v1.html`, aussi listé en tête par le serveur d'aperçus (`python3 source/serveur_apercus/serve.py`, port 8000).
- Lot : `renders/entree_star_cave_sud_nord_v1/` (`ESC1_projet_pmdo_0812.zip`, `ESC1_calques_png_8px.zip`, ORA, WebP animé, planche des poses).
- Source : `source/entree_star_cave_sud_nord_v1/`.

**Demande de l'utilisateur** : « poursuis les prochaines maps ! faut tourner le serveur dans la session arena ». Deux réponses :

- le **serveur d'aperçus** tourne dans la session : sa page d'accueil liste les 131 aperçus, les entrées sud → nord en tête ;
- la carte suivante. L'agent a choisi le biome **Star Cave**, grotte de cristaux étoilée, **à confirmer**. La capture `starcavepmdsky.png` n'était la source d'aucun lot, sur aucune branche ; elle n'apparaissait que dans des inventaires.

Méthode des textures canoniques = **rendu généré référencé**. La capture est passée au générateur, qui produit trois bruts :

- le décor complet en 4:3, **sans étoiles** puisqu'elles sont animées à part ;
- un sol complet édité depuis le décor ;
- une planche de poussière d'étoile sur magenta.

L'arrivée est au sud par un couloir entre deux avancées de cristal. Il débouche sur une grande caverne, et le sol s'assombrit jusqu'à l'entrée sombre au nord.

La map compte 9 calques : sol complet, sol, ombres, parois de cristal, blocs, profondeur, reflets, étoiles et poussière d'étoile. Elle a trois animations de 24 × 5 ticks :

- **étoiles** : les **4 formes relevées pixel par pixel sur la capture** (croix blanche, croix lavande, étoile lavande, étoile verte), à ses couleurs exactes. Chaque étoile grandit et décroît, ou jaillit puis s'éteint ;
- **reflets** : une vague diagonale parcourt les facettes claires des cristaux, avec la seule rampe cyan de la capture ;
- **poussière d'étoile** : des orbes générées montent du sol puis se dispersent en nuée. La frange magenta de la planche est traitée comme du fond, et une pose entièrement teintée est écartée.

Toutes les boucles sont fermées (testé). Fidélité au rip mesurée par test : sol 7,3, parois 4,0, blocs 3,9 (seuil 35). 13 tests PASS ; 8 mutations vérifiées. Pas de test PMDO en jeu.

## Entrée Sables mouvants — 4:3, désert aux chutes de sable et fosse qui aspire, réf. Furnace Desert (27 septembre 2026)

- Aperçu : `apercu_entree_sables_mouvants_sud_nord_v1.html`.
- Lot : `renders/entree_sables_mouvants_sud_nord_v1/` (`EQS1_projet_pmdo_0812.zip`, `EQS1_calques_png_8px.zip`, ORA, WebP animé, planche des poses).
- Source : `source/entree_sables_mouvants_sud_nord_v1/`.

**Demande de l'utilisateur** : « poursuis le projet ». Carte suivante de la série. Comme pour EUL1, le biome a été choisi par l'agent : **désert aux sables mouvants, à confirmer**.

La référence est `witheringdesert.png`, soit **Furnace Desert** (zone amie de *PMD Rescue Team*). Aucune entrée de la série ne l'utilisait. Elle a déjà servi hors de la série : au duo désert DB1 (`dungeon_biomes_v1`) et, sur une branche ancienne non fusionnée, à un biome swap en eau.

Méthode des textures canoniques = **rendu généré référencé**. La capture est passée au générateur, qui produit trois bruts :

- le décor complet en 4:3, avec la fosse et les deux chutes en magenta ;
- un sol complet édité depuis le décor (2ᵉ essai ; le 1ᵉʳ, un aplat jaune, a été écarté) ;
- une planche de poussière et de tourbillons sur magenta.

L'arrivée est au sud, entre des pierres dressées. Un large bassin de sable mène à l'entrée sombre au nord, dans une falaise en strates encadrée par deux chutes de sable. La fosse de sable mouvant est à l'est, à l'écart du chemin.

La map compte 11 calques : fosse, sol complet, sable, ombres au pied des roches, bord de la fosse, roches, pierres, profondeur, chutes, poussière et rayons. Elle a quatre animations :

- la **fosse** aspire : lignes de 1 px aux **couleurs exactes de la capture**, lobes qui tournent, anneaux qui s'enfoncent vers le centre (12 × 10 ticks) ;
- les **chutes** : zigzags en V relevés sur la capture, redessinés aux couleurs exactes, qui défilent vers le sud (24 × 5 ticks) ;
- la **poussière** au pied des chutes et des tourbillons de grains générés, sur le sable dégagé (24 × 5 ticks) ;
- les **rayons de soleil** en overlay translucide : couleur de la capture, alpha équivalent à l'éclaircissement additif mesuré (12 × 10 ticks).

Toutes les boucles sont fermées (testé). Fidélité au rip mesurée par test : sable 15,5, roches 22,0, pierres 17,7 (seuil 35). 14 tests PASS ; 7 mutations vérifiées. Pas de test PMDO en jeu.

## Entrée Underground Lake — 4:3, lac souterrain lumineux et chaussée jusqu'à la grotte, réf. Underground Lake (26 septembre 2026)

- Aperçu : `apercu_entree_underground_lake_sud_nord_v1.html`.
- Lot : `renders/entree_underground_lake_sud_nord_v1/` (`EUL1_projet_pmdo_0812.zip`, `EUL1_calques_png_8px.zip`, ORA, WebP animé, planche des poses).
- Source : `source/entree_underground_lake_sud_nord_v1/`.

**Demande de l'utilisateur** : « go carte suivante choisis ! ». L'agent a choisi le biome **Underground Lake**, comme demandé ; la capture `Underground_Lake_shore_TDS.png` n'avait encore jamais servi de référence principale. Méthode des textures canoniques = **rendu généré référencé**. La capture est passée au générateur, qui produit trois bruts :

- le décor complet en 4:3, avec le lac en magenta ;
- un sol complet édité depuis le décor : parois gardées au pixel près, qui servent aussi de témoin pour isoler les piliers ;
- une planche de gouttes et de ronds sur magenta.

L'arrivée est au sud, par un chemin de sable entre des parois en bosses. Le chemin débouche sur une large plage. Au nord, une chaussée sèche traverse le lac, qui a deux bassins avec des piliers et des stalagmites, jusqu'à l'entrée sombre ; il n'y a pas d'eau devant la bouche. La map compte 11 calques : sol complet, sable, ombres au pied des parois, berge, parois, piliers et profondeur. Elle a quatre animations :

- le lac façon Métano, avec les **couleurs exactes de la capture** et **sans liseré clair** (4 × 10 ticks) ;
- la lueur turquoise du lac, dont les 9 couleurs de la capture respirent (12 × 10 ticks) ;
- des scintillements Métano natifs, posés sur la lueur ;
- des gouttes qui tombent du plafond et font des ronds dans l'eau (24 × 5 ticks).

Toutes les boucles sont fermées (testé). Fidélité au rip mesurée par test : sable 3,9, parois 5,6, piliers 15,2. 15 tests PASS ; 6 mutations vérifiées. Pas de test PMDO en jeu.

## Entrée Waterfall Cave V3 — la cascade se fend en deux et s'écarte devant la paroi (26 septembre 2026)

- Aperçu : `apercu_entree_waterfall_cave_sud_nord_v3.html`, avec les boutons « Ouvrir la cascade » et « Refermer » et une démo automatique.
- Lot : `renders/entree_waterfall_cave_sud_nord_v3/` (`EWC3_projet_pmdo_0812.zip`, `EWC3_calques_png_8px.zip`, ORA, WebP animé, planche de l'ouverture, comparaison de l'état ouvert V2 / V3).
- Source : `source/entree_waterfall_cave_sud_nord_v3/`.

**Même demande qu'EWC2** (retours sur EWC1) ; les deux versions restent disponibles. EWC3 garde tout ce que fait EWC2 : rives sans liseré clair, couloir de sable jusqu'à la grotte, états PMDO. Un test vérifie que ces calques sont identiques pixel pour pixel. Elle change la lecture de « la cascade se fend ». Dans EWC2, une fente en forme de grotte se découpe dans le rideau. Dans EWC3, le rideau **se fend en deux sur toute sa hauteur** :

- une fissure part de la lèvre de la falaise et descend jusqu'à la grotte, avec une gerbe à sa pointe ;
- les deux moitiés **s'écartent** : l'eau est repoussée et se tasse sur les côtés, elle n'est pas découpée ;
- derrière apparaît une **paroi rocheuse générée** : un 4e brut, le décor EWC1 édité par le générateur sans la cascade, recalé au pixel près et ramené à la palette du terrain ;
- une fois ouverte, la cascade tombe en deux chutes de part et d'autre de la grotte dégagée.

L'ouverture dure 24 × 4 ticks et se joue une fois, entre l'état fermé et l'état ouvert, qui sont des boucles de 12 × 4 ticks. Paroi à 10,4 du rip et à 5,5 des falaises de la carte. 17 tests PASS, dont les raccords fermée → ouverture → ouverte, la pointe qui descend, la paroi sans trou et au moins 2 px de roche autour de la grotte ; 6 mutations vérifiées. `init.lua` : `ouvrir_cascade()`, **non testée dans PMDO**. Pas de test PMDO en jeu.

## Entrée Mystifying Forest — 4:3, clairière et ouverture sombre au nord, réf. Mystifying Forest (26 septembre 2026)

- Aperçu : `apercu_entree_mystifying_forest_sud_nord_v1.html`.
- Lot : `renders/entree_mystifying_forest_sud_nord_v1/` (`EMF1_projet_pmdo_0812.zip`, `EMF1_calques_png_8px.zip`, ORA, WebP animé).
- Source : `source/entree_mystifying_forest_sud_nord_v1/`.

**Demande de l'utilisateur** : « passe à la suite ! » (après EWC2). Le biome **Mystifying Forest a été choisi par l'agent : à confirmer**. Méthode des textures canoniques = **rendu généré référencé** : la capture `Mystifying_Forest_entrance_TDS.png` est passée au générateur, qui produit trois bruts :

- le décor complet en 4:3, avec la mare en magenta ;
- une herbe complète, dont deux zones sombres parasites sont réparées par recopie d'herbe du même brut ;
- une planche de feuilles et de lucioles sur magenta.

Le chemin part du sud, serpente dans une grande clairière et mène à une ouverture sombre entre les arbres, au nord. La map compte 11 calques : sol, herbe, chemin, herbes hautes, rochers, arbres et profondeur, avec quatre animations :

- mare façon Métano, en couleurs Métano exactes, **sans liseré clair** (4 × 10 ticks) ;
- scintillements Métano natifs ;
- feuilles qui tombent des houppiers (48 × 5 ticks) ;
- lucioles qui clignotent à l'orée (48 × 5 ticks).

Toutes les boucles sont fermées (testé). Fidélité au rip mesurée par test : herbe 4,1, chemin 6,4, feuillage 2,9, rochers 3,9. 13 tests PASS. Pas de test PMDO en jeu.

## Entrée Waterfall Cave V2 — cascade en deux temps, sans liseré de rive ni eau devant la grotte (26 septembre 2026)

- Aperçu : `apercu_entree_waterfall_cave_sud_nord_v2.html`, avec les boutons « Ouvrir la cascade » et « Refermer » et une démo automatique.
- Lot : `renders/entree_waterfall_cave_sud_nord_v2/` (`EWC2_projet_pmdo_0812.zip`, `EWC2_calques_png_8px.zip`, ORA, WebP animé, planche de l'ouverture).
- Source : `source/entree_waterfall_cave_sud_nord_v2/`.

**Retours de l'utilisateur sur EWC1** : « il y a des petits traits blancs au bord des rives, fais une version sans ça, et faut pas d'eau devant l'entrée de la grotte, et faut que la cascade soit en deux temps : la cascade qui prend tout et après une animation où la cascade se fend pour ouvrir la grotte ». La V2 repart des **mêmes bruts générés** qu'EWC1, sans nouvelle génération, et EWC1 reste intact.

- **Rives** : le liseré clair en tirets (couleur Métano `clair`) est retiré de l'eau ; la bande sombre touche la rive.
- **Couloir** : un couloir de sable (pixels du sol complet généré) remplace la partie centrale de la vasque et mène à la bouche. Il reste deux bassins latéraux.
- **Cascade en deux temps**, avec des calques d'état :
  - fermée : le rideau recouvre toute la grotte (12 × 4 ticks) ;
  - ouverture : la fente naît en haut, descend et s'écarte jusqu'au contour de la grotte, avec des gerbes aux lèvres (24 × 4 ticks, jouée une fois) ;
  - ouverte : le rideau contourne la grotte (12 × 4 ticks).
- **PMDO** : les calques des états ouverture et ouverte sont `Visible=false`. `init.lua` fournit `ouvrir_cascade()`, **non testée dans PMDO**.

15 tests PASS, dont les raccords fermée → ouverture → ouverte et la fente qui ne fait que s'agrandir. Pas de test PMDO en jeu.

## Entrée Waterfall Cave — 4:3, génération fond magenta multicalque, réf. entrancecascade (26 septembre 2026)

- Aperçu : `apercu_entree_waterfall_cave_sud_nord_v1.html`.
- Lot : `renders/entree_waterfall_cave_sud_nord_v1/` (`EWC1_projet_pmdo_0812.zip`, `EWC1_calques_png_8px.zip`, ORA, WebP animé).
- Source : `source/entree_waterfall_cave_sud_nord_v1/`.

**Demande de l'utilisateur** : « tu dois utiliser la méthode et reprendre seulement de ta branche parente. Et refaire waterfall avec la génération fond majenta multicalque ». Le lot repart de la seule branche parente (Jungle V1). Textures canoniques = **rendu généré référencé** : la capture de l'entrée de Waterfall Cave (`entrancecascade.png`) est passée au générateur, qui produit le décor complet en 4:3 avec l'eau plate en magenta, un sol de sable complet et une planche d'écume sur magenta.

Le résultat compte 16 calques : sol, sable, cailloux, touffes, plateaux, berge, falaises, arbres, bouche sombre et écume du pied, avec cinq animations :
- bassins et vasque façon Métano, en couleurs Métano exactes (4 × 10 ticks) ;
- scintillements Métano natifs ;
- rideau de cascade défilant vers le sud (12 × 4 ticks, translation pure testée) ;
- bouillons d'écume générés ;
- embruns générés.

Fidélité au rip mesurée par test : sable 6,5, roche 5,0, feuillage 2,3, rideau 8,8. Des palettes séparées corrigent le virage du rideau et de la bouche. 13 tests PASS, build reproductible. Pas de test PMDO en jeu.

## Entrée Jungle — format 4:3 vaste, réf. Southern Jungle (26 septembre 2026)

- Aperçu : `apercu_entree_jungle_sud_nord_v1.html`.
- Lot : `renders/entree_jungle_sud_nord_v1/` (`EJN1_projet_pmdo_0812.zip`, `EJN1_calques_png_8px.zip`, ORA, WebP animé).
- Source : `source/entree_jungle_sud_nord_v1/`.

**Nouveau format demandé : 4:3, plus vaste.** La map fait 768 × 576 px, soit 96 × 72 cases : 65 % de cases en plus, environ 2,4 écrans PMDO dans chaque sens. Grande clairière de jungle, sentier en S du sud jusqu'à l'entrée sombre au nord, rivière et mare à l'ouest, deux îlots d'arbres. L'eau est façon Métano (4 × 10 ticks) avec des scintillements Métano natifs, et 6 papillons générés volent en boucles en huit (48 × 5 ticks). La normalisation est uniforme ×0,643, en moyenne pondérée par classe. 9 tests PASS. Biome choisi par l'agent. Pas de test PMDO en jeu.

## Entrée Bristle — sud → nord, rendu généré réf. Mt. Bristle (26 septembre 2026)

- Aperçu : `apercu_entree_bristle_sud_nord_v1.html`.
- Lot : `renders/entree_bristle_sud_nord_v1/` (`EBN1_projet_pmdo_0812.zip`, `EBN1_calques_png_8px.zip`, ORA, WebP animé).
- Source : `source/entree_bristle_sud_nord_v1/`.

Cinquième map de la série : canyon de sable entre des falaises grises en aiguilles, gorge au nord, torrent sur le flanc est. Le torrent reprend la structure de la rivière de Métano **avec ses couleurs exactes** (biome de jour), sur 4 × 10 ticks, avec des scintillements Métano **natifs** non recolorés. Les 8 touffes d'herbe générées se balancent en rafale d'ouest en est (12 × 10 ticks) ; leurs poses sont triées par inclinaison mesurée. 9 tests PASS. Biome choisi par l'agent (à confirmer). Pas de test PMDO en jeu.

## Entrée Givre — sud → nord, rendu généré réf. Frosty Forest (25 septembre 2026)

- Aperçu : `apercu_entree_givre_sud_nord_v1.html`.
- Lot : `renders/entree_givre_sud_nord_v1/` (`EGN1_projet_pmdo_0812.zip`, `EGN1_calques_png_8px.zip`, ORA, WebP animé).
- Source : `source/entree_givre_sud_nord_v1/`.

Quatrième map de la série : forêt de sapins enneigés, sentier de pierre et grotte de glace au nord. Eau glacée façon rivière de Métano (4 × 10 ticks), scintillements Métano recolorés, 40 flocons générés qui tombent en tournoyant puis se posent (48 × 5 ticks, boucle de 4 s). Le ruisseau généré coupait le sentier : un gué gelé est **dessiné par script**, et les congères à moins de 6 px du sentier sont praticables (collision seulement). 11 tests PASS. Biome choisi par l'agent, à confirmer. Pas de test PMDO en jeu.

## Entrée Ruine — sud → nord, rendu généré réf. Sealed Ruin (25 septembre 2026)

- Aperçu : `apercu_entree_ruine_sud_nord_v1.html`.
- Lot : `renders/entree_ruine_sud_nord_v1/` (`ERN1_projet_pmdo_0812.zip`, `ERN1_calques_png_8px.zip`, ORA, WebP).
- Source : `source/entree_ruine_sud_nord_v1/`.

Canyon de grès ocre, arbres morts gris, grotte au nord. Animations : sables mouvants « façon Métano » dans 5 fosses (4 × 10 ticks), 8 bulles de sable générées qui éclatent (24 × 5 ticks) et 2 tourbillons de poussière générés (8 × 5 ticks, non bloquants). 12 tests PASS. Biome choisi par l'agent (à confirmer). Pas de test PMDO en jeu.

## Entrée Cratère — sud → nord, rendu généré réf. Dark Crater (25 septembre 2026)

- Aperçu : `apercu_entree_cratere_sud_nord_v1.html`.
- Lot : `renders/entree_cratere_sud_nord_v1/` (`ECN1_projet_pmdo_0812.zip`, `ECN1_calques_png_8px.zip`, ORA, WebP animé).
- Source : `source/entree_cratere_sud_nord_v1/`.

Il s'agit de la map suivante demandée après l'Entrée Vapeur V2. Le décor complet a été généré sur magenta (lave = magenta) et le sol de cendre complet séparément, puis le tout est réduit ×0,5 (424×632). Les animations sont chacune sur leur calque : lave « façon Métano » (4 × 10 ticks), éclats Métano recolorés, 6 bulles de lave générées qui éclatent (24 × 5 ticks) et braises pulsantes (6 × 10 ticks). Collisions déduites, `entrance` au sud, `donjon_seuil` au nord, sans warp. 11 tests PASS. Le biome a été choisi par l'agent (à confirmer). Pas de test PMDO en jeu.

## Entrée Vapeur V2 — eau façon rivière de Métano + bulles de marais (25 septembre 2026)

- Aperçu : `apercu_entree_vapeur_sud_nord_v2.html`.
- Lot : `renders/entree_vapeur_sud_nord_v2/` (`ESN2_projet_pmdo_0812.zip`, `ESN2_calques_png_8px.zip`, ORA, WebP animé).
- Source : `source/entree_vapeur_sud_nord_v2/`.

Le terrain V1 est inchangé. L'eau reprend la structure et la cadence de la rivière Métano (4 phases × 10 ticks) : bande de berge ondulante, lèvre claire, aplat. Les scintillements utilisent les pixels Métano recolorés. Les 9 bulles générées sont décalées : elles montent, gonflent et éclatent, sur 24 phases de 5 ticks. 9 tests PASS. L'eau est inspirée de Métano, pas faite de tuiles natives ; les bulles sont générées. Pas de test PMDO en jeu.

## Entrée Vapeur — arrivée au sud, grotte au nord (rendu généré, 25 septembre 2026)

- **[Aperçu interactif : calques, eau animée, grille, collisions et viewport](apercu_entree_vapeur_sud_nord_v1.html)**.
- [Calques PNG pour l'import 8 px](renders/entree_vapeur_sud_nord_v1/ESN1_calques_png_8px.zip) · [projet Ground PMDO 0.8.12](renders/entree_vapeur_sud_nord_v1/ESN1_projet_pmdo_0812.zip) · [ORA](renders/entree_vapeur_sud_nord_v1/ESN1_entree_vapeur_calques.ora).
- [Méthode, contrôles et limites](renders/entree_vapeur_sud_nord_v1/README.md).

424×632 px (53×79 cases de 8 px), 9 calques et un avant-plan Top vide. Eau en palette cycling à indices fixes : 12 phases × 10 ticks, soit 2 s. Référence de style : Steam Cave (PMD Sky). **Terrain généré, pas de pixels natifs certifiés.** Le mouvement de l'eau est une création. Collisions de base, marqueurs `entrance` et `donjon_seuil`, chemin 16×16 vérifié sur la grille. Aucun warp configuré. Dix tests PASS, dont l'aller-retour `.rsground`/`.tile`. **PMDO non testé.**

## Beach — référence conservée, neuf calques et eau animée

- **[Atelier interactif : calques, animation et exports PNG](apercu_beach_calques_v1.html)**.
- [Animation WebP](renders/beach_layers_v1/BeachV1_plage_animee.webp) · [GIF](renders/beach_layers_v1/BeachV1_plage_animee.gif) · [document OpenRaster](renders/beach_layers_v1/BeachV1_calques.ora) · [pack ZIP](renders/beach_layers_v1/BeachV1_pack.zip).
- [Méthode, provenance et import 8 px](renders/beach_layers_v1/README.md).

`DSVFS.png` conservée en 702×466 ; neuf partitions visibles, deux pistes mer/écume de 64 phases (3,2 s). Phase 0 exacte, décor et contacts fixes. Mouvement nouveau guidé par la planche Beach, **pas un cycle officiel récupéré**. Option d’import 704×472 par transparence ajoutée, sans étirement. Dix tests d’assets PASS, viewer contrôlé en DOM simulé ; PMDO non testé. Les anciens lots restent inchangés.

## Dix créations supplémentaires — contrôle Métano renforcé

- **[Aperçu des dix propositions et statuts d’audit](apercu_caps_terrasses_v4.html)**.
- [PNG et bilan : huit retenues, deux à reprendre](renders/caps_terrasses_v4/README.md) · [comparatif des bordures](renders/caps_terrasses_v4/AUDIT_BORDURES_AVANT_APRES.png).
- [Audit détaillé](source/caps_terrasses_v4/AUDIT.md) : palette de 328 couleurs natives vérifiées, zéro pixel opaque hors palette sur les exports jour.

**07 et 11 ne passent pas l’audit du dessin et restent à régénérer.** Les autres sont retenues visuellement, sans prétendre que les motifs générés sont des tuiles natives identiques.

## Nouveaux calques — six caps et terrasses face à la mer

- **[Aperçu animé avec calques activables](apercu_caps_terrasses_v3.html)** : falaise proche de la caméra, ciel/océan séparés, jour/nuit.
- **[Planche PNG des six variantes](renders/caps_terrasses_v3/PLANCHE_FACE_MER.png)** · [PNG transparents, magenta et compositions](renders/caps_terrasses_v3/README.md).
- [Océan : 64 phases, boucle plus lente de 3,2 s](renders/caps_terrasses_v3/ocean/README.md).

Présentation Cap V2 / Terrasse V2 et références roche/herbe Métano. Les nouveaux calques et le cycle sont livrés séparément ; le mod natif reste inchangé.

## Témoin courant — méthode Métano sur fond magenta

**[Voir la falaise texturée sur magenta et son PNG transparent](renders/falaise_metano_temoin/README.md)**. Retour aux références de roche et d’herbe Métano, sans nouvelle matière ni layouts plats comme résultat final. Un témoin à valider avant de reprendre la série ; cartes natives préservées.

## V6 — retouches des zones et prototypes de calques

- **[Atelier visuel : avant/après et calques activables](apercu_retouches_et_calques_v6.html)**.
- [Dix retouches, PNG originaux et nuits](renders/retouches_zones_v6/README.md) — les sorties 01, 04 et 10 restent à reprendre.
- [Forêt et grotte : PNG séparés et projets OpenRaster](renders/entrees_calques_v6/README.md).
- [Références Spriters Resource/Halcyon, méthode et suite à faire](source/retouches_v6/README.md).

Les originaux et le mod sont conservés. La limite de dix générations a empêché les trois reprises et les deux nouveaux atlas : les calques livrés ici sont des découpages provisoires des propositions existantes, avec un sol caché complété par échantillonnage.

## Nouveaux PNG — 12 entrées générées dans la DA PMD

- **[Planche des 12 entrées](renders/entrees_pmd_collection/PLANCHE_12_ENTREES.png)** — forêt, cristaux, volcan, glace, ruines, cascade, marais, gouffre et autres compositions.
- **[Catalogue des PNG individuels et variantes Abyss](renders/entrees_pmd_collection/README.md)** · [galerie HTML locale](renders/entrees_pmd_collection/index.html).
- **[40 rendus PNG du mod actuel et calques des trois entrées natives](renders/metano_expeditions_actuel/README.md)**.

Les nouvelles entrées utilisent des matières librement inventées dans la DA PMD ; la fidélité stricte à Métano reste réservée à ses extensions. **Les 12 créations sont des images générées aplaties, pas encore des cartes natives intégrées au mod ci-dessous.**

## Livraison courante — Métano Expéditions, mod de 40 Ground

- **[Voir nos nouvelles entrées et les falaises](apercu_metano_expeditions.html)** — l’aperçu démarre sur l’Antre Crochu ; 20 lieux en jour/nuit, calques et exports.
- **[Télécharger le mod PMDO 0.8.12](mod_metano_expeditions_pmdo_0812.zip)** — **7 nouvelles falaises + 3 entrées**, leurs 20 variantes et les 20 Ground Métano/Abyss précédents.
- **[Installation et catalogue](source/cote_v5_expeditions/README.md)** · [manuel détaillé](MANUEL_METHODE_PMDO.md) · [40 chargements dans le vrai moteur](source/cote_v5_expeditions/runtime_verification.json).

Copier le dossier `metano_expeditions` dans `MODS`, puis lancer `OUVRIR_EDITEUR.bat` (Windows) ou `bash OUVRIR_EDITEUR.sh` (Linux). Ressources, index complet, scripts et manuel inclus ; aucun import PNG. **Projet prêt à éditer, pas une aventure complète.** Les trois seuils sont repérés et accessibles sur la grille ; leurs destinations de donjon restent à raccorder. Les 40 Ground passent le chargeur natif sans affichage ; rendu GPU et gameplay non validés ici.


## Manuel et préparation des prochaines entrées

**Nouveau : [PMDO installé depuis RUNTIMEPMDO et 20 Ground désérialisés par le vrai moteur](source/pmdo_runtime/README.md)**. Test sans affichage réussi ; rendu dans l’éditeur non validé. Les mentions antérieures « non testé moteur » décrivent les contrôles à la date de construction des packs.

- **[Manuel détaillé des méthodes PMDO](MANUEL_METHODE_PMDO.md)** — ressources natives, layouts, échelle, calques, filtre Abyss, animations, formats, installation, tests et limites.
- [Étude de Crooked Cavern, Brine Cave et Drenched Bluff](source/cote_v5_expeditions/README.md) pour le lot de sept falaises et trois entrées désormais livré ci-dessus. Moteur installé ; éditeur graphique encore en échec dans cet environnement.


## Dernière correction — Métano natif et filtre nuit Abyss

- **[Ouvrir l’aperçu des dix côtes](apercu_cotes_metano_abyss.html)** — jour/nuit, cinq calques de terrain, grille 8 px, exports PNG.
- **[Télécharger les 20 Ground PMDO 0.8.12](cotes_metano_abyss_0812_pmdo.zip)** — projet séparé `cotes_metano_abyss_0812`, toutes les ressources et l’index inclus.
- **[Installation et méthode](source/cote_v4_abyss/README.md)** · [résultats des contrôles](source/cote_v4_abyss/verification.json).

Herbe et roche entièrement reconstruites depuis les pixels Métano : plus de lisières ni d’ombres générées. Faces, retours, couronnes et pieds séparés ; silhouettes et contacts W/E/S conservés. **Filtre exact d’Abyss V4**, vérifié contre ses trois feuilles nocturnes complètes. Le remplissage des grandes hauteurs répète des modules natifs ; les raccords restent à apprécier en jeu. **Fichiers vérifiés par code, ouverture réelle dans PMDO non testée. Collisions à dessiner.** Les anciens packs ci-dessous sont conservés.


## Archive V3 — formes V2, pack ciblé PMDO 0.8.12

- **[Voir les dix côtes jour/nuit](apercu_cotes_v2_0812.html)** — silhouettes organiques, calques activables, grille 8 px et exports natifs.
- **[Télécharger les 20 Ground et leur projet séparé](cotes_v2_0812_pmdo.zip)** — dossier `cotes_v2_0812` à placer dans `PMDO/MODS/`, index complet et ressources incluses.
- **[Installation dans un projet séparé ou existant](source/cote_v3_0812/README.md)** · [contrôles](source/cote_v3_0812/verification.json).

Bords ouest/est/sud joints par recadrage, sans étirement. Roche brute Métano à 1×, ombres séparées ; herbe et lisières générées. Nuages et nuit Guilde / Sharpedo. **Format et fichiers vérifiés par code, ouverture réelle dans PMDO non testée.** Collisions à dessiner. Les anciens lots restent disponibles ci-dessous.


## Lot 2 — 10 côtes supplémentaires dans la même DA

- **[Voir les zones 11 à 20 en jour/nuit](apercu_dix_zones_metano_lot2.html)** : mêmes nuages et palette nocturne, dix agencements supplémentaires, calques et exports PNG natifs.
- **[Pack de 20 Ground PMDO](cote_metano_dix_zones_lot2_pmdo.zip)** — ressources et installateur inclus ; préfixes `cote20_` / `C20_`, sans remplacement des anciennes cartes.
- **[Installation et provenance](source/cote_dix_zones_lot2/README.md)** · [planche jour/nuit](sprites/cote_dix_zones_lot2/PLANCHE_JOUR_NUIT_NE_PAS_IMPORTER.png).

Bases sans bâtiments ni arbres, collisions libres à dessiner. Pixels et formats contrôlés ; **ouverture dans PMDO non testée**.


## Nouveau — 10 côtes Métano, nuages et nuit Guilde / Sharpedo

- **Voir : [aperçu interactif jour/nuit](apercu_dix_zones_metano.html)** — 10 nouveaux lieux et les deux côtes V2 adaptées, calques, zoom natif, animation et exports PNG.
- **[Pack PMDO natif](cote_metano_dix_zones_pmdo.zip)** : 20 Ground pour les nouveaux lieux (jour/nuit), plus 4 variantes des anciennes côtes ; ressources `.tile` / `.dir` et installateur préservant les cartes modifiées.
- **[Installation, provenance et limites](source/cote_dix_zones/README.md)** ; [planche réduite](sprites/cote_dix_zones/PLANCHE_JOUR_NUIT_NE_PAS_IMPORTER.png).

Les six nuages et la recette de nuit sont repris directement du travail de l'autre agent (`c16efe12`), pas redessinés. Les dix terrains utilisent des modules Métano natifs ; les rives ont une découpe alpha et les faces sont prolongées par répétition de rangées. **Collisions à dessiner, raccords à contrôler et ouverture PMDO non testée.** Les variantes V2 ne remplacent pas les anciennes cartes.

Le premier pack de deux cartes est aussi versionné : [cote_metano_v2_pmdo.zip](cote_metano_v2_pmdo.zip).


Cette reprise conserve l’univers graphique du **premier pack**. Les accès ont été corrigés suivant la dernière consigne : **des ruptures du contour avec un sol continu, pas une porte à chaque sortie**.

## Règles effectivement appliquées

- **Est / Ouest :** le plancher traverse une interruption de la bordure latérale. Pas de battant, de portique ni d’arche ajoutée sur ces accès.
- **Sud :** seul le sol se prolonge vers le passage. Une éventuelle porte se trouve hors caméra et n’est pas dessinée.
- **Nord :** passage de sol ouvert pour les salles 01 et 09 ; les accès par échelle gardent leur fonction.
- **Une seule porte fermée visible :** au nord du hall 02, donnant vers le bureau du maître 12. Le bureau conserve son accès sud, sans porte visible depuis l’intérieur.
- Les anciennes fausses portes de fond et les sorties sud superflues des chambres latérales ont été retirées.
- Dans le hall, **le tronc et l’échelle se prolongent au-delà du bord supérieur**, sans sommet de tronc scié visible.
- Les ombres restent des ombres de contact aux retours du contour ; elles ne forment pas de barre noire bouchant le sol.

Les pièces sont **vides et fixes**. Aucun meuble, paillasse, tapis, plante, bannière ou lampe n’est posé dans les fonds. Les deux tableaux muraux du hall sont conservés comme équipements encastrés. La banque d’objets du pack précédent reste fournie séparément.

## Fenêtres et paysage

Les cadres et croisillons sont conservés, mais **aucun paysage n’est peint dans le calque intérieur**.

- `base_jour_transparente.png` / `base_nuit_transparente.png` : vrais PNG RGBA, avec les ouvertures de fenêtres transparentes.
- `base_jour_magenta.png` / `base_nuit_magenta.png` : variantes de contrôle sur fond **#FF00FF**, visible à travers les fenêtres. Pour le jeu, utiliser de préférence les PNG transparents.
- `fenetres_exterieur/NN/` : six vues déjà positionnées et masquées aux fenêtres de chaque salle.
- `exterieur/` : les six panoramas complets, issus de la géographie de la terrasse approuvée.

Ambiances : **jour, nuit, crépuscule, aube, soir et orageux**. Les montagnes, le village et la rivière restent au même endroit. Les palettes, le ciel et la météo varient. Le paysage et la palette de l’intérieur peuvent être choisis indépendamment.

La salle 01 n’a pas de fenêtre vitrée : son accès nord est désormais une continuité de sol. Les persiennes des salles 08/10 conservent leurs lattes, avec une vue interchangeable dans leurs interstices.

## Onze calques séparés

1. Paysage extérieur interchangeable
2. Sol et continuité des passages
3. Structure, murs et ouvertures
4. Cadres de fenêtres, sans paysage
5. Contenu des tableaux encastrés
6. Porte nord du bureau — uniquement dans le hall
7. Décorations — **vide**
8. Objets — **vide**
9. Ombres de contact des accès
10. Éclairage complémentaire — **vide**
11. Bordure de premier plan, interrompue aux passages

Chaque salle est disponible en **jour et nuit**, avec une seule image par fichier Aseprite. Il n’y a aucune animation dans cette version.

## Contenu du kit

- `apercu_pmd.html` : aperçu autonome, hors ligne. Le bouton **« Base seule — magenta »** retire le paysage pour vérifier les ouvertures. Les cases permettent de masquer chaque calque.
- `salles/` : compositions, bases transparentes, bases magenta et 24 Aseprite fixes.
- `calques/` : 11 PNG transparents par salle et par palette.
- `tiled/` : 24 cartes orthogonales à cellules de **8 × 8 px**, avec des tuiles reconstituant exactement les images.
- `fenetres_exterieur/` : masques et 72 couches de paysage positionnées.
- `exterieur/` : 6 ambiances complètes.
- `sprites/` : banque indépendante du premier kit modulaire ; ces éléments ne sont pas posés dans les salles.
- `kit.json` : dimensions, accès, calques et chemins.
- `source/` : retouches natives retenues, sources du panorama, règles et scripts de reconstruction.

Le hall mesure **1280 × 544 px** ; les autres pièces **648 × 432 px**. Les grilles Aseprite et Tiled sont réglées sur 8 px. Les PNG ne sont pas pixellisés en gros blocs de 8 px.

Les cartes ne sont pas un jeu intégré : collisions, transitions et déclencheurs de porte doivent être configurés dans le moteur. Les accès sont décrits dans `kit.json` et `source/regles_acces.json`.

## Reproduction et contrôles

```bash
pip install -r source/requirements.txt
python source/rebuild_landscapes.py
python source/rebuild_kit.py
python source/build_preview.py
python source/verify_pmd.py
```

Le contrôle relit et recompose les PNG, Aseprite et cartes Tiled ; vérifie les bases transparentes/magenta, les 6 vues alignées, les calques vides et l’unique porte nord. Validation par code, pas par ouverture dans l’interface d’Aseprite.

Les retouches ont été faites avec le générateur à partir des images du kit. Les images du jeu fournies par l’utilisateur ont servi à comprendre le principe des passages, pas à être collées dans les décors. **Le tout premier ZIP de la guilde et les archives de la terrasse approuvée restent inchangés.**

## Ponts suspendus modulaires — ajout indépendant

Voir **`apercu_ponts.html`** et **`sprites/ponts/README.md`** : ponts originaux inspirés de PMD, horizontaux/verticaux, jour/nuit, PNG transparents et tilesets Tiled animés en quatre phases. Cellules de 64 × 64 px, centres répétables entre les ancrages. Cet ajout ne change pas les salles fixes décrites ci-dessus. Reconstruction : `python source/build_bridges.py`.

### Nouvelle version dorée passée au générateur — PMDO / town02

**`apercu_ponts_pmdo.html`** présente la version adaptée à la référence jaune doré. Les assets sont dans **`sprites/ponts_pmdo/`** : deux orientations, quatre phases, jour/nuit, PNG transparents, huit `.tile` natifs en **8 × 8 px** et manifests d'animation. Les modules de dessin font 80 × 80 px (10 × 10 cellules moteur). Voir le README de ce dossier pour la réindexation PMDO et les limites de validation : les ressources Metano ont été inspectées, mais le téléchargement LFS de `WaterfallVillageCapital.rsground` a échoué, donc son TexSize et le placement précis restent à vérifier. Reconstruction et tests : `python source/build_bridges_pmdo.py && python source/verify_bridges_pmdo.py`.

## Dix maisons arrondies — référence Métano Town de Palika

**`apercu_maisons_metano.html`** : dix nouvelles huttes générées avec références originales affichées à la même échelle, jour/nuit, zoom et grille. **`sprites/maisons_metano/`** contient les 20 PNG, les deux atlas et `.tile` PMDO natifs, les TSJ et le manifeste. Cadres **112 × 128 px**, cellules **8 × 8 px**, dessins à une échelle comparable aux maisons de Métano. Les trois références ont été comparées aux ressources originales de `Palikadude/Halcyon` (0 différence sur les pixels opaques). Voir le README du dossier pour l'import, l'attribution et les limites : structures fixes, collisions/entrées à régler, pas de test en jeu. Reconstruction : `python source/build_houses_metano.py`; tests : `python source/verify_houses_metano.py`.

## Eau de Métano — extraction identique des animations originales

**`apercu_eau_metano.html`** présente les **quatre frames de cascade** extraites de `Metano_Town_Animation_Tileset` et les **quatre vraies planches de rivière** de Palika/Halcyon. Fichiers dans **`sprites/eau_metano/`** : PNG natifs, atlas source complet, cascades séparées, banque compacte de rivière, `.tile`, TSJ et provenance. Aucune génération ni retouche de pixels. La carte originale de Métano a été lue : grille 8 px et `FrameLength = 10` vérifiés pour la rivière ; la cadence autonome des rectangles de cascade reste proposée, non prouvée. Comparaisons source/export : zéro différence, voir le README et `verification.json`. Attribution aux auteurs de Halcyon conservée. Reconstruction : `python source/build_water_metano.py`; tests : `python source/verify_water_metano.py`.

## Trois grands layouts de falaises — extensions visuelles de Métano

**`apercu_falaises_metano.html`** : trois cartes de **2048 × 1536 px**, chacune en **256 × 192 cases de 8 px** : grande paroi, plateau isolé et trois terrasses. Textures natives répétées sans agrandissement, escaliers et grandes cascades à quatre phases. **`sprites/falaises_metano/`** contient les calques PNG, les compositions, trois cartes Tiled, l'atlas commun `.tile` PMDO et les métadonnées. Les formes du terrain et des rivières sont nouvelles ; ce ne sont pas des zones officielles ou des raccords déjà intégrés à Métano. Collisions et transitions à configurer. Contrôles : recomposition exacte des cartes sur les quatre phases et relecture de l'atlas natif. Voir le README du pack pour l'import et l'attribution. Reconstruction : `python source/build_cliff_layouts.py`; validation : `python source/verify_cliff_layouts.py`.

## Lot 02 — dix nouvelles maisons, falaises modulaires et rendu PNG

**`sprites/falaises_modulaires_v2/rendu_collection.png`** présente le nouveau décor, les dix nouvelles maisons et les morceaux de falaises. Rendus natifs **2048 × 1536 px** : `rendu_falaise.png` (sans maisons), `rendu_village.png` (avec maisons). **`sprites/maisons_organiques_v2/planche.png`** montre le nouveau lot ; **`sprites/falaises_modulaires_v2/planche_modules.png`** montre 11 fragments natifs et les 4 phases de cascade. La planche importable, les PNG individuels, les `.tile`/TSJ et les cartes Tiled sont fournis séparément, tous sur grille de 8 px. Les anciens lots restent inchangés. Voir les README de ces dossiers pour les commandes de reconstruction et les limites : géométrie nouvelle, morceaux sources inchangés, intégration PMDO et collisions à faire. Les vérificateurs comparent les fragments à leurs sources et recomposent le décor/village aux quatre phases.

## Layouts canoniques pixel-perfect — versions sèches et animées

**`apercu_metano_pixel_perfect.html`** : trois layouts **2048 × 1536 px**, grille **8 px**, avec bascule **sans eau / eau animée**. Dans **`sprites/metano_pixel_perfect/`**, chaque carte possède un PNG sec ne contenant que l'herbe, les falaises et leurs bordures, quatre rendus humides, les calques séparés et deux cartes Tiled. Aucun chemin, escalier ou bâtiment n'est ajouté. Contrairement aux prototypes précédents, chaque tuile utilisée est une copie vérifiée d'une tuile canonique de Métano : aucun dessin généré, aucune berge tracée, aucun agrandissement de texture. La géométrie est nouvelle ; les longues faces et chutes répètent des rangées natives. L'atlas `.tile` PMDO et les références source/Frames sont fournis. Voir `verification.json` et le README du dossier pour la portée exacte du contrôle et les limites d'intégration moteur. Reconstruction : `python source/build_metano_pixel_perfect.py`; tests : `python source/verify_metano_pixel_perfect.py`.

## Falaises côtières nues — générations et calques animés

**`apercu_falaises_cotieres_nues.html`** présente deux terrains sans bâtiments, arbres, campement, objets ni chemins, sur trois calques : terrain transparent, ciel animé (8 frames) et mer animée (5 frames). Les PNG et leur manifeste sont dans `sprites/falaises_cotieres_nues/`, l’archive dans `falaises_cotieres_nues_pack.zip`.

**Statut explicite : les falaises sont générées et guidées par les références Métano, pas composées de tuiles canoniques vérifiées.** Les fonds viennent de la planche côtière fournie par l’utilisateur, avec cadences proposées. L’animation est visible dans l’aperçu ; elle doit être configurée séparément dans PMDO. Voir [le README du lot](sprites/falaises_cotieres_nues/README.md).

## Côte V2 — roche corrigée, overlay de nuages wrap et mer à palette cyclique

**`apercu_cote_v2.html`** présente quatre calques indépendants : ciel généré sans nuages, nuages transparents à défilement horizontal continu avec wrap, mer indexée à huit palettes et terrain. La roche de la **terrasse** a été régénérée avec les modules Métano comme référence ; elle reste un rendu généré, non une copie certifiée des tuiles natives. Le terrain du promontoire est conservé.

Les huit PNG de mer ont **les mêmes indices et chunks IDAT** : seules les entrées de palette tournent, sans déplacement géométrique ni changement de transparence. Les quatre nuages sont exportés séparément et sur un strip wrap de **2200 × 344 px**, sans redimensionnement. Les tests vérifient la jonction du wrap et le cycle de palette. L’import PMDO seul n’active pas ces animations : voir [les instructions](sprites/cote_v2/README.md).

- Assets et paramètres : `sprites/cote_v2/`.
- Comparatif de roche : `sprites/cote_v2/ROCHE_AVANT_APRES_NE_PAS_IMPORTER.png`.
- Pack : `cote_metano_v2_wrap_palette.zip`.
- Scripts : `source/build_cote_v2.py`, `source/verify_cote_v2.py`, `source/package_cote_v2.py`.

## Cartes côtières V2 — Ground PMDO natives

Les deux zones V2 ont désormais un générateur de **vraies `.rsground`** avec
leurs tilesets `.tile`, fonds `.dir`, mer animée et nuages en wrap natif.
Des calques vides permettent d'ajouter sols, structures, avant-plans et objets.

- [Installation, calques, limites et formats vérifiés](source/pmdo_cote/README.md)
- Reproduire le pack : `.venv/bin/python source/pmdo_cote/package.py`
- Sortie par défaut du générateur : `~/cote_metano_v2_pmdo.zip` ; une copie livrée est versionnée à la racine.
- Validation indépendante des ressources et des pixels ; **pas de test dans PMDO**.
- Collisions libres à dessiner avant utilisation comme niveau jouable.

## Zones guidées par le générateur → tuiles canoniques

Deux nouvelles compositions (cirque et terrasses), illustrées par le générateur puis reconstruites avec de vraies tuiles Métano de 8 px : **2048 × 1536 px**, versions sèches sans chemin et quatre phases d’eau natives.

- **Voir avant/après :** `sprites/zones_guidees/comparaison_generateur_canonique.png`.
- **Explorer / animer :** `apercu_zones_guidees.html` (autonome, grille et zoom natif).
- **Pack :** `zones_guidees_metano_pack.zip` ; PNG, atlas natif, maps Tiled et provenance dans `sprites/zones_guidees/`.
- **Méthode et limites :** [README des zones guidées](sprites/zones_guidees/README.md). Le générateur fournit le guide, jamais les pixels canoniques. Les raccords sont encore approximatifs par endroits ; gameplay et import PMDO non validés.
- **Contrôle indépendant :** `.venv/bin/python source/verify_zones_guidees.py`.

### Zones approuvées — édition multicalques comme la guilde

**`apercu_zones_multicalques.html`** permet maintenant d’afficher, masquer ou isoler les six calques des deux zones approuvées : sol, parois, bordures, berges, rivière et cascades. Les compositions et pixels Métano restent **inchangés**.

Dans `sprites/zones_guidees/{01_cirque,02_terrasses}/multicalques/` : PNG transparents alignés, Aseprite sec (3 calques / 1 frame) et animé (6 calques / 4 frames), cartes Tiled réutilisant l’atlas canonique. Le découpage et les fichiers éditables ont été vérifiés par relecture : **0 différence de pixel**. Les archives antérieures ne sont pas modifiées. Voir [les instructions multicalques](sprites/zones_guidees/README_multicalques.md) et `sprites/zones_guidees/planche_multicalques.png`.

La méthode approuvée est conservée dans `AGENTS.md` pour les prochaines zones. Reconstruction : `source/build_zones_multicalques.py`, contrôle : `source/verify_zones_multicalques.py`, aperçu : `source/package_zones_multicalques.py`.

### Audit du rendu en jeu et de l’échelle des falaises

Après le retour utilisateur sur la qualité à l’import, [l’audit](audits/metano_import/RAPPORT.md) distingue un **défaut confirmé d’assemblage des fragments natifs** d’un éventuel problème d’échelle/filtrage côté import, encore à vérifier. Le contrôle des pixels ne validait pas les volumes des falaises. Comparatif à zoom entier : `audits/metano_import/comparaison_echelle.png` ; mesures : `audits/metano_import/mesures.json`. Les zones approuvées ne sont pas modifiées par cet audit.

### Métano V3 — PNG pour l’importeur PMDO Dev

Le [lot PNG natif](sprites/metano_import_png/README.md) fournit deux premières scènes sèches de calibration **1016 × 512** et **1016 × 768**, avec des blocs de falaises complets et leurs calques sol/falaises. Aucun pixel natif redimensionné. Les noms `METANO_V3_*` sont uniques pour éviter les écrasements lors de « PNG to Tileset ». Importer en **8 px**, puis comparer le témoin natif **64 × 96** en jeu. Les grandes zones précédentes restent intactes ; ce lot n’en est pas encore le remplacement complet. Construction : `source/build_metano_import_png.py` ; contrôle : `source/verify_metano_import_png.py`. Archive : `metano_png_import_v3.zip`.

### Layouts côtiers du commit utilisateur — génération sur les vraies références

Le commit **`3bc185b`**, ajouté sur la branche de cette session et non sur `main`, contient les références du **promontoire de Bekipan** et de la **terrasse côtière avec campement/grotte**. Elles ont été intégrées sans modification. Deux nouvelles reproductions diurnes ont été réalisées avec le générateur à partir de ces layouts et de la référence Métano :

- `source/layouts_commit_3bc185b/01_promontoire_bekipan.png`
- `source/layouts_commit_3bc185b/02_terrasse_campement.png`

Voir [les références et limites](source/layouts_commit_3bc185b/README.md). **Ces images sont des propositions générées, pas des textures canoniques certifiées pour PMDO.** Les originales, dont la vue nocturne, restent à la racine ; le lot natif d’import et les anciens travaux sont conservés séparément.

## Nouveaux calques côtiers V2

[10 promontoires et animations séparées](renders/references_calques_v2/README.md) — [galerie autonome](apercu_references_calques_v2.html). Étoiles, lune/halo, reflets et nuages wrap ; réserves artistiques documentées, sans modification du mod natif.

## Soleil animé et Luminous Spring

[Nouveau pack PNG multicouche](renders/soleil_spring_v1/README.md) — [aperçu autonome](apercu_soleil_spring_v1.html). Soleil subtil 64 phases, grands nuages traversants, variante du Spring Halcyon avec cycles natifs 3/13 phases préservés.
