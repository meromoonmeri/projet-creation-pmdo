# Rapport de génération — Rock Path

- **ID** : `rock_path`  
- **Chapitre** : 24 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Rock Path (4F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/RockPath) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 24. Recoupé avec Bulbapedia (page « Rock Path »).  
- **Étages** : 4 — direction `fond`  
- **Zone écrite** : `Data/Zone/rock_path.json`  
- **Seed d'auteur (debug)** : `1888404111352172820` (explicite : False)  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| rock_path | 1-4 | rock_path | `rock_path_rb_floor` | branching, mixed, dense | 5 | oui | oui | — |

## Scènes fixes

- entrée : `—`
- midpoint : `—`
- Ground de fin : `—`
- boss : mode `` → Ground `—`, rsmap `—`
  - no fixed 'entrance' Ground declared
  - no fixed 'mid' Ground declared
  - no fixed 'end' Ground declared
  - no boss scene declared

## Étages

| Ét. | Segment | Type | Profil | Grille | Cellule | Variantes OK | Rejets | Rooms (min/moy/max) | Halls | Branches | Culs-de-sac | Boucles | Dist. escaliers | Signatures | Traversable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | rock_path | procedural | branching+mixed+dense | 6x4 | 11x8 | 5 | 0 | 6/15.8/30 | 18.2 | 4.8 | 4.0 | 1.8 | 41.2 | 5 | oui |
| 2 | rock_path | procedural | branching+mixed+dense | 5x3 | 8x11 | 5 | 0 | 7/13.8/24 | 15.4 | 4.0 | 4.2 | 1.2 | 45.2 | 5 | oui |
| 3 | rock_path | procedural | branching+mixed+dense | 6x3 | 12x10 | 5 | 0 | 9/11.6/16 | 13.2 | 3.8 | 3.6 | 1.2 | 30.6 | 5 | oui |
| 4 | rock_path | procedural | branching+mixed+dense | 8x4 | 8x8 | 5 | 0 | 9/13.0/22 | 16.4 | 5.4 | 3.0 | 2.6 | 32.6 | 5 | oui |
