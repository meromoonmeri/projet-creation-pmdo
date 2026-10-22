# Pack `FTX1` — Fin Traversée Cristal — Lac Cristallin (`96 × 72` cases, `768 × 576 px`, format `4:3`)

- **Références ROM** : `D17P33A.png` (`456 × 504`) + `D17P45A.png` (`696 × 504`, `pret/pmd-sky@c8073235`) + cadences BPA exactes `d17p33a1.bpa` (`6 poses × 10 ticks = 60 ticks`, caustiques du lac) et `d17p33a5.bpa` (`4 poses × 10 ticks = 40 ticks`, reflets du pont cristallin), boucle polymétrique exacte `PPCM(60, 40) = 120 ticks` (`12 × 10 ticks`, `2,00 s` à `60 i/s`).
- **Méthode** : rendu généré référencé (`decor.png`, `sol_complet.png`, `particules_poses.png` détouré à `0 px` magenta/violet), découpé en **10 calques** (`00 sol_complet`, `01 eau_lac`, `02 pont_cristal`, `03 dalles_sanctuaire`, `04 ilots_cristal`, `05 parois_cristal`, `06 piliers_nord`, `07 autel_cristal`, `08 caustiques_lac`, `09 lueur_pont_et_eclats`) + calque `10` `Top` vide (`Layer = 4`) dans le Ground `PMDO 0.8.12`.
- **Navigation `16 × 16`** : cul-de-sac fermé sur toute la couronne nord (`closed_north_rows >= 14`), chemin praticable continu depuis `entrance` (sud du pont cristallin) jusqu'à `boss` et `objectif`, aucun warp câblé.
- **Statut** : `art_approved = false`, `runtime_tested = false`.

```bash
.venv/bin/python source/fin_traversee_cristal_v1/build.py
.venv/bin/python -m unittest source.fin_traversee_cristal_v1.test_build -v
.venv/bin/python source/fin_traversee_cristal_v1/package.py
```
