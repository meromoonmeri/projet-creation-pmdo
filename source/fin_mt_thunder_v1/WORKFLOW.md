# WORKFLOW — Fin Mt. Thunder (FTM1)

Livré le 8 octobre 2026. Procédure : [../../WORKFLOW.md](../../WORKFLOW.md).

## Identité

- **Préfixe** : `FTM1` (`FMT1` pris sur une sœur)
- **Namespace / asset** : `fin_mt_thunder` / `ftm1_fin_mt_thunder`
- **Format** : 768 × 576, brut 1200 × 896
- **Référence** : `Game Boy Advance - Pokemon Mystery Dungeon_ Red Rescue Team - Dungeon Boss Rooms - Mt. Thunder.png`
- **Méthode** : rendu généré référencé. Éclairs = pixels exacts de la planche.

## Relancer

Rip à la racine, bruts dans `source/fin_mt_thunder_v1/bruts/`, ZIP gabarit
`mod_metano_expeditions_pmdo_0812.zip` (non versionné, à reprendre depuis `projet-pmdo`).

```sh
python3 -m venv .venv
.venv/bin/pip install Pillow==12.3.0 numpy==2.4.0 scipy==1.17.0
.venv/bin/python source/fin_mt_thunder_v1/build.py
.venv/bin/python -m unittest source.fin_mt_thunder_v1.test_build -v
.venv/bin/python source/fin_mt_thunder_v1/package.py
```

## Bruts (`GEN`)

- `decor.png` — plateau fermé, pas de grotte / bouche
- `sol_complet.png` — sable seul, distance 5,0 au sable du rip

Fidélité (seuil 35) : sable 2,9 · roche 10,3 · ciel 5,4 · nuages sombres 3,0 · nuages clairs 20,6.

## Calques

sol_complet → sable → cailloux → pics → falaise → piton → ciel → nuages → lueurs (48 × 5) → éclairs (48 × 5) → Top.

`art_approved: false` · `runtime_tested: false`
