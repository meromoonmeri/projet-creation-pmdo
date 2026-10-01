# Entrée Jardin secret sud → nord (4:3) — projet PMDO 0.8.12

Ce dossier est un projet d'édition autonome, `entree_jardin_secret_sud_nord`. Il contient le Ground `ejs1_entree_jardin_secret` au **format 4:3 vaste** : 768 × 576 px, soit 96 × 72 cases de 8 px (`TexSize=1`), environ 2,4 × 2,4 écrans PMDO.

Le biome (jardin secret : prairie fleurie entre des haies, souche dorée à marches sous un rayon de lumière verte, d'après la capture `secretgarden.png`) a été choisi par l'agent pour la suite de la série. Il reste à confirmer.

## Installer

- **Projet séparé** : copier `entree_jardin_secret_sud_nord` dans `PMDO/MODS/`, activer le mod, puis ouvrir le Ground.
- **Dans un mod existant** : lancer `python INSTALLER.py /chemin/PMDO/MODS/mon_mod --dry-run`, puis relancer la même commande sans `--dry-run`.

## Calques (bas → haut)

| # | Calque | Animation |
|---|---|---|
| 00 | Sol complet (herbe, aussi sous tout le reste) | fixe |
| 01 | Prairie : herbe claire et jaune du centre | fixe |
| 02 | Herbe moyenne | fixe |
| 03 | Ombres : herbe assombrie au pied des haies, des arbres et des rochers | fixe |
| 04 | Fleurs blanches, jaunes et roses (praticables) | fixe |
| 05 | Rochers beiges | fixe |
| 06 | Arbres ronds | fixe |
| 07 | Haies de bordure | fixe |
| 08 | Souche dorée | fixe |
| 09 | Marches de la souche (praticables) | fixe |
| 10 | Profondeur : trou sombre de la souche | fixe |
| 11 | Fond vert sombre | fixe |
| 12 | Rayon de lumière : le faisceau « respire » sur la rampe exacte de la capture | 24 × 5 ticks |
| 13 | Lucioles : 10 points lumineux qui montent, couleurs exactes du rayon | 24 × 5 ticks |
| 14 | Vide, `Layer=4` (Top) | — |

La scène complète boucle en 120 ticks (2 s). Tous les calques sont opaques ou transparents, sans alpha intermédiaire.

## Marqueurs et collisions

- **Marqueurs** : `entrance` est au sud, au bout de l'allée entre les haies. `donjon_seuil` est au pied du trou de la souche, sur les marches. **Aucun warp.**
- **Collisions** : la prairie, l'herbe, les ombres, les fleurs et les marches reliées à l'allée sud sont praticables. Les rochers, les arbres, les haies, la souche, le trou, le fond et le rayon sont bloqués. Les lucioles sont purement visuelles. Quelques poches d'herbe murées entre les haies et les rochers restent bloquées. Un chemin libre de 16 × 16 px a été vérifié sur la grille. **À contrôler en jeu.**

## Limites

- **Terrain** : dessin généré à partir de la capture.
- **Rayon et lucioles** : couleurs exactes de la capture ; la forme du rayon est générée, le souffle, les trajets et la cadence sont créés par nous.
- **Animations** : ce ne sont pas des animations officielles.
- **Tests** : aucun test fait dans PMDO.
