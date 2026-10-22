# Rapport de génération — Joyous Tower

- **ID** : `joyous_tower`  
- **Chapitre** : 27 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Joyous Tower (99F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/JoyousTower) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 27. Recoupé avec Bulbapedia (page « Joyous Tower »).  
- **Étages** : 99 — direction `sommet`  
- **Zone écrite** : `Data/Zone/joyous_tower.json`  
- **Seed d'auteur (debug)** : `4373681568592600798` (explicite : False)  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| tower_base | 1-33 | tower_base | `lush_prairie_floor` | crossroads, branching, mixed | 43 | oui | oui | — |
| tower_middle | 34-66 | tower_middle | `lush_prairie_floor` | lattice, looping, mixed | 50 | oui | oui | — |
| tower_top | 67-99 | tower_top | `lush_prairie_floor` | large_rooms, crossroads, mixed | 32 | oui | oui | — |

## Scènes fixes

- entrée : `—`
- midpoint : `—`
- Ground de fin : `—`
- boss : mode `` → Ground `—`, rsmap `—`
  - no fixed 'entrance' Ground declared
  - no fixed 'mid' Ground declared
  - no fixed 'end' Ground declared
  - no boss scene declared

## Étages

| Ét. | Segment | Type | Profil | Grille | Cellule | Variantes OK | Rejets | Rooms (min/moy/max) | Halls | Branches | Culs-de-sac | Boucles | Dist. escaliers | Signatures | Traversable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | tower_base | procedural | crossroads+branching+mixed | 6x4 | 12x10 | 5 | 1 | 9/14.8/21 | 16.6 | 4.4 | 4.2 | 1.8 | 41.4 | 5 | oui |
| 2 | tower_base | procedural | crossroads+branching+mixed | 5x5 | 9x10 | 5 | 2 | 8/12.0/16 | 11.6 | 2.4 | 4.0 | 0.6 | 41.8 | 5 | oui |
| 3 | tower_base | procedural | crossroads+branching+mixed | 4x3 | 9x10 | 5 | 0 | 7/11.6/14 | 12.0 | 2.8 | 3.4 | 0.8 | 33.4 | 5 | oui |
| 4 | tower_base | procedural | crossroads+branching+mixed | 4x4 | 11x9 | 5 | 1 | 8/11.4/15 | 12.8 | 3.8 | 3.4 | 1.4 | 34.8 | 5 | oui |
| 5 | tower_base | procedural | crossroads+branching+mixed | 6x3 | 11x11 | 5 | 2 | 6/10.0/16 | 9.6 | 2.4 | 3.8 | 0.6 | 41.0 | 5 | oui |
| 6 | tower_base | procedural | crossroads+branching+mixed | 6x4 | 11x10 | 5 | 0 | 8/10.6/14 | 11.0 | 2.8 | 3.4 | 1.0 | 50.6 | 5 | oui |
| 7 | tower_base | procedural | crossroads+branching+mixed | 4x4 | 12x9 | 5 | 1 | 10/12.4/16 | 12.4 | 3.4 | 4.2 | 1.0 | 52.4 | 5 | oui |
| 8 | tower_base | procedural | crossroads+branching+mixed | 6x5 | 13x10 | 5 | 0 | 8/8.6/10 | 8.2 | 2.0 | 3.4 | 0.6 | 36.6 | 5 | oui |
| 9 | tower_base | procedural | crossroads+branching+mixed | 5x3 | 10x7 | 5 | 0 | 8/11.0/14 | 10.6 | 2.2 | 3.8 | 0.4 | 38.6 | 5 | oui |
| 10 | tower_base | procedural | crossroads+branching+mixed | 4x4 | 11x8 | 5 | 0 | 8/11.2/17 | 11.2 | 3.2 | 4.0 | 0.8 | 31.0 | 5 | oui |
| 11 | tower_base | procedural | crossroads+branching+mixed | 5x4 | 10x12 | 5 | 0 | 7/10.6/15 | 10.4 | 2.8 | 5.0 | 0.4 | 34.0 | 5 | oui |
| 12 | tower_base | procedural | crossroads+branching+mixed | 5x4 | 9x9 | 5 | 0 | 7/9.4/15 | 9.2 | 2.4 | 4.2 | 0.4 | 28.0 | 5 | oui |
| 13 | tower_base | procedural | crossroads+branching+mixed | 7x3 | 12x9 | 5 | 0 | 7/10.8/14 | 10.6 | 2.4 | 4.2 | 0.4 | 33.0 | 5 | oui |
| 14 | tower_base | procedural | crossroads+branching+mixed | 5x3 | 11x10 | 5 | 0 | 8/10.0/13 | 9.6 | 2.2 | 4.2 | 0.4 | 36.8 | 5 | oui |
| 15 | tower_base | procedural | crossroads+branching+mixed | 6x5 | 9x10 | 5 | 0 | 8/12.0/18 | 13.0 | 3.2 | 3.6 | 1.4 | 40.6 | 5 | oui |
| 16 | tower_base | procedural | crossroads+branching+mixed | 5x3 | 10x8 | 5 | 0 | 7/8.8/11 | 8.4 | 1.8 | 4.0 | 0.2 | 47.6 | 5 | oui |
| 17 | tower_base | procedural | crossroads+branching+mixed | 4x4 | 9x9 | 5 | 0 | 7/9.8/19 | 9.8 | 2.4 | 3.6 | 0.6 | 43.2 | 5 | oui |
| 18 | tower_base | procedural | crossroads+branching+mixed | 5x3 | 13x9 | 5 | 2 | 8/10.4/16 | 10.8 | 2.4 | 3.6 | 0.6 | 35.6 | 5 | oui |
| 19 | tower_base | procedural | crossroads+branching+mixed | 4x4 | 12x9 | 5 | 1 | 7/13.4/23 | 15.2 | 4.0 | 3.6 | 1.8 | 33.0 | 5 | oui |
| 20 | tower_base | procedural | crossroads+branching+mixed | 5x5 | 12x10 | 5 | 1 | 7/10.0/14 | 10.0 | 2.8 | 4.0 | 0.8 | 39.4 | 5 | oui |
| 21 | tower_base | procedural | crossroads+branching+mixed | 7x5 | 14x7 | 5 | 0 | 7/10.6/17 | 11.0 | 2.4 | 3.2 | 0.8 | 37.2 | 5 | oui |
| 22 | tower_base | procedural | crossroads+branching+mixed | 6x3 | 14x10 | 5 | 2 | 8/12.4/18 | 13.2 | 2.8 | 3.8 | 0.8 | 42.8 | 5 | oui |
| 23 | tower_base | procedural | crossroads+branching+mixed | 4x3 | 11x9 | 5 | 0 | 7/9.6/12 | 9.4 | 2.4 | 3.8 | 0.6 | 34.8 | 5 | oui |
| 24 | tower_base | procedural | crossroads+branching+mixed | 4x3 | 9x9 | 5 | 1 | 7/8.0/10 | 7.4 | 1.4 | 3.8 | 0.4 | 39.4 | 5 | oui |
| 25 | tower_base | procedural | crossroads+branching+mixed | 6x4 | 11x8 | 5 | 0 | 8/10.4/12 | 9.8 | 2.0 | 3.8 | 0.4 | 38.6 | 5 | oui |
| 26 | tower_base | procedural | crossroads+branching+mixed | 4x4 | 9x7 | 5 | 3 | 8/10.8/15 | 11.2 | 3.0 | 4.2 | 1.0 | 42.4 | 5 | oui |
| 27 | tower_base | procedural | crossroads+branching+mixed | 6x3 | 11x9 | 5 | 2 | 9/11.4/15 | 11.6 | 3.0 | 4.0 | 0.8 | 42.4 | 5 | oui |
| 28 | tower_base | procedural | crossroads+branching+mixed | 7x4 | 14x12 | 5 | 0 | 7/10.6/16 | 10.8 | 2.8 | 3.2 | 1.0 | 37.6 | 5 | oui |
| 29 | tower_base | procedural | crossroads+branching+mixed | 6x4 | 12x9 | 5 | 0 | 7/12.6/23 | 13.4 | 3.6 | 4.2 | 1.0 | 37.2 | 5 | oui |
| 30 | tower_base | procedural | crossroads+branching+mixed | 7x3 | 9x10 | 5 | 0 | 7/9.8/14 | 9.6 | 2.0 | 3.8 | 0.6 | 36.0 | 5 | oui |
| 31 | tower_base | procedural | crossroads+branching+mixed | 7x5 | 11x8 | 5 | 0 | 8/9.8/12 | 9.4 | 2.0 | 3.8 | 0.4 | 32.6 | 5 | oui |
| 32 | tower_base | procedural | crossroads+branching+mixed | 5x4 | 11x9 | 5 | 0 | 7/10.8/16 | 10.8 | 2.6 | 4.2 | 0.8 | 43.0 | 5 | oui |
| 33 | tower_base | procedural | crossroads+branching+mixed | 5x4 | 10x8 | 5 | 0 | 7/13.6/30 | 14.0 | 3.6 | 4.8 | 1.2 | 33.6 | 5 | oui |
| 34 | tower_middle | procedural | lattice+looping+mixed | 4x5 | 12x10 | 5 | 1 | 6/9.6/12 | 14.0 | 4.2 | 1.4 | 2.8 | 31.0 | 5 | oui |
| 35 | tower_middle | procedural | lattice+looping+mixed | 6x5 | 9x8 | 5 | 0 | 8/9.0/12 | 15.4 | 4.6 | 1.6 | 3.8 | 41.2 | 5 | oui |
| 36 | tower_middle | procedural | lattice+looping+mixed | 4x5 | 12x10 | 5 | 1 | 8/11.0/19 | 15.2 | 4.8 | 2.0 | 3.0 | 45.2 | 5 | oui |
| 37 | tower_middle | procedural | lattice+looping+mixed | 4x3 | 12x9 | 5 | 2 | 8/10.4/13 | 15.0 | 4.6 | 2.6 | 2.4 | 46.8 | 5 | oui |
| 38 | tower_middle | procedural | lattice+looping+mixed | 5x5 | 11x8 | 5 | 1 | 5/14.2/27 | 17.0 | 5.0 | 2.6 | 2.2 | 37.0 | 5 | oui |
| 39 | tower_middle | procedural | lattice+looping+mixed | 5x5 | 10x9 | 5 | 0 | 4/8.0/11 | 9.8 | 2.6 | 2.0 | 1.4 | 33.4 | 5 | oui |
| 40 | tower_middle | procedural | lattice+looping+mixed | 4x3 | 11x8 | 5 | 0 | 7/9.0/12 | 12.8 | 4.0 | 1.6 | 2.4 | 38.8 | 5 | oui |
| 41 | tower_middle | procedural | lattice+looping+mixed | 4x4 | 12x9 | 5 | 2 | 7/12.0/21 | 14.2 | 4.4 | 2.6 | 2.0 | 44.0 | 5 | oui |
| 42 | tower_middle | procedural | lattice+looping+mixed | 5x5 | 14x9 | 5 | 0 | 5/11.6/24 | 14.6 | 3.8 | 2.2 | 2.2 | 37.4 | 5 | oui |
| 43 | tower_middle | procedural | lattice+looping+mixed | 6x4 | 11x8 | 5 | 0 | 5/10.6/15 | 14.8 | 4.4 | 3.0 | 2.4 | 37.4 | 5 | oui |
| 44 | tower_middle | procedural | lattice+looping+mixed | 5x4 | 12x9 | 5 | 0 | 10/12.4/16 | 21.8 | 8.2 | 2.0 | 5.4 | 44.0 | 5 | oui |
| 45 | tower_middle | procedural | lattice+looping+mixed | 4x4 | 9x10 | 5 | 0 | 6/11.4/18 | 17.6 | 4.8 | 2.0 | 3.0 | 40.2 | 5 | oui |
| 46 | tower_middle | procedural | lattice+looping+mixed | 4x3 | 12x10 | 5 | 0 | 7/9.8/14 | 13.6 | 4.8 | 2.6 | 2.6 | 42.4 | 5 | oui |
| 47 | tower_middle | procedural | lattice+looping+mixed | 4x4 | 11x8 | 5 | 0 | 9/10.6/13 | 14.8 | 4.2 | 2.4 | 2.4 | 39.4 | 5 | oui |
| 48 | tower_middle | procedural | lattice+looping+mixed | 4x4 | 10x8 | 5 | 0 | 8/12.0/18 | 19.2 | 6.6 | 3.8 | 3.6 | 47.0 | 5 | oui |
| 49 | tower_middle | procedural | lattice+looping+mixed | 4x5 | 11x9 | 5 | 1 | 9/11.4/15 | 15.8 | 5.0 | 2.4 | 2.8 | 53.6 | 5 | oui |
| 50 | tower_middle | procedural | lattice+looping+mixed | 6x3 | 11x9 | 5 | 0 | 9/11.4/15 | 16.8 | 5.8 | 3.6 | 2.8 | 34.6 | 5 | oui |
| 51 | tower_middle | procedural | lattice+looping+mixed | 5x4 | 10x9 | 5 | 0 | 7/9.8/14 | 13.4 | 3.2 | 2.2 | 2.2 | 35.8 | 5 | oui |
| 52 | tower_middle | procedural | lattice+looping+mixed | 5x4 | 11x7 | 5 | 0 | 9/10.4/14 | 15.4 | 5.0 | 3.8 | 2.4 | 44.6 | 5 | oui |
| 53 | tower_middle | procedural | lattice+looping+mixed | 6x5 | 9x9 | 5 | 1 | 7/10.0/13 | 16.2 | 5.6 | 2.2 | 3.6 | 29.0 | 5 | oui |
| 54 | tower_middle | procedural | lattice+looping+mixed | 4x4 | 11x10 | 5 | 0 | 8/13.0/27 | 19.0 | 6.4 | 3.6 | 3.2 | 56.2 | 5 | oui |
| 55 | tower_middle | procedural | lattice+looping+mixed | 4x4 | 10x10 | 5 | 0 | 8/10.2/12 | 16.8 | 5.4 | 2.4 | 3.6 | 38.2 | 5 | oui |
| 56 | tower_middle | procedural | lattice+looping+mixed | 6x4 | 11x7 | 5 | 1 | 9/10.4/11 | 15.2 | 4.4 | 2.6 | 2.6 | 32.4 | 5 | oui |
| 57 | tower_middle | procedural | lattice+looping+mixed | 5x5 | 9x7 | 5 | 1 | 5/10.8/20 | 15.6 | 4.6 | 2.0 | 3.0 | 30.6 | 5 | oui |
| 58 | tower_middle | procedural | lattice+looping+mixed | 7x4 | 10x11 | 5 | 0 | 8/11.8/17 | 15.6 | 4.0 | 2.4 | 2.2 | 43.6 | 5 | oui |
| 59 | tower_middle | procedural | lattice+looping+mixed | 5x3 | 11x9 | 5 | 2 | 10/15.4/23 | 20.0 | 6.0 | 1.4 | 3.6 | 50.4 | 5 | oui |
| 60 | tower_middle | procedural | lattice+looping+mixed | 5x3 | 11x9 | 5 | 0 | 7/9.6/16 | 15.0 | 4.8 | 2.6 | 2.8 | 43.0 | 5 | oui |
| 61 | tower_middle | procedural | lattice+looping+mixed | 7x5 | 9x10 | 5 | 0 | 7/11.2/19 | 16.0 | 5.4 | 2.6 | 3.0 | 45.6 | 5 | oui |
| 62 | tower_middle | procedural | lattice+looping+mixed | 4x3 | 10x9 | 5 | 0 | 8/13.0/25 | 16.8 | 5.2 | 2.6 | 2.6 | 49.6 | 5 | oui |
| 63 | tower_middle | procedural | lattice+looping+mixed | 7x5 | 9x7 | 5 | 0 | 4/11.2/16 | 17.8 | 6.0 | 2.0 | 3.8 | 48.0 | 5 | oui |
| 64 | tower_middle | procedural | lattice+looping+mixed | 5x3 | 8x8 | 5 | 0 | 9/9.6/11 | 15.0 | 4.6 | 2.4 | 2.8 | 39.8 | 5 | oui |
| 65 | tower_middle | procedural | lattice+looping+mixed | 5x5 | 12x9 | 5 | 0 | 4/7.4/13 | 10.6 | 2.8 | 1.0 | 2.0 | 40.4 | 5 | oui |
| 66 | tower_middle | procedural | lattice+looping+mixed | 6x5 | 11x8 | 5 | 0 | 5/9.8/14 | 13.2 | 3.6 | 3.0 | 2.0 | 37.2 | 5 | oui |
| 67 | tower_top | procedural | large_rooms+crossroads+mixed | 3x2 | 13x13 | 5 | 1 | 5/8.4/11 | 8.2 | 1.6 | 2.4 | 0.8 | 37.6 | 5 | oui |
| 68 | tower_top | procedural | large_rooms+crossroads+mixed | 6x5 | 11x11 | 5 | 0 | 10/10.8/11 | 10.8 | 2.0 | 2.8 | 0.8 | 39.4 | 5 | oui |
| 69 | tower_top | procedural | large_rooms+crossroads+mixed | 4x3 | 8x9 | 5 | 0 | 6/9.8/18 | 10.0 | 2.2 | 3.0 | 0.8 | 42.6 | 5 | oui |
| 70 | tower_top | procedural | large_rooms+crossroads+mixed | 3x3 | 16x11 | 5 | 0 | 5/8.8/16 | 9.0 | 2.4 | 3.4 | 0.8 | 34.2 | 5 | oui |
| 71 | tower_top | procedural | large_rooms+crossroads+mixed | 7x5 | 13x11 | 5 | 1 | 5/9.8/14 | 10.6 | 2.8 | 2.4 | 1.4 | 31.8 | 5 | oui |
| 72 | tower_top | procedural | large_rooms+crossroads+mixed | 4x5 | 8x10 | 5 | 0 | 7/9.4/12 | 9.6 | 2.0 | 3.0 | 0.8 | 34.4 | 5 | oui |
| 73 | tower_top | procedural | large_rooms+crossroads+mixed | 6x5 | 10x9 | 5 | 0 | 4/8.8/13 | 8.8 | 1.4 | 3.0 | 0.4 | 33.6 | 5 | oui |
| 74 | tower_top | procedural | large_rooms+crossroads+mixed | 3x2 | 15x11 | 5 | 0 | 4/9.4/15 | 9.0 | 1.6 | 3.4 | 0.4 | 42.2 | 5 | oui |
| 75 | tower_top | procedural | large_rooms+crossroads+mixed | 6x5 | 10x9 | 5 | 1 | 4/8.8/17 | 8.6 | 1.6 | 2.8 | 0.6 | 44.6 | 5 | oui |
| 76 | tower_top | procedural | large_rooms+crossroads+mixed | 7x4 | 12x7 | 5 | 0 | 7/9.0/12 | 8.8 | 2.2 | 3.4 | 0.6 | 36.2 | 5 | oui |
| 77 | tower_top | procedural | large_rooms+crossroads+mixed | 3x3 | 15x11 | 5 | 0 | 5/9.0/13 | 8.6 | 1.8 | 3.2 | 0.6 | 41.6 | 5 | oui |
| 78 | tower_top | procedural | large_rooms+crossroads+mixed | 3x3 | 15x11 | 5 | 0 | 5/8.6/14 | 9.4 | 2.4 | 2.6 | 1.2 | 36.0 | 5 | oui |
| 79 | tower_top | procedural | large_rooms+crossroads+mixed | 3x2 | 15x13 | 5 | 0 | 7/8.2/10 | 7.6 | 1.4 | 3.0 | 0.4 | 40.0 | 5 | oui |
| 80 | tower_top | procedural | large_rooms+crossroads+mixed | 7x4 | 11x9 | 5 | 2 | 4/7.8/12 | 7.6 | 1.6 | 2.6 | 0.6 | 42.8 | 5 | oui |
| 81 | tower_top | procedural | large_rooms+crossroads+mixed | 6x3 | 10x9 | 5 | 0 | 4/7.2/11 | 7.4 | 1.4 | 2.4 | 0.8 | 34.4 | 5 | oui |
| 82 | tower_top | procedural | large_rooms+crossroads+mixed | 4x3 | 8x11 | 5 | 1 | 4/10.0/17 | 10.2 | 2.0 | 2.8 | 0.8 | 38.6 | 5 | oui |
| 83 | tower_top | procedural | large_rooms+crossroads+mixed | 6x4 | 10x8 | 5 | 0 | 7/9.4/15 | 9.2 | 1.8 | 2.8 | 0.8 | 35.2 | 5 | oui |
| 84 | tower_top | procedural | large_rooms+crossroads+mixed | 4x3 | 14x10 | 5 | 0 | 6/9.6/14 | 9.4 | 2.0 | 3.2 | 0.6 | 46.0 | 5 | oui |
| 85 | tower_top | procedural | large_rooms+crossroads+mixed | 3x3 | 15x10 | 5 | 2 | 6/11.6/22 | 14.0 | 4.0 | 3.2 | 2.0 | 35.4 | 5 | oui |
| 86 | tower_top | procedural | large_rooms+crossroads+mixed | 7x5 | 11x9 | 5 | 0 | 4/9.4/13 | 9.8 | 2.6 | 2.6 | 1.2 | 45.8 | 5 | oui |
| 87 | tower_top | procedural | large_rooms+crossroads+mixed | 4x2 | 14x12 | 5 | 1 | 5/11.8/21 | 13.2 | 3.4 | 3.4 | 1.6 | 46.4 | 5 | oui |
| 88 | tower_top | procedural | large_rooms+crossroads+mixed | 3x2 | 14x12 | 5 | 1 | 5/7.2/10 | 6.4 | 0.8 | 2.8 | 0.2 | 44.6 | 5 | oui |
| 89 | tower_top | procedural | large_rooms+crossroads+mixed | 4x2 | 15x12 | 5 | 0 | 7/10.0/15 | 9.8 | 2.0 | 3.4 | 0.6 | 41.0 | 5 | oui |
| 90 | tower_top | procedural | large_rooms+crossroads+mixed | 4x2 | 14x12 | 5 | 0 | 5/9.0/13 | 8.2 | 1.6 | 3.6 | 0.2 | 36.2 | 5 | oui |
| 91 | tower_top | procedural | large_rooms+crossroads+mixed | 4x3 | 13x11 | 5 | 0 | 5/7.6/10 | 7.0 | 1.4 | 3.0 | 0.4 | 39.8 | 5 | oui |
| 92 | tower_top | procedural | large_rooms+crossroads+mixed | 3x3 | 12x11 | 5 | 1 | 6/10.6/14 | 11.6 | 2.8 | 2.6 | 1.2 | 42.0 | 5 | oui |
| 93 | tower_top | procedural | large_rooms+crossroads+mixed | 7x3 | 10x9 | 5 | 1 | 4/8.2/12 | 8.8 | 2.2 | 2.0 | 1.2 | 30.8 | 5 | oui |
| 94 | tower_top | procedural | large_rooms+crossroads+mixed | 6x5 | 11x8 | 5 | 0 | 4/9.2/17 | 9.4 | 1.8 | 2.6 | 0.8 | 40.4 | 5 | oui |
| 95 | tower_top | procedural | large_rooms+crossroads+mixed | 4x3 | 12x11 | 5 | 1 | 5/9.6/20 | 10.4 | 2.8 | 2.8 | 1.2 | 45.0 | 5 | oui |
| 96 | tower_top | procedural | large_rooms+crossroads+mixed | 3x2 | 12x11 | 5 | 1 | 4/10.8/18 | 12.4 | 3.0 | 3.0 | 1.4 | 43.6 | 5 | oui |
| 97 | tower_top | procedural | large_rooms+crossroads+mixed | 7x4 | 12x8 | 5 | 0 | 7/11.0/22 | 11.0 | 2.2 | 3.0 | 0.8 | 33.0 | 5 | oui |
| 98 | tower_top | procedural | large_rooms+crossroads+mixed | 4x3 | 13x13 | 5 | 1 | 5/9.0/12 | 9.4 | 2.2 | 2.6 | 1.0 | 34.4 | 5 | oui |
| 99 | tower_top | procedural | large_rooms+crossroads+mixed | 7x4 | 11x9 | 5 | 0 | 6/10.0/18 | 11.0 | 2.2 | 2.6 | 1.2 | 48.6 | 5 | oui |
