# Entrée Jardin secret V2, temple de Celebi, sud → nord (4:3) — projet PMDO 0.8.12

Ce dossier est un projet d'édition autonome, `entree_jardin_secret_sud_nord_v2`. Il contient le Ground `ejs2_entree_jardin_secret_temple` au **format 4:3 vaste** : 768 × 576 px, soit 96 × 72 cases de 8 px (`TexSize=1`), environ 2,4 × 2,4 écrans PMDO.

C'est le jardin secret d'EJS1 (d'après la capture `secretgarden.png`), avec, à la demande de l'utilisateur, un **temple miniature de Celebi** posé sur la souche : toit vert, piliers de bois, socle de pierre, emblème de Celebi sur le fronton. La porte du temple est l'entrée du donjon. Ces choix (porte = entrée, Celebi en emblème, nouvelle version) sont ceux de l'agent et restent à confirmer.

## Installer

- **Projet séparé** : copier `entree_jardin_secret_sud_nord_v2` dans `PMDO/MODS/`, activer le mod, puis ouvrir le Ground.
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
| 09 | Temple miniature de Celebi : toit, piliers, socle | fixe |
| 10 | Marches : escalier de la souche et parvis de pierre (praticables) | fixe |
| 11 | Profondeur : porte sombre du temple | fixe |
| 12 | Fond vert sombre | fixe |
| 13 | Emblème de Celebi : il s'éclaire puis revient, rampe exacte du rayon | 24 × 5 ticks |
| 14 | Rayon de lumière : le faisceau « respire » sur la rampe exacte de la capture | 24 × 5 ticks |
| 15 | Lucioles : 10 points lumineux qui montent, couleurs exactes du rayon | 24 × 5 ticks |
| 16 | Vide, `Layer=4` (Top) | — |

La scène complète boucle en 120 ticks (2 s). Tous les calques sont opaques ou transparents, sans alpha intermédiaire.

## Marqueurs et collisions

- **Marqueurs** : `entrance` est au sud, au bout de l'allée entre les haies. `donjon_seuil` est devant la porte du temple, sur le parvis. **Aucun warp.**
- **Collisions** : la prairie, l'herbe, les ombres, les fleurs et les marches reliées à l'allée sud sont praticables. Les rochers, les arbres, les haies, la souche, le temple, sa porte, le fond et le rayon sont bloqués. Les lucioles sont purement visuelles. Quelques poches d'herbe murées entre les haies et les rochers restent bloquées. Un chemin libre de 16 × 16 px a été vérifié sur la grille. **À contrôler en jeu.**

## Limites

- **Terrain** : dessin généré à partir de la capture.
- **Temple** : généré à partir de la capture et du décor d'EJS1 ; seule sa zone est reprise dans le décor.
- **Emblème, rayon et lucioles** : couleurs exactes du rayon de la capture ; les formes sont générées, la lueur, le souffle, les trajets et la cadence sont créés par nous.
- **Animations** : ce ne sont pas des animations officielles.
- **Tests** : aucun test fait dans PMDO.
