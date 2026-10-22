# Rapport de génération — Northwind Field

- **ID** : `northwind_field`  
- **Chapitre** : 19 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Northwind Field (30F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/NorthwindField) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 19. Recoupé avec Bulbapedia (page « Northwind Field »).  
- **Étages** : 30 — direction `sommet`  
- **Zone écrite** : `Data/Zone/northwind_field.json`  
- **Seed d'auteur (debug)** : `6270485013459108761` (explicite : False)  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| north_plain | 1-15 | north_plain | `northwind_field` | twosides, large_rooms, mixed | 8 | oui | oui | — |
| gale_plain | 16-30 | gale_plain | `northwind_field` | looping, mixed, large_rooms | 12 | oui | oui | — |

## Scènes fixes

- entrée : `—`
- midpoint : `—`
- Ground de fin : `champ_vent_boreal`
- boss : mode `canonical_ground` → Ground `champ_vent_boreal`, rsmap `—`
  - no fixed 'entrance' Ground declared
  - no fixed 'mid' Ground declared
  - final battle stays on the canonical end Ground 'champ_vent_boreal' (no separate arena created)

## Étages

| Ét. | Segment | Type | Profil | Grille | Cellule | Variantes OK | Rejets | Rooms (min/moy/max) | Halls | Branches | Culs-de-sac | Boucles | Dist. escaliers | Signatures | Traversable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | north_plain | procedural | twosides+large_rooms+mixed | 3x4 | 10x9 | 5 | 1 | 4/5.8/8 | 5.8 | 0.2 | 1.4 | 0.4 | 30.4 | 5 | oui |
| 2 | north_plain | procedural | twosides+large_rooms+mixed | 5x3 | 12x10 | 5 | 0 | 6/7.4/11 | 8.8 | 2.0 | 1.6 | 1.2 | 45.8 | 5 | oui |
| 3 | north_plain | procedural | twosides+large_rooms+mixed | 3x2 | 14x11 | 5 | 0 | 6/8.4/12 | 9.4 | 1.6 | 2.6 | 0.6 | 45.0 | 5 | oui |
| 4 | north_plain | procedural | twosides+large_rooms+mixed | 3x3 | 13x9 | 5 | 0 | 5/8.8/21 | 10.0 | 1.8 | 2.2 | 0.8 | 44.2 | 5 | oui |
| 5 | north_plain | procedural | twosides+large_rooms+mixed | 3x2 | 12x12 | 5 | 1 | 5/8.0/14 | 8.4 | 1.4 | 2.2 | 0.6 | 33.6 | 5 | oui |
| 6 | north_plain | procedural | twosides+large_rooms+mixed | 4x2 | 15x11 | 5 | 2 | 4/5.8/8 | 5.4 | 1.0 | 1.8 | 0.6 | 32.2 | 5 | oui |
| 7 | north_plain | procedural | twosides+large_rooms+mixed | 3x4 | 10x10 | 5 | 1 | 5/6.8/10 | 7.2 | 1.4 | 1.8 | 0.8 | 34.4 | 5 | oui |
| 8 | north_plain | procedural | twosides+large_rooms+mixed | 4x4 | 10x9 | 5 | 0 | 6/7.8/11 | 9.4 | 1.4 | 1.8 | 0.8 | 42.2 | 5 | oui |
| 9 | north_plain | procedural | twosides+large_rooms+mixed | 4x3 | 11x9 | 5 | 1 | 4/7.8/14 | 8.8 | 1.6 | 1.6 | 1.0 | 34.8 | 5 | oui |
| 10 | north_plain | procedural | twosides+large_rooms+mixed | 4x2 | 13x13 | 5 | 2 | 5/6.8/11 | 6.6 | 1.2 | 2.0 | 0.6 | 37.4 | 5 | oui |
| 11 | north_plain | procedural | twosides+large_rooms+mixed | 3x4 | 11x9 | 5 | 0 | 8/9.8/16 | 11.4 | 2.0 | 2.2 | 1.0 | 40.0 | 5 | oui |
| 12 | north_plain | procedural | twosides+large_rooms+mixed | 4x2 | 14x10 | 5 | 0 | 6/9.8/16 | 11.6 | 2.4 | 2.4 | 1.2 | 37.8 | 5 | oui |
| 13 | north_plain | procedural | twosides+large_rooms+mixed | 4x4 | 12x8 | 5 | 1 | 4/9.2/17 | 10.2 | 1.8 | 2.2 | 0.8 | 32.4 | 5 | oui |
| 14 | north_plain | procedural | twosides+large_rooms+mixed | 5x3 | 9x8 | 5 | 0 | 4/6.6/8 | 7.8 | 1.0 | 1.6 | 0.8 | 41.0 | 5 | oui |
| 15 | north_plain | procedural | twosides+large_rooms+mixed | 6x4 | 9x7 | 5 | 1 | 5/8.4/12 | 9.4 | 2.2 | 2.4 | 1.0 | 48.2 | 5 | oui |
| 16 | gale_plain | procedural | looping+mixed+large_rooms | 6x3 | 11x8 | 5 | 1 | 4/9.4/14 | 11.0 | 2.6 | 1.8 | 1.4 | 43.6 | 5 | oui |
| 17 | gale_plain | procedural | looping+mixed+large_rooms | 7x3 | 10x9 | 5 | 0 | 8/12.2/19 | 15.0 | 3.8 | 1.6 | 2.4 | 36.0 | 5 | oui |
| 18 | gale_plain | procedural | looping+mixed+large_rooms | 5x3 | 12x8 | 5 | 1 | 8/13.0/20 | 16.4 | 4.0 | 1.2 | 2.6 | 34.6 | 5 | oui |
| 19 | gale_plain | procedural | looping+mixed+large_rooms | 5x4 | 10x10 | 5 | 0 | 7/11.2/16 | 13.2 | 4.0 | 1.8 | 2.2 | 37.8 | 5 | oui |
| 20 | gale_plain | procedural | looping+mixed+large_rooms | 4x3 | 9x8 | 5 | 0 | 8/11.2/14 | 13.0 | 4.0 | 1.8 | 2.2 | 36.8 | 5 | oui |
| 21 | gale_plain | procedural | looping+mixed+large_rooms | 4x4 | 10x8 | 5 | 0 | 4/10.6/17 | 12.4 | 3.8 | 1.8 | 2.0 | 41.8 | 5 | oui |
| 22 | gale_plain | procedural | looping+mixed+large_rooms | 7x3 | 14x11 | 5 | 0 | 8/12.2/17 | 14.8 | 4.0 | 2.8 | 1.8 | 37.4 | 5 | oui |
| 23 | gale_plain | procedural | looping+mixed+large_rooms | 5x3 | 10x10 | 5 | 0 | 7/11.6/21 | 13.8 | 3.8 | 3.0 | 1.6 | 36.4 | 5 | oui |
| 24 | gale_plain | procedural | looping+mixed+large_rooms | 4x4 | 12x8 | 5 | 1 | 7/11.0/21 | 12.4 | 2.4 | 1.6 | 1.6 | 46.2 | 5 | oui |
| 25 | gale_plain | procedural | looping+mixed+large_rooms | 5x3 | 9x10 | 5 | 0 | 6/11.2/17 | 12.4 | 3.2 | 2.8 | 1.6 | 39.0 | 5 | oui |
| 26 | gale_plain | procedural | looping+mixed+large_rooms | 5x4 | 10x10 | 5 | 0 | 4/8.6/14 | 9.8 | 2.4 | 1.2 | 1.6 | 43.2 | 5 | oui |
| 27 | gale_plain | procedural | looping+mixed+large_rooms | 3x3 | 13x11 | 5 | 0 | 8/12.8/18 | 14.2 | 3.4 | 2.6 | 1.8 | 42.2 | 5 | oui |
| 28 | gale_plain | procedural | looping+mixed+large_rooms | 5x3 | 12x9 | 5 | 0 | 8/13.6/26 | 16.0 | 4.0 | 2.2 | 2.2 | 40.6 | 5 | oui |
| 29 | gale_plain | procedural | looping+mixed+large_rooms | 3x2 | 12x10 | 5 | 1 | 5/10.0/20 | 10.6 | 2.8 | 2.6 | 1.2 | 46.8 | 5 | oui |
| 30 | gale_plain | procedural | looping+mixed+large_rooms | 4x2 | 15x13 | 5 | 0 | 7/9.8/13 | 12.2 | 3.6 | 2.2 | 2.0 | 40.6 | 5 | oui |
