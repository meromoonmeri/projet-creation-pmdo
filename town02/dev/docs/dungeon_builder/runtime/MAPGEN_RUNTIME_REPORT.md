# Validation runtime de la génération — moteur RogueEssence

Généré par `tools/runtime/run_engine_mapgen.sh` : chaque ligne provient d'un appel
réel à `ZoneSegmentBase.GetMap(ZoneGenContext)` dans le moteur (même chemin que
MapGenTest), binaire PMDO officiel en headless ANGLE/SwiftShader.

- zones testées : **51**
- itérations : **3**
- générations tentées : **4287**
- réussies : **4287**
- échecs : **0**

## Traversabilité (données du moteur, `Map:TileBlocked`)

- étages analysés : **4287**
- étages dont tous les escaliers sont atteignables depuis le point d'entrée : **4281**
- étages avec une poche de terrain praticable non atteinte : **0**

| Zone | Segment | Étage | Escaliers | Atteignables | Praticables | Atteints |
|---|---|---|---|---|---|---|
| `buried_relic` | 2 | 32 | 0 | 0 | 345 | 345 |
| `buried_relic` | 2 | 32 | 0 | 0 | 345 | 345 |
| `buried_relic` | 2 | 32 | 0 | 0 | 345 | 345 |
| `meteor_cave` | 1 | 9 | 0 | 0 | 345 | 345 |
| `meteor_cave` | 1 | 9 | 0 | 0 | 345 | 345 |
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
| `buried_relic` | 297 | 2/9.3/32 | 62 | 40 | 10.4 |
| `darknight_relic` | 45 | 5/9.0/19 | 58 | 41 | 4.3 |
| `desert_region` | 60 | 2/10.1/28 | 61 | 39 | 6.7 |
| `fantasy_strait` | 90 | 4/9.5/25 | 51 | 40 | 5.4 |
| `far_off_sea` | 225 | 1/8.9/28 | 57 | 39 | 7.1 |
| `fiery_field` | 90 | 2/8.4/19 | 57 | 37 | 6.5 |
| `frosty_forest` | 27 | 6/10.9/26 | 53 | 37 | 6.5 |
| `frosty_grotto` | 15 | 7/14.3/23 | 64 | 35 | 8.6 |
| `gloomy_forest` | 42 | 5/11.0/22 | 61 | 41 | 9.3 |
| `grand_sea` | 90 | 4/9.8/17 | 58 | 39 | 8.0 |
| `great_canyon` | 36 | 4/8.9/24 | 55 | 36 | 8.0 |
| `howling_forest` | 45 | 5/15.3/34 | 59 | 38 | 7.2 |
| `joyous_tower` | 297 | 1/8.9/28 | 62 | 40 | 7.7 |
| `lapis_cave` | 42 | 5/13.3/29 | 65 | 40 | 6.9 |
| `lightning_field` | 90 | 2/8.4/18 | 54 | 37 | 6.5 |
| `magma_cavern` | 69 | 2/11.4/26 | 60 | 37 | 7.0 |
| `magma_cavern_pit` | 9 | 11/14.2/20 | 67 | 45 | 10.2 |
| `marvelous_sea` | 60 | 4/9.1/23 | 54 | 41 | 6.1 |
| `meteor_cave` | 60 | 4/12.3/27 | 60 | 39 | 7.4 |
| `mt_blaze` | 36 | 4/10.4/19 | 58 | 35 | 6.7 |
| `mt_blaze_peak` | 9 | 7/10.1/18 | 74 | 41 | 7.8 |
| `mt_faraway` | 120 | 1/8.1/24 | 57 | 36 | 5.8 |
| `mt_freeze` | 45 | 5/10.2/22 | 57 | 44 | 7.6 |
| `mt_freeze_peak` | 15 | 2/3.8/9 | 55 | 31 | 3.9 |
| `mt_steel` | 27 | 5/9.1/22 | 54 | 39 | 6.5 |
| `mt_thunder` | 30 | 4/8.2/13 | 57 | 39 | 7.4 |
| `mt_thunder_peak` | 9 | 4/9.0/14 | 63 | 35 | 8.3 |
| `murky_cave` | 57 | 4/11.4/28 | 61 | 39 | 7.1 |
| `northern_range` | 75 | 4/9.1/20 | 59 | 38 | 7.5 |
| `northwind_field` | 90 | 2/7.6/16 | 55 | 33 | 6.5 |
| `oddity_cave` | 45 | 6/13.7/31 | 62 | 41 | 9.2 |
| `pitfall_valley` | 75 | 4/9.7/26 | 61 | 39 | 7.0 |
| `purity_forest` | 297 | 1/10.5/32 | 60 | 37 | 6.9 |
| `remains_island` | 60 | 4/8.4/22 | 61 | 40 | 7.4 |
| `rock_path` | 12 | 6/12.3/21 | 68 | 36 | 7.8 |
| `silent_chasm` | 27 | 5/15.9/30 | 60 | 43 | 6.9 |
| `silver_trench` | 297 | 2/7.8/22 | 56 | 35 | 5.8 |
| `sky_tower` | 75 | 4/9.3/17 | 61 | 40 | 6.4 |
| `sky_tower_summit` | 27 | 3/10.0/26 | 61 | 45 | 11.6 |
| `snow_path` | 12 | 2/5.0/7 | 43 | 40 | 6.7 |
| `solar_cave` | 60 | 5/11.1/22 | 60 | 37 | 7.9 |
| `southern_cavern` | 150 | 2/10.7/26 | 57 | 39 | 6.4 |
| `stormy_sea` | 120 | 2/8.5/23 | 58 | 36 | 7.4 |
| `thunderwave_cave` | 15 | 6/14.3/27 | 58 | 42 | 7.1 |
| `tiny_woods` | 9 | 9/19.7/33 | 69 | 34 | 6.9 |
| `unown_relic` | 33 | 5/7.8/12 | 63 | 38 | 6.6 |
| `uproar_forest` | 30 | 7/13.3/24 | 60 | 35 | 7.9 |
| `waterfall_pond` | 57 | 3/8.1/16 | 55 | 35 | 5.5 |
| `western_cave` | 297 | 2/11.2/30 | 61 | 39 | 7.6 |
| `wish_cave` | 297 | 4/11.7/30 | 58 | 38 | 6.5 |
| `wyvern_hill` | 90 | 4/9.1/25 | 59 | 39 | 6.7 |

Ligne terminale du moteur : `{"event": "end", "attempted": 4287, "generated": 4287, "failures": 0, "non_traversable": 6}`

