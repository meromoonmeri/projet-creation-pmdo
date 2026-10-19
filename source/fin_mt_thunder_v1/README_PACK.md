# Fin Mt. Thunder (4:3) — projet PMDO 0.8.12

Ce dossier est un projet d'édition autonome, `fin_mt_thunder`. Il contient le Ground `fmt4_fin_mt_thunder` au **format 4:3 vaste** : 768 × 576 px, soit 96 × 72 cases de 8 px (`TexSize=1`), environ 2,4 × 2,4 écrans PMDO.

Cette salle de fin (sommet d'orage de Mt. Thunder, cul-de-sac de boss et d'objectif sans sortie) prolonge l'entrée `EMT1` (`entree_mt_thunder_sud_nord`, réf. `Game Boy Advance - Pokemon Mystery Dungeon_ Red Rescue Team - Dungeon Boss Rooms - Mt. Thunder.png`).

## Installer

- **Projet séparé** : copier `fin_mt_thunder` dans `PMDO/MODS/`, activer le mod, puis ouvrir le Ground.
- **Dans un mod existant** : lancer `python INSTALLER.py /chemin/PMDO/MODS/mon_mod --dry-run`, puis relancer la même commande sans `--dry-run`.

## Calques (bas → haut)

| # | Calque | Animation |
|---|---|---|
| 00 | Sol complet (sable, aussi sous tout le reste) | fixe |
| 01 | Sable du plateau et de la crête d'arrivée | fixe |
| 02 | Cailloux (petits, praticables) | fixe |
| 03 | Pics de roche et pierres moussues | fixe |
| 04 | Falaise : bords rocheux du plateau et de la crête | fixe |
| 05 | Piton : massif rocheux de l'estrade nord | fixe |
| 06 | Degrés : escalier de pierre central de l'estrade nord | fixe |
| 07 | Esplanade : terrasse de sable au sommet de l'estrade nord | fixe |
| 08 | Ciel d'orage | fixe |
| 09 | Nuages | fixe |
| 10 | Lueurs : arc « Flash » de la planche, au pied de chaque éclair | 48 × 5 ticks |
| 11 | Éclairs : les 4 éclairs de la planche, « Normal » puis « Fading » | 48 × 5 ticks |
| 12 | Vide, `Layer=4` (Top) | — |

La scène complète boucle en 240 ticks (4 s). Tous les calques sont opaques ou transparents, sans alpha intermédiaire.

## Marqueurs et collisions (fin de donjon sans sortie)

- **Marqueurs** : `entrance` est au sud, sur la crête d'arrivée. `boss` est au centre du plateau de sable. `objectif` est au nord, au pied des degrés de l'estrade sommitale. **Aucune sortie, aucun warp, aucun marqueur `donjon_seuil`.**
- **Collisions** : le sable et les cailloux reliés à la crête sud sont praticables. Les pics, la falaise, le massif de l'estrade nord (`piton`, `degres`, `esplanade`), le ciel et les nuages sont bloqués ; les bords nord, ouest et est sont entièrement fermés. Les éclairs et les lueurs sont purement visuels. Un chemin libre de 16 × 16 px relie `entrance` → `boss` → `objectif`. **À contrôler en jeu.**

## Limites

- **Terrain** : dessin généré à partir de la capture (`sol_complet` partagé avec `EMT1`).
- **Éclairs et arc** : pixels et couleurs exacts de la planche ; le placement, la cadence et l'arc au pied de l'éclair sont créés par nous.
- **Animations** : ce ne sont pas des animations officielles.
- **Tests** : aucun test fait dans PMDO.
