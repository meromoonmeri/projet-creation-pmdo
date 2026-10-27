# Crédits — quest_pmd_destiny

Tout le contenu de cette quest provient de `bibliotheque_ground/` et reste
soumis au même filtre de provenance : **voir `bibliotheque_ground/CREDITS.md`**
(détail dépôt par dépôt, auteur, licence, commit).

Résumé :

- 126 maps des ZIP livrés `meromoonmeri/projet-pmdo` (contenu original de
  l'auteur) + 39 maps des branches `arena/*` de `meromoonmeri/projet-creation-pmdo`.
- 7 maps de référence : base PMDO/DumpAsset (crédit PMDCollab), mod Halcyon
  (crédit auteur, licence à confirmer), univers Metano (auteur).
- **5 fichiers exclus** de l'import (Étape 0) : 2 dérivés d'un remake de jeu
  commercial (ExplorersOfSkyOrigins), 3 provenances à clarifier. Ils ne sont ni
  déclarés ni présents dans cette quest.
- 13 stubs en liens symboliques `.cache/tiles/` : absents de la quest
  (cibles non versionnées), listés dans `bibliotheque_ground/rapport_clamp.md`.
  **Récupérés depuis** : les maps sont régénérées par `source/<lot>/build.py`
  (voir `RAPPORT_MAPS_DESTINY.md`).

Note : les maps `metano_town`, `altere_pond`, `metano_cafe`, `ledian_dojo`,
`vast_steppe_entrance`, `crooked_cavern_entrance`… sont déjà déclarées dans le
`master_zone` de `meromoonmeri/town02` (quest New Era) — provenance propre au
projet, utilisable avec crédit.

## Tuiles town02 / WaterfallVillage (import « compatible quest »)

Les tuiles de `meromoonmeri/town02` (New Era : Abyss to Ascension, auteur
Minori) ont été importées dans `Content/Tile|BG` avec la règle suivante
(détail : `COMPATIBILITE_TUILES.md`, manifeste : `PLACEHOLDERS_HALCYON.json`) :

- **Créations Abyss Ascension : conservées à l'identique** (1 165 fichiers).
- **Éléments de Palikadude/Halcyon (mod tiers) : NON redistribués** (190
  fichiers identiques ou homonymes). Ils sont remplacés par des *placeholders
  neutres* de mêmes dimensions et coordonnées — les maps se chargent sans
  aucun pixel tiers. Crédit : Halcyon par Palika
  (github.com/Palikadude/Halcyon), sprites : Edan Momu, D4yz, Jaifain.
- `Content/Tile/index.idx` régénéré au format natif (1 279 tilesets).
- 2 fichiers homonymes modifiés (`Metano_Town_Base.tile`,
  `Title_Screen_Background.dir`) neutralisés **par défaut**. Depuis le 27 oct.
  2026, `Title_Screen_Background.dir` est passé **« propre »** sur attestation
  de l'utilisateur : le title screen animé PMD Destiny est une création de la
  quest (`pmd_destiny_fangame_v1`), pas un dérivé Halcyon
  (`OUTILS/surcharge_provenance_tiles.json`). `Metano_Town_Base.tile` reste
  neutre par défaut.

## Maps WaterfallVillage (« Reverie Town ») de town02

`WaterfallVillageCapital.rsground` et `waterfall_cave_1.rsground` sont les maps
de l'utilisateur dans `meromoonmeri/town02` (attestation : « TOUTES LES MAP
DANS APERCU SONT MES CREATIONS » ; WaterfallVillageCapital = « Reverie Town »).
`waterfall_cave_1` a été récupéré **sans LFS** (copie publique
`meromoonmeri/PMD-SKY-PMDO-PORT/output/Grounds/`, sha256 identique à l'objet
LFS) et intégré à la quest. `WaterfallVillageCapital` (233 Mo) reste à fournir
(fichier réel uniquement — l'objet LFS est hors de portée réseau du sandbox) ;
la zone `town02_waterfallvillage` est déjà déclarée et compatible.

## Title screen animé PMD Destiny (« Ray of Hope MIX »)

Ensemble intégré à la quest (fonds Jour/Nuit animés 24 poses, opening du blason
Œuf Ailé, UI Title/Enter, service `destiny_title_anim`, map-menu
`pmd_destiny_menu_jour`) : généré par `source/pmd_destiny_fangame_v1/build.py`
(branche `arena/e39626d2`) à partir des **bruts de l'utilisateur** (logo
œuf+ailes, mer pixelart jour/nuit, nuages cathédrale). Voir
`quest_pmd_destiny/TITLE_SCREEN_PMD_DESTINY.md`.

## Maps café — réseau Métano (2026-10-27)
- 5 maps (`metano_gen_accueil`, `metano_gen_cafe`, `metano_gen_casino`, `metano_gen_salon_bas`, `metano_gen_salon_haut`) : générations originales de l'utilisateur (série café/casino/salons), méthode guidée par images de référence.
- Références de travail créditées : Palikadude/Halcyon (`Metano_Town_Normal_Home`), formes Café Spinda — usage de référence uniquement, aucune tuile native tierce copiée dans la quest.
