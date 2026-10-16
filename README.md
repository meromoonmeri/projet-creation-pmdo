# Projet création PMDO — méthodes de création de cartes

Ce dépôt rassemble **toutes les méthodes** de création de cartes du projet
[`meromoonmeri/projet-pmdo`](https://github.com/meromoonmeri/projet-pmdo) (« Guilde Treehouse »,
zones Métano, entrées et fins de donjon, arènes, packs PMDO 0.8.12) — **sans les 6 Go de rendus**.
Extraction faite au commit [`6cca4a0`](https://github.com/meromoonmeri/projet-pmdo/commit/6cca4a09380211e510ab1bea454a1b1926ef4b5a) :
**3 592 fichiers, 169 Mo, soit 2,7 % du volume d'origine.**

| | |
|---|---|
| **208 sous-projets de map** | `source/` — chacun avec son générateur, ses tests, sa doc, sa provenance |
| **626 scripts Python + 24 C# + 6 Lua** | générateurs, tests, packaging, installateur PMDO, codec `.rsground` |
| **326 documents de méthode** | manuel, méthode d'agents, reprises, `README`/`WORKFLOW`/`STATUS` par chantier |
| **245 fichiers de données PMDO natives** | `.rsground` (Ground), `.tile` (tilesets), `.tmj`/`.tsj` (Tiled), `.npz` (provenance), `.chara`, `.dir` |
| **règles JSON** | `kit.json`, `source/regles_acces.json`, `controle_qualite.json`, `controle_navigateur.json` |

## Forêt de feuillus — entrée EFF1 et fin FFF1

Après le rejet des Schistes bleus et la demande « continue des biome forestier etc », nouvelle
**[entrée de la Forêt de feuillus](source/entree_foret_feuillus_v1/README_PACK.md)**, référence D24P11A :
canopée dense, clairière et chemin sinueux, sans grotte ni falaise ajoutée.
**768×576, neuf calques + Top**, herbe/chemin et troncs/feuillage séparés, feuilles animées.
**14 tests PASS**, 32 images reconstruites exactement, deux builds identiques.
[Décor généré](source/entree_foret_feuillus_v1/bruts/decor.png) ·
[statut détaillé](source/entree_foret_feuillus_v1/STATUS.md).
**Avis artistique et moteur en attente.** Le terrain est généré référencé, pas extrait de la ROM.
Les ZIP PMDO/PNG-ORA et l'aperçu se régénèrent avec build puis package.
ESB1 est rejeté ; la proposition Col de sable est laissée de côté au profit de la forêt.

La **[clairière finale FFF1](source/fin_foret_feuillus_v1/README_PACK.md)** complète cette direction :
terre nue centrale, feuillus et lisière nord bloquante, sans sortie ni construction.
**Huit calques + Top, 14 tests PASS, 31 images reconstruites exactement** ; loi de feuilles assortie
à l'entrée, source et support vérifiés. [Décor généré](source/fin_foret_feuillus_v1/bruts/decor.png) ·
[statut](source/fin_foret_feuillus_v1/STATUS.md). Paquets PMDO/PNG-ORA et aperçu régénérables.
**Avis artistique et moteur en attente pour les deux cartes.**

## Nouvelle fin — Aiguilles dorées FAD1

La **[fin des Aiguilles dorées](source/fin_aiguilles_dorees_v1/README_PACK.md)** accompagne EAD2 :
vaste chambre souterraine plein cadre, paroi nord fermée, sable ocre et aiguilles, sans porte,
structure ni sortie ajoutée. Référence D14P12A, 768×576, six calques + Top, poussière indépendante.
**13 tests PASS**, 29 images reconstruites, deux builds identiques ; ZIP PMDO et calques/ORA prêts.
[Décor généré conservé](source/fin_aiguilles_dorees_v1/bruts/decor.png),
[état détaillé](source/fin_aiguilles_dorees_v1/STATUS.md). **Avis artistique et moteur en attente**.
Les sources et bruts sont versionnés ; les packs et l'aperçu se régénèrent avec build puis package.

## Correction en cours de validation — grotte immersive EAD2

La [V2 des Aiguilles dorées](source/entree_aiguilles_dorees_v2/README_PACK.md) répond au retour
« grotte trop petite, pas immersive » : nouveau layout plein cadre, grande voûte et profondeur
intérieure dessinée, même format 768×576. **8 tests PASS**, 30 images reconstruites depuis les
banques natives ; **avis artistique et test en jeu en attente**. L'essai EAD1 est rejeté ;
la [fin grise FDR1](source/fin_defile_roches_grises_v1/README_PACK.md) est maintenant finalisée techniquement : 13 tests PASS, 29 images reconstruites et paquets PMDO/calques. Avis artistique et test en jeu en attente pour ces deux lots. Voir leurs `STATUS.md`.

## Reprise du 16 octobre 2026 — nouveau biome EDR1

La nouvelle **[entrée du Défilé des Roches grises](source/entree_defile_roches_grises_v1/README_PACK.md)**
utilise la référence ROM **D46P11A** : décor généré référencé, sol séparé, 7 calques + Top,
poussière au vent, collisions et marqueurs sud → nord, projet PMDO 0.8.12.
**16 tests PASS**, dont 5 mutations ; **30 images reconstruites depuis les banques natives**.
Ni le chargeur réel ni le rendu en jeu n'ont été testés pour ce nouveau lot.
Les sources et bruts sont présents ; les sorties lourdes se régénèrent localement.

La synthèse actuelle est dans **[WORKFLOW.md — générateur + pipeline natif](WORKFLOW.md)**.
Elle précise les deux routes : **pixels générés référencés**, encodés au format natif pour la
série des nouveaux biomes, ou **pixels natifs exacts** pour les demandes qui l'exigent (Métano).
Ne pas confondre les deux sens de « natif » dans les descriptions historiques ci-dessous.

## Par où commencer

| Document | Rôle |
|---|---|
| **[GUIDE_CREATION_DE_MAP.md](GUIDE_CREATION_DE_MAP.md)** | **La méthode pas à pas**, du rendu généré au Ground importé dans PMDO |
| **[METHODE_MAGENTA_ET_GENERATEUR.md](METHODE_MAGENTA_ET_GENERATEUR.md)** | **Comment ça marche** : générateur d'images → fond magenta → tuiles natives (formules, seuils, fidélité) |
| [INDEX_METHODES.md](INDEX_METHODES.md) | Tableau des **208 sous-projets** : générateur, tests, package, provenance, Ground/tileset présents |
| [MANUEL_METHODE_PMDO.md](MANUEL_METHODE_PMDO.md) | Manuel de production : état des livraisons, contrat artistique, limites du moteur |
| [AGENTS.md](AGENTS.md) | Méthode de production approuvée (Métano, textures canoniques, contrat d'import) |
| [REPRISE_MAPS.md](REPRISE_MAPS.md) | Reprise de la série de maps sud→nord : état, bogues, décisions |
| [kit.json](kit.json) · [source/regles_acces.json](source/regles_acces.json) | Kit « Guilde Treehouse » : 12 salles, 11 calques, règles d'accès, ambiances |
| [JOURNAL_GUILDE_TREEHOUSE.md](JOURNAL_GUILDE_TREEHOUSE.md) | Journal chronologique des livraisons (ancien `README.md` du dépôt source) |
| [MANIFESTE_EXTRACTION.md](MANIFESTE_EXTRACTION.md) | Ce qui a été extrait, ce qui ne l'a pas été, comment récupérer le reste |
| [INVENTAIRE_FICHIERS.txt](INVENTAIRE_FICHIERS.txt) | Liste exhaustive des 3 592 fichiers extraits |

## La chaîne de production, en une phrase

> Un **rendu généré** (image complète, sol sur magenta) sert de **composition** ; il est ensuite
> **reconstruit en tuiles natives de 8 px**, découpé en **calques PNG transparents** et en
> **animations**, vérifié par des **tests Python**, puis empaqueté en **projet PMDO 0.8.12**
> (`.rsground` + `.tile` + `index.idx` + script d'init) et installé dans `PMDO/MODS/`.

Le détail — commandes, formats, règles de calques, marqueurs, collisions, limites — est dans
**[GUIDE_CREATION_DE_MAP.md](GUIDE_CREATION_DE_MAP.md)**.

## Structure du dépôt

```
├── source/           208 chantiers de map, chacun autonome
│   └── <projet>/     build.py · test_build.py · verify.py · package.py
│                     README_PACK.md · WORKFLOW.md · STATUS.md · provenance.json
│                     viewer_template.html · references/*.rsground · references/*.tile
│   ├── pmdo_cote/    codec binaire .rsground + INSTALLER.py (installation dans un mod)
│   ├── pmdo_runtime/ test avec le vrai chargeur PMDO 0.8.12 (sans affichage)
│   ├── build_zones_guidees.py · build_zones_multicalques.py · regles_acces.json
│   └── <utils>       utilitaires partagés (Bristle, sud→nord, codec, index de tiles)
├── salles/           12 salles de guilde : PNG jour/nuit, bases magenta, transparentes
├── calques/          les 11 calques séparés par salle (264 PNG)
├── fenetres_exterieur/  vues extérieures des fenêtres (12 × 7 PNG)
├── exterieur/        paysages extérieurs interchangeables
├── tiled/            sources Tiled des salles
├── audits/           rapports d'audit (ex. imports Métano)
├── sprites/          données de découpe/layout (.tmj, .tsj, JSON) — pas les planches PNG
├── exports/          JSON, CSV, NPZ de provenance et d'audit (pas les images)
├── renders/          manifest.json, configs et scripts des rendus (pas les images)
└── OUTILS/           extraction reproductible depuis projet-pmdo
```

## Ce qui n'est **pas** ici

Les images de rendu (`renders/`, 4,4 Go), les archives ZIP livrées, les aperçus HTML autonomes
(779 Mo) et les planches de sprites — soit **6,04 Go**. Ils restent dans le dépôt source et se
récupèrent fichier par fichier sans rien cloner :

```sh
curl -L -o fichier.png \
  https://raw.githubusercontent.com/meromoonmeri/projet-pmdo/6cca4a09380211e510ab1bea454a1b1926ef4b5a/renders/<dossier>/<fichier>.png
```

Voir [MANIFESTE_EXTRACTION.md](MANIFESTE_EXTRACTION.md) et `OUTILS/extraire_depuis_projet-pmdo.py`
(`--avec-media` pour tout reprendre).

## Règles d'or du projet

1. **Grille 8 px, taille native, aucun agrandissement.** Un PNG destiné au jeu reste net et
   divisible par 8 ; on ne rééchantillonne pas une illustration générée pour la faire passer pour un tileset.
2. **Le rendu généré est une composition, jamais une preuve de fidélité.** Les tuiles livrées sont
   natives ; la référence canonique (rip PMD) fixe les couleurs, avec un seuil de fidélité (≈ 35).
3. **Un calque par fonction** (sol, parois, ombres, animations…), du bas vers le haut, avec un
   calque `Top` vide au-dessus. Transparence propre, magenta exact, bases de fenêtres transparentes.
4. **Markers explicites** : `entrance` au sud, `boss` au centre, `objectif` au nord ; pas de warp
   non demandé, collisions vérifiées sur la grille.
5. **Tests avant livraison** : `test_build.py` (images, formats, cadence), `verify.py` (contrôle
   aveugle des sorties), puis `package.py` pour les ZIP et l'aperçu. Un test Python n'est **pas**
   un test moteur.
6. **Honnêteté sur l'état** : `art_approved: false`, aucun test runtime présenté comme fait,
   les aperçus approuvés ne valent pas validation à l'import.

---

*Dépôt d'origine : `meromoonmeri/projet-pmdo`. Dépôt de travail : `meromoonmeri/projet-creation-pmdo`.*
*Extraction du 2026-10-01, reproductible via `OUTILS/extraire_depuis_projet-pmdo.py`.*
