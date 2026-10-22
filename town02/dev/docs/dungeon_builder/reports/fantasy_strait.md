# Rapport de génération — Fantasy Strait

- **ID** : `fantasy_strait`  
- **Chapitre** : 24 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Fantasy Strait (30F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/FantasyStrait) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 24. Recoupé avec Bulbapedia (page « Fantasy Strait »).  
- **Étages** : 30 — direction `fond`  
- **Zone écrite** : `Data/Zone/fantasy_strait.json`  
- **Seed d'auteur (debug)** : `6506444204159245677` (explicite : False)  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| strait_shelf | 1-15 | strait_shelf | `craggy_coast_floor` | looping, ring, mixed | 15 | oui | oui | — |
| strait_deep | 16-30 | strait_deep | `craggy_coast_floor` | ring, lattice, looping | 14 | oui | oui | — |

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
| 1 | strait_shelf | procedural | looping+ring+mixed | 4x3 | 9x12 | 5 | 0 | 7/11.6/24 | 17.0 | 4.0 | 2.2 | 2.0 | 39.6 | 5 | oui |
| 2 | strait_shelf | procedural | looping+ring+mixed | 7x5 | 8x11 | 5 | 0 | 5/8.6/15 | 13.2 | 3.0 | 1.4 | 1.8 | 38.0 | 5 | oui |
| 3 | strait_shelf | procedural | looping+ring+mixed | 4x3 | 10x10 | 5 | 0 | 5/9.0/13 | 13.2 | 3.6 | 1.4 | 2.2 | 35.2 | 5 | oui |
| 4 | strait_shelf | procedural | looping+ring+mixed | 7x5 | 13x7 | 5 | 1 | 6/9.4/11 | 14.4 | 2.6 | 1.6 | 1.8 | 39.4 | 5 | oui |
| 5 | strait_shelf | procedural | looping+ring+mixed | 4x3 | 9x10 | 5 | 0 | 5/9.8/22 | 14.4 | 3.6 | 1.2 | 2.6 | 38.4 | 5 | oui |
| 6 | strait_shelf | procedural | looping+ring+mixed | 5x3 | 9x9 | 5 | 0 | 6/10.8/15 | 15.2 | 4.0 | 1.6 | 2.4 | 36.4 | 5 | oui |
| 7 | strait_shelf | procedural | looping+ring+mixed | 5x4 | 9x10 | 5 | 0 | 7/10.0/13 | 14.0 | 3.4 | 1.4 | 2.0 | 47.6 | 5 | oui |
| 8 | strait_shelf | procedural | looping+ring+mixed | 4x4 | 10x10 | 5 | 1 | 5/8.8/12 | 14.0 | 2.8 | 1.0 | 2.0 | 35.4 | 5 | oui |
| 9 | strait_shelf | procedural | looping+ring+mixed | 4x3 | 10x8 | 5 | 0 | 6/9.0/16 | 15.0 | 3.8 | 1.6 | 2.4 | 39.2 | 5 | oui |
| 10 | strait_shelf | procedural | looping+ring+mixed | 4x3 | 9x8 | 5 | 1 | 6/9.4/12 | 15.8 | 3.6 | 1.0 | 2.4 | 32.2 | 5 | oui |
| 11 | strait_shelf | procedural | looping+ring+mixed | 4x5 | 10x10 | 5 | 1 | 7/11.6/22 | 15.8 | 4.0 | 1.6 | 2.4 | 47.0 | 5 | oui |
| 12 | strait_shelf | procedural | looping+ring+mixed | 4x3 | 11x9 | 5 | 0 | 5/8.6/12 | 13.6 | 2.8 | 1.4 | 1.8 | 39.6 | 5 | oui |
| 13 | strait_shelf | procedural | looping+ring+mixed | 4x3 | 9x9 | 5 | 0 | 8/9.4/10 | 13.6 | 2.6 | 1.0 | 1.8 | 43.2 | 5 | oui |
| 14 | strait_shelf | procedural | looping+ring+mixed | 4x3 | 12x9 | 5 | 2 | 6/9.2/13 | 11.8 | 2.8 | 1.2 | 1.8 | 40.0 | 5 | oui |
| 15 | strait_shelf | procedural | looping+ring+mixed | 5x4 | 11x9 | 5 | 0 | 7/10.2/16 | 14.8 | 2.8 | 1.2 | 2.0 | 50.2 | 5 | oui |
| 16 | strait_deep | procedural | ring+lattice+looping | 5x4 | 10x10 | 5 | 0 | 6/8.2/12 | 13.8 | 4.0 | 1.8 | 2.4 | 38.8 | 5 | oui |
| 17 | strait_deep | procedural | ring+lattice+looping | 5x5 | 10x9 | 5 | 0 | 5/6.8/9 | 10.8 | 2.2 | 1.8 | 1.2 | 36.4 | 5 | oui |
| 18 | strait_deep | procedural | ring+lattice+looping | 5x4 | 10x8 | 5 | 0 | 5/8.4/12 | 13.6 | 3.2 | 1.2 | 2.2 | 37.6 | 5 | oui |
| 19 | strait_deep | procedural | ring+lattice+looping | 4x4 | 11x8 | 5 | 1 | 5/9.6/15 | 18.6 | 6.0 | 1.8 | 3.8 | 30.8 | 5 | oui |
| 20 | strait_deep | procedural | ring+lattice+looping | 5x4 | 9x9 | 5 | 0 | 6/8.4/11 | 15.6 | 4.6 | 2.6 | 2.6 | 41.4 | 5 | oui |
| 21 | strait_deep | procedural | ring+lattice+looping | 4x3 | 9x8 | 5 | 0 | 7/9.8/16 | 15.6 | 4.0 | 2.6 | 2.2 | 46.8 | 5 | oui |
| 22 | strait_deep | procedural | ring+lattice+looping | 4x5 | 10x9 | 5 | 1 | 7/8.2/10 | 15.8 | 4.2 | 1.2 | 2.8 | 35.0 | 5 | oui |
| 23 | strait_deep | procedural | ring+lattice+looping | 5x4 | 10x10 | 5 | 1 | 7/10.2/14 | 17.0 | 4.0 | 1.2 | 2.8 | 45.6 | 5 | oui |
| 24 | strait_deep | procedural | ring+lattice+looping | 5x3 | 10x10 | 5 | 2 | 9/9.6/11 | 15.0 | 4.2 | 2.0 | 2.4 | 41.0 | 5 | oui |
| 25 | strait_deep | procedural | ring+lattice+looping | 4x3 | 9x9 | 5 | 0 | 5/6.8/9 | 11.8 | 2.4 | 1.2 | 1.6 | 39.4 | 5 | oui |
| 26 | strait_deep | procedural | ring+lattice+looping | 4x4 | 9x10 | 5 | 0 | 7/9.4/11 | 17.2 | 5.0 | 2.2 | 3.2 | 47.6 | 5 | oui |
| 27 | strait_deep | procedural | ring+lattice+looping | 5x4 | 9x10 | 5 | 2 | 7/9.4/14 | 16.8 | 3.8 | 0.8 | 2.8 | 37.2 | 5 | oui |
| 28 | strait_deep | procedural | ring+lattice+looping | 5x4 | 11x9 | 5 | 1 | 8/9.0/11 | 16.2 | 5.8 | 2.6 | 3.2 | 55.6 | 5 | oui |
| 29 | strait_deep | procedural | ring+lattice+looping | 4x4 | 9x9 | 5 | 1 | 7/10.0/12 | 17.0 | 4.6 | 1.6 | 2.8 | 30.6 | 5 | oui |
| 30 | strait_deep | procedural | ring+lattice+looping | 4x4 | 10x9 | 5 | 1 | 4/8.0/15 | 14.0 | 3.4 | 1.2 | 2.2 | 34.8 | 5 | oui |
