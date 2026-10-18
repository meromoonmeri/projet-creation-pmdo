# Workflow du chantier `fin_underground_lake_sanctuaire_v1` (`FUL2`)

Fiche opérationnelle du chantier `source/fin_underground_lake_sanctuaire_v1/` (appairé à l'entrée `entree_underground_lake_sud_nord_v1` `EUL1`).

## 1. Caractéristiques du lot

- **Lot** : `fin_underground_lake_sanctuaire_v1`
- **Préfixe `.tile`** : `FUL2`
- **Format / dimensions** : `4:3 vaste` (`[768, 576]` px, grille 8 px `[96, 72]`, `TexSize = 1`)
- **Référence DA canonique ROM** : `D15P41A.png` (*Underground Lake*, PMD Explorers of Sky, 69 couleurs exactes)
- **Bruts (`bruts/`)** : `decor_magenta.png` (`1200×896`), `sol_complet.png` (`1200×896`), `gouttes_ronds_poses.png` (`1024×1024`)
- **Aperçu HTML** : [`apercu_fin_underground_lake_sanctuaire_v1.html`](../../apercu_fin_underground_lake_sanctuaire_v1.html)

## 2. Commandes d'exécution

Depuis la racine du dépôt :

```bash
.venv/bin/python source/fin_underground_lake_sanctuaire_v1/build.py
.venv/bin/python -m unittest source.fin_underground_lake_sanctuaire_v1.test_build -v
.venv/bin/python source/fin_underground_lake_sanctuaire_v1/package.py
```

## 3. Contrôles de qualité vérifiés

- 10 calques RGBA `768 × 576` multiples exacts de `8 px` sans pixel `#FF00FF` résiduel + calque `Top` (`Layer = 4`) vide.
- Eau (`00_eau`, `4 × 10 = 40` ticks) et lueur bioluminescente (`01_lueur`, `12 × 10 = 120` ticks) aux couleurs exactes de `D15P41A.png`.
- Scintillements Métano natifs (`02_scintillements`, `4 × 10 = 40` ticks) sur le cœur de la lueur et gouttes/ronds d'onde (`03_gouttes`, `24 × 5 = 120` ticks) en boucle fermée.
- `art_approved: false` et `runtime_tested: false` tant que la validation humaine et le test en moteur PMDO `0.8.12` n'ont pas été réalisés.
