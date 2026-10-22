# Rapport de génération — Far-Off Sea

- **ID** : `far_off_sea`  
- **Chapitre** : 27 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Far-Off Sea (75F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/FaroffSea) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 27. Recoupé avec Bulbapedia (page « Far-Off Sea »).  
- **Étages** : 75 — direction `fond`  
- **Zone écrite** : `Data/Zone/far_off_sea.json`  
- **Seed d'auteur (debug)** : `4110731156707058207` (explicite : False)  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| far_shelf | 1-25 | far_shelf | `zero_isle_east_4_floor` | looping, ring, mixed | 10 | oui | oui | — |
| far_deep | 26-50 | far_deep | `zero_isle_east_4_floor` | ring, lattice, looping | 14 | oui | oui | — |
| far_abyss | 51-75 | far_abyss | `zero_isle_east_4_floor` | large_rooms, looping, mixed | 12 | oui | oui | — |

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
| 1 | far_shelf | procedural | looping+ring+mixed | 5x4 | 12x9 | 5 | 0 | 5/10.0/20 | 15.0 | 3.6 | 1.4 | 2.6 | 36.0 | 5 | oui |
| 2 | far_shelf | procedural | looping+ring+mixed | 5x3 | 11x9 | 5 | 0 | 6/10.6/16 | 17.0 | 4.6 | 1.2 | 2.8 | 35.0 | 5 | oui |
| 3 | far_shelf | procedural | looping+ring+mixed | 4x4 | 11x8 | 5 | 0 | 8/11.0/18 | 16.0 | 4.4 | 1.4 | 2.6 | 46.0 | 5 | oui |
| 4 | far_shelf | procedural | looping+ring+mixed | 4x4 | 9x9 | 5 | 0 | 7/10.2/16 | 15.6 | 4.2 | 1.4 | 2.4 | 43.2 | 5 | oui |
| 5 | far_shelf | procedural | looping+ring+mixed | 4x4 | 12x9 | 5 | 0 | 6/10.2/16 | 16.0 | 4.0 | 1.2 | 2.4 | 38.0 | 5 | oui |
| 6 | far_shelf | procedural | looping+ring+mixed | 7x5 | 11x7 | 5 | 0 | 7/13.4/24 | 18.8 | 4.6 | 2.0 | 2.4 | 51.8 | 5 | oui |
| 7 | far_shelf | procedural | looping+ring+mixed | 4x4 | 11x9 | 5 | 1 | 8/10.8/16 | 15.4 | 4.2 | 1.6 | 2.4 | 34.4 | 5 | oui |
| 8 | far_shelf | procedural | looping+ring+mixed | 7x3 | 8x8 | 5 | 1 | 7/9.0/12 | 14.2 | 3.4 | 1.0 | 2.2 | 48.6 | 5 | oui |
| 9 | far_shelf | procedural | looping+ring+mixed | 4x4 | 11x10 | 5 | 0 | 5/9.0/13 | 14.2 | 3.0 | 0.6 | 2.2 | 43.2 | 5 | oui |
| 10 | far_shelf | procedural | looping+ring+mixed | 5x4 | 12x9 | 5 | 1 | 8/12.4/18 | 15.0 | 2.8 | 2.0 | 1.6 | 42.2 | 5 | oui |
| 11 | far_shelf | procedural | looping+ring+mixed | 4x3 | 9x10 | 5 | 0 | 7/11.0/16 | 17.0 | 4.4 | 0.8 | 2.8 | 26.8 | 5 | oui |
| 12 | far_shelf | procedural | looping+ring+mixed | 4x4 | 12x10 | 5 | 0 | 7/10.2/13 | 14.8 | 3.4 | 1.0 | 2.2 | 36.0 | 5 | oui |
| 13 | far_shelf | procedural | looping+ring+mixed | 5x3 | 12x10 | 5 | 0 | 7/9.6/14 | 15.2 | 3.8 | 1.4 | 2.2 | 50.4 | 5 | oui |
| 14 | far_shelf | procedural | looping+ring+mixed | 4x3 | 10x10 | 5 | 1 | 6/9.8/14 | 15.2 | 3.8 | 0.6 | 2.6 | 39.2 | 5 | oui |
| 15 | far_shelf | procedural | looping+ring+mixed | 7x4 | 10x12 | 5 | 0 | 6/10.8/18 | 15.4 | 4.0 | 1.8 | 2.2 | 44.0 | 5 | oui |
| 16 | far_shelf | procedural | looping+ring+mixed | 7x5 | 9x12 | 5 | 0 | 7/11.0/18 | 15.8 | 3.8 | 2.4 | 2.0 | 30.8 | 5 | oui |
| 17 | far_shelf | procedural | looping+ring+mixed | 5x3 | 9x9 | 5 | 1 | 8/13.0/19 | 17.2 | 4.6 | 2.4 | 2.2 | 32.4 | 5 | oui |
| 18 | far_shelf | procedural | looping+ring+mixed | 4x3 | 11x10 | 5 | 0 | 8/11.6/14 | 17.2 | 3.8 | 1.0 | 2.6 | 44.0 | 5 | oui |
| 19 | far_shelf | procedural | looping+ring+mixed | 6x4 | 13x10 | 5 | 0 | 6/10.0/20 | 15.4 | 3.6 | 0.6 | 2.8 | 34.8 | 5 | oui |
| 20 | far_shelf | procedural | looping+ring+mixed | 5x4 | 10x10 | 5 | 1 | 6/10.2/16 | 14.6 | 2.8 | 1.0 | 2.0 | 34.2 | 5 | oui |
| 21 | far_shelf | procedural | looping+ring+mixed | 5x3 | 10x8 | 5 | 1 | 7/10.4/20 | 13.4 | 3.6 | 2.6 | 1.8 | 32.6 | 5 | oui |
| 22 | far_shelf | procedural | looping+ring+mixed | 5x4 | 11x8 | 5 | 0 | 7/9.6/12 | 13.6 | 2.8 | 1.4 | 1.8 | 37.0 | 5 | oui |
| 23 | far_shelf | procedural | looping+ring+mixed | 5x4 | 9x9 | 5 | 0 | 6/9.8/16 | 15.0 | 4.2 | 1.4 | 2.4 | 33.4 | 5 | oui |
| 24 | far_shelf | procedural | looping+ring+mixed | 5x4 | 12x9 | 5 | 0 | 6/11.4/21 | 16.8 | 3.8 | 1.2 | 2.4 | 49.6 | 5 | oui |
| 25 | far_shelf | procedural | looping+ring+mixed | 4x4 | 14x7 | 5 | 0 | 5/10.8/18 | 15.8 | 4.2 | 1.2 | 2.6 | 35.2 | 5 | oui |
| 26 | far_deep | procedural | ring+lattice+looping | 4x3 | 10x10 | 5 | 1 | 6/7.8/9 | 13.6 | 3.6 | 1.0 | 2.6 | 40.8 | 5 | oui |
| 27 | far_deep | procedural | ring+lattice+looping | 5x4 | 9x10 | 5 | 3 | 6/8.6/11 | 15.0 | 4.0 | 2.6 | 2.2 | 48.2 | 5 | oui |
| 28 | far_deep | procedural | ring+lattice+looping | 4x4 | 11x10 | 5 | 0 | 5/7.6/12 | 11.8 | 2.2 | 1.6 | 1.4 | 35.6 | 5 | oui |
| 29 | far_deep | procedural | ring+lattice+looping | 5x4 | 9x9 | 5 | 2 | 6/9.2/12 | 16.4 | 5.4 | 2.0 | 3.4 | 29.4 | 5 | oui |
| 30 | far_deep | procedural | ring+lattice+looping | 4x3 | 10x8 | 5 | 0 | 9/9.4/11 | 18.6 | 5.2 | 2.4 | 3.2 | 46.4 | 5 | oui |
| 31 | far_deep | procedural | ring+lattice+looping | 4x5 | 11x9 | 5 | 0 | 7/10.2/15 | 18.6 | 5.0 | 2.2 | 3.4 | 42.4 | 5 | oui |
| 32 | far_deep | procedural | ring+lattice+looping | 5x4 | 12x8 | 5 | 1 | 8/9.6/10 | 17.8 | 5.6 | 1.6 | 3.6 | 51.2 | 5 | oui |
| 33 | far_deep | procedural | ring+lattice+looping | 6x4 | 10x10 | 5 | 0 | 7/8.2/9 | 15.4 | 4.2 | 2.0 | 3.0 | 39.4 | 5 | oui |
| 34 | far_deep | procedural | ring+lattice+looping | 4x4 | 11x10 | 5 | 1 | 9/9.8/11 | 17.6 | 5.2 | 3.0 | 3.2 | 35.8 | 5 | oui |
| 35 | far_deep | procedural | ring+lattice+looping | 5x3 | 10x9 | 5 | 0 | 5/8.2/11 | 14.2 | 3.2 | 2.6 | 1.6 | 40.2 | 5 | oui |
| 36 | far_deep | procedural | ring+lattice+looping | 6x3 | 10x8 | 5 | 0 | 6/9.0/13 | 17.6 | 5.2 | 2.0 | 3.2 | 39.2 | 5 | oui |
| 37 | far_deep | procedural | ring+lattice+looping | 4x4 | 9x10 | 5 | 0 | 5/8.8/14 | 15.2 | 3.4 | 2.8 | 2.0 | 38.0 | 5 | oui |
| 38 | far_deep | procedural | ring+lattice+looping | 5x4 | 10x9 | 5 | 1 | 7/9.8/12 | 17.6 | 4.2 | 1.2 | 2.8 | 42.4 | 5 | oui |
| 39 | far_deep | procedural | ring+lattice+looping | 4x4 | 11x9 | 5 | 0 | 5/8.0/13 | 12.4 | 2.4 | 1.4 | 1.6 | 42.0 | 5 | oui |
| 40 | far_deep | procedural | ring+lattice+looping | 4x4 | 12x9 | 5 | 0 | 8/10.8/16 | 18.6 | 5.0 | 2.8 | 2.8 | 39.4 | 5 | oui |
| 41 | far_deep | procedural | ring+lattice+looping | 4x4 | 10x9 | 5 | 1 | 8/8.8/10 | 19.0 | 5.8 | 1.6 | 4.0 | 34.6 | 5 | oui |
| 42 | far_deep | procedural | ring+lattice+looping | 5x3 | 12x9 | 5 | 5 | 8/8.8/10 | 14.0 | 3.6 | 2.6 | 1.8 | 30.0 | 5 | oui |
| 43 | far_deep | procedural | ring+lattice+looping | 4x4 | 11x10 | 5 | 0 | 8/9.0/11 | 15.0 | 4.2 | 2.6 | 2.2 | 39.6 | 5 | oui |
| 44 | far_deep | procedural | ring+lattice+looping | 5x4 | 9x10 | 5 | 0 | 5/7.8/11 | 12.6 | 2.4 | 2.2 | 1.2 | 35.4 | 5 | oui |
| 45 | far_deep | procedural | ring+lattice+looping | 5x4 | 10x9 | 5 | 1 | 4/8.8/14 | 13.8 | 3.6 | 1.2 | 2.2 | 42.0 | 5 | oui |
| 46 | far_deep | procedural | ring+lattice+looping | 5x3 | 12x8 | 5 | 0 | 7/9.6/15 | 17.4 | 5.4 | 3.0 | 3.2 | 43.0 | 5 | oui |
| 47 | far_deep | procedural | ring+lattice+looping | 6x3 | 9x9 | 5 | 3 | 7/10.8/13 | 18.2 | 5.0 | 1.8 | 3.4 | 43.2 | 5 | oui |
| 48 | far_deep | procedural | ring+lattice+looping | 5x3 | 9x8 | 5 | 0 | 7/8.2/13 | 17.4 | 5.4 | 1.4 | 3.8 | 42.4 | 5 | oui |
| 49 | far_deep | procedural | ring+lattice+looping | 5x5 | 10x10 | 5 | 1 | 8/10.6/16 | 17.0 | 3.6 | 1.0 | 2.6 | 43.4 | 5 | oui |
| 50 | far_deep | procedural | ring+lattice+looping | 5x4 | 9x9 | 5 | 0 | 5/9.2/14 | 16.8 | 4.6 | 1.6 | 3.2 | 46.4 | 5 | oui |
| 51 | far_abyss | procedural | large_rooms+looping+mixed | 4x3 | 13x10 | 5 | 0 | 6/9.2/11 | 11.0 | 2.6 | 1.4 | 1.6 | 31.4 | 5 | oui |
| 52 | far_abyss | procedural | large_rooms+looping+mixed | 6x4 | 8x12 | 5 | 0 | 7/10.4/15 | 12.2 | 2.8 | 1.6 | 1.8 | 33.8 | 5 | oui |
| 53 | far_abyss | procedural | large_rooms+looping+mixed | 3x3 | 15x13 | 5 | 0 | 6/13.6/28 | 15.6 | 3.6 | 3.4 | 1.4 | 34.0 | 5 | oui |
| 54 | far_abyss | procedural | large_rooms+looping+mixed | 4x3 | 13x7 | 5 | 0 | 6/8.4/12 | 9.4 | 2.6 | 2.2 | 1.2 | 39.6 | 5 | oui |
| 55 | far_abyss | procedural | large_rooms+looping+mixed | 4x3 | 16x11 | 5 | 0 | 5/7.8/12 | 9.8 | 2.8 | 1.0 | 2.0 | 31.6 | 5 | oui |
| 56 | far_abyss | procedural | large_rooms+looping+mixed | 4x2 | 16x12 | 5 | 0 | 5/13.2/24 | 15.2 | 4.2 | 2.4 | 2.0 | 42.0 | 5 | oui |
| 57 | far_abyss | procedural | large_rooms+looping+mixed | 4x3 | 16x10 | 5 | 0 | 5/10.0/20 | 11.4 | 2.2 | 1.4 | 1.4 | 44.2 | 5 | oui |
| 58 | far_abyss | procedural | large_rooms+looping+mixed | 4x4 | 9x8 | 5 | 0 | 6/11.4/16 | 13.6 | 3.0 | 1.6 | 1.8 | 34.4 | 5 | oui |
| 59 | far_abyss | procedural | large_rooms+looping+mixed | 5x3 | 10x11 | 5 | 0 | 4/8.8/12 | 10.6 | 2.6 | 1.6 | 1.6 | 43.4 | 5 | oui |
| 60 | far_abyss | procedural | large_rooms+looping+mixed | 4x2 | 16x12 | 5 | 2 | 8/9.6/11 | 11.6 | 3.0 | 0.8 | 2.2 | 35.0 | 5 | oui |
| 61 | far_abyss | procedural | large_rooms+looping+mixed | 4x3 | 13x11 | 5 | 0 | 6/10.6/16 | 12.0 | 3.0 | 1.4 | 1.8 | 44.4 | 5 | oui |
| 62 | far_abyss | procedural | large_rooms+looping+mixed | 3x3 | 16x12 | 5 | 0 | 7/11.0/17 | 13.8 | 4.0 | 1.8 | 2.2 | 37.4 | 5 | oui |
| 63 | far_abyss | procedural | large_rooms+looping+mixed | 3x2 | 16x12 | 5 | 0 | 4/8.6/11 | 10.2 | 2.6 | 1.6 | 1.6 | 33.0 | 5 | oui |
| 64 | far_abyss | procedural | large_rooms+looping+mixed | 3x2 | 12x12 | 5 | 0 | 4/7.6/12 | 8.4 | 1.8 | 1.4 | 1.2 | 35.0 | 5 | oui |
| 65 | far_abyss | procedural | large_rooms+looping+mixed | 4x4 | 12x10 | 5 | 0 | 6/9.6/20 | 10.4 | 3.0 | 3.0 | 1.0 | 44.4 | 5 | oui |
| 66 | far_abyss | procedural | large_rooms+looping+mixed | 3x2 | 16x12 | 5 | 0 | 7/9.6/12 | 11.6 | 2.6 | 2.0 | 1.4 | 34.2 | 5 | oui |
| 67 | far_abyss | procedural | large_rooms+looping+mixed | 4x3 | 10x10 | 5 | 0 | 4/9.4/15 | 11.0 | 2.6 | 1.8 | 1.6 | 45.4 | 5 | oui |
| 68 | far_abyss | procedural | large_rooms+looping+mixed | 6x4 | 10x7 | 5 | 0 | 8/11.2/20 | 13.2 | 3.4 | 2.0 | 1.8 | 41.4 | 5 | oui |
| 69 | far_abyss | procedural | large_rooms+looping+mixed | 4x2 | 12x10 | 5 | 1 | 5/9.8/14 | 12.0 | 3.6 | 1.8 | 2.0 | 40.0 | 5 | oui |
| 70 | far_abyss | procedural | large_rooms+looping+mixed | 6x4 | 14x9 | 5 | 1 | 6/11.0/22 | 12.4 | 3.0 | 2.4 | 1.6 | 33.0 | 5 | oui |
| 71 | far_abyss | procedural | large_rooms+looping+mixed | 4x3 | 15x12 | 5 | 0 | 6/9.4/13 | 11.0 | 2.0 | 1.4 | 1.4 | 32.0 | 5 | oui |
| 72 | far_abyss | procedural | large_rooms+looping+mixed | 4x5 | 12x12 | 5 | 0 | 5/9.0/14 | 10.2 | 2.4 | 1.6 | 1.4 | 45.6 | 5 | oui |
| 73 | far_abyss | procedural | large_rooms+looping+mixed | 7x4 | 8x10 | 5 | 0 | 5/9.8/15 | 12.6 | 3.6 | 1.4 | 2.2 | 37.0 | 5 | oui |
| 74 | far_abyss | procedural | large_rooms+looping+mixed | 3x2 | 15x12 | 5 | 0 | 6/10.8/18 | 12.6 | 2.6 | 1.8 | 1.4 | 37.4 | 5 | oui |
| 75 | far_abyss | procedural | large_rooms+looping+mixed | 5x4 | 13x11 | 5 | 0 | 4/8.0/12 | 9.0 | 2.4 | 1.6 | 1.4 | 30.2 | 5 | oui |
