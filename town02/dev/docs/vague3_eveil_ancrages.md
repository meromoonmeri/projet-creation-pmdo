# Vague 3 — « L'Éveil des Ancrages » : 28 donjons légendaires ch11-32 (2026-07-27)

Directive : « BRANCHE TOUT — chaque légendaire ajouté a une zone tirée des
GitHub référencés, assortie à sa DA. » Plan source :
plan_integration_legendaires_ch8-32.md (concept Ancrages, Livre II).

Correction canon actée : **Sky Tower = Rayquaza** (le Neuvième Sommet lui
revient) ; Lugia = fosse abyssale (Silver Trench DA, autotiles silver_trench_3).

## Boucle jouable (branchée, testable dès maintenant)

Chaque donjon = zone DumpAsset renivelée + segment d'arène ajouté (LayeredSegment
→ .rsmap dédiée, autotiles à la DA du légendaire, mysterious_force) + contrat
LegendZones **ready** (Grodoudou : verrou d'histoire = chapitre atteint, posé à
l'ENTRÉE du chapitre comme demandé — verrou d'achat — verrou de combat).
Victoire → `LegendZones.SetDefeated` + `SV.Anchors.Stabilized[clé]` (compteur
pour la double fin ch32). Tous recrutables (Unrecruitable=false).

| Ch | Donjon (source DumpAsset) | Légendaire(s) (niv) | Arène (autotiles DA) | Contrat LZ |
|---|---|---|---|---|
| 11 | Caldeira Endormie (sleeping_caldera) | Groudon 37 | deep_dark_crater | molten_throne |
| 12 | Eaux Inexplorées (uncharted_waters) | Kyogre 39 | stormy_sea_1 | tide_hollow |
| 13 | Sentier du Savoir (wisdom_road) | Uxie 41 | crystal_cave_2 | quiet_ledger |
| 13 | Sentier de l'Espoir (hope_road) | Mesprit 41 | crystal_cave_1 | kept_feeling |
| 13 | Sentier du Courage (bravery_road) | Azelf 41 | crystal_crossing | last_resolve |
| 14 | Île de Lave Flottante (lava_floe_island) | Sulfura 43 | fiery_field | long_ash |
| 16 | Crête Voilée (veiled_ridge) | Raikou 46 | lightning_field | storm_bell |
| 17 | Montagne Traîtresse (treacherous_mountain) | Artikodin + Électhor 48 | northwind_field | thawed_step + high_conductor |
| 18 | Tour Sacrée (sacred_tower) | Ho-Oh 51 | mt_faraway_4 | rainbow_ash |
| 19 | Fosse des Abysses (the_abyss) | Lugia 54 | silver_trench_3 | sunken_choir |
| 20 | Bois d'Antan (tropical_path) | Celebi 56 | mystery_jungle_2 | dead_hours |
| 21 | Forteresse Abandonnée (deserted_fortress) | Mewtwo 58 | western_cave_1 | western_silence |
| 22 | Crête de la Faille (faultline_ridge) | Entei 60 + Victini 58 | deep_dark_crater | ember_vigil + victory_spark |
| 23 | Cour du Clair de Lune (moonlit_courtyard) | Cresselia + Darkrai 62 | darknight_relic | soft_sleep + upturned_dream |
| 24 | Île Éon (eon_island) | Latios + Latias 64 | sky_tower | twin_rift (+_latias) |
| 25 | Antre Chuchotant (cave_of_whispers) | Suicune 66 | howling_forest_1 | clearwater_ford |
| 26 | Bois Enchevêtrés (overgrown_wilds) | Mew 68 + Hoopa 67 | mystery_jungle_1 | first_cradle (+_hoopa) |
| 27 | Hauteurs de l'Étoile Filante (starfall_heights) | **Rayquaza 70** | sky_tower | ninth_summit |
| 28 | Tour des Reliques (relic_tower) | Dialga 72 | temporal_tower | hour_that_lags |
| 28 | Grotte Gravée (inscribed_cave) | Palkia 72 | spacial_rift_1 | spatial_hill |
| 29 | Labyrinthe des Perdus (labyrinth_of_the_lost) | Giratina 74 | world_abyss_2 | reverse_slope |
| 29 | Vallon Malsain (sickly_hollow) | Yveltal 74 | dark_wasteland | final_rest |
| 30 | Le Ciel Suspendu (the_sky) | Zygarde 76 | spacial_cliffs | cells_gathering |
| 30 | Îles Prismatiques (prism_isles) | Xerneas 76 | crystal_crossing | given_life |
| 31 | Le Conte Sans Fin (the_neverending_tale) | Solgaleo + Lunala 78 | mt_faraway_2 | two_lights (+_lunala) |
| 31 | Dédale du Vœu (training_maze) | Jirachi 75 | wish_cave_2 | unsaid_wishes |
| 32 | Sentier Éteint (faded_trail) | Necrozma 80 | deep_dusk_forest_1 | borrowed_light |
| 32 | Nervure du Monde (guildmaster_trail) | Eternatus 85 | world_abyss_2 | eternal_coil (verrou : StoryCompleted) |

Regigigas (colossus_quarry) : revanche câblée sur cloven_ruins seg3 (Sanctuaire
des Titans), flag SawAnimaCoreCorruption (ch7 vécu). Total LegendZones :
**37 contrats, 36 ready** (terrakion reste un contrat futur).

## Dépendances importées
- 18 OST (Champion Road, Sky Tower, Relic Tower, Sacred Tower, Enraged
  Caldera, Sickly Hollow ×2, Treacherous Mountain ×3, Lava Floe ×2, etc.) ;
  3 substitutions documentées (Fortune Ravine Depths→Boulder Quarry,
  Hidden Land→Time Gear Remix, Title→Top Menu Theme).
- 41 cartes fixes (17 arènes boss_ officielles, salles lunaires room_moon_*,
  autels, fins de donjon ; end_treacherous_mountain→montagne_traitresse_fond
  pour éviter la collision avec le ground ch5).
- 28 scripts de zone (patron petit_tunnel + SetDefeated + SV.Anchors).
- 72 clés strings FR/EN (noms, boniments, descriptions Grodoudou).
- Fix : lands_wrath (land_s_wrath n'existe pas dans PMDO).

## Audits
- 28/28 zones : refs cartes/musiques OK, 0 script banni, segments d'arène
  valides, 28 arènes flood-fill OK, 39 boss atteignables (positions 7,5/5,5/9,5).
- 24 contrats ready vérifiés zone+segment (script) puis 36/36 après insertion.
- 0 orphelin $values ; Lua 28+1 fichiers OK ; resx XML valides.
- Éternatus verrouillé derrière StoryCompleted (fin d'histoire), pas un chapitre.

## Note d'intention (à écrire plus tard)
Les cinématiques d'histoire des Ancrages (visions ch15/ch20, intros 3 couches)
et les grounds pmd-red 1:1 (fosse_ardente, abime_tempetes, sommet_aurore…)
seront branchés lors de l'écriture des chapitres 11+ : la boucle jouable
(donjon + boss + recrutement) est déjà complète via Grodoudou.
