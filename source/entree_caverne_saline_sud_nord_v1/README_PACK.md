# Entrée Caverne Saline sud → nord V1 (`EBC1`, format 4:3 vaste — 768 × 576 px)

Première carte du biome **Caverne Saline** (*Brine Cave*, Explorers of Sky), couloir d'entrée **sud vers nord** bordé de calcaire brun-rouge strié, de crêtes en saillie et de flaques turquoise d'eau de saumure, menant à la salle du boss (carte appairée `FBC1`).

- **Dimensions** : `768 × 576 px` (`96 × 72` tuiles de `8 × 8 px`, `TexSize=1`, ratio 4:3 vaste).
- **Préfixe de banques `.tile`** : `EBC1` (`EBC1_00` à `EBC1_06`, plus `07 Top` vide `Layer=4`).
- **Carte Ground** : `Data/Ground/ebc1_entree_caverne_saline.rsground`.
- **Référence canonique** : `source/entree_caverne_saline_sud_nord_v1/reference/D26P31A.png` (rip `pret/pmd-sky`, commit épinglé).
- **Provenance** : art généré référencé sur le rip (jamais de tuile native revendiquée) — `art_approved=false`, `runtime_tested=false`.

## Pile de calques (`bas → haut`)

| # | Calque | Contenu | Cadence |
|---|---|---|---|
| `00` | `EBC1_00_sol_complet` | Fond continu : sol sablonneux rose-brun, bordure de pierre sombre (`100 %` opaque) | Fixe (`60` ticks) |
| `01` | `EBC1_01_vide` | Marge sombre hors carte | Fixe (`60` ticks) |
| `02` | `EBC1_02_parois` | Calcaire brun-rouge strié des deux côtés | Fixe (`60` ticks) |
| `03` | `EBC1_03_rochers` | Crêtes claires en saillie (resserrement du couloir) | Fixe (`60` ticks) |
| `04` | `EBC1_04_sol` | Couloir sablonneux du sud au nord | Fixe (`60` ticks) |
| `05` | `EBC1_05_ombres` | Sol assombri au pied des parois et des flaques | Fixe (`60` ticks) |
| `06` | `EBC1_06_eau` | Flaques turquoise d'eau de saumure | Fixe (`60` ticks) |
| `07` | `Top` | Vide, `Layer=4` (éléments avant-plan PMDO) | — |

## Marqueurs

- `entrance` : arrivée au bord sud (centre du couloir).
- `boss_center` : milieu du couloir.
- `donjon_seuil` : sortie nord (haut du couloir), case 2×2 praticable.
