# Rapport de génération — Grand Sea

- **ID** : `grand_sea`  
- **Chapitre** : 21 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Grand Sea (30F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/GrandSea) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 21. Recoupé avec Bulbapedia (page « Grand Sea »).  
- **Étages** : 30 — direction `fond`  
- **Zone écrite** : `Data/Zone/grand_sea.json`  
- **Seed d'auteur (debug)** : `436833178020881332` (explicite : False)  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| grand_shelf | 1-15 | grand_shelf | `surrounded_sea_floor` | looping, ring, mixed | 11 | oui | oui | — |
| grand_deep | 16-30 | grand_deep | `surrounded_sea_floor` | ring, lattice, looping | 12 | oui | oui | — |

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
| 1 | grand_shelf | procedural | looping+ring+mixed | 5x3 | 11x8 | 5 | 2 | 5/9.0/14 | 16.0 | 3.4 | 0.6 | 2.6 | 48.6 | 5 | oui |
| 2 | grand_shelf | procedural | looping+ring+mixed | 6x4 | 12x12 | 5 | 0 | 7/8.8/10 | 15.4 | 4.2 | 1.0 | 2.8 | 49.8 | 5 | oui |
| 3 | grand_shelf | procedural | looping+ring+mixed | 4x4 | 9x10 | 5 | 1 | 8/10.8/15 | 15.2 | 2.8 | 1.0 | 2.2 | 40.8 | 5 | oui |
| 4 | grand_shelf | procedural | looping+ring+mixed | 6x4 | 13x12 | 5 | 0 | 7/10.6/14 | 16.0 | 3.8 | 1.0 | 2.6 | 37.2 | 5 | oui |
| 5 | grand_shelf | procedural | looping+ring+mixed | 4x4 | 12x8 | 5 | 0 | 5/9.0/14 | 14.2 | 3.4 | 1.2 | 2.2 | 32.0 | 5 | oui |
| 6 | grand_shelf | procedural | looping+ring+mixed | 4x3 | 10x9 | 5 | 0 | 7/11.2/21 | 17.0 | 3.8 | 1.4 | 2.6 | 43.4 | 5 | oui |
| 7 | grand_shelf | procedural | looping+ring+mixed | 4x4 | 12x9 | 5 | 1 | 5/11.0/17 | 13.6 | 4.0 | 2.8 | 1.8 | 36.2 | 5 | oui |
| 8 | grand_shelf | procedural | looping+ring+mixed | 5x3 | 11x10 | 5 | 0 | 7/11.0/19 | 16.6 | 3.6 | 1.4 | 2.2 | 39.0 | 5 | oui |
| 9 | grand_shelf | procedural | looping+ring+mixed | 4x3 | 12x8 | 5 | 0 | 7/9.6/14 | 14.0 | 2.8 | 1.2 | 1.8 | 41.0 | 5 | oui |
| 10 | grand_shelf | procedural | looping+ring+mixed | 4x3 | 11x9 | 5 | 0 | 5/9.0/13 | 13.4 | 2.8 | 1.6 | 1.8 | 37.6 | 5 | oui |
| 11 | grand_shelf | procedural | looping+ring+mixed | 5x4 | 12x9 | 5 | 0 | 7/8.2/11 | 12.4 | 2.2 | 0.6 | 1.8 | 42.2 | 5 | oui |
| 12 | grand_shelf | procedural | looping+ring+mixed | 4x4 | 8x11 | 5 | 0 | 7/10.6/18 | 14.4 | 2.6 | 1.4 | 1.6 | 40.2 | 5 | oui |
| 13 | grand_shelf | procedural | looping+ring+mixed | 6x5 | 8x8 | 5 | 0 | 6/9.2/12 | 12.6 | 2.8 | 1.4 | 1.8 | 35.4 | 5 | oui |
| 14 | grand_shelf | procedural | looping+ring+mixed | 4x4 | 13x9 | 5 | 1 | 5/9.2/17 | 15.4 | 3.2 | 1.4 | 2.0 | 41.2 | 5 | oui |
| 15 | grand_shelf | procedural | looping+ring+mixed | 5x3 | 12x8 | 5 | 1 | 8/11.0/16 | 16.0 | 4.4 | 0.6 | 3.0 | 32.6 | 5 | oui |
| 16 | grand_deep | procedural | ring+lattice+looping | 6x3 | 11x10 | 5 | 1 | 5/10.4/16 | 16.0 | 4.4 | 2.4 | 2.2 | 49.4 | 5 | oui |
| 17 | grand_deep | procedural | ring+lattice+looping | 5x4 | 12x8 | 5 | 1 | 6/8.4/11 | 13.6 | 3.0 | 1.6 | 1.8 | 43.2 | 5 | oui |
| 18 | grand_deep | procedural | ring+lattice+looping | 5x4 | 9x9 | 5 | 1 | 7/10.2/15 | 16.0 | 3.4 | 2.2 | 1.8 | 38.4 | 5 | oui |
| 19 | grand_deep | procedural | ring+lattice+looping | 5x3 | 11x10 | 5 | 0 | 5/8.0/11 | 14.8 | 3.6 | 1.4 | 2.4 | 35.6 | 5 | oui |
| 20 | grand_deep | procedural | ring+lattice+looping | 4x4 | 10x8 | 5 | 0 | 6/9.0/14 | 15.4 | 3.2 | 1.4 | 2.4 | 37.0 | 5 | oui |
| 21 | grand_deep | procedural | ring+lattice+looping | 6x5 | 12x10 | 5 | 2 | 7/8.6/10 | 12.6 | 2.6 | 2.0 | 1.4 | 36.0 | 5 | oui |
| 22 | grand_deep | procedural | ring+lattice+looping | 5x4 | 11x8 | 5 | 0 | 5/6.8/9 | 11.2 | 2.4 | 1.8 | 1.4 | 34.0 | 5 | oui |
| 23 | grand_deep | procedural | ring+lattice+looping | 5x4 | 12x9 | 5 | 2 | 5/8.4/10 | 15.0 | 4.4 | 2.0 | 2.8 | 41.8 | 5 | oui |
| 24 | grand_deep | procedural | ring+lattice+looping | 4x4 | 10x10 | 5 | 0 | 6/9.0/12 | 14.8 | 3.0 | 2.6 | 1.6 | 31.4 | 5 | oui |
| 25 | grand_deep | procedural | ring+lattice+looping | 5x3 | 12x10 | 5 | 2 | 7/7.8/10 | 14.0 | 4.4 | 2.0 | 2.6 | 36.8 | 5 | oui |
| 26 | grand_deep | procedural | ring+lattice+looping | 5x3 | 10x8 | 5 | 2 | 8/9.4/11 | 17.0 | 5.6 | 3.8 | 3.2 | 39.4 | 5 | oui |
| 27 | grand_deep | procedural | ring+lattice+looping | 4x4 | 12x9 | 5 | 2 | 8/10.8/16 | 15.2 | 3.2 | 1.4 | 2.0 | 44.2 | 5 | oui |
| 28 | grand_deep | procedural | ring+lattice+looping | 4x4 | 11x10 | 5 | 0 | 5/8.4/13 | 19.4 | 6.0 | 2.2 | 4.2 | 45.6 | 5 | oui |
| 29 | grand_deep | procedural | ring+lattice+looping | 5x4 | 10x8 | 5 | 0 | 7/10.2/13 | 17.2 | 4.4 | 2.4 | 2.6 | 33.0 | 5 | oui |
| 30 | grand_deep | procedural | ring+lattice+looping | 4x4 | 10x8 | 5 | 0 | 6/8.4/12 | 15.2 | 3.6 | 2.2 | 2.2 | 38.4 | 5 | oui |
