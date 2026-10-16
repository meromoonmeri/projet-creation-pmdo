# Fin Grotte aux vasques (4:3) — projet PMDO 0.8.12

Ce dossier est un projet d'édition autonome : `fin_grotte_vasques`. Il contient le Ground `fgv1_fin_grotte_vasques` au **format 4:3 vaste**, soit 768 × 576 px ou 96 × 72 cases de 8 px (`TexSize=1`).

C'est la zone de fin du donjon de la Grotte aux vasques, qui fait suite à l'entrée EGV1. On arrive au sud par un couloir de sable qui débouche sur une grande arène, entre deux pentes de blocs dorés couvertes de vasques turquoise. Trois marches de sable courbes traversent l'arène. Au nord, une cascade de vasques en pyramide, adossée à la voûte, ferme la salle. Il n'y a **ni objet, ni autel, ni structure** : le décor seul. Le biome est inédit et a été choisi par l'agent : il reste à confirmer.

## Installer

- **Projet séparé** : copier `fin_grotte_vasques` dans `PMDO/MODS/`, activer le mod, puis ouvrir le Ground.
- **Dans un mod existant** : lancer `python INSTALLER.py /chemin/PMDO/MODS/mon_mod --dry-run`, puis relancer la même commande sans `--dry-run`.

## Calques (bas → haut)

| # | Calque | Animation |
|---|---|---|
| 00 | Sol complet : sable doré bord à bord, marches comprises, aussi sous les parois | fixe |
| 01 | Sol praticable : sable et contremarches claires | fixe |
| 02 | Ombres : traits sombres des marches et sable assombri au pied des pentes (praticables) | fixe |
| 03 | Vasques : eau aux 14 couleurs exactes du rip `D56P41A` et rebords de pierre | fixe |
| 04 | Parois de blocs dorés et stalactites | fixe |
| 05 | Fond sarcelle derrière les stalactites | fixe |
| 06 | Reflets des vasques : animation de palette exacte du jeu (BPL de `D56P41A`) | 12 × 8 ticks |
| 07 | Bulles de source : une bulle naît, éclate, puis des anneaux s'élargissent (poses générées) | 24 × 4 ticks |
| 08 | Vide, `Layer=4` (Top) | — |

La scène complète boucle en 96 ticks (1,6 s). Chaque pixel de calque est soit opaque, soit transparent : aucun alpha intermédiaire.

## Marqueurs et collisions

- **Marqueurs** :
  - `entrance` au sud, au bord de la carte ;
  - `boss` au centre de l'arène, sous les marches ;
  - `objectif` au pied de la cascade de vasques.

  **Aucun warp, aucune sortie, pas de `donjon_seuil`.**
- **Collisions** : seuls le sable et les ombres sont praticables, marches comprises. Les vasques, les parois et le fond sont bloqués. Les reflets et les bulles sont purement visuels. Un chemin libre de 16 × 16 px de l'arrivée au boss et à l'objectif a été vérifié sur la grille. **À contrôler en jeu.**

## Limites

- **Terrain** : dessin généré à partir de la map `D56P41A` de la ROM (rendu skytemple depuis `pret/pmd-sky`) et du décor de l'entrée EGV1. Ce ne sont pas des tuiles natives. Le nom officiel du lieu n'est pas identifié.
- **Eau** : les tons de l'eau générée sont remplacés par les couleurs d'eau du rip de luminance la plus proche. Le dessin des vasques reste généré.
- **Reflets** : les couleurs et l'enchaînement sont exactement ceux de l'animation de palette du jeu. Les pixels qui les portent viennent du rendu généré.
- **Bulles** : poses de l'entrée EGV1, couleurs ramenées à l'eau du rip, chronologie créée par nous. Ce n'est pas une animation officielle.
- **Tests** : aucun test fait dans PMDO.
