# Vague 1 — 7 donjons secondaires (ch1-4) + renivelage option (a)

Date : 2026-07-26
Décision utilisateur : **option (a)** — renivelage des boss ch6-10 vers le barème multi-sources.

## 1. Renivelage des boss (option a)

| Combat | Avant | Après | HP |
|---|---|---|---|
| Zarude (Forêt Lugubre, ch6) | L42 | **L27** | 200+80 |
| Zarude revanche (verdant_oath) | L45 | **L30** | 220+90 |
| Regigigas (Aegis Cave, ch7) | L45 | **L28** | 260+120 |
| Diancie (Sanctuaire, ch8) | L40 | **L30** | 240+100 |
| Laggron (Marais, ch9) | L42 | **L32** | 280+120 |
| Escouade Fulgur (ch10) | L38 | **L33** | 180-190+30/40 |
| Lugia (Pic Céleste, ch10) | L48 | **L35** | 320+150 |

Progression : 27 → 28 → 30 → 32 → 33 → 35, calée sur P2 (~25) / P3 (~35) avec Lugia en légendaire de fin d'arc. Outil reproductible : `tools/rebalance_bosses.py`. NB : les spawns de gloomy_forest (L21-24) restent cohérents avec Zarude L27.

## 2. Donjons importés (fiches §7 condensées)

| Nouvelle identité | Origine | Source | Ch. | Étages | Niveau | Fonction narrative |
|---|---|---|---|---|---|---|
| Petit Tunnel (`petit_tunnel`) | Tiny_Tunnel | DumpAsset | 1 | 9 | ~5 | Première mission job board près de Metano |
| Bosquet Voilé (`bosquet_voile`) | mystery_grove | ZMDO | 1 | 3 | ~6 | Zone d'entraînement post-tutoriel |
| Grotte du Mystère (`grotte_mystere`) | mystery_cave | ZMDO | 2 | 6 | ~10 | « Cristaux qui chantent » — préfigure le Sanctuaire ch8 |
| Vallée Fertile (`vallee_fertile`) | Fertile_Valley | DumpAsset | 2 | 16 | ~12 | Escortes pour les fermiers Zigzaton |
| Antre de l'Énigme (`antre_enigme`) | mystery_dungeon | ZMDO | 3 | 10 | ~13 | Enquêtes de la guilde |
| Carrière de Cuivre (`carriere_cuivre`) | Copper_Quarry | DumpAsset | 3 | 19 | ~13 | Livraisons de minerai |
| Grotte de l'Échoué (`grotte_echoue`) | Castaway_Cave | DumpAsset | 4 | 12 | ~15 | Naufragé à secourir sur la côte |

## 3. Nettoyage des traces des mods sources (§10.1)

Scripts purgés des zones (référencés mais inexistants ou indésirables chez nous — crash garanti sinon, nos scriptvars écrasent ceux du jeu de base) :
- `Tutorial` (ZMDO — dialogues Melanie/Lumiere, `SV.charvars`) : 2×2 occurrences ;
- `Mysteriosity` (`SV.magnagate` — mécanique Magnagate du jeu de base) : 4 occurrences ;
- `SpawnRandomTutor` (`SV.adventure.Tutors`, non déclaré chez nous) : 2 occurrences ;
- `CastawayCaveAltEnemies/AltMusic/Revisit/Shift` (`SV.castaway_cave`) : 28 occurrences ;
- `ShopkeeperInteract` (event_battle du jeu de base non embarqué) : purgé avec les steps Copper.

Renommages internes : `end_tiny_tunnel→petit_tunnel_fond`, `end_copper_quarry→carriere_cuivre_fond`, `room_muddy_valley_entrance→vallee_fertile_seuil`, `room_castaway_cave_altar→grotte_echoue_autel`.

Niveaux des spawns rescalés par zone (facteurs 0.35-1.0) vers le palier 1 : ZMDO était calé L20-21, Copper L18-26, Castaway L22-30.

## 4. Infrastructure importée telle quelle

- 11 cartes génériques du jeu de base : `pattern_*` (6), `room_evo_altar_*` (3 — autels d'évolution), `special_gsc_plant`, `special_rby_fossil` (salles secrètes fossiles/plante).
- 12 musiques officielles : Bramble Woods, Demonstration, Fertile Valley, Muddy Valley, Mysterious Passage, Copper Quarry, Lodestone Quarry, Castaway Cave, Luminous Spring (DumpAsset) + Water Cave, Crystal Cave, Intro Cave (ZMDO).
- Les autotiles (crystal_cave_*, the_nightmare, world_abyss_2, treeshroud_forest_2, etc.) sont ceux du jeu de base — résolus au runtime (mod Quest).

## 5. Branchements

- `mission_gen.lua` : les 7 zones ajoutées à `DUNGEON_LIST` + difficultés (E/E/D/D/C/C/B) + `EXPECTED_LEVEL`.
- Déblocages story : ch1 fin (petit_tunnel, bosquet_voile, grotte_mystere, vallee_fertile), ch2→3 (antre_enigme, carriere_cuivre), ch3→4 (grotte_echoue).
- Rétro-compatibilité vieilles sauvegardes : déblocage rétroactif dans `debug_tools/init.lua` (même mécanisme que crooked_cavern).
- Menu destinations Metano : 7 zones ajoutées.
- Scripts de zone : 7 `init.lua` sur le patron secondaire (retour Metano carte 1, missions/rescue gérés).

## 6. Validations

- 0 erreur Lua (36 scripts de zone + fichiers modifiés).
- JSON + BOM valides (7 zones, 15 maps, index.idx).
- 0 script banni résiduel (vérification par motif sur les 7 zones).
- 17 musiques référencées, 0 manquante.
- Test en jeu requis : job board avec les nouveaux donjons, déblocages ch1/3/4, difficulté après renivelage.
