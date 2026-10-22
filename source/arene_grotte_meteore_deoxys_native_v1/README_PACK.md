# FGM1 — Grotte Météore · Arène de Deoxys (Port Natif Multicalque 576×576, 10 calques)

## Référence canonique et statut exact
- Capture issue du port `PMD Red` : `references/b74_meteor_cave_deoxys.png` (`b74` *Meteor Cave*, `576 × 576 px`, `72 × 72` cases `8×8`).
- **Nature : `100 % Natif` (pixels natifs exacts de `b74`, dérive chromatique `0,00` sur tous les matériaux ; recomposition à `t = 0` bit-à-bit identique à `b74_meteor_cave_deoxys.png`)**.
- Aucun cristal ni aucune météorite flottante n'est coupé : les 8 météorites en lévitation (`poses/FGM1_pose_00..07_meteorite.png`) sont extraites par composantes connexes entières (`scipy.ndimage.label`) et animées par décalages entiers fermés (`±2 px`) en conservant exclusivement la palette GBA native de `b74`.
- Statut : `art_approved = false`, `runtime_tested = false`.

## Empilement multicalque (bas → haut)
0. `FGM1_00_vide_spatial` — fond spatial bleu nuit natif continu (`0` trou sous les météorites en lévitation)
1. `FGM1_01_dalle_meteorite_violette` — plateau central praticable de l'arène de Deoxys
2. `FGM1_02_anneaux_gravures_sombres` — cercles concentriques outremer gravés au sol
3. `FGM1_03_coeur_cyan_central` — médaillon central cyan d'énergie
4. `FGM1_04_circuits_psioniques` — réseau géométrique gravé dans le cratère
5. `FGM1_05_rempart_cristaux_sombres` — assise sombre du rempart cristallin carré
6. `FGM1_06_rempart_facettes_vives` — facettes vives et reflets cyan du rempart
7. `FGM1_07_meteorites_fixes_et_cosmos` — astéroïdes périphériques fixes et nuances spatiales natives
8. `FGM1_08_onde_psionique_b74` — onde radiale centrifuge dans la palette native exacte de `b74` (`16 × 4 = 64 ticks`)
9. `FGM1_09_levitation_meteorites` — lévitation douce de 8 modules complets de météorites natives (`16 × 4 = 64 ticks`)
10. `Top` (`Layer = 4`) — calque avant-plan vide pour l'édition dans PMDO `0.8.12`
