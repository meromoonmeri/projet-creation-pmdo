# Pack 10 Falaises Nord Centrées Nues — 100 % Textures Canoniques Métano · Multicalque · Mer 8 Phases · Jour & Nuit (PMDO 0.8.12)

## Garantie Matière 100 % Canonique (`generated_terrain_rgb_pixels == 0`)
- **0 pixel RGB généré** dans les 10 terrains : chaque calque de chaque carte est reconstruit **exclusivement par tampons alignés sur la grille `8 px`** depuis les planches natives officielles **Halcyon** (`Metano_Town_Base.tile` et `Metano_Town_Cliffs.tile`), découpés selon les 10 silhouettes organiques centrées.
- **5 calques de terrain canoniques séparés par carte** :
  1. `01_Herbe_Metano_Native` (`Metano_Town_Base` `(0,640,128,768)` + brins `(16,776,32,792)` / `(48,792,64,808)`)
  2. `02_Faces_Metano_Natives` (`Metano_Town_Cliffs` `(1064,464,1192,528)` — grès doré Chunsoft torique `32×32` sans raccord X/Y)
  3. `03_Retours_Metano_Natifs` (`Metano_Town_Cliffs` `(456,240,480,304)` Ouest & `(1456,352,1480,416)` Est)
  4. `04_Couronnes_Metano_Natives` (`Metano_Town_Cliffs` `(1064..1192,448..464)` — tranches `8×16` verrouillées en phase)
  5. `05_Pieds_Metano_Natifs` (`Metano_Town_Cliffs` `(1064..1192,520..544)` — tranches `8×24` verrouillées en phase)
- **Nuit exacte `Abyss V4`** (`source/cote_v4_abyss/night.py`), vérifiée bit-à-bit identique à 100 % sur `Metano_Town_Base_Night.tile`, `Metano_Town_Cliffs_Night.tile` et `Metano_Town_Fringe_Night.tile`.
- **Audit indépendant** : exécuter `python3 source/cliff_nord_centre_v1/verify_canonique.py` pour reconstruire les 100 calques depuis `provenance_canonique/*_placements.json` et vérifier l’égalité au bit près.

## Crédits & Statut
- **Palikadude** & contributeurs (*PMDO Halcyon*), **Abyss to Ascension**, **Spike Chunsoft**.
- Statut : `art_approved: false`, `runtime_tested: false`.
