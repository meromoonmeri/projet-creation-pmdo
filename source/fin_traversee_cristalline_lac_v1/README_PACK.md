# Fin Traversée Cristalline — Sanctuaire des Trois Cristaux 4:3 (`FTX1`)

Carte de fin de donjon (`fin_traversee_cristalline_lac_v1`, préfixe `FTX1`) référencée sur **`D16P31A`** (*Crystal Lake*, *Pokémon Mystery Dungeon: Explorers of Sky*).

## Caractéristiques techniques
- **Format** : `768 × 576 px` (`96 × 72` tuiles de `8 × 8 px`, `TexSize = 1`).
- **Scène** :
  - Arrivée au sud (`entrance`) par une passe entre deux corniches rocheuses sombres (`rebords`) ;
  - Vaste arène souterraine de sable bleu-sarcelle (`sable`, `ombres`, `halos_sol`), centrée sur le marqueur `boss` ;
  - Trois dalles runiques lumineuses cyan (`dalles`, praticables) et amas de rochers stratifiés (`rochers`, `cailloux`) ;
  - Trois grands massifs de cristaux cyan-bleu disposés en triangle au nord-centre (`cristaux_iliens`), parois caverneuses serties de cristaux (`parois`, `cristaux_paroi`), et marqueur `objectif` au sanctuaire nord (aucune sortie, aucun warp, aucun `donjon_seuil`).
- **Animations en boucles fermées (`24 phases × 5 ticks = 120 ticks = 2,0 s`)** :
  - `lueur_cristaux` : chatoiement déphasé (`2π/3`) des facettes des 3 massifs cristallins (`cristaux_iliens`) et des cristaux de paroi (`cristaux_paroi`), reproduisant le déphasage multi-palettes (palettes 4, 5, 6) de `D16P31A` ;
  - `lueur_dalles` : pulsation lumineuse en boucle fermée des 3 dalles runiques au sol (`dalles`) et de leurs halos (`halos_sol`, palette 3 de `D16P31A`) ;
  - `scintillements` : particules cristallines cyan-blanc dérivant en boucle fermée autour des trois massifs de cristal.

## Statut honnête
- `art_approved: false`
- `runtime_tested: false`
