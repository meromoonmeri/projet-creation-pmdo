# INVENTAIRE — Grounds PMD Red ↔ Donjons (port repo PMD-RED-PMDO-PORT)

**Date** : 2026-08-06 — **Source** : branche `master` du dépôt (245 `.rsground` pixel-perfect) croisée avec `pmd_red_extraction/pmd_red_index.json` (rôles ENTRY/MID/END vérifiés) et `MAP_DATABASE.md` / `CINEMATICS_DATABASE.md` (boss documentés).

**Règle appliquée (exigence n°3)** : un donjon **sans** ground d'entrée dans la source n'en reçoit pas ici — l'inventaire reflète exactement ce qui existe (colonnes `—`).

---

## 1. Donjons du scénario principal (D01–D13) — entrée + relais + fin

| Donjon (GBA) | Boss (doc) | ENTREE (ground) | RELAIS (ground) | FIN / ARENE (ground) |
|---|---|---|---|---|
| **D01 Tiny Woods** | — | `foret_tendre_oree` (D01P01) | — | `d01p02` (D01P02) |
| **D02 Thunderwave Cave** | — | `grotte_statique_seuil` (D02P01) | — | `d02p02` (D02P02) |
| **D03 Mt. Steel** | — | `pic_ferreux_pied` (D03P01) | — | `d03p02` (D03P02) |
| **D04 Sinister Woods** | — | `bois_sombres_oree` (D04P01) | — | `bois_sombres_fond` (D04P02) |
| **D05 Silent Chasm** | — | `gouffre_muet_bord` (D05P01) | — | `d05p02` (D05P02) |
| **D06 Mt. Thunder** | Zapdos | `mont_grondant_pied` (D06P01) | `d06p02` (D06P02) | `d06p03` (D06P03) |
| **D07 Great Canyon** | — | `grand_canyon_porte` (D07P01) | — | — (pas de fin dédiée) + `d07p02` = Colline des Anciens (scène Xatu) |
| **D08 Lapis Cave** | — | `grotte_lazuli_seuil` (D08P01) | — | `grotte_lazuli_fond` (D08P02) |
| **D09 Mt. Blaze** | Moltres | `mont_cendre_pied` (D09P01) | `d09p02` (D09P02) | `d09p03` (D09P03) |
| **D10 Frosty Forest** | Articuno | `foret_givree_oree` (D10P01) | `d10p02` (D10P02) | `d10p03` (D10P03) |
| **D11 Mt. Freeze** | Ninetales | `mont_gele_pied` (D11P01) | `d11p02` (D11P02) | `d11p03` (D11P03) |
| **D12 Magma Cavern** | Groudon | `gorge_ardente_porte` (D12P01) | `gorge_ardente_coeur` (D12P02) | `fosse_ardente` (D12P04) |
| **D13 Sky Tower** | Rayquaza | `parvis_celeste` (D13P01) | `palier_celeste` (D13P02) | `tour_ciel_sommet` (D13P03) |

## 2. Arènes de boss post-game (D14–D25) — ground unique, PAS d'entrée

> Ces donjons sont **procéduraux sans entrance ground** dans la source : seul le ground d'arène existe. Conformément à l'exigence n°3, aucun ne reçoit d'entrée inventée.

| Donjon (GBA) | Boss (doc) | Ground (arène) |
|---|---|---|
| **D14 Stormy Sea** | Kyogre | `abime_tempetes` (D14P01) |
| **D15 Silver Trench** | Lugia | `fosse_argentee` (D15P01) |
| **D16 Fiery Field** | Moltres | `champ_braises` (D16P01) |
| **D17 Lightning Field** | Raikou | `champ_foudre` (D17P01) |
| **D18 Northwind Field** | Articuno | `champ_vent_boreal` (D18P01) |
| **D19 Mt. Faraway** | Ho-Oh | `sommet_aurore` (D19P01) |
| **D20 Western Cave** | Mewtwo | `antre_occident` (D20P01) |
| **D21 Northern Range** | Latios/Latias | `cretes_boreales` (D21P01) |
| **D22 Pitfall Valley** | — | `vallon_perdu` (D22P01) |
| **D23 Wish Cave** | Jirachi | `sanctuaire_voeu` (D23P01) |
| **D24 Murky Cave** | — | `caverne_trouble_fond` (D24P01) + `caverne_trouble_autel` (D24P02) |
| **D25 Howling Forest** | Suicune | `bois_des_plaintes` (D25P01) |

## 3. Synthèse

| Catégorie | Nombre | Donjons |
|---|---|---|
| Donjons avec **entrance ground** | 13 | D01–D13 |
| Donjons **sans** entrance (arène seule) | 12 | D14–D25 |
| Donjons avec **relais/midpoint** | 6 | D06, D09, D10, D11, D12, D13 |
| Donjons avec **ground de fin/arène dédié** | 24 | D01–D06, D08–D25 (D07 excepté) |
| Donjons **sans** ground de fin | 1 | D07 (Great Canyon — fin procédurale) |

## 4. Correspondance fichier port repo ↔ identifiant source

Tous les grounds listés existent dans `output/Grounds/` du port (branche master) sous ces noms exacts :
- **33 nommés en français** (les `foret_tendre_oree`, `mont_grondant_pied`, `tour_ciel_sommet`… ci-dessus) — ce sont les noms déjà intégrés au mod New Era.
- **13 restants par identifiant source** : `d01p02`, `d02p02`, `d03p02`, `d05p02`, `d06p02`, `d06p03`, `d07p02`, `d09p02`, `d09p03`, `d10p02`, `d10p03`, `d11p02`, `d11p03` — **midpoints/fins non encore renommés ni branchés** dans le mod.

## 5. Vérifications (auto-questionnement)

- **Structure vérifiée avant hypothèse** ✅ : rôles lus depuis `pmd_red_index.json` (map_id ENTRY/MID/END), fichiers croisés avec `output/Grounds/` (245 présents).
- **Aucune entrance inventée** ✅ : D14–D25 sans entrance dans la source → colonne vide.
- **Aucun ground modifié/remplacé** ✅ : inventaire pur, aucune écriture dans les dépôts ni dans le mod.
- **D07** : cas particulier documenté — pas de fin dédiée, ground `d07p02` = Colline des Anciens (scène cinématique, pas une arène).
- **D24** : deux grounds de fin (fond + autel), pas d'entrée.
