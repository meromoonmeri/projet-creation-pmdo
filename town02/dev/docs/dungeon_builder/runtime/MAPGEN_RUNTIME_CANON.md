# Validation runtime de la génération — moteur RogueEssence

Généré par `tools/runtime/run_engine_mapgen.sh` : chaque ligne provient d'un appel
réel à `ZoneSegmentBase.GetMap(ZoneGenContext)` dans le moteur (même chemin que
MapGenTest), binaire PMDO officiel en headless ANGLE/SwiftShader.

- zones testées : **51**
- itérations : **1**
- générations tentées : **1429**
- réussies : **1429**
- échecs : **0**

## Traversabilité (données du moteur, `Map:TileBlocked`)

- étages analysés : **1429**
- étages dont tous les escaliers sont atteignables depuis le point d'entrée : **1427**
- étages avec une poche de terrain praticable non atteinte : **0**

| Zone | Segment | Étage | Escaliers | Atteignables | Praticables | Atteints |
|---|---|---|---|---|---|---|
| `buried_relic` | 2 | 32 | 0 | 0 | 345 | 345 |
| `meteor_cave` | 1 | 9 | 0 | 0 | 345 | 345 |

Un étage sans escalier est un **étage terminal** (salle fixe de boss chargée en `fixed_floors`) : le donjon s'y achève, il n'y a rien à rejoindre.

## Grounds de scène chargés par le moteur

- liaisons zone → Ground vérifiées : **54**
- problèmes : **0**

Chaque Ground est réellement désérialisé par `DataManager.GetGround`, son mode d'entrée est celui qu'appelle le script de zone (marqueur nommé ou index), et sa présence dans les `GroundMaps` de la zone est vérifiée : sans elle, `MoveToGround` refuse la transition.

## Échecs

Aucun. Tous les étages demandés ont été construits par le moteur.

## Par donjon

| Donjon | Étages générés | Salles min/moy/max | Largeur moy | Hauteur moy | ms moy |
|---|---|---|---|---|---|
| `buried_relic` | 99 | 2/9.1/32 | 62 | 40 | 15.8 |
| `darknight_relic` | 15 | 5/9.1/22 | 58 | 41 | 15.4 |
| `desert_region` | 20 | 2/9.5/21 | 61 | 39 | 11.1 |
| `fantasy_strait` | 30 | 3/9.4/22 | 51 | 40 | 9.1 |
| `far_off_sea` | 75 | 2/8.7/23 | 57 | 39 | 6.8 |
| `fiery_field` | 30 | 2/8.3/20 | 57 | 37 | 6.7 |
| `frosty_forest` | 9 | 6/10.7/26 | 53 | 37 | 3.7 |
| `frosty_grotto` | 5 | 8/14.2/21 | 64 | 35 | 10.4 |
| `gloomy_forest` | 14 | 6/10.9/18 | 61 | 41 | 8.9 |
| `grand_sea` | 30 | 5/9.5/16 | 58 | 39 | 7.5 |
| `great_canyon` | 12 | 6/9.2/14 | 55 | 36 | 3.6 |
| `howling_forest` | 15 | 7/14.0/26 | 59 | 38 | 7.7 |
| `joyous_tower` | 99 | 1/8.9/27 | 62 | 40 | 7.6 |
| `lapis_cave` | 14 | 5/13.4/26 | 65 | 40 | 11.2 |
| `lightning_field` | 30 | 3/8.4/17 | 54 | 37 | 6.0 |
| `magma_cavern` | 23 | 2/11.3/27 | 60 | 37 | 9.0 |
| `magma_cavern_pit` | 3 | 11/15.0/20 | 67 | 45 | 5.3 |
| `marvelous_sea` | 20 | 5/9.7/23 | 54 | 41 | 10.3 |
| `meteor_cave` | 20 | 5/12.8/26 | 60 | 39 | 9.1 |
| `mt_blaze` | 12 | 5/10.1/20 | 58 | 35 | 6.2 |
| `mt_blaze_peak` | 3 | 9/12.7/19 | 74 | 41 | 11.7 |
| `mt_faraway` | 40 | 3/8.4/25 | 57 | 36 | 7.7 |
| `mt_freeze` | 15 | 4/10.2/25 | 57 | 44 | 7.0 |
| `mt_freeze_peak` | 5 | 2/3.4/7 | 55 | 31 | 2.6 |
| `mt_steel` | 9 | 5/9.1/18 | 54 | 39 | 4.7 |
| `mt_thunder` | 10 | 4/7.9/12 | 57 | 39 | 10.2 |
| `mt_thunder_peak` | 3 | 4/6.3/8 | 63 | 35 | 9.7 |
| `murky_cave` | 19 | 4/11.6/24 | 61 | 39 | 8.6 |
| `northern_range` | 25 | 5/9.7/20 | 59 | 38 | 5.9 |
| `northwind_field` | 30 | 2/7.7/14 | 55 | 33 | 4.9 |
| `oddity_cave` | 15 | 7/13.9/29 | 62 | 41 | 6.3 |
| `pitfall_valley` | 25 | 5/9.4/23 | 61 | 39 | 7.7 |
| `purity_forest` | 99 | 2/10.4/30 | 60 | 37 | 7.5 |
| `remains_island` | 20 | 5/8.3/24 | 61 | 40 | 4.5 |
| `rock_path` | 4 | 5/12.5/20 | 68 | 36 | 13.2 |
| `silent_chasm` | 9 | 6/14.8/23 | 60 | 43 | 7.0 |
| `silver_trench` | 99 | 2/7.9/26 | 56 | 35 | 5.8 |
| `sky_tower` | 25 | 4/9.4/17 | 61 | 40 | 8.3 |
| `sky_tower_summit` | 9 | 3/10.2/17 | 61 | 45 | 8.4 |
| `snow_path` | 4 | 2/5.0/8 | 43 | 40 | 6.8 |
| `solar_cave` | 20 | 4/11.7/22 | 60 | 37 | 5.8 |
| `southern_cavern` | 50 | 2/10.8/27 | 57 | 39 | 6.6 |
| `stormy_sea` | 40 | 3/8.6/21 | 58 | 36 | 8.1 |
| `thunderwave_cave` | 5 | 9/16.4/26 | 58 | 42 | 10.0 |
| `tiny_woods` | 3 | 9/18.7/27 | 69 | 34 | 16.3 |
| `unown_relic` | 11 | 6/7.7/10 | 63 | 38 | 7.4 |
| `uproar_forest` | 10 | 6/13.9/23 | 60 | 35 | 4.7 |
| `waterfall_pond` | 19 | 4/8.2/16 | 55 | 35 | 6.8 |
| `western_cave` | 99 | 2/11.1/32 | 61 | 39 | 9.1 |
| `wish_cave` | 99 | 4/11.8/32 | 58 | 38 | 9.4 |
| `wyvern_hill` | 30 | 5/9.0/15 | 59 | 39 | 8.2 |

Ligne terminale du moteur : `{"event": "end", "attempted": 1429, "generated": 1429, "failures": 0, "non_traversable": 2}`

