# État de la série sud → nord — 8 octobre 2026

Série extraite dans `projet-creation-pmdo` (méthodes sans PNG de rendu).
Dernier lot **produit** dans l’historique source : **FST1 Fin Star Cave** (29 sept. 2026).

`art_approved` / `runtime_tested` : **false** sur toute la série, sauf mention contraire
dans un `STATUS.md` de lot (aucun à ce jour).

## Entrées (sud → nord)

| Préfixe | Lot | Référence principale | Notes |
|---|---|---|---|
| ESN1 / ESN2 | `entree_vapeur_sud_nord_v1` / `_v2` | Steam Cave | V1 hors extraction partielle ; V2 eau Métano |
| ECN1 | `entree_cratere_sud_nord_v1` | Dark Crater | **homonyme** ECN1 cascade sur une sœur |
| ERN1 | `entree_ruine_sud_nord_v1` | Sealed Ruin | |
| EGN1 | `entree_givre_sud_nord_v1` | Frosty Forest | |
| EBN1 | `entree_bristle_sud_nord_v1` | Mt. Bristle | utilitaires partagés |
| EJN1 | `entree_jungle_sud_nord_v1` | Southern Jungle | **gabarit 4:3** |
| EWC1–3 | `entree_waterfall_cave_sud_nord_v1`…`v3` | `entrancecascade.png` | V3 : rideau qui se fend |
| EUL1 | `entree_underground_lake_sud_nord_v1` | Underground Lake shore | |
| EMF1 | `entree_mystifying_forest_sud_nord_v1` | Mystifying Forest | |
| EQS1 | `entree_sables_mouvants_sud_nord_v1` | `witheringdesert.png` | |
| ESC1 | `entree_star_cave_sud_nord_v1` | `starcavepmdsky.png` | |
| ETC1 | `entree_clairiere_tropicale_sud_nord_v1` | `large.S01P03A…png` | ponton + mer |
| ECV1 | `entree_couloir_violet_sud_nord_v1` | `large.S05P03A…png` | |
| EMT1 | `entree_mt_thunder_sud_nord_v1` | Mt. Thunder (GBA) | |
| EJS1 / EJS2 | `entree_jardin_secret_sud_nord_v1` / `_v2` | `secretgarden.png` | V2 = temple Celebi |
| ECM1 | `entree_cratere_magma_v1` | Dark Crater entrance | magma visqueux |

Mod unique des 18 entrées : `source/mod_guilde_entrees_v1/` (EJS2 ajoutée, v1.1.0.0).
Toute nouvelle entrée de la série doit être ajoutée à `MAPS` dans `build_mod.py`.

## Fins (même ordre de biomes)

| Préfixe | Lot | Jumeau | État |
|---|---|---|---|
| FVS1 | `fin_vapeur_sommet_v1` | ESN2 | fait |
| FCF1 | `fin_cratere_fosse_v1` | ECN1 | fait |
| FRP1 | `fin_ruine_puits_v1` | ERN1 | fait |
| FGG1 / FGG2 | `fin_givre_grotte_v1` / `fin_givre_aurore_v2` | EGN1 | fait (V2 = aurores, sans cristal) |
| FBS1 | `fin_bristle_sommet_v1` | EBN1 | fait |
| FJS1 | `fin_jungle_sud_v1` | EJN1 | fait |
| FWC1 | `fin_waterfall_cave_v1` | EWC* | fait |
| FOC1 | `fin_ocean_kyogre_v1` | — | fait (hors ordre strict) |
| FSM1 | `fin_sables_mouvants_v1` | EQS1 | fait |
| FST1 | `fin_star_cave_v1` | ESC1 | fait — **dernier livré** |
| **FCT1** | **`fin_clairiere_tropicale_v1`** | ETC1 | **suivant, méthode ouverte** |
| — | Fin Couloir violet | ECV1 | à faire (`FCV1` pris sur sœur) |
| — | Fin Mt. Thunder | EMT1 | à faire (`FMT1` pris sur sœur) |
| — | Fin Jardin secret | EJS* | à faire |
| FUL1, FMF1/2 | Underground Lake, Mystifying Forest | EUL1, EMF1 | **sœurs non fusionnées** |

## Carte suivante

**Fin Clairière tropicale**, slug `fin_clairiere_tropicale_v1`, préfixe **FCT1**
(`FTC1` est un repère de branche sœur : ne pas le réutiliser).

- Rip : `large.S01P03A.png.84e22fb77c4061e77b0f546545fed2c7.png` (même que ETC1).
- Layout de fin : pas de mer / ponton / bouche sombre ; clairière fermée par la jungle ;
  `entrance` sud, `boss` centre, `objectif` nord (tertres de fleurs / grand palmier).
- Réutiliser la planche de papillons ETC1 (même biome, mêmes poses).
- Détail : `source/fin_clairiere_tropicale_v1/WORKFLOW.md`.

## Préfixes à ne plus prendre

Série ici : ESN1, ESN2, ECN1, ERN1, EGN1, EBN1, EJN1, EWC1–3, EUL1, EMF1, EQS1,
ESC1, ETC1, ECV1, EMT1, EJS1, EJS2, ECM1, FVS1, FCF1, FRP1, FGG1, FGG2, FBS1,
FJS1, FWC1, FOC1, FSM1, FST1, FCT1, AGM1–3, ATP1, CLR1, RAZ1–3, EAZ1, RAF1–3,
EAF1, RZD1, ZRV1, ZRV2.

Sœurs (relevé 27–29 sept., non fusionnées) : EFF1, EFF2, EDP1, ECF1, ECC1, ECC2,
ESJ1, ESR1, EWL1, TMA1–3, ZGE1, ZGA1, EJT1, ESP1, ESP2, EGC1, EAN1, EHN1, EWN1,
ECN2, FUL1, FMF1, FMF2, ATF1, BZF1, FCV1, FJS3, FMT1, FQS1, FSC1, FTC1.
