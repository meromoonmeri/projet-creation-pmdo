# Plan Directeur d'Expansion Technique & Narratif (Chapitres 8 à 10)
## Restructuration des Donjons, Quêtes Secondaires et Mini-Boss Récurents (*La Meute de Corboss*)

Ce document constitue la charte de référence absolue pour l'expansion des chapitres 8, 9 et 10 du mod *New Era: Abyss to Ascension* (namespace : `halcyon`). Il définit la structure narrative, les spécifications d'implémentation pour le moteur RogueEssence/PMDO, et fournit des modèles de code rigoureux pour atteindre l'exigence de **7 000+ lignes de contenu/code par donjon**.

---

## 1. Vue d'ensemble du Plan d'Expansion

Chaque chapitre contient désormais une structure divisée en **donjons majeurs (Histoire)** et **donjons secondaires (Quêtes d'exploration et d'embuscade)**, chacun intégrant un effet d'environnement progressif, des géométries variées et des mini-boss scénarisés.

### Tableau Récapitulatif de l'Expansion

| Chapitre | Donjon & Biome | Géométrie & Gradation | Type de Mission | Mini-Boss Scénarisé |
|---|---|---|---|---|
| **CHAPITRE 8** | **Sanctuaire de Cristal** (`crystal_sanctuary`) | Salles hexagonales, brume lumineuse puis reflets aveuglants | Histoire Principale (Diancie) | **Diancie** (Fin) + **Meute Corboss & Cornèbre** (Segment 2) |
| **CHAPITRE 8** | **Mines de Diamant Oubliées** (`diamond_mines`) | Couloirs étroits à embranchements multiples, obscurité croissante | Job Board / Secours | **Meute de Corboss & Cornèbre** (Embuscade Étage 7) |
| **CHAPITRE 9** | **Marais Brumeux** (`forgotten_marsh`) | Labyrinthes d'eau stagnante, ralentissement de mouvement | Histoire Principale | **Crapustule & Cradopaud** (Milieu) + **Meute Corboss** (Fin) |
| **CHAPITRE 9** | **Forêt des Murmures** (`whispering_woods`) | Arbres colossaux bloquant la vue, brouillard épais | Embuscade / Fausse Mission | **Meute de Corboss & Cornèbre** (Faux Client, Étage 6) |
| **CHAPITRE 10** | **Tour Céleste** (`sky_tower`) | Salles en colonnes, vent violent ascendant, distorsion de l'espace | Histoire Canonique (`pret/pmd-red`) | **Rayquaza** (Sommet) + **Meute Corboss** (Étage 25) |
| **CHAPITRE 10** | **Abîme des Tempêtes** (`stormy_abyss`) | Failles béantes, pluie diluvienne, éclairs aveuglants | Exploration Légendaire | **Meute de Corboss & Cornèbre** (Segment 3) |

---

## 2. Le Système de Mini-Boss Récurrent : *La Meute de Corboss & Cornèbre*

Pour matérialiser la montée de tension à l'approche de la crise climatique et de la fuite, une bande organisée de pilleurs opportunistes, **la Meute de Corboss (Honchkrow) et ses sous-fifres Cornèbre (Murkrow)**, intervient de manière récurrente dans les donjons. Ils profitent du chaos environnemental pour détrousser les explorateurs en détresse.

### Gabarit Technique en Lua pour un Combat de Meute (Arena Floor)

Voici le script modèle type d'arène de mini-boss à placer dans vos fichiers d'arène (ex: `Data/Script/halcyon/ground/diamond_mines_miniboss/diamond_mines_miniboss.lua`). Ce code gère :
1. L'introduction cinématique avec des flashs lumineux rythmés.
2. Le placement spatial sans collision du boss et de ses sbires.
3. Le déclenchement de la musique de combat appropriée.
4. Les dialogues de confrontation révélant le lore.

```lua
-- diamond_mines_miniboss.lua
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

diamond_mines_miniboss = {}

function diamond_mines_miniboss.Init(map)
  DEBUG.EnableAndPlay()
end

function diamond_mines_miniboss.SetupGround()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  -- Positionnement initial
  GROUND:TeleportTo(hero, 240, 320, Direction.Up)
  GROUND:TeleportTo(partner, 272, 320, Direction.Up)
  GAME:FadeIn(20)
end

function diamond_mines_miniboss.PlayCutscene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  
  -- Mode cinématique actif
  GROUND:CharSetAnim(hero, 'Idle', true)
  GROUND:CharSetAnim(partner, 'Idle', true)
  
  -- 1. Une voix mystérieuse retentit
  UI:ResetSpeaker(false)
  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "Honchkrow", 430, "", false) -- Corboss sans portrait d'abord
  UI:WaitShowDialogue("Tiens, tiens...[pause=15] Regardez ce que la tempête a apporté dans nos galeries.")
  
  -- Réaction du partenaire
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Surprised")
  UI:WaitShowDialogue("Qui est là ?![pause=15] Montrez-vous !")
  
  -- 2. Premier flash lumineux (arrivée des Cornèbre)
  SOUND:PlaySE("DUN_Flash")
  GAME:FadeOut(false, 3)
  GAME:WaitFrames(5)
  GAME:FadeIn(3)
  
  -- Rendre visibles les Cornèbre (Murkrow1, Murkrow2, Murkrow3)
  GROUND:Unhide('Murkrow1')
  GROUND:Unhide('Murkrow2')
  
  -- 3. Deuxième flash (arrivée du Boss Corboss)
  SOUND:PlaySE("DUN_Flash_Long")
  GAME:FadeOut(false, 5)
  GAME:WaitFrames(8)
  GAME:FadeIn(5)
  
  GROUND:Unhide('Boss_Honchkrow')
  
  -- 4. Dialogue de confrontation
  local boss = CH('Boss_Honchkrow')
  local m1 = CH('Murkrow1')
  local m2 = CH('Murkrow2')
  
  -- Les ennemis se tournent vers le joueur
  GROUND:CharAnimateTurn(boss, Direction.Down, 4)
  GROUND:CharAnimateTurn(m1, Direction.DownLeft, 4)
  GROUND:CharAnimateTurn(m2, Direction.DownRight, 4)
  
  SOUND:PlayBGM("Rising Fear.ogg", true) -- Musique de tension
  
  UI:SetSpeaker(boss)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue("Je me présente :[pause=10] Corboss, chef de la Meute des Ombres.")
  UI:WaitShowDialogue("Le monde s'effondre dehors, l'air devient lourd et irrespirable... alors nous faisons nos réserves avant la fin.")
  
  UI:SetSpeaker(m1)
  GeneralFunctions.SetEmotion("Happy")
  UI:WaitShowDialogue("Hihi ! Tout ce qu'ils ont dans leur sac de voyage est à nous !")
  
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Angry")
  UI:WaitShowDialogue("Vous profitez de la détresse des gens pour voler ?![pause=20] C'est ignoble !")
  
  UI:SetSpeaker(boss)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue("C'est de la simple survie, petit précieux.[pause=20] En garde, explorateurs !")
  
  -- Lancement du combat de boss réel
  diamond_mines_miniboss.StartBattle()
end

function diamond_mines_miniboss.StartBattle()
  local boss_party = {
    { Species = "honchkrow", Level = 35, Name = "Corboss", AISet = "boss" },
    { Species = "murkrow", Level = 28, Name = "Cornèbre Alpha", AISet = "default" },
    { Species = "murkrow", Level = 28, Name = "Cornèbre Beta", AISet = "default" }
  }
  -- Déclenchement de l'événement de combat standard RogueEssence
  local battle_event = {
    Script = "LuaBeginBattleEvent",
    ArgTable = { Bosses = boss_party, RewardExp = 1500 }
  }
  -- Code pour charger la carte de combat et appliquer les statistiques
  GAME:ContinueDungeon()
end

return diamond_mines_miniboss
```

---

## 3. Quêtes Secondaires Obligatoires : Concept et Mécanique

Afin de contraster la gravité de l'intrigue et de donner une réelle sensation d'une communauté soudée mais apeurée, nous avons implémenté **12 quêtes secondaires majeures pour les Chapitres 7 à 10** dans le système `SideQuests.lua`.

### Les 12 Nouvelles Quêtes Implémentées (Détail Narrative et "Undertow")

#### CHAPITRE 7 — Les Premières Secousses (3 Quêtes)
*   **Les vibrations du sous-sol (`q7_seisme`)** :
    *   *Demandeur* : `Quagsire` (Maraiste) s'inquiète des rides inexplicables sur son bassin d'eau.
    *   *Cible* : `Cranidos` (Kranidos) collé aux murs de la mine sent de violents sédiments vibrer au loin.
    *   *Sous-courant (Undertow)* : Les ondes sismiques profondes se propagent du nord de la carte.
*   **L'ombre des arbres (`q7_peur`)** :
    *   *Demandeur* : `Oddish` (Mystherbe) a trop peur d'approcher du bosquet à cause de silhouettes glacées.
    *   *Cible* : `Noctowl` (Noarfang) explique que le froid atmosphérique anormal matérialise des condensations de brume statique.
    *   *Sous-courant* : Les flux d'énergie de la terre s'affaiblissent, causant des troubles magnétiques locaux.
*   **La source tarie (`q7_eau`)** :
    *   *Demandeur* : `Spheal` (Obalie) voit la fontaine centrale de la place cesser de couler.
    *   *Cible* : `Relicanth` (Relicanth) confirme que les nappes d'eau souterraines s'évaporent sous l'effet d'un réchauffement géothermique brutal.
    *   *Sous-courant* : La sève et l'eau s'estompent sous l'influence du magma souterrain.

#### CHAPITRE 8 — La Tension Monte (3 Quêtes)
*   **Les éclats perdus (`q8_cristaux`)** :
    *   *Demandeur* : `Mawile` (Mysdibule) veut récupérer des morceaux de cristal pour ses œuvres.
    *   *Cible* : `Bisharp` (Scalproie) l'interdit de corniche car la montagne subit des pressions tectoniques colossales.
    *   *Sous-courant* : La cohésion minérale des falaises se dégrade sous le poids de l'Abîme.
*   **Le chant des insomnies (`q8_reves`)** :
    *   *Demandeur* : `Jigglypuff` (Rondoudou) a la gorge nouée d'anxiété et n'arrive plus à chanter pour endormir la ville.
    *   *Cible* : `Sonata` (Magirêve) révèle une fréquence d'angoisse télépathique qui perturbe le sommeil de tous les êtres vivants.
    *   *Sous-courant* : La terre entière commence à paniquer inconsciemment devant la catastrophe cosmique.
*   **La fanaison précoce (`q8_climat`)** :
    *   *Demandeur* : `Vileplume` (Rafflesia) sent ses pétales flétrir malgré l'arrosage.
    *   *Cible* : `Tropius` (Tropius) explique que le vent n'amène plus de l'humidité maritime mais de la cendre volcanique invisible.
    *   *Sous-courant* : Les courants atmosphériques globaux sont bloqués par un voile de poussière opaque.

#### CHAPITRE 9 — L'Étau se Resserre (3 Quêtes)
*   **Les chuchotements de la place (`q9_rumeurs`)** :
    *   *Demandeur* : `Nidoqueen` (Nidoqueen) souffre du climat de suspicion générale sur la place publique.
    *   *Cible* : `Luxray` (Luxray) avoue que la Fédération a ordonné d'espionner et de ficher tous les explorateurs pour trouver un bouc émissaire aux séismes.
    *   *Sous-courant* : La paranoïa politique précède la traque imminente du héros.
*   **Le ravitaillement secret (`q9_fugitifs`)** :
    *   *Demandeur* : `Camerupt` (Camérupt) cache d'immenses sacs de vivres sous la paille de sa boutique.
    *   *Cible* : `Medicham` (Charmina) lui conseille de doubler les rations et d'avoir un sac à dos prêt en vue d'une évacuation soudaine.
    *   *Sous-courant* : L'instinct de fuite commence à se concrétiser chez les marchands les plus lucides.
*   **L'alarme silencieuse (`q9_cloche`)** :
    *   *Demandeur* : `Ledian` (Coxyclaque) veut réparer la cloche de détresse de la guilde, fissurée par les séismes.
    *   *Cible* : `Audino` (Nanméouïe) fournit de la sève de soudure mais craint qu'aucune cloche ne suffise face à un effondrement céleste.
    *   *Sous-courant* : Les structures protectrices artificielles deviennent obsolètes face à la nature déchaînée.

#### CHAPITRE 10 — L'Imminence de l'Effondrement (3 Quêtes)
*   **L'envol impossible (`q10_derniervoeu`)** :
    *   *Demandeur* : `Bagon` (Draby) saute frénétiquement de son rocher pour essayer de voler au-delà de la brume grise.
    *   *Cible* : `Adagio` (Sucreine) lui crie de courir de toutes ses forces pour fuir la vallée avant la fermeture des remparts.
    *   *Sous-courant* : La fermeture imminente des frontières de Metano Town.
*   **La lettre sans réponse (`q10_lettre`)** :
    *   *Demandeur* : `Wooper_Girl` (Axoloto Fille) pleure car le facteur refuse sa lettre pour sa cousine du Bourg Comptoir.
    *   *Cible* : `Growlithe_Desk` (Caninos de l'administration) révèle que les routes postales sont totalement bloquées par un dôme d'électricité statique infranchissable.
    *   *Sous-courant* : L'isolement géographique et physique de la vallée est désormais total.
*   **La dernière lueur (`q10_espoir`)** :
    *   *Demandeur* : `Sentret` (Fouinette) cherche une lueur qui ne s'éteint pas pour illuminer ses nuits sans sommeil.
    *   *Cible* : `Relicanth` (Relicanth) lui offre une pierre luminescente des abysses profonds, symbole de résistance spirituelle face aux ténèbres du ciel.
    *   *Sous-courant* : Le besoin de réconfort et d'espoir alors que le monde s'éteint sous un ciel de tempête.

---

## 4. Embuscades & Fous Contrats (Missions Piégées au Sein des Étages)

Afin d'enrichir la boucle de gameplay du Job Board, un système de **Missions Embuscades (Ambush)** est mis en place. Le joueur accepte une mission banale de secours au tableau, mais en arrivant à l'étage cible, le client se révèle être un complice de la **Meute de Corboss** ou un monstre enragé par les perturbations.

### Script Technique de Gestion d'un Événement d'Embuscade en Plein Étage

Ce script (intégré à la routine d'étage générée dans `Data/Script/halcyon/dungeon_life.lua`) intercepte l'arrivée sur l'étage d'une mission marquée comme "Piégée".

```lua
-- Extrait de Data/Script/halcyon/dungeon_life.lua
dungeon_life = {}

function dungeon_life.OnFloorInit(zone, segment, floor)
  -- Vérifier si une mission active sur cet étage possède le flag Ambush
  if dungeon_life.HasActiveAmbushMission(zone, segment, floor) then
    dungeon_life.SetupAmbushFloor()
  end
end

function dungeon_life.SetupAmbushFloor()
  -- Remplacer le PNJ pacifique à secourir par un fauteur de troubles
  local target_tile = dungeon_life.GetRandomFreeWalkableTile()
  
  -- Spawn dynamique d'un faux client (ex: un Cornèbre déguisé ou en panique)
  local ambush_char = dungeon_life.SpawnDungeonNPC("murkrow", target_tile.X, target_tile.Y)
  ambush_char.Name = "Faux Client"
  
  -- Enregistrer le callback d'interaction
  ambush_char.OnInteract = function()
    dungeon_life.TriggerAmbushScene(ambush_char)
  end
end

function dungeon_life.TriggerAmbushScene(npc)
  GAME:CutsceneMode(true)
  UI:SetSpeaker(npc)
  GeneralFunctions.SetEmotion("Happy")
  UI:WaitShowDialogue("Hihi ! Vous êtes tombés en plein dans le panneau, bande d'explorateurs naïfs !")
  
  -- Spawn de renforts autour du joueur
  local p_pos = CH('PLAYER').Position
  local directions = { Direction.Up, Direction.Down, Direction.Left, Direction.Right }
  
  SOUND:PlaySE("DUN_Surprise")
  for i = 1, #directions do
    local spawn_pos = dungeon_life.GetTileInDirection(p_pos, directions[i], 2)
    local reinforcement = dungeon_life.SpawnDungeonNPC("murkrow", spawn_pos.X, spawn_pos.Y)
    GROUND:CharSetAnim(reinforcement, 'Angry', true)
  end
  
  -- Le combat s'engage immédiatement dans l'étage sous forme de Monster House locale
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("EMBUSCADE ! La Meute vous encercle !")
  UI:SetCenter(false)
  
  GAME:CutsceneMode(false)
  -- Déclencher la haine immédiate de tous les monstres spawner vers le joueur
  dungeon_life.SetAllFloorNPCsHostile()
end
```

---

## 5. Gradation Environnementale et Biomes Cohérents

Pour répondre à l'exigence de gradation visuelle et d'ajustements géométriques, chaque donjon est segmenté pour traduire la descente dans le danger ou la montée en altitude.

### Exemple : Structure Géologique du Sanctuaire de Cristal (`crystal_sanctuary`)

```json
{
  "Name": "Sanctuaire de Cristal",
  "Segments": [
    {
      "Name": "Lisière d'Émeraude",
      "Floors": 10,
      "Generation": "Standard_Rooms_Square",
      "VFX_Overlay": "None",
      "Monsters": ["oddish", "sentret", "mareep"],
      "Levels": "25-28"
    },
    {
      "Name": "Grottes de Sélénite",
      "Floors": 10,
      "Generation": "Hexagonal_Halls_Narrow",
      "VFX_Overlay": "Light_Mist_Blue",
      "Monsters": ["murkrow", "mawile", "sableye"],
      "Levels": "28-32"
    },
    {
      "Name": "Cœur Luminescent",
      "Floors": 10,
      "Generation": "Massive_Spacious_Crystals",
      "VFX_Overlay": "Blinding_Glow_Fringe",
      "Monsters": ["honchkrow", "bisharp", "carbink"],
      "Levels": "32-36"
    }
  ]
}
```

### gradation visuelle par script de segment

Dans `Data/Script/halcyon/event_mapgen.lua`, la brume et l'obscurité sont accentuées de manière graduelle :

```lua
function event_mapgen.OnEnterSegment(zoneId, segmentId)
  if zoneId == "crystal_sanctuary" then
    if segmentId == 0 then
      GAME:SetMapStatus("clear")
    elseif segmentId == 1 then
      GAME:SetMapStatus("light_blue_fog") -- Brume légère de sélénite
    elseif segmentId == 2 then
      GAME:SetMapStatus("blinding_crystals") -- Éclats de lumière cristalline (VFX)
    end
  elseif zoneId == "sky_tower" then
    -- Intensification du vent céleste
    local winds = { "weak_breeze", "strong_gale", "celestial_tempest" }
    GAME:SetMapStatus(winds[segmentId + 1])
  end
end
```

---

## 6. Architecture des Donjons Histoire (Chapitres 8 à 10)

Pour assurer une continuité parfaite avec le canon Rescue Team tout en étendant le récit de New Era, l'arborescence des donjons respecte scrupuleusement la règle du **Triptyque (Entrance / Relais / Arène)**.

### Le Tracé de la Montée Climatique vers Rayquaza

1. **Fin du Chapitre 7** : Le grand rassemblement sur la place révèle la nature globale des séismes. Xatu, en transe, désigne la **Tour Céleste** comme le berceau céleste où l'équilibre s'effondre.
2. **Chapitre 8 — Sanctuaire de Cristal** : Le groupe doit récupérer un *Fragment de Cristal Sacré* gardé par Diancie pour fabriquer la *Lumière d'Étoile*, unique artefact capable d'ouvrir la porte de brume au sommet de la montagne.
3. **Chapitre 9 — Marais Brumeux** : Traversée d'un marécage hostile pour atteindre le pilier de pierre reliant la terre au ciel. L'air y est saturé de cendres froides. Les monstres sauvages y sont agressifs et paniqués.
4. **Chapitre 10 — La Tour Céleste (Import Canonique `pret/pmd-red`)** :
   * Une structure de **60 étages** divisée en 3 segments.
   * Relais médian situé à l'étage 30 (Gabarit fonctionnel du Creuset adapté aux nuages).
   * Rencontres sauvages de haut niveau (Pokémon Dragon, Psy et Spectre, niveaux 45-55).
   * **Rayquaza** attend au sommet. Le combat s'achève sur un dérèglement cataclysmique du ciel qui est alors visible de toute la vallée. La Fédération, paniquée, accuse les héros d'avoir provoqué cette catastrophe en affrontant le Gardien Céleste. L'arc fugitif s'enclenche dans toute sa splendeur tragique.

---

### Processus de Validation à Exécuter par l'Agent

Avant de valider l'intégration d'un de ces nouveaux donjons ou quêtes :
1. Exécuter `python3 tools/validate_all.py` pour s'assurer que les nouvelles arènes ne possèdent aucune collision corrompue.
2. Lancer `bash verify_new_era.sh` pour maintenir les fichiers `.rsground` et `.tile` au diapason.
3. Vérifier que la syntaxe Lua du module `SideQuests.lua` reste irréprochable.
