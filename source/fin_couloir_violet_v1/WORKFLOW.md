# WORKFLOW — Fin Couloir violet (FVL1)

Livré le 8 octobre 2026. Procédure : [../../WORKFLOW.md](../../WORKFLOW.md).

## Identité

- **Préfixe** : `FVL1` (`FCV1` pris sur une sœur)
- **Namespace / asset** : `fin_couloir_violet` / `fvl1_fin_couloir_violet`
- **Format** : 768 × 576, brut 1200 × 896
- **Référence** : `large.S05P03A.png.301f7a1eadda348357be0801e81faa2a.png`
- **Méthode** : rendu généré référencé. Planche poussière = copie ECV1.

## Relancer

Rip à la racine, bruts dans `source/fin_couloir_violet_v1/bruts/`, ZIP gabarit
`mod_metano_expeditions_pmdo_0812.zip` (non versionné, à reprendre depuis `projet-pmdo`).

```sh
python3 -m venv .venv
.venv/bin/pip install Pillow==12.3.0 numpy==2.4.0 scipy==1.17.0
.venv/bin/python source/fin_couloir_violet_v1/build.py
.venv/bin/python -m unittest source.fin_couloir_violet_v1.test_build -v
.venv/bin/python source/fin_couloir_violet_v1/package.py
```

## Bruts (`GEN`)

- `decor.png` — arène fermée, pas de tunnel / bouche sombre
- `sol_complet.png` — sol mauve plein, distance 3,5 au sol du rip
- `poussiere_poses.png` — copie ECV1 (même sha256)

Fidélité (seuil 35) : sol 2,7 · roche 11,9. Calques : sol 5,1 · rochers 11,6 · blocs 7,8.

## Calques

sol_complet → sol → ombres → gravillons → blocs → rochers → vide → éboulis (24 × 5) → poussière (24 × 5) → Top.

`art_approved: false` · `runtime_tested: false`
