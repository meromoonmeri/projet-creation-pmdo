# Fin Clairière tropicale (4:3) — projet PMDO 0.8.12

Ce dossier est un projet d'édition autonome, `fin_clairiere_tropicale`. Il contient le Ground `fct3_fin_clairiere_tropicale` au **format 4:3 vaste** : 768 × 576 px, soit 96 × 72 cases de 8 px (`TexSize=1`), environ 2,4 × 2,4 écrans PMDO.

Cette zone de fin de donjon prolonge l'entrée `ETC1` (`entree_clairiere_tropicale_sud_nord_v1`, réf. `large.S01P03A…png`) dans l'ordre du mod après `FST1`. Le préfixe `FCT3` est utilisé car `FTC1`, `FCT1` et `FCT2` sont pris sur des branches sœurs.

## Installer

- **Projet séparé** : copier `fin_clairiere_tropicale` dans `PMDO/MODS/`, activer le mod, puis ouvrir le Ground.
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
| 08 | Tertre sanctuaire de terre et de roche au nord | fixe |
| 09 | Rive de terre le long de la mer | fixe |
| 10 | Mer : vagues de la capture qui montent vers la rive ; seule une bande sombre touche la terre | 24 × 5 ticks |
| 11 | Papillons (planche de l'entrée ETC1 réutilisée), vol en huit | 24 × 5 ticks |
| 12 | Vide, `Layer=4` (Top) | — |

La scène complète boucle en 120 ticks (2 s). Tous les calques sont opaques ou transparents, sans alpha intermédiaire.

## Marqueurs et collisions

- **Marqueurs** : `entrance` est au sud, dans le couloir d'arrivée. `boss` est au centre de la clairière. `objectif` est au nord, au pied du tertre sanctuaire. **Aucune sortie, aucun warp, pas de `donjon_seuil`.**
- **Collisions** : l'herbe, les ombres, les dalles et les touffes reliées à la clairière sont praticables. La jungle, les palmiers, les fleurs, le tertre, la rive et la mer sont bloqués. Un chemin libre de 16 × 16 px a été vérifié de l'arrivée au boss et à l'objectif. **À contrôler en jeu.**

## Limites

- **Terrain et papillons** : ce sont des dessins générés à partir de la capture (`papillons_poses.png` reprise de l'entrée `ETC1` sans nouvelle génération). Ce ne sont pas des tuiles natives.
- **Mer** : pixels posés par programme, avec uniquement le profil, la crête et les couleurs relevés sur la capture. Le défilement est créé par nous. Le filet clair de la capture contre la rive n'est **pas** repris.
- **Animations** : ce ne sont pas des animations officielles.
- **Tests** : aucun test fait dans PMDO (`art_approved: false`, `runtime_tested: false`).
