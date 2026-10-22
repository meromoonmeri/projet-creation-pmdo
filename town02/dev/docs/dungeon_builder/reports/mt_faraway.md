# Rapport de génération — Mt. Faraway

- **ID** : `mt_faraway`  
- **Chapitre** : 28 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Mt. Faraway (40F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/MtFaraway) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 28. Recoupé avec Bulbapedia (page « Mt. Faraway »).  
- **Étages** : 40 — direction `sommet`  
- **Zone écrite** : `Data/Zone/mt_faraway.json`  
- **Seed d'auteur (debug)** : `4394283697082123148` (explicite : False)  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| faraway_slope | 1-13 | faraway_slope | `hidden_highland_floor` | twosides, branching, mixed | 8 | oui | oui | — |
| faraway_ridge | 14-27 | faraway_ridge | `hidden_highland_floor` | branching, crossroads, mixed | 7 | oui | oui | — |
| faraway_peak | 28-40 | faraway_peak | `hidden_highland_floor` | large_rooms, mixed, branching | 9 | oui | oui | — |

## Scènes fixes

- entrée : `—`
- midpoint : `—`
- Ground de fin : `sommet_aurore`
- boss : mode `canonical_ground` → Ground `sommet_aurore`, rsmap `—`
  - no fixed 'entrance' Ground declared
  - no fixed 'mid' Ground declared
  - final battle stays on the canonical end Ground 'sommet_aurore' (no separate arena created)

## Étages

| Ét. | Segment | Type | Profil | Grille | Cellule | Variantes OK | Rejets | Rooms (min/moy/max) | Halls | Branches | Culs-de-sac | Boucles | Dist. escaliers | Signatures | Traversable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | faraway_slope | procedural | twosides+branching+mixed | 6x3 | 10x10 | 5 | 0 | 6/11.8/18 | 13.2 | 3.2 | 3.8 | 1.0 | 43.4 | 5 | oui |
| 2 | faraway_slope | procedural | twosides+branching+mixed | 6x3 | 12x8 | 5 | 1 | 7/10.4/18 | 11.6 | 2.8 | 2.8 | 1.2 | 38.8 | 5 | oui |
| 3 | faraway_slope | procedural | twosides+branching+mixed | 6x4 | 10x10 | 5 | 1 | 6/8.4/11 | 10.0 | 1.6 | 2.4 | 0.6 | 38.0 | 5 | oui |
| 4 | faraway_slope | procedural | twosides+branching+mixed | 4x4 | 11x8 | 5 | 1 | 6/10.8/18 | 12.2 | 3.6 | 4.2 | 1.2 | 33.0 | 5 | oui |
| 5 | faraway_slope | procedural | twosides+branching+mixed | 4x4 | 10x8 | 5 | 2 | 8/11.4/14 | 11.8 | 3.4 | 4.2 | 1.0 | 35.8 | 5 | oui |
| 6 | faraway_slope | procedural | twosides+branching+mixed | 4x4 | 10x8 | 5 | 0 | 6/10.2/16 | 12.2 | 2.4 | 3.2 | 1.0 | 38.8 | 5 | oui |
| 7 | faraway_slope | procedural | twosides+branching+mixed | 4x4 | 11x9 | 5 | 2 | 9/12.6/15 | 12.6 | 3.4 | 4.4 | 0.8 | 32.8 | 5 | oui |
| 8 | faraway_slope | procedural | twosides+branching+mixed | 3x4 | 11x11 | 5 | 1 | 6/10.6/17 | 10.6 | 2.6 | 4.2 | 0.4 | 30.0 | 5 | oui |
| 9 | faraway_slope | procedural | twosides+branching+mixed | 3x3 | 10x8 | 5 | 1 | 6/9.6/17 | 9.6 | 2.2 | 3.8 | 0.4 | 31.6 | 5 | oui |
| 10 | faraway_slope | procedural | twosides+branching+mixed | 3x3 | 11x9 | 5 | 2 | 8/13.2/19 | 13.4 | 3.8 | 5.2 | 0.8 | 39.6 | 5 | oui |
| 11 | faraway_slope | procedural | twosides+branching+mixed | 4x4 | 10x11 | 5 | 1 | 6/10.8/14 | 13.2 | 3.2 | 3.2 | 1.0 | 51.2 | 5 | oui |
| 12 | faraway_slope | procedural | twosides+branching+mixed | 4x4 | 12x10 | 5 | 1 | 6/10.4/13 | 11.2 | 3.2 | 3.0 | 1.2 | 32.8 | 5 | oui |
| 13 | faraway_slope | procedural | twosides+branching+mixed | 5x4 | 10x12 | 5 | 1 | 8/12.2/16 | 13.4 | 3.0 | 3.6 | 1.0 | 41.2 | 5 | oui |
| 14 | faraway_ridge | procedural | branching+crossroads+mixed | 5x4 | 13x8 | 5 | 0 | 8/10.6/14 | 10.6 | 2.4 | 3.2 | 0.8 | 33.4 | 5 | oui |
| 15 | faraway_ridge | procedural | branching+crossroads+mixed | 6x3 | 8x12 | 5 | 0 | 7/10.2/14 | 10.2 | 2.2 | 4.0 | 0.6 | 43.0 | 5 | oui |
| 16 | faraway_ridge | procedural | branching+crossroads+mixed | 4x3 | 11x10 | 5 | 1 | 6/12.8/17 | 13.6 | 3.6 | 4.8 | 0.8 | 36.6 | 5 | oui |
| 17 | faraway_ridge | procedural | branching+crossroads+mixed | 4x3 | 11x9 | 5 | 0 | 8/10.4/14 | 10.2 | 2.2 | 4.0 | 0.4 | 40.4 | 5 | oui |
| 18 | faraway_ridge | procedural | branching+crossroads+mixed | 5x3 | 10x8 | 5 | 2 | 7/8.8/12 | 8.6 | 2.2 | 3.6 | 0.6 | 35.0 | 5 | oui |
| 19 | faraway_ridge | procedural | branching+crossroads+mixed | 6x4 | 13x8 | 5 | 0 | 6/8.4/10 | 7.6 | 1.4 | 4.0 | 0.0 | 34.0 | 5 | oui |
| 20 | faraway_ridge | procedural | branching+crossroads+mixed | 6x4 | 12x8 | 5 | 0 | 7/10.2/12 | 10.2 | 2.6 | 4.0 | 0.8 | 36.8 | 5 | oui |
| 21 | faraway_ridge | procedural | branching+crossroads+mixed | 7x3 | 11x10 | 5 | 0 | 6/9.6/17 | 8.8 | 2.2 | 4.0 | 0.2 | 48.6 | 5 | oui |
| 22 | faraway_ridge | procedural | branching+crossroads+mixed | 5x3 | 9x9 | 5 | 0 | 9/11.0/15 | 10.8 | 2.8 | 3.8 | 0.8 | 37.0 | 5 | oui |
| 23 | faraway_ridge | procedural | branching+crossroads+mixed | 5x3 | 12x8 | 5 | 1 | 8/10.6/13 | 10.0 | 2.2 | 4.0 | 0.4 | 34.6 | 5 | oui |
| 24 | faraway_ridge | procedural | branching+crossroads+mixed | 4x4 | 10x8 | 5 | 0 | 6/8.6/13 | 8.0 | 2.2 | 3.8 | 0.4 | 33.6 | 5 | oui |
| 25 | faraway_ridge | procedural | branching+crossroads+mixed | 7x4 | 9x10 | 5 | 2 | 7/10.0/13 | 10.4 | 3.2 | 3.2 | 1.2 | 36.6 | 5 | oui |
| 26 | faraway_ridge | procedural | branching+crossroads+mixed | 5x3 | 9x8 | 5 | 0 | 8/9.8/13 | 10.0 | 2.6 | 3.2 | 1.0 | 36.2 | 5 | oui |
| 27 | faraway_ridge | procedural | branching+crossroads+mixed | 5x4 | 11x9 | 5 | 0 | 6/9.4/16 | 9.6 | 2.2 | 3.2 | 1.0 | 39.4 | 5 | oui |
| 28 | faraway_peak | procedural | large_rooms+mixed+branching | 4x3 | 9x8 | 5 | 0 | 4/7.2/11 | 7.2 | 1.4 | 2.0 | 1.0 | 33.6 | 5 | oui |
| 29 | faraway_peak | procedural | large_rooms+mixed+branching | 3x3 | 16x12 | 5 | 0 | 5/10.2/15 | 10.0 | 2.2 | 3.0 | 0.6 | 42.8 | 5 | oui |
| 30 | faraway_peak | procedural | large_rooms+mixed+branching | 4x3 | 12x11 | 5 | 1 | 7/10.4/15 | 10.4 | 2.2 | 2.8 | 0.8 | 38.4 | 5 | oui |
| 31 | faraway_peak | procedural | large_rooms+mixed+branching | 3x3 | 16x10 | 5 | 0 | 6/9.0/13 | 9.2 | 2.2 | 2.6 | 1.0 | 31.6 | 5 | oui |
| 32 | faraway_peak | procedural | large_rooms+mixed+branching | 5x4 | 8x10 | 5 | 0 | 7/11.0/17 | 11.4 | 2.2 | 2.0 | 1.2 | 42.4 | 5 | oui |
| 33 | faraway_peak | procedural | large_rooms+mixed+branching | 7x5 | 13x8 | 5 | 0 | 7/8.8/10 | 9.0 | 2.0 | 2.2 | 1.0 | 34.0 | 5 | oui |
| 34 | faraway_peak | procedural | large_rooms+mixed+branching | 7x3 | 10x7 | 5 | 0 | 5/11.2/20 | 12.8 | 4.0 | 2.2 | 2.0 | 36.2 | 5 | oui |
| 35 | faraway_peak | procedural | large_rooms+mixed+branching | 7x4 | 8x9 | 5 | 0 | 6/12.8/24 | 14.4 | 4.0 | 2.8 | 2.0 | 48.2 | 5 | oui |
| 36 | faraway_peak | procedural | large_rooms+mixed+branching | 4x3 | 13x11 | 5 | 0 | 5/9.2/13 | 10.4 | 3.2 | 2.0 | 1.8 | 32.0 | 5 | oui |
| 37 | faraway_peak | procedural | large_rooms+mixed+branching | 5x4 | 9x8 | 5 | 1 | 4/10.8/25 | 11.8 | 2.6 | 2.6 | 1.2 | 36.6 | 5 | oui |
| 38 | faraway_peak | procedural | large_rooms+mixed+branching | 3x2 | 13x11 | 5 | 0 | 6/11.8/19 | 13.0 | 3.2 | 3.0 | 1.4 | 36.0 | 5 | oui |
| 39 | faraway_peak | procedural | large_rooms+mixed+branching | 3x3 | 14x10 | 5 | 0 | 4/10.0/17 | 11.8 | 3.8 | 1.8 | 2.0 | 37.6 | 5 | oui |
| 40 | faraway_peak | procedural | large_rooms+mixed+branching | 3x2 | 16x10 | 5 | 0 | 5/11.4/19 | 12.4 | 3.8 | 2.6 | 1.8 | 37.0 | 5 | oui |
