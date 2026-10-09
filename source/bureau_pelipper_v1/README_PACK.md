# Bureau Pelipper — intérieur agrandi (4:3) — projet PMDO 0.8.12

Projet d’édition autonome `bureau_pelipper` : Ground `ppo1_bureau_pelipper`
au **format 4:3 vaste** (768 × 576 px, 96 × 72 cases de 8 px, `TexSize=1`).

Grande salle **vide** et spacieuse du Pelipper Post Office (Red Rescue Team),
textures de [la planche Spriters Resource n° 5416](https://www.spriters-resource.com/game_boy_advance/pokemonmysterydungeonredrescueteam/asset/5416/).
Le **mobilier** est sur `PPO1_mobilier_tilesheet.png` (fond magenta) : à placer
ensuite dans PMDO (décorations / Top).
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
| 03 | Bois (murs planches) | fixe |
| 04 | Murs (rebord, fenêtres) | fixe |
| 05 | Fond magenta (hors bâtiment) | fixe |
| 06 | vide, `Layer=4` (Top) | — |

## Tilesheet mobilier

`PPO1_mobilier_tilesheet.png` : foin, sacs, bûches, poteaux, comptoir, rayonnage,
casiers, bouteilles, damier, tableau. Fond magenta `(255, 0, 255)`.

## Marqueurs et collisions

- `entrance` au sud (chemin de terre), `comptoir` au nord de la cour.
  **Aucun warp.**
- Herbe et chemin reliés au sud : praticable. Murs, bois, fond : bloqués.
  **À contrôler en jeu.**

## Limites

- Terrain : dessin généré d’après la planche d’intérieur (sans les poses Pelipper).
- Ce ne sont pas des tuiles natives. Tests moteur : aucun. `art_approved: false`.
