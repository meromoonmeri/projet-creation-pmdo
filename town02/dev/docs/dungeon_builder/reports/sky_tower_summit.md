# Rapport de génération — Sky Tower Summit

- **ID** : `sky_tower_summit`  
- **Chapitre** : 10 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Sky Tower Summit (9F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/SkyTowerSummit) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 10. Recoupé avec Bulbapedia (page « Sky Tower Summit »).  
- **Étages** : 9 — direction `sommet`  
- **Zone écrite** : `Data/Zone/sky_tower_summit.json`  
- **Seed d'auteur (debug)** : `3147467851076867520` (explicite : False)  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| sky_summit | 1-9 | sky_summit | `sky_tower_floor` | large_rooms, crossroads, mixed | 7 | oui | oui | — |

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
| 1 | sky_summit | procedural | large_rooms+crossroads+mixed | 6x4 | 9x10 | 5 | 0 | 4/8.8/16 | 8.8 | 1.6 | 2.4 | 0.8 | 43.4 | 5 | oui |
| 2 | sky_summit | procedural | large_rooms+crossroads+mixed | 3x3 | 12x11 | 5 | 1 | 6/11.2/19 | 12.0 | 3.2 | 3.6 | 1.4 | 42.4 | 5 | oui |
| 3 | sky_summit | procedural | large_rooms+crossroads+mixed | 7x5 | 9x11 | 5 | 0 | 5/9.2/18 | 9.4 | 2.4 | 3.4 | 0.8 | 36.2 | 5 | oui |
| 4 | sky_summit | procedural | large_rooms+crossroads+mixed | 4x2 | 16x11 | 5 | 0 | 6/9.4/15 | 9.0 | 1.4 | 3.0 | 0.6 | 46.2 | 5 | oui |
| 5 | sky_summit | procedural | large_rooms+crossroads+mixed | 5x5 | 12x11 | 5 | 0 | 7/8.8/13 | 9.4 | 2.0 | 2.6 | 1.0 | 38.8 | 5 | oui |
| 6 | sky_summit | procedural | large_rooms+crossroads+mixed | 5x4 | 11x9 | 5 | 0 | 7/10.8/18 | 11.2 | 2.4 | 3.2 | 0.8 | 44.8 | 5 | oui |
| 7 | sky_summit | procedural | large_rooms+crossroads+mixed | 3x3 | 13x10 | 5 | 0 | 5/8.4/11 | 8.4 | 1.0 | 2.4 | 0.6 | 39.4 | 5 | oui |
| 8 | sky_summit | procedural | large_rooms+crossroads+mixed | 6x4 | 10x12 | 5 | 0 | 6/8.6/12 | 9.0 | 2.0 | 2.6 | 1.2 | 31.8 | 5 | oui |
| 9 | sky_summit | procedural | large_rooms+crossroads+mixed | 6x4 | 10x11 | 5 | 0 | 6/8.2/11 | 8.8 | 2.2 | 2.8 | 1.2 | 30.6 | 5 | oui |
