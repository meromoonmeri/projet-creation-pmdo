# Entrée Mt. Thunder sud → nord (4:3) — projet PMDO 0.8.12

Ce dossier est un projet d'édition autonome, `entree_mt_thunder_sud_nord`. Il contient le Ground `emt1_entree_mt_thunder` au **format 4:3 vaste** : 768 × 576 px, soit 96 × 72 cases de 8 px (`TexSize=1`), environ 2,4 × 2,4 écrans PMDO.

Le biome (sommet d'orage au-dessus des nuages, d'après la planche de la salle du sommet de Mt. Thunder, *Red Rescue Team*) a été choisi par l'agent pour la suite de la série. Il reste à confirmer.

## Installer

- **Projet séparé** : copier `entree_mt_thunder_sud_nord` dans `PMDO/MODS/`, activer le mod, puis ouvrir le Ground.
- **Dans un mod existant** : lancer `python INSTALLER.py /chemin/PMDO/MODS/mon_mod --dry-run`, puis relancer la même commande sans `--dry-run`.

## Calques (bas → haut)

| # | Calque | Animation |
|---|---|---|
| 00 | Sol complet (sable, aussi sous tout le reste) | fixe |
| 01 | Sable du plateau et de la crête | fixe |
| 02 | Cailloux (petits, praticables) | fixe |
| 03 | Pics de roche et pierres moussues | fixe |
| 04 | Falaise : bords et gradins du plateau | fixe |
| 05 | Piton : roche autour de la grotte | fixe |
| 06 | Seuil : sol de terre de la grotte (praticable) | fixe |
| 07 | Profondeur : grotte sombre au nord | fixe |
| 08 | Ciel d'orage | fixe |
| 09 | Nuages | fixe |
| 10 | Lueurs : arc « Flash » de la planche, au pied de chaque éclair | 48 × 5 ticks |
| 11 | Éclairs : les 4 éclairs de la planche, « Normal » puis « Fading » | 48 × 5 ticks |
| 12 | Vide, `Layer=4` (Top) | — |

La scène complète boucle en 240 ticks (4 s). Tous les calques sont opaques ou transparents, sans alpha intermédiaire.

## Marqueurs et collisions

- **Marqueurs** : `entrance` est au sud, sur la crête d'arrivée. `donjon_seuil` est au ras de la grotte, sur le seuil. **Aucun warp.**
- **Collisions** : le sable, les cailloux et le seuil reliés à la crête sud sont praticables. Les pics, la falaise, le piton, la grotte, le ciel et les nuages sont bloqués. Les éclairs et les lueurs sont purement visuels. Un chemin libre de 16 × 16 px a été vérifié sur la grille. **À contrôler en jeu.**

## Limites

- **Terrain** : dessin généré à partir de la capture.
- **Éclairs et arc** : pixels et couleurs exacts de la planche ; le placement, la cadence et l'arc au pied de l'éclair sont créés par nous.
- **Animations** : ce ne sont pas des animations officielles.
- **Tests** : aucun test fait dans PMDO.
