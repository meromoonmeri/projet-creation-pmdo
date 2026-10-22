# Rapport de génération — Southern Cavern

- **ID** : `southern_cavern`  
- **Chapitre** : 17 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Southern Cavern (50F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/SouthernCavern) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 17. Recoupé avec Bulbapedia (page « Southern Cavern »).  
- **Étages** : 50 — direction `fond`  
- **Zone écrite** : `Data/Zone/southern_cavern.json`  
- **Seed d'auteur (debug)** : `3792442964809267015` (explicite : False)  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| south_gallery | 1-17 | south_gallery | `crystal_cave_1_floor` | branching, mixed, dense | 10 | oui | oui | — |
| south_depths | 18-33 | south_depths | `crystal_cave_1_floor` | looping, lattice, mixed | 13 | oui | oui | — |
| south_abyss | 34-50 | south_abyss | `crystal_cave_1_floor` | large_rooms, mixed, looping | 8 | oui | oui | — |

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
| 1 | south_gallery | procedural | branching+mixed+dense | 4x3 | 10x10 | 5 | 1 | 8/11.8/17 | 12.4 | 2.8 | 3.8 | 1.0 | 35.2 | 5 | oui |
| 2 | south_gallery | procedural | branching+mixed+dense | 4x3 | 12x8 | 5 | 0 | 7/12.2/21 | 13.6 | 4.2 | 3.4 | 1.6 | 31.4 | 5 | oui |
| 3 | south_gallery | procedural | branching+mixed+dense | 5x3 | 10x9 | 5 | 4 | 8/12.4/17 | 13.4 | 4.0 | 4.4 | 1.2 | 37.8 | 5 | oui |
| 4 | south_gallery | procedural | branching+mixed+dense | 6x3 | 12x8 | 5 | 0 | 8/12.2/16 | 14.4 | 4.2 | 3.8 | 1.4 | 32.8 | 5 | oui |
| 5 | south_gallery | procedural | branching+mixed+dense | 7x5 | 7x7 | 5 | 1 | 9/14.2/21 | 16.8 | 5.4 | 4.8 | 1.6 | 42.2 | 5 | oui |
| 6 | south_gallery | procedural | branching+mixed+dense | 4x3 | 11x10 | 5 | 0 | 9/15.6/23 | 20.0 | 6.2 | 3.6 | 2.6 | 52.4 | 5 | oui |
| 7 | south_gallery | procedural | branching+mixed+dense | 5x3 | 10x10 | 5 | 0 | 10/13.0/17 | 14.4 | 4.6 | 4.2 | 1.4 | 35.6 | 5 | oui |
| 8 | south_gallery | procedural | branching+mixed+dense | 7x5 | 9x8 | 5 | 0 | 10/14.8/20 | 17.0 | 4.4 | 3.4 | 2.0 | 39.8 | 5 | oui |
| 9 | south_gallery | procedural | branching+mixed+dense | 6x4 | 7x8 | 5 | 1 | 8/13.2/19 | 14.0 | 3.8 | 4.2 | 1.2 | 41.0 | 5 | oui |
| 10 | south_gallery | procedural | branching+mixed+dense | 8x4 | 8x7 | 5 | 0 | 8/17.2/23 | 21.4 | 6.6 | 4.2 | 2.8 | 32.6 | 5 | oui |
| 11 | south_gallery | procedural | branching+mixed+dense | 6x4 | 9x8 | 5 | 0 | 7/13.6/22 | 15.8 | 4.6 | 4.0 | 1.6 | 34.0 | 5 | oui |
| 12 | south_gallery | procedural | branching+mixed+dense | 6x4 | 11x10 | 5 | 1 | 8/16.4/29 | 18.4 | 5.4 | 5.2 | 1.6 | 37.0 | 5 | oui |
| 13 | south_gallery | procedural | branching+mixed+dense | 7x4 | 12x10 | 5 | 1 | 8/11.8/18 | 13.4 | 3.8 | 3.0 | 1.6 | 41.8 | 5 | oui |
| 14 | south_gallery | procedural | branching+mixed+dense | 5x4 | 11x9 | 5 | 1 | 6/9.8/15 | 10.6 | 2.8 | 2.6 | 1.2 | 38.6 | 5 | oui |
| 15 | south_gallery | procedural | branching+mixed+dense | 6x4 | 12x9 | 5 | 2 | 9/15.2/23 | 17.2 | 5.2 | 5.0 | 1.4 | 49.6 | 5 | oui |
| 16 | south_gallery | procedural | branching+mixed+dense | 8x4 | 9x8 | 5 | 1 | 6/11.8/17 | 12.6 | 3.2 | 3.0 | 1.2 | 36.6 | 5 | oui |
| 17 | south_gallery | procedural | branching+mixed+dense | 6x3 | 10x9 | 5 | 0 | 10/16.0/24 | 18.6 | 5.4 | 4.0 | 1.8 | 45.0 | 5 | oui |
| 18 | south_depths | procedural | looping+lattice+mixed | 4x5 | 10x12 | 5 | 0 | 8/11.2/15 | 18.0 | 6.0 | 3.4 | 3.4 | 32.8 | 5 | oui |
| 19 | south_depths | procedural | looping+lattice+mixed | 7x5 | 10x9 | 5 | 2 | 9/11.6/15 | 14.6 | 5.0 | 2.6 | 2.2 | 38.6 | 5 | oui |
| 20 | south_depths | procedural | looping+lattice+mixed | 4x4 | 10x8 | 5 | 0 | 9/10.6/12 | 14.8 | 4.2 | 3.0 | 2.4 | 41.2 | 5 | oui |
| 21 | south_depths | procedural | looping+lattice+mixed | 5x3 | 10x9 | 5 | 1 | 8/10.4/13 | 14.0 | 4.4 | 1.8 | 2.6 | 35.4 | 5 | oui |
| 22 | south_depths | procedural | looping+lattice+mixed | 6x4 | 10x8 | 5 | 0 | 9/13.6/24 | 19.4 | 6.2 | 3.6 | 3.2 | 47.4 | 5 | oui |
| 23 | south_depths | procedural | looping+lattice+mixed | 5x5 | 12x10 | 5 | 0 | 8/9.4/12 | 13.8 | 4.2 | 1.6 | 2.6 | 35.4 | 5 | oui |
| 24 | south_depths | procedural | looping+lattice+mixed | 6x5 | 9x10 | 5 | 1 | 7/10.6/16 | 14.0 | 4.4 | 2.2 | 2.4 | 41.2 | 5 | oui |
| 25 | south_depths | procedural | looping+lattice+mixed | 5x4 | 10x11 | 5 | 1 | 7/10.4/16 | 15.4 | 4.8 | 3.0 | 2.8 | 35.8 | 5 | oui |
| 26 | south_depths | procedural | looping+lattice+mixed | 4x4 | 10x12 | 5 | 0 | 8/12.2/21 | 19.8 | 6.2 | 3.0 | 3.6 | 37.4 | 5 | oui |
| 27 | south_depths | procedural | looping+lattice+mixed | 4x4 | 9x8 | 5 | 0 | 8/11.4/14 | 18.2 | 5.8 | 2.2 | 3.6 | 38.0 | 5 | oui |
| 28 | south_depths | procedural | looping+lattice+mixed | 4x3 | 9x8 | 5 | 1 | 7/11.8/20 | 15.0 | 3.8 | 1.4 | 2.2 | 35.0 | 5 | oui |
| 29 | south_depths | procedural | looping+lattice+mixed | 4x4 | 8x8 | 5 | 1 | 7/11.6/14 | 16.6 | 5.6 | 2.8 | 3.0 | 42.6 | 5 | oui |
| 30 | south_depths | procedural | looping+lattice+mixed | 5x4 | 11x10 | 5 | 0 | 5/13.0/23 | 17.4 | 5.8 | 3.2 | 2.6 | 47.6 | 5 | oui |
| 31 | south_depths | procedural | looping+lattice+mixed | 6x5 | 11x12 | 5 | 0 | 8/11.4/18 | 18.0 | 6.6 | 2.4 | 3.8 | 33.8 | 5 | oui |
| 32 | south_depths | procedural | looping+lattice+mixed | 4x3 | 9x9 | 5 | 1 | 5/10.4/14 | 12.2 | 3.2 | 2.0 | 1.8 | 42.4 | 5 | oui |
| 33 | south_depths | procedural | looping+lattice+mixed | 5x5 | 11x10 | 5 | 0 | 4/9.4/12 | 12.2 | 2.6 | 1.8 | 1.6 | 37.4 | 5 | oui |
| 34 | south_abyss | procedural | large_rooms+mixed+looping | 4x3 | 8x8 | 5 | 0 | 5/12.2/19 | 14.0 | 3.6 | 2.8 | 1.6 | 36.2 | 5 | oui |
| 35 | south_abyss | procedural | large_rooms+mixed+looping | 4x2 | 12x13 | 5 | 0 | 7/11.0/19 | 13.6 | 3.8 | 1.4 | 2.6 | 44.4 | 5 | oui |
| 36 | south_abyss | procedural | large_rooms+mixed+looping | 6x4 | 9x10 | 5 | 0 | 6/10.6/15 | 11.2 | 2.6 | 2.4 | 1.4 | 38.8 | 5 | oui |
| 37 | south_abyss | procedural | large_rooms+mixed+looping | 4x3 | 10x9 | 5 | 0 | 7/10.8/15 | 12.6 | 3.8 | 2.4 | 1.8 | 45.4 | 5 | oui |
| 38 | south_abyss | procedural | large_rooms+mixed+looping | 3x2 | 15x11 | 5 | 0 | 4/12.8/24 | 14.8 | 4.2 | 2.4 | 2.2 | 35.6 | 5 | oui |
| 39 | south_abyss | procedural | large_rooms+mixed+looping | 3x2 | 16x11 | 5 | 0 | 5/8.8/16 | 9.8 | 2.2 | 2.2 | 1.2 | 40.2 | 5 | oui |
| 40 | south_abyss | procedural | large_rooms+mixed+looping | 5x4 | 12x12 | 5 | 1 | 6/8.8/13 | 11.2 | 2.8 | 1.6 | 2.0 | 26.6 | 5 | oui |
| 41 | south_abyss | procedural | large_rooms+mixed+looping | 3x3 | 13x12 | 5 | 0 | 4/9.4/19 | 9.6 | 2.0 | 2.6 | 0.8 | 32.4 | 5 | oui |
| 42 | south_abyss | procedural | large_rooms+mixed+looping | 5x4 | 10x10 | 5 | 0 | 5/10.0/16 | 10.6 | 3.2 | 2.4 | 1.6 | 41.0 | 5 | oui |
| 43 | south_abyss | procedural | large_rooms+mixed+looping | 4x2 | 14x12 | 5 | 0 | 5/12.8/25 | 14.0 | 3.6 | 3.2 | 1.4 | 36.8 | 5 | oui |
| 44 | south_abyss | procedural | large_rooms+mixed+looping | 4x3 | 12x10 | 5 | 0 | 6/9.6/12 | 11.0 | 2.4 | 2.0 | 1.4 | 41.2 | 5 | oui |
| 45 | south_abyss | procedural | large_rooms+mixed+looping | 3x3 | 13x12 | 5 | 0 | 5/10.4/16 | 12.2 | 3.0 | 1.8 | 1.8 | 51.4 | 5 | oui |
| 46 | south_abyss | procedural | large_rooms+mixed+looping | 4x3 | 10x9 | 5 | 0 | 4/10.2/17 | 12.2 | 4.0 | 2.6 | 2.0 | 39.6 | 5 | oui |
| 47 | south_abyss | procedural | large_rooms+mixed+looping | 4x5 | 14x8 | 5 | 0 | 5/11.0/19 | 13.8 | 3.2 | 1.6 | 2.0 | 32.6 | 5 | oui |
| 48 | south_abyss | procedural | large_rooms+mixed+looping | 5x3 | 11x8 | 5 | 2 | 6/8.6/10 | 10.6 | 3.0 | 1.2 | 2.0 | 38.8 | 5 | oui |
| 49 | south_abyss | procedural | large_rooms+mixed+looping | 5x5 | 8x7 | 5 | 0 | 6/13.6/17 | 15.4 | 3.8 | 2.4 | 2.0 | 38.6 | 5 | oui |
| 50 | south_abyss | procedural | large_rooms+mixed+looping | 3x3 | 14x10 | 5 | 2 | 5/9.4/16 | 10.4 | 2.8 | 2.2 | 1.4 | 39.2 | 5 | oui |
