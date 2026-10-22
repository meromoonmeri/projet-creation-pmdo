# Lot Red Story 02 — Silent Chasm + Great Canyon

## Statut

| Donjon | Floors | Mapgen PMDO | Route PMDO | Promotion | Blocker restant |
|---|---:|---:|---:|---:|---|
| Silent Chasm | 9  | 90/90, invalid 0  | PASS | **oui** (PROMOTED_RUNTIME_VALIDATED) | — |
| Great Canyon | 12 | 120/120, invalid 0 | PASS | **oui** (PROMOTED_RUNTIME_VALIDATED) | — |

Les deux routes chargent l'entrée canonique (Ground `gouffre_muet_bord`, resp. `grand_canyon_porte`), traversent tous les floors procéduraux, arrivent sur le **Ground final canonique PMD Red** (`d05p02`, resp. `d07p02`), y déclenchent la cinématique canonique via `RedCanonScene.Play` et retournent au Ground d'entrée après `EndDungeonRun`. La scène finale et le combat éventuel se déroulent **sur le même Ground que dans la ROM PMD Red** — aucune arène séparée n'est inventée.

Preuves PMDO 0.8.12 :

- `runtime/native_mapgen.jsonl` : 210 générations natives (90 Silent + 120 Great) via
  `ZoneSegmentBase.GetMap(ZoneGenContext)`, seeds toutes distinctes, architectures variées.
  - Silent Chasm : rooms 10–18 (médiane 13), halls 24–51, loops 1–57
  - Great Canyon : rooms 4–18 (médiane 12), halls 7–63, loops 1–58
- `runtime/routes/silent_chasm.jsonl` : 25 events, `grounds=[gouffre_muet_bord, d05p02,
  gouffre_muet_bord]`, `canonical_end.scene_complete=true`, `end.canonical_complete=true`.
- `runtime/routes/great_canyon.jsonl` : 31 events, `grounds=[grand_canyon_porte, d07p02,
  grand_canyon_porte]`, `canonical_end.scene_complete=true`, `end.canonical_complete=true`.

## Règles réconciliées

- Nom canonique (Silent Chasm / Great Canyon), pas d'ID technique visible.
- Musique canonique extraite de la ROM PMD Red EU
  (`Content/Music/Silent Chasm.ogg` et `Content/Music/Great Canyon.ogg`, provenance
  `docs/canonical/red/audio/pmdred_eu_music_extraction.json`).
- Tileset propre au donjon (`silent_chasm_{floor,wall,secondary}` et
  `great_canyon_{floor,wall,secondary}` de PMDO base, jamais `sinister_woods_b41_*`).
- shops désactivés, Monster Houses désactivées, météo claire.
- Species, probabilités, objets et floors issus du manifest ROM ; ITEM_BLOWBACK_ORB,
  ITEM_HURL_ORB, ITEM_RADAR_ORB, ITEM_SWITCHER_ORB, ITEM_WARP_ORB, ITEM_TM_TOXIC,
  ITEM_STAMINA_BAND, ITEM_GOLD_RIBBON explicitement `SKIPPED_MISSING_IN_PMDO_BASE`
  (documenté au niveau du floor items block dans la definition staged).
- Fixed floors : aucun (les 9 floors de Silent et 12 floors de Great sont tous
  procéduraux dans la ROM).
- Ground final canonique = combat canonique = même endroit
  (`battle_ground = canonical_end_ground = cinematic_ground`).

## Rappels d'infrastructure

- `Data/Item/index.idx` : 13 items PMDODump base importés (medicine_max_elixir,
  tm_aerial_ace, tm_brick_break, tm_bullet_seed, tm_dig, tm_facade, tm_frustration,
  tm_giga_drain, tm_hidden_power, tm_rest, tm_return, tm_roar, tm_safeguard,
  tm_secret_power, tm_shadow_ball, tm_shock_wave, tm_taunt, tm_thief) depuis
  `audinowho/DumpAsset@d74394dc…` (le commit épinglé par `scope_registry.py`),
  Version downgraded à 0.8.9.0 pour cohérence avec les 240 autres items du repo.
- `Data/Script/halcyon/common.lua:RespawnAllies/RespawnGuests` : pre-check `Spawners`
  au lieu d'un pcall, corrige les Grounds PMD Red d'entrée/final qui n'embarquent
  pas de spawners `TEAMMATE_N`/`GUEST_N` (silent/great/tiny/thunderwave/gloomy).
- `Data/Script/halcyon/ground/{gouffre_muet_bord,grand_canyon_porte,d05p02,d07p02}/init.lua` :
  garde `os.getenv('PMDO_RED_STORY_ROUTE_VALIDATOR')` — le validator lua drive la
  transition d'entrée et l'`EndDungeonRun`, les scripts Ground cèdent le contrôle.
- `Data/Script/halcyon/zone/silent_chasm/init.lua` :
  `EnterZone(zone.ID, -1, ZONE_GROUND_IDX(zone, 'd05p02'), 0)` (comme `tiny_woods`
  au lieu de `EnterGroundMap` seul, qui restait bloqué dans la DungeonScene).
- `Data/Script/halcyon/zone/great_canyon/init.lua` : segment 0 unique de 12 floors
  vers `d07p02` (ancien script `great_canyon.ExitSegment` chargeait un segment 1
  inexistant dans la nouvelle définition staged).
- `Data/Zone/index.idx` : Silent et Great re-registered avec le vrai layout
  1-segment (l'index héritait de 2 segments × 6 floors, ce qui faisait échouer
  `MoveToZone(great_canyon, seg=0, floor=6)` avec `Invalid Segment ID`).
- `Data/Script/halcyon/services/red_story_route_validator/init.lua` :
  `CONFIG.silent_chasm` et `CONFIG.great_canyon` ajoutés.
- `tools/dungeon_builder/red_story_batch_02.py` : profils resserrés
  (`grid_x=[5,7]`, `grid_y=[4,6]`, `combine_rate=0`) pour éliminer les floors
  trop pauvres (3 rooms / 4 halls / 0 branches) observés sur la première passe
  du mapgen (17 invalid sur 210 avant fix ; 0/210 après).
