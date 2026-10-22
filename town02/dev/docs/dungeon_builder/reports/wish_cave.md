# Rapport de génération — Wish Cave

- **ID** : `wish_cave`  
- **Chapitre** : 15 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Wish Cave (99F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/WishCave) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 15. Recoupé avec Bulbapedia (page « Wish Cave »).  
- **Étages** : 99 — direction `fond`  
- **Zone écrite** : `Data/Zone/wish_cave.json`  
- **Seed d'auteur (debug)** : `3857354273124611576` (explicite : False)  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| wish_gallery | 1-50 | wish_gallery | `wish_cave_1_floor` | branching, mixed, dense | 43 | oui | oui | — |
| wish_sanctum | 51-99 | wish_sanctum | `wish_cave_1_floor` | looping, lattice, mixed | 40 | oui | oui | — |

## Scènes fixes

- entrée : `—`
- midpoint : `—`
- Ground de fin : `sanctuaire_voeu`
- boss : mode `canonical_ground` → Ground `sanctuaire_voeu`, rsmap `sanctuaire_voeu`
  - no fixed 'entrance' Ground declared
  - no fixed 'mid' Ground declared
  - final battle stays on the canonical end Ground 'sanctuaire_voeu' (no separate arena created)
  - scene source of truth: sanctuaire_voeu.rsmap matches the end Ground

## Étages

| Ét. | Segment | Type | Profil | Grille | Cellule | Variantes OK | Rejets | Rooms (min/moy/max) | Halls | Branches | Culs-de-sac | Boucles | Dist. escaliers | Signatures | Traversable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | wish_gallery | procedural | branching+mixed+dense | 4x3 | 8x10 | 5 | 0 | 8/11.4/16 | 11.8 | 3.4 | 4.2 | 0.8 | 35.0 | 5 | oui |
| 2 | wish_gallery | procedural | branching+mixed+dense | 6x3 | 12x9 | 5 | 0 | 10/13.2/17 | 14.0 | 3.2 | 4.4 | 0.6 | 39.8 | 5 | oui |
| 3 | wish_gallery | procedural | branching+mixed+dense | 5x3 | 10x10 | 5 | 1 | 10/16.4/27 | 18.8 | 5.8 | 5.0 | 1.8 | 36.4 | 5 | oui |
| 4 | wish_gallery | procedural | branching+mixed+dense | 4x4 | 12x9 | 5 | 1 | 10/17.2/29 | 21.0 | 7.2 | 3.6 | 3.4 | 46.6 | 5 | oui |
| 5 | wish_gallery | procedural | branching+mixed+dense | 6x3 | 9x10 | 5 | 3 | 7/9.0/10 | 8.8 | 2.6 | 3.8 | 0.6 | 37.6 | 5 | oui |
| 6 | wish_gallery | procedural | branching+mixed+dense | 5x3 | 9x8 | 5 | 1 | 8/11.4/16 | 11.8 | 3.0 | 3.2 | 1.0 | 38.4 | 5 | oui |
| 7 | wish_gallery | procedural | branching+mixed+dense | 4x4 | 10x9 | 5 | 0 | 7/10.0/14 | 11.6 | 3.6 | 3.4 | 1.2 | 43.2 | 5 | oui |
| 8 | wish_gallery | procedural | branching+mixed+dense | 5x3 | 11x9 | 5 | 1 | 8/15.0/21 | 17.0 | 5.2 | 3.6 | 2.2 | 40.6 | 5 | oui |
| 9 | wish_gallery | procedural | branching+mixed+dense | 6x3 | 11x9 | 5 | 1 | 9/12.2/18 | 12.8 | 3.2 | 3.6 | 1.0 | 32.2 | 5 | oui |
| 10 | wish_gallery | procedural | branching+mixed+dense | 4x4 | 9x8 | 5 | 1 | 10/13.6/23 | 14.6 | 4.2 | 5.0 | 0.8 | 57.0 | 5 | oui |
| 11 | wish_gallery | procedural | branching+mixed+dense | 4x3 | 13x7 | 5 | 1 | 7/14.0/23 | 16.8 | 4.4 | 2.4 | 2.2 | 44.4 | 5 | oui |
| 12 | wish_gallery | procedural | branching+mixed+dense | 6x4 | 10x10 | 5 | 0 | 9/15.2/27 | 17.4 | 5.0 | 3.6 | 1.8 | 37.4 | 5 | oui |
| 13 | wish_gallery | procedural | branching+mixed+dense | 6x5 | 7x6 | 5 | 1 | 6/11.2/17 | 11.6 | 3.4 | 3.4 | 1.2 | 35.8 | 5 | oui |
| 14 | wish_gallery | procedural | branching+mixed+dense | 6x4 | 10x8 | 5 | 0 | 7/13.2/19 | 15.2 | 4.4 | 3.8 | 1.8 | 40.2 | 5 | oui |
| 15 | wish_gallery | procedural | branching+mixed+dense | 5x3 | 11x9 | 5 | 2 | 8/13.4/17 | 14.6 | 4.4 | 3.2 | 1.6 | 43.2 | 5 | oui |
| 16 | wish_gallery | procedural | branching+mixed+dense | 6x4 | 11x8 | 5 | 1 | 7/12.8/26 | 14.0 | 3.2 | 3.4 | 1.0 | 44.2 | 5 | oui |
| 17 | wish_gallery | procedural | branching+mixed+dense | 5x3 | 10x8 | 5 | 0 | 9/14.2/20 | 17.0 | 5.2 | 3.2 | 2.2 | 36.2 | 5 | oui |
| 18 | wish_gallery | procedural | branching+mixed+dense | 7x3 | 8x7 | 5 | 0 | 10/17.2/27 | 21.0 | 6.6 | 4.4 | 2.6 | 34.0 | 5 | oui |
| 19 | wish_gallery | procedural | branching+mixed+dense | 8x4 | 7x6 | 5 | 0 | 10/14.8/19 | 17.4 | 5.2 | 3.4 | 2.0 | 41.2 | 5 | oui |
| 20 | wish_gallery | procedural | branching+mixed+dense | 5x3 | 11x10 | 5 | 0 | 9/20.2/34 | 22.8 | 6.8 | 5.8 | 2.0 | 37.8 | 5 | oui |
| 21 | wish_gallery | procedural | branching+mixed+dense | 6x5 | 9x7 | 5 | 0 | 9/15.4/33 | 17.4 | 4.8 | 4.6 | 1.4 | 41.0 | 5 | oui |
| 22 | wish_gallery | procedural | branching+mixed+dense | 7x5 | 7x6 | 5 | 0 | 9/13.2/24 | 15.2 | 4.8 | 4.4 | 1.4 | 38.8 | 5 | oui |
| 23 | wish_gallery | procedural | branching+mixed+dense | 5x3 | 11x8 | 5 | 2 | 7/13.4/23 | 15.2 | 4.6 | 5.0 | 1.2 | 50.6 | 5 | oui |
| 24 | wish_gallery | procedural | branching+mixed+dense | 6x4 | 11x8 | 5 | 0 | 8/13.0/20 | 15.2 | 4.2 | 3.4 | 1.6 | 32.8 | 5 | oui |
| 25 | wish_gallery | procedural | branching+mixed+dense | 8x4 | 7x7 | 5 | 1 | 8/17.4/22 | 19.0 | 5.4 | 5.0 | 1.4 | 39.6 | 5 | oui |
| 26 | wish_gallery | procedural | branching+mixed+dense | 5x4 | 10x9 | 5 | 0 | 9/14.2/21 | 16.4 | 5.6 | 4.8 | 1.6 | 50.2 | 5 | oui |
| 27 | wish_gallery | procedural | branching+mixed+dense | 4x4 | 10x9 | 5 | 2 | 7/16.4/29 | 19.2 | 6.2 | 5.6 | 1.8 | 31.8 | 5 | oui |
| 28 | wish_gallery | procedural | branching+mixed+dense | 6x4 | 8x8 | 5 | 0 | 8/16.4/25 | 19.2 | 6.2 | 4.0 | 2.4 | 44.2 | 5 | oui |
| 29 | wish_gallery | procedural | branching+mixed+dense | 4x3 | 13x9 | 5 | 1 | 9/15.2/25 | 17.8 | 5.6 | 5.0 | 1.6 | 40.4 | 5 | oui |
| 30 | wish_gallery | procedural | branching+mixed+dense | 7x4 | 8x12 | 5 | 0 | 6/14.2/24 | 16.4 | 4.8 | 4.2 | 1.8 | 43.4 | 5 | oui |
| 31 | wish_gallery | procedural | branching+mixed+dense | 6x4 | 7x7 | 5 | 0 | 8/14.4/19 | 16.6 | 4.0 | 3.2 | 1.6 | 40.8 | 5 | oui |
| 32 | wish_gallery | procedural | branching+mixed+dense | 7x5 | 9x7 | 5 | 0 | 6/14.8/21 | 17.0 | 5.2 | 4.4 | 1.8 | 37.4 | 5 | oui |
| 33 | wish_gallery | procedural | branching+mixed+dense | 6x5 | 14x8 | 5 | 0 | 8/14.4/27 | 16.6 | 5.0 | 4.2 | 1.8 | 38.6 | 5 | oui |
| 34 | wish_gallery | procedural | branching+mixed+dense | 4x3 | 10x10 | 5 | 0 | 10/13.6/24 | 14.4 | 4.0 | 4.4 | 1.0 | 39.2 | 5 | oui |
| 35 | wish_gallery | procedural | branching+mixed+dense | 5x4 | 10x9 | 5 | 0 | 9/14.0/24 | 15.8 | 4.4 | 4.6 | 1.4 | 48.6 | 5 | oui |
| 36 | wish_gallery | procedural | branching+mixed+dense | 4x4 | 12x10 | 5 | 0 | 8/11.6/20 | 12.6 | 3.2 | 4.0 | 1.2 | 38.0 | 5 | oui |
| 37 | wish_gallery | procedural | branching+mixed+dense | 8x5 | 9x6 | 5 | 0 | 7/14.0/26 | 17.2 | 5.6 | 3.4 | 2.2 | 35.0 | 5 | oui |
| 38 | wish_gallery | procedural | branching+mixed+dense | 6x4 | 9x9 | 5 | 0 | 8/15.0/25 | 17.2 | 4.6 | 4.0 | 1.6 | 47.6 | 5 | oui |
| 39 | wish_gallery | procedural | branching+mixed+dense | 6x5 | 7x7 | 5 | 0 | 10/15.8/20 | 18.4 | 6.0 | 4.4 | 2.0 | 37.4 | 5 | oui |
| 40 | wish_gallery | procedural | branching+mixed+dense | 6x4 | 11x10 | 5 | 2 | 7/12.6/22 | 14.0 | 4.6 | 4.2 | 1.6 | 33.8 | 5 | oui |
| 41 | wish_gallery | procedural | branching+mixed+dense | 6x3 | 10x9 | 5 | 0 | 7/14.8/28 | 16.4 | 4.4 | 3.8 | 1.8 | 40.6 | 5 | oui |
| 42 | wish_gallery | procedural | branching+mixed+dense | 7x4 | 11x7 | 5 | 0 | 8/15.4/29 | 17.6 | 5.4 | 5.2 | 1.8 | 45.6 | 5 | oui |
| 43 | wish_gallery | procedural | branching+mixed+dense | 6x3 | 9x9 | 5 | 1 | 7/16.6/31 | 20.2 | 5.6 | 5.8 | 1.6 | 39.4 | 5 | oui |
| 44 | wish_gallery | procedural | branching+mixed+dense | 6x4 | 9x6 | 5 | 0 | 6/12.8/19 | 14.8 | 4.2 | 2.8 | 1.8 | 34.0 | 5 | oui |
| 45 | wish_gallery | procedural | branching+mixed+dense | 6x4 | 10x9 | 5 | 0 | 7/12.0/17 | 12.6 | 3.6 | 4.4 | 0.8 | 43.2 | 5 | oui |
| 46 | wish_gallery | procedural | branching+mixed+dense | 5x4 | 10x9 | 5 | 1 | 9/11.8/14 | 12.4 | 3.6 | 3.8 | 1.2 | 44.0 | 5 | oui |
| 47 | wish_gallery | procedural | branching+mixed+dense | 5x4 | 11x8 | 5 | 0 | 11/14.4/19 | 15.6 | 4.8 | 5.4 | 1.0 | 47.8 | 5 | oui |
| 48 | wish_gallery | procedural | branching+mixed+dense | 4x5 | 11x7 | 5 | 1 | 7/14.8/26 | 16.2 | 4.6 | 4.8 | 1.2 | 32.4 | 5 | oui |
| 49 | wish_gallery | procedural | branching+mixed+dense | 6x3 | 11x10 | 5 | 1 | 9/13.0/19 | 13.8 | 4.4 | 4.0 | 1.8 | 36.8 | 5 | oui |
| 50 | wish_gallery | procedural | branching+mixed+dense | 7x5 | 8x8 | 5 | 0 | 10/13.0/18 | 14.0 | 3.6 | 4.2 | 0.8 | 42.8 | 5 | oui |
| 51 | wish_sanctum | procedural | looping+lattice+mixed | 6x5 | 12x9 | 5 | 0 | 5/10.2/15 | 12.6 | 3.4 | 3.0 | 1.4 | 47.8 | 5 | oui |
| 52 | wish_sanctum | procedural | looping+lattice+mixed | 4x3 | 11x10 | 5 | 1 | 7/8.0/11 | 13.2 | 4.6 | 2.8 | 2.8 | 41.2 | 5 | oui |
| 53 | wish_sanctum | procedural | looping+lattice+mixed | 5x3 | 10x10 | 5 | 1 | 8/10.2/12 | 18.0 | 6.2 | 3.8 | 3.4 | 45.4 | 5 | oui |
| 54 | wish_sanctum | procedural | looping+lattice+mixed | 4x3 | 11x10 | 5 | 1 | 8/11.6/17 | 15.8 | 4.4 | 2.6 | 2.2 | 38.2 | 5 | oui |
| 55 | wish_sanctum | procedural | looping+lattice+mixed | 4x4 | 9x9 | 5 | 1 | 8/11.8/15 | 17.4 | 6.0 | 2.4 | 3.6 | 38.2 | 5 | oui |
| 56 | wish_sanctum | procedural | looping+lattice+mixed | 4x4 | 11x9 | 5 | 0 | 5/9.0/13 | 11.4 | 3.4 | 3.0 | 1.4 | 36.4 | 5 | oui |
| 57 | wish_sanctum | procedural | looping+lattice+mixed | 5x4 | 9x9 | 5 | 0 | 8/11.4/18 | 16.6 | 4.6 | 2.4 | 2.6 | 29.4 | 5 | oui |
| 58 | wish_sanctum | procedural | looping+lattice+mixed | 4x3 | 10x10 | 5 | 0 | 6/10.6/14 | 16.4 | 5.2 | 3.0 | 3.0 | 40.0 | 5 | oui |
| 59 | wish_sanctum | procedural | looping+lattice+mixed | 5x3 | 12x9 | 5 | 0 | 7/10.0/13 | 15.8 | 4.2 | 2.4 | 2.8 | 36.8 | 5 | oui |
| 60 | wish_sanctum | procedural | looping+lattice+mixed | 4x5 | 11x10 | 5 | 0 | 6/10.4/20 | 13.4 | 3.4 | 2.4 | 1.8 | 38.0 | 5 | oui |
| 61 | wish_sanctum | procedural | looping+lattice+mixed | 4x4 | 12x12 | 5 | 0 | 5/10.8/19 | 13.8 | 3.8 | 3.2 | 1.6 | 40.8 | 5 | oui |
| 62 | wish_sanctum | procedural | looping+lattice+mixed | 4x5 | 12x10 | 5 | 2 | 9/11.0/14 | 14.0 | 3.2 | 2.0 | 1.8 | 40.8 | 5 | oui |
| 63 | wish_sanctum | procedural | looping+lattice+mixed | 5x5 | 14x11 | 5 | 0 | 8/9.6/14 | 13.6 | 4.6 | 2.6 | 2.4 | 49.6 | 5 | oui |
| 64 | wish_sanctum | procedural | looping+lattice+mixed | 6x5 | 11x8 | 5 | 1 | 9/11.6/15 | 18.8 | 5.8 | 1.2 | 4.2 | 44.0 | 5 | oui |
| 65 | wish_sanctum | procedural | looping+lattice+mixed | 4x3 | 9x9 | 5 | 0 | 9/12.0/14 | 17.8 | 5.8 | 2.4 | 3.2 | 45.4 | 5 | oui |
| 66 | wish_sanctum | procedural | looping+lattice+mixed | 4x3 | 9x8 | 5 | 2 | 7/9.6/12 | 14.0 | 4.8 | 1.8 | 3.0 | 46.6 | 5 | oui |
| 67 | wish_sanctum | procedural | looping+lattice+mixed | 4x4 | 10x9 | 5 | 1 | 5/9.0/11 | 10.2 | 2.6 | 1.8 | 1.4 | 34.8 | 5 | oui |
| 68 | wish_sanctum | procedural | looping+lattice+mixed | 4x4 | 10x8 | 5 | 1 | 9/13.6/21 | 19.2 | 5.4 | 2.6 | 2.8 | 35.6 | 5 | oui |
| 69 | wish_sanctum | procedural | looping+lattice+mixed | 7x4 | 11x11 | 5 | 0 | 8/10.4/14 | 16.2 | 6.2 | 3.2 | 3.2 | 34.6 | 5 | oui |
| 70 | wish_sanctum | procedural | looping+lattice+mixed | 6x3 | 10x9 | 5 | 0 | 4/8.6/12 | 13.0 | 4.2 | 1.4 | 2.8 | 38.0 | 5 | oui |
| 71 | wish_sanctum | procedural | looping+lattice+mixed | 4x4 | 9x9 | 5 | 1 | 7/10.8/15 | 15.2 | 5.6 | 2.8 | 2.8 | 51.6 | 5 | oui |
| 72 | wish_sanctum | procedural | looping+lattice+mixed | 5x4 | 9x10 | 5 | 0 | 7/11.0/18 | 15.6 | 4.6 | 2.6 | 2.6 | 33.0 | 5 | oui |
| 73 | wish_sanctum | procedural | looping+lattice+mixed | 6x3 | 10x9 | 5 | 0 | 9/10.2/13 | 17.2 | 5.6 | 2.4 | 3.6 | 49.4 | 5 | oui |
| 74 | wish_sanctum | procedural | looping+lattice+mixed | 4x4 | 12x8 | 5 | 2 | 7/9.6/14 | 10.8 | 2.2 | 1.8 | 1.2 | 50.6 | 5 | oui |
| 75 | wish_sanctum | procedural | looping+lattice+mixed | 5x3 | 12x10 | 5 | 0 | 8/10.2/12 | 18.4 | 6.6 | 2.8 | 4.0 | 41.0 | 5 | oui |
| 76 | wish_sanctum | procedural | looping+lattice+mixed | 4x3 | 10x8 | 5 | 0 | 5/9.8/14 | 13.6 | 4.0 | 1.8 | 2.2 | 31.2 | 5 | oui |
| 77 | wish_sanctum | procedural | looping+lattice+mixed | 5x3 | 10x9 | 5 | 0 | 8/10.0/12 | 14.4 | 4.6 | 3.6 | 2.2 | 46.8 | 5 | oui |
| 78 | wish_sanctum | procedural | looping+lattice+mixed | 5x3 | 9x10 | 5 | 0 | 4/9.2/11 | 13.6 | 4.0 | 2.2 | 2.6 | 38.4 | 5 | oui |
| 79 | wish_sanctum | procedural | looping+lattice+mixed | 5x5 | 11x10 | 5 | 1 | 8/12.2/16 | 14.8 | 4.8 | 2.8 | 2.2 | 34.8 | 5 | oui |
| 80 | wish_sanctum | procedural | looping+lattice+mixed | 4x3 | 12x8 | 5 | 0 | 5/8.8/14 | 10.8 | 2.8 | 3.0 | 1.2 | 41.0 | 5 | oui |
| 81 | wish_sanctum | procedural | looping+lattice+mixed | 5x4 | 11x8 | 5 | 1 | 9/12.6/21 | 18.4 | 6.2 | 3.4 | 3.2 | 48.8 | 5 | oui |
| 82 | wish_sanctum | procedural | looping+lattice+mixed | 5x3 | 9x8 | 5 | 0 | 8/11.2/15 | 19.8 | 7.6 | 2.6 | 4.6 | 31.8 | 5 | oui |
| 83 | wish_sanctum | procedural | looping+lattice+mixed | 4x3 | 11x10 | 5 | 0 | 7/12.6/22 | 19.4 | 6.2 | 3.6 | 3.2 | 39.0 | 5 | oui |
| 84 | wish_sanctum | procedural | looping+lattice+mixed | 4x4 | 9x9 | 5 | 0 | 9/10.8/12 | 19.0 | 6.4 | 1.6 | 4.4 | 34.0 | 5 | oui |
| 85 | wish_sanctum | procedural | looping+lattice+mixed | 6x5 | 11x10 | 5 | 3 | 8/12.6/19 | 15.2 | 4.2 | 3.0 | 1.8 | 48.4 | 5 | oui |
| 86 | wish_sanctum | procedural | looping+lattice+mixed | 5x4 | 9x9 | 5 | 1 | 8/11.4/15 | 21.2 | 8.2 | 3.4 | 5.0 | 59.2 | 5 | oui |
| 87 | wish_sanctum | procedural | looping+lattice+mixed | 4x4 | 12x8 | 5 | 0 | 8/10.2/13 | 16.8 | 5.2 | 2.4 | 3.4 | 41.2 | 5 | oui |
| 88 | wish_sanctum | procedural | looping+lattice+mixed | 4x4 | 12x8 | 5 | 3 | 9/12.6/23 | 18.8 | 6.0 | 3.6 | 3.0 | 31.2 | 5 | oui |
| 89 | wish_sanctum | procedural | looping+lattice+mixed | 6x4 | 11x10 | 5 | 1 | 8/10.6/13 | 17.0 | 5.2 | 2.4 | 3.2 | 42.4 | 5 | oui |
| 90 | wish_sanctum | procedural | looping+lattice+mixed | 5x3 | 9x10 | 5 | 1 | 8/10.6/13 | 13.8 | 3.2 | 1.2 | 2.4 | 47.8 | 5 | oui |
| 91 | wish_sanctum | procedural | looping+lattice+mixed | 5x5 | 12x10 | 5 | 0 | 8/11.8/19 | 15.8 | 5.0 | 3.6 | 2.2 | 39.0 | 5 | oui |
| 92 | wish_sanctum | procedural | looping+lattice+mixed | 5x4 | 10x9 | 5 | 0 | 7/11.8/18 | 16.8 | 4.6 | 1.8 | 3.0 | 32.2 | 5 | oui |
| 93 | wish_sanctum | procedural | looping+lattice+mixed | 4x4 | 9x10 | 5 | 2 | 6/10.4/16 | 16.0 | 5.0 | 3.4 | 2.8 | 40.0 | 5 | oui |
| 94 | wish_sanctum | procedural | looping+lattice+mixed | 5x4 | 10x8 | 5 | 0 | 5/9.8/19 | 12.8 | 3.0 | 1.6 | 2.0 | 36.0 | 5 | oui |
| 95 | wish_sanctum | procedural | looping+lattice+mixed | 5x3 | 9x8 | 5 | 1 | 8/12.0/19 | 15.8 | 4.2 | 2.6 | 2.2 | 41.4 | 5 | oui |
| 96 | wish_sanctum | procedural | looping+lattice+mixed | 4x3 | 11x8 | 5 | 1 | 8/11.4/17 | 15.2 | 5.0 | 3.4 | 2.2 | 40.4 | 5 | oui |
| 97 | wish_sanctum | procedural | looping+lattice+mixed | 4x4 | 11x10 | 5 | 1 | 7/11.8/20 | 15.0 | 4.6 | 2.4 | 2.2 | 43.6 | 5 | oui |
| 98 | wish_sanctum | procedural | looping+lattice+mixed | 4x4 | 12x10 | 5 | 0 | 9/11.2/13 | 20.0 | 7.4 | 3.0 | 4.4 | 38.4 | 5 | oui |
| 99 | wish_sanctum | procedural | looping+lattice+mixed | 6x3 | 11x10 | 5 | 0 | 7/12.0/15 | 17.6 | 4.8 | 2.6 | 3.0 | 54.6 | 5 | oui |
