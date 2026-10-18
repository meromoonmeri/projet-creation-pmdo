# Fin Grotte de Givre — Sanctuaire de la Glacière V1 (`FGI1`, format 4:3 vaste — 768 × 576 px)

Fin de donjon du biome **Grotte de Givre** (*Icicle Cavern*, Explorers of Sky) : **sommet glaciaire** aux strates en gradins, **plateau sommital de glace claire** parsemé de blocs de glace, fissures et cristaux, silhouettes de montagnes luminieuses en fond, et **sanctuaire de cristal** (autel glacière) au centre nord du plateau. Appairée à `EGI1`.

- **Dimensions** : `768 × 576 px` (`96 × 72` tuiles de `8 × 8 px`, `TexSize=1`, ratio 4:3 vaste).
- **Préfixe de banques `.tile`** : `FGI1` (`FGI1_00` à `FGI1_05`, plus `06 Top` vide `Layer=4`).
- **Carte Ground** : `Data/Ground/fgi1_fin_grotte_givre.rsground`.
- **Référence canonique** : `source/fin_grotte_givre_sanctuaire_v1/reference/D53P41C.png` (rip `pret/pmd-sky`, sommet glaciaire, commit épinglé).
- **Provenance** : art généré référencé sur le rip (jamais de tuile native revendiquée) ; le brut a été recolorisé de façon déterministe (fond → blanc chaud du rip, roc → teinte du rip) pour rester fidèle au canon — `art_approved=false`, `runtime_tested=false`.

## Pile de calques (`bas → haut`)

| # | Calque | Contenu | Cadence |
|---|---|---|---|
| `00` | `FGI1_00_sol_complet` | Fond continu : plateau et versants de glace complets (`100 %` opaque) | Fixe (`60` ticks) |
| `01` | `FGI1_01_ciel` | Fond clair lisse et silhouettes de montagnes en halo | Fixe (`60` ticks) |
| `02` | `FGI1_02_roc_givre` | Versants texturés du pic et montagnes | Fixe (`60` ticks) |
| `03` | `FGI1_03_plateau` | Glace sommitale claire (praticable) | Fixe (`60` ticks) |
| `04` | `FGI1_04_escaliers` | Strates en gradins du flanc sud (praticables, entrée) | Fixe (`60` ticks) |
| `05` | `FGI1_05_autel` | Sanctuaire de cristal (objectif) | Fixe (`60` ticks) |
| `06` | `Top` | Vide, `Layer=4` (éléments avant-plan PMDO) | — |

## Marqueurs

- `entrance` : strates d'arrivée au bord sud (centre).
- `boss_center` : centre du plateau sommital.
- `autel_glaciere` : pied du sanctuaire de cristal (nord du plateau), case 2×2 praticable.
