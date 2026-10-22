# Rapport de génération — Magma Cavern

- **ID** : `magma_cavern`  
- **Chapitre** : 12 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Magma Cavern (23F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/MagmaCavern) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 12. Recoupé avec Bulbapedia (page « Magma Cavern »).  
- **Étages** : 23 — direction `fond`  
- **Zone écrite** : `Data/Zone/magma_cavern.json`  
- **Seed d'auteur (debug)** : `5851627730880862949` (explicite : False)  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| magma_gallery | 1-8 | magma_gallery | `magma_cavern_2_floor` | branching, mixed, dense | 8 | oui | oui | — |
| magma_core | 9-15 | magma_core | `magma_cavern_2_floor` | looping, lattice, mixed | 9 | oui | oui | — |
| magma_abyss | 16-23 | magma_abyss | `magma_cavern_2_floor` | large_rooms, mixed, looping | 5 | oui | oui | — |

## Scènes fixes

- entrée : `gorge_ardente_porte`
- midpoint : `—`
- Ground de fin : `fosse_ardente`
- boss : mode `canonical_ground` → Ground `fosse_ardente`, rsmap `—`
  - no fixed 'mid' Ground declared
  - final battle stays on the canonical end Ground 'fosse_ardente' (no separate arena created)

## Étages

| Ét. | Segment | Type | Profil | Grille | Cellule | Variantes OK | Rejets | Rooms (min/moy/max) | Halls | Branches | Culs-de-sac | Boucles | Dist. escaliers | Signatures | Traversable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | magma_gallery | procedural | branching+mixed+dense | 7x5 | 9x8 | 5 | 1 | 11/14.8/22 | 16.6 | 4.6 | 3.6 | 1.8 | 40.4 | 5 | oui |
| 2 | magma_gallery | procedural | branching+mixed+dense | 5x4 | 10x8 | 5 | 1 | 8/12.4/19 | 13.6 | 4.6 | 4.4 | 1.4 | 36.6 | 5 | oui |
| 3 | magma_gallery | procedural | branching+mixed+dense | 5x3 | 12x10 | 5 | 1 | 10/16.8/26 | 19.8 | 6.2 | 4.8 | 1.8 | 43.6 | 5 | oui |
| 4 | magma_gallery | procedural | branching+mixed+dense | 8x4 | 8x7 | 5 | 1 | 10/16.0/26 | 16.2 | 5.2 | 6.0 | 0.8 | 41.8 | 5 | oui |
| 5 | magma_gallery | procedural | branching+mixed+dense | 7x4 | 7x8 | 5 | 0 | 8/14.6/23 | 16.6 | 5.6 | 4.8 | 1.6 | 33.2 | 5 | oui |
| 6 | magma_gallery | procedural | branching+mixed+dense | 7x3 | 14x8 | 5 | 1 | 7/9.6/12 | 10.2 | 2.8 | 2.8 | 1.2 | 47.0 | 5 | oui |
| 7 | magma_gallery | procedural | branching+mixed+dense | 4x3 | 8x12 | 5 | 0 | 8/15.0/21 | 16.8 | 5.0 | 5.4 | 1.2 | 46.2 | 5 | oui |
| 8 | magma_gallery | procedural | branching+mixed+dense | 7x5 | 8x7 | 5 | 2 | 8/11.0/12 | 11.0 | 2.6 | 4.2 | 0.6 | 35.6 | 5 | oui |
| 9 | magma_core | procedural | looping+lattice+mixed | 5x3 | 12x11 | 5 | 0 | 7/8.6/12 | 12.6 | 3.6 | 2.4 | 2.2 | 36.8 | 5 | oui |
| 10 | magma_core | procedural | looping+lattice+mixed | 7x4 | 10x7 | 5 | 3 | 10/13.8/20 | 18.0 | 5.2 | 2.4 | 2.6 | 55.0 | 5 | oui |
| 11 | magma_core | procedural | looping+lattice+mixed | 6x4 | 11x8 | 5 | 0 | 8/9.2/12 | 13.2 | 3.6 | 2.0 | 2.2 | 34.8 | 5 | oui |
| 12 | magma_core | procedural | looping+lattice+mixed | 4x5 | 12x10 | 5 | 0 | 9/11.2/13 | 19.6 | 6.2 | 3.0 | 4.0 | 48.4 | 5 | oui |
| 13 | magma_core | procedural | looping+lattice+mixed | 5x3 | 9x10 | 5 | 0 | 7/10.4/18 | 13.8 | 4.2 | 2.8 | 2.2 | 45.2 | 5 | oui |
| 14 | magma_core | procedural | looping+lattice+mixed | 4x4 | 9x8 | 5 | 0 | 5/8.2/10 | 10.8 | 2.6 | 1.8 | 1.6 | 44.4 | 5 | oui |
| 15 | magma_core | procedural | looping+lattice+mixed | 5x3 | 11x8 | 5 | 0 | 9/12.2/14 | 19.6 | 6.6 | 4.4 | 3.4 | 36.8 | 5 | oui |
| 16 | magma_abyss | procedural | large_rooms+mixed+looping | 5x4 | 11x10 | 5 | 1 | 5/12.2/27 | 14.2 | 3.6 | 1.8 | 2.0 | 32.2 | 5 | oui |
| 17 | magma_abyss | procedural | large_rooms+mixed+looping | 6x5 | 10x9 | 5 | 0 | 7/13.0/21 | 15.4 | 4.0 | 2.4 | 2.0 | 41.0 | 5 | oui |
| 18 | magma_abyss | procedural | large_rooms+mixed+looping | 4x3 | 10x9 | 5 | 0 | 5/10.8/16 | 12.8 | 2.4 | 1.4 | 1.8 | 45.0 | 5 | oui |
| 19 | magma_abyss | procedural | large_rooms+mixed+looping | 5x3 | 10x9 | 5 | 0 | 4/9.2/15 | 11.0 | 2.6 | 1.6 | 1.6 | 33.0 | 5 | oui |
| 20 | magma_abyss | procedural | large_rooms+mixed+looping | 3x2 | 13x11 | 5 | 0 | 4/12.2/21 | 14.4 | 3.8 | 2.0 | 2.2 | 35.0 | 5 | oui |
| 21 | magma_abyss | procedural | large_rooms+mixed+looping | 4x2 | 16x11 | 5 | 0 | 8/12.0/16 | 14.2 | 3.6 | 2.0 | 2.0 | 39.6 | 5 | oui |
| 22 | magma_abyss | procedural | large_rooms+mixed+looping | 5x3 | 8x11 | 5 | 0 | 4/8.6/15 | 9.0 | 2.2 | 2.4 | 1.0 | 37.4 | 5 | oui |
| 23 | magma_abyss | procedural | large_rooms+mixed+looping | 4x3 | 10x12 | 5 | 0 | 7/9.0/13 | 8.8 | 2.0 | 3.4 | 0.6 | 46.0 | 5 | oui |
