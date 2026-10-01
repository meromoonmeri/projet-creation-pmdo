# Entrée Sables mouvants sud → nord (4:3) — projet PMDO 0.8.12

Ce dossier est un projet d'édition autonome, `entree_sables_mouvants_sud_nord`. Il contient le Ground `eqs1_entree_sables_mouvants` au **format 4:3 vaste** : 768 × 576 px, soit 96 × 72 cases de 8 px (`TexSize=1`), environ 2,4 × 2,4 écrans PMDO.

Le biome (désert aux sables mouvants) a été choisi par l'agent pour la suite de la série. Il reste à confirmer.

## Installer

- **Projet séparé** : copier `entree_sables_mouvants_sud_nord` dans `PMDO/MODS/`, activer le mod, puis ouvrir le Ground.
- **Dans un mod existant** : lancer `python INSTALLER.py /chemin/PMDO/MODS/mon_mod --dry-run`, puis relancer la même commande sans `--dry-run`.

## Calques (bas → haut)

| # | Calque | Animation |
|---|---|---|
| 00 | Fosse de sable mouvant (4 couleurs exactes du rip ; les anneaux s'enfoncent, les lobes tournent) | 12 × 10 ticks |
| 01 | Sol complet (sable avec ses stries) | fixe |
| 02 | Sable praticable | fixe |
| 03 | Ombres au pied des roches (sable assombri du rendu) | fixe |
| 04 | Bord de la fosse (lèvre sombre) | fixe |
| 05 | Roches en strates | fixe |
| 06 | Pierres dressées | fixe |
| 07 | Profondeur : entrée sombre au nord | fixe |
| 08 | Chutes de sable (chevrons aux 4 couleurs exactes du rip) | 24 × 5 ticks |
| 09 | Poussière au pied des chutes et tourbillons de grains (générés) | 24 × 5 ticks |
| 10 | Rayons de soleil, overlay translucide (alpha 16 à 80 sur 255) | 12 × 10 ticks |
| 11 | Vide, `Layer=4` (Top) | — |

La scène complète boucle en 120 ticks (2 s). Le calque 10 est le seul à alpha intermédiaire : on peut le masquer sans rien perdre du terrain.

## Marqueurs et collisions

- **Marqueurs** : `entrance` est au sud, sur le sable. `donjon_seuil` est juste sous l'entrée sombre, entre les deux chutes. **Aucun warp.**
- **Collisions** : seul le sable (ombres comprises) est praticable. La fosse et son bord, les roches, les pierres, les chutes et la bouche sont bloqués. Un chemin libre de 16 × 16 px a été vérifié sur la grille. **À contrôler en jeu.**

## Limites

- **Terrain, poussière et tourbillons** : ce sont des dessins générés à partir de la capture `witheringdesert.png`.
- **Animations** : l'aspiration de la fosse, le défilement des chutes, la chronologie de la poussière et la respiration des rayons sont créés par nous. Ce ne sont pas des animations officielles.
- **Fosse et chutes** : pixels recalculés, avec uniquement des couleurs du rip.
- **Rayons** : sur le rip, l'éclaircissement est additif. PMDO mélange en alpha, donc c'est une approximation (couleur du rip, alpha mesuré).
- **Tests** : aucun test fait dans PMDO.
