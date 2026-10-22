# Rapport de génération — Stormy Sea

- **ID** : `stormy_sea`  
- **Chapitre** : 13 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Stormy Sea (40F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/StormySea) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 13. Recoupé avec Bulbapedia (page « Stormy Sea »).  
- **Étages** : 40 — direction `fond`  
- **Zone écrite** : `Data/Zone/stormy_sea.json`  
- **Seed d'auteur (debug)** : `6053031196769375822` (explicite : False)  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| stormy_shelf | 1-13 | stormy_shelf | `stormy_sea_1_floor` | looping, ring, mixed | 7 | oui | oui | — |
| stormy_deep | 14-27 | stormy_deep | `stormy_sea_1_floor` | ring, lattice, looping | 8 | oui | oui | — |
| stormy_abyss | 28-40 | stormy_abyss | `stormy_sea_1_floor` | large_rooms, looping, mixed | 9 | oui | oui | — |

## Scènes fixes

- entrée : `—`
- midpoint : `—`
- Ground de fin : `abime_tempetes`
- boss : mode `canonical_ground` → Ground `abime_tempetes`, rsmap `—`
  - no fixed 'entrance' Ground declared
  - no fixed 'mid' Ground declared
  - final battle stays on the canonical end Ground 'abime_tempetes' (no separate arena created)

## Étages

| Ét. | Segment | Type | Profil | Grille | Cellule | Variantes OK | Rejets | Rooms (min/moy/max) | Halls | Branches | Culs-de-sac | Boucles | Dist. escaliers | Signatures | Traversable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | stormy_shelf | procedural | looping+ring+mixed | 5x4 | 9x10 | 5 | 1 | 7/9.6/17 | 17.8 | 4.0 | 0.8 | 2.8 | 34.4 | 5 | oui |
| 2 | stormy_shelf | procedural | looping+ring+mixed | 4x3 | 12x7 | 5 | 1 | 7/15.8/25 | 21.2 | 6.8 | 1.8 | 3.8 | 44.2 | 5 | oui |
| 3 | stormy_shelf | procedural | looping+ring+mixed | 4x4 | 12x8 | 5 | 1 | 6/13.8/19 | 17.8 | 3.8 | 1.8 | 2.2 | 45.6 | 5 | oui |
| 4 | stormy_shelf | procedural | looping+ring+mixed | 5x4 | 12x8 | 5 | 0 | 7/11.8/22 | 15.8 | 3.4 | 2.2 | 1.8 | 37.0 | 5 | oui |
| 5 | stormy_shelf | procedural | looping+ring+mixed | 7x5 | 11x7 | 5 | 0 | 6/9.0/12 | 13.4 | 2.6 | 1.2 | 1.8 | 37.2 | 5 | oui |
| 6 | stormy_shelf | procedural | looping+ring+mixed | 5x3 | 9x9 | 5 | 0 | 5/10.8/19 | 16.4 | 3.4 | 1.4 | 2.0 | 40.0 | 5 | oui |
| 7 | stormy_shelf | procedural | looping+ring+mixed | 4x4 | 11x10 | 5 | 0 | 6/9.4/15 | 14.2 | 4.2 | 1.8 | 2.2 | 40.6 | 5 | oui |
| 8 | stormy_shelf | procedural | looping+ring+mixed | 5x3 | 9x12 | 5 | 0 | 6/10.0/14 | 14.2 | 3.0 | 1.4 | 1.8 | 37.6 | 5 | oui |
| 9 | stormy_shelf | procedural | looping+ring+mixed | 4x4 | 12x9 | 5 | 1 | 8/11.2/15 | 15.6 | 4.0 | 1.8 | 2.4 | 32.0 | 5 | oui |
| 10 | stormy_shelf | procedural | looping+ring+mixed | 5x4 | 13x9 | 5 | 1 | 6/11.6/18 | 15.0 | 3.6 | 2.0 | 1.8 | 39.8 | 5 | oui |
| 11 | stormy_shelf | procedural | looping+ring+mixed | 4x4 | 10x9 | 5 | 0 | 8/11.8/23 | 18.2 | 4.4 | 1.8 | 2.6 | 44.2 | 5 | oui |
| 12 | stormy_shelf | procedural | looping+ring+mixed | 4x3 | 10x9 | 5 | 0 | 6/10.6/17 | 15.8 | 4.4 | 1.4 | 2.6 | 44.0 | 5 | oui |
| 13 | stormy_shelf | procedural | looping+ring+mixed | 5x3 | 9x10 | 5 | 1 | 8/10.4/14 | 14.0 | 4.2 | 1.4 | 2.4 | 35.4 | 5 | oui |
| 14 | stormy_deep | procedural | ring+lattice+looping | 5x3 | 12x9 | 5 | 0 | 6/7.8/10 | 14.6 | 4.0 | 1.0 | 2.8 | 49.0 | 5 | oui |
| 15 | stormy_deep | procedural | ring+lattice+looping | 5x3 | 12x9 | 5 | 0 | 5/8.2/11 | 12.2 | 2.8 | 2.4 | 1.4 | 39.0 | 5 | oui |
| 16 | stormy_deep | procedural | ring+lattice+looping | 6x3 | 11x9 | 5 | 1 | 5/8.6/12 | 13.0 | 2.8 | 2.0 | 1.6 | 41.0 | 5 | oui |
| 17 | stormy_deep | procedural | ring+lattice+looping | 5x4 | 10x10 | 5 | 0 | 6/9.2/13 | 19.6 | 6.0 | 2.2 | 4.2 | 35.8 | 5 | oui |
| 18 | stormy_deep | procedural | ring+lattice+looping | 4x4 | 10x9 | 5 | 1 | 7/9.6/15 | 15.0 | 4.4 | 0.8 | 3.0 | 39.8 | 5 | oui |
| 19 | stormy_deep | procedural | ring+lattice+looping | 6x5 | 12x8 | 5 | 0 | 4/7.8/10 | 13.0 | 3.4 | 2.0 | 2.0 | 35.0 | 5 | oui |
| 20 | stormy_deep | procedural | ring+lattice+looping | 4x3 | 11x9 | 5 | 2 | 5/9.2/16 | 12.8 | 2.8 | 2.4 | 1.4 | 35.8 | 5 | oui |
| 21 | stormy_deep | procedural | ring+lattice+looping | 5x4 | 9x8 | 5 | 0 | 7/7.6/9 | 14.0 | 4.2 | 2.0 | 2.6 | 38.2 | 5 | oui |
| 22 | stormy_deep | procedural | ring+lattice+looping | 6x3 | 10x8 | 5 | 1 | 7/8.2/10 | 12.8 | 2.2 | 1.4 | 1.6 | 35.8 | 5 | oui |
| 23 | stormy_deep | procedural | ring+lattice+looping | 4x3 | 9x9 | 5 | 0 | 6/9.8/14 | 21.6 | 6.8 | 2.2 | 4.8 | 36.8 | 5 | oui |
| 24 | stormy_deep | procedural | ring+lattice+looping | 4x4 | 11x8 | 5 | 0 | 4/7.4/10 | 12.6 | 2.6 | 1.4 | 1.8 | 35.4 | 5 | oui |
| 25 | stormy_deep | procedural | ring+lattice+looping | 5x4 | 9x9 | 5 | 0 | 5/9.2/14 | 15.8 | 4.6 | 1.4 | 3.0 | 37.4 | 5 | oui |
| 26 | stormy_deep | procedural | ring+lattice+looping | 4x3 | 12x8 | 5 | 0 | 6/9.0/12 | 17.4 | 4.6 | 1.6 | 3.4 | 47.2 | 5 | oui |
| 27 | stormy_deep | procedural | ring+lattice+looping | 4x4 | 9x9 | 5 | 0 | 6/7.4/9 | 13.4 | 3.0 | 2.0 | 1.8 | 44.4 | 5 | oui |
| 28 | stormy_abyss | procedural | large_rooms+looping+mixed | 4x3 | 15x12 | 5 | 0 | 7/10.4/15 | 12.2 | 3.6 | 2.0 | 2.0 | 44.6 | 5 | oui |
| 29 | stormy_abyss | procedural | large_rooms+looping+mixed | 5x4 | 11x10 | 5 | 0 | 4/9.4/16 | 10.8 | 2.6 | 1.8 | 1.4 | 31.2 | 5 | oui |
| 30 | stormy_abyss | procedural | large_rooms+looping+mixed | 4x3 | 13x13 | 5 | 0 | 4/8.6/12 | 9.6 | 2.4 | 2.0 | 1.2 | 39.8 | 5 | oui |
| 31 | stormy_abyss | procedural | large_rooms+looping+mixed | 6x4 | 12x11 | 5 | 0 | 6/10.0/16 | 11.4 | 2.8 | 2.0 | 1.4 | 41.4 | 5 | oui |
| 32 | stormy_abyss | procedural | large_rooms+looping+mixed | 3x2 | 15x13 | 5 | 0 | 8/11.2/16 | 12.8 | 3.0 | 1.8 | 1.6 | 37.8 | 5 | oui |
| 33 | stormy_abyss | procedural | large_rooms+looping+mixed | 4x3 | 12x10 | 5 | 1 | 9/12.0/15 | 14.2 | 2.8 | 0.6 | 2.2 | 41.0 | 5 | oui |
| 34 | stormy_abyss | procedural | large_rooms+looping+mixed | 3x2 | 16x10 | 5 | 1 | 4/11.6/22 | 13.6 | 4.0 | 3.2 | 1.8 | 45.2 | 5 | oui |
| 35 | stormy_abyss | procedural | large_rooms+looping+mixed | 3x3 | 15x11 | 5 | 1 | 7/10.2/12 | 13.2 | 3.6 | 0.6 | 2.6 | 36.4 | 5 | oui |
| 36 | stormy_abyss | procedural | large_rooms+looping+mixed | 6x4 | 13x8 | 5 | 0 | 4/9.8/17 | 11.4 | 2.8 | 2.0 | 1.6 | 39.2 | 5 | oui |
| 37 | stormy_abyss | procedural | large_rooms+looping+mixed | 4x2 | 13x10 | 5 | 1 | 5/7.0/9 | 7.6 | 1.6 | 1.2 | 1.2 | 39.2 | 5 | oui |
| 38 | stormy_abyss | procedural | large_rooms+looping+mixed | 4x2 | 16x13 | 5 | 0 | 5/9.2/15 | 10.8 | 2.2 | 1.0 | 1.6 | 33.0 | 5 | oui |
| 39 | stormy_abyss | procedural | large_rooms+looping+mixed | 5x5 | 12x9 | 5 | 0 | 6/9.4/12 | 10.4 | 2.2 | 1.4 | 1.4 | 43.6 | 5 | oui |
| 40 | stormy_abyss | procedural | large_rooms+looping+mixed | 3x2 | 15x10 | 5 | 0 | 4/9.6/16 | 10.6 | 2.4 | 2.2 | 1.2 | 35.0 | 5 | oui |
