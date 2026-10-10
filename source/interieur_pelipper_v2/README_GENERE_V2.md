# PPO2 — Pelipper Post Office, taille de la référence Halcyon/Palika

**Cible de taille** : `Data/Ground/post_office.rsground` (Palikadude/Halcyon, commit `da6c2130d641507447e6386a5e47a296e8cb4c71`).
Mesuré dans le fichier : `Layers[0].Tiles` est une grille de **16 × 13 tuiles de 24 px**, et les obstacles couvrent 0–384 × 0–312. Soit **384 × 312 px**, ou 48 × 39 cases de 8 px.

## Sorties (`renders/interieur_pelipper_v2/genere/`, non versionnées)

- `PPO2_00_base.png`, `PPO2_01_herbe.png`, `PPO2_02_contour_brun.png`, `PPO2_Top_vide.png` (vide, `Layer=4`).
- `PPO2_assemblage.png`, aperçu HTML, `manifest.json`.

## Méthode

- Brut : `renders/interieur_pelipper_v2/bruts/decor_magenta_v2.png`, rendu généré référencé (`images=[capture PMD]`), plus spacieux que la v1. Non versionné.
- La salle occupe toute la largeur (384 px) et 284 px de hauteur. Elle est réduite à facteur uniforme (≈ 3,125 en x, ≈ 3,13 en y), par vote majoritaire de classe, puis centrée dans le canevas. Les 14 px du haut et du bas sont transparents.
- Palette : 96 couleurs au plus, MEDIANCUT sans tramage.
- Fidélité : distance RGB de l'herbe contre la capture PMD = **6,2** (seuil 35).

## Limites

- Pixels **générés**, non natifs. Taille de référence Halcyon, pas un test moteur.
- Pas de Ground PMDO, de marqueurs ni de collisions dans ce lot.
- Les objets restent dans `00_base` : aucune séparation fine.

## Reproduire

```sh
.venv/bin/python source/interieur_pelipper_v2/build_genere_v2.py
.venv/bin/python -m unittest source.interieur_pelipper_v2.test_genere_v2 -v
```
