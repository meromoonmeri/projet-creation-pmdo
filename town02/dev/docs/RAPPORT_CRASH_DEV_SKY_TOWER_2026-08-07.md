# Rapport de crash Mod Dev — `sky_tower.json`

Date : 2026-08-07  
Preuve runtime : log utilisateur `2026-08-07.txt` (PMDO 0.8.12.0)

## Verdict

Le crash du formulaire Dev n’était pas causé en premier lieu par le déblocage Lua. La première exception réelle est la désérialisation de `Data/Zone/sky_tower.json` :

```text
System.ArgumentException: Spawn range must be 1 or higher.
at RogueElements.SpawnRangeList<T>.ICollection<SpawnRange>.Add(...)
```

Le message suivant `Missing Data: sky_tower`, puis le `NullReferenceException` dans `DevTabTravelViewModel.ZoneChanged`, sont des conséquences : la zone a échoué à charger, l’éditeur essaie ensuite de sélectionner son entrée d’index devenue sans objet.

Cette séquence apparaît à répétition dans le log, notamment vers 00:23, 00:29, 00:50, 01:12, 11:30 et 13:43.

## Cause exacte dans le JSON

Les trois `TeamSpawnZoneStep` des segments procéduraux de Sky Tower contenaient 30 entrées dans `Spawns` de la forme :

```json
{
  "Rate": 10,
  "Spawn": { ... }
}
```

Or `TeamSpawnZoneStep.Spawns` est un `RogueElements.SpawnRangeList<TeamMemberSpawn>`. Chaque entrée doit obligatoirement contenir :

```json
"Range": { "Min": ..., "Max": ... }
```

Lors de l’ajout par Newtonsoft, le champ absent devenait la plage par défaut `[0,0[`, de longueur zéro. `SpawnRangeList.Add` la refuse explicitement.

Référence moteur vérifiée : `RogueElements/Rand/SpawnRangeList.cs`, qui lève l’exception lorsque `range.Range.Length <= 0`.

## Correctif

Ajout des plages manquantes aux 30 entrées :

- segment 0 : `Min=0`, `Max=25` ;
- segment 2 : `Min=0`, `Max=9` ;
- segment 4 : `Min=0`, `Max=4`.

Les bornes correspondent exactement aux `RangeDictSegment.Floors` de chaque segment.

## Garde-fou exhaustif

Nouveau script :

```bash
python3 tools/audit_spawn_ranges.py
```

Il lit les classes connues contenant des `SpawnRangeList` :

- `TeamSpawnZoneStep` ;
- `ItemSpawnZoneStep` ;
- `TileSpawnZoneStep` ;
- `SpreadStepRangeZoneStep` ;
- `SpreadBossZoneStep` ;
- `SpreadHouseZoneStep` ;
- `SpreadVaultZoneStep`.

Résultat après correction : **3 467 entrées contrôlées, 0 erreur**.

## Erreurs secondaires du même log

Le log montre également sur `carrefour_assemblee` :

```text
SpawnerSetSpawn(TEAMMATE_1): Couldn't find spawner!
SpawnerDoSpawn(TEAMMATE_1): Couldn't find spawner!
```

Le Ground appelait `COMMON.RespawnAllies(true)` sans spawner `TEAMMATE_1`; son unique spawner `PARTNER_SPAWN` était en plus hors carte `(516,-7)` pour une carte de 432 px de large.

Correction :

- `PARTNER_SPAWN` replacé en `(208,392)` ;
- spawner `TEAMMATE_1` ajouté en `(192,392)`.

Cette erreur était non fatale dans le log, mais interrompait l’apparition du partenaire et polluait le diagnostic.

## Validation runtime attendue

Après mise à jour du mod :

1. ouvrir le Mod Dev ;
2. recharger les données Zone ;
3. vérifier que `sky_tower` apparaît dans Travel sans exception ;
4. sélectionner Sky Tower et ses segments ;
5. visiter `carrefour_assemblee` et confirmer l’apparition du partenaire.

Si le formulaire conserve une ancienne zone invalide en mémoire, fermer complètement PMDO puis relancer après remplacement des fichiers du mod.
