# Fin Clairière tropicale — arène de fin (4:3) — projet PMDO 0.8.12

Projet d’édition autonome `fin_clairiere_tropicale` : Ground `fct1_fin_clairiere_tropicale`
au **format 4:3 vaste** (768 × 576 px, 96 × 72 cases de 8 px, `TexSize=1`).

Zone de fin qui prolonge l’entrée Clairière tropicale (ETC1). Biome et portée
choisis par l’agent pour la suite de la série. **À confirmer.**

## Installer

- **Projet séparé** : copier `fin_clairiere_tropicale` dans `PMDO/MODS/`, activer, ouvrir le Ground.
- **Dans un mod existant** : `python INSTALLER.py /chemin/PMDO/MODS/mon_mod --dry-run`, puis sans `--dry-run`.

## Calques (bas → haut)

| # | Calque | Animation |
|---|---|---|
| 00 | Sol complet (herbe de clairière, aussi sous la jungle) | fixe |
| 01 | Herbe praticable | fixe |
| 02 | Ombres au pied de la jungle | fixe |
| 03 | Dalles de sable | fixe |
| 04 | Touffes et cailloux | fixe |
| 05 | Fleurs (hibiscus) | fixe |
| 06 | Jungle dense | fixe |
| 07 | Palmiers | fixe |
| 08 | Papillons (planche ETC1) | 24 × 5 ticks |
| 09 | vide, `Layer=4` (Top) | — |

La scène boucle en 120 ticks (2 s). Tous les calques sont opaques ou transparents, sans alpha intermédiaire.

## Marqueurs et collisions

- `entrance` au sud (sentier de dalles), `boss` au centre, `objectif` au pied du tertre de fleurs au nord.
  **Aucun warp, aucune sortie, pas de `donjon_seuil`.**
- Herbe, ombres, dalles et touffes reliées au sud : praticable. Jungle, palmiers, fleurs : bloqués.
  Papillons visuels. Chemin 16 × 16 vérifié sur la grille. **À contrôler en jeu.**

## Limites

- Terrain : dessin généré d’après `large.S01P03A…png`. Papillons : poses d’ETC1, trajectoires créées par nous.
- Ce ne sont pas des tuiles natives ni des animations officielles.
- Tests moteur : aucun. `art_approved: false`.
