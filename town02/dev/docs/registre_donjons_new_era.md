# REGISTRE COMPLET DES DONJONS NEW ERA — 2026-07-27

Généré depuis le dépôt (Data/Zone + LegendZones + grounds). ✅ = branché/jouable.

## Le template standard d'un donjon New Era

```
Data/Zone/<id>.json               la zone : Segments[] =
  seg N (RangeDict)  = étages procéduraux (autotiles DA, spawns renivelés)
  seg N (Layered)    = étage FIXE -> .rsmap (relais, arène de boss)
Data/Map/<arène>.rsmap            l'arène : boss placés (MapTeam), mysterious_force,
                                  2 EntryPoints sur sol, autotiles = DA du boss
Data/Ground/<...>.rsground        grounds : entrée (camp + Kangourex + Dungeon_Entrance),
                                  relais (statue/rocher Kangourex = checkpoint,
                                  North_Exit/South_Exit, TEAMMATE_1..3),
                                  cinématique boss (markers positions d'origine)
Data/Script/halcyon/zone/<id>/    init.lua : EnterSegment/ExitSegment
                                  (routage victoire/défaite, SetDefeated, SV.Anchors)
index.idx                         résumé ZoneEntrySummary (CountedFloors, Maps[])
```
Boucle boss : étages → ExitSegment → ground cinématique → ContinueDungeon(seg arène)
→ combat → retour. Revanche/recrutement : LegendZones (Grodoudou, 3 verrous).

## Relais/checkpoints avec rocher-statue Kangourex (16 grounds)

`celestial_peak_entrance`, `celestial_peak_relay`, `cloven_ruins_entrance`, `cloven_ruins_midpoint`, `crooked_cavern_midpoint`, `crystal_sanctuary_entrance`, `crystal_sanctuary_relay`, `forgotten_marsh_entrance`, `forgotten_marsh_relay`, `gloomy_forest_midpoint`, `mount_windswept_entrance`, `mount_windswept_midpoint`, `searing_tunnel_entrance`, `searing_tunnel_midpoint`, `vast_steppe_entrance`, `vast_steppe_midpoint`

## Grounds pmd-red importés 1:1 (32) et leur assignation

| Ground New Era | Source pmd-red (donjon d'origine) | Assigné à |
|---|---|---|
| abime_tempetes | D14P01 Stormy Sea (Kyogre) | eaux_inexplorees |
| antre_occident | D20P01 Western Cave (Mewtwo) | forteresse_abandonnee |
| autel_celeste | D13P03 Sky Tower Summit (Rayquaza) | hauteurs_etoile, celestial_peak |
| bois_des_plaintes | D25P01 Howling Forest (Suicune) | antre_chuchotant |
| bois_sombres_oree | D04P01 Sinister Woods | réserve (entrée/cinématique chapitres 11+) |
| caverne_trouble_autel | D24P02 Murky Cave autel | réserve (entrée/cinématique chapitres 11+) |
| caverne_trouble_fond | D24P01 Murky Cave | labyrinthe_perdus |
| champ_braises | D16P01 Fiery Field (Moltres) | ile_lave_flottante |
| champ_foudre | D17P01 Lightning Field (Raikou) | crete_voilee |
| champ_vent_boreal | D18P01 Northwind Field (Articuno) | montagne_traitresse |
| cretes_boreales | D21P01 Northern Range (Latios) | ile_eon |
| foret_givree_oree | D10P01 Frosty Forest | réserve (entrée/cinématique chapitres 11+) |
| foret_tendre_oree | D01P01 Tiny Woods (entrée) | réserve (entrée/cinématique chapitres 11+) |
| fosse_ardente | D12P04 Magma Cavern Pit (Groudon) | caldeira_endormie |
| fosse_argentee | D15P01 Silver Trench (Lugia) | fosse_abysses |
| gorge_ardente_coeur | D12P02 Magma Cavern (cœur) | réserve (entrée/cinématique chapitres 11+) |
| gorge_ardente_porte | D12P01 Magma Cavern (porte) | caldeira_endormie |
| gouffre_muet_bord | D05P01 Silent Chasm | réserve (entrée/cinématique chapitres 11+) |
| grand_canyon_porte | D07P01 Great Canyon | réserve (entrée/cinématique chapitres 11+) |
| grotte_lazuli_fond | D08P02 Lapis Cave fond | réserve (entrée/cinématique chapitres 11+) |
| grotte_lazuli_seuil | D08P01 Lapis Cave | réserve (entrée/cinématique chapitres 11+) |
| grotte_statique_seuil | D02P01 Thunderwave (entrée) | réserve (entrée/cinématique chapitres 11+) |
| mont_cendre_pied | D09P01 Mt. Blaze | réserve (entrée/cinématique chapitres 11+) |
| mont_gele_pied | D11P01 Mt. Freeze | réserve (entrée/cinématique chapitres 11+) |
| mont_grondant_pied | D06P01 Mt. Thunder | mont_grondant |
| palier_celeste | D13P02 Sky Tower (palier) | hauteurs_etoile |
| parvis_celeste | D13P01 Sky Tower (entrée) | réserve (entrée/cinématique chapitres 11+) |
| pic_ferreux_pied | D03P01 Mt. Steel | réserve (entrée/cinématique chapitres 11+) |
| sanctuaire_voeu | D23P01 Wish Cave (Jirachi) | dedale_voeu |
| sommet_aurore | D19P01 Mt. Faraway (Ho-Oh) | tour_sacree |
| vallon_perdu | D22P01 Pitfall Valley | réserve (entrée/cinématique chapitres 11+) |

## Donjons (93 zones) — par bloc

### A. Histoire ch1-10 (12)

| Zone | Nom FR | Niv | Segments |
|---|---|---|---|
| relic_forest | Forêt des Reliques | -1 | 0:Layered |
| illuminant_riverbed | Lit de Rivière Lumineux | -1 | 0:RangeDict |
| crooked_cavern | Caverne Tortueuse | -1 | 0:RangeDict · 1:RangeDict · 2:Layered→chapter_3_boss_fight |
| apricorn_grove | Forêt des Noigrumes | -1 | 0:Layered |
| vast_steppe | Grande Steppe | -1 | 0:RangeDict · 1:Layered→vast_steppe_miniboss · 2:RangeDict · 3:Layered→vast_steppe_guardian |
| searing_tunnel | Tunnel Incandescent | -1 | 0:RangeDict · 1:RangeDict · 2:Layered→searing_crucible |
| mount_windswept | Mont Venteux | -1 | 0:RangeDict · 1:Layered→mount_windswept_miniboss · 2:RangeDict · 3:Layered→mount_windswept_guardian |
| gloomy_forest | Forêt Lugubre | -1 | 0:RangeDict · 1:RangeDict · 2:Layered→gloomy_forest_boss · 3:Layered→verdant_oath_arena |
| cloven_ruins | Aegis Cave | -1 | 0:RangeDict · 1:Layered→cloven_ruins_relay · 2:RangeDict · 3:Layered→sanctuaire_titans |
| crystal_sanctuary | Sanctuaire de Cristal | -1 | 0:RangeDict · 1:Layered→crystal_sanctuary_relay · 2:RangeDict · 3:Layered→crystal_sanctuary_boss |
| forgotten_marsh | Marais de l'Oubli | -1 | 0:RangeDict · 1:Layered→forgotten_marsh_relay · 2:RangeDict · 3:Layered→forgotten_marsh_boss |
| celestial_peak | Pic Celeste | -1 | 0:RangeDict · 1:Layered→celestial_peak_relay · 2:RangeDict · 3:Layered→celestial_peak_fulgur · 4:RangeDict · 5:Layered→celestial_peak_boss |

### B. Donjons-Ancrages légendaires ch11-32 (42 donjons, 1 légendaire = 1 donjon)

| Ch | Zone | Nom FR | Boss | Seg arène | Contrat |
|---|---|---|---|---|---|
| 11 | caldeira_endormie | Caldeira Endormie | groudon | 1 | molten_throne |
| 12 | eaux_inexplorees | Eaux Inexplorées | kyogre | 32 | tide_hollow |
| 13 | sentier_courage | Sentier du Courage | azelf | 1 | last_resolve_road |
| 13 | sentier_espoir | Sentier de l'Espoir | mesprit | 1 | kept_feeling_road |
| 13 | sentier_savoir | Sentier du Savoir | uxie | 1 | quiet_ledger_road |
| 14 | ile_lave_flottante | Île de Lave Flottante | moltres | 5 | long_ash_isle |
| 15 | jardin_gratitude | Jardin de la Gratitude | shaymin | 1 | thanks_bloom |
| 16 | berceau_mers | Berceau des Mers | manaphy/phione | 1 | sea_cradle |
| 16 | crete_voilee | Crête Voilée | raikou | 5 | storm_bell_ridge |
| 17 | mont_grondant | Mont Grondant | zapdos | 5 | high_conductor |
| 17 | montagne_traitresse | Montagne Traîtresse | articuno/zapdos | 4 | frozen_watch |
| 18 | gue_poulain | Gué du Poulain | keldeo | 1 | resolute_ford |
| 18 | tour_sacree | Tour Sacrée | ho_oh | 1 | rainbow_ash_tower |
| 19 | fosse_abysses | Fosse des Abysses | lugia | 1 | sunken_choir_deep |
| 20 | amphitheatre_oublie | Amphithéâtre Oublié | meloetta | 1 | last_encore |
| 20 | bois_antan | Bois d'Antan | celebi | 3 | dead_hours_grove |
| 21 | forteresse_abandonnee | Forteresse Abandonnée | mewtwo | 1 | western_silence |
| 21 | grotte_meteore | Grotte du Météore | deoxys | 1 | fallen_visitor |
| 22 | crete_faille | Crête de la Faille | entei/victini | 3 | ember_vigil_ridge |
| 22 | reacteur_enfoui | Réacteur Enfoui | genesect | 1 | old_reactor |
| 23 | cour_clair_lune | Cour du Clair de Lune | cresselia/darkrai | 5 | soft_sleep_court |
| 23 | forge_vapeur | Forge de Vapeur | volcanion | 1 | steam_heart |
| 24 | atelier_coeur_mecanique | Atelier du Cœur-Mécanique | magearna | 3 | gear_heart |
| 24 | ile_eon | Île Éon | latios/latias | 1 | twin_rift |
| 25 | antre_chuchotant | Antre Chuchotant | suicune | 1 | clearwater_hollow |
| 25 | piste_fulgurante | Piste Fulgurante | zeraora | 3 | wild_current |
| 26 | bois_enchevetres | Bois Enchevêtrés | mew/hoopa | 5 | first_cradle_wilds |
| 26 | creux_ombres | Creux des Ombres | marshadow | 1 | only_shadow |
| 27 | fonderie_hex | Fonderie Hex | melmetal/meltan | 3 | liquid_metal |
| 27 | hauteurs_etoile | Hauteurs de l'Étoile Filante | rayquaza | 1 | ninth_summit_heights |
| 28 | grotte_gravee | Grotte Gravée | palkia | 1 | spatial_hill_cave |
| 28 | tour_reliques | Tour des Reliques | dialga | 3 | hour_that_lags_tower |
| 29 | labyrinthe_perdus | Labyrinthe des Perdus | giratina | 1 | reverse_slope_maze |
| 29 | vallon_malsain | Vallon Malsain | yveltal | 3 | final_rest |
| 30 | ciel_suspendu | Le Ciel Suspendu | zygarde | 1 | cells_gathering |
| 30 | iles_prismatiques | Îles Prismatiques | xerneas | 1 | given_life_isles |
| 31 | chapelle_nuit | Chapelle de la Nuit | lunala | 5 | two_lights_lunala |
| 31 | conte_sans_fin | Le Conte Sans Fin | solgaleo/lunala | 1 | two_lights |
| 31 | dedale_voeu | Dédale du Vœu | jirachi | 1 | unsaid_wishes_maze |
| 32 | nervure_monde | Nervure du Monde | eternatus | 1 | eternal_coil |
| 32 | sentier_eteint | Sentier Éteint | necrozma | 4 | borrowed_light_trail |
| 32 | tour_origine | Tour de l'Origine | arceus | 1 | first_breath |

### C. Secondaires vagues 1-2 (22) + Imbion (7) + mazes (8) + reste

| Zone | Nom FR | Niv | Segments |
|---|---|---|---|
| antre_enigme | Antre de l'Énigme | 13 | 0:Layered |
| bassin_tari | Bassin Tari | 25 | 0:Layered→bassin_tari_fond,pattern_dither_fourth,room_evo_altar_normal,room_labyrinth_entrance · 1:Layered→pattern_blob,pattern_bubble,pattern_crosshair,pattern_x · 2:Singular→special_rby_fossil · 3:Singular · 4:Singular |
| beginner_lesson | Leçon pour débutants | 5 | 0:Layered→beginner_lesson_general,beginner_lesson_items,beginner_lesson_recruit,beginner_lesson_status,beginner_lesson_terrain |
| bois_filou | Bois du Filou | 16 | 0:Layered→pattern_crosshair,pattern_slash,pattern_squiggle,pattern_x_repeat,room_fairy_ring · 1:Layered→pattern_checker,pattern_crosshair,pattern_x_repeat · 2:Singular→special_gsc_plant · 3:Singular · 4:Singular |
| bois_ronces | Bois des Ronces | 12 | 0:Layered→bois_ronces_fond · 1:Layered · 2:Singular · 3:Singular |
| bosquet_voile | Bosquet Voilé | 6 | 0:Layered |
| bug_maze | Labyrinthe Insecte | 13 | 0:Singular |
| carriere_cuivre | Carrière de Cuivre | 13 | 0:Layered→carriere_cuivre_fond,pattern_dither_fourth,pattern_x,room_evo_altar_diamond · 1:Layered→room_evo_altar_diamond · 2:Singular→special_rby_fossil · 3:Singular · 4:Singular |
| col_foudre | Col de la Foudre | 27 | 0:Layered · 1:Singular→special_grass_maze · 2:Singular |
| crevasse_geode | Crevasse de Géode | 19 | 0:Layered→crevasse_geode_fond,pattern_crosshair,pattern_plus,pattern_slash,pattern_squiggle,pattern_teeth,room_evo_altar_diamond |
| desert_oublies | Désert des Oubliés | 19 | 0:Layered→boss_artifact_water,boss_awd,boss_ditto,boss_fossil_hoenn,boss_fossil_kanto,boss_fossil_sinnoh,boss_lava_plume_water,boss_lycanroc,boss_sand_spirit,boss_sandstorm_2,boss_tanker,boss_thief,desert_oublies_fond,room_pyramid · 1:Layered→desert_oublies_secret |
| electric_maze | Labyrinthe Électrique | 13 | 0:Singular |
| falaises_envol | Falaises de l'Envol | 27 | 0:Layered→room_flying_item · 1:Singular→special_rby_bird · 2:Singular |
| fire_maze | Labyrinthe de Feu | 7 | 0:Singular |
| flying_maze | Labyrinthe Volant | 10 | 0:Singular |
| foret_embuscade | Forêt de l'Embuscade | 16 | 0:Layered→pattern_checker_large,pattern_crosshair,pattern_squiggle,room_ambush_item · 1:Singular→special_grass_maze · 2:Singular · 3:Layered→foret_embuscade_fond |
| grass_maze | Labyrinthe Plante | 7 | 0:Singular |
| grotte_echoue | Grotte de l'Échoué | 15 | 0:Layered→grotte_echoue_autel,room_evo_altar_normal |
| grotte_mystere | Grotte du Mystère | 10 | 0:Layered |
| grotte_repos | Grotte du Repos | 10 | 0:Layered |
| halles_royales | Halles Royales | 14 | 0:Layered |
| imbion_ashen_geode | Ashen Geode | 13 | 0:RangeDict |
| imbion_berry_grove | Berry Grove | 9 | 0:RangeDict |
| imbion_coven_cave | Coven Cave | -1 |  |
| imbion_gourmet_jungle | Gourmet Jungle | 17 | 0:RangeDict · 1:RangeDict |
| imbion_grainy_pasture | Grainy Pasture | 27 | 0:RangeDict |
| imbion_haunted_bazar | Haunted Bazar | -1 |  |
| imbion_sentient_workshop | Sentient Workshop | -1 |  |
| jardin_energie | Jardin d'Énergie | 22 | 0:Layered |
| jardin_secret | Jardin Secret | 14 | 0:Layered→boss_burmy_pair,boss_cattle_pair,boss_eclipse,boss_nido_pair,boss_plus_minus_1,boss_plus_minus_2,boss_poli_pair,boss_skarmbliss,boss_slow_pair,room_evo_altar_small,room_garden_cross_water |
| marais_errants | Marais Errants | 25 | 0:Layered→marais_errants_fond,room_evo_altar_small · 1:Singular |
| normal_maze | Labyrinthe Normal | 5 | 0:Layered |
| petit_tunnel | Petit Tunnel | 5 | 0:Layered→pattern_blob_small,pattern_crosshair,pattern_dither_three_fourth,pattern_plus,petit_tunnel_fond,room_evo_altar_small |
| rock_maze | Labyrinthe Roche | 10 | 0:Singular |
| sentier_enneige | Sentier Enneigé | 27 | 0:Layered→pattern_bubble,pattern_squiggle,pattern_teeth,pattern_x,room_evo_altar_small · 1:Layered · 2:Singular→special_grass_maze · 3:Singular · 4:Singular |
| shady_shop | Shady Shop | -1 |  |
| toundra_desolee | Toundra Désolée | 22 | 0:Layered |
| vallee_fertile | Vallée Fertile | 12 | 0:Layered→vallee_fertile_seuil · 1:Layered · 2:Singular→special_gsc_plant · 3:Singular · 4:Singular |
| water_maze | Labyrinthe Aquatique | 7 | 0:Singular |