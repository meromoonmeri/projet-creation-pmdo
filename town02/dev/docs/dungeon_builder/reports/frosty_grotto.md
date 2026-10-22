# Rapport de génération — Frosty Grotto

- **ID** : `frosty_grotto`  
- **Chapitre** : 11 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Frosty Grotto (5F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/FrostyGrotto) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 11. Recoupé avec Bulbapedia (page « Frosty Grotto »).  
- **Étages** : 5 — direction `sommet`  
- **Zone écrite** : `Data/Zone/frosty_grotto.json`  
- **Seed d'auteur (debug)** : `8904834547963222912` (explicite : False)  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| frosty_grotto | 1-5 | frosty_grotto | `mt_freeze_floor` | branching, mixed, dense | 3 | oui | oui | — |

## Scènes fixes

- entrée : `foret_givree_oree`
- midpoint : `—`
- Ground de fin : `d10p03`
- boss : mode `canonical_ground` → Ground `d10p03`, rsmap `—`
  - no fixed 'mid' Ground declared
  - final battle stays on the canonical end Ground 'd10p03' (no separate arena created)

## Étages

| Ét. | Segment | Type | Profil | Grille | Cellule | Variantes OK | Rejets | Rooms (min/moy/max) | Halls | Branches | Culs-de-sac | Boucles | Dist. escaliers | Signatures | Traversable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | frosty_grotto | procedural | branching+mixed+dense | 6x4 | 9x6 | 5 | 1 | 8/16.2/27 | 19.0 | 6.0 | 5.0 | 1.8 | 44.8 | 5 | oui |
| 2 | frosty_grotto | procedural | branching+mixed+dense | 8x4 | 9x6 | 5 | 1 | 8/11.6/17 | 12.8 | 4.6 | 3.6 | 1.8 | 47.4 | 5 | oui |
| 3 | frosty_grotto | procedural | branching+mixed+dense | 6x4 | 12x10 | 5 | 0 | 9/13.6/27 | 15.4 | 3.8 | 4.2 | 1.2 | 37.8 | 5 | oui |
| 4 | frosty_grotto | procedural | branching+mixed+dense | 4x4 | 10x9 | 5 | 0 | 8/16.2/29 | 18.6 | 5.8 | 5.2 | 1.6 | 32.2 | 5 | oui |
| 5 | frosty_grotto | procedural | branching+mixed+dense | 4x3 | 12x9 | 5 | 0 | 10/14.4/22 | 17.8 | 4.8 | 3.2 | 2.6 | 35.4 | 5 | oui |
