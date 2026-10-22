--[[ Autel des Cieux — Climax du Chapitre 10 : Combat Sacré contre Rayquaza et Destruction de la Météorite
     Ground importé 1:1 de pmd-red D13P03 (Sky Tower Summit).
     Intègre la cinématique de la météorite détruite une seconde fois (30 ans après)
     et le clin d'œil légendaire à l'Équipe de Secours d'origine.
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'
require 'halcyon.ChapterAftermath'
require 'halcyon.ReplayEnding'
require 'halcyon.BossMusic'

local autel_celeste = {}

function autel_celeste.Init(map)
  pcall(function() GAME:FadeOut(false, 1) end)
  pcall(function() GAME:CutsceneMode(true) end)
  COMMON.RespawnAllies(true)
  pcall(function() PartnerEssentials.InitializePartnerSpawn() end)
  
  pcall(function()
    local sceneAVenir = false
    if SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter == 11 then
      sceneAVenir = not SV.Chapter11.FinishedTreasureTownIntro
    end
    if not sceneAVenir then GAME:CutsceneMode(false) end
  end)
end

function autel_celeste.Enter(map)
  DEBUG.EnableDbgCoro()

  -- Rejouabilité : après la fin du jeu, l'autel céleste est désert.
  if ReplayEnding.IsReplay('sky_tower', 10) then
    ReplayEnding.EmptyArena({
      hero = {296, 296}, partner = {256, 296},
      camera = {276, 280}, look = {276, 248},
      walk = 48, title = true, music = 'Rainbow Peak.ogg',
      lines = {
        { spk='partner', emo='Normal', key='CPB_R01', wait=10 },
        { spk='hero',    emo='Normal', key='CPB_R02', wait=10 },
        { spk='partner', emo='Normal', key='CPB_R03' },
        { spk='narrator',              key='CPB_R04' },
      },
    })
    return
  end

  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)

  -- Si la scène post-victoire n'a pas encore été jouée et que Lugia (ou Rayquaza) a été battu
  -- ACTE 2 du climax : la meteorite et Rayquaza. On y entre une fois le
  -- combat gagne ET la discussion de Lugia jouee (acte 1, flag
  -- PlayedLugiaTalk pose par ChapterAftermath.PeakVictory).
  if SV.Chapter10.CelestialPeakComplete and SV.Chapter10.PlayedLugiaTalk
     and not SV.Chapter10.PlayedVictoryScene then
    autel_celeste.PlayPostVictoryScene(hero, partner)
    return
  end

  -- ============================================================
  -- CINÉMATIQUE DE CONFRONTATION (AVANT COMBAT)
  -- ============================================================
  GROUND:TeleportTo(hero, 296, 296, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 256, 296, Direction.Up) end
  GAME:MoveCamera(276, 280, 1, false)

  GAME:FadeIn(60)
  GAME:WaitFrames(30)

  -- ------------------------------------------------------------
  -- APPARITION EN TROIS COUCHES
  --
  -- Couche 1 — la voix seule. Rayquaza parle avant d'etre visible :
  -- aucun portrait, aucun corps a l'ecran. On n'emploie pas
  -- BossFX.Voice ici : cette fonction est reservee a la Voix anonyme
  -- (\uE040), qui n'a rien a voir avec le Gardien et fait souffrir le
  -- heros. Le locuteur est simplement laisse vide.
  -- ------------------------------------------------------------
  SOUND:StopBGM()
  GAME:WaitFrames(30)

  -- Le duo cherche d'ou vient la voix : chacun leve la tete depuis sa
  -- propre place, personne ne reste fige.
  pcall(function()
    GROUND:CharSetEmote(hero, "question", 1)
    if partner ~= nil then GROUND:CharSetEmote(partner, "question", 1) end
  end)
  SOUND:PlayBattleSE("DUN_Wind")
  GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 3, 30))
  GAME:WaitFrames(30)

  UI:ResetSpeaker(false)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CPB_001']))
  GAME:WaitFrames(20)

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

  BossMusic.Play('autel_celeste')

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
function autel_celeste.PlayPostVictoryScene(hero, partner)
  local rayquaza = CharacterEssentials.MakeCharactersFromList({{'Rayquaza', 272, 272, Direction.Down}})
  
  -- Rayquaza est blessé, à bout de forces
  GROUND:CharSetAnim(rayquaza, "Pain", true)
  GROUND:TeleportTo(hero, 296, 296, Direction.Up)
  GROUND:TeleportTo(partner, 256, 296, Direction.Up)
  GAME:MoveCamera(276, 280, 1, false)
  
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
  pcall(function()
    local ray_emitter = RogueEssence.Content.SingleEmitter(RogueEssence.Content.AnimData("VFX_Rayquaza_Hyperbeam_Core", 4))
    GROUND:PlayVFX(ray_emitter, rayquaza.Position.X, rayquaza.Position.Y)
  end)
  GAME:FadeOut(false, 10)
  GAME:WaitFrames(15)
  GAME:FadeIn(10)
  
  -- Cinématique de vol de Rayquaza vers la météorite
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CPB_013']))
  
  -- Flashs et explosions dans le ciel
  SOUND:PlaySE("DUN_Hyper_Beam")
  pcall(function()
    local beam_emitter = RogueEssence.Content.SingleEmitter(RogueEssence.Content.AnimData("VFX_Rayquaza_Hyperbeam_Core", 4))
    GROUND:PlayVFX(beam_emitter, 276, 180) -- Centre du ciel
  end)
  GAME:FadeOut(false, 2)
  GAME:WaitFrames(10)
  GAME:FadeIn(2)
  GAME:FadeOut(false, 1)
  GAME:WaitFrames(15)
  GAME:FadeIn(1)
  
  SOUND:PlaySE("DUN_Explosion")
  pcall(function()
    local met_emitter = RogueEssence.Content.SingleEmitter(RogueEssence.Content.AnimData("VFX_Meteor_Fragment", 8))
    GROUND:PlayVFX(met_emitter, 276, 180) -- Explosion de la météorite
  end)
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

function autel_celeste.Update(map, time) end
function autel_celeste.GameSave(map) end
function autel_celeste.GameLoad(map) end

return autel_celeste
