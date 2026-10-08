# FCT1 — Fin Clairière tropicale : arène fermée (4:3, PMDO 0.8.12)

Dixième zone de fin de donjon de la série, après Fin Vapeur, Cratère, Ruine, Givre, Bristle, Jungle, Waterfall Cave, Sables mouvants et Star Cave. Elle prolonge l'entrée **ETC1**. Biome et portée choisis par l'agent, **à confirmer**.

- **Référence** : `large.S01P03A.png.84e22fb77c4061e77b0f546545fed2c7.png` (clairière tropicale, 456 × 456), passée au générateur. **Rendu généré référencé**, pas des tuiles natives.
- **Layout** : arrivée au sud par un sentier de dalles (`entrance`), grande clairière fermée par la jungle, `boss` au centre, tertre de hibiscus et palmier au nord (`objectif`). Ni mer, ni ponton, ni bouche sombre, ni warp.
- **Bruts** (`source/fin_clairiere_tropicale_v1/bruts/`) : `decor.png` (1200 × 896), `sol_complet.png` et `temoin_sans_objets.png` (édités depuis le décor, recalage (0, 0)), `papillons_poses.png` (planche ETC1, même sha256).
- **Calques** (9 dans le Ground, dont un Top vide) : sol complet, herbe, ombres, dalles, touffes, fleurs, jungle, palmiers, papillons. Boucle 120 ticks.
- **Fidélité au rip** (distance RVB moyenne, seuil 35) : herbe 11,1 (calque 11,8), jungle 26,6 (30,5), dalles 14,8 (15,1).
- **Accès** : 2 777 cases praticables sur 6 912 ; chemins 16 × 16 de l'arrivée au boss et à l'objectif vérifiés.
- **Tests** : 11 PASS. Paquets : `FCT1_projet_pmdo_0812.zip`, `FCT1_calques_png_8px.zip`, aperçu `apercu_fin_clairiere_tropicale_v1.html`.

Limites : `runtime_tested: false`, `art_approved: false`. Les palmiers du générateur sont plus « noix de coco » que le rip. Collisions et gameplay à contrôler en jeu.
