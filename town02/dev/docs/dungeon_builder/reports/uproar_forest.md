# Rapport de génération — Uproar Forest

- **ID** : `uproar_forest`  
- **Chapitre** : 22 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Uproar Forest (10F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/UproarForest) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 22. Recoupé avec Bulbapedia (page « Uproar Forest »).  
- **Étages** : 10 — direction `fond`  
- **Zone écrite** : `Data/Zone/uproar_forest.json`  
- **Seed d'auteur (debug)** : `7069874675371842336` (explicite : False)  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| uproar_edge | 1-5 | uproar_edge | `treeshroud_forest_2_floor` | branching, dense, mixed | 5 | oui | oui | — |
| uproar_heart | 6-10 | uproar_heart | `treeshroud_forest_2_floor` | looping, branching, mixed | 5 | oui | oui | — |

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
| 1 | uproar_edge | procedural | branching+dense+mixed | 8x4 | 8x6 | 5 | 1 | 10/14.4/21 | 16.2 | 4.4 | 3.6 | 1.8 | 38.6 | 5 | oui |
| 2 | uproar_edge | procedural | branching+dense+mixed | 5x4 | 12x9 | 5 | 1 | 10/13.2/23 | 15.0 | 4.6 | 4.8 | 1.4 | 39.4 | 5 | oui |
| 3 | uproar_edge | procedural | branching+dense+mixed | 6x4 | 8x9 | 5 | 1 | 6/12.8/20 | 15.4 | 3.6 | 3.4 | 1.6 | 40.6 | 5 | oui |
| 4 | uproar_edge | procedural | branching+dense+mixed | 6x3 | 8x8 | 5 | 1 | 7/13.6/18 | 15.4 | 4.2 | 4.0 | 1.2 | 41.8 | 5 | oui |
| 5 | uproar_edge | procedural | branching+dense+mixed | 6x5 | 8x6 | 5 | 1 | 8/17.4/28 | 20.4 | 6.0 | 4.6 | 1.8 | 43.2 | 5 | oui |
| 6 | uproar_heart | procedural | looping+branching+mixed | 5x4 | 12x8 | 5 | 0 | 9/13.2/15 | 15.6 | 4.6 | 2.6 | 2.2 | 33.8 | 5 | oui |
| 7 | uproar_heart | procedural | looping+branching+mixed | 4x4 | 11x10 | 5 | 0 | 8/9.6/11 | 12.0 | 3.8 | 2.0 | 2.2 | 44.0 | 5 | oui |
| 8 | uproar_heart | procedural | looping+branching+mixed | 5x4 | 11x9 | 5 | 0 | 10/13.2/18 | 15.4 | 4.2 | 2.8 | 1.8 | 34.6 | 5 | oui |
| 9 | uproar_heart | procedural | looping+branching+mixed | 5x3 | 12x8 | 5 | 0 | 8/12.0/21 | 12.4 | 3.2 | 3.4 | 1.0 | 33.2 | 5 | oui |
| 10 | uproar_heart | procedural | looping+branching+mixed | 5x3 | 10x8 | 5 | 0 | 6/9.6/13 | 10.2 | 2.8 | 3.2 | 1.0 | 34.0 | 5 | oui |
