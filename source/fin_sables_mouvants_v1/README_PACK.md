# Fin Sables mouvants (4:3) — projet PMDO 0.8.12

Ce dossier est un projet d'édition autonome, `fin_sables_mouvants`. Il contient le Ground `fsm1_fin_sables_mouvants` au **format 4:3 vaste** : 768 × 576 px, soit 96 × 72 cases de 8 px (`TexSize=1`), environ 2,4 × 2,4 écrans PMDO.

C'est la zone de fin du désert, dans la suite de l'entrée Sables mouvants (EQS1). Biome et portée choisis par l'agent, à confirmer.

## Installer

- **Projet séparé** : copier `fin_sables_mouvants` dans `PMDO/MODS/`, activer le mod, puis ouvrir le Ground.
- **Dans un mod existant** : lancer `python INSTALLER.py /chemin/PMDO/MODS/mon_mod --dry-run`, puis relancer la même commande sans `--dry-run`.

## Calques (bas → haut)

| # | Calque | Animation |
|---|---|---|
| 00 | Fosse de sable mouvant (4 couleurs exactes du rip ; les anneaux s'enfoncent, les lobes tournent) | 12 × 10 ticks |
| 01 | Sol complet (sable avec ses stries) | fixe |
| 02 | Sable praticable | fixe |
| 03 | Ombres au pied des roches (sable assombri du rendu) | fixe |
| 04 | Bord de la fosse (lèvre sombre) | fixe |
| 05 | Roches en strates, estrade de pierre au nord comprise | fixe |
| 06 | Pierres dressées | fixe |
| 07 | Chutes de sable (chevrons aux couleurs exactes du rip) | 24 × 5 ticks |
| 08 | Poussière au pied des chutes et tourbillons de grains (générés) | 24 × 5 ticks |
| 09 | Vide, `Layer=4` (Top) | — |

La scène complète boucle en 120 ticks (2 s). Aucun calque translucide : l'arène est fermée par des falaises, sans ciel ni rayons.

## Marqueurs et collisions

- **Marqueurs** : `entrance` au sud, sur le sable ; `boss` sur le sable au sud de la fosse ; `objectif` au pied de l'estrade, entre les deux chutes. **Aucune sortie, aucun warp, pas de `donjon_seuil`.**
- **Collisions** : seul le sable (ombres comprises) est praticable. La fosse et son bord, les roches, les pierres et les chutes sont bloqués ; la bande nord est une paroi. Des chemins libres de 16 × 16 px de l'arrivée au boss et à l'objectif ont été vérifiés sur la grille. **À contrôler en jeu.**

## Limites

- **Terrain, poussière et tourbillons** : dessins générés à partir de la capture `witheringdesert.png` (Furnace Desert). Ce ne sont pas des tuiles natives.
- **Animations** : l'aspiration de la fosse, le défilement des chutes et la chronologie de la poussière sont créés par nous, avec les lois et les couleurs de l'entrée EQS1. Ce ne sont pas des animations officielles.
- **Boss** : aucun boss n'est nommé ni placé ; `boss` est seulement un marqueur d'emplacement.
- **Tests** : aucun test fait dans PMDO.
