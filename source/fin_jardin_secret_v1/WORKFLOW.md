# WORKFLOW — Fin Jardin secret (FSG1)

Livré le 9 octobre 2026. Procédure : [../../WORKFLOW.md](../../WORKFLOW.md).

## Identité

- **Préfixe** : `FSG1` (`FJS1` = jungle, `FJS3` pris sur une sœur)
- **Namespace / asset** : `fin_jardin_secret` / `fsg1_fin_jardin_secret`
- **Format** : 768 × 576, brut 1200 × 896
- **Référence** : `secretgarden.png`
- **Méthode** : rendu généré référencé. Rayon = rampe exacte du rip.

## Relancer

Rip à la racine, bruts dans `source/fin_jardin_secret_v1/bruts/`, ZIP gabarit
`mod_metano_expeditions_pmdo_0812.zip` (non versionné, à reprendre depuis `projet-pmdo`).

```sh
python3 -m venv .venv
.venv/bin/pip install Pillow==12.3.0 numpy==2.4.0 scipy==1.17.0
.venv/bin/python source/fin_jardin_secret_v1/build.py
.venv/bin/python -m unittest source.fin_jardin_secret_v1.test_build -v
.venv/bin/python source/fin_jardin_secret_v1/package.py
```

## Bruts (`GEN`)

- `decor.png` — prairie fermée, souche pleine, pas de trou
- `temoin_sans_objets.png` — recalé (0, 0), écart 2,15
- `sol_complet.png` — herbe moyenne depuis le témoin, distance 32,5
- `ecartes/sol_complet_essai1_acide.png` — écarté (59,3 > 35)

Fidélité (seuil 35) : fond 5,6 · herbe claire 9,5 · herbe 8,2 · roche 12,0.

## Calques

sol_complet → prairie → herbe → ombres → fleurs → rochers → arbres → haies → souche → fond → rayon (24 × 5) → lucioles (24 × 5) → Top.

`art_approved: false` · `runtime_tested: false`
