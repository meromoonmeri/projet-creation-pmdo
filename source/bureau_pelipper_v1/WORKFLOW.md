# WORKFLOW — PPO1 Bureau Pelipper

1. Reconstruction `pelipper_poste_interieur.png` (salle seule, sans poses Pelipper) d’après la planche TSR 5416.
2. Génération `bruts/decor.png` 1200 × 896 (grande salle ovale, entrée sud).
3. Témoin sans foin / sacs / objets du comptoir ; sol d’herbe seul.
4. `build.py` : classify, palettes, Ground 768 × 576, 9 calques + Top.
5. `test_build.py` puis `package.py`.
