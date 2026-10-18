# Entrée Grotte Étoile sud → nord V1 (`EGE1`, format 4:3 vaste — 768 × 576 px)

Première carte du biome **Grotte Étoile** (*Star Cave*, épisode spécial 1 — *Le Vœu de Keunotor*, Explorers of Sky) : salle ovale de **cristal saphir scintillant** (sparkles 4 branches), plancher bleu lisse à anneaux de cratères, **passage sud d'arrivée** et **bouche de tunnel sombre voûtée au nord** (seuil du donjon). Appairée à `FGE1`.

- **Dimensions** : `768 × 576 px` (`96 × 72` tuiles de `8 × 8 px`, `TexSize=1`, ratio 4:3 vaste).
- **Préfixe de banques `.tile`** : `EGE1` (`EGE1_00` à `EGE1_05`, plus `06 Top` vide `Layer=4`).
- **Carte Ground** : `Data/Ground/ege1_entree_grotte_etoile.rsground`.
- **Référence canonique** : `source/entree_grotte_etoile_sud_nord_v1/reference/D42P31A.png` (rip `pret/pmd-sky`, moitié droite de la salle d'entrée, commit épinglé).
- **Provenance** : art généré référencé sur le rip (jamais de tuile native revendiquée) — `art_approved=false`, `runtime_tested=false`.

## Pile de calques (`bas → haut`)

| # | Calque | Contenu | Cadence |
|---|---|---|---|
| `00` | `EGE1_00_sol_complet` | Fond continu : plancher bleu pierre, fissures et anneaux discrets (`100 %` opaque) | Fixe (`60` ticks) |
| `01` | `EGE1_01_vide` | Marge sombre hors carte (void ardoise) | Fixe (`60` ticks) |
| `02` | `EGE1_02_parois_sombres` | Roc saphir profond de la voûte ovale | Fixe (`60` ticks) |
| `03` | `EGE1_03_cristaux` | Hautes lumières cristallines ice-bleu et sparkles | Fixe (`60` ticks) |
| `04` | `EGE1_04_tunnel` | Bouche de tunnel sombre voûtée (nord) | Fixe (`60` ticks) |
| `05` | `EGE1_05_sol` | Plancher bleu de la salle + passage sud | Fixe (`60` ticks) |
| `06` | `Top` | Vide, `Layer=4` (éléments avant-plan PMDO) | — |

## Marqueurs

- `entrance` : passage au bord sud (centre).
- `boss_center` : centre de la salle ovale.
- `seuil_tunnel` : pied de la bouche de tunnel (nord), case 2×2 praticable.
