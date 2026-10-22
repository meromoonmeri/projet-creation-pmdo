--[[
    guild_heros_room_ch_9.lua
    Chapitre 9 — Carton-titre + veillee apres le Marais de l'Oubli

    Patron identique a guild_heros_room_ch_7/8.

    C'est ici que la phrase du Cercle du Suaire commence a travailler le duo :
    « Chaque Coeur que vous guerissez rapproche la fin. » Le heros n'a pas de
    reponse, et c'est exactement le point. Aucun nom interdit n'est prononce :
    la Voix reste anonyme, conformement a la regle du projet.
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.HeroVisions'
require 'halcyon.ground.guild_heros_room.guild_heros_room_helper'

guild_heros_room_ch_9 = {}

function guild_heros_room_ch_9.ShowTitleCard()
  GAME:FadeOut(false, 1)
  GAME:CutsceneMode(true)
  AI:DisableCharacterAI(CH('Teammate1'))
  UI:ResetSpeaker()
  SOUND:StopBGM()
  GAME:WaitFrames(60)
  local coro1 = TASK:BranchCoroutine(function()
    UI:WaitShowTitle("Chapitre 9\nLe Marais de l'Oubli\n", 20)
    GAME:WaitFrames(180)
    UI:WaitHideTitle(20) end)
  local coro2 = TASK:BranchCoroutine(function()
    UI:WaitShowBG("Chapter_9", 180, 20)
    GAME:WaitFrames(180)
    UI:WaitHideBG(20) end)
  TASK:JoinCoroutines({coro1, coro2})
  GAME:WaitFrames(120)
  SV.Chapter9.ShowedTitleCard = true
  guild_heros_room_helper.Morning(true)
end

-- Veillee : la phrase du Cercle du Suaire empeche le duo de dormir.
function guild_heros_room_ch_9.PostMarshBedtalk()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  guild_heros_room_helper.Bedtime(false)
  UI:ResetSpeaker()
  GAME:FadeIn(40)

  SOUND:PlayBGM('Goodnight.ogg', true)
  GAME:WaitFrames(40)

  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR9_001']))

  GAME:WaitFrames(20)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR9_002']))

  GAME:WaitFrames(30)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['GHR9_003']), "Worried")

  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Sad")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR9_004']))

  GAME:WaitFrames(30)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR9_005']))

  GAME:WaitFrames(20)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['GHR9_006']), "Normal")

  GAME:WaitFrames(30)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR9_007']))

  GAME:WaitFrames(40)
  GROUND:CharSetAnim(partner, "Laying", true)
  GAME:WaitFrames(60)
  GROUND:CharSetAnim(hero, "Laying", true)
  GAME:WaitFrames(40)
  GROUND:CharSetAnim(partner, "EventSleep", true)
  GAME:WaitFrames(60)

  -- Le heros reste eveille un moment. Pas de voix, pas de vision : juste
  -- la question qui tourne. Le silence en dit plus qu'une cinematique.
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['GHR9_008']), "Sad")
  GAME:WaitFrames(40)
  GROUND:CharSetAnim(hero, "EventSleep", true)
  GAME:WaitFrames(120)

  SOUND:FadeOutBGM(80)
  GAME:FadeOut(false, 120)

    -- Vision du passe : le heros seul la traverse, endormi. Le partenaire dort
  -- a cote de lui et ne verra rien. Ne se joue qu'une fois (PlayOnce).
  HeroVisions.TryTrigger('sommet', partner)
  GAME:WaitFrames(30)

  SV.Chapter9.FinishedBedtimeCutscene = true
  SV.TemporaryFlags.MorningAddress = true
  SV.TemporaryFlags.MorningWakeup = true
  GeneralFunctions.EndOfDay()
  GAME:CutsceneMode(false)
  GAME:EnterGroundMap('guild_heros_room', 'Main_Entrance_Marker')
end

return guild_heros_room_ch_9
