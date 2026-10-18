# Fin de Mt. Thunder — Sommet Foudroyant V1 (`FMT3`, format 4:3 vaste — 768 × 576 px)

Seconde carte du biome **Mt. Thunder** (après l'entrée sud → nord `EMT1`), représentant l'**arène finale du sommet au-dessus des nuages d'orage** dominée au nord par la **couronne de pitons rocheux foudroyés** (`piton_foudre`) où se dresse le boss (**Électhor / Zapdos**).

- **Dimensions** : `768 × 576 px` (`96 × 72` tuiles de `8 × 8 px`, `TexSize=1`, ratio 4:3 vaste).
- **Préfixe de banques `.tile`** : `FMT3` (`FMT3_00` à `FMT3_10`, plus `11 Top` vide `Layer=4`).
- **Carte Ground** : `Data/Ground/fmt3_fin_mt_thunder_sommet.rsground`.
- **Référence canonique** : `source/fin_mt_thunder_sommet_v1/reference/mt_thunder.png` (*Mt. Thunder Peak*, Red Rescue Team, `432 × 498 px`, `sha256 = 6f1dc6a9a907fff7e3e8f57ea3a97a3e0a5de36312ce7939d7834f6d407da416`).

## Pile de calques (`bas → haut`)

| # | Calque | Contenu | Cadence |
|---|---|---|---|
| `00` | `FMT3_00_sol_complet` | Fond continu de sable jaune pâle du sommet (`768 × 576`, 100 % opaque) | Fixe (`60` ticks) |
| `01` | `FMT3_01_sable` | Plateau praticable de sable jaune pâle et crête d'arrivée sud | Fixe (`60` ticks) |
| `02` | `FMT3_02_cailloux` | Petits cailloux gris disséminés sur le plateau | Fixe (`60` ticks) |
| `03` | `FMT3_03_pics` | Pics rocheux coniques et rochers moussus sur le plateau | Fixe (`60` ticks) |
| `04` | `FMT3_04_falaise` | Parois rocheuses brunes fissurées bordant le plateau | Fixe (`60` ticks) |
| `05` | `FMT3_05_piton_foudre` | Couronne nord de grands pitons et monolithes rocheux du sommet | Fixe (`60` ticks) |
| `06` | `FMT3_06_ciel` | Ciel d'orage sombre (`lum < 90`) au nord | Fixe (`60` ticks) |
| `07` | `FMT3_07_nuages` | Mer de nuages d'orage festonnés entourant le sommet | Fixe (`60` ticks) |
| `08` | `FMT3_08_lueurs_fNN` | Arcs lumineux « Flash » exacts de la planche GBA (`Normal` → `Fading`) | `48 × 5 = 240` ticks |
| `09` | `FMT3_09_eclairs_fNN` | 4 éclairs exacts de la planche GBA + miroirs à droite (`Normal` → `Fading`) | `48 × 5 = 240` ticks |
| `10` | `FMT3_10_lueur_piton_fNN` | Pulsation électrique dorée sur les arêtes de la couronne nord (couleurs exactes de la planche) | `48 × 5 = 240` ticks |
| `11` | `11 Top` | Calque supérieur vide (`Layer = 4`) dans le `.rsground` | Fixe (`60` ticks) |

## Commandes

```bash
.venv/bin/python source/fin_mt_thunder_sommet_v1/build.py
.venv/bin/python -m unittest source.fin_mt_thunder_sommet_v1.test_build -v
.venv/bin/python source/fin_mt_thunder_sommet_v1/package.py
```
