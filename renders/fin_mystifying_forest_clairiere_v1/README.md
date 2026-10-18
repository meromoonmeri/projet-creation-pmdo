# Fin Mystifying Forest — Clairière de la Source Lumineuse (FMF3, 4:3 vaste, 768×576) — PMDO 0.8.12

Fin de donjon appairée à l'entrée `entree_mystifying_forest_sud_nord_v1` (`EMF1`), au format **4:3 vaste** (`768 × 576 px`, `96 × 72` cases de `8 × 8 px`, `TexSize = 1`).

## Provenance et méthode

- **Références canoniques ROM (`pret/pmd-sky`, `source/outil_maps_pmdsky/`)** :
  - `reference/D31P31A.png` : Clairière de la Forêt Trompeuse (*Mystifying Forest Clearing*, PMD Explorers of Sky).
  - `reference/D31P11A.png` : Entrée de la Forêt Trompeuse (*Mystifying Forest Entrance*, PMD Explorers of Sky).
  - `reference/D31P41A.png` : Source Lumineuse (*Luminous Spring*, 8 tons dorés NDS 5 bits exacts).
- **Bruts générés référencés (`bruts/`)** :
  - `bruts/decor_magenta.png` (`1200 × 896`) : décor complet de la clairière finale en pur décor forestier (sans bâtiment ni statue), avec l'arrivée au sud sur le chemin de terre rose-brun, la grande clairière d'herbe émeraude au centre, la vasque circulaire de pierre et de racines de la Source Lumineuse au nord-centre (peinte en `#FF00FF`), et deux mares forestières latérales (peintes en `#FF00FF`).
  - `bruts/sol_complet.png` (`1200 × 896`) : herbe émeraude pleine toile éditée depuis le décor et la référence `D31P31A.png`.
  - `bruts/feuilles_lucioles_poses.png` (`1376 × 768`) : planche sur `#FF00FF` de 6 poses de feuille en rotation et 6 poses de luciole dorée.
- **Segmentation et réduction** : segmentation en pleine résolution (`1200 × 896`), réduction uniforme par classe (`down_class`, `×576/896`, recadrage centré à `768 × 576`), quantification par groupes de matières (`terrain` 96 couleurs, `arbres` 40, `rochers` 24).

## Calques et animations (boucle 240 ticks = 4 s)

1. `00_eau` — Mares latérales animées façon rivière Métano, couleurs Métano exactes sans liseré clair (`4 × 10 = 40` ticks).
2. `01_scintillements` — Scintillements natifs `Metano_Town_River_Sparkles.tile` sur les mares (`4 × 10 = 40` ticks).
3. `02_source_lumineuse` — Bassin nord-centre animé aux **8 couleurs dorées exactes** de `D31P41A.png` (`12 × 20 = 240` ticks).
4. `03_sol_complet` — Fond d'herbe complet sous les calques terrestres.
5. `04_herbe` — Herbe claire praticable de la grande clairière centrale.
6. `05_chemin` — Chemin de terre rose-brun d'arrivée au sud.
7. `06_herbes_hautes` — Bordure d'herbes hautes sombres au pied des grands arbres.
8. `07_rochers` — Rochers moussus gris-vert.
9. `08_vasque` — Anneau de pierres moussues et de racines entourant la Source Lumineuse au nord-centre.
10. `09_arbres` — Grands arbres de la Forêt Trompeuse (houppiers et racines exposées).
11. `10_feuilles` — Chute de feuilles forestières (`48 × 5 = 240` ticks).
12. `11_lucioles` — Lucioles dorées à l'orée et autour de la Source Lumineuse (`48 × 5 = 240` ticks).
13. `12 Vos elements avant-plan (Top)` — Calque `Top` (`Layer = 4`) vide dans le Ground PMDO.

## Commandes

```bash
.venv/bin/python source/fin_mystifying_forest_clairiere_v1/build.py
.venv/bin/python -m unittest source.fin_mystifying_forest_clairiere_v1.test_build -v
.venv/bin/python source/fin_mystifying_forest_clairiere_v1/package.py
```

Statut : art généré référencé, `art_approved = false`, `runtime_tested = false`.
