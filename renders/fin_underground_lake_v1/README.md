# Fin Underground Lake : rive du lac souterrain (4:3) — projet PMDO 0.8.12

Ce dossier est un projet d'édition autonome, `fin_underground_lake`. Il contient le Ground `ful2_fin_underground_lake` au **format 4:3 vaste** : 768 × 576 px, soit 96 × 72 cases de 8 px (`TexSize=1`), environ 2,4 × 2,4 écrans PMDO.

Cette carte est la **fin de donjon** qui prolonge l'entrée `EUL1` (Underground Lake), d'après la capture `Underground_Lake_shore_TDS.png` (rive finale du lac souterrain dans *PMD Explorers*). Le préfixe est **`FUL2`** (`FUL1` étant déjà pris sur les branches sœurs `01a0ea8f` et `01a0eaca`).

## Installer

- **Projet séparé** : copier `fin_underground_lake` dans `PMDO/MODS/`, activer le mod, puis ouvrir le Ground.
- **Dans un mod existant** : lancer `python INSTALLER.py /chemin/PMDO/MODS/mon_mod --dry-run`, puis relancer la même commande sans `--dry-run`.

## Calques (bas → haut)

| # | Calque | Animation |
|---|---|---|
| 00 | Eau du lac, façon Métano (couleurs exactes du rip, sans liseré clair) | 4 × 10 ticks |
| 01 | Lueur du lac (9 couleurs exactes du rip ; les anneaux respirent entre les deux piliers) | 12 × 10 ticks |
| 02 | Scintillements Métano natifs (sur le cœur de la lueur) | 4 × 10 ticks |
| 03 | Gouttes qui tombent du plafond et ronds dans l'eau (poses générées réutilisées d'EUL1) | 24 × 5 ticks |
| 04 | Sol complet (sable ; les parois du brut restent dessous) | fixe |
| 05 | Sable praticable : couloir d'arrivée et promontoire d'arène | fixe |
| 06 | Ombres au pied des parois (sable assombri du rendu) | fixe |
| 07 | Berge : rebord entre le lac et le sable | fixe |
| 08 | Parois rocheuses | fixe |
| 09 | Piliers et stalagmites dressés dans le lac | fixe |
| 10 | Vide, `Layer=4` (Top) | — |

La scène complète boucle en 120 ticks (2 s).

## Marqueurs et collisions

- **Marqueurs** : `entrance` est au sud, sur le couloir de sable ; `boss` est au centre du promontoire de sable ; `objectif` est au bord nord de la rive, face à la lueur du lac souterrain entre les deux grands piliers. **Aucune sortie, aucun warp.**
- **Collisions** : seul le sable (ombres comprises) est praticable ; le lac, la berge, les parois et les piliers/stalagmites sont bloqués, ainsi que les bords nord, gauche et droit. Un chemin libre de 16 × 16 px relie `entrance`, `boss` et `objectif`. **À contrôler en jeu.**

## Limites

- **Terrain et gouttes** : ce sont des dessins générés à partir de la capture `Underground_Lake_shore_TDS.png`.
- **Animations** : la chute, les ronds, la respiration de la lueur et leur chronologie sont créées par nous. Ce ne sont pas des animations officielles.
- **Eau et lueur** : pixels recalculés, avec uniquement des couleurs du rip.
- **Scintillements** : pixels Métano natifs du pack, sans modification.
- **Tests** : aucun test fait dans PMDO (`runtime_tested: false`, `art_approved: false`).
