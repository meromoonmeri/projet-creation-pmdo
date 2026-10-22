# Rapport de génération — Howling Forest

- **ID** : `howling_forest`  
- **Chapitre** : 25 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Howling Forest (15F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/HowlingForest) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 25. Recoupé avec Bulbapedia (page « Howling Forest »).  
- **Étages** : 15 — direction `sommet`  
- **Zone écrite** : `Data/Zone/howling_forest.json`  
- **Seed d'auteur (debug)** : `478616200503809045` (explicite : False)  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| howling_edge | 1-8 | howling_edge | `howling_forest_2_floor` | branching, dense, mixed | 7 | oui | oui | — |
| howling_heart | 9-15 | howling_heart | `howling_forest_2_floor` | looping, branching, mixed | 9 | oui | oui | — |

## Scènes fixes

- entrée : `—`
- midpoint : `—`
- Ground de fin : `bois_des_plaintes`
- boss : mode `canonical_ground` → Ground `bois_des_plaintes`, rsmap `—`
  - no fixed 'entrance' Ground declared
  - no fixed 'mid' Ground declared
  - final battle stays on the canonical end Ground 'bois_des_plaintes' (no separate arena created)

## Étages

| Ét. | Segment | Type | Profil | Grille | Cellule | Variantes OK | Rejets | Rooms (min/moy/max) | Halls | Branches | Culs-de-sac | Boucles | Dist. escaliers | Signatures | Traversable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | howling_edge | procedural | branching+dense+mixed | 7x4 | 10x9 | 5 | 1 | 10/14.0/19 | 15.6 | 3.6 | 3.2 | 1.6 | 38.2 | 5 | oui |
| 2 | howling_edge | procedural | branching+dense+mixed | 7x4 | 8x7 | 5 | 0 | 9/16.0/22 | 18.6 | 5.6 | 5.0 | 1.8 | 34.2 | 5 | oui |
| 3 | howling_edge | procedural | branching+dense+mixed | 8x5 | 8x6 | 5 | 0 | 10/17.2/25 | 20.2 | 6.0 | 5.0 | 1.6 | 47.6 | 5 | oui |
| 4 | howling_edge | procedural | branching+dense+mixed | 5x3 | 9x10 | 5 | 0 | 11/18.0/28 | 21.0 | 6.4 | 5.4 | 1.8 | 30.8 | 5 | oui |
| 5 | howling_edge | procedural | branching+dense+mixed | 5x4 | 10x8 | 5 | 1 | 7/14.4/27 | 16.2 | 5.0 | 4.8 | 1.6 | 38.2 | 5 | oui |
| 6 | howling_edge | procedural | branching+dense+mixed | 5x4 | 9x9 | 5 | 1 | 6/13.4/21 | 15.4 | 5.0 | 4.2 | 1.6 | 41.0 | 5 | oui |
| 7 | howling_edge | procedural | branching+dense+mixed | 7x4 | 7x6 | 5 | 1 | 7/12.8/21 | 14.2 | 3.8 | 4.2 | 1.0 | 39.8 | 5 | oui |
| 8 | howling_edge | procedural | branching+dense+mixed | 8x5 | 7x7 | 5 | 0 | 6/17.4/26 | 21.2 | 6.4 | 3.4 | 3.0 | 37.8 | 5 | oui |
| 9 | howling_heart | procedural | looping+branching+mixed | 6x3 | 10x11 | 5 | 0 | 10/14.6/23 | 16.6 | 4.6 | 3.8 | 1.8 | 31.6 | 5 | oui |
| 10 | howling_heart | procedural | looping+branching+mixed | 7x4 | 8x10 | 5 | 0 | 10/11.4/13 | 13.2 | 4.4 | 3.4 | 1.8 | 38.6 | 5 | oui |
| 11 | howling_heart | procedural | looping+branching+mixed | 4x4 | 12x9 | 5 | 1 | 7/12.4/16 | 13.6 | 3.8 | 3.6 | 1.2 | 38.6 | 5 | oui |
| 12 | howling_heart | procedural | looping+branching+mixed | 5x4 | 9x10 | 5 | 0 | 8/12.2/16 | 13.4 | 4.0 | 3.6 | 1.6 | 44.8 | 5 | oui |
| 13 | howling_heart | procedural | looping+branching+mixed | 6x4 | 9x10 | 5 | 0 | 10/12.0/16 | 13.0 | 3.8 | 3.0 | 1.6 | 45.8 | 5 | oui |
| 14 | howling_heart | procedural | looping+branching+mixed | 4x4 | 9x8 | 5 | 0 | 8/13.8/21 | 16.0 | 5.2 | 3.2 | 2.2 | 43.8 | 5 | oui |
| 15 | howling_heart | procedural | looping+branching+mixed | 4x3 | 11x8 | 5 | 0 | 10/13.4/17 | 14.8 | 4.2 | 3.6 | 1.6 | 39.0 | 5 | oui |
