# Récupération des maps des aperçus dans la quest

Généré le 2026-10-27 par `OUTILS/construire_maps_destiny.py`.

- Scripts de build exécutés : **99** (98 OK, 1 échecs).
- Maps récoltées et clampees : **6** (3 lots).
- Maps présentes dans `quest_pmd_destiny/Data/Ground/` : **262**.

## Échecs de build (maps non récupérées)

- `source/zone_zero_v1/build.py` : /home/user/projet-creation-pmdo/.venv/bin/python: can't open file '/tmp/destiny-src/source/zone_zero_v1/build.py': [Errno 2] No such file or directory

## Provenance

Les maps sont régénérées par les scripts `source/**/build.py` de la branche `arena/e39626d2` (méthode documentée dans chaque `renders/<lot>/manifest.json`). Les images de référence servant aux builds restent hors du dépôt et ne sont pas distribuées. `art_approved: false` / `runtime_tested: false` restent la règle.
