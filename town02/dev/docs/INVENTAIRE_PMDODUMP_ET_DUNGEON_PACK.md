# INVENTAIRE EXHAUSTIF DES DONJONS EXTERNES, ENTRÉES ET RELAIS

**Sources audichées** :  
1. `audinowho/PMDODump` (47 donjons officiels de génération procédurale PMDO)  
2. `DoubleTrio/dungeon-pack` (3 grands donjons fan-made + 6 Checkpoints / Relais de bivouac)  
**Date d'exécution** : 2026-08-04  
**Objectif** : Cartographie exhaustive et état des lieux complet **avant implémentation**, liant chaque donjon à son entrée (`entrance`) et son relais/bivouac (`relay` / `checkpoint`).

---

## SYNTHÈSE DES DEUX SOURCES

| Source | Nombre de Donjons | Entrées dédiées (`entrance`) | Relais / Checkpoints assignés (`relay` / `camp`) |
| :--- | :---: | :---: | :---: |
| **PMDODump** | **47 donjons** | 18 entrées intégrées (vagues 1-2) + 29 entrées de réserve | 18 relais intégrés + Relais `source_duns_imbi` assignés par biome |
| **DoubleTrio (`dungeon-pack`)** | **3 donjons** | 3 entrées dédiées | 6 Checkpoints natifs (`blaze`, `cove`, `elemental`, `forest`, `frost`, `rocky`) |
| **TOTAL** | **50 donjons** | **50 entrées (prêtes ou mappées)** | **50 relais / bivouacs de repos (100% couverts)** |

---

## 1. DONJONS `audinowho/PMDODump` (47 DONJONS)

### A. Donjons déjà intégrés et branchés (Vagues 1 & 2 — Chapitres 1 à 10)
Chaque donjon ci-dessous est d'ores et déjà branché au mod avec son point d'entrée et son relais opérationnels :

| ID d'Origine (`PMDODump`) | Nom Français (`New Era`) | Chapitre | Entrée (`entrance` / lisière) | Relais / Checkpoint (`relay` / `midpoint`) | Boss / Gardien |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `Tiny_Tunnel` | Petit Tunnel | **Ch1** | `tiny_tunnel_entrance` | *Donjon court (sans relais)* | — |
| `Fertile_Valley` | Vallée Fertile | **Ch1** | `fertile_valley_entrance` | `fertile_valley_relay` | — |
| `Cave_Of_Solace` | Grotte du Repos | **Ch2** | `cave_of_solace_entrance` | `cave_of_solace_relay` (via `cave_camp`) | — |
| `Copper_Quarry` | Carrière de Cuivre | **Ch3** | `copper_quarry_entrance` | `copper_quarry_relay` | — |
| `Muddy_Valley` | Vallée Boueuse | **Ch3** | `muddy_valley_entrance` | `muddy_valley_relay` | — |
| `Castaway_Cave` | Grotte de l'Échoué | **Ch4** | `castaway_cave_entrance` | `castaway_cave_relay` | — |
| `Secret_Garden` | Jardin Secret | **Ch4** | `secret_garden_entrance` | `secret_garden_relay` | — |
| `Royal_Garden` | Halles Royales | **Ch4** | `royal_halls_entrance` | `royal_halls_relay` | — |
| `Ambush_Forest` | Forêt de l'Embuscade | **Ch5** | `ambush_forest_entrance` | `ambush_forest_relay` (`foret_embuscade_fond`) | — |
| `Trickster_Woods` | Bois du Filou | **Ch5** | `trickster_woods_entrance` | `trickster_woods_relay` | — |
| `Forsaken_Desert` | Désert des Oubliés | **Ch6** | `forsaken_desert_entrance` | `forsaken_desert_relay` | — |
| `Geode_Crevice` | Crevasse de Géode | **Ch6** | `geode_crevice_entrance` | `geode_crevice_relay` | — |
| `Energy_Garden` | Jardin d'Énergie | **Ch7** | `energy_garden_entrance` | `energy_garden_relay` | — |
| `Barren_Tundra` | Toundra Désolée | **Ch8** | `barren_tundra_entrance` | `barren_tundra_relay` (remplace `glacial_path`) | — |
| `Depleted_Basin` | Bassin Tari | **Ch9** | `depleted_basin_entrance` | `depleted_basin_relay` | — |
| `Wayward_Wetlands` | Marais Errants | **Ch9** | `wayward_wetlands_entrance` | `wayward_wetlands_relay` | — |
| `Snowbound_Path` | Sentier Enneigé | **Ch10** | `snowbound_path_entrance` | `snowbound_path_relay` (`snow_camp`) | — |
| `Thunderstruck_Pass` | Col de la Foudre | **Ch10** | `thunderstruck_pass_entrance` | `thunderstruck_pass_relay` | — |
| `Flyaway_Cliffs` | Falaises de l'Envol | **Ch10** | `flyaway_cliffs_entrance` | `flyaway_cliffs_relay` (`cliff_camp`) | — |

---

### B. Réserve Stratégique PMDODump (28 Donjons — Chapitres 11 à 32)
Ces donjons constituent la réserve assignée pour la suite de l'histoire. Chacun s'appuie sur le système de **Checkpoints de biome** (`source_duns_imbi/ground/*_camp`) pour ses relais à mi-parcours :

| ID d'Origine (`PMDODump`) | Nom Français (`New Era`) | Palier / Arc | Entrée assignée (`entrance`) | Relais assigné (`relay` / Checkpoint) | Légendaire / Boss assigné |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `Veiled_Ridge` | Crête Voilée | Palier 3 | `veiled_ridge_entrance` | `rocky_camp` (Checkpoint Rocheux) | **Raikou** (`storm_bell`) |
| `Deserted_Fortress` | Forteresse Abandonnée | Palier 3 | `deserted_fortress_entrance` | `base_camp` (Checkpoint Bastion) | — |
| `Magnetic_Quarry` | Carrière Magnétique | Palier 3 | `magnetic_quarry_entrance` | `rocky_camp` | — |
| `Exotic_Wilds` | Terres Exotiques | Palier 3 | `exotic_wilds_entrance` | `forest_camp` (Checkpoint Forêt) | — |
| `Sleeping_Caldera` | Caldeira Endormie | **Ch13-16** | `sleeping_caldera_entrance` | `blaze_camp` (Checkpoint Magma) | **Heatran** |
| `Lava_Floe_Island` | Île de Lave Flottante | **Ch13-16** | `lava_floe_island_entrance` | `blaze_camp` (Checkpoint Magma) | — |
| `Illusory_Ridge` | Crête de l'Illusion | **Ch13-16** | `illusory_ridge_entrance` | `cliff_camp` (Checkpoint Cimes) | — |
| `Clouded_Road` | Route Embrumée | **Ch13-16** | `clouded_road_entrance` | `canyon_camp` (Checkpoint Vallée) | — |
| `Trickster_Maze` | Labyrinthe du Filou | **Ch13-16** | `trickster_maze_entrance` | `forest_camp` | — |
| `Overgrown_Wilds` | Terres Envahies | **Ch13-16** | `overgrown_wilds_entrance` | `forest_camp` | — |
| `Sea_Current_Maze` | Labyrinthe des Courants | **Ch13-16** | `sea_current_maze_entrance` | `cove_camp` (Checkpoint Crique/Océan) | **Manaphy / Phione** |
| `Treacherous_Mountain` | Montagne Traîtresse | **Ch13-16** | `treacherous_mountain_entrance` | `cliff_camp` | *Arène custom (gardien alpin)* |
| `Moonlit_Courtyard` | Cour du Clair de Lune | **Ch17-20** | `moonlit_courtyard_entrance` | `forest_camp` | **Cresselia / Darkrai** |
| `Relic_Tower` | Tour des Reliques | **Ch17-20** | `relic_tower_entrance` | `base_camp` | **Dialga** (`hour_that_lags`) |
| `Abyssal_Island` | Île Abyssale | **Ch17-20** | `abyssal_island_entrance` | `cove_camp` | **Lugia** (réserve) |
| `Wisdom_Road` | Sentier du Savoir | **Ch17-20** | `wisdom_road_entrance` | `cave_camp` (Checkpoint Grotte) | **Uxie** (Créhelf) |
| `Hope_Road` | Sentier de l'Espoir | **Ch17-20** | `hope_road_entrance` | `cave_camp` | **Mesprit** (Créfollet) |
| `Bravery_Road` | Sentier du Courage | **Ch17-20** | `bravery_road_entrance` | `cave_camp` | **Azelf** (Créfadet) |
| `Eon_Island_Cave` | Île Éon — Grotte & Côte | **Ch17-20** | `eon_island_cave_entrance` | `cove_camp` | — |
| `Eon_Island_Field` | Île Éon — Plaine | **Ch21-24** | `eon_island_field_entrance` | `forest_camp` | — |
| `Eon_Island_Peak` | Île Éon — Cime | **Ch21-24** | `eon_island_peak_entrance` | `cliff_camp` | **Latios & Latias** (`twin_rift_latias`) |
| `Moonlit_Temple` | Temple du Clair de Lune | **Ch21-24** | `moonlit_temple_entrance` | `forest_camp` | **Cresselia** |
| `Starfall_Heights` | Hauteurs de l'Étoile Filante | **Ch21-24** | `starfall_heights_entrance` | `cliff_camp` | **Solgaleo** (`two_lights`) |
| `Oblivion_Valley` | Vallée de l'Oubli | **Ch21-24** | `oblivion_valley_entrance` | `canyon_camp` | **Yveltal** (`final_rest`) |
| `Primeval_Fissure` | Faille Primordiale | **Ch25-28** | `primeval_fissure_entrance` | `rocky_camp` | **Giratina** (`reverse_slope`) |
| `The_Sky` | Le Ciel Suspendu | **Ch25-28** | `the_sky_entrance` | `cliff_camp` | **Zygarde** (`cells_gathering`) |
| `Champion_Road` | Sentier du Champion | **Ch29-32** | `champion_road_entrance` | `base_camp` | **Boss narratif ultime** |

---

## 2. DONJONS ET CHECKPOINTS `DoubleTrio/dungeon-pack`

Le dépôt `DoubleTrio/dungeon-pack` apporte **3 grands donjons fan-made de palier 7 à 8** et le système complet des **6 Checkpoints de Bivouac** (qui sert de relais à tous les donjons de 15+ étages du mod) :

### A. Les 3 Grands Donjons du `dungeon-pack`

| ID d'Origine (`dungeon-pack`) | Nom Français (`New Era`) | Palier | Entrée dédiée (`entrance`) | Relais assigné (`checkpoint`) | Légendaire / Boss | Fonction Scénaristique |
| :--- | :--- | :---: | :--- | :--- | :--- | :--- |
| `emberfrost_depths` | **Profondeurs de Braise-Givre** | Palier 7 | `emberfrost_depths_entrance` | `blaze_camp` & `frost_camp` | **14+ Boss optionnels** | Gauntlet hybride feu/glace avec autels d'évolution. |
| `wishmaker_cave` | **Grotte du Vœu** | Palier 7 | `wishmaker_cave_entrance` | `cave_camp` (Grotte Astrale) | **Jirachi** | Donjon narratif majeur (vœu du héros, P7). |
| `adventurers_peak` | **Pic de l'Aventurier** | Palier 8 | `adventurers_peak_entrance` | `cliff_camp` | **Gauntlet Ultime** | Défi de fin de contenu (*Endgame*). |

---

### B. Cartographie des 6 Checkpoints de Bivouac (`dungeon-pack` -> `source_duns_imbi`)

Ces 6 cartes (`Data/Ground/*_camp.rsground`) constituent les **relais standardisés du projet** :

```
+--------------------------------------------------------------------------------+
| SYSTÈME DES CHECKPOINTS DE BIVOUAC (DoubleTrio / dungeon-pack)                 |
|                                                                                |
|  [ blaze_camp ]    -> Relais des donjons Magma / Volcaniques (ex. Caldeira)    |
|  [ cove_camp ]     -> Relais des donjons Maritimes / Plages (ex. Île Abyssale) |
|  [ elemental_camp ]-> Relais des donjons Énergétiques / Cristallins (Ch7-8)    |
|  [ forest_camp ]   -> Relais des donjons Sylvestres / Clairières (ex. Filou)   |
|  [ frost_camp ]    -> Relais des donjons Glaciaires / Neige (ex. Sentier)      |
|  [ rocky_camp ]    -> Relais des donjons Rocheux / Cavernes (ex. Crête Voilée) |
+--------------------------------------------------------------------------------+
```

| Checkpoint d'Origine | Fichier Ground dans le Projet | Biomes couplés | Exemple de Donjon rattaché |
| :--- | :--- | :--- | :--- |
| `blaze_camp` | `Data/Ground/blaze_camp.rsground` | Magma, Lave, Volcan, Feu | *Caldeira Endormie*, *Profondeurs de Braise-Givre* |
| `cove_camp` | `Data/Ground/cove_camp.rsground` | Crique, Océan, Marécage, Île | *Île Abyssale*, *Labyrinthe des Courants* |
| `elemental_camp` | `Data/Ground/elemental_camp.rsground` | Cristal, Énergie, Temple | *Jardin d'Énergie*, *Sanctuaire de Cristal* |
| `forest_camp` | `Data/Ground/forest_camp.rsground` | Forêt, Sous-bois, Jardin | *Bois du Filou*, *Cour du Clair de Lune* |
| `frost_camp` | `Data/Ground/frost_camp.rsground` | Glace, Neige, Toundra | *Sentier Enneigé*, *Toundra Désolée* |
| `rocky_camp` | `Data/Ground/rocky_camp.rsground` | Grotte, Montagne, Carrière | *Crête Voilée*, *Carrière Magnétique* |

---

## 3. RÈGLE D'IMPLÉMENTATION ACTÉE

**Aucun de ces donjons n'est implémenté sans vérifier au préalable** :
1. Que son **Entrée (`entrance`)** possède une carte valide (native PMDO ou générée et calibrée par notre protocole d'échelle `576×408 px` / `552×504 px`).
2. Que son **Relais à mi-parcours (`relay` / `checkpoint`)** est explicitement rattaché au Checkpoint de biome approprié (`source_duns_imbi/ground/*_camp.rsground`) dans sa table de zone JSON.
3. Que le **Boss ou Légendaire** rattaché ne rentre en conflit avec aucun donjon existant du même chapitre (`docs/DOCUMENT_MAITRE_donjons_externes.md`).
