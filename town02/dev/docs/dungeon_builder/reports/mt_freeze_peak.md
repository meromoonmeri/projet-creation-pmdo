# Rapport de génération — Mt. Freeze Peak

- **ID** : `mt_freeze_peak`  
- **Chapitre** : 12 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Mt. Freeze Peak (5F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/MtFreezePeak) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 12. Recoupé avec Bulbapedia (page « Mt. Freeze Peak »).  
- **Étages** : 4 — direction `sommet`  
- **Zone écrite** : `Data/Zone/mt_freeze_peak.json`  
- **Gate canonique** : configuration `validated`, runtime `validated`  
- **Seed runtime** : fournie et journalisée par PMDO lors du test moteur ; aucune seed de production n'est écrite dans la zone.  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| freeze_peak | 1-4 | freeze_peak | `mt_freeze_floor` | branching, lattice | 4 | non | non | — |

## Scènes fixes

- entrée : `d11p02`
- midpoint : `—`
- Ground de fin : `d11p03`
- boss : mode `canonical_ground` → Ground `d11p03`, rsmap `mt_freeze_peak_boss`
  - no fixed 'mid' Ground declared
  - final battle stays on the canonical end Ground 'd11p03' (no separate arena created)
  - scene source of truth: mt_freeze_peak_boss.rsmap matches the end Ground

## Étages

| Ét. | Segment | Type | Profil | Grille | Cellule | Variantes OK | Rejets | Rooms (min/moy/max) | Halls | Branches | Culs-de-sac | Boucles | Dist. escaliers | Signatures | Traversable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | freeze_peak | procedural | branching|lattice | 5x4 | 9x9 | 10 | 0 | 9/13.8/22 | 21.3 | 7.6 | 3.8 | 4.3 | 43.2 | 10 | oui |
| 2 | freeze_peak | procedural | branching|lattice | 6x5 | 10x10 | 10 | 2 | 10/16.2/23 | 23.9 | 8.1 | 5.5 | 4.1 | 41.3 | 10 | oui |
| 3 | freeze_peak | procedural | branching|lattice | 6x4 | 12x8 | 10 | 1 | 11/14.6/21 | 22.6 | 7.7 | 4.8 | 4.1 | 55.5 | 10 | oui |
| 4 | freeze_peak | procedural | branching|lattice | 6x5 | 12x8 | 10 | 3 | 11/17.7/26 | 24.6 | 8.1 | 5.8 | 3.9 | 48.9 | 10 | oui |
