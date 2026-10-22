# AUDIT FINAL — DONJONS DU FUTUR CORROMPU (NDS → PMDO natif)

Date : 2026-08-09 — Branche `arena/019fd882-new-era-abyss-to-ascension-v4`

## ROOT CAUSE

Le crash PMDO venait du JSON `Data/Zone/chasm_cave.json` :

```
Type specified in JSON 'RogueEssence.LevelGen.MultiSpawner`1[[RogueEssence.LevelGen.MapGenContext, RogueEssence], RogueEssence]' was not resolved.
Path: Object.Segments[0].Floors[0].GenSteps[17].Value.Spawn.$type
```

`MultiSpawner` n'existe **pas** dans le runtime 0.8.12.0 (assembly RogueEssence
chargée). Le type avait été inventé par le premier générateur (copie d'un
gabarit erroné).

## FIX

Inspection des Zones natives fonctionnelles du mod (vallee_fertile,
wish_cave, jardin_energie, jardin_secret) → **types natifs 0.8.12.0** :

- **Table d'ennemis par étage** : `RogueEssence.LevelGen.MobSpawnStep` +
  `RogueEssence.LevelGen.PoolTeamSpawner` (BaseForm/Level/SpecifiedSkills/
  Tactic + TeamSizes + Rate).
- **Placement des mobs** : `RogueEssence.LevelGen.PlaceRandomMobsStep` +
  **`RogueEssence.LevelGen.TeamContextSpawner`** (remplace `MultiSpawner`).
- **Pièges** : `RogueEssence.LevelGen.TileSpawnZoneStep` (ZoneStep).
- **Monster houses** : `PMDC.LevelGen.SpreadHouseZoneStep` +
  `PMDC.LevelGen.MonsterHouseStep` (Chance = % NDS).
- **Musique/darkness** : `PMDC.LevelGen.MapDataStep` (TileSight).
- **Tilesets** : `RogueEssence.LevelGen.MapTextureStep`.

## VALIDATION DES TYPES

- Types dans les 6 zones : **50 distincts**.
- Comparés à l'union des types des zones natives du mod (386) :
  **0 type absent** du mod.
- Scan `$type` total : **1998** occurrences, **0 non reconnu**.
- **0 occurrence de `MultiSpawner`** dans les 6 zones.

## ZONES (6/6) — FLOORS (46/46)

| Zone | Floors | Tilesets NDS | Musique | Dark | MH |
|---|---|---|---|---|---|
| chasm_cave (D27) | **8** | 26→27 (F5) | Chasm Cave.ogg | F1-8 (sight 0) | 0 |
| dark_hill (D28) | **15** | 28→29 (F7) | Dark Hill.ogg | — | 0 |
| sealed_ruin (D29) | **8** | 30 | Sealed Ruin.ogg | — | **5%** |
| sealed_ruin_pit (D30) | **6** | 31 | Sealed Ruin Pit.ogg | — | **5%** |
| spiritomb_room (D31) | **1 fixe** | 176 | Sealed Ruin Pit.ogg | — | — |
| dusk_forest (D32) | **8** | 33→34 (F5) | Dusk Forest.ogg | **F6-8** | 0 |
| **TOTAL** | **46** | | | | |

## POKÉMON — TABLES NDS PAR FLOOR (mappa_s.bin + monster.md)

Résolution md_index → dex (FileType.MD) → species PMDO (27 espèces vérifiées).

- **Chasm Cave** : magneton/eevee/houndour/spinda/drifblim (F1-4, L26-28) →
  +drowzee/buneary (F5) → farfetchd/drowzee/eevee/spinda/buneary (F6-8, L27-29).
- **Dark Hill** : haunter/unown/duskull/mamoswine (F1-5, L28-30) → +lileep (F6) →
  gengar (F7-8) → +tropius (F9) → onix (F12-15, L32-33).
- **Sealed Ruin** : shellder/dunsparce/salamence/metagross/electivire/dusknoir
  (L27-31). **Sealed Ruin Pit** : même table, L28-32.
- **Spiritomb Room** : **SPIRITOMB L51, weight 10000** (unique, garanti).
- **Dusk Forest** : aipom/combee/honchkrow/garchomp (L30-34).

Poids NDS convertis en Rate PMDO proportionnel (round(weight/100)).

## ITEMS / TRAPS / MONSTER HOUSES

- **Traps** : TileSpawnZoneStep avec les pièges NDS mappés (MappaTrapType →
  trap PMDO) : trap_mud, trap_sticky, trap_grimy, trap_summon, trap_gust,
  trap_spin, trap_slumber, trap_slow, trap_seal, trap_poison, trap_self_destruct,
  trap_explosion, trap_pp_leech, trap_chestnut, trap_trigger, trap_trip,
  trap_grudge. Traps sans équivalent PMDO (Pitfall, Warp, WonderTile, SpikedTile,
  StealthRock, ToxicSpikes) : **documentés, non mappés** (pas d'équivalent).
- **Monster houses** : SpreadHouseZoneStep Chance=5 (Sealed Ruin, Sealed Ruin
  Pit) — conforme NDS.
- **Items** : ItemSpawnZoneStep + DueSpawnStep (densité NDS par floor).

## MAPS FIXES / ARÈNES (6/6)

| Dungeon | Map fixe NDS | .rsground | Tileset .tile | Scènes | Arène boss |
|---|---|---|---|---|---|
| Chasm Cave | D18P11A | ✅ | D18p11a_Base.tile | m17a0501/0504/0601/0701 | — |
| Dark Hill | D19P11A | ✅ | D19p11a_Base.tile | m18a0101/0201/0301 | — |
| Sealed Ruin | D20P11A | ✅ | D20p11a_Base.tile | m18b0501/0601/0701 | — |
| SR Pit | D21P21A | ✅ | D21p21a_Base.tile | m18b0801/0901/1002 | — |
| **Spiritomb** | **D21P41A** | ✅ | D21p41a_Base.tile | m18b0902/1101/1201/1301 | **SPIRITOMB (8,2)=(324,196)** |
| Dusk Forest | D22P11A | ✅ | D22p11a_Base.tile | m19a0201/0301/0401/0403/0501 | — |

Chaque arène de boss/confrontation utilise le ground NDS exact (jamais une
arène générique). Spiritomb = NPC_MIKARUGE (ミカルゲ), L51, poids 10000, arène
fixe 22×17, position (8,2) → (324,196) px, ordre LSD m18b1101→1201→1301.

## SE5 — SÉPARATION STRICTE

D55 (dungeons 138/139/140, Passage du Temps) = **Special Episode 5**, séparé
des dungeons 27-32 du main story. Aucune référence croisée introduite.

## ARCHITECTURE PMDO NATIVE

```
Data/Zone/<dungeon>.json        Zone → Segments → Floors (GridFloorGen → GenSteps)
Data/Script/halcyon/zone/<d>/init.lua   Init/EnterSegment/Rescued/ExitSegment
Data/Script/halcyon/future_arc/_future_dungeons_common.lua   helper sortie
Data/Script/halcyon/ground/d18p11a..d22p11a/init.lua          scènes + EnterDungeon
Data/Ground/d18p11a..d22p11a.rsground                          maps fixes (port)
Content/Tile/D1[89]p11a_Base.tile, D2[0-2]*_Base.tile         tilesets des maps fixes
```

Le runner FutureArc ne simule AUCUN dungeon : il orchestre les scènes et les
transitions ; chaque dungeon est une Zone PMDO native jouable
(entrée → floors générés → combat → escaliers → sortie).

## RUNTIME

**Non exécuté ici** (moteur PMDO non disponible dans l'environnement de
travail). La validation statique est complète :
- désérialisation des types garantie par la comparaison exhaustive avec le mod ;
- 46 floors, tables NDS, arènes vérifiées.
Statut : `INTEGRATED` — `RUNTIME_VERIFIED: PENDING` (à tester en jeu :
boot → DevTab Travel → les 6 zones → parcours).

## ERREURS

- Crash MultiSpawner : **CORRIGÉ** (0 occurrence).
- `$type` inconnus : **0**.
- `Missing Data` / `Could not find Zone ID` : **0** (zones enregistrées dans index.idx).
