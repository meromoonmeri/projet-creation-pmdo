# Rapport de génération — Unown Relic

- **ID** : `unown_relic`  
- **Chapitre** : 26 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Unown Relic (11F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/UnownRelic) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 26. Recoupé avec Bulbapedia (page « Unown Relic »).  
- **Étages** : 11 — direction `fond`  
- **Zone écrite** : `Data/Zone/unown_relic.json`  
- **Seed d'auteur (debug)** : `2749498202820138187` (explicite : False)  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| unown_halls | 1-6 | unown_halls | `deep_sealed_ruin_floor` | crossroads, lattice, mixed | 27 | oui | oui | — |
| unown_vault | 7-11 | unown_vault | `deep_sealed_ruin_floor` | lattice, looping, dense | 25 | oui | oui | — |

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
| 1 | unown_halls | procedural | crossroads+lattice+mixed | 4x4 | 11x10 | 10 | 2 | 5/8.8/16 | 11.0 | 3.3 | 3.7 | 1.4 | 41.8 | 10 | oui |
| 2 | unown_halls | procedural | crossroads+lattice+mixed | 5x3 | 11x8 | 10 | 0 | 5/10.5/22 | 12.7 | 3.5 | 3.6 | 1.4 | 41.9 | 10 | oui |
| 3 | unown_halls | procedural | crossroads+lattice+mixed | 7x5 | 12x9 | 10 | 1 | 7/10.1/16 | 11.9 | 3.2 | 3.4 | 1.3 | 47.8 | 10 | oui |
| 4 | unown_halls | procedural | crossroads+lattice+mixed | 4x5 | 10x9 | 10 | 0 | 6/11.3/23 | 14.4 | 4.2 | 3.7 | 1.9 | 43.4 | 10 | oui |
| 5 | unown_halls | procedural | crossroads+lattice+mixed | 6x4 | 11x8 | 10 | 1 | 5/11.1/18 | 13.3 | 3.8 | 4.1 | 1.5 | 48.3 | 10 | oui |
| 6 | unown_halls | procedural | crossroads+lattice+mixed | 5x3 | 13x10 | 10 | 1 | 5/10.5/24 | 13.9 | 3.9 | 3.4 | 1.9 | 37.8 | 10 | oui |
| 7 | unown_vault | procedural | lattice+looping+dense | 5x3 | 12x9 | 10 | 1 | 7/13.1/29 | 22.4 | 8.2 | 3.6 | 4.7 | 46.8 | 10 | oui |
| 8 | unown_vault | procedural | lattice+looping+dense | 5x4 | 10x8 | 10 | 1 | 5/12.7/27 | 18.9 | 6.1 | 3.1 | 3.2 | 43.1 | 10 | oui |
| 9 | unown_vault | procedural | lattice+looping+dense | 5x3 | 9x10 | 10 | 2 | 8/13.6/26 | 21.7 | 7.7 | 4.3 | 3.8 | 42.6 | 10 | oui |
| 10 | unown_vault | procedural | lattice+looping+dense | 6x3 | 11x8 | 10 | 3 | 7/14.6/26 | 19.4 | 5.3 | 2.5 | 2.8 | 41.6 | 10 | oui |
| 11 | unown_vault | procedural | lattice+looping+dense | 4x4 | 12x10 | 10 | 0 | 6/12.6/26 | 18.2 | 5.2 | 2.9 | 2.9 | 43.6 | 10 | oui |
