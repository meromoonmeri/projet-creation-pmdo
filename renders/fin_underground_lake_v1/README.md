# Fin Underground Lake V1 (FLU1)

Fin de donjon de l'entrée Underground Lake (EUL1), suite de la série des fins dans
l'ordre du mod (après FWC1 ; FUL1 des branches sœurs non repris, d'où le préfixe FLU1).
Référence `Underground_Lake_shore_TDS.png`. Méthode « textures canoniques = rendu
généré RÉFÉRENCÉ » : décor 4:3 généré avec le rip en référence (lac en magenta),
sol complet édité depuis le décor, planche gouttes/ronds réutilisée d'EUL1.
10 calques + Top vide ; lac Métano (4×10), lueur (12×10), scintillements natifs (4×10),
gouttes et ronds (24×5) animés, scène 120 ticks.

Marqueurs : `entrance` (384,560), `boss` (384,376), `objectif` (368,152, haut de la
chaussée sur la rive nord). Aucun tunnel, aucun warp, pas de `donjon_seuil`.
1334 cases praticables / 5578 bloquées, chemins 16×16 entrance → boss et → objectif vérifiés.

Fidélité au rip (seuil 35 pour les calques) : brut sable 4,8 / roche 1,8 ; calques
finaux sable 6,0 / roche 4,3 / piliers 21,9. Eau et lueur aux couleurs exactes du rip,
scintillements Métano natifs. 15 tests PASS, 1 mutation vérifiée (pixel magenta dans
une frame d'eau détecté, restauré par rebuild). `art_approved: false`,
`runtime_tested: false` : aucun test PMDO. Biome et portée choisis par l'agent, à
confirmer. Voir `manifest.json` et `README_PACK.md` (dans `source/fin_underground_lake_v1/`).
