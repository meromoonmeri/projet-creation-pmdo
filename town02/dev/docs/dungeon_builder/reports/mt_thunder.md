# Rapport de génération — Mt. Thunder

- **ID** : `mt_thunder`  
- **Chapitre** : 9 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Mt. Thunder (10F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/MtThunder) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 9. Recoupé avec Bulbapedia (page « Mt. Thunder »).  
- **Étages** : 10 — direction `sommet`  
- **Zone écrite** : `Data/Zone/mt_thunder.json`  
- **Gate canonique** : configuration `validated`, runtime `validated`  
- **Seed runtime** : fournie et journalisée par PMDO lors du test moteur ; aucune seed de production n'est écrite dans la zone.  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| thunder_slope | 1-10 | thunder_slope | `mt_thunder_floor` | branching, lattice | 47 | non | non | — |

## Scènes fixes

- entrée : `mont_grondant_pied`
- midpoint : `—`
- Ground de fin : `d06p02`
- boss : mode `canonical_ground` → Ground `d06p02`, rsmap `—`
  - no fixed 'mid' Ground declared
  - final battle stays on the canonical end Ground 'd06p02' (no separate arena created)
  - declared boss Ground 'd06p02' is not among the detected canonical end scenes ['d06p03']

## Étages

| Ét. | Segment | Type | Profil | Grille | Cellule | Variantes OK | Rejets | Rooms (min/moy/max) | Halls | Branches | Culs-de-sac | Boucles | Dist. escaliers | Signatures | Traversable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | thunder_slope | procedural | branching|lattice | 5x4 | 12x10 | 10 | 0 | 9/14.7/25 | 20.7 | 6.6 | 4.3 | 3.4 | 43.4 | 10 | oui |
| 2 | thunder_slope | procedural | branching|lattice | 6x4 | 12x10 | 10 | 0 | 10/15.4/22 | 23.7 | 8.0 | 4.8 | 4.5 | 44.8 | 10 | oui |
| 3 | thunder_slope | procedural | branching|lattice | 5x5 | 12x8 | 10 | 0 | 10/15.1/21 | 22.3 | 8.3 | 5.5 | 3.9 | 60.0 | 10 | oui |
| 4 | thunder_slope | procedural | branching|lattice | 6x4 | 9x9 | 10 | 0 | 10/14.3/22 | 21.1 | 7.0 | 4.6 | 3.7 | 45.7 | 10 | oui |
| 5 | thunder_slope | procedural | branching|lattice | 6x5 | 12x8 | 10 | 2 | 11/14.6/20 | 23.1 | 8.0 | 4.4 | 4.5 | 54.3 | 10 | oui |
| 6 | thunder_slope | procedural | branching|lattice | 5x5 | 10x9 | 10 | 1 | 11/14.8/19 | 22.9 | 8.0 | 5.3 | 4.0 | 50.4 | 10 | oui |
| 7 | thunder_slope | procedural | branching|lattice | 3x3 | 12x8 | 10 | 0 | 6/6.7/8 | 7.2 | 2.1 | 2.9 | 0.7 | 31.4 | 10 | oui |
| 8 | thunder_slope | procedural | branching|lattice | 5x4 | 9x10 | 10 | 0 | 11/16.4/22 | 23.1 | 7.9 | 6.2 | 3.5 | 46.3 | 10 | oui |
| 9 | thunder_slope | procedural | branching|lattice | 6x5 | 10x8 | 10 | 1 | 11/17.9/25 | 24.3 | 8.7 | 7.0 | 3.5 | 45.5 | 10 | oui |
| 10 | thunder_slope | procedural | branching|lattice | 5x4 | 10x9 | 10 | 1 | 12/16.1/24 | 23.3 | 8.0 | 4.9 | 4.2 | 50.9 | 10 | oui |
