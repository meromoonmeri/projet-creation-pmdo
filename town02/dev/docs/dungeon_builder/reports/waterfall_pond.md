# Rapport de génération — Waterfall Pond

- **ID** : `waterfall_pond`  
- **Chapitre** : 26 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Waterfall Pond (19F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/WaterfallPond) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 26. Recoupé avec Bulbapedia (page « Waterfall Pond »).  
- **Étages** : 19 — direction `fond`  
- **Zone écrite** : `Data/Zone/waterfall_pond.json`  
- **Seed d'auteur (debug)** : `1993927611505303333` (explicite : False)  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| pond_shore | 1-10 | pond_shore | `unused_waterfall_pond_floor` | looping, ring, mixed | 12 | oui | oui | — |
| pond_depths | 11-19 | pond_depths | `unused_waterfall_pond_floor` | ring, lattice, looping | 11 | oui | oui | — |

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
| 1 | pond_shore | procedural | looping+ring+mixed | 4x3 | 11x10 | 5 | 0 | 8/9.0/11 | 14.8 | 4.0 | 1.2 | 2.6 | 38.4 | 5 | oui |
| 2 | pond_shore | procedural | looping+ring+mixed | 4x4 | 12x10 | 5 | 0 | 7/10.8/21 | 15.8 | 4.6 | 1.4 | 2.6 | 29.8 | 5 | oui |
| 3 | pond_shore | procedural | looping+ring+mixed | 5x4 | 10x9 | 5 | 0 | 6/10.6/16 | 15.6 | 3.0 | 1.8 | 1.8 | 43.8 | 5 | oui |
| 4 | pond_shore | procedural | looping+ring+mixed | 5x3 | 12x9 | 5 | 0 | 7/9.8/14 | 15.4 | 3.4 | 0.6 | 2.6 | 50.0 | 5 | oui |
| 5 | pond_shore | procedural | looping+ring+mixed | 4x3 | 12x10 | 5 | 0 | 6/9.6/13 | 13.6 | 2.6 | 1.8 | 1.4 | 38.8 | 5 | oui |
| 6 | pond_shore | procedural | looping+ring+mixed | 7x3 | 8x9 | 5 | 0 | 6/9.6/18 | 13.4 | 2.8 | 1.6 | 1.6 | 46.0 | 5 | oui |
| 7 | pond_shore | procedural | looping+ring+mixed | 5x3 | 12x10 | 5 | 0 | 5/10.0/15 | 15.6 | 3.4 | 1.4 | 2.2 | 41.8 | 5 | oui |
| 8 | pond_shore | procedural | looping+ring+mixed | 5x4 | 9x8 | 5 | 1 | 6/11.6/20 | 16.8 | 4.6 | 1.0 | 3.0 | 43.0 | 5 | oui |
| 9 | pond_shore | procedural | looping+ring+mixed | 5x3 | 12x9 | 5 | 1 | 8/11.2/13 | 15.6 | 4.2 | 1.8 | 2.6 | 40.0 | 5 | oui |
| 10 | pond_shore | procedural | looping+ring+mixed | 4x5 | 8x8 | 5 | 1 | 5/9.8/16 | 15.0 | 3.0 | 1.4 | 1.8 | 34.2 | 5 | oui |
| 11 | pond_depths | procedural | ring+lattice+looping | 4x4 | 10x8 | 5 | 0 | 7/9.4/12 | 14.8 | 3.4 | 2.6 | 2.0 | 43.2 | 5 | oui |
| 12 | pond_depths | procedural | ring+lattice+looping | 4x3 | 12x8 | 5 | 0 | 8/8.8/10 | 17.0 | 4.6 | 1.6 | 3.2 | 53.8 | 5 | oui |
| 13 | pond_depths | procedural | ring+lattice+looping | 5x3 | 9x10 | 5 | 0 | 5/8.0/10 | 17.2 | 4.4 | 3.0 | 2.6 | 43.2 | 5 | oui |
| 14 | pond_depths | procedural | ring+lattice+looping | 5x3 | 10x10 | 5 | 0 | 4/7.8/10 | 12.4 | 2.2 | 1.8 | 1.4 | 37.4 | 5 | oui |
| 15 | pond_depths | procedural | ring+lattice+looping | 4x5 | 12x9 | 5 | 1 | 7/9.6/15 | 14.8 | 3.2 | 1.0 | 2.4 | 43.0 | 5 | oui |
| 16 | pond_depths | procedural | ring+lattice+looping | 6x3 | 9x8 | 5 | 0 | 7/9.0/12 | 17.0 | 4.4 | 2.0 | 2.8 | 45.2 | 5 | oui |
| 17 | pond_depths | procedural | ring+lattice+looping | 5x3 | 9x8 | 5 | 1 | 9/10.8/16 | 16.4 | 3.8 | 1.6 | 2.4 | 46.0 | 5 | oui |
| 18 | pond_depths | procedural | ring+lattice+looping | 5x3 | 10x9 | 5 | 0 | 5/9.6/12 | 18.4 | 5.2 | 3.2 | 3.0 | 40.2 | 5 | oui |
| 19 | pond_depths | procedural | ring+lattice+looping | 4x4 | 11x8 | 5 | 1 | 6/8.0/10 | 16.8 | 5.2 | 2.2 | 3.6 | 38.0 | 5 | oui |
