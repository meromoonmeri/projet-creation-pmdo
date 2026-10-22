# PMDO 0.8.12 — dépendances `LoadBlobStep` de Relic Forest

## Cause

`Data/Zone/relic_forest.json` et `Data/Zone/gloomy_forest.json` référencent six
Maps de décor dans leurs étapes `LoadBlobStep` :

- `relic_forest_blob_broken_pillar` ;
- `relic_forest_blob_fallen_left` ;
- `relic_forest_blob_fallen_right` ;
- `relic_forest_blob_pillar` ;
- `relic_forest_blob_rubble` ;
- `relic_forest_blob_ruins`.

Les six références étaient présentes, ainsi que leurs tilesheets
`Content/Tile/Relic_Forest_Blob_*.tile`, mais les six fichiers
`Data/Map/relic_forest_blob_*.rsmap` avaient été omis lors de la promotion qui
a introduit `relic_forest.json`. Le choix du blob étant aléatoire, restaurer
uniquement `broken_pillar`, premier nom observé dans le journal, aurait reporté
l'erreur sur l'un des cinq autres fichiers.

## Correction

Les six Maps ont été restaurées byte pour byte depuis leur source historique,
le commit `55860b9a5eb48697a3cea3a8bdfce5f0529d6141`. Aucun Ground, tilesheet, fichier
Zone ou script narratif n'a été reconstruit ou modifié.

Les deux messages de démarrage contenant un tiret Unicode ont aussi été rendus
ASCII (`--`) afin d'éviter l'affichage mojibake `ÔÇö`. La sonde NRE décrit
maintenant l'absence d'équipe pendant `DungeonModeBegin` comme la transition
normale précédant `DungeonMapInit`; l'équipe est bien attachée à l'événement
suivant.

`missingno` pendant `NewGame` reste la sentinelle interne normale du moteur. Il
n'est ni remplacé ni rendu visible : le sélecteur New Era installe ensuite la
véritable équipe.

## Validation réelle PMDO 0.8.12

`tools/run_relic_forest_blob_regression.sh` :

1. construit une fixture ignorée et isolée en conservant les assets source en
   lecture seule ;
2. indexe les 57 Zones avec le binaire PMDO 0.8.12 qualifié ;
3. désérialise explicitement les six Maps et contrôle leurs dimensions ;
4. lance une nouvelle sauvegarde de fixture et entre réellement dans
   `relic_forest`, segment 0, étage 0 ;
5. exige que la génération atteigne `DungeonMapInit` avec une carte et une
   équipe attachée ;
6. refuse `Missing Data`, `FileNotFoundException`, toute exception/Lua trace et
   le mojibake `ÔÇö` dans les journaux ;
7. exige un arrêt PMDO natif de code 0, sans processus résiduel.

Résultat :

```text
PMDO_TERMINATION_GATE_PASS kind=NORMAL_EXIT returncode=0 signal=None terminal=True graceful=True watchdog=False residual=0
RELIC_FOREST_BLOB_REGRESSION_REPRODUCTION_PASS
```

Le test `tools/test_relic_forest_blob_dependencies.py` verrouille les six hashes,
la résolution exhaustive de toutes les références `LoadBlobStep`, la présence
des tilesheets et les messages ASCII de la sonde.

Le guard final conserve 99 fichiers chapitres 1–5, 27 routes FugitiveArc, 438
fichiers Ground/tile immuables et 219 Grounds qualifiés.
