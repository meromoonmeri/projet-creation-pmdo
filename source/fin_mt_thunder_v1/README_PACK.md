# Fin Mt. Thunder — arène du sommet (4:3) — projet PMDO 0.8.12

Ce dossier est un projet d'édition autonome, `fin_mt_thunder`. Il contient le Ground
`fth1_fin_mt_thunder` au **format 4:3 vaste** : 768 × 576 px, soit 96 × 72 cases de 8 px
(`TexSize=1`).

C'est la zone de fin de donjon qui prolonge l'entrée Mt. Thunder (EMT1) : arrivée par une crête de
sable qui sort des nuages au sud, immense plateau sommital (l'arène), piton rocheux fermé au nord.
Biome et portée choisis par l'agent pour la suite de la série des fins. Ils restent à confirmer.

## Installer

- **Projet séparé** : copier `fin_mt_thunder` dans `PMDO/MODS/`, activer le mod, puis ouvrir le
  Ground.
- **Dans un mod existant** : lancer `python INSTALLER.py /chemin/PMDO/MODS/mon_mod --dry-run`,
  puis relancer la même commande sans `--dry-run`.

## Calques (bas → haut)

| # | Calque | Animation |
|---|---|---|
| 00 | Sol complet (sable, aussi sous les roches et les nuages) | fixe |
| 01 | Sable praticable du plateau et de la crête | fixe |
| 02 | Cailloux posés sur le sable | fixe |
| 03 | Pics de roche | fixe |
| 04 | Falaise : bords et gradins du plateau | fixe |
| 05 | Piton rocheux au nord (fermé, sans grotte) | fixe |
| 06 | Ciel d'orage sombre | fixe |
| 07 | Mer de nuages autour du plateau | fixe |
| 08 | Lueurs : l'arc « Flash » du rip s'allume au pied des éclairs | 48 × 5 ticks |
| 09 | Éclairs : sprites et couleurs Normal / Fading exacts du rip | 48 × 5 ticks |
| 10 | Vide, `Layer=4` (Top) | — |

La scène complète boucle en 240 ticks (4 s). Tous les calques sont opaques ou transparents, sans
alpha intermédiaire.

## Marqueurs et collisions

- **Marqueurs** : `entrance` est au sud, sur la crête. `boss` est au centre du plateau.
  `objectif` est au pied du piton, au nord. **Aucun warp, aucune sortie, pas de `donjon_seuil`**
  (c'est une fin).
- **Collisions** : seuls le sable et les cailloux reliés au sud sont praticables. Les pics, la
  falaise, le piton, le ciel et les nuages sont bloqués. Un chemin libre de 16 × 16 px de
  l'arrivée au boss et à l'objectif a été vérifié sur la grille. **À contrôler en jeu.**

## Limites

- **Terrain** : dessin généré à partir de la planche `Mt. Thunder` (salle du boss, Red Rescue
  Team). Ce ne sont pas des tuiles natives certifiées.
- **Éclairs** : sprites et couleurs relevés pixel par pixel sur la planche du rip (y compris
  l'arc « Flash ») ; placement et cadence sont créés par nous. L'éclair 3 touche le bas de la
  planche du rip : il est peut-être tronqué à la source.
- **Sol complet** : repris d'EMT1 sans nouvelle génération (même biome).
- **Tests** : aucun test fait dans PMDO (`runtime_tested: false`, `art_approved: false`).
