# MST1 — Relais Mi-Tour de la Tour Céleste (sud → nord, 768×576, 10 calques)

## Référence canonique
- Capture issue du port `PMD Red` : `references/D13P02.png` (`MAP_FILE_ID_SKY_TOWER_MID` / `b35`, `456 × 456 px`).
- Sol complet natif périodique : `references/D13P02_sol_natif_768x576.png` (`72 × 72 px`, tuilage sans couture `dx = dy = 0`, dérive RVB `0,00`).
- Table d'animation matérielle : `references/rom_d13p01_bpl.json` (`D13P01.bpl`, `Palettes 9 & 10`, `8 poses × 8 ticks = 64 ticks`).
- Nature : décor généré 4:3 (`1200 × 896 → 768 × 576`) référencé sur `D13P02.png`, segmenté à pleine résolution avant réduction non mélangeante, associé au sol complet natif de `D13P02`.
- Statut : `art_approved = false`, `runtime_tested = false`.

## Empilement multicalque (bas → haut)
0. `MST1_00_sol_complet` — fond plein d'écailles de nuage pervenche natif `D13P02` (`0` trou)
1. `MST1_01_pont_et_ile_relais` — pont sud, grande île centrale plate et pont nord praticables
2. `MST1_02_motifs_ecaille_sol` — croissants clairs et étoiles douces pervenche du dallage
3. `MST1_03_ourlets_ponts` — bordures festonnées blanches et ombrées de l'île et des ponts
4. `MST1_04_douve_celeste` — gouffre bleu royal encadrant le relais central
5. `MST1_05_murs_nuages_blancs` — hautes parois de cumulus blanc pur gauche/droite
6. `MST1_06_ombres_cumulus` — reliefs bleutés sculptant les parois de cumulus
7. `MST1_07_etoiles_diamant_bleues` — étoiles à 4 branches bleu royal incrustées dans les murs
8. `MST1_08_scintillement_bpl` — animation matérielle `D13P01.bpl` Palettes 9 & 10 (`8 × 8 = 64 ticks`)
9. `MST1_09_eclats_et_brises` — cycle de vie des 8 poses pixel-art détourées (`16 × 4 = 64 ticks`)
10. `Top` (`Layer = 4`) — calque avant-plan vide pour l'édition dans PMDO `0.8.12`
