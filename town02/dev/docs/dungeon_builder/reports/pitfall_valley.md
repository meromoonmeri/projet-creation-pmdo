# Rapport de génération — Pitfall Valley

- **ID** : `pitfall_valley`  
- **Chapitre** : 16 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Pitfall Valley (25F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/PitfallValley) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 16. Recoupé avec Bulbapedia (page « Pitfall Valley »).  
- **Étages** : 25 — direction `fond`  
- **Zone écrite** : `Data/Zone/pitfall_valley.json`  
- **Seed d'auteur (debug)** : `2823104767095208122` (explicite : False)  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| pitfall_rim | 1-12 | pitfall_rim | `pitfall_valley_1_floor` | twosides, branching, mixed | 12 | oui | oui | — |
| pitfall_floor | 13-25 | pitfall_floor | `pitfall_valley_1_floor` | branching, crossroads, mixed | 5 | oui | oui | — |

## Scènes fixes

- entrée : `vallon_perdu`
- midpoint : `—`
- Ground de fin : `vallon_perdu`
- boss : mode `canonical_ground` → Ground `vallon_perdu`, rsmap `—`
  - no fixed 'mid' Ground declared
  - final battle stays on the canonical end Ground 'vallon_perdu' (no separate arena created)

## Étages

| Ét. | Segment | Type | Profil | Grille | Cellule | Variantes OK | Rejets | Rooms (min/moy/max) | Halls | Branches | Culs-de-sac | Boucles | Dist. escaliers | Signatures | Traversable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | pitfall_rim | procedural | twosides+branching+mixed | 6x3 | 9x10 | 5 | 1 | 7/9.6/14 | 10.4 | 2.4 | 3.0 | 0.8 | 39.2 | 5 | oui |
| 2 | pitfall_rim | procedural | twosides+branching+mixed | 3x4 | 13x9 | 5 | 0 | 6/13.0/30 | 14.4 | 3.0 | 3.8 | 0.8 | 42.2 | 5 | oui |
| 3 | pitfall_rim | procedural | twosides+branching+mixed | 3x3 | 13x10 | 5 | 2 | 10/12.0/16 | 12.2 | 3.2 | 4.0 | 0.8 | 33.2 | 5 | oui |
| 4 | pitfall_rim | procedural | twosides+branching+mixed | 4x3 | 12x8 | 5 | 0 | 6/9.6/13 | 11.0 | 2.2 | 3.0 | 1.0 | 40.4 | 5 | oui |
| 5 | pitfall_rim | procedural | twosides+branching+mixed | 3x3 | 13x9 | 5 | 1 | 6/10.0/17 | 10.2 | 2.2 | 3.2 | 0.6 | 31.8 | 5 | oui |
| 6 | pitfall_rim | procedural | twosides+branching+mixed | 5x3 | 10x8 | 5 | 4 | 8/9.4/12 | 9.6 | 2.6 | 3.8 | 0.4 | 39.0 | 5 | oui |
| 7 | pitfall_rim | procedural | twosides+branching+mixed | 5x3 | 14x8 | 5 | 2 | 6/12.6/23 | 14.4 | 4.2 | 3.8 | 1.6 | 35.8 | 5 | oui |
| 8 | pitfall_rim | procedural | twosides+branching+mixed | 7x3 | 9x9 | 5 | 2 | 7/9.6/12 | 9.0 | 2.2 | 3.6 | 0.4 | 41.0 | 5 | oui |
| 9 | pitfall_rim | procedural | twosides+branching+mixed | 4x5 | 9x10 | 5 | 0 | 6/10.8/14 | 13.2 | 3.4 | 2.6 | 1.4 | 38.2 | 5 | oui |
| 10 | pitfall_rim | procedural | twosides+branching+mixed | 3x3 | 10x10 | 5 | 4 | 8/10.2/12 | 9.8 | 2.8 | 3.8 | 0.6 | 32.0 | 5 | oui |
| 11 | pitfall_rim | procedural | twosides+branching+mixed | 4x3 | 10x8 | 5 | 0 | 6/10.2/17 | 12.0 | 2.6 | 3.0 | 0.8 | 32.8 | 5 | oui |
| 12 | pitfall_rim | procedural | twosides+branching+mixed | 4x4 | 11x9 | 5 | 2 | 8/11.6/16 | 13.6 | 3.6 | 3.2 | 1.4 | 40.2 | 5 | oui |
| 13 | pitfall_floor | procedural | branching+crossroads+mixed | 4x4 | 9x8 | 5 | 1 | 7/12.2/17 | 12.6 | 3.4 | 4.2 | 1.2 | 37.2 | 5 | oui |
| 14 | pitfall_floor | procedural | branching+crossroads+mixed | 5x5 | 12x12 | 5 | 0 | 7/9.4/12 | 9.2 | 2.6 | 3.6 | 0.8 | 42.6 | 5 | oui |
| 15 | pitfall_floor | procedural | branching+crossroads+mixed | 7x5 | 9x10 | 5 | 1 | 9/13.0/21 | 14.0 | 3.8 | 3.2 | 1.6 | 49.6 | 5 | oui |
| 16 | pitfall_floor | procedural | branching+crossroads+mixed | 7x4 | 13x8 | 5 | 0 | 7/10.2/15 | 10.0 | 1.8 | 3.2 | 0.8 | 41.6 | 5 | oui |
| 17 | pitfall_floor | procedural | branching+crossroads+mixed | 7x5 | 12x9 | 5 | 0 | 8/9.8/12 | 9.4 | 2.6 | 4.4 | 0.4 | 44.0 | 5 | oui |
| 18 | pitfall_floor | procedural | branching+crossroads+mixed | 7x5 | 11x8 | 5 | 0 | 9/11.2/17 | 11.0 | 3.2 | 4.4 | 0.6 | 45.4 | 5 | oui |
| 19 | pitfall_floor | procedural | branching+crossroads+mixed | 5x3 | 12x8 | 5 | 0 | 8/11.0/17 | 10.4 | 2.8 | 4.6 | 0.4 | 44.6 | 5 | oui |
| 20 | pitfall_floor | procedural | branching+crossroads+mixed | 7x4 | 9x8 | 5 | 0 | 9/11.0/14 | 10.6 | 2.8 | 4.0 | 0.6 | 33.0 | 5 | oui |
| 21 | pitfall_floor | procedural | branching+crossroads+mixed | 6x3 | 10x8 | 5 | 1 | 7/13.8/21 | 14.6 | 4.6 | 4.6 | 1.2 | 44.4 | 5 | oui |
| 22 | pitfall_floor | procedural | branching+crossroads+mixed | 5x4 | 12x11 | 5 | 1 | 9/12.6/17 | 13.0 | 3.6 | 5.0 | 0.6 | 61.6 | 5 | oui |
| 23 | pitfall_floor | procedural | branching+crossroads+mixed | 6x3 | 10x10 | 5 | 0 | 7/10.0/15 | 10.2 | 2.8 | 3.8 | 0.8 | 34.0 | 5 | oui |
| 24 | pitfall_floor | procedural | branching+crossroads+mixed | 4x5 | 11x12 | 5 | 2 | 10/13.0/16 | 13.4 | 4.2 | 4.6 | 1.0 | 41.8 | 5 | oui |
| 25 | pitfall_floor | procedural | branching+crossroads+mixed | 7x3 | 9x10 | 5 | 0 | 8/10.4/14 | 10.0 | 2.0 | 3.6 | 0.6 | 35.4 | 5 | oui |
