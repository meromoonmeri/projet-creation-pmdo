# Entrée Clairière tropicale sud → nord (4:3) — projet PMDO 0.8.12

Ce dossier est un projet d'édition autonome, `entree_clairiere_tropicale_sud_nord`. Il contient le Ground `etc1_entree_clairiere_tropicale` au **format 4:3 vaste** : 768 × 576 px, soit 96 × 72 cases de 8 px (`TexSize=1`), environ 2,4 × 2,4 écrans PMDO.

Le biome (clairière tropicale avec arrivée par un ponton, d'après la capture `large.S01P03A…png`) a été choisi par l'agent pour la suite de la série. Il reste à confirmer.

## Installer

- **Projet séparé** : copier `entree_clairiere_tropicale_sud_nord` dans `PMDO/MODS/`, activer le mod, puis ouvrir le Ground.
- **Dans un mod existant** : lancer `python INSTALLER.py /chemin/PMDO/MODS/mon_mod --dry-run`, puis relancer la même commande sans `--dry-run`.

## Calques (bas → haut)

| # | Calque | Animation |
|---|---|---|
| 00 | Sol complet (herbe claire, aussi sous tout le reste) | fixe |
| 01 | Herbe de la clairière | fixe |
| 02 | Ombres : l'herbe s'assombrit au pied du tertre | fixe |
| 03 | Dalles de sable | fixe |
| 04 | Touffes et cailloux | fixe |
| 05 | Fleurs (hibiscus) | fixe |
| 06 | Jungle dense | fixe |
| 07 | Palmiers | fixe |
| 08 | Tertre de terre et de roche autour de l'entrée | fixe |
| 09 | Seuil : sol de terre de la bouche | fixe |
| 10 | Profondeur : entrée sombre au nord | fixe |
| 11 | Rive de terre | fixe |
| 12 | Ponton | fixe |
| 13 | Mer : vagues de la capture qui montent vers la rive ; seule une bande sombre touche la terre | 24 × 5 ticks |
| 14 | Papillons (générés), vol en huit | 24 × 5 ticks |
| 15 | Vide, `Layer=4` (Top) | — |

La scène complète boucle en 120 ticks (2 s). Tous les calques sont opaques ou transparents, sans alpha intermédiaire.

## Marqueurs et collisions

- **Marqueurs** : `entrance` est au sud, sur le ponton. `donjon_seuil` est juste sous l'entrée sombre. **Aucun warp.**
- **Collisions** : l'herbe, les ombres, les dalles, le seuil, les touffes reliées à la clairière et le ponton sont praticables. La jungle, les palmiers, les fleurs, le tertre, la rive, la bouche et la mer sont bloqués. Les papillons sont purement visuels. Un chemin libre de 16 × 16 px a été vérifié sur la grille. **À contrôler en jeu.**

## Limites

- **Terrain et papillons** : ce sont des dessins générés à partir de la capture.
- **Mer** : pixels posés par programme, avec uniquement le profil, la crête et les couleurs relevés sur la capture. Le défilement est créé par nous. Le filet clair de la capture contre la rive n'est **pas** repris.
- **Animations** : ce ne sont pas des animations officielles.
- **Tests** : aucun test fait dans PMDO.
