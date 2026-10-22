# Zone de test — Arène de Tornadus (`tornadus_arena`)

Date : 2026-08-05. Demande auteur : *« test : une zone de combat pour
l'arène de Tornadus »* — un seul segment fixe, biome `craggy_peak`,
accès de test sans passer par l'histoire.

## Contenu

| Fichier | Rôle |
|---|---|
| `Data/Zone/tornadus_arena.json` | Zone 1 segment (`LayeredSegment` → `LoadGen` + `MappedRoomStep` → `MapID: mount_windswept_guardian`), ZoneSteps `SaveVarsZoneStep` + `FloorNameDropZoneStep` (patron de `mount_windswept` seg 2). Nom FR « Arène de Tornadus (TEST) ». Level -1, TeamSize -1, Rescues 0, Rogue 0 (style zones d'histoire). |
| `Data/Zone/index.idx` | Entrée `ZoneEntrySummary` insérée au style près (Newtonsoft) : `CountedFloors: 1`, `Maps: [[0]]`, `Grounds: []`. Lue par le moteur **avant** le JSON complet — sans elle : « Invalid Segment ID » / écran noir. |
| `Data/Script/halcyon/zone/tornadus_arena/init.lua` | Cycle de vie copié de `petit_tunnel` (`Init`, `EnterSegment`, `Rescued`, `ExitSegment`) ; sortie `EndDungeonRun(..., "master_zone", -1, 1, 0)` = retour Metano dans tous les cas (victoire, défaite, fuite). |
| `metano_town/init.lua` | `"tornadus_arena"` ajouté à la liste `dungeons` du menu de destinations. |
| `services/debug_tools/init.lua` | `GAME:UnlockDungeon("tornadus_arena")` (ligne commentée TEST, à retirer avant release). |

## Comment tester en jeu

1. Charger une sauvegarde (le service `debug_tools` débloque la zone au
   chargement/migration).
2. À Metano, ouvrir le **panneau des destinations** : « Arène de Tornadus
   (TEST) » en bas de liste (non complétée = bleue).
3. Entrer → le segment fixe charge l'arène `mount_windswept_guardian`
   (19×19, Tornadus lv33 au perchoir (9,5), équipe aux entrées (9,16)/(10,16)).
4. Fin de combat (gagné ou perdu) → retour automatique à Metano.

## Validation

- `tools/verify_zone_index.py --all` : **OK `tornadus_arena` : 1 segments,
  1 floors, Grounds synchronisés** ; les 4 zones d'histoire ciblées restent
  OK.
- Les 184 incohérences `--all` déjà présentes (crooked_cavern, zones
  purgées ch6-32…) sont **pré-existantes**, non liées.
- `tools/validate_all.py` : ✅ salles toutes valides (aucun changement de
  carte).
- JSON round-trip vérifié ; les 3 Lua modifiés/créés compilent (lupa).
- **Non testé en jeu** — c'est précisément l'objet de cette zone.

## Retrait avant release (5 points)

1. `Data/Zone/tornadus_arena.json`
2. entrée `tornadus_arena` dans `Data/Zone/index.idx`
3. `Data/Script/halcyon/zone/tornadus_arena/`
4. `"tornadus_arena"` dans la liste `dungeons` de `metano_town/init.lua`
5. ligne `UnlockDungeon` dans `services/debug_tools/init.lua`
