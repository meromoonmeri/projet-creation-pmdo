# Rapport de génération — Silent Chasm

- **ID** : `silent_chasm`  
- **Chapitre** : 8 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Silent Chasm (9F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/SilentChasm) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 8. Recoupé avec Bulbapedia (page « Silent Chasm »).  
- **Étages** : 9 — direction `fond`  
- **Zone écrite** : `Data/Zone/silent_chasm.json`  
- **Gate canonique** : configuration `validated`, runtime `validated`  
- **Seed runtime** : fournie et journalisée par PMDO lors du test moteur ; aucune seed de production n'est écrite dans la zone.  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| silent_rim | 1-9 | silent_rim | `silent_chasm_floor` | ring, lattice | 53 | non | non | — |

## Scènes fixes

- entrée : `gouffre_muet_bord`
- midpoint : `—`
- Ground de fin : `d05p02`
- boss : mode `canonical_ground` → Ground `d05p02`, rsmap `—`
  - no fixed 'mid' Ground declared
  - final battle stays on the canonical end Ground 'd05p02' (no separate arena created)

## Étages

| Ét. | Segment | Type | Profil | Grille | Cellule | Variantes OK | Rejets | Rooms (min/moy/max) | Halls | Branches | Culs-de-sac | Boucles | Dist. escaliers | Signatures | Traversable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | silent_rim | procedural | ring|lattice | 6x4 | 11x8 | 10 | 1 | 11/14.2/17 | 26.6 | 7.1 | 2.9 | 4.6 | 47.9 | 10 | oui |
| 2 | silent_rim | procedural | ring|lattice | 5x5 | 11x10 | 10 | 1 | 10/12.9/16 | 23.9 | 6.0 | 2.1 | 4.2 | 49.3 | 10 | oui |
| 3 | silent_rim | procedural | ring|lattice | 6x5 | 12x8 | 10 | 1 | 8/13.2/16 | 25.7 | 6.6 | 2.5 | 4.3 | 48.2 | 10 | oui |
| 4 | silent_rim | procedural | ring|lattice | 5x5 | 10x9 | 10 | 3 | 12/13.7/16 | 28.5 | 9.2 | 2.8 | 6.3 | 45.4 | 10 | oui |
| 5 | silent_rim | procedural | ring|lattice | 5x5 | 10x8 | 10 | 0 | 12/14.1/17 | 27.1 | 7.9 | 2.7 | 5.2 | 60.0 | 10 | oui |
| 6 | silent_rim | procedural | ring|lattice | 5x5 | 12x10 | 10 | 3 | 11/13.5/15 | 23.6 | 5.7 | 2.7 | 3.6 | 52.5 | 10 | oui |
| 7 | silent_rim | procedural | ring|lattice | 5x4 | 10x10 | 10 | 1 | 10/12.4/15 | 24.3 | 6.7 | 2.0 | 5.1 | 45.5 | 10 | oui |
| 8 | silent_rim | procedural | ring|lattice | 5x4 | 9x9 | 10 | 0 | 10/13.7/17 | 26.4 | 7.2 | 2.3 | 4.9 | 48.0 | 10 | oui |
| 9 | silent_rim | procedural | ring|lattice | 5x4 | 12x9 | 10 | 1 | 9/12.2/15 | 23.3 | 5.9 | 1.3 | 4.4 | 44.3 | 10 | oui |
