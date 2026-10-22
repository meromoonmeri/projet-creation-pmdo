--contains helper functions used by guild_heros_room scripts.
guild_heros_room_helper = {}
------------------------------------
--Special Functions
------------------------------------
function guild_heros_room_helper.Bedtime(generic, continueSong)
--if generic is true, do a generic nighttime cutscene and relevant processing.
--if generic is false, just make the room look like it's night and put the duo in bed.
	if generic == nil then generic = false end
	if continueSong == nil then continueSong = false end

	local groundObj = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("Night_Window", 1, 0, 0),
													RogueElements.Rect(176, 56, 64, 64),
													RogueElements.Loc(0, 0),
													false,
													"Window_Cutscene")
	groundObj:ReloadEvents()
	GAME:GetCurrentGround():AddTempObject(groundObj)
	GROUND:AddMapStatus("darkness")
	if not continueSong then SOUND:StopBGM() end--cut bgm so it doesn't kick in until we want it to, unless we want the previous track to continue on
	AI:DisableCharacterAI(CH('Teammate1'))

	local hero_bed = MRKR('Hero_Bed')
	local partner_bed = MRKR('Partner_Bed')
	GROUND:Hide("Save_Point")--disable bed saving
	GROUND:TeleportTo(CH('PLAYER'), hero_bed.Position.X, hero_bed.Position.Y, Direction.Right)
	GROUND:TeleportTo(CH('Teammate1'), partner_bed.Position.X, partner_bed.Position.Y, Direction.Left)
	GeneralFunctions.CenterCamera({CH('PLAYER'), CH('Teammate1')})


	--todo: generic
	if generic then
		local partner = CH('Teammate1')
		local hero = CH('PLAYER')
		GAME:CutsceneMode(true)
		GAME:FadeIn(40)
		SOUND:PlayBGM('Goodnight.ogg', true)
		GAME:WaitFrames(40)
		
		-- Discussion intime au coucher dynamique selon la progression du chapitre
		local chapter = (SV.ChapterProgression and SV.ChapterProgression.Chapter) or 1
		UI:SetSpeaker(partner)
		
		if chapter == 1 or chapter == 2 then
			GeneralFunctions.SetEmotion("Normal")
			UI:WaitShowDialogue("Dis, " .. hero:GetDisplayName() .. "...[pause=20] C'est toujours bizarre de me dire que tu étais un humain.")
			GeneralFunctions.SetEmotion("Happy")
			UI:WaitShowDialogue("Mais je suis tellement heureux de t'avoir rencontré. Je sais qu'on fera une super équipe !")
			UI:WaitShowDialogue("Allez, bonne nuit, dors bien.")
		elseif chapter == 3 or chapter == 4 then
			GeneralFunctions.SetEmotion("Inspired")
			UI:WaitShowDialogue("On est de vrais explorateurs de la guilde maintenant ![pause=15] C'est incroyable.")
			GeneralFunctions.SetEmotion("Worried")
			UI:WaitShowDialogue("Parfois, j'ai un peu peur des hors-la-loi et des dangers... mais quand tu es là, je me sens courageux.")
			GeneralFunctions.SetEmotion("Normal")
			UI:WaitShowDialogue("Merci d'être là pour moi. Bonne nuit, " .. hero:GetDisplayName() .. ".")
		elseif chapter == 5 then
			GeneralFunctions.SetEmotion("Worried")
			UI:WaitShowDialogue("La grande expédition approche...[pause=20] J'ai l'estomac tout noué par le trac.")
			GeneralFunctions.SetEmotion("Normal")
			UI:WaitShowDialogue("Mais je sais que tant qu'on marche côte à côte, rien ne pourra nous arrêter.")
			GeneralFunctions.SetEmotion("Happy")
			UI:WaitShowDialogue("Je suis fier d'être ton partenaire. À demain pour de nouvelles aventures !")
		elseif chapter == 6 then
			GeneralFunctions.SetEmotion("Normal")
			UI:WaitShowDialogue("Cette forêt lugubre est terrifiante...[pause=15] et l'ambiance au village devient bizarre.")
			GeneralFunctions.SetEmotion("Inspired")
			UI:WaitShowDialogue("Mais quand je te regarde, ma peur s'en va d'un coup. Tu es ma plus belle rencontre, tu sais ?")
			GeneralFunctions.SetEmotion("Normal")
			UI:WaitShowDialogue("Repose-toi bien. Bonne nuit.")
		elseif chapter == 7 then
			GeneralFunctions.SetEmotion("Worried")
			UI:WaitShowDialogue("Les prédictions de Xatu... et ces secousses sous la terre...[pause=20] Ça m'inquiète beaucoup.")
			GeneralFunctions.SetEmotion("Normal")
			UI:WaitShowDialogue("S'il te plaît, promets-moi...[pause=15] Promets-moi que quoi qu'il arrive, on surmontera ça ensemble.")
			GeneralFunctions.SetEmotion("Happy")
			UI:WaitShowDialogue("On restera soudés, d'accord ? Bonne nuit, mon ami.")
		elseif chapter == 8 then
			GeneralFunctions.SetEmotion("Sad")
			UI:WaitShowDialogue("Le sanctuaire de cristal et toutes ces forces anciennes...[pause=15] J'ai l'impression que le monde change.")
			GeneralFunctions.SetEmotion("Normal")
			UI:WaitShowDialogue("Mais ma confiance en toi est plus solide que tous les cristaux du monde.")
			GeneralFunctions.SetEmotion("Happy")
			UI:WaitShowDialogue("Dors bien, " .. hero:GetDisplayName() .. ". Demain est un autre jour.")
		elseif chapter == 9 then
			GeneralFunctions.SetEmotion("Worried")
			UI:WaitShowDialogue("Les gens chuchotent sur la place publique... la Fédération devient nerveuse...")
			GeneralFunctions.SetEmotion("Determined")
			UI:WaitShowDialogue("Mais sache une chose :[pause=10] même si le monde entier se retournait contre toi... moi, je serai toujours de ton côté.")
			GeneralFunctions.SetEmotion("Normal")
			UI:WaitShowDialogue("Je te ferai toujours confiance. Bonne nuit.")
		elseif chapter == 10 then
			GeneralFunctions.SetEmotion("Normal")
			UI:WaitShowDialogue("Regarde les étoiles par la fenêtre...[pause=20] Le ciel semble si lourd de secrets ce soir.")
			GeneralFunctions.SetEmotion("Inspired")
			UI:WaitShowDialogue("Demain, nous montons à la Tour Céleste. J'ai un étrange pressentiment... mais je n'ai pas peur.")
			GeneralFunctions.SetEmotion("Happy")
			UI:WaitShowDialogue("Tant que je suis avec toi, mon cœur est en paix. Bonne nuit, mon irremplaçable ami.")
		else
			GeneralFunctions.SetEmotion("Normal")
			UI:WaitShowDialogue("Aujourd'hui, c'était fatiguant.[pause=0]Il faudrait se reposer un peu pour pouvoir tout donner demain !")
			UI:WaitShowDialogue("OK,[pause=10]bonne nuit,[pause=10]" .. hero:GetDisplayName() .. ".")
		end
		
		SOUND:FadeOutBGM(60)
		GAME:FadeOut(false, 60)
		SV.TemporaryFlags.Bedtime = false
		GROUND:RemoveMapStatus("darkness")
		GAME:CutsceneMode(false)
		GAME:GetCurrentGround():RemoveTempObject(groundObj)
		GeneralFunctions.EndOfDay()--reset daily flags and increment day counter by 1

	end
end

function guild_heros_room_helper.Morning(generic)
	if generic == nil then generic = true end

	if generic then
		GAME:FadeOut(false, 1)--fadeout if we aren't already
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
		GROUND:TeleportTo(CH('PLAYER'), hero_bed.Position.X, hero_bed.Position.Y, Direction.Right)
		GROUND:TeleportTo(CH('Teammate1'), partner_bed.Position.X, partner_bed.Position.Y, Direction.Left)
		GeneralFunctions.CenterCamera({hero, partner})
		GAME:WaitFrames(90)--wait a bit just in case we didn't wait before starting this scene

		local audino =
			CharacterEssentials.MakeCharactersFromList({
				{"Audino", 120, 204, Direction.UpRight},
			})

		UI:SetAutoFinish(true)
		UI:WaitShowVoiceOver("Le lendemain matin...", -1)
		UI:SetAutoFinish(false)

		GAME:WaitFrames(60)
		UI:SetSpeaker(audino)
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue("Bonjour les endormis ![pause=0]C'est une nouvelle journée radieuse !")
		GAME:FadeIn(40)
		GAME:WaitFrames(20)

		GROUND:CharAnimateTurnTo(audino, Direction.Down, 4)
		GAME:WaitFrames(10)
		SOUND:PlayBattleSE("DUN_Heal_Bell")
		GROUND:CharSetAction(audino, RogueEssence.Ground.PoseGroundAction(audino.Position, audino.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
		GAME:WaitFrames(100)
		GROUND:CharEndAnim(audino)
		GAME:WaitFrames(10)
		GROUND:CharAnimateTurnTo(audino, Direction.Left, 4)
		GROUND:MoveToPosition(audino, 0, 204, false, 2)
		GAME:GetCurrentGround():RemoveTempChar(audino)
		GROUND:CharSetAnim(hero, "Laying", true)
		GROUND:CharSetAnim(partner, "Laying", true)

		coro1 = TASK:BranchCoroutine(function () GAME:WaitFrames(10)
												 GeneralFunctions.Shake(hero)
												 GAME:WaitFrames(20)
												 GeneralFunctions.DoAnimation(hero, 'Wake')
												 --GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)
												 GAME:WaitFrames(20) end)
		coro2 = TASK:BranchCoroutine(function () GeneralFunctions.Shake(partner)
												 GAME:WaitFrames(20)
												 GeneralFunctions.DoAnimation(partner, 'Wake')
												 --GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
												 GAME:WaitFrames(20) end)
		TASK:JoinCoroutines({coro1, coro2})

		GROUND:CharTurnToCharAnimated(partner, hero, 4)
		GROUND:CharTurnToCharAnimated(hero, partner, 4)
		UI:SetSpeaker(partner)
		GeneralFunctions.SetEmotion("Happy")
		SOUND:PlayBGM("Wigglytuff's Guild.ogg", true)
		UI:WaitShowDialogue("Bonjour,[pause=10]" .. hero:GetDisplayName() .. " !")
		GAME:WaitFrames(20)
		GeneralFunctions.PanCamera()
		GAME:WaitFrames(20)
		GROUND:CharEndAnim(hero)
		GROUND:CharEndAnim(partner)
		GROUND:Unhide("Bedroom_Exit")
		GROUND:Unhide("Save_Point")
		GAME:CutsceneMode(false)
		AI:EnableCharacterAI(partner)
		AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)

		SV.TemporaryFlags.JustWokeUp = true
		SV.TemporaryFlags.MorningWakeup = false
	end

end
