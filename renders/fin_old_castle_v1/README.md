# Fin Old Castle / Chambre Dorée (4:3) — salle de boss / trésor — projet PMDO 0.8.12

Ce dossier est un projet d'édition autonome, `fin_old_castle`. Il contient le Ground `foc2_fin_old_castle` au **format 4:3 vaste** : 768 × 576 px, soit 96 × 72 cases de 8 px (`TexSize=1`), environ 2,4 × 2,4 écrans PMDO.

Le biome reprend l'esthétique de la Chambre Dorée (`oldcastlepmd.png`, *Pokémon Donjon Mystère : Explorateurs du Ciel*) : dalles de brique dorées avec gradient lumineux crème-or vers le nord, grande rosace circulaire sculptée au centre (arène de boss), double arc semi-circulaire de 22 coffres au trésor verts et argentés, balustrades à volutes dorées, colonnes à sphère d'or et autel royal doré devant le mur nord fermé.

## Installer

- **Projet séparé** : copier `fin_old_castle` dans `PMDO/MODS/`, activer le mod, puis ouvrir le Ground.
- **Dans un mod existant** : lancer `python INSTALLER.py /chemin/PMDO/MODS/mon_mod --dry-run`, puis relancer la même commande sans `--dry-run`.

## Calques (bas → haut)

| # | Calque | Animation |
|---|---|---|
| 00 | Sol complet (dalles dorées, rosace et mur nord, sous tout le reste) | fixe |
| 01 | Dalles claires (halo crème-or nord) | fixe |
| 02 | Dalles dorées principales | fixe |
| 03 | Rosace circulaire sculptée (arène centrale) | fixe |
| 04 | Dalles sombres (allée bronze sud) | fixe |
| 05 | Murs de bordure (mur nord fermé, côtés et terrasses sud) | fixe |
| 06 | Colonnes à sphère d'or et balustrades à volutes | fixe |
| 07 | Autel royal doré au nord-centre | fixe |
| 08 | Coffres au trésor (double arc semi-circulaire de 22 coffres) | fixe |
| 09 | Lueur de l'autel : halo crème-or respirant | 24 × 5 ticks |
| 10 | Éclats d'or : scintillements sur les coffres, l'autel et les sphères d'or | 24 × 5 ticks |
| 11 | Vide, `Layer=4` (Top) | — |

La scène complète boucle en 120 ticks (2 s). Tous les calques sont opaques ou transparents, sans alpha intermédiaire.

## Marqueurs et collisions

- **Marqueurs** : `entrance` est au sud, entre les deux balustrades à volutes ; `boss` est au centre de la rosace sculptée ; `objectif` est au nord, au pied de l'autel royal doré. **Aucune sortie, aucun `donjon_seuil`, aucun warp.**
- **Collisions** : les dalles claires, les dalles dorées, la rosace centrale et l'allée de dalles sombres sont praticables. Le mur nord fermé, les bords latéraux, les terrasses sud, les colonnes, les balustrades, l'autel et les 22 coffres sont bloqués. Un chemin libre de 16 × 16 px a été vérifié sur la grille (`entrance` → `boss` → `objectif`). **À contrôler en jeu.**

## Limites

- **Terrain, colonnes, autel et coffres** : dessins générés à partir de la capture `oldcastlepmd.png`.
- **Animations** : la lueur de l'autel et les éclats d'or sont créés par programme en utilisant uniquement des couleurs exactes relevées sur `oldcastlepmd.png`. Ce ne sont pas des animations officielles.
- **Tests** : aucun test fait dans PMDO.
