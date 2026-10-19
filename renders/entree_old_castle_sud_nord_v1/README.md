# Entrée Old Castle / Chambre Dorée sud → nord (4:3) — projet PMDO 0.8.12

Ce dossier est un projet d'édition autonome, `entree_old_castle_sud_nord`. Il contient le Ground `eoc2_entree_old_castle` au **format 4:3 vaste** : 768 × 576 px, soit 96 × 72 cases de 8 px (`TexSize=1`), environ 2,4 × 2,4 écrans PMDO.

Le biome reprend l'esthétique de la Chambre Dorée (`oldcastlepmd.png`, *Pokémon Donjon Mystère : Explorateurs du Ciel*) : dalles de brique dorées avec gradient lumineux crème-or vers le nord, rosace circulaire sculptée au centre, balustrades à volutes dorées, colonnes à sphère d'or et coffres au trésor verts et argentés.

## Installer

- **Projet séparé** : copier `entree_old_castle_sud_nord` dans `PMDO/MODS/`, activer le mod, puis ouvrir le Ground.
- **Dans un mod existant** : lancer `python INSTALLER.py /chemin/PMDO/MODS/mon_mod --dry-run`, puis relancer la même commande sans `--dry-run`.

## Calques (bas → haut)

| # | Calque | Animation |
|---|---|---|
| 00 | Sol complet (dalles dorées et rosace, sous tout le reste) | fixe |
| 01 | Dalles claires (halo crème-or nord) | fixe |
| 02 | Dalles dorées principales | fixe |
| 03 | Rosace circulaire sculptée | fixe |
| 04 | Dalles sombres (allée bronze sud) | fixe |
| 05 | Murs de bordure (enceinte N, S, O, E) | fixe |
| 06 | Colonnes à sphère d'or et balustrades à volutes | fixe |
| 07 | Arche dorée du seuil nord | fixe |
| 08 | Coffres au trésor (deux ailes latérales de 10 coffres) | fixe |
| 09 | Lueur du portail : halo crème-or respirant dans l'arche | 24 × 5 ticks |
| 10 | Éclats d'or : scintillements sur les coffres et sphères d'or | 24 × 5 ticks |
| 11 | Vide, `Layer=4` (Top) | — |

La scène complète boucle en 120 ticks (2 s). Tous les calques sont opaques ou transparents, sans alpha intermédiaire.

## Marqueurs et collisions

- **Marqueurs** : `entrance` est au sud, entre les deux balustrades à volutes. `donjon_seuil` est au nord, sous l'ouverture de l'arche dorée. **Aucun warp.**
- **Collisions** : les dalles claires, les dalles dorées, la rosace centrale et l'allée de dalles sombres sont praticables. Les murs de bordure, les colonnes, les balustrades, les montants de l'arche et les 20 coffres sont bloqués. Un chemin libre de 16 × 16 px a été vérifié sur la grille. **À contrôler en jeu.**

## Limites

- **Terrain, colonnes, arche et coffres** : dessins générés à partir de la capture `oldcastlepmd.png`.
- **Animations** : la lueur du portail et les éclats d'or sont créés par programme en utilisant uniquement des couleurs exactes relevées sur `oldcastlepmd.png`. Ce ne sont pas des animations officielles.
- **Tests** : aucun test fait dans PMDO.
