# Fin Jardin secret (4:3) — projet PMDO 0.8.12

Ce dossier est un projet d'édition autonome, `fin_jardin_secret`. Il contient le Ground `fjs5_fin_jardin_secret` au **format 4:3 vaste** : 768 × 576 px, soit 96 × 72 cases de 8 px (`TexSize=1`), environ 2,4 × 2,4 écrans PMDO.

Cette salle de fin (sanctuaire intérieur du Jardin secret, cul-de-sac de boss et d'objectif sans sortie) prolonge les entrées `EJS1`/`EJS2` (`entree_jardin_secret_sud_nord_v2`, réf. `secretgarden.png` : prairie claire, herbe moyenne, fleurs, rochers beiges, arbres ronds, haies de bordure, souche dorée, rayon de lumière verte).

## Installer

- **Projet séparé** : copier `fin_jardin_secret` dans `PMDO/MODS/`, activer le mod, puis ouvrir le Ground.
- **Dans un mod existant** : lancer `python INSTALLER.py /chemin/PMDO/MODS/mon_mod --dry-run`, puis relancer la même commande sans `--dry-run`.

## Calques (bas → haut)

| # | Calque | Animation |
|---|---|---|
| 00 | Sol complet (herbe, aussi sous tout le reste) | fixe |
| 01 | Prairie : herbe claire et jaune de l'arène centrale | fixe |
| 02 | Herbe moyenne | fixe |
| 03 | Ombres : herbe assombrie au pied des haies, des arbres et des rochers | fixe |
| 04 | Fleurs blanches, jaunes et roses (praticables) | fixe |
| 05 | Rochers beiges | fixe |
| 06 | Arbres ronds | fixe |
| 07 | Haies de bordure | fixe |
| 08 | Souche dorée du sanctuaire nord | fixe |
| 09 | Autel : stèle de pierre fermée posée au sommet de la souche | fixe |
| 10 | Marches : escalier de bois de la souche (praticables) | fixe |
| 11 | Fond vert sombre | fixe |
| 12 | Emblème de Celebi sur la stèle : il s'éclaire puis revient, rampe exacte du rayon | 24 × 5 ticks |
| 13 | Rayon de lumière : le faisceau « respire » sur la rampe exacte de la capture | 24 × 5 ticks |
| 14 | Lucioles : 10 points lumineux qui montent, couleurs exactes du rayon | 24 × 5 ticks |
| 15 | Vide, `Layer=4` (Top) | — |

La scène complète boucle en 120 ticks (2 s). Tous les calques sont opaques ou transparents, sans alpha intermédiaire.

## Marqueurs et collisions (fin de donjon sans sortie)

- **Marqueurs** : `entrance` est au sud, au bout de l'allée entre les haies. `boss` est au centre de la grande prairie. `objectif` est au nord, au pied des marches de la souche-autel. **Aucune sortie, aucun warp, aucun marqueur `donjon_seuil`.**
- **Collisions** : la prairie, l'herbe, les ombres, les fleurs et les marches reliées à l'allée sud sont praticables. Les rochers, les arbres, les haies, la souche, l'autel de pierre, le fond et le rayon sont bloqués ; les bords nord, ouest et est sont entièrement fermés. L'emblème, le rayon et les lucioles sont purement visuels. Un chemin libre de 16 × 16 px relie `entrance` → `boss` → `objectif`. **À contrôler en jeu.**

## Limites

- **Terrain** : dessin généré à partir de la capture (`sol_complet` partagé avec `EJS1`/`EJS2`).
- **Emblème, rayon et lucioles** : couleurs exactes du rayon de la capture ; les formes sont générées, la lueur, le souffle, les trajets et la cadence sont créés par nous.
- **Animations** : ce ne sont pas des animations officielles.
- **Tests** : aucun test fait dans PMDO.
