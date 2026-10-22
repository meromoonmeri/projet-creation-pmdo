# b41 CANM — adaptation one-shot PMDO validée en staging

**Statut : `STAGED + VALIDATED + RUNTIME_TESTED` ; promotion toujours
interdite par la séparation des consommateurs partagés.**

Preuve :
`SINISTER_WOODS_B41_STARTUP_ADAPTER_RUNTIME_2026-08-19.json`.

## Pourquoi cette adaptation était nécessaire

Le GBA conserve la palette brute dans les slots CANM pendant le premier délai
puis publie la couleur 0 de chaque record. `TileLayer` PMDO boucle ses frames et
ne fournit pas de frame one-shot. Le candidat b41 v3 contient donc :

- le frame brut initial ;
- les 16 états CANM publiés ;
- un overlay indépendant par record, avec sa propre durée 12 ou 8 ticks.

L'adaptateur staging parcourt les 47 codes AutoTile et leurs trois variantes,
restaure le frame brut à chaque `DungeonMapInit`, puis, après les délais source,
retire le frame brut et fait tourner la liste vers `[couleur15, couleur0, …,
couleur14]`. Avec l'horloge PMDO courante, cela rend la couleur 0 à l'instant
exact de la première publication, puis conserve le cycle steady-state sans
réintroduire le frame brut.

## Preuve runtime PMDO 0.8.12

La fixture isolée a chargé le candidat v3 et l'adaptateur. Pour chacun des trois
étages testés, les logs montrent :

- début à l'horloge `0`, `3000`, `6000` ;
- restauration de `2 001` couches après le premier étage ;
- publication de `405` couches à durée `8` ;
- publication de `1 596` couches à durée `12` ;
- mêmes deux publications à chaque nouvel étage ;
- aucune erreur de désérialisation, exception, `Lua Trace` ou `Missing Data` ;
- `NORMAL_EXIT`, code `0`, aucun watchdog ni processus résiduel.

Les contrôles indépendants b41 restent au vert : **2 001 contrôles de couches**
et **32 016 contrôles pixels**.

## Blocage de promotion restant

L'audit des noms partagés démontre que `treeshroud_forest_1_*` et
`TreeshroudForest1` ne sont pas propriétaires de Sinister Woods :

- `relic_forest` utilise les trois AutoTiles sur cinq étages ;
- les six `relic_forest_blob_*.rsmap` utilisent transitivement le floor ;
- `gloomy_forest_miniboss`, `verdant_oath_arena` et leurs Grounds utilisent
  encore le wall/floor.

Remplacer globalement ces quatre noms par b41 casserait donc la séparation et
modifierait indirectement Relic Forest, ce qui est interdit. Aucun blob, Ground
D04P01/D04P02 ou asset partagé n'a été modifié.

Verdict :

```text
BLOCKED_WITH_EXACT_MISSING_COMPONENT
SHARED_TREESHROUD_CONSUMERS_REQUIRE_DECOUPLING_BEFORE_PROMOTION
```

La route sûre est maintenant explicite : donner à Sinister Woods un namespace
b41 unique et valider le changement de ses trois `MapTextureStep`, ou découpler
indépendamment tous les consommateurs non Sinister. La première option est la
plus sûre ; elle doit être réalisée sans toucher aux six blobs Relic Forest,
puis rejouée avec la régression Relic séparée avant toute promotion.
