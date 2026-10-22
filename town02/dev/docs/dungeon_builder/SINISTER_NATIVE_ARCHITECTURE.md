# Sinister Woods — architecture native PMDO/RogueElements

## Statut

**MAP GENERATION RUNTIME VERIFIED — ROUTE RUNTIME STILL BLOCKED.**

Ce rapport ne certifie pas encore le trajet Ground → midpoint → D04P02 → combat
→ sortie. Il certifie que le candidat canonique (12 floors procéduraux + 1
segment fixe D04P02) est réellement chargé et généré par PMDO 0.8.12.

## Exécution réelle

Commande : `tools/runtime/run_engine_mapgen.sh` sur un miroir jetable contenant
le ZoneData candidat, le Ground canonique et son `.rsmap` pixel-exact.

- 10 seeds runtime par floor ;
- 12 floors procéduraux × 10 = 120 générations RogueElements ;
- D04P02 fixe × 10 = 10 chargements `LoadGen` ;
- total : **130/130** ;
- échecs moteur : **0** ;
- floors invalides : **0** ;
- escaliers inaccessibles : **0** ;
- cellules praticables isolées : **0**.

Les métriques proviennent de `result.RoomPlan` et `Map:TileBlocked` dans le
binaire PMDO, pas du simulateur Python.

## Profils réellement sélectionnés par la seed PMDO

| Profil | Générations | Rooms moy. | Halls moy. | Branches moy. | Culs-de-sac moy. | Boucles moy. | Grandes rooms moy. | Signatures distinctes |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| branching | 44 | 8,89 | 7,89 | 1,64 | 3,68 | 0,00 | 0,00 | 44 |
| looping | 39 | 7,33 | 18,21 | 2,51 | 0,38 | 2,18 | 0,00 | 39 |
| large_rooms | 37 | 15,51 | 16,57 | 4,78 | 5,08 | 1,54 | 6,51 | 37 |

Les comportements sont structurellement distincts :

- `branching` conserve l'arbre RogueElements (`ConnectPercent=0`) et ses
  terminaux ;
- `looping` utilise réellement `GridPathCircle`, donc un cycle n'est pas simulé
  par une métrique ;
- `large_rooms` utilise réellement `CombineGridRoomStep` avec le réglage validé
  sur une grille plus grande.

## Variation par floor

Chaque floor procédural a produit **10 signatures topologiques distinctes sur
10 seeds**. Tous les floors ont sélectionné au moins deux profils ; onze floors
sur douze ont sélectionné les trois profils. Le floor source SMALL (8F) est
volontairement limité à `branching` + `looping` et ne reçoit pas artificiellement
le profil `large_rooms`.

## Contenu runtime

Sur les 120 floors procéduraux :

- objets placés : 6–8 ;
- Pokémon placés : 2–7 ;
- `tile_wonder:3` : 120/120 ;
- DTEF : `sinister_woods_b41_floor` + `sinister_woods_b41_wall` ;
- floor final : 10/10 chargements, 3 boss canoniques présents.

## Floor final canonique

`Data/Map/gloomy_forest_boss.rsmap` est une représentation dungeon-mode de
`Data/Ground/sinister_woods_clearing.rsground` :

- Ground : 480×376 ;
- rsmap : 480×384 (8 px de padding noir transparent en bas) ;
- pixels différents dans la zone canonique : **0** ;
- pixels non noirs dans le padding : **0** ;
- boss : Gengar Lv15, Medicham Lv12, Ekans Lv15 (`PMD_RED_ROM`) ;
- moves et HP : `INFERRED`, explicitement marqués comme tels.

## Preuves

- `docs/dungeon_builder/runtime/sinister_canonical_candidate_runtime.jsonl` ;
- `docs/dungeon_builder/SINISTER_CANONICAL_CANDIDATE_RUNTIME.md` ;
- `docs/dungeon_builder/SINISTER_FINAL_STAGE_REPORT.json`.

## Blocage restant

Le validateur de route headless atteint et charge D04P01, mais la transition
pilotée depuis le service de validation reste suspendue dans le scheduler de
scène. Ce problème de harness ne doit pas être transformé en faux PASS. La zone
active `Data/Zone/gloomy_forest.json` n'est donc pas encore remplacée par le
candidat, et `batch_approved` reste faux.
