# Rapport de génération — Lightning Field

- **ID** : `lightning_field`  
- **Chapitre** : 20 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Lightning Field (30F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/LightningField) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 20. Recoupé avec Bulbapedia (page « Lightning Field »).  
- **Étages** : 30 — direction `sommet`  
- **Zone écrite** : `Data/Zone/lightning_field.json`  
- **Seed d'auteur (debug)** : `7085726557157956166` (explicite : False)  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| storm_plain | 1-15 | storm_plain | `lightning_field_floor` | twosides, large_rooms, mixed | 11 | oui | oui | — |
| thunder_plain | 16-30 | thunder_plain | `lightning_field_floor` | looping, mixed, large_rooms | 11 | oui | oui | — |

## Scènes fixes

- entrée : `—`
- midpoint : `—`
- Ground de fin : `champ_foudre`
- boss : mode `canonical_ground` → Ground `champ_foudre`, rsmap `—`
  - no fixed 'entrance' Ground declared
  - no fixed 'mid' Ground declared
  - final battle stays on the canonical end Ground 'champ_foudre' (no separate arena created)

## Étages

| Ét. | Segment | Type | Profil | Grille | Cellule | Variantes OK | Rejets | Rooms (min/moy/max) | Halls | Branches | Culs-de-sac | Boucles | Dist. escaliers | Signatures | Traversable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | storm_plain | procedural | twosides+large_rooms+mixed | 5x3 | 9x10 | 5 | 0 | 4/7.8/10 | 9.6 | 2.0 | 2.0 | 1.0 | 33.4 | 5 | oui |
| 2 | storm_plain | procedural | twosides+large_rooms+mixed | 4x3 | 12x8 | 5 | 0 | 5/7.6/14 | 8.8 | 1.6 | 1.8 | 1.0 | 31.2 | 5 | oui |
| 3 | storm_plain | procedural | twosides+large_rooms+mixed | 3x3 | 11x8 | 5 | 2 | 4/10.4/20 | 10.8 | 2.6 | 2.6 | 1.2 | 33.6 | 5 | oui |
| 4 | storm_plain | procedural | twosides+large_rooms+mixed | 4x5 | 14x10 | 5 | 0 | 4/9.0/20 | 10.0 | 1.0 | 1.8 | 0.6 | 31.6 | 5 | oui |
| 5 | storm_plain | procedural | twosides+large_rooms+mixed | 3x4 | 10x9 | 5 | 1 | 4/6.0/9 | 6.4 | 1.0 | 1.8 | 0.6 | 31.2 | 5 | oui |
| 6 | storm_plain | procedural | twosides+large_rooms+mixed | 4x4 | 13x8 | 5 | 1 | 5/6.6/9 | 6.8 | 0.8 | 1.6 | 0.6 | 33.2 | 5 | oui |
| 7 | storm_plain | procedural | twosides+large_rooms+mixed | 7x4 | 8x9 | 5 | 1 | 6/7.2/11 | 8.4 | 1.6 | 2.4 | 0.6 | 44.4 | 5 | oui |
| 8 | storm_plain | procedural | twosides+large_rooms+mixed | 4x4 | 11x10 | 5 | 2 | 5/7.8/11 | 8.4 | 2.2 | 2.4 | 1.0 | 34.4 | 5 | oui |
| 9 | storm_plain | procedural | twosides+large_rooms+mixed | 5x4 | 13x8 | 5 | 1 | 4/6.8/10 | 7.0 | 0.8 | 1.6 | 0.6 | 34.8 | 5 | oui |
| 10 | storm_plain | procedural | twosides+large_rooms+mixed | 3x4 | 10x11 | 5 | 2 | 4/8.4/15 | 9.4 | 3.0 | 2.2 | 1.4 | 38.2 | 5 | oui |
| 11 | storm_plain | procedural | twosides+large_rooms+mixed | 4x3 | 12x10 | 5 | 1 | 5/9.0/19 | 10.8 | 3.0 | 2.2 | 1.8 | 45.8 | 5 | oui |
| 12 | storm_plain | procedural | twosides+large_rooms+mixed | 6x4 | 8x10 | 5 | 2 | 4/9.0/21 | 10.4 | 2.6 | 2.2 | 1.4 | 50.2 | 5 | oui |
| 13 | storm_plain | procedural | twosides+large_rooms+mixed | 4x3 | 11x11 | 5 | 0 | 5/8.6/18 | 10.0 | 1.6 | 2.2 | 0.8 | 32.4 | 5 | oui |
| 14 | storm_plain | procedural | twosides+large_rooms+mixed | 4x4 | 11x9 | 5 | 1 | 5/7.2/14 | 7.6 | 1.4 | 2.2 | 0.6 | 40.4 | 5 | oui |
| 15 | storm_plain | procedural | twosides+large_rooms+mixed | 4x4 | 11x8 | 5 | 3 | 6/7.2/8 | 7.8 | 1.6 | 1.8 | 1.0 | 46.8 | 5 | oui |
| 16 | thunder_plain | procedural | looping+mixed+large_rooms | 3x2 | 13x11 | 5 | 0 | 6/10.2/14 | 12.4 | 3.6 | 2.0 | 2.2 | 38.6 | 5 | oui |
| 17 | thunder_plain | procedural | looping+mixed+large_rooms | 3x2 | 13x10 | 5 | 0 | 6/12.2/18 | 14.2 | 3.8 | 1.2 | 2.4 | 44.4 | 5 | oui |
| 18 | thunder_plain | procedural | looping+mixed+large_rooms | 5x3 | 13x8 | 5 | 0 | 4/11.2/15 | 13.0 | 3.4 | 2.2 | 1.8 | 38.6 | 5 | oui |
| 19 | thunder_plain | procedural | looping+mixed+large_rooms | 7x4 | 12x12 | 5 | 0 | 5/12.2/18 | 15.6 | 3.8 | 1.2 | 2.4 | 36.0 | 5 | oui |
| 20 | thunder_plain | procedural | looping+mixed+large_rooms | 5x5 | 13x10 | 5 | 0 | 4/11.2/16 | 13.6 | 3.6 | 2.0 | 2.0 | 41.2 | 5 | oui |
| 21 | thunder_plain | procedural | looping+mixed+large_rooms | 4x2 | 12x10 | 5 | 0 | 9/14.2/21 | 18.0 | 5.2 | 2.4 | 3.0 | 42.0 | 5 | oui |
| 22 | thunder_plain | procedural | looping+mixed+large_rooms | 3x3 | 13x10 | 5 | 0 | 6/12.0/21 | 14.4 | 4.0 | 1.8 | 2.4 | 34.6 | 5 | oui |
| 23 | thunder_plain | procedural | looping+mixed+large_rooms | 5x3 | 11x9 | 5 | 0 | 5/13.2/19 | 15.2 | 3.4 | 2.6 | 1.8 | 32.8 | 5 | oui |
| 24 | thunder_plain | procedural | looping+mixed+large_rooms | 4x4 | 12x8 | 5 | 1 | 6/11.4/18 | 13.0 | 3.6 | 2.2 | 1.8 | 46.8 | 5 | oui |
| 25 | thunder_plain | procedural | looping+mixed+large_rooms | 4x4 | 9x9 | 5 | 0 | 6/11.0/15 | 12.0 | 2.6 | 2.4 | 1.4 | 37.2 | 5 | oui |
| 26 | thunder_plain | procedural | looping+mixed+large_rooms | 4x3 | 11x9 | 5 | 0 | 5/15.2/27 | 18.0 | 4.2 | 2.2 | 2.2 | 45.0 | 5 | oui |
| 27 | thunder_plain | procedural | looping+mixed+large_rooms | 4x3 | 13x10 | 5 | 0 | 8/11.0/14 | 13.6 | 4.0 | 2.4 | 2.2 | 40.0 | 5 | oui |
| 28 | thunder_plain | procedural | looping+mixed+large_rooms | 5x4 | 12x8 | 5 | 0 | 8/11.2/15 | 13.0 | 3.2 | 2.4 | 1.6 | 34.4 | 5 | oui |
| 29 | thunder_plain | procedural | looping+mixed+large_rooms | 6x4 | 9x8 | 5 | 1 | 5/8.2/16 | 9.6 | 2.6 | 1.6 | 1.6 | 37.4 | 5 | oui |
| 30 | thunder_plain | procedural | looping+mixed+large_rooms | 5x4 | 9x9 | 5 | 0 | 6/8.8/12 | 11.0 | 2.8 | 1.2 | 2.0 | 47.0 | 5 | oui |
