# Rapport de génération — Tiny Woods

- **ID** : `tiny_woods`  
- **Chapitre** : 7 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Tiny Woods (3F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/TinyWoods) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 7. Recoupé avec Bulbapedia (page « Tiny Woods »).  
- **Étages** : 3 — direction `fond`  
- **Zone écrite** : `Data/Zone/tiny_woods.json`  
- **Gate canonique** : configuration `validated`, runtime `validated`  
- **Seed runtime** : fournie et journalisée par PMDO lors du test moteur ; aucune seed de production n'est écrite dans la zone.  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| young_woods | 1-3 | young_woods | `tiny_woods_floor` | looping, lattice | 10 | non | non | — |

## Scènes fixes

- entrée : `foret_tendre_oree`
- midpoint : `—`
- Ground de fin : `d01p02`
- boss : mode `canonical_ground` → Ground `d01p02`, rsmap `—`
  - no fixed 'mid' Ground declared
  - final battle stays on the canonical end Ground 'd01p02' (no separate arena created)

## Étages

| Ét. | Segment | Type | Profil | Grille | Cellule | Variantes OK | Rejets | Rooms (min/moy/max) | Halls | Branches | Culs-de-sac | Boucles | Dist. escaliers | Signatures | Traversable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | young_woods | procedural | looping|lattice | 4x3 | 12x8 | 10 | 3 | 6/6.9/9 | 9.2 | 1.6 | 1.9 | 0.9 | 32.6 | 10 | oui |
| 2 | young_woods | procedural | looping|lattice | 4x3 | 11x8 | 10 | 3 | 5/6.4/9 | 8.8 | 1.8 | 1.6 | 1.2 | 34.2 | 10 | oui |
| 3 | young_woods | procedural | looping|lattice | 4x3 | 9x8 | 10 | 8 | 6/6.4/8 | 9.1 | 1.7 | 1.8 | 1.0 | 32.4 | 10 | oui |
