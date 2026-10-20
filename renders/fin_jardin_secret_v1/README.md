# Fin Jardin secret V1 (FSE1)

Fin de donjon du Jardin secret (EJS1/EJS2), dernière fin de la série des 4 fins.
Préfixe `FSE1` (la série `FJS*` est déjà prise par des repères existants, non repris).
Référence `secretgarden.png` (jardin secret, Explorers of Sky). Méthode « textures
canoniques = rendu généré RÉFÉRENCÉ » : décor 4:3 généré avec le rip en référence
(temple de Celebi sur la souche dorée au nord, grande arène centrale, allée sud entre
haies), témoin sans objets, sol complet (7 essais, 6 écartés gardés dans `bruts/ecartes/`).
14 calques + Top vide ; rayon (rampe exacte du rip) et lucioles animés 24 × 5 ticks.
**Arbres statiques** (la version à feuillage animé a été retirée à la demande de
l'utilisateur, le même jour) et **temple sans emblème** (idem ; décor avec emblème gardé
dans `bruts/ecartes/decor_avec_embleme_v1.png`).

Marqueurs : `entrance` (376,560), `boss` (384,296), `objectif` (360,176, pied des
marches du temple). Aucun warp, aucune sortie, pas de `donjon_seuil`.
2190 cases praticables / 4722 bloquées, chemins 16×16 entrance → boss et → objectif vérifiés.

Fidélité au rip (moyenne RGB par matière, seuil 35) : brut fond 3,5 / herbe claire 8,2 /
herbe 11,5 / roche 17,9 ; calques finaux ≤ 9,1 ; sol complet 31,6.
12 tests PASS, 1 mutation vérifiée. `art_approved: false`, `runtime_tested: false` : aucun test PMDO.
Biome et portée choisis par l'agent, à confirmer. Voir `manifest.json` et
`README_PACK.md` (dans `source/fin_jardin_secret_v1/`).
