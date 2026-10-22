# Rapport de génération — Mt. Blaze Peak

- **ID** : `mt_blaze_peak`  
- **Chapitre** : 10 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Mt. Blaze Peak (3F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/MtBlazePeak) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 10. Recoupé avec Bulbapedia (page « Mt. Blaze Peak »).  
- **Étages** : 2 — direction `sommet`  
- **Zone écrite** : `Data/Zone/mt_blaze_peak.json`  
- **Gate canonique** : configuration `validated`, runtime `validated`  
- **Seed runtime** : fournie et journalisée par PMDO lors du test moteur ; aucune seed de production n'est écrite dans la zone.  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| blaze_peak | 1-2 | blaze_peak | `mt_blaze_floor` | branching, lattice | 4 | non | non | — |

## Scènes fixes

- entrée : `d09p02`
- midpoint : `—`
- Ground de fin : `d09p03`
- boss : mode `canonical_ground` → Ground `d09p03`, rsmap `mt_blaze_peak_boss`
  - no fixed 'mid' Ground declared
  - final battle stays on the canonical end Ground 'd09p03' (no separate arena created)
  - scene source of truth: mt_blaze_peak_boss.rsmap matches the end Ground

## Étages

| Ét. | Segment | Type | Profil | Grille | Cellule | Variantes OK | Rejets | Rooms (min/moy/max) | Halls | Branches | Culs-de-sac | Boucles | Dist. escaliers | Signatures | Traversable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | blaze_peak | procedural | branching|lattice | 6x4 | 12x9 | 10 | 1 | 11/15.0/19 | 21.1 | 6.8 | 4.9 | 3.5 | 36.1 | 10 | oui |
| 2 | blaze_peak | procedural | branching|lattice | 5x5 | 11x9 | 10 | 3 | 10/15.2/24 | 20.7 | 7.2 | 5.6 | 3.0 | 40.9 | 10 | oui |
