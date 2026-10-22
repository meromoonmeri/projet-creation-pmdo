# Séparation runtime — Sinister Woods / Relic Forest

**État : `SEPARATED` pour le câblage des blobs**
**Point de référence : `c3ba0185ff3ea5bc0ad67edf0b3cc5e2928f09ee`**
**Preuve machine :** `SINISTER_WOODS_RELIC_FOREST_SEPARATION_2026-08-18.json`

## Conclusion

`gloomy_forest` chargeait effectivement du contenu Relic Forest par erreur. Ce
n'était pas une dépendance PMD Red nécessaire : les trois étapes
`LoadBlobStep` des segments procéduraux 0, 1 et 3 étaient la même étape clonée
que celle de `relic_forest`, avec le même stencil, la même quantité `2..4`, les
mêmes six maps et les mêmes poids.

Le même héritage de template avait aussi laissé trois
`ScriptZoneStep.Script = ReverseRelicForest` dans `gloomy_forest`. Ce script ne
charge pas une map, mais appelle `RelicForestFlipStairs` et consulte les flags
`SV.Chapter1` de la progression Relic Forest. Il n'a donc pas sa place dans le
portage Sinister Woods.

La correction retire uniquement, dans `Data/Zone/gloomy_forest.json` :

- 3 `LoadBlobStep` (segments 0, 1 et 3), soit 18 références de blobs ;
- 3 `ReverseRelicForest` (segments 0, 1 et 3).

Aucun fichier blob, aucune tuile blob, aucun Ground D04P01/D04P02 et aucun
script global Relic Forest n'a été supprimé ou remplacé.

## Inventaire avant / après

| Zone | `LoadBlobStep` avant | blobs avant | `LoadBlobStep` après | blobs après | `ReverseRelicForest` après |
|---|---:|---:|---:|---:|---:|
| `gloomy_forest` / Sinister Woods | 3 | 18 | **0** | **0** | **0** |
| `relic_forest` / Forêt des Reliques | 5 | 30 | 5 | 30 | 1 |

La comparaison structurelle de l'étape clonée est verrouillée par le hash
normalisé :

```text
b12dae34924ad092e0f62bcc54fab71247b9b105fd12e20e9876479218837c23
```

Ce hash est identique aux cinq étapes propriétaires de `relic_forest` et aux
étapes retirées de `gloomy_forest`. Cela établit l'origine par clonage du
squelette PMDO, plutôt qu'une nécessité du générateur Sinister Woods.

## Dépendances transitives conservées

Les six identifiants restent résolus par `relic_forest` et sont donc conservés
:

- `relic_forest_blob_broken_pillar`
- `relic_forest_blob_fallen_left`
- `relic_forest_blob_fallen_right`
- `relic_forest_blob_pillar`
- `relic_forest_blob_rubble`
- `relic_forest_blob_ruins`

Pour chacun, l'audit vérifie :

1. `Data/Map/<id>.rsmap` présent et hashé ;
2. copie `RESERVE/maps/<id>.rsmap` présente et identique ;
3. `AssetName`/`Sheet` du `.rsmap` résolu vers
   `Content/Tile/Relic_Forest_Blob_*.tile` ;
4. tuile présente ;
5. référence transitive `treeshroud_forest_1_floor` enregistrée dans le
   `.rsmap` comme terrain sous-jacent.

La provenance des six maps est le commit PMDO/New Era
`55860b9a5eb48697a3cea3a8bdfce5f0529d6141`; les hashes exacts et les chemins
sont dans le manifeste JSON. La régression dédiée confirme que Relic Forest
résout les six maps et génère réellement son étage 0.

Point important pour l'étape graphique suivante : le matériau Treeshroud est
partagé par `relic_forest`, par les blobs et par d'autres assets New Era. Le
futur matériau procédural ROM **b41** ne doit donc pas être installé sous ce
nom partagé sans une décision de découplage documentée. La séparation des
zones est maintenant établie ; elle ne constitue pas encore la certification
graphique b41 de Sinister Woods.

Les trois fichiers de conversion dans `external/BIBLIOTHEQUE_WORKSPACE` qui
mentionnent ces blobs restent des bibliothèques de conversion non chargées par
le runtime de ce dépôt. Ils n'ont pas été modifiés.

## Validation statique

Commandes exécutées :

```bash
python3 tools/audit_sinister_woods_relic_forest_separation.py \
  --expect-separated \
  --output docs/pmdred_eu/narrative_audit/SINISTER_WOODS_RELIC_FOREST_SEPARATION_2026-08-18.json
python3 tools/test_relic_forest_blob_dependencies.py
python3 tools/audit_gloomy_forest_23f.py
python3 tools/verify_zone_index.py
```

Résultats :

- manifeste de séparation : `SEPARATED` ;
- 7/7 checks de séparation/transitivité : `PASS` ;
- régression blobs : `5 tests, OK` ;
- progression Sinister Woods : `15 + 5 + 3`, `PASS` ;
- index des zones ciblées : `PASS`.

La gate PMD Red globale reste volontairement bloquée par deux éléments
indépendants : le matériau procédural Treeshroud non équivalent au ROM b41 et
le composant runtime `deep_shadow` du segment 3. Ce dernier est déjà consigné
dans l'audit matériau ; cette correction de câblage ne l'a ni inventé ni
masqué.

## Validation runtime PMDO

La fixture ignorée contrôlée a remplacé sa copie de Zone par la Zone corrigée
et a parcouru les segments 0 et 1, étage 0 :

| segment | dimensions | probes libres | probes bloquées | musique |
|---:|---:|---:|---:|---|
| 0 | `38×51` | 3 | 1 | `Sinister Woods.ogg` |
| 1 | `51×38` | 4 | 0 | `Sinister Woods.ogg` |

Le runtime a atteint les deux `DungeonMapInit`, attaché l'équipe, écrit
l'événement terminal et s'est arrêté par `NORMAL_EXIT`, code `0`, sans
watchdog, processus résiduel, `Missing Data`, `Lua Trace` ou exception.

La régression Relic Forest séparée a ensuite résolu les six maps (`1×2`, `2×2`,
`2×2`, `1×3`, `1×1`, `4×3`) et généré son étage 0 (`25×38`) avec la même
terminaison PMDO normale.

Les détails et empreintes des journaux runtime ignorés sont conservés dans :
`SINISTER_WOODS_RELIC_FOREST_SEPARATION_RUNTIME_2026-08-18.json`.

## Portée non encore certifiée

Cette correction ne certifie pas encore :

- le remplacement du triplet Treeshroud par l'IR ROM b41 ;
- les palettes, CANM, AutoTiles et collisions du matériau b41 ;
- le runtime du segment 3 tant que `deep_shadow` n'a pas de preuve/source
  validée ;
- le portage narratif complet des 133 scènes PMD Red.
