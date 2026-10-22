# Add-on « Réseau du Ciel » — les donjons d'Explorateurs du Ciel recréés New Era

> Session `arena/019fa547`, 2026-07-31. Générateur : `tools/gen_addon_sky_network.py`.
> Add-on frère du « Réseau des Anciens Chemins » (46 zones pmd-red). **67 zones créées**,
> `new_era_sky_00` → `new_era_sky_66`.

## 1. Méthode

`gen_addon_sky_network.py` **importe** `gen_addon_pmdred_network.py` et réutilise ses
helpers (`load`/`save`, `retarget_floor_ranges`, `scale_levels`) et ses patrons Lua
(`ZONE_LUA`, `RELAY_BLOCK`, `RELAY_INIT_LUA`). Même plomberie, catalogue différent.

Aucun contenu existant n'est modifié : uniquement des fichiers **nouveaux**, plus
`index.idx`, le déblocage et les 3 fichiers de tag.

## 2. Dédoublonnage — 2 SKIP

| Donjon EoS | Raison du SKIP |
|---|---|
| **Aegis Cave** | Déjà consommé : arène Regigigas du ch7 (`sanctuaire_titans`), import 1:1 de « Deep Aegis Cave Regigigas Boss Arena » — `inventaire_boss_arenes_provenances.md:31`. |
| **Mt. Faraway** | Déjà consommé : `sommet_aurore` / arène Ho-Oh réservée par `tour_sacree` ch18 — `registre_donjons_new_era.md:61`. Une version sans boss existe déjà côté pmd-red (`new_era_zone_47`). |

**Cas vérifiés et NON skippés** : `temporal_tower`, `spacial_rift`, `world_abyss`,
`dark_crater`, `mystery_jungle`, `crystal_cave`, `amp_plains`, `apple_woods`,
`waterfall_cave`, `steam_cave`. Contrôle fait zone par zone : les Ancrages
(`relic_tower`, `inscribed_cave`, `fosse_abysses`, `crete_voilee`…) n'en réutilisent
que le **tileset**, jamais le donjon — ce que la consigne autorise explicitement.

## 3. Les 67 zones

| Zone | Origine EoS | Nom New Era | Ét. | Niv | Relais | Palier |
|---|---|---|---|---|---|---|
| `new_era_sky_00` | Beach Cave | Grotte du Ressac | 4 | 8 | — | ch11+ |
| `new_era_sky_01` | Drenched Bluff | Falaise Ruisselante | 6 | 10 | — | ch11+ |
| `new_era_sky_02` | Mt. Bristle | Mont Hérissé | 8 | 12 | — | ch11+ |
| `new_era_sky_03` | Waterfall Cave | Grotte de la Cascade | 6 | 14 | — | ch11+ |
| `new_era_sky_04` | Apple Woods | Bois des Pommes | 6 | 15 | — | ch11+ |
| `new_era_sky_05` | Craggy Coast | Côte Escarpée | 6 | 17 | — | ch11+ |
| `new_era_sky_06` | Side Path | Sente Latérale | 3 | 18 | — | ch11+ |
| `new_era_sky_07` | Mt. Horn | Mont Corne | 9 | 19 | — | ch11+ |
| `new_era_sky_08` | Rock Path | Sente Rocheuse | 3 | 20 | — | ch11+ |
| `new_era_sky_09` | Foggy Forest | Forêt Embrumée | 6 | 21 | — | ch11+ |
| `new_era_sky_10` | Forest Path | Sente Forestière | 3 | 22 | — | ch11+ |
| `new_era_sky_11` | Steam Cave | Grotte des Vapeurs | 16 | 23 | — | ch11+ |
| `new_era_sky_12` | Amp Plains | Plaines du Grand Arc | 19 | 25 | oui | ch11+ |
| `new_era_sky_13` | Northern Desert | Désert Boréal | 8 | 26 | — | ch11+ |
| `new_era_sky_14` | Quicksand Cave | Grotte des Sables Mouvants | 14 | 27 | — | ch11+ |
| `new_era_sky_15` | Crystal Cave | Grotte de Cristal | 10 | 28 | — | ch11+ |
| `new_era_sky_16` | Crystal Crossing | Carrefour de Cristal | 8 | 29 | — | ch11+ |
| `new_era_sky_17` | Chasm Cave | Grotte du Gouffre | 9 | 30 | — | ch11+ |
| `new_era_sky_18` | Dark Hill | Colline Obscure | 10 | 31 | — | ch11+ |
| `new_era_sky_19` | Sealed Ruin | Ruine Scellée | 8 | 32 | — | ch11+ |
| `new_era_sky_20` | Dusk Forest | Forêt du Crépuscule | 8 | 33 | — | ch11+ |
| `new_era_sky_21` | Deep Dusk Forest | Crépuscule Profond | 8 | 34 | — | ch11+ |
| `new_era_sky_22` | Treeshroud Forest | Forêt du Linceul | 9 | 35 | — | ch11+ |
| `new_era_sky_23` | Brine Cave | Grotte Saumâtre | 14 | 36 | oui | ch11+ |
| `new_era_sky_24` | Hidden Land | Terre Dérobée | 17 | 38 | oui | ch20+ |
| `new_era_sky_25` | Temporal Tower | Tour Suspendue | 17 | 40 | oui | ch20+ |
| `new_era_sky_26` | Mystifying Forest | Forêt Mystifiante | 13 | 36 | — | ch20+ |
| `new_era_sky_27` | Blizzard Island | Île des Blizzards | 10 | 37 | — | ch20+ |
| `new_era_sky_28` | Crevice Cave | Grotte de la Crevasse | 15 | 38 | oui | ch20+ |
| `new_era_sky_29` | Surrounded Sea | Mer Encerclée | 15 | 39 | — | ch20+ |
| `new_era_sky_30` | Miracle Sea | Mer des Miracles | 15 | 40 | — | ch20+ |
| `new_era_sky_31` | Mt. Travail | Mont Labeur | 10 | 41 | — | ch20+ |
| `new_era_sky_32` | The Nightmare | Le Cauchemar | 9 | 42 | — | ch20+ |
| `new_era_sky_33` | Spacial Rift | Faille Spatiale | 15 | 43 | oui | ch20+ |
| `new_era_sky_34` | Dark Crater | Cratère Obscur | 15 | 44 | oui | ch20+ |
| `new_era_sky_35` | Concealed Ruins | Ruines Dissimulées | 14 | 42 | — | post-game |
| `new_era_sky_36` | Marine Resort | Havre Marin | 19 | 43 | — | post-game |
| `new_era_sky_37` | Bottomless Sea | Mer sans Fond | 25 | 45 | oui | post-game |
| `new_era_sky_38` | Shimmer Desert | Désert Chatoyant | 25 | 45 | oui | post-game |
| `new_era_sky_39` | Mt. Avalanche | Mont des Avalanches | 20 | 46 | oui | post-game |
| `new_era_sky_40` | Giant Volcano | Volcan Géant | 20 | 46 | oui | post-game |
| `new_era_sky_41` | World Abyss | Abysse du Monde | 20 | 47 | oui | post-game |
| `new_era_sky_42` | Sky Stairway | Escalier Céleste | 25 | 48 | oui | post-game |
| `new_era_sky_43` | Mystery Jungle | Jungle Mystère | 30 | 47 | oui | post-game |
| `new_era_sky_44` | Serenity River | Rivière Sereine | 9 | 30 | — | post-game |
| `new_era_sky_45` | Landslide Cave | Grotte des Éboulements | 10 | 31 | — | post-game |
| `new_era_sky_46` | Lush Prairie | Prairie Verdoyante | 9 | 32 | — | post-game |
| `new_era_sky_47` | Tiny Meadow | Pré Minuscule | 9 | 33 | — | post-game |
| `new_era_sky_48` | Labyrinth Cave | Grotte du Labyrinthe | 15 | 34 | — | post-game |
| `new_era_sky_49` | Oran Forest | Forêt des Oran | 17 | 35 | — | post-game |
| `new_era_sky_50` | Lake Afar | Lac Lointain | 20 | 36 | oui | post-game |
| `new_era_sky_51` | Happy Outlook | Belvédère Serein | 20 | 37 | oui | post-game |
| `new_era_sky_52` | Mt. Mistral | Mont Mistral | 20 | 38 | oui | post-game |
| `new_era_sky_53` | Shimmer Hill | Colline Chatoyante | 20 | 39 | oui | post-game |
| `new_era_sky_54` | Lost Wilderness | Étendue Perdue | 20 | 40 | oui | post-game |
| `new_era_sky_55` | Midnight Forest | Forêt de Minuit | 20 | 41 | oui | post-game |
| `new_era_sky_56` | Zero Isle North | Île Zéro — Nord | 25 | 1 | — | post-game |
| `new_era_sky_57` | Zero Isle East | Île Zéro — Est | 40 | 1 | — | post-game |
| `new_era_sky_58` | Zero Isle West | Île Zéro — Ouest | 40 | 1 | — | post-game |
| `new_era_sky_59` | Zero Isle South | Île Zéro — Sud | 50 | 1 | — | post-game |
| `new_era_sky_60` | Zero Isle Center | Île Zéro — Centre | 99 | 1 | — | post-game |
| `new_era_sky_61` | Destiny Tower | Tour du Destin | 99 | 1 | — | post-game |
| `new_era_sky_62` | Oblivion Forest | Forêt de l'Oubli | 30 | 48 | oui | post-game |
| `new_era_sky_63` | Treacherous Waters | Eaux Traîtresses | 30 | 48 | oui | post-game |
| `new_era_sky_64` | Southeastern Islands | Îles du Sud-Est | 30 | 48 | oui | post-game |
| `new_era_sky_65` | Inferno Cave | Grotte Infernale | 30 | 48 | oui | post-game |
| `new_era_sky_66` | Star Cave | Grotte des Étoiles | 20 | 49 | oui | post-game |

## 4. Étages — source et incertitude assumée

**Bulbapedia n'est pas consultable depuis ce sandbox** (pas d'accès réseau garanti).
Les nombres d'étages proviennent donc de ma connaissance d'Explorers of Sky, **pas** d'un
recoupement de source. Ils sont cohérents entre eux et jouables, mais doivent être
considérés comme **à vérifier**.

Valeurs les moins sûres, à recouper en priorité :

| Zone | Retenu | Remarque |
|---|---|---|
| Zero Isle East / West | 40 | l'original varie selon l'île |
| Zero Isle South | 50 | idem |
| Zero Isle Center | 99 | valeur « palier », à confirmer |
| Mystery Jungle | 30 | l'original a une partie profonde distincte |
| Bottomless Sea / Shimmer Desert | 25 | souvent cités à 20 ou 30 |
| Marine Resort | 19 | proche de 20, à confirmer |

Les donjons courts du début (Beach Cave 4, Drenched Bluff 6, Mt. Bristle 8,
Apple Woods 6, Craggy Coast 6, Mt. Horn 9) sont en revanche fiables.

## 5. Substitutions d'autotiles (37)

Beaucoup d'autotiles EoS ne sont pas fournis par ce dépôt : ils viennent du jeu de base
PMDO/PMDODump. Règle appliquée, celle de la consigne — **substitut du même biome,
documenté**. Critère retenu : n'utiliser QUE des autotiles déjà référencés par une zone
existante, donc déjà éprouvés en jeu.

| Donjon | Souhaité | Substitut | Biome |
|---|---|---|---|
| Apple Woods | `apple_woods` | `treeshroud_forest_1` | forest |
| Beach Cave | `beach_cave` | `craggy_coast` | beach |
| Blizzard Island | `blizzard_island` | `frosty_forest` | ice |
| Bottomless Sea | `bottomless_sea` | `surrounded_sea` | water |
| Concealed Ruins | `concealed_ruins` | `buried_relic_1` | relic |
| Crevice Cave | `crevice_cave` | `frosty_forest` | ice |
| Crystal Crossing | `crystal_crossing` | `frosty_forest` | ice |
| Dark Hill | `dark_hill` | `the_nightmare` | ghost |
| Destiny Tower | `destiny_tower` | `sky_tower` | sky |
| Drenched Bluff | `drenched_bluff` | `chasm_cave_1` | cave |
| Dusk Forest | `dusk_forest` | `the_nightmare` | ghost |
| Giant Volcano | `giant_volcano` | `deep_dark_crater` | fire |
| Happy Outlook | `happy_outlook` | `sky_tower` | sky |
| Hidden Land | `hidden_land` | `mystery_jungle_2` | jungle |
| Inferno Cave | `inferno_cave` | `deep_dark_crater` | fire |
| Labyrinth Cave | `labyrinth_cave` | `chasm_cave_1` | cave |
| Lake Afar | `lake_afar` | `surrounded_sea` | water |
| Landslide Cave | `landslide_cave` | `chasm_cave_1` | cave |
| Lost Wilderness | `lost_wilderness` | `mystery_jungle_2` | jungle |
| Marine Resort | `marine_resort` | `surrounded_sea` | water |
| Midnight Forest | `midnight_forest` | `the_nightmare` | ghost |
| Mt. Avalanche | `mt_avalanche` | `frosty_forest` | ice |
| Mt. Bristle | `mt_bristle` | `mt_horn` | mountain |
| Mt. Mistral | `mt_mistral` | `mt_horn` | mountain |
| Mt. Travail | `mt_travail` | `mt_horn` | mountain |
| Oblivion Forest | `oblivion_forest` | `the_nightmare` | ghost |
| Oran Forest | `oran_forest` | `treeshroud_forest_1` | forest |
| Sealed Ruin | `sealed_ruin` | `buried_relic_1` | relic |
| Serenity River | `serenity_river` | `surrounded_sea` | water |
| Shimmer Desert | `shimmer_desert` | `northern_desert_1` | desert |
| Shimmer Hill | `shimmer_hill` | `sky_tower` | sky |
| Sky Stairway | `sky_stairway` | `sky_tower` | sky |
| Southeastern Islands | `southeastern_islands` | `craggy_coast` | beach |
| Star Cave | `star_cave` | `buried_relic_1` | relic |
| Steam Cave | `steam_cave` | `deep_dark_crater` | fire |
| Treacherous Waters | `treacherous_waters` | `surrounded_sea` | water |
| Waterfall Cave | `waterfall_cave` | `surrounded_sea` | water |

Substitution supplémentaire après audit : `chasm_cave_1_secondary` n'était référencé
nulle part (seuls `_floor` et `_wall` le sont) → remplacé par `murky_cave_secondary`
sur 4 zones. Après ce correctif, **aucune référence non éprouvée** ne subsiste.

25 autotiles EoS sont utilisés tels quels, sans substitution : `craggy_coast`,
`side_path`, `mt_horn`, `rock_path_tds`, `foggy_forest`, `amp_plains`,
`northern_desert_1`, `quicksand_cave`, `crystal_cave_1`, `chasm_cave_1`,
`deep_dusk_forest_2`, `treeshroud_forest_1`, `brine_cave`, `temporal_tower`,
`mystifying_forest`, `surrounded_sea`, `miracle_sea`, `the_nightmare`,
`spacial_rift_1`, `deep_dark_crater`, `world_abyss_2`, `mystery_jungle_2`,
`lush_prairie`, `tiny_meadow`, `zero_isle_east_4`.

## 6. Stations-Relais

25 zones ont une Station-Relais (Terminal Kangourex, patron `searing_tunnel_midpoint`) :

- **7 relais « multi-parties »** correspondant aux donjons composés de l'original :
  Amp Plains (+Far), Brine Cave, Hidden Land (+Old Ruins), Temporal Tower (+Summit),
  Crevice Cave (+Lower), Spacial Rift (+Deep), Dark Crater (+Deep).
- **18 relais « mi-parcours »** ajoutés à la demande, pour tout donjon de 20 étages ou
  plus qui n'en avait pas. Le donjon est coupé en deux segments à peu près égaux.

**Exception assumée : les gauntlets restent sans relais.** Zero Isle ×5 et la Tour du
Destin n'ont volontairement aucun point de sauvegarde — c'est leur intérêt dans
l'original, et y mettre un Terminal les viderait de leur sens.

## 7. Restrictions d'origine

| Zone | Level | LevelCap | TeamRestrict | TeamSize | MoneyRestrict | BagRestrict |
|---|---|---|---|---|---|---|
| Tour du Destin | 1 | oui | oui | 1 (solo) | oui | 0 (sac vide) |
| Zero Isle ×5 | 1 | oui | non | -1 | oui | 0 (sac vide) |

Posées sur le patron exact de `new_era_zone_26` (Puits des Vœux) et recopiées
à l'identique dans le `ZoneEntrySummary` — le moteur valide contre le résumé.
Nuance : les Zero Isles autorisent l'équipe, la Tour du Destin est strictement solo,
conformément à l'original.

## 8. Contenu narratif

**Aucun boss, aucune cinématique, aucun ground de cinématique** — conforme à la
consigne. Chaque zone finit par `EndDungeonRun(..., "master_zone", -1, 1, 0, ...)`,
retour Metano. Les scènes viendront dans une vague ultérieure, comme pour les Veilleurs.

**Aucun légendaire ni fabuleux** : les 14 tables d'espèces ne contiennent que des
Pokémon ordinaires gén. 4-9. Les donjons EoS à boss légendaire sont recréés sans boss.

**Reskin systématique** : noms français originaux, lexique des bâtisseurs (Station,
Terminal, Sente, Balise). Aucune référence à l'intrigue d'EoS, et jamais
« Necrozma », « Eternatus » ni « l'Abîme ».

## 9. Déblocage

Dans `services/debug_tools/init.lua`, même mécanisme `OnUpgrade` que l'add-on pmd-red
(couvre nouvelles parties et sauvegardes existantes) :

- **24 zones** au ch11+ (Beach Cave → Brine Cave)
- **11 zones** au ch20+ (Hidden Land → Dark Crater)
- **32 zones** derrière `StoryCompleted` (post-game)

## 10. Validation exécutée

1. `json.load(utf-8-sig)` — 67 zones + `index.idx` : **OK**
2. Syntaxe Lua — **632/632** fichiers du dépôt : **OK**
3. Audit des références — autotiles non éprouvés : **aucun** ; musiques absentes :
   **aucune** ; 25 relais `.rsground` valides
4. 5 zones au hasard **+ contrôle exhaustif des 67** : chaque segment a des étages (>0),
   `CountedFloors` == somme, `len(Maps)` == nb segments, `index.Grounds` ==
   `json.GroundMaps` → **0 incohérence**
5. Périmètre : fichiers nouveaux + `index.idx` + déblocage + 3 tags + doc
