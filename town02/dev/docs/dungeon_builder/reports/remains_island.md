# Rapport de génération — Remains Island

- **ID** : `remains_island`  
- **Chapitre** : 23 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Remains Island (20F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/RemainsIsland) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 23. Recoupé avec Bulbapedia (page « Remains Island »).  
- **Étages** : 20 — direction `fond`  
- **Zone écrite** : `Data/Zone/remains_island.json`  
- **Seed d'auteur (debug)** : `7467923991188863663` (explicite : False)  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| remains_shore | 1-10 | remains_shore | `concealed_ruins_floor` | crossroads, lattice, mixed | 16 | oui | oui | — |
| remains_ruins | 11-20 | remains_ruins | `concealed_ruins_floor` | lattice, looping, dense | 11 | oui | oui | — |

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
| 1 | remains_shore | procedural | crossroads+lattice+mixed | 6x3 | 10x8 | 5 | 0 | 5/8.6/15 | 10.0 | 2.2 | 3.8 | 0.8 | 42.8 | 5 | oui |
| 2 | remains_shore | procedural | crossroads+lattice+mixed | 7x4 | 10x8 | 5 | 1 | 8/9.6/13 | 14.2 | 4.6 | 3.4 | 2.2 | 42.0 | 5 | oui |
| 3 | remains_shore | procedural | crossroads+lattice+mixed | 7x5 | 12x12 | 5 | 0 | 7/10.4/19 | 14.6 | 4.6 | 3.4 | 2.6 | 52.0 | 5 | oui |
| 4 | remains_shore | procedural | crossroads+lattice+mixed | 6x5 | 12x9 | 5 | 0 | 8/10.6/17 | 13.2 | 3.2 | 4.2 | 1.2 | 40.6 | 5 | oui |
| 5 | remains_shore | procedural | crossroads+lattice+mixed | 6x3 | 10x9 | 5 | 0 | 7/8.6/11 | 11.6 | 3.0 | 3.0 | 1.6 | 40.4 | 5 | oui |
| 6 | remains_shore | procedural | crossroads+lattice+mixed | 5x5 | 12x8 | 5 | 0 | 9/10.8/14 | 17.8 | 5.2 | 3.8 | 3.4 | 37.8 | 5 | oui |
| 7 | remains_shore | procedural | crossroads+lattice+mixed | 5x5 | 11x11 | 5 | 0 | 7/11.0/15 | 17.4 | 5.8 | 4.4 | 3.0 | 48.2 | 5 | oui |
| 8 | remains_shore | procedural | crossroads+lattice+mixed | 5x3 | 12x8 | 5 | 1 | 7/11.8/18 | 19.8 | 6.6 | 3.4 | 4.0 | 49.2 | 5 | oui |
| 9 | remains_shore | procedural | crossroads+lattice+mixed | 4x4 | 9x9 | 5 | 0 | 8/10.6/14 | 15.0 | 4.8 | 4.4 | 2.2 | 44.0 | 5 | oui |
| 10 | remains_shore | procedural | crossroads+lattice+mixed | 5x4 | 12x9 | 5 | 0 | 5/10.6/16 | 15.0 | 4.4 | 4.4 | 2.2 | 42.2 | 5 | oui |
| 11 | remains_ruins | procedural | lattice+looping+dense | 4x4 | 10x9 | 5 | 0 | 7/14.6/33 | 22.4 | 7.6 | 3.4 | 4.2 | 46.4 | 5 | oui |
| 12 | remains_ruins | procedural | lattice+looping+dense | 4x4 | 11x8 | 5 | 0 | 9/11.4/15 | 18.4 | 5.8 | 2.6 | 3.4 | 47.0 | 5 | oui |
| 13 | remains_ruins | procedural | lattice+looping+dense | 6x4 | 12x9 | 5 | 0 | 10/13.0/21 | 20.2 | 6.4 | 4.0 | 2.8 | 39.2 | 5 | oui |
| 14 | remains_ruins | procedural | lattice+looping+dense | 5x4 | 11x10 | 5 | 0 | 8/13.2/19 | 18.8 | 5.6 | 4.0 | 2.8 | 52.0 | 5 | oui |
| 15 | remains_ruins | procedural | lattice+looping+dense | 4x4 | 11x8 | 5 | 0 | 5/11.2/21 | 17.2 | 5.6 | 2.4 | 3.2 | 42.4 | 5 | oui |
| 16 | remains_ruins | procedural | lattice+looping+dense | 5x3 | 9x9 | 5 | 0 | 8/12.8/26 | 19.0 | 6.8 | 3.6 | 3.2 | 38.0 | 5 | oui |
| 17 | remains_ruins | procedural | lattice+looping+dense | 4x5 | 9x8 | 5 | 2 | 9/9.8/11 | 14.6 | 6.0 | 3.8 | 2.6 | 47.4 | 5 | oui |
| 18 | remains_ruins | procedural | lattice+looping+dense | 4x3 | 9x8 | 5 | 0 | 4/11.0/19 | 14.6 | 4.6 | 3.4 | 1.8 | 30.6 | 5 | oui |
| 19 | remains_ruins | procedural | lattice+looping+dense | 5x3 | 11x9 | 5 | 0 | 8/11.6/22 | 17.2 | 4.6 | 3.4 | 2.6 | 44.4 | 5 | oui |
| 20 | remains_ruins | procedural | lattice+looping+dense | 5x3 | 11x8 | 5 | 0 | 7/10.8/19 | 15.0 | 5.2 | 3.0 | 2.6 | 39.2 | 5 | oui |
