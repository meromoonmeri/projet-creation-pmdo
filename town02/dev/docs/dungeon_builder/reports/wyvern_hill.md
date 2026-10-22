# Rapport de génération — Wyvern Hill

- **ID** : `wyvern_hill`  
- **Chapitre** : 18 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Wyvern Hill (30F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/WyvernHill) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 18. Recoupé avec Bulbapedia (page « Wyvern Hill »).  
- **Étages** : 30 — direction `sommet`  
- **Zone écrite** : `Data/Zone/wyvern_hill.json`  
- **Seed d'auteur (debug)** : `8748793873274580613` (explicite : False)  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| wyvern_slope | 1-15 | wyvern_slope | `wyvern_hill_floor` | twosides, branching, mixed | 10 | oui | oui | — |
| wyvern_crest | 16-30 | wyvern_crest | `wyvern_hill_floor` | branching, crossroads, mixed | 8 | oui | oui | — |

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
| 1 | wyvern_slope | procedural | twosides+branching+mixed | 7x4 | 10x10 | 5 | 0 | 6/9.2/13 | 10.8 | 2.6 | 2.4 | 1.2 | 38.0 | 5 | oui |
| 2 | wyvern_slope | procedural | twosides+branching+mixed | 6x3 | 11x10 | 5 | 1 | 6/11.4/23 | 12.8 | 3.8 | 4.0 | 1.0 | 35.4 | 5 | oui |
| 3 | wyvern_slope | procedural | twosides+branching+mixed | 4x4 | 13x9 | 5 | 0 | 7/9.4/16 | 11.4 | 2.4 | 2.2 | 1.2 | 49.4 | 5 | oui |
| 4 | wyvern_slope | procedural | twosides+branching+mixed | 6x3 | 10x10 | 5 | 1 | 6/10.4/16 | 12.2 | 3.0 | 2.8 | 1.2 | 39.4 | 5 | oui |
| 5 | wyvern_slope | procedural | twosides+branching+mixed | 4x4 | 13x10 | 5 | 1 | 6/11.6/16 | 12.8 | 3.6 | 2.8 | 1.4 | 51.2 | 5 | oui |
| 6 | wyvern_slope | procedural | twosides+branching+mixed | 4x3 | 10x8 | 5 | 1 | 5/7.0/11 | 8.8 | 1.8 | 2.0 | 1.0 | 34.2 | 5 | oui |
| 7 | wyvern_slope | procedural | twosides+branching+mixed | 3x3 | 11x9 | 5 | 1 | 6/9.0/12 | 9.6 | 2.8 | 3.2 | 0.8 | 32.6 | 5 | oui |
| 8 | wyvern_slope | procedural | twosides+branching+mixed | 5x4 | 10x8 | 5 | 1 | 6/9.6/16 | 10.4 | 2.6 | 3.2 | 0.8 | 45.6 | 5 | oui |
| 9 | wyvern_slope | procedural | twosides+branching+mixed | 3x4 | 12x10 | 5 | 1 | 6/8.8/15 | 9.8 | 2.2 | 2.4 | 1.0 | 43.8 | 5 | oui |
| 10 | wyvern_slope | procedural | twosides+branching+mixed | 3x3 | 12x11 | 5 | 1 | 6/10.0/16 | 10.8 | 2.6 | 2.8 | 1.0 | 38.8 | 5 | oui |
| 11 | wyvern_slope | procedural | twosides+branching+mixed | 3x4 | 11x11 | 5 | 0 | 6/11.4/21 | 13.2 | 3.4 | 3.2 | 1.4 | 47.0 | 5 | oui |
| 12 | wyvern_slope | procedural | twosides+branching+mixed | 4x3 | 11x9 | 5 | 2 | 7/13.4/23 | 15.2 | 4.2 | 3.4 | 1.6 | 43.4 | 5 | oui |
| 13 | wyvern_slope | procedural | twosides+branching+mixed | 4x4 | 11x8 | 5 | 1 | 6/10.4/14 | 11.0 | 2.8 | 3.6 | 0.6 | 33.2 | 5 | oui |
| 14 | wyvern_slope | procedural | twosides+branching+mixed | 6x4 | 14x8 | 5 | 0 | 6/8.6/11 | 9.6 | 1.8 | 3.0 | 0.4 | 41.6 | 5 | oui |
| 15 | wyvern_slope | procedural | twosides+branching+mixed | 5x3 | 9x9 | 5 | 0 | 6/10.8/21 | 12.8 | 2.4 | 3.2 | 1.0 | 35.6 | 5 | oui |
| 16 | wyvern_crest | procedural | branching+crossroads+mixed | 6x3 | 10x9 | 5 | 0 | 6/10.4/14 | 10.2 | 2.2 | 3.8 | 0.6 | 33.6 | 5 | oui |
| 17 | wyvern_crest | procedural | branching+crossroads+mixed | 6x3 | 10x10 | 5 | 0 | 9/14.2/25 | 15.0 | 4.0 | 4.2 | 1.6 | 41.2 | 5 | oui |
| 18 | wyvern_crest | procedural | branching+crossroads+mixed | 5x3 | 13x9 | 5 | 0 | 8/10.2/12 | 10.4 | 2.8 | 3.4 | 1.0 | 32.6 | 5 | oui |
| 19 | wyvern_crest | procedural | branching+crossroads+mixed | 4x3 | 11x9 | 5 | 0 | 6/9.6/14 | 9.0 | 2.0 | 3.8 | 0.4 | 36.0 | 5 | oui |
| 20 | wyvern_crest | procedural | branching+crossroads+mixed | 5x3 | 10x8 | 5 | 1 | 8/10.2/15 | 10.8 | 2.8 | 3.2 | 1.2 | 35.8 | 5 | oui |
| 21 | wyvern_crest | procedural | branching+crossroads+mixed | 6x4 | 10x10 | 5 | 1 | 7/12.8/24 | 13.6 | 3.6 | 3.8 | 1.4 | 39.4 | 5 | oui |
| 22 | wyvern_crest | procedural | branching+crossroads+mixed | 5x5 | 14x11 | 5 | 0 | 6/9.8/17 | 9.4 | 1.8 | 3.4 | 0.4 | 42.6 | 5 | oui |
| 23 | wyvern_crest | procedural | branching+crossroads+mixed | 4x3 | 12x9 | 5 | 0 | 7/9.6/14 | 9.4 | 2.0 | 3.2 | 0.6 | 36.2 | 5 | oui |
| 24 | wyvern_crest | procedural | branching+crossroads+mixed | 5x5 | 11x11 | 5 | 1 | 7/11.8/17 | 12.8 | 3.0 | 2.8 | 1.4 | 34.8 | 5 | oui |
| 25 | wyvern_crest | procedural | branching+crossroads+mixed | 4x5 | 9x9 | 5 | 2 | 8/12.0/23 | 12.4 | 3.4 | 4.0 | 1.0 | 38.0 | 5 | oui |
| 26 | wyvern_crest | procedural | branching+crossroads+mixed | 6x4 | 10x10 | 5 | 1 | 8/10.6/12 | 11.8 | 2.8 | 2.8 | 1.6 | 35.8 | 5 | oui |
| 27 | wyvern_crest | procedural | branching+crossroads+mixed | 5x3 | 10x9 | 5 | 2 | 7/12.2/24 | 12.4 | 3.2 | 4.6 | 0.8 | 31.0 | 5 | oui |
| 28 | wyvern_crest | procedural | branching+crossroads+mixed | 7x5 | 13x8 | 5 | 1 | 9/10.8/12 | 10.8 | 2.2 | 3.0 | 0.8 | 39.0 | 5 | oui |
| 29 | wyvern_crest | procedural | branching+crossroads+mixed | 4x4 | 11x9 | 5 | 0 | 9/10.2/11 | 10.4 | 2.8 | 3.8 | 0.8 | 29.0 | 5 | oui |
| 30 | wyvern_crest | procedural | branching+crossroads+mixed | 4x4 | 12x10 | 5 | 0 | 7/10.4/16 | 10.4 | 2.6 | 3.2 | 1.0 | 46.8 | 5 | oui |
