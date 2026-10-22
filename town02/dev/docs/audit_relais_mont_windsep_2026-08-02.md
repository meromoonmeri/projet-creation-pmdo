# Audit exhaustif — écran noir à l'arrivée au relais du Mont Windsep

**Branche :** `arena/019fad83-new-era-abyss-to-ascension-v4`
**HEAD audité :** `ee06be8`
**Date :** 2026-08-02
**Statut :** correctif appliqué et validé statiquement ; test manette en main impossible dans le sandbox.

## 1. Diagnostic exécutif

Le problème venait de deux défauts dans la même chaîne :

1. **Résumé de zone désynchronisé dans `Data/Zone/index.idx`.**
   `mount_windswept.json` contient désormais trois segments : première moitié,
   seconde moitié et arène finale. Le résumé `index.idx` conservait l'ancien
   découpage à quatre entrées et les anciens IDs de floors. Ce résumé est lu par
   le moteur avant le JSON complet pour valider les `SegLoc` (`GameManager.MoveToZone`
   et `ZoneEntrySummary.SegLocValid`). C'était une régression introduite par les
   suppressions/recalages de segments des commits `e8ca019`, `93a191d` et
   `19f9341` sans resynchronisation complète de l'index.

2. **La première scène du relais relançait une transition vers la même GroundMap
   depuis son callback `Enter`.**
   Après le fondu noir final, `FirstArrival()` appelait
   `GAME:EnterGroundMap("mount_windswept_midpoint", ...)` alors que le moteur était
   encore dans `GroundMap.OnEnter`/`BeginGround`. Une nouvelle chaîne `SceneOutcome`
   était donc armée depuis une transition déjà en cours. En cas d'erreur ou de
   désynchronisation de l'installation, le fondu noir restait actif et le joueur
   n'avait aucun chemin de reprise.

Le correctif supprime cette transition imbriquée : la mise en place finale est
faite directement sur la carte déjà chargée, puis la caméra est rendue au joueur.
Un garde `pcall` autour du routeur du relais restaure aussi `CutsceneMode`, la
caméra et le fondu si une erreur Lua future survient.

## 2. Chaîne d'exécution vérifiée

```text
mount_windswept.ExitSegment(seg=0, Cleared)
  -> ReplayEnding.FollowsRoute('mount_windswept', 5)
  -> GAME:EnterGroundMap('mount_windswept_midpoint', 'Main_Entrance_Marker')
  -> GameManager.MoveToGround
  -> ZoneEntrySummary.GroundValid
  -> Zone.GroundMaps.FindIndex
  -> GroundMap.GetEntryPointIdx
  -> GroundScene.EnterGround
  -> GroundMap.OnInit
  -> mount_windswept_midpoint.Init
  -> GroundMap.OnEnter
  -> mount_windswept_midpoint.Enter
  -> PlotScripting
  -> FirstArrival / SetupGround
```

### Preuves de validité de la destination

- `mount_windswept.json` liste `mount_windswept_midpoint` dans `GroundMaps`.
- `index.idx` liste aussi `mount_windswept_midpoint` dans `Grounds`.
- `mount_windswept_midpoint.rsground` existe et se désérialise en JSON.
- `Main_Entrance_Marker` existe à `(836,384)`.
- La case du marqueur est libre (`Tags == 0`) et dans la composante accessible.
- La musique `Canyon Camp.ogg` existe.
- Le statut `blowing_wind` existe.
- Le script `init.lua` charge bien le module `_ch_5`.
- Tous les scripts Lua compilent avec Lupa.
- `fix_ground_serialization.py` ne trouve aucun `$values` orphelin,
  `Front` invalide ou `rand.s` dégénéré sur les grounds.

## 3. Désynchronisations d'index découvertes par l'audit

Le vérificateur ajouté est `tools/verify_zone_index.py`. Il reproduit la logique
utile de `ZoneData.GenerateEntrySummary` pour les quatre zones d'histoire dont la
segmentation a changé récemment.

| Zone | JSON actuel | Résumé ancien | Correction |
|---|---:|---:|---|
| `vast_steppe` | 3 segments | 4 listes `Maps` | listes recalées |
| `searing_tunnel` | 3 segments | 4 listes `Maps` | listes recalées |
| `mount_windswept` | 3 segments, ranges 10 + 5 + boss | 4 listes, ancien découpage 7 + 5 + boss | recalé |
| `gloomy_forest` | 11 segments + 4 grounds | 9 listes + 3 grounds | recalé |

L'audit général précédent de `verify_ground_registration.py` ne contrôlait que
les noms de GroundMaps, pas le nombre et les IDs des listes `Maps`. C'est pourquoi
la régression pouvait passer avec zéro anomalie bloquante.

## 4. Correctifs appliqués

### Index

`Data/Zone/index.idx` a été mis en cohérence avec les JSON courants pour les quatre
zones ci-dessus :

- `Maps` recalculés selon les ranges/floors actuels ;
- `Grounds` synchronisés avec `GroundMaps` ;
- `CountedFloors` recalculés pour les segments pertinents.

### Relais du Mont Windsep

`Data/Script/halcyon/ground/mount_windswept_midpoint/mount_windswept_midpoint_ch_5.lua`
:

- suppression de la seconde transition `EnterGroundMap` vers la même carte ;
- appel direct à `SetupGround()` après le fondu ;
- retour caméra joueur avec `GAME:MoveCamera(0, 0, 1, true)`.

`Data/Script/halcyon/ground/mount_windswept_midpoint/init.lua` :

- `Enter` et `GameLoad` passent par `PlotScriptingSafely()` ;
- en cas d'exception, l'erreur est journalisée avec le préfixe
  `[MOUNTAIN_MIDPOINT][ERROR]` ;
- le mode cinématique est désarmé, la caméra rendue au joueur et le fondu relevé.

### Régression sœur évitée

Le même self-reload existait dans la première arrivée du relais de la Grande
Steppe. Il a été remplacé par le même pattern local afin d'éviter que la même
classe de panne réapparaisse dans le relais précédent de l'expédition.

### Tag de build

Le tag présent était `2026-08-03-N`. Il a été incrémenté en `2026-08-03-O` dans
les trois fichiers exigés :

- `Data/Script/halcyon/main.lua`
- `Data/Script/halcyon/scriptvars.lua`
- `Data/Script/halcyon/ground/vast_steppe_midpoint/init.lua`

## 5. Tests exécutés

### Tests statiques

- Compilation Lupa de tous les `Data/Script/**/*.lua` : **OK**.
- `tools/verify_zone_index.py .` : **OK**, quatre zones synchronisées.
- `tools/validate_all.py .` : toutes les arènes présentes valides.
- `tools/verify_ground_registration.py .` : 0 erreur bloquante ; 91 avertissements
  de dette existante.
- `tools/verify_lua_globals.py .` : 0 fonction fantôme.
- `tools/verify_emotions.py .` : 0 émotion invalide.
- `tools/verify_cutscene_guard.py .` : 0 scène à risque détectée.
- `tools/verify_spawner_enabled.py .` : 0 spawner d'équipier désactivé.
- `tools/verify_legend.py .` : OK.
- `bash verify_new_era.sh` : **277 grounds, 525 tilesets, 133 musiques — OK**.
- `git diff --check` : aucune erreur de whitespace après nettoyage.

### Simulation Lua ciblée

Un test Lupa a exécuté le vrai code Lua du relais avec des stubs moteur :

- `mount_windswept.ExitSegment(seg=0, Cleared)` demande bien
  `GAME.EnterGroundMap('mount_windswept_midpoint', 'Main_Entrance_Marker')` ;
- `mount_windswept_midpoint.Init` + `Enter` + `FirstArrival` terminent sans erreur ;
- `SV.Chapter5.PlayedMountMidpointIntro` passe à `true` ;
- aucune transition `EnterGroundMap` récursive vers le relais n'est plus produite ;
- le fondu final est relevé et la caméra est rendue au joueur.

### Limite

Le sandbox ne contient pas l'exécutable RogueEssence ni le runtime complet du jeu.
Il est donc impossible d'affirmer qu'un test manette en main a été effectué. La
validation réelle doit encore couvrir :

1. nouvelle partie jusqu'au premier passage du segment 0 ;
2. reprise d'une sauvegarde faite au relais ;
3. retour volontaire par la sortie sud puis nouvelle montée ;
4. défaite au-delà du checkpoint et réveil au relais ;
5. progression vers les Crêtes puis l'arène finale ;
6. ancienne sauvegarde créée avec un ancien découpage de segments.
