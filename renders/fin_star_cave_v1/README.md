# FST1 — Fin Star Cave : arène de cristal (4:3, PMDO 0.8.12)

Neuvième zone de fin de donjon de la série, après Fin Vapeur, Cratère, Ruine, Givre, Bristle, Jungle, Waterfall Cave et Sables mouvants. Elle prolonge l'entrée **ESC1** (Star Cave). Biome et portée choisis par l'agent, **à confirmer**.

- **Référence** : `starcavepmdsky.png` (Star Cave, deux vues 504 × 504), passée au générateur en image de référence. C'est un **rendu généré référencé**, pas des tuiles natives.
- **Layout** : arrivée au sud par un couloir de sol acier (`entrance`), caverne ronde fermée par des parois de cristal, amas de rochers de chaque côté, alcôve de cristal au nord ; `boss` au centre de l'arène, `objectif` au pied de l'alcôve. Ni sortie ni warp.
- **Bruts** (`source/fin_star_cave_v1/bruts/`) : `decor.png` (1200 × 896, deuxième essai ; le premier, 1440 × 720, a été écarté), `sol_complet.png` (édité depuis le décor), `poussiere_etoile_poses.png` (planche de ESC1 réutilisée sans nouvelle génération).
- **Calques** (9 dans le Ground, dont un Top vide) : sol complet, sol, ombres, parois, blocs, reflets, étoiles, poussière d'étoile. Boucle de scène : 120 ticks. Aucun calque translucide. Pas de calque de profondeur (pas de bouche sombre dans une fin).
- **Animations** : mêmes fonctions, mêmes sprites d'étoiles et mêmes couleurs EXACTES du rip que ESC1. Le mouvement est créé par nous.
- **Fidélité au rip** (distance RVB moyenne par matière, seuil 35) : sol 6,8 (calque 8,4), cristal 30,8 (parois 32,1, blocs 18,0).
- **Accès** : 1 659 cases praticables sur 6 912 ; chemins 16 × 16 de l'arrivée au boss et à l'objectif vérifiés ; la bande nord et les flancs sont des parois.
- **Recalage** du sol complet sur le décor : (0, 0), écart moyen 12,0 (décalé de 1 px : 12,5).
- **Tests** : `.venv/bin/python -m unittest source.fin_star_cave_v1.test_build -v` (13 PASS). 5 mutations vérifiées : boss déplacé sur une paroi, pixel rouge dans le sol, poussière modifiée, marqueur `donjon_seuil` ajouté, masque de blocs modifié.
- **Paquets** : `FST1_projet_pmdo_0812.zip`, `FST1_calques_png_8px.zip`, aperçu `apercu_fin_star_cave_v1.html` à la racine.

Limites : `runtime_tested: false`, `art_approved: false`. Le cristal des parois est le plus éloigné du rip (32,1 sur 35) : le générateur a peint des cristaux plus cyan, en motif répétitif. Collisions, occlusion et gameplay ne sont pas déduits des contrôles d'images. Pas de boss nommé.
