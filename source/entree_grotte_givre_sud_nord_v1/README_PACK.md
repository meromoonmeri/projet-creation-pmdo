# Entrée Grotte de Givre sud → nord V1 (`EGI1`, format 4:3 vaste — 768 × 576 px)

Entrée du biome **Grotte de Givre** (*Icicle Cavern*, Explorers of Sky) : champ de glace fendue avec **chaussée de glace lisse sud → nord**, croupes de blocs de glace bleu-gris des deux côtés, crête de montagnes enneigées, bande de ciel bleu profond et **arche sombre de roc givré au nord** (seuil du donjon). Appairée à `FGI1`.

- **Dimensions** : `768 × 576 px` (`96 × 72` tuiles de `8 × 8 px`, `TexSize=1`, ratio 4:3 vaste).
- **Préfixe de banques `.tile`** : `EGI1` (`EGI1_00` à `EGI1_05`, plus `06 Top` vide `Layer=4`).
- **Carte Ground** : `Data/Ground/egi1_entree_grotte_givre.rsground`.
- **Référence canonique** : `source/entree_grotte_givre_sud_nord_v1/reference/D53P11B.png` (rip `pret/pmd-sky`, « iceroad » identifié au pixel près, commit épinglé).
- **Provenance** : art généré référencé sur le rip (jamais de tuile native revendiquée) — `art_approved=false`, `runtime_tested=false`.

## Pile de calques (`bas → haut`)

| # | Calque | Contenu | Cadence |
|---|---|---|---|
| `00` | `EGI1_00_sol_complet` | Fond continu : plaine de glace complète, fissures et neige (`100 %` opaque) | Fixe (`60` ticks) |
| `01` | `EGI1_01_vide` | Bande de ciel bleu profond en haut | Fixe (`60` ticks) |
| `02` | `EGI1_02_rochers` | Croupes de blocs de glace et crête de montagnes | Fixe (`60` ticks) |
| `03` | `EGI1_03_crevasses` | Fissures, ombres et retraits sur la glace | Fixe (`60` ticks) |
| `04` | `EGI1_04_arche` | Arche sombre de roc givré (nord, seuil du donjon) | Fixe (`60` ticks) |
| `05` | `EGI1_05_sol` | Glace lisse : plaine et chaussée sud → nord | Fixe (`60` ticks) |
| `06` | `Top` | Vide, `Layer=4` (éléments avant-plan PMDO) | — |

## Marqueurs

- `entrance` : plaine de glace au bord sud (centre).
- `boss_center` : centre de la plaine.
- `seuil_arche` : pied de l'arche (nord), case 2×2 praticable.
