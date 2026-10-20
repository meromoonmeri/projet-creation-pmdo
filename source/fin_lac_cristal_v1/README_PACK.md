# Fin Lac Cristal (Crystal Lake) — FLC1 (768 × 576, 8 px)

Salle de fin de donjon (boss / objectif) dans le biome **Lac Cristal / Crystal Lake** (*Pokémon Donjon Mystère : Explorateurs du Temps / de l'Ombre / du Ciel*), construite à partir de la capture canonique `lakecrystalpmdsky.png` (696 × 600 px).

## Calques

| N° | Calque | Cadence |
|---:|---|---|
| 00 | Sol complet reconstruit (témoin sans objets) | fixe |
| 01 | Eau profonde bleu azur du Lac Cristal | fixe |
| 02 | Îlots de cristal détachés flottant sur le lac | fixe |
| 03 | Dalles hexagonales cyan de la chaussée et de la péninsule | fixe |
| 04 | Cœurs hexagonaux cyan-blanc très lumineux du sol de cristal | fixe |
| 05 | Amas de cristaux taillés bordant la chaussée et la péninsule | fixe |
| 06 | Couronne nord de colonnes hexagonales de cristal bleu-glace | fixe |
| 07 | Autel de Cristal hexagonal à degrés et Prisme Souverain au nord-centre | fixe |
| 08 | Reflets et ondulation des caustiques bleu azur sur l'eau (sans liseré clair en berge) | 24 × 5 ticks |
| 09 | Anneaux hexagonaux de lumière cyan autour de l'autel et sur la péninsule (`cristal_eclats_poses.png`) | 24 × 5 ticks |
| 10 | Étoiles cristallines et prismes de glace (`cristal_eclats_poses.png`) | 24 × 5 ticks |
| 11 | Vide, `Layer=4` (Top) | — |

La scène complète boucle en 120 ticks (2 s). Tous les calques sont opaques ou transparents, sans alpha intermédiaire.

## Marqueurs et collisions

- **Marqueurs** : `entrance` au sud sur la chaussée de cristal ; `boss` au centre de la péninsule ; `objectif` au nord au pied de l'Autel de Cristal et du Prisme Souverain. **Aucune sortie, aucun `donjon_seuil`, aucun warp.**
- **Collisions** : les dalles hexagonales (`dalles_cristal` et `dalles_claires`) sont praticables. L'eau du lac, les îlots, les amas de cristaux, la couronne de colonnes hexagonales et l'Autel de Cristal sont bloqués. Un chemin libre de 16 × 16 px a été vérifié sur la grille (`entrance` → `boss` → `objectif`). **À contrôler en jeu.**

## Limites

- **Eau, dalles de cristal, colonnes, amas de cristaux, autel et poses d'éclats/anneaux** : dessins générés à partir de la capture `lakecrystalpmdsky.png` (`cristal_eclats_poses.png` sur fond magenta pur `#FF00FF`). Ce ne sont pas des tuiles natives.
- **Animations** : les caustiques d'eau, anneaux hexagonaux et étoiles/prismes sont animés par programme à partir des poses générées sur fond magenta. Ce ne sont pas des animations officielles.
- **Moteur PMDO** : `runtime_tested: false`, `art_approved: false`.
