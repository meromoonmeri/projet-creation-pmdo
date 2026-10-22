# Rapport de génération — Great Canyon

- **ID** : `great_canyon`  
- **Chapitre** : 9 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Great Canyon (12F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/GreatCanyon) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 9. Recoupé avec Bulbapedia (page « Great Canyon »).  
- **Étages** : 12 — direction `sommet`  
- **Zone écrite** : `Data/Zone/great_canyon.json`  
- **Gate canonique** : configuration `validated`, runtime `validated`  
- **Seed runtime** : fournie et journalisée par PMDO lors du test moteur ; aucune seed de production n'est écrite dans la zone.  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| canyon_rim | 1-12 | canyon_rim | `great_canyon_floor` | ring, lattice | 42 | non | non | — |

## Scènes fixes

- entrée : `grand_canyon_porte`
- midpoint : `—`
- Ground de fin : `d07p02`
- boss : mode `canonical_ground` → Ground `d07p02`, rsmap `—`
  - no fixed 'mid' Ground declared
  - final battle stays on the canonical end Ground 'd07p02' (no separate arena created)

## Étages

| Ét. | Segment | Type | Profil | Grille | Cellule | Variantes OK | Rejets | Rooms (min/moy/max) | Halls | Branches | Culs-de-sac | Boucles | Dist. escaliers | Signatures | Traversable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | canyon_rim | procedural | ring|lattice | 5x4 | 11x9 | 10 | 0 | 10/13.3/17 | 27.8 | 8.9 | 2.3 | 6.3 | 59.0 | 10 | oui |
| 2 | canyon_rim | procedural | ring|lattice | 4x3 | 13x10 | 10 | 2 | 6/7.0/9 | 9.9 | 2.7 | 1.4 | 1.8 | 38.8 | 10 | oui |
| 3 | canyon_rim | procedural | ring|lattice | 5x4 | 12x8 | 10 | 3 | 9/13.0/14 | 23.6 | 6.0 | 2.0 | 4.2 | 52.3 | 10 | oui |
| 4 | canyon_rim | procedural | ring|lattice | 4x3 | 11x11 | 10 | 2 | 5/6.5/9 | 9.3 | 2.4 | 1.2 | 1.6 | 33.0 | 10 | oui |
| 5 | canyon_rim | procedural | ring|lattice | 5x4 | 13x10 | 10 | 0 | 11/12.9/15 | 27.0 | 7.9 | 2.9 | 5.2 | 57.7 | 10 | oui |
| 6 | canyon_rim | procedural | ring|lattice | 5x5 | 10x9 | 10 | 3 | 10/13.1/16 | 29.0 | 9.4 | 2.7 | 6.6 | 58.6 | 10 | oui |
| 7 | canyon_rim | procedural | ring|lattice | 4x3 | 11x11 | 10 | 0 | 5/6.8/10 | 9.3 | 2.6 | 1.3 | 1.7 | 30.8 | 10 | oui |
| 8 | canyon_rim | procedural | ring|lattice | 5x4 | 11x11 | 10 | 1 | 11/14.9/19 | 32.7 | 11.0 | 3.0 | 7.8 | 49.8 | 10 | oui |
| 9 | canyon_rim | procedural | ring|lattice | 6x4 | 11x11 | 10 | 1 | 10/14.2/18 | 28.3 | 7.4 | 2.8 | 5.0 | 55.3 | 10 | oui |
| 10 | canyon_rim | procedural | ring|lattice | 5x4 | 12x10 | 10 | 2 | 11/14.0/17 | 27.2 | 6.3 | 2.2 | 4.4 | 65.7 | 10 | oui |
| 11 | canyon_rim | procedural | ring|lattice | 5x5 | 12x9 | 10 | 1 | 12/13.7/16 | 27.6 | 8.7 | 3.4 | 5.9 | 48.9 | 10 | oui |
| 12 | canyon_rim | procedural | ring|lattice | 5x4 | 12x9 | 10 | 2 | 12/14.1/16 | 29.3 | 9.1 | 2.5 | 6.2 | 51.8 | 10 | oui |
