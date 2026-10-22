require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.ground.guild_heros_room.guild_heros_room_helper'

guild_heros_room_ch_1 = {}





--This is for the hero's bed. Event is to go to bed at the end of the chapter to trigger final cutscene.
function guild_heros_room_ch_1.Save_Bed_Dialogue(obj, activator)
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Normal")
	if SV.Chapter1.MetSnubbull and SV.Chapter1.MetZigzagoon and SV.Chapter1.MetCranidosMareep and SV.Chapter1.MetBreloomGirafarig and SV.Chapter1.MetAudino then
		GeneralFunctions.StartPartnerConversation("Il se fait tard...[pause=0]Et je pense que nous avons assez regardé autour de la guilde...")
		UI:ChoiceMenuYesNo(STRINGS:Format(STRINGS.MapStrings['GHR1_001']))
		UI:WaitForChoice()
		local result = UI:ChoiceResult()
		if result then
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR1_002']))
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR1_003']))
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR1_004'], hero:GetDisplayName()))
			SOUND:FadeOutBGM(120)
			GAME:FadeOut(false, 60)
			GAME:WaitFrames(120)
			GeneralFunctions.EndConversation(partner)
			guild_heros_room_ch_1.Bedtalk()
		else
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR1_005']))
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR1_006']))
			GAME:WaitFrames(20)
			GeneralFunctions.PromptSaveAndQuit()
			GeneralFunctions.EndConversation(partner)
		end
	else
		GeneralFunctions.StartPartnerConversation("Il n'est pas encore si tard...[pause=0]Regardons autour de la guilde et essayons de rencontrer tous les autres membres de la guilde !")
		GAME:WaitFrames(20)
		GeneralFunctions.PromptSaveAndQuit()
		GeneralFunctions.EndConversation(partner)
	end
end


function guild_heros_room_ch_1.Bedtalk()

	--Set nighttime, put duo in beds asleep

	GROUND:Hide("Save_Point")
	guild_heros_room_helper.Bedtime()--set nighttime scene, put duo in their beds
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')

	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	GeneralFunctions.CenterCamera({hero, partner})
	GROUND:CharSetAnim(hero, 'Laying', true)
	GROUND:CharSetAnim(partner, 'Laying', true)
	GAME:FadeIn(40)

	SOUND:PlayBGM("Goodnight.ogg", true)
	GAME:WaitFrames(60)
	UI:SetSpeaker(partner:GetDisplayName(), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR1_007']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR1_008'], hero:GetDisplayName()))
	GAME:WaitFrames(20)

	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR1_009']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR1_010']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR1_011']))
	GAME:WaitFrames(20)

	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR1_012']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR1_013']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR1_014']))
	GAME:WaitFrames(20)

	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR1_015']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR1_016']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR1_017']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR1_018'], hero:GetDisplayName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR1_019']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR1_020'], hero:GetDisplayName()))
	--UI:WaitShowDialogue("Once we're great adventurers,[pause=10] I'm sure we'll be able to solve the mystery of your amnesia.[pause=0] I promise.")
	GAME:WaitFrames(20)

	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR1_021']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR1_022']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR1_023']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR1_024'], hero:GetDisplayName()))
	GAME:WaitFrames(20)

	GROUND:CharSetAnim(partner, "EventSleep", true)
	SOUND:FadeOutBGM(60)
	GAME:WaitFrames(60)

	UI:SetSpeaker('', false, "", -1, "", RogueEssence.Data.Gender.Unknown)
	--man im excited but why do i feel so at ease and maybe a bit of deja vu? why am i a picklemanster?
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR1_025']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR1_026']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR1_027']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR1_028']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR1_029'], partner:GetDisplayName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR1_030']))
	GAME:WaitFrames(20)

	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR1_031']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR1_032']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR1_033']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR1_034']))
	GAME:WaitFrames(60)

	--not thematically appropriate on second thought. Hero hasn't necessarily played explorers. Strange feelings felt elsewhere that tip off to "playing explorers" can instead be interpreted as the hero is progressing along the path he wants to / should progress on and is progressing the plot as he should.
	--UI:WaitShowDialogue("(Even more troubling...)")
	--UI:WaitShowDialogue("(Why do I have this weird feeling of déjà vu?)")
	--GAME:WaitFrames(60)

	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR1_035']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR1_036']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR1_037']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR1_038'], partner:GetDisplayName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR1_039'], partner:GetDisplayName()))
	GAME:WaitFrames(20)

	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR1_061']))--doesn't really care if he finds out or not since hero can just enjoy life as a pokemon regardless of solving the mystery
	GAME:WaitFrames(40)
	GROUND:CharSetAnim(hero, "EventSleep", true)
	GAME:WaitFrames(80)

	-- LE TOUT PREMIER RÊVE DE GARDEVOIR (Chapitre 1) — Mystérieux, court, pose le début de l'intrigue.
	SOUND:PlayBGM('Star Cave.ogg', true)
	UI:WaitShowBG("Genesis_Void", 40, 20)
	GAME:WaitFrames(60)

	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", 0) -- Voix lointaine sans portrait
	UI:WaitShowDialogue("...Humain...")
	GAME:WaitFrames(15)
	UI:WaitShowDialogue("...S'il te plaît... entends mon appel...")
	GAME:WaitFrames(30)

	UI:WaitHideBG(20)
	SOUND:FadeOutBGM(40)
	GAME:WaitFrames(60)

	GAME:UnlockDungeon("illuminant_riverbed")--unlock riverbed for when it's ready in chapter 2.
	GAME:UnlockDungeon("illuminant_riverbed")--unlock riverbed for when it's ready in chapter 2.
	--Vague 1 multi-sources : secondaires ch1-2 disponibles des l'entree a la guilde
	GAME:UnlockDungeon("petit_tunnel")
	GAME:UnlockDungeon("bosquet_voile")
	GAME:UnlockDungeon("grotte_mystere")
	GAME:UnlockDungeon("vallee_fertile")
	--Vague 2 multi-sources : secondaire ch2
	GAME:UnlockDungeon("grotte_repos")
	GAME:FadeOut(false, 120)
	SV.ChapterProgression.Chapter = 2
	GeneralFunctions.EndOfDay()--reset daily flags and increment day counter by 1

	GAME:WaitFrames(120)
	UI:ResetSpeaker()
	--UI:WaitShowDialogue("That's the end of Chapter 1![pause=0] Thanks for playing!")
	--UI:WaitShowDialogue("I'm starting work on Chapter 2 next.[pause=0] But give me your thoughts on Chapter 1!")
	--UI:WaitShowDialogue("Hopefully it won't take as long to do the next chapters.[pause=0] I'm hoping that your guys help will speed things along.")
	--UI:WaitShowDialogue("Let me know if you managed to find any bugs as well.")
	--UI:WaitShowDialogue("In the meantime, I've set the flags so that you can freeroam in this debug-esque state.")
	--UI:WaitShowDialogue("I don't think any cutscenes should be triggering now, but don't expect anything to be looking too normal in this state.")
	--UI:WaitShowDialogue("Do let me know if any story cutscenes trigger.[pause=0] Because if any do I messed up.")
	--UI:WaitShowDialogue("And anything you see is subject to change, just so you know.")
	--UI:WaitShowDialogue("I already have some plans to modify some things around the town...")
	--UI:WaitShowDialogue("Also be sure to check the discord for updates and notes on known bugs/issues, chapter 2 progress, etc.")
	--UI:WaitShowDialogue("Alright.[pause=0] I'm enabling free roam now...[pause=0] Thanks again for playing!")

	--GAME:CutsceneMode(false)
	GROUND:RemoveMapStatus("darkness")--Remove map status before saving the game, as saving with a map status saves it for the next load.
	GeneralFunctions.PromptChapterSaveAndQuit("guild_heros_room", "Main_Entrance_Marker", 2)
--	GAME:WaitFrames(20)
	--GAME:EnterGroundMap("guild_heros_room", "Main_Entrance_Marker")
	--[[GAME:CutsceneMode(false)
	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	GROUND:RemoveMapStatus("darkness")
	SOUND:PlayBGM("Wigglytuff's Guild.ogg", false)
	GROUND:
	GAME:FadeIn(40)
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)]]--

end



function guild_heros_room_ch_1.RoomIntro()
--TASK:BranchCoroutine(guild_heros_room_ch_1.RoomIntro)
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	UI:ResetSpeaker()
	SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true)
	GROUND:Hide('Bedroom_Exit')--disable map transition object
	GROUND:Hide("Save_Point")--disable bed saving

	local noctowl =
		CharacterEssentials.MakeCharactersFromList({
			{"Noctowl", 0, 204, Direction.Right},
		})

	GAME:MoveCamera(192, 176, 1, false)
	GROUND:TeleportTo(partner, -32, 192, Direction.Right)
	GROUND:TeleportTo(hero, -32, 216, Direction.Right)

	GAME:FadeIn(40)

	local coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(8)
												  GROUND:MoveToPosition(partner, 172, 192, false, 1)
												  GAME:WaitFrames(10)
												  GeneralFunctions.EmoteAndPause(partner, "Exclaim", true)
												  end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(16)
												  GROUND:MoveToPosition(hero, 172, 216, false, 1)
												  GAME:WaitFrames(10)
												  GeneralFunctions.EmoteAndPause(hero, "Exclaim", false)
												  end)
	local coro3 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(noctowl, 200, 204, false, 1)
											      GROUND:CharAnimateTurnTo(noctowl, Direction.Left, 4)
												  end)

	TASK:JoinCoroutines({coro1, coro2, coro3})



	UI:SetSpeaker(noctowl)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR1_040']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR1_041']))
	GAME:WaitFrames(20)


	--thanks phileas!
	GeneralFunctions.Hop(partner, "Idle")
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Joyous")
	GROUND:CharSetEmote(partner, "glowing", 0)
	GROUND:CharSetAnim(partner, "Idle", true)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR1_042'], noctowl:GetDisplayName()))

	GAME:WaitFrames(20)
	GROUND:CharSetEmote(partner, "", 0)
	GROUND:CharSetAnim(partner, "None", true)
	local bed1 = MRKR("Hero_Bed")
	local bed2 = MRKR("Partner_Bed")

	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(partner, bed1.Position.X, bed1.Position.Y, false, 1)
											GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(hero, partner, 4) end)
	coro3 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(noctowl, partner, 4)
											GROUND:CharAnimateTurnTo(noctowl, Direction.Up, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})

	--this bed is comfy
	GeneralFunctions.Hop(partner)
	GeneralFunctions.Hop(partner)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR1_043'], hero:GetDisplayName()))

	GAME:WaitFrames(20)

	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(hero, bed1.Position.X, bed1.Position.Y, false, 1)
											GROUND:CharAnimateTurnTo(hero, Direction.Down, 4) end)
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(partner, bed2.Position.X, bed2.Position.Y, false, 1)
											GROUND:CharAnimateTurnTo(partner, Direction.Left, 4) end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(30)
	GeneralFunctions.HeroDialogue(hero, "(Pour un tas de pailles,[pause=10] ce lit est en fait assez confortable !)", "Normal")


	--is this what's it's like to want to wag your tail?
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(J'ai peut-être perdu la mémoire et me suis transformé en Pokémon,[pause=10]mais...)", "Normal")
	GeneralFunctions.HeroDialogue(hero, "(Après avoir rencontré " .. partner:GetDisplayName() .. " et rejoint cette guilde...)", "Normal")
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(...Je ne peux m'empêcher de me sentir excité.)", "Inspired")
	GeneralFunctions.HeroDialogue(hero, "(Je me suis transformé en Pokémon...[pause=0]Et pourtant je suis content !)", "Inspired")
	GeneralFunctions.HeroDialogue(hero, "(Je ne peux pas vraiment le décrire,[pause=10]mais je me sens comme chez moi !)", "Inspired")

	GAME:WaitFrames(20)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Happy")
	GROUND:CharSetEmote(partner, "glowing", 0)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR1_044']))
	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(hero, "glowing", 0)

	GAME:WaitFrames(60)
	UI:SetSpeaker(noctowl)
	GeneralFunctions.SetEmotion("Normal")
	--GROUND:CharSetEmote(noctowl, "glowing", 0)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR1_045']))
	--GROUND:CharSetEmote(noctowl, "", 0)


	--why not go meet your compatriots?
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(partner, "", 0)
	GROUND:CharSetEmote(hero, "", 0)
	GROUND:CharTurnToCharAnimated(partner, noctowl, 4)
	GROUND:CharTurnToCharAnimated(hero, noctowl, 4)

	GAME:WaitFrames(12)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR1_046']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR1_047']))
	GAME:WaitFrames(40)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR1_048']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR1_049']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR1_050']))
	GAME:WaitFrames(20)

	--we should go meet our guildmembers
	GeneralFunctions.Hop(partner)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR1_051']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR1_052']))
	GAME:WaitFrames(20)

	GROUND:CharAnimateTurnTo(noctowl, Direction.Left, 4)
	coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(noctowl, 0, 204, false, 1) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(hero, noctowl, 4, Direction.DownLeft) end)
	coro3 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(partner, noctowl, 4, Direction.DownLeft) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
	GAME:GetCurrentGround():RemoveTempChar(noctowl)

	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	GAME:WaitFrames(12)

	--wow, can you believe how amazing this all is? welp, let's go explore!
	--we can hit the hay when we've felt we looked around enough
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Inspired")
	GROUND:CharSetAnim(partner, "Idle", true)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR1_053'], hero:GetDisplayName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR1_054']))

	GAME:WaitFrames(20)

	GeneralFunctions.HeroDialogue(hero, "(Être ici dans cette guilde est la chose la moins surréaliste qui me soit arrivée aujourd'hui...)", "Worried")
	GAME:WaitFrames(20)
	GROUND:CharSetAnim(hero, "Idle", true)
	GeneralFunctions.HeroDialogue(hero, "(Toujours...[pause=0]C'est fantastique que nous ayons réussi à rejoindre la guilde.)", "Happy")
	GeneralFunctions.HeroDialogue(hero, "(J'en suis plutôt excité ![pause=0]Je pense que je vais m'amuser beaucoup à l'aventure avec " .. partner:GetDisplayName() .. " !)", "Happy")


	--let's go meet our guildmates!!
	GAME:WaitFrames(10)
	GROUND:CharEndAnim(hero)
	GROUND:CharEndAnim(partner)
	GeneralFunctions.DoubleHop(partner)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR1_055']))
	GAME:WaitFrames(20)
	SOUND:FadeOutBGM()

	GeneralFunctions.PanCamera(192, 176)
	GAME:WaitFrames(40)

	SOUND:PlayFanfare("Fanfare/Note")

	--adventurer's tip (how to save the game)
	UI:ResetSpeaker(false)
	UI:SetCenter(true)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR1_056']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR1_057']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR1_058']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR1_059'], STRINGS:LocalKeyString(9)))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR1_060']))
	UI:SetCenter(false)
	GAME:WaitFrames(20)

	SOUND:PlayBGM("Wigglytuff's Guild.ogg", true)
	GROUND:Unhide("Bedroom_Exit")
	GROUND:Unhide("Save_Point")
	SV.Chapter1.TeamJoinedGuild = true
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)

	GAME:CutsceneMode(false)


end



