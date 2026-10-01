# FSM1 — Fin Sables mouvants : arène du désert (4:3, PMDO 0.8.12)

Huitième zone de fin de donjon de la série, après Fin Vapeur, Cratère, Ruine, Givre, Bristle, Jungle et Waterfall Cave. Elle prolonge l'entrée **EQS1** (Sables mouvants). Biome et portée choisis par l'agent, **à confirmer**.

- **Référence** : `witheringdesert.png` (Furnace Desert, PMD Rescue Team), copiée telle quelle en image de référence du générateur. C'est un **rendu généré référencé**, pas des tuiles natives.
- **Layout** : arrivée au sud par un couloir de sable (`entrance`) ; arène ronde fermée par des falaises ; grande fosse de sable mouvant au centre ; couronne de sable praticable autour ; deux chutes de sable et une estrade de pierre au nord ; objectif au pied de l'estrade (`objectif`) ; emplacement du combat au sud de la fosse (`boss`). Aucune sortie, aucun warp.
- **Bruts** (`source/fin_sables_mouvants_v1/bruts/`) :
  1. `decor_magenta.png`, arène complète, fosse et chutes en magenta pur (premier essai gardé) ;
  2. `sol_complet.png`, édité depuis le décor ;
  3. `poussiere_poses.png`, planche de l'entrée EQS1 réutilisée sans nouvelle génération.
- **Calques** (10 dans le Ground, dont un Top vide) : fosse (12 × 10), sol complet, sable, ombres, bord de la fosse, roches, pierres, chutes (24 × 5), poussière et tourbillons (24 × 5). Boucle de scène : 120 ticks. Aucun calque translucide.
- **Animations** : mêmes fonctions et mêmes couleurs EXACTES du rip que EQS1 (chargées par `loadmod`, un test compare les constantes). Le mouvement est créé par nous.
- **Fidélité au rip** (distance RVB moyenne par matière, seuil 35) : sable 19,9 (calque 17,4), roche 22,9 (calque 23,9), pierres 14,2.
- **Accès** : 2 184 cases praticables sur 6 912 ; chemins 16 × 16 de l'arrivée au boss et à l'objectif vérifiés ; la fosse est bloquante et se contourne ; la bande nord est une paroi.
- **Recalage** du sol complet sur le décor : (0, 0), écart moyen 4,2 (décalé de 1 px : 4,4).
- **Tests** : `.venv/bin/python -m unittest source.fin_sables_mouvants_v1.test_build -v` (15 PASS). 5 mutations vérifiées : pixel hors rip dans la fosse, boss déplacé dans la fosse, poussière vidée, chute décalée d'un pixel, calque de pierres vidé.
- **Paquets** : `FSM1_projet_pmdo_0812.zip` (projet PMDO), `FSM1_calques_png_8px.zip` (calques PNG, animations, masques, ORA), aperçu `apercu_fin_sables_mouvants_v1.html` à la racine.

Limites : `runtime_tested: false`, `art_approved: false`. Collisions, occlusion et gameplay ne sont pas déduits des contrôles d'images. Pas de boss nommé.
