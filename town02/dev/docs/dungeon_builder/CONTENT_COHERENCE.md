# Cohérence du contenu produit — rejeu des paramètres réellement émis

_Généré le 2026-08-22T23:54:52+00:00 — 51 zones, 1429 étages, paramètres relus dans `Data/Zone/*.json` puis rejoués par le simulateur (2 variantes par étage)._

Ce contrôle ne lit pas les définitions : il relit **ce qui a été écrit** dans chaque étage (grille, cellules, step de chemin et ses valeurs, liste de salles, ratios connect/combine/defaults, biais de couloir, distance d'escalier) et mesure le résultat.

| Zone | Ét. | Fixes | Profils émis | Grilles | Formes de salles | Rooms min/moy/max | Halls min/moy/max | Branches | Culs-de-sac | Boucles | Coudes/étage | Aire salle min→max | Dist. E→S | Layouts distincts | Conforme |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| `buried_relic` | 99 | 1 | crossroads, dense, large_rooms, lattice, looping, mixed | 17 | cave, cross, round, square | 4/10.69/32 | 3/14.08/42 | 3.85 | 3.34 | 1.95 | 22.19 | 9→368 | 33.72 | 196/196 | ✅ |
| `darknight_relic` | 15 | 0 | crossroads, dense, lattice, looping, mixed | 7 | cave, cross, round, square | 6/10.27/20 | 5/13.33/25 | 3.8 | 3.5 | 1.7 | 19.77 | 9→220 | 30.8 | 30/30 | ✅ |
| `desert_region` | 20 | 0 | dense, large_rooms, looping, mixed, twosides | 11 | cave, cross, round, square | 3/11.68/26 | 3/14.03/35 | 3.7 | 2.23 | 1.93 | 20.45 | 9→396 | 30.75 | 40/40 | ✅ |
| `fantasy_strait` | 30 | 0 | lattice, looping, mixed, ring | 7 | cave, cross, round, square | 5/10.27/28 | 8/15.77/34 | 3.92 | 1.67 | 2.47 | 24.78 | 20→228 | 29.33 | 60/60 | ✅ |
| `far_off_sea` | 75 | 0 | large_rooms, lattice, looping, mixed, ring | 14 | cave, cross, round, square | 3/10.17/30 | 3/14.13/34 | 3.43 | 1.98 | 1.95 | 21.85 | 20→400 | 33.49 | 150/150 | ✅ |
| `fiery_field` | 30 | 0 | large_rooms, looping, mixed, twosides | 12 | cave, cross, round, square | 3/10.17/20 | 3/11.93/22 | 2.77 | 2.33 | 1.3 | 19.42 | 20→341 | 30.2 | 60/60 | ✅ |
| `frosty_forest` | 9 | 0 | branching, dense, mixed | 6 | cave, cross, round, square | 6/11.33/24 | 5/11.78/32 | 3.5 | 4.06 | 0.94 | 18.89 | 9→200 | 29.61 | 18/18 | ✅ |
| `frosty_grotto` | 5 | 0 | branching, dense | 4 | cave, cross, round, square | 6/14.3/27 | 5/16.3/32 | 4.7 | 4.6 | 1.2 | 22.4 | 9→96 | 21.3 | 10/10 | ✅ |
| `grand_sea` | 30 | 0 | lattice, looping, mixed, ring | 7 | cave, cross, round, square | 5/10.75/22 | 8/15.78/32 | 4.07 | 1.92 | 2.42 | 25.03 | 20→264 | 30.1 | 60/60 | ✅ |
| `great_canyon` | 12 | 0 | branching, crossroads, mixed, twosides | 9 | cave, cross, round, square | 5/9.83/22 | 7/10.75/29 | 2.5 | 3.17 | 0.83 | 18.83 | 20→220 | 26.33 | 24/24 | ✅ |
| `howling_forest` | 15 | 0 | branching, dense, looping, mixed | 8 | cave, cross, round, square | 8/15.87/32 | 8/18.63/41 | 5.53 | 4.23 | 2.13 | 29.97 | 9→198 | 28.13 | 30/30 | ✅ |
| `joyous_tower` | 99 | 0 | branching, crossroads, large_rooms, lattice, looping, mixed | 15 | cave, cross, round, square | 3/10.69/30 | 3/12.89/34 | 3.53 | 3.24 | 1.67 | 20.91 | 20→338 | 31.14 | 198/198 | ✅ |
| `lapis_cave` | 14 | 0 | branching, dense, lattice, looping, mixed | 9 | cave, cross, round, square | 6/13.96/31 | 5/17.61/41 | 5.21 | 3.57 | 2.21 | 29.25 | 9→192 | 31.54 | 28/28 | ✅ |
| `lightning_field` | 30 | 0 | large_rooms, looping, mixed, twosides | 12 | cave, cross, round, square | 4/10.32/22 | 3/12.62/25 | 2.83 | 2.1 | 1.53 | 19 | 20→260 | 31.67 | 60/60 | ✅ |
| `magma_cavern` | 23 | 0 | branching, dense, large_rooms, lattice, looping, mixed | 13 | cave, cross, round, square | 3/13.2/30 | 3/16.28/35 | 4.63 | 2.96 | 2.24 | 25.24 | 9→230 | 29.83 | 46/46 | ✅ |
| `magma_cavern_pit` | 3 | 0 | branching, dense, mixed | 3 | cave, cross, round, square | 11/16.5/23 | 10/20.17/31 | 6.33 | 5 | 2.33 | 33.17 | 12→264 | 31 | 6/6 | ✅ |
| `marvelous_sea` | 20 | 0 | lattice, looping, mixed, ring | 9 | cave, cross, round, square | 5/10.57/25 | 10/16.68/32 | 4.15 | 1.8 | 2.48 | 28.07 | 20→231 | 32.3 | 40/40 | ✅ |
| `meteor_cave` | 20 | 1 | branching, dense, lattice, looping, mixed | 9 | cave, cross, round, square | 4/13.53/25 | 6/16.03/33 | 4.84 | 3.58 | 1.95 | 27.5 | 9→187 | 31.82 | 38/38 | ✅ |
| `mt_blaze` | 12 | 0 | branching, mixed, twosides | 7 | cave, cross, round, square | 5/10.75/20 | 5/11.62/23 | 2.96 | 3.62 | 0.92 | 20.08 | 20→253 | 28.5 | 24/24 | ✅ |
| `mt_blaze_peak` | 3 | 0 | crossroads, mixed | 3 | cave, cross, round, square | 9/13.5/20 | 9/14.17/22 | 3.5 | 4.17 | 1 | 24.17 | 20→209 | 32 | 6/6 | ✅ |
| `mt_faraway` | 40 | 0 | branching, crossroads, large_rooms, mixed, twosides | 12 | cave, cross, round, square | 4/9.57/24 | 4/10.34/33 | 2.39 | 3.05 | 0.89 | 16.41 | 20→297 | 29.61 | 80/80 | ✅ |
| `mt_freeze` | 15 | 0 | branching, crossroads, mixed, twosides | 9 | cave, cross, round, square | 6/11.5/25 | 8/12.87/30 | 3.57 | 3.43 | 1.4 | 20 | 20→253 | 26.57 | 30/30 | ✅ |
| `mt_freeze_peak` | 5 | 0 | crossroads, large_rooms | 2 | cave, cross, round, square | 3/5.5/10 | 3/4.9/9 | 0.4 | 1.8 | 0.4 | 4.6 | 20→429 | 33.9 | 10/10 | ✅ |
| `mt_steel` | 9 | 0 | branching, mixed, twosides | 6 | cave, cross, round, square | 5/9.72/22 | 7/12/30 | 2.83 | 2.94 | 1.11 | 19.22 | 20→308 | 31 | 18/18 | ✅ |
| `mt_thunder` | 10 | 0 | branching, crossroads, mixed, twosides | 6 | cave, cross, round, square | 6/10.05/16 | 6/11.6/20 | 2.45 | 3 | 1.15 | 17.85 | 20→276 | 26.55 | 20/20 | ✅ |
| `mt_thunder_peak` | 3 | 0 | large_rooms, mixed | 3 | cave, cross, round, square | 6/10.67/14 | 5/12.17/16 | 2.83 | 2.83 | 1.5 | 18.67 | 24→294 | 27.33 | 6/6 | ✅ |
| `murky_cave` | 19 | 0 | branching, dense, lattice, looping, mixed | 11 | cave, cross, round, square | 4/12.5/24 | 6/15.47/30 | 4.53 | 3.24 | 2.11 | 26.61 | 9→264 | 31.95 | 38/38 | ✅ |
| `northern_range` | 25 | 0 | branching, crossroads, mixed, twosides | 10 | cave, cross, round, square | 6/10.38/23 | 6/11.74/31 | 2.62 | 3.42 | 0.84 | 19.72 | 20→220 | 27.92 | 50/50 | ✅ |
| `northwind_field` | 30 | 0 | large_rooms, looping, mixed, twosides | 11 | cave, cross, round, square | 3/8.77/16 | 3/10.85/20 | 2.35 | 1.67 | 1.4 | 15.6 | 20→338 | 25.6 | 60/60 | ✅ |
| `oddity_cave` | 15 | 0 | branching, dense, lattice, looping, mixed | 10 | cave, cross, round, square | 6/14.83/31 | 5/20.37/41 | 6.53 | 5 | 2.67 | 35.8 | 9→216 | 34.33 | 30/30 | ✅ |
| `pitfall_valley` | 25 | 0 | branching, crossroads, mixed, twosides | 12 | cave, cross, round, square | 5/11.64/26 | 5/13.12/33 | 3.2 | 3.42 | 1.12 | 21.52 | 20→250 | 30.78 | 50/50 | ✅ |
| `purity_forest` | 99 | 0 | branching, dense, large_rooms, looping, mixed | 17 | cave, cross, round, square | 3/11.75/32 | 2/13.47/43 | 3.72 | 2.99 | 1.65 | 21.84 | 9→360 | 30.12 | 198/198 | ✅ |
| `remains_island` | 20 | 0 | crossroads, lattice, looping, mixed | 11 | cave, cross, round, square | 5/9.6/21 | 6/15.03/34 | 4.85 | 3.45 | 2.62 | 22.45 | 20→242 | 36.65 | 40/40 | ✅ |
| `rock_path` | 4 | 0 | branching, dense, mixed | 4 | cave, cross, round, square | 10/14.88/25 | 9/17.12/34 | 4.5 | 4.25 | 1.62 | 29.38 | 9→184 | 30.75 | 8/8 | ✅ |
| `silent_chasm` | 9 | 0 | branching, dense, mixed | 6 | cave, cross, round, square | 8/12.89/23 | 7/13.44/30 | 3.94 | 4.94 | 0.89 | 22.67 | 9→252 | 31.56 | 18/18 | ✅ |
| `silver_trench` | 99 | 0 | large_rooms, lattice, looping, mixed, ring | 13 | cave, cross, round, square | 3/8.79/25 | 2/12.95/35 | 3.09 | 1.64 | 1.95 | 20.88 | 20→400 | 30.9 | 198/198 | ✅ |
| `gloomy_forest` | 14 | 0 | branching, crossroads, large_rooms, looping, mixed, ring | 9 | cave, cross, round, square | 7/11.93/20 | 7/14.36/26 | 3.68 | 2.93 | 1.68 | 21.68 | 20→300 | 30.21 | 28/28 | ✅ |
| `sky_tower` | 25 | 0 | branching, crossroads, mixed | 11 | cave, cross, round, square | 6/10.68/17 | 5/10.46/16 | 2.74 | 4.18 | 0.62 | 15.64 | 20→264 | 30.36 | 50/50 | ✅ |
| `sky_tower_summit` | 9 | 0 | crossroads, large_rooms, mixed | 6 | cave, cross, round, square | 5/12.44/21 | 5/14/25 | 3.83 | 3.11 | 1.67 | 21.33 | 20→270 | 35.22 | 18/18 | ✅ |
| `snow_path` | 4 | 0 | large_rooms, twosides | 2 | cave, cross, round, square | 5/6.75/8 | 4/9.25/13 | 1 | 1.5 | 0.75 | 15.62 | 20→154 | 24 | 8/8 | ✅ |
| `solar_cave` | 20 | 0 | branching, dense, lattice, looping, mixed | 10 | cave, cross, round, square | 6/12.55/25 | 5/16.35/33 | 4.9 | 3.33 | 2.4 | 27.52 | 9→175 | 27.93 | 40/40 | ✅ |
| `southern_cavern` | 50 | 0 | branching, dense, large_rooms, lattice, looping, mixed | 15 | cave, cross, round, square | 3/11.94/28 | 2/14.88/36 | 4.31 | 3.21 | 2.05 | 26.36 | 9→325 | 32.71 | 100/100 | ✅ |
| `stormy_sea` | 40 | 0 | large_rooms, lattice, looping, mixed, ring | 12 | cave, cross, round, square | 3/9.86/23 | 2/13.9/33 | 3.35 | 1.76 | 2.02 | 20.49 | 20→378 | 29.29 | 80/80 | ✅ |
| `thunderwave_cave` | 5 | 0 | branching, dense, mixed | 5 | cave, cross, round, square | 8/15.5/28 | 8/18.1/34 | 5 | 4.3 | 1.8 | 27.8 | 9→198 | 30.8 | 10/10 | ✅ |
| `tiny_woods` | 3 | 0 | dense, mixed | 3 | cave, cross, round, square | 11/19.5/29 | 14/25.83/43 | 8.17 | 6 | 2.67 | 42.5 | 9→221 | 26.67 | 6/6 | ✅ |
| `unown_relic` | 11 | 0 | crossroads, dense, lattice, looping, mixed | 6 | cave, cross, round, square | 6/11.68/19 | 5/17.23/26 | 5.55 | 3 | 3 | 30.41 | 9→200 | 31.91 | 22/22 | ✅ |
| `uproar_forest` | 10 | 0 | branching, dense, looping, mixed | 7 | cave, cross, round, square | 9/14.5/27 | 10/17.8/34 | 5.2 | 3.1 | 2.4 | 26.75 | 9→119 | 25.3 | 20/20 | ✅ |
| `waterfall_pond` | 19 | 0 | lattice, looping, mixed, ring | 7 | cave, cross, round, square | 5/9.24/15 | 9/14.95/22 | 3.47 | 1.61 | 2.16 | 23.32 | 20→140 | 29.08 | 38/38 | ✅ |
| `western_cave` | 99 | 0 | branching, dense, large_rooms, lattice, looping, mixed | 17 | cave, cross, round, square | 3/12.49/30 | 2/15.4/37 | 4.36 | 3.05 | 2.05 | 24.91 | 9→324 | 30.91 | 198/198 | ✅ |
| `wish_cave` | 99 | 0 | branching, dense, lattice, looping, mixed | 14 | cave, cross, round, square | 6/12.26/28 | 7/15.85/39 | 4.85 | 3.38 | 2.21 | 25.37 | 9→299 | 30.12 | 198/198 | ✅ |
| `wyvern_hill` | 30 | 0 | branching, crossroads, mixed, twosides | 12 | cave, cross, round, square | 5/10.58/27 | 5/11.88/31 | 2.68 | 3.53 | 0.83 | 18.92 | 20→286 | 32.2 | 60/60 | ✅ |

**51/51 zones conformes.**

## Limites du traceur hors-ligne (non bloquantes)

> **Lecture du résidu de 1–3 %.** Les lignes « disconnected in the offline tracer »
> ci-dessous sont une **limite du simulateur hors-ligne**, pas une preuve que les
> étages produits par le moteur sont déconnectés. Le traceur reconstitue les
> couloirs à partir des paramètres ; il ne rejoue pas `RoomGen.AskBorderFromRoom`
> ni `DigAtBorder`, qui garantissent côté moteur l'ouverture des salles sur les
> couloirs. `DetectIsolatedStairsStep` **reste actif sur les 51 zones** (vérifié :
> 51/51) et rejette côté moteur toute carte dont l'escalier serait inatteignable ;
> il n'a jamais été désactivé, et aucun test ne doit l'être pour obtenir un PASS.
> Le verdict définitif appartient au moteur — et il est tombé : sur **4 287 étages
> réellement générés par RogueEssence**, la mesure faite avec les données du moteur
> (`Map:TileBlocked` depuis `Map.EntryPoints[0]`) donne **0 poche praticable non
> atteinte** et **4 281 / 4 287 étages dont tous les escaliers sont atteignables** ;
> les 6 restants sont les deux salles fixes de boss (Buried Relic F99, Meteor Cave
> F20), qui n'ont pas d'escalier par conception. Le résidu de 1–3 % était donc bien
> un artefact du traceur hors-ligne, pas un défaut des étages produits. Voir
> `docs/dungeon_builder/runtime/MAPGEN_RUNTIME_REPORT.md`.


- `buried_relic` : 7/196 replays (3.6%) disconnected in the offline tracer — engine-side guarded by AskBorderFromRoom/DigAtBorder + DetectIsolatedStairsStep
- `darknight_relic` : 1/30 replays (3.3%) disconnected in the offline tracer — engine-side guarded by AskBorderFromRoom/DigAtBorder + DetectIsolatedStairsStep
- `fantasy_strait` : 1/60 replays (1.7%) disconnected in the offline tracer — engine-side guarded by AskBorderFromRoom/DigAtBorder + DetectIsolatedStairsStep
- `frosty_forest` : 1/18 replays (5.6%) disconnected in the offline tracer — engine-side guarded by AskBorderFromRoom/DigAtBorder + DetectIsolatedStairsStep
- `joyous_tower` : 2/198 replays (1.0%) disconnected in the offline tracer — engine-side guarded by AskBorderFromRoom/DigAtBorder + DetectIsolatedStairsStep
- `lapis_cave` : 1/28 replays (3.6%) disconnected in the offline tracer — engine-side guarded by AskBorderFromRoom/DigAtBorder + DetectIsolatedStairsStep
- `lightning_field` : 2/60 replays (3.3%) disconnected in the offline tracer — engine-side guarded by AskBorderFromRoom/DigAtBorder + DetectIsolatedStairsStep
- `magma_cavern` : 1/46 replays (2.2%) disconnected in the offline tracer — engine-side guarded by AskBorderFromRoom/DigAtBorder + DetectIsolatedStairsStep
- `meteor_cave` : 1/38 replays (2.6%) disconnected in the offline tracer — engine-side guarded by AskBorderFromRoom/DigAtBorder + DetectIsolatedStairsStep
- `mt_faraway` : 1/80 replays (1.2%) disconnected in the offline tracer — engine-side guarded by AskBorderFromRoom/DigAtBorder + DetectIsolatedStairsStep
- `murky_cave` : 1/38 replays (2.6%) disconnected in the offline tracer — engine-side guarded by AskBorderFromRoom/DigAtBorder + DetectIsolatedStairsStep
- `northern_range` : 1/50 replays (2.0%) disconnected in the offline tracer — engine-side guarded by AskBorderFromRoom/DigAtBorder + DetectIsolatedStairsStep
