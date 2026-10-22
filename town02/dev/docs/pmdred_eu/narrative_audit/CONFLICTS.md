# Conflits à résoudre explicitement

Aucun conflit de cette liste ne peut être résolu par écrasement. La résolution normale est un **namespace parallèle**, un alias, une route dédiée ou une décision humaine documentée.

## 1. Vingt-sept routes FugitiveArc actives

Classification principale des 27 scènes : **`CONFLIT`**.

| Étape | Ground New Era | Scène | Musique actuelle | Conflits principaux |
|---:|---|---|---|---|
| 1 | `a02p01` | `a02p01` | `Rising Fear.ogg` | active FugitiveArc route; preserve current New Era scene and flags |
| 2 | `a02p02` | `a02p02` | `Rising Fear.ogg` | active FugitiveArc route; preserve current New Era scene and flags |
| 3 | `a02p03` | `a02p03` | `Rising Fear.ogg` | active FugitiveArc route; preserve current New Era scene and flags |
| 4 | `a02p04` | `a02p04` | `Rising Fear.ogg` | active FugitiveArc route; preserve current New Era scene and flags |
| 5 | `grotte_lazuli_seuil` | `d08p01` | `Water Cave.ogg` | active FugitiveArc route; preserve current New Era scene and flags |
| 6 | `grotte_lazuli_fond` | `d08p02` | `Growing Anxiety.ogg` | active FugitiveArc route; preserve current New Era scene and flags |
| 7 | `mont_cendre_pied` | `d09p01` | `Treacherous Mountain.ogg` | active FugitiveArc route; preserve current New Era scene and flags |
| 8 | `d09p02` | `d09p02` | `Treacherous Mountain.ogg` | active FugitiveArc route; preserve current New Era scene and flags; one of 27 dungeon-backed relationships; keep separate from archive-backed Ground |
| 9 | `d09p03` | `d09p03` | `In the Depths of the Pit.ogg` | active FugitiveArc route; preserve current New Era scene and flags; one of 27 dungeon-backed relationships; keep separate from archive-backed Ground |
| 10 | `a03p01` | `a03p01` | `Glacial Path.ogg` | active FugitiveArc route; preserve current New Era scene and flags |
| 11 | `a03p02` | `a03p02` | `Snowbound Path.ogg` | active FugitiveArc route; preserve current New Era scene and flags |
| 12 | `a03p03` | `a03p03` | `Snowbound Path.ogg` | active FugitiveArc route; preserve current New Era scene and flags |
| 13 | `foret_givree_oree` | `d10p01` | `Snowbound Path.ogg` | active FugitiveArc route; preserve current New Era scene and flags |
| 14 | `d10p02` | `d10p02` | `Glacial Path.ogg` | active FugitiveArc route; preserve current New Era scene and flags; one of 27 dungeon-backed relationships; keep separate from archive-backed Ground |
| 15 | `d10p03` | `d10p03` | `In the Depths of the Pit.ogg` | active FugitiveArc route; preserve current New Era scene and flags; one of 27 dungeon-backed relationships; keep separate from archive-backed Ground |
| 16 | `mont_gele_pied` | `d11p01` | `Snowbound Path.ogg` | active FugitiveArc route; preserve current New Era scene and flags |
| 17 | `d11p02` | `d11p02` | `Snow Camp.ogg` | active FugitiveArc route; preserve current New Era scene and flags; one of 27 dungeon-backed relationships; keep separate from archive-backed Ground |
| 18 | `d11p03` | `d11p03` | `Mystifying Forest.ogg` | active FugitiveArc route; preserve current New Era scene and flags; one of 27 dungeon-backed relationships; keep separate from archive-backed Ground |
| 19 | `gorge_ardente_porte` | `d12p01` | `Enraged Caldera.ogg` | active FugitiveArc route; preserve current New Era scene and flags; EU graph needs dedicated decoder/interpreter before implementation |
| 20 | `gorge_ardente_coeur` | `d12p02` | `Enraged Caldera.ogg` | active FugitiveArc route; preserve current New Era scene and flags; one of 27 dungeon-backed relationships; keep separate from archive-backed Ground |
| 21 | `fosse_ardente` | `d12p04` | `In the Depths of the Pit.ogg` | active FugitiveArc route; preserve current New Era scene and flags; one of 27 dungeon-backed relationships; keep separate from archive-backed Ground |
| 22 | `arc_parvis_celeste` | `d13p01` | `Sky Tower.ogg` | active FugitiveArc route; preserve current New Era scene and flags; EU graph needs dedicated decoder/interpreter before implementation |
| 23 | `arc_palier_celeste` | `d13p02` | `Sky Tower.ogg` | active FugitiveArc route; preserve current New Era scene and flags; one of 27 dungeon-backed relationships; keep separate from archive-backed Ground |
| 24 | `arc_tour_ciel_sommet` | `d13p03` | `Sky Tower.ogg` | active FugitiveArc route; preserve current New Era scene and flags; one of 27 dungeon-backed relationships; keep separate from archive-backed Ground |
| 25 | `t01p01` | `t01p01` | `Treasure Town.ogg` | active FugitiveArc route; preserve current New Era scene and flags; EU graph needs dedicated decoder/interpreter before implementation |
| 26 | `a04p01` | `a04p01` | `At the End of the Day.ogg` | active FugitiveArc route; preserve current New Era scene and flags |
| 27 | `a05p03` | `a05p03` | `silence` | active FugitiveArc route; preserve current New Era scene and flags |

Conflits systémiques de cette route :

- le casting est centré sur le héros/partenaire New Era et remplace souvent les rôles PMD Red ;
- les dialogues littéraux de `FugitiveCinematics.lua` sont des réécritures, pas les textes français EU ;
- les positions, caméras, VFX, musiques et vitesses sont des adaptations non qualifiées ;
- `FugitiveArc.Play` avance au segment suivant après une exception : une scène PMD Red fidèle doit au contraire échouer sans masquer l’erreur ;
- les mêmes Grounds servent déjà la continuité New Era ; les scripts canoniques PMD Red doivent être appelables séparément ;
- les routes aliases (`grotte_lazuli_*`, `mont_cendre_pied`, `arc_*`, etc.) ne doivent pas être remplacées par les IDs techniques sans décision explicite.

**Résolution exigée :** conserver `SV.FugitiveArc`, `FugitiveCinematics` et leurs routes. Ajouter une campagne PMD Red EU distincte (`SV.PmdRedEuNarrative` ou équivalent), sans partage de compteur d’étape.

## 2. Chapitres 1–5 — périmètre intouchable

Les **99 fichiers explicitement identifiés** ci-dessous ont chacun la classification principale **`CONFLIT`** et ne doivent subir aucune réécriture, suppression, modification de flags, changement de destination ou injection automatique :

- `Data/Script/halcyon/ground/altere_pond/altere_pond_ch_1.lua`
- `Data/Script/halcyon/ground/altere_pond/altere_pond_ch_2.lua`
- `Data/Script/halcyon/ground/altere_pond/altere_pond_ch_3.lua`
- `Data/Script/halcyon/ground/altere_pond/altere_pond_ch_4.lua`
- `Data/Script/halcyon/ground/altere_pond/altere_pond_ch_5.lua`
- `Data/Script/halcyon/ground/apricorn_glade/apricorn_glade_ch_4.lua`
- `Data/Script/halcyon/ground/apricorn_grove_entrance/apricorn_grove_entrance_ch_4.lua`
- `Data/Script/halcyon/ground/cloven_ruins_entrance/cloven_ruins_entrance_ch_5.lua`
- `Data/Script/halcyon/ground/cloven_ruins_miniboss/cloven_ruins_miniboss_ch_5.lua`
- `Data/Script/halcyon/ground/crooked_cavern_entrance/crooked_cavern_entrance_ch_3.lua`
- `Data/Script/halcyon/ground/crooked_cavern_midpoint/crooked_cavern_midpoint_ch_3.lua`
- `Data/Script/halcyon/ground/crooked_den/crooked_den_ch_3.lua`
- `Data/Script/halcyon/ground/first_core_location/first_core_location_ch_3.lua`
- `Data/Script/halcyon/ground/guild_bottom_left_bedroom/guild_bottom_left_bedroom_ch_1.lua`
- `Data/Script/halcyon/ground/guild_bottom_right_bedroom/guild_bottom_right_bedroom_ch_3.lua`
- `Data/Script/halcyon/ground/guild_bottom_right_bedroom/guild_bottom_right_bedroom_ch_4.lua`
- `Data/Script/halcyon/ground/guild_dining_room/guild_dining_room_ch_1.lua`
- `Data/Script/halcyon/ground/guild_first_floor/guild_first_floor_ch_1.lua`
- `Data/Script/halcyon/ground/guild_guildmasters_room/guild_guildmasters_room_ch_1.lua`
- `Data/Script/halcyon/ground/guild_guildmasters_room/guild_guildmasters_room_ch_2.lua`
- `Data/Script/halcyon/ground/guild_guildmasters_room/guild_guildmasters_room_ch_3.lua`
- `Data/Script/halcyon/ground/guild_guildmasters_room/guild_guildmasters_room_ch_4.lua`
- `Data/Script/halcyon/ground/guild_guildmasters_room/guild_guildmasters_room_ch_5.lua`
- `Data/Script/halcyon/ground/guild_heros_room/guild_heros_room_ch_1.lua`
- `Data/Script/halcyon/ground/guild_heros_room/guild_heros_room_ch_2.lua`
- `Data/Script/halcyon/ground/guild_heros_room/guild_heros_room_ch_3.lua`
- `Data/Script/halcyon/ground/guild_heros_room/guild_heros_room_ch_4.lua`
- `Data/Script/halcyon/ground/guild_heros_room/guild_heros_room_ch_5.lua`
- `Data/Script/halcyon/ground/guild_second_floor/guild_second_floor_ch_1.lua`
- `Data/Script/halcyon/ground/guild_second_floor/guild_second_floor_ch_2.lua`
- `Data/Script/halcyon/ground/guild_second_floor/guild_second_floor_ch_3.lua`
- `Data/Script/halcyon/ground/guild_second_floor/guild_second_floor_ch_4.lua`
- `Data/Script/halcyon/ground/guild_second_floor/guild_second_floor_ch_5.lua`
- `Data/Script/halcyon/ground/guild_storage_hallway/guild_storage_hallway_ch_1.lua`
- `Data/Script/halcyon/ground/guild_third_floor_lobby/guild_third_floor_lobby_ch_1.lua`
- `Data/Script/halcyon/ground/guild_third_floor_lobby/guild_third_floor_lobby_ch_2.lua`
- `Data/Script/halcyon/ground/guild_third_floor_lobby/guild_third_floor_lobby_ch_3.lua`
- `Data/Script/halcyon/ground/guild_third_floor_lobby/guild_third_floor_lobby_ch_4.lua`
- `Data/Script/halcyon/ground/guild_third_floor_lobby/guild_third_floor_lobby_ch_5.lua`
- `Data/Script/halcyon/ground/guild_third_floor_lobby/guild_third_floor_lobby_ch_5_epilogue.lua`
- `Data/Script/halcyon/ground/guild_third_floor_lobby/guild_third_floor_lobby_ch_5_retour.lua`
- `Data/Script/halcyon/ground/guild_top_right_bedroom/guild_top_right_bedroom_ch_1.lua`
- `Data/Script/halcyon/ground/illuminant_riverbed_entrance/illuminant_riverbed_entrance_ch_2.lua`
- `Data/Script/halcyon/ground/ledian_dojo/ledian_dojo_ch_2.lua`
- `Data/Script/halcyon/ground/ledian_dojo/ledian_dojo_ch_3.lua`
- `Data/Script/halcyon/ground/ledian_dojo/ledian_dojo_ch_4.lua`
- `Data/Script/halcyon/ground/ledian_dojo/ledian_dojo_ch_5.lua`
- `Data/Script/halcyon/ground/luminous_spring/luminous_spring_ch_2.lua`
- `Data/Script/halcyon/ground/metano_altere_transition/metano_altere_transition_ch_1.lua`
- `Data/Script/halcyon/ground/metano_altere_transition/metano_altere_transition_ch_2.lua`
- `Data/Script/halcyon/ground/metano_cafe/metano_cafe_ch_3.lua`
- `Data/Script/halcyon/ground/metano_cafe/metano_cafe_ch_4.lua`
- `Data/Script/halcyon/ground/metano_cafe/metano_cafe_ch_5.lua`
- `Data/Script/halcyon/ground/metano_cave/metano_cave_ch_2.lua`
- `Data/Script/halcyon/ground/metano_cave/metano_cave_ch_3.lua`
- `Data/Script/halcyon/ground/metano_cave/metano_cave_ch_4.lua`
- `Data/Script/halcyon/ground/metano_electric_home/metano_electric_home_ch_2.lua`
- `Data/Script/halcyon/ground/metano_electric_home/metano_electric_home_ch_3.lua`
- `Data/Script/halcyon/ground/metano_electric_home/metano_electric_home_ch_4.lua`
- `Data/Script/halcyon/ground/metano_electric_home/metano_electric_home_ch_5.lua`
- `Data/Script/halcyon/ground/metano_fire_home/metano_fire_home_ch_2.lua`
- `Data/Script/halcyon/ground/metano_fire_home/metano_fire_home_ch_3.lua`
- `Data/Script/halcyon/ground/metano_fire_home/metano_fire_home_ch_4.lua`
- `Data/Script/halcyon/ground/metano_fire_home/metano_fire_home_ch_5.lua`
- `Data/Script/halcyon/ground/metano_grass_home/metano_grass_home_ch_2.lua`
- `Data/Script/halcyon/ground/metano_grass_home/metano_grass_home_ch_3.lua`
- `Data/Script/halcyon/ground/metano_grass_home/metano_grass_home_ch_4.lua`
- `Data/Script/halcyon/ground/metano_inn/metano_inn_ch_2.lua`
- `Data/Script/halcyon/ground/metano_inn/metano_inn_ch_3.lua`
- `Data/Script/halcyon/ground/metano_inn/metano_inn_ch_4.lua`
- `Data/Script/halcyon/ground/metano_inn/metano_inn_ch_5.lua`
- `Data/Script/halcyon/ground/metano_normal_home/metano_normal_home_ch_2.lua`
- `Data/Script/halcyon/ground/metano_normal_home/metano_normal_home_ch_4.lua`
- `Data/Script/halcyon/ground/metano_normal_home/metano_normal_home_ch_5.lua`
- `Data/Script/halcyon/ground/metano_rock_home/metano_rock_home_ch_2.lua`
- `Data/Script/halcyon/ground/metano_rock_home/metano_rock_home_ch_3.lua`
- `Data/Script/halcyon/ground/metano_rock_home/metano_rock_home_ch_4.lua`
- `Data/Script/halcyon/ground/metano_town/metano_town_ch_1.lua`
- `Data/Script/halcyon/ground/metano_town/metano_town_ch_2.lua`
- `Data/Script/halcyon/ground/metano_town/metano_town_ch_3.lua`
- `Data/Script/halcyon/ground/metano_town/metano_town_ch_4.lua`
- `Data/Script/halcyon/ground/metano_town/metano_town_ch_5.lua`
- `Data/Script/halcyon/ground/metano_water_home/metano_water_home_ch_2.lua`
- `Data/Script/halcyon/ground/metano_water_home/metano_water_home_ch_3.lua`
- `Data/Script/halcyon/ground/metano_water_home/metano_water_home_ch_4.lua`
- `Data/Script/halcyon/ground/metano_water_home/metano_water_home_ch_5.lua`
- `Data/Script/halcyon/ground/mount_windswept_entrance/mount_windswept_entrance_ch_5.lua`
- `Data/Script/halcyon/ground/mount_windswept_guardian/mount_windswept_guardian_ch_5.lua`
- `Data/Script/halcyon/ground/mount_windswept_midpoint/mount_windswept_midpoint_ch_5.lua`
- `Data/Script/halcyon/ground/mount_windswept_miniboss/mount_windswept_miniboss_ch_5.lua`
- `Data/Script/halcyon/ground/relic_forest/relic_forest_ch_1.lua`
- `Data/Script/halcyon/ground/searing_crucible/searing_crucible_ch_5.lua`
- `Data/Script/halcyon/ground/searing_tunnel_entrance/searing_tunnel_entrance_ch_5.lua`
- `Data/Script/halcyon/ground/searing_tunnel_midpoint/searing_tunnel_midpoint_ch_5.lua`
- `Data/Script/halcyon/ground/searing_tunnel_miniboss/searing_tunnel_miniboss_ch_5.lua`
- `Data/Script/halcyon/ground/vast_steppe_entrance/vast_steppe_entrance_ch_5.lua`
- `Data/Script/halcyon/ground/vast_steppe_guardian/vast_steppe_guardian_ch_5.lua`
- `Data/Script/halcyon/ground/vast_steppe_midpoint/vast_steppe_midpoint_ch_5.lua`
- `Data/Script/halcyon/ground/vast_steppe_miniboss/vast_steppe_miniboss_ch_5.lua`

Cette liste explicite est un minimum : les modules partagés qu’elle appelle (`GeneralFunctions`, helpers de guilde, services de ville, sauvegarde) sont également protégés contre les changements incompatibles. La campagne PMD Red doit être testée sans modifier les hashes de ces 99 fichiers.

## 3. Conflits d’identité régionale

- `s06` est EU et absent des scènes New Era : il doit être ajouté, pas remplacé par `t01p06`.
- `t01p06` est une scène New Era/pret US hors inventaire EU : la conserver comme variante séparée.
- `t01p01`, `b01p01a`, `a05p02`, `d06p01`, `d07p02`, `d12p01`, `d13p01` ont un graphe EU divergent ou non fermé ; aucune génération depuis les seules déclarations US n’est autorisée.

## 4. Conflits Grounds et aliases

- Les **219 Grounds archive-backed** sont des entrées validées : scripts narratifs seulement, aucune retouche visuelle/géométrique.
- `h17p01_Base` historique reste utilisé par `pre_tonnerre`; la scène PMD Red doit référencer `h17p01_pmdred_Base` via le Ground déjà promu.
- `a03p01`, `a03p02`, `a03p03` utilisent des aliases PMD Red et conservent leurs tuiles historiques ; ne jamais recâbler les Grounds historiques.
- Les migrations `a02*`, `a03*`, `a04p01`, `a05p03` ont préservé les Markers/Spawners New Era. Une scène PMD Red doit distinguer entités persistantes et acteurs temporaires.

## 5. Conflits de casting et de continuité

Le port fidèle doit conserver le casting PMD Red dans les scènes canoniques. Les substitutions New Era (Team Dazzling pour Team Meanies, équipe contemporaine pour Team ACT, mémoire trente ans plus tard) restent valides uniquement dans les scènes New Era. Deux versions peuvent coexister :

1. **présent New Era**, inchangé ;
2. **restitution canonique PMD Red EU**, casting original et flags séparés.

Une fusion automatique des castings est interdite : elle altérerait à la fois le canon PMD Red et la continuité New Era.

## 6. Conflits audio/assets

Une musique New Era de même humeur ne remplace pas automatiquement le cue PMD Red. Toute substitution d’OST, SFX, portrait, animation, attaque ou VFX doit être une ligne `ADAPTÉ` avec comparaison et décision explicites.
