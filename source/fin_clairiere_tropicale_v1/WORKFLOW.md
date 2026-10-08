# WORKFLOW — Fin Clairière tropicale (FCT1)

Livré le 8 octobre 2026. Procédure : [../../WORKFLOW.md](../../WORKFLOW.md).

## Identité

- **Préfixe** : `FCT1` (`FTC1` pris sur une sœur)
- **Namespace / asset** : `fin_clairiere_tropicale` / `fct1_fin_clairiere_tropicale`
- **Format** : 768 × 576, brut 1200 × 896
- **Référence** : `large.S01P03A.png.84e22fb77c4061e77b0f546545fed2c7.png`
- **Méthode** : rendu généré référencé. Planche papillons = copie ETC1.

## Relancer

Rip à la racine, bruts dans `source/fin_clairiere_tropicale_v1/bruts/`, ZIP gabarit
`mod_metano_expeditions_pmdo_0812.zip` (non versionné, à reprendre depuis `projet-pmdo`).

```sh
python3 -m venv .venv
.venv/bin/pip install Pillow==12.3.0 numpy==2.4.0 scipy==1.17.0
.venv/bin/python source/fin_clairiere_tropicale_v1/build.py
.venv/bin/python -m unittest source.fin_clairiere_tropicale_v1.test_build -v
.venv/bin/python source/fin_clairiere_tropicale_v1/package.py
```

## Bruts (`GEN`)

- `decor.png` — arène fermée, pas de mer / ponton / grotte
- `sol_complet.png` — herbe seule, recalé (0, 0), écart 4,32
- `temoin_sans_objets.png` — sans palmiers ni fleurs, recalé (0, 0)
- `papillons_poses.png` — copie ETC1

Fidélité (seuil 35) : herbe 11,1 · jungle 26,6 · dalles 14,8.

## Calques

sol_complet → herbe → ombres → dalles → touffes → fleurs → jungle → palmiers → papillons (24 × 5) → Top.

`art_approved: false` · `runtime_tested: false`
