# Fin Tour Temporelle V2 — Arène du prisme temporel (`FTT2`)

**Fin de donjon** pour **Pokémon Mystery Dungeon: Origins `0.8.12.0`**, au format **4:3 vaste**
(`768 × 576 px` = `96 × 72` cases de `8 × 8 px`, `TexSize = 1`). C'est la salle finale qui prolonge
l'entrée `ETT2` (Tour Temporelle sud → nord V2 — Noir & Or Prismatique) : même tour, même sol,
mêmes lois d'animation, **nouveau layout d'arène**.

> `FTT1` existe sur une branche sœur non fusionnée (`arena/52e6a9de`, dans `exports/`) : rien n'en
> est repris ici. Ce lot est construit uniquement depuis la branche parente et le lot ETT2 de ce
> dépôt, d'où le préfixe **`FTT2`** (vérifié libre sur toutes les branches le 17 octobre 2026).

- **Espace de noms (`Namespace`)** : `fin_tour_temporelle_v2`
- **Carte Ground (`AssetName`)** : `ftt2_fin_tour_temporelle_noire_or`
- **Préfixe des feuilles `.tile`** : `FTT2_`
- **Layout d'une fin** : arrivée au sud par la chaussée (marqueur `entrance`), grande arène
  hexagonale d'ardoise au centre (marqueur `boss`), prisme temporel de cristal sur son dais au
  nord (marqueur `objectif`, au pied du socle). **Aucune sortie, aucun warp, pas de
  `donjon_seuil`** : la muraille gothique du nord est entièrement fermée.

## Provenance et méthode (canonique « rendu généré référencé »)

- Le décor est un **nouveau rendu généré** avec le décor exact d'ETT2 passé en `images=` au
  générateur : textures, palette noir-or et style de pixel reproduits sur un layout nouveau
  (« même endroit, autre lieu »). Trois essais : le 1er, quasi identique à l'entrée (écart RGB
  moyen 6,7), et le 2e, arène large mais sol plat sans joints (écart-type de luminance 0,4), sont
  archivés dans `bruts/ecartes/` et **jamais lus par le build** ; le 3e, édition corrective du 2e,
  est retenu (écart 26,1 contre ETT2).
- `sol_complet.png` et la planche `nuages_magenta.png` sont des **copies byte-identiques** des
  bruts ETT2 (SHA-256 vérifiés par test) : même tour, même dallage, même mer de nuages rouge/noir.
- Segmentation en matières en pleine résolution (seuils mesurés, voir `classify()` dans
  `build.py`), réduction par classe à facteur uniforme vers `768 × 576`, palette quantifiée par
  matière, puis encodage en banques PMDO de 8 px. **Les pixels générés ne sont pas des tuiles
  natives extraites du jeu** ; « PMDO » décrit le projet technique livré (Ground, `.tile`, index,
  installateur), pas la provenance de l'art.
- Les références ROM `D29P11A` / `D30P34A` citées depuis ETT1/ETT2 sont **absentes du dépôt** :
  elles sont signalées comme telles dans le manifeste, sans substitution. La fidélité est mesurée
  contre les cibles Noir & Or / Nuages Rouge-Noir d'ETT2 (seuil `< 35`) : dalles 7,4 · muraille
  6,9 · roche 16,1 · circuits or 18,3 · nuages 1,3 · sol complet 10,1 (recalculées par les tests).

## Contenu des calques (`00` à `13`, du bas vers le haut)

| # | Feuille `.tile` | Rôle | Animation |
|---|---|---|---|
| `00` | `FTT2_00_CIEL` | Ciel d'abîme rouge-noir (`28, 8, 13`) | Fixe |
| `01` | `FTT2_01_NUAGES` | Mer de nuages cramoisi/noir en dérive (`8 px`/phase, période `384 px`) | `48` phases × `5` ticks |
| `02` | `FTT2_02_SOL` | Dallage d'ardoise complet sous la plateforme (brut ETT2) | Fixe |
| `03` | `FTT2_03_CHAUSSEE` | Chaussée pavée sombre arrivant du sud | Fixe |
| `04` | `FTT2_04_ARENE` | Grande arène hexagonale, dais et degrés en dalles d'ardoise | Fixe |
| `05` | `FTT2_05_PAROIS` | Rebords et massifs de roche d'obsidienne noire | Fixe |
| `06` | `FTT2_06_MURAILLE` | Muraille gothique noire **fermée** au nord, ogives dorées | Fixe |
| `07` | `FTT2_07_PRISME` | Prisme temporel de cristal irisé et son socle (objectif, bloquant) | Fixe |
| `08` | `FTT2_08_REFLETS` | Reflets légèrement arc-en-ciel sur le prisme et les ogives | `24` phases × `10` ticks |
| `09` | `FTT2_09_ROCHERS` | 5 îlots de roche noire en lévitation | `24` phases × `10` ticks |
| `10` | `FTT2_10_CIRCUITS` | Circuits de la muraille et veines en **or incandescent** (rampes ETT2) | `16` phases × `5` ticks |
| `11` | `FTT2_11_BRECHES` | 10 brèches de réalité sur rochers et nuages (**0 px** sur le chemin) | `24` phases × `10` ticks |
| `12` | `FTT2_12_ECLATS` | 16 éclats d'or et de prisme montant du prisme et des veines | `24` phases × `10` ticks |
| `13` | *(Top vide, `Layer=4`)* | Calque d'avant-plan libre | — |

Scène bouclée sur **240 ticks (4 s à 60 Hz)**, comme ETT2.

## Accès, marqueurs, collisions

- `entrance` : sud, sur la chaussée (le couloir qui sort du donjon).
- `boss` : case 2×2 libre la plus proche du centroïde de l'arène.
- `objectif` : première case 2×2 entièrement libre au sud du socle du prisme.
- Chemins libres de `16 × 16 px` vérifiés par BFS sur la grille : `entrance → boss` et
  `entrance → objectif`. Le praticable ne touche que le bord sud (ni le haut ni les côtés).
- **Aucun warp, aucun téléporteur, aucun événement** : cette base d'édition est à raccorder vous-même.

## Installation dans PMDO `0.8.12`

```bash
python3 INSTALLER.py /chemin/vers/PMDO/MODS/mon_mod --dry-run
python3 INSTALLER.py /chemin/vers/PMDO/MODS/mon_mod
```

L'installateur fusionne les banques `FTT2_*` dans l'index des tilesets du mod cible, conserve une
sauvegarde de l'ancien index s'il change et refuse d'écraser un fichier déjà modifié. Ouvrir
ensuite l'asset `ftt2_fin_tour_temporelle_noire_or` dans l'éditeur Ground.

## Vérifications et limites

- `build.py` asserte en cours de production : fidélité des six matières sous le seuil, **0 pixel de
  brèche sur le chemin**, chemins `16 × 16` vers `boss` et `objectif`.
- `test_build.py` (et `verify.py`, qui délègue) contrôle les sorties : bruts et hashes (dont les
  copies byte-identiques d'ETT2), partition exacte des calques, zéro magenta résiduel, boucles et
  zones des animations, lois identiques à ETT2, marqueurs d'une fin (pas de sortie), ORA, Ground
  `0.8.12`, index, installeur en dossier temporaire.
- **Aucun test moteur** : PMDO n'a pas été lancé, la carte n'a été ni ouverte dans l'éditeur
  Ground ni jouée. `art_approved = false`, `runtime_tested = false`.

## Reproduction

Depuis la racine du dépôt (`Pillow`, `numpy`, `scipy` dans `.venv`) :

```sh
.venv/bin/python source/fin_tour_temporelle_v2/build.py
.venv/bin/python source/fin_tour_temporelle_v2/test_build.py
.venv/bin/python source/fin_tour_temporelle_v2/package.py
```
