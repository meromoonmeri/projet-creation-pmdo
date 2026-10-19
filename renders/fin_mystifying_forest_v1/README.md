# Fin Mystifying Forest : clairière de la source (4:3) — projet PMDO 0.8.12

Projet d'édition autonome `fin_mystifying_forest`. Il contient un Ground `fmf3_fin_mystifying_forest` au **format 4:3 vaste** : 768 × 576 px, soit 96 × 72 cases de 8 px (`TexSize=1`), environ 2,4 × 2,4 écrans PMDO.

Cette carte est la **fin de donjon** qui prolonge l'entrée `EMF1` (Mystifying Forest), d'après la capture `Mystifying_Forest_entrance_TDS.png`. Le préfixe est **`FMF3`** (`FMF1` et `FMF2` étant déjà pris sur la branche sœur `01a0eaca`).

## Installer

- **Projet séparé** : copier `fin_mystifying_forest` dans `PMDO/MODS/`, l'activer, puis ouvrir le Ground.
- **Dans un mod existant** : lancer `python INSTALLER.py /chemin/PMDO/MODS/mon_mod --dry-run`, puis relancer sans `--dry-run`.

## Calques (bas → haut)

| # | Calque | Animation |
|---|---|---|
| 00 | Eau de la mare, façon Métano (couleurs Métano exactes, sans liseré clair) | 4 × 10 ticks |
| 01 | Scintillements Métano natifs | 4 × 10 ticks |
| 02 | Sol complet (herbe) | fixe |
| 03 | Herbe de la clairière (praticable) | fixe |
| 04 | Chemin et arène centrale (praticable) | fixe |
| 05 | Herbes hautes et sous-bois | fixe |
| 06 | Rochers moussus | fixe |
| 07 | Arbres : houppiers, troncs, racines | fixe |
| 08 | Stèle moussue au nord de l'arène, devant la mare | fixe |
| 09 | Feuilles qui tombent (poses générées réutilisées d'EMF1) | 48 × 5 ticks |
| 10 | Lucioles (poses générées réutilisées d'EMF1) | 48 × 5 ticks |
| 11 | Vide, `Layer=4` (Top) | — |

La scène complète boucle en 240 ticks (4 s).

## Marqueurs et collisions

- `entrance` est au sud, sur le chemin ; `boss` est au centre de l'arène ; `objectif` est au bout nord du chemin, au pied de la stèle moussue devant la mare. **Aucune sortie, aucun warp.**
- Sont praticables l'herbe de la clairière et le chemin. Un chemin libre de 16 × 16 px relie `entrance`, `boss` et `objectif`. **À contrôler en jeu.**

## Limites

- **Terrain, feuilles et lucioles** : dessins générés à partir de la capture `Mystifying_Forest_entrance_TDS.png`. Les trajectoires, les boucles et la chronologie sont créées par nous ; ce ne sont pas des animations officielles.
- **Eau** : façon Métano, pixels recalculés avec les couleurs Métano exactes.
- **Scintillements** : seuls pixels Métano natifs du pack.
- **Tests** : aucun test fait dans PMDO (`runtime_tested: false`, `art_approved: false`).
