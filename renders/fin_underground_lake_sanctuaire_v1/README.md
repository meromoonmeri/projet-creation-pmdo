# Fin Underground Lake — Sanctuaire Bioluminescent (FUL2, 4:3 vaste, 768×576) — PMDO 0.8.12

Fin de donjon appairée à l'entrée `entree_underground_lake_sud_nord_v1` (`EUL1`), au format **4:3 vaste** (`768 × 576 px`, `96 × 72` cases de `8 × 8 px`, `TexSize = 1`).

## Provenance et méthode

- **Référence canonique ROM (`pret/pmd-sky`, `source/outil_maps_pmdsky/`)** :
  - `reference/D15P41A.png` : Rive du Lac Souterrain (*Underground Lake*, PMD Explorers of Sky, 69 couleurs exactes dont 3 tons d'eau profonde et 9 tons de lueur cyan-turquoise).
- **Bruts générés référencés (`bruts/`)** :
  - `bruts/decor_magenta.png` (`1200 × 896`) : décor complet du sanctuaire souterrain en pur décor caverneux (sans bâtiment ni statue), avec l'arrivée au sud par le couloir de sable jaune pâle entre les parois bosselées olive-kaki, le grand promontoire central de sable formant l'arène du boss, et le vaste lac souterrain (peint en `#FF00FF`) d'où émergent quatre grands piliers rocheux et des stalagmites pointues.
  - `bruts/sol_complet.png` (`1200 × 896`) : sol complet édité depuis le décor (lac, piliers et stalagmites retirés ; parois externes conservées et recalées à `(0, 0)`, servant aussi de témoin pour isoler les piliers).
  - `bruts/gouttes_ronds_poses.png` (`1024 × 1024`) : planche sur `#FF00FF` de gouttes d'eau, impacts, éclaboussures et ronds d'onde concentriques.
- **Segmentation et réduction** : segmentation en pleine résolution (`1200 × 896`), réduction uniforme par classe (`down_class`, `×576/896`, recadrage centré à `768 × 576`), quantification par groupes de matières (`terrain` 96 couleurs, `roche` 64 couleurs).

## Calques et animations (boucle 120 ticks = 2 s)

1. `00_eau` — Lac souterrain animé façon rivière Métano aux **3 couleurs d'eau exactes** de `D15P41A.png` sans liseré clair (`4 × 10 = 40` ticks).
2. `01_lueur` — Lueur bioluminescente du lac animée aux **9 couleurs cyan-turquoise exactes** de `D15P41A.png` (cœur + 8 anneaux qui respirent, `12 × 10 = 120` ticks).
3. `02_scintillements` — Scintillements natifs `Metano_Town_River_Sparkles.tile` sur le cœur de la lueur (`4 × 10 = 40` ticks).
4. `03_gouttes` — Gouttes d'eau tombant du plafond de la caverne et ronds d'onde concentriques sur le lac (`24 × 5 = 120` ticks).
5. `04_sol_complet` — Fond de sable et parois complet sous les calques terrestres.
6. `05_sable` — Sable jaune pâle praticable du couloir sud et du promontoire central.
7. `06_ombres` — Bande de sable assombrie au pied des parois.
8. `07_berge` — Rebord rocheux entre le promontoire de sable et le lac.
9. `08_roche` — Parois bosselées olive-kaki de la caverne.
10. `09_piliers` — Grands piliers cylindriques et stalagmites dressés dans le lac.
11. `10 Vos elements avant-plan (Top)` — Calque `Top` (`Layer = 4`) vide dans le Ground PMDO.

## Commandes

```bash
.venv/bin/python source/fin_underground_lake_sanctuaire_v1/build.py
.venv/bin/python -m unittest source.fin_underground_lake_sanctuaire_v1.test_build -v
.venv/bin/python source/fin_underground_lake_sanctuaire_v1/package.py
```

Statut : art généré référencé, `art_approved = false`, `runtime_tested = false`.
