# EST1 — Entrée de la Tour Céleste (sud → nord, 768×576, 10 calques)

## Référence canonique
- Capture issue du port `PMD Red` : `references/D13P01.png` (`MAP_FILE_ID_SKY_TOWER_ENTRY`, `408 × 288 px`).
- Table d'animation matérielle : `references/rom_d13p01_bpl.json` extraite de `data/map_bg/D13P01.bpl` (`Palettes 9 & 10`, `8 poses × 8 ticks = 64 ticks`).
- Nature : décor généré 4:3 (`1200 × 896 → 768 × 576`) référencé sur `D13P01.png`, segmenté à pleine résolution avant réduction non mélangeante (`down_class` + `exclusive`), avec table matérielle exacte `D13P01.bpl` sur le calque `08` et sprites pixel-art détourés sur le calque `09`.
- Statut : `art_approved = false`, `runtime_tested = false`.

## Empilement multicalque (bas → haut)
0. `EST1_00_sol_complet` — fond plein de nuage glacé canonique (`0` trou transparent)
1. `EST1_01_esplanade_nuage` — pont d'accès sud et vaste esplanade centrale praticable
2. `EST1_02_motifs_vent_sol` — croissants blancs et triangles/papillons pervenche du sol
3. `EST1_03_rebords_festonnes` — ourlets festonnés bleu moyen de l'esplanade et du pont
4. `EST1_04_arche_portail_nord` — nuages tourbillonnants encadrant le seuil nord
5. `EST1_05_seuil_obscur` — ouverture sombre au nord (`donjon_seuil`)
6. `EST1_06_ciel_royal` — ciel bleu cobalt royal latéral
7. `EST1_07_panaches_nuages` — grands panaches obliques blanc et azur
8. `EST1_08_courants_bpl` — animation matérielle `D13P01.bpl` Palettes 9 & 10 (`8 × 8 = 64 ticks`)
9. `EST1_09_brises_et_eclats` — cycle de vie des 8 poses détourées (`16 × 4 = 64 ticks`)
10. `Top` (`Layer = 4`) — calque avant-plan vide pour l'édition dans PMDO `0.8.12`
