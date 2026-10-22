# Rapport de génération — Desert Region

- **ID** : `desert_region`  
- **Chapitre** : 17 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Desert Region (20F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/DesertRegion) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 17. Recoupé avec Bulbapedia (page « Desert Region »).  
- **Étages** : 20 — direction `sommet`  
- **Zone écrite** : `Data/Zone/desert_region.json`  
- **Seed d'auteur (debug)** : `3131170500377457868` (explicite : False)  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| dunes | 1-10 | dunes | `northern_desert_1_floor` | large_rooms, twosides, mixed | 6 | oui | oui | — |
| deep_desert | 11-20 | deep_desert | `northern_desert_1_floor` | looping, mixed, dense | 7 | oui | oui | — |

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
| 1 | dunes | procedural | large_rooms+twosides+mixed | 7x3 | 14x11 | 5 | 0 | 5/8.8/18 | 11.2 | 2.2 | 2.2 | 1.2 | 37.4 | 5 | oui |
| 2 | dunes | procedural | large_rooms+twosides+mixed | 3x4 | 10x10 | 5 | 1 | 4/9.0/15 | 10.2 | 2.2 | 2.6 | 1.0 | 32.2 | 5 | oui |
| 3 | dunes | procedural | large_rooms+twosides+mixed | 4x4 | 10x9 | 5 | 1 | 6/9.6/16 | 10.6 | 3.0 | 3.0 | 1.2 | 40.2 | 5 | oui |
| 4 | dunes | procedural | large_rooms+twosides+mixed | 4x3 | 13x10 | 5 | 2 | 6/8.4/12 | 9.4 | 2.2 | 2.6 | 1.0 | 34.2 | 5 | oui |
| 5 | dunes | procedural | large_rooms+twosides+mixed | 3x2 | 12x13 | 5 | 0 | 6/9.6/18 | 11.2 | 1.8 | 2.0 | 1.0 | 36.6 | 5 | oui |
| 6 | dunes | procedural | large_rooms+twosides+mixed | 4x2 | 13x12 | 5 | 0 | 5/8.0/12 | 9.8 | 1.4 | 1.2 | 1.2 | 48.8 | 5 | oui |
| 7 | dunes | procedural | large_rooms+twosides+mixed | 4x3 | 16x13 | 5 | 1 | 5/8.2/12 | 9.6 | 2.8 | 2.0 | 1.4 | 44.6 | 5 | oui |
| 8 | dunes | procedural | large_rooms+twosides+mixed | 7x3 | 14x7 | 5 | 2 | 9/12.6/17 | 13.2 | 3.4 | 3.8 | 1.0 | 55.6 | 5 | oui |
| 9 | dunes | procedural | large_rooms+twosides+mixed | 4x3 | 15x11 | 5 | 1 | 4/9.0/18 | 10.4 | 2.4 | 2.2 | 1.2 | 38.4 | 5 | oui |
| 10 | dunes | procedural | large_rooms+twosides+mixed | 6x4 | 10x9 | 5 | 0 | 5/8.2/12 | 9.8 | 1.8 | 1.6 | 1.2 | 40.6 | 5 | oui |
| 11 | deep_desert | procedural | looping+mixed+dense | 4x3 | 9x10 | 5 | 0 | 9/14.0/20 | 18.2 | 6.2 | 2.8 | 3.0 | 41.0 | 5 | oui |
| 12 | deep_desert | procedural | looping+mixed+dense | 5x5 | 13x10 | 5 | 0 | 10/13.8/20 | 18.0 | 6.6 | 2.6 | 3.0 | 55.2 | 5 | oui |
| 13 | deep_desert | procedural | looping+mixed+dense | 5x4 | 11x10 | 5 | 0 | 7/17.4/29 | 22.6 | 7.0 | 3.4 | 3.0 | 43.8 | 5 | oui |
| 14 | deep_desert | procedural | looping+mixed+dense | 5x3 | 10x9 | 5 | 0 | 10/15.4/21 | 17.6 | 4.8 | 3.0 | 2.2 | 42.6 | 5 | oui |
| 15 | deep_desert | procedural | looping+mixed+dense | 6x4 | 12x11 | 5 | 1 | 8/13.8/19 | 16.6 | 4.2 | 2.8 | 1.8 | 47.4 | 5 | oui |
| 16 | deep_desert | procedural | looping+mixed+dense | 7x5 | 9x8 | 5 | 0 | 9/14.2/21 | 16.8 | 4.4 | 3.4 | 1.6 | 33.4 | 5 | oui |
| 17 | deep_desert | procedural | looping+mixed+dense | 5x3 | 12x9 | 5 | 0 | 11/17.2/28 | 20.4 | 5.2 | 3.8 | 1.8 | 51.2 | 5 | oui |
| 18 | deep_desert | procedural | looping+mixed+dense | 5x5 | 8x10 | 5 | 0 | 11/16.4/30 | 21.2 | 6.8 | 2.6 | 3.4 | 53.8 | 5 | oui |
| 19 | deep_desert | procedural | looping+mixed+dense | 4x4 | 8x7 | 5 | 0 | 10/14.8/20 | 19.4 | 5.4 | 2.6 | 2.8 | 40.8 | 5 | oui |
| 20 | deep_desert | procedural | looping+mixed+dense | 4x4 | 10x9 | 5 | 0 | 8/14.4/27 | 17.2 | 4.8 | 3.2 | 2.4 | 50.6 | 5 | oui |
