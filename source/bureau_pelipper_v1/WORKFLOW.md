# WORKFLOW — PPO1 Bureau Pelipper

1. Planche TSR 5416 recadrée (`bruts/planche_salle.png`, sans poses Pelipper).
2. Génération `bruts/decor.png` 1200 × 896, textures canoniques, layout spacieux (cour d’herbe au sud).
3. Témoin sans foin / sacs / bûches ; sol d’herbe GBA.
4. `build.py` : classify, palettes, Ground 768 × 576, 9 calques + Top.
5. `test_build.py` puis `package.py`.
