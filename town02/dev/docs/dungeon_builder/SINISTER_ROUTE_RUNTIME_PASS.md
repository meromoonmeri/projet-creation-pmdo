# Sinister Woods — validation PMDO active de bout en bout

_Date locale du run : 2026-08-23 — PMDO 0.8.12 headless, SDL offscreen, ANGLE/SwiftShader._

## Verdict

**ACTIVE ROUTE HARNESS PASS** pour l’artefact actif `Data/Zone/gloomy_forest.json`.

Le gate batch reste fermé (`batch_approved=false`) et les 50 autres définitions ne sont pas promues par ce résultat.

## Commandes réelles

```bash
PMDO_MAPGEN_MOD_SRC="$PWD" \
PMDO_MAPGEN_MOD_NAME=sinister-active-mapgen \
PMDO_MAPGEN_VALIDATOR_SPEC=gloomy_forest \
tools/runtime/run_engine_mapgen.sh \
  /tmp/sinister-runtime-candidate/runtime 10

PMDO_ROUTE_TIMEOUT=240 \
tools/runtime/run_sinister_route.sh \
  /tmp/sinister-runtime-candidate/runtime "$PWD"
```

## Résultats moteur

### Génération active

- 130 tentatives ;
- 130 cartes retournées ;
- 0 exception de génération ;
- 0 carte non traversable ;
- 0 carte topologiquement invalide ;
- 12 floors procéduraux × 10 seeds, plus D04P02 × 10 seeds ;
- contenu PMDO réel placé et seeds journalisées.

Preuve brute : `runtime/sinister_active_native_runtime.jsonl`.

### Route active

Grounds observés, dans l’ordre :

1. `bois_sombres_oree` (D04P01) ;
2. `gloomy_forest_midpoint` (checkpoint New Era explicitement `SUPPLEMENTAL`) ;
3. `sinister_woods_clearing` (D04P02) ;
4. `metano_town` (destination de fin).

Maps observées :

- segment 0, floors 0 à 5 ;
- segment 1, floors 0 à 5 ;
- segment 2, floor 0 (`LoadGen` de `gloomy_forest_boss`).

Chaque floor procédural possède un escalier localisé et une seed PMDO journalisée. D04P02 charge les trois boss canoniques et installe un `LuaCheckBossClearEvent` natif. La sortie du segment 2 exécute l’`EndGame` moteur, écrit `MissionComplete=true`, puis charge réellement Metano Town.

Preuves :

- `SINISTER_ROUTE_RUNTIME_PASS.json` ;
- `runtime/sinister_full_route_runtime.jsonl`.

## Correction runtime découverte

Le premier chargement de D04P02 échouait dans `Map.EnterMap` :

- `Tiles` : 20×16 ;
- ancien `DiscoveryArray` hérité du template : 15×18.

`tools/dungeon_builder/canonical_battle.py` reconstruit désormais `DiscoveryArray` aux dimensions exactes de `Tiles`. La map a été régénérée :

- pixels Ground différents : 0 ;
- pixels non noirs dans le padding : 0 ;
- hash map actif : `99032d873363343e18d7676ca5d45551145f644b199fb328dc957c4dff539bfa`.

## Adaptations strictement headless

Le harness ne modifie pas ces chemins en jeu normal. Sous `PMDO_SINISTER_ROUTE_VALIDATOR=1` seulement :

- les attentes de fondu visuel sont terminées immédiatement ;
- les floors 1–5 de chaque segment sont chargés par `GAME:EnterZone` après vérification de la présence de l’escalier ;
- 6F utilise le vrai `EndSegment` et le vrai `ExitSegment` ;
- le résultat boss `Cleared` est simulé après chargement des trois boss et vérification du hook de victoire natif ;
- l’itérateur `EndGame` moteur est exécuté jusqu’à son seul délai terminal de 20 frames ;
- la cinématique de ville hors périmètre est ignorée après le chargement réel de Metano Town.

Cette preuve valide la génération, les assets, les Grounds, les segments, les sorties et l’état de fin dans PMDO. Elle **ne prétend pas être un replay de commandes de combat joueur** contre Gengar, Medicham et Ekans.

## Artefacts liés

- zone active : `da71e8cd2ce64d6892a684e925da87f603b02bf9e235671bafed955bf47d9421` ;
- map D04P02 : `99032d873363343e18d7676ca5d45551145f644b199fb328dc957c4dff539bfa` ;
- rapport visuel : `SINISTER_FINAL_STAGE_REPORT.json`.
