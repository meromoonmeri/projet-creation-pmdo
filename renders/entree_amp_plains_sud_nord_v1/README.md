# Entrée Amp Plains / Plaine Électrik sud → nord (4:3) — projet PMDO 0.8.12

Ce dossier est un projet d'édition autonome, `entree_amp_plains_sud_nord`. Il contient le Ground `eam1_entree_amp_plains` au **format 4:3 vaste** : 768 × 576 px, soit 96 × 72 cases de 8 px (`TexSize=1`), environ 2,4 × 2,4 écrans PMDO.

Le biome reprend l'esthétique de la Plaine Électrik (`Amp_Plains_entrance_TD.png`, *Pokémon Donjon Mystère : Explorateurs du Ciel*) : savane jaune-olive à brins fins, falaises et rochers gris-ardoise fracturés, et arbres morts noirs tortueux foudroyés.

## Installer

- **Projet séparé** : copier `entree_amp_plains_sud_nord` dans `PMDO/MODS/`, activer le mod, puis ouvrir le Ground.
- **Dans un mod existant** : lancer `python INSTALLER.py /chemin/PMDO/MODS/mon_mod --dry-run`, puis relancer la même commande sans `--dry-run`.

## Calques (bas → haut)

| # | Calque | Animation |
|---|---|---|
| 00 | Sol complet (savane et falaises sans objets, sous tout le reste) | fixe |
| 01 | Herbe de savane jaune-olive | fixe |
| 02 | Herbe sombre (ombres et touffes denses) | fixe |
| 03 | Petits cailloux (praticables) | fixe |
| 04 | Rochers gris-ardoise (17 blocs) | fixe |
| 05 | Arbres morts foudroyés (4 arbres) | fixe |
| 06 | Falaises claires d'ardoise | fixe |
| 07 | Falaises sombres et crevasses | fixe |
| 08 | Arcs électriques : éclairs ramifiés et arcs/couronnes au sol générés (style PMD, `electricite_poses.png`) | 24 × 5 ticks |
| 09 | Étincelles statiques : étoiles d'étincelles en 6 poses générées (`electricite_poses.png`) | 24 × 5 ticks |
| 10 | Vide, `Layer=4` (Top) | — |

La scène complète boucle en 120 ticks (2 s). Tous les calques sont opaques ou transparents, sans alpha intermédiaire.

## Marqueurs et collisions

- **Marqueurs** : `entrance` est au sud, dans le goulet d'arrivée. `donjon_seuil` est au nord, dans le goulet rocheux. **Aucun warp.**
- **Collisions** : l'herbe, l'herbe sombre et les petits cailloux sont praticables. Les falaises d'ardoise, les 17 rochers et les 4 arbres morts sont bloqués. Un chemin libre de 16 × 16 px a été vérifié sur la grille. **À contrôler en jeu.**

## Limites

- **Terrain, rochers, arbres morts et électricité** : dessins générés à partir des captures `Amp_Plains_entrance_TD.png` et `Mt. Thunder` (`electricite_poses.png` sur fond magenta pur `#FF00FF`). Ce ne sont pas des tuiles natives.
- **Animations** : les éclairs, arcs et étincelles utilisent les poses générées sur fond magenta et sont animés par programme. Ce ne sont pas des animations officielles.
- **Tests** : aucun test fait dans PMDO.
