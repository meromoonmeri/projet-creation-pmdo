# Bureau Pelipper — intérieur agrandi (4:3) — projet PMDO 0.8.12

Projet d’édition autonome `bureau_pelipper` : Ground `ppo1_bureau_pelipper`
au **format 4:3 vaste** (768 × 576 px, 96 × 72 cases de 8 px, `TexSize=1`).

Grande salle intérieure du Pelipper Post Office (Red Rescue Team), d’après
[la planche Spriters Resource n° 5416](https://www.spriters-resource.com/game_boy_advance/pokemonmysterydungeonredrescueteam/asset/5416/).
**À confirmer.**

## Installer

- **Projet séparé** : copier `bureau_pelipper` dans `PMDO/MODS/`, activer, ouvrir le Ground.
- **Dans un mod existant** : `python INSTALLER.py /chemin/PMDO/MODS/mon_mod --dry-run`, puis sans `--dry-run`.

## Calques (bas → haut)

| # | Calque | Animation |
|---|---|---|
| 00 | Sol complet (herbe) | fixe |
| 01 | Herbe (cour) | fixe |
| 02 | Chemin (terre, sud) | fixe |
| 03 | Bois (plancher haut) | fixe |
| 04 | Foin | fixe |
| 05 | Sacs | fixe |
| 06 | Meubles (comptoir, rayonnages, rambardes) | fixe |
| 07 | Murs (planches, fenêtres) | fixe |
| 08 | Fond (navy hors bâtiment) | fixe |
| 09 | vide, `Layer=4` (Top) | — |

## Marqueurs et collisions

- `entrance` au sud (chemin de terre), `comptoir` au pied de l’escalier, au nord de la cour.
  **Aucun warp.**
- Herbe et chemin reliés au sud : praticable. Plancher haut, foin, sacs, meubles, murs, fond : bloqués.
  **À contrôler en jeu.**

## Limites

- Terrain : dessin généré d’après la planche d’intérieur (sans les poses Pelipper).
- Ce ne sont pas des tuiles natives. Tests moteur : aucun. `art_approved: false`.
