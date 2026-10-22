# Rapport de génération — Mt. Blaze

- **ID** : `mt_blaze`  
- **Chapitre** : 10 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Mt. Blaze (12F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/MtBlaze) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 10. Recoupé avec Bulbapedia (page « Mt. Blaze »).  
- **Étages** : 12 — direction `sommet`  
- **Zone écrite** : `Data/Zone/mt_blaze.json`  
- **Gate canonique** : configuration `validated`, runtime `validated`  
- **Seed runtime** : fournie et journalisée par PMDO lors du test moteur ; aucune seed de production n'est écrite dans la zone.  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| blaze_slope | 1-12 | blaze_slope | `mt_blaze_floor` | branching, lattice, looping | 42 | non | non | — |

## Scènes fixes

- entrée : `mont_cendre_pied`
- midpoint : `—`
- Ground de fin : `d09p02`
- boss : mode `canonical_ground` → Ground `d09p02`, rsmap `—`
  - no fixed 'mid' Ground declared
  - final battle stays on the canonical end Ground 'd09p02' (no separate arena created)
  - declared boss Ground 'd09p02' is not among the detected canonical end scenes ['d09p03']

## Étages

| Ét. | Segment | Type | Profil | Grille | Cellule | Variantes OK | Rejets | Rooms (min/moy/max) | Halls | Branches | Culs-de-sac | Boucles | Dist. escaliers | Signatures | Traversable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | blaze_slope | procedural | branching|lattice|looping | 5x5 | 12x9 | 10 | 1 | 11/15.3/20 | 26.7 | 8.3 | 3.9 | 4.8 | 49.3 | 10 | oui |
| 2 | blaze_slope | procedural | branching|lattice|looping | 5x5 | 9x10 | 10 | 2 | 11/15.0/25 | 21.0 | 5.5 | 4.0 | 2.5 | 41.6 | 10 | oui |
| 3 | blaze_slope | procedural | branching|lattice|looping | 5x4 | 9x8 | 10 | 2 | 10/15.2/20 | 25.0 | 8.4 | 4.7 | 4.7 | 39.3 | 10 | oui |
| 4 | blaze_slope | procedural | branching|lattice|looping | 5x5 | 10x10 | 10 | 2 | 8/15.4/22 | 23.5 | 6.6 | 3.7 | 3.3 | 45.3 | 10 | oui |
| 5 | blaze_slope | procedural | branching|lattice|looping | 5x5 | 11x8 | 10 | 1 | 10/15.3/26 | 22.4 | 5.8 | 3.5 | 2.8 | 44.4 | 10 | oui |
| 6 | blaze_slope | procedural | branching|lattice|looping | 7x5 | 11x8 | 10 | 5 | 10/14.8/24 | 21.7 | 6.5 | 4.6 | 2.9 | 43.6 | 10 | oui |
| 7 | blaze_slope | procedural | branching|lattice|looping | 7x4 | 10x10 | 10 | 1 | 12/15.2/19 | 24.0 | 8.2 | 5.3 | 4.0 | 47.4 | 10 | oui |
| 8 | blaze_slope | procedural | branching|lattice|looping | 5x4 | 11x9 | 10 | 3 | 10/14.7/25 | 26.0 | 7.4 | 3.6 | 4.5 | 43.7 | 10 | oui |
| 9 | blaze_slope | procedural | branching|lattice|looping | 6x4 | 12x8 | 10 | 2 | 10/16.6/27 | 22.6 | 6.1 | 5.0 | 2.4 | 45.1 | 10 | oui |
| 10 | blaze_slope | procedural | branching|lattice|looping | 7x5 | 10x9 | 10 | 1 | 9/14.2/18 | 22.7 | 5.7 | 3.8 | 3.3 | 37.7 | 10 | oui |
| 11 | blaze_slope | procedural | branching|lattice|looping | 5x4 | 10x8 | 10 | 0 | 8/16.2/28 | 23.4 | 6.8 | 4.4 | 3.1 | 52.8 | 10 | oui |
| 12 | blaze_slope | procedural | branching|lattice|looping | 5x4 | 9x10 | 10 | 1 | 11/14.7/19 | 24.8 | 8.1 | 4.2 | 4.5 | 45.9 | 10 | oui |
