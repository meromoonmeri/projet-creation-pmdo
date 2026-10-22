# Relais — Conversion vers des grounds officiels PMDO

Date : 2026-07-26
Demande : remplacer toutes les cartes de relais par des **grounds officiels** issus des sources documentées du jeu (au lieu des cartes composées par script).

## Source officielle

- **DumpAsset** : https://github.com/audinowho/DumpAsset — submodule officiel de **PMDODump** (https://github.com/audinowho/PMDODump), le dump des assets du jeu de base *Pokémon Mystery Dungeon: Origins*. C'est la même source déjà utilisée dans le projet pour `mount_windswept_guardian` (`end_treacherous_mountain`) et pour les musiques manquantes.
- Méthode d'intégration : directive multi-sources §§3, 6, 11 (renommage complet, MapChars supprimés, objets de gameplay remplacés par le patron New Era, collisions officielles conservées, audit spatial rejoué).
- Outil reproductible : `tools/convert_relays_official.py` (+ `tools/rebuild_tile_index.py`).

## Correspondances (ancien → officiel)

| Relais New Era | Ground officiel source | Taille | Musique | Justification biome |
|---|---|---|---|---|
| `vast_steppe_midpoint` (ch5) | `cliff_camp` | 792×528 | Cliff Camp.ogg | falaises herbeuses ouvertes = steppe |
| `mount_windswept_midpoint` (ch5) | `canyon_camp` | 1152×624 | Canyon Camp.ogg | canyon rocheux = flanc de montagne |
| `searing_tunnel_midpoint` (ch5) | — inchangé — | 456×456 | Spring Cave.ogg | déjà le patron canonique validé en jeu |
| `crooked_cavern_midpoint` (ch3) | `rest_stop` | 456×456 | Cave Camp.ogg | halte caverne officielle |
| `gloomy_forest_midpoint` (ch6) | `forest_camp` | 912×720 | Mystifying Forest.ogg | clairière forestière officielle |
| `cloven_ruins_midpoint` (ch7) | `end_moonlit_temple` | 384×480 | In the Depths of the Pit.ogg | temple ancien = esplanade des ruines |
| `crystal_sanctuary_relay` (ch8) | `final_stop` | 600×648 | Snow Camp.ogg | camp de neige = pureté cristalline |
| `forgotten_marsh_relay` (ch9) | `end_ambush_forest` | 408×432 | Cave Camp.ogg | sous-bois dense et sombre = marais |
| `celestial_peak_relay` (ch10) | `guildmaster_summit` | 408×384 | Summit.ogg | corniche de sommet officielle |

Note narrative : `guildmaster_summit` avait été écarté à l'époque comme **arène** (son nom SV est lié au maître de guilde). Ici il devient une simple **corniche-relais** du Pic Céleste, sans réutiliser `SV.guildmaster_summit` ni ses events — aucun conflit.

## Ce qui est fait sur chaque carte

1. `AssetName`, `Name` (fr/en), `Comment`, `Music` réécrits — plus aucune identité du jeu de base.
2. **Tous les MapChars supprimés** (PNJ des camps officiels : Rival, NPC_*, Snorlax…).
3. Objets de gameplay du jeu de base (`Assembly`, `Storage`, boutiques, gates scriptées, `Ferry`…) **supprimés** et remplacés par le patron New Era :
   - `Kangaskhan_Rock` (triggerType 1 → `GeneralFunctions.Kangashkhan_Rock_Interact`) ;
   - `North_Exit` / `South_Exit` (triggerType 2), recâblés sur les exits officiels quand ils existaient (E/W → continuer/retour sur cliff/canyon) ;
   - `gloomy_forest_midpoint` : **sortie unique** vers les profondeurs (spec ch6), `Secret_Exit` et les gates du forest_camp condamnés.
4. Objets **décoratifs** conservés mais neutralisés (trigger 0) : tentes, feux de camp, pots, souches, barrières — la carte garde sa vie visuelle officielle sans interactions héritées.
5. Spawners `TEAMMATE_1..3` : officiels conservés quand présents et walkables, sinon repositionnés (rest_stop, moonlit, ambush, final_stop) — tous vérifiés `is_cell_walkable` + connexité.
6. `Main_Entrance_Marker` ajouté sur cellule walkable connectée (les markers officiels `entrance_*` sont conservés en plus).
7. **Collisions officielles conservées telles quelles** (correctes par construction chez PMDO).

## Assets importés (officiels, nécessaires aux cartes)

- Tilesets (13) : `CliffCamp`, `CanyonCamp`, `CaveStop`, `ForestCamp(+Front/Secret/SecretFront)`, `ForestGrove(+Top)`, `SnowCamp(+Cliffs)`, `Summit(+Top)`.
- `Content/Tile/index.idx` régénéré (261 tilesets) par `tools/rebuild_tile_index.py`, format round-trip validé.
- Musiques (5) : `Cliff Camp`, `Canyon Camp`, `Cave Camp`, `Snow Camp`, `Summit` (.ogg).
- `cloven_ruins_midpoint` utilise les autotiles `wish_cave_1_*` du jeu de base — résolus au runtime (même mécanisme que `magma_cavern_2_*` du searing midpoint, mod Quest).

## Scripts recalés sur les nouvelles géométries

- `vast_steppe_midpoint_ch_5.lua` : arrivée (404/372,300), caméra (388,260), montée 48 px — chemin simulé pas à pas, BGM → Cliff Camp.
- `mount_windswept_midpoint_ch_5.lua` : arrivée (852/820,416), caméra (836,376), BGM → Canyon Camp.
- `gloomy_forest_midpoint_ch_6.lua` : toutes les coords décalées de +104 px en X (188/156 → 292/260), alignées sur `entrance_center` du forest_camp ; chaque segment vérifié walkable.
- `crooked_cavern_midpoint_ch_3.lua` : **aucune modification nécessaire** — toutes ses coordonnées (156/188, 176–272) tombent sur des cellules walkables du rest_stop officiel (vérifié).
- `searing_tunnel_midpoint_ch_5.lua` : inchangé (25 coordonnées vérifiées sur la carte, 0 invalide).

## Audit §11 final

- 9/9 relais : spawners nommés, walkables, connectés à l'entrée ; objets interactifs accessibles ; 0 MapChar hérité ; 0 problème.
- Chemins de cinématique simulés point par point (vast, mount, gloomy, crooked) : aucun mur traversé.
- Syntaxe Lua : 0 erreur sur tous les scripts ground/zone.
- Musiques et tilesets référencés : tous présents.
- Test en jeu requis à la prochaine session (relais ch3/5/6 prioritaires, puis 7-10).
