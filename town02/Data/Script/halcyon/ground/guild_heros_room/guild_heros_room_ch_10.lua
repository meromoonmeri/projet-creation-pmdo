--[[
    guild_heros_room_ch_10.lua
    Chapitre 10 — Carton-titre + veillee finale avant le Pic Celeste

    Patron identique a guild_heros_room_ch_7/8/9.

    Dernier chapitre ecrit a ce jour. La veillee ferme l'arc : la Voix
    mysterieuse revient une derniere fois, toujours ANONYME (speaker \uE040),
    et ne prononce aucun nom interdit. Elle ne menace pas — elle previent.
    Le mot « prison » n'est pas dit non plus : il est seulement approche.
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.HeroVisions'
require 'halcyon.ground.guild_heros_room.guild_heros_room_helper'

guild_heros_room_ch_10 = {}

function guild_heros_room_ch_10.ShowTitleCard()
  GAME:FadeOut(false, 1)
  GAME:CutsceneMode(true)
  AI:DisableCharacterAI(CH('Teammate1'))
  UI:ResetSpeaker()
  SOUND:StopBGM()
  GAME:WaitFrames(60)
  local coro1 = TASK:BranchCoroutine(function()
    UI:WaitShowTitle("Chapitre 10\nLe Pic Celeste\n", 20)
    GAME:WaitFrames(180)
    UI:WaitHideTitle(20) end)
  local coro2 = TASK:BranchCoroutine(function()
    UI:WaitShowBG("Chapter_10", 180, 20)
    GAME:WaitFrames(180)
    UI:WaitHideBG(20) end)
  TASK:JoinCoroutines({coro1, coro2})
  GAME:WaitFrames(120)
  SV.Chapter10.ShowedTitleCard = true
  guild_heros_room_helper.Morning(true)
end

-- Veillee finale : apres Lugia, la Voix revient. Elle ne menace plus.
function guild_heros_room_ch_10.PostPeakBedtalk()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  guild_heros_room_helper.Bedtime(false)
  UI:ResetSpeaker()
  GAME:FadeIn(40)

  SOUND:PlayBGM('Goodnight.ogg', true)
  GAME:WaitFrames(40)

  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Happy")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR10_001']))

  GAME:WaitFrames(20)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR10_002']))

  GAME:WaitFrames(20)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['GHR10_003']), "Normal")

  GAME:WaitFrames(30)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR10_004']))

  GAME:WaitFrames(40)
  GROUND:CharSetAnim(partner, "Laying", true)
  GAME:WaitFrames(60)
  GROUND:CharSetAnim(hero, "Laying", true)
  GAME:WaitFrames(40)
  GROUND:CharSetAnim(partner, "EventSleep", true)
  GAME:WaitFrames(40)
  GROUND:CharSetAnim(hero, "EventSleep", true)

  -- === LA VOIX, UNE DERNIERE FOIS ===
  GAME:WaitFrames(120)
  SOUND:FadeOutBGM(80)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(60)

  UI:ResetSpeaker()
  SOUND:PlayBattleSE('EVT_Battle_Flash')

  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR10_005']))

  GAME:WaitFrames(60)
  SOUND:PlayBattleSE('_UNK_EVT_102')
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR10_006']))

  GAME:WaitFrames(60)

  -- Bref eclat prismatique, plus large que celui du chapitre 7.
  GAME:FadeIn(3)
  local center = GAME:GetCameraCenter()
  local flash = RogueEssence.Content.FlashEmitter()
  flash.FadeInTime = 2; flash.HoldTime = 5; flash.FadeOutTime = 20
  flash.StartColor = Color(80, 20, 120, 0)
  flash.Layer = DrawLayer.Top
  flash.Anim = RogueEssence.Content.BGAnimData("White", 0)
  GROUND:PlayVFX(flash, center.X, center.Y)
  GAME:WaitFrames(12)
  GAME:FadeOut(false, 3)
  GAME:WaitFrames(30)

  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR10_007']))

  GAME:WaitFrames(90)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(120)

  -- Reveil
  GROUND:CharSetAnim(hero, "Idle", true)
  GROUND:CharSetAnim(partner, "Idle", true)
  GAME:FadeIn(20)

  GAME:WaitFrames(30)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR10_008']))

  GAME:WaitFrames(20)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['GHR10_009']), "Sad")

  GAME:WaitFrames(30)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR10_010']))

  GAME:WaitFrames(60)
  GROUND:CharSetAnim(partner, "EventSleep", true)
  GAME:WaitFrames(40)
  GROUND:CharSetAnim(hero, "EventSleep", true)
  GAME:WaitFrames(120)

  SOUND:FadeOutBGM(80)
  GAME:FadeOut(false, 120)

    -- Vision du passe : le heros seul la traverse, endormi. Le partenaire dort
  -- a cote de lui et ne verra rien. Ne se joue qu'une fois (PlayOnce).
  HeroVisions.TryTrigger('effacement', partner)
  GAME:WaitFrames(30)

  SV.Chapter10.FinishedBedtimeCutscene = true
  SV.TemporaryFlags.MorningAddress = true
  SV.TemporaryFlags.MorningWakeup = true
  GeneralFunctions.EndOfDay()
  GAME:CutsceneMode(false)
  GAME:EnterGroundMap('guild_heros_room', 'Main_Entrance_Marker')
end

return guild_heros_room_ch_10
