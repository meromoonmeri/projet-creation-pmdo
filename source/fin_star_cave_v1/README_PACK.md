# Fin Star Cave — arène de cristal (4:3) — projet PMDO 0.8.12

Ce dossier est un projet d'édition autonome, `fin_star_cave`. Il contient le Ground `fst1_fin_star_cave` au **format 4:3 vaste** : 768 × 576 px, soit 96 × 72 cases de 8 px (`TexSize=1`), environ 2,4 × 2,4 écrans PMDO.

C'est la zone de fin de donjon qui prolonge l'entrée Star Cave (ESC1) : couloir au sud, caverne ronde de cristal, alcôve de cristal au nord. Biome et portée choisis par l'agent pour la suite de la série. Ils restent à confirmer.

## Installer

- **Projet séparé** : copier `fin_star_cave` dans `PMDO/MODS/`, activer le mod, puis ouvrir le Ground.
- **Dans un mod existant** : lancer `python INSTALLER.py /chemin/PMDO/MODS/mon_mod --dry-run`, puis relancer la même commande sans `--dry-run`.

## Calques (bas → haut)

| # | Calque | Animation |
|---|---|---|
| 00 | Sol complet (sol bleu acier avec cratères, aussi sous les parois) | fixe |
| 01 | Sol praticable | fixe |
| 02 | Ombres : le sol s'assombrit contre les parois | fixe |
| 03 | Parois de cristal | fixe |
| 04 | Blocs de cristal posés sur le sol | fixe |
| 05 | Reflets des cristaux (rampe cyan exacte du rip, vague diagonale) | 24 × 5 ticks |
| 06 | Étoiles scintillantes (4 formes et couleurs exactes du rip) | 24 × 5 ticks |
| 07 | Poussière d'étoile : orbes qui montent puis se dispersent (générées) | 24 × 5 ticks |
| 08 | Vide, `Layer=4` (Top) | — |

La scène complète boucle en 120 ticks (2 s). Tous les calques sont opaques ou transparents, sans alpha intermédiaire.

## Marqueurs et collisions

- **Marqueurs** : `entrance` est au sud, au bout du couloir. `boss` est au centre de l'arène. `objectif` est au pied de l'alcôve, au nord. **Aucun warp, aucune sortie.**
- **Collisions** : seul le sol (ombres comprises) est praticable. Les parois et les blocs sont bloqués. Les étoiles et la poussière sont purement visuelles. Un chemin libre de 16 × 16 px de l'arrivée au boss et à l'objectif a été vérifié sur la grille. **À contrôler en jeu.**

## Limites

- **Terrain** : dessin généré à partir de la capture `starcavepmdsky.png`. La poussière d'étoile reprend la planche de ESC1, sans nouvelle génération.
- **Animations** : le scintillement des étoiles, la vague des reflets et la montée des orbes sont créés par nous. Ce ne sont pas des animations officielles.
- **Étoiles et reflets** : pixels posés par programme, avec uniquement des couleurs du rip.
- **Tests** : aucun test fait dans PMDO.
