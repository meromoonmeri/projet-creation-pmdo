--[[
    guild_heros_room_ch_5.lua
    Chapter 5 hero room scenes: Title Card + Post-Expedition Bedtalk
]]

require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.HeroVisions'
require 'halcyon.CharacterEssentials'
require 'halcyon.ground.guild_heros_room.guild_heros_room_helper'

guild_heros_room_ch_5 = {}


function guild_heros_room_ch_5.ShowTitleCard()
  GAME:FadeOut(false, 1)
  GAME:CutsceneMode(true)
  AI:DisableCharacterAI(CH('Teammate1'))
  UI:ResetSpeaker()
  SOUND:StopBGM()
  GAME:WaitFrames(60)
  local coro1 = TASK:BranchCoroutine(function()
    UI:WaitShowTitle("Chapitre 5\n\nL'Expédition\n", 20)
    GAME:WaitFrames(180)
    UI:WaitHideTitle(20)
  end)
  local coro2 = TASK:BranchCoroutine(function()
    UI:WaitShowBG("Chapter_5", 180, 20)
    GAME:WaitFrames(180)
    UI:WaitHideBG(20)
  end)
  TASK:JoinCoroutines({coro1, coro2})

  GAME:WaitFrames(120)
  SV.Chapter5.ShowedTitleCard = true
  guild_heros_room_helper.Morning(true)
end


--[[
  PostExpeditionBedtalk
  Plays when the hero and partner return from the expedition (Mount Windswept cleared).
  They reflect on their journey, the mysterious voice, and look forward to what comes next.
  Sets DaysToReach to force 2 days of missions before Chapter 6 starts.
]]
function guild_heros_room_ch_5.PostExpeditionBedtalk()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  guild_heros_room_helper.Bedtime(false)
  UI:ResetSpeaker()
  GAME:FadeIn(40)

  SOUND:PlayBGM('Goodnight.ogg', true)
  GAME:WaitFrames(40)

  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Inspired")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR5_001'], hero:GetDisplayName()))
  -- "On l'a fait, [hero]... L'expédition est terminée !"

  GAME:WaitFrames(20)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR5_002']))
  -- "La Grande Steppe, le Tunnel Incandescent, le Mont Venteux..."

  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR5_003']))
  -- "On a traversé tellement d'endroits dangereux. Et on est toujours debout !"

  GAME:WaitFrames(20)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['GHR5_004']), "Happy")
  -- "(Oui. C'était dur, mais on a réussi ensemble.)"

  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR5_005']))
  -- "Mais... cette voix qu'on a entendue. Plusieurs fois."

  GAME:WaitFrames(10)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR5_006']))
  -- "Elle semblait tout savoir. Les boss, les lieux... et nous."

  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR5_007']))
  -- "Qui peut bien être derrière tout ça ?"

  GAME:WaitFrames(20)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['GHR5_008']), "Worried")
  -- "(Je ne sais pas. Mais cette présence... elle n'est pas hostile.)"

  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['GHR5_009']), "Normal")
  -- "(Elle nous observait. Comme si elle attendait quelque chose de nous.)"

  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR5_010']))
  -- "En tout cas, on a prouvé qu'on était de vrais aventuriers !"

  GAME:WaitFrames(15)
  GeneralFunctions.SetEmotion("Happy")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR5_011']))
  -- "La guilde va être fière de nous. Surtout Penticus !"

  GAME:WaitFrames(20)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR5_012']))
  -- "Bon... on devrait se reposer un peu. Ces derniers jours ont été épuisants."

  GAME:WaitFrames(20)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR5_013']))
  -- "Mais dès qu'on est prêts, on devrait continuer à explorer."

  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR5_014']))
  -- "Il y a sûrement d'autres donjons à découvrir, d'autres missions à accomplir."

  GAME:WaitFrames(20)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['GHR5_015']), "Happy")
  -- "(Tu as raison. Prenons quelques jours pour nous entraîner.)"

  GAME:WaitFrames(40)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Happy")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR5_016'], hero:GetDisplayName()))
  -- "Bonne nuit, [hero]. À demain !"

  GAME:WaitFrames(40)
  GROUND:CharSetAnim(partner, "Laying", true)
  GAME:WaitFrames(60)
  GROUND:CharSetAnim(hero, "Laying", true)
  GAME:WaitFrames(40)
  UI:SetSpeaker(partner:GetDisplayName(), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR5_017']))
  -- "Zzz..."

  GAME:WaitFrames(40)
  GROUND:CharSetAnim(partner, "EventSleep", true)
  GAME:WaitFrames(40)
  GROUND:CharSetAnim(hero, "EventSleep", true)
  GAME:WaitFrames(180)
  SOUND:FadeOutBGM(120)
  GAME:FadeOut(false, 120)

  --------------------------------------------------------------------
  -- LE PREMIER RÊVE (foreshadowing arcs 2-6 : mémoire du dernier
  -- gardien du sceau — le joueur ne peut PAS le comprendre maintenant).
  -- Écran noir, voix off sans boîte de dialogue, son de cristal.
  -- « Elle ne nourrit pas... elle retient » = le twist final (la lumière
  -- des Cœurs est une prison), énoncé mot pour mot 27 chapitres à l'avance.
  --------------------------------------------------------------------
  GAME:WaitFrames(120)
  SOUND:PlayBattleSE("DUN_Power_Gem")
  GAME:WaitFrames(80)
  UI:WaitShowVoiceOver("[speed=0.5]...la lumière...[pause=30] n'est pas ce que tu crois...[speed=1]", -1)
  GAME:WaitFrames(40)
  SOUND:PlayBattleSE("DUN_Power_Gem")
  GAME:WaitFrames(40)
  UI:WaitShowVoiceOver("[speed=0.5]...elle ne nourrit pas...[pause=30] elle retient...[speed=1]", -1)
  GAME:WaitFrames(40)
  SOUND:PlayBattleSE("EVT_Battle_Flash")
  GAME:WaitFrames(60)
  UI:WaitShowVoiceOver("[speed=0.4]...souviens-toi...[pause=40] pourquoi tu es venu...[speed=1]", -1)
  GAME:WaitFrames(90)
  UI:WaitShowVoiceOver("(...![pause=20] Un rêve ?[pause=20] Je...[pause=20] je n'arrive déjà plus à m'en souvenir...)", -1)
  GAME:WaitFrames(60)
  SV.Chapter5.HadFirstDream = true

    -- Vision du passe : le heros seul la traverse, endormi. Le partenaire dort
  -- a cote de lui et ne verra rien. Ne se joue qu'une fois (PlayOnce).
  HeroVisions.TryTrigger('meteore', partner)
  GAME:WaitFrames(30)

  SV.Chapter5.FinishedBedtimeCutscene = true
  SV.ChapterProgression.CurrentStoryDungeon = ''
  SV.TemporaryFlags.MorningAddress = true
  SV.TemporaryFlags.MorningWakeup = true
  GeneralFunctions.EndOfDay()
  -- 2 days of missions before Chapter 6 starts
  SV.ChapterProgression.DaysToReach = SV.ChapterProgression.DaysPassed + 2
  GAME:CutsceneMode(false)
  GAME:EnterGroundMap('guild_heros_room', 'Main_Entrance_Marker')
end


-- Chapter 5 bedtime dialogue strings for the resx
-- These will be registered by the resx files
return guild_heros_room_ch_5
