# quest_pmd_destiny — Quest PMDO Destiny 0.8.12 (« comme town02 »)

La quest **Pokémon Mystery Dungeon: Destiny** contenant **toutes les maps
Ground de la bibliothèque** (165 maps clampées, 17 zones conteneurs),
intégrées sur le modèle de `meromoonmeri/town02` (quest « New Era : Abyss to
Ascension » — schéma `master_zone` / `sky_hub_zone`).

## Structure (identique à town02)

```
quest_pmd_destiny/
  Mod.xml                  # IDENTIQUE à la base Destiny — Namespace halcyon,
                           # UUID D571E9A0-…0812, GameVersion 0.8.12.0 (jamais modifiés)
  Data/Zone/<zone>.json    # 17 « zones conteneurs » : ZoneData avec
                           #   "Segments": [] + "GroundMaps": [...]
  Data/Zone/index.idx      # registre Dictionary<string, ZoneEntrySummary>
                           #   avec champ "Grounds" (comme town02)
  Data/Ground/*.rsground   # les 165 maps clampées (données, non suivies)
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
python3 OUTILS/construire_quest_destiny.py         # (idempotent)
```

## Ce qui reste à faire (Étape 2 / partie jeu)

- [ ] **Tests en jeu** (impossible depuis le sandbox) : chargement des zones,
  `GAME:EnterGroundMap(<map>, <marqueur>)`, caméra, collisions.
- [ ] Brancher les entrées/sorties (marqueurs `entrance`, warps) entre maps et
  vers les donjons (`RACCORDEMENT_DONJONS.json` des packs).
- [ ] Adapter noms/strings (`Strings/TextData`), `SV.*` dans `scriptvars.lua`.
- [ ] Fusion éventuelle des zones conteneurs dans le plan narratif de la quest.

Voir `bibliotheque_ground/README.md` (procédure d'import complète) et
`bibliotheque_ground/CREDITS.md` (provenance ; exclusions Étape 0).
