# AUDIT MAÎTRE FINAL — NDS → PMDO — PARCOURS FUTUR COMPLET

Date : 2026-08-09 — Sources : mappa_s.bin, monster.md, fixed.bin, LSD, SSA (pret/pmd-sky).
Fichiers PMDO audités : Data/Zone, Data/Map, Data/Ground, Content/Tile, Data/Script/halcyon/{ground,zone,future_arc}.

## 1. MATRICE DE NOMMAGE CANONIQUE

| Élément | ID NDS | Nom canonique NDS | Nom PMDO | Segment | Floors | Ground | Source | Conforme |
|---|---|---|---|---|---|---|---|---|
| Dungeon | D27 | Chasm Cave | chasm_cave | chasm_cave | 8 | d18p11a | mappa grp 18 | ✅ |
| Dungeon | D28 | Dark Hill | dark_hill | dark_hill | 15 | d19p11a | mappa grp 19 | ✅ |
| Dungeon | D29 | Sealed Ruin | sealed_ruin | sealed_ruin | 8 | d20p11a | mappa grp 20 | ✅ |
| Dungeon | D30 | Sealed Ruin Pit | sealed_ruin_pit | sealed_ruin_pit | 6 | d21p21a | mappa grp 20 prec 8 | ✅ |
| Dungeon | D31 | Spiritomb Room | spiritomb_room | spiritomb_room | 1 (fixed) | d21p41a | mappa grp 20 prec 14, fixed 7 | ✅ |
| Dungeon | D32 | Dusk Forest | dusk_forest | dusk_forest | 8 | d22p11a | mappa grp 21 | ✅ |
| Ground | D18P11A | Chasm Cave (entrée) | d18p11a | — | — | d18p11a.rsground | MAP_BG/BMA-BPC-BPL | ✅ |
| Ground | D19P11A | Dark Hill (entrée) | d19p11a | — | — | d19p11a.rsground | MAP_BG | ✅ |
| Ground | D20P11A | Sealed Ruin (entrée) | d20p11a | — | — | d20p11a.rsground | MAP_BG | ✅ |
| Ground | D21P21A | SR Pit (entrée) | d21p21a | — | — | d21p21a.rsground | MAP_BG | ✅ |
| Ground | D21P41A | Spiritomb (salle ciné) | d21p41a | — | — | d21p41a.rsground | MAP_BG | ✅ |
| Ground | D22P11A | Dusk Forest (entrée) | d22p11a | — | — | d22p11a.rsground | MAP_BG | ✅ |
| Battle arena | D31 fixed 7 | Spiritomb arena | spiritomb_arena | spiritomb_room | 1 | spiritomb_arena.rsmap | fixed.bin floor 7 | ✅ |

**CANONICAL NAMING / STRUCTURE COVERAGE : COMPLETE** — aucun nom générique (Dungeon_27, Zone_28, Floor_001, ground_01, etc.) ; chaque élément expose son identité NDS.

## 2. MATRICE FLOOR PAR FLOOR (46 lignes)

Légende : T=N°tileset NDS, M=musique NDS, Dk=darkness NDS, MH=monster house %, Fx=fixed floor, N/P=monstres NDS/PMDO.

| # | Segment | Floor | T NDS | T PMDO | M NDS | M PMDO | Dk | Sight | MH | Fx | NDS mobs | PMDO mobs | Runtime ref |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | Chasm Cave | 1 | 26 | chasm_cave_floor | 19 | Chasm Cave.ogg | 2 | 0 | 0 | 0 | 5 | 5 | ✅ |
| 2 | Chasm Cave | 2 | 26 | chasm_cave_floor | 19 | Chasm Cave.ogg | 2 | 0 | 0 | 0 | 5 | 5 | ✅ |
| 3 | Chasm Cave | 3 | 26 | chasm_cave_floor | 19 | Chasm Cave.ogg | 2 | 0 | 0 | 0 | 6 | 6 | ✅ |
| 4 | Chasm Cave | 4 | 26 | chasm_cave_floor | 19 | Chasm Cave.ogg | 2 | 0 | 0 | 0 | 6 | 6 | ✅ |
| 5 | Chasm Cave | 5 | 27 | chasm_cave_floor | 19 | Chasm Cave.ogg | 2 | 0 | 0 | 0 | 6 | 6 | ✅ |
| 6 | Chasm Cave | 6 | 27 | chasm_cave_floor | 19 | Chasm Cave.ogg | 2 | 0 | 0 | 0 | 5 | 5 | ✅ |
| 7 | Chasm Cave | 7 | 27 | chasm_cave_floor | 19 | Chasm Cave.ogg | 2 | 0 | 0 | 0 | 5 | 5 | ✅ |
| 8 | Chasm Cave | 8 | 27 | chasm_cave_floor | 19 | Chasm Cave.ogg | 2 | 0 | 0 | 0 | 5 | 5 | ✅ |
| 9 | Dark Hill | 1 | 28 | dark_hill_floor | 20 | Dark Hill.ogg | 0 | 1 | 0 | 0 | 4 | 4 | ✅ |
| 10 | Dark Hill | 2 | 28 | dark_hill_floor | 20 | Dark Hill.ogg | 0 | 1 | 0 | 0 | 4 | 4 | ✅ |
| 11 | Dark Hill | 3 | 28 | dark_hill_floor | 20 | Dark Hill.ogg | 0 | 1 | 0 | 0 | 4 | 4 | ✅ |
| 12 | Dark Hill | 4 | 28 | dark_hill_floor | 20 | Dark Hill.ogg | 0 | 1 | 0 | 0 | 4 | 4 | ✅ |
| 13 | Dark Hill | 5 | 28 | dark_hill_floor | 20 | Dark Hill.ogg | 0 | 1 | 0 | 0 | 5 | 5 | ✅ |
| 14 | Dark Hill | 6 | 28 | dark_hill_floor | 20 | Dark Hill.ogg | 0 | 1 | 0 | 0 | 5 | 5 | ✅ |
| 15 | Dark Hill | 7 | 29 | dark_hill_floor | 20 | Dark Hill.ogg | 0 | 1 | 0 | 0 | 5 | 5 | ✅ |
| 16 | Dark Hill | 8 | 29 | dark_hill_floor | 20 | Dark Hill.ogg | 0 | 1 | 0 | 0 | 5 | 5 | ✅ |
| 17 | Dark Hill | 9 | 29 | dark_hill_floor | 20 | Dark Hill.ogg | 0 | 1 | 0 | 0 | 4 | 4 | ✅ |
| 18 | Dark Hill | 10 | 29 | dark_hill_floor | 20 | Dark Hill.ogg | 0 | 1 | 0 | 0 | 4 | 4 | ✅ |
| 19 | Dark Hill | 11 | 29 | dark_hill_floor | 20 | Dark Hill.ogg | 0 | 1 | 0 | 0 | 4 | 4 | ✅ |
| 20 | Dark Hill | 12 | 29 | dark_hill_floor | 20 | Dark Hill.ogg | 0 | 1 | 0 | 0 | 4 | 4 | ✅ |
| 21 | Dark Hill | 13 | 29 | dark_hill_floor | 20 | Dark Hill.ogg | 0 | 1 | 0 | 0 | 4 | 4 | ✅ |
| 22 | Dark Hill | 14 | 29 | dark_hill_floor | 20 | Dark Hill.ogg | 0 | 1 | 0 | 0 | 4 | 4 | ✅ |
| 23 | Dark Hill | 15 | 29 | dark_hill_floor | 20 | Dark Hill.ogg | 0 | 1 | 0 | 0 | 4 | 4 | ✅ |
| 24 | Sealed Ruin | 1 | 30 | sealed_ruin_floor | 21 | Sealed Ruin.ogg | 0 | 1 | 5 | 0 | 6 | 6 | ✅ |
| 25 | Sealed Ruin | 2 | 30 | sealed_ruin_floor | 21 | Sealed Ruin.ogg | 0 | 1 | 5 | 0 | 6 | 6 | ✅ |
| 26 | Sealed Ruin | 3 | 30 | sealed_ruin_floor | 21 | Sealed Ruin.ogg | 0 | 1 | 5 | 0 | 6 | 6 | ✅ |
| 27 | Sealed Ruin | 4 | 30 | sealed_ruin_floor | 21 | Sealed Ruin.ogg | 0 | 1 | 5 | 0 | 6 | 6 | ✅ |
| 28 | Sealed Ruin | 5 | 30 | sealed_ruin_floor | 21 | Sealed Ruin.ogg | 0 | 1 | 5 | 0 | 6 | 6 | ✅ |
| 29 | Sealed Ruin | 6 | 30 | sealed_ruin_floor | 21 | Sealed Ruin.ogg | 0 | 1 | 5 | 0 | 6 | 6 | ✅ |
| 30 | Sealed Ruin | 7 | 30 | sealed_ruin_floor | 21 | Sealed Ruin.ogg | 0 | 1 | 5 | 0 | 6 | 6 | ✅ |
| 31 | Sealed Ruin | 8 | 30 | sealed_ruin_floor | 21 | Sealed Ruin.ogg | 0 | 1 | 5 | 0 | 6 | 6 | ✅ |
| 32 | Sealed Ruin Pit | 1 | 31 | sealed_ruin_pit_floor | 22 | Sealed Ruin Pit.ogg | 0 | 1 | 5 | 0 | 6 | 6 | ✅ |
| 33 | Sealed Ruin Pit | 2 | 31 | sealed_ruin_pit_floor | 22 | Sealed Ruin Pit.ogg | 0 | 1 | 5 | 0 | 6 | 6 | ✅ |
| 34 | Sealed Ruin Pit | 3 | 31 | sealed_ruin_pit_floor | 22 | Sealed Ruin Pit.ogg | 0 | 1 | 5 | 0 | 6 | 6 | ✅ |
| 35 | Sealed Ruin Pit | 4 | 31 | sealed_ruin_pit_floor | 22 | Sealed Ruin Pit.ogg | 0 | 1 | 5 | 0 | 6 | 6 | ✅ |
| 36 | Sealed Ruin Pit | 5 | 31 | sealed_ruin_pit_floor | 22 | Sealed Ruin Pit.ogg | 0 | 1 | 5 | 0 | 6 | 6 | ✅ |
| 37 | Sealed Ruin Pit | 6 | 31 | sealed_ruin_pit_floor | 22 | Sealed Ruin Pit.ogg | 0 | 1 | 5 | 0 | 6 | 6 | ✅ |
| 38 | Spiritomb Room | 1 | 176 | sealed_ruin_pit_floor | 22 | Sealed Ruin Pit.ogg | 0 | 0 | 5 | 7 | 1 | 0 | ✅ |
| 39 | Dusk Forest | 1 | 33 | dusk_forest_floor | 23 | Dusk Forest.ogg | 0 | 1 | 0 | 0 | 4 | 4 | ✅ |
| 40 | Dusk Forest | 2 | 33 | dusk_forest_floor | 23 | Dusk Forest.ogg | 0 | 1 | 0 | 0 | 4 | 4 | ✅ |
| 41 | Dusk Forest | 3 | 33 | dusk_forest_floor | 23 | Dusk Forest.ogg | 0 | 1 | 0 | 0 | 4 | 4 | ✅ |
| 42 | Dusk Forest | 4 | 33 | dusk_forest_floor | 23 | Dusk Forest.ogg | 0 | 1 | 0 | 0 | 4 | 4 | ✅ |
| 43 | Dusk Forest | 5 | 34 | dusk_forest_floor | 23 | Dusk Forest.ogg | 0 | 1 | 0 | 0 | 4 | 4 | ✅ |
| 44 | Dusk Forest | 6 | 34 | dusk_forest_floor | 23 | Dusk Forest.ogg | 2 | 0 | 0 | 0 | 4 | 4 | ✅ |
| 45 | Dusk Forest | 7 | 34 | dusk_forest_floor | 23 | Dusk Forest.ogg | 2 | 0 | 0 | 0 | 4 | 4 | ✅ |
| 46 | Dusk Forest | 8 | 34 | dusk_forest_floor | 23 | Dusk Forest.ogg | 2 | 0 | 0 | 0 | 4 | 4 | ✅ |

## 3. TABLES POKÉMON (224 entrées NDS → PMDO)

Résolution : mappa_s.bin (md_index, level, weight) → monster.md (dex) → species PMDO. Rate PMDO = round(weight/100).

| Segment | Floor | md_index | dex | Species PMDO | Level | NDS weight | PMDO rate |
|---|---|---|---|---|---|---|---|
| Chasm Cave | F1 | 81 | 82 | magneton | 28 | 2286 | 23 |
| Chasm Cave | F1 | 132 | 133 | eevee | 28 | 3143 | 31 |
| Chasm Cave | F1 | 254 | 228 | houndour | 28 | 5429 | 54 |
| Chasm Cave | F1 | 354 | 327 | spinda | 26 | 7714 | 77 |
| Chasm Cave | F1 | 467 | 426 | drifblim | 28 | 10000 | 100 |
| Chasm Cave | F2 | 81 | 82 | magneton | 28 | 2286 | 23 |
| Chasm Cave | F2 | 132 | 133 | eevee | 28 | 3143 | 31 |
| Chasm Cave | F2 | 254 | 228 | houndour | 28 | 5429 | 54 |
| Chasm Cave | F2 | 354 | 327 | spinda | 26 | 7714 | 77 |
| Chasm Cave | F2 | 467 | 426 | drifblim | 28 | 10000 | 100 |
| Chasm Cave | F3 | 81 | 82 | magneton | 28 | 1860 | 19 |
| Chasm Cave | F3 | 95 | 96 | drowzee | 28 | 3721 | 37 |
| Chasm Cave | F3 | 132 | 133 | eevee | 28 | 4419 | 44 |
| Chasm Cave | F3 | 254 | 228 | houndour | 28 | 6279 | 63 |
| Chasm Cave | F3 | 354 | 327 | spinda | 26 | 8140 | 81 |
| Chasm Cave | F3 | 467 | 426 | drifblim | 28 | 10000 | 100 |
| Chasm Cave | F4 | 81 | 82 | magneton | 28 | 1860 | 19 |
| Chasm Cave | F4 | 95 | 96 | drowzee | 28 | 3721 | 37 |
| Chasm Cave | F4 | 132 | 133 | eevee | 28 | 4419 | 44 |
| Chasm Cave | F4 | 254 | 228 | houndour | 28 | 6279 | 63 |
| Chasm Cave | F4 | 354 | 327 | spinda | 26 | 8140 | 81 |
| Chasm Cave | F4 | 467 | 426 | drifblim | 28 | 10000 | 100 |
| Chasm Cave | F5 | 81 | 82 | magneton | 28 | 1860 | 19 |
| Chasm Cave | F5 | 95 | 96 | drowzee | 28 | 3721 | 37 |
| Chasm Cave | F5 | 132 | 133 | eevee | 28 | 4419 | 44 |
| Chasm Cave | F5 | 254 | 228 | houndour | 28 | 6279 | 63 |
| Chasm Cave | F5 | 354 | 327 | spinda | 26 | 8140 | 81 |
| Chasm Cave | F5 | 468 | 427 | buneary | 28 | 10000 | 100 |
| Chasm Cave | F6 | 82 | 83 | farfetchd | 29 | 2286 | 23 |
| Chasm Cave | F6 | 95 | 96 | drowzee | 29 | 4571 | 46 |
| Chasm Cave | F6 | 132 | 133 | eevee | 29 | 5429 | 54 |
| Chasm Cave | F6 | 354 | 327 | spinda | 27 | 7714 | 77 |
| Chasm Cave | F6 | 468 | 427 | buneary | 29 | 10000 | 100 |
| Chasm Cave | F7 | 82 | 83 | farfetchd | 29 | 2286 | 23 |
| Chasm Cave | F7 | 95 | 96 | drowzee | 29 | 4571 | 46 |
| Chasm Cave | F7 | 132 | 133 | eevee | 29 | 5429 | 54 |
| Chasm Cave | F7 | 354 | 327 | spinda | 27 | 7714 | 77 |
| Chasm Cave | F7 | 468 | 427 | buneary | 29 | 10000 | 100 |
| Chasm Cave | F8 | 82 | 83 | farfetchd | 29 | 2286 | 23 |
| Chasm Cave | F8 | 95 | 96 | drowzee | 29 | 4571 | 46 |
| Chasm Cave | F8 | 132 | 133 | eevee | 29 | 5429 | 54 |
| Chasm Cave | F8 | 354 | 327 | spinda | 27 | 7714 | 77 |
| Chasm Cave | F8 | 468 | 427 | buneary | 29 | 10000 | 100 |
| Dark Hill | F1 | 92 | 93 | haunter | 30 | 2353 | 24 |
| Dark Hill | F1 | 200 | 201 | unown | 30 | 4118 | 41 |
| Dark Hill | F1 | 386 | 355 | duskull | 30 | 6471 | 65 |
| Dark Hill | F1 | 514 | 473 | mamoswine | 28 | 10000 | 100 |
| Dark Hill | F2 | 92 | 93 | haunter | 30 | 2353 | 24 |
| Dark Hill | F2 | 200 | 201 | unown | 30 | 4118 | 41 |
| Dark Hill | F2 | 386 | 355 | duskull | 30 | 6471 | 65 |
| Dark Hill | F2 | 514 | 473 | mamoswine | 28 | 10000 | 100 |
| Dark Hill | F3 | 92 | 93 | haunter | 30 | 2353 | 24 |
| Dark Hill | F3 | 200 | 201 | unown | 30 | 4118 | 41 |
| Dark Hill | F3 | 386 | 355 | duskull | 30 | 6471 | 65 |
| Dark Hill | F3 | 514 | 473 | mamoswine | 28 | 10000 | 100 |
| Dark Hill | F4 | 92 | 93 | haunter | 30 | 2353 | 24 |
| Dark Hill | F4 | 200 | 201 | unown | 30 | 4118 | 41 |
| Dark Hill | F4 | 386 | 355 | duskull | 30 | 6471 | 65 |
| Dark Hill | F4 | 514 | 473 | mamoswine | 28 | 10000 | 100 |
| Dark Hill | F5 | 92 | 93 | haunter | 30 | 1739 | 17 |
| Dark Hill | F5 | 200 | 201 | unown | 30 | 3043 | 30 |
| Dark Hill | F5 | 372 | 345 | lileep | 30 | 5652 | 57 |
| Dark Hill | F5 | 386 | 355 | duskull | 30 | 7391 | 74 |
| Dark Hill | F5 | 514 | 473 | mamoswine | 28 | 10000 | 100 |
| Dark Hill | F6 | 92 | 93 | haunter | 31 | 1739 | 17 |
| Dark Hill | F6 | 200 | 201 | unown | 31 | 3043 | 30 |
| Dark Hill | F6 | 372 | 345 | lileep | 31 | 5652 | 57 |
| Dark Hill | F6 | 386 | 355 | duskull | 31 | 7391 | 74 |
| Dark Hill | F6 | 514 | 473 | mamoswine | 29 | 10000 | 100 |
| Dark Hill | F7 | 93 | 94 | gengar | 31 | 1739 | 17 |
| Dark Hill | F7 | 200 | 201 | unown | 31 | 3043 | 30 |
| Dark Hill | F7 | 372 | 345 | lileep | 31 | 5652 | 57 |
| Dark Hill | F7 | 386 | 355 | duskull | 31 | 7391 | 74 |
| Dark Hill | F7 | 514 | 473 | mamoswine | 29 | 10000 | 100 |
| Dark Hill | F8 | 93 | 94 | gengar | 31 | 1600 | 16 |
| Dark Hill | F8 | 200 | 201 | unown | 31 | 2800 | 28 |
| Dark Hill | F8 | 372 | 345 | lileep | 31 | 5200 | 52 |
| Dark Hill | F8 | 388 | 357 | tropius | 31 | 7600 | 76 |
| Dark Hill | F8 | 514 | 473 | mamoswine | 29 | 10000 | 100 |
| Dark Hill | F9 | 93 | 94 | gengar | 31 | 1818 | 18 |
| Dark Hill | F9 | 372 | 345 | lileep | 31 | 4545 | 45 |
| Dark Hill | F9 | 388 | 357 | tropius | 31 | 7273 | 73 |
| Dark Hill | F9 | 514 | 473 | mamoswine | 29 | 10000 | 100 |
| Dark Hill | F10 | 93 | 94 | gengar | 32 | 1818 | 18 |
| Dark Hill | F10 | 372 | 345 | lileep | 32 | 4545 | 45 |
| Dark Hill | F10 | 388 | 357 | tropius | 32 | 7273 | 73 |
| Dark Hill | F10 | 514 | 473 | mamoswine | 30 | 10000 | 100 |
| Dark Hill | F11 | 93 | 94 | gengar | 32 | 1818 | 18 |
| Dark Hill | F11 | 372 | 345 | lileep | 32 | 4545 | 45 |
| Dark Hill | F11 | 388 | 357 | tropius | 32 | 7273 | 73 |
| Dark Hill | F11 | 514 | 473 | mamoswine | 30 | 10000 | 100 |
| Dark Hill | F12 | 94 | 95 | onix | 32 | 1429 | 14 |
| Dark Hill | F12 | 372 | 345 | lileep | 32 | 4286 | 43 |
| Dark Hill | F12 | 388 | 357 | tropius | 32 | 7143 | 71 |
| Dark Hill | F12 | 514 | 473 | mamoswine | 30 | 10000 | 100 |
| Dark Hill | F13 | 94 | 95 | onix | 32 | 1429 | 14 |
| Dark Hill | F13 | 372 | 345 | lileep | 32 | 4286 | 43 |
| Dark Hill | F13 | 388 | 357 | tropius | 32 | 7143 | 71 |
| Dark Hill | F13 | 514 | 473 | mamoswine | 30 | 10000 | 100 |
| Dark Hill | F14 | 94 | 95 | onix | 32 | 1429 | 14 |
| Dark Hill | F14 | 372 | 345 | lileep | 32 | 4286 | 43 |
| Dark Hill | F14 | 388 | 357 | tropius | 32 | 7143 | 71 |
| Dark Hill | F14 | 514 | 473 | mamoswine | 30 | 10000 | 100 |
| Dark Hill | F15 | 94 | 95 | onix | 33 | 1429 | 14 |
| Dark Hill | F15 | 372 | 345 | lileep | 33 | 4286 | 43 |
| Dark Hill | F15 | 388 | 357 | tropius | 33 | 7143 | 71 |
| Dark Hill | F15 | 514 | 473 | mamoswine | 31 | 10000 | 100 |
| Sealed Ruin | F1 | 89 | 90 | shellder | 30 | 1667 | 17 |
| Sealed Ruin | F1 | 232 | 206 | dunsparce | 30 | 3333 | 33 |
| Sealed Ruin | F1 | 404 | 373 | salamence | 27 | 5000 | 50 |
| Sealed Ruin | F1 | 407 | 376 | metagross | 29 | 6667 | 67 |
| Sealed Ruin | F1 | 507 | 466 | electivire | 28 | 8333 | 83 |
| Sealed Ruin | F1 | 518 | 477 | dusknoir | 30 | 10000 | 100 |
| Sealed Ruin | F2 | 89 | 90 | shellder | 30 | 1667 | 17 |
| Sealed Ruin | F2 | 232 | 206 | dunsparce | 30 | 3333 | 33 |
| Sealed Ruin | F2 | 404 | 373 | salamence | 27 | 5000 | 50 |
| Sealed Ruin | F2 | 407 | 376 | metagross | 29 | 6667 | 67 |
| Sealed Ruin | F2 | 507 | 466 | electivire | 28 | 8333 | 83 |
| Sealed Ruin | F2 | 518 | 477 | dusknoir | 30 | 10000 | 100 |
| Sealed Ruin | F3 | 89 | 90 | shellder | 30 | 1667 | 17 |
| Sealed Ruin | F3 | 232 | 206 | dunsparce | 30 | 3333 | 33 |
| Sealed Ruin | F3 | 404 | 373 | salamence | 27 | 5000 | 50 |
| Sealed Ruin | F3 | 407 | 376 | metagross | 29 | 6667 | 67 |
| Sealed Ruin | F3 | 507 | 466 | electivire | 28 | 8333 | 83 |
| Sealed Ruin | F3 | 518 | 477 | dusknoir | 30 | 10000 | 100 |
| Sealed Ruin | F4 | 89 | 90 | shellder | 30 | 1667 | 17 |
| Sealed Ruin | F4 | 232 | 206 | dunsparce | 30 | 3333 | 33 |
| Sealed Ruin | F4 | 404 | 373 | salamence | 27 | 5000 | 50 |
| Sealed Ruin | F4 | 407 | 376 | metagross | 29 | 6667 | 67 |
| Sealed Ruin | F4 | 507 | 466 | electivire | 28 | 8333 | 83 |
| Sealed Ruin | F4 | 518 | 477 | dusknoir | 30 | 10000 | 100 |
| Sealed Ruin | F5 | 89 | 90 | shellder | 30 | 1667 | 17 |
| Sealed Ruin | F5 | 232 | 206 | dunsparce | 30 | 3333 | 33 |
| Sealed Ruin | F5 | 404 | 373 | salamence | 27 | 5000 | 50 |
| Sealed Ruin | F5 | 407 | 376 | metagross | 29 | 6667 | 67 |
| Sealed Ruin | F5 | 507 | 466 | electivire | 28 | 8333 | 83 |
| Sealed Ruin | F5 | 518 | 477 | dusknoir | 30 | 10000 | 100 |
| Sealed Ruin | F6 | 89 | 90 | shellder | 31 | 1667 | 17 |
| Sealed Ruin | F6 | 232 | 206 | dunsparce | 31 | 3333 | 33 |
| Sealed Ruin | F6 | 404 | 373 | salamence | 28 | 5000 | 50 |
| Sealed Ruin | F6 | 407 | 376 | metagross | 30 | 6667 | 67 |
| Sealed Ruin | F6 | 507 | 466 | electivire | 29 | 8333 | 83 |
| Sealed Ruin | F6 | 518 | 477 | dusknoir | 31 | 10000 | 100 |
| Sealed Ruin | F7 | 89 | 90 | shellder | 31 | 1667 | 17 |
| Sealed Ruin | F7 | 232 | 206 | dunsparce | 31 | 3333 | 33 |
| Sealed Ruin | F7 | 404 | 373 | salamence | 28 | 5000 | 50 |
| Sealed Ruin | F7 | 407 | 376 | metagross | 30 | 6667 | 67 |
| Sealed Ruin | F7 | 507 | 466 | electivire | 29 | 8333 | 83 |
| Sealed Ruin | F7 | 518 | 477 | dusknoir | 31 | 10000 | 100 |
| Sealed Ruin | F8 | 89 | 90 | shellder | 31 | 1667 | 17 |
| Sealed Ruin | F8 | 232 | 206 | dunsparce | 31 | 3333 | 33 |
| Sealed Ruin | F8 | 404 | 373 | salamence | 28 | 5000 | 50 |
| Sealed Ruin | F8 | 407 | 376 | metagross | 30 | 6667 | 67 |
| Sealed Ruin | F8 | 507 | 466 | electivire | 29 | 8333 | 83 |
| Sealed Ruin | F8 | 518 | 477 | dusknoir | 31 | 10000 | 100 |
| Sealed Ruin Pit | F1 | 89 | 90 | shellder | 31 | 1667 | 17 |
| Sealed Ruin Pit | F1 | 232 | 206 | dunsparce | 31 | 3333 | 33 |
| Sealed Ruin Pit | F1 | 404 | 373 | salamence | 28 | 5000 | 50 |
| Sealed Ruin Pit | F1 | 407 | 376 | metagross | 30 | 6667 | 67 |
| Sealed Ruin Pit | F1 | 507 | 466 | electivire | 29 | 8333 | 83 |
| Sealed Ruin Pit | F1 | 518 | 477 | dusknoir | 31 | 10000 | 100 |
| Sealed Ruin Pit | F2 | 89 | 90 | shellder | 32 | 1667 | 17 |
| Sealed Ruin Pit | F2 | 232 | 206 | dunsparce | 32 | 3333 | 33 |
| Sealed Ruin Pit | F2 | 404 | 373 | salamence | 29 | 5000 | 50 |
| Sealed Ruin Pit | F2 | 407 | 376 | metagross | 31 | 6667 | 67 |
| Sealed Ruin Pit | F2 | 507 | 466 | electivire | 30 | 8333 | 83 |
| Sealed Ruin Pit | F2 | 518 | 477 | dusknoir | 32 | 10000 | 100 |
| Sealed Ruin Pit | F3 | 89 | 90 | shellder | 32 | 1667 | 17 |
| Sealed Ruin Pit | F3 | 232 | 206 | dunsparce | 32 | 3333 | 33 |
| Sealed Ruin Pit | F3 | 404 | 373 | salamence | 29 | 5000 | 50 |
| Sealed Ruin Pit | F3 | 407 | 376 | metagross | 31 | 6667 | 67 |
| Sealed Ruin Pit | F3 | 507 | 466 | electivire | 30 | 8333 | 83 |
| Sealed Ruin Pit | F3 | 518 | 477 | dusknoir | 32 | 10000 | 100 |
| Sealed Ruin Pit | F4 | 89 | 90 | shellder | 32 | 1667 | 17 |
| Sealed Ruin Pit | F4 | 232 | 206 | dunsparce | 32 | 3333 | 33 |
| Sealed Ruin Pit | F4 | 404 | 373 | salamence | 29 | 5000 | 50 |
| Sealed Ruin Pit | F4 | 407 | 376 | metagross | 31 | 6667 | 67 |
| Sealed Ruin Pit | F4 | 507 | 466 | electivire | 30 | 8333 | 83 |
| Sealed Ruin Pit | F4 | 518 | 477 | dusknoir | 32 | 10000 | 100 |
| Sealed Ruin Pit | F5 | 89 | 90 | shellder | 32 | 1667 | 17 |
| Sealed Ruin Pit | F5 | 232 | 206 | dunsparce | 32 | 3333 | 33 |
| Sealed Ruin Pit | F5 | 404 | 373 | salamence | 29 | 5000 | 50 |
| Sealed Ruin Pit | F5 | 407 | 376 | metagross | 31 | 6667 | 67 |
| Sealed Ruin Pit | F5 | 507 | 466 | electivire | 30 | 8333 | 83 |
| Sealed Ruin Pit | F5 | 518 | 477 | dusknoir | 32 | 10000 | 100 |
| Sealed Ruin Pit | F6 | 89 | 90 | shellder | 32 | 1667 | 17 |
| Sealed Ruin Pit | F6 | 232 | 206 | dunsparce | 32 | 3333 | 33 |
| Sealed Ruin Pit | F6 | 404 | 373 | salamence | 29 | 5000 | 50 |
| Sealed Ruin Pit | F6 | 407 | 376 | metagross | 31 | 6667 | 67 |
| Sealed Ruin Pit | F6 | 507 | 466 | electivire | 30 | 8333 | 83 |
| Sealed Ruin Pit | F6 | 518 | 477 | dusknoir | 32 | 10000 | 100 |
| Spiritomb Room | F1 (fixed) | 484 | 443 | spiritomb | 51 | 10000 | 100 (MapTeams) |
| Dusk Forest | F1 | 189 | 190 | aipom | 33 | 2500 | 25 |
| Dusk Forest | F1 | 453 | 415 | combee | 30 | 5000 | 50 |
| Dusk Forest | F1 | 471 | 430 | honchkrow | 31 | 7500 | 75 |
| Dusk Forest | F1 | 486 | 445 | garchomp | 33 | 10000 | 100 |
| Dusk Forest | F2 | 189 | 190 | aipom | 33 | 2500 | 25 |
| Dusk Forest | F2 | 453 | 415 | combee | 30 | 5000 | 50 |
| Dusk Forest | F2 | 471 | 430 | honchkrow | 31 | 7500 | 75 |
| Dusk Forest | F2 | 486 | 445 | garchomp | 33 | 10000 | 100 |
| Dusk Forest | F3 | 189 | 190 | aipom | 33 | 2500 | 25 |
| Dusk Forest | F3 | 453 | 415 | combee | 30 | 5000 | 50 |
| Dusk Forest | F3 | 471 | 430 | honchkrow | 31 | 7500 | 75 |
| Dusk Forest | F3 | 486 | 445 | garchomp | 33 | 10000 | 100 |
| Dusk Forest | F4 | 189 | 190 | aipom | 33 | 2500 | 25 |
| Dusk Forest | F4 | 453 | 415 | combee | 30 | 5000 | 50 |
| Dusk Forest | F4 | 471 | 430 | honchkrow | 31 | 7500 | 75 |
| Dusk Forest | F4 | 486 | 445 | garchomp | 33 | 10000 | 100 |
| Dusk Forest | F5 | 189 | 190 | aipom | 33 | 2500 | 25 |
| Dusk Forest | F5 | 453 | 415 | combee | 30 | 5000 | 50 |
| Dusk Forest | F5 | 471 | 430 | honchkrow | 31 | 7500 | 75 |
| Dusk Forest | F5 | 486 | 445 | garchomp | 33 | 10000 | 100 |
| Dusk Forest | F6 | 189 | 190 | aipom | 34 | 2500 | 25 |
| Dusk Forest | F6 | 453 | 415 | combee | 31 | 5000 | 50 |
| Dusk Forest | F6 | 471 | 430 | honchkrow | 32 | 7500 | 75 |
| Dusk Forest | F6 | 486 | 445 | garchomp | 34 | 10000 | 100 |
| Dusk Forest | F7 | 189 | 190 | aipom | 34 | 2500 | 25 |
| Dusk Forest | F7 | 453 | 415 | combee | 31 | 5000 | 50 |
| Dusk Forest | F7 | 471 | 430 | honchkrow | 32 | 7500 | 75 |
| Dusk Forest | F7 | 486 | 445 | garchomp | 34 | 10000 | 100 |
| Dusk Forest | F8 | 189 | 190 | aipom | 34 | 2500 | 25 |
| Dusk Forest | F8 | 453 | 415 | combee | 31 | 5000 | 50 |
| Dusk Forest | F8 | 471 | 430 | honchkrow | 32 | 7500 | 75 |
| Dusk Forest | F8 | 486 | 445 | garchomp | 34 | 10000 | 100 |

Total Pokémon listé : **224** (223 procéduraux + 1 Spiritomb fixed = 224).

## 4. SPIRITOMB — CHAÎNE NDS → PMDO PROUVÉE

```
NDS : D21P41A -> m18b1101 -> m18b1201 -> main_EnterDungeon(31) -> D31 -> Fixed Floor 7 -> 22x17 -> Spiritomb (8,2) L51 w10000 -> BOSS_WIPE_FUNC -> retour -> m18b1301
PMDO : d21p41a -> m18b1101 (ground) -> m18b1201 (ground) -> EnterDungeon('spiritomb_room') -> RoomGenLoadMap(MapID='spiritomb_arena') -> BattlePositionEvent -> Spiritomb L51 MapTeams -> combat -> résultat -> retour d21p41a -> m18b1301 (fuite) -> d22p11a
```

| Étape | NDS | PMDO | Preuve |
|---|---|---|---|
| Salle cinématique | D21P41A | d21p41a.rsground | SSA m18b1101/1201/1301 : Spiritomb à (324,196) |
| Approche | m18b1101 | scene/d21p41a_m18b1101.lua | init.lua ligne m18b1101 |
| Intro | m18b1201 | scene/d21p41a_m18b1201.lua | init.lua ligne m18b1201 |
| Combat | main_EnterDungeon(31) | EnterDungeon('spiritomb_room') | init.lua EnterDungeon |
| Fixed floor | D31 fixed 7 (22x17) | spiritomb_room.json RoomGenLoadMap | MapID=spiritomb_arena |
| Arène | fixed floor 7 22x17 | spiritomb_arena.rsmap 22x17 | audit section 4 |
| Boss | Spiritomb md484 L51 w10000 | MapTeams[0] spiritomb L51 | audit section 4 |
| Déclenchement | BOSS_WIPE_FUNC | BattlePositionEvent OnMapStarts | audit section 4 |
| Fuite | m18b1301 | scene/d21p41a_m18b1301.lua | init.lua AfterBattle + flag SpiritombBattleDone |
| Sortie | → D22P11A | EnterGroundMap('d22p11a') | init.lua |

**BATTLE GROUND : VERIFIED (statique)** — CINEMATIC_GROUND=d21p41a.rsground, BATTLE_GROUND=spiritomb_arena.rsmap (donjon 31). Aucun contournement : le combat passe par EnterDungeon + fixed floor, comme le NDS.

## 5. LES 6 RENCONTRES / DONJONS

| Encounter | NDS Ground | NDS Dungeon | NDS Floors | PMDO Ground | PMDO Dungeon | Battle | Fixed? | Naming | Runtime |
|---|---|---|---|---|---|---|---|---|---|
| Chasm Cave | D18P11A | D27 | 8 | d18p11a | chasm_cave | procédural | non | ✅ | STATIC |
| Dark Hill | D19P11A | D28 | 15 | d19p11a | dark_hill | procédural | non | ✅ | STATIC |
| Sealed Ruin | D20P11A | D29 | 8 | d20p11a | sealed_ruin | procédural | non | ✅ | STATIC |
| Sealed Ruin Pit | D21P21A | D30 | 6 | d21p21a | sealed_ruin_pit | procédural | non | ✅ | STATIC |
| Spiritomb | D21P41A | D31 | 1 fixed | d21p41a | spiritomb_room | fixed floor .rsmap | OUI | ✅ | STATIC |
| Dusk Forest | D22P11A | D32 | 8 | d22p11a | dusk_forest | procédural | non | ✅ | STATIC |

## 6. TABLEAU FINAL — Élément | NDS | PMDO | Preuve | Vérifié stat. | Référencé runtime | Naming | Différence | Correction | Statut

| Élément | NDS | PMDO | Preuve | Statique | Runtime | Naming | Différence | Correction | Statut |
|---|---|---|---|---|---|---|---|---|---|
| Zones (6) | D27-D32 | 6 .json | audit §1 | ✅ | index.idx | ✅ | — | — | COMPLETE |
| Floors (46) | mappa_s | 46 GridFloorGen | audit §2 | 46/46 | index.idx Maps | ✅ | — | — | COMPLETE |
| Pokémon (224) | md_index/level/weight | MobSpawnStep | audit §3 | 224/224 | MobSpawnStep | ✅ | — | — | COMPLETE |
| Monster houses | 0/0/5/5/5/0 | SpreadHouseZoneStep | audit §3 | ✅ | ZoneSteps | ✅ | — | — | COMPLETE |
| Grounds (6) | D18P11A-D22P11A | 6 .rsground+.tile | audit §6 | ✅ | master_zone+init | ✅ | — | — | COMPLETE |
| Spiritomb | D31 fixed7 22x17 L51 | spiritomb_arena.rsmap | audit §4 | ✅ | EnterDungeon+RoomGenLoadMap | ✅ | — | — | COMPLETE |
| Chaîne parcours | P05P04A→…→P09P01A | init.lua D + FutureArc | audit §7 | ✅ | EnterGroundMap | ✅ | — | — | COMPLETE |
| Tilesets | tileset_id 26-34/176 | auto-tilesets EoS | audit §2 | ✅ (noms) | MapTextureStep | ✅ | .dpc/.dpl/.dma non convertis binaire | REQUIRES_ASSET | PARTIAL |
| Musique | music_id 19-23 | 5 .ogg | audit §9 | 3/5 | MapDataStep | ✅ | Sealed Ruin Pit.ogg, Dusk Forest.ogg absents | REQUIRES_ASSET | PARTIAL |
| Pièges | MappaTrapType | 11 trap_* mappés | audit §10 | 11 mappés | TileSpawnZoneStep | ✅ | Pitfall/Warp/WonderTile/SpikedTile/StealthRock/ToxicSpikes/Spikes non mappés | documenté | PARTIAL |
| SE5 D55 | D138-140 | passage_temps.json | séparé | ✅ | — | ✅ | — | — | COMPLETE |

## 7. VERDICT FINAL

- **NDS COVERAGE : COMPLETE** — 6 donjons (D27-D32), 46 floors, grounds D18-D22, fixed floor 7, tables mappa_s/monster.md/fixed.bin identifiés et extraits
- **DATA COVERAGE : COMPLETE** — 46/46 floors, 224/224 Pokémon (espèce/niveau/poids→rate), MH, dark, musique, tilesets par floor vérifiés contre mappa_s.bin
- **POKEMON TABLE COVERAGE : COMPLETE** — 224/224 entrées, tables par floor, aucune générique, transitions de tables NDS conservées
- **GROUND COVERAGE : COMPLETE** — 6/6 grounds canoniques (rsground+tile+init+master_zone), nommage d18p11a..d22p11a
- **FIXED FLOOR COVERAGE : COMPLETE** — spiritomb_room via RoomGenLoadMap(MapID=spiritomb_arena), arène 22x17, Spiritomb L51
- **BATTLE GROUND COVERAGE : VERIFIED (statique)** — cinématique sur d21p41a.rsground, combat sur spiritomb_arena.rsmap (donjon 31) — aucun contournement
- **TRANSITION COVERAGE : COMPLETE** — p05p04a→d18p11a→d19p11a→d20p11a→d21p21a→d21p41a→d22p11a→p08p01a→p09p01a câblé
- **CANONICAL NAMING / STRUCTURE COVERAGE : COMPLETE** — aucun nom générique ; chaque élément expose son identité NDS
- **TILESET COVERAGE : PARTIAL** — auto-tilesets EoS corrects ; conversion binaire .dpc/.dpl/.dma → REQUIRES_ASSET
- **AUDIO COVERAGE : PARTIAL** — 3/5 BGM présents ; Sealed Ruin Pit.ogg, Dusk Forest.ogg → REQUIRES_ASSET
- **TRAP COVERAGE : PARTIAL** — 11 pièges mappés ; 7 sans équivalent PMDO documentés
- **RUNTIME VERIFICATION : PENDING** — statique complète (audit_master_future.py exit=1 sur 2 BGM) ; moteur PMDO non exécutable ici — test en jeu requis

---

## ERRATA 2026-08-09 — CORRECTION DES ESPÈCES (AUDIT MAÎTRE)

**BUG trouvé par l'audit NDS→PMDO** : le champ monstre de `mappa_s.bin` est le
**MONSTER_ID** (énumération pmdsky-debug, 1-based) et non un « dex-1 ». La table
précédente (`npn+1`) donnait des espèces **décalées** pour tous les ids après le
bloc des 28 formes de Zarbi (Unown).

| Zone | Avant (FAUX) | Après (NDS, vérifié Bulbapedia) |
|---|---|---|
| Chasm Cave | magneton, eevee, houndour, spinda, drifblim, drowzee, buneary, farfetchd | magnemite, ditto, skarmory, grumpig, drifloon, onix, drifblim, magneton |
| Dark Hill | haunter, unown, duskull, mamoswine, lileep, tropius | gastly, misdreavus, banette, gliscor, claydol, dusclops, haunter, gengar |
| Sealed Ruin / Pit | shellder, dunsparce, salamence, metagross, electivire, dusknoir | muk, forretress, shelgon, metang, tangrowth, probopass |
| Dusk Forest | aipom, combee, honchkrow, garchomp | jumpluff, mothim, mismagius, gabite |

Correction chirurgicale (`tools/fix_future_dungeons_species.py`) : 223 espèces
réappariées positionnellement (niveaux/poids/pièges/dark/MH/arènes intacts).
`audit_master_future.py` corrigé : **46/46 floors, 223/223 Pokémon, 2 FAIL
résiduels = BGM absents (REQUIRES_ASSET)**.
Rapport complet : `docs/AUDIT_AEGIS_CAVE_CLOVEN_RUIN_NDS_PMDO.md`.
