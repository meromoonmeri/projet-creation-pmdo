# Workflow du chantier `fin_tour_temporelle_noire_or_v2` (`FTN2`)

Fiche opérationnelle du chantier `source/fin_tour_temporelle_noire_or_v2/` (appairé à l'entrée `entree_tour_temporelle_sud_nord_v2` `ETT2`).

## 1. Caractéristiques du lot

- **Lot** : `fin_tour_temporelle_noire_or_v2`
- **Préfixe `.tile`** : `FTN2`
- **Format / dimensions** : `4:3 vaste` (`[768, 576]` px, grille 8 px `[96, 72]`, `TexSize = 1`)
- **Références DA canoniques ROM** : `D30P34A.png`, `D30P41A.png`, `D29P11A.png` + `ETT2`
- **Bruts (`bruts/`)** : `decor_magenta.png` (`1200×896`), `trou_noir_magenta.png` (`1200×896`), `fond_nuages_rouges.png` (`1200×896`), `sol_complet.png` (`1200×896`), `nuages_magenta.png` (`1200×896`)
- **Aperçu HTML** : [`apercu_fin_tour_temporelle_noire_or_v2.html`](../../apercu_fin_tour_temporelle_noire_or_v2.html)

## 2. Commandes d'exécution

Depuis la racine du dépôt :

```bash
.venv/bin/python source/fin_tour_temporelle_noire_or_v2/build.py
.venv/bin/python -m unittest source.fin_tour_temporelle_noire_or_v2.test_build -v
.venv/bin/python source/fin_tour_temporelle_noire_or_v2/package.py
```

## 3. Contrôles de qualité vérifiés

- 14 calques RGBA `768 × 576` multiples exacts de `8 px` sans pixel `#FF00FF` résiduel (`13` banques `.tile` + calque `Top` `Layer = 4` vide).
- Deux couches de fond animées 100% indépendantes en 10 frames pixel-art nettes (`10 × 12 = 120` ticks, 2 cycles par boucle de `240` ticks) :
  - `01_nuages_orage_rouges` : 9 strates de nuages d'orage rouges/noirs plein cadre en parallaxe horizontale différentielle (`±40 px/frame` sur période `400 px`, zéro interstice, sans Trou Noir collé dedans).
  - `02_trou_noir_spirale` : Trou Noir cosmique et vortex spiralé d'accrétion indépendant sur fond transparent RGBA (`cx=384, cy=134`, horizon `r=72 px`, anneau d'accrétion `r=72..98 px`), avec rotation physique continue des bras spiraux (`18°/frame`) et ondes d'accrétion relativistes entrantes.
- Veines d'or aux reflets arc-en-ciel (`11_circuits_or` + `12_reflets_arc_en_ciel`).
- `art_approved: false` et `runtime_tested: false` tant que la validation humaine et le test en moteur PMDO `0.8.12` n'ont pas été réalisés.
