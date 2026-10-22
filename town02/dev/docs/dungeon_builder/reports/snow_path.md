# Rapport de génération — Snow Path

- **ID** : `snow_path`  
- **Chapitre** : 25 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Snow Path (4F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/SnowPath) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 25. Recoupé avec Bulbapedia (page « Snow Path »).  
- **Étages** : 4 — direction `fond`  
- **Zone écrite** : `Data/Zone/snow_path.json`  
- **Seed d'auteur (debug)** : `4945487965292812243` (explicite : False)  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| snow_path | 1-4 | snow_path | `sky_peak_4th_pass_floor` | twosides, large_rooms, mixed | 4 | oui | oui | — |

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
| 1 | snow_path | procedural | twosides+large_rooms+mixed | 3x2 | 16x13 | 5 | 1 | 5/8.4/13 | 9.0 | 1.4 | 2.6 | 0.4 | 44.6 | 5 | oui |
| 2 | snow_path | procedural | twosides+large_rooms+mixed | 3x4 | 11x9 | 5 | 2 | 6/10.8/26 | 12.6 | 3.4 | 2.0 | 2.0 | 43.4 | 5 | oui |
| 3 | snow_path | procedural | twosides+large_rooms+mixed | 3x4 | 13x11 | 5 | 3 | 4/9.6/18 | 10.8 | 2.6 | 1.8 | 1.6 | 34.4 | 5 | oui |
| 4 | snow_path | procedural | twosides+large_rooms+mixed | 3x4 | 12x9 | 5 | 1 | 5/10.2/22 | 11.8 | 2.4 | 2.4 | 1.2 | 29.0 | 5 | oui |
