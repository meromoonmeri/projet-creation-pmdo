# Fin du Jardin Secret — Sanctuaire de Celebi V1 (`FJS4`, format 4:3 vaste — 768 × 576 px)

Seconde carte du biome **Jardin secret** (appairée aux entrées sud → nord `EJS1` et `EJS2`), représentant la **clairière sanctuaire intérieure** entourée de haies buissonneuses, de quatre grands arbres feuillus, de rochers beiges et de parterres fleuris, dominée au nord par la **grande souche dorée portant l'autel de pierre et l'emblème lumineux de Celebi** sous le faisceau de lumière verte.

- **Dimensions** : `768 × 576 px` (`96 × 72` tuiles de `8 × 8 px`, `TexSize=1`, ratio 4:3 vaste).
- **Préfixe de banques `.tile`** : `FJS4` (`FJS4_00` à `FJS4_14`, plus `15 Top` vide `Layer=4`).
- **Carte Ground** : `Data/Ground/fjs4_fin_jardin_secret_sanctuaire.rsground`.
- **Référence canonique** : `source/fin_jardin_secret_sanctuaire_v1/reference/secretgarden.png` (*Jardin secret*, `408 × 400 px`, `sha256 = e5a41562745c6fbfd3bb9edceed054810bbb07adf2f1b2a74e7ece8e19a2164f`).

## Pile de calques (`bas → haut`)

| # | Calque | Contenu | Cadence |
|---|---|---|---|
| `00` | `FJS4_00_sol_complet` | Fond continu d'herbe verte moyenne à touffes (`768 × 576`, 100 % opaque) | Fixe (`60` ticks) |
| `01` | `FJS4_01_prairie` | Prairie centrale jaune-vert clair et allée d'arrivée sud | Fixe (`60` ticks) |
| `02` | `FJS4_02_herbe` | Herbe verte moyenne entourant la prairie centrale | Fixe (`60` ticks) |
| `03` | `FJS4_03_ombres` | Ombres portées sombres au pied des quatre grands arbres | Fixe (`60` ticks) |
| `04` | `FJS4_04_fleurs` | Petites fleurs blanches, jaunes et roses à 5 pétales | Fixe (`60` ticks) |
| `05` | `FJS4_05_rochers` | Rochers beiges-bruns bordant la clairière | Fixe (`60` ticks) |
| `06` | `FJS4_06_arbres` | Quatre grands arbres feuillus et leurs troncs | Fixe (`60` ticks) |
| `07` | `FJS4_07_haies` | Haies buissonneuses arrondies ceinturant le sanctuaire | Fixe (`60` ticks) |
| `08` | `FJS4_08_souche` | Grande souche dorée à racines au nord de la clairière | Fixe (`60` ticks) |
| `09` | `FJS4_09_marches` | Escalier de bois sur le devant de la souche (praticable) | Fixe (`60` ticks) |
| `10` | `FJS4_10_autel` | Socle et autel de pierre sculptée posé sur la souche | Fixe (`60` ticks) |
| `11` | `FJS4_11_fond` | Fond forestier vert sombre entourant la clairière | Fixe (`60` ticks) |
| `12` | `FJS4_12_embleme_fNN` | Emblème foliaire de Celebi sur l'autel (rampe exacte des 22 verts du rip) | `24 × 5 = 120` ticks |
| `13` | `FJS4_13_rayon_fNN` | Faisceau vertical de lumière verte (rampe exacte des 22 verts du rip) | `24 × 5 = 120` ticks |
| `14` | `FJS4_14_lucioles_fNN` | 10 lucioles montantes oscillantes aux couleurs exactes du rip | `24 × 5 = 120` ticks |
| `15` | `15 Top` | Calque supérieur vide (`Layer = 4`) dans le `.rsground` | Fixe (`60` ticks) |

## Commandes

```bash
.venv/bin/python source/fin_jardin_secret_sanctuaire_v1/build.py
.venv/bin/python -m unittest source.fin_jardin_secret_sanctuaire_v1.test_build -v
.venv/bin/python source/fin_jardin_secret_sanctuaire_v1/package.py
```
