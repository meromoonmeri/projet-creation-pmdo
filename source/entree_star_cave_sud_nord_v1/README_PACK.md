# Entrée Star Cave sud → nord (4:3) — projet PMDO 0.8.12

Ce dossier est un projet d'édition autonome, `entree_star_cave_sud_nord`. Il contient le Ground `esc1_entree_star_cave` au **format 4:3 vaste** : 768 × 576 px, soit 96 × 72 cases de 8 px (`TexSize=1`), environ 2,4 × 2,4 écrans PMDO.

Le biome (grotte de cristaux étoilée, d'après la capture Star Cave) a été choisi par l'agent pour la suite de la série. Il reste à confirmer.

## Installer

- **Projet séparé** : copier `entree_star_cave_sud_nord` dans `PMDO/MODS/`, activer le mod, puis ouvrir le Ground.
- **Dans un mod existant** : lancer `python INSTALLER.py /chemin/PMDO/MODS/mon_mod --dry-run`, puis relancer la même commande sans `--dry-run`.

## Calques (bas → haut)

| # | Calque | Animation |
|---|---|---|
| 00 | Sol complet (sol bleu acier avec cratères, aussi sous les parois) | fixe |
| 01 | Sol praticable | fixe |
| 02 | Ombres : le sol s'assombrit contre les parois et jusque dans la bouche | fixe |
| 03 | Parois de cristal | fixe |
| 04 | Blocs de cristal posés sur le sol | fixe |
| 05 | Profondeur : entrée sombre au nord | fixe |
| 06 | Reflets des cristaux (rampe cyan exacte du rip, vague diagonale) | 24 × 5 ticks |
| 07 | Étoiles scintillantes (4 formes et couleurs exactes du rip) | 24 × 5 ticks |
| 08 | Poussière d'étoile : orbes qui montent puis se dispersent (générées) | 24 × 5 ticks |
| 09 | Vide, `Layer=4` (Top) | — |

La scène complète boucle en 120 ticks (2 s). Tous les calques sont opaques ou transparents, sans alpha intermédiaire.

## Marqueurs et collisions

- **Marqueurs** : `entrance` est au sud, au bout du couloir. `donjon_seuil` est juste sous l'entrée sombre. **Aucun warp.**
- **Collisions** : seul le sol (ombres comprises) est praticable. Les parois, les blocs et la bouche sont bloqués. Les étoiles et la poussière sont purement visuelles. Un chemin libre de 16 × 16 px a été vérifié sur la grille. **À contrôler en jeu.**

## Limites

- **Terrain et poussière d'étoile** : ce sont des dessins générés à partir de la capture `starcavepmdsky.png`.
- **Animations** : le scintillement des étoiles, la vague des reflets et la montée des orbes sont créés par nous. Ce ne sont pas des animations officielles.
- **Étoiles et reflets** : pixels posés par programme, avec uniquement des couleurs du rip.
- **Tests** : aucun test fait dans PMDO.
