# Rapport de génération — Mt. Freeze

- **ID** : `mt_freeze`  
- **Chapitre** : 11 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Mt. Freeze (15F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/MtFreeze) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 11. Recoupé avec Bulbapedia (page « Mt. Freeze »).  
- **Étages** : 15 — direction `sommet`  
- **Zone écrite** : `Data/Zone/mt_freeze.json`  
- **Gate canonique** : configuration `validated`, runtime `validated`  
- **Seed runtime** : fournie et journalisée par PMDO lors du test moteur ; aucune seed de production n'est écrite dans la zone.  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| freeze_slope | 1-15 | freeze_slope | `mt_freeze_floor` | branching, lattice, looping | 49 | non | non | — |

## Scènes fixes

- entrée : `mont_gele_pied`
- midpoint : `—`
- Ground de fin : `d11p02`
- boss : mode `canonical_ground` → Ground `d11p02`, rsmap `—`
  - no fixed 'mid' Ground declared
  - final battle stays on the canonical end Ground 'd11p02' (no separate arena created)
  - declared boss Ground 'd11p02' is not among the detected canonical end scenes ['d11p03']

## Étages

| Ét. | Segment | Type | Profil | Grille | Cellule | Variantes OK | Rejets | Rooms (min/moy/max) | Halls | Branches | Culs-de-sac | Boucles | Dist. escaliers | Signatures | Traversable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | freeze_slope | procedural | branching|lattice|looping | 6x5 | 10x9 | 10 | 4 | 9/15.7/23 | 22.1 | 6.8 | 4.6 | 3.1 | 46.6 | 10 | oui |
| 2 | freeze_slope | procedural | branching|lattice|looping | 5x4 | 12x8 | 10 | 1 | 12/17.9/26 | 25.4 | 7.6 | 5.5 | 3.4 | 41.9 | 10 | oui |
| 3 | freeze_slope | procedural | branching|lattice|looping | 5x5 | 10x9 | 10 | 1 | 10/15.2/24 | 22.2 | 6.2 | 3.9 | 2.8 | 48.1 | 10 | oui |
| 4 | freeze_slope | procedural | branching|lattice|looping | 5x4 | 11x10 | 10 | 2 | 11/16.0/24 | 23.7 | 7.3 | 5.0 | 3.6 | 52.5 | 10 | oui |
| 5 | freeze_slope | procedural | branching|lattice|looping | 7x4 | 9x10 | 10 | 1 | 10/15.4/20 | 27.6 | 8.7 | 3.8 | 5.4 | 55.5 | 10 | oui |
| 6 | freeze_slope | procedural | branching|lattice|looping | 5x4 | 9x8 | 10 | 1 | 11/15.0/23 | 24.2 | 7.0 | 4.1 | 3.7 | 40.7 | 10 | oui |
| 7 | freeze_slope | procedural | branching|lattice|looping | 6x5 | 9x8 | 10 | 0 | 9/14.4/20 | 22.5 | 6.6 | 3.8 | 3.3 | 45.4 | 10 | oui |
| 8 | freeze_slope | procedural | branching|lattice|looping | 5x5 | 11x9 | 10 | 1 | 9/15.9/28 | 24.3 | 6.5 | 3.8 | 3.3 | 43.8 | 10 | oui |
| 9 | freeze_slope | procedural | branching|lattice|looping | 7x5 | 10x10 | 10 | 1 | 10/14.6/25 | 22.2 | 5.4 | 3.7 | 2.5 | 45.0 | 10 | oui |
| 10 | freeze_slope | procedural | branching|lattice|looping | 7x5 | 12x10 | 10 | 1 | 9/15.2/27 | 28.0 | 9.2 | 3.5 | 5.9 | 54.3 | 10 | oui |
| 11 | freeze_slope | procedural | branching|lattice|looping | 7x4 | 10x8 | 10 | 1 | 11/14.1/19 | 24.3 | 7.8 | 3.8 | 4.7 | 50.1 | 10 | oui |
| 12 | freeze_slope | procedural | branching|lattice|looping | 5x4 | 10x8 | 10 | 1 | 12/16.2/26 | 22.7 | 6.8 | 4.8 | 3.3 | 46.8 | 10 | oui |
| 13 | freeze_slope | procedural | branching|lattice|looping | 6x4 | 10x10 | 10 | 0 | 10/14.9/22 | 22.6 | 6.6 | 4.4 | 3.0 | 40.5 | 10 | oui |
| 14 | freeze_slope | procedural | branching|lattice|looping | 7x5 | 10x8 | 10 | 1 | 11/13.8/19 | 23.9 | 6.5 | 3.9 | 3.7 | 45.3 | 10 | oui |
| 15 | freeze_slope | procedural | branching|lattice|looping | 5x5 | 10x10 | 10 | 2 | 10/16.9/27 | 25.7 | 8.0 | 4.9 | 4.0 | 44.8 | 10 | oui |
