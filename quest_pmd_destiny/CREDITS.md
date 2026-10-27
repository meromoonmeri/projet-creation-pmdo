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
  `Title_Screen_Background.dir`) neutralisés **par défaut** : passe-les en
  « propre » dans `OUTILS/surcharge_provenance_tiles.json` s'il s'agit de vos
  propres versions.
