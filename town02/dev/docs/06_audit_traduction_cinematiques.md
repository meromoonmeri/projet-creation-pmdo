# Audit traduction — cinématiques et textes visibles

Date : 24 juillet 2026

## Résultat après la passe de finalisation

Le chapitre 5 a été relu sur ses scripts actifs de scènes, de camps, d'entrées de donjon et de dialogues secondaires.

- 18 scripts de scènes du chapitre 5 examinés ;
- 739 clés principales `MapStrings` référencées ;
- 739 versions françaises présentes ;
- 96 lignes de dialogues/voix codées directement en Lua traduites ;
- voix off du départ traduites ;
- objectifs de mission du chapitre 5 traduits ;
- textes de défaite de la Steppe et du Tunnel traduits ;
- noms français des trois zones principales et des étages ajoutés ;
- 80 clés de commentaires de personnalité d'expédition ajoutées dans `Strings/stringsEx.fr.resx`.

Les appels qui restent détectés par un simple grep correspondent à des textes français codés directement dans Lua, à des commentaires, à des noms de fonctions ou à des identifiants de ressources audio. Ils ne constituent pas des phrases anglaises visibles du chapitre 5.

## Fichiers de scènes relus

- `guild_guildmasters_room_ch_5.lua`
- `guild_heros_room_ch_5.lua`
- `guild_second_floor_ch_5.lua`
- `guild_third_floor_lobby_ch_5.lua`
- `metano_cafe_ch_5.lua`
- `metano_inn_ch_5.lua`
- `metano_normal_home_ch_5.lua`
- `metano_town_ch_5.lua`
- `mount_windswept_entrance_ch_5.lua`
- `searing_crucible_ch_5.lua`
- `searing_tunnel_entrance_ch_5.lua`
- `searing_tunnel_midpoint_ch_5.lua`
- `vast_steppe_entrance_ch_5.lua`
- `ledian_dojo_ch_5.lua`
- `altere_pond_ch_5.lua`

## Limite technique

Une partie des 96 textes secondaires a été traduite directement dans les scripts Lua plutôt que d'être entièrement extraite vers de nouvelles clés `.resx`. Le texte affiché est français, mais une passe d'extraction supplémentaire serait nécessaire pour obtenir une séparation stricte code/ressource pour chaque phrase.

Cette limite ne concerne pas les 739 clés principales déjà localisées dans les fichiers `.resx`.

## Reste du projet

La fin de la traduction du chapitre 5 ne signifie pas que tout le mod est français. Les chapitres 1 à 4, les menus génériques et `PartnerEssentials.lua` contiennent encore des textes anglais. Ils sont hors du périmètre de la finalisation du chapitre 5.

## Validation

- 178 fichiers Lua : 0 erreur de syntaxe ;
- fichiers `.resx` analysés : 0 erreur XML ;
- JSON des trois zones du chapitre 5 : valides ;
- 80 clés `TALK_*` du chapitre 5 : 0 manque en français.

Le test réel dans PMDO n'a pas été exécuté automatiquement. Il reste à tester en jeu chaque branche de défaite, fuite, victoire et non-répétition des cinématiques.
