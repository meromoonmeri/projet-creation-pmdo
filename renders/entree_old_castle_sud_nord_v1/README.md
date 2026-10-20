# Entrée Old Castle sud → nord — EOC1 (projet PMDO 0.8.12)

Ce dossier est un projet d'édition autonome, `entree_old_castle_sud_nord`. Il contient le Ground `eoc1_entree_old_castle` au **format 4:3 vaste** : 768 × 576 px, soit 96 × 72 cases de 8 px (`TexSize=1`).

Le biome (intérieur de vieux château en ruines, salle au trésor, d'après la capture `oldcastlepmd.png`) est la seule référence de la racine encore libre sur toutes les branches ; choix pour la suite de la série sud → nord, décor validé par l'utilisateur.

## Installation éditeur

- **Projet séparé** : copier `entree_old_castle_sud_nord` dans `PMDO/MODS/`, activer le mod, puis ouvrir le Ground.
- L'installateur `INSTALLER.py` est celui du projet Métano (ne pas l'utiliser pour un autre usage).

## Calques (dans l'ordre du Ground)

| # | Calque | Type |
|---|---|---|
| 00 | sol_complet (briques beige, fond plein) | fixe |
| 01 | sol | fixe |
| 02 | ombres (pied des parois) | fixe |
| 03 | medaillon (arène circulaire centrale) | fixe |
| 04 | Alcôve (plateforme au trésor) | fixe |
| 05 | eboulis (blocs de pierre) | fixe |
| 06 | tresor (coffres, statues et or) | fixe |
| 07 | parois | fixe |
| 08 | vide (noir hors carte) | fixe |
| 09 | scintillement (éclats dorés sur l'or, 24 phases × 5 ticks) | animé |
| 10 | Top (vos éléments d'avant-plan) | vide, à vous |

- **Marqueurs** : `entrance` au sud, `donjon_seuil` au sud de l'Alcôve au trésor. **Aucun warp.**
- **Collisions** : sol, ombres, médaillon et Alcôve reliés au sud sont praticables ; le reste est bloqué. Chemin 16 × 16 px vérifié sur la grille. **À contrôler en jeu** ; aucun test runtime PMDO.
- `art_approved: false` (en attente de validation globale).
