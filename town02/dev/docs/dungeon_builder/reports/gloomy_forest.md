# Rapport de génération — Sinister Woods

- **ID** : `gloomy_forest`  
- **Chapitre** : 6 (main)  
- **Source canonique** : Pokémon Mystery Dungeon: Rescue Team (Red/Blue Rescue Team & Rescue Team DX) — Sinister Woods, B1F-B12F. Species/items adapted to PMDO spawn tables and rescaled to New Era chapter 6 (30 years later).  
- **Étages** : 14 — direction `fond`  
- **Zone écrite** : `Data/Zone/gloomy_forest.json`  
- **Seed d'auteur (debug)** : `2101663151294867089` (explicite : False)  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| Lisière hantée | 1-5 | forest_edge | `sinister_woods_b41` | branching, dense, mixed, crossroads | 9 | oui | oui | fog, light_rain |
| Bois profonds | 6-10 | deep_forest | `sinister_woods_b41` | looping, branching, large_rooms, mixed, ring | 9 | oui | oui | fog, light_rain |
| Clairière du Filou | 11-14 | forest_clearing | `sinister_woods_b41` | mixed, large_rooms, looping, branching | 9 | oui | oui | fog, light_rain |

## Scènes fixes

- entrée : `—`
- midpoint : `gloomy_forest_midpoint`
- Ground de fin : `sinister_woods_clearing`
- boss : mode `canonical_ground` → Ground `sinister_woods_clearing`, rsmap `—`
  - no fixed 'entrance' Ground declared
  - final battle stays on the canonical end Ground 'sinister_woods_clearing' (no separate arena created)

## Étages

| Ét. | Segment | Type | Profil | Grille | Cellule | Variantes OK | Rejets | Rooms (min/moy/max) | Halls | Branches | Culs-de-sac | Boucles | Dist. escaliers | Signatures | Traversable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | Lisière hantée | procedural | branching+dense+mixed+crossroads | 6x3 | 9x9 | 5 | 1 | 8/13.2/21 | 13.8 | 3.2 | 4.0 | 1.0 | 42.8 | 5 | oui |
| 2 | Lisière hantée | procedural | branching+dense+mixed+crossroads | 6x5 | 13x10 | 5 | 0 | 7/11.2/17 | 12.8 | 3.8 | 3.2 | 1.6 | 45.8 | 5 | oui |
| 3 | Lisière hantée | procedural | branching+dense+mixed+crossroads | 7x4 | 12x9 | 5 | 0 | 10/14.6/22 | 16.0 | 4.4 | 4.2 | 1.4 | 39.4 | 5 | oui |
| 4 | Lisière hantée | procedural | branching+dense+mixed+crossroads | 5x5 | 11x10 | 5 | 0 | 7/13.8/20 | 15.8 | 4.8 | 4.4 | 1.6 | 32.0 | 5 | oui |
| 5 | Lisière hantée | procedural | branching+dense+mixed+crossroads | 5x4 | 12x8 | 5 | 0 | 8/11.8/18 | 12.6 | 3.6 | 4.0 | 1.0 | 35.8 | 5 | oui |
| 6 | Bois profonds | procedural | looping+branching+large_rooms+mixed+ring | 4x3 | 11x8 | 5 | 0 | 6/9.6/14 | 11.6 | 3.0 | 2.4 | 1.4 | 35.2 | 5 | oui |
| 7 | Bois profonds | procedural | looping+branching+large_rooms+mixed+ring | 6x4 | 10x9 | 5 | 0 | 7/10.0/17 | 11.8 | 2.6 | 2.6 | 1.2 | 38.4 | 5 | oui |
| 8 | Bois profonds | procedural | looping+branching+large_rooms+mixed+ring | 5x4 | 10x9 | 5 | 0 | 6/10.6/17 | 13.0 | 3.4 | 2.8 | 1.4 | 38.2 | 5 | oui |
| 9 | Bois profonds | procedural | looping+branching+large_rooms+mixed+ring | 4x3 | 9x8 | 5 | 0 | 6/9.4/14 | 11.6 | 2.2 | 1.8 | 1.2 | 37.6 | 5 | oui |
| 10 | Bois profonds | procedural | looping+branching+large_rooms+mixed+ring | 4x4 | 12x9 | 5 | 0 | 5/9.8/18 | 13.8 | 3.6 | 1.8 | 2.0 | 43.2 | 5 | oui |
| 11 | Clairière du Filou | procedural | mixed+large_rooms+looping+branching | 4x3 | 12x13 | 5 | 0 | 8/12.2/19 | 13.4 | 3.2 | 2.4 | 1.6 | 35.6 | 5 | oui |
| 12 | Clairière du Filou | procedural | mixed+large_rooms+looping+branching | 4x4 | 13x11 | 5 | 1 | 5/9.6/17 | 11.2 | 3.6 | 2.6 | 1.6 | 32.6 | 5 | oui |
| 13 | Clairière du Filou | procedural | mixed+large_rooms+looping+branching | 5x4 | 9x9 | 5 | 1 | 4/11.8/25 | 13.6 | 3.4 | 2.6 | 1.8 | 37.4 | 5 | oui |
| 14 | Clairière du Filou | procedural | mixed+large_rooms+looping+branching | 4x5 | 14x8 | 5 | 0 | 8/14.4/25 | 17.6 | 5.4 | 3.0 | 2.6 | 41.8 | 5 | oui |
