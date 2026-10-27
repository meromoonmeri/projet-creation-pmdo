# Contexte projet — PMDO Destiny 0.8.12

## Quest cible

- **Pokémon Mystery Dungeon: Destiny** — quest PMDO **0.8.12**
  (`Mod.xml` de la base : `GameVersion 0.8.12.0`, `ModType Quest`).
- **Namespace `halcyon`**, UUID `D571E9A0-4C8B-4F2D-9E61-8A3B5C7D0812` :
  **jamais modifiés** (règle Étape 1).
- Base de travail déjà présente dans le dépôt :
  `renders/pmd_destiny_fangame_v1/fangame_base/` (Mod.xml, Data/Ground,
  Data/Script/halcyon/…, services/destiny_title_anim) + les apercus
  d'ouverture/title screen de l'index.

## Rôle de cette branche

Bibliothèque de maps Ground/`.rsground` **clampées** à importer dans la quest
(`bibliotheque_ground/`), construite par `OUTILS/construire_bibliotheque_ground.py`.
Toute nouvelle map ajoutée à une source (ZIP ou branche) est reprise par une
nouvelle exécution du script, qui régénère le rapport d'audit.

## Règles en vigueur (PROMPT)

- **Preuve avant hypothèse** : aucun fichier modifié sans lecture préalable ;
  toute source créditée dans `CREDITS.md` avant usage.
- **Exclusion ferme** des contenus issus de jeux commerciaux ou de leurs remakes
  (ExplorersOfSkyOrigins, pret/pmd-red, extractions de ROM, Spriters Resource,
  parties rippées de ProjectEoN) ; un dépôt mêlant original et rippé est
  écarté entier.
- Cohérence visuelle à l'import : biome/palette sans trahir la source, pas de
  mélange 8 px/24 px dans une même carte.
- Cinématiques (PARTIE 2) : tutoriel L6 + Scripting Cheat Sheet, dialogues
  français originaux, caméra dynamique, portraits vérifiés, transitions
  FadeOut → WaitFrames → EnterGroundMap, `docs/foreshadowing.md` tenu à jour.
- Validation : checklist du PROMPT dans `bibliotheque_ground/README.md` ;
  **tests en jeu à faire par l'utilisateur** (impossible depuis le sandbox).

## État au 27 octobre 2026

- Bibliothèque construite : 165 maps clampées (15 corrections hors zone,
  0 restante), 17 lots, rapports `rapport_clamp.{md,json}`.
- **Quest `quest_pmd_destiny/` générée « comme town02 »** : 17 zones conteneurs
  (`ZoneData` + `GroundMaps`), registre `Data/Zone/index.idx` (champ `Grounds`),
  165 maps déclarées = 165 sur disque (contrôle OK), `Mod.xml` identique.
- 5 fichiers exclus au titre de l'Étape 0 (2 remakes commerciaux,
  3 provenances ambiguës) ; 13 liens symboliques non matérialisés.
- Découverte : `metano_town`, `altere_pond`, `ledian_dojo`, `vast_steppe_entrance`
  etc. sont déjà déclarés dans le `master_zone` de `meromoonmeri/town02`
  (quest New Era) — provenance propre, à confirmer pour les sortir du doute.
- Prochaines étapes : tests en jeu (utilisateur), branchement des entrées/
  sorties et `RACCORDEMENT_DONJONS`, strings/`SV.*`, puis cinématiques (PARTIE 2).

## État au 27 octobre 2026 (suite — tuiles town02 + maps des aperçus)

- **Tuiles town02 importées** (1 355 fichiers `Content/Tile|BG`) avec séparation
  de provenance : 1 165 créations Abyss Ascension conservées à l'identique,
  **190 éléments Palikadude/Halcyon neutralisés** (placeholders de mêmes
  dimensions/coord., aucun pixel tiers ; `quest_pmd_destiny/COMPATIBILITE_TUILES.md`,
  `PLACEHOLDERS_HALCYON.json`, surcharge `OUTILS/surcharge_provenance_tiles.json`).
  `Content/Tile/index.idx` natif régénéré (2 269 tilesets, writer INSTALLER).
- **Toutes les maps des aperçus récupérées** : 98 scripts `source/**/build.py`
  exécutés (branche e39626d2), 97 maps régénérées + clampees — dont les
  **13 anciens stubs** (faille spatiale, forêt givrée, mine magma, monts,
  tour céleste…). Quest finale : **262 maps, 111 zones** (contrôle OK).
  Rapport : `quest_pmd_destiny/RAPPORT_MAPS_DESTINY.md`.
- 2 maps waterfall de town02 (`WaterfallVillageCapital` 233 Mo,
  `waterfall_cave_1`) stockées en **Git LFS** : récupération via l'artefact
  GitHub `.github/workflows/recuperer_lfs_town02.yml` (hébergeur LFS bloqué
  depuis le sandbox) — à intégrer ensuite comme lot `town02_waterfallvillage`.
- Reste à faire : tests en jeu ; confirmer les 33 noms de tuiles d'origine non
  vérifiée (liste dans `COMPATIBILITE_TUILES.md`) ; les 28 lots d'aperçu sans
  script de build (études/prototypes — non régénérables automatiquement,
  listés au rapport) ; cinématiques (PARTIE 2).

## Repères de documentation

- RogueEssence (Lua) : https://github.com/RogueCollab/RogueEssence
- PMDC / PMDCollab : https://github.com/PMDCollab
- PMDODump 0.8.12 : https://github.com/audinowho/PMDODump
- Wiki PMDO : https://wiki.pmdo.pmdcollab.org/
- Tutoriel PMDOTutorial (L1-L8) : https://github.com/audinowho/PMDOTutorial/releases
- Pipeline maps : `meromoonmeri/guilde-treehouse-pmd` (`MANUEL_METHODE_PMDO.md`, `AGENTS.md`)
