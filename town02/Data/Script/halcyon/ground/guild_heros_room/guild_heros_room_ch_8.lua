--[[
    guild_heros_room_ch_8.lua
    Chapitre 8 — Carton-titre + veillee avant le Sanctuaire de Cristal

    Ecrit sur le patron exact de guild_heros_room_ch_7.lua : meme structure de
    carton-titre (titre + fond en coroutines paralleles), meme enchainement
    Bedtime -> dialogue -> coucher -> EndOfDay.

    Le chapitre 8 n'avait NI carton-titre NI scene de chambre : le joueur
    passait du chapitre 7 au Sanctuaire de Cristal sans aucune transition.
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.ground.guild_heros_room.guild_heros_room_helper'

guild_heros_room_ch_8 = {}

function guild_heros_room_ch_8.ShowTitleCard()
  GAME:FadeOut(false, 1)
  GAME:CutsceneMode(true)
  AI:DisableCharacterAI(CH('Teammate1'))
  UI:ResetSpeaker()
  SOUND:StopBGM()
  GAME:WaitFrames(60)
  local coro1 = TASK:BranchCoroutine(function()
    UI:WaitShowTitle("Chapitre 8\nLe Sanctuaire de Cristal\n", 20)
    GAME:WaitFrames(180)
    UI:WaitHideTitle(20) end)
  local coro2 = TASK:BranchCoroutine(function()
    UI:WaitShowBG("Chapter_8", 180, 20)
    GAME:WaitFrames(180)
    UI:WaitHideBG(20) end)
  TASK:JoinCoroutines({coro1, coro2})
  GAME:WaitFrames(120)
  SV.Chapter8.ShowedTitleCard = true
  guild_heros_room_helper.Morning(true)
end

-- Veillee : le Fragment de Cristal repond au reve de la nuit precedente.
-- Pas de nouvelle voix ici : on laisse le doute pose au chapitre 7 travailler.
function guild_heros_room_ch_8.PostSanctuaryBedtalk()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  guild_heros_room_helper.Bedtime(false)
  UI:ResetSpeaker()
  GAME:FadeIn(40)

  SOUND:PlayBGM('Goodnight.ogg', true)
  GAME:WaitFrames(40)

  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR8_001']))

  GAME:WaitFrames(20)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR8_002']))

  GAME:WaitFrames(20)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['GHR8_003']), "Worried")

  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR8_004']))

  GAME:WaitFrames(20)
  GeneralFunctions.SetEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR8_005']))

  -- ENRICHISSEMENT 2026-08-09 — le Fragment de Cristal, les doutes, le rêve.
  -- La veillée ne s'arrêtait plus après cinq répliques : le duo venait de
  -- battre Diancie et de recevoir la première preuve de leur quête. On
  -- donne à cette nuit son poids — le Fragment, le Cercle du Suaire, la
  -- crainte que les autres Cœurs s'éteignent, et le rêve qui revient.
  GAME:WaitFrames(30)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['GHR8_006']), "Normal")

  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR8_007']))
  GAME:WaitFrames(12)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR8_008']))
  GAME:WaitFrames(12)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR8_009']))
  GAME:WaitFrames(16)

  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['GHR8_010']), "Worried")
  GAME:WaitFrames(16)

  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR8_011']))
  GAME:WaitFrames(12)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR8_012']))
  GAME:WaitFrames(14)

  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['GHR8_013']), "Worried")
  GAME:WaitFrames(16)

  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR8_014']))
  GAME:WaitFrames(12)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR8_015']))
  GAME:WaitFrames(16)

  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['GHR8_016']), "Worried")
  GAME:WaitFrames(14)

  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR8_017']))
  GAME:WaitFrames(12)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR8_018']))
  GAME:WaitFrames(16)

  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['GHR8_019']), "Determined")
  GAME:WaitFrames(16)

  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR8_020']))
  GAME:WaitFrames(12)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR8_021']))
  GAME:WaitFrames(14)

  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['GHR8_022']), "Determined")
  GAME:WaitFrames(16)

  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR8_023']))
  GAME:WaitFrames(12)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR8_024']))
  GAME:WaitFrames(14)

  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['GHR8_025']), "Normal")
  GAME:WaitFrames(14)

  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR8_026']))
  GAME:WaitFrames(16)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['GHR8_027']), "Normal")
  GAME:WaitFrames(20)

  GAME:WaitFrames(40)
  GROUND:CharSetAnim(partner, "Laying", true)
  GAME:WaitFrames(60)
  GROUND:CharSetAnim(hero, "Laying", true)
  GAME:WaitFrames(40)
  GROUND:CharSetAnim(partner, "EventSleep", true)
  GAME:WaitFrames(40)
  GROUND:CharSetAnim(hero, "EventSleep", true)
  GAME:WaitFrames(120)

  SOUND:FadeOutBGM(80)
  GAME:FadeOut(false, 120)

  SV.Chapter8.FinishedBedtimeCutscene = true
  SV.TemporaryFlags.MorningAddress = true
  SV.TemporaryFlags.MorningWakeup = true
  GeneralFunctions.EndOfDay()
  GAME:CutsceneMode(false)
  GAME:EnterGroundMap('guild_heros_room', 'Main_Entrance_Marker')
end

return guild_heros_room_ch_8
