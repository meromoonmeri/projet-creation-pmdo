# WORKFLOW — Entrée Jungle sud → nord (EJN1) — **gabarit 4:3**

Premier lot au format vaste 768 × 576. **C’est le gabarit à copier** pour une
nouvelle entrée. Procédure de session : [../../WORKFLOW.md](../../WORKFLOW.md).
Série : [../methode_serie_sud_nord/](../methode_serie_sud_nord/).

## Identité

- **Préfixe** : `EJN1` (pris)
- **Namespace / asset** : `entree_jungle_sud_nord` / `ejn1_entree_jungle`
- **Format** : 1200 × 896 brut → ×576/896 → 771 × 576 → crop centré 768 × 576
- **Référence** : Southern Jungle (`Southern_Jungle_exit_S.png` côté fin ; entrée d’après le même biome)
- **Méthode** : rendu généré, eau en magenta, rivière façon Métano (pixels recalculés)

## Relancer

Bruts et rip **absents** de cette extraction.

```sh
.venv/bin/python source/entree_jungle_sud_nord_v1/build.py
.venv/bin/python -m unittest source.entree_jungle_sud_nord_v1.test_build -v
.venv/bin/python source/entree_jungle_sud_nord_v1/package.py
```

9 tests PASS dans la session du 26 sept. 2026 (byte-identiques hors horodatage ORA).

## Ce que les autres lots doivent reprendre

1. `W, H = 768, 576` et `SRC = (1200, 896)` — `down_class` / `down_full` / `rgba` / `quantize_group`.
2. `loadmod` de Bristle pour `keep_large`, `quantize_layers`, `place`, `cell_grid`, `write_ora` ;
   **assigner `BM.W, BM.H` avant l’appel**.
3. Calques : eau → scintillements → sol complet → matières → entrée sombre → animation → Top vide.
4. `entrance` au sud, `donjon_seuil` au nord, aucun warp, chemin 16 × 16.
5. `README_PACK.md` + `viewer_template.html` + `package.py` (ZIP + aperçu base64).
6. Manifeste : hashes des bruts, `art_approved: false`, `runtime_tested: false`.

## Bruts

- `decor_magenta.png` — jungle + clairière, eau = magenta
- `sol_complet.png` — herbe seule
- `papillons_poses.png` — planche 2 × 6 (jaune / bleu)

## Pièges nés ici

- Facteur non entier 576/896 : **moyenne par classe**, jamais un resize global.
- Crop : 1 px à gauche, 2 px à droite (771 → 768).
- Palette d’eau jungle choisie à la main (rôles Métano, teintes sarcelle) : ce n’est pas l’eau native Métano.

Notice : `README_PACK.md`. Pas de runtime.
