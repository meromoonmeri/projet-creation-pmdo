# New Era — Direction Artistique PMD : Cartographie des Références Officielles
## Mapping systématique des assets PMD officiels → zones New Era
### Généré le 2026-07-26 — Projet New Era: Abyss to Ascension V4

---

## 📚 SOURCES ANALYSÉES

| Source | Contenu | Usage |
|--------|---------|-------|
| **pret/pmd-red** (GitHub) | Données complètes des 60+ donjons officiels, Friend Areas, scripts | Référence structurelle |
| **Spriters-Resource EoS** | 147 tilesets donjon + maps statiques + backgrounds | Référence visuelle |
| **Spriters-Resource RT** | 120+ tilesets GBA + backgrounds + Friend Areas | Référence visuelle |
| **TCRF (tcrf.net)** | Liste exhaustive tilesets EoS #000-#147 + usages croisés RT | Pont entre les 2 jeux |
| **Friend Areas Guide** | 56 zones de recrutement classées par biome | Classification environnementale |

---

## 🏔️ 1. LES 14 BIOMES OFFICIELS PMD ET LEURS RÈGLES

### 1.1 FORÊT TEMPÉRÉE (Tiny Woods, Sinister Woods, Murky Forest)
**Tilesets officiels** : #078 (Tiny Woods), EoS Murky Forest, Howling Forest 1F-7F
**Palette** : Verts moyens, bruns chauds, sols feuillus
**Éléments architecturaux obligatoires** :
- Sol : patchwork de terre/herbe avec racines apparentes
- Murs : troncs d'arbres denses + feuillage-canopée en overlay
- Eau : ruisseaux peu profonds, flaques
- Objets : souches, champignons, buissons, fleurs sauvages
**Friend Areas de référence** : Mist-Rise Forest, Energetic Forest, Overgrown Forest, Mushroom Forest
**Animations PMD canon** : feuilles oscillantes (vent), herbes animées, lucioles en couche overlay
**Pokémon type** : Insecte, Plante, Normal, Fée — PNJ papillons, chenilles, rongeurs

### 1.2 FORÊT PROFONDE/SOMBRE (Howling Forest, Uproar Forest, Darknight Relic)
**Tilesets officiels** : Howling Forest 1F-7F, Uproar Forest, Darknight Relic
**Palette** : Verts très sombres, noir/violet, gris-brun
**Éléments** : arbres morts, brume épaisse, sol de terre noire, racines noueuses
**Friend Areas de référence** : Darkness Ridge, Secretive Forest
**Animations** : brume mouvante (particules lentes), ombres dansantes, champignons phosphorescents

### 1.3 MONTAGNE/ROCHER (Mt. Blaze, Mt. Faraway, Mt. Thunder Peak)
**Tilesets officiels** : #110 (Mt. Blaze), Mt. Faraway 10F-20F, Mt. Thunder Peak
**Palette** : Gris pierre, brun-rouge, ocre
**Éléments** : falaises stratifiées, corniches, éboulis, piliers rocheux, grottes latérales
**Friend Areas de référence** : Mt. Cleft, Mt. Discipline, Mt. Deepgreen, Mt. Moonview, Rainbow Peak, Boulder Cave
**Animations** : poussière, chutes de cailloux, nuages en arrière-plan

### 1.4 GROTTE/SOUTERRAIN (Crystal Cave, Lapis Cave, Meteor Cave)
**Tilesets officiels** : Lapis Cave, Meteor Cave, Southern Cavern B24F-B50F, Magma Cavern Pit
**Palette** : Bleu-gris profond, teintes minérales, cristaux
**Éléments** : stalactites, stalagmites, cristaux brillants, murs de pierre brute
**Friend Areas de référence** : Echo Cave, Dragon Cave, Cryptic Cave, Frigid Cavern, Boulder Cave
**Animations** : cristaux scintillants, gouttes d'eau, lueurs minérales

### 1.5 VOLCAN/LAVE (Magma Cavern, Fiery Field, Scorched Plains)
**Tilesets officiels** : Magma Cavern, Fiery Field, Magma Cavern Pit, Scorched Plains
**Palette** : Noir basalte, rouge feu, orange magma, gris cendres
**Éléments** : rivières de lave, roche volcanique noire, fumerolles, cendres au sol
**Friend Areas de référence** : Crater, Volcanic Pit, Scorched Plains
**Animations** : lave mouvante, fumée montante, braises flottantes, lueur rouge pulsante

### 1.6 DÉSERT/ARIDE (Desert Region, Furnace Desert)
**Tilesets officiels** : Desert Region, Furnace Desert, Northern Range 8F-16F
**Palette** : Sable ocre/jaune, beige, orange pâle
**Éléments** : dunes, cactus, rochers érodés, oasis rares, sol craquelé
**Friend Areas de référence** : Furnace Desert, Withering Desert, Ravaged Field
**Animations** : mirages, sable soufflé, chaleur ondulante, tempêtes

### 1.7 GLACE/NEIGE (Frosty Forest, Frosty Grotto, Icicle Forest)
**Tilesets officiels** : #100 (Frosty Forest), Frosty Grotto, EoS Icicle Forest
**Palette** : Blanc neige, bleu pâle, cyan glacé, gris-bleu
**Éléments** : sol gelé craquelé, stalactites de glace, arbres enneigés, lacs gelés
**Friend Areas de référence** : Frigid Cavern, Ice Floe Beach
**Animations** : neige tombante, souffle glacé (vapeur blanche), scintillements de givre

### 1.8 EAU/LAC/RIVIÈRE (Waterfall Pond, Stormy Sea, Silver Trench)
**Tilesets officiels** : #080 Waterfall Pond, Stormy Sea B1F-B16F, Silver Trench
**Palette** : Bleu profond, turquoise, cyan, sable beige (berges)
**Éléments** : eau navigable (tiles walkable + non-walkable), cascades, ponts de pierre
**Friend Areas de référence** : Turtleshell Pond, Waterfall Lake, Mystic Lake, Tadpole Pond, Rub-a-Dub River, Bountiful Sea, Serene Sea, Deep-Sea Current, Deep-Sea Floor, Treasure Sea
**Animations** : eau ondulante (4 frames), cascades animées, bulles, reflets lumineux

### 1.9 PLAGE/OCÉAN (Stormy Sea, Silver Trench, Far-off Sea)
**Tilesets officiels** : Stormy Sea, Grand Sea, Far-off Sea
**Palette** : Sable doré, bleu océan, écume blanche, corail rose/orange
**Éléments** : sable, rochers marins, coraux, coquillages, algues
**Friend Areas de référence** : Shallow Beach, Ice Floe Beach, Southern Island, Final Island, Enclosed Island, Legendary Island, Northern Isles
**Animations** : vagues, écume, mousse marine

### 1.10 MARAIS/TOURBIÈRE (Poison Swamp, Gourd Swamp, Peanut Swamp)
**Tilesets officiels** : EoS Spacial Cliffs (terrain mixte), Quicksand Cave
**Palette** : Vert-marron, violet poison, eau stagnante vert foncé
**Éléments** : eau trouble, boue (tiles ralentissants), arbres morts, nénuphars
**Friend Areas de référence** : Poison Swamp, Gourd Swamp, Peanut Swamp
**Animations** : bulles de méthane, brume basse, eau stagnante

### 1.11 RUINES/TEMPLE ANCIEN (Buried Relic, Ancient Relic, Sealed Ruin)
**Tilesets officiels** : Buried Relic B1F-B20F, Sealed Ruin, Darknight Relic
**Palette** : Pierre grise, or terni, marbre blanc cassé, mousse verte
**Éléments** : colonnes brisées, dalles fissurées, glyphes et runes, statues, autels
**Friend Areas de référence** : Ancient Relic, Aged Chamber AN, Aged Chamber O?, Decrepit Lab, Power Plant
**Animations** : runes lumineuses pulsantes, poussière tombant des colonnes, torches vacillantes

### 1.12 PLAINE/PRAIRIE (Beau Plains, Sky Blue Plains, Sacred Field)
**Tilesets officiels** : Northern Range 1F-7F, Great Canyon
**Palette** : Vert prairie, jaune herbe, bleu ciel
**Éléments** : herbes hautes, fleurs sauvages, rochers isolés, ciel ouvert
**Friend Areas de référence** : Beau Plains, Sky Blue Plains, Sacred Field, Safari, South Plains, Western Forest
**Animations** : herbes ondulant au vent, fleurs oscillantes, papillons

### 1.13 CIEL/SOMMET (Sky Peak, Temporal Tower, Stratos Lookout)
**Tilesets officiels** : Temporal Tower, Sky Peak Summit Pass, Stratos Lookout
**Palette** : Blanc nuage, bleu ciel, doré soleil, violet crépuscule
**Éléments** : nuages, plates-formes flottantes, colonnes célestes
**Animations** : nuages mouvants, particules lumineuses, aurores

### 1.14 USINE/LABORATOIRE (Decrepit Lab, Power Plant, Magnetic Quarry)
**Tilesets officiels** : Power Plant, Decrepit Lab
**Palette** : Métal gris, néons, écrans, câbles
**Éléments** : sol grillagé, machines, panneaux électriques, cristaux énergétiques
**Animations** : écrans flicker, néons clignotants, étincelles électriques

---

## 🔗 2. CORRESPONDANCE ZONES NEW ERA ↔ RÉFÉRENCES PMD OFFICIELLES

### 2.1 VAST_STEPPE (4 segments, 14 étages, 7+7)
**Biome New Era** : Steppe immense, herbes hautes, ciel ouvert, falaises au loin
**Référence PMD** : **Great Canyon + Northern Range 1F-7F + Beau Plains**
**Tileset à utiliser** : `VastSteppe_Base` (sol herbeux ocre), `VastSteppe_Fringe` (falaises/bordures)
**Règles de construction visuelle** :
- Sol : alternance herbe rase (walkable) / herbes hautes (walkable, ralentissant)
- Murs : falaises stratifiées (calque type Great Canyon) — 2-3 couches
- Eau : aucune dans les étages 1-7, rivière apparaît étages 8-14
- Objets : rochers plats (comme Mt. Faraway), buissons d'herbes jaunies
- Bordures : ciel ouvert + ligne d'horizon montagneuse (inspiré Platane Céleste)
**Friend Area de référence** : Beau Plains (étendue herbeuse), Sky Blue Plains (ciel ouvert)
**Animations à intégrer** : herbes ondulant au vent (4 frames), poussière soulevée, nuages mouvants en overlay
**Pokémon d'ambiance** : Ponyta, Tauros, Doduo, Poussifeu, Lixy, Hélion, Furaiglon (PNJ marchant)
**Maps associées** : `vast_steppe_entrance`, `vast_steppe_midpoint` (Kangourex), `vast_steppe_miniboss`, `vast_steppe_guardian`

### 2.2 SEARING_TUNNEL (3 segments, 15 étages, 10+5)
**Biome New Era** : Tunnel volcanique, chaleur intense, rivières de lave
**Référence PMD** : **Magma Cavern + Fiery Field**
**Tileset à utiliser** : `SearingTunnel_Base` (roche noire), `SearingTunnel_Rocks` (éboulis)
**Règles de construction visuelle** :
- Sol : roche basaltique noire avec fissures rougeoyantes
- Murs : parois rocheuses irrégulières + stalactites (inspiré Magma Cavern Pit)
- Lave : rivières de lave (tiles non-walkable) avec animation 4 frames
- Objets : fumerolles, geysers de vapeur, rochers chauffés à blanc
- Segment 3 (étages 11-15) : la lave s'intensifie, sol instable (tiles pièges)
**Environnement sonore** : grondements magma (inspiré Magma Cavern OST)
**Pokémon d'ambiance** : Torkoal, Magmar, Camérupt, Limagma, Salamèche, Goupix
**Animations** : lave mouvante, fumée toxique, braises ascendantes

### 2.3 MOUNT_WINDSWEPT (4 segments, 13 étages, 7+6)
**Biome New Era** : Montagne venteuse, falaises à pic, neige au sommet
**Référence PMD** : **Mt. Faraway + Frosty Forest + Sky Peak** — mixte roche/glace
**Tileset à utiliser** : `MountWindswept_Base`, `MountainPeak` (roche), héritage `FrostyForest` pour le sommet
**Règles de construction visuelle** :
- Segments 1-2 (étages 1-7) : roche grise, corniches, plateformes décalées
- Segments 3-4 (étages 8-13) : neige apparaît progressivement, glace au sol (glissant)
- Murs : falaises verticales avec corniches (structure Mt. Faraway — pas de mur vertical simple)
- Vent : particules animées traversant l'écran (neige/feuilles)
- Boss (Guardian) : Skarmory — arène en plein ciel, plates-formes nuageuses (Stratos Lookout)
**Friend Area de référence** : Mt. Cleft (structure rocheuse), Rainbow Peak (sommet)
**Animations** : vent (particules linéaires rapides), neige (segment 3+), chutes de pierres

### 2.4 GLOOMY_FOREST (4 segments, 21 étages, 18+3)
**Biome New Era** : Forêt lugubre, arbres morts, brume épaisse, Zarude boss
**Référence PMD** : **Howling Forest + Darknight Relic + Uproar Forest**
**Tileset à utiliser** : `GloomyForestMidpoint_Base`, inspiration `DarknightRelic`
**Règles de construction visuelle** :
- Sol : terre noire/racines, tapis de feuilles mortes (brun-rouge)
- Murs : troncs d'arbres morts noueux + canopée noire
- Eau stagnante (étages 8-18) : eau trouble avec bulles
- Objets : arbres morts couchés, champignons bioluminescents, toiles d'araignée
- Zone boss (Zarude) : clairière interdite, arbre géant au centre, racines animées
**Friend Area de référence** : Darkness Ridge, Secretive Forest
**Animations** : brume mouvante, lucioles (étincelles vertes), champignons phosphorescents
**Pokémon d'ambiance** : Spectrum, Cornèbre, Smogogo, Ténéfix, Capumain, Scarhino

### 2.5 CLOVEN_RUINS (4 segments, 20 étages, 15+5)
**Biome New Era** : Ruines antiques fendues, Cœur des Anima, Regigigas L45
**Référence PMD** : **Buried Relic + Sealed Ruin + Ancient Relic**
**Tileset à utiliser** : `ClovenRuins` (dalles pierre), `CrookedCavern` pour souterrains
**Règles de construction visuelle** :
- Sol : dalles de marbre blanc cassé avec motifs géométriques
- Murs : colonnes brisées, murs de pierre avec glyphes (runes gravées)
- Étages profonds (10-20) : mousse envahit les murs, racines percent les dalles
- Arène boss : salle circulaire, 8 piliers, dalle centrale avec le Cœur (gemme pulsante)
- BossFX : RockFall (effondrement colonnes), Voice (murmure abyssal)
**Friend Area de référence** : Ancient Relic, Aged Chamber AN, Decrepit Lab
**Animations** : runes lumineuses pulsantes, poussière tombant des arches, gemme au cœur vibrant
**Entités** : Regigigas L45, 400HP, Slow Start, Crush Grip/Zen Headbutt/Heavy Slam/Stomp

### 2.6 RELIC_FOREST (Donjon existant Ch2, boss Terrakion)
**Référence PMD** : **Tiny Woods + Sinister Woods + Howling Forest**
**Particularité** : Forêt ancienne, ruines éparpillées (piliers moussus)
**Vérification** : `relic_forest_blob_*.rsmap` déjà produit avec Pillow

### 2.7 CROOKED_CAVERN (Donjon existant)
**Référence PMD** : **Lapis Cave + Crystal Cave**
**Vérification** : `Crooked_Cavern_Base.tile`, `Crooked_Cavern_Objects.tile`

### 2.8 ILLUMINANT_RIVERBED (Donjon existant)
**Référence PMD** : **Waterfall Pond + Rub-a-Dub River**
**Vérification** : `Illuminant_Riverbed_Base.tile`, eau animée

### 2.9 APRICORN_GROVE (Donjon existant, 8 variantes couleur)
**Référence PMD** : **Southern Jungle + Mushroom Forest + Fantasy Strait**
**Vérification** : `Apricorn_Grove_Base.tile` + 8 variantes couleur (Black, Blue, ..., Yellow)

### 2.10 MAZES (bug_maze, fire_maze, electric_maze, etc.)
**Référence PMD** : **Makuhita Dojo Mazes** + TCRF tilesets #070-072
**Particularité** : Donjons d'entraînement, existants avec tilesets dédiés

---

## 🗺️ 3. HUBS, VILLAGES & GROUND MAPS — RÉFÉRENCES OFFICIELLES

### 3.1 METANO_TOWN (Hub principal)
**Référence PMD** : **Pokémon Square (RT) + Treasure Town (EoS)**
**Règles architecturales** :
- Place centrale avec fontaine/puits (Treasure Town)
- Bâtiments disposés en cercle/fer à cheval autour de la place
- Tentes pour marchands ambulants (inspiré Kecleon Shops)
- Pont menant vers la guilde (Pokémon Square → guilde)
- Sorties : Nord (rivière), Est (donjons), Sud (route), Ouest (marché)
- Palette : tons chauds, bois, pierre, toits de tuiles
- Animations : drapeaux flottants, fumée des cheminées, habitants marchant
- PNJ marchands disposant de routines AI `halcyon.ai.ground_default`

### 3.2 GUILD (Guild Floors 1-3 + Bedrooms + Dining Room + Storage)
**Référence PMD** : **Wigglytuff's Guild (EoS)**
**Éléments de référence** :
- Premier étage : hall d'entrée + panneau d'affichage + escalier central (comme EoS)
- Deuxième étage : dortoirs, chambre des héros, salle de stockage
- Troisième étage : lobby, salle de réunion, bureau du chef
- Salle à manger : grande table commune, cuisine adjacente
**Tilesets existants** : `Guild_Bedroom_Hallway_*`, `Guild_Bottom_Left_Bedroom_*`

### 3.3 METANO_CAFE
**Référence PMD** : **Spinda's Café (EoS)**
**Animation** : Spinda derrière le comptoir, clients attablés

### 3.4 LEDIAN_DOJO
**Référence PMD** : **Makuhita Dojo (RT) / Marowak Dojo (EoS)**
**Structure** : Salle d'entraînement + mazes accessibles

### 3.5 LUMINOUS_SPRING
**Référence PMD** : **Luminous Spring (EoS)**
**Fonction** : Évolution des Pokémon

### 3.6 POST_OFFICE
**Référence PMD** : **Pelipper Post Office (EoS)**

### 3.7 METANO_CAVE
**Référence PMD** : **Spinda's Café basement** — zone cachée, hermit Sunflora

### 3.8 METANO_INN
**Nouveau hub** — style auberge PMD avec chambres pour PNJ de passage

---

## 🎨 4. RÈGLES DE COMPOSITION DES TILESETS (GRAMMAIRE VISUELLE PMD)

### 4.1 STRUCTURE D'UNE MAP DE DONJON PMD (procedurale)
```
[Ciel/Overlay arrière-plan]
  └── Couche 0 : Sol de fond (walkable) — tiles 32×32px
  └── Couche 1 : Sol décoratif (walkable) — variations, ombres
  └── Couche 2 : Murs (non-walkable) — bords de la zone jouable
  └── Couche 3 : Eau/lave/éléments liquides (walkable/non selon type)
  └── Couche 4 : Objets décoratifs (arbres, rochers, colonnes)
  └── Couche 5 : Overlay (brume, particules, feuillage avant-plan)
```

### 4.2 PROPORTIONS D'UNE SALLE PMD CANON
- Salle standard : 6×5 à 12×8 tiles de 32px
- Couloir : 2-3 tiles de large
- Eau dans la salle : 25-40% de la surface
- Objets par salle : 2-5 éléments décoratifs
- Distance min entre 2 entrées : 4 tiles

### 4.3 PALETTE DE COULEURS PAR BIOME (Nuancier PMD)
| Biome | Sol | Mur | Eau | Objets | Overlay |
|-------|-----|-----|-----|--------|---------|
| Forêt | #4A6B3A | #5C3D2E | #3A7B8C | #6B8C3A | #2A4B1A (brume) |
| Montagne | #7B7B6B | #5B5B4B | — | #8B7B5B | #CBB (neige) |
| Volcan | #2B1B0B | #1B0B00 | #FF4500 | #3B1B0B | #FF6600 (lave) |
| Ruines | #C4C0B8 | #9B9080 | #6B8494 | #D4C090 | #4B4B4B |
| Caverne | #3B4B5B | #2B3B4B | #4B6B8B | #5B7B9B | #1B2B3B |
| Glace | #D4E4F4 | #B4C4D4 | #84B4D4 | #E4F4FF | #F4F4FF |

---

## 🧬 5. POKÉMON PAR ENVIRONNEMENT — COHÉRENCE ÉCOLOGIQUE

### 5.1 Forêt tempérée (vast_steppe, relic_forest, apricorn_grove)
🐛 Insectes : Chenipan, Chrysacier, Coconfort, Scarhino, Yanma, Apitrini, Apireine
🌿 Plantes : Bulbizarre, Ortide, Joliflor, Tournegrin, Rosélia, Feuillajou
🐭 Rongeurs : Rattata, Rattatac, Fouinette, Fouinar, Capumain, Cerfrousse
🦉 Oiseaux : Hoothoot, Noarfang, Canarticho, Tylton
🧚 Fées : Mélofée, Togepi, Snubbull, Spinda

### 5.2 Volcan (searing_tunnel)
🔥 Feu : Salamèche, Goupix, Limagma, Torkoal, Camérupt, Magmar, Ouisticram, Darumarond
🌋 Roche/Sol : Racaillou, Gravalanch, Taupiqueur, Marcacrin, Onix

### 5.3 Montagne (mount_windswept)
🪨 Roche : Onix, Steelix, Tarinor, Terhal, Galekid, Galegon, Archeodong
⛰️ Combat : Machoc, Machopeur, Mackogneur, Méditikka, Charmina
❄️ Glace (sommet) : Stalgamin, Marcacrin, Lippoutou, Séléroc

### 5.4 Forêt lugubre (gloomy_forest)
👻 Spectre : Feuforêve, Téraclope, Baudrive, Skélénox, Ténéfix, Magirêve
🌑 Ténèbres : Cornèbre, Smogogo, Spectrum, Zorua (camouflé)
🌱 Plante obscure : Bouldeneu, Vorastérie, Torterra

### 5.5 Ruines (cloven_ruins, future zones)
👁️ Psy : Abra, Kadabra, Alakazam, Zarbi, Archéomire, Archéodong, Symbios
🗿 Roche/Légende : Regirock, Regice, Registeel, Regigigas, Terhal, Métang
🔮 Fée antique : Mélofée, Mélodelfe, Tarsal, Kirlia, Gardevoir, Gringolem

---

## 🎬 6. ANIMATIONS D'AMBIANCE — SPÉCIFICATIONS TECHNIQUES

### 6.1 Eau animée (tous les biomes aquatiques)
- Format PMDO : 4 frames cycliques en boucle
- Vitesse : 8 frames par cycle (125ms/frame)
- Tiles : chaque tile d'eau a ses 4 frames stockées séquentiellement dans le .tile
- Implémentation New Era : animation native via le loader .tile (format identique PMDO)

### 6.2 Lave (searing_tunnel, futures zones volcaniques)
- 4 frames : ondulation + bulles + éclaboussures
- Palette rouge → orange → jaune (cycle chaud)
- Tile séparé `SearingTunnel_Lava_Anim.tile`

### 6.3 Brume/particules (gloomy_forest, cloven_ruins)
- Overlay semi-transparent (couche 5)
- Particules 8×8px, déplacement lent aléatoire
- 3 types : brume (blanc 40% alpha), lucioles (vert #88FF88), poussière (gris 30% alpha)

### 6.4 Végétation animée (toutes zones vertes)
- Herbes : oscillation 2 frames (gauche → droite), vitesse 250ms
- Fleurs : oscillation + changement couleur léger
- Arbres : uniquement feuillage, oscillation subtile (4 frames, 500ms)

### 6.5 Effets météo
- Pluie : particules 4×8px verticales, vitesse rapide
- Neige : particules 6×6px, descente lente + oscillation horizontale
- Vent : particules linéaires 16×2px traversant l'écran en diagonale

---

## 🏗️ 7. POKÉMON VIVANTS — ROUTINES D'AMBIANCE

### 7.1 PNJ Marchands (patterns PMDO)
```lua
-- Routine marchand (inspiré Kecleon Shop)
AI:SetCharacterAI(npc, "halcyon.ai.ground_default",
    homePos, wanderArea, speed, minDist, maxDist, minDelay, maxDelay)
```
**Comportements** : marche lente, pauses, orientation vers joueur approchant

### 7.2 Groupes de PNJ (patterns EoS Treasure Town)
- **Marché** : 2-3 PNJ proches, échangeant animations `ground_talking`
- **Fontaine** : 1-2 PNJ arrêtés, animation `Idle`, émoticônes occasionnelles
- **Enfants** : course rapide (Wander speed 2), sauts, cercles

### 7.3 PNJ Dormeurs (auberge, maisons)
- Animation `Sleep` (yeux fermés, Zzz périodiques)
- Position fixe, pas de déplacement
- Réveil si interaction joueur

### 7.4 PNJ Travailleurs (dojo, boutique, guilde)
- Animation spécifique au métier (ex: forgeron = `Strike` répété)
- Déplacement limité autour du poste de travail

### 7.5 Groupes de danse/musique (café, place)
- Pattern `Ludicolo + Spinda` (dungeon_life.lua)
- Animation de danse synchronisée sur BGM

---

## 📐 8. STRUCTURE D'UNE FRIEND AREA → INSPIRATION GROUND MAP

### 8.1 Beau Plains → vast_steppe_entrance / vast_steppe_midpoint
```
┌──────────────────────────────┐
│ ☁️  ciel ouvert            │
│                              │
│  🌿 herbes hautes          │
│  🪨 rocher                 │
│           🏕️ checkpoint    │
│  🌾 herbes                 │
│                              │
│  🏔️ falaises lointaines   │
└──────────────────────────────┘
```
**Dimensions** : 40×30 tiles → 1280×960 px
**Points d'intérêt** : entrée (Sud), checkpoint Kangourex (Centre), sortie donjon (Nord)

### 8.2 Darkness Ridge → gloomy_forest_entrance
```
┌──────────────────────────────┐
│ 🌑 canopée noire           │
│                              │
│  🕸️ toiles                │
│       🌳 arbre mort géant  │
│  🍄 champignons            │
│                              │
│  ⬇️ entrée forêt lugubre   │
└──────────────────────────────┘
```

### 8.3 Ancient Relic → cloven_ruins_entrance / cloven_ruins_boss
```
┌──────────────────────────────┐
│ 🏛️ arche brisée           │
│                              │
│  ▓▓▓ colonnes ▓▓▓          │
│                              │
│  💎 Cœur centrale          │
│                              │
│  📜 glyphes au sol         │
└──────────────────────────────┘
```

---

## 🔮 9. ZONES FUTURES (Chapitres 8-32) — PRÉ-AFFECTATION BIOMES

| Chapitre | Zone | Biome PMD de référence | Tileset(s) inspiration |
|----------|------|------------------------|------------------------|
| 8 | sanctuaire_cristal | Crystal Cave + Meteor Cave + Ancient Relic | CrystalCave |
| 9 | marais_oublie | Poison Swamp + Gourd Swamp + Peanut Swamp | Swamp |
| 10 | pic_celeste | Sky Peak + Temporal Tower + Stratos Lookout | SkyPeak |
| 11 | desert_ardent | Desert Region + Furnace Desert + Fiery Field | Desert |
| 12 | abysses_glaces | Frosty Grotto + Ice Floe Beach + Frigid Cavern | AbyssIce |
| 13 | jardin_interdit | Healing Forest + Secretive Forest + Jungle | SacredGarden |
| 14 | forge_primordiale | Magma Cavern + Volcanic Pit + Magma Cavern Pit | Forge |
| 15-32 | (à définir) | — | — |

---

## ✅ 10. CHECK-LIST DE CONFORMITÉ PMD PAR ZONE

### Pour chaque zone, vérifier :
- [ ] Tileset sol cohérent avec le biome (palette, motif, variations)
- [ ] Tileset murs adapté (falaises, arbres, colonnes, glace selon biome)
- [ ] Eau/lave/liquide avec animation 4 frames si applicable
- [ ] Objets décoratifs respectant la densité PMD (2-5/salle)
- [ ] Overlay atmosphérique (brume, particules, vent) si applicable
- [ ] Bordures de map cohérentes (pas de vide noir non justifié)
- [ ] Entités Pokémon cohérentes avec le biome (cf. section 5)
- [ ] PNJ avec routines d'ambiance (section 7)
- [ ] Ground maps avec points d'intérêt structurés (section 8)
- [ ] Palette couleurs dans le nuancier PMD (section 4.3)

---

*Document généré à partir de l'analyse de : pret/pmd-red, Spriters-Resource RT+EoS (267+ tilesets), TCRF, Friend Areas Guide complet (56 zones), Bulbapedia Rescue Team Camps*
*Projet New Era: Abyss to Ascension V4 — Arena Agent, 2026-07-26*
