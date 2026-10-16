# Entrée Grotte aux vasques — sud → nord (4:3) — projet PMDO 0.8.12

Ce dossier est un projet d'édition autonome : `entree_grotte_vasques_sud_nord`. Il contient le Ground `egv1_entree_grotte_vasques` au **format 4:3 vaste**, soit 768 × 576 px ou 96 × 72 cases de 8 px (`TexSize=1`), environ 2,4 × 2,4 écrans PMDO.

C'est une entrée de donjon de la série sud → nord. On arrive au sud dans une grotte de grès doré. Un large passage de sable traverse la salle entre des pentes de blocs couvertes de vasques turquoise en terrasses, puis mène à la bouche d'un tunnel au nord. Il n'y a pas d'eau devant l'entrée. Le biome est inédit et a été choisi par l'agent : il reste à confirmer.

## Installer

- **Projet séparé** : copier `entree_grotte_vasques_sud_nord` dans `PMDO/MODS/`, activer le mod, puis ouvrir le Ground.
- **Dans un mod existant** : lancer `python INSTALLER.py /chemin/PMDO/MODS/mon_mod --dry-run`, puis relancer la même commande sans `--dry-run`.

## Calques (bas → haut)

| # | Calque | Animation |
|---|---|---|
| 00 | Sol complet : sable doré bord à bord, aussi sous les parois | fixe |
| 01 | Sol praticable (sable) | fixe |
| 02 | Ombres : sable assombri devant la bouche du tunnel | fixe |
| 03 | Vasques : eau aux 12 couleurs exactes du rip et rebords de pierre | fixe |
| 04 | Parois de blocs dorés et stalactites | fixe |
| 05 | Flèches rocheuses posées sur le sable | fixe |
| 06 | Profondeur : bouche du tunnel et fond sarcelle derrière les stalactites | fixe |
| 07 | Reflets des vasques : animation de palette exacte du jeu (palette 13 du BPL de D56P12A) | 32 × 2 ticks |
| 08 | Bulles de source : une bulle naît, éclate, puis des anneaux s'élargissent (poses générées) | 32 × 4 ticks |
| 09 | Vide, `Layer=4` (Top) | — |

La scène complète boucle en 128 ticks (2,1 s). Chaque pixel de calque est soit opaque, soit transparent : aucun alpha intermédiaire.

## Marqueurs et collisions

- **Marqueurs** : `entrance` est au sud, au bord de la carte. `donjon_seuil` est un simple repère juste sous la bouche du tunnel. **Aucun warp, aucune destination.**
- **Collisions** : seuls le sable et les ombres sont praticables. Les vasques, les parois, les flèches et la profondeur sont bloquées. Les reflets et les bulles sont purement visuels. Un chemin libre de 16 × 16 px de l'arrivée au seuil a été vérifié sur la grille. **À contrôler en jeu.**

## Limites

- **Terrain** : dessin généré à partir des maps `D56P12A` et `D56P41A` de la ROM (rendu skytemple depuis `pret/pmd-sky`). Ce ne sont pas des tuiles natives. Le nom officiel du lieu n'est pas identifié.
- **Eau** : les tons de l'eau générée sont remplacés par les couleurs d'eau du rip de luminance la plus proche. Le dessin des vasques reste généré.
- **Reflets** : les couleurs et l'enchaînement sont exactement ceux de l'animation de palette du jeu. Les pixels qui les portent viennent du rendu généré.
- **Bulles** : dessin généré, couleurs ramenées à l'eau du rip, chronologie créée par nous. Ce n'est pas une animation officielle.
- **Tests** : aucun test fait dans PMDO.
