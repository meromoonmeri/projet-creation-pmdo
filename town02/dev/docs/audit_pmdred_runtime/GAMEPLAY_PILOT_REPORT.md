# Ground Gameplay Validator — pilote PMDO réel

Exécution : PMDO/PMDC 0.8.12 Linux x64, New Era chargé comme Quest, FNA3D OpenGL/llvmpipe offscreen, audio SDL dummy.

## Structures représentées

- `a02p01` : transition linéaire de l’Arc Fugitif.
- `mt_blaze_midpoint` : relais/checkpoint dans une ZoneData canonique.
- `mount_windswept_guardian` : Ground de boss avec équipe et caméra dédiée.
- `d11p03` : salle fixe précédemment isolée par flood-fill.
- `champ_vent_boreal` : Ground dungeon-backed nommé, sans script propre.

## Première exécution

Les cinq Grounds ont réellement été chargés. Le moteur a découvert deux défauts invisibles dans le précédent audit statique :

- `a02p01` : `TEAMMATE_2` et `TEAMMATE_3` manquants ; `SpawnerSetSpawn/SpawnerDoSpawn` levaient quatre exceptions.
- `d11p03` : `TEAMMATE_1`, `TEAMMATE_2`, `TEAMMATE_3` manquants ; six exceptions.
- `champ_vent_boreal` : aucun `Main_Entrance_Marker`, spawn moteur observé à `(0,0)`.
- les trois relais avaient été ajoutés aux ZoneData mais pas à `Data/Zone/index.idx`; ils étaient donc impossibles à adresser par index runtime.

## Corrections et rechargement

- spawners manquants ajoutés sur cellules libres vérifiées ;
- marqueurs canoniques Northwind Field restaurés ;
- entrées d’index des relais ajoutées aux zones `mt_blaze`, `frosty_forest`, `mt_freeze` ;
- les cinq Grounds ont été rechargés dans une seconde exécution.

Deuxième exécution :

- 5/5 `LOAD PASS` ;
- coordonnées de spawn moteur capturées ;
- 0 exception de spawner ;
- 0 erreur de Ground/Zone/index ;
- séquence complète `begin → cinq Grounds → end`.

## Limite du pilote

Les appels de déplacement forcé lancés dans le callback synchrone `GroundMapEnter` ne permettent pas d’observer le déplacement avant la transition suivante. Les quatre zéros de `move_dirs` sont donc **INCONCLUSIVE_SYNC_CONTEXT**, et non `SPAWN_ISOLATED`.

Aucun de ces Grounds n’est promu `RUNTIME_PASS` pour la mobilité, la caméra, les interactions ou les combats. Ils restent `MANUAL_REVIEW` sur ces colonnes jusqu’à la phase asynchrone suivante.
