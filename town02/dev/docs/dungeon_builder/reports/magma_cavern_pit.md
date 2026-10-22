# Rapport de génération — Magma Cavern Pit

- **ID** : `magma_cavern_pit`  
- **Chapitre** : 12 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Magma Cavern Pit (3F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/MagmaCavernPit) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 12. Recoupé avec Bulbapedia (page « Magma Cavern Pit »).  
- **Étages** : 3 — direction `fond`  
- **Zone écrite** : `Data/Zone/magma_cavern_pit.json`  
- **Seed d'auteur (debug)** : `1939074602930152269` (explicite : False)  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| magma_pit | 1-3 | magma_pit | `world_abyss_2_floor` | branching, mixed, dense | 5 | oui | oui | — |

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
| 1 | magma_pit | procedural | branching+mixed+dense | 6x5 | 9x7 | 5 | 0 | 9/13.6/19 | 15.6 | 4.4 | 4.4 | 1.4 | 42.8 | 5 | oui |
| 2 | magma_pit | procedural | branching+mixed+dense | 6x4 | 12x12 | 5 | 0 | 10/14.8/21 | 16.6 | 5.4 | 4.8 | 1.6 | 37.8 | 5 | oui |
| 3 | magma_pit | procedural | branching+mixed+dense | 5x4 | 11x9 | 5 | 0 | 13/18.6/22 | 21.8 | 6.4 | 5.2 | 2.0 | 55.6 | 5 | oui |
