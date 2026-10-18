# Fin Caverne Saline — Sanctuaire des Reliques V1 (`FBC1`, format 4:3 vaste — 768 × 576 px)

Deuxième carte du biome **Caverne Saline** (*Brine Cave*, Explorers of Sky), appairée à `EBC1` : vaste **arène centrale sablonneuse** (boss) bordée de calcaire brun-rouge strié, de crêtes et de flaques turquoise d'eau de saumure, avec **brèche sud d'arrivée** et **passage nord resserré** vers le reliquaire.

- **Dimensions** : `768 × 576 px` (`96 × 72` tuiles de `8 × 8 px`, `TexSize=1`, ratio 4:3 vaste).
- **Préfixe de banques `.tile`** : `FBC1` (`FBC1_00` à `FBC1_06`, plus `07 Top` vide `Layer=4`).
- **Carte Ground** : `Data/Ground/fbc1_fin_caverne_saline.rsground`.
- **Référence canonique** : `source/fin_caverne_saline_sanctuaire_v1/reference/D26P43A.png` (rip `pret/pmd-sky`, commit épinglé).
- **Provenance** : art généré référencé sur le rip (jamais de tuile native revendiquée) — `art_approved=false`, `runtime_tested=false`.

## Pile de calques (`bas → haut`)

| # | Calque | Contenu | Cadence |
|---|---|---|---|
| `00` | `FBC1_00_sol_complet` | Fond continu : sol sablonneux rose-brun, bordure de pierre sombre (`100 %` opaque) | Fixe (`60` ticks) |
| `01` | `FBC1_01_vide` | Marge sombre hors carte | Fixe (`60` ticks) |
| `02` | `FBC1_02_parois` | Calcaire brun-rouge strié entourant l'arène | Fixe (`60` ticks) |
| `03` | `FBC1_03_rochers` | Crêtes claires et blocs en saillie | Fixe (`60` ticks) |
| `04` | `FBC1_04_sol` | Arène centrale + passage nord + brèche sud | Fixe (`60` ticks) |
| `05` | `FBC1_05_ombres` | Sol assombri au pied des parois et des flaques | Fixe (`60` ticks) |
| `06` | `FBC1_06_eau` | Flaques turquoise d'eau de saumure | Fixe (`60` ticks) |
| `07` | `Top` | Vide, `Layer=4` (éléments avant-plan PMDO) | — |

## Marqueurs

- `entrance` : brèche d'arrivée au bord sud (centre).
- `boss_center` : centre de l'arène.
- `reliquaire` : passage nord (objectif), case 2×2 praticable au plus haut du sol.
