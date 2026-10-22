--[[ SKY TOWER SUMMIT — D13P03 / gs209 (PMD Red Rescue Team).

     Ground et tileset importés 1:1 depuis meromoonmeri/PMD-RED-PMDO-PORT.
     Géométrie 69x75, collision et marqueurs canoniques conservés :
       héros/entrée (296,296), partenaire (256,296),
       Rayquaza (272,272), déclencheur/caméra (272,280).

     La cinématique New Era transpose le casting sans changer la grammaire
     de gs209/d13p03 : Domaine de Rayquaza, double flash 8f, rugissement et
     secousse, flash 30f/retour 16f, confrontation, combat, puis séquence
     météorite/hyperbeam. Les dialogues racontent l'état du monde trente ans
     plus tard, mais le lieu, les positions, les VFX et le rythme restent
     ceux du sommet canonique.
]]--
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'
require 'halcyon.BossMusic'
require 'halcyon.ReplayEnding'

local tour_ciel_sommet = {}

function tour_ciel_sommet.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo('=>> Init_tour_ciel_sommet')
  pcall(function() GAME:FadeOut(false, 1) end)
  pcall(function() GAME:CutsceneMode(true) end)
  COMMON.RespawnAllies()
  pcall(function() PartnerEssentials.InitializePartnerSpawn() end)
end

function tour_ciel_sommet.Enter(map)
  DEBUG.EnableDbgCoro()
  -- SORTIE GARANTIE : toute la scène sous pcall. Si elle lève, on rend
  -- la main plutôt que de laisser le joueur sur un écran noir.
  local ok, err = pcall(tour_ciel_sommet.ArrivalBody)
  if not ok then
    PrintInfo('[tour_ciel_sommet] scène interrompue : ' .. tostring(err))
    pcall(function() GAME:CutsceneMode(false) end)
    pcall(function() GAME:FadeIn(20) end)
  end
end

function tour_ciel_sommet.ArrivalBody()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  -- ACTE 2 déjà armé : on revient du combat, la météorite attend.
  -- CONDITION REPRISE MOT POUR MOT d'autel_celeste/init.lua:59.
  -- Première rédaction : SV.Chapter10.DefeatedRayquaza — drapeau que
  -- j'avais INVENTÉ. Vérification faite dans scriptvars.lua : il n'existe
  -- pas. Les drapeaux réels sont CelestialPeakComplete (posé par
  -- zone/celestial_peak:137) et PlayedLugiaTalk (posé par
  -- ChapterAftermath.PeakVictory, acte 1).
  if SV.Chapter10 ~= nil and SV.Chapter10.CelestialPeakComplete
     and SV.Chapter10.PlayedLugiaTalk
     and not SV.Chapter10.PlayedVictoryScene then
    tour_ciel_sommet.PlayPostVictoryScene(hero, partner)
    return
  end

  -- Rejouabilité : après la fin du jeu, le sommet est désert.
  if ReplayEnding.IsReplay('sky_tower', 10) then
    ReplayEnding.EmptyArena({
      hero = {296, 296}, partner = {256, 296},
      camera = {272, 280}, look = {272, 272},
      walk = 48, title = true, music = 'Sky Tower.ogg',
    })
    return
  end

  GAME:CutsceneMode(true)
  if partner ~= nil then AI:DisableCharacterAI(partner) end
  GROUND:TeleportTo(hero, 296, 296, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 256, 296, Direction.Up) end
  GAME:MoveCamera(272, 280, 1, false)
  pcall(function() SOUND:PlayBGM('Sky Tower.ogg', true) end)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)

  UI:ResetSpeaker(false)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CPB_001']))
  -- Cadence exacte extraite de d13p03.cif.json (gs209) : deux éclairs,
  -- rugissement/secousse, puis révélation longue.
  GAME:FadeOut(true, 8)
  GAME:FadeIn(8)
  GAME:FadeOut(true, 8)
  GAME:FadeIn(8)
  SOUND:PlayBattleSE('EVT_Roar')
  pcall(function() GAME:ScreenShake(4, 4, 20) end)
  GAME:WaitFrames(20)
  GAME:FadeOut(true, 30)
  GAME:FadeIn(16)

  -- ------------------------------------------------------------
  -- Couche 2 — il fend les nuages. Descente verticale reelle,
  -- puis souffle qui repousse le groupe.
  -- ------------------------------------------------------------
  local rayquaza = CharacterEssentials.MakeCharactersFromList({{'Rayquaza', 272, 272, Direction.Down}})
  GROUND:Hide('Rayquaza')
  BossFX.DescendSky(rayquaza, 272, 272, 160)

  BossFX.PushBack({hero, partner}, Direction.Down)
  pcall(function()
    GROUND:CharSetEmote(hero, "shock", 1)
    if partner ~= nil then GROUND:CharSetEmote(partner, "shock", 1) end
  end)

  -- ------------------------------------------------------------
  -- Couche 3 — deploiement, lumiere, theme celeste. C'est seulement
  -- ici qu'il devient un interlocuteur avec un portrait.
  -- ------------------------------------------------------------
  GROUND:CharSetAnim(rayquaza, "Attack", false)
  SOUND:PlaySE("DUN_Thundurus_Spawn")
  pcall(function() BossFX.Flash(272, 272, 4, 6, 30) end)
  GAME:WaitFrames(25)
  GROUND:CharSetAnim(rayquaza, "Idle", true)

  -- La scene a ete transposee depuis autel_celeste, et l'appel a suivi
  -- tel quel : elle demandait le theme de l'AUTEL alors qu'elle se joue
  -- au SOMMET. Les deux pointent aujourd'hui sur la meme piste (T.CIEL),
  -- donc rien ne s'entendait — mais toute retouche de BossMusic.LIST sur
  -- l'une aurait silencieusement change l'autre.
  BossMusic.Play('tour_ciel_sommet')

  UI:WaitShowTitle(rayquaza:GetDisplayName(), 20)
  GAME:WaitFrames(40)
  UI:WaitHideTitle(20)

  -- Le duo se retourne vers lui, chacun selon sa position.
  pcall(function()
    GROUND:CharTurnToCharAnimated(hero, rayquaza, 4)
    if partner ~= nil then GROUND:CharTurnToCharAnimated(partner, rayquaza, 4) end
  end)
  GAME:WaitFrames(15)

  UI:SetSpeaker(rayquaza)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CPB_002']))
  GeneralFunctions.SetEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CPB_003']))

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  
  -- Lancement du combat de boss légendaire
  GAME:ContinueDungeon("sky_tower", 5, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

-- ============================================================
-- CINÉMATIQUE DE LA MÉTÉORITE & CLIN D'ŒIL (APRÈS COMBAT)
-- ============================================================

function tour_ciel_sommet.PlayPostVictoryScene(hero, partner)
  local rayquaza = CharacterEssentials.MakeCharactersFromList({{'Rayquaza', 272, 272, Direction.Down}})
  
  -- Rayquaza est blessé, à bout de forces
  GROUND:CharSetAnim(rayquaza, "Pain", true)
  GROUND:TeleportTo(hero, 296, 296, Direction.Up)
  GROUND:TeleportTo(partner, 256, 296, Direction.Up)
  GAME:MoveCamera(272, 280, 1, false)
  
  GAME:FadeIn(30)
  GAME:WaitFrames(20)
  
  -- Rayquaza réalise la force des héros
  UI:SetSpeaker(rayquaza)
  GeneralFunctions.SetEmotion("Pain")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CPB_004']))
  
  -- Déclenchement du clin d'œil à l'Équipe de Secours d'origine
  GeneralFunctions.SetEmotion("Surprised")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CPB_005']))
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CPB_006']))
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CPB_007']))
  
  -- Le partenaire réagit avec stupeur
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Surprised")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CPB_008']))
  
  -- Rayquaza confirme l'héritage légendaire
  UI:SetSpeaker(rayquaza)
  GeneralFunctions.SetEmotion("Inspired")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CPB_009']))
  
  -- SOUDAIN : Ciel de sang et séismes violents
  SOUND:PlaySE("DUN_Earthquake_Loop")
  GAME:WaitFrames(10)
  SOUND:PlaySE("DUN_Light_Screen")
  
  -- Flashs rouges pour matérialiser la météorite qui approche
  GAME:FadeOut(false, 5)
  GAME:WaitFrames(5)
  GAME:FadeIn(5)
  
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Surprised")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CPB_010']))
  
  -- Rayquaza s'élève avec détermination
  UI:SetSpeaker(rayquaza)
  GeneralFunctions.SetEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CPB_011']))
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CPB_012']))
  
  -- Animation de chargement de puissance divine (Mega Evolution/Draco-Ascension)
  SOUND:PlaySE("DUN_Stat_Up")
  GAME:FadeOut(false, 10)
  GAME:WaitFrames(15)
  GAME:FadeIn(10)
  
  -- Cinématique de vol de Rayquaza vers la météorite
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CPB_013']))
  
  -- Flashs et explosions dans le ciel. Les deux VFX proviennent du port
  -- canonique PMD-RED-PMDO-PORT et sont vérifiés octet pour octet.
  SOUND:PlaySE("DUN_Hyper_Beam")
  pcall(function()
    local core = RogueEssence.Content.SingleEmitter(
      RogueEssence.Content.AnimData("VFX_Rayquaza_Hyperbeam_Core", 4))
    GROUND:PlayVFX(core, rayquaza.Position.X, rayquaza.Position.Y)
  end)
  GAME:WaitFrames(8)
  pcall(function()
    local meteor = RogueEssence.Content.SingleEmitter(
      RogueEssence.Content.AnimData("VFX_Meteor_Fragment", 4))
    GROUND:PlayVFX(meteor, 272, 224)
  end)
  GAME:FadeOut(false, 2)
  GAME:WaitFrames(10)
  GAME:FadeIn(2)
  GAME:FadeOut(false, 1)
  GAME:WaitFrames(15)
  GAME:FadeIn(1)
  
  SOUND:PlaySE("DUN_Explosion")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CPB_014']))
  UI:SetCenter(false)
  
  -- Arrêt des séismes, ciel redevenu paisible baigné d'étoiles filantes
  SOUND:PlaySE("DUN_Reflect")
  GAME:WaitFrames(30)
  
  -- Le partenaire admire les débris cosmiques inoffensifs
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Joyous")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CPB_015']))
  
  -- Mais la panique de la ville se fait sentir au loin (grondement)
  SOUND:PlaySE("DUN_Earthquake_Loop")
  GAME:WaitFrames(20)
  
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CPB_016']))
  
  -- Rayquaza redescend, épuisé, pour donner son avertissement final
  GROUND:CharSetAnim(rayquaza, "Idle", true)
  UI:SetSpeaker(rayquaza)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CPB_017']))
  
  -- Fin de la cinématique et validation de la progression
  SV.Chapter10.PlayedVictoryScene = true
  SV.ChapterProgression.Chapter = 11 -- Bascule vers le Chapitre 11 (Arc Fugitif)
  
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(60)
  
  -- Sauvegarde et transition vers la chambre d'éveil comme fugitif
  GAME:CutsceneMode(false)
  GAME:EnterGroundMap("guild_heros_room", "Main_Entrance_Marker", true)
end

function tour_ciel_sommet.Update(map, time) end

function tour_ciel_sommet.GameSave(map)
  pcall(function() PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1')) end)
end

function tour_ciel_sommet.GameLoad(map)
  pcall(function() PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1')) end)
  tour_ciel_sommet.Enter(map)
end

return tour_ciel_sommet
