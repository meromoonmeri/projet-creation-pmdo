# Rapport de génération — Western Cave

- **ID** : `western_cave`  
- **Chapitre** : 14 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Western Cave (99F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/WesternCave) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 14. Recoupé avec Bulbapedia (page « Western Cave »).  
- **Étages** : 99 — direction `fond`  
- **Zone écrite** : `Data/Zone/western_cave.json`  
- **Seed d'auteur (debug)** : `9100710750576887767` (explicite : False)  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| western_gallery | 1-33 | western_gallery | `western_cave_1_floor` | branching, mixed, dense | 28 | oui | oui | — |
| western_depths | 34-66 | western_depths | `western_cave_1_floor` | looping, lattice, mixed | 15 | oui | oui | — |
| western_abyss | 67-99 | western_abyss | `western_cave_1_floor` | large_rooms, mixed, looping | 12 | oui | oui | — |

## Scènes fixes

- entrée : `—`
- midpoint : `—`
- Ground de fin : `antre_occident`
- boss : mode `canonical_ground` → Ground `antre_occident`, rsmap `—`
  - no fixed 'entrance' Ground declared
  - no fixed 'mid' Ground declared
  - final battle stays on the canonical end Ground 'antre_occident' (no separate arena created)

## Étages

| Ét. | Segment | Type | Profil | Grille | Cellule | Variantes OK | Rejets | Rooms (min/moy/max) | Halls | Branches | Culs-de-sac | Boucles | Dist. escaliers | Signatures | Traversable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | western_gallery | procedural | branching+mixed+dense | 5x3 | 10x8 | 5 | 1 | 9/12.6/20 | 13.6 | 4.6 | 3.4 | 1.8 | 33.8 | 5 | oui |
| 2 | western_gallery | procedural | branching+mixed+dense | 6x3 | 12x8 | 5 | 0 | 11/15.0/22 | 16.6 | 4.8 | 4.6 | 1.4 | 42.0 | 5 | oui |
| 3 | western_gallery | procedural | branching+mixed+dense | 4x4 | 14x10 | 5 | 0 | 11/14.8/28 | 17.4 | 4.6 | 3.8 | 1.8 | 52.0 | 5 | oui |
| 4 | western_gallery | procedural | branching+mixed+dense | 8x4 | 9x6 | 5 | 0 | 6/14.8/24 | 16.8 | 4.4 | 4.4 | 1.4 | 53.0 | 5 | oui |
| 5 | western_gallery | procedural | branching+mixed+dense | 7x3 | 12x12 | 5 | 2 | 6/11.2/18 | 13.2 | 4.4 | 3.2 | 1.8 | 40.8 | 5 | oui |
| 6 | western_gallery | procedural | branching+mixed+dense | 7x5 | 9x6 | 5 | 1 | 8/12.6/25 | 13.8 | 3.4 | 4.2 | 1.2 | 44.0 | 5 | oui |
| 7 | western_gallery | procedural | branching+mixed+dense | 6x3 | 12x10 | 5 | 0 | 8/12.2/17 | 13.8 | 4.0 | 5.0 | 1.0 | 39.8 | 5 | oui |
| 8 | western_gallery | procedural | branching+mixed+dense | 6x4 | 8x6 | 5 | 0 | 11/16.2/22 | 18.4 | 6.2 | 5.0 | 2.2 | 44.4 | 5 | oui |
| 9 | western_gallery | procedural | branching+mixed+dense | 5x4 | 12x10 | 5 | 0 | 7/14.4/22 | 15.2 | 4.6 | 5.2 | 0.8 | 46.0 | 5 | oui |
| 10 | western_gallery | procedural | branching+mixed+dense | 6x4 | 10x8 | 5 | 0 | 9/14.6/25 | 16.4 | 5.2 | 4.6 | 1.4 | 33.6 | 5 | oui |
| 11 | western_gallery | procedural | branching+mixed+dense | 4x3 | 10x9 | 5 | 0 | 9/13.6/22 | 15.4 | 4.8 | 4.4 | 1.4 | 30.6 | 5 | oui |
| 12 | western_gallery | procedural | branching+mixed+dense | 7x4 | 14x11 | 5 | 0 | 12/17.4/31 | 19.2 | 4.8 | 5.2 | 1.4 | 40.4 | 5 | oui |
| 13 | western_gallery | procedural | branching+mixed+dense | 4x5 | 11x7 | 5 | 0 | 12/18.6/26 | 21.4 | 5.8 | 5.0 | 2.0 | 48.6 | 5 | oui |
| 14 | western_gallery | procedural | branching+mixed+dense | 6x3 | 12x9 | 5 | 0 | 10/15.0/23 | 17.4 | 4.8 | 4.6 | 1.4 | 29.0 | 5 | oui |
| 15 | western_gallery | procedural | branching+mixed+dense | 5x3 | 12x8 | 5 | 1 | 6/12.6/28 | 13.6 | 4.4 | 3.4 | 1.6 | 40.8 | 5 | oui |
| 16 | western_gallery | procedural | branching+mixed+dense | 5x4 | 10x10 | 5 | 1 | 7/12.8/23 | 14.0 | 4.2 | 4.4 | 1.4 | 32.8 | 5 | oui |
| 17 | western_gallery | procedural | branching+mixed+dense | 6x3 | 12x10 | 5 | 0 | 6/12.8/18 | 14.4 | 3.8 | 3.8 | 1.2 | 37.8 | 5 | oui |
| 18 | western_gallery | procedural | branching+mixed+dense | 8x4 | 9x8 | 5 | 0 | 7/15.0/22 | 17.4 | 4.8 | 4.6 | 1.4 | 33.6 | 5 | oui |
| 19 | western_gallery | procedural | branching+mixed+dense | 4x4 | 9x11 | 5 | 0 | 9/13.6/21 | 15.8 | 3.8 | 3.8 | 1.4 | 52.2 | 5 | oui |
| 20 | western_gallery | procedural | branching+mixed+dense | 6x3 | 13x8 | 5 | 1 | 6/9.6/14 | 9.6 | 2.6 | 3.6 | 0.6 | 35.8 | 5 | oui |
| 21 | western_gallery | procedural | branching+mixed+dense | 7x5 | 7x6 | 5 | 0 | 8/14.4/27 | 16.4 | 5.6 | 4.4 | 2.0 | 39.8 | 5 | oui |
| 22 | western_gallery | procedural | branching+mixed+dense | 5x3 | 9x11 | 5 | 0 | 12/17.4/25 | 19.2 | 4.8 | 3.6 | 1.8 | 45.6 | 5 | oui |
| 23 | western_gallery | procedural | branching+mixed+dense | 8x4 | 8x6 | 5 | 0 | 13/19.4/25 | 23.2 | 7.6 | 5.8 | 2.8 | 45.0 | 5 | oui |
| 24 | western_gallery | procedural | branching+mixed+dense | 6x5 | 11x12 | 5 | 0 | 8/11.6/18 | 12.4 | 3.4 | 4.4 | 0.8 | 43.0 | 5 | oui |
| 25 | western_gallery | procedural | branching+mixed+dense | 5x4 | 14x7 | 5 | 0 | 9/17.6/28 | 21.0 | 5.8 | 4.4 | 2.4 | 53.4 | 5 | oui |
| 26 | western_gallery | procedural | branching+mixed+dense | 6x3 | 9x10 | 5 | 0 | 12/14.8/18 | 16.2 | 4.6 | 5.2 | 1.6 | 37.6 | 5 | oui |
| 27 | western_gallery | procedural | branching+mixed+dense | 6x4 | 11x10 | 5 | 0 | 6/11.4/22 | 11.8 | 3.2 | 4.2 | 0.6 | 36.2 | 5 | oui |
| 28 | western_gallery | procedural | branching+mixed+dense | 4x4 | 10x12 | 5 | 2 | 8/16.4/23 | 19.6 | 5.8 | 3.4 | 2.8 | 38.8 | 5 | oui |
| 29 | western_gallery | procedural | branching+mixed+dense | 7x5 | 10x10 | 5 | 0 | 6/12.4/23 | 13.6 | 3.8 | 3.6 | 1.4 | 43.8 | 5 | oui |
| 30 | western_gallery | procedural | branching+mixed+dense | 8x5 | 8x8 | 5 | 1 | 9/11.8/16 | 11.8 | 3.6 | 4.2 | 1.0 | 39.0 | 5 | oui |
| 31 | western_gallery | procedural | branching+mixed+dense | 7x5 | 8x6 | 5 | 0 | 11/15.2/19 | 16.0 | 4.8 | 4.8 | 1.2 | 40.4 | 5 | oui |
| 32 | western_gallery | procedural | branching+mixed+dense | 4x3 | 10x9 | 5 | 2 | 10/13.4/17 | 15.8 | 5.4 | 3.4 | 2.2 | 49.0 | 5 | oui |
| 33 | western_gallery | procedural | branching+mixed+dense | 6x4 | 10x11 | 5 | 0 | 11/16.0/21 | 18.4 | 5.2 | 4.2 | 1.8 | 51.8 | 5 | oui |
| 34 | western_depths | procedural | looping+lattice+mixed | 4x5 | 14x9 | 5 | 0 | 9/12.2/20 | 19.0 | 6.2 | 3.0 | 3.6 | 37.4 | 5 | oui |
| 35 | western_depths | procedural | looping+lattice+mixed | 4x3 | 11x10 | 5 | 0 | 8/9.2/11 | 13.2 | 4.4 | 3.0 | 2.2 | 40.8 | 5 | oui |
| 36 | western_depths | procedural | looping+lattice+mixed | 6x3 | 10x9 | 5 | 1 | 8/13.4/24 | 16.6 | 5.2 | 3.4 | 2.4 | 39.6 | 5 | oui |
| 37 | western_depths | procedural | looping+lattice+mixed | 4x4 | 10x10 | 5 | 1 | 5/12.6/18 | 15.4 | 4.2 | 2.4 | 2.0 | 43.4 | 5 | oui |
| 38 | western_depths | procedural | looping+lattice+mixed | 5x3 | 11x9 | 5 | 2 | 7/12.0/17 | 14.0 | 4.4 | 2.2 | 2.2 | 37.6 | 5 | oui |
| 39 | western_depths | procedural | looping+lattice+mixed | 5x4 | 9x8 | 5 | 0 | 7/11.2/18 | 16.4 | 5.2 | 2.8 | 2.8 | 39.8 | 5 | oui |
| 40 | western_depths | procedural | looping+lattice+mixed | 5x3 | 10x10 | 5 | 0 | 9/11.6/15 | 18.8 | 5.8 | 3.0 | 3.6 | 35.6 | 5 | oui |
| 41 | western_depths | procedural | looping+lattice+mixed | 5x3 | 9x9 | 5 | 0 | 8/11.8/16 | 18.4 | 5.4 | 2.4 | 3.4 | 53.4 | 5 | oui |
| 42 | western_depths | procedural | looping+lattice+mixed | 7x4 | 9x9 | 5 | 0 | 8/11.4/18 | 15.2 | 5.0 | 2.4 | 2.6 | 36.4 | 5 | oui |
| 43 | western_depths | procedural | looping+lattice+mixed | 5x5 | 12x8 | 5 | 0 | 7/13.8/25 | 19.2 | 5.8 | 3.0 | 3.0 | 37.8 | 5 | oui |
| 44 | western_depths | procedural | looping+lattice+mixed | 4x4 | 9x10 | 5 | 2 | 7/13.0/16 | 17.8 | 5.6 | 3.4 | 2.6 | 41.6 | 5 | oui |
| 45 | western_depths | procedural | looping+lattice+mixed | 5x3 | 11x10 | 5 | 1 | 11/13.6/21 | 18.4 | 5.2 | 2.8 | 2.6 | 53.0 | 5 | oui |
| 46 | western_depths | procedural | looping+lattice+mixed | 6x3 | 11x8 | 5 | 0 | 10/11.0/14 | 19.2 | 6.2 | 2.0 | 4.2 | 44.8 | 5 | oui |
| 47 | western_depths | procedural | looping+lattice+mixed | 6x3 | 10x9 | 5 | 1 | 8/10.2/16 | 17.2 | 6.0 | 2.8 | 3.4 | 42.2 | 5 | oui |
| 48 | western_depths | procedural | looping+lattice+mixed | 5x3 | 11x9 | 5 | 3 | 8/10.2/12 | 15.2 | 5.2 | 2.6 | 2.8 | 39.0 | 5 | oui |
| 49 | western_depths | procedural | looping+lattice+mixed | 4x4 | 11x10 | 5 | 2 | 8/9.8/13 | 15.4 | 5.0 | 2.0 | 3.2 | 34.4 | 5 | oui |
| 50 | western_depths | procedural | looping+lattice+mixed | 4x3 | 9x10 | 5 | 1 | 8/9.2/12 | 14.6 | 5.2 | 3.0 | 2.6 | 43.0 | 5 | oui |
| 51 | western_depths | procedural | looping+lattice+mixed | 5x3 | 10x10 | 5 | 1 | 8/10.4/13 | 16.4 | 5.4 | 3.2 | 3.2 | 34.6 | 5 | oui |
| 52 | western_depths | procedural | looping+lattice+mixed | 4x4 | 10x8 | 5 | 1 | 7/11.6/21 | 16.8 | 4.8 | 1.8 | 3.2 | 42.8 | 5 | oui |
| 53 | western_depths | procedural | looping+lattice+mixed | 6x3 | 14x10 | 5 | 2 | 5/8.4/10 | 11.8 | 3.4 | 3.4 | 1.4 | 36.6 | 5 | oui |
| 54 | western_depths | procedural | looping+lattice+mixed | 5x3 | 9x8 | 5 | 0 | 7/11.6/20 | 20.0 | 6.8 | 3.4 | 4.2 | 48.6 | 5 | oui |
| 55 | western_depths | procedural | looping+lattice+mixed | 4x4 | 10x10 | 5 | 0 | 5/10.2/16 | 14.6 | 4.4 | 2.6 | 2.6 | 40.4 | 5 | oui |
| 56 | western_depths | procedural | looping+lattice+mixed | 5x4 | 12x8 | 5 | 2 | 9/12.0/14 | 20.2 | 7.4 | 3.4 | 4.2 | 48.0 | 5 | oui |
| 57 | western_depths | procedural | looping+lattice+mixed | 7x5 | 11x8 | 5 | 1 | 5/13.4/24 | 17.2 | 5.2 | 2.4 | 2.8 | 48.4 | 5 | oui |
| 58 | western_depths | procedural | looping+lattice+mixed | 6x5 | 12x10 | 5 | 0 | 6/9.2/12 | 14.4 | 4.2 | 2.6 | 2.4 | 37.0 | 5 | oui |
| 59 | western_depths | procedural | looping+lattice+mixed | 7x3 | 11x7 | 5 | 0 | 8/11.8/17 | 18.0 | 5.6 | 2.8 | 3.2 | 38.6 | 5 | oui |
| 60 | western_depths | procedural | looping+lattice+mixed | 7x3 | 14x11 | 5 | 0 | 5/12.4/18 | 17.2 | 5.4 | 3.4 | 2.4 | 46.6 | 5 | oui |
| 61 | western_depths | procedural | looping+lattice+mixed | 4x3 | 9x10 | 5 | 0 | 8/11.2/17 | 17.0 | 5.8 | 2.8 | 3.2 | 37.2 | 5 | oui |
| 62 | western_depths | procedural | looping+lattice+mixed | 5x3 | 10x9 | 5 | 0 | 9/9.4/10 | 14.8 | 4.8 | 2.0 | 3.0 | 47.2 | 5 | oui |
| 63 | western_depths | procedural | looping+lattice+mixed | 6x5 | 12x9 | 5 | 1 | 5/10.2/14 | 13.2 | 3.8 | 2.0 | 2.2 | 42.0 | 5 | oui |
| 64 | western_depths | procedural | looping+lattice+mixed | 5x5 | 8x9 | 5 | 1 | 8/12.6/21 | 15.4 | 4.0 | 3.2 | 1.8 | 38.6 | 5 | oui |
| 65 | western_depths | procedural | looping+lattice+mixed | 4x5 | 11x10 | 5 | 0 | 5/7.8/9 | 11.8 | 3.8 | 2.2 | 2.2 | 35.2 | 5 | oui |
| 66 | western_depths | procedural | looping+lattice+mixed | 7x3 | 9x12 | 5 | 0 | 7/13.2/19 | 18.0 | 6.0 | 3.6 | 3.0 | 48.6 | 5 | oui |
| 67 | western_abyss | procedural | large_rooms+mixed+looping | 4x4 | 9x8 | 5 | 1 | 9/18.4/30 | 20.4 | 5.2 | 4.2 | 2.2 | 55.2 | 5 | oui |
| 68 | western_abyss | procedural | large_rooms+mixed+looping | 3x2 | 16x11 | 5 | 1 | 6/11.2/16 | 13.2 | 4.0 | 2.4 | 2.0 | 34.8 | 5 | oui |
| 69 | western_abyss | procedural | large_rooms+mixed+looping | 7x3 | 14x9 | 5 | 0 | 4/8.6/13 | 9.2 | 2.2 | 2.2 | 1.0 | 38.2 | 5 | oui |
| 70 | western_abyss | procedural | large_rooms+mixed+looping | 4x5 | 12x12 | 5 | 0 | 4/8.6/13 | 9.4 | 2.4 | 2.0 | 1.2 | 39.8 | 5 | oui |
| 71 | western_abyss | procedural | large_rooms+mixed+looping | 3x2 | 14x12 | 5 | 0 | 6/12.0/20 | 14.0 | 3.6 | 1.4 | 2.4 | 42.8 | 5 | oui |
| 72 | western_abyss | procedural | large_rooms+mixed+looping | 4x2 | 14x10 | 5 | 0 | 8/11.2/15 | 13.0 | 3.2 | 1.8 | 1.8 | 40.4 | 5 | oui |
| 73 | western_abyss | procedural | large_rooms+mixed+looping | 4x3 | 14x11 | 5 | 0 | 8/12.4/17 | 13.4 | 3.6 | 3.0 | 1.4 | 37.8 | 5 | oui |
| 74 | western_abyss | procedural | large_rooms+mixed+looping | 6x5 | 14x9 | 5 | 1 | 5/9.2/17 | 11.6 | 3.2 | 1.2 | 2.0 | 41.2 | 5 | oui |
| 75 | western_abyss | procedural | large_rooms+mixed+looping | 4x4 | 10x9 | 5 | 0 | 7/12.0/20 | 13.2 | 3.2 | 2.4 | 1.4 | 48.2 | 5 | oui |
| 76 | western_abyss | procedural | large_rooms+mixed+looping | 7x5 | 8x9 | 5 | 0 | 5/10.0/18 | 12.0 | 3.0 | 1.6 | 1.8 | 42.6 | 5 | oui |
| 77 | western_abyss | procedural | large_rooms+mixed+looping | 3x2 | 14x13 | 5 | 0 | 4/10.8/16 | 12.2 | 3.8 | 2.4 | 1.8 | 44.0 | 5 | oui |
| 78 | western_abyss | procedural | large_rooms+mixed+looping | 4x5 | 12x9 | 5 | 0 | 6/10.8/16 | 11.2 | 2.4 | 2.4 | 1.0 | 56.2 | 5 | oui |
| 79 | western_abyss | procedural | large_rooms+mixed+looping | 3x2 | 15x11 | 5 | 0 | 6/10.8/17 | 12.2 | 3.2 | 2.8 | 1.4 | 46.4 | 5 | oui |
| 80 | western_abyss | procedural | large_rooms+mixed+looping | 5x4 | 9x10 | 5 | 1 | 5/9.6/17 | 9.6 | 2.6 | 3.0 | 0.8 | 41.6 | 5 | oui |
| 81 | western_abyss | procedural | large_rooms+mixed+looping | 4x4 | 11x8 | 5 | 0 | 6/10.4/15 | 12.8 | 3.4 | 1.4 | 2.2 | 44.2 | 5 | oui |
| 82 | western_abyss | procedural | large_rooms+mixed+looping | 3x3 | 13x13 | 5 | 1 | 5/8.8/13 | 10.2 | 2.2 | 1.6 | 1.4 | 39.4 | 5 | oui |
| 83 | western_abyss | procedural | large_rooms+mixed+looping | 3x3 | 12x12 | 5 | 0 | 5/10.2/22 | 11.2 | 2.8 | 3.0 | 1.0 | 41.0 | 5 | oui |
| 84 | western_abyss | procedural | large_rooms+mixed+looping | 4x4 | 8x12 | 5 | 0 | 6/11.0/22 | 13.0 | 3.2 | 3.0 | 1.4 | 39.8 | 5 | oui |
| 85 | western_abyss | procedural | large_rooms+mixed+looping | 6x4 | 10x8 | 5 | 0 | 7/12.8/25 | 14.0 | 3.6 | 2.0 | 1.8 | 47.6 | 5 | oui |
| 86 | western_abyss | procedural | large_rooms+mixed+looping | 4x3 | 10x8 | 5 | 0 | 6/9.4/14 | 10.4 | 2.2 | 1.8 | 1.4 | 34.2 | 5 | oui |
| 87 | western_abyss | procedural | large_rooms+mixed+looping | 5x5 | 9x9 | 5 | 0 | 6/11.6/19 | 13.4 | 3.4 | 1.4 | 2.2 | 34.4 | 5 | oui |
| 88 | western_abyss | procedural | large_rooms+mixed+looping | 6x4 | 10x8 | 5 | 0 | 8/11.4/15 | 13.6 | 4.2 | 1.8 | 2.4 | 45.8 | 5 | oui |
| 89 | western_abyss | procedural | large_rooms+mixed+looping | 4x4 | 11x10 | 5 | 0 | 4/10.4/18 | 11.4 | 2.2 | 2.4 | 1.2 | 35.8 | 5 | oui |
| 90 | western_abyss | procedural | large_rooms+mixed+looping | 4x4 | 10x9 | 5 | 0 | 6/11.4/18 | 12.8 | 3.2 | 3.0 | 1.2 | 40.8 | 5 | oui |
| 91 | western_abyss | procedural | large_rooms+mixed+looping | 6x3 | 10x12 | 5 | 1 | 6/9.4/13 | 10.8 | 2.8 | 1.8 | 1.6 | 40.0 | 5 | oui |
| 92 | western_abyss | procedural | large_rooms+mixed+looping | 6x5 | 12x11 | 5 | 1 | 6/9.0/13 | 9.6 | 2.2 | 1.8 | 1.2 | 40.4 | 5 | oui |
| 93 | western_abyss | procedural | large_rooms+mixed+looping | 3x3 | 12x10 | 5 | 1 | 7/11.0/15 | 13.8 | 3.8 | 1.0 | 2.4 | 39.4 | 5 | oui |
| 94 | western_abyss | procedural | large_rooms+mixed+looping | 3x3 | 12x11 | 5 | 0 | 6/11.6/23 | 14.2 | 4.0 | 1.0 | 2.6 | 37.4 | 5 | oui |
| 95 | western_abyss | procedural | large_rooms+mixed+looping | 7x5 | 11x9 | 5 | 0 | 5/10.0/16 | 12.4 | 3.4 | 1.2 | 2.4 | 37.4 | 5 | oui |
| 96 | western_abyss | procedural | large_rooms+mixed+looping | 4x4 | 11x10 | 5 | 0 | 4/10.8/21 | 12.6 | 3.6 | 2.2 | 1.8 | 41.0 | 5 | oui |
| 97 | western_abyss | procedural | large_rooms+mixed+looping | 5x3 | 10x12 | 5 | 0 | 4/13.2/24 | 16.4 | 4.8 | 2.6 | 2.4 | 37.4 | 5 | oui |
| 98 | western_abyss | procedural | large_rooms+mixed+looping | 4x2 | 13x11 | 5 | 0 | 4/9.8/17 | 11.4 | 3.2 | 2.6 | 1.4 | 38.6 | 5 | oui |
| 99 | western_abyss | procedural | large_rooms+mixed+looping | 3x2 | 12x13 | 5 | 0 | 6/11.0/21 | 11.6 | 2.4 | 2.6 | 1.0 | 44.8 | 5 | oui |
