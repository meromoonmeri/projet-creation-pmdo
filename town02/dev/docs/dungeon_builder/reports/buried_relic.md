# Rapport de génération — Buried Relic

- **ID** : `buried_relic`  
- **Chapitre** : 15 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Buried Relic (99F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/BuriedRelic) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 15. Recoupé avec Bulbapedia (page « Buried Relic »).  
- **Étages** : 99 — direction `fond`  
- **Zone écrite** : `Data/Zone/buried_relic.json`  
- **Seed d'auteur (debug)** : `1644873516998839223` (explicite : False)  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| relic_halls | 1-33 | relic_halls | `buried_relic_1_floor` | crossroads, lattice, mixed | 27 | oui | oui | — |
| relic_depths | 34-66 | relic_depths | `buried_relic_1_floor` | lattice, looping, dense | 12 | oui | oui | — |
| relic_vault | 67-99 | relic_vault | `buried_relic_1_floor` | large_rooms, crossroads, mixed | 11 | oui | oui | — |

## Scènes fixes

- entrée : `—`
- midpoint : `—`
- Ground de fin : `—`
- boss : mode `arena_rsmap` → Ground `—`, rsmap `buried_relic_arena`
  - no fixed 'entrance' Ground declared
  - no fixed 'mid' Ground declared
  - no fixed 'end' Ground declared
  - dedicated arena scene: buried_relic_arena.rsmap (source of truth) → to be converted into a boss Ground

## Étages

| Ét. | Segment | Type | Profil | Grille | Cellule | Variantes OK | Rejets | Rooms (min/moy/max) | Halls | Branches | Culs-de-sac | Boucles | Dist. escaliers | Signatures | Traversable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | relic_halls | procedural | crossroads+lattice+mixed | 5x4 | 10x11 | 5 | 1 | 9/10.4/12 | 16.8 | 5.0 | 4.0 | 3.2 | 47.0 | 5 | oui |
| 2 | relic_halls | procedural | crossroads+lattice+mixed | 5x4 | 9x10 | 5 | 0 | 4/8.0/13 | 8.4 | 1.6 | 3.2 | 0.4 | 38.0 | 5 | oui |
| 3 | relic_halls | procedural | crossroads+lattice+mixed | 6x4 | 11x10 | 5 | 0 | 7/11.2/22 | 13.8 | 3.8 | 3.8 | 1.6 | 46.2 | 5 | oui |
| 4 | relic_halls | procedural | crossroads+lattice+mixed | 7x5 | 13x9 | 5 | 1 | 8/12.8/19 | 15.4 | 4.2 | 4.2 | 1.8 | 43.2 | 5 | oui |
| 5 | relic_halls | procedural | crossroads+lattice+mixed | 4x5 | 12x10 | 5 | 0 | 8/10.4/15 | 14.6 | 4.6 | 3.6 | 2.6 | 52.4 | 5 | oui |
| 6 | relic_halls | procedural | crossroads+lattice+mixed | 5x4 | 12x9 | 5 | 3 | 5/11.2/21 | 14.4 | 3.6 | 3.8 | 1.8 | 47.2 | 5 | oui |
| 7 | relic_halls | procedural | crossroads+lattice+mixed | 4x4 | 12x9 | 5 | 1 | 7/10.4/16 | 11.6 | 3.2 | 4.0 | 1.2 | 43.6 | 5 | oui |
| 8 | relic_halls | procedural | crossroads+lattice+mixed | 4x5 | 12x8 | 5 | 1 | 7/8.4/10 | 13.6 | 4.8 | 3.0 | 2.8 | 39.2 | 5 | oui |
| 9 | relic_halls | procedural | crossroads+lattice+mixed | 5x3 | 11x8 | 5 | 1 | 6/9.4/12 | 13.8 | 3.8 | 2.8 | 2.6 | 50.4 | 5 | oui |
| 10 | relic_halls | procedural | crossroads+lattice+mixed | 5x5 | 10x9 | 5 | 0 | 8/11.6/21 | 17.0 | 5.4 | 3.6 | 3.0 | 43.8 | 5 | oui |
| 11 | relic_halls | procedural | crossroads+lattice+mixed | 7x4 | 13x11 | 5 | 0 | 8/12.4/25 | 17.4 | 5.4 | 4.0 | 2.8 | 42.0 | 5 | oui |
| 12 | relic_halls | procedural | crossroads+lattice+mixed | 5x5 | 11x9 | 5 | 1 | 5/8.2/10 | 8.6 | 1.8 | 4.0 | 0.2 | 40.6 | 5 | oui |
| 13 | relic_halls | procedural | crossroads+lattice+mixed | 5x4 | 12x10 | 5 | 0 | 5/9.8/19 | 12.0 | 3.4 | 4.0 | 1.2 | 42.8 | 5 | oui |
| 14 | relic_halls | procedural | crossroads+lattice+mixed | 4x5 | 13x12 | 5 | 0 | 7/10.4/17 | 13.0 | 3.6 | 4.2 | 1.4 | 38.4 | 5 | oui |
| 15 | relic_halls | procedural | crossroads+lattice+mixed | 7x4 | 9x8 | 5 | 1 | 5/10.0/17 | 15.4 | 4.0 | 3.2 | 2.4 | 48.2 | 5 | oui |
| 16 | relic_halls | procedural | crossroads+lattice+mixed | 5x3 | 12x11 | 5 | 1 | 8/10.4/14 | 12.2 | 3.6 | 4.4 | 1.2 | 36.0 | 5 | oui |
| 17 | relic_halls | procedural | crossroads+lattice+mixed | 6x5 | 12x9 | 5 | 0 | 5/10.6/18 | 15.6 | 4.8 | 3.8 | 2.6 | 35.8 | 5 | oui |
| 18 | relic_halls | procedural | crossroads+lattice+mixed | 7x3 | 10x9 | 5 | 0 | 5/9.2/12 | 11.8 | 3.2 | 4.4 | 1.2 | 40.0 | 5 | oui |
| 19 | relic_halls | procedural | crossroads+lattice+mixed | 5x5 | 8x10 | 5 | 1 | 9/10.2/12 | 15.8 | 5.2 | 4.4 | 2.4 | 42.2 | 5 | oui |
| 20 | relic_halls | procedural | crossroads+lattice+mixed | 4x3 | 9x10 | 5 | 0 | 7/9.2/10 | 11.6 | 3.0 | 3.6 | 1.2 | 50.0 | 5 | oui |
| 21 | relic_halls | procedural | crossroads+lattice+mixed | 4x5 | 8x10 | 5 | 1 | 7/10.4/16 | 11.6 | 2.4 | 3.2 | 1.2 | 40.8 | 5 | oui |
| 22 | relic_halls | procedural | crossroads+lattice+mixed | 5x5 | 12x8 | 5 | 0 | 7/12.0/27 | 14.0 | 3.6 | 4.8 | 1.0 | 43.2 | 5 | oui |
| 23 | relic_halls | procedural | crossroads+lattice+mixed | 6x5 | 11x10 | 5 | 0 | 7/9.4/14 | 13.8 | 4.2 | 4.6 | 2.0 | 46.6 | 5 | oui |
| 24 | relic_halls | procedural | crossroads+lattice+mixed | 5x4 | 10x8 | 5 | 1 | 8/15.0/29 | 19.4 | 5.6 | 3.8 | 2.8 | 52.4 | 5 | oui |
| 25 | relic_halls | procedural | crossroads+lattice+mixed | 5x5 | 13x10 | 5 | 1 | 4/8.4/11 | 11.2 | 2.6 | 2.8 | 1.4 | 36.6 | 5 | oui |
| 26 | relic_halls | procedural | crossroads+lattice+mixed | 4x3 | 12x10 | 5 | 3 | 8/13.2/22 | 15.6 | 4.0 | 3.4 | 1.6 | 37.8 | 5 | oui |
| 27 | relic_halls | procedural | crossroads+lattice+mixed | 5x4 | 13x11 | 5 | 3 | 8/9.4/13 | 12.8 | 4.0 | 3.6 | 2.0 | 34.8 | 5 | oui |
| 28 | relic_halls | procedural | crossroads+lattice+mixed | 5x4 | 11x9 | 5 | 1 | 10/11.8/14 | 20.4 | 7.0 | 5.0 | 3.8 | 50.6 | 5 | oui |
| 29 | relic_halls | procedural | crossroads+lattice+mixed | 5x4 | 13x12 | 5 | 0 | 7/9.0/10 | 12.6 | 3.6 | 3.2 | 2.0 | 38.2 | 5 | oui |
| 30 | relic_halls | procedural | crossroads+lattice+mixed | 5x5 | 11x9 | 5 | 2 | 8/9.6/14 | 15.2 | 5.0 | 5.0 | 2.4 | 40.2 | 5 | oui |
| 31 | relic_halls | procedural | crossroads+lattice+mixed | 5x4 | 9x8 | 5 | 0 | 7/10.2/18 | 14.8 | 3.8 | 3.0 | 2.4 | 38.8 | 5 | oui |
| 32 | relic_halls | procedural | crossroads+lattice+mixed | 5x4 | 12x9 | 5 | 0 | 7/9.8/14 | 14.0 | 4.6 | 4.4 | 2.0 | 40.2 | 5 | oui |
| 33 | relic_halls | procedural | crossroads+lattice+mixed | 6x4 | 11x9 | 5 | 0 | 8/9.4/12 | 12.8 | 3.8 | 3.4 | 2.0 | 38.4 | 5 | oui |
| 34 | relic_depths | procedural | lattice+looping+dense | 8x5 | 7x6 | 5 | 0 | 8/11.8/19 | 15.6 | 3.6 | 3.0 | 1.8 | 33.8 | 5 | oui |
| 35 | relic_depths | procedural | lattice+looping+dense | 6x4 | 12x10 | 5 | 0 | 4/11.8/23 | 15.8 | 4.4 | 2.6 | 2.4 | 36.2 | 5 | oui |
| 36 | relic_depths | procedural | lattice+looping+dense | 8x5 | 8x6 | 5 | 0 | 9/12.2/19 | 20.6 | 6.6 | 3.8 | 3.8 | 45.4 | 5 | oui |
| 37 | relic_depths | procedural | lattice+looping+dense | 4x4 | 9x10 | 5 | 0 | 4/10.8/22 | 15.4 | 4.2 | 1.8 | 2.6 | 41.4 | 5 | oui |
| 38 | relic_depths | procedural | lattice+looping+dense | 6x3 | 11x9 | 5 | 1 | 5/7.6/10 | 11.6 | 3.4 | 2.0 | 2.2 | 39.8 | 5 | oui |
| 39 | relic_depths | procedural | lattice+looping+dense | 6x4 | 8x6 | 5 | 0 | 8/12.6/23 | 18.2 | 5.4 | 2.8 | 2.8 | 44.6 | 5 | oui |
| 40 | relic_depths | procedural | lattice+looping+dense | 6x5 | 10x8 | 5 | 0 | 7/11.6/20 | 16.2 | 5.0 | 2.8 | 2.4 | 31.8 | 5 | oui |
| 41 | relic_depths | procedural | lattice+looping+dense | 4x5 | 12x10 | 5 | 0 | 7/11.6/20 | 18.4 | 5.6 | 3.0 | 3.0 | 40.4 | 5 | oui |
| 42 | relic_depths | procedural | lattice+looping+dense | 7x4 | 9x8 | 5 | 1 | 7/9.6/12 | 15.8 | 5.2 | 3.4 | 2.6 | 39.2 | 5 | oui |
| 43 | relic_depths | procedural | lattice+looping+dense | 8x4 | 8x6 | 5 | 1 | 9/10.8/15 | 16.2 | 4.6 | 3.6 | 2.4 | 35.6 | 5 | oui |
| 44 | relic_depths | procedural | lattice+looping+dense | 6x3 | 9x9 | 5 | 2 | 9/15.2/23 | 19.6 | 6.2 | 3.8 | 2.4 | 34.6 | 5 | oui |
| 45 | relic_depths | procedural | lattice+looping+dense | 6x5 | 11x10 | 5 | 1 | 7/12.6/21 | 16.8 | 4.6 | 2.6 | 2.6 | 45.4 | 5 | oui |
| 46 | relic_depths | procedural | lattice+looping+dense | 7x4 | 7x8 | 5 | 2 | 7/10.6/16 | 18.4 | 6.2 | 2.6 | 3.6 | 44.4 | 5 | oui |
| 47 | relic_depths | procedural | lattice+looping+dense | 6x5 | 11x9 | 5 | 2 | 7/9.2/11 | 14.0 | 3.8 | 2.2 | 2.6 | 41.4 | 5 | oui |
| 48 | relic_depths | procedural | lattice+looping+dense | 5x3 | 11x8 | 5 | 0 | 5/10.6/19 | 15.2 | 4.4 | 2.8 | 2.2 | 46.2 | 5 | oui |
| 49 | relic_depths | procedural | lattice+looping+dense | 5x3 | 12x10 | 5 | 0 | 6/9.4/16 | 14.0 | 4.6 | 2.0 | 2.6 | 36.0 | 5 | oui |
| 50 | relic_depths | procedural | lattice+looping+dense | 4x3 | 12x9 | 5 | 2 | 8/9.2/11 | 14.0 | 3.8 | 2.2 | 2.4 | 44.0 | 5 | oui |
| 51 | relic_depths | procedural | lattice+looping+dense | 4x3 | 9x8 | 5 | 3 | 8/12.4/20 | 20.4 | 7.0 | 2.8 | 4.2 | 30.6 | 5 | oui |
| 52 | relic_depths | procedural | lattice+looping+dense | 8x5 | 7x6 | 5 | 1 | 8/10.4/14 | 17.0 | 6.2 | 3.0 | 3.4 | 38.2 | 5 | oui |
| 53 | relic_depths | procedural | lattice+looping+dense | 5x5 | 11x8 | 5 | 0 | 4/10.2/18 | 15.0 | 5.2 | 3.0 | 2.4 | 37.4 | 5 | oui |
| 54 | relic_depths | procedural | lattice+looping+dense | 5x4 | 10x9 | 5 | 0 | 9/12.6/24 | 21.0 | 7.0 | 2.6 | 4.2 | 35.8 | 5 | oui |
| 55 | relic_depths | procedural | lattice+looping+dense | 7x4 | 9x6 | 5 | 0 | 8/13.0/22 | 17.8 | 4.6 | 3.0 | 2.4 | 38.6 | 5 | oui |
| 56 | relic_depths | procedural | lattice+looping+dense | 4x3 | 10x8 | 5 | 3 | 8/9.8/12 | 12.8 | 4.2 | 2.2 | 2.2 | 39.4 | 5 | oui |
| 57 | relic_depths | procedural | lattice+looping+dense | 6x4 | 9x10 | 5 | 1 | 9/12.2/20 | 19.4 | 6.4 | 3.2 | 3.6 | 41.8 | 5 | oui |
| 58 | relic_depths | procedural | lattice+looping+dense | 4x4 | 9x8 | 5 | 1 | 8/12.0/18 | 15.4 | 4.2 | 3.0 | 2.0 | 43.6 | 5 | oui |
| 59 | relic_depths | procedural | lattice+looping+dense | 4x3 | 10x9 | 5 | 1 | 7/9.2/13 | 17.8 | 6.6 | 2.8 | 4.4 | 48.8 | 5 | oui |
| 60 | relic_depths | procedural | lattice+looping+dense | 5x4 | 10x9 | 5 | 1 | 8/11.2/16 | 16.0 | 5.4 | 2.2 | 2.6 | 40.6 | 5 | oui |
| 61 | relic_depths | procedural | lattice+looping+dense | 4x4 | 9x10 | 5 | 0 | 8/12.2/24 | 16.2 | 4.0 | 3.0 | 2.2 | 35.6 | 5 | oui |
| 62 | relic_depths | procedural | lattice+looping+dense | 4x3 | 9x10 | 5 | 0 | 9/13.6/28 | 19.6 | 6.2 | 4.0 | 2.8 | 42.4 | 5 | oui |
| 63 | relic_depths | procedural | lattice+looping+dense | 5x3 | 11x10 | 5 | 1 | 9/13.2/17 | 20.6 | 7.0 | 2.2 | 4.2 | 42.2 | 5 | oui |
| 64 | relic_depths | procedural | lattice+looping+dense | 8x5 | 9x7 | 5 | 1 | 7/11.0/20 | 14.2 | 4.6 | 3.0 | 2.0 | 45.2 | 5 | oui |
| 65 | relic_depths | procedural | lattice+looping+dense | 6x5 | 12x10 | 5 | 3 | 8/11.8/22 | 17.2 | 6.6 | 3.6 | 3.2 | 40.2 | 5 | oui |
| 66 | relic_depths | procedural | lattice+looping+dense | 8x4 | 8x8 | 5 | 1 | 7/13.2/23 | 17.8 | 6.2 | 3.6 | 2.6 | 36.6 | 5 | oui |
| 67 | relic_vault | procedural | large_rooms+crossroads+mixed | 3x2 | 12x11 | 5 | 0 | 4/8.8/13 | 9.0 | 2.0 | 3.0 | 0.8 | 34.8 | 5 | oui |
| 68 | relic_vault | procedural | large_rooms+crossroads+mixed | 3x3 | 13x11 | 5 | 1 | 4/11.2/19 | 12.0 | 2.8 | 3.4 | 1.0 | 31.6 | 5 | oui |
| 69 | relic_vault | procedural | large_rooms+crossroads+mixed | 5x3 | 13x11 | 5 | 0 | 8/10.6/15 | 10.6 | 2.8 | 3.6 | 0.8 | 42.6 | 5 | oui |
| 70 | relic_vault | procedural | large_rooms+crossroads+mixed | 5x5 | 13x9 | 5 | 0 | 5/7.6/9 | 6.8 | 1.0 | 3.0 | 0.2 | 34.0 | 5 | oui |
| 71 | relic_vault | procedural | large_rooms+crossroads+mixed | 5x3 | 13x8 | 5 | 0 | 6/9.8/20 | 9.8 | 2.2 | 3.0 | 0.8 | 50.8 | 5 | oui |
| 72 | relic_vault | procedural | large_rooms+crossroads+mixed | 3x3 | 14x11 | 5 | 0 | 7/8.4/10 | 8.2 | 1.2 | 2.4 | 0.6 | 50.8 | 5 | oui |
| 73 | relic_vault | procedural | large_rooms+crossroads+mixed | 3x3 | 14x13 | 5 | 0 | 6/11.0/25 | 12.6 | 3.0 | 3.2 | 1.4 | 44.2 | 5 | oui |
| 74 | relic_vault | procedural | large_rooms+crossroads+mixed | 4x3 | 13x10 | 5 | 0 | 5/8.6/15 | 8.4 | 2.0 | 3.0 | 0.8 | 47.0 | 5 | oui |
| 75 | relic_vault | procedural | large_rooms+crossroads+mixed | 5x5 | 12x10 | 5 | 0 | 4/8.6/15 | 8.4 | 2.0 | 3.2 | 0.6 | 30.2 | 5 | oui |
| 76 | relic_vault | procedural | large_rooms+crossroads+mixed | 5x3 | 13x12 | 5 | 0 | 6/8.8/15 | 8.4 | 1.4 | 2.6 | 0.6 | 27.2 | 5 | oui |
| 77 | relic_vault | procedural | large_rooms+crossroads+mixed | 4x2 | 13x10 | 5 | 1 | 4/12.0/21 | 12.8 | 2.6 | 3.2 | 1.0 | 38.6 | 5 | oui |
| 78 | relic_vault | procedural | large_rooms+crossroads+mixed | 3x3 | 16x11 | 5 | 0 | 6/10.0/16 | 10.0 | 1.8 | 2.8 | 0.8 | 39.0 | 5 | oui |
| 79 | relic_vault | procedural | large_rooms+crossroads+mixed | 7x3 | 11x11 | 5 | 0 | 5/10.2/21 | 10.4 | 2.6 | 3.0 | 1.0 | 39.8 | 5 | oui |
| 80 | relic_vault | procedural | large_rooms+crossroads+mixed | 3x2 | 16x11 | 5 | 0 | 7/10.6/19 | 11.0 | 2.6 | 3.6 | 0.8 | 44.6 | 5 | oui |
| 81 | relic_vault | procedural | large_rooms+crossroads+mixed | 4x3 | 15x10 | 5 | 0 | 6/9.8/17 | 9.2 | 1.6 | 3.6 | 0.2 | 36.2 | 5 | oui |
| 82 | relic_vault | procedural | large_rooms+crossroads+mixed | 4x2 | 15x11 | 5 | 0 | 7/9.4/16 | 9.6 | 2.0 | 2.8 | 0.8 | 36.2 | 5 | oui |
| 83 | relic_vault | procedural | large_rooms+crossroads+mixed | 6x4 | 10x9 | 5 | 0 | 5/8.4/10 | 8.4 | 1.8 | 3.0 | 0.6 | 40.4 | 5 | oui |
| 84 | relic_vault | procedural | large_rooms+crossroads+mixed | 6x3 | 11x8 | 5 | 0 | 6/9.2/12 | 9.2 | 2.4 | 3.2 | 0.8 | 34.8 | 5 | oui |
| 85 | relic_vault | procedural | large_rooms+crossroads+mixed | 6x4 | 9x8 | 5 | 1 | 5/9.0/13 | 9.4 | 2.2 | 3.0 | 0.8 | 43.0 | 5 | oui |
| 86 | relic_vault | procedural | large_rooms+crossroads+mixed | 3x2 | 16x13 | 5 | 0 | 6/8.8/12 | 9.0 | 1.8 | 2.8 | 0.8 | 28.0 | 5 | oui |
| 87 | relic_vault | procedural | large_rooms+crossroads+mixed | 6x5 | 12x9 | 5 | 0 | 4/7.0/9 | 6.2 | 1.2 | 3.4 | 0.2 | 42.0 | 5 | oui |
| 88 | relic_vault | procedural | large_rooms+crossroads+mixed | 6x4 | 9x10 | 5 | 1 | 7/9.8/14 | 10.6 | 2.6 | 2.6 | 1.2 | 34.2 | 5 | oui |
| 89 | relic_vault | procedural | large_rooms+crossroads+mixed | 4x2 | 16x11 | 5 | 1 | 5/10.8/18 | 11.2 | 2.6 | 3.4 | 0.8 | 36.4 | 5 | oui |
| 90 | relic_vault | procedural | large_rooms+crossroads+mixed | 4x3 | 12x13 | 5 | 0 | 5/9.2/19 | 9.4 | 2.2 | 3.0 | 1.0 | 39.0 | 5 | oui |
| 91 | relic_vault | procedural | large_rooms+crossroads+mixed | 5x5 | 9x10 | 5 | 0 | 5/9.4/16 | 9.0 | 1.6 | 3.4 | 0.4 | 49.4 | 5 | oui |
| 92 | relic_vault | procedural | large_rooms+crossroads+mixed | 7x5 | 9x10 | 5 | 0 | 5/9.0/16 | 9.2 | 2.0 | 2.8 | 0.8 | 46.8 | 5 | oui |
| 93 | relic_vault | procedural | large_rooms+crossroads+mixed | 7x5 | 10x7 | 5 | 0 | 4/7.6/14 | 7.4 | 1.2 | 2.6 | 0.6 | 27.8 | 5 | oui |
| 94 | relic_vault | procedural | large_rooms+crossroads+mixed | 4x2 | 15x10 | 5 | 0 | 6/8.6/14 | 8.2 | 1.0 | 2.8 | 0.4 | 38.0 | 5 | oui |
| 95 | relic_vault | procedural | large_rooms+crossroads+mixed | 3x3 | 12x10 | 5 | 1 | 7/10.4/17 | 11.8 | 2.8 | 2.0 | 1.6 | 41.0 | 5 | oui |
| 96 | relic_vault | procedural | large_rooms+crossroads+mixed | 4x5 | 13x8 | 5 | 0 | 5/9.6/18 | 9.8 | 2.2 | 2.8 | 1.0 | 43.2 | 5 | oui |
| 97 | relic_vault | procedural | large_rooms+crossroads+mixed | 7x5 | 10x9 | 5 | 0 | 4/8.8/16 | 8.4 | 1.4 | 3.0 | 0.4 | 46.4 | 5 | oui |
| 98 | relic_vault | procedural | large_rooms+crossroads+mixed | 3x3 | 16x11 | 5 | 0 | 7/11.2/21 | 11.2 | 2.4 | 3.6 | 0.8 | 35.8 | 5 | oui |
