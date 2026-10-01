# Entrée Couloir violet sud → nord (4:3) — projet PMDO 0.8.12

Ce dossier est un projet d'édition autonome, `entree_couloir_violet_sud_nord`. Il contient le Ground `ecv1_entree_couloir_violet` au **format 4:3 vaste** : 768 × 576 px, soit 96 × 72 cases de 8 px (`TexSize=1`), environ 2,4 × 2,4 écrans PMDO.

Le biome (couloir rocheux violet qui s'ouvre sur une grande salle, d'après la capture `large.S05P03A…png`) a été choisi par l'agent pour la suite de la série. Il reste à confirmer.

## Installer

- **Projet séparé** : copier `entree_couloir_violet_sud_nord` dans `PMDO/MODS/`, activer le mod, puis ouvrir le Ground.
- **Dans un mod existant** : lancer `python INSTALLER.py /chemin/PMDO/MODS/mon_mod --dry-run`, puis relancer la même commande sans `--dry-run`.

## Calques (bas → haut)

| # | Calque | Animation |
|---|---|---|
| 00 | Sol complet (sol mauve, aussi sous tout le reste) | fixe |
| 01 | Sol mauve de la salle et du couloir | fixe |
| 02 | Ombres : le sol s'assombrit au pied des parois et des blocs | fixe |
| 03 | Gravillons (petits cailloux au sol, praticables) | fixe |
| 04 | Blocs : amas de rochers posés dans la salle | fixe |
| 05 | Rochers : parois de rochers empilés, arche du tunnel | fixe |
| 06 | Falaise striée du fond | fixe |
| 07 | Vide : noir hors carte | fixe |
| 08 | Profondeur : tunnel sombre au nord | fixe |
| 09 | Éboulis : gravillons de la capture qui tombent du pied des parois, rebondissent et roulent | 24 × 5 ticks |
| 10 | Poussière (générée) : un nuage à chaque impact | 24 × 5 ticks |
| 11 | Vide, `Layer=4` (Top) | — |

La scène complète boucle en 120 ticks (2 s). Tous les calques sont opaques ou transparents, sans alpha intermédiaire.

## Marqueurs et collisions

- **Marqueurs** : `entrance` est au sud, dans le couloir d'arrivée. `donjon_seuil` est juste sous le tunnel. **Aucun warp.**
- **Collisions** : le sol, les ombres et les gravillons reliés au couloir sud sont praticables. Les blocs, les rochers, la falaise, le vide et le tunnel sont bloqués. Les éboulis et la poussière sont purement visuels. Un chemin libre de 16 × 16 px a été vérifié sur la grille. **À contrôler en jeu.**

## Limites

- **Terrain et poussière** : ce sont des dessins générés à partir de la capture.
- **Gravillons des éboulis** : pixels et couleurs exacts de la capture ; la chute, le rebond et le roulement sont créés par nous.
- **Animations** : ce ne sont pas des animations officielles.
- **Tests** : aucun test fait dans PMDO.
