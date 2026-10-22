--[[
    guild_heros_room_ch_7.lua
    Chapitre 7 — Title Card + Reve du heros (Necrozma)
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.HeroVisions'
require 'halcyon.ground.guild_heros_room.guild_heros_room_helper'

guild_heros_room_ch_7 = {}

function guild_heros_room_ch_7.ShowTitleCard()
  GAME:FadeOut(false, 1)
  GAME:CutsceneMode(true)
  AI:DisableCharacterAI(CH('Teammate1'))
  UI:ResetSpeaker()
  SOUND:StopBGM()
  GAME:WaitFrames(60)
  local coro1 = TASK:BranchCoroutine(function()
    UI:WaitShowTitle("Chapitre 7\nLes Aegis Cave\n", 20)
    GAME:WaitFrames(180)
    UI:WaitHideTitle(20) end)
  local coro2 = TASK:BranchCoroutine(function()
    UI:WaitShowBG("Chapter_7", 180, 20)
    GAME:WaitFrames(180)
    UI:WaitHideBG(20) end)
  TASK:JoinCoroutines({coro1, coro2})
  GAME:WaitFrames(120)
  SV.Chapter7.ShowedTitleCard = true
  guild_heros_room_helper.Morning(true)
end

-- Reve nocturne : premiere vision de Necrozma
function guild_heros_room_ch_7.DreamCutscene()
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
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR7_001']))
  -- "Quelle journee...[pause=15] Phileas nous a raconte des choses incroyables."

  GAME:WaitFrames(20)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR7_002']))
  -- "Mew...[pause=20] les Coeurs des Anima...[pause=15] tout ca me depasse."

  GAME:WaitFrames(20)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['GHR7_003']), "Worried")
  -- "(Ca fait beaucoup a assimiler. Mais au moins on comprend mieux maintenant.)"

  GAME:WaitFrames(40)

  -- Coucher
  GROUND:CharSetAnim(partner, "Laying", true)
  GAME:WaitFrames(60)
  GROUND:CharSetAnim(hero, "Laying", true)
  GAME:WaitFrames(40)
  GROUND:CharSetAnim(partner, "EventSleep", true)
  GAME:WaitFrames(40)
  GROUND:CharSetAnim(hero, "EventSleep", true)

  -- === REVE DU HEROS ===
  GAME:WaitFrames(120)
  SOUND:FadeOutBGM(80)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(60)

  -- Fond noir, silence
  UI:ResetSpeaker()
  SOUND:PlayBattleSE('EVT_Battle_Flash')

  -- Voix cryptique (Necrozma)
  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR7_004']))
  -- "...le sceau...[pause=30] s'affaiblit..."

  GAME:WaitFrames(60)
  SOUND:PlayBattleSE('_UNK_EVT_102')
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR7_005']))
  -- "Tu ne peux pas...[pause=20] les sauver tous..."

  GAME:WaitFrames(60)

  -- Bref flash d'une silhouette prismatique enchainee
  GAME:FadeIn(3)
  local center = GAME:GetCameraCenter()
  local flash = RogueEssence.Content.FlashEmitter()
  flash.FadeInTime = 2; flash.HoldTime = 3; flash.FadeOutTime = 15
  flash.StartColor = Color(80, 20, 120, 0)
  flash.Layer = DrawLayer.Top
  flash.Anim = RogueEssence.Content.BGAnimData("White", 0)
  GROUND:PlayVFX(flash, center.X, center.Y)
  GAME:WaitFrames(10)
  GAME:FadeOut(false, 3)
  GAME:WaitFrames(30)

  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR7_006']))
  -- "Ce qui est enferme...[pause=30] DOIT le rester."

  GAME:WaitFrames(90)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(120)

  -- Reveil en sursaut
  GROUND:CharSetAnim(hero, "Idle", true)
  GROUND:CharSetAnim(partner, "Idle", true)
  GAME:FadeIn(20)

  GAME:WaitFrames(30)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Surprised")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR7_007']))
  -- "Hein ?![pause=10] Qu'est-ce que...[pause=15] Tu as fait un cauchemar ?"

  GAME:WaitFrames(20)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['GHR7_008']), "Worried")
  -- "(Je... je ne sais pas. Une voix. Et une ombre. C'etait... different.)"

  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR7_009']))
  -- "Encore la Voix ?[pause=15] Non...[pause=20] Celle-ci etait differente, c'est ca ?"

  GAME:WaitFrames(20)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['GHR7_010']), "Sad")
  -- "(...Oui. Plus sombre. Plus... ancienne.)"

  GAME:WaitFrames(40)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR7_011']))
  -- "On en parlera demain.[pause=25] Essaie de te rendormir."

  GAME:WaitFrames(60)
  GROUND:CharSetAnim(partner, "EventSleep", true)
  GAME:WaitFrames(40)
  GROUND:CharSetAnim(hero, "EventSleep", true)
  GAME:WaitFrames(120)

  SOUND:FadeOutBGM(80)
  GAME:FadeOut(false, 120)

  -- Second fragment de la meme nuit : apres la Voix, une vision d'un monde
  -- ou le temps s'est arrete. Le heros ne fait pas le lien. Pas encore.
  HeroVisions.TryTrigger('rouage', partner)
  GAME:WaitFrames(30)

  SV.Chapter7.HadFirstDream = true
  --Delai avant l'ouverture du chapitre 8, comme aux paliers precedents.
  --Sans cette ligne, DaysToReach garderait la valeur du palier ch6->ch7 (deja
  --depassee) et le chapitre 8 s'ouvrirait des la nuit suivante.
  SV.ChapterProgression.DaysToReach = SV.ChapterProgression.DaysPassed + 2
  SV.TemporaryFlags.MorningAddress = true
  SV.TemporaryFlags.MorningWakeup = true
  GeneralFunctions.EndOfDay()
  GAME:CutsceneMode(false)
  GAME:EnterGroundMap('guild_heros_room', 'Main_Entrance_Marker')
end

return guild_heros_room_ch_7
