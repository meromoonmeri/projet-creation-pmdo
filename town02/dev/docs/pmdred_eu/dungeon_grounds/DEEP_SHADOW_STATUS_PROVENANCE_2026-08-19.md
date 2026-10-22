# `deep_shadow` — provenance et reconstruction PMDO

**Statut : `GENERATED + VALIDATED + RUNTIME_TESTED` ; pas encore
`CERTIFIED` pour le portage graphique Sinister Woods.**

Preuve runtime :
`docs/pmdred_eu/dungeon_grounds/DEEP_SHADOW_RUNTIME_2026-08-19.json`.

## Constat d'audit

`Data/Zone/gloomy_forest.json` contient un
`PMDC.LevelGen.DefaultMapStatusStep` dont le `SetterID` est `deep_shadow` et
dont les choix sont `darkness` et `dusk`. Avant cette correction, aucune des
sources auditées ne contenait `Data/MapStatus/deep_shadow.json` :

- aucun fichier exact dans le checkout du projet ;
- aucun fichier exact dans l'arbre DumpAsset PMDO 0.8.12 restauré par le
  pipeline d'audit ; DumpAsset fournit les familles natives
  `default_weather` et `default_mapstatus`, mais pas `deep_shadow` ;
- aucun fichier exact retrouvé dans le travail des anciens agents/branches
  audités ;
- `gloomy_forest` était donc le seul consommateur de cet identifiant.

Le diagnostic runtime précédent était exact : `Missing Data: deep_shadow` à
`Data/Zone/gloomy_forest.json:6808`. Copier `darkness` ou `dusk` aurait été
incorrect : ces deux fichiers sont des effets visuels concrets, tandis que
`SetterID` doit désigner une famille qui contient `MapIDState`.

Le premier runtime après ajout du setter a ensuite révélé un second défaut de
sérialisation dans ses dépendances : `darkness.json` et `dusk.json` déclaraient
`OnMapRefresh: null`. PMDO parcourt cette collection lors de
`Map.RefreshTraits`; les deux valeurs ont donc été normalisées en tableaux
vides, sans ajouter d'effet ni changer l'overlay. Cette correction est
nécessaire au composant et est couverte par la validation dédiée.

## Autorité de format et sémantique

La source PMDC de `DefaultMapStatusStep` est verrouillée dans :

- PMDODump : commit
  `21ec4abdddf4f705c6e75a0635358d597c884f8c` ;
- sous-module PMDC : commit
  `6a368be5b2daa87a16b14885cc156c37eec7531f` ;
- fichier :
  `PMDC/PMDC/LevelGen/Floors/GenSteps/MapDataStep.cs` ;
- SHA-256 du fichier source :
  `993d2dd6d65ebd79e189e4c3fb361696c31f70c482bf969982e5036d45a1371e`.

La méthode `DefaultMapStatusStep.Apply` :

1. choisit une valeur de `DefaultMapStatus` ;
2. charge le MapStatus désigné par `SetterID` ;
3. récupère son `MapIDState` ;
4. écrit l'identifiant choisi dans ce `MapIDState` ;
5. ajoute le setter à la carte.

La `WeatherFillEvent` PMDC lit ensuite ce `MapIDState`, charge le statut
choisi et l'ajoute au début de la carte ou lors du remplissage de la météo.
Les deux choix actuels `darkness` et `dusk` portent déjà
`RogueEssence.Dungeon.MapWeatherState`; ils appartiennent donc à la famille
météo et exigent `WeatherFillEvent`, pas `MapStatusFillEvent`.

## Reconstruction effectuée

`Data/MapStatus/deep_shadow.json` est un **setter de famille**, pas une
recoloration et pas un nouvel effet graphique :

- `StatusStates` contient exactement un `MapIDState` vide ;
- `Emitter` est `EmptySwitchOffEmitter` ; aucune couleur, texture ou animation
  n'est ajoutée ;
- `RepeatMethod` suit la convention `default_weather` :
  `MapStatusReplaceEvent` ;
- `OnMapStarts[0]` et `OnMapTurnEnds[6]` utilisent
  `PMDC.Dungeon.WeatherFillEvent` ;
- les effets visuels réels restent exclusivement ceux des statuts sélectionnés
  `darkness`/`dusk` déjà déclarés dans le dépôt ;
- `Data/MapStatus/index.idx` déclare l'entrée et son nom français.

Ce composant est classé **`NEW_ERA_RUNTIME_ADAPTER`**. Il n'est pas présenté
comme une ressource extraite de la ROM PMD Red EU. La ROM autorise les données
de gameplay et de matériau Sinister Woods ; le nom `deep_shadow` est une
adaptation PMDO introduite par la zone actuelle. Sa reconstruction ferme
uniquement l'absence de type runtime, sans certifier que cette ambiance visuelle
est une donnée GBA canonique.

## Validation dédiée

```bash
python3 -m unittest tools.test_deep_shadow_mapstatus -v
python3 tools/verify_zone_index.py
python3 tools/build_sinister_woods_procedural_fixture.py \
  --output .runtime-cache/sinister-woods-procedural-fixture
# puis le gate PMDO 0.8.12 avec PMDO_SINISTER_WOODS_PROBE=1
```

La première commande vérifie le schéma, la famille `MapIDState`, les deux
événements `WeatherFillEvent`, les choix de zone, l'index et les hashes des
statuts visuels d'entrée. La seconde vérifie que l'index de zone reste
cohérent ; aucune map fixe D04P01/D04P02 ni aucun `relic_forest_blob_*` n'est
modifié.

Le runtime PMDO 0.8.12 a ensuite parcouru les segments procéduraux 0, 1 et 3 :
les dimensions observées sont `38×51`, `51×38` et `38×64`, la musique est
`Sinister Woods.ogg`, chaque map possède une sonde de collision libre et
bloquée, et le segment 3 installe le setter `deep_shadow` puis le statut visuel
choisi (`dusk` dans ce tirage). Le processus a terminé par `NORMAL_EXIT`, code
`0`, sans watchdog, résidu, `Missing Data`, `Exception Depth`, `Lua Trace` ou
`RUNTIME_FAIL`. Toute promotion graphique reste interdite tant que le candidat
matériau ROM b41 n'est pas validé séparément.
