# Rapport de génération — Murky Cave

- **ID** : `murky_cave`  
- **Chapitre** : 21 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Murky Cave (19F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/MurkyCave) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 21. Recoupé avec Bulbapedia (page « Murky Cave »).  
- **Étages** : 19 — direction `fond`  
- **Zone écrite** : `Data/Zone/murky_cave.json`  
- **Seed d'auteur (debug)** : `5289380585744237490` (explicite : False)  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| murky_gallery | 1-10 | murky_gallery | `murky_cave_floor` | branching, mixed, dense | 9 | oui | oui | — |
| murky_depths | 11-19 | murky_depths | `murky_cave_floor` | looping, lattice, mixed | 8 | oui | oui | — |

## Scènes fixes

- entrée : `—`
- midpoint : `—`
- Ground de fin : `caverne_trouble_fond`
- boss : mode `canonical_ground` → Ground `caverne_trouble_fond`, rsmap `—`
  - no fixed 'entrance' Ground declared
  - no fixed 'mid' Ground declared
  - final battle stays on the canonical end Ground 'caverne_trouble_fond' (no separate arena created)

## Étages

| Ét. | Segment | Type | Profil | Grille | Cellule | Variantes OK | Rejets | Rooms (min/moy/max) | Halls | Branches | Culs-de-sac | Boucles | Dist. escaliers | Signatures | Traversable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | murky_gallery | procedural | branching+mixed+dense | 6x4 | 12x8 | 5 | 1 | 6/12.0/22 | 12.4 | 3.2 | 3.2 | 1.0 | 40.0 | 5 | oui |
| 2 | murky_gallery | procedural | branching+mixed+dense | 5x5 | 14x11 | 5 | 0 | 13/17.8/26 | 20.0 | 6.0 | 6.0 | 1.6 | 41.6 | 5 | oui |
| 3 | murky_gallery | procedural | branching+mixed+dense | 4x5 | 9x9 | 5 | 1 | 8/11.0/14 | 10.8 | 2.6 | 4.0 | 0.4 | 35.0 | 5 | oui |
| 4 | murky_gallery | procedural | branching+mixed+dense | 6x3 | 11x10 | 5 | 0 | 8/15.8/22 | 19.0 | 5.0 | 4.2 | 1.8 | 38.6 | 5 | oui |
| 5 | murky_gallery | procedural | branching+mixed+dense | 5x5 | 11x7 | 5 | 0 | 9/13.6/19 | 14.6 | 4.6 | 4.2 | 1.2 | 41.0 | 5 | oui |
| 6 | murky_gallery | procedural | branching+mixed+dense | 5x3 | 12x12 | 5 | 1 | 10/13.8/17 | 14.2 | 4.2 | 4.4 | 1.0 | 41.6 | 5 | oui |
| 7 | murky_gallery | procedural | branching+mixed+dense | 6x5 | 8x6 | 5 | 0 | 10/17.8/29 | 20.4 | 5.8 | 4.4 | 2.2 | 36.6 | 5 | oui |
| 8 | murky_gallery | procedural | branching+mixed+dense | 5x4 | 11x8 | 5 | 1 | 10/13.0/15 | 13.4 | 4.0 | 4.6 | 0.8 | 42.2 | 5 | oui |
| 9 | murky_gallery | procedural | branching+mixed+dense | 4x3 | 11x9 | 5 | 1 | 8/12.2/14 | 12.4 | 3.8 | 4.4 | 0.8 | 44.6 | 5 | oui |
| 10 | murky_gallery | procedural | branching+mixed+dense | 4x3 | 9x9 | 5 | 0 | 8/14.8/26 | 17.0 | 4.6 | 3.8 | 1.8 | 39.8 | 5 | oui |
| 11 | murky_depths | procedural | looping+lattice+mixed | 5x3 | 10x10 | 5 | 1 | 8/12.8/19 | 17.6 | 6.8 | 2.4 | 3.6 | 53.4 | 5 | oui |
| 12 | murky_depths | procedural | looping+lattice+mixed | 7x3 | 13x8 | 5 | 2 | 7/11.6/24 | 15.6 | 4.2 | 2.2 | 2.4 | 35.4 | 5 | oui |
| 13 | murky_depths | procedural | looping+lattice+mixed | 7x5 | 9x8 | 5 | 0 | 5/8.2/10 | 10.4 | 2.8 | 2.6 | 1.2 | 37.2 | 5 | oui |
| 14 | murky_depths | procedural | looping+lattice+mixed | 4x3 | 9x10 | 5 | 1 | 8/12.8/26 | 17.2 | 4.8 | 2.0 | 2.8 | 38.4 | 5 | oui |
| 15 | murky_depths | procedural | looping+lattice+mixed | 5x3 | 12x8 | 5 | 1 | 6/8.8/11 | 14.6 | 5.0 | 1.6 | 3.2 | 30.4 | 5 | oui |
| 16 | murky_depths | procedural | looping+lattice+mixed | 4x5 | 14x7 | 5 | 1 | 7/9.2/12 | 10.8 | 2.4 | 1.6 | 1.6 | 40.0 | 5 | oui |
| 17 | murky_depths | procedural | looping+lattice+mixed | 5x4 | 12x9 | 5 | 1 | 6/10.2/16 | 16.4 | 6.4 | 4.0 | 3.0 | 44.0 | 5 | oui |
| 18 | murky_depths | procedural | looping+lattice+mixed | 5x5 | 10x9 | 5 | 0 | 6/10.0/12 | 15.8 | 5.0 | 2.0 | 3.2 | 49.4 | 5 | oui |
| 19 | murky_depths | procedural | looping+lattice+mixed | 4x4 | 10x9 | 5 | 0 | 8/10.2/14 | 14.4 | 4.8 | 2.6 | 2.6 | 45.2 | 5 | oui |
