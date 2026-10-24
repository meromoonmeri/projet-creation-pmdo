# Outil de récupération des maps de référence natives de PMD Red Rescue Team

`recuperer_maps.py` extrait et indexe **toutes** les cartes `MAP_BG` officielles de *Pokémon Mystery Dungeon: Red Rescue Team* depuis la décompilation [`pret/pmd-red`](https://github.com/pret/pmd-red) via le décodeur `1×` bit-exact `source/moteur_gba_pmd_red_natif.py`.

## Commandes

```bash
.venv/bin/python source/outil_maps_pmdred/recuperer_maps.py rom
.venv/bin/python source/outil_maps_pmdred/recuperer_maps.py cherche woods
.venv/bin/python source/outil_maps_pmdred/recuperer_maps.py cherche forest
```

## Correspondances canoniques vérifiées (`src/map_files_table.c`)

| Code | Constante `GroundMapID` | Lieu FR / EN | Taille native `1×` |
|---|---|---|---|
| `D01P01` / `D01P02` | `MAP_TINY_WOODS_ENTRY` / `END` | Petit Bois (*Tiny Woods*) | `432 × 360` / `360 × 336` |
| `D02P01` / `D02P02` | `MAP_THUNDERWAVE_CAVE_ENTRY` / `END` | Grotte Éclair (*Thunderwave Cave*) | `384 × 312` / `360 × 336` |
| `D03P01` / `D03P02` | `MAP_MT_STEEL_ENTRY` / `END` | Mont Acier (*Mt. Steel*) | `360 × 312` / `456 × 552` |
| `D04P01` / `D04P02` | `MAP_SINISTER_WOODS_ENTRY` / `END` | Bois Sinistre (*Sinister Woods*) | `456 × 384` / `552 × 576` |
| `D05P01` / `D05P02` | `MAP_SILENT_CHASM_ENTRY` / `END` | Fosse Silencieuse (*Silent Chasm*) | `672 × 240` / `360 × 408` |
| `D06P01`..`D06P03` | `MAP_MT_THUNDER_*` | Mont Foudre (*Mt. Thunder*) | `480 × 312` |
| `D07P01` / `D07P02` | `MAP_GREAT_CANYON_ENTRY` / `HILL_OF_THE_ANCIENTS` | Grand Canyon & Colline des Anciens | `456 × 240` / `480 × 360` |
| `D08P01` / `D08P02` | `MAP_LAPIS_CAVE_ENTRY` / `END` | Grotte Lapis (*Lapis Cave*) | `384 × 312` |
| `D09P01`..`D09P03` | `MAP_MT_BLAZE_*` | Mont Brasier (*Mt. Blaze*) | `480 × 312` |
| `D10P01`..`D10P03` | `MAP_FROSTY_FOREST_*` | Forêt Givrée (*Frosty Forest*) | `480 × 312` |
| `D11P01`..`D11P03` | `MAP_MT_FREEZE_*` | Mont Gelé (*Mt. Freeze*) | `480 × 312` |
| `D12P01`..`D12P04` | `MAP_MAGMA_CAVERN_*` | Mine Magma (*Magma Cavern*) | `480 × 312` |
| `D13P01`..`D13P03` | `MAP_SKY_TOWER_*` | Tour Céleste (*Sky Tower*) | `456 × 384` |
| `H07P01`..`H07P08` | `MAP_FRIEND_AREA_*_FOREST` | Zones d'Accueil Forêts (*Mist-Rise*, *Flyaway*, *Overgrown*, *Energetic*, *Mushroom*, *Healing*, *Transform*, *Secretive*) | `456..480 × 312..336` |
