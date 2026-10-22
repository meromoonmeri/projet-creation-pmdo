# INVENTAIRE CENTRAL DES DONJONS (Source de Vérité Unique)

**Projet** : *New Era : Abyss to Ascension* (moteur RogueEssence / PMDO)  
**Rôle** : Répertoire unique des donjons d'histoire et secondaires (Chapitres 6 à 32), consignant nom, chapitre, rang narratif, structure, biomes, arènes d'étage (`.rsmap`), mini-boss, légendaires, bestiaire (20 à 50 espèces/donjon), objets, marchand Kecleon, missions du Job Board (`SecondaryJobs.lua`), quêtes secondaires PNJ de Metano Town (`SideQuests.lua`) avec **retour automatique en cinématique de récompense (PNJ ou Job Board de Bekipan)**, et musique.  
**Règle du Framework (§9)** : Chaque chapitre secondaire est **d'abord listé et présenté pour validation** ci-dessous avant toute génération détaillée de fichiers `.json` ou `.lua`.

---

## 1. DONJONS PRINCIPAUX D'HISTOIRE (CHAPITRES 5 À 10)

| Chapitre | Identifiant (`ID`) | Nom Français | Étages / Segments | Relais / Checkpoints | Boss Final (Arène `.rsmap`) | Gardiens | Musique Principale |
| :---: | :--- | :--- | :---: | :--- | :--- | :--- | :--- |
| **Ch 5 — FINAL** | `cloven_ruins` | Aegis Cave — héritage d’**Aegis Cave** | 15 étages pertinents / 8 segments | `cloven_ruins_entrance`, salles de stèle | **Regigigas** (`sanctuaire_titans`, segment 7) | Regice, Regirock, Registeel dans leurs arènes intégrées | `Aegis Cave.ogg` |
| **Ch 6** | `gloomy_forest` | Forêt Lugubre | 26 ét. / 11 seg. | `gloomy_forest_midpoint` | **Zeraora** (`gloomy_forest_boss.rsmap`) | Tengalice et Cornèbre (`gloomy_forest_miniboss`) | `Mystifying Forest.ogg` |
| **Ch 8** | `crystal_sanctuary` | Sanctuaire de Cristal | 25 ét. / 6 seg. | `crystal_sanctuary_relay` | **Diancie** (`crystal_sanctuary_boss`) | Carbink & Froslass (`crystal_sanctuary_miniboss`) | `Crystal Crossing.ogg` |
| **Ch 9** | `forgotten_marsh` | Marais de l'Oubli | 25 ét. / 6 seg. | `forgotten_marsh_relay` | **Laggron / Swampert** (`forgotten_marsh_boss`) | Swalot & Toxicroak (`forgotten_marsh_miniboss`) | `Cave Camp.ogg` |
| **Ch 10** | `celestial_peak` | Pic Céleste | 44 ét. / 6 seg. | `celestial_peak_relay` | **Lugia** (`celestial_peak_boss`) | Escouade Fulgur (`celestial_peak_fulgur`) | `Summit.ogg` |

---

## 2. SYNTHÈSE DU ROSTER DES DONJONS SECONDAIRES (CHAPITRES 6 À 10 — POUR VALIDATION)

> **Exigence Structure & Arènes d'Étage (§1, §1.5)** :  
> Chaque donjon secondaire ci-dessous comporte **20 ÉTAGES EXACTS** :
> - **17 étages d'exploration procédurale** (divisés en 2 segments de biome avec scaling de niveau et 22 à 26 espèces sauvages vérifiées).
> - **3 ARÈNES D'ÉTAGE DÉDIÉES (`.rsmap`)** intégrées dans le donjon (Étage 6, Étage 13, Étage 20) : chaque mini-boss ou boss est combattu dans sa **propre salle de confrontation (`.rsmap`)**, adaptée aux tuiles et au biome de son segment.  
> **Zéro ground indépendant (`.rsground`) pour les boss**, et **zéro légendaire gratuit** dans ces donjons secondaires.

---

### A. CHAPITRE 6 — DONJONS SECONDAIRES (20 ÉTAGES / 3 ARÈNES D'ÉTAGE)

| Identifiant (`ID`) | Nom Français | Total Étages | Biomes (Seg 1 → Seg 2) | Espèces Sauvages (`20-50/donjon`, Lv 18-33) | Les 3 Arènes d'Étage (`.rsmap` intégrées, adaptées au biome) | Relais (Modèle Tunnel Incandescent + Kangourex) |
| :--- | :--- | :---: | :--- | :--- | :--- | :--- |
| **`forsaken_desert`** | **Désert des Oubliés** | **22 ét.** | Désert Ardent → Vallée Stérile | **22 espèces**<br>*(Stade 1 → Évolué)* | • **Ét. 7 (`forsaken_desert_mb1.rsmap`)** : Sablaireau l'Ancien<br>• **Ét. 14 (`forsaken_desert_mb2.rsmap`)** : Cacturne le Veilleur<br>• **Ét. 22 (`forsaken_desert_boss.rsmap`)** : Hippodocus le Colosse | `forsaken_desert_relay.rsground` (Biome Désert Aride) |
| **`geode_crevice`** | **Crevasse de Géode** | **24 ét.** | Grotte Cristal → Caverne Quartz | **24 espèces**<br>*(Stade 1 → Évolué)* | • **Ét. 8 (`geode_crevice_mb1.rsmap`)** : Gravalanch du Filon<br>• **Ét. 16 (`geode_crevice_mb2.rsmap`)** : Tarinor la Boussole<br>• **Ét. 24 (`geode_crevice_boss.rsmap`)** : Gigalithe le Diamant | `geode_crevice_relay.rsground` (Biome Cristal) |
| **`wild_orchard`** | **Verger Sauvage** | **23 ét.** | Bois Pommes → Sentier Verger | **24 espèces**<br>*(Stade 1 → Évolué)* | • **Ét. 7 (`wild_orchard_mb1.rsmap`)** : Scarhino la Corne<br>• **Ét. 15 (`wild_orchard_mb2.rsmap`)** : Scarabrute la Pince<br>• **Ét. 23 (`wild_orchard_boss.rsmap`)** : Apireine la Souveraine | `wild_orchard_relay.rsground` (Biome Forêt) |
| **`scorched_plains`** | **Plaines Brûlées** | **25 ét.** | Plaines Élec → Plaines Arides | **22 espèces**<br>*(Stade 1 → Évolué)* | • **Ét. 8 (`scorched_plains_mb1.rsmap`)** : Luxio l'Éclair<br>• **Ét. 16 (`scorched_plains_mb2.rsmap`)** : Phanpy la Charge<br>• **Ét. 25 (`scorched_plains_boss.rsmap`)** : Élecsprint la Tempête | `scorched_plains_relay.rsground` (Biome Savane) |

---

### B. CHAPITRE 7 — DONJONS SECONDAIRES (20 ÉTAGES / 3 ARÈNES D'ÉTAGE)

| Identifiant (`ID`) | Nom Français | Total Étages | Biomes (Seg 1 → Seg 2) | Espèces Sauvages (`20-50/donjon`, Lv 20-35) | Les 3 Arènes d'Étage (`.rsmap` intégrées, adaptées au biome) | Relais (Modèle Tunnel Incandescent + Kangourex) |
| :--- | :--- | :---: | :--- | :--- | :--- | :--- |
| **`energy_garden`** | **Jardin d'Énergie** | **20 ét.** | Grotte Cristal → Caverne Énergie | **24 espèces**<br>*(Stade 1 → Évolué)* | • **Ét. 6 (`energy_garden_mb1.rsmap`)** : Magnéton le Flux<br>• **Ét. 13 (`energy_garden_mb2.rsmap`)** : Tarpaud la Résonance<br>• **Ét. 20 (`energy_garden_boss.rsmap`)** : Lucario l'Onde | `energy_garden_relay.rsground` (Biome Énergie) |
| **`sunken_relic`** | **Relique Engloutie** | **20 ét.** | Grotte Ouest → Ruines Antiques | **22 espèces**<br>*(Stade 1 → Évolué)* | • **Ét. 6 (`sunken_relic_mb1.rsmap`)** : Kaorine le Sceau<br>• **Ét. 13 (`sunken_relic_mb2.rsmap`)** : Archéodong la Cloche<br>• **Ét. 20 (`sunken_relic_boss.rsmap`)** : Tutufeur le Gardien | `sunken_relic_relay.rsground` (Biome Ruines Antiques) |
| **`mossy_labyrinth`** | **Labyrinthe Moussue** | **20 ét.** | Forêt Moussue → Forêt Envahie | **24 espèces**<br>*(Stade 1 → Évolué)* | • **Ét. 6 (`mossy_labyrinth_mb1.rsmap`)** : Tengalice la Canopée<br>• **Ét. 13 (`mossy_labyrinth_mb2.rsmap`)** : Bouldeneu la Racine<br>• **Ét. 20 (`mossy_labyrinth_boss.rsmap`)** : Torterra le Géant | `mossy_labyrinth_relay.rsground` (Biome Forêt Moussue) |
| **`magma_quarry`** | **Carrière Magmatique** | **20 ét.** | Caverne Magma → Sommet Volcan | **22 espèces**<br>*(Stade 1 → Évolué)* | • **Ét. 6 (`magma_quarry_mb1.rsmap`)** : Camerupt la Lave<br>• **Ét. 13 (`magma_quarry_mb2.rsmap`)** : Démolosse le Foyer<br>• **Ét. 20 (`magma_quarry_boss.rsmap`)** : Arkani la Flamme | `magma_quarry_relay.rsground` (Biome Volcan) |

---

### C. CHAPITRE 8 — DONJONS SECONDAIRES (20 ÉTAGES / 3 ARÈNES D'ÉTAGE)

| Identifiant (`ID`) | Nom Français | Total Étages | Biomes (Seg 1 → Seg 2) | Espèces Sauvages (`20-50/donjon`, Lv 25-40) | Les 3 Arènes d'Étage (`.rsmap` intégrées, adaptées au biome) | Relais (Modèle Tunnel Incandescent + Kangourex) |
| :--- | :--- | :---: | :--- | :--- | :--- | :--- |
| **`barren_tundra`** | **Toundra Désolée** | **20 ét.** | Sentier Glace → Toundra Désolée | **26 espèces**<br>*(Stade 1 → Évolué)* | • **Ét. 6 (`barren_tundra_mb1.rsmap`)** : Mammochon le Glacier<br>• **Ét. 13 (`barren_tundra_mb2.rsmap`)** : Oniglali le Gel<br>• **Ét. 20 (`barren_tundra_boss.rsmap`)** : Blizzarroi l'Hiver | `barren_tundra_relay.rsground` (Biome Neige) |
| **`barren_cavern`** | **Caverne Stérile** | **20 ét.** | Grotte Rocheuse → Caverne Profonde | **24 espèces**<br>*(Stade 1 → Évolué)* | • **Ét. 6 (`barren_cavern_mb1.rsmap`)** : Steelix la Faille<br>• **Ét. 13 (`barren_cavern_mb2.rsmap`)** : Galeking le Fer<br>• **Ét. 20 (`barren_cavern_boss.rsmap`)** : Charmina le Sceau | `barren_cavern_relay.rsground` (Biome Grotte) |
| **`cracked_ridge`** | **Crête Craquelée** | **20 ét.** | Col Rocheux → Crête Craquelée | **25 espèces**<br>*(Stade 1 → Évolué)* | • **Ét. 6 (`cracked_ridge_mb1.rsmap`)** : Rhinastoc la Roche<br>• **Ét. 13 (`cracked_ridge_mb2.rsmap`)** : Tyranocif l'Abysse<br>• **Ét. 20 (`cracked_ridge_boss.rsmap`)** : Drattak la Cime | `cracked_ridge_relay.rsground` (Biome Crête) |
| **`suspended_valley`** | **Vallon Suspendu** | **20 ét.** | Vallon Brumeux → Vallon Suspendu | **22 espèces**<br>*(Stade 1 → Évolué)* | • **Ét. 6 (`suspended_valley_mb1.rsmap`)** : Roucarnage le Vent<br>• **Ét. 13 (`suspended_valley_mb2.rsmap`)** : Altaria la Brume<br>• **Ét. 20 (`suspended_valley_boss.rsmap`)** : Bruyverne le Cri | `suspended_valley_relay.rsground` (Biome Cimes) |

---

### D. CHAPITRE 9 — DONJONS SECONDAIRES (20 ÉTAGES / 3 ARÈNES D'ÉTAGE)

| Identifiant (`ID`) | Nom Français | Total Étages | Biomes (Seg 1 → Seg 2) | Espèces Sauvages (`20-50/donjon`, Lv 30-45) | Les 3 Arènes d'Étage (`.rsmap` intégrées, adaptées au biome) | Relais (Modèle Tunnel Incandescent + Kangourex) |
| :--- | :--- | :---: | :--- | :--- | :--- | :--- |
| **`depleted_basin`** | **Bassin Tari** | **20 ét.** | Bassin Aride → Fond Tari | **25 espèces**<br>*(Stade 1 → Évolué)* | • **Ét. 6 (`depleted_basin_mb1.rsmap`)** : Akwakwak la Secheresse<br>• **Ét. 13 (`depleted_basin_mb2.rsmap`)** : Flagadoss le Calme<br>• **Ét. 20 (`depleted_basin_boss.rsmap`)** : Léviator le Courroux | `depleted_basin_relay.rsground` (Biome Bassin) |
| **`wayward_wetlands`** | **Marais Errants** | **20 ét.** | Marais Humide → Marais Errants | **24 espèces**<br>*(Stade 1 → Évolué)* | • **Ét. 6 (`wayward_wetlands_mb1.rsmap`)** : Ludicolo la Danse<br>• **Ét. 13 (`wayward_wetlands_mb2.rsmap`)** : Colhomard la Pince<br>• **Ét. 20 (`wayward_wetlands_boss.rsmap`)** : Milobellus le Bassin | `wayward_wetlands_relay.rsground` (Biome Marais) |
| **`southern_jungle`** | **Jungle Méridionale** | **20 ét.** | Forêt Tropicale → Jungle Dense | **26 espèces**<br>*(Stade 1 → Évolué)* | • **Ét. 6 (`southern_jungle_mb1.rsmap`)** : Empiflor le Liane<br>• **Ét. 13 (`southern_jungle_mb2.rsmap`)** : Noadkoko le Soleil<br>• **Ét. 20 (`southern_jungle_boss.rsmap`)** : Roserade le Venin | `southern_jungle_relay.rsground` (Biome Jungle) |
| **`submerged_chasm`** | **Gouffre Immergé** | **20 ét.** | Grotte Marine → Gouffre Profond | **24 espèces**<br>*(Stade 1 → Évolué)* | • **Ét. 6 (`submerged_chasm_mb1.rsmap`)** : Crustabri la Coquille<br>• **Ét. 13 (`submerged_chasm_mb2.rsmap`)** : Ectoplasma l'Ombre<br>• **Ét. 20 (`submerged_chasm_boss.rsmap`)** : Hyporoi le Fond | `submerged_chasm_relay.rsground` (Biome Océanique) |

---

### E. CHAPITRE 10 — DONJONS SECONDAIRES (20 ÉTAGES / 3 ARÈNES D'ÉTAGE)

| Identifiant (`ID`) | Nom Français | Total Étages | Biomes (Seg 1 → Seg 2) | Espèces Sauvages (`20-50/donjon`, Lv 35-50) | Les 3 Arènes d'Étage (`.rsmap` intégrées, adaptées au biome) | Relais (Modèle Tunnel Incandescent + Kangourex) |
| :--- | :--- | :---: | :--- | :--- | :--- | :--- |
| **`snowbound_path`** | **Sentier Enneigé** | **22 ét.** | Sentier Blanc → Col Glacial | **25 espèces**<br>*(Stade 1 → Évolué)* | • **Ét. 7 (`snowbound_path_mb1.rsmap`)** : Kaimorse le Croc<br>• **Ét. 14 (`snowbound_path_mb2.rsmap`)** : Polagriffe la Tempête<br>• **Ét. 22 (`snowbound_path_boss.rsmap`)** : Momartik le Souffle | `snowbound_path_relay.rsground` (Biome Neige) |
| **`thunderstruck_pass`** | **Col de la Foudre** | **24 ét.** | Col Orageux → Crête Foudroyée | **24 espèces**<br>*(Stade 1 → Évolué)* | • **Ét. 8 (`thunderstruck_pass_mb1.rsmap`)** : Élekable la Haute-Tension<br>• **Ét. 16 (`thunderstruck_pass_mb2.rsmap`)** : Luxray le Foudre<br>• **Ét. 24 (`thunderstruck_pass_boss.rsmap`)** : Magnézone l'Éclair | `thunderstruck_pass_relay.rsground` (Biome Électrique) |
| **`flyaway_cliffs`** | **Falaises de l'Envol** | **25 ét.** | Falaises Aériennes → Cimes Volantes | **26 espèces**<br>*(Stade 1 → Évolué)* | • **Ét. 8 (`flyaway_cliffs_mb1.rsmap`)** : Airmure la Lame<br>• **Ét. 16 (`flyaway_cliffs_mb2.rsmap`)** : Xatu l'Oracle<br>• **Ét. 25 (`flyaway_cliffs_boss.rsmap`)** : Roucarnage le Sommet | `flyaway_cliffs_relay.rsground` (Biome Falaises) |
| **`forgotten_silver_spire`** | **Cime d'Argent Oubliée** | **23 ét.** | Spirale Antique → Cime Oubliée | **25 espèces**<br>*(Stade 1 → Évolué)* | • **Ét. 7 (`forgotten_silver_spire_mb1.rsmap`)** : Alakazam l'Esprit<br>• **Ét. 15 (`forgotten_silver_spire_mb2.rsmap`)** : Gardevoir la Vision<br>• **Ét. 23 (`forgotten_silver_spire_boss.rsmap`)** : Kaorine l'Antique | `forgotten_silver_spire_relay.rsground` (Biome Tour Céleste) |

---

**J'attends ta validation** sur ce roster de **20 donjons secondaires de 20 étages exacts** (dont **3 arènes d'étage `.rsmap` par donjon** et **20 à 50 espèces sauvages en scaling évolutif**) avant d'engager la génération des fichiers de zone et de cartes !

---

## 3. ROSTER DES DONJONS SECONDAIRES POUR LE CHAPITRE 11 — L'ARC FUGITIF (GÉNÉRÉS ET VALIDÉS)

> **Contexte Narratif (Chapitre 11 — Arc Fugitif)** :  
> À la suite des événements de la Tour Céleste au Chapitre 10, le Héros et son Partenaire sont isolés et doivent fuir dans les terres sauvages et hostiles du Nord sous une pluie battante. Les donjons secondaires du Chapitre 11 reflètent cet environnement rude, humide et escarpé.  
> **Respect du Framework (§1, §9)** :
> - **22 à 25 étages d'exploration** par donjon (2 segments de biome, scaling de niveau Lv 38-53, 20 à 50 espèces sauvages vérifiées dans `Content/Chara/`).
> - **3 arènes d'étage `.rsmap` intégrées** par donjon (aucun ground `.rsground` indépendant pour les boss).
> - **Zéro concept de Temps ou d'Espace** dans les donjons secondaires.
> - **Relais Kangourex** au modèle `searing_tunnel_midpoint` adapté au biome.

| Identifiant (`ID`) | Nom Français | Total Étages | Biomes (Seg 1 → Seg 2) | Espèces Sauvages (`20-50/donjon`, Lv 38-53) | Les 3 Arènes d'Étage (`.rsmap` intégrées, adaptées au biome) | Relais (Modèle Tunnel Incandescent + Kangourex) |
| :--- | :--- | :---: | :--- | :--- | :--- | :--- |
| **`rainy_ravine`** | **Ravin Pluvieux** | **22 ét.** | Ravin Brumeux → Torrent Rocailleux | **26 espèces**<br>*(Stade 1 → Évolué)* | • **Ét. 7 (`rainy_ravine_mb1.rsmap`)** : Maraiste le Torrent<br>• **Ét. 14 (`rainy_ravine_mb2.rsmap`)** : Barbicha le Remous<br>• **Ét. 22 (`rainy_ravine_boss.rsmap`)** : Tarpaud la Tempête | `rainy_ravine_relay.rsground` (Biome Ravin Humide) |
| **`mossy_gorge`** | **Gorge Moussue** | **24 ét.** | Gorge Ombragée → Caverne Humide | **25 espèces**<br>*(Stade 1 → Évolué)* | • **Ét. 8 (`mossy_gorge_mb1.rsmap`)** : Tengalice l'Écorce<br>• **Ét. 16 (`mossy_gorge_mb2.rsmap`)** : Torterra la Racine<br>• **Ét. 24 (`mossy_gorge_boss.rsmap`)** : Ludicolo le Déluge | `mossy_gorge_relay.rsground` (Biome Gorge Moussue) |
| **`windswept_trail`** | **Piste Venteuse** | **23 ét.** | Sentier Rocailleux → Crête Boréale | **24 espèces**<br>*(Stade 1 → Évolué)* | • **Ét. 7 (`windswept_trail_mb1.rsmap`)** : Airmure la Rafale<br>• **Ét. 15 (`windswept_trail_mb2.rsmap`)** : Togekiss le Vent<br>• **Ét. 23 (`windswept_trail_boss.rsmap`)** : Aéromite le Bourrasque | `windswept_trail_relay.rsground` (Biome Crête Venteuse) |
| **`foggy_hollow`** | **Creux Brumeux** | **25 ét.** | Forêt Brouillard → Sous-Bois Oublié | **26 espèces**<br>*(Stade 1 → Évolué)* | • **Ét. 8 (`foggy_hollow_mb1.rsmap`)** : Spiritomb l'Écho<br>• **Ét. 16 (`foggy_hollow_mb2.rsmap`)** : Ectoplasma la Brume<br>• **Ét. 25 (`foggy_hollow_boss.rsmap`)** : Noctunoir le Guetteur | `foggy_hollow_relay.rsground` (Biome Forêt Brumeuse) |

---

---

## 4. ROSTER DES DONJONS SECONDAIRES POUR LE CHAPITRE 12 — L'ARC FUGITIF (GÉNÉRÉS ET VALIDÉS)

> **Contexte Narratif (Chapitre 12)** :  
> Toujours traqués dans les terres désolées du nord après les révélations de la Tour Céleste, le Héros et son Partenaire traversent des reliefs de plus en plus extrêmes, entre cendres volcaniques, failles glaciaires et marais tourbeux.  
> **Respect du Framework (§1, §9)** :
> - **22 à 25 étages d'exploration** par donjon (2 segments de biome, scaling de niveau Lv 40-56, 20 à 50 espèces sauvages vérifiées dans `Content/Chara/`).
> - **3 arènes d'étage `.rsmap` intégrées** par donjon (aucun ground `.rsground` indépendant pour les boss).
> - **Zéro concept de Temps ou d'Espace** dans les donjons secondaires.
> - **Relais Kangourex** au modèle `searing_tunnel_midpoint` adapté au biome.

| Identifiant (`ID`) | Nom Français | Total Étages | Biomes (Seg 1 → Seg 2) | Espèces Sauvages (`20-50/donjon`, Lv 40-56) | Les 3 Arènes d'Étage (`.rsmap` intégrées, adaptées au biome) | Relais (Modèle Tunnel Incandescent + Kangourex) |
| :--- | :--- | :---: | :--- | :--- | :--- | :--- |
| **`ashen_hollow`** | **Creux Cendré** | **22 ét.** | Grotte Cendrée → Terres Calcinées | **26 espèces**<br>*(Stade 1 → Évolué)* | • **Ét. 7 (`ashen_hollow_mb1.rsmap`)** : Limonde le Piège<br>• **Ét. 14 (`ashen_hollow_mb2.rsmap`)** : Grotadmorv le Boue<br>• **Ét. 22 (`ashen_hollow_boss.rsmap`)** : Grotadmorv d'Alola le Toxique | `ashen_hollow_relay.rsground` (Biome Cendres) |
| **`frozen_rift`** | **Faille Gelée** | **24 ét.** | Faille Glaciale → Caverne Cristal de Glace | **25 espèces**<br>*(Stade 1 → Évolué)* | • **Ét. 8 (`frozen_rift_mb1.rsmap`)** : Grelaçon le Gel<br>• **Ét. 16 (`frozen_rift_mb2.rsmap`)** : Hexagel le Cristal<br>• **Ét. 24 (`frozen_rift_boss.rsmap`)** : Séracrawl le Roc Glacé | `frozen_rift_relay.rsground` (Biome Glacial) |
| **`whispering_crag`** | **Crête Chuchotante** | **23 ét.** | Crête Rocheuse → Sommet Venté | **24 espèces**<br>*(Stade 1 → Évolué)* | • **Ét. 7 (`whispering_crag_mb1.rsmap`)** : Aéromite l'Écho<br>• **Ét. 15 (`whispering_crag_mb2.rsmap`)** : Guériaigle le Vent<br>• **Ét. 23 (`whispering_crag_boss.rsmap`)** : Corvaillus l'Acier | `whispering_crag_relay.rsground` (Biome Crête) |
| **`twilight_marsh`** | **Marais Crépusculaire** | **25 ét.** | Marais Sombres → Bois Tourbeux | **26 espèces**<br>*(Stade 1 → Évolué)* | • **Ét. 8 (`twilight_marsh_mb1.rsmap`)** : Crapustule la Tourbe<br>• **Ét. 16 (`twilight_marsh_mb2.rsmap`)** : Bourrinos le Boue<br>• **Ét. 25 (`twilight_marsh_boss.rsmap`)** : Bourrinos la Tourbe | `twilight_marsh_relay.rsground` (Biome Marais) |

---

---

## 5. ROSTER DES DONJONS SECONDAIRES POUR LE CHAPITRE 13 — L'ARC DE LA BRUME DU NORD (GÉNÉRÉS ET VALIDÉS)

> **Contexte Narratif (Chapitre 13)** :  
> Le Héros et son Partenaire s'enfoncent plus profondément dans les terres glaciales et brumeuses du Nord. Les conditions d'exploration deviennent extrêmes, nécessitant une synergie parfaite.  
> **Respect du Framework (§1, §9)** :
> - **22 à 25 étages d'exploration** par donjon (2 segments de biome, scaling de niveau Lv 42-58, 20 à 50 espèces sauvages vérifiées dans `Content/Chara/`).
> - **3 arènes d'étage `.rsmap` intégrées** par donjon (aucun ground `.rsground` indépendant pour les boss).
> - **Zéro concept de Temps ou d'Espace** dans les donjons secondaires.
> - **Relais Kangourex** au modèle `searing_tunnel_midpoint` adapté au biome.

| Identifiant (`ID`) | Nom Français | Total Étages | Biomes (Seg 1 → Seg 2) | Espèces Sauvages (`20-50/donjon`, Lv 42-58) | Les 3 Arènes d'Étage (`.rsmap` intégrées, adaptées au biome) | Relais (Modèle Tunnel Incandescent + Kangourex) |
| :--- | :--- | :---: | :--- | :--- | :--- | :--- |
| **`shivering_cavern`** | **Caverne Grelottante** | **22 ét.** | Grotte Givre → Caverne Frisson | **26 espèces**<br>*(Stade 1 → Évolué)* | • **Ét. 7 (`shivering_cavern_mb1.rsmap`)** : Momartik le Souffle<br>• **Ét. 14 (`shivering_cavern_mb2.rsmap`)** : Blizzarroi le Givre<br>• **Ét. 22 (`shivering_cavern_boss.rsmap`)** : Blizzarroi le Gel Éternel | `shivering_cavern_relay.rsground` (Biome Givre) |
| **`tempest_ridge`** | **Crête de la Tempête** | **24 ét.** | Crête Orage → Sommet Foudre | **25 espèces**<br>*(Stade 1 → Évolué)* | • **Ét. 8 (`tempest_ridge_mb1.rsmap`)** : Élekable l'Éclair<br>• **Ét. 16 (`tempest_ridge_mb2.rsmap`)** : Magnézone le Flux<br>• **Ét. 24 (`tempest_ridge_boss.rsmap`)** : Fulguris le Tonnerre | `tempest_ridge_relay.rsground` (Biome Tempête) |
| **`hollow_thicket`** | **Fourré Creux** | **23 ét.** | Forêt Ronce → Sous-Bois Creux | **24 espèces**<br>*(Stade 1 → Évolué)* | • **Ét. 7 (`hollow_thicket_mb1.rsmap`)** : Desséliande l'Écorce<br>• **Ét. 15 (`hollow_thicket_mb2.rsmap`)** : Banshitrouye l'Ombre<br>• **Ét. 23 (`hollow_thicket_boss.rsmap`)** : Zarude le Rôdeur | `hollow_thicket_relay.rsground` (Biome Ronce) |
| **`silent_marsh`** | **Marais Silencieux** | **25 ét.** | Marais Brume → Tourbière Muette | **26 espèces**<br>*(Stade 1 → Évolué)* | • **Ét. 8 (`silent_marsh_mb1.rsmap`)** : Muplodocus la Brume<br>• **Ét. 16 (`silent_marsh_mb2.rsmap`)** : Tarpaud le Silence<br>• **Ét. 25 (`silent_marsh_boss.rsmap`)** : Muplodocus de Hisui l'Acier | `silent_marsh_relay.rsground` (Biome Tourbière) |

---

---

## 6. PROPOSITION DU ROSTER DES DONJONS SECONDAIRES POUR LE CHAPITRE 14 — L'ARC DU CIEL BORÉAL (POUR VALIDATION)

> **Contexte Narratif (Chapitre 14)** :  
> Le Héros et son Partenaire atteignent les sommets ultimes du Nord, sous les aurores boréales et les blizzards constants de la crête glaciaire.  
> **Respect du Framework (§1, §9)** :
> - **22 à 25 étages d'exploration** par donjon (2 segments de biome, scaling de niveau Lv 44-60, 20 à 50 espèces sauvages vérifiées dans `Content/Chara/`).
> - **3 arènes d'étage `.rsmap` intégrées** par donjon (aucun ground `.rsground` indépendant pour les boss).
> - **Zéro concept de Temps ou d'Espace** dans les donjons secondaires.
> - **Relais Kangourex** au modèle `searing_tunnel_midpoint` adapté au biome.

| Identifiant (`ID`) | Nom Français | Total Étages | Biomes (Seg 1 → Seg 2) | Espèces Sauvages (`20-50/donjon`, Lv 44-60) | Les 3 Arènes d'Étage (`.rsmap` intégrées, adaptées au biome) | Relais (Modèle Tunnel Incandescent + Kangourex) |
| :--- | :--- | :---: | :--- | :--- | :--- | :--- |
| **`aurora_pass`** | **Col de l'Aurore** | **22 ét.** | Sentier Boréal → Col Polaire | **26 espèces**<br>*(Stade 1 → Évolué)* | • **Ét. 7 (`aurora_pass_mb1.rsmap`)** : Momartik la Brume<br>• **Ét. 14 (`aurora_pass_mb2.rsmap`)** : Blizzarroi le Souffle<br>• **Ét. 22 (`aurora_pass_boss.rsmap`)** : Feunard d'Alola l'Aurore | `aurora_pass_relay.rsground` (Biome Boréal) |
| **`crystal_crevasse`** | **Crevasse Cristalline** | **24 ét.** | Grotte Quartz → Gouffre Glacé | **25 espèces**<br>*(Stade 1 → Évolué)* | • **Ét. 8 (`crystal_crevasse_mb1.rsmap`)** : Hexagel le Givre<br>• **Ét. 16 (`crystal_crevasse_mb2.rsmap`)** : Séracrawl la Glace<br>• **Ét. 24 (`crystal_crevasse_boss.rsmap`)** : Kaimorse le Glacier | `crystal_crevasse_relay.rsground` (Biome Cristal Glacé) |
| **`roaring_summit`** | **Sommet Grondant** | **23 ét.** | Montagne Ventée → Pic Tempête | **24 espèces**<br>*(Stade 1 → Évolué)* | • **Ét. 7 (`roaring_summit_mb1.rsmap`)** : Guériaigle l'Élan<br>• **Ét. 15 (`roaring_summit_mb2.rsmap`)** : Corvaillus l'Ombre<br>• **Ét. 23 (`roaring_summit_boss.rsmap`)** : Dracolosse le Sommet | `roaring_summit_relay.rsground` (Biome Sommet) |
| **`forgotten_tundra`** | **Toundra Oubliée** | **25 ét.** | Plaine Glacée → Désert Blanc | **26 espèces**<br>*(Stade 1 → Évolué)* | • **Ét. 8 (`forgotten_tundra_mb1.rsmap`)** : Mammochon le Croc<br>• **Ét. 16 (`forgotten_tundra_mb2.rsmap`)** : Polagriffe la Force<br>• **Ét. 25 (`forgotten_tundra_boss.rsmap`)** : Blizzarroi le Géant | `forgotten_tundra_relay.rsground` (Biome Toundra) |

---
