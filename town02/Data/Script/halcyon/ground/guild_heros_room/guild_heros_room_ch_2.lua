require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.ground.guild_heros_room.guild_heros_room_helper'

guild_heros_room_ch_2 = {}




function guild_heros_room_ch_2.FirstMorning()
	GAME:FadeOut(false, 1)
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	UI:ResetSpeaker()
	SOUND:StopBGM()
	GROUND:CharSetAnim(hero, 'EventSleep', true)
	GROUND:CharSetAnim(partner, 'EventSleep', true)
	GROUND:Hide('Bedroom_Exit')--disable map transition object
	GROUND:Hide("Save_Point")--disable bed saving
	local hero_bed = MRKR('Hero_Bed')
	local partner_bed = MRKR('Partner_Bed')
	GROUND:TeleportTo(CH('PLAYER'), hero_bed.Position.X, hero_bed.Position.Y, Direction.Left)
	GROUND:TeleportTo(CH('Teammate1'), partner_bed.Position.X, partner_bed.Position.Y, Direction.Right)
	GeneralFunctions.CenterCamera({hero, partner})
	SV.TemporaryFlags.JustWokeUp = true

	local audino =
		CharacterEssentials.MakeCharactersFromList({
			{"Audino", 120, 204, Direction.UpRight},
		})

	GAME:WaitFrames(80)
	local coro1 = TASK:BranchCoroutine(function() UI:WaitShowTitle("Chapitre 2\n\nLa Première Mission\n", 20)
												  GAME:WaitFrames(180)
												  UI:WaitHideTitle(20) end)
	local coro2 = TASK:BranchCoroutine(function() UI:WaitShowBG("Chapter_2", 180, 20)
												  GAME:WaitFrames(180)
												  UI:WaitHideBG(20) end)
	TASK:JoinCoroutines({coro1, coro2})

	GAME:WaitFrames(120)

	UI:SetAutoFinish(true)
	UI:WaitShowVoiceOver("Le lendemain matin...", -1)
	UI:SetAutoFinish(false)

	GAME:WaitFrames(60)
	SOUND:PlayBattleSE("DUN_Heal_Bell")
	GAME:WaitFrames(100)
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR2_001']))
	GAME:FadeIn(40)

	--sleepyheads
	GAME:WaitFrames(20)
	UI:SetSpeaker('', true, "", -1, "", RogueEssence.Data.Gender.Unknown)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR2_002']))
	GAME:WaitFrames(40)

	UI:SetSpeaker(audino)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR2_003']))
	GAME:WaitFrames(20)

	GROUND:CharAnimateTurnTo(audino, Direction.Down, 4)
	GAME:WaitFrames(10)
	SOUND:PlayBattleSE("DUN_Heal_Bell")
	GROUND:CharSetAction(audino, RogueEssence.Ground.PoseGroundAction(audino.Position, audino.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GAME:WaitFrames(100)
	GROUND:CharSetAnim(audino, 'None', true)
	GROUND:CharAnimateTurnTo(audino, Direction.UpRight, 4)

	GAME:WaitFrames(20)
	UI:SetSpeaker(partner:GetDisplayName(), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR2_004']))
	GAME:WaitFrames(20)
	GROUND:CharSetAnim(hero, "Laying", true)
	GROUND:CharSetAnim(partner, "Laying", true)

	coro1 = TASK:BranchCoroutine(function () GAME:WaitFrames(10)
											 GeneralFunctions.Shake(hero)
											 GAME:WaitFrames(20)
											 GeneralFunctions.DoAnimation(hero, 'Wake')
											 GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)
											 GAME:WaitFrames(20)
											 GeneralFunctions.LookAround(hero, 2, 4, false, false, false, Direction.DownLeft) end)
	coro2 = TASK:BranchCoroutine(function () GeneralFunctions.Shake(partner)
											 GAME:WaitFrames(20)
											 GeneralFunctions.DoAnimation(partner, 'Wake')
											 GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
											 GAME:WaitFrames(20)
											 GeneralFunctions.LookAround(partner, 2, 4, false, false, false, Direction.DownLeft) end)
	TASK:JoinCoroutines({coro1, coro2})

	GAME:WaitFrames(10)
	GeneralFunctions.EmoteAndPause(partner, "Notice", true)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR2_005'], audino:GetDisplayName()))
	GAME:WaitFrames(20)

	SOUND:PlayBGM("Wigglytuff's Guild.ogg", true)
	UI:SetSpeaker(audino)
	GeneralFunctions.SetEmotion("Happy")
	local move = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Skill]:Get("heal_bell")--healbell

	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR2_006'], move:GetColoredName()))

	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR2_007']))

	GAME:WaitFrames(10)
	UI:SetSpeaker(partner)
	GeneralFunctions.EmoteAndPause(partner, "Question", true)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR2_008']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(audino)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR2_009']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR2_010']))

	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(audino, Direction.Left, 4)
	GAME:WaitFrames(60)
	GROUND:CharAnimateTurnTo(audino, Direction.UpRight, 4)

	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR2_011']))
	GAME:WaitFrames(20)

	GROUND:CharAnimateTurnTo(audino, Direction.Left, 4)
	GROUND:MoveToPosition(audino, 0, 204, false, 2)
	GAME:GetCurrentGround():RemoveTempChar(audino)
	GAME:WaitFrames(20)

	--good morning, hero!
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	GAME:WaitFrames(12)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR2_012'], hero:GetDisplayName()))
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR2_013']))

	GAME:WaitFrames(20)
	GeneralFunctions.PanCamera(208, 156)
	GAME:WaitFrames(20)
	GROUND:CharEndAnim(hero)
	GROUND:CharEndAnim(partner)
	GROUND:Unhide("Bedroom_Exit")
	GROUND:Unhide("Save_Point")
	SV.Chapter2.FinishedFirstWakeup = true
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)

	GAME:CutsceneMode(false)


end

function guild_heros_room_ch_2.PostRiverBedtalk()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	GAME:CutsceneMode(true)
	guild_heros_room_helper.Bedtime(false)
	UI:ResetSpeaker()
	GAME:FadeIn(40)

	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("relic_forest")

	SOUND:PlayBGM('Goodnight.ogg', true)
	GAME:WaitFrames(40)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR2_014'], hero:GetDisplayName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR2_015']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR2_016'], CharacterEssentials.GetCharacterName("Camerupt")))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR2_017']))
	GAME:WaitFrames(20)

	GeneralFunctions.HeroDialogue(hero, "(Je suis content que nous ayons pu les aider aussi.[pause=0]Je me sens comme une sorte de héros !)", "Happy")
	GeneralFunctions.HeroDialogue(hero, "(Aider les Pokémon dans le besoin est vraiment gratifiant.[pause=0]J'espère que " .. partner:GetDisplayName() .. " et moi pourrons continuer à le faire.)", "Happy")
	GAME:WaitFrames(20)

	UI:SetSpeaker(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR2_018']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR2_019'], CharacterEssentials.GetCharacterName("Noctowl")))
	GAME:WaitFrames(20)

	GeneralFunctions.HeroDialogue(hero, "(Il m'a dit de ne pas m'inquiéter,[pause=10]mais je ne peux pas m'empêcher de penser à cette étrange sensation que j'ai ressentie au printemps.)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(C'était écoeurant,[pause=10]mais tellement similaire à ce que je ressentais dans " .. zone:GetColoredName() .. "...[pause=0]Ces deux endroits pourraient-ils être connectés ?)", "Worried")
	GAME:WaitFrames(40)

	GeneralFunctions.HeroSpeak(hero, 60)
	GAME:WaitFrames(20)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR2_020'], zone:GetColoredName()))
	GAME:WaitFrames(20)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR2_021']))

	GAME:WaitFrames(20)
	GeneralFunctions.HeroSpeak(hero, 60)

	GAME:WaitFrames(20)
	GeneralFunctions.Recoil(partner)
	GeneralFunctions.SetEmotion("Surprised")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR2_022'], zone:GetColoredName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR2_023']))

	GAME:WaitFrames(20)
	GeneralFunctions.EmoteAndPause(partner, "Sweating", true)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR2_024']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR2_025']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR2_026'], zone:GetColoredName()))

	--note: there is signficance in the feelings, as both the tablet and the spring are connected to the tree of life, to which the hero has significance as they were "summoned" here to save it
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(C'est vrai...[pause=0]Je pourrais chercher un sens là où il n'y en a pas.)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(Il est même possible que ces sentiments soient simplement l'excitation des situations dans lesquelles j'ai été.)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(C'est difficile à dire,[pause=10]étant donné toute ma situation...)", "Worried")

	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR2_027']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR2_028'], CharacterEssentials.GetCharacterName("Noctowl")))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR2_029']))

	--player is more interested in living pokemon life than figuring shit out? potentially? just an idea
	GAME:WaitFrames(20)
	GeneralFunctions.DoAnimation(hero, 'Nod')

	GAME:WaitFrames(40)
	GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
	GeneralFunctions.DoAnimation(partner, "DeepBreath")
	GAME:WaitFrames(10)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR2_030']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR2_031']))

	GAME:WaitFrames(20)
	GROUND:CharSetAnim(partner, "Laying", true)


	GAME:WaitFrames(60)

	GROUND:CharSetAnim(hero, "Laying", true)

	GAME:WaitFrames(40)
	UI:SetSpeaker(partner:GetDisplayName(), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR2_032'], hero:GetDisplayName()))
	GAME:WaitFrames(40)
	GROUND:CharSetAnim(partner, "EventSleep", true)
	GAME:WaitFrames(40)
	GROUND:CharSetAnim(hero, "EventSleep", true)
	GAME:WaitFrames(80)

	-- LE DEUXIÈME RÊVE DE GARDEVOIR (Chapitre 2) — Un peu plus long, plus précis.
	SOUND:PlayBGM('Star Cave.ogg', true)
	UI:WaitShowBG("Genesis_Void", 40, 20)
	GAME:WaitFrames(60)

	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", 0) -- Voix mystérieuse sans portrait
	UI:WaitShowDialogue("...Tu as réussi à franchir la rivière...")
	GAME:WaitFrames(15)
	UI:WaitShowDialogue("...Ton cœur s'éveille à ce monde...")
	GAME:WaitFrames(15)
	UI:WaitShowDialogue("...S'il te plaît... le temps presse... protège l'équilibre...")
	GAME:WaitFrames(30)

	UI:WaitHideBG(20)
	SOUND:FadeOutBGM(40)
	GAME:WaitFrames(60)

	GAME:WaitFrames(180)
	SOUND:FadeOutBGM(120)
	GAME:FadeOut(false, 120)
	GAME:CutsceneMode(false)
	GAME:WaitFrames(60)
	GAME:EnterGroundMap("guild_guildmasters_room", "Main_Entrance_Marker")







end

function guild_heros_room_ch_2.FirstNightBedtalk()
	GAME:FadeOut(false, 1)
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	GAME:CutsceneMode(true)
	guild_heros_room_helper.Bedtime(false)
	UI:ResetSpeaker()
	GROUND:CharSetAnim(hero, 'Laying', true)
	GROUND:CharSetAnim(partner, 'Laying', true)

	--wait a bit after the transition from dinner scene before starting this one
	GAME:WaitFrames(60)
	--characters commenting on the dinner they just had while the screen is still faded out
	UI:SetSpeaker(CharacterEssentials.GetCharacterName('Tropius'), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR2_033'], CharacterEssentials.GetCharacterName('Snubbull')))
	GAME:WaitFrames(20)

	UI:SetSpeaker(CharacterEssentials.GetCharacterName('Breloom'), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR2_034']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(CharacterEssentials.GetCharacterName('Mareep'), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR2_035']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(CharacterEssentials.GetCharacterName('Zigzagoon'), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR2_036']))
	GAME:WaitFrames(90)

	GAME:FadeIn(60)
	SOUND:PlayBGM("Goodnight.ogg", true)
	GAME:WaitFrames(20)
	--GAME:WaitFrames(20)

	UI:SetSpeaker(partner:GetDisplayName(), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR2_037'], hero:GetDisplayName()))
	GAME:WaitFrames(20)

	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR2_038']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR2_039'], CharacterEssentials.GetCharacterName('Ledian')))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR2_040']))

	GAME:WaitFrames(40)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR2_041']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR2_042']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GHR2_043'], hero:GetDisplayName()))

	GAME:WaitFrames(20)
	GROUND:CharSetAnim(partner, 'EventSleep', true)
	GAME:WaitFrames(10)
	GROUND:CharSetAnim(hero, 'EventSleep', true)
	GAME:WaitFrames(180)
	SOUND:FadeOutBGM(120)
	GAME:FadeOut(false, 120)
	GAME:WaitFrames(60)
	GAME:CutsceneMode(false)
	SV.Chapter2.FinishedFirstDay = true
	GeneralFunctions.EndOfDay()--reset daily flags and increment day counter by 1
	SV.TemporaryFlags.MorningWakeup = true
	SV.TemporaryFlags.MorningAddress = true
	GAME:EnterGroundMap("guild_heros_room", "Main_Entrance_Marker")
end
