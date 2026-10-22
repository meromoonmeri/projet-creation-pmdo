# Rapport de génération — Solar Cave

- **ID** : `solar_cave`  
- **Chapitre** : 19 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Solar Cave (20F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/SolarCave) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 19. Recoupé avec Bulbapedia (page « Solar Cave »).  
- **Étages** : 20 — direction `fond`  
- **Zone écrite** : `Data/Zone/solar_cave.json`  
- **Seed d'auteur (debug)** : `6818183228115747374` (explicite : False)  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| solar_gallery | 1-10 | solar_gallery | `golden_chamber_floor` | branching, mixed, dense | 14 | oui | oui | — |
| solar_heart | 11-20 | solar_heart | `golden_chamber_floor` | looping, lattice, mixed | 11 | oui | oui | — |

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
| 1 | solar_gallery | procedural | branching+mixed+dense | 5x4 | 11x8 | 5 | 2 | 8/13.8/21 | 16.0 | 4.2 | 4.0 | 1.4 | 35.8 | 5 | oui |
| 2 | solar_gallery | procedural | branching+mixed+dense | 4x3 | 10x10 | 5 | 0 | 11/13.8/20 | 16.0 | 4.8 | 4.0 | 1.8 | 37.4 | 5 | oui |
| 3 | solar_gallery | procedural | branching+mixed+dense | 6x4 | 9x10 | 5 | 1 | 10/18.4/27 | 22.4 | 7.0 | 5.6 | 2.2 | 40.0 | 5 | oui |
| 4 | solar_gallery | procedural | branching+mixed+dense | 5x5 | 14x7 | 5 | 0 | 7/15.4/25 | 17.0 | 4.6 | 4.4 | 1.6 | 50.6 | 5 | oui |
| 5 | solar_gallery | procedural | branching+mixed+dense | 4x3 | 12x8 | 5 | 1 | 7/13.8/30 | 15.8 | 4.4 | 2.8 | 2.6 | 36.0 | 5 | oui |
| 6 | solar_gallery | procedural | branching+mixed+dense | 7x3 | 9x8 | 5 | 1 | 9/16.4/29 | 18.8 | 5.8 | 5.0 | 1.8 | 45.2 | 5 | oui |
| 7 | solar_gallery | procedural | branching+mixed+dense | 5x3 | 9x8 | 5 | 1 | 11/17.4/23 | 20.6 | 6.2 | 4.4 | 2.0 | 45.2 | 5 | oui |
| 8 | solar_gallery | procedural | branching+mixed+dense | 6x4 | 7x6 | 5 | 2 | 8/12.0/20 | 13.6 | 4.2 | 3.6 | 1.8 | 33.4 | 5 | oui |
| 9 | solar_gallery | procedural | branching+mixed+dense | 5x3 | 12x7 | 5 | 0 | 8/17.2/29 | 22.0 | 6.0 | 3.0 | 3.2 | 39.2 | 5 | oui |
| 10 | solar_gallery | procedural | branching+mixed+dense | 4x3 | 9x10 | 5 | 1 | 7/10.8/17 | 11.4 | 3.6 | 4.0 | 1.2 | 34.4 | 5 | oui |
| 11 | solar_heart | procedural | looping+lattice+mixed | 6x3 | 8x9 | 5 | 0 | 9/11.8/16 | 15.0 | 4.8 | 3.2 | 2.0 | 36.0 | 5 | oui |
| 12 | solar_heart | procedural | looping+lattice+mixed | 7x5 | 8x12 | 5 | 0 | 8/11.0/17 | 16.8 | 5.4 | 1.8 | 3.4 | 44.8 | 5 | oui |
| 13 | solar_heart | procedural | looping+lattice+mixed | 5x3 | 10x10 | 5 | 0 | 6/8.2/10 | 11.6 | 3.8 | 2.0 | 2.0 | 40.0 | 5 | oui |
| 14 | solar_heart | procedural | looping+lattice+mixed | 5x4 | 12x8 | 5 | 0 | 9/11.6/15 | 15.6 | 4.0 | 3.0 | 2.2 | 40.8 | 5 | oui |
| 15 | solar_heart | procedural | looping+lattice+mixed | 5x4 | 11x9 | 5 | 0 | 9/11.8/15 | 18.6 | 7.0 | 3.0 | 3.6 | 43.8 | 5 | oui |
| 16 | solar_heart | procedural | looping+lattice+mixed | 6x5 | 9x7 | 5 | 0 | 10/11.6/16 | 20.2 | 6.6 | 2.4 | 4.6 | 48.2 | 5 | oui |
| 17 | solar_heart | procedural | looping+lattice+mixed | 4x4 | 10x9 | 5 | 2 | 5/8.8/12 | 13.0 | 3.6 | 2.0 | 2.2 | 37.0 | 5 | oui |
| 18 | solar_heart | procedural | looping+lattice+mixed | 6x4 | 12x9 | 5 | 1 | 8/10.2/15 | 14.8 | 4.2 | 1.6 | 3.0 | 36.0 | 5 | oui |
| 19 | solar_heart | procedural | looping+lattice+mixed | 5x3 | 12x9 | 5 | 0 | 5/10.8/16 | 15.8 | 5.6 | 3.2 | 2.8 | 46.8 | 5 | oui |
| 20 | solar_heart | procedural | looping+lattice+mixed | 6x5 | 12x8 | 5 | 0 | 7/13.6/27 | 21.6 | 7.4 | 2.4 | 4.6 | 45.8 | 5 | oui |
