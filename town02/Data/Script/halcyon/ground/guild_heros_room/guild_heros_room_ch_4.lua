require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.ground.guild_heros_room.guild_heros_room_helper'

guild_heros_room_ch_4 = {}


function guild_heros_room_ch_4.ShowTitleCard()
	GAME:FadeOut(false, 1)
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(CH('Teammate1'))
	UI:ResetSpeaker()
	SOUND:StopBGM()
	GAME:WaitFrames(60)
	local coro1 = TASK:BranchCoroutine(function() UI:WaitShowTitle("Chapitre 4\n\nUne Vraie Aventure\n", 20)
												  GAME:WaitFrames(180)
												  UI:WaitHideTitle(20) end)
	local coro2 = TASK:BranchCoroutine(function() UI:WaitShowBG("Chapter_4", 180, 20)
												  GAME:WaitFrames(180)
												  UI:WaitHideBG(20) end)
	TASK:JoinCoroutines({coro1, coro2})

	GAME:WaitFrames(120)
	SV.Chapter4.ShowedTitleCard = true
	guild_heros_room_helper.Morning(true)
end

function guild_heros_room_ch_4.PostGroveBedtalk()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	GAME:CutsceneMode(true)
	guild_heros_room_helper.Bedtime(false)
	UI:ResetSpeaker()
	GAME:FadeIn(40)

	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("relic_forest")

	--partner is excited about the day.
	--getting to explore a new place, getting the apricorn, actually being able to keep it.
	--even met new teammates that helped get the treasure
	--so happy with how things have been turning out, hopes the player is enjoying themselves too
	--excitement for the expedition on top of all this
	---thanks the player for forming the team.
	--hero is happy to be apart of the team as well. happy partner isnt thinking about thwait Really enjoying life as a pokemon
	--partner is reminded... has hero remembered anything else that's important?
	--no. nothing new remembered or realized.
	--dang, unfortunate... any more meaning to the strange feelings?
	--hero thinks it over, hasn't really figured anything else out yet.
	--come to think of it... i felt a bit strange hearing the expedition announcement.
	--actually, i felt strange joining the guild and meeting the partner too!
	--it's a different kind of strangeness, but there's no other way to put it really than "strange".
	--What could it all mean. Tells the partner
	--wow, really! That's weird...
	--Is there some sort of connection? Or do you just feel that way because you're a Pokemon now, or because you just felt happy?
	--Hard to say. Could just be excitement after all. After this expedition, we should see if we can do anything to learn more about your past.
	--it's getting late... Good night, player.

--[[Wow today was great im having so much fun and im so happy about things rn i hope u are too
Yes me human me enjoy pokemon world this is awesome. also im happy that ur happy
partner really doesnt need to thank the player for forming the team i think its unneeded on further thought and copies the original too hard
partner's joy fades a bit and they change topics to players amnesia
has the player remembered anything else, anything else about the strange feelings?
player notes he got caught up in the fun it slipped his mind. Thinks about it a bit, but doesn't really have anything new.
Thinks about when he feels strange besides the times he told the partner, they muse a bit on it, then resolve to look into it once the expedition is through
]]--


	SOUND:PlayBGM('Goodnight.ogg', true)
	GAME:WaitFrames(40)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR4_001'], hero:GetDisplayName()))
	GeneralFunctions.SetEmotion("Inspired")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR4_002']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR4_003']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR4_004']))

	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(Les choses ont été passionnantes ces derniers temps.[pause=0]Il semble que l'enthousiasme ait aidé " .. partner:GetDisplayName() .. " à oublier " .. GeneralFunctions.GetPronoun(partner, "their") .. " et " .. CharacterEssentials.GetCharacterName("Sandile") .. ",[pause=10]également.)", "Normal")
	GeneralFunctions.HeroDialogue(hero, "(Cela a été très amusant de partir à l'aventure avec " .. partner:GetDisplayName() .. " !)", "Normal")
	GeneralFunctions.HeroDialogue(hero, "(La vie dans la guilde a été géniale jusqu'à présent...[pause=0]J'aimerais continuer à vivre des aventures avec " .. partner:GetDisplayName() .. " !)", "Happy")

	GAME:WaitFrames(20)
	GeneralFunctions.DoAnimation(hero, "Nod")
	GAME:WaitFrames(10)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR4_005'], hero:GetDisplayName()))

	GROUND:CharSetEmote(partner, "glowing", 0)
	GAME:WaitFrames(40)
	GROUND:CharSetEmote(hero, "glowing", 0)
	GAME:WaitFrames(60)
	GROUND:CharSetEmote(partner, "", 0)
	GROUND:CharSetEmote(hero, "", 0)
	GAME:WaitFrames(40)
	GROUND:EntTurn(partner, Direction.UpLeft)
	GAME:WaitFrames(90)
	GROUND:CharTurnToChar(partner, hero)
	SOUND:FadeOutBGM(120)
	--SOUND:PlayBattleSE('EVT_Emote_Exclaim_Idea')
	--GeneralFunctions.EmoteAndPause(
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR4_006'], hero:GetDisplayName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR4_007']))
	GeneralFunctions.SetEmotion("Sad")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR4_008']))
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR4_009']), {function() return GeneralFunctions.Hop(partner) end})

	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR4_010']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR4_011'], hero:GetDisplayName(), zone:GetColoredName()))
	GAME:WaitFrames(20)

	GeneralFunctions.HeroDialogue(hero, "(Hmm...[pause=0], je n'y ai pas réfléchi,[pause=10]en fait.)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(J'étais tellement occupé à travailler en guilde avec " .. partner:GetDisplayName() .. " que cela m'est complètement sorti de l'esprit !)", "Worried")
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(Mais,[pause=10]maintenant que j'arrête et y réfléchis...[pause=0], je ne me souviens toujours de rien.)", "Sad")
	GAME:WaitFrames(20)
	GeneralFunctions.ShakeHead(hero)
	GAME:WaitFrames(10)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Sad")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR4_012']))
	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR4_013']))

	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(Je ne me suis pas senti malade comme à Luminous Spring depuis que nous y étions.[pause=0]Je ne sais toujours pas pourquoi je me suis senti ainsi.)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(Il y avait aussi ce que j'avais ressenti en touchant l'obélisque dans " .. zone:GetColoredName() .. ",[pause=10]mais je n'en sais rien non plus...)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(Hmm...)", "Worried")

	GAME:WaitFrames(60)
	SOUND:PlayBattleSE('EVT_Emote_Exclaim_Idea')
	GeneralFunctions.EmoteAndPause(hero, "Exclaim", false)

	SOUND:PlayBGM('I Saw Something Again....ogg', false)
	GeneralFunctions.HeroDialogue(hero, "(Attendez ![pause=0]Ce ne sont pas les seules fois où j'ai ressenti cela ![pause=0]J'ai eu une sensation étrange à plusieurs autres reprises !)", "Surprised")
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(Je me suis senti étrange quand je suis arrivé dans la guilde pour la première fois,[pause=10]quand j'ai entendu parler de l'expédition plus tôt,[pause=10]et...)", "Normal")
	GAME:WaitFrames(40)
	GeneralFunctions.HeroDialogue(hero, "(...Et quand j'ai rencontré " .. partner:GetDisplayName() .. ".)", "Worried")
	GAME:WaitFrames(20)

	GeneralFunctions.HeroDialogue(hero, "(La tension que j'ai ressentie à cette époque n'était pas aussi forte qu'avec l'obélisque et le Printemps lumineux,[pause=10] mais la sensation était similaire.)", "Normal")

	GAME:WaitFrames(20)
	GeneralFunctions.HeroSpeak(hero, 60)
	GAME:WaitFrames(20)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR4_014']))
	GAME:WaitFrames(20)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR4_015']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR4_016']))
	GAME:WaitFrames(20)

	GeneralFunctions.SetEmotion("Sad")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR4_017']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR4_018']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR4_019']))
	GAME:WaitFrames(20)

	GeneralFunctions.HeroDialogue(hero, "(.........)", "Sad")
	GAME:WaitFrames(20)

	SOUND:FadeOutBGM(120)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR4_020']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR4_021']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR4_022']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR4_023']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR4_024'], hero:GetDisplayName()))
	GAME:WaitFrames(20)

	GeneralFunctions.HeroDialogue(hero, "(C'est frustrant, nous ne pourrons pas faire de progrès dans ce domaine bientôt...)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(Mais à l'approche de l'expédition,[pause=10] il est logique de se concentrer là-dessus pour le moment.)", "Normal")
	GAME:WaitFrames(20)
	GeneralFunctions.DoAnimation(hero, "Nod")
	GAME:WaitFrames(40)

	SOUND:PlayBGM('Goodnight.ogg', true)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR4_025']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR4_026']))

	GAME:WaitFrames(40)
	GROUND:CharSetAnim(partner, "Laying", true)
	GAME:WaitFrames(60)
	GROUND:CharSetAnim(hero, "Laying", true)
	GAME:WaitFrames(40)
	UI:SetSpeaker(partner:GetDisplayName(), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR4_027'], hero:GetDisplayName()))
	GAME:WaitFrames(40)
	GROUND:CharSetAnim(partner, "EventSleep", true)
	GAME:WaitFrames(40)
	GROUND:CharSetAnim(hero, "EventSleep", true)
	GAME:WaitFrames(180)
	SOUND:FadeOutBGM(120)
	GAME:FadeOut(false, 120)

	SV.Chapter4.FinishedBedtimeCutscene = true
	SV.ChapterProgression.CurrentStoryDungeon = ''--Clear the current story dungeon flag
	SV.TemporaryFlags.MorningAddress = true
	SV.TemporaryFlags.MorningWakeup = true
	GeneralFunctions.EndOfDay()
	--Need to pass 4 (add 3 because of how when it checks the days passed parameter) days before chapter 5 starts
	SV.ChapterProgression.DaysToReach = SV.ChapterProgression.DaysPassed + 3
	GAME:CutsceneMode(false)
	GAME:EnterGroundMap('guild_heros_room', 'Main_Entrance_Marker')



end
