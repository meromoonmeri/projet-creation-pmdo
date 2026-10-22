# Rapport de génération — Frosty Forest

- **ID** : `frosty_forest`  
- **Chapitre** : 11 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Frosty Forest (9F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/FrostyForest) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 11. Recoupé avec Bulbapedia (page « Frosty Forest »).  
- **Étages** : 9 — direction `sommet`  
- **Zone écrite** : `Data/Zone/frosty_forest.json`  
- **Seed d'auteur (debug)** : `8551319622303074313` (explicite : False)  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| frosty_edge | 1-9 | frosty_edge | `frosty_forest_floor` | branching, dense, mixed | 8 | oui | oui | — |

## Scènes fixes

- entrée : `foret_givree_oree`
- midpoint : `frosty_forest_midpoint`
- Ground de fin : `d10p03`
- boss : mode `canonical_ground` → Ground `d10p03`, rsmap `—`
  - final battle stays on the canonical end Ground 'd10p03' (no separate arena created)

## Étages

| Ét. | Segment | Type | Profil | Grille | Cellule | Variantes OK | Rejets | Rooms (min/moy/max) | Halls | Branches | Culs-de-sac | Boucles | Dist. escaliers | Signatures | Traversable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | frosty_edge | procedural | branching+dense+mixed | 5x3 | 12x9 | 5 | 0 | 6/13.6/25 | 15.4 | 4.2 | 4.4 | 1.2 | 37.8 | 5 | oui |
| 2 | frosty_edge | procedural | branching+dense+mixed | 4x5 | 12x10 | 5 | 0 | 10/17.0/25 | 20.2 | 6.6 | 4.8 | 2.0 | 36.2 | 5 | oui |
| 3 | frosty_edge | procedural | branching+dense+mixed | 5x4 | 9x9 | 5 | 0 | 13/18.6/28 | 22.0 | 7.2 | 6.8 | 1.6 | 43.0 | 5 | oui |
| 4 | frosty_edge | procedural | branching+dense+mixed | 4x3 | 11x10 | 5 | 0 | 10/14.0/17 | 17.2 | 5.6 | 4.6 | 1.6 | 35.8 | 5 | oui |
| 5 | frosty_edge | procedural | branching+dense+mixed | 7x5 | 7x6 | 5 | 1 | 6/16.2/23 | 19.4 | 6.2 | 4.4 | 2.6 | 39.6 | 5 | oui |
| 6 | frosty_edge | procedural | branching+dense+mixed | 4x3 | 10x8 | 5 | 1 | 10/14.2/23 | 16.2 | 5.4 | 4.6 | 1.6 | 40.4 | 5 | oui |
| 7 | frosty_edge | procedural | branching+dense+mixed | 4x3 | 9x10 | 5 | 1 | 10/17.4/24 | 22.6 | 6.0 | 5.0 | 2.4 | 38.0 | 5 | oui |
| 8 | frosty_edge | procedural | branching+dense+mixed | 5x3 | 12x10 | 5 | 1 | 7/12.6/26 | 14.4 | 4.6 | 4.6 | 1.2 | 40.6 | 5 | oui |
| 9 | frosty_edge | procedural | branching+dense+mixed | 4x4 | 12x9 | 5 | 0 | 10/15.4/26 | 17.2 | 5.4 | 6.0 | 1.0 | 41.4 | 5 | oui |
