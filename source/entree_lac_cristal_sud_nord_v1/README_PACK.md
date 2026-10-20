# Entrée Lac Cristal (Crystal Lake) — ELC1 (768 × 576, 8 px)

Entrée de donjon sud → nord dans le biome **Lac Cristal / Crystal Lake** (*Pokémon Donjon Mystère : Explorateurs du Temps / de l'Ombre / du Ciel*), construite à partir de la capture canonique `lakecrystalpmdsky.png` (696 × 600 px).

## Calques

| N° | Calque | Cadence |
|---:|---|---|
| 00 | Sol complet reconstruit (témoin sans objets) | fixe |
| 01 | Eau profonde bleu azur du Lac Cristal | fixe |
| 02 | Îlots de cristal détachés flottant sur le lac | fixe |
| 03 | Dalles hexagonales cyan de la chaussée et de l'esplanade | fixe |
| 04 | Cœurs hexagonaux cyan-blanc très lumineux du sol de cristal | fixe |
| 05 | Amas de cristaux taillés bordant la chaussée et l'esplanade | fixe |
| 06 | Colonnes hexagonales de cristal bleu-glace | fixe |
| 07 | Arche et colonnes de cristal encadrant le seuil nord | fixe |
| 08 | Reflets et ondulation des caustiques bleu azur sur l'eau (sans liseré clair en berge) | 24 × 5 ticks |
| 09 | Anneaux hexagonaux de lumière cyan sur les dalles (`cristal_eclats_poses.png`) | 24 × 5 ticks |
| 10 | Étoiles cristallines et prismes de glace (`cristal_eclats_poses.png`) | 24 × 5 ticks |
| 11 | Vide, `Layer=4` (Top) | — |

La scène complète boucle en 120 ticks (2 s). Tous les calques sont opaques ou transparents, sans alpha intermédiaire.

## Marqueurs et collisions

- **Marqueurs** : `entrance` au sud sur la chaussée de cristal ; `donjon_seuil` au nord sous l'arche de cristal. **Aucun warp.**
- **Collisions** : les dalles hexagonales (`dalles_cristal` et `dalles_claires`) sont praticables. L'eau du lac, les îlots, les amas de cristaux, les colonnes hexagonales et les montants de l'arche nord sont bloqués. Un chemin libre de 16 × 16 px a été vérifié sur la grille (`entrance` → `donjon_seuil`). **À contrôler en jeu.**

## Limites

- **Eau, dalles de cristal, colonnes, amas de cristaux, arche et poses d'éclats/anneaux** : dessins générés à partir de la capture `lakecrystalpmdsky.png` (`cristal_eclats_poses.png` sur fond magenta pur `#FF00FF`). Ce ne sont pas des tuiles natives.
- **Animations** : les caustiques d'eau, anneaux hexagonaux et étoiles/prismes sont animés par programme à partir des poses générées sur fond magenta. Ce ne sont pas des animations officielles.
- **Moteur PMDO** : `runtime_tested: false`, `art_approved: false`.
