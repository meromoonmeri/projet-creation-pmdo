# PMDO 0.8.12 — correction des erreurs du 12 août 2026

## Diagnostic causal

La première erreur utile du journal était la désérialisation de
`Data/Zone/spiritomb_room.json`. La métadonnée générique de
`FloorStairsStep` déclarait `TeamSpawner` et `MapGenEntrance` alors que PMDO
0.8.12 attend `MapGenEntrance` et `MapGenExit`.

La chaîne suivante était donc une seule régression :

1. `spiritomb_room.json` ne peut pas être désérialisé ;
2. `spiritomb_room` disparaît de l'index Zone ;
3. l'éditeur signale `Missing Data: spiritomb_room` ;
4. `DevTabTravelViewModel.ZoneChanged()` reçoit une Zone nulle et lève les deux
   `NullReferenceException` visibles dans le journal.

Le même générateur avait produit les mêmes métadonnées obsolètes dans six
Zones. L'inventaire complet est :

| Zone | `FloorStairsStep` | `DetectIsolatedStairsStep` | ancien stencil eau |
|---|---:|---:|---:|
| `chasm_cave` | 8 | 8 | 0 |
| `dark_hill` | 15 | 15 | 15 |
| `dusk_forest` | 8 | 8 | 8 |
| `sealed_ruin` | 8 | 8 | 8 |
| `sealed_ruin_pit` | 6 | 6 | 6 |
| `spiritomb_room` | 1 | 1 | 0 |
| **Total** | **46** | **46** | **37** |

`RogueElements.WaterTerrainStencil` n'existe pas non plus dans le runtime
qualifié. Il est migré vers le stencil PMDO 0.8.12 natif
`MapTerrainStencil<MapGenContext>` configuré sur le terrain mur, configuration
équivalente employée par `PerlinWaterStep` dans RogueElements.

La source de régénération `tools/gen_future_dungeons.py` a reçu les mêmes
corrections afin qu'une future exécution ne réintroduise pas ces types.

Le warning séparé venait de
`Data/Script/halcyon/services/debug_tools/init.lua` : la surcharge
`RegisterMonster(string)` perdait la forme et enregistrait toujours la forme
0. Le service passe désormais le `MonsterID` complet (`BaseForm`).

## Validation

`tools/run_pmdo_0812_zone_deserialization_repro.sh` construit une fixture
ignorée et isolée, copie localement les 57 JSON Zone, puis :

- indexe réellement toutes les Zones avec le binaire PMDO 0.8.12 qualifié ;
- refuse toute erreur de désérialisation ou d'import dans le journal moteur ;
- résout ensuite les six Zones avec `DataManager.GetZone`, y compris
  `spiritomb_room` ;
- exige l'arrêt natif PMDO avec code 0 et l'absence de processus résiduel ;
- réexécute le guard des données protégées.

Résultat observé :

```text
PMDO_TERMINATION_GATE_PASS kind=NORMAL_EXIT returncode=0 signal=None terminal=True graceful=True watchdog=False residual=0
PMDO_0812_ZONE_DESERIALIZATION_REPRODUCTION_PASS
```

`tools/run_new_game_startup_regression.sh` a également été rejoué depuis le
vrai titre. Le parcours normal `personality_test` → `relic_forest` passe avec
95 événements, et le journal PMDO ne contient plus le warning
`RegisterMonster(string) only registers form 0`.

Le test statique `tools/test_pmdo_0812_log_regressions.py` interdit le retour
des trois signatures obsolètes, verrouille l'inventaire 46/46/37, contrôle la
source du générateur et la surcharge `RegisterMonster(MonsterID)`.

## Invariants préservés

Le guard final conserve : 99 fichiers chapitres 1–5, 27 routes FugitiveArc,
438 fichiers Ground/tile immuables et 219 Grounds qualifiés. Aucun Ground,
tile, chapitre 1–5 ou route protégée n'a été modifié.
