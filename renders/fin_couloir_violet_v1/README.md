# Fin Couloir violet (4:3) — projet PMDO 0.8.12

Ce dossier est un projet d'édition autonome, `fin_couloir_violet`. Il contient le Ground `fcv5_fin_couloir_violet` au **format 4:3 vaste** : 768 × 576 px, soit 96 × 72 cases de 8 px (`TexSize=1`), environ 2,4 × 2,4 écrans PMDO.

Cette salle de fin prolonge l'entrée `ECV1` (`entree_couloir_violet_sud_nord`, réf. `large.S05P03A…png` : couloir rocheux violet, sol mauve marbré, rochers empilés bleu-violet, falaises striées sombres, gravillons).

## Installer

- **Projet séparé** : copier `fin_couloir_violet` dans `PMDO/MODS/`, activer le mod, puis ouvrir le Ground.
- **Dans un mod existant** : lancer `python INSTALLER.py /chemin/PMDO/MODS/mon_mod --dry-run`, puis relancer la même commande sans `--dry-run`.

## Calques (bas → haut)

| # | Calque | Animation |
|---|---|---|
| 00 | Sol complet (sol mauve, aussi sous tout le reste) | fixe |
| 01 | Sol mauve de l'arène et du couloir d'arrivée | fixe |
| 02 | Ombres : le sol s'assombrit au pied des parois, de l'autel et des blocs | fixe |
| 03 | Gravillons (petits cailloux au sol, praticables) | fixe |
| 04 | Blocs : 6 amas de rochers posés dans l'arène | fixe |
| 05 | Autel : monolithe rocheux à degrés au fond nord de la salle | fixe |
| 06 | Rochers : parois de rochers empilés refermant la caverne | fixe |
| 07 | Falaise striée du fond | fixe |
| 08 | Vide : noir hors carte | fixe |
| 09 | Éboulis : gravillons de la capture qui tombent du pied des parois, rebondissent et roulent | 24 × 5 ticks |
| 10 | Poussière (générée) : un nuage à chaque impact | 24 × 5 ticks |
| 11 | Vide, `Layer=4` (Top) | — |

La scène complète boucle en 120 ticks (2 s). Tous les calques sont opaques ou transparents, sans alpha intermédiaire.

## Marqueurs et collisions (fin de donjon sans sortie)

- **Marqueurs** : `entrance` est au sud, dans le couloir d'arrivée. `boss` est au centre de l'arène. `objectif` est au nord, devant les degrés de l'autel rocheux. **Aucune sortie, aucun warp, aucun marqueur `donjon_seuil`.**
- **Collisions** : le sol, les ombres et les gravillons reliés au couloir sud sont praticables. Les blocs, l'autel rocheux, les rochers, la falaise et le vide sont bloqués ; les bords nord, ouest et est sont entièrement fermés. Les éboulis et la poussière sont purement visuels. Un chemin libre de 16 × 16 px relie `entrance` → `boss` → `objectif`. **À contrôler en jeu.**

## Limites

- **Terrain et poussière** : ce sont des dessins générés à partir de la capture (`sol_complet` et `poussiere_poses` partagés avec `ECV1`).
- **Gravillons des éboulis** : pixels et couleurs exacts de la capture ; la chute, le rebond et le roulement sont créés par nous.
- **Animations** : ce ne sont pas des animations officielles.
- **Tests** : aucun test fait dans PMDO.
