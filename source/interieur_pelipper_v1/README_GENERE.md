# PPO1 — rendu généré référencé, fond magenta, multicalque

Seconde version de l'intérieur Pelipper Post Office, selon la méthode du `GUIDE_CREATION_DE_MAP.md` (étape 1 à 3) :

- **Brut** : `renders/interieur_pelipper_v1/bruts/decor_magenta.png`, généré avec la capture PMD en `images=[reference]`, salle sur fond magenta (255,0,255). Non versionné (règle `renders/**/*.png`).
- **Sorties** : `renders/interieur_pelipper_v1/genere/` — `PPO1_00_base.png`, `PPO1_01_herbe.png`, `PPO1_02_contour_brun.png`, `PPO1_Top_vide.png` (vide, `Layer=4`), `PPO1_assemblage.png`, aperçu HTML, `manifest.json`.
- **Dimensions** : 368 × 296 px (46 × 37 cases de 8 px), taille de la capture.
- **Réduction** : recadrage de la salle (x 134–1078, y 37–786 du brut, marge magenta de 5 px en haut et en bas) puis réduction par classe, vote majoritaire par bloc (≈ 2,57 × 2,57 px par bloc).
- **Palette** : 96 couleurs au plus, MEDIANCUT sans tramage.
- **Fidélité** : distance RGB de l'herbe contre la capture PMD = **4,7** (seuil 35).

## Limites

- Pixels **générés**, non natifs : ne pas présenter comme tuiles canoniques.
- Les trois couches partitionnent la salle, mais les objets (étagères, sacs, bottes de foin) restent dans `00_base` : aucune séparation fine.
- Pas de Ground PMDO, marqueurs ni collisions. Pas de test moteur.

## Reproduire

```sh
.venv/bin/python source/interieur_pelipper_v1/build_genere.py
.venv/bin/python -m unittest source.interieur_pelipper_v1.test_genere -v
```
