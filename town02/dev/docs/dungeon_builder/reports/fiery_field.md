# Rapport de génération — Fiery Field

- **ID** : `fiery_field`  
- **Chapitre** : 18 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Fiery Field (30F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/FieryField) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 18. Recoupé avec Bulbapedia (page « Fiery Field »).  
- **Étages** : 30 — direction `sommet`  
- **Zone écrite** : `Data/Zone/fiery_field.json`  
- **Seed d'auteur (debug)** : `64095297481194545` (explicite : False)  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| ember_plain | 1-15 | ember_plain | `deep_dark_crater_floor` | twosides, large_rooms, mixed | 13 | oui | oui | — |
| burning_plain | 16-30 | burning_plain | `deep_dark_crater_floor` | looping, mixed, large_rooms | 10 | oui | oui | — |

## Scènes fixes

- entrée : `—`
- midpoint : `—`
- Ground de fin : `champ_braises`
- boss : mode `canonical_ground` → Ground `champ_braises`, rsmap `—`
  - no fixed 'entrance' Ground declared
  - no fixed 'mid' Ground declared
  - final battle stays on the canonical end Ground 'champ_braises' (no separate arena created)

## Étages

| Ét. | Segment | Type | Profil | Grille | Cellule | Variantes OK | Rejets | Rooms (min/moy/max) | Halls | Branches | Culs-de-sac | Boucles | Dist. escaliers | Signatures | Traversable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | ember_plain | procedural | twosides+large_rooms+mixed | 4x2 | 14x11 | 5 | 0 | 4/7.4/11 | 9.4 | 2.0 | 1.2 | 1.4 | 52.8 | 5 | oui |
| 2 | ember_plain | procedural | twosides+large_rooms+mixed | 7x4 | 11x12 | 5 | 1 | 5/8.2/14 | 9.0 | 1.6 | 2.2 | 0.8 | 41.2 | 5 | oui |
| 3 | ember_plain | procedural | twosides+large_rooms+mixed | 4x5 | 14x7 | 5 | 1 | 5/6.0/8 | 6.2 | 1.2 | 2.4 | 0.4 | 38.2 | 5 | oui |
| 4 | ember_plain | procedural | twosides+large_rooms+mixed | 3x3 | 10x9 | 5 | 3 | 5/10.4/26 | 10.6 | 2.0 | 2.4 | 1.0 | 35.8 | 5 | oui |
| 5 | ember_plain | procedural | twosides+large_rooms+mixed | 7x4 | 12x7 | 5 | 3 | 6/11.6/23 | 13.2 | 2.8 | 3.8 | 0.8 | 39.4 | 5 | oui |
| 6 | ember_plain | procedural | twosides+large_rooms+mixed | 3x2 | 16x11 | 5 | 1 | 5/6.4/8 | 6.8 | 1.4 | 1.8 | 0.8 | 46.0 | 5 | oui |
| 7 | ember_plain | procedural | twosides+large_rooms+mixed | 4x3 | 15x12 | 5 | 1 | 4/7.4/13 | 8.4 | 1.8 | 1.4 | 1.2 | 37.8 | 5 | oui |
| 8 | ember_plain | procedural | twosides+large_rooms+mixed | 7x3 | 10x12 | 5 | 0 | 5/7.6/13 | 8.8 | 1.4 | 2.2 | 0.6 | 31.6 | 5 | oui |
| 9 | ember_plain | procedural | twosides+large_rooms+mixed | 3x4 | 12x8 | 5 | 1 | 4/8.2/23 | 8.4 | 1.4 | 3.2 | 0.4 | 44.6 | 5 | oui |
| 10 | ember_plain | procedural | twosides+large_rooms+mixed | 4x3 | 10x11 | 5 | 0 | 4/7.0/9 | 8.0 | 1.2 | 2.0 | 0.6 | 44.6 | 5 | oui |
| 11 | ember_plain | procedural | twosides+large_rooms+mixed | 4x2 | 12x12 | 5 | 0 | 6/6.6/8 | 7.8 | 1.0 | 1.4 | 0.8 | 38.4 | 5 | oui |
| 12 | ember_plain | procedural | twosides+large_rooms+mixed | 5x4 | 12x11 | 5 | 0 | 5/8.6/15 | 10.2 | 2.4 | 2.0 | 1.2 | 39.4 | 5 | oui |
| 13 | ember_plain | procedural | twosides+large_rooms+mixed | 4x4 | 10x9 | 5 | 2 | 4/9.2/14 | 9.6 | 2.2 | 2.0 | 1.2 | 32.8 | 5 | oui |
| 14 | ember_plain | procedural | twosides+large_rooms+mixed | 4x3 | 13x11 | 5 | 1 | 5/7.6/11 | 7.4 | 1.2 | 2.8 | 0.2 | 37.6 | 5 | oui |
| 15 | ember_plain | procedural | twosides+large_rooms+mixed | 3x4 | 11x10 | 5 | 1 | 5/9.0/20 | 10.6 | 2.4 | 2.4 | 1.2 | 29.4 | 5 | oui |
| 16 | burning_plain | procedural | looping+mixed+large_rooms | 4x4 | 10x8 | 5 | 1 | 4/10.0/17 | 11.2 | 2.4 | 2.2 | 1.2 | 44.2 | 5 | oui |
| 17 | burning_plain | procedural | looping+mixed+large_rooms | 4x3 | 10x9 | 5 | 0 | 5/11.6/16 | 13.4 | 3.6 | 1.6 | 2.0 | 37.2 | 5 | oui |
| 18 | burning_plain | procedural | looping+mixed+large_rooms | 7x3 | 12x11 | 5 | 0 | 8/13.8/25 | 16.6 | 4.2 | 2.4 | 2.4 | 35.6 | 5 | oui |
| 19 | burning_plain | procedural | looping+mixed+large_rooms | 3x2 | 12x12 | 5 | 2 | 5/12.6/23 | 15.8 | 4.4 | 2.2 | 2.4 | 37.8 | 5 | oui |
| 20 | burning_plain | procedural | looping+mixed+large_rooms | 4x3 | 9x9 | 5 | 1 | 5/10.4/18 | 12.8 | 3.6 | 1.4 | 2.4 | 36.0 | 5 | oui |
| 21 | burning_plain | procedural | looping+mixed+large_rooms | 4x4 | 12x10 | 5 | 0 | 7/14.6/24 | 18.2 | 5.2 | 3.2 | 2.4 | 40.2 | 5 | oui |
| 22 | burning_plain | procedural | looping+mixed+large_rooms | 4x4 | 11x10 | 5 | 0 | 4/14.0/23 | 15.6 | 4.2 | 3.0 | 1.8 | 47.0 | 5 | oui |
| 23 | burning_plain | procedural | looping+mixed+large_rooms | 7x3 | 10x11 | 5 | 0 | 8/10.6/13 | 12.6 | 3.2 | 1.0 | 2.2 | 40.6 | 5 | oui |
| 24 | burning_plain | procedural | looping+mixed+large_rooms | 4x3 | 14x12 | 5 | 0 | 5/9.6/14 | 11.4 | 3.0 | 1.8 | 1.8 | 40.4 | 5 | oui |
| 25 | burning_plain | procedural | looping+mixed+large_rooms | 5x3 | 10x8 | 5 | 0 | 8/13.0/25 | 15.6 | 3.4 | 1.6 | 2.0 | 37.8 | 5 | oui |
| 26 | burning_plain | procedural | looping+mixed+large_rooms | 4x3 | 10x9 | 5 | 0 | 8/13.0/17 | 15.4 | 5.2 | 2.4 | 2.4 | 35.0 | 5 | oui |
| 27 | burning_plain | procedural | looping+mixed+large_rooms | 4x5 | 14x10 | 5 | 1 | 5/10.2/19 | 11.8 | 2.4 | 1.8 | 1.4 | 43.6 | 5 | oui |
| 28 | burning_plain | procedural | looping+mixed+large_rooms | 4x4 | 14x9 | 5 | 0 | 4/11.6/17 | 13.6 | 3.8 | 2.2 | 2.0 | 36.8 | 5 | oui |
| 29 | burning_plain | procedural | looping+mixed+large_rooms | 4x4 | 9x10 | 5 | 0 | 7/15.6/30 | 18.6 | 5.6 | 3.2 | 2.6 | 46.6 | 5 | oui |
| 30 | burning_plain | procedural | looping+mixed+large_rooms | 6x3 | 11x9 | 5 | 0 | 7/10.2/16 | 12.6 | 3.8 | 1.6 | 2.2 | 42.4 | 5 | oui |
