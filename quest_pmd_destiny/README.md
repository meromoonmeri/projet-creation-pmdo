# quest_pmd_destiny — Quest PMDO Destiny 0.8.12 (« comme town02 »)

La quest **Pokémon Mystery Dungeon: Destiny** contenant **toutes les maps
Ground de la bibliothèque** (262 maps clampées, 111 zones conteneurs),
intégrées sur le modèle de `meromoonmeri/town02` (quest « New Era : Abyss to
Ascension » — schéma `master_zone` / `sky_hub_zone`).

## Structure (identique à town02)

```
quest_pmd_destiny/
  Mod.xml                  # IDENTIQUE à la base Destiny — Namespace halcyon,
                           # UUID D571E9A0-…0812, GameVersion 0.8.12.0 (jamais modifiés)
  Data/Zone/<zone>.json    # 111 « zones conteneurs » : ZoneData avec
                           #   "Segments": [] + "GroundMaps": [...]
  Data/Zone/index.idx      # registre Dictionary<string, ZoneEntrySummary>
                           #   avec champ "Grounds" (comme town02)
  Data/Ground/*.rsground   # les 262 maps clampées (données, non suivies)
  Data/Script/ground/<map>/init.lua
  Content/Tile/ + Content/BG/
```

- Zones = les lots de la bibliothèque (`bibliotheque_ground/lots/<lot>/lot.json`
  porte la même déclaration `GroundMaps`).
- **20 homonymes entre packs** ont été renommés avec le préfixe du lot
  (`<lot>__<map>.rsground`) — règle Étape 2.2 : « deux homonymes s'écrasent →
  préfixer ». Les deux versions sont conservées (pas d'écrasement).
- 0 écart entre `GroundMaps` déclarés et fichiers sur disque (contrôle automatique).

## Régénérer

```
python3 OUTILS/construire_bibliotheque_ground.py   # si bibliotheque_ground/lots absent
python3 OUTILS/construire_maps_destiny.py          # régénère les maps des aperçus (builds)
python3 OUTILS/importer_tiles_town02.py            # tuiles town02 + placeholders Halcyon + index
python3 OUTILS/construire_quest_destiny.py         # (idempotent)
```

## Toutes les maps des aperçus (visionneuses comprises)

**Toutes les maps des aperçus sont dans la quest** : les 126 maps des ZIP, les
39 maps des branches, et les **97 maps régénérées** par les scripts
`source/**/build.py` de la branche `arena/e39626d2` (98 scripts exécutés avec
succès : arènes, entrées, fins de donjon, faille spatiale, monts, tours,
zone zéro, ouvertures Destiny…). Les 13 anciens stubs en liens symboliques
sont remplacés par leurs vraies maps. Détail : `RAPPORT_MAPS_DESTINY.md`,
rapport machine : `../bibliotheque_ground/rapport_maps_destiny.json`.

Les images de référence servant aux builds (captures de jeux commerciaux
utilisées comme références de dessin) restent **hors de la quest** et ne sont
pas distribuées. Règles d'honnêteté conservées : `art_approved: false`,
`runtime_tested: false`.

## Tuiles town02 compatibles (sans éléments tiers)

Les 1 355 fichiers `Content/Tile|BG` de town02 ont été importés avec la règle
suivante (détail : `COMPATIBILITE_TUILES.md`) :

- **1 165 fichiers = créations Abyss Ascension** : copiés à l'identique ;
- **190 fichiers = Palikadude/Halcyon** (contenu tiers) : **art non
  redistribué**, remplacés par des placeholders neutres de mêmes dimensions et
  coordonnées — les maps se chargent sans aucun pixel tiers ;
- `Content/Tile/index.idx` régénéré (2 269 tilesets, format natif INSTALLER) ;
- 2 homonymes modifiés neutralisés par défaut, basculables via
  `OUTILS/surcharge_provenance_tiles.json`.

## Ce qui reste à faire (Étape 2 / partie jeu)

- [ ] **Tests en jeu** (impossible depuis le sandbox) : chargement des zones,
  `GAME:EnterGroundMap(<map>, <marqueur>)`, caméra, collisions.
- [ ] Brancher les entrées/sorties (marqueurs `entrance`, warps) entre maps et
  vers les donjons (`RACCORDEMENT_DONJONS.json` des packs).
- [ ] Adapter noms/strings (`Strings/TextData`), `SV.*` dans `scriptvars.lua`.
- [ ] Fusion éventuelle des zones conteneurs dans le plan narratif de la quest.

Voir `bibliotheque_ground/README.md` (procédure d'import complète) et
`bibliotheque_ground/CREDITS.md` (provenance ; exclusions Étape 0).
