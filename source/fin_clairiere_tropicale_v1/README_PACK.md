# Fin Clairière tropicale — arène du tertre sacré (4:3) — projet PMDO 0.8.12

Ce dossier est un projet d'édition autonome, `fin_clairiere_tropicale`. Il contient le Ground
`fct1_fin_clairiere_tropicale` au **format 4:3 vaste** : 768 × 576 px, soit 96 × 72 cases de 8 px
(`TexSize=1`), environ 2,4 × 2,4 écrans PMDO.

C'est la zone de fin de donjon qui prolonge l'entrée Clairière tropicale (ETC1) : arrivée par le
ponton au sud, grande clairière-arène au centre, plateforme de sable au pied du tertre sacré au
nord. Biome et portée choisis par l'agent pour la suite de la série des fins. Ils restent à
confirmer.

## Installer

- **Projet séparé** : copier `fin_clairiere_tropicale` dans `PMDO/MODS/`, activer le mod, puis
  ouvrir le Ground.
- **Dans un mod existant** : lancer `python INSTALLER.py /chemin/PMDO/MODS/mon_mod --dry-run`,
  puis relancer la même commande sans `--dry-run`.

## Calques (bas → haut)

| # | Calque | Animation |
|---|---|---|
| 00 | Sol complet (herbe, aussi sous la jungle et le tertre) | fixe |
| 01 | Herbe praticable de la clairière | fixe |
| 02 | Ombres : l'herbe s'assombrit au pied du tertre | fixe |
| 03 | Dalles de sable du chemin | fixe |
| 04 | Touffes et cailloux | fixe |
| 05 | Fleurs (hibiscus) | fixe |
| 06 | Jungle dense qui ferme la clairière | fixe |
| 07 | Palmiers | fixe |
| 08 | Tertre sacré au nord | fixe |
| 09 | Plateforme de sable au pied du tertre (objectif) | fixe |
| 10 | Rive de terre entre l'herbe et la mer | fixe |
| 11 | Ponton de bois (arrivée) | fixe |
| 12 | Mer : profil, crête et couleurs exacts du rip, sans liseré clair | 24 × 5 ticks |
| 13 | Papillons générés (planche d'ETC1 réutilisée) | 24 × 5 ticks |
| 14 | Vide, `Layer=4` (Top) | — |

La scène complète boucle en 120 ticks (2 s). Tous les calques sont opaques ou transparents, sans
alpha intermédiaire.

## Marqueurs et collisions

- **Marqueurs** : `entrance` est au sud, sur le ponton. `boss` est au centre de la clairière.
  `objectif` est au pied de la plateforme du tertre, au nord. **Aucun warp, aucune sortie, pas de
  `donjon_seuil`** (c'est une fin).
- **Collisions** : seuls l'herbe, les ombres, les dalles, la plateforme, les touffes reliées à la
  clairière et le ponton sont praticables. La jungle, les palmiers, le tertre, la rive et la mer
  sont bloqués. Un chemin libre de 16 × 16 px de l'arrivée au boss et à l'objectif a été vérifié
  sur la grille. **À contrôler en jeu.**

## Limites

- **Terrain** : dessin généré à partir de la capture `large.S01P03A…png` (clairière tropicale).
  Ce ne sont pas des tuiles natives certifiées.
- **Mer** : profil vertical, crête et couleurs relevés pixel par pixel sur la capture ; le filet
  clair que la capture a contre la rive n'est **pas** repris (retour utilisateur sur EWC1).
- **Papillons** : planche générée pour ETC1, réutilisée sans nouvelle génération ; les vols en
  huit sont créés par nous.
- **Tests** : aucun test fait dans PMDO (`runtime_tested: false`, `art_approved: false`).
