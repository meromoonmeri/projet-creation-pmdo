# Fin Couloir violet — arène fermée (4:3) — projet PMDO 0.8.12

Ce dossier est un projet d'édition autonome, `fin_couloir_violet`. Il contient le Ground
`fvc1_fin_couloir_violet` au **format 4:3 vaste** : 768 × 576 px, soit 96 × 72 cases de 8 px
(`TexSize=1`).

C'est la zone de fin de donjon qui prolonge l'entrée Couloir violet (ECV1) : arrivée par un couloir
étroit au sud, très grande arène ronde de rochers bleu-violet, objectif au pied du mur nord.
Biome et portée choisis par l'agent pour la suite de la série des fins. Ils restent à confirmer.

## Installer

- **Projet séparé** : copier `fin_couloir_violet` dans `PMDO/MODS/`, activer le mod, puis ouvrir
  le Ground.
- **Dans un mod existant** : lancer `python INSTALLER.py /chemin/PMDO/MODS/mon_mod --dry-run`,
  puis relancer la même commande sans `--dry-run`.

## Calques (bas → haut)

| # | Calque | Animation |
|---|---|---|
| 00 | Sol complet (sol mauve, aussi sous les parois) | fixe |
| 01 | Sol praticable | fixe |
| 02 | Ombres : le sol s'assombrit au pied des parois et des blocs | fixe |
| 03 | Gravillons posés sur le sol | fixe |
| 04 | Blocs : amas de rochers dans l'arène | fixe |
| 05 | Rochers (parois) | fixe |
| 06 | Falaise striée sombre | fixe |
| 07 | Vide, hors carte | fixe |
| 08 | Éboulis : gravillons exacts du rip qui tombent, rebondissent, roulent | 24 × 5 ticks |
| 09 | Poussière aux impacts (poses générées, planche d'ECV1 réutilisée) | 24 × 5 ticks |
| 10 | Vide, `Layer=4` (Top) | — |

La scène complète boucle en 120 ticks (2 s). Tous les calques sont opaques ou transparents, sans
alpha intermédiaire.

## Marqueurs et collisions

- **Marqueurs** : `entrance` est au sud, au bout du couloir. `boss` est au centre de l'arène.
  `objectif` est au pied du mur nord. **Aucun warp, aucune sortie, pas de `donjon_seuil`**
  (c'est une fin).
- **Collisions** : seuls le sol, les ombres et les gravillons reliés au sud sont praticables. Les
  blocs, les rochers, la falaise et le vide sont bloqués. Un chemin libre de 16 × 16 px de
  l'arrivée au boss et à l'objectif a été vérifié sur la grille. **À contrôler en jeu.**

## Limites

- **Terrain** : dessin généré à partir de la capture `large.S05P03A…png` (couloir rocheux violet).
  Ce ne sont pas des tuiles natives certifiées.
- **Éboulis** : les trois gravillons sont relevés pixel par pixel sur la capture (couleurs
  exactes) ; chute, rebond et roulement sont créés par nous.
- **Sol complet et poussière** : repris d'ECV1 sans nouvelle génération (même biome).
- **Tests** : aucun test fait dans PMDO (`runtime_tested: false`, `art_approved: false`).
