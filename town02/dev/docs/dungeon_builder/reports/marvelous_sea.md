# Rapport de génération — Marvelous Sea

- **ID** : `marvelous_sea`  
- **Chapitre** : 23 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Marvelous Sea (20F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/MarvelousSea) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 23. Recoupé avec Bulbapedia (page « Marvelous Sea »).  
- **Étages** : 20 — direction `fond`  
- **Zone écrite** : `Data/Zone/marvelous_sea.json`  
- **Seed d'auteur (debug)** : `3268811124586862566` (explicite : False)  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| marvelous_shelf | 1-10 | marvelous_shelf | `miracle_sea_floor` | looping, ring, mixed | 8 | oui | oui | — |
| marvelous_deep | 11-20 | marvelous_deep | `miracle_sea_floor` | ring, lattice, looping | 7 | oui | oui | — |

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
| 1 | marvelous_shelf | procedural | looping+ring+mixed | 7x5 | 8x12 | 5 | 0 | 7/7.8/8 | 10.4 | 2.0 | 1.6 | 1.2 | 42.6 | 5 | oui |
| 2 | marvelous_shelf | procedural | looping+ring+mixed | 7x5 | 12x10 | 5 | 2 | 8/11.0/19 | 15.6 | 4.8 | 1.0 | 3.2 | 36.2 | 5 | oui |
| 3 | marvelous_shelf | procedural | looping+ring+mixed | 5x3 | 10x9 | 5 | 0 | 9/9.2/10 | 13.4 | 3.2 | 1.4 | 2.0 | 45.0 | 5 | oui |
| 4 | marvelous_shelf | procedural | looping+ring+mixed | 4x4 | 10x9 | 5 | 0 | 6/10.0/14 | 15.0 | 3.6 | 2.0 | 1.8 | 32.6 | 5 | oui |
| 5 | marvelous_shelf | procedural | looping+ring+mixed | 4x3 | 10x8 | 5 | 0 | 8/11.8/15 | 16.2 | 3.2 | 1.4 | 2.2 | 35.2 | 5 | oui |
| 6 | marvelous_shelf | procedural | looping+ring+mixed | 7x3 | 9x10 | 5 | 0 | 10/12.0/16 | 17.0 | 4.6 | 1.0 | 3.0 | 29.0 | 5 | oui |
| 7 | marvelous_shelf | procedural | looping+ring+mixed | 6x3 | 13x12 | 5 | 0 | 8/11.2/17 | 14.8 | 3.6 | 2.2 | 1.8 | 39.4 | 5 | oui |
| 8 | marvelous_shelf | procedural | looping+ring+mixed | 4x4 | 11x9 | 5 | 1 | 8/11.6/18 | 15.2 | 4.0 | 1.8 | 2.2 | 44.0 | 5 | oui |
| 9 | marvelous_shelf | procedural | looping+ring+mixed | 4x3 | 11x8 | 5 | 0 | 7/10.6/19 | 15.4 | 3.0 | 1.0 | 2.0 | 41.2 | 5 | oui |
| 10 | marvelous_shelf | procedural | looping+ring+mixed | 4x4 | 9x10 | 5 | 0 | 6/8.6/13 | 12.2 | 2.4 | 2.0 | 1.2 | 40.0 | 5 | oui |
| 11 | marvelous_deep | procedural | ring+lattice+looping | 4x3 | 12x10 | 5 | 1 | 8/9.4/12 | 15.0 | 3.8 | 1.2 | 2.6 | 37.4 | 5 | oui |
| 12 | marvelous_deep | procedural | ring+lattice+looping | 4x4 | 12x8 | 5 | 1 | 7/9.4/13 | 14.8 | 3.8 | 1.6 | 2.2 | 36.2 | 5 | oui |
| 13 | marvelous_deep | procedural | ring+lattice+looping | 5x5 | 9x9 | 5 | 0 | 5/7.4/10 | 12.2 | 2.2 | 1.6 | 1.4 | 45.6 | 5 | oui |
| 14 | marvelous_deep | procedural | ring+lattice+looping | 5x4 | 10x9 | 5 | 1 | 5/7.0/9 | 13.2 | 2.4 | 1.6 | 1.6 | 42.6 | 5 | oui |
| 15 | marvelous_deep | procedural | ring+lattice+looping | 4x4 | 9x8 | 5 | 1 | 7/9.2/11 | 14.6 | 4.4 | 3.6 | 1.8 | 38.4 | 5 | oui |
| 16 | marvelous_deep | procedural | ring+lattice+looping | 4x5 | 11x9 | 5 | 0 | 7/8.2/10 | 15.6 | 3.6 | 1.8 | 2.4 | 39.8 | 5 | oui |
| 17 | marvelous_deep | procedural | ring+lattice+looping | 4x4 | 10x8 | 5 | 0 | 7/9.8/13 | 20.4 | 6.4 | 2.8 | 4.2 | 51.4 | 5 | oui |
| 18 | marvelous_deep | procedural | ring+lattice+looping | 4x3 | 11x9 | 5 | 0 | 6/8.2/10 | 15.6 | 4.0 | 1.8 | 2.8 | 48.2 | 5 | oui |
| 19 | marvelous_deep | procedural | ring+lattice+looping | 4x4 | 9x10 | 5 | 0 | 7/9.0/11 | 14.0 | 4.4 | 1.6 | 2.4 | 38.8 | 5 | oui |
| 20 | marvelous_deep | procedural | ring+lattice+looping | 4x4 | 12x10 | 5 | 0 | 8/8.4/10 | 14.6 | 3.2 | 1.6 | 2.2 | 39.4 | 5 | oui |
