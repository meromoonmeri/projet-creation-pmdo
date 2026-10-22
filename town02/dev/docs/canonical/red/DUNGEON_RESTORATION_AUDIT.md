# PMD Red — matrice canonique des donjons

Source unique : `pret/pmd-red/data/dungeon`.  **64 ensembles, 1767 étages.**

| Donjon source | Étages | Groupes de tables | Zone New Era candidate | État |
|---|---:|---:|---|---|
| Autopilot | 10 | 10 | — | missing_zone |
| Boss3 | 20 | 20 | — | missing_zone |
| Boss4 | 11 | 11 | — | missing_zone |
| Boss9 | 12 | 12 | — | missing_zone |
| BuriedRelic | 99 | 99 | — | missing_zone |
| D50 | 2 | 2 | — | missing_zone |
| D51 | 50 | 50 | — | missing_zone |
| D54 | 30 | 30 | — | missing_zone |
| D61 | 99 | 99 | — | missing_zone |
| D63 | 1 | 1 | — | missing_zone |
| DarknightRelic | 15 | 15 | — | missing_zone |
| DesertRegion | 20 | 20 | — | missing_zone |
| DojoRegistration | 69 | 69 | — | missing_zone |
| FantasyStrait | 30 | 30 | — | missing_zone |
| FantasyStraitAlt | 19 | 19 | — | missing_zone |
| FaroffSea | 75 | 75 | — | missing_zone |
| FieryField | 30 | 30 | — | missing_zone |
| FrostyForest | 9 | 9 | frosty_forest | present_candidate |
| FrostyGrotto | 5 | 5 | — | missing_zone |
| GrandSea | 30 | 30 | — | missing_zone |
| GreatCanyon | 12 | 12 | — | missing_zone |
| HowlingForest | 15 | 15 | — | missing_zone |
| JoyousTower | 99 | 99 | — | missing_zone |
| LapisCave | 14 | 14 | lapis_cave | present_candidate |
| LightningField | 30 | 30 | — | missing_zone |
| MagmaCavern | 23 | 23 | magma_cavern | present_candidate |
| MagmaCavernPit | 3 | 3 | — | missing_zone |
| MarvelousSea | 20 | 20 | — | missing_zone |
| MeteorCave | 20 | 20 | — | missing_zone |
| MtBlaze | 12 | 12 | mt_blaze | present_candidate |
| MtBlazePeak | 3 | 3 | — | missing_zone |
| MtFaraway | 40 | 40 | — | missing_zone |
| MtFreeze | 15 | 15 | mt_freeze | present_candidate |
| MtFreezePeak | 5 | 5 | — | missing_zone |
| MtFreezePeakAlt | 4 | 4 | — | missing_zone |
| MtSteel | 9 | 9 | — | missing_zone |
| MtThunder | 10 | 10 | — | missing_zone |
| MtThunderPeak | 3 | 3 | — | missing_zone |
| MurkyCave | 19 | 19 | — | missing_zone |
| NorthernRange | 25 | 25 | — | missing_zone |
| NorthwindField | 30 | 30 | — | missing_zone |
| OddityCave | 15 | 15 | — | missing_zone |
| PitfallValley | 25 | 25 | — | missing_zone |
| PurityForest | 99 | 99 | — | missing_zone |
| RemainsIsland | 20 | 20 | — | missing_zone |
| RockPath | 4 | 4 | — | missing_zone |
| SilentChasm | 9 | 9 | — | missing_zone |
| SilverTrench | 99 | 99 | — | missing_zone |
| SinisterWoods | 13 | 13 | gloomy_forest | present_candidate |
| SkyTower | 25 | 25 | sky_tower | present_candidate |
| SkyTowerSummit | 9 | 9 | — | missing_zone |
| SnowPath | 4 | 4 | — | missing_zone |
| SolarCave | 20 | 20 | — | missing_zone |
| SouthernCavern | 50 | 50 | — | missing_zone |
| StormySea | 40 | 40 | — | missing_zone |
| ThunderwaveCave | 5 | 5 | — | missing_zone |
| TinyWoods | 3 | 3 | — | missing_zone |
| UnownRelic | 11 | 11 | — | missing_zone |
| UproarForest | 10 | 10 | — | missing_zone |
| WaterfallPond | 19 | 19 | waterfall_pond | present_candidate |
| WesternCave | 99 | 99 | — | missing_zone |
| WishCave | 99 | 99 | wish_cave | present_candidate |
| WondrousSea | 12 | 12 | — | missing_zone |
| WyvernHill | 30 | 30 | — | missing_zone |

## Contrat de restauration

Chaque entrée JSON conserve pour chaque étage les index `MainData`, `Pokemon`, `Traps`, `Items`, `KecleonShop`, `MonsterRoomItems` et `BuriedItems`, ainsi que les restrictions globales du donjon. Les ajouts New Era doivent être placés dans des segments/extensions distincts et ne doivent pas écraser cette base.

Les Grounds d’entrée, relais et boss seront associés dans la matrice de migration suivante; les 27 scènes dungeon-backed restent bloquées tant que les blobs ROM légaux ne sont pas disponibles.
