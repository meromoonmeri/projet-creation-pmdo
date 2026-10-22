# Câblage narratif des 51 donjons Ch.6-32

Règle verrouillée : **Ground de cinématique = Ground du combat = Ground final canonique**. Boss internes (Buried Relic, Meteor Cave) = salle fixe `.rsmap` chargée en étage, jamais un Ground inventé.

| Donjon | Segments | Sorties de segment | Suite | Ground final |
|---|---|---|---|---|
| `buried_relic` | 3 | 0→zone:buried_relic · 1→zone:buried_relic · 2→end_run:master_zone | — | — |
| `darknight_relic` | 2 | 0→zone:darknight_relic · 1→end_run:master_zone | — | — |
| `desert_region` | 2 | 0→zone:desert_region · 1→end_run:master_zone | — | — |
| `fantasy_strait` | 2 | 0→zone:fantasy_strait · 1→end_run:master_zone | — | — |
| `far_off_sea` | 3 | 0→zone:far_off_sea · 1→zone:far_off_sea · 2→end_run:master_zone | — | — |
| `fiery_field` | 2 | 0→ground:champ_braises · 1→end_run:master_zone | — | champ_braises |
| `frosty_forest` | 1 | 0→ground:d10p02 | frosty_grotto | d10p03 |
| `frosty_grotto` | 1 | 0→ground:d10p03 | — | d10p03 |
| `gloomy_forest` | 3 | 0→ground:gloomy_forest_midpoint · 1→ground:sinister_woods_clearing · 2→end_run:master_zone | — | sinister_woods_clearing |
| `grand_sea` | 2 | 0→zone:grand_sea · 1→end_run:master_zone | — | — |
| `great_canyon` | 2 | 0→zone:great_canyon · 1→ground:d07p02 | — | d07p02 |
| `howling_forest` | 2 | 0→ground:bois_des_plaintes · 1→end_run:master_zone | — | bois_des_plaintes |
| `joyous_tower` | 3 | 0→zone:joyous_tower · 1→zone:joyous_tower · 2→end_run:master_zone | — | — |
| `lapis_cave` | 2 | 0→zone:lapis_cave · 1→ground:grotte_lazuli_fond | — | grotte_lazuli_fond |
| `lightning_field` | 2 | 0→zone:lightning_field · 1→ground:champ_foudre | — | champ_foudre |
| `magma_cavern` | 3 | 0→zone:magma_cavern · 1→zone:magma_cavern · 2→ground:gorge_ardente_coeur | magma_cavern_pit | fosse_ardente |
| `magma_cavern_pit` | 1 | 0→ground:fosse_ardente | — | fosse_ardente |
| `marvelous_sea` | 2 | 0→zone:marvelous_sea · 1→end_run:master_zone | — | — |
| `meteor_cave` | 2 | 0→zone:meteor_cave · 1→end_run:master_zone | — | — |
| `mt_blaze` | 2 | 0→ground:mt_blaze_midpoint · 1→ground:d09p02 | mt_blaze_peak | d09p03 |
| `mt_blaze_peak` | 1 | 0→ground:d09p03 | — | d09p03 |
| `mt_faraway` | 3 | 0→zone:mt_faraway · 1→ground:sommet_aurore · 2→end_run:master_zone | — | sommet_aurore |
| `mt_freeze` | 2 | 0→ground:mt_freeze_midpoint · 1→ground:d11p02 | mt_freeze_peak | d11p03 |
| `mt_freeze_peak` | 1 | 0→ground:d11p03 | — | d11p03 |
| `mt_steel` | 1 | 0→ground:d03p02 | — | d03p02 |
| `mt_thunder` | 2 | 0→ground:mt_thunder_midpoint · 1→ground:d06p02 | mt_thunder_peak | d06p03 |
| `mt_thunder_peak` | 1 | 0→ground:d06p03 | — | d06p03 |
| `murky_cave` | 2 | 0→zone:murky_cave · 1→ground:caverne_trouble_fond | — | caverne_trouble_fond |
| `northern_range` | 2 | 0→ground:cretes_boreales · 1→end_run:master_zone | — | cretes_boreales |
| `northwind_field` | 2 | 0→ground:champ_vent_boreal · 1→end_run:master_zone | — | champ_vent_boreal |
| `oddity_cave` | 2 | 0→zone:oddity_cave · 1→end_run:master_zone | — | — |
| `pitfall_valley` | 2 | 0→ground:vallon_perdu · 1→end_run:master_zone | — | vallon_perdu |
| `purity_forest` | 4 | 0→zone:purity_forest · 1→zone:purity_forest · 2→zone:purity_forest · 3→ground:foret_guerison | — | foret_guerison |
| `remains_island` | 2 | 0→zone:remains_island · 1→end_run:master_zone | — | — |
| `rock_path` | 1 | 0→end_run:master_zone | — | — |
| `silent_chasm` | 1 | 0→ground:d05p02 | — | d05p02 |
| `silver_trench` | 3 | 0→zone:silver_trench · 1→ground:fosse_argentee · 2→end_run:master_zone | — | fosse_argentee |
| `sky_tower` | 1 | 0→ground:arc_palier_celeste | sky_tower_summit | arc_tour_ciel_sommet |
| `sky_tower_summit` | 1 | 0→ground:arc_tour_ciel_sommet | — | arc_tour_ciel_sommet |
| `snow_path` | 1 | 0→end_run:master_zone | — | — |
| `solar_cave` | 2 | 0→zone:solar_cave · 1→end_run:master_zone | — | — |
| `southern_cavern` | 3 | 0→zone:southern_cavern · 1→zone:southern_cavern · 2→end_run:master_zone | — | — |
| `stormy_sea` | 3 | 0→zone:stormy_sea · 1→ground:abime_tempetes · 2→end_run:master_zone | — | abime_tempetes |
| `thunderwave_cave` | 1 | 0→ground:d02p02 | — | d02p02 |
| `tiny_woods` | 1 | 0→ground:d01p02 | — | d01p02 |
| `unown_relic` | 2 | 0→zone:unown_relic · 1→end_run:master_zone | — | — |
| `uproar_forest` | 2 | 0→zone:uproar_forest · 1→end_run:master_zone | — | — |
| `waterfall_pond` | 2 | 0→zone:waterfall_pond · 1→end_run:master_zone | — | — |
| `western_cave` | 3 | 0→zone:western_cave · 1→ground:antre_occident · 2→end_run:master_zone | — | antre_occident |
| `wish_cave` | 2 | 0→ground:sanctuaire_voeu · 1→end_run:master_zone | — | sanctuaire_voeu |
| `wyvern_hill` | 2 | 0→zone:wyvern_hill · 1→end_run:master_zone | — | — |

## Recâblages de Grounds (0)

Aucun.
