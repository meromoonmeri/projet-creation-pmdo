# Zone « Exploration des cartes » (mode développeur)

Zone de prévisualisation : `Data/Zone/exploration_cartes.json`, déclarée dans `Data/Zone/index.idx`.
Elle liste les **108 maps `Data/Ground`** sans aucune transition ni script de progression.
Créée par `OUTILS/creer_zone_exploration_cartes.py`.

## Testé dans PMDO 0.8.12.0 (headless, binaire officiel, cache disposable)

| Test | Résultat |
|---|---|
| `DataManager.Instance:GetZone("exploration_cartes")` | PASS, zone trouvée, 108 `GroundMaps` |
| `DataManager.Instance:GetGround(n)` pour les 108 maps | **108/108 PASS** (`source/pmdo_runtime/`, voir `exploration_cartes_results.tsv`) |

Limites : aucun rendu graphique, aucun test du mode `-dev` / éditeur (le mode `-dev` a planté
nativement en code 139 dans cet environnement sans affichage), aucun déplacement dans les maps.

## Non vérifié

- 41 maps n'ont pas de `Data/Script/ground/<map>/init.lua` : le moteur les charge sans script,
  mais le comportement en jeu reste à confirmer manuellement.
- Les scripts déployés depuis les ZIP sont sous des espaces de noms autres que `destiny` et ne sont pas
  appelés par le moteur tant qu'ils ne sont pas rattachés à une zone.
