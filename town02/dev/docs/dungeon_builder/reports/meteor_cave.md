# Rapport de génération — Meteor Cave

- **ID** : `meteor_cave`  
- **Chapitre** : 14 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Meteor Cave (20F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/MeteorCave) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 14. Recoupé avec Bulbapedia (page « Meteor Cave »).  
- **Étages** : 20 — direction `fond`  
- **Zone écrite** : `Data/Zone/meteor_cave.json`  
- **Seed d'auteur (debug)** : `3760974074876992205` (explicite : False)  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| meteor_shell | 1-10 | meteor_shell | `spacial_rift_1_floor` | branching, mixed, dense | 3 | oui | oui | — |
| meteor_core | 11-20 | meteor_core | `spacial_rift_1_floor` | looping, lattice, mixed | 4 | oui | oui | — |

## Scènes fixes

- entrée : `—`
- midpoint : `—`
- Ground de fin : `—`
- boss : mode `arena_rsmap` → Ground `—`, rsmap `meteor_cave_arena`
  - no fixed 'entrance' Ground declared
  - no fixed 'mid' Ground declared
  - no fixed 'end' Ground declared
  - dedicated arena scene: meteor_cave_arena.rsmap (source of truth) → to be converted into a boss Ground

## Étages

| Ét. | Segment | Type | Profil | Grille | Cellule | Variantes OK | Rejets | Rooms (min/moy/max) | Halls | Branches | Culs-de-sac | Boucles | Dist. escaliers | Signatures | Traversable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | meteor_shell | procedural | branching+mixed+dense | 6x3 | 11x10 | 5 | 0 | 10/14.2/24 | 17.2 | 5.2 | 3.8 | 1.8 | 45.2 | 5 | oui |
| 2 | meteor_shell | procedural | branching+mixed+dense | 6x3 | 11x8 | 5 | 1 | 11/19.6/32 | 23.2 | 7.2 | 5.4 | 2.4 | 47.8 | 5 | oui |
| 3 | meteor_shell | procedural | branching+mixed+dense | 4x4 | 12x8 | 5 | 1 | 8/11.0/14 | 12.0 | 3.2 | 2.6 | 1.4 | 33.8 | 5 | oui |
| 4 | meteor_shell | procedural | branching+mixed+dense | 4x4 | 10x11 | 5 | 0 | 11/13.8/19 | 16.4 | 4.6 | 3.4 | 1.6 | 43.4 | 5 | oui |
| 5 | meteor_shell | procedural | branching+mixed+dense | 5x4 | 12x10 | 5 | 0 | 9/14.0/23 | 15.6 | 4.8 | 4.4 | 1.6 | 38.6 | 5 | oui |
| 6 | meteor_shell | procedural | branching+mixed+dense | 7x4 | 9x7 | 5 | 0 | 12/16.8/23 | 20.2 | 6.4 | 3.0 | 2.8 | 39.0 | 5 | oui |
| 7 | meteor_shell | procedural | branching+mixed+dense | 5x4 | 9x10 | 5 | 0 | 14/15.8/19 | 18.6 | 6.4 | 4.0 | 2.2 | 42.8 | 5 | oui |
| 8 | meteor_shell | procedural | branching+mixed+dense | 4x4 | 12x9 | 5 | 0 | 10/13.4/21 | 14.6 | 4.4 | 4.6 | 1.2 | 38.0 | 5 | oui |
| 9 | meteor_shell | procedural | branching+mixed+dense | 6x5 | 8x12 | 5 | 1 | 8/15.6/31 | 18.8 | 5.6 | 4.6 | 2.0 | 35.8 | 5 | oui |
| 10 | meteor_shell | procedural | branching+mixed+dense | 7x5 | 9x7 | 5 | 0 | 11/18.0/25 | 21.2 | 6.8 | 6.0 | 2.2 | 40.2 | 5 | oui |
| 11 | meteor_core | procedural | looping+lattice+mixed | 5x3 | 11x10 | 5 | 2 | 7/10.2/14 | 15.4 | 5.2 | 4.2 | 2.4 | 48.6 | 5 | oui |
| 12 | meteor_core | procedural | looping+lattice+mixed | 4x3 | 12x10 | 5 | 1 | 9/11.0/15 | 18.0 | 5.4 | 2.6 | 3.4 | 31.8 | 5 | oui |
| 13 | meteor_core | procedural | looping+lattice+mixed | 5x3 | 9x9 | 5 | 2 | 9/9.4/11 | 12.6 | 3.8 | 2.6 | 2.0 | 30.4 | 5 | oui |
| 14 | meteor_core | procedural | looping+lattice+mixed | 4x3 | 10x9 | 5 | 0 | 9/11.0/14 | 15.0 | 3.8 | 3.0 | 2.0 | 47.0 | 5 | oui |
| 15 | meteor_core | procedural | looping+lattice+mixed | 5x3 | 13x11 | 5 | 0 | 9/10.0/12 | 14.6 | 4.8 | 2.2 | 2.6 | 35.6 | 5 | oui |
| 16 | meteor_core | procedural | looping+lattice+mixed | 5x5 | 14x8 | 5 | 0 | 5/10.8/18 | 14.4 | 4.6 | 3.0 | 2.2 | 37.8 | 5 | oui |
| 17 | meteor_core | procedural | looping+lattice+mixed | 7x4 | 12x7 | 5 | 0 | 5/10.0/14 | 15.6 | 4.2 | 2.6 | 2.8 | 42.6 | 5 | oui |
| 18 | meteor_core | procedural | looping+lattice+mixed | 4x4 | 11x9 | 5 | 1 | 8/11.2/15 | 15.6 | 4.8 | 1.8 | 2.8 | 42.2 | 5 | oui |
| 19 | meteor_core | procedural | looping+lattice+mixed | 7x5 | 10x11 | 5 | 1 | 9/10.8/12 | 16.6 | 5.6 | 2.8 | 3.0 | 48.0 | 5 | oui |
