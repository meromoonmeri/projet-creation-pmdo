# Vague 2 — 15 donjons secondaires ch2-10 (2026-07-27)

Source : PMDODump/DumpAsset (API blobs GitHub). Outil : `tools/import_wave2_dungeons.py`.
Comble la règle « 2-3 secondaires/chapitre » du document maître (Partie 2.1) pour ch2-10.

## Zones importées

| Zone New Era | Nom FR | Source | Ch. | Niveau | Étages | Difficulté job | Notes |
|---|---|---|---|---|---|---|---|
| grotte_repos | Grotte du Repos | cave_of_solace | 2 | 10 | 25 | E | level-reset (spawns relatifs) |
| bois_ronces | Bois des Ronces | bramble_woods | 3 | 12 | 13 | D | substitut de muddy_valley (absent de la source) |
| halles_royales | Halles Royales | royal_halls | 4 | 14 | 25 | C | substitut de royal_garden (absent) |
| jardin_secret | Jardin Secret | secret_garden | 4 | 14 | 40 | B | défi long, teaser Anima végétale |
| foret_embuscade | Forêt de l'Embuscade | ambush_forest | 5 | 16 | 23 | C | bandits sur la route de l'expédition |
| bois_filou | Bois du Filou | trickster_woods | 5 | 16 | 17 | C | voleur d'objets du camp |
| desert_oublies | Désert des Oubliés | forsaken_desert | 6 | 19 | 6 | B | piste des Anima asséchés |
| crevasse_geode | Crevasse de Géode | geode_crevice | 6 | 19 | 14 | B | minerais résonnant avec les Cœurs |
| jardin_energie | Jardin d'Énergie | energy_garden | 7 | 22 | 12 | B | concentration d'Anima vivante |
| toundra_desolee | Toundra Désolée | barren_tundra | 8 | 22 | 30 | A | substitut de glacial_path (absent) |
| bassin_tari | Bassin Tari | depleted_basin | 9 | 25 | 17 | A | bassin vidé de son Anima |
| marais_errants | Marais Errants | wayward_wetlands | 9 | 25 | 18 | A | approche du Marais de l'Oubli |
| col_foudre | Col de la Foudre | thunderstruck_pass | 10 | 27 | 16 | S | territoire Fulgur |
| falaises_envol | Falaises de l'Envol | flyaway_cliffs | 10 | 27 | 12 | S | contreforts du Pic |
| sentier_enneige | Sentier Enneigé | snowbound_path | 10 | 27 | 27 | S | approche enneigée du Pic |

## Dépendances récupérées et adaptées

- **OST : 20 musiques** importées dans `Content/Music/` (Ambush Forest ×3, Barren
  Tundra ×2, Bramble Thicket, Deep/Limestone Cavern, Demonstration 2/3, Depleted
  Basin, Flyaway Cliffs, Forsaken Desert, Glacial Path, Moonlit Courtyard,
  Overgrown Wilds, Snowbound Path, Thunderstruck Pass, Treeshroud Forest,
  Trickster Woods). « Fortune Ravine.ogg » absent de la source → substitut
  `Boulder Quarry.ogg` (déjà présent) appliqué dans crevasse_geode.
- **Cartes fixes : 44** (21 arènes boss_*, 9 pattern_*, 6 room_*, 2 special_*,
  6 cartes de fond renommées FR : bois_ronces_fond, foret_embuscade_fond,
  desert_oublies_fond/secret, crevasse_geode_fond, bassin_tari_fond,
  marais_errants_fond).
- **Tileset : 1** (`NorthernDesert1OwnWall.tile`, requis par secret_forsaken_desert
  → desert_oublies_secret) ; `Content/Tile/index.idx` régénéré (293 tilesets).
- **Pièges** : uniquement `tile_wonder`/`tile_evo`/`tile_switch` référencés = pièges
  du jeu de base, rien à importer (vérifié : 0 manquant).
- **Objets** : tous les items référencés (berry_*, tm_*, wand_*, seed_*, held_*,
  ammo_*, orb_*) sont des items du **jeu de base PMDO** ; notre `Data/Item/` ne
  contient que des overrides — même situation que les zones vague 1 qui
  fonctionnent. 0 import nécessaire (vérifié).

## Purge des scripts sources (anti-crash)

`Mysteriosity`, `ShopkeeperInteract`, `GeodeCreviceRevisit`, `HiddenLegend`,
`PairTalk`, `RoamingLegend`, `SpawnRandomTutor` : 11 spawns bannis purgés +
21 ZoneSteps vides retirés (le pattern `{"Spawn":{"Script":...}}` échappait à la
purge vague 1 — corrigé dans l'outil). 0 référence restante (audit).

## Câblage

- **Déblocages histoire** : ch2 (`guild_heros_room_ch_1`), ch3
  (`guild_guildmasters_room_ch_2`), ch4/5/6 (`guild_heros_room/init.lua`).
- **Rétroactif vieilles sauvegardes + ch7-10** : `debug_tools/init.lua` OnUpgrade
  (les ch7-10 se débloquent dès que le chapitre est atteint — la progression
  scriptée 6→7+ reste un chantier séparé, cf. document maître).
- **Job board** : `mission_gen.lua` — DUNGEON_LIST (+15), DUNGEON_DIFFICULTY
  (E→S), EXPECTED_LEVEL (10→27). Filtre moteur `GetDungeonUnlock == Completed`
  inchangé.
- **Zone scripts** : 15 `init.lua` (patron petit_tunnel : retour Metano, missions).

## Audits (§10/§11)

- Dépendances : 0 musique manquante, 0 carte manquante, 0 item/piège manquant,
  0 script banni restant, 0 `$values` orphelin (fichiers générés au format
  canonique post-fix écran noir).
- Renivelage : spawns max ≤ 28 (barème paliers 1-3, option (a)) ; grotte_repos &
  halles_royales : zones level-reset (spawns relatifs conservés).
- Narratif : aucun nom de mod source visible ; noms FR originaux ; rôles
  narratifs alignés sur le plan (indices Anima ch6-9, Fulgur ch10).
- Syntaxe Lua : 20/20 fichiers modifiés/créés OK (lupa).
