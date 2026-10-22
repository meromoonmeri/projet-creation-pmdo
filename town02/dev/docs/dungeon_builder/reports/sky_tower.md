# Rapport de génération — Sky Tower

- **ID** : `sky_tower`  
- **Chapitre** : 10 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Sky Tower (25F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/SkyTower) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 10. Recoupé avec Bulbapedia (page « Sky Tower »).  
- **Étages** : 25 — direction `sommet`  
- **Zone écrite** : `Data/Zone/sky_tower.json`  
- **Seed d'auteur (debug)** : `524594378337858679` (explicite : False)  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| sky_ascent | 1-25 | sky_ascent | `sky_tower_floor` | crossroads, branching, mixed | 16 | oui | oui | — |

## Scènes fixes

- entrée : `arc_parvis_celeste`
- midpoint : `—`
- Ground de fin : `arc_tour_ciel_sommet`
- boss : mode `canonical_ground` → Ground `arc_tour_ciel_sommet`, rsmap `—`
  - no fixed 'mid' Ground declared
  - final battle stays on the canonical end Ground 'arc_tour_ciel_sommet' (no separate arena created)

## Étages

| Ét. | Segment | Type | Profil | Grille | Cellule | Variantes OK | Rejets | Rooms (min/moy/max) | Halls | Branches | Culs-de-sac | Boucles | Dist. escaliers | Signatures | Traversable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | sky_ascent | procedural | crossroads+branching+mixed | 5x5 | 10x8 | 5 | 0 | 8/10.6/16 | 10.8 | 2.6 | 4.4 | 0.8 | 41.4 | 5 | oui |
| 2 | sky_ascent | procedural | crossroads+branching+mixed | 6x4 | 12x8 | 5 | 1 | 8/13.2/24 | 14.2 | 4.0 | 4.4 | 1.2 | 34.6 | 5 | oui |
| 3 | sky_ascent | procedural | crossroads+branching+mixed | 5x5 | 13x11 | 5 | 0 | 7/10.2/13 | 10.0 | 2.2 | 3.8 | 0.4 | 37.2 | 5 | oui |
| 4 | sky_ascent | procedural | crossroads+branching+mixed | 7x3 | 9x11 | 5 | 0 | 9/11.2/14 | 11.8 | 3.0 | 3.6 | 1.0 | 32.4 | 5 | oui |
| 5 | sky_ascent | procedural | crossroads+branching+mixed | 4x3 | 10x9 | 5 | 1 | 7/11.0/21 | 11.4 | 2.8 | 3.6 | 1.0 | 42.8 | 5 | oui |
| 6 | sky_ascent | procedural | crossroads+branching+mixed | 6x3 | 11x9 | 5 | 1 | 9/10.2/11 | 9.8 | 2.4 | 4.2 | 0.4 | 34.6 | 5 | oui |
| 7 | sky_ascent | procedural | crossroads+branching+mixed | 5x4 | 12x8 | 5 | 0 | 7/10.2/17 | 10.6 | 2.6 | 3.2 | 1.2 | 36.4 | 5 | oui |
| 8 | sky_ascent | procedural | crossroads+branching+mixed | 5x4 | 11x10 | 5 | 1 | 9/11.4/15 | 11.2 | 3.0 | 4.0 | 0.6 | 43.4 | 5 | oui |
| 9 | sky_ascent | procedural | crossroads+branching+mixed | 5x3 | 10x9 | 5 | 2 | 8/10.0/14 | 10.0 | 2.8 | 3.4 | 1.0 | 42.6 | 5 | oui |
| 10 | sky_ascent | procedural | crossroads+branching+mixed | 6x3 | 13x11 | 5 | 0 | 7/12.4/17 | 12.0 | 3.6 | 5.2 | 0.6 | 46.4 | 5 | oui |
| 11 | sky_ascent | procedural | crossroads+branching+mixed | 6x4 | 12x10 | 5 | 0 | 8/11.0/17 | 10.8 | 2.6 | 4.6 | 0.4 | 35.6 | 5 | oui |
| 12 | sky_ascent | procedural | crossroads+branching+mixed | 5x3 | 10x7 | 5 | 0 | 6/9.4/16 | 9.0 | 1.8 | 4.0 | 0.2 | 34.0 | 5 | oui |
| 13 | sky_ascent | procedural | crossroads+branching+mixed | 4x3 | 8x7 | 5 | 0 | 8/10.6/14 | 10.8 | 2.6 | 3.8 | 1.0 | 35.8 | 5 | oui |
| 14 | sky_ascent | procedural | crossroads+branching+mixed | 5x4 | 10x8 | 5 | 0 | 8/9.4/10 | 9.0 | 2.0 | 4.0 | 0.4 | 43.6 | 5 | oui |
| 15 | sky_ascent | procedural | crossroads+branching+mixed | 5x3 | 9x11 | 5 | 1 | 9/12.0/18 | 12.4 | 3.0 | 4.2 | 0.8 | 35.2 | 5 | oui |
| 16 | sky_ascent | procedural | crossroads+branching+mixed | 6x5 | 12x8 | 5 | 0 | 7/10.0/13 | 9.8 | 2.4 | 4.0 | 0.6 | 33.6 | 5 | oui |
| 17 | sky_ascent | procedural | crossroads+branching+mixed | 6x3 | 10x8 | 5 | 0 | 9/12.6/24 | 12.6 | 3.0 | 4.6 | 0.8 | 52.0 | 5 | oui |
| 18 | sky_ascent | procedural | crossroads+branching+mixed | 4x5 | 8x11 | 5 | 0 | 8/9.6/13 | 9.6 | 2.2 | 3.2 | 0.8 | 43.6 | 5 | oui |
| 19 | sky_ascent | procedural | crossroads+branching+mixed | 7x5 | 10x10 | 5 | 1 | 7/11.6/23 | 12.2 | 2.8 | 3.6 | 1.0 | 39.0 | 5 | oui |
| 20 | sky_ascent | procedural | crossroads+branching+mixed | 4x5 | 8x11 | 5 | 0 | 7/9.8/12 | 9.6 | 2.4 | 3.8 | 0.6 | 39.8 | 5 | oui |
| 21 | sky_ascent | procedural | crossroads+branching+mixed | 6x3 | 10x8 | 5 | 2 | 7/10.0/13 | 9.2 | 2.2 | 4.8 | 0.2 | 40.2 | 5 | oui |
| 22 | sky_ascent | procedural | crossroads+branching+mixed | 4x4 | 9x10 | 5 | 0 | 7/10.8/21 | 11.4 | 3.0 | 3.6 | 1.0 | 35.6 | 5 | oui |
| 23 | sky_ascent | procedural | crossroads+branching+mixed | 4x3 | 9x10 | 5 | 0 | 8/10.8/15 | 10.4 | 2.6 | 3.8 | 0.6 | 34.4 | 5 | oui |
| 24 | sky_ascent | procedural | crossroads+branching+mixed | 6x3 | 10x10 | 5 | 0 | 8/9.2/11 | 8.8 | 2.0 | 3.6 | 0.4 | 35.4 | 5 | oui |
| 25 | sky_ascent | procedural | crossroads+branching+mixed | 4x4 | 13x12 | 5 | 1 | 7/9.6/12 | 8.8 | 1.6 | 4.0 | 0.2 | 34.6 | 5 | oui |
