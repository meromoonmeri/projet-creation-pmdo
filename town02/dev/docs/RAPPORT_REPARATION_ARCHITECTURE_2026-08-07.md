# Rapport de réparation architecture — lot existant Ch5–Ch11

Branche source : `arena/019fd882-new-era-abyss-to-ascension-v4`  
Commit audité : `105508117353be08db21c09bd1becaa1328a50f8`  
Nature : corrections statiques, sans validation en jeu.

## Corrections appliquées

### Index de zones

`Data/Zone/index.idx` a été resynchronisé selon `ZoneData.GenerateEntrySummary()` de RogueEssence :

- `Grounds` depuis `GroundMaps` ;
- `Maps` depuis les IDs réels de chaque segment ;
- `CountedFloors` comme somme des `FloorCount` des segments `IsRelevant`.

Les sept divergences précédentes (`cloven_ruins`, `crooked_cavern`, `desert_oublies`, `poisonous_forest`, `sky_tower`, `toundra_desolee`, `waterfall_pond`) sont corrigées.

### Transitions fragiles de master_zone

Remplacement des index codés en dur par une résolution symbolique `GROUND_IDX(...)` dans les flux suivants :

- `searing_tunnel` : entrée, midpoint et creuset ;
- `mount_windswept` : entrée ;
- `vast_steppe` : entrée et passage vers le Tunnel ;
- `crooked_cavern` : entrée et `crooked_den` ;
- `waterfall_pond` : retours Metano / ground actuellement associé.

Le menu de Metano utilise désormais des noms de grounds au lieu d’index. `waterfall_pond` n’est plus envoyé par erreur vers `sanctuaire_voeu` comme « entrée du Sanctuaire de Cristal » : en l’absence d’un véritable ground d’approche, le menu entre directement dans le donjon. Cela préserve le statut canonique de `sanctuaire_voeu` comme import PMD Red/Jirachi.

### Suppression complète du ground boss obsolète Ch6

- suppression de `Data/Ground/gloomy_forest_boss.rsground` ;
- suppression de son script Ground ;
- retrait de `gloomy_forest.GroundMaps` ;
- retrait de `master_zone.GroundMaps` ;
- retrait de l’entrée SceneDebug ;
- transitions remplacées par `ContinueDungeon('gloomy_forest', 4, ...)` vers l’arène `.rsmap` intégrée.

`Data/Map/gloomy_forest_boss.rsmap` reste la véritable arène de combat.

### Validateur principal

`tools/validate_all.py` :

- coordonnées Tornadus resynchronisées sur le ground et le script actuels ;
- distinction entre grounds cinématiques et arènes `.rsmap` ;
- contrôle de présence, lisibilité JSON et cohérence `AssetName` des arènes Ch8–Ch10.

Le validateur ne plante plus et termine au vert.

## Validations obtenues

- `python3 tools/validate_all.py` : **OK** ;
- `python3 tools/verify_zone_index.py --all` : **0 incohérence** ;
- `python3 tools/audit_grounds_correlation.py` : **0 bloquant** ;
- `git diff --check` : **OK**.

## Éléments volontairement non falsifiés

Cette réparation ne prétend pas terminer les chapitres 12–32 : ils ne sont pas implémentés dans le dépôt. Aucun faux `SV.Chapter12..32`, aucune zone vide et aucun donjon factice n’ont été créés.

Restent à arbitrer/tester en jeu :

1. les contenus sérialisés des arènes Ch8/Ch9, qui semblent issus de gabarits mal recastés ;
2. la fonction exacte de `sanctuaire_voeu.rsmap` encore utilisée comme arène Ch8 dans la zone, malgré sa provenance Jirachi documentée — sa suppression de ce segment exige une nouvelle arène Diancie authentique ;
3. les cinématiques et branches victoire/défaite après passage direct aux `.rsmap` ;
4. `VeilleurArc` / `LegendArc` / `FriendAreaUtils` ;
5. les anomalies historiques hors périmètre Ch5–11 et les réserves pmd-red, conservées volontairement.

## Test runtime obligatoire

Avant fusion :

- Ch5 : Steppe → Tunnel → Creuset → Mont Venteux ;
- Ch6 : profondeur → arène Zeraora → victoire/défaite/retry ;
- Ch7 : chaque boucle Zarbi et Regigigas ;
- Ch8–10 : entrée, relais, mini-boss, boss, défaite et retour ;
- menu Metano pour chaque donjon d’histoire.
