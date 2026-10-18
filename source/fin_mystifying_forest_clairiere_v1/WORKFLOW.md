# Workflow du chantier `fin_mystifying_forest_clairiere_v1` (`FMF3`)

Fiche opérationnelle du chantier `source/fin_mystifying_forest_clairiere_v1/` (appairé à l'entrée `entree_mystifying_forest_sud_nord_v1` `EMF1`).

## 1. Caractéristiques du lot

- **Lot** : `fin_mystifying_forest_clairiere_v1`
- **Préfixe `.tile`** : `FMF3`
- **Format / dimensions** : `4:3 vaste` (`[768, 576]` px, grille 8 px `[96, 72]`, `TexSize = 1`)
- **Références DA canoniques ROM** : `D31P31A.png` (Clairière de la Forêt Trompeuse), `D31P11A.png` (Entrée), `D31P41A.png` (Source Lumineuse)
- **Bruts (`bruts/`)** : `decor_magenta.png` (`1200×896`), `sol_complet.png` (`1200×896`), `feuilles_lucioles_poses.png` (`1376×768`)
- **Aperçu HTML** : [`apercu_fin_mystifying_forest_clairiere_v1.html`](../../apercu_fin_mystifying_forest_clairiere_v1.html)

## 2. Commandes d'exécution

Depuis la racine du dépôt :

```bash
.venv/bin/python source/fin_mystifying_forest_clairiere_v1/build.py
.venv/bin/python -m unittest source.fin_mystifying_forest_clairiere_v1.test_build -v
.venv/bin/python source/fin_mystifying_forest_clairiere_v1/package.py
```

## 3. Contrôles de qualité vérifiés

- 12 calques RGBA `768 × 576` multiples exacts de `8 px` sans pixel `#FF00FF` résiduel + calque `Top` (`Layer = 4`) vide.
- Source Lumineuse (`02_source_lumineuse`, `12 × 20 = 240` ticks) animée aux 8 tons dorés NDS 5 bits exacts de `D31P41A.png`.
- Mares latérales (`00_eau`, `4 × 10 = 40` ticks) aux couleurs Métano exactes sans liseré clair + scintillements natifs (`01_scintillements`).
- Feuilles (`10_feuilles`, `48 × 5 = 240` ticks) et lucioles (`11_lucioles`, `48 × 5 = 240` ticks) en boucles fermées.
- `art_approved: false` et `runtime_tested: false` tant que la validation humaine et le test en moteur PMDO `0.8.12` n'ont pas été réalisés.
