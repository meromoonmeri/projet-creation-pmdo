# Rapport de génération — Purity Forest

- **ID** : `purity_forest`  
- **Chapitre** : 29 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Purity Forest (99F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/PurityForest) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 29. Recoupé avec Bulbapedia (page « Purity Forest »).  
- **Étages** : 99 — direction `sommet`  
- **Zone écrite** : `Data/Zone/purity_forest.json`  
- **Seed d'auteur (debug)** : `2722997828126802575` (explicite : False)  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| purity_outer | 1-25 | purity_outer | `purity_forest_4_floor` | branching, dense, mixed | 48 | oui | oui | — |
| purity_inner | 26-50 | purity_inner | `purity_forest_4_floor` | looping, branching, mixed | 38 | oui | oui | — |
| purity_heart | 51-74 | purity_heart | `purity_forest_4_floor` | mixed, large_rooms, looping | 36 | oui | oui | — |
| purity_core | 75-99 | purity_core | `purity_forest_4_floor` | mixed, large_rooms, looping | 32 | oui | oui | — |

## Scènes fixes

- entrée : `—`
- midpoint : `—`
- Ground de fin : `foret_guerison`
- boss : mode `canonical_ground` → Ground `foret_guerison`, rsmap `—`
  - no fixed 'entrance' Ground declared
  - no fixed 'mid' Ground declared
  - final battle stays on the canonical end Ground 'foret_guerison' (no separate arena created)

## Étages

| Ét. | Segment | Type | Profil | Grille | Cellule | Variantes OK | Rejets | Rooms (min/moy/max) | Halls | Branches | Culs-de-sac | Boucles | Dist. escaliers | Signatures | Traversable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | purity_outer | procedural | branching+dense+mixed | 6x5 | 9x7 | 5 | 0 | 8/16.6/27 | 19.8 | 5.4 | 4.2 | 2.4 | 40.4 | 5 | oui |
| 2 | purity_outer | procedural | branching+dense+mixed | 8x5 | 9x8 | 5 | 1 | 8/15.4/31 | 17.2 | 4.4 | 3.8 | 1.6 | 41.2 | 5 | oui |
| 3 | purity_outer | procedural | branching+dense+mixed | 6x4 | 11x8 | 5 | 0 | 9/17.8/28 | 21.4 | 6.4 | 5.2 | 2.2 | 48.4 | 5 | oui |
| 4 | purity_outer | procedural | branching+dense+mixed | 7x5 | 9x8 | 5 | 2 | 8/12.0/19 | 13.0 | 3.2 | 3.2 | 1.2 | 40.0 | 5 | oui |
| 5 | purity_outer | procedural | branching+dense+mixed | 6x3 | 9x9 | 5 | 1 | 7/15.2/23 | 17.8 | 5.8 | 4.0 | 2.4 | 30.8 | 5 | oui |
| 6 | purity_outer | procedural | branching+dense+mixed | 4x3 | 10x10 | 5 | 0 | 6/14.8/29 | 18.8 | 5.4 | 4.6 | 1.8 | 40.2 | 5 | oui |
| 7 | purity_outer | procedural | branching+dense+mixed | 7x3 | 11x7 | 5 | 1 | 9/16.2/21 | 20.6 | 5.8 | 2.6 | 3.0 | 41.8 | 5 | oui |
| 8 | purity_outer | procedural | branching+dense+mixed | 6x4 | 12x9 | 5 | 1 | 8/15.2/24 | 17.2 | 4.8 | 4.2 | 2.0 | 30.0 | 5 | oui |
| 9 | purity_outer | procedural | branching+dense+mixed | 5x4 | 10x8 | 5 | 0 | 9/14.4/20 | 17.4 | 5.8 | 5.0 | 1.8 | 44.4 | 5 | oui |
| 10 | purity_outer | procedural | branching+dense+mixed | 4x5 | 9x8 | 5 | 0 | 12/16.4/21 | 19.2 | 5.2 | 4.8 | 1.6 | 49.6 | 5 | oui |
| 11 | purity_outer | procedural | branching+dense+mixed | 8x4 | 8x8 | 5 | 0 | 6/14.2/22 | 16.0 | 4.2 | 4.4 | 1.0 | 31.0 | 5 | oui |
| 12 | purity_outer | procedural | branching+dense+mixed | 6x3 | 9x10 | 5 | 1 | 11/19.2/26 | 23.0 | 6.4 | 5.2 | 1.8 | 42.4 | 5 | oui |
| 13 | purity_outer | procedural | branching+dense+mixed | 4x4 | 9x12 | 5 | 0 | 12/16.6/22 | 19.4 | 5.8 | 4.2 | 2.2 | 41.0 | 5 | oui |
| 14 | purity_outer | procedural | branching+dense+mixed | 4x3 | 11x9 | 5 | 2 | 13/16.2/20 | 20.0 | 5.8 | 3.4 | 2.4 | 53.2 | 5 | oui |
| 15 | purity_outer | procedural | branching+dense+mixed | 8x5 | 7x6 | 5 | 1 | 7/13.8/19 | 16.0 | 5.0 | 4.6 | 1.6 | 44.2 | 5 | oui |
| 16 | purity_outer | procedural | branching+dense+mixed | 4x3 | 11x9 | 5 | 2 | 8/15.2/22 | 16.8 | 5.2 | 5.2 | 1.4 | 44.2 | 5 | oui |
| 17 | purity_outer | procedural | branching+dense+mixed | 6x5 | 7x6 | 5 | 2 | 8/14.2/25 | 16.0 | 5.0 | 4.2 | 1.6 | 39.8 | 5 | oui |
| 18 | purity_outer | procedural | branching+dense+mixed | 4x5 | 13x7 | 5 | 1 | 8/11.6/16 | 13.0 | 4.2 | 4.0 | 1.2 | 35.6 | 5 | oui |
| 19 | purity_outer | procedural | branching+dense+mixed | 7x5 | 9x12 | 5 | 3 | 8/13.4/22 | 14.8 | 4.6 | 5.0 | 1.2 | 33.6 | 5 | oui |
| 20 | purity_outer | procedural | branching+dense+mixed | 6x4 | 12x10 | 5 | 0 | 8/14.6/24 | 15.8 | 4.6 | 5.2 | 1.0 | 29.6 | 5 | oui |
| 21 | purity_outer | procedural | branching+dense+mixed | 7x4 | 7x7 | 5 | 0 | 8/17.6/34 | 21.2 | 6.6 | 5.0 | 2.2 | 36.8 | 5 | oui |
| 22 | purity_outer | procedural | branching+dense+mixed | 4x4 | 12x9 | 5 | 1 | 10/15.0/19 | 18.8 | 5.2 | 5.0 | 1.8 | 33.4 | 5 | oui |
| 23 | purity_outer | procedural | branching+dense+mixed | 7x3 | 9x10 | 5 | 0 | 12/17.6/21 | 20.8 | 6.6 | 4.6 | 2.2 | 33.0 | 5 | oui |
| 24 | purity_outer | procedural | branching+dense+mixed | 5x4 | 9x9 | 5 | 0 | 8/16.2/31 | 19.4 | 5.6 | 4.8 | 2.2 | 37.6 | 5 | oui |
| 25 | purity_outer | procedural | branching+dense+mixed | 6x3 | 11x9 | 5 | 1 | 8/15.2/23 | 18.0 | 5.2 | 4.4 | 1.8 | 44.2 | 5 | oui |
| 26 | purity_inner | procedural | looping+branching+mixed | 5x4 | 10x8 | 5 | 1 | 11/13.6/17 | 16.4 | 4.0 | 2.6 | 2.0 | 57.8 | 5 | oui |
| 27 | purity_inner | procedural | looping+branching+mixed | 4x3 | 10x9 | 5 | 0 | 8/10.8/13 | 12.2 | 3.2 | 2.4 | 1.4 | 43.0 | 5 | oui |
| 28 | purity_inner | procedural | looping+branching+mixed | 5x4 | 12x10 | 5 | 0 | 7/11.6/17 | 13.8 | 3.8 | 2.2 | 2.0 | 47.4 | 5 | oui |
| 29 | purity_inner | procedural | looping+branching+mixed | 5x4 | 9x8 | 5 | 0 | 8/10.2/13 | 11.4 | 3.2 | 2.4 | 1.4 | 39.4 | 5 | oui |
| 30 | purity_inner | procedural | looping+branching+mixed | 5x5 | 14x10 | 5 | 0 | 9/13.8/22 | 16.0 | 4.6 | 3.2 | 2.2 | 33.6 | 5 | oui |
| 31 | purity_inner | procedural | looping+branching+mixed | 5x3 | 13x9 | 5 | 0 | 7/12.0/15 | 14.0 | 4.0 | 2.4 | 2.2 | 38.8 | 5 | oui |
| 32 | purity_inner | procedural | looping+branching+mixed | 6x5 | 8x9 | 5 | 0 | 9/12.6/21 | 15.2 | 5.0 | 2.4 | 2.4 | 32.2 | 5 | oui |
| 33 | purity_inner | procedural | looping+branching+mixed | 5x4 | 12x9 | 5 | 0 | 7/11.6/18 | 13.6 | 3.8 | 2.0 | 2.0 | 41.2 | 5 | oui |
| 34 | purity_inner | procedural | looping+branching+mixed | 6x3 | 9x10 | 5 | 2 | 6/11.2/21 | 12.2 | 2.8 | 2.2 | 1.4 | 44.2 | 5 | oui |
| 35 | purity_inner | procedural | looping+branching+mixed | 6x5 | 10x9 | 5 | 0 | 9/10.4/13 | 12.2 | 2.8 | 1.6 | 1.6 | 35.4 | 5 | oui |
| 36 | purity_inner | procedural | looping+branching+mixed | 6x4 | 8x9 | 5 | 0 | 8/10.6/14 | 12.6 | 3.4 | 2.6 | 1.6 | 37.8 | 5 | oui |
| 37 | purity_inner | procedural | looping+branching+mixed | 4x4 | 12x9 | 5 | 0 | 8/13.0/20 | 15.2 | 4.4 | 3.8 | 1.6 | 40.6 | 5 | oui |
| 38 | purity_inner | procedural | looping+branching+mixed | 4x3 | 12x9 | 5 | 0 | 8/13.2/18 | 15.2 | 4.6 | 3.2 | 2.0 | 39.0 | 5 | oui |
| 39 | purity_inner | procedural | looping+branching+mixed | 4x3 | 10x10 | 5 | 2 | 7/10.6/16 | 13.6 | 3.6 | 0.8 | 2.4 | 34.6 | 5 | oui |
| 40 | purity_inner | procedural | looping+branching+mixed | 4x3 | 11x9 | 5 | 0 | 9/11.6/17 | 14.4 | 4.2 | 2.2 | 2.0 | 34.2 | 5 | oui |
| 41 | purity_inner | procedural | looping+branching+mixed | 7x5 | 11x12 | 5 | 0 | 8/10.8/17 | 12.4 | 3.6 | 2.6 | 1.6 | 40.8 | 5 | oui |
| 42 | purity_inner | procedural | looping+branching+mixed | 4x3 | 11x9 | 5 | 0 | 7/12.0/17 | 12.6 | 3.2 | 4.2 | 1.0 | 38.0 | 5 | oui |
| 43 | purity_inner | procedural | looping+branching+mixed | 4x4 | 14x12 | 5 | 0 | 9/11.6/16 | 13.2 | 3.8 | 2.8 | 1.8 | 35.2 | 5 | oui |
| 44 | purity_inner | procedural | looping+branching+mixed | 5x3 | 9x8 | 5 | 0 | 6/9.4/15 | 10.6 | 3.0 | 2.6 | 1.2 | 33.2 | 5 | oui |
| 45 | purity_inner | procedural | looping+branching+mixed | 4x3 | 9x10 | 5 | 1 | 9/10.6/14 | 13.0 | 4.6 | 2.4 | 2.2 | 39.4 | 5 | oui |
| 46 | purity_inner | procedural | looping+branching+mixed | 6x5 | 10x9 | 5 | 1 | 8/11.0/14 | 12.4 | 3.6 | 2.2 | 1.8 | 31.0 | 5 | oui |
| 47 | purity_inner | procedural | looping+branching+mixed | 4x3 | 10x9 | 5 | 2 | 7/10.6/15 | 11.4 | 2.6 | 3.0 | 1.0 | 30.2 | 5 | oui |
| 48 | purity_inner | procedural | looping+branching+mixed | 4x3 | 12x8 | 5 | 0 | 10/11.2/13 | 12.6 | 2.8 | 2.0 | 1.4 | 34.8 | 5 | oui |
| 49 | purity_inner | procedural | looping+branching+mixed | 5x4 | 12x10 | 5 | 0 | 6/9.6/15 | 11.2 | 3.2 | 1.6 | 2.0 | 33.2 | 5 | oui |
| 50 | purity_inner | procedural | looping+branching+mixed | 4x3 | 10x9 | 5 | 0 | 9/13.4/17 | 15.6 | 4.8 | 3.0 | 2.2 | 48.2 | 5 | oui |
| 51 | purity_heart | procedural | mixed+large_rooms+looping | 4x2 | 14x11 | 5 | 0 | 5/13.6/23 | 14.8 | 3.0 | 3.2 | 1.4 | 37.6 | 5 | oui |
| 52 | purity_heart | procedural | mixed+large_rooms+looping | 3x2 | 13x12 | 5 | 0 | 5/7.2/11 | 7.8 | 1.8 | 1.6 | 1.2 | 38.8 | 5 | oui |
| 53 | purity_heart | procedural | mixed+large_rooms+looping | 4x4 | 12x8 | 5 | 0 | 7/13.4/24 | 15.6 | 4.2 | 2.2 | 2.4 | 42.4 | 5 | oui |
| 54 | purity_heart | procedural | mixed+large_rooms+looping | 3x2 | 15x11 | 5 | 0 | 4/8.8/13 | 9.6 | 2.6 | 1.8 | 1.4 | 32.4 | 5 | oui |
| 55 | purity_heart | procedural | mixed+large_rooms+looping | 3x2 | 14x10 | 5 | 0 | 4/7.6/10 | 8.8 | 2.0 | 1.8 | 1.4 | 43.6 | 5 | oui |
| 56 | purity_heart | procedural | mixed+large_rooms+looping | 6x4 | 13x7 | 5 | 0 | 5/11.0/17 | 12.4 | 3.2 | 3.0 | 1.6 | 34.0 | 5 | oui |
| 57 | purity_heart | procedural | mixed+large_rooms+looping | 4x4 | 12x8 | 5 | 0 | 4/9.0/15 | 11.2 | 2.8 | 2.2 | 1.8 | 45.2 | 5 | oui |
| 58 | purity_heart | procedural | mixed+large_rooms+looping | 4x5 | 11x12 | 5 | 0 | 5/8.4/11 | 9.4 | 2.2 | 1.6 | 1.4 | 27.0 | 5 | oui |
| 59 | purity_heart | procedural | mixed+large_rooms+looping | 4x3 | 11x8 | 5 | 1 | 5/8.0/15 | 8.8 | 1.8 | 1.4 | 1.2 | 36.8 | 5 | oui |
| 60 | purity_heart | procedural | mixed+large_rooms+looping | 5x3 | 14x9 | 5 | 2 | 5/14.6/23 | 18.0 | 4.8 | 2.2 | 2.6 | 46.0 | 5 | oui |
| 61 | purity_heart | procedural | mixed+large_rooms+looping | 3x2 | 14x10 | 5 | 0 | 4/10.2/16 | 12.2 | 3.0 | 1.6 | 1.8 | 40.0 | 5 | oui |
| 62 | purity_heart | procedural | mixed+large_rooms+looping | 4x3 | 9x7 | 5 | 0 | 4/10.2/18 | 11.6 | 3.4 | 2.4 | 1.6 | 33.0 | 5 | oui |
| 63 | purity_heart | procedural | mixed+large_rooms+looping | 3x2 | 12x12 | 5 | 0 | 4/8.4/15 | 10.4 | 3.0 | 1.6 | 2.0 | 32.6 | 5 | oui |
| 64 | purity_heart | procedural | mixed+large_rooms+looping | 5x3 | 10x10 | 5 | 0 | 5/8.2/11 | 9.4 | 2.8 | 1.8 | 1.6 | 40.4 | 5 | oui |
| 65 | purity_heart | procedural | mixed+large_rooms+looping | 3x2 | 13x10 | 5 | 0 | 5/11.8/18 | 13.8 | 3.4 | 3.0 | 1.4 | 47.4 | 5 | oui |
| 66 | purity_heart | procedural | mixed+large_rooms+looping | 4x3 | 12x12 | 5 | 0 | 5/9.4/12 | 11.0 | 3.2 | 1.8 | 1.8 | 34.4 | 5 | oui |
| 67 | purity_heart | procedural | mixed+large_rooms+looping | 5x4 | 14x12 | 5 | 0 | 7/11.0/13 | 12.4 | 3.0 | 1.8 | 1.8 | 37.2 | 5 | oui |
| 68 | purity_heart | procedural | mixed+large_rooms+looping | 3x3 | 15x10 | 5 | 0 | 6/11.4/18 | 13.4 | 4.8 | 2.4 | 2.2 | 36.2 | 5 | oui |
| 69 | purity_heart | procedural | mixed+large_rooms+looping | 3x2 | 16x11 | 5 | 0 | 5/11.2/18 | 13.4 | 3.6 | 2.6 | 1.8 | 36.6 | 5 | oui |
| 70 | purity_heart | procedural | mixed+large_rooms+looping | 3x3 | 16x12 | 5 | 0 | 6/9.0/13 | 10.2 | 2.4 | 1.6 | 1.4 | 35.2 | 5 | oui |
| 71 | purity_heart | procedural | mixed+large_rooms+looping | 6x3 | 10x8 | 5 | 0 | 5/9.6/14 | 10.6 | 2.0 | 1.6 | 1.4 | 44.2 | 5 | oui |
| 72 | purity_heart | procedural | mixed+large_rooms+looping | 5x4 | 14x12 | 5 | 0 | 6/11.2/23 | 13.4 | 4.2 | 2.6 | 2.0 | 40.0 | 5 | oui |
| 73 | purity_heart | procedural | mixed+large_rooms+looping | 3x2 | 13x10 | 5 | 0 | 5/9.2/18 | 11.0 | 3.4 | 2.2 | 1.8 | 36.4 | 5 | oui |
| 74 | purity_heart | procedural | mixed+large_rooms+looping | 4x2 | 13x12 | 5 | 0 | 5/10.2/14 | 11.0 | 2.4 | 2.4 | 1.0 | 35.0 | 5 | oui |
| 75 | purity_core | procedural | mixed+large_rooms+looping | 4x2 | 13x10 | 5 | 1 | 5/11.0/19 | 12.4 | 3.6 | 3.2 | 1.6 | 43.0 | 5 | oui |
| 76 | purity_core | procedural | mixed+large_rooms+looping | 4x3 | 15x12 | 5 | 0 | 7/11.4/16 | 12.6 | 3.2 | 3.0 | 1.2 | 33.0 | 5 | oui |
| 77 | purity_core | procedural | mixed+large_rooms+looping | 7x3 | 11x8 | 5 | 0 | 5/12.0/23 | 14.6 | 4.0 | 2.4 | 2.2 | 51.2 | 5 | oui |
| 78 | purity_core | procedural | mixed+large_rooms+looping | 5x4 | 13x12 | 5 | 0 | 6/12.8/20 | 15.2 | 3.8 | 2.8 | 1.8 | 38.4 | 5 | oui |
| 79 | purity_core | procedural | mixed+large_rooms+looping | 7x5 | 12x7 | 5 | 0 | 6/10.6/19 | 12.0 | 3.2 | 2.4 | 1.6 | 34.4 | 5 | oui |
| 80 | purity_core | procedural | mixed+large_rooms+looping | 3x3 | 12x12 | 5 | 0 | 5/12.8/28 | 14.6 | 4.4 | 2.8 | 2.0 | 44.2 | 5 | oui |
| 81 | purity_core | procedural | mixed+large_rooms+looping | 7x4 | 9x11 | 5 | 0 | 4/12.4/23 | 13.6 | 3.4 | 3.0 | 1.4 | 38.2 | 5 | oui |
| 82 | purity_core | procedural | mixed+large_rooms+looping | 4x3 | 14x8 | 5 | 0 | 4/10.4/19 | 13.2 | 3.6 | 1.2 | 3.0 | 41.6 | 5 | oui |
| 83 | purity_core | procedural | mixed+large_rooms+looping | 5x4 | 9x8 | 5 | 1 | 6/8.0/10 | 8.8 | 2.2 | 1.4 | 1.4 | 39.6 | 5 | oui |
| 84 | purity_core | procedural | mixed+large_rooms+looping | 4x3 | 15x11 | 5 | 0 | 4/11.0/18 | 11.6 | 2.6 | 2.4 | 1.2 | 31.8 | 5 | oui |
| 85 | purity_core | procedural | mixed+large_rooms+looping | 5x3 | 12x9 | 5 | 0 | 4/12.2/18 | 14.6 | 3.4 | 1.6 | 2.0 | 43.2 | 5 | oui |
| 86 | purity_core | procedural | mixed+large_rooms+looping | 5x3 | 11x9 | 5 | 0 | 4/8.0/12 | 9.2 | 2.4 | 1.6 | 1.4 | 39.4 | 5 | oui |
| 87 | purity_core | procedural | mixed+large_rooms+looping | 5x3 | 14x8 | 5 | 0 | 7/11.4/16 | 13.6 | 3.4 | 1.4 | 2.0 | 36.2 | 5 | oui |
| 88 | purity_core | procedural | mixed+large_rooms+looping | 5x5 | 14x10 | 5 | 0 | 7/11.4/16 | 12.8 | 2.6 | 2.4 | 1.2 | 45.8 | 5 | oui |
| 89 | purity_core | procedural | mixed+large_rooms+looping | 5x3 | 9x9 | 5 | 0 | 8/12.4/23 | 13.8 | 3.4 | 2.8 | 1.6 | 38.8 | 5 | oui |
| 90 | purity_core | procedural | mixed+large_rooms+looping | 4x5 | 10x11 | 5 | 0 | 5/11.2/26 | 13.4 | 3.8 | 1.6 | 2.2 | 45.0 | 5 | oui |
| 91 | purity_core | procedural | mixed+large_rooms+looping | 3x2 | 12x12 | 5 | 0 | 5/8.0/10 | 9.2 | 2.2 | 1.6 | 1.4 | 34.4 | 5 | oui |
| 92 | purity_core | procedural | mixed+large_rooms+looping | 4x4 | 11x8 | 5 | 0 | 6/9.4/15 | 10.0 | 2.4 | 2.4 | 1.0 | 38.4 | 5 | oui |
| 93 | purity_core | procedural | mixed+large_rooms+looping | 7x3 | 13x12 | 5 | 0 | 7/11.2/20 | 12.6 | 3.0 | 2.4 | 1.4 | 38.8 | 5 | oui |
| 94 | purity_core | procedural | mixed+large_rooms+looping | 7x4 | 10x10 | 5 | 0 | 5/11.6/17 | 13.4 | 3.0 | 2.4 | 1.4 | 32.2 | 5 | oui |
| 95 | purity_core | procedural | mixed+large_rooms+looping | 4x2 | 15x10 | 5 | 1 | 8/13.2/18 | 15.6 | 4.4 | 2.2 | 2.6 | 40.0 | 5 | oui |
| 96 | purity_core | procedural | mixed+large_rooms+looping | 3x2 | 15x13 | 5 | 1 | 7/9.2/11 | 10.2 | 2.8 | 1.6 | 1.6 | 44.4 | 5 | oui |
| 97 | purity_core | procedural | mixed+large_rooms+looping | 6x3 | 8x10 | 5 | 0 | 4/8.6/15 | 8.8 | 2.0 | 2.8 | 0.8 | 33.4 | 5 | oui |
| 98 | purity_core | procedural | mixed+large_rooms+looping | 6x5 | 12x12 | 5 | 0 | 5/11.4/18 | 13.8 | 4.0 | 1.2 | 2.6 | 35.4 | 5 | oui |
| 99 | purity_core | procedural | mixed+large_rooms+looping | 7x3 | 12x11 | 5 | 0 | 6/9.4/14 | 10.8 | 3.0 | 2.4 | 1.4 | 38.6 | 5 | oui |
