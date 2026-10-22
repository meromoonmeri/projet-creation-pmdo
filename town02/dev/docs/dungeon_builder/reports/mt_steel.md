# Rapport de génération — Mt. Steel

- **ID** : `mt_steel`  
- **Chapitre** : 7 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Mt. Steel (9F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/MtSteel) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 7. Recoupé avec Bulbapedia (page « Mt. Steel »).  
- **Étages** : 8 — direction `sommet`  
- **Zone écrite** : `Data/Zone/mt_steel.json`  
- **Gate canonique** : configuration `validated`, runtime `validated`  
- **Seed runtime** : fournie et journalisée par PMDO lors du test moteur ; aucune seed de production n'est écrite dans la zone.  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| steel_slope | 1-8 | steel_slope | `mt_steel_1_floor` | branching, lattice | 38 | non | non | — |

## Scènes fixes

- entrée : `pic_ferreux_pied`
- midpoint : `—`
- Ground de fin : `d03p02`
- boss : mode `canonical_ground` → Ground `d03p02`, rsmap `mt_steel_boss`
  - no fixed 'mid' Ground declared
  - final battle stays on the canonical end Ground 'd03p02' (no separate arena created)
  - scene source of truth: mt_steel_boss.rsmap matches the end Ground

## Étages

| Ét. | Segment | Type | Profil | Grille | Cellule | Variantes OK | Rejets | Rooms (min/moy/max) | Halls | Branches | Culs-de-sac | Boucles | Dist. escaliers | Signatures | Traversable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | steel_slope | procedural | branching|lattice | 5x5 | 9x8 | 10 | 0 | 10/16.2/25 | 23.4 | 7.8 | 5.4 | 3.9 | 48.2 | 10 | oui |
| 2 | steel_slope | procedural | branching|lattice | 6x4 | 12x8 | 10 | 0 | 11/15.8/22 | 22.5 | 7.4 | 5.4 | 3.6 | 60.7 | 10 | oui |
| 3 | steel_slope | procedural | branching|lattice | 6x4 | 12x10 | 10 | 2 | 10/15.7/21 | 22.6 | 7.4 | 5.6 | 3.5 | 47.5 | 10 | oui |
| 4 | steel_slope | procedural | branching|lattice | 6x5 | 10x10 | 10 | 1 | 11/17.3/25 | 23.2 | 7.6 | 5.7 | 3.3 | 45.9 | 10 | oui |
| 5 | steel_slope | procedural | branching|lattice | 6x4 | 12x9 | 10 | 0 | 10/14.7/21 | 22.5 | 7.6 | 4.4 | 4.3 | 47.3 | 10 | oui |
| 6 | steel_slope | procedural | branching|lattice | 5x4 | 11x10 | 10 | 0 | 13/16.8/24 | 25.0 | 9.0 | 6.1 | 4.3 | 47.0 | 10 | oui |
| 7 | steel_slope | procedural | branching|lattice | 5x5 | 12x10 | 10 | 3 | 11/16.9/24 | 23.0 | 7.6 | 5.7 | 3.5 | 48.9 | 10 | oui |
| 8 | steel_slope | procedural | branching|lattice | 6x4 | 9x8 | 10 | 0 | 11/15.7/23 | 24.0 | 8.9 | 5.8 | 4.5 | 42.5 | 10 | oui |
