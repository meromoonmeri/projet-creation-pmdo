# Rapport de génération — Oddity Cave

- **ID** : `oddity_cave`  
- **Chapitre** : 22 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Oddity Cave (15F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/OddityCave) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 22. Recoupé avec Bulbapedia (page « Oddity Cave »).  
- **Étages** : 15 — direction `fond`  
- **Zone écrite** : `Data/Zone/oddity_cave.json`  
- **Seed d'auteur (debug)** : `2834984438898067140` (explicite : False)  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| oddity_gallery | 1-8 | oddity_gallery | `spacial_rift_2_floor` | branching, mixed, dense | 14 | oui | oui | — |
| oddity_core | 9-15 | oddity_core | `spacial_rift_2_floor` | looping, lattice, mixed | 10 | oui | oui | — |

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
| 1 | oddity_gallery | procedural | branching+mixed+dense | 8x5 | 7x7 | 5 | 1 | 8/10.4/17 | 10.4 | 2.8 | 3.6 | 0.8 | 34.6 | 5 | oui |
| 2 | oddity_gallery | procedural | branching+mixed+dense | 5x3 | 11x11 | 5 | 1 | 11/15.6/22 | 19.0 | 5.0 | 3.4 | 2.2 | 38.2 | 5 | oui |
| 3 | oddity_gallery | procedural | branching+mixed+dense | 7x5 | 9x6 | 5 | 0 | 11/17.0/30 | 19.8 | 5.8 | 4.8 | 1.8 | 50.0 | 5 | oui |
| 4 | oddity_gallery | procedural | branching+mixed+dense | 8x5 | 7x6 | 5 | 1 | 8/16.6/24 | 19.6 | 5.8 | 5.0 | 2.0 | 32.0 | 5 | oui |
| 5 | oddity_gallery | procedural | branching+mixed+dense | 4x3 | 10x9 | 5 | 0 | 8/15.8/25 | 17.2 | 5.4 | 5.2 | 1.4 | 40.4 | 5 | oui |
| 6 | oddity_gallery | procedural | branching+mixed+dense | 6x4 | 12x10 | 5 | 2 | 7/15.0/30 | 16.8 | 4.2 | 3.0 | 2.0 | 37.8 | 5 | oui |
| 7 | oddity_gallery | procedural | branching+mixed+dense | 4x4 | 12x9 | 5 | 0 | 6/14.6/21 | 17.8 | 5.0 | 4.0 | 2.0 | 38.0 | 5 | oui |
| 8 | oddity_gallery | procedural | branching+mixed+dense | 6x4 | 12x9 | 5 | 2 | 6/12.4/23 | 13.8 | 4.2 | 3.6 | 1.6 | 38.4 | 5 | oui |
| 9 | oddity_core | procedural | looping+lattice+mixed | 5x3 | 10x8 | 5 | 0 | 8/13.8/23 | 22.4 | 7.0 | 3.2 | 4.2 | 44.0 | 5 | oui |
| 10 | oddity_core | procedural | looping+lattice+mixed | 5x4 | 9x10 | 5 | 0 | 7/10.6/13 | 13.6 | 4.2 | 2.6 | 2.0 | 44.8 | 5 | oui |
| 11 | oddity_core | procedural | looping+lattice+mixed | 6x5 | 10x10 | 5 | 1 | 7/9.0/12 | 12.2 | 3.2 | 3.4 | 1.4 | 32.0 | 5 | oui |
| 12 | oddity_core | procedural | looping+lattice+mixed | 5x5 | 12x9 | 5 | 3 | 4/9.0/11 | 11.4 | 3.2 | 2.6 | 1.4 | 36.6 | 5 | oui |
| 13 | oddity_core | procedural | looping+lattice+mixed | 4x5 | 12x9 | 5 | 0 | 8/10.4/12 | 17.2 | 5.8 | 2.2 | 3.8 | 32.2 | 5 | oui |
| 14 | oddity_core | procedural | looping+lattice+mixed | 5x4 | 12x8 | 5 | 0 | 8/11.4/17 | 14.6 | 4.8 | 3.4 | 2.0 | 36.2 | 5 | oui |
| 15 | oddity_core | procedural | looping+lattice+mixed | 5x5 | 8x8 | 5 | 0 | 9/11.0/15 | 18.4 | 6.2 | 2.6 | 3.8 | 49.0 | 5 | oui |
