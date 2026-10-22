# Rapport de génération — Thunderwave Cave

- **ID** : `thunderwave_cave`  
- **Chapitre** : 7 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Thunderwave Cave (5F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/ThunderwaveCave) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 7. Recoupé avec Bulbapedia (page « Thunderwave Cave »).  
- **Étages** : 5 — direction `fond`  
- **Zone écrite** : `Data/Zone/thunderwave_cave.json`  
- **Gate canonique** : configuration `validated`, runtime `validated`  
- **Seed runtime** : fournie et journalisée par PMDO lors du test moteur ; aucune seed de production n'est écrite dans la zone.  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| static_cave | 1-5 | static_cave | `thunderwave_cave_floor` | branching, looping | 18 | non | non | — |

## Scènes fixes

- entrée : `grotte_statique_seuil`
- midpoint : `—`
- Ground de fin : `d02p02`
- boss : mode `canonical_ground` → Ground `d02p02`, rsmap `—`
  - no fixed 'mid' Ground declared
  - final battle stays on the canonical end Ground 'd02p02' (no separate arena created)

## Étages

| Ét. | Segment | Type | Profil | Grille | Cellule | Variantes OK | Rejets | Rooms (min/moy/max) | Halls | Branches | Culs-de-sac | Boucles | Dist. escaliers | Signatures | Traversable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | static_cave | procedural | branching|looping | 5x4 | 9x9 | 10 | 5 | 7/10.3/13 | 13.2 | 2.5 | 3.2 | 0.7 | 42.3 | 10 | oui |
| 2 | static_cave | procedural | branching|looping | 5x3 | 12x8 | 10 | 2 | 6/10.0/16 | 13.0 | 2.0 | 3.0 | 0.6 | 39.8 | 10 | oui |
| 3 | static_cave | procedural | branching|looping | 5x4 | 9x9 | 10 | 0 | 7/10.6/15 | 13.8 | 2.5 | 2.5 | 1.0 | 41.8 | 10 | oui |
| 4 | static_cave | procedural | branching|looping | 5x4 | 10x9 | 10 | 2 | 6/10.0/16 | 12.5 | 2.5 | 3.1 | 0.8 | 35.2 | 10 | oui |
| 5 | static_cave | procedural | branching|looping | 4x4 | 10x8 | 10 | 1 | 7/9.5/13 | 11.4 | 2.2 | 3.3 | 0.5 | 40.5 | 10 | oui |
