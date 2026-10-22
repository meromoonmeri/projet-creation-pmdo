# Rapport de génération — Silver Trench

- **ID** : `silver_trench`  
- **Chapitre** : 13 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Silver Trench (99F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/SilverTrench) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 13. Recoupé avec Bulbapedia (page « Silver Trench »).  
- **Étages** : 99 — direction `fond`  
- **Zone écrite** : `Data/Zone/silver_trench.json`  
- **Seed d'auteur (debug)** : `3709926040247911092` (explicite : False)  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| silver_shelf | 1-33 | silver_shelf | `silver_trench_3_floor` | looping, ring, mixed | 23 | oui | oui | — |
| silver_deep | 34-66 | silver_deep | `silver_trench_3_floor` | ring, lattice, looping | 20 | oui | oui | — |
| silver_trench | 67-99 | silver_trench | `silver_trench_3_floor` | large_rooms, looping, mixed | 16 | oui | oui | — |

## Scènes fixes

- entrée : `—`
- midpoint : `—`
- Ground de fin : `fosse_argentee`
- boss : mode `canonical_ground` → Ground `fosse_argentee`, rsmap `—`
  - no fixed 'entrance' Ground declared
  - no fixed 'mid' Ground declared
  - final battle stays on the canonical end Ground 'fosse_argentee' (no separate arena created)

## Étages

| Ét. | Segment | Type | Profil | Grille | Cellule | Variantes OK | Rejets | Rooms (min/moy/max) | Halls | Branches | Culs-de-sac | Boucles | Dist. escaliers | Signatures | Traversable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | silver_shelf | procedural | looping+ring+mixed | 5x3 | 9x10 | 5 | 0 | 7/11.2/19 | 16.4 | 4.0 | 1.6 | 2.2 | 41.2 | 5 | oui |
| 2 | silver_shelf | procedural | looping+ring+mixed | 5x3 | 11x10 | 5 | 1 | 7/15.0/28 | 20.2 | 6.0 | 2.6 | 3.0 | 44.8 | 5 | oui |
| 3 | silver_shelf | procedural | looping+ring+mixed | 5x3 | 10x10 | 5 | 0 | 7/9.8/13 | 14.8 | 3.0 | 1.4 | 2.0 | 32.2 | 5 | oui |
| 4 | silver_shelf | procedural | looping+ring+mixed | 4x4 | 9x8 | 5 | 0 | 8/9.6/12 | 15.8 | 3.2 | 1.2 | 2.2 | 47.0 | 5 | oui |
| 5 | silver_shelf | procedural | looping+ring+mixed | 5x3 | 11x8 | 5 | 0 | 6/11.4/16 | 15.4 | 3.4 | 1.6 | 2.0 | 37.6 | 5 | oui |
| 6 | silver_shelf | procedural | looping+ring+mixed | 5x3 | 10x10 | 5 | 1 | 7/10.4/17 | 14.6 | 3.4 | 0.6 | 2.4 | 35.8 | 5 | oui |
| 7 | silver_shelf | procedural | looping+ring+mixed | 4x3 | 9x10 | 5 | 0 | 7/10.6/14 | 17.0 | 4.2 | 1.0 | 2.6 | 44.8 | 5 | oui |
| 8 | silver_shelf | procedural | looping+ring+mixed | 5x4 | 9x8 | 5 | 0 | 6/10.2/15 | 15.0 | 4.2 | 1.0 | 2.6 | 31.4 | 5 | oui |
| 9 | silver_shelf | procedural | looping+ring+mixed | 4x4 | 10x8 | 5 | 1 | 8/13.0/20 | 18.8 | 4.8 | 1.4 | 3.0 | 43.0 | 5 | oui |
| 10 | silver_shelf | procedural | looping+ring+mixed | 4x4 | 11x8 | 5 | 0 | 7/9.2/15 | 13.6 | 2.8 | 1.2 | 1.8 | 41.0 | 5 | oui |
| 11 | silver_shelf | procedural | looping+ring+mixed | 4x4 | 11x10 | 5 | 0 | 6/8.4/12 | 11.6 | 2.8 | 2.0 | 1.4 | 35.6 | 5 | oui |
| 12 | silver_shelf | procedural | looping+ring+mixed | 7x4 | 11x9 | 5 | 0 | 7/8.4/10 | 12.0 | 2.4 | 1.6 | 1.4 | 39.0 | 5 | oui |
| 13 | silver_shelf | procedural | looping+ring+mixed | 4x4 | 10x10 | 5 | 0 | 8/9.8/12 | 15.4 | 3.0 | 1.0 | 2.2 | 41.0 | 5 | oui |
| 14 | silver_shelf | procedural | looping+ring+mixed | 6x4 | 11x7 | 5 | 0 | 7/10.2/16 | 14.6 | 3.2 | 2.0 | 1.8 | 34.4 | 5 | oui |
| 15 | silver_shelf | procedural | looping+ring+mixed | 7x5 | 11x10 | 5 | 0 | 8/10.6/13 | 15.8 | 3.8 | 1.4 | 2.4 | 48.0 | 5 | oui |
| 16 | silver_shelf | procedural | looping+ring+mixed | 4x4 | 12x9 | 5 | 1 | 7/9.4/14 | 15.8 | 3.2 | 1.0 | 2.2 | 40.0 | 5 | oui |
| 17 | silver_shelf | procedural | looping+ring+mixed | 4x3 | 12x10 | 5 | 0 | 8/11.0/16 | 15.6 | 4.0 | 1.0 | 2.6 | 36.4 | 5 | oui |
| 18 | silver_shelf | procedural | looping+ring+mixed | 4x3 | 11x9 | 5 | 0 | 7/12.0/29 | 18.0 | 4.4 | 1.6 | 2.8 | 38.6 | 5 | oui |
| 19 | silver_shelf | procedural | looping+ring+mixed | 4x3 | 12x8 | 5 | 0 | 7/11.8/26 | 18.2 | 5.2 | 1.4 | 3.2 | 32.2 | 5 | oui |
| 20 | silver_shelf | procedural | looping+ring+mixed | 4x3 | 10x8 | 5 | 1 | 7/13.0/20 | 16.8 | 4.4 | 1.8 | 2.4 | 45.2 | 5 | oui |
| 21 | silver_shelf | procedural | looping+ring+mixed | 4x4 | 12x10 | 5 | 0 | 6/8.8/10 | 12.6 | 2.8 | 1.0 | 2.0 | 40.6 | 5 | oui |
| 22 | silver_shelf | procedural | looping+ring+mixed | 5x4 | 9x8 | 5 | 0 | 5/9.4/15 | 13.2 | 2.4 | 1.4 | 1.6 | 39.6 | 5 | oui |
| 23 | silver_shelf | procedural | looping+ring+mixed | 4x3 | 10x8 | 5 | 1 | 5/8.8/12 | 14.2 | 3.4 | 0.6 | 2.6 | 34.4 | 5 | oui |
| 24 | silver_shelf | procedural | looping+ring+mixed | 5x4 | 12x8 | 5 | 0 | 9/11.0/13 | 15.6 | 3.2 | 0.6 | 2.4 | 40.8 | 5 | oui |
| 25 | silver_shelf | procedural | looping+ring+mixed | 4x4 | 9x8 | 5 | 0 | 7/10.8/16 | 16.2 | 3.2 | 1.4 | 2.0 | 35.4 | 5 | oui |
| 26 | silver_shelf | procedural | looping+ring+mixed | 4x3 | 12x8 | 5 | 0 | 7/10.6/17 | 16.6 | 3.4 | 1.6 | 2.2 | 39.6 | 5 | oui |
| 27 | silver_shelf | procedural | looping+ring+mixed | 4x4 | 10x9 | 5 | 0 | 7/9.2/12 | 15.4 | 4.2 | 0.6 | 3.0 | 40.6 | 5 | oui |
| 28 | silver_shelf | procedural | looping+ring+mixed | 5x5 | 11x7 | 5 | 0 | 7/9.2/12 | 13.8 | 2.4 | 1.8 | 1.4 | 38.4 | 5 | oui |
| 29 | silver_shelf | procedural | looping+ring+mixed | 5x3 | 10x8 | 5 | 0 | 7/10.2/14 | 15.2 | 3.2 | 1.2 | 2.2 | 37.8 | 5 | oui |
| 30 | silver_shelf | procedural | looping+ring+mixed | 4x3 | 11x10 | 5 | 2 | 10/15.2/27 | 18.0 | 5.0 | 2.8 | 2.4 | 51.0 | 5 | oui |
| 31 | silver_shelf | procedural | looping+ring+mixed | 4x3 | 12x9 | 5 | 0 | 7/10.0/13 | 14.2 | 3.0 | 1.4 | 2.0 | 28.8 | 5 | oui |
| 32 | silver_shelf | procedural | looping+ring+mixed | 4x4 | 10x8 | 5 | 0 | 6/9.6/13 | 13.4 | 3.2 | 1.6 | 2.0 | 42.2 | 5 | oui |
| 33 | silver_shelf | procedural | looping+ring+mixed | 4x4 | 10x8 | 5 | 0 | 7/10.0/13 | 15.0 | 3.6 | 1.6 | 2.2 | 36.0 | 5 | oui |
| 34 | silver_deep | procedural | ring+lattice+looping | 4x4 | 9x8 | 5 | 0 | 5/8.2/12 | 12.8 | 2.8 | 2.0 | 1.8 | 40.0 | 5 | oui |
| 35 | silver_deep | procedural | ring+lattice+looping | 5x3 | 10x8 | 5 | 1 | 7/9.0/12 | 15.6 | 4.2 | 2.0 | 2.8 | 45.8 | 5 | oui |
| 36 | silver_deep | procedural | ring+lattice+looping | 5x4 | 9x10 | 5 | 0 | 8/9.8/13 | 16.2 | 3.8 | 1.2 | 2.6 | 53.6 | 5 | oui |
| 37 | silver_deep | procedural | ring+lattice+looping | 5x4 | 12x9 | 5 | 0 | 7/9.2/16 | 15.0 | 2.6 | 2.2 | 1.6 | 37.4 | 5 | oui |
| 38 | silver_deep | procedural | ring+lattice+looping | 5x3 | 11x10 | 5 | 1 | 5/7.4/10 | 11.2 | 2.6 | 1.2 | 1.8 | 39.2 | 5 | oui |
| 39 | silver_deep | procedural | ring+lattice+looping | 5x4 | 12x10 | 5 | 1 | 7/8.4/10 | 13.4 | 3.0 | 1.4 | 2.0 | 28.0 | 5 | oui |
| 40 | silver_deep | procedural | ring+lattice+looping | 4x3 | 12x9 | 5 | 0 | 7/9.2/12 | 15.8 | 4.0 | 1.8 | 2.6 | 47.8 | 5 | oui |
| 41 | silver_deep | procedural | ring+lattice+looping | 5x4 | 12x9 | 5 | 0 | 5/8.2/12 | 14.4 | 4.0 | 2.2 | 2.4 | 32.4 | 5 | oui |
| 42 | silver_deep | procedural | ring+lattice+looping | 4x4 | 11x9 | 5 | 0 | 5/7.2/9 | 12.8 | 3.2 | 2.4 | 1.6 | 44.4 | 5 | oui |
| 43 | silver_deep | procedural | ring+lattice+looping | 4x4 | 10x8 | 5 | 0 | 6/8.4/10 | 14.2 | 2.6 | 2.4 | 1.4 | 39.4 | 5 | oui |
| 44 | silver_deep | procedural | ring+lattice+looping | 6x5 | 9x9 | 5 | 0 | 6/8.0/13 | 12.4 | 2.4 | 1.6 | 1.8 | 40.6 | 5 | oui |
| 45 | silver_deep | procedural | ring+lattice+looping | 6x3 | 11x9 | 5 | 0 | 8/9.4/11 | 18.8 | 4.8 | 1.8 | 3.2 | 40.2 | 5 | oui |
| 46 | silver_deep | procedural | ring+lattice+looping | 6x5 | 10x10 | 5 | 0 | 5/8.6/12 | 16.4 | 4.6 | 1.6 | 3.2 | 45.6 | 5 | oui |
| 47 | silver_deep | procedural | ring+lattice+looping | 6x4 | 11x10 | 5 | 0 | 7/9.0/10 | 17.8 | 5.0 | 2.4 | 3.0 | 49.4 | 5 | oui |
| 48 | silver_deep | procedural | ring+lattice+looping | 6x3 | 11x8 | 5 | 0 | 4/9.0/15 | 14.6 | 4.2 | 1.8 | 2.4 | 41.0 | 5 | oui |
| 49 | silver_deep | procedural | ring+lattice+looping | 5x4 | 12x10 | 5 | 1 | 5/9.8/13 | 18.2 | 6.0 | 1.8 | 3.8 | 34.4 | 5 | oui |
| 50 | silver_deep | procedural | ring+lattice+looping | 5x3 | 10x10 | 5 | 0 | 7/9.4/12 | 18.2 | 5.2 | 1.8 | 3.6 | 49.0 | 5 | oui |
| 51 | silver_deep | procedural | ring+lattice+looping | 6x5 | 10x8 | 5 | 0 | 5/7.8/11 | 17.6 | 5.4 | 1.8 | 3.8 | 38.0 | 5 | oui |
| 52 | silver_deep | procedural | ring+lattice+looping | 5x3 | 12x8 | 5 | 1 | 6/9.8/13 | 19.8 | 6.0 | 3.2 | 4.0 | 44.8 | 5 | oui |
| 53 | silver_deep | procedural | ring+lattice+looping | 4x3 | 12x10 | 5 | 0 | 9/9.8/12 | 17.0 | 5.0 | 2.4 | 2.8 | 38.8 | 5 | oui |
| 54 | silver_deep | procedural | ring+lattice+looping | 4x4 | 11x10 | 5 | 0 | 6/9.0/12 | 18.0 | 4.8 | 2.8 | 2.8 | 46.6 | 5 | oui |
| 55 | silver_deep | procedural | ring+lattice+looping | 4x4 | 12x8 | 5 | 0 | 6/9.4/13 | 15.6 | 3.8 | 2.2 | 2.4 | 42.4 | 5 | oui |
| 56 | silver_deep | procedural | ring+lattice+looping | 5x4 | 9x10 | 5 | 1 | 5/7.4/9 | 12.4 | 2.6 | 1.0 | 1.8 | 32.8 | 5 | oui |
| 57 | silver_deep | procedural | ring+lattice+looping | 4x3 | 12x10 | 5 | 1 | 8/9.2/11 | 18.2 | 5.6 | 2.0 | 3.8 | 35.0 | 5 | oui |
| 58 | silver_deep | procedural | ring+lattice+looping | 5x3 | 12x8 | 5 | 1 | 8/10.2/14 | 17.2 | 5.8 | 4.2 | 2.8 | 37.0 | 5 | oui |
| 59 | silver_deep | procedural | ring+lattice+looping | 4x3 | 11x9 | 5 | 1 | 6/9.0/13 | 14.4 | 3.2 | 1.6 | 2.0 | 37.6 | 5 | oui |
| 60 | silver_deep | procedural | ring+lattice+looping | 4x3 | 11x9 | 5 | 1 | 9/11.2/12 | 23.6 | 8.0 | 3.4 | 5.4 | 46.2 | 5 | oui |
| 61 | silver_deep | procedural | ring+lattice+looping | 5x3 | 11x9 | 5 | 0 | 6/9.0/15 | 17.2 | 5.0 | 1.8 | 3.2 | 31.0 | 5 | oui |
| 62 | silver_deep | procedural | ring+lattice+looping | 5x3 | 11x9 | 5 | 0 | 6/8.8/11 | 17.4 | 6.2 | 1.8 | 4.0 | 32.4 | 5 | oui |
| 63 | silver_deep | procedural | ring+lattice+looping | 4x3 | 10x9 | 5 | 0 | 5/7.2/9 | 11.2 | 2.0 | 1.8 | 1.2 | 33.0 | 5 | oui |
| 64 | silver_deep | procedural | ring+lattice+looping | 4x4 | 12x9 | 5 | 1 | 7/9.2/13 | 14.0 | 3.0 | 1.8 | 1.8 | 42.6 | 5 | oui |
| 65 | silver_deep | procedural | ring+lattice+looping | 4x3 | 10x10 | 5 | 0 | 7/8.4/9 | 17.0 | 4.4 | 2.2 | 2.8 | 41.8 | 5 | oui |
| 66 | silver_deep | procedural | ring+lattice+looping | 5x3 | 11x8 | 5 | 1 | 6/9.0/15 | 14.0 | 3.4 | 1.2 | 2.2 | 29.4 | 5 | oui |
| 67 | silver_trench | procedural | large_rooms+looping+mixed | 3x3 | 14x12 | 5 | 0 | 4/9.4/15 | 11.8 | 3.0 | 1.6 | 1.8 | 35.8 | 5 | oui |
| 68 | silver_trench | procedural | large_rooms+looping+mixed | 3x3 | 12x10 | 5 | 0 | 4/9.8/15 | 12.2 | 3.2 | 1.6 | 2.0 | 37.2 | 5 | oui |
| 69 | silver_trench | procedural | large_rooms+looping+mixed | 4x3 | 12x13 | 5 | 0 | 5/10.0/13 | 11.2 | 2.6 | 2.0 | 1.4 | 45.4 | 5 | oui |
| 70 | silver_trench | procedural | large_rooms+looping+mixed | 3x2 | 16x11 | 5 | 0 | 9/11.2/16 | 12.8 | 4.2 | 2.2 | 2.0 | 34.4 | 5 | oui |
| 71 | silver_trench | procedural | large_rooms+looping+mixed | 6x3 | 12x10 | 5 | 1 | 5/7.8/11 | 8.2 | 1.6 | 1.4 | 1.2 | 33.8 | 5 | oui |
| 72 | silver_trench | procedural | large_rooms+looping+mixed | 4x3 | 14x12 | 5 | 0 | 5/8.0/10 | 9.2 | 2.2 | 1.6 | 1.4 | 35.2 | 5 | oui |
| 73 | silver_trench | procedural | large_rooms+looping+mixed | 4x4 | 12x10 | 5 | 0 | 4/9.0/16 | 10.8 | 3.0 | 2.0 | 1.6 | 42.2 | 5 | oui |
| 74 | silver_trench | procedural | large_rooms+looping+mixed | 4x3 | 11x10 | 5 | 0 | 4/11.2/22 | 12.6 | 3.0 | 1.4 | 1.8 | 29.4 | 5 | oui |
| 75 | silver_trench | procedural | large_rooms+looping+mixed | 4x3 | 9x8 | 5 | 0 | 6/8.0/10 | 9.0 | 2.2 | 1.4 | 1.4 | 37.6 | 5 | oui |
| 76 | silver_trench | procedural | large_rooms+looping+mixed | 4x3 | 10x10 | 5 | 1 | 7/9.2/12 | 11.2 | 3.2 | 1.8 | 1.8 | 43.4 | 5 | oui |
| 77 | silver_trench | procedural | large_rooms+looping+mixed | 4x2 | 16x13 | 5 | 0 | 6/11.0/21 | 13.8 | 3.4 | 1.6 | 2.0 | 39.8 | 5 | oui |
| 78 | silver_trench | procedural | large_rooms+looping+mixed | 4x2 | 14x11 | 5 | 0 | 5/9.0/12 | 9.4 | 1.6 | 2.4 | 0.8 | 42.4 | 5 | oui |
| 79 | silver_trench | procedural | large_rooms+looping+mixed | 4x2 | 16x11 | 5 | 0 | 4/9.2/17 | 10.0 | 2.8 | 2.0 | 1.4 | 35.0 | 5 | oui |
| 80 | silver_trench | procedural | large_rooms+looping+mixed | 3x3 | 15x11 | 5 | 0 | 7/12.4/22 | 15.4 | 4.8 | 2.0 | 2.6 | 47.6 | 5 | oui |
| 81 | silver_trench | procedural | large_rooms+looping+mixed | 4x2 | 12x10 | 5 | 1 | 7/12.0/16 | 14.8 | 4.0 | 2.4 | 2.0 | 43.8 | 5 | oui |
| 82 | silver_trench | procedural | large_rooms+looping+mixed | 4x2 | 13x12 | 5 | 0 | 5/9.8/12 | 10.6 | 2.0 | 1.8 | 1.2 | 39.8 | 5 | oui |
| 83 | silver_trench | procedural | large_rooms+looping+mixed | 4x3 | 10x10 | 5 | 0 | 7/10.8/15 | 12.2 | 3.0 | 2.0 | 1.6 | 45.4 | 5 | oui |
| 84 | silver_trench | procedural | large_rooms+looping+mixed | 5x3 | 13x7 | 5 | 0 | 4/8.2/12 | 9.8 | 3.0 | 1.4 | 1.8 | 32.8 | 5 | oui |
| 85 | silver_trench | procedural | large_rooms+looping+mixed | 4x2 | 15x10 | 5 | 1 | 8/10.6/14 | 12.4 | 3.4 | 2.0 | 1.8 | 40.2 | 5 | oui |
| 86 | silver_trench | procedural | large_rooms+looping+mixed | 4x3 | 11x10 | 5 | 0 | 4/7.8/12 | 9.2 | 2.4 | 1.6 | 1.4 | 41.2 | 5 | oui |
| 87 | silver_trench | procedural | large_rooms+looping+mixed | 4x4 | 11x8 | 5 | 0 | 6/9.8/14 | 11.6 | 2.6 | 1.4 | 1.8 | 41.2 | 5 | oui |
| 88 | silver_trench | procedural | large_rooms+looping+mixed | 3x2 | 12x10 | 5 | 0 | 6/7.8/11 | 9.0 | 1.8 | 0.8 | 1.6 | 42.6 | 5 | oui |
| 89 | silver_trench | procedural | large_rooms+looping+mixed | 3x2 | 13x12 | 5 | 0 | 6/10.8/20 | 13.2 | 3.4 | 1.8 | 2.0 | 37.2 | 5 | oui |
| 90 | silver_trench | procedural | large_rooms+looping+mixed | 4x2 | 15x11 | 5 | 2 | 8/12.2/17 | 13.4 | 3.6 | 2.2 | 1.8 | 39.0 | 5 | oui |
| 91 | silver_trench | procedural | large_rooms+looping+mixed | 6x5 | 14x10 | 5 | 0 | 4/9.4/18 | 11.2 | 2.4 | 1.6 | 1.4 | 38.8 | 5 | oui |
| 92 | silver_trench | procedural | large_rooms+looping+mixed | 3x3 | 14x12 | 5 | 0 | 6/10.4/15 | 11.0 | 2.4 | 2.4 | 1.0 | 45.2 | 5 | oui |
| 93 | silver_trench | procedural | large_rooms+looping+mixed | 4x2 | 15x10 | 5 | 0 | 9/10.4/13 | 11.8 | 2.8 | 2.2 | 1.4 | 39.6 | 5 | oui |
| 94 | silver_trench | procedural | large_rooms+looping+mixed | 4x3 | 13x12 | 5 | 0 | 7/10.2/15 | 13.0 | 4.4 | 1.8 | 2.4 | 42.6 | 5 | oui |
| 95 | silver_trench | procedural | large_rooms+looping+mixed | 3x2 | 14x11 | 5 | 0 | 5/10.0/14 | 12.2 | 3.4 | 2.0 | 1.8 | 37.2 | 5 | oui |
| 96 | silver_trench | procedural | large_rooms+looping+mixed | 3x2 | 16x11 | 5 | 0 | 5/12.8/23 | 14.8 | 3.6 | 2.0 | 2.0 | 44.8 | 5 | oui |
| 97 | silver_trench | procedural | large_rooms+looping+mixed | 3x2 | 15x12 | 5 | 0 | 6/10.0/14 | 12.2 | 3.0 | 1.4 | 2.0 | 35.0 | 5 | oui |
| 98 | silver_trench | procedural | large_rooms+looping+mixed | 5x4 | 11x11 | 5 | 0 | 5/9.8/15 | 11.4 | 2.6 | 1.8 | 1.6 | 37.4 | 5 | oui |
| 99 | silver_trench | procedural | large_rooms+looping+mixed | 5x3 | 10x9 | 5 | 1 | 10/10.6/12 | 13.8 | 4.0 | 1.4 | 2.6 | 31.8 | 5 | oui |
