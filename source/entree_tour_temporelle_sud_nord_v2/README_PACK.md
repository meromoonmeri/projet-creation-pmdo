# Entrée Tour Temporelle sud → nord V2 — Noir & Or Prismatique (`ETT2`)

Base d'édition pour **Pokémon Mystery Dungeon: Origins `0.8.12.0`**, au format **4:3 vaste** (`768 × 576 px` = `96 × 72` cases de `8 × 8 px`, `TexSize = 1`).
La version 1 (`entree_tour_temporelle_sud_nord_v1`, `ETT1`) est intégralement conservée.

- **Espace de noms (`Namespace`)** : `entree_tour_temporelle_sud_nord_v2`
- **Carte Ground (`AssetName`)** : `ett2_entree_tour_temporelle_noire_or`
- **Préfixe des feuilles `.tile`** : `ETT2_` (aucun conflit avec `ETT1` ni avec aucun autre pack du dépôt ou des branches sœurs)
- **Direction artistique V2** :
  - **Tour prismatique Noir & Or** : muraille gothique en obsidienne noire à ogives dorées/prismatiques, circuits verticaux et veines des rochers en **or en fusion** (aucune veine rouge).
  - **Arche de cristal à reflets arc-en-ciel** : portail de cristal clair parcouru par deux bandes spectrales irisées douces (`08_reflets_arc_en_ciel`).
  - **Roches en nuances de noir** : chaussée sud, corniches rocheuses et îlots flottants en basalte et obsidienne noire ; esplanade et escaliers en dalles d'ardoise sombre.
  - **Mer de nuages rouge / noir** : nuages d'orage cramoisis et noir d'encre en dérive vers l'ouest sur ciel d'abîme écarlate sombre.
  - **Brèches de réalité (`12_breches_realite`)** : 10 déchirures dimensionnelles qui s'ouvrent et se referment à tour de rôle **exclusivement sur les rochers noirs et dans les nuages** (**jamais** sur le chemin praticable).

## Contenu des calques (`00` à `14`, du bas vers le haut)

| # | Feuille `.tile` | Rôle | Animation |
|---|---|---|---|
| `00` | `ETT2_00_CIEL` | Ciel d'abîme rouge-noir (`72, 13, 20`) | Fixe (`60` ticks) |
| `01` | `ETT2_01_NUAGES` | Bandes de nuages rouge cramoisi / noir d'encre en dérive (`8 px` / phase, période `384 px`) | `48` phases × `5` ticks = `240` ticks |
| `02` | `ETT2_02_SOL` | Dallage d'ardoise noire complet sous toute la plateforme | Fixe (`60` ticks) |
| `03` | `ETT2_03_CHAUSSEE` | Chaussée praticable de basalte noir au sud | Fixe (`60` ticks) |
| `04` | `ETT2_04_PARVIS` | Escaliers, esplanade octogonale et terrasse haute en dalles d'ardoise noire | Fixe (`60` ticks) |
| `05` | `ETT2_05_PAROIS` | Flancs et corniches de roche d'obsidienne noire | Fixe (`60` ticks) |
| `06` | `ETT2_06_MURAILLE` | Haute muraille gothique noire à colonnes et ogives dorées au nord | Fixe (`60` ticks) |
| `07` | `ETT2_07_PORTAIL` | Arche-portail à pointes de cristal clair encadrant la bouche | Fixe (`60` ticks) |
| `08` | `ETT2_08_REFLETS` | Reflets légèrement arc-en-ciel sur les facettes du cristal et les ogives de la tour | `24` phases × `10` ticks = `240` ticks |
| `09` | `ETT2_09_PROFONDEUR` | Bouche sombre du donjon au nord | Fixe (`60` ticks) |
| `10` | `ETT2_10_ROCHERS` | 5 îlots de roche noire en lévitation dans la mer de nuages | `24` phases × `10` ticks = `240` ticks |
| `11` | `ETT2_11_CIRCUITS` | Circuits de la tour et veines rocheuses en **or incandescent** (16 crans aller-retour) | `16` phases × `5` ticks = `80` ticks |
| `12` | `ETT2_12_BRECHES` | 10 brèches de réalité qui s'ouvrent et se ferment sur les rochers et les nuages (0 px sur le chemin) | `24` phases × `10` ticks = `240` ticks |
| `13` | `ETT2_13_ECLATS` | 16 éclats d'or et de prisme montant du portail et des veines dorées | `24` phases × `10` ticks = `240` ticks |
| `14` | *(Top vide, `Layer=4`)* | Calque d'avant-plan libre pour vos éléments au-dessus des personnages | — |

## Installation dans PMDO `0.8.12`

```bash
python3 INSTALLER.py /chemin/vers/PMDO
```
