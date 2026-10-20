# Fin Jardin secret V1 (FSE1)

Fin de donjon du Jardin secret (EJS1/EJS2), dernière fin de la série des 4 fins.
Préfixe `FSE1` (la série `FJS*` est déjà prise par des repères existants, non repris).
Référence `secretgarden.png` (jardin secret, Explorers of Sky). Méthode « textures
canoniques = rendu généré RÉFÉRENCÉ » : décor 4:3 généré avec le rip en référence
(temple de Celebi sur la souche dorée au nord, grande arène centrale, allée sud entre
haies), témoin sans objets, sol complet (7 essais, 6 écartés gardés dans `bruts/ecartes/`).
15 calques + Top vide ; rayon (rampe exacte du rip) et lucioles animés 24 × 5 ticks,
et **feuillage des arbres animé** (demande explicite) : cisaillement horizontal par
houppier, base fixe, haut mobile de 3 px max, phase par arbre, troncs statiques séparés ;
composantes < 300 px (toit-feuille du temple) statiques.

Marqueurs : `entrance` (384,560), `boss` (392,296), `objectif` (360,176, pied des
marches du temple). Aucun warp, aucune sortie, pas de `donjon_seuil`.
2204 cases praticables / 4708 bloquées, chemins 16×16 entrance → boss et → objectif vérifiés.

Fidélité au rip (moyenne RGB par matière, seuil 35) : brut fond 2,1 / herbe claire 10,5 /
herbe 11,8 / roche 16,4 ; calques finaux ≤ 20,6 ; sol complet 31,6.
12 tests PASS, 1 mutation vérifiée (pixel magenta dans une frame de feuillage détecté,
restauré par rebuild). `art_approved: false`, `runtime_tested: false` : aucun test PMDO.
Biome et portée choisis par l'agent, à confirmer. Voir `manifest.json` et
`README_PACK.md` (dans `source/fin_jardin_secret_v1/`).
