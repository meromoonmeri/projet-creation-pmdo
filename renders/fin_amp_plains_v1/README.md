# Fin Amp Plains / Plaine Électrik (4:3) — arène de boss — projet PMDO 0.8.12

Ce dossier est un projet d'édition autonome, `fin_amp_plains`. Il contient le Ground `fam1_fin_amp_plains` au **format 4:3 vaste** : 768 × 576 px, soit 96 × 72 cases de 8 px (`TexSize=1`), environ 2,4 × 2,4 écrans PMDO.

Le biome reprend l'esthétique de la Plaine Électrik (`Amp_Plains_entrance_TD.png`, *Pokémon Donjon Mystère : Explorateurs du Ciel*) : arène de savane jaune-olive à brins fins entourée de falaises d'ardoise fracturées fermant le nord et les côtés, 2 arbres morts foudroyés, 11 rochers d'ardoise et un monolithe / autel de foudre à degrés au nord-centre.

## Installer

- **Projet séparé** : copier `fin_amp_plains` dans `PMDO/MODS/`, activer le mod, puis ouvrir le Ground.
- **Dans un mod existant** : lancer `python INSTALLER.py /chemin/PMDO/MODS/mon_mod --dry-run`, puis relancer la même commande sans `--dry-run`.

## Calques (bas → haut)

| # | Calque | Animation |
|---|---|---|
| 00 | Sol complet (savane et falaises sans objets, sous tout le reste) | fixe |
| 01 | Herbe de savane jaune-olive | fixe |
| 02 | Herbe sombre (ombres au pied des parois) | fixe |
| 03 | Petits cailloux (praticables) | fixe |
| 04 | Rochers gris-ardoise (11 blocs) | fixe |
| 05 | Arbres morts foudroyés (2 arbres) | fixe |
| 06 | Autel / monolithe de foudre au nord-centre | fixe |
| 07 | Falaises claires d'ardoise (enceinte fermée) | fixe |
| 08 | Falaises sombres et crevasses | fixe |
| 09 | Foudre sur l'autel et les arbres morts | 24 × 5 ticks |
| 10 | Étincelles statiques dérivant au-dessus de l'arène | 24 × 5 ticks |
| 11 | Vide, `Layer=4` (Top) | — |

La scène complète boucle en 120 ticks (2 s). Tous les calques sont opaques ou transparents, sans alpha intermédiaire.

## Marqueurs et collisions

- **Marqueurs** : `entrance` est au sud, dans le goulet d'arrivée ; `boss` est au centre de l'arène ; `objectif` est au nord, au pied du monolithe de foudre. **Aucune sortie, aucun `donjon_seuil`, aucun warp.**
- **Collisions** : l'herbe, l'herbe sombre et les petits cailloux sont praticables. Les falaises d'ardoise, le monolithe de foudre, les 11 rochers et les 2 arbres morts sont bloqués. Un chemin libre de 16 × 16 px a été vérifié sur la grille (`entrance` → `boss` → `objectif`). **À contrôler en jeu.**

## Limites

- **Terrain, monolithe, rochers et arbres morts** : dessins générés à partir de la capture `Amp_Plains_entrance_TD.png`.
- **Animations** : les arcs de foudre et étincelles statiques sont créés par programme. Ce ne sont pas des animations officielles.
- **Tests** : aucun test fait dans PMDO.
