# Rapport de génération — Northern Range

- **ID** : `northern_range`  
- **Chapitre** : 16 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Northern Range (25F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/NorthernRange) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 16. Recoupé avec Bulbapedia (page « Northern Range »).  
- **Étages** : 25 — direction `sommet`  
- **Zone écrite** : `Data/Zone/northern_range.json`  
- **Seed d'auteur (debug)** : `946168538976676180` (explicite : False)  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| north_ridge | 1-12 | north_ridge | `craggy_peak_floor` | twosides, branching, mixed | 9 | oui | oui | — |
| north_heights | 13-25 | north_heights | `craggy_peak_floor` | branching, crossroads, mixed | 10 | oui | oui | — |

## Scènes fixes

- entrée : `—`
- midpoint : `—`
- Ground de fin : `cretes_boreales`
- boss : mode `canonical_ground` → Ground `cretes_boreales`, rsmap `—`
  - no fixed 'entrance' Ground declared
  - no fixed 'mid' Ground declared
  - final battle stays on the canonical end Ground 'cretes_boreales' (no separate arena created)

## Étages

| Ét. | Segment | Type | Profil | Grille | Cellule | Variantes OK | Rejets | Rooms (min/moy/max) | Halls | Branches | Culs-de-sac | Boucles | Dist. escaliers | Signatures | Traversable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | north_ridge | procedural | twosides+branching+mixed | 4x4 | 13x8 | 5 | 1 | 8/11.4/15 | 11.6 | 3.0 | 4.8 | 0.4 | 34.6 | 5 | oui |
| 2 | north_ridge | procedural | twosides+branching+mixed | 4x4 | 12x9 | 5 | 1 | 6/10.4/15 | 11.0 | 3.2 | 4.0 | 0.8 | 32.4 | 5 | oui |
| 3 | north_ridge | procedural | twosides+branching+mixed | 4x3 | 10x11 | 5 | 1 | 8/11.0/15 | 11.8 | 2.8 | 3.6 | 0.6 | 41.6 | 5 | oui |
| 4 | north_ridge | procedural | twosides+branching+mixed | 3x4 | 10x8 | 5 | 1 | 8/11.4/17 | 12.2 | 3.4 | 4.4 | 0.8 | 36.2 | 5 | oui |
| 5 | north_ridge | procedural | twosides+branching+mixed | 3x4 | 10x8 | 5 | 1 | 6/11.4/17 | 13.0 | 2.4 | 3.0 | 0.8 | 42.6 | 5 | oui |
| 6 | north_ridge | procedural | twosides+branching+mixed | 7x4 | 9x10 | 5 | 1 | 7/12.6/21 | 13.4 | 4.2 | 4.4 | 1.0 | 43.2 | 5 | oui |
| 7 | north_ridge | procedural | twosides+branching+mixed | 5x3 | 11x9 | 5 | 2 | 9/10.2/11 | 10.2 | 3.0 | 3.2 | 1.0 | 34.8 | 5 | oui |
| 8 | north_ridge | procedural | twosides+branching+mixed | 5x3 | 11x9 | 5 | 0 | 6/9.4/15 | 11.6 | 2.6 | 2.4 | 1.4 | 26.0 | 5 | oui |
| 9 | north_ridge | procedural | twosides+branching+mixed | 6x3 | 14x8 | 5 | 1 | 6/11.2/19 | 12.2 | 3.0 | 3.0 | 1.0 | 34.2 | 5 | oui |
| 10 | north_ridge | procedural | twosides+branching+mixed | 4x4 | 11x11 | 5 | 1 | 6/13.8/22 | 15.0 | 4.2 | 4.6 | 1.2 | 31.6 | 5 | oui |
| 11 | north_ridge | procedural | twosides+branching+mixed | 4x3 | 10x8 | 5 | 0 | 7/7.8/10 | 9.4 | 2.2 | 2.2 | 1.0 | 34.2 | 5 | oui |
| 12 | north_ridge | procedural | twosides+branching+mixed | 3x4 | 11x10 | 5 | 1 | 5/12.2/21 | 13.4 | 3.4 | 3.8 | 1.0 | 40.8 | 5 | oui |
| 13 | north_heights | procedural | branching+crossroads+mixed | 7x5 | 10x9 | 5 | 0 | 8/12.4/25 | 12.6 | 2.8 | 4.0 | 1.0 | 38.4 | 5 | oui |
| 14 | north_heights | procedural | branching+crossroads+mixed | 6x4 | 10x10 | 5 | 1 | 9/13.2/24 | 13.6 | 3.6 | 3.8 | 1.2 | 42.4 | 5 | oui |
| 15 | north_heights | procedural | branching+crossroads+mixed | 4x3 | 11x8 | 5 | 1 | 6/8.4/10 | 8.4 | 2.4 | 3.0 | 0.8 | 35.4 | 5 | oui |
| 16 | north_heights | procedural | branching+crossroads+mixed | 5x4 | 11x10 | 5 | 1 | 10/16.2/28 | 17.6 | 4.8 | 5.2 | 1.4 | 37.0 | 5 | oui |
| 17 | north_heights | procedural | branching+crossroads+mixed | 5x4 | 12x8 | 5 | 1 | 8/10.6/16 | 10.0 | 2.8 | 4.6 | 0.4 | 36.0 | 5 | oui |
| 18 | north_heights | procedural | branching+crossroads+mixed | 5x3 | 12x9 | 5 | 1 | 9/13.0/19 | 13.8 | 4.0 | 3.8 | 1.4 | 44.8 | 5 | oui |
| 19 | north_heights | procedural | branching+crossroads+mixed | 6x3 | 11x8 | 5 | 0 | 8/11.6/17 | 11.6 | 2.6 | 3.8 | 0.8 | 34.2 | 5 | oui |
| 20 | north_heights | procedural | branching+crossroads+mixed | 5x4 | 9x9 | 5 | 0 | 9/11.4/16 | 11.6 | 2.8 | 3.2 | 1.0 | 41.0 | 5 | oui |
| 21 | north_heights | procedural | branching+crossroads+mixed | 7x5 | 9x8 | 5 | 1 | 7/9.0/11 | 8.2 | 1.6 | 4.2 | 0.2 | 42.0 | 5 | oui |
| 22 | north_heights | procedural | branching+crossroads+mixed | 6x5 | 13x7 | 5 | 0 | 9/11.2/18 | 10.8 | 2.4 | 4.4 | 0.4 | 39.6 | 5 | oui |
| 23 | north_heights | procedural | branching+crossroads+mixed | 5x3 | 10x9 | 5 | 0 | 8/9.6/11 | 9.2 | 2.4 | 4.0 | 0.4 | 32.6 | 5 | oui |
| 24 | north_heights | procedural | branching+crossroads+mixed | 6x3 | 11x10 | 5 | 0 | 7/11.4/23 | 12.0 | 3.0 | 3.4 | 1.0 | 45.6 | 5 | oui |
| 25 | north_heights | procedural | branching+crossroads+mixed | 4x4 | 11x11 | 5 | 1 | 6/9.6/16 | 9.0 | 2.2 | 4.0 | 0.4 | 33.2 | 5 | oui |
