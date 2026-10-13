# WORKFLOW — Biomes Apple Woods, Glace, Ruine Légendaire & Monde Inversé de Giratina (4:3, Pur Décor Sans Artefact ni Structure)

```
source/<lot>/reference/ (PNG canoniques PMD2)
   + source/<lot>/bruts/{sol_complet,decor,decor_magenta}.png
   -> .venv/bin/python source/<lot>/build.py
   -> .venv/bin/python source/<lot>/package.py
   -> renders/<lot>/ + apercu_<lot>.html
```

## Lots livrés (`768 × 576 px`, `96 × 72` cases `8 × 8`, `TexSize=1`, 100 % décor naturel/architectural pur, zéro artefact/objet/structure en fin de donjon)

1. **`entree_apple_woods_sud_nord_v1` (`EAW1`)** — Entrée Apple Woods Sud → Nord (`Apple_Woods_entrance_TDS.png` + `applewoods_arbres_decoupe_x2.png`).
2. **`fin_apple_woods_clairiere_pommier_v1` (`FAW1`)** — Fin Apple Woods — Clairière des Pommiers (clairière naturelle entourée de pommiers, sans panier ni objet).
3. **`entree_route_glace_sud_nord_v1` (`ERG1`)** — Entrée Route de Glace Sud → Nord (`iceroadpmdsky.png` + `pmdskyicearena.png`).
4. **`fin_route_glace_cirque_polaire_v1` (`FRG1`)** — Fin Route de Glace — Cirque Polaire (amphithéâtre glaciaire et stalagmites de glace, sans piédestal ni cristal).
5. **`entree_ruine_legendaire_sud_nord_v1` (`ERL1`)** — Entrée Ruine Légendaire Sud → Nord (`D28P44A_decoupe_style_x2.png`).
6. **`fin_ruine_legendaire_sanctuaire_v1` (`FRL1`)** & **`fin_ruine_legendaire_sanctuaire_v2` (`FRL2`)** — Fin Ruine Légendaire — Fosse des Ruines Scellées (`Sealed_Ruin_pit_TDS.png` + dalles anciennes, 100 % roche naturelle et dalles brisées, sans sceau, sans autel ni structure).
7. **`entree_monde_inverse_giratina_v1` (`EMI1`)** & **`entree_monde_inverse_giratina_v2` (`EMI2`)** — Entrée Monde Inversé de Giratina — Chemins à l'Envers & Cascades Inversées (`finalisland.png` + `Waterfall_Cave_ledge_TDS.png` + `D42P41A.png`, îles flottantes renversées dans le néant bleu abyssal animé, arbres la tête en bas, cascades qui coulent vers le haut, sans colonnes ni structures).
8. **`fin_monde_inverse_giratina_v1` (`FMI1`)** & **`fin_monde_inverse_giratina_v2` (`FMI2`)** — Fin Monde Inversé de Giratina — Archipel du Néant Abyssal (`finalisland.png` + `Waterfall_Cave_ledge_TDS.png` + `Sealed_Ruin_pit_TDS.png` + `D42P41A.png`, chemin rocheux à l'envers menant à la grande île flottante entourée d'îles inversées et de cascades ascendantes dans le néant bleu abyssal animé, zéro structure et zéro artefact).

### Lot Giratina Monde Inversé V3 (`EMI3`, `FMI3`)
- `source/entree_monde_inverse_giratina_v3` (`EMI3`) : Entrée Monde Inversé de Giratina V3 — Anneau Gravitationnel & Chemins à l'Envers (`768 × 576`, `entrance=(376,552)` -> `donjon_seuil=(376,112)`, `651` cases explorées, cascades inversées ascendantes et vortex abyssal animé, zéro structure ni artefact).
- `source/fin_monde_inverse_giratina_v3` (`FMI3`) : Fin Monde Inversé de Giratina V3 — Archipel Abyssal Pur Décor Naturel (`768 × 576`, `entrance=(376,552)` -> `boss=(376,328)` -> `objectif=(376,216)`, `437` cases explorées, îles flottantes à l'envers, chemins latéraux inversés et 5 cascades inversées ascendantes, zéro structure ni artefact).
