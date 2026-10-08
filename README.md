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

## Par où commencer

| Document | Rôle |
|---|---|
| **[WORKFLOW.md](WORKFLOW.md)** | **Procédure de session** : ouvrir, copier le gabarit, générer, tester, documenter, commit |
| **[GUIDE_CREATION_DE_MAP.md](GUIDE_CREATION_DE_MAP.md)** | **La méthode pas à pas**, du rendu généré au Ground importé dans PMDO |
| **[METHODE_MAGENTA_ET_GENERATEUR.md](METHODE_MAGENTA_ET_GENERATEUR.md)** | **Comment ça marche** : générateur d'images → fond magenta → tuiles natives (formules, seuils, fidélité) |
| **[source/methode_serie_sud_nord/](source/methode_serie_sud_nord/)** | Gabarit, ordre des lots, préfixes, **carte suivante (Fin Mt. Thunder)** |
| [INDEX_METHODES.md](INDEX_METHODES.md) | Tableau des **208+ sous-projets** : générateur, tests, package, provenance, Ground/tileset, WORKFLOW |
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
├── WORKFLOW.md       procédure de session (série courante 4:3)
├── source/           208+ chantiers de map, chacun autonome
│   ├── methode_serie_sud_nord/   gabarit, STATUS, préfixes, carte suivante
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
└── OUTILS/           extraction reproductible ; `ecrire_workflows_lots.py` (WORKFLOW par lot)
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
