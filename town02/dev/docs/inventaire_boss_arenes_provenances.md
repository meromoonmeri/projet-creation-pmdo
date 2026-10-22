# Inventaire complet — Boss, arènes, grounds et provenances (2026-07-27)

Réponse à la demande : « liste de tous les donjons avec leur boss, le ground
d'origine, le donjon d'origine du mod importé ». Vérifié fichier par fichier
dans le dépôt (espèces/niveaux lus dans les .rsmap, provenances dans les
Comment + docs de traçabilité).

Légende provenance : **[NE]** = création New Era · **[DumpAsset]** = jeu de
base PMDO (github.com/audinowho/DumpAsset) · **[pmd-red]** = pret/pmd-red
(GBA, import 1:1) · **[EoSO]** = ExplorersOfSkyOrigins (tilesets PMD Sky
convertis PMDO) · **[FA]** = Friend Area (Drive, tilesets RTRB)

---

## 1. Boss d'histoire (ch1-10)

| Ch. | Donjon New Era | Boss (niv) | Arène de combat (.rsmap) | Provenance arène | Ground de cinématique (.rsground) | Provenance ground |
|---|---|---|---|---|---|---|
| 1 | Forêt Relique | — (pas de boss) | — | — | scènes dans `relic_forest` | [NE] |
| 2 | Rivière Illuminée | — (fin scénarisée) | — | — | `luminous_spring` | [DumpAsset] ground officiel (tileset LuminousSpring) |
| 3 | Caverne Tortueuse | Luxio 10 + Glameow 9 + Cacnea 9 (Team Dazzling) | `chapter_3_boss_fight` (seg2) | [NE] autotiles rock_maze | `crooked_den` | [NE] (tileset Crooked_Den) |
| 4 | Bosquet Apricorn | — (fin scénarisée) | — | — | `apricorn_glade` | [NE] |
| 5 | Grande Steppe | mini-boss Mudbray 16 + Stantler 16 | `vast_steppe_miniboss` (seg1) | [NE] autotiles lush_prairie | `vast_steppe_miniboss` | [NE] (crop biome, VastSteppeMiniboss_*) |
| 5 | Grande Steppe | gardien Stantler 20 | `vast_steppe_guardian` (seg3) | [NE] | `vast_steppe_guardian` | [NE] |
| 5 | Tunnel Incandescent | mini-boss Torkoal 17 + Magmar 17 | étage procédural seg1 (embuscade voulue) | [NE] | `searing_tunnel_miniboss` | [NE] (SearingTunnelMiniboss_*) |
| 5 | Tunnel Incandescent | Magcargo 18 + 8 Slugma 13 | `searing_crucible` (seg2) | [NE] sur tileset [DumpAsset] Spring_Cave_Pit | `searing_crucible` | tileset [DumpAsset] Spring_Cave_Pit |
| 5 | Mont Venteux | mini-boss Gligar 18 + Skarmory 18 | `mount_windswept_miniboss` (seg1) | [NE] autotiles craggy_peak | `mount_windswept_miniboss` | [NE] |
| 5 | Mont Venteux | gardien Aerodactyl 22 | `mount_windswept_guardian` (seg3) | [NE] | `mount_windswept_guardian` | **[DumpAsset] `end_treacherous_mountain`** (donjon source : Treacherous Mountain ; tileset MountainPeak) |
| 6 | Forêt Lugubre | **Zarude 27** | `gloomy_forest_boss` (seg2) | [NE] autotiles treeshroud_forest | `gloomy_forest_boss` | [NE] (tilesets Relic_Forest_*) |
| 6 | Serment Verdoyant (revanche) | **Zarude 30** | `verdant_oath_arena` (seg3) | [NE] | même ground | [NE] |
| 7 | Aegis Cave | **Regigigas 28 + Regirock/Regice/Registeel 26** | **`sanctuaire_titans`** (seg3) | **[EoSO] « Deep Aegis Cave Regigigas Boss Arena » — donjon d'origine : Aegis Cave (PMD Explorers of Sky), import 1:1, tileset renommé Titans_Arena_Base** | `cloven_ruins_boss` | [NE] (tileset Relic_Forest_Base) |
| 8 | Sanctuaire de Cristal | **Diancie 30** | `crystal_sanctuary_boss` (seg3) | [NE] (modèle cloven, autotiles concealed_ruins) — aucun lieu Diancie n'existe dans aucun jeu (Domaine Diamant = film) | `crystal_sanctuary_boss` | [NE] (tileset First_Core_Location_Base) |
| 9 | Marais de l'Oubli | **Laggron 32** (swampert « gardien millénaire ») | `forgotten_marsh_boss` (seg3) | [NE] — Laggron n'a de lieu dédié dans aucun jeu (boss inventé New Era) | `forgotten_marsh_boss` | [NE] (tileset Altere_Pond_Base) |
| 10 | Pic Céleste | **Escouade Fulgur** : Luxray « Voltra » + Lucario « Aegis » + Heliolisk « Solaire », niv 33 | `celestial_peak_fulgur` (seg3) | [NE] | `celestial_peak_fulgur` | [NE] (tileset Mount_Windswept_Base) |
| 10 | Pic Céleste | **Lugia 35** | `celestial_peak_boss` (seg5), **retilée [FA] Rainbow_Peak** (mer de nuages) | [NE] + retiling [FA] | **`autel_celeste`** | **[pmd-red] D13P03 « Sky Tower Summit » (arène Rayquaza de Rescue Team), import 1:1 — donjon d'origine : Sky Tower ; casting Rayquaza→Lugia, positions gs209 exactes** |

Relais/checkpoints importés dans ces donjons (pas des boss mais liés) :
`vast_steppe_midpoint` ← [DumpAsset] `cliff_camp` · `mount_windswept_midpoint`
← [DumpAsset] `canyon_camp` · `crooked_cavern_midpoint` ← [DumpAsset]
`rest_stop` · `gloomy_forest_midpoint` ← [DumpAsset] `forest_camp` ·
`cloven_ruins_midpoint` ← [DumpAsset] `end_moonlit_temple` ·
`crystal_sanctuary_relay` ← [DumpAsset] `final_stop` · `forgotten_marsh_relay`
← [DumpAsset] `end_ambush_forest` · `celestial_peak_relay` ← [DumpAsset]
`guildmaster_summit`.

## 2. Boss hors histoire

| Contexte | Boss (niv) | Arène | Provenance |
|---|---|---|---|
| Zone légendaire (Grodoudou/revanches) | Terrakion 20 | `terrakion_fight` | [NE] (autotiles test_dungeon) |

## 3. Arènes de mini-boss importées avec la vague 2 (DumpAsset, prêtes dans les donjons secondaires)

21 arènes officielles du jeu de base, avec leurs boss d'origine, chargées par
les zones secondaires ch2-10 (spawns du jeu de base renivelés au barème) :
`boss_thief`, `boss_lycanroc`, `boss_skarmbliss`, `boss_awd`, `boss_ditto`,
`boss_eclipse`, `boss_tanker`, `boss_sand_spirit`, `boss_sandstorm_2`,
`boss_artifact_water`, `boss_lava_plume_water`, `boss_burmy_pair`,
`boss_cattle_pair`, `boss_nido_pair`, `boss_poli_pair`, `boss_slow_pair`,
`boss_plus_minus_1/2`, `boss_fossil_kanto/hoenn/sinnoh`.
Donjons d'origine : les mêmes zones DumpAsset que leurs donjons hôtes
(Ambush Forest, Trickster Woods, Forsaken Desert, Geode Crevice, Depleted
Basin, Wayward Wetlands, Thunderstruck Pass, Flyaway Cliffs, Snowbound Path,
Secret Garden, Royal Halls, Cave of Solace, Bramble Woods, Energy Garden,
Barren Tundra).

## 4. Réserve : 12 arènes de boss pmd-red converties 1:1 (non branchées, boss d'origine conservés)

| Asset New Era | Donjon d'origine (pmd-red) | Boss d'origine (règle 1:1 : conservé) |
|---|---|---|
| `fosse_ardente` | Magma Cavern Pit (D12P04) | **Groudon** |
| `gorge_ardente_coeur` | Magma Cavern mi-parcours (D12P02) | mise en scène |
| `abime_tempetes` | Stormy Sea fond (D14P01) | **Kyogre** |
| `fosse_argentee` | Silver Trench fond (D15P01) | **Lugia** (réserve, distinct du ch10) |
| `champ_braises` | Fiery Field (D16P01) | **Moltres** |
| `champ_foudre` | Lightning Field (D17P01) | **Raikou** |
| `champ_vent_boreal` | Northwind Field (D18P01) | **Articuno** |
| `sommet_aurore` | Mt. Faraway (D19P01) | **Ho-Oh** |
| `antre_occident` | Western Cave (D20P01) | **Mewtwo** |
| `cretes_boreales` | Northern Range (D21P01) | **Latios/Latias** |
| `bois_des_plaintes` | Howling Forest (D25P01) | **Suicune** |
| `sanctuaire_voeu` | Wish Cave fond (D23P01) | **Jirachi** (salle finale actée de la Grotte du Vœu) |
| `palier_celeste` | Sky Tower mi-parcours (D13P02) | mise en scène |

(+ 18 grounds d'entrée/cinématique pmd-red lot 2 : Tiny Woods, Thunderwave,
Mt. Steel, Sinister Woods, Silent Chasm, Mt. Thunder, Great Canyon, Lapis
Cave ×2, Mt. Blaze, Frosty Forest, Mt. Freeze, Magma Cavern porte, Sky Tower
entrée, Pitfall Valley, Murky Cave ×2 — détail dans
`pmdred_extraction_tracabilite.md` lots 2-3.)
