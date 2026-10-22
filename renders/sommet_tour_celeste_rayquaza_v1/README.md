# SST1 — Sommet de la Tour Céleste — Arène de Rayquaza (768×576, 10 calques)

## Référence canonique
- Capture issue du port `PMD Red` : `references/b71_sky_tower_summit.png` (`D13P03` / `b71`, `552 × 576 px`).
- Table d'animation matérielle : `references/rom_d13p01_bpl.json` (`D13P01.bpl`, `Palettes 9 & 10`, `8 poses × 8 ticks = 64 ticks`).
- Nature : décor généré 4:3 (`1200 × 896 → 768 × 576`) référencé sur `b71_sky_tower_summit.png` (distance chromatique maximale `< 7,0` sur le brut, seuil `< 35`), segmenté à pleine résolution avant réduction non mélangeante.
- Statut : `art_approved = false`, `runtime_tested = false`.

## Empilement multicalque (bas → haut)
0. `SST1_00_sol_complet` — fond plein de nuage glacé canonique `b71` (`0` trou)
1. `SST1_01_couronne_et_acces_sud` — pont d'accès sud et couronne centrale praticable de Rayquaza
2. `SST1_02_reliefs_couronne` — croissants blancs et triangles d'alizé incrustés sur l'arène
3. `SST1_03_ourlet_couronne` — anneau festonné pervenche cernant la couronne du sommet
4. `SST1_04_stratosphere_outremer` — stratosphère outremer profond au nord
5. `SST1_05_arc_horizon_lumineux` — grand arc courbe lumineux de l'atmosphère terrestre
6. `SST1_06_ailes_vent_profondes` — nappes latérales de courants d'altitude
7. `SST1_07_plumes_vent_sculptees` — panaches d'ailes de vent pervenche entourant la couronne
8. `SST1_08_souffle_stratosphere_bpl` — animation matérielle `D13P01.bpl` Palettes 9 & 10 (`8 × 8 = 64 ticks`)
9. `SST1_09_alizes_et_eclats` — cycle de vie des 8 poses pixel-art détourées (`16 × 4 = 64 ticks`)
10. `Top` (`Layer = 4`) — calque avant-plan vide pour l'édition dans PMDO `0.8.12`
