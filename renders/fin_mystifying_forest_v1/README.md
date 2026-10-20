# Fin Mystifying Forest V1 (FMY1)

Fin de donjon de l'entrée Mystifying Forest (EMF1), **dernière fin de la série** :
toutes les entrées de cette branche ont désormais leur fin. Préfixe `FMY1` (FMF1/FMF2
des branches sœurs non repris). Référence `Mystifying_Forest_entrance_TDS.png`.
Méthode « textures canoniques = rendu généré RÉFÉRENCÉ » : décor 4:3 généré avec le
rip en référence (mare en magenta), sol complet édité depuis le décor (3e essai, 2
réponses vides), planche feuilles/lucioles réutilisée d'EMF1. 10 calques + Top vide ;
mare Métano (4×10), scintillements natifs (4×10), feuilles et lucioles (48×5) animés,
scène 240 ticks.

Marqueurs : `entrance` (384,560), `boss` (376,376), `objectif` (344,184, bord nord de
la clairière). Aucune ouverture, aucun warp, pas de `donjon_seuil`.
1892 cases praticables / 5020 bloquées, chemins 16×16 entrance → boss et → objectif vérifiés.

Fidélité au rip (seuil 35) : brut herbe 5,9 / chemin 6,5 / feuillage sombre 4,5 /
roche-racines 16,9 ; calques finaux ≤ 25,8. 13 tests PASS, 1 mutation vérifiée (pixel
magenta dans une frame d'eau détecté, restauré par rebuild). `art_approved: false`,
`runtime_tested: false` : aucun test PMDO. Biome et portée choisis par l'agent, à
confirmer. Voir `manifest.json` et `README_PACK.md` (dans `source/fin_mystifying_forest_v1/`).
