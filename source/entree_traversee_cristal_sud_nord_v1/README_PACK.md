# Pack `ETX1` — Entrée Traversée Cristal (`96 × 72` cases, `768 × 576 px`, format `4:3`)

- **Référence ROM** : `D17P11A.png` (`600 × 480`, `pret/pmd-sky@c8073235`) + tables d'animation de palette exactes **Palettes 8 et 9** de `d17p11a.bpl` (`19 poses × 4 ticks = 76 ticks`, `1,27 s` à `60 i/s`).
- **Méthode** : rendu généré référencé (`decor.png`, `sol_complet.png`, `particules_poses.png` détouré à `0 px` magenta/violet), découpé en **10 calques** (`00 sol_complet`, `01 ardoise_sombre`, `02 pierre_turquoise`, `03 dalles_cristal`, `04 rochers`, `05 parois`, `06 cristaux`, `07 profondeur`, `08 lueur_sanctuaire`, `09 reflets_et_poussiere`) + calque `10` `Top` vide (`Layer = 4`) dans le Ground `PMDO 0.8.12`.
- **Navigation `16 × 16`** : couloir sud praticable (`entrance`) jusqu'au seuil nord devant l'arche du cristal central (`donjon_seuil`), aucun warp câblé.
- **Statut** : `art_approved = false`, `runtime_tested = false`.

```bash
.venv/bin/python source/entree_traversee_cristal_sud_nord_v1/build.py
.venv/bin/python -m unittest source.entree_traversee_cristal_sud_nord_v1.test_build -v
.venv/bin/python source/entree_traversee_cristal_sud_nord_v1/package.py
```
