# Rapport de génération — Mt. Thunder Peak

- **ID** : `mt_thunder_peak`  
- **Chapitre** : 9 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Mt. Thunder Peak (3F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/MtThunderPeak) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 9. Recoupé avec Bulbapedia (page « Mt. Thunder Peak »).  
- **Étages** : 2 — direction `sommet`  
- **Zone écrite** : `Data/Zone/mt_thunder_peak.json`  
- **Gate canonique** : configuration `validated`, runtime `validated`  
- **Seed runtime** : fournie et journalisée par PMDO lors du test moteur ; aucune seed de production n'est écrite dans la zone.  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| thunder_peak | 1-2 | thunder_peak | `mt_thunder_peak_floor` | branching, lattice | 10 | non | non | — |

## Scènes fixes

- entrée : `d06p02`
- midpoint : `—`
- Ground de fin : `d06p03`
- boss : mode `canonical_ground` → Ground `d06p03`, rsmap `mt_thunder_peak_boss`
  - no fixed 'mid' Ground declared
  - final battle stays on the canonical end Ground 'd06p03' (no separate arena created)
  - scene source of truth: mt_thunder_peak_boss.rsmap matches the end Ground

## Étages

| Ét. | Segment | Type | Profil | Grille | Cellule | Variantes OK | Rejets | Rooms (min/moy/max) | Halls | Branches | Culs-de-sac | Boucles | Dist. escaliers | Signatures | Traversable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | thunder_peak | procedural | branching|lattice | 5x5 | 12x9 | 10 | 3 | 12/16.2/23 | 22.5 | 7.4 | 5.2 | 3.6 | 46.0 | 10 | oui |
| 2 | thunder_peak | procedural | branching|lattice | 4x3 | 9x8 | 10 | 0 | 5/6.6/10 | 6.9 | 1.9 | 2.6 | 0.7 | 34.2 | 10 | oui |
