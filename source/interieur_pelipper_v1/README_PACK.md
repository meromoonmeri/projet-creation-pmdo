# Intérieur Pelipper Post Office (PPO1)

Projet d'intérieur `interieur_pelipper_v1`, source : capture 1× de *Pokémon Mystery Dungeon : Red Rescue Team* (GBA), fournie par l'utilisateur.

## Sortie

- `renders/interieur_pelipper_v1/PPO1_00_salle_complete.png` — salle recadrée, **368 × 296 px** (46 × 37 cases de 8 px), pixels identiques à la capture.
- `renders/interieur_pelipper_v1/PPO1_apercu_x2_non_destine_au_jeu.png` — aperçu ×2, **non destiné au jeu**.
- `renders/interieur_pelipper_v1/apercu_interieur_pelipper_v1.html` — aperçu autonome.
- `renders/interieur_pelipper_v1/manifest.json` — source (sha256), boîte de recadrage, exclusions, états.

## Ce que ce lot est, et n'est pas

- **Méthode** : recadrage d'une capture de jeu, sans rééchantillonnage, sans recoloration, sans génération.
  Ce n'est ni un rendu généré référencé, ni une extraction de tuiles natives.
- **Un seul calque aplati.** Sols, murs, objets et ombres ne sont pas séparés : les séparer demanderait de redessiner.
- **Exclus** : bande des 7 sprites (y 300–343) et légende (y 352–391).
- **Non produit** : projet Ground PMDO 0.8.12, marqueurs (entrée, objectifs), collisions, animations.
  Ces éléments sont à décider sur la salle avant de les poser ; aucune collision n'est déduite de l'image.
- **Tests** : `test_build.py` (dimensions, pixels identiques, aucune couleur inventée, manifeste). Aucun test moteur.

## Reproduire

```sh
.venv/bin/python source/interieur_pelipper_v1/build.py
.venv/bin/python -m unittest source.interieur_pelipper_v1.test_build -v
```
