# RAPPORT TORNADUS — VÉRIFICATION DE BOUT EN BOUT (2026-08-07)

## Chaîne complète prouvée

1. **Script qui lance le combat** : `Data/Script/halcyon/ground/mount_windswept_guardian/mount_windswept_guardian_ch_5.lua`
   (FirstPreBossScene / SecondPreBossScene) → `COMMON.BossTransition()` puis
   `GAME:ContinueDungeon("mount_windswept", 2, ...)` (lignes 423-424 et 480-481).
2. **Étage chargé** : `Data/Zone/mount_windswept.json` segment 2 (LayeredSegment)
   → `MapID = mount_windswept_guardian` → `Data/Map/mount_windswept_guardian.rsmap`
   (15x14 tuiles, boss tornadus niv. 33, EntryPoints (7,7)/(8,7), musique Mt. Travail.ogg).
3. **Ground de cinématique** : `Data/Ground/mount_windswept_guardian.rsground`
   (AssetName = mount_windswept_guardian, 45x42 cellules, 360x336 px,
   musique 'Mt. Travail.ogg' — harmonisée cutscene + rsmap + BossMusic).
4. **Map source** : `pret/pmd-red` D18P01 — preuves dans le code Red :
   `src/ground_map.c` l.180-184 : `MAP_D18 ↔ DUNGEON_NORTHWIND_FIELD` ;
   `src/map_files_table.c` l.1344-1347 : `MAP_FILE_ID_D18 = D18P01 + D18P01c + D18P01m`.
5. **PIXEL-PERFECT PROUVÉ (2026-08-07, après correction du format 8x8)** :
   rendu du ground (planche 8px ChampVentBoreal_Base, 1890 tuiles 8x8) vs
   rendu de la rsmap (planche 24px mount_windswept_guardian_Base) :
   **0 pixel différent sur 120 960, RGBA complet** (même géométrie 360x336,
   même fond opaque noir).
6. **Index stables** : master_zone index 51 = mount_windswept_guardian
   (JSON et index.idx identiques).

## « Northern Field (Suicune) »

- D18P01 est le **Northwind Field** de PMD Red (DUNGEON_NORTHWIND_FIELD = 35,
  cutscenes CUTSCENE_NORTHWIND_FIELD_*).
- Suicune n'existe PAS en bataille vivante dans le mod (aucun script actif).
  « Northern Field (Suicune) » = la référence canonique de cette map dans
  PMD Red. **Tornadus et « Suicune » chargent donc exactement la même map
  source (D18P01) — c'est le comportement demandé.**

## Résidus vérifiés

- `champ_vent_boreal.rsground` = placeholder 16x12 (fantôme index 81,
  matérialisé pour le warp dev) — plus AUCUNE référence vivante ne le charge.
- `mt_travail_peak` : aucun fichier, aucune référence.
- BossMusic.lua : mount_windswept_guardian = 'Mt. Travail.ogg'.

## Correctifs appliqués

- Data/Ground/mount_windswept_guardian.rsground : Music → 'Mt. Travail.ogg'.
- Data/Script/halcyon/BossMusic.lua : T.CIEL → 'Mt. Travail.ogg'.
- **Correctif critique du pipeline Red** : les planches .tile des grounds
  doivent contenir des tuiles 8x8 par position de grille (et non des cellules
  24x24) — c'est le format exact du port officiel ; corrigé et re-prouvé
  (reconstruction = port à 0 pixel sur 7 maps de référence).
