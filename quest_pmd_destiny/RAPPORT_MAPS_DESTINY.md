# Récupération des maps des aperçus dans la quest

Généré le 2026-10-27 par `OUTILS/construire_maps_destiny.py`.

- Scripts de build exécutés : **99** (98 OK, 1 échecs).
- Maps récoltées et clampees : **6** (3 lots).
- Maps présentes dans `quest_pmd_destiny/Data/Ground/` : **262**.

## Échecs de build (maps non récupérées)

- `source/zone_zero_v1/build.py` : /home/user/projet-creation-pmdo/.venv/bin/python: can't open file '/tmp/destiny-src/source/zone_zero_v1/build.py': [Errno 2] No such file or directory

## Provenance

Les maps sont régénérées par les scripts `source/**/build.py` de la branche `arena/e39626d2` (méthode documentée dans chaque `renders/<lot>/manifest.json`). Les images de référence servant aux builds restent hors du dépôt et ne sont pas distribuées. `art_approved: false` / `runtime_tested: false` restent la règle.

## Couverture des aperçus — bilan

- **126 maps ZIP + 39 maps de branches + 97 maps régénérées = 262 maps dans la
  quest.** Toutes les maps présentées dans les aperçus et visionneuses
  récupérables automatiquement y sont.
- Les 13 stubs en liens symboliques sont **remplacés par leurs vraies maps**.
- **27 lots d'aperçu sans script de build** : ce sont pour l'essentiel des
  études/prototypes (études d'animations, calques, galeries de sprites) sans
  map à récupérer ; quelques versions intermédiaires (`entree_vapeur_sud_nord_v1`,
  `crooked_statique_v2`, `falaise_metano_temoin`, `mod_guilde_entrees_v1`,
  `northern_calques_v1`) ont leurs maps finales couvertes par d'autres lots ou
  versions déjà dans la quest. Non régénérables en l'état (scripts absents).
- **2 maps WaterfallVillage de town02** (`WaterfallVillageCapital` 233 Mo,
  `waterfall_cave_1`) : stockées en **Git LFS**, l'hébergeur LFS n'est pas
  joignable depuis le sandbox. Script prêt : `OUTILS/integrer_waterfall_town02.py`
  (à lancer depuis un clone local de town02 après `git lfs pull`).
