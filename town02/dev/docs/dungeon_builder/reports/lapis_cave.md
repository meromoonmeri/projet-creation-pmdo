# Rapport de génération — Lapis Cave

- **ID** : `lapis_cave`  
- **Chapitre** : 10 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Lapis Cave (14F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/LapisCave) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 10. Recoupé avec Bulbapedia (page « Lapis Cave »).  
- **Étages** : 14 — direction `fond`  
- **Zone écrite** : `Data/Zone/lapis_cave.json`  
- **Gate canonique** : configuration `validated`, runtime `validated`  
- **Seed runtime** : fournie et journalisée par PMDO lors du test moteur ; aucune seed de production n'est écrite dans la zone.  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| lapis_gallery | 1-14 | lapis_gallery | `lapis_cave_floor` | branching, lattice, looping | 34 | non | non | — |

## Scènes fixes

- entrée : `grotte_lazuli_seuil`
- midpoint : `—`
- Ground de fin : `grotte_lazuli_fond`
- boss : mode `canonical_ground` → Ground `grotte_lazuli_fond`, rsmap `—`
  - no fixed 'mid' Ground declared
  - final battle stays on the canonical end Ground 'grotte_lazuli_fond' (no separate arena created)

## Étages

| Ét. | Segment | Type | Profil | Grille | Cellule | Variantes OK | Rejets | Rooms (min/moy/max) | Halls | Branches | Culs-de-sac | Boucles | Dist. escaliers | Signatures | Traversable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | lapis_gallery | procedural | branching|lattice|looping | 7x5 | 9x8 | 10 | 0 | 11/14.7/22 | 22.6 | 6.3 | 4.0 | 3.3 | 53.8 | 10 | oui |
| 2 | lapis_gallery | procedural | branching|lattice|looping | 7x5 | 12x8 | 10 | 0 | 9/14.9/21 | 24.5 | 7.6 | 4.5 | 4.0 | 41.4 | 10 | oui |
| 3 | lapis_gallery | procedural | branching|lattice|looping | 6x4 | 10x8 | 10 | 1 | 11/17.5/29 | 28.6 | 9.3 | 4.9 | 5.1 | 44.8 | 10 | oui |
| 4 | lapis_gallery | procedural | branching|lattice|looping | 5x4 | 10x10 | 10 | 2 | 11/15.1/25 | 26.7 | 7.4 | 3.5 | 4.7 | 49.4 | 10 | oui |
| 5 | lapis_gallery | procedural | branching|lattice|looping | 7x4 | 9x8 | 10 | 1 | 10/14.8/24 | 26.8 | 8.2 | 3.7 | 5.2 | 57.0 | 10 | oui |
| 6 | lapis_gallery | procedural | branching|lattice|looping | 5x4 | 11x8 | 10 | 1 | 11/16.4/28 | 25.0 | 6.7 | 3.8 | 3.4 | 50.0 | 10 | oui |
| 7 | lapis_gallery | procedural | branching|lattice|looping | 6x4 | 9x10 | 10 | 1 | 9/14.4/20 | 25.6 | 7.3 | 3.7 | 4.3 | 52.7 | 10 | oui |
| 8 | lapis_gallery | procedural | branching|lattice|looping | 6x4 | 11x10 | 10 | 1 | 9/15.0/22 | 21.2 | 6.2 | 4.7 | 2.7 | 52.2 | 10 | oui |
| 9 | lapis_gallery | procedural | branching|lattice|looping | 6x4 | 11x9 | 10 | 0 | 11/15.4/23 | 22.4 | 6.2 | 4.5 | 2.8 | 41.4 | 10 | oui |
| 10 | lapis_gallery | procedural | branching|lattice|looping | 7x4 | 11x8 | 10 | 0 | 10/14.3/20 | 22.0 | 6.3 | 4.0 | 3.1 | 37.2 | 10 | oui |
| 11 | lapis_gallery | procedural | branching|lattice|looping | 6x4 | 11x9 | 10 | 0 | 9/14.4/25 | 21.5 | 6.0 | 4.4 | 2.8 | 38.1 | 10 | oui |
| 12 | lapis_gallery | procedural | branching|lattice|looping | 6x4 | 9x9 | 10 | 0 | 11/15.1/23 | 23.1 | 6.7 | 3.5 | 3.7 | 50.8 | 10 | oui |
| 13 | lapis_gallery | procedural | branching|lattice|looping | 5x5 | 12x9 | 10 | 1 | 11/14.8/20 | 22.3 | 6.6 | 4.3 | 3.2 | 46.0 | 10 | oui |
| 14 | lapis_gallery | procedural | branching|lattice|looping | 5x4 | 11x8 | 10 | 0 | 10/15.3/21 | 22.6 | 6.0 | 4.2 | 3.1 | 41.6 | 10 | oui |
