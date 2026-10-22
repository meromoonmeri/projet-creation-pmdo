# Spécification Technique & Plan de Réalisation : Chapitre 12 — L'Arc Fugitif (*Le Long Exil*)
## Composition des 5 Donjons Canoniques, Cartes de Transition et Scripts de Recrutement/Révélation

Ce document établit la structure technique et narrative complète pour le **Chapitre 12**, l'arc emblématique de la fuite (Fugitive Arc). Il ressuscite l'esprit de *PMD Rouge* et *PMD Ciel* à travers une composition de **5 donjons massifs**, l'intégration des cartes de transition canoniques, et des modèles de code Lua rigoureux pour gérer le recrutement d'Absol et la révélation de Feunard.

---

## 1. Structure Globale du Chapitre 12 : La Route de l'Exil

Après les révélations cataclysmiques de la Tour Céleste au Chapitre 10 et l'isolement complet de Metano Town au Chapitre 11, le Héros et son Partenaire sont déclarés hors-la-loi. Traqués par la Fédération et l'Équipe Alakazam, ils s'enfuient vers les terres hostiles du Nord.

Le chapitre est conçu comme une longue traversée linéaire et éprouvante, sans possibilité de retour à Metano Town. Le joueur doit gérer ses ressources de manière critique à travers les **5 épreuves** suivantes :

```text
[Bourg Comptoir] -> [DONJON 1 : Grotte Lapis]
                         |
                 (Route de Cendre)
                         |
                 [DONJON 2 : Mont Brasier (Sulfura)]
                         |
                 (Route de Vapeur)
                         |
                 [DONJON 3 : Grotte de Vapeur (Créhelf)]
                         |
                 (Route de Neige)
                         |
                 [DONJON 4 : Forêt Givrée (Artikodin + Absol)]
                         |
                 (Route des Glaciers)
                         |
                 [DONJON 5 : Mont Gel (Feunard + Climax)]
```

---

## 2. Spécifications des 5 Donjons de l'Exil

Chaque donjon dispose d'une progression de biome graduelle, d'une géométrie de salles spécifique et d'une table de Pokémon sauvages de force croissante.

### Donjon 1 : Grotte Lapis (`lapis_cave`) — *L'Échappatoire*
*   **Biome** : Cavernes étroites et humides aux reflets de saphir.
*   **Géométrie** : Salles très petites reliées par de longs couloirs sinueux pour encourager les embuscades de couloirs.
*   **Étages** : 14 étages.
*   **Enjeu** : Fuir les éclaireurs de la Fédération. Pas de boss, mais des cinématiques d'étage montrant des ombres de poursuivants.
*   **Pokémon Sauvages** : Nidoran, Nosferapti, Racaillou, Évoli (Niveaux 35-38).

### Donjon 2 : Mont Brasier (`mount_blaze`) — *L'Épreuve du Feu*
*   **Biome** : Cratère actif, rivières de magma liquide et brume de soufre.
*   **Géométrie** : Plateformes de roche volcanique entourées de lave (infranchissable pour les non-Feu).
*   **Étages** : 12 étages + Relais Médian (`mont_cendre_pied`) + 3 étages de crête.
*   **Boss / Légendaire** : **Sulfura (Moltres)**. S'attaque aux héros car les éruptions de lave bloquent son sommet.
*   **Pokémon Sauvages** : Limagma, Volcaropod, Ponyta, Caninos, Simiabraz (Niveaux 38-42).

### Donjon 3 : Grotte de Vapeur (`steam_cave`) — *L'Épreuve du Souffle (Crossover PMD Sky)*
*   **Biome** : Galeries de granite poli enveloppées de geysers et d'une vapeur brûlante masquant la carte.
*   **Géométrie** : Salles vastes et circulaires formées par l'érosion des eaux chaudes.
*   **Étages** : 15 étages.
*   **Boss / Légendaire** : **Créhelf (Uxie)**. Il garde le Lac de la Confiance et attaque les héros car les rumeurs d'Ectoplasma l'ont convaincu que les fugitifs venaient voler le rouage du temps.
*   **Pokémon Sauvages** : Chartor, Kraknoix, Volcanion, Smogo, Griknot (Niveaux 42-45).

### Donjon 4 : Forêt Givrée (`frosty_forest`) — *L'Épreuve de la Glace*
*   **Biome** : Bois ancestraux figés sous une neige éternelle et des stalactites acérées.
*   **Géométrie** : Labyrinthe d'arbres gelés réduisant la vitesse de déplacement sur les tuiles enneigées.
*   **Étages** : 14 étages + 5 étages de grotte de glace.
*   **Boss / Légendaire** : **Artikodin (Articuno)**. Après sa défaite, **Absol** intervient pour calmer le dragon de glace, comprend l'innocence des fugitifs, et rejoint l'équipe comme guide.
*   **Pokémon Sauvages** : Obalie, Polagriffe, Sorbébé, Farfuret, Stalgamin (Niveaux 45-48).

### Donjon 5 : Mont Gel (`mount_freeze`) — *L'Autel de la Vérité*
*   **Biome** : Sommet montagneux balayé par un blizzard permanent, glace glissante (le joueur glisse jusqu'au prochain obstacle).
*   **Géométrie** : Cols escarpés et crevasses sans fond.
*   **Étages** : 20 étages + Relais Médian (`mont_gele_pied`) + 4 étages de pic.
*   **Climax / Événement** : L'équipe d'Alakazam et la foule de Metano coincent le duo. Gengar s'apprête à porter le coup de grâce. Soudain, **Feunard (Ninetales)** apparaît de la tempête de neige, révèle que le Héros n'est pas l'humain maudit de la légende, et dévoile la vérité sur la Faille de l'Abîme.
*   **Pokémon Sauvages** : Cochignon, Momartik, Blizzaroi, Oniglali, Loupio (Niveaux 48-52).

---

## 3. Les Cartes de Transition et Cinématiques de Route (*Fugitive Road*)

Pour restituer le sentiment d'épuisement et d'exil d'il y a 30 ans, nous réutilisons et codons les cartes d'exil du projet `pret/pmd-red` :

### A. Route de Cendre (`mont_cendre_pied.rsground`)
*   **Mise en scène** : Le Héros et le Partenaire se reposent au pied d'une crevasse de lave chaude. Le Partenaire a faim et shiver de fatigue.
*   **Dialogue** : Le Partenaire rassure le Héros, lui promettant qu'ils prouveront leur innocence coûte que coûte. Le thème *Rising Fear.ogg* s'estompe pour une mélodie douce.

### B. Route de Neige (`mont_gele_pied.rsground`)
*   **Mise en scène** : Le duo progresse péniblement dans une tempête de neige épaisse (`GAME:SetMapStatus("winter_snow")`). Leurs mouvements de marche sont ralentis de 50%.
*   **Dialogue** : Ils réalisent qu'ils sont arrivés au bout du monde connu. Devant eux se dresse le Mont Gel, ultime refuge du secret de Feunard.

---

## 4. Implémentations Lua du Chapitre 12

### A. Script de Défaite d'Artikodin et Recrutement d'Absol (`frosty_forest_boss.lua`)

Ce script gère le moment crucial où Artikodin est apaisé par l'intervention d'Absol, qui rejoint ensuite votre équipe.

```lua
-- frosty_forest_boss.lua
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

frosty_forest_boss = {}

function frosty_forest_boss.PlayPostBossScene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local articuno = CH('Articuno')
  
  GAME:CutsceneMode(true)
  GROUND:CharSetAnim(articuno, "Pain", true)
  
  UI:SetSpeaker(articuno)
  UI:WaitShowDialogue("Ggrr...[pause=15] Mortels insolents...[pause=20] Mon gel éternel aurait dû vous purifier !")
  
  -- Un bruissement dans les buissons enneigés
  SOUND:PlaySE("DUN_Surprise")
  GAME:WaitFrames(20)
  
  -- Absol sort de l'ombre en marchant élégamment
  local absol = CharacterEssentials.MakeCharactersFromList({{'Absol', 120, 240, Direction.Right}})
  GROUND:CharSetAnim(absol, "Walk", true)
  
  -- Absol s'interpose entre Artikodin et le duo
  UI:SetSpeaker(absol)
  UI:WaitShowDialogue("Assez, Artikodin.[pause=20] Ces enfants ne portent pas la souillure de la brume.")
  
  UI:SetSpeaker(articuno)
  UI:WaitShowDialogue("Absol...?[pause=15] Toi, le messager des catastrophes, tu prends leur défense ?")
  
  UI:SetSpeaker(absol)
  UI:WaitShowDialogue("Je ressens les battements de la terre depuis des siècles.[pause=20] Eux ne provoquent pas les séismes... Ils les traquent.")
  UI:WaitShowDialogue("Laisse-les passer.[pause=15] Le temps presse pour nous tous.")
  
  -- Artikodin s'envole dans un cri de blizzard
  SOUND:PlaySE("DUN_Fly")
  GAME:FadeOut(false, 30)
  GROUND:Hide('Articuno')
  GAME:FadeIn(30)
  
  -- Absol se tourne vers le joueur
  GROUND:CharAnimateTurn(absol, Direction.Right, 4)
  
  UI:SetSpeaker(absol)
  UI:WaitShowDialogue("Vous fuyez la vallée, je le sais.[pause=20] La Fédération a les yeux aveuglés par la panique.")
  UI:WaitShowDialogue("Je m'appelle Absol.[pause=15] Je connais le chemin secret vers le sommet du Mont Gel.")
  UI:WaitShowDialogue("Permettez-moi de vous guider.[pause=20] Ma lame et mon flair sont à votre service.")
  
  -- Recrutement officiel d'Absol
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  SOUND:PlaySE("DUN_Fanfare_Level_Up")
  UI:WaitShowDialogue("Absol rejoint votre équipe de secours légendaire !")
  UI:SetCenter(false)
  
  -- Enregistrement du recrutement
  SV.Chapter12.RecruitedAbsol = true
  GAME:CutsceneMode(false)
  
  -- Continuer la route vers le Mont Gel
  GAME:EnterGroundMap("mont_gele_pied", "Main_Entrance_Marker", true)
end

return frosty_forest_boss
```

### B. Script de Révélation de Feunard au Sommet du Mont Gel (`mount_freeze_summit.lua`)

Ce script gère la confrontation de l'Équipe Alakazam, la foule menée par Ectoplasma, et l'apparition de Feunard pour rétablir la vérité.

```lua
-- mount_freeze_summit.lua
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

mount_freeze_summit = {}

function mount_freeze_summit.PlayClimaxScene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local alakazam = CH('Alakazam')
  local gengar = CH('Gengar')
  
  GAME:CutsceneMode(true)
  
  -- Le duo est acculé contre la falaise de glace
  GROUND:TeleportTo(hero, 160, 240, Direction.Down)
  GROUND:TeleportTo(partner, 192, 240, Direction.Down)
  
  UI:SetSpeaker(gengar)
  GeneralFunctions.SetEmotion("Happy")
  UI:WaitShowDialogue("C'est la fin du voyage pour vous, les monstres ![pause=20] Alakazam, détruisez-les ! C'est à cause d'eux que le ciel brûle !")
  
  UI:SetSpeaker(alakazam)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue("Héraut...[pause=15] Je ne souhaite pas ce combat, mais la sécurité de notre monde passe avant nos sentiments.")
  UI:WaitShowDialogue("En garde.")
  
  -- SOUDAIN : Un cri de renard mystique résonne, accompagné de flammes bleues
  SOUND:PlaySE("DUN_Will_O_Wisp")
  GAME:FadeOut(false, 5)
  GAME:WaitFrames(5)
  GAME:FadeIn(5)
  
  -- Feunard apparaît au centre sous une brume mystique
  local ninetales = CharacterEssentials.MakeCharactersFromList({{'Ninetales', 176, 200, Direction.Down}})
  
  UI:SetSpeaker(ninetales)
  UI:WaitShowDialogue("Halte.[pause=20] Rangez vos armes, explorateurs de la Fédération.")
  
  UI:SetSpeaker(gengar)
  GeneralFunctions.SetEmotion("Shock")
  UI:WaitShowDialogue("Qu-Quoi ?! Le Feunard de la prophétie !!")
  
  UI:SetSpeaker(ninetales)
  UI:WaitShowDialogue("L'humain maudit de la légende d'il y a trente ans n'est pas celui qui se tient devant vous.")
  UI:WaitShowDialogue("La prophétie a déjà été accomplie, et le péché d'autrefois a été pardonné par la bravoure de l'ancienne équipe de secours.")
  UI:WaitShowDialogue("Celui-ci... n'est qu'un voyageur du temps envoyé par le destin pour sceller l'Abîme de l'Éternité.")
  
  UI:SetSpeaker(alakazam)
  GeneralFunctions.SetEmotion("Surprised")
  UI:WaitShowDialogue("Alors...[pause=15] les séismes ne sont pas leur œuvre ?")
  
  UI:SetSpeaker(ninetales)
  UI:WaitShowDialogue("Non.[pause=20] C'est le réveil d'Eternatus, tapi sous l'Abîme, qui dévore la structure de notre dôme terrestre.")
  UI:WaitShowDialogue("Allez, Alakazam.[pause=15] Votre véritable ennemi n'est pas ici, il est sous nos pieds.")
  
  -- Alakazam baisse les bras, Gengar s'enfuit de rage
  GROUND:CharAnimateTurn(gengar, Direction.Down, 4)
  GROUND:CharSetAnim(gengar, "Run", true)
  SOUND:PlaySE("DUN_Flee")
  GROUND:Hide('Gengar')
  
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Happy")
  UI:WaitShowDialogue("On est sauvés...[pause=20] Notre nom est lavé de tout soupçon !")
  
  -- Transition vers l'Arc 3 (La Lumière dévorée)
  SV.Chapter12.FugitiveArcComplete = true
  SV.ChapterProgression.Chapter = 13
  
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(60)
  GAME:CutsceneMode(false)
  GAME:EnterGroundMap("guild_heros_room", "Main_Entrance_Marker", true)
end

return mount_freeze_summit
```

---

## 5. Processus de Validation Statistique pour l'Agent

Avant d'intégrer physiquement les assets et fichiers de cartes de ces 5 donjons dans les index du jeu :
1.  Vérifier la bonne renumérotation de la zone `Data/Zone/new_era_zone_09.json` pour correspondre à notre structure de Mont Brasier.
2.  Lancer `python3 tools/validate_all.py` pour s'assurer que les calques d'obstacles et d'arènes de Sulfura et Artikodin ne provoquent aucune erreur d'accessibilité.
3.  Vérifier via `python3 tools/verify_lua_globals.py` qu'aucun appel à des fonctions de combat ou de déplacement ne lève d'exception nil.
