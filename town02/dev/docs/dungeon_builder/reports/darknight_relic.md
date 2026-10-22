# Rapport de génération — Darknight Relic

- **ID** : `darknight_relic`  
- **Chapitre** : 20 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Darknight Relic (15F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/DarknightRelic) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 20. Recoupé avec Bulbapedia (page « Darknight Relic »).  
- **Étages** : 15 — direction `fond`  
- **Zone écrite** : `Data/Zone/darknight_relic.json`  
- **Seed d'auteur (debug)** : `3053127263044125234` (explicite : False)  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| dark_halls | 1-8 | dark_halls | `the_nightmare_floor` | crossroads, lattice, mixed | 7 | oui | oui | — |
| dark_sanctum | 9-15 | dark_sanctum | `the_nightmare_floor` | lattice, looping, dense | 7 | oui | oui | — |

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
| 1 | dark_halls | procedural | crossroads+lattice+mixed | 5x3 | 12x8 | 5 | 1 | 9/11.2/15 | 12.6 | 3.0 | 3.6 | 1.2 | 43.0 | 5 | oui |
| 2 | dark_halls | procedural | crossroads+lattice+mixed | 7x4 | 8x12 | 5 | 0 | 7/8.8/10 | 11.4 | 3.6 | 3.8 | 1.4 | 46.0 | 5 | oui |
| 3 | dark_halls | procedural | crossroads+lattice+mixed | 7x4 | 10x10 | 5 | 0 | 8/12.6/28 | 14.2 | 3.6 | 4.2 | 1.2 | 38.0 | 5 | oui |
| 4 | dark_halls | procedural | crossroads+lattice+mixed | 5x3 | 12x11 | 5 | 2 | 6/9.6/14 | 12.2 | 3.0 | 3.2 | 1.6 | 37.2 | 5 | oui |
| 5 | dark_halls | procedural | crossroads+lattice+mixed | 7x4 | 9x10 | 5 | 0 | 6/9.2/13 | 11.4 | 3.6 | 4.4 | 1.0 | 47.8 | 5 | oui |
| 6 | dark_halls | procedural | crossroads+lattice+mixed | 6x3 | 9x10 | 5 | 1 | 9/11.6/14 | 17.4 | 5.0 | 2.4 | 3.8 | 49.8 | 5 | oui |
| 7 | dark_halls | procedural | crossroads+lattice+mixed | 5x4 | 8x11 | 5 | 3 | 8/10.6/17 | 12.4 | 3.8 | 3.8 | 1.4 | 52.4 | 5 | oui |
| 8 | dark_halls | procedural | crossroads+lattice+mixed | 5x3 | 12x10 | 5 | 0 | 6/9.4/13 | 13.2 | 4.4 | 4.2 | 2.0 | 38.6 | 5 | oui |
| 9 | dark_sanctum | procedural | lattice+looping+dense | 6x4 | 9x6 | 5 | 2 | 8/16.0/29 | 21.0 | 6.8 | 3.6 | 3.2 | 29.8 | 5 | oui |
| 10 | dark_sanctum | procedural | lattice+looping+dense | 6x3 | 11x8 | 5 | 0 | 10/12.4/21 | 19.2 | 5.8 | 2.8 | 3.2 | 45.4 | 5 | oui |
| 11 | dark_sanctum | procedural | lattice+looping+dense | 4x5 | 10x10 | 5 | 0 | 9/12.2/17 | 18.6 | 5.2 | 3.8 | 2.8 | 47.0 | 5 | oui |
| 12 | dark_sanctum | procedural | lattice+looping+dense | 4x5 | 10x9 | 5 | 0 | 4/10.8/19 | 17.0 | 5.0 | 1.8 | 3.2 | 33.4 | 5 | oui |
| 13 | dark_sanctum | procedural | lattice+looping+dense | 4x4 | 10x8 | 5 | 0 | 7/11.2/24 | 16.2 | 4.6 | 2.6 | 2.6 | 32.0 | 5 | oui |
| 14 | dark_sanctum | procedural | lattice+looping+dense | 4x4 | 10x9 | 5 | 0 | 5/9.8/17 | 13.2 | 4.2 | 2.8 | 1.8 | 47.0 | 5 | oui |
| 15 | dark_sanctum | procedural | lattice+looping+dense | 4x4 | 10x9 | 5 | 2 | 8/14.6/23 | 22.2 | 7.0 | 2.6 | 4.0 | 38.4 | 5 | oui |
