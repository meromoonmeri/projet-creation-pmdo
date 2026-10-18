# Fin Grotte Étoile — Sanctuaire de Jirachi V1 (`FGE1`, format 4:3 vaste — 768 × 576 px)

Deuxième carte du biome **Grotte Étoile** (*Star Cave*, épisode spécial 1 — *Le Vœu de Keunotor*, Explorers of Sky), appairée à `EGE1` : salle circulaire de **cristal saphir profond** aux hautes lumières ice-bleu/vert-glacé, plancher bleu ciel lumineux, et au centre de la salle l'**emblème en étoile à 5 branches lumineux de Jirachi** (halo doux, sans trait néon).

- **Dimensions** : `768 × 576 px` (`96 × 72` tuiles de `8 × 8 px`, `TexSize=1`, ratio 4:3 vaste).
- **Préfixe de banques `.tile`** : `FGE1` (`FGE1_00` à `FGE1_05`, plus `06 Top` vide `Layer=4`).
- **Carte Ground** : `Data/Ground/fge1_fin_grotte_etoile.rsground`.
- **Référence canonique** : `source/fin_grotte_etoile_sanctuaire_v1/reference/D42P42A.png` (rip `pret/pmd-sky`, salle du vœu de Jirachi, commit épinglé).
- **Provenance** : art généré référencé sur le rip (jamais de tuile native revendiquée) — `art_approved=false`, `runtime_tested=false`.

## Pile de calques (`bas → haut`)

| # | Calque | Contenu | Cadence |
|---|---|---|---|
| `00` | `FGE1_00_sol_complet` | Fond continu : plancher bleu ciel pierre, fissures discrètes (`100 %` opaque) | Fixe (`60` ticks) |
| `01` | `FGE1_01_vide` | Marge sombre hors carte (void marine) | Fixe (`60` ticks) |
| `02` | `FGE1_02_parois_sombres` | Roc saphir profond de la voûte circulaire | Fixe (`60` ticks) |
| `03` | `FGE1_03_cristaux` | Hautes lumières cristallines ice-bleu/vert-glacé | Fixe (`60` ticks) |
| `04` | `FGE1_04_sol` | Plancher bleu ciel de la salle + passage sud | Fixe (`60` ticks) |
| `05` | `FGE1_05_etoile` | Emblème en étoile à 5 branches lumineux de Jirachi (centre) | Fixe (`60` ticks) |
| `06` | `Top` | Vide, `Layer=4` (éléments avant-plan PMDO) | — |

## Marqueurs

- `entrance` : passage au bord sud (centre).
- `boss_center` : centre de l'emblème étoilé.
- `autel_jirachi` : case praticable la plus au nord de l'axe central (derrière l'étoile).
