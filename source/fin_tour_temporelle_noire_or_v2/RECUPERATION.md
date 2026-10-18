# Fiche de récupération et de traçabilité — `fin_tour_temporelle_noire_or_v2` (`FTN2`)

## 1. Identité du lot

- **Lot** : `source/fin_tour_temporelle_noire_or_v2/`
- **Préfixe `.tile`** : `FTN2` (vérifié sans collision sur la branche locale et les 11 branches `arena/*` distantes ; `FTT1` est pris sur `arena/52e6a9de` et `FTT2` sur `arena/1ec61104`).
- **Carte Ground PMDO** : `ftn2_fin_tour_temporelle_noire_or` (`768 × 576 px`, grille `96 × 72` de `8 × 8 px`, `TexSize = 1`).
- **Entrée appairée** : `source/entree_tour_temporelle_sud_nord_v2/` (`ETT2`, `ett2_entree_tour_temporelle_noire_or`).
- **Références ROM canoniques** (`source/fin_tour_temporelle_noire_or_v2/reference/`) :
  - `D30P34A.png` (Tour du Temps — Sommet / *Temporal Pinnacle*)
  - `D30P41A.png` (Tour du Temps — Cime / *Temporal Spire*)
  - `D29P11A.png` (Entrée des Terres Illusoires / *Hidden Land*)

## 2. Exigences architecturales et d'animation

1. **Même chemin que l'entrée (`ETT2`) vers la zone du boss** :
   - Chaussée sud en basalte noir naturel (`04_chaussee_noire`, `13 789 px` opaques) avec ses deux veines d'or.
   - Escalier sud, large esplanade octogonale ouverte en dalles d'ardoise sombre sans piliers bloquants (`05_parvis_dalles`, `46 439 px` opaques, fidélité `0.95` RGB), et escalier nord menant au pied du sanctuaire.
   - Le premier essai de décor (qui comportait un tapis rectangulaire au sud, 4 colonnes sur l'esplanade et une muraille pleine largeur) a été archivé dans `bruts/alternatives/decor_magenta_essai1_muraille_colonnes.png`.
2. **Veines d'or aux reflets arc-en-ciel (`10_circuits_or` + `11_reflets_arc_en_ciel`)** :
   - Les veines des parois d'obsidienne noire, de la chaussée sud et de l'arche gothique combinent une pulsation d'or en fusion sur `16` crans (`10_circuits_or`, `FrameLength = 5`, `80` ticks × 3 = `240` ticks) et une onde spectrale irisée sur `24` phases (`11_reflets_arc_en_ciel`, `FrameLength = 10`, `240` ticks) parcourant les 12 teintes `GOLD_RAINBOW_TONES` (or rosé, ambré, solaire, péridot, émeraude, turquoise, cyan, saphir, améthyste, orchidée, rubis, corail).
3. **Fond Trou Noir cosmique et nuages rouges/noirs plein cadre en 10 frames nettes derrière le cadran (`01_trou_noir_spirale`)** :
   - Le brut plein cadre `bruts/fond_trou_noir_spirale.png` (`1200 × 896`, 100% couvert de nuages spiraux rouge cramoisi et noir d'encre jusqu'aux 4 bords, **zéro magenta, zéro interstice, zéro rayure de clamp**) remplace le premier essai sur fond magenta (archivé dans `bruts/alternatives/trou_noir_spirale_magenta_essai1.png`).
   - Derrière l'arche gothique centrale (`07_muraille_gothique`), le reliquaire de cristal (`08_reliquaire_cristal`) et le cadran temporel circulaire (`09_cadran_temporel`, gravé en `(384, 164)`), le Trou Noir est centré en `(384, 134)` (fenêtre intérieure `[256..942] × [193..707]` du brut `1200 × 896` à l'échelle `1.12`, laissant plus de `185 px` de marge de vrais nuages peints sur les 4 côtés).
   - Son horizon noir abyssal (`R_horizon = 86 px`) et son anneau d'accrétion doré-écarlate en pixel-art net débordent largement de part et d'autre et au-dessus de l'arche gothique (`largeur ~120 px`).
   - Les **10 frames** (`animation/trou_noir_spirale/FTN2_00_trou_noir_spirale_f00.png` .. `f09.png`, `10` frames × `24` ticks = `240` ticks, WebP dédié `FTN2_trou_noir_spirale_10frames.webp` et planche 2×5 `review/FTN2_planche_10_frames_trou_noir.png`) sont construites par **échantillonnage entier Nearest-Neighbor** (`0` flou d'interpolation) dans la carte indexée à 16 niveaux peints (`animation/trou_noir_spirale_indexee.png`) combiné au **palette cycling fermé en 10 pas** (`animation/palettes_spirale_10frames.json`, 16 couleurs NDS 5 bits).

## 3. Commandes de reconstruction et vérification

```bash
.venv/bin/python source/fin_tour_temporelle_noire_or_v2/build.py
.venv/bin/python source/fin_tour_temporelle_noire_or_v2/package.py
.venv/bin/python source/fin_tour_temporelle_noire_or_v2/verify.py
```
