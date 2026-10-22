require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.SideQuests'
require 'halcyon.TownVoices'
require 'halcyon.TownVoicesNight'
require 'halcyon.TownLife'
require 'halcyon.DazzlingPlaza'

metano_town_ch_6 = {}

local function RestorePartnerAI(partner)
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
end

local function AddDazzlingPlazaTrigger()
	local plazaTrigger = RogueEssence.Ground.GroundObject(
		RogueEssence.Content.ObjAnimData("", 1),
		RogueElements.Rect(760, 736, 288, 224),
		RogueElements.Loc(0, 0),
		false,
		"Event_Trigger_9")
	plazaTrigger:ReloadEvents()
	GAME:GetCurrentGround():AddTempObject(plazaTrigger)
end

function metano_town_ch_6.SetupGround()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')

	-- Boutique d'Échange (Ambipom) : OUVERTE depuis le retour de l'expédition (ch6+).
	-- C'était le dernier commerce indisponible prévu par Palika ; les Hide sont retirés.
	GROUND:Unhide('Swap_Owner')
	GROUND:Unhide('Swap')

	if not SV.Chapter6.DazzlingIntroPlayed then
		AddDazzlingPlazaTrigger()
	end

	local butterfree, adagio, aria, sonata = CharacterEssentials.MakeCharactersFromList({
		{'Butterfree', 824, 816, Direction.Right},
		{'Adagio', 1080, 784, Direction.Left},
		{'Aria', 1112, 816, Direction.Left},
		{'Sonata', 1144, 848, Direction.Left}
	})
	local mawile, floatzel, quagsire = CharacterEssentials.MakeCharactersFromList({
		{'Mawile', 736, 960, Direction.Up},
		{'Floatzel', 928, 1040, Direction.UpLeft},
		{'Quagsire', 640, 1008, Direction.UpRight}
	})
	AI:SetCharacterAI(floatzel, "halcyon.ai.ground_default", RogueElements.Loc(912, 1024), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)
	AI:SetCharacterAI(quagsire, "halcyon.ai.ground_default", RogueElements.Loc(624, 992), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)

	--------------------------------------------------------------------
	-- LA VILLE EST HABITEE, ET ELLE CHANGE D'UN JOUR A L'AUTRE.
	--
	-- Le chapitre 6 ne peuplait Metano que de trois PNJ (Mawile,
	-- Floatzel, Quagsire), la ou les chapitres 1 a 4 en placaient une
	-- vingtaine. Le joueur revenait donc d'expedition dans une ville
	-- pratiquement vide — l'inverse de ce que la narration raconte
	-- (« toute la ville parle du phenomene du sommet »).
	--
	-- On restaure donc la population, et on la fait VIVRE : chaque
	-- habitant a une tournee de postes (halcyon.TownLife), et le poste
	-- du jour depend de DaysPassed. Deux visites le meme jour donnent la
	-- meme ville ; deux jours differents ne se ressemblent pas. La
	-- rotation ne boucle pas avant quatorze jours.
	--
	-- Mawile est incluse dans la tournee : elle avait une position fixe
	-- ici, elle rejoint la vie commune.
	--------------------------------------------------------------------
	--2e argument `true` = rendre une TABLE indexable. Sans lui,
	--MakeCharactersFromList fait table.unpack (CharacterEssentials:1766)
	--et ne renverrait que le premier personnage dans `habitants`.
	local habitants = CharacterEssentials.MakeCharactersFromList({
		{'Electrike',   232,  872, Direction.Left},
		{'Sentret',     388,  716, Direction.Right},
		{'Manectric',  1144,  904, Direction.Down},
		{'Wooper_Girl', 328, 1000, Direction.Right},
		{'Wooper_Boy',  360, 1000, Direction.Left},
		{'Meditite',    416,  416, Direction.Down},
		{'Machamp',     576,  704, Direction.Down},
		{'Luxray',      304, 1024, Direction.Down},
		{'Gloom',       512,  184, Direction.DownRight},
		{'Oddish',      408,  396, Direction.DownLeft},
		{'Numel',       400,  432, Direction.Right},
		{'Bellossom',   472,  608, Direction.UpLeft},
		{'Nidoking',   1136,  896, Direction.Left},
		{'Roselia',    1204, 1128, Direction.Down},
		{'Spinda',     1184, 1160, Direction.UpRight},
		{'Ludicolo',   1184, 1128, Direction.DownRight}
	}, true)
	metano_town_ch_6.HABITANTS = {
		Electrike   = habitants[1],  Sentret   = habitants[2],
		Manectric   = habitants[3],  Wooper_Girl = habitants[4],
		Wooper_Boy  = habitants[5],  Meditite  = habitants[6],
		Machamp     = habitants[7],  Luxray    = habitants[8],
		Gloom       = habitants[9],  Oddish    = habitants[10],
		Numel       = habitants[11], Bellossom = habitants[12],
		Nidoking    = habitants[13], Roselia   = habitants[14],
		Spinda      = habitants[15], Ludicolo  = habitants[16],
		Mawile      = mawile,
	}
	pcall(function() TownLife.PlacerTous(metano_town_ch_6.HABITANTS) end)


	if SV.Chapter6.DazzlingIntroPlayed then
		GROUND:TeleportTo(butterfree, 824, 816, Direction.Right)
		GROUND:TeleportTo(adagio, 1008, 784, Direction.DownLeft)
		GROUND:TeleportTo(aria, 1040, 816, Direction.Left)
		GROUND:TeleportTo(sonata, 1072, 848, Direction.Left)
	end

	AI:SetCharacterAI(adagio, "halcyon.ai.ground_talking", false, 240, 60, 0, false, 'Default', {aria, sonata})
	AI:SetCharacterAI(aria, "halcyon.ai.ground_talking", false, 240, 60, 60, false, 'Default', {adagio, sonata})
	AI:SetCharacterAI(sonata, "halcyon.ai.ground_talking", false, 240, 60, 120, false, 'Default', {adagio, aria})

	if SV.Chapter6.MissionComplete and not SV.Chapter6.PostMissionScenePlayed then
		local venipede = CharacterEssentials.MakeCharactersFromList({
			{'Venipede', 864, 848, Direction.Left}
		})
		AI:DisableCharacterAI(butterfree)
		AI:DisableCharacterAI(venipede)
	end

	--------------------------------------------------------------------
	-- RETOUR DU DUEL DE LA PLACE. Le combat s'est joue sur
	-- metano_town_duel.rsmap ; on revient ici pour l'acte III.
	-- PlazaPending est pose par zone/gloomy_forest/init.lua (segment 7).
	--------------------------------------------------------------------
	if SV.Chapter6.PlazaPending ~= nil and SV.Chapter6.PlazaPending ~= false then
		local issue = SV.Chapter6.PlazaPending
		SV.Chapter6.PlazaPending = false
		-- Retour sur les mêmes cellules de la place que le rsmap de duel.
		-- Aucun saut vers l'ancien cadrage x=840 : exploration et combat coïncident.
		GROUND:TeleportTo(hero, 1128, 984, Direction.Up)
		GROUND:TeleportTo(partner, 1104, 984, Direction.Up)
		SV.Chapter6.PlazaTransitionStage = 'aftermath'
		if issue == 'win' then
			DazzlingPlaza.Victoire()
		else
			DazzlingPlaza.Defaite()
			--Le chevet se joue dans la chambre. On pose le drapeau puis on
			--change de carte : guild_heros_room.PlotScripting le consomme
			--a l'arrivee (meme patron que RaidScenes.Bedside).
			SV.Chapter6.PlazaBedsidePending = true
			pcall(function()
				GAME:EnterGroundMap("guild_heros_room", "Main_Entrance_Marker")
			end)
		end
		return
	end

	if SV.Chapter6.DefeatedByZeraora and not SV.Chapter6.PostDefeatScenePlayed then
		-- Le joueur revient apres avoir perdu contre Zeraora
		GROUND:TeleportTo(hero, 792, 896, Direction.Up)
		GROUND:TeleportTo(partner, 824, 896, Direction.Up)
	end

	GAME:FadeIn(20)
end

function metano_town_ch_6.Event_Trigger_9_Touch(obj, activator)
	if SV.Chapter6.DazzlingIntroPlayed then return end
	GROUND:Hide('Event_Trigger_9')
	metano_town_ch_6.DazzlingIntroduction()
end

function metano_town_ch_6.DazzlingIntroduction()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local butterfree = CH('Butterfree')
	local adagio = CH('Adagio')
	local aria = CH('Aria')
	local sonata = CH('Sonata')
	local mawile = CH('Mawile')
	local floatzel = CH('Floatzel')
	local quagsire = CH('Quagsire')

	-- Continuité directe avec la fin d'Aegis Cave : si le trio a déjà
	-- annoncé son arrivée au camp, cette scène est une RETROUVAILLE, jamais
	-- une seconde présentation. Son thème reste le même, mais les dialogues
	-- reconnaissent explicitement la rencontre précédente.
	if SV.Chapter6.DazzlingAegisAftermath then
		GAME:CutsceneMode(true)
		AI:DisableCharacterAI(partner);AI:DisableCharacterAI(adagio);AI:DisableCharacterAI(aria);AI:DisableCharacterAI(sonata)
		GAME:MoveCamera(960,816,1,false);SOUND:PlayBGM("Team_Dazzling_Theme.ogg",true)
		GROUND:MoveToPosition(adagio,1008,784,false,1);GROUND:MoveToPosition(aria,1040,816,false,1);GROUND:MoveToPosition(sonata,1072,848,false,1)
		UI:SetSpeaker(partner);GeneralFunctions.SetEmotion("Surprised");UI:WaitShowDialogue("Vous trois...[pause=10] Les Aegis Cave.[pause=15] Vous aviez dit qu'on se reverrait à Metano.")
		UI:SetSpeaker(adagio);GeneralFunctions.SetEmotion("Normal");UI:WaitShowDialogue("Et nous tenons parole.[pause=10] La pulsation que Sonata a suivie atteint maintenant Sinister Woods.")
		UI:SetSpeaker(sonata);GeneralFunctions.SetEmotion("Worried");UI:WaitShowDialogue("Elle se déplace sous les racines.[pause=10] Quelque chose l'attire vers le cœur de la forêt.")
		UI:SetSpeaker(aria);GeneralFunctions.SetEmotion("Happy");UI:WaitShowDialogue("Alors ?[pause=10] Vous êtes toujours aussi courageux loin de Regigigas ?")
		UI:SetSpeaker(butterfree);GeneralFunctions.SetEmotion("Worried");UI:WaitShowDialogue("Mon enfant est parti vers cette forêt.[pause=15] S'il vous plaît,[pause=10] retrouvez-le.")
		SV.Chapter6.DazzlingIntroPlayed=true;SV.Chapter6.MissionAvailable=true
		SOUND:FadeOutBGM(40);GAME:CutsceneMode(false);return
	end

	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	AI:DisableCharacterAI(butterfree)
	AI:DisableCharacterAI(adagio)
	AI:DisableCharacterAI(aria)
	AI:DisableCharacterAI(sonata)
	GAME:MoveCamera(896, 816, 1, false)

	local coro1 = TASK:BranchCoroutine(function()
		GROUND:MoveToPosition(butterfree, 872, 816, false, 1)
		GROUND:CharAnimateTurnTo(butterfree, Direction.Down, 4)
	end)
	local coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(10)
		GROUND:MoveToPosition(hero, 792, 896, false, 1)
		GROUND:CharAnimateTurnTo(hero, Direction.UpRight, 4)
	end)
	local coro3 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(14)
		GROUND:MoveToPosition(partner, 824, 896, false, 1)
		GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
	end)
		TASK:JoinCoroutines({coro1, coro2, coro3})

		UI:SetSpeaker(partner)
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_118']))
		UI:SetSpeaker(mawile)
		GeneralFunctions.SetEmotion("Inspired")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_119']))
		UI:SetSpeaker(floatzel)
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_120']))
		UI:SetSpeaker(quagsire)
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_121']))

		-- The square notices the commotion before the rivals speak.  This gives
		-- the entrance the same lived-in rhythm as the guild scenes.
	local crowd1 = TASK:BranchCoroutine(function()
		GROUND:CharAnimateTurnTo(mawile, Direction.UpRight, 4)
		GROUND:CharSetEmote(mawile, "notice", 1)
	end)
	local crowd2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(8)
		GROUND:CharAnimateTurnTo(floatzel, Direction.UpLeft, 4)
		GROUND:CharSetEmote(floatzel, "notice", 1)
	end)
	local crowd3 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(14)
		GROUND:CharAnimateTurnTo(quagsire, Direction.Up, 4)
		GROUND:CharSetEmote(quagsire, "question", 1)
	end)
	TASK:JoinCoroutines({crowd1, crowd2, crowd3})
	SOUND:PlayBattleSE("EVT_Emote_Exclaim_2")
	UI:SetSpeaker(mawile)
	GeneralFunctions.SetEmotion("Surprised")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_042']))
	UI:SetSpeaker(floatzel)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_043']))
	UI:SetSpeaker(quagsire)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_044']))

		SOUND:FadeOutBGM(30)
		GAME:WaitFrames(20)

		--L'ENTREE DES RIVALES — LE MOMENT DOIT SE VOIR ET S'ENTENDRE.
		--Le theme Team_Dazzling_Theme.ogg demarrait pendant que la place etait
		--encore cadree sur le duo : leur arrivee s'entendait avant de se
		--voir. La camera glisse desormais vers l'est PENDANT le silence,
		--et la musique tombe sur l'image une fois le cadre en place —
		--patron de l'arrivee au Mont Windsep.
		local reveal = TASK:BranchCoroutine(function()
			GAME:MoveCamera(960, 816, 50, false)
		end)
		TASK:JoinCoroutines({reveal})
		SOUND:PlayBGM("Team_Dazzling_Theme.ogg", true)
		GAME:WaitFrames(18)

		--TOUTE LA PLACE SE TOURNE VERS ELLES. Le duo, Butterfree et les
		--trois badauds : personne ne reste dos a l'evenement. Les delais
		--sont echelonnes pour que ce soit une vague, pas un pivot
		--collectif au meme instant.
		local look = {}
		for i, who in ipairs({partner, hero, butterfree, mawile, floatzel, quagsire}) do
			look[#look+1] = TASK:BranchCoroutine(function()
				GAME:WaitFrames((i - 1) * 5)
				pcall(function() GROUND:CharAnimateTurnTo(who, Direction.Right, 4) end)
			end)
		end
		TASK:JoinCoroutines(look)
		GAME:WaitFrames(10)

		coro1 = TASK:BranchCoroutine(function()
			GROUND:MoveToPosition(adagio, 1008, 784, false, 1)
			GROUND:CharAnimateTurnTo(adagio, Direction.DownLeft, 4)
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(8)
		GROUND:MoveToPosition(aria, 1040, 816, false, 1)
		GROUND:CharAnimateTurnTo(aria, Direction.Left, 4)
	end)
	coro3 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(16)
		GROUND:MoveToPosition(sonata, 1072, 848, false, 1)
		GROUND:CharAnimateTurnTo(sonata, Direction.Left, 4)
	end)
	TASK:JoinCoroutines({coro1, coro2, coro3})

	--ELLES SE TOURNENT VERS LE HEROS, PAS VERS LE VIDE.
	--Les trois pivotaient vers Direction.Down au meme instant : un pivot
	--collectif identique, que la directive de mise en scene interdit
	--explicitement (« chaque position dans l'espace appelle un ajustement
	--different »). Elles se tournent desormais vers le duo, chacune
	--depuis sa propre position, et en decale — Aria la premiere, elle est
	--la plus impatiente ; Adagio en dernier, elle ne se presse jamais.
	local face = {}
	for i, who in ipairs({aria, sonata, adagio}) do
		face[#face+1] = TASK:BranchCoroutine(function()
			GAME:WaitFrames((i - 1) * 7)
			pcall(function() GROUND:CharTurnToCharAnimated(who, hero, 4) end)
		end)
	end
	TASK:JoinCoroutines(face)
	GAME:WaitFrames(10)
	SOUND:PlayBattleSE("EVT_Emote_Exclaim_2")
	UI:SetSpeaker(aria)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_045']))
	GeneralFunctions.Hop(aria, "None", 6, 6, true, true)
	UI:SetSpeaker(sonata)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_046']))
		GeneralFunctions.DoubleHop(sonata)
		UI:SetSpeaker(adagio)
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_047']))

		--BUTTERFREE S'INTERPOSE : les rivales se tournent vers lui, et le
		--duo aussi. Le foyer d'attention se deplace, les orientations
		--suivent — c'est ce qui manquait a toute cette scene.
		local b1 = {}
		for i, who in ipairs({adagio, aria, sonata, hero, partner}) do
			b1[#b1+1] = TASK:BranchCoroutine(function()
				GAME:WaitFrames((i - 1) * 4)
				pcall(function() GROUND:CharTurnToCharAnimated(who, butterfree, 4) end)
			end)
		end
		TASK:JoinCoroutines(b1)

		UI:SetSpeaker(butterfree)
		GeneralFunctions.SetEmotion("Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_001']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_002']))
		GAME:WaitFrames(12)

		--ADAGIO REPOND. Elle est la meneuse : quand elle parle, tout le
		--monde se tourne, y compris ses deux coequipieres.
		local a1 = {}
		for i, who in ipairs({butterfree, aria, sonata, hero, partner}) do
			a1[#a1+1] = TASK:BranchCoroutine(function()
				GAME:WaitFrames((i - 1) * 4)
				pcall(function() GROUND:CharTurnToCharAnimated(who, adagio, 4) end)
			end)
		end
		TASK:JoinCoroutines(a1)

		UI:SetSpeaker(adagio)
		GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_003']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_004']))

	--Aria coupe la parole : le duo se tourne vers elle, Adagio non —
	--elle a l'habitude, et ce detail dit leur relation sans un mot.
	local ar1 = TASK:BranchCoroutine(function()
		pcall(function() GROUND:CharTurnToCharAnimated(hero, aria, 4) end)
	end)
	local ar2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(5)
		pcall(function() GROUND:CharTurnToCharAnimated(partner, aria, 4) end)
	end)
	TASK:JoinCoroutines({ar1, ar2})

	UI:SetSpeaker(aria)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_005']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_006']))

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Angry")
	GeneralFunctions.EmoteAndPause(partner, "Angry", true)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_007']))

	-- Aria tests the partner physically, but backs off as soon as she has
	-- obtained the reaction she wanted.
	local bump1 = TASK:BranchCoroutine(function()
		GROUND:MoveToPosition(aria, 880, 864, false, 1)
		GROUND:MoveInDirection(partner, Direction.DownRight, 8, false, 1)
	end)
	local bump2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(12)
		SOUND:PlayBattleSE("EVT_Emote_Shock_2")
		GROUND:CharSetEmote(partner, "shock", 1)
	end)
	TASK:JoinCoroutines({bump1, bump2})
	UI:SetSpeaker(aria)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_048']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_049']))
	GROUND:MoveToPosition(aria, 1040, 816, false, 1)
	GROUND:CharAnimateTurnTo(aria, Direction.Left, 4)

	UI:SetSpeaker(sonata)
	GeneralFunctions.SetEmotion("Happy")
	GROUND:CharSetEmote(sonata, "happy", 0)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_008']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_009']))
	GROUND:CharSetEmote(sonata, "", 0)

	local trick = TASK:BranchCoroutine(function()
		GROUND:MoveToPosition(sonata, 848, 848, false, 1)
		GROUND:CharAnimateTurnTo(sonata, Direction.Right, 4)
	end)
	local trick2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(12)
		SOUND:PlayBattleSE("EVT_Emote_Confused_2")
		GROUND:CharSetEmote(partner, "question", 1)
	end)
	TASK:JoinCoroutines({trick, trick2})
	UI:SetSpeaker(sonata)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_050']))
	GROUND:MoveToPosition(sonata, 1072, 848, false, 1)
	GROUND:CharAnimateTurnTo(sonata, Direction.Left, 4)

	--LE PARTENAIRE TIENT TETE. C'est le pivot de la scene : il faut que
	--les trois rivales le regardent pour que sa replique porte.
	local st = {}
	for i, who in ipairs({aria, sonata, adagio, butterfree}) do
		st[#st+1] = TASK:BranchCoroutine(function()
			GAME:WaitFrames((i - 1) * 5)
			pcall(function() GROUND:CharTurnToCharAnimated(who, partner, 4) end)
		end)
	end
	--Le heros se tourne vers son partenaire : il le soutient du corps
	--avant de parler.
	st[#st+1] = TASK:BranchCoroutine(function()
		pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
	end)
	TASK:JoinCoroutines(st)
	GAME:WaitFrames(8)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_010']))
	GAME:WaitFrames(10)

	--Le heros prend le relais : tout le monde se tourne vers lui.
	local hr = {}
	for i, who in ipairs({partner, aria, adagio, butterfree}) do
		hr[#hr+1] = TASK:BranchCoroutine(function()
			GAME:WaitFrames((i - 1) * 4)
			pcall(function() GROUND:CharTurnToCharAnimated(who, hero, 4) end)
		end)
	end
	TASK:JoinCoroutines(hr)

	UI:SetSpeaker(hero)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_011']))
	GAME:WaitFrames(10)

	pcall(function() GROUND:CharTurnToCharAnimated(hero, butterfree, 4) end)
	pcall(function() GROUND:CharTurnToCharAnimated(partner, butterfree, 4) end)
	UI:SetSpeaker(butterfree)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_012']))
	GAME:WaitFrames(10)

	--Aria est prise de court : le corps le dit avant la boite.
	pcall(function() GROUND:CharTurnToCharAnimated(aria, hero, 4) end)
	pcall(function() GeneralFunctions.EmoteAndPause(aria, "Shock", true) end)
	UI:SetSpeaker(aria)
	GeneralFunctions.SetEmotion("Surprised")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_013']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_014']))

	UI:SetSpeaker(adagio)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_015']))
	GROUND:CharSetEmote(adagio, "happy", 0)
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(adagio, "", 0)

	UI:SetSpeaker(sonata)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_016']))

	UI:SetSpeaker(adagio)
	GeneralFunctions.SetEmotion("Sigh")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_017']))

	UI:SetSpeaker(floatzel)
	GeneralFunctions.SetEmotion("Surprised")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_051']))
	UI:SetSpeaker(aria)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_052']))
	UI:SetSpeaker(sonata)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_053']))
	UI:SetSpeaker(adagio)
	GeneralFunctions.SetEmotion("Sigh")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_054']))

	local exit1 = TASK:BranchCoroutine(function()
		GROUND:MoveToPosition(aria, 1120, 816, false, 1)
		GROUND:CharAnimateTurnTo(aria, Direction.Right, 4)
	end)
	local exit2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(8)
		GROUND:MoveToPosition(sonata, 1152, 848, false, 1)
		GROUND:CharAnimateTurnTo(sonata, Direction.Right, 4)
	end)
	local exit3 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(16)
		GROUND:MoveToPosition(adagio, 1080, 784, false, 1)
		GROUND:CharAnimateTurnTo(adagio, Direction.Right, 4)
	end)
	TASK:JoinCoroutines({exit1, exit2, exit3})
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_055']))
	UI:SetSpeaker(adagio)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_056']))

	SV.Chapter6.DazzlingIntroPlayed = true
	SV.Chapter6.MissionAvailable = true
	GAME:WaitFrames(20)

	--------------------------------------------------------------------
	-- LA CONFRONTATION DE LA PLACE — enchainee ici, une seule fois.
	--
	-- La presentation ci-dessus reste INTACTE : elle installe les trois
	-- rivales et se termine sur leur pique habituelle. La confrontation
	-- proprement dite (mere Papilusion, cercle d'habitants, combat)
	-- prend le relais immediatement, sans rendre la main entre les deux :
	-- c'est UNE seule sequence pour le joueur.
	--
	-- Verrou d'unicite : SV.Chapter6.PlazaMet est pose par ActeII juste
	-- avant le combat. La scene ne peut donc jamais etre rejouee, meme
	-- si le joueur repasse sur le declencheur.
	--------------------------------------------------------------------
	if not SV.Chapter6.PlazaMet then
		local ok, err = pcall(function()
			DazzlingPlaza.ActeI()
		end)
		if not ok then PrintInfo('[metano_town_ch_6] ActeI ecourte : '..tostring(err)) end
		--ActeII bascule sur la carte de duel : on ne rend PAS la main ici.
		DazzlingPlaza.ActeII()
		return
	end

	GAME:CutsceneMode(false)
	RestorePartnerAI(partner)
	AI:SetCharacterAI(adagio, "halcyon.ai.ground_talking", false, 240, 60, 0, false, 'Default', {aria, sonata})
	AI:SetCharacterAI(aria, "halcyon.ai.ground_talking", false, 240, 60, 60, false, 'Default', {adagio, sonata})
	AI:SetCharacterAI(sonata, "halcyon.ai.ground_talking", false, 240, 60, 120, false, 'Default', {adagio, aria})
end

function metano_town_ch_6.Butterfree_Action(chara, activator)
  --LA CONFRONTATION DE LA PLACE. Si le joueur y etait, ce temoin a
  --SA replique sur ce qu'il a vu, differente selon l'issue du combat.
  --Elle prime sur tout le reste, puis la cascade habituelle reprend.
  if DazzlingPlaza.Temoin('Butterfree') then return end
  --LA VILLE PARLE DE LA NUIT. Reaction au dernier raid, si la ville en
  --porte encore la trace. Une seule fois par journee, puis on rend la
  --main au dialogue de chapitre : rien n'est perdu.
  if TownVoicesNight.Talk('Butterfree') then return end
	if not SV.Chapter6.DazzlingIntroPlayed then return end
	if SV.Chapter6.MissionComplete then
		GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_018']), "Happy")
		GeneralFunctions.EndConversation(chara)
		return
	end

	local partner = CH('Teammate1')
	GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_019']), "Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_020']))
	UI:ChoiceMenuYesNo(STRINGS:Format(STRINGS.MapStrings['MT6_021']), true)
	UI:WaitForChoice()
	local result = UI:ChoiceResult()
	if result then
		SV.Chapter6.MissionAccepted = true
		GeneralFunctions.EndConversation(chara)
		AI:DisableCharacterAI(partner)
		SOUND:FadeOutBGM(40)
		GAME:FadeOut(false, 40)
		GAME:EnterGroundMap("gloomy_forest_entrance", "Main_Entrance_Marker")
	else
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_022']))
		GeneralFunctions.EndConversation(chara)
	end
end

function metano_town_ch_6.Venipede_Action(chara, activator)
  --LA VILLE PARLE DE LA NUIT. Reaction au dernier raid, si la ville en
  --porte encore la trace. Une seule fois par journee, puis on rend la
  --main au dialogue de chapitre : rien n'est perdu.
  --LA CONFRONTATION DE LA PLACE : sa replique de temoin prime.
  if DazzlingPlaza.Temoin('Venipede') then return end
  if TownVoicesNight.Talk('Venipede') then return end
	GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_035']), "Happy")
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Adagio_Action(chara, activator)
  --LA VILLE PARLE DE LA NUIT. Reaction au dernier raid, si la ville en
  --porte encore la trace. Une seule fois par journee, puis on rend la
  --main au dialogue de chapitre : rien n'est perdu.
  if TownVoicesNight.Talk('Adagio') then return end
	GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_023']), "Normal")
	GeneralFunctions.SetEmotion("Sigh")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_024']))
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Aria_Action(chara, activator)
  --LA VILLE PARLE DE LA NUIT. Reaction au dernier raid, si la ville en
  --porte encore la trace. Une seule fois par journee, puis on rend la
  --main au dialogue de chapitre : rien n'est perdu.
  if TownVoicesNight.Talk('Aria') then return end
  -- Requetes de Metano : elles doivent etre rendues avant que la guilde
  -- lance l'expedition suivante (cf. SideQuests.lua). Si le PNJ n'a rien
  -- a dire sur une requete, on retombe sur son dialogue habituel.
  if SideQuests.Interact('Aria', 6) then return end
	GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_025']), "Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_026']))
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Sonata_Action(chara, activator)
  --LA VILLE PARLE DE LA NUIT. Reaction au dernier raid, si la ville en
  --porte encore la trace. Une seule fois par journee, puis on rend la
  --main au dialogue de chapitre : rien n'est perdu.
  if TownVoicesNight.Talk('Sonata') then return end
	GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_027']), "Happy")
	GROUND:CharSetEmote(chara, "happy", 0)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_028']))
	GROUND:CharSetEmote(chara, "", 0)
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.PostMissionCutscene()
	if SV.Chapter6.PostMissionScenePlayed ~= false or not SV.Chapter6.MissionComplete then return end
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local butterfree = CH('Butterfree')
	local venipede = CH('Venipede')
	local adagio = CH('Adagio')
	local aria = CH('Aria')
	local sonata = CH('Sonata')

	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	AI:DisableCharacterAI(butterfree)
	AI:DisableCharacterAI(venipede)
	AI:DisableCharacterAI(adagio)
	AI:DisableCharacterAI(aria)
	AI:DisableCharacterAI(sonata)
	GAME:MoveCamera(896, 816, 1, false)

	UI:SetSpeaker(butterfree)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_029']))
	UI:SetSpeaker(venipede)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_030']))
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_031']))
	UI:SetSpeaker(aria)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_032']))
	UI:SetSpeaker(sonata)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_033']))
	UI:SetSpeaker(adagio)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_034']))

	SV.Chapter6.PostMissionScenePlayed = true

	--VERROU DES REQUETES. Les 3 requetes de Metano doivent etre rendues avant
	--que la guilde lance l'expedition suivante. Tant qu'il en reste, on
	--repousse le palier d'un jour a chaque nuit : le joueur n'est jamais
	--bloque en silence, la ville le lui dit et le tableau des Requetes
	--affiche ce qui manque (cf. SideQuests.lua).
	SideQuests.Ensure()
	if not SideQuests.AllDone(6) then
		local reste = SideQuests.Remaining(6)
		GAME:WaitFrames(20)
		UI:SetSpeaker(adagio)
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue("Une derniere chose.[pause=25] Votre ville vous reclame.")
		UI:SetSpeaker(partner)
		GeneralFunctions.SetEmotion("Surprised")
		UI:WaitShowDialogue("Nous ?[pause=20] Mais on rentre a peine—")
		UI:SetSpeaker(adagio)
		GeneralFunctions.SetEmotion("Sigh")
		UI:WaitShowDialogue("Il y a " .. reste .. " requete(s) au tableau.[pause=25] Personne d'autre ne s'en occupe.")
		UI:SetSpeaker(adagio)
		GeneralFunctions.SetEmotion("Determined")
		UI:WaitShowDialogue("Une equipe qui sauve des forets et laisse sa ville en plan,[pause=20] ca ne vaut rien.")
		UI:ResetSpeaker()
		--Le palier reste hors d'atteinte tant que les requetes tiennent.
		SV.ChapterProgression.DaysToReach = SV.ChapterProgression.DaysPassed + 1
	else
		--Delai avant l'ouverture du chapitre 7, sur le modele des paliers ch4->ch5
		--(guild_heros_room_ch_4:216, +3 jours) et ch5->ch6 (guild_heros_room_ch_5:175,
		--+2 jours) : quelques jours de missions libres avant que l'histoire reprenne.
		--Sans cette ligne, DaysToReach garderait la valeur du palier precedent et le
		--chapitre 7 s'ouvrirait des la nuit suivante.
		SV.ChapterProgression.DaysToReach = SV.ChapterProgression.DaysPassed + 2
	end
	GAME:WaitFrames(20)
	GAME:CutsceneMode(false)
	RestorePartnerAI(partner)
	AI:EnableCharacterAI(butterfree)
	AI:EnableCharacterAI(venipede)
	AI:SetCharacterAI(adagio, "halcyon.ai.ground_talking", false, 240, 60, 0, false, 'Default', {aria, sonata})
	AI:SetCharacterAI(aria, "halcyon.ai.ground_talking", false, 240, 60, 60, false, 'Default', {adagio, sonata})
	AI:SetCharacterAI(sonata, "halcyon.ai.ground_talking", false, 240, 60, 120, false, 'Default', {adagio, aria})
end

function metano_town_ch_6.Mawile_Action(chara, activator)
  --LA CONFRONTATION DE LA PLACE. Si le joueur y etait, ce temoin a
  --SA replique sur ce qu'il a vu, differente selon l'issue du combat.
  --Elle prime sur tout le reste, puis la cascade habituelle reprend.
  if DazzlingPlaza.Temoin('Mawile') then return end
  --LA VILLE PARLE DE LA NUIT. Reaction au dernier raid, si la ville en
  --porte encore la trace. Une seule fois par journee, puis on rend la
  --main au dialogue de chapitre : rien n'est perdu.
  if TownVoicesNight.Talk('Mawile') then return end
	GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_036']), "Inspired")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_037']))
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Floatzel_Action(chara, activator)
  --LA CONFRONTATION DE LA PLACE. Si le joueur y etait, ce temoin a
  --SA replique sur ce qu'il a vu, differente selon l'issue du combat.
  --Elle prime sur tout le reste, puis la cascade habituelle reprend.
  if DazzlingPlaza.Temoin('Floatzel') then return end
  --LA VILLE PARLE DE LA NUIT. Reaction au dernier raid, si la ville en
  --porte encore la trace. Une seule fois par journee, puis on rend la
  --main au dialogue de chapitre : rien n'est perdu.
  if TownVoicesNight.Talk('Floatzel') then return end
	GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_038']), "Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_039']))
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Quagsire_Action(chara, activator)
  --LA CONFRONTATION DE LA PLACE. Si le joueur y etait, ce temoin a
  --SA replique sur ce qu'il a vu, differente selon l'issue du combat.
  --Elle prime sur tout le reste, puis la cascade habituelle reprend.
  if DazzlingPlaza.Temoin('Quagsire') then return end
  --LA VILLE PARLE DE LA NUIT. Reaction au dernier raid, si la ville en
  --porte encore la trace. Une seule fois par journee, puis on rend la
  --main au dialogue de chapitre : rien n'est perdu.
  if TownVoicesNight.Talk('Quagsire') then return end
	GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_040']), "Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_041']))
	GeneralFunctions.EndConversation(chara)
end

-- TOWN NPCS — Chapter 6 dialogues (Pre/During/Post Forest)
-- Each NPC has multiple dialogue variants depending on mission progress

local function Ch6State()
  if SV.Chapter6.MissionComplete then return "post"
  elseif SV.Chapter6.MissionAccepted then return "during"
  elseif SV.Chapter6.DazzlingIntroPlayed then return "pre"
  else return "early"
  end
end

function metano_town_ch_6.Luxray_Action(chara, activator)
  --LA VILLE PARLE DE LA NUIT. Reaction au dernier raid, si la ville en
  --porte encore la trace. Une seule fois par journee, puis on rend la
  --main au dialogue de chapitre : rien n'est perdu.
  if TownVoicesNight.Talk('Luxray') then return end
  -- Voix de ville reactive a l'avancement (cf. TownVoices.lua).
  -- APRES SideQuests : une requete prime toujours sur l'ambiance.
  if TownVoices.Talk('Luxray', 6) then return end
  --LA VIE QUOTIDIENNE. Le propos du jour depend du poste qu'occupe
  --l'habitant aujourd'hui (halcyon.TownLife) : il parle de la ou il
  --est, et pas la meme chose d'un jour a l'autre. Place APRES les
  --voix evenementielles (nuit, avancement) : un evenement prime
  --toujours sur l'ambiance, et AVANT le dialogue de chapitre, qui
  --reste le repli.
  if TownLife.TOURNEES['Luxray'] ~= nil and TownLife.Parler(chara, 'Luxray') then return end
  local s = Ch6State()
  if s == "post" then
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_077']), "Normal")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_079']))
  elseif s == "during" then
    GeneralFunctions.StartConversation(chara, "Allez, [player].[pause=15] La foret n'attend pas.", "Determined")
  else
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_057']), "Normal")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Electrike_Action(chara, activator)
  --LA VILLE PARLE DE LA NUIT. Reaction au dernier raid, si la ville en
  --porte encore la trace. Une seule fois par journee, puis on rend la
  --main au dialogue de chapitre : rien n'est perdu.
  if TownVoicesNight.Talk('Electrike') then return end
  local s = Ch6State()
  if s == "post" then
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_082']), "Inspired")
  elseif s == "pre" then
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_059']), "Normal")
  else
    GeneralFunctions.StartConversation(chara, "Vous partez en mission ?[pause=15] Trop cool !", "Happy")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Manectric_Action(chara, activator)
  --LA VILLE PARLE DE LA NUIT. Reaction au dernier raid, si la ville en
  --porte encore la trace. Une seule fois par journee, puis on rend la
  --main au dialogue de chapitre : rien n'est perdu.
  if TownVoicesNight.Talk('Manectric') then return end
  -- Voix de ville reactive a l'avancement (cf. TownVoices.lua).
  -- APRES SideQuests : une requete prime toujours sur l'ambiance.
  if TownVoices.Talk('Manectric', 6) then return end
  --LA VIE QUOTIDIENNE. Le propos du jour depend du poste qu'occupe
  --l'habitant aujourd'hui (halcyon.TownLife) : il parle de la ou il
  --est, et pas la meme chose d'un jour a l'autre. Place APRES les
  --voix evenementielles (nuit, avancement) : un evenement prime
  --toujours sur l'ambiance, et AVANT le dialogue de chapitre, qui
  --reste le repli.
  if TownLife.TOURNEES['Manectric'] ~= nil and TownLife.Parler(chara, 'Manectric') then return end
  local s = Ch6State()
  if s == "post" then
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_080']), "Normal")
  else
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_065']), "Worried")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Bellossom_Action(chara, activator)
  --LA VILLE PARLE DE LA NUIT. Reaction au dernier raid, si la ville en
  --porte encore la trace. Une seule fois par journee, puis on rend la
  --main au dialogue de chapitre : rien n'est perdu.
  if TownVoicesNight.Talk('Bellossom') then return end
  -- Requetes de Metano : elles doivent etre rendues avant que la guilde
  -- lance l'expedition suivante (cf. SideQuests.lua). Si le PNJ n'a rien
  -- a dire sur une requete, on retombe sur son dialogue habituel.
  if SideQuests.Interact('Bellossom', 6) then return end
  -- Voix de ville reactive a l'avancement (cf. TownVoices.lua).
  -- APRES SideQuests : une requete prime toujours sur l'ambiance.
  if TownVoices.Talk('Bellossom', 6) then return end
  --LA VIE QUOTIDIENNE. Le propos du jour depend du poste qu'occupe
  --l'habitant aujourd'hui (halcyon.TownLife) : il parle de la ou il
  --est, et pas la meme chose d'un jour a l'autre. Place APRES les
  --voix evenementielles (nuit, avancement) : un evenement prime
  --toujours sur l'ambiance, et AVANT le dialogue de chapitre, qui
  --reste le repli.
  if TownLife.TOURNEES['Bellossom'] ~= nil and TownLife.Parler(chara, 'Bellossom') then return end
  local s = Ch6State()
  if s == "post" then
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_081']), "Happy")
  elseif s == "pre" then
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_068']), "Worried")
  else
    GeneralFunctions.StartConversation(chara, "La foret...[pause=20] elle a besoin d'aide. Je le sens.", "Sad")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Vileplume_Action(chara, activator)
  --LA VILLE PARLE DE LA NUIT. Reaction au dernier raid, si la ville en
  --porte encore la trace. Une seule fois par journee, puis on rend la
  --main au dialogue de chapitre : rien n'est perdu.
  if TownVoicesNight.Talk('Vileplume') then return end
  -- Voix de ville reactive a l'avancement (cf. TownVoices.lua).
  -- APRES SideQuests : une requete prime toujours sur l'ambiance.
  if TownVoices.Talk('Vileplume', 6) then return end
  --LA VIE QUOTIDIENNE. Le propos du jour depend du poste qu'occupe
  --l'habitant aujourd'hui (halcyon.TownLife) : il parle de la ou il
  --est, et pas la meme chose d'un jour a l'autre. Place APRES les
  --voix evenementielles (nuit, avancement) : un evenement prime
  --toujours sur l'ambiance, et AVANT le dialogue de chapitre, qui
  --reste le repli.
  if TownLife.TOURNEES['Vileplume'] ~= nil and TownLife.Parler(chara, 'Vileplume') then return end
  local s = Ch6State()
  if s == "post" then
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_070']), "Happy")
  else
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_061']), "Worried")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Gloom_Action(chara, activator)
  --LA VILLE PARLE DE LA NUIT. Reaction au dernier raid, si la ville en
  --porte encore la trace. Une seule fois par journee, puis on rend la
  --main au dialogue de chapitre : rien n'est perdu.
  if TownVoicesNight.Talk('Gloom') then return end
  -- Voix de ville reactive a l'avancement (cf. TownVoices.lua).
  -- APRES SideQuests : une requete prime toujours sur l'ambiance.
  if TownVoices.Talk('Gloom', 6) then return end
  --LA VIE QUOTIDIENNE. Le propos du jour depend du poste qu'occupe
  --l'habitant aujourd'hui (halcyon.TownLife) : il parle de la ou il
  --est, et pas la meme chose d'un jour a l'autre. Place APRES les
  --voix evenementielles (nuit, avancement) : un evenement prime
  --toujours sur l'ambiance, et AVANT le dialogue de chapitre, qui
  --reste le repli.
  if TownLife.TOURNEES['Gloom'] ~= nil and TownLife.Parler(chara, 'Gloom') then return end
  local s = Ch6State()
  if s == "post" then
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_078']), "Happy")
  else
    GeneralFunctions.StartConversation(chara, "Chenipent...[pause=25] il est si petit.", "Sad")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Oddish_Action(chara, activator)
  --LA VILLE PARLE DE LA NUIT. Reaction au dernier raid, si la ville en
  --porte encore la trace. Une seule fois par journee, puis on rend la
  --main au dialogue de chapitre : rien n'est perdu.
  if TownVoicesNight.Talk('Oddish') then return end
  -- Voix de ville reactive a l'avancement (cf. TownVoices.lua).
  -- APRES SideQuests : une requete prime toujours sur l'ambiance.
  if TownVoices.Talk('Oddish', 6) then return end
  --LA VIE QUOTIDIENNE. Le propos du jour depend du poste qu'occupe
  --l'habitant aujourd'hui (halcyon.TownLife) : il parle de la ou il
  --est, et pas la meme chose d'un jour a l'autre. Place APRES les
  --voix evenementielles (nuit, avancement) : un evenement prime
  --toujours sur l'ambiance, et AVANT le dialogue de chapitre, qui
  --reste le repli.
  if TownLife.TOURNEES['Oddish'] ~= nil and TownLife.Parler(chara, 'Oddish') then return end
  local s = Ch6State()
  if s == "post" then
    GeneralFunctions.StartConversation(chara, "Chenipent dit que vous etes ses heros ![pause=15] Il le dit a TOUT le monde !", "Happy")
  else
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_064'], CH('PLAYER'):GetDisplayName(), CH('Teammate1'):GetDisplayName()), "Normal")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Numel_Action(chara, activator)
  --LA VILLE PARLE DE LA NUIT. Reaction au dernier raid, si la ville en
  --porte encore la trace. Une seule fois par journee, puis on rend la
  --main au dialogue de chapitre : rien n'est perdu.
  if TownVoicesNight.Talk('Numel') then return end
  GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_062']), "Angry")
  UI:WaitShowDialogue("Pourquoi les equipes d'elite ne font rien ?![pause=15] C'est pas juste !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Camerupt_Action(chara, activator)
  --LA VILLE PARLE DE LA NUIT. Reaction au dernier raid, si la ville en
  --porte encore la trace. Une seule fois par journee, puis on rend la
  --main au dialogue de chapitre : rien n'est perdu.
  if TownVoicesNight.Talk('Camerupt') then return end
  local s = Ch6State()
  if s == "post" then
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_076']), "Normal")
  else
    GeneralFunctions.StartConversation(chara, "Numel est enerve.[pause=20] Il a raison.[pause=25] Mais on ne peut pas forcer les autres.", "Worried")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Machamp_Action(chara, activator)
  --LA VILLE PARLE DE LA NUIT. Reaction au dernier raid, si la ville en
  --porte encore la trace. Une seule fois par journee, puis on rend la
  --main au dialogue de chapitre : rien n'est perdu.
  if TownVoicesNight.Talk('Machamp') then return end
  -- Voix de ville reactive a l'avancement (cf. TownVoices.lua).
  -- APRES SideQuests : une requete prime toujours sur l'ambiance.
  if TownVoices.Talk('Machamp', 6) then return end
  --LA VIE QUOTIDIENNE. Le propos du jour depend du poste qu'occupe
  --l'habitant aujourd'hui (halcyon.TownLife) : il parle de la ou il
  --est, et pas la meme chose d'un jour a l'autre. Place APRES les
  --voix evenementielles (nuit, avancement) : un evenement prime
  --toujours sur l'ambiance, et AVANT le dialogue de chapitre, qui
  --reste le repli.
  if TownLife.TOURNEES['Machamp'] ~= nil and TownLife.Parler(chara, 'Machamp') then return end
  local s = Ch6State()
  if s == "post" then
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_095']), "Happy")
  else
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_064'], CH('PLAYER'):GetDisplayName(), CH('Teammate1'):GetDisplayName()), "Normal")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Meditite_Action(chara, activator)
  --LA VILLE PARLE DE LA NUIT. Reaction au dernier raid, si la ville en
  --porte encore la trace. Une seule fois par journee, puis on rend la
  --main au dialogue de chapitre : rien n'est perdu.
  if TownVoicesNight.Talk('Meditite') then return end
  local s = Ch6State()
  if s == "post" then
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_096']), "Normal")
  else
    GeneralFunctions.StartConversation(chara, "La Team Dazzling...[pause=20] elles font peur.[pause=15] Mais elles sont fascinantes.", "Normal")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Medicham_Action(chara, activator)
  --LA VILLE PARLE DE LA NUIT. Reaction au dernier raid, si la ville en
  --porte encore la trace. Une seule fois par journee, puis on rend la
  --main au dialogue de chapitre : rien n'est perdu.
  if TownVoicesNight.Talk('Medicham') then return end
  -- Voix de ville reactive a l'avancement (cf. TownVoices.lua).
  -- APRES SideQuests : une requete prime toujours sur l'ambiance.
  if TownVoices.Talk('Medicham', 6) then return end
  --LA VIE QUOTIDIENNE. Le propos du jour depend du poste qu'occupe
  --l'habitant aujourd'hui (halcyon.TownLife) : il parle de la ou il
  --est, et pas la meme chose d'un jour a l'autre. Place APRES les
  --voix evenementielles (nuit, avancement) : un evenement prime
  --toujours sur l'ambiance, et AVANT le dialogue de chapitre, qui
  --reste le repli.
  if TownLife.TOURNEES['Medicham'] ~= nil and TownLife.Parler(chara, 'Medicham') then return end
  if Ch6State() == "post" then
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_097']), "Normal")
  else
    GeneralFunctions.StartConversation(chara, "L'entrainement est la cle.[pause=25] Surtout avant d'affronter l'inconnu.", "Determined")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Furret_Action(chara, activator)
  --LA VILLE PARLE DE LA NUIT. Reaction au dernier raid, si la ville en
  --porte encore la trace. Une seule fois par journee, puis on rend la
  --main au dialogue de chapitre : rien n'est perdu.
  if TownVoicesNight.Talk('Furret') then return end
  -- Requetes de Metano : elles doivent etre rendues avant que la guilde
  -- lance l'expedition suivante (cf. SideQuests.lua). Si le PNJ n'a rien
  -- a dire sur une requete, on retombe sur son dialogue habituel.
  if SideQuests.Interact('Furret', 6) then return end
  -- Voix de ville reactive a l'avancement (cf. TownVoices.lua).
  -- APRES SideQuests : une requete prime toujours sur l'ambiance.
  if TownVoices.Talk('Furret', 6) then return end
  --LA VIE QUOTIDIENNE. Le propos du jour depend du poste qu'occupe
  --l'habitant aujourd'hui (halcyon.TownLife) : il parle de la ou il
  --est, et pas la meme chose d'un jour a l'autre. Place APRES les
  --voix evenementielles (nuit, avancement) : un evenement prime
  --toujours sur l'ambiance, et AVANT le dialogue de chapitre, qui
  --reste le repli.
  if TownLife.TOURNEES['Furret'] ~= nil and TownLife.Parler(chara, 'Furret') then return end
  local s = Ch6State()
  if s == "post" then
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_094']), "Happy")
  elseif s == "pre" then
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_058']), "Inspired")
  else
    GeneralFunctions.StartConversation(chara, "La foret...[pause=25] faites attention a vous.", "Worried")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Linoone_Action(chara, activator)
  --LA VILLE PARLE DE LA NUIT. Reaction au dernier raid, si la ville en
  --porte encore la trace. Une seule fois par journee, puis on rend la
  --main au dialogue de chapitre : rien n'est perdu.
  if TownVoicesNight.Talk('Linoone') then return end
  -- Voix de ville reactive a l'avancement (cf. TownVoices.lua).
  -- APRES SideQuests : une requete prime toujours sur l'ambiance.
  if TownVoices.Talk('Linoone', 6) then return end
  --LA VIE QUOTIDIENNE. Le propos du jour depend du poste qu'occupe
  --l'habitant aujourd'hui (halcyon.TownLife) : il parle de la ou il
  --est, et pas la meme chose d'un jour a l'autre. Place APRES les
  --voix evenementielles (nuit, avancement) : un evenement prime
  --toujours sur l'ambiance, et AVANT le dialogue de chapitre, qui
  --reste le repli.
  if TownLife.TOURNEES['Linoone'] ~= nil and TownLife.Parler(chara, 'Linoone') then return end
  local s = Ch6State()
  if s == "post" then
    GeneralFunctions.StartConversation(chara, "Mon petit veut etre comme vous plus tard.[pause=25] J'espere que vous serez un bon modele.", "Normal")
  else
    GeneralFunctions.StartConversation(chara, "Les enfants ne comprennent pas le danger.[pause=20] Vous, si.", "Worried")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Sentret_Action(chara, activator)
  --LA VILLE PARLE DE LA NUIT. Reaction au dernier raid, si la ville en
  --porte encore la trace. Une seule fois par journee, puis on rend la
  --main au dialogue de chapitre : rien n'est perdu.
  if TownVoicesNight.Talk('Sentret') then return end
  -- Voix de ville reactive a l'avancement (cf. TownVoices.lua).
  -- APRES SideQuests : une requete prime toujours sur l'ambiance.
  if TownVoices.Talk('Sentret', 6) then return end
  --LA VIE QUOTIDIENNE. Le propos du jour depend du poste qu'occupe
  --l'habitant aujourd'hui (halcyon.TownLife) : il parle de la ou il
  --est, et pas la meme chose d'un jour a l'autre. Place APRES les
  --voix evenementielles (nuit, avancement) : un evenement prime
  --toujours sur l'ambiance, et AVANT le dialogue de chapitre, qui
  --reste le repli.
  if TownLife.TOURNEES['Sentret'] ~= nil and TownLife.Parler(chara, 'Sentret') then return end
  local s = Ch6State()
  if s == "post" then
    GeneralFunctions.StartConversation(chara, "Vous avez vu Zeraora de PRES ?![pause=15] Waaaah ![pause=20] Racontez-moi TOUT !", "Inspired")
  else
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_066']), "Normal")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Wooper_Girl_Action(chara, activator)
  --LA VILLE PARLE DE LA NUIT. Reaction au dernier raid, si la ville en
  --porte encore la trace. Une seule fois par journee, puis on rend la
  --main au dialogue de chapitre : rien n'est perdu.
  if TownVoicesNight.Talk('Wooper_Girl') then return end
  -- Voix de ville reactive a l'avancement (cf. TownVoices.lua).
  -- APRES SideQuests : une requete prime toujours sur l'ambiance.
  if TownVoices.Talk('Wooper_Girl', 6) then return end
  --LA VIE QUOTIDIENNE. Le propos du jour depend du poste qu'occupe
  --l'habitant aujourd'hui (halcyon.TownLife) : il parle de la ou il
  --est, et pas la meme chose d'un jour a l'autre. Place APRES les
  --voix evenementielles (nuit, avancement) : un evenement prime
  --toujours sur l'ambiance, et AVANT le dialogue de chapitre, qui
  --reste le repli.
  if TownLife.TOURNEES['Wooper_Girl'] ~= nil and TownLife.Parler(chara, 'Wooper_Girl') then return end
  local s = Ch6State()
  if s == "post" then
    GeneralFunctions.StartConversation(chara, "Chenipent m'a raconte que vous l'aviez porte sur votre dos ![pause=15] C'est vrai ?", "Happy")
  else
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_063']), "Sad")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Wooper_Boy_Action(chara, activator)
  --LA VILLE PARLE DE LA NUIT. Reaction au dernier raid, si la ville en
  --porte encore la trace. Une seule fois par journee, puis on rend la
  --main au dialogue de chapitre : rien n'est perdu.
  if TownVoicesNight.Talk('Wooper_Boy') then return end
  -- Voix de ville reactive a l'avancement (cf. TownVoices.lua).
  -- APRES SideQuests : une requete prime toujours sur l'ambiance.
  if TownVoices.Talk('Wooper_Boy', 6) then return end
  --LA VIE QUOTIDIENNE. Le propos du jour depend du poste qu'occupe
  --l'habitant aujourd'hui (halcyon.TownLife) : il parle de la ou il
  --est, et pas la meme chose d'un jour a l'autre. Place APRES les
  --voix evenementielles (nuit, avancement) : un evenement prime
  --toujours sur l'ambiance, et AVANT le dialogue de chapitre, qui
  --reste le repli.
  if TownLife.TOURNEES['Wooper_Boy'] ~= nil and TownLife.Parler(chara, 'Wooper_Boy') then return end
  if Ch6State() == "post" then
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_075']), "Shock")
  else
    GeneralFunctions.StartConversation(chara, "La foret fait peur...[pause=30] Vous n'avez pas peur, vous ?", "Worried")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Nidorina_Action(chara, activator)
  --LA VILLE PARLE DE LA NUIT. Reaction au dernier raid, si la ville en
  --porte encore la trace. Une seule fois par journee, puis on rend la
  --main au dialogue de chapitre : rien n'est perdu.
  if TownVoicesNight.Talk('Nidorina') then return end
  -- Voix de ville reactive a l'avancement (cf. TownVoices.lua).
  -- APRES SideQuests : une requete prime toujours sur l'ambiance.
  if TownVoices.Talk('Nidorina', 6) then return end
  --LA VIE QUOTIDIENNE. Le propos du jour depend du poste qu'occupe
  --l'habitant aujourd'hui (halcyon.TownLife) : il parle de la ou il
  --est, et pas la meme chose d'un jour a l'autre. Place APRES les
  --voix evenementielles (nuit, avancement) : un evenement prime
  --toujours sur l'ambiance, et AVANT le dialogue de chapitre, qui
  --reste le repli.
  if TownLife.TOURNEES['Nidorina'] ~= nil and TownLife.Parler(chara, 'Nidorina') then return end
  local s = Ch6State()
  if s == "post" then
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_069']), "Happy")
  else
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_067']), "Normal")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Nidoran_Male_Action(chara, activator)
  --LA VILLE PARLE DE LA NUIT. Reaction au dernier raid, si la ville en
  --porte encore la trace. Une seule fois par journee, puis on rend la
  --main au dialogue de chapitre : rien n'est perdu.
  if TownVoicesNight.Talk('Nidoran_Male') then return end
  if Ch6State() == "post" then
    GeneralFunctions.StartConversation(chara, "Ma soeur veut etre comme vous.[pause=20] Moi aussi.[pause=25] Mais je le dirai pas.", "Normal")
  else
    GeneralFunctions.StartConversation(chara, "Allez-y ![pause=15] Sauvez Chenipent ![pause=20] Et revenez vite !", "Determined")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Nidoking_Action(chara, activator)
  --LA VILLE PARLE DE LA NUIT. Reaction au dernier raid, si la ville en
  --porte encore la trace. Une seule fois par journee, puis on rend la
  --main au dialogue de chapitre : rien n'est perdu.
  if TownVoicesNight.Talk('Nidoking') then return end
  -- Voix de ville reactive a l'avancement (cf. TownVoices.lua).
  -- APRES SideQuests : une requete prime toujours sur l'ambiance.
  if TownVoices.Talk('Nidoking', 6) then return end
  --LA VIE QUOTIDIENNE. Le propos du jour depend du poste qu'occupe
  --l'habitant aujourd'hui (halcyon.TownLife) : il parle de la ou il
  --est, et pas la meme chose d'un jour a l'autre. Place APRES les
  --voix evenementielles (nuit, avancement) : un evenement prime
  --toujours sur l'ambiance, et AVANT le dialogue de chapitre, qui
  --reste le repli.
  if TownLife.TOURNEES['Nidoking'] ~= nil and TownLife.Parler(chara, 'Nidoking') then return end
  local s = Ch6State()
  if s == "post" then
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_079']), "Happy")
  else
    GeneralFunctions.StartConversation(chara, "Protegez les petits.[pause=25] C'est tout ce qui compte.", "Determined")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Azumarill_Action(chara, activator)
  --LA CONFRONTATION DE LA PLACE. Si le joueur y etait, ce temoin a
  --SA replique sur ce qu'il a vu, differente selon l'issue du combat.
  --Elle prime sur tout le reste, puis la cascade habituelle reprend.
  if DazzlingPlaza.Temoin('Azumarill') then return end
  --LA VILLE PARLE DE LA NUIT. Reaction au dernier raid, si la ville en
  --porte encore la trace. Une seule fois par journee, puis on rend la
  --main au dialogue de chapitre : rien n'est perdu.
  if TownVoicesNight.Talk('Azumarill') then return end
  local s = Ch6State()
  if s == "post" then
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_084']), "Normal")
  else
    GeneralFunctions.StartConversation(chara, "La riviere est calme aujourd'hui.[pause=20] Trop calme.", "Worried")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Gulpin_Action(chara, activator)
  --LA VILLE PARLE DE LA NUIT. Reaction au dernier raid, si la ville en
  --porte encore la trace. Une seule fois par journee, puis on rend la
  --main au dialogue de chapitre : rien n'est perdu.
  if TownVoicesNight.Talk('Gulpin') then return end
  -- Voix de ville reactive a l'avancement (cf. TownVoices.lua).
  -- APRES SideQuests : une requete prime toujours sur l'ambiance.
  if TownVoices.Talk('Gulpin', 6) then return end
  --LA VIE QUOTIDIENNE. Le propos du jour depend du poste qu'occupe
  --l'habitant aujourd'hui (halcyon.TownLife) : il parle de la ou il
  --est, et pas la meme chose d'un jour a l'autre. Place APRES les
  --voix evenementielles (nuit, avancement) : un evenement prime
  --toujours sur l'ambiance, et AVANT le dialogue de chapitre, qui
  --reste le repli.
  if TownLife.TOURNEES['Gulpin'] ~= nil and TownLife.Parler(chara, 'Gulpin') then return end
  if Ch6State() == "post" then
    GeneralFunctions.StartConversation(chara, "Un festin ![pause=15] Il faut celebrer ca avec un festin ![pause=20] Qui paye ?", "Happy")
  else
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_068']), "Worried")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Lickitung_Action(chara, activator)
  --LA VILLE PARLE DE LA NUIT. Reaction au dernier raid, si la ville en
  --porte encore la trace. Une seule fois par journee, puis on rend la
  --main au dialogue de chapitre : rien n'est perdu.
  if TownVoicesNight.Talk('Lickitung') then return end
  -- Voix de ville reactive a l'avancement (cf. TownVoices.lua).
  -- APRES SideQuests : une requete prime toujours sur l'ambiance.
  if TownVoices.Talk('Lickitung', 6) then return end
  --LA VIE QUOTIDIENNE. Le propos du jour depend du poste qu'occupe
  --l'habitant aujourd'hui (halcyon.TownLife) : il parle de la ou il
  --est, et pas la meme chose d'un jour a l'autre. Place APRES les
  --voix evenementielles (nuit, avancement) : un evenement prime
  --toujours sur l'ambiance, et AVANT le dialogue de chapitre, qui
  --reste le repli.
  if TownLife.TOURNEES['Lickitung'] ~= nil and TownLife.Parler(chara, 'Lickitung') then return end
  if Ch6State() == "post" then
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_093']), "Happy")
  else
    GeneralFunctions.StartConversation(chara, "Le Cafe a un nouveau jus de Baie Mepris.[pause=25] Pour se donner du courage.", "Normal")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Roselia_Action(chara, activator)
  --LA VILLE PARLE DE LA NUIT. Reaction au dernier raid, si la ville en
  --porte encore la trace. Une seule fois par journee, puis on rend la
  --main au dialogue de chapitre : rien n'est perdu.
  if TownVoicesNight.Talk('Roselia') then return end
  -- Requetes de Metano : elles doivent etre rendues avant que la guilde
  -- lance l'expedition suivante (cf. SideQuests.lua). Si le PNJ n'a rien
  -- a dire sur une requete, on retombe sur son dialogue habituel.
  if SideQuests.Interact('Roselia', 6) then return end
  -- Voix de ville reactive a l'avancement (cf. TownVoices.lua).
  -- APRES SideQuests : une requete prime toujours sur l'ambiance.
  if TownVoices.Talk('Roselia', 6) then return end
  --LA VIE QUOTIDIENNE. Le propos du jour depend du poste qu'occupe
  --l'habitant aujourd'hui (halcyon.TownLife) : il parle de la ou il
  --est, et pas la meme chose d'un jour a l'autre. Place APRES les
  --voix evenementielles (nuit, avancement) : un evenement prime
  --toujours sur l'ambiance, et AVANT le dialogue de chapitre, qui
  --reste le repli.
  if TownLife.TOURNEES['Roselia'] ~= nil and TownLife.Parler(chara, 'Roselia') then return end
  if Ch6State() == "post" then
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_081']), "Happy")
  else
    GeneralFunctions.StartConversation(chara, "Mes epines sont affutees.[pause=20] Mais la foret...[pause=25] elle est plus tranchante.", "Worried")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Spinda_Action(chara, activator)
  --LA VILLE PARLE DE LA NUIT. Reaction au dernier raid, si la ville en
  --porte encore la trace. Une seule fois par journee, puis on rend la
  --main au dialogue de chapitre : rien n'est perdu.
  if TownVoicesNight.Talk('Spinda') then return end
  -- Voix de ville reactive a l'avancement (cf. TownVoices.lua).
  -- APRES SideQuests : une requete prime toujours sur l'ambiance.
  if TownVoices.Talk('Spinda', 6) then return end
  --LA VIE QUOTIDIENNE. Le propos du jour depend du poste qu'occupe
  --l'habitant aujourd'hui (halcyon.TownLife) : il parle de la ou il
  --est, et pas la meme chose d'un jour a l'autre. Place APRES les
  --voix evenementielles (nuit, avancement) : un evenement prime
  --toujours sur l'ambiance, et AVANT le dialogue de chapitre, qui
  --reste le repli.
  if TownLife.TOURNEES['Spinda'] ~= nil and TownLife.Parler(chara, 'Spinda') then return end
  if Ch6State() == "post" then
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_093']), "Happy")
  else
    GeneralFunctions.StartConversation(chara, "Un cafe avant de partir ?[pause=15] Pour la route ?[pause=25] Je vous l'offre !", "Happy")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Ludicolo_Action(chara, activator)
  --LA VILLE PARLE DE LA NUIT. Reaction au dernier raid, si la ville en
  --porte encore la trace. Une seule fois par journee, puis on rend la
  --main au dialogue de chapitre : rien n'est perdu.
  if TownVoicesNight.Talk('Ludicolo') then return end
  -- Voix de ville reactive a l'avancement (cf. TownVoices.lua).
  -- APRES SideQuests : une requete prime toujours sur l'ambiance.
  if TownVoices.Talk('Ludicolo', 6) then return end
  --LA VIE QUOTIDIENNE. Le propos du jour depend du poste qu'occupe
  --l'habitant aujourd'hui (halcyon.TownLife) : il parle de la ou il
  --est, et pas la meme chose d'un jour a l'autre. Place APRES les
  --voix evenementielles (nuit, avancement) : un evenement prime
  --toujours sur l'ambiance, et AVANT le dialogue de chapitre, qui
  --reste le repli.
  if TownLife.TOURNEES['Ludicolo'] ~= nil and TownLife.Parler(chara, 'Ludicolo') then return end
  if Ch6State() == "post" then
    GeneralFunctions.StartConversation(chara, "La musique est plus joyeuse aujourd'hui ![pause=15] Vous voulez danser ?", "Happy")
  else
    GeneralFunctions.StartConversation(chara, "La pluie va tomber.[pause=25] Je le sens dans mes os.", "Normal")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Jigglypuff_Action(chara, activator)
  --LA VILLE PARLE DE LA NUIT. Reaction au dernier raid, si la ville en
  --porte encore la trace. Une seule fois par journee, puis on rend la
  --main au dialogue de chapitre : rien n'est perdu.
  if TownVoicesNight.Talk('Jigglypuff') then return end
  -- Voix de ville reactive a l'avancement (cf. TownVoices.lua).
  -- APRES SideQuests : une requete prime toujours sur l'ambiance.
  if TownVoices.Talk('Jigglypuff', 6) then return end
  --LA VIE QUOTIDIENNE. Le propos du jour depend du poste qu'occupe
  --l'habitant aujourd'hui (halcyon.TownLife) : il parle de la ou il
  --est, et pas la meme chose d'un jour a l'autre. Place APRES les
  --voix evenementielles (nuit, avancement) : un evenement prime
  --toujours sur l'ambiance, et AVANT le dialogue de chapitre, qui
  --reste le repli.
  if TownLife.TOURNEES['Jigglypuff'] ~= nil and TownLife.Parler(chara, 'Jigglypuff') then return end
  if Ch6State() == "post" then
    GeneralFunctions.StartConversation(chara, "Je vous chante une berceuse ?[pause=20] Pour feter votre victoire ?", "Happy")
  else
    GeneralFunctions.StartConversation(chara, "Je peux vous endormir avant la mission...[pause=30] Non ?[pause=15] Dommage.", "Normal")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Marill_Action(chara, activator)
  --LA CONFRONTATION DE LA PLACE. Si le joueur y etait, ce temoin a
  --SA replique sur ce qu'il a vu, differente selon l'issue du combat.
  --Elle prime sur tout le reste, puis la cascade habituelle reprend.
  if DazzlingPlaza.Temoin('Marill') then return end
  --LA VILLE PARLE DE LA NUIT. Reaction au dernier raid, si la ville en
  --porte encore la trace. Une seule fois par journee, puis on rend la
  --main au dialogue de chapitre : rien n'est perdu.
  if TownVoicesNight.Talk('Marill') then return end
  -- Requetes de Metano : elles doivent etre rendues avant que la guilde
  -- lance l'expedition suivante (cf. SideQuests.lua). Si le PNJ n'a rien
  -- a dire sur une requete, on retombe sur son dialogue habituel.
  if SideQuests.Interact('Marill', 6) then return end
  -- Voix de ville reactive a l'avancement (cf. TownVoices.lua).
  -- APRES SideQuests : une requete prime toujours sur l'ambiance.
  if TownVoices.Talk('Marill', 6) then return end
  --LA VIE QUOTIDIENNE. Le propos du jour depend du poste qu'occupe
  --l'habitant aujourd'hui (halcyon.TownLife) : il parle de la ou il
  --est, et pas la meme chose d'un jour a l'autre. Place APRES les
  --voix evenementielles (nuit, avancement) : un evenement prime
  --toujours sur l'ambiance, et AVANT le dialogue de chapitre, qui
  --reste le repli.
  if TownLife.TOURNEES['Marill'] ~= nil and TownLife.Parler(chara, 'Marill') then return end
  if Ch6State() == "post" then
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_070']), "Happy")
  else
    GeneralFunctions.StartConversation(chara, "J'aimerais pouvoir vous aider.[pause=25] Mais je suis trop petit.", "Sad")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Spheal_Action(chara, activator)
  --LA VILLE PARLE DE LA NUIT. Reaction au dernier raid, si la ville en
  --porte encore la trace. Une seule fois par journee, puis on rend la
  --main au dialogue de chapitre : rien n'est perdu.
  if TownVoicesNight.Talk('Spheal') then return end
  if Ch6State() == "post" then
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_078']), "Happy")
  else
    GeneralFunctions.StartConversation(chara, "Roulez, roulez jusqu'a la foret ![pause=10] Enfin, pas moi. Vous.", "Normal")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Bagon_Action(chara, activator)
  --LA VILLE PARLE DE LA NUIT. Reaction au dernier raid, si la ville en
  --porte encore la trace. Une seule fois par journee, puis on rend la
  --main au dialogue de chapitre : rien n'est perdu.
  if TownVoicesNight.Talk('Bagon') then return end
  if Ch6State() == "post" then
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_076']), "Inspired")
  else
    GeneralFunctions.StartConversation(chara, "Un jour, je volerai ![pause=15] Et je pourrai vous aider !", "Determined")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Doduo_Action(chara, activator)
  --LA VILLE PARLE DE LA NUIT. Reaction au dernier raid, si la ville en
  --porte encore la trace. Une seule fois par journee, puis on rend la
  --main au dialogue de chapitre : rien n'est perdu.
  if TownVoicesNight.Talk('Doduo') then return end
  if Ch6State() == "post" then
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_077']), "Normal")
  else
    GeneralFunctions.StartConversation(chara, "Courir, toujours courir.[pause=20] C'est comme ca qu'on avance.", "Normal")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Metapod_Action(chara, activator)
  --LA VILLE PARLE DE LA NUIT. Reaction au dernier raid, si la ville en
  --porte encore la trace. Une seule fois par journee, puis on rend la
  --main au dialogue de chapitre : rien n'est perdu.
  if TownVoicesNight.Talk('Metapod') then return end
  -- Voix de ville reactive a l'avancement (cf. TownVoices.lua).
  -- APRES SideQuests : une requete prime toujours sur l'ambiance.
  if TownVoices.Talk('Metapod', 6) then return end
  --LA VIE QUOTIDIENNE. Le propos du jour depend du poste qu'occupe
  --l'habitant aujourd'hui (halcyon.TownLife) : il parle de la ou il
  --est, et pas la meme chose d'un jour a l'autre. Place APRES les
  --voix evenementielles (nuit, avancement) : un evenement prime
  --toujours sur l'ambiance, et AVANT le dialogue de chapitre, qui
  --reste le repli.
  if TownLife.TOURNEES['Metapod'] ~= nil and TownLife.Parler(chara, 'Metapod') then return end
  if Ch6State() == "post" then
    GeneralFunctions.StartConversation(chara, "...[pause=30] (Metapod semble plus brillant qu'avant.)", "Normal")
  else
    GeneralFunctions.StartConversation(chara, "...[pause=40] (Metapod vous fixe sans cligner.)", "Normal")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Silcoon_Action(chara, activator)
  --LA VILLE PARLE DE LA NUIT. Reaction au dernier raid, si la ville en
  --porte encore la trace. Une seule fois par journee, puis on rend la
  --main au dialogue de chapitre : rien n'est perdu.
  if TownVoicesNight.Talk('Silcoon') then return end
  -- Voix de ville reactive a l'avancement (cf. TownVoices.lua).
  -- APRES SideQuests : une requete prime toujours sur l'ambiance.
  if TownVoices.Talk('Silcoon', 6) then return end
  --LA VIE QUOTIDIENNE. Le propos du jour depend du poste qu'occupe
  --l'habitant aujourd'hui (halcyon.TownLife) : il parle de la ou il
  --est, et pas la meme chose d'un jour a l'autre. Place APRES les
  --voix evenementielles (nuit, avancement) : un evenement prime
  --toujours sur l'ambiance, et AVANT le dialogue de chapitre, qui
  --reste le repli.
  if TownLife.TOURNEES['Silcoon'] ~= nil and TownLife.Parler(chara, 'Silcoon') then return end
  if Ch6State() == "post" then
    GeneralFunctions.StartConversation(chara, "Chenipent est passe me voir ![pause=15] Il m'a parle de vous.", "Happy")
  else
    GeneralFunctions.StartConversation(chara, "Papilusion est ma voisine.[pause=20] Aidez-la,[pause=10] s'il vous plait.", "Worried")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Mareep_Action(chara, activator)
  --LA VILLE PARLE DE LA NUIT. Reaction au dernier raid, si la ville en
  --porte encore la trace. Une seule fois par journee, puis on rend la
  --main au dialogue de chapitre : rien n'est perdu.
  if TownVoicesNight.Talk('Mareep') then return end
  -- Voix de ville reactive a l'avancement (cf. TownVoices.lua).
  -- APRES SideQuests : une requete prime toujours sur l'ambiance.
  if TownVoices.Talk('Mareep', 6) then return end
  --LA VIE QUOTIDIENNE. Le propos du jour depend du poste qu'occupe
  --l'habitant aujourd'hui (halcyon.TownLife) : il parle de la ou il
  --est, et pas la meme chose d'un jour a l'autre. Place APRES les
  --voix evenementielles (nuit, avancement) : un evenement prime
  --toujours sur l'ambiance, et AVANT le dialogue de chapitre, qui
  --reste le repli.
  if TownLife.TOURNEES['Mareep'] ~= nil and TownLife.Parler(chara, 'Mareep') then return end
  if Ch6State() == "post" then
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_098']), "Worried")
  else
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_063']), "Sad")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Cranidos_Action(chara, activator)
  --LA VILLE PARLE DE LA NUIT. Reaction au dernier raid, si la ville en
  --porte encore la trace. Une seule fois par journee, puis on rend la
  --main au dialogue de chapitre : rien n'est perdu.
  if TownVoicesNight.Talk('Cranidos') then return end
  -- Voix de ville reactive a l'avancement (cf. TownVoices.lua).
  -- APRES SideQuests : une requete prime toujours sur l'ambiance.
  if TownVoices.Talk('Cranidos', 6) then return end
  --LA VIE QUOTIDIENNE. Le propos du jour depend du poste qu'occupe
  --l'habitant aujourd'hui (halcyon.TownLife) : il parle de la ou il
  --est, et pas la meme chose d'un jour a l'autre. Place APRES les
  --voix evenementielles (nuit, avancement) : un evenement prime
  --toujours sur l'ambiance, et AVANT le dialogue de chapitre, qui
  --reste le repli.
  if TownLife.TOURNEES['Cranidos'] ~= nil and TownLife.Parler(chara, 'Cranidos') then return end
  if Ch6State() == "post" then
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_095']), "Normal")
  else
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_062']), "Angry")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Snubbull_Action(chara, activator)
  --LA VILLE PARLE DE LA NUIT. Reaction au dernier raid, si la ville en
  --porte encore la trace. Une seule fois par journee, puis on rend la
  --main au dialogue de chapitre : rien n'est perdu.
  if TownVoicesNight.Talk('Snubbull') then return end
  if Ch6State() == "post" then
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_085']), "Inspired")
  else
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_057']), "Normal")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Audino_Action(chara, activator)
  --LA VILLE PARLE DE LA NUIT. Reaction au dernier raid, si la ville en
  --porte encore la trace. Une seule fois par journee, puis on rend la
  --main au dialogue de chapitre : rien n'est perdu.
  if TownVoicesNight.Talk('Audino') then return end
  if Ch6State() == "post" then
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_092']), "Happy")
  else
    GeneralFunctions.StartConversation(chara, "Prenez des Baies Oran.[pause=15] Et des Baies Sitrus.[pause=25] Et... prenez tout.", "Worried")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Zigzagoon_Action(chara, activator)
  --LA VILLE PARLE DE LA NUIT. Reaction au dernier raid, si la ville en
  --porte encore la trace. Une seule fois par journee, puis on rend la
  --main au dialogue de chapitre : rien n'est perdu.
  if TownVoicesNight.Talk('Zigzagoon') then return end
  -- Requetes de Metano : elles doivent etre rendues avant que la guilde
  -- lance l'expedition suivante (cf. SideQuests.lua). Si le PNJ n'a rien
  -- a dire sur une requete, on retombe sur son dialogue habituel.
  if SideQuests.Interact('Zigzagoon', 6) then return end
  if Ch6State() == "post" then
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_094']), "Happy")
  else
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_064'], CH('PLAYER'):GetDisplayName(), CH('Teammate1'):GetDisplayName()), "Determined")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Growlithe_Desk_Action(chara, activator)
  if Ch6State() == "post" then
    GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_091']), "Normal")
  else
    GeneralFunctions.StartConversation(chara, "La guilde vous soutient.[pause=15] Toujours. N'oubliez jamais ca.", "Determined")
  end
  GeneralFunctions.EndConversation(chara)
end


-- ============================================================
-- CINEMATIQUE DEFAITE — Team Dazzling se moque du joueur
-- Joue quand le joueur revient en ville apres avoir perdu contre Zeraora
-- ============================================================
function metano_town_ch_6.PostDefeatCutscene()
	if SV.Chapter6.PostDefeatScenePlayed ~= false then return end
	if not SV.Chapter6.DefeatedByZeraora then return end
	if SV.Chapter6.MissionComplete then return end
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local adagio = CH('Adagio')
	local aria = CH('Aria')
	local sonata = CH('Sonata')
	local mawile = CH('Mawile')
	local floatzel = CH('Floatzel')
	local quagsire = CH('Quagsire')
	local luxray = CH('Luxray')

	SOUND:PlayBGM('Team_Dazzling_Theme.ogg', true)
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	AI:DisableCharacterAI(adagio)
	AI:DisableCharacterAI(aria)
	AI:DisableCharacterAI(sonata)
	GAME:MoveCamera(896, 816, 1, false)

	-- Le heros et partenaire arrivent, tete basse
	GAME:WaitFrames(10)
	GROUND:CharSetEmote(partner, "sweating", 1)
	GAME:WaitFrames(10)
	GROUND:CharSetEmote(hero, "sweatdrop", 1)
	GAME:WaitFrames(20)

	-- Team Dazzling arrive deja au courant
	local c1 = TASK:BranchCoroutine(function()
		GROUND:MoveToPosition(adagio, 1008, 784, false, 1)
		GROUND:CharAnimateTurnTo(adagio, Direction.DownLeft, 4)
	end)
	local c2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(8)
		GROUND:MoveToPosition(aria, 1040, 816, false, 1)
		GROUND:CharAnimateTurnTo(aria, Direction.Left, 4)
	end)
	local c3 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(16)
		GROUND:MoveToPosition(sonata, 1072, 848, false, 1)
		GROUND:CharAnimateTurnTo(sonata, Direction.Left, 4)
	end)
	TASK:JoinCoroutines({c1, c2, c3})

	-- La foule regarde, genee
	GROUND:CharAnimateTurnTo(mawile, Direction.UpLeft, 4)
	GROUND:CharSetEmote(mawile, "question", 1)
	GROUND:CharAnimateTurnTo(floatzel, Direction.Up, 4)
	GROUND:CharSetEmote(floatzel, "sweating", 1)
	GROUND:CharAnimateTurnTo(quagsire, Direction.UpRight, 4)
	GROUND:CharSetEmote(quagsire, "sad", 1)

	-- Aria se moque
	SOUND:PlayBattleSE("EVT_Emote_Exclaim_2")
	UI:SetSpeaker(aria)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_102']))
	GeneralFunctions.Hop(aria, "None", 4, 4, true, true)

	-- Sonata rencherit
	UI:SetSpeaker(sonata)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_103']))

	-- Le partenaire explose
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Angry")
	GROUND:CharSetEmote(partner, "angry", 1)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_104']))

	-- Adagio, glaciale
	UI:SetSpeaker(adagio)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_105']))
	GeneralFunctions.SetEmotion("Sigh")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_106']))

	-- Aria, coup de grace
	UI:SetSpeaker(aria)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_107']))

	-- Luxray intervient
	if luxray then
		GROUND:CharAnimateTurnTo(luxray, Direction.Up, 4)
		GROUND:CharSetEmote(luxray, "notice", 1)
		UI:SetSpeaker(luxray)
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_108']))
	end

	-- Adagio conclut
	UI:SetSpeaker(adagio)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_109']))

	-- Elles repartent
	local d1 = TASK:BranchCoroutine(function()
		GROUND:MoveToPosition(aria, 1120, 816, false, 1)
		GROUND:CharAnimateTurnTo(aria, Direction.Right, 4)
	end)
	local d2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(8)
		GROUND:MoveToPosition(sonata, 1152, 848, false, 1)
		GROUND:CharAnimateTurnTo(sonata, Direction.Right, 4)
	end)
	local d3 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(16)
		GROUND:MoveToPosition(adagio, 1080, 784, false, 1)
		GROUND:CharAnimateTurnTo(adagio, Direction.Right, 4)
	end)
	TASK:JoinCoroutines({d1, d2, d3})

	-- Village glace, gene
	GROUND:CharAnimateTurnTo(mawile, Direction.Down, 4)
	GROUND:CharSetEmote(mawile, "sweating", 1)
	UI:SetSpeaker(mawile)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_110']))

	-- Le partenaire, resolu
	GROUND:CharSetEmote(partner, "determined", 1)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_111'], hero:GetDisplayName()))

	SV.Chapter6.PostDefeatScenePlayed = true
	GAME:WaitFrames(20)
	GAME:CutsceneMode(false)
	RestorePartnerAI(partner)
	AI:SetCharacterAI(adagio, "halcyon.ai.ground_talking", false, 240, 60, 0, false, 'Default', {aria, sonata})
	AI:SetCharacterAI(aria, "halcyon.ai.ground_talking", false, 240, 60, 60, false, 'Default', {adagio, sonata})
	AI:SetCharacterAI(sonata, "halcyon.ai.ground_talking", false, 240, 60, 120, false, 'Default', {adagio, aria})
	SOUND:PlayBGM('Treasure Town.ogg', true)
end







function metano_town_ch_6.Mawile_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est une magnifique journée d'histoire.", "Normal")
  UI:WaitShowDialogue("Le Chapitre 6 est plein d'aventures et de rumeurs mystérieuses dans la Forêt Lugubre.")
  UI:WaitShowDialogue("Certains disent avoir vu une ombre gigantesque courir à travers les lianes...")
  UI:WaitShowDialogue("...Serait-ce le terrible Zeraora ? Personne n'ose s'en approcher de trop près.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Forêt Lugubre", "La Team Dazzling", "L'expédition", "Rien"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Forêt Lugubre est située juste au nord du village. L'air y est très lourd.")
    UI:WaitShowDialogue("On raconte que les arbres bougent tout seuls et que les lianes emprisonnent les intrus.")
    UI:WaitShowDialogue("Si vous y entrez, restez sur vos gardes. Ne laissez jamais votre partenaire seul.")
    UI:WaitShowDialogue("Et surtout... méfiez-vous du cri de la jungle. Il annonce la colère de son roi.")
    UI:WaitShowDialogue("Je crois que même la guilde n'a pas encore cartographié tout le donjon.")
    UI:WaitShowDialogue("Mais avec votre courage, je sais que vous pourrez y arriver et sauver le petit !")
  elseif choice == 2 then
    UI:WaitShowDialogue("La Team Dazzling... Elles sont arrivées de la côte il y a quelques jours seulement.")
    UI:WaitShowDialogue("Adagio est si polie mais on sent toute sa supériorité dans ses paroles.")
    UI:WaitShowDialogue("Aria est très provocatrice, elle passe son temps à sauter de joie et à se moquer.")
    UI:WaitShowDialogue("Et Sonata... elle est tellement théâtrale avec ses mimiques et ses colères !")
    UI:WaitShowDialogue("Elles se croient déjà au sommet, prétendant que ce sauvetage n'est qu'un jeu pour elles.")
    UI:WaitShowDialogue("Ne les laissez pas vous intimider. Montrez-leur de quel bois vous vous chauffez !")
    UI:WaitShowDialogue("Toute la ville attend de voir qui ramènera le Chenipent en premier.")
  elseif choice == 3 then
    UI:WaitShowDialogue("L'expédition du Mont Venteux... C'était une aventure extraordinaire.")
    UI:WaitShowDialogue("Vous avez gravi les sommets, traversé les tempêtes et affronté le Seigneur des Vents.")
    UI:WaitShowDialogue("Le doyen Penticus m'a dit que votre exploit résonnera longtemps à la guilde.")
    UI:WaitShowDialogue("Mais ce n'était que le début de l'histoire, je le ressens au fond de mes os.")
    UI:WaitShowDialogue("Les flux d'énergie continuent de s'agiter sous la terre, de plus en plus chauds.")
    UI:WaitShowDialogue("Restez forts, mes amis. Le monde a plus que jamais besoin de héros.")
  else
    UI:WaitShowDialogue("D'accord. Prenez soin de vous sur les sentiers et dans les donjons.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Mawile_GossipTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Oh, vous revoilà ! J'ai encore entendu d'étranges rumeurs...", "Normal")
  UI:WaitShowDialogue("On dit que la Team Dazzling n'est pas là pour faire du secours, mais pour un secret...")
  UI:WaitShowDialogue("Elles fouillent les recoins du village et de la guilde, murmurant entre elles.")
  UI:WaitShowDialogue("Même les marchands du marché les trouvent suspectes, malgré leur éclat.")
  UI:WaitShowDialogue("Qu'en pensez-vous ? Pensez-vous qu'elles complotent quelque chose de louche ?")
  UI:BeginChoiceMenu("Que lui dites-vous ?", {"Elles complotent", "Elles sont juste fières", "Je ne sais pas"}, 1, 3)
  UI:WaitForChoice()
  local result = UI:ChoiceResult()
  if result == 1 then
    UI:WaitShowDialogue("Je le savais ! Leurs mines mystérieuses et leurs messes basses ne trompent personne.")
    UI:WaitShowDialogue("Même le Doyen Penticus les surveille du coin de l'œil, je l'ai vu hier.")
    UI:WaitShowDialogue("Faites bien attention si vous les croisez dans la Forêt Lugubre.")
  elseif result == 2 then
    UI:WaitShowDialogue("C'est possible. Les équipes de la côte ont toujours cette fierté un peu agaçante.")
    UI:WaitShowDialogue("Après tout, elles ont une grande réputation à tenir, mais quand même...")
    UI:WaitShowDialogue("Ne relâchez pas votre attention pour autant. On ne sait jamais.")
  else
    UI:WaitShowDialogue("La prudence est mère de sûreté, comme on dit toujours à la guilde.")
    UI:WaitShowDialogue("Nous verrons bien ce que l'avenir nous réserve. Restons concentrés.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Mawile_RaidTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous entendu les rumeurs sur les pilleurs nocturnes ?", "Worried")
  UI:WaitShowDialogue("On dit que des spectres rodent dans les ombres de la ville dès que la nuit tombe...")
  UI:WaitShowDialogue("Ils forcent les coffres, pillent les stands et s'enfuient sans laisser de traces.")
  UI:WaitShowDialogue("La place entière retient son souffle dès que le soleil se couche.")
  UI:WaitShowDialogue("Si vous veillez de nuit, soyez extrêmement prudents. Ils sont redoutables.")
  UI:WaitShowDialogue("Mais je sais que votre équipe a le courage de défendre notre ville de Metano !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Mawile_PrepTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avant de repartir en mission, assurez-vous d'être bien préparés !", "Normal")
  UI:WaitShowDialogue("La Forêt Lugubre ne pardonne pas le manque d'organisation.")
  UI:WaitShowDialogue("Prenez toujours des Baies Oran, des Baies Ceriz et des Échapporbes en cas de besoin.")
  UI:WaitShowDialogue("L'entrepôt de la guilde est là pour stocker vos trésors précieux.")
  UI:WaitShowDialogue("Même l'équipe la plus forte peut faillir sans un bon équipement.")
  UI:WaitShowDialogue("Faites-moi confiance, la préparation est la clé de toute grande aventure !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Mawile_RelaxTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'ambiance au café est si relaxante en ce moment...", "Normal")
  UI:WaitShowDialogue("C'est l'endroit idéal pour faire une pause et discuter avec les autres.")
  UI:WaitShowDialogue("Après une longue journée dans les donjons, rien ne vaut une bonne boisson chaude.")
  UI:WaitShowDialogue("Même les rumeurs les plus folles se partagent ici autour d'une table.")
  UI:WaitShowDialogue("Prenez le temps de souffler un peu avant de retourner affronter la jungle.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Mawile_DazzlingChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, que pensez-vous de chaque membre des Dazzling ?", "Normal")
  UI:BeginChoiceMenu("Qui souhaitez-vous évaluer ?", {"Adagio", "Aria", "Sonata", "Toutes"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Adagio est d'une élégance rare, mais ses yeux brillent d'une ambition froide.")
  elseif res == 2 then
    UI:WaitShowDialogue("Aria ne fait que s'exciter et provoquer tout le monde. C'est insupportable.")
  elseif res == 3 then
    UI:WaitShowDialogue("Sonata est tellement théâtrale ! Ses grands gestes amusent la galerie.")
  else
    UI:WaitShowDialogue("Elles forment un groupe redoutable. Ne sous-estimez jamais leur union.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Mawile_ExpeditionChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "L'expédition reste le plus grand événement de l'année !", "Normal")
  UI:WaitShowDialogue("Chacun de nous en garde un souvenir marquant et impérissable.")
  UI:WaitShowDialogue("Pour certains, c'était la première fois qu'ils voyaient de si grandes montagnes.")
  UI:WaitShowDialogue("Et pour vous, quel reste le plus beau souvenir de cette ascension ?")
  UI:BeginChoiceMenu("Votre moment favori :", {"Le feu de camp", "La tempête", "Le sommet"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Le feu de camp était si convivial, à partager des rumeurs au milieu de la nuit !")
  elseif res == 2 then
    UI:WaitShowDialogue("La tempête était terrifiante, mais elle a montré toute la force de notre guilde !")
  else
    UI:WaitShowDialogue("Le sommet Venteux était d'une majesté absolue. On y touchait le ciel !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Mawile_StoryDazzlingTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La Team Dazzling fait sensation à Metano Town...", "Normal")
  UI:WaitShowDialogue("Leurs voix magiques s'entendent jusqu'aux confins de la forêt.")
  UI:WaitShowDialogue("On dit qu'elles préparent un grand spectacle pour fêter leur prochaine victoire.")
  UI:WaitShowDialogue("Mais certains érudits pensent qu'il y a une magie ancienne derrière leur chant.")
  UI:WaitShowDialogue("Nous verrons bien si elles parviennent à apaiser le roi de la jungle !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Mawile_ExpeditionBivouacTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les récits de votre bivouac au Mont Venteux sont incroyables...", "Normal")
  UI:WaitShowDialogue("Dormir sous les étoiles, à l'écoute du chant mystique de la montagne...")
  UI:WaitShowDialogue("C'est le genre d'expérience qui forge l'âme d'un véritable aventurier.")
  UI:WaitShowDialogue("Toute la ville est fière de voir votre équipe progresser si vite !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Electrike_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est une magnifique journée d'histoire.", "Normal")
  UI:WaitShowDialogue("Le Chapitre 6 est plein d'aventures et de rumeurs mystérieuses dans la Forêt Lugubre.")
  UI:WaitShowDialogue("Certains disent avoir vu une ombre gigantesque courir à travers les lianes...")
  UI:WaitShowDialogue("...Serait-ce le terrible Zeraora ? Personne n'ose s'en approcher de trop près.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Forêt Lugubre", "La Team Dazzling", "L'expédition", "Rien"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Forêt Lugubre est située juste au nord du village. L'air y est très lourd.")
    UI:WaitShowDialogue("On raconte que les arbres bougent tout seuls et que les lianes emprisonnent les intrus.")
    UI:WaitShowDialogue("Si vous y entrez, restez sur vos gardes. Ne laissez jamais votre partenaire seul.")
    UI:WaitShowDialogue("Et surtout... méfiez-vous du cri de la jungle. Il annonce la colère de son roi.")
    UI:WaitShowDialogue("Je crois que même la guilde n'a pas encore cartographié tout le donjon.")
    UI:WaitShowDialogue("Mais avec votre courage, je sais que vous pourrez y arriver et sauver le petit !")
  elseif choice == 2 then
    UI:WaitShowDialogue("La Team Dazzling... Elles sont arrivées de la côte il y a quelques jours seulement.")
    UI:WaitShowDialogue("Adagio est si polie mais on sent toute sa supériorité dans ses paroles.")
    UI:WaitShowDialogue("Aria est très provocatrice, elle passe son temps à sauter de joie et à se moquer.")
    UI:WaitShowDialogue("Et Sonata... elle est tellement théâtrale avec ses mimiques et ses colères !")
    UI:WaitShowDialogue("Elles se croient déjà au sommet, prétendant que ce sauvetage n'est qu'un jeu pour elles.")
    UI:WaitShowDialogue("Ne les laissez pas vous intimider. Montrez-leur de quel bois vous vous chauffez !")
    UI:WaitShowDialogue("Toute la ville attend de voir qui ramènera le Chenipent en premier.")
  elseif choice == 3 then
    UI:WaitShowDialogue("L'expédition du Mont Venteux... C'était une aventure extraordinaire.")
    UI:WaitShowDialogue("Vous avez gravi les sommets, traversé les tempêtes et affronté le Seigneur des Vents.")
    UI:WaitShowDialogue("Le doyen Penticus m'a dit que votre exploit résonnera longtemps à la guilde.")
    UI:WaitShowDialogue("Mais ce n'était que le début de l'histoire, je le ressens au fond de mes os.")
    UI:WaitShowDialogue("Les flux d'énergie continuent de s'agiter sous la terre, de plus en plus chauds.")
    UI:WaitShowDialogue("Restez forts, mes amis. Le monde a plus que jamais besoin de héros.")
  else
    UI:WaitShowDialogue("D'accord. Prenez soin de vous sur les sentiers et dans les donjons.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Electrike_GossipTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Oh, vous revoilà ! J'ai encore entendu d'étranges rumeurs...", "Normal")
  UI:WaitShowDialogue("On dit que la Team Dazzling n'est pas là pour faire du secours, mais pour un secret...")
  UI:WaitShowDialogue("Elles fouillent les recoins du village et de la guilde, murmurant entre elles.")
  UI:WaitShowDialogue("Même les marchands du marché les trouvent suspectes, malgré leur éclat.")
  UI:WaitShowDialogue("Qu'en pensez-vous ? Pensez-vous qu'elles complotent quelque chose de louche ?")
  UI:BeginChoiceMenu("Que lui dites-vous ?", {"Elles complotent", "Elles sont juste fières", "Je ne sais pas"}, 1, 3)
  UI:WaitForChoice()
  local result = UI:ChoiceResult()
  if result == 1 then
    UI:WaitShowDialogue("Je le savais ! Leurs mines mystérieuses et leurs messes basses ne trompent personne.")
    UI:WaitShowDialogue("Même le Doyen Penticus les surveille du coin de l'œil, je l'ai vu hier.")
    UI:WaitShowDialogue("Faites bien attention si vous les croisez dans la Forêt Lugubre.")
  elseif result == 2 then
    UI:WaitShowDialogue("C'est possible. Les équipes de la côte ont toujours cette fierté un peu agaçante.")
    UI:WaitShowDialogue("Après tout, elles ont une grande réputation à tenir, mais quand même...")
    UI:WaitShowDialogue("Ne relâchez pas votre attention pour autant. On ne sait jamais.")
  else
    UI:WaitShowDialogue("La prudence est mère de sûreté, comme on dit toujours à la guilde.")
    UI:WaitShowDialogue("Nous verrons bien ce que l'avenir nous réserve. Restons concentrés.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Electrike_RaidTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous entendu les rumeurs sur les pilleurs nocturnes ?", "Worried")
  UI:WaitShowDialogue("On dit que des spectres rodent dans les ombres de la ville dès que la nuit tombe...")
  UI:WaitShowDialogue("Ils forcent les coffres, pillent les stands et s'enfuient sans laisser de traces.")
  UI:WaitShowDialogue("La place entière retient son souffle dès que le soleil se couche.")
  UI:WaitShowDialogue("Si vous veillez de nuit, soyez extrêmement prudents. Ils sont redoutables.")
  UI:WaitShowDialogue("Mais je sais que votre équipe a le courage de défendre notre ville de Metano !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Electrike_PrepTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avant de repartir en mission, assurez-vous d'être bien préparés !", "Normal")
  UI:WaitShowDialogue("La Forêt Lugubre ne pardonne pas le manque d'organisation.")
  UI:WaitShowDialogue("Prenez toujours des Baies Oran, des Baies Ceriz et des Échapporbes en cas de besoin.")
  UI:WaitShowDialogue("L'entrepôt de la guilde est là pour stocker vos trésors précieux.")
  UI:WaitShowDialogue("Même l'équipe la plus forte peut faillir sans un bon équipement.")
  UI:WaitShowDialogue("Faites-moi confiance, la préparation est la clé de toute grande aventure !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Electrike_RelaxTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'ambiance au café est si relaxante en ce moment...", "Normal")
  UI:WaitShowDialogue("C'est l'endroit idéal pour faire une pause et discuter avec les autres.")
  UI:WaitShowDialogue("Après une longue journée dans les donjons, rien ne vaut une bonne boisson chaude.")
  UI:WaitShowDialogue("Même les rumeurs les plus folles se partagent ici autour d'une table.")
  UI:WaitShowDialogue("Prenez le temps de souffler un peu avant de retourner affronter la jungle.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Electrike_DazzlingChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, que pensez-vous de chaque membre des Dazzling ?", "Normal")
  UI:BeginChoiceMenu("Qui souhaitez-vous évaluer ?", {"Adagio", "Aria", "Sonata", "Toutes"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Adagio est d'une élégance rare, mais ses yeux brillent d'une ambition froide.")
  elseif res == 2 then
    UI:WaitShowDialogue("Aria ne fait que s'exciter et provoquer tout le monde. C'est insupportable.")
  elseif res == 3 then
    UI:WaitShowDialogue("Sonata est tellement théâtrale ! Ses grands gestes amusent la galerie.")
  else
    UI:WaitShowDialogue("Elles forment un groupe redoutable. Ne sous-estimez jamais leur union.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Electrike_ExpeditionChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "L'expédition reste le plus grand événement de l'année !", "Normal")
  UI:WaitShowDialogue("Chacun de nous en garde un souvenir marquant et impérissable.")
  UI:WaitShowDialogue("Pour certains, c'était la première fois qu'ils voyaient de si grandes montagnes.")
  UI:WaitShowDialogue("Et pour vous, quel reste le plus beau souvenir de cette ascension ?")
  UI:BeginChoiceMenu("Votre moment favori :", {"Le feu de camp", "La tempête", "Le sommet"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Le feu de camp était si convivial, à partager des rumeurs au milieu de la nuit !")
  elseif res == 2 then
    UI:WaitShowDialogue("La tempête était terrifiante, mais elle a montré toute la force de notre guilde !")
  else
    UI:WaitShowDialogue("Le sommet Venteux était d'une majesté absolue. On y touchait le ciel !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Electrike_StoryDazzlingTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La Team Dazzling fait sensation à Metano Town...", "Normal")
  UI:WaitShowDialogue("Leurs voix magiques s'entendent jusqu'aux confins de la forêt.")
  UI:WaitShowDialogue("On dit qu'elles préparent un grand spectacle pour fêter leur prochaine victoire.")
  UI:WaitShowDialogue("Mais certains érudits pensent qu'il y a une magie ancienne derrière leur chant.")
  UI:WaitShowDialogue("Nous verrons bien si elles parviennent à apaiser le roi de la jungle !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Electrike_ExpeditionBivouacTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les récits de votre bivouac au Mont Venteux sont incroyables...", "Normal")
  UI:WaitShowDialogue("Dormir sous les étoiles, à l'écoute du chant mystique de la montagne...")
  UI:WaitShowDialogue("C'est le genre d'expérience qui forge l'âme d'un véritable aventurier.")
  UI:WaitShowDialogue("Toute la ville est fière de voir votre équipe progresser si vite !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Sentret_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est une magnifique journée d'histoire.", "Normal")
  UI:WaitShowDialogue("Le Chapitre 6 est plein d'aventures et de rumeurs mystérieuses dans la Forêt Lugubre.")
  UI:WaitShowDialogue("Certains disent avoir vu une ombre gigantesque courir à travers les lianes...")
  UI:WaitShowDialogue("...Serait-ce le terrible Zeraora ? Personne n'ose s'en approcher de trop près.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Forêt Lugubre", "La Team Dazzling", "L'expédition", "Rien"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Forêt Lugubre est située juste au nord du village. L'air y est très lourd.")
    UI:WaitShowDialogue("On raconte que les arbres bougent tout seuls et que les lianes emprisonnent les intrus.")
    UI:WaitShowDialogue("Si vous y entrez, restez sur vos gardes. Ne laissez jamais votre partenaire seul.")
    UI:WaitShowDialogue("Et surtout... méfiez-vous du cri de la jungle. Il annonce la colère de son roi.")
    UI:WaitShowDialogue("Je crois que même la guilde n'a pas encore cartographié tout le donjon.")
    UI:WaitShowDialogue("Mais avec votre courage, je sais que vous pourrez y arriver et sauver le petit !")
  elseif choice == 2 then
    UI:WaitShowDialogue("La Team Dazzling... Elles sont arrivées de la côte il y a quelques jours seulement.")
    UI:WaitShowDialogue("Adagio est si polie mais on sent toute sa supériorité dans ses paroles.")
    UI:WaitShowDialogue("Aria est très provocatrice, elle passe son temps à sauter de joie et à se moquer.")
    UI:WaitShowDialogue("Et Sonata... elle est tellement théâtrale avec ses mimiques et ses colères !")
    UI:WaitShowDialogue("Elles se croient déjà au sommet, prétendant que ce sauvetage n'est qu'un jeu pour elles.")
    UI:WaitShowDialogue("Ne les laissez pas vous intimider. Montrez-leur de quel bois vous vous chauffez !")
    UI:WaitShowDialogue("Toute la ville attend de voir qui ramènera le Chenipent en premier.")
  elseif choice == 3 then
    UI:WaitShowDialogue("L'expédition du Mont Venteux... C'était une aventure extraordinaire.")
    UI:WaitShowDialogue("Vous avez gravi les sommets, traversé les tempêtes et affronté le Seigneur des Vents.")
    UI:WaitShowDialogue("Le doyen Penticus m'a dit que votre exploit résonnera longtemps à la guilde.")
    UI:WaitShowDialogue("Mais ce n'était que le début de l'histoire, je le ressens au fond de mes os.")
    UI:WaitShowDialogue("Les flux d'énergie continuent de s'agiter sous la terre, de plus en plus chauds.")
    UI:WaitShowDialogue("Restez forts, mes amis. Le monde a plus que jamais besoin de héros.")
  else
    UI:WaitShowDialogue("D'accord. Prenez soin de vous sur les sentiers et dans les donjons.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Sentret_GossipTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Oh, vous revoilà ! J'ai encore entendu d'étranges rumeurs...", "Normal")
  UI:WaitShowDialogue("On dit que la Team Dazzling n'est pas là pour faire du secours, mais pour un secret...")
  UI:WaitShowDialogue("Elles fouillent les recoins du village et de la guilde, murmurant entre elles.")
  UI:WaitShowDialogue("Même les marchands du marché les trouvent suspectes, malgré leur éclat.")
  UI:WaitShowDialogue("Qu'en pensez-vous ? Pensez-vous qu'elles complotent quelque chose de louche ?")
  UI:BeginChoiceMenu("Que lui dites-vous ?", {"Elles complotent", "Elles sont juste fières", "Je ne sais pas"}, 1, 3)
  UI:WaitForChoice()
  local result = UI:ChoiceResult()
  if result == 1 then
    UI:WaitShowDialogue("Je le savais ! Leurs mines mystérieuses et leurs messes basses ne trompent personne.")
    UI:WaitShowDialogue("Même le Doyen Penticus les surveille du coin de l'œil, je l'ai vu hier.")
    UI:WaitShowDialogue("Faites bien attention si vous les croisez dans la Forêt Lugubre.")
  elseif result == 2 then
    UI:WaitShowDialogue("C'est possible. Les équipes de la côte ont toujours cette fierté un peu agaçante.")
    UI:WaitShowDialogue("Après tout, elles ont une grande réputation à tenir, mais quand même...")
    UI:WaitShowDialogue("Ne relâchez pas votre attention pour autant. On ne sait jamais.")
  else
    UI:WaitShowDialogue("La prudence est mère de sûreté, comme on dit toujours à la guilde.")
    UI:WaitShowDialogue("Nous verrons bien ce que l'avenir nous réserve. Restons concentrés.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Sentret_RaidTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous entendu les rumeurs sur les pilleurs nocturnes ?", "Worried")
  UI:WaitShowDialogue("On dit que des spectres rodent dans les ombres de la ville dès que la nuit tombe...")
  UI:WaitShowDialogue("Ils forcent les coffres, pillent les stands et s'enfuient sans laisser de traces.")
  UI:WaitShowDialogue("La place entière retient son souffle dès que le soleil se couche.")
  UI:WaitShowDialogue("Si vous veillez de nuit, soyez extrêmement prudents. Ils sont redoutables.")
  UI:WaitShowDialogue("Mais je sais que votre équipe a le courage de défendre notre ville de Metano !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Sentret_PrepTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avant de repartir en mission, assurez-vous d'être bien préparés !", "Normal")
  UI:WaitShowDialogue("La Forêt Lugubre ne pardonne pas le manque d'organisation.")
  UI:WaitShowDialogue("Prenez toujours des Baies Oran, des Baies Ceriz et des Échapporbes en cas de besoin.")
  UI:WaitShowDialogue("L'entrepôt de la guilde est là pour stocker vos trésors précieux.")
  UI:WaitShowDialogue("Même l'équipe la plus forte peut faillir sans un bon équipement.")
  UI:WaitShowDialogue("Faites-moi confiance, la préparation est la clé de toute grande aventure !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Sentret_RelaxTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'ambiance au café est si relaxante en ce moment...", "Normal")
  UI:WaitShowDialogue("C'est l'endroit idéal pour faire une pause et discuter avec les autres.")
  UI:WaitShowDialogue("Après une longue journée dans les donjons, rien ne vaut une bonne boisson chaude.")
  UI:WaitShowDialogue("Même les rumeurs les plus folles se partagent ici autour d'une table.")
  UI:WaitShowDialogue("Prenez le temps de souffler un peu avant de retourner affronter la jungle.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Sentret_DazzlingChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, que pensez-vous de chaque membre des Dazzling ?", "Normal")
  UI:BeginChoiceMenu("Qui souhaitez-vous évaluer ?", {"Adagio", "Aria", "Sonata", "Toutes"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Adagio est d'une élégance rare, mais ses yeux brillent d'une ambition froide.")
  elseif res == 2 then
    UI:WaitShowDialogue("Aria ne fait que s'exciter et provoquer tout le monde. C'est insupportable.")
  elseif res == 3 then
    UI:WaitShowDialogue("Sonata est tellement théâtrale ! Ses grands gestes amusent la galerie.")
  else
    UI:WaitShowDialogue("Elles forment un groupe redoutable. Ne sous-estimez jamais leur union.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Sentret_ExpeditionChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "L'expédition reste le plus grand événement de l'année !", "Normal")
  UI:WaitShowDialogue("Chacun de nous en garde un souvenir marquant et impérissable.")
  UI:WaitShowDialogue("Pour certains, c'était la première fois qu'ils voyaient de si grandes montagnes.")
  UI:WaitShowDialogue("Et pour vous, quel reste le plus beau souvenir de cette ascension ?")
  UI:BeginChoiceMenu("Votre moment favori :", {"Le feu de camp", "La tempête", "Le sommet"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Le feu de camp était si convivial, à partager des rumeurs au milieu de la nuit !")
  elseif res == 2 then
    UI:WaitShowDialogue("La tempête était terrifiante, mais elle a montré toute la force de notre guilde !")
  else
    UI:WaitShowDialogue("Le sommet Venteux était d'une majesté absolue. On y touchait le ciel !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Sentret_StoryDazzlingTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La Team Dazzling fait sensation à Metano Town...", "Normal")
  UI:WaitShowDialogue("Leurs voix magiques s'entendent jusqu'aux confins de la forêt.")
  UI:WaitShowDialogue("On dit qu'elles préparent un grand spectacle pour fêter leur prochaine victoire.")
  UI:WaitShowDialogue("Mais certains érudits pensent qu'il y a une magie ancienne derrière leur chant.")
  UI:WaitShowDialogue("Nous verrons bien si elles parviennent à apaiser le roi de la jungle !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Sentret_ExpeditionBivouacTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les récits de votre bivouac au Mont Venteux sont incroyables...", "Normal")
  UI:WaitShowDialogue("Dormir sous les étoiles, à l'écoute du chant mystique de la montagne...")
  UI:WaitShowDialogue("C'est le genre d'expérience qui forge l'âme d'un véritable aventurier.")
  UI:WaitShowDialogue("Toute la ville est fière de voir votre équipe progresser si vite !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Manectric_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est une magnifique journée d'histoire.", "Normal")
  UI:WaitShowDialogue("Le Chapitre 6 est plein d'aventures et de rumeurs mystérieuses dans la Forêt Lugubre.")
  UI:WaitShowDialogue("Certains disent avoir vu une ombre gigantesque courir à travers les lianes...")
  UI:WaitShowDialogue("...Serait-ce le terrible Zeraora ? Personne n'ose s'en approcher de trop près.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Forêt Lugubre", "La Team Dazzling", "L'expédition", "Rien"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Forêt Lugubre est située juste au nord du village. L'air y est très lourd.")
    UI:WaitShowDialogue("On raconte que les arbres bougent tout seuls et que les lianes emprisonnent les intrus.")
    UI:WaitShowDialogue("Si vous y entrez, restez sur vos gardes. Ne laissez jamais votre partenaire seul.")
    UI:WaitShowDialogue("Et surtout... méfiez-vous du cri de la jungle. Il annonce la colère de son roi.")
    UI:WaitShowDialogue("Je crois que même la guilde n'a pas encore cartographié tout le donjon.")
    UI:WaitShowDialogue("Mais avec votre courage, je sais que vous pourrez y arriver et sauver le petit !")
  elseif choice == 2 then
    UI:WaitShowDialogue("La Team Dazzling... Elles sont arrivées de la côte il y a quelques jours seulement.")
    UI:WaitShowDialogue("Adagio est si polie mais on sent toute sa supériorité dans ses paroles.")
    UI:WaitShowDialogue("Aria est très provocatrice, elle passe son temps à sauter de joie et à se moquer.")
    UI:WaitShowDialogue("Et Sonata... elle est tellement théâtrale avec ses mimiques et ses colères !")
    UI:WaitShowDialogue("Elles se croient déjà au sommet, prétendant que ce sauvetage n'est qu'un jeu pour elles.")
    UI:WaitShowDialogue("Ne les laissez pas vous intimider. Montrez-leur de quel bois vous vous chauffez !")
    UI:WaitShowDialogue("Toute la ville attend de voir qui ramènera le Chenipent en premier.")
  elseif choice == 3 then
    UI:WaitShowDialogue("L'expédition du Mont Venteux... C'était une aventure extraordinaire.")
    UI:WaitShowDialogue("Vous avez gravi les sommets, traversé les tempêtes et affronté le Seigneur des Vents.")
    UI:WaitShowDialogue("Le doyen Penticus m'a dit que votre exploit résonnera longtemps à la guilde.")
    UI:WaitShowDialogue("Mais ce n'était que le début de l'histoire, je le ressens au fond de mes os.")
    UI:WaitShowDialogue("Les flux d'énergie continuent de s'agiter sous la terre, de plus en plus chauds.")
    UI:WaitShowDialogue("Restez forts, mes amis. Le monde a plus que jamais besoin de héros.")
  else
    UI:WaitShowDialogue("D'accord. Prenez soin de vous sur les sentiers et dans les donjons.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Manectric_GossipTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Oh, vous revoilà ! J'ai encore entendu d'étranges rumeurs...", "Normal")
  UI:WaitShowDialogue("On dit que la Team Dazzling n'est pas là pour faire du secours, mais pour un secret...")
  UI:WaitShowDialogue("Elles fouillent les recoins du village et de la guilde, murmurant entre elles.")
  UI:WaitShowDialogue("Même les marchands du marché les trouvent suspectes, malgré leur éclat.")
  UI:WaitShowDialogue("Qu'en pensez-vous ? Pensez-vous qu'elles complotent quelque chose de louche ?")
  UI:BeginChoiceMenu("Que lui dites-vous ?", {"Elles complotent", "Elles sont juste fières", "Je ne sais pas"}, 1, 3)
  UI:WaitForChoice()
  local result = UI:ChoiceResult()
  if result == 1 then
    UI:WaitShowDialogue("Je le savais ! Leurs mines mystérieuses et leurs messes basses ne trompent personne.")
    UI:WaitShowDialogue("Même le Doyen Penticus les surveille du coin de l'œil, je l'ai vu hier.")
    UI:WaitShowDialogue("Faites bien attention si vous les croisez dans la Forêt Lugubre.")
  elseif result == 2 then
    UI:WaitShowDialogue("C'est possible. Les équipes de la côte ont toujours cette fierté un peu agaçante.")
    UI:WaitShowDialogue("Après tout, elles ont une grande réputation à tenir, mais quand même...")
    UI:WaitShowDialogue("Ne relâchez pas votre attention pour autant. On ne sait jamais.")
  else
    UI:WaitShowDialogue("La prudence est mère de sûreté, comme on dit toujours à la guilde.")
    UI:WaitShowDialogue("Nous verrons bien ce que l'avenir nous réserve. Restons concentrés.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Manectric_RaidTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous entendu les rumeurs sur les pilleurs nocturnes ?", "Worried")
  UI:WaitShowDialogue("On dit que des spectres rodent dans les ombres de la ville dès que la nuit tombe...")
  UI:WaitShowDialogue("Ils forcent les coffres, pillent les stands et s'enfuient sans laisser de traces.")
  UI:WaitShowDialogue("La place entière retient son souffle dès que le soleil se couche.")
  UI:WaitShowDialogue("Si vous veillez de nuit, soyez extrêmement prudents. Ils sont redoutables.")
  UI:WaitShowDialogue("Mais je sais que votre équipe a le courage de défendre notre ville de Metano !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Manectric_PrepTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avant de repartir en mission, assurez-vous d'être bien préparés !", "Normal")
  UI:WaitShowDialogue("La Forêt Lugubre ne pardonne pas le manque d'organisation.")
  UI:WaitShowDialogue("Prenez toujours des Baies Oran, des Baies Ceriz et des Échapporbes en cas de besoin.")
  UI:WaitShowDialogue("L'entrepôt de la guilde est là pour stocker vos trésors précieux.")
  UI:WaitShowDialogue("Même l'équipe la plus forte peut faillir sans un bon équipement.")
  UI:WaitShowDialogue("Faites-moi confiance, la préparation est la clé de toute grande aventure !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Manectric_RelaxTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'ambiance au café est si relaxante en ce moment...", "Normal")
  UI:WaitShowDialogue("C'est l'endroit idéal pour faire une pause et discuter avec les autres.")
  UI:WaitShowDialogue("Après une longue journée dans les donjons, rien ne vaut une bonne boisson chaude.")
  UI:WaitShowDialogue("Même les rumeurs les plus folles se partagent ici autour d'une table.")
  UI:WaitShowDialogue("Prenez le temps de souffler un peu avant de retourner affronter la jungle.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Manectric_DazzlingChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, que pensez-vous de chaque membre des Dazzling ?", "Normal")
  UI:BeginChoiceMenu("Qui souhaitez-vous évaluer ?", {"Adagio", "Aria", "Sonata", "Toutes"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Adagio est d'une élégance rare, mais ses yeux brillent d'une ambition froide.")
  elseif res == 2 then
    UI:WaitShowDialogue("Aria ne fait que s'exciter et provoquer tout le monde. C'est insupportable.")
  elseif res == 3 then
    UI:WaitShowDialogue("Sonata est tellement théâtrale ! Ses grands gestes amusent la galerie.")
  else
    UI:WaitShowDialogue("Elles forment un groupe redoutable. Ne sous-estimez jamais leur union.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Manectric_ExpeditionChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "L'expédition reste le plus grand événement de l'année !", "Normal")
  UI:WaitShowDialogue("Chacun de nous en garde un souvenir marquant et impérissable.")
  UI:WaitShowDialogue("Pour certains, c'était la première fois qu'ils voyaient de si grandes montagnes.")
  UI:WaitShowDialogue("Et pour vous, quel reste le plus beau souvenir de cette ascension ?")
  UI:BeginChoiceMenu("Votre moment favori :", {"Le feu de camp", "La tempête", "Le sommet"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Le feu de camp était si convivial, à partager des rumeurs au milieu de la nuit !")
  elseif res == 2 then
    UI:WaitShowDialogue("La tempête était terrifiante, mais elle a montré toute la force de notre guilde !")
  else
    UI:WaitShowDialogue("Le sommet Venteux était d'une majesté absolue. On y touchait le ciel !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Manectric_StoryDazzlingTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La Team Dazzling fait sensation à Metano Town...", "Normal")
  UI:WaitShowDialogue("Leurs voix magiques s'entendent jusqu'aux confins de la forêt.")
  UI:WaitShowDialogue("On dit qu'elles préparent un grand spectacle pour fêter leur prochaine victoire.")
  UI:WaitShowDialogue("Mais certains érudits pensent qu'il y a une magie ancienne derrière leur chant.")
  UI:WaitShowDialogue("Nous verrons bien si elles parviennent à apaiser le roi de la jungle !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Manectric_ExpeditionBivouacTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les récits de votre bivouac au Mont Venteux sont incroyables...", "Normal")
  UI:WaitShowDialogue("Dormir sous les étoiles, à l'écoute du chant mystique de la montagne...")
  UI:WaitShowDialogue("C'est le genre d'expérience qui forge l'âme d'un véritable aventurier.")
  UI:WaitShowDialogue("Toute la ville est fière de voir votre équipe progresser si vite !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Wooper_Girl_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est une magnifique journée d'histoire.", "Normal")
  UI:WaitShowDialogue("Le Chapitre 6 est plein d'aventures et de rumeurs mystérieuses dans la Forêt Lugubre.")
  UI:WaitShowDialogue("Certains disent avoir vu une ombre gigantesque courir à travers les lianes...")
  UI:WaitShowDialogue("...Serait-ce le terrible Zeraora ? Personne n'ose s'en approcher de trop près.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Forêt Lugubre", "La Team Dazzling", "L'expédition", "Rien"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Forêt Lugubre est située juste au nord du village. L'air y est très lourd.")
    UI:WaitShowDialogue("On raconte que les arbres bougent tout seuls et que les lianes emprisonnent les intrus.")
    UI:WaitShowDialogue("Si vous y entrez, restez sur vos gardes. Ne laissez jamais votre partenaire seul.")
    UI:WaitShowDialogue("Et surtout... méfiez-vous du cri de la jungle. Il annonce la colère de son roi.")
    UI:WaitShowDialogue("Je crois que même la guilde n'a pas encore cartographié tout le donjon.")
    UI:WaitShowDialogue("Mais avec votre courage, je sais que vous pourrez y arriver et sauver le petit !")
  elseif choice == 2 then
    UI:WaitShowDialogue("La Team Dazzling... Elles sont arrivées de la côte il y a quelques jours seulement.")
    UI:WaitShowDialogue("Adagio est si polie mais on sent toute sa supériorité dans ses paroles.")
    UI:WaitShowDialogue("Aria est très provocatrice, elle passe son temps à sauter de joie et à se moquer.")
    UI:WaitShowDialogue("Et Sonata... elle est tellement théâtrale avec ses mimiques et ses colères !")
    UI:WaitShowDialogue("Elles se croient déjà au sommet, prétendant que ce sauvetage n'est qu'un jeu pour elles.")
    UI:WaitShowDialogue("Ne les laissez pas vous intimider. Montrez-leur de quel bois vous vous chauffez !")
    UI:WaitShowDialogue("Toute la ville attend de voir qui ramènera le Chenipent en premier.")
  elseif choice == 3 then
    UI:WaitShowDialogue("L'expédition du Mont Venteux... C'était une aventure extraordinaire.")
    UI:WaitShowDialogue("Vous avez gravi les sommets, traversé les tempêtes et affronté le Seigneur des Vents.")
    UI:WaitShowDialogue("Le doyen Penticus m'a dit que votre exploit résonnera longtemps à la guilde.")
    UI:WaitShowDialogue("Mais ce n'était que le début de l'histoire, je le ressens au fond de mes os.")
    UI:WaitShowDialogue("Les flux d'énergie continuent de s'agiter sous la terre, de plus en plus chauds.")
    UI:WaitShowDialogue("Restez forts, mes amis. Le monde a plus que jamais besoin de héros.")
  else
    UI:WaitShowDialogue("D'accord. Prenez soin de vous sur les sentiers et dans les donjons.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Wooper_Girl_GossipTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Oh, vous revoilà ! J'ai encore entendu d'étranges rumeurs...", "Normal")
  UI:WaitShowDialogue("On dit que la Team Dazzling n'est pas là pour faire du secours, mais pour un secret...")
  UI:WaitShowDialogue("Elles fouillent les recoins du village et de la guilde, murmurant entre elles.")
  UI:WaitShowDialogue("Même les marchands du marché les trouvent suspectes, malgré leur éclat.")
  UI:WaitShowDialogue("Qu'en pensez-vous ? Pensez-vous qu'elles complotent quelque chose de louche ?")
  UI:BeginChoiceMenu("Que lui dites-vous ?", {"Elles complotent", "Elles sont juste fières", "Je ne sais pas"}, 1, 3)
  UI:WaitForChoice()
  local result = UI:ChoiceResult()
  if result == 1 then
    UI:WaitShowDialogue("Je le savais ! Leurs mines mystérieuses et leurs messes basses ne trompent personne.")
    UI:WaitShowDialogue("Même le Doyen Penticus les surveille du coin de l'œil, je l'ai vu hier.")
    UI:WaitShowDialogue("Faites bien attention si vous les croisez dans la Forêt Lugubre.")
  elseif result == 2 then
    UI:WaitShowDialogue("C'est possible. Les équipes de la côte ont toujours cette fierté un peu agaçante.")
    UI:WaitShowDialogue("Après tout, elles ont une grande réputation à tenir, mais quand même...")
    UI:WaitShowDialogue("Ne relâchez pas votre attention pour autant. On ne sait jamais.")
  else
    UI:WaitShowDialogue("La prudence est mère de sûreté, comme on dit toujours à la guilde.")
    UI:WaitShowDialogue("Nous verrons bien ce que l'avenir nous réserve. Restons concentrés.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Wooper_Girl_RaidTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous entendu les rumeurs sur les pilleurs nocturnes ?", "Worried")
  UI:WaitShowDialogue("On dit que des spectres rodent dans les ombres de la ville dès que la nuit tombe...")
  UI:WaitShowDialogue("Ils forcent les coffres, pillent les stands et s'enfuient sans laisser de traces.")
  UI:WaitShowDialogue("La place entière retient son souffle dès que le soleil se couche.")
  UI:WaitShowDialogue("Si vous veillez de nuit, soyez extrêmement prudents. Ils sont redoutables.")
  UI:WaitShowDialogue("Mais je sais que votre équipe a le courage de défendre notre ville de Metano !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Wooper_Girl_PrepTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avant de repartir en mission, assurez-vous d'être bien préparés !", "Normal")
  UI:WaitShowDialogue("La Forêt Lugubre ne pardonne pas le manque d'organisation.")
  UI:WaitShowDialogue("Prenez toujours des Baies Oran, des Baies Ceriz et des Échapporbes en cas de besoin.")
  UI:WaitShowDialogue("L'entrepôt de la guilde est là pour stocker vos trésors précieux.")
  UI:WaitShowDialogue("Même l'équipe la plus forte peut faillir sans un bon équipement.")
  UI:WaitShowDialogue("Faites-moi confiance, la préparation est la clé de toute grande aventure !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Wooper_Girl_RelaxTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'ambiance au café est si relaxante en ce moment...", "Normal")
  UI:WaitShowDialogue("C'est l'endroit idéal pour faire une pause et discuter avec les autres.")
  UI:WaitShowDialogue("Après une longue journée dans les donjons, rien ne vaut une bonne boisson chaude.")
  UI:WaitShowDialogue("Même les rumeurs les plus folles se partagent ici autour d'une table.")
  UI:WaitShowDialogue("Prenez le temps de souffler un peu avant de retourner affronter la jungle.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Wooper_Girl_DazzlingChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, que pensez-vous de chaque membre des Dazzling ?", "Normal")
  UI:BeginChoiceMenu("Qui souhaitez-vous évaluer ?", {"Adagio", "Aria", "Sonata", "Toutes"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Adagio est d'une élégance rare, mais ses yeux brillent d'une ambition froide.")
  elseif res == 2 then
    UI:WaitShowDialogue("Aria ne fait que s'exciter et provoquer tout le monde. C'est insupportable.")
  elseif res == 3 then
    UI:WaitShowDialogue("Sonata est tellement théâtrale ! Ses grands gestes amusent la galerie.")
  else
    UI:WaitShowDialogue("Elles forment un groupe redoutable. Ne sous-estimez jamais leur union.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Wooper_Girl_ExpeditionChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "L'expédition reste le plus grand événement de l'année !", "Normal")
  UI:WaitShowDialogue("Chacun de nous en garde un souvenir marquant et impérissable.")
  UI:WaitShowDialogue("Pour certains, c'était la première fois qu'ils voyaient de si grandes montagnes.")
  UI:WaitShowDialogue("Et pour vous, quel reste le plus beau souvenir de cette ascension ?")
  UI:BeginChoiceMenu("Votre moment favori :", {"Le feu de camp", "La tempête", "Le sommet"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Le feu de camp était si convivial, à partager des rumeurs au milieu de la nuit !")
  elseif res == 2 then
    UI:WaitShowDialogue("La tempête était terrifiante, mais elle a montré toute la force de notre guilde !")
  else
    UI:WaitShowDialogue("Le sommet Venteux était d'une majesté absolue. On y touchait le ciel !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Wooper_Girl_StoryDazzlingTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La Team Dazzling fait sensation à Metano Town...", "Normal")
  UI:WaitShowDialogue("Leurs voix magiques s'entendent jusqu'aux confins de la forêt.")
  UI:WaitShowDialogue("On dit qu'elles préparent un grand spectacle pour fêter leur prochaine victoire.")
  UI:WaitShowDialogue("Mais certains érudits pensent qu'il y a une magie ancienne derrière leur chant.")
  UI:WaitShowDialogue("Nous verrons bien si elles parviennent à apaiser le roi de la jungle !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Wooper_Girl_ExpeditionBivouacTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les récits de votre bivouac au Mont Venteux sont incroyables...", "Normal")
  UI:WaitShowDialogue("Dormir sous les étoiles, à l'écoute du chant mystique de la montagne...")
  UI:WaitShowDialogue("C'est le genre d'expérience qui forge l'âme d'un véritable aventurier.")
  UI:WaitShowDialogue("Toute la ville est fière de voir votre équipe progresser si vite !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Wooper_Boy_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est une magnifique journée d'histoire.", "Normal")
  UI:WaitShowDialogue("Le Chapitre 6 est plein d'aventures et de rumeurs mystérieuses dans la Forêt Lugubre.")
  UI:WaitShowDialogue("Certains disent avoir vu une ombre gigantesque courir à travers les lianes...")
  UI:WaitShowDialogue("...Serait-ce le terrible Zeraora ? Personne n'ose s'en approcher de trop près.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Forêt Lugubre", "La Team Dazzling", "L'expédition", "Rien"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Forêt Lugubre est située juste au nord du village. L'air y est très lourd.")
    UI:WaitShowDialogue("On raconte que les arbres bougent tout seuls et que les lianes emprisonnent les intrus.")
    UI:WaitShowDialogue("Si vous y entrez, restez sur vos gardes. Ne laissez jamais votre partenaire seul.")
    UI:WaitShowDialogue("Et surtout... méfiez-vous du cri de la jungle. Il annonce la colère de son roi.")
    UI:WaitShowDialogue("Je crois que même la guilde n'a pas encore cartographié tout le donjon.")
    UI:WaitShowDialogue("Mais avec votre courage, je sais que vous pourrez y arriver et sauver le petit !")
  elseif choice == 2 then
    UI:WaitShowDialogue("La Team Dazzling... Elles sont arrivées de la côte il y a quelques jours seulement.")
    UI:WaitShowDialogue("Adagio est si polie mais on sent toute sa supériorité dans ses paroles.")
    UI:WaitShowDialogue("Aria est très provocatrice, elle passe son temps à sauter de joie et à se moquer.")
    UI:WaitShowDialogue("Et Sonata... elle est tellement théâtrale avec ses mimiques et ses colères !")
    UI:WaitShowDialogue("Elles se croient déjà au sommet, prétendant que ce sauvetage n'est qu'un jeu pour elles.")
    UI:WaitShowDialogue("Ne les laissez pas vous intimider. Montrez-leur de quel bois vous vous chauffez !")
    UI:WaitShowDialogue("Toute la ville attend de voir qui ramènera le Chenipent en premier.")
  elseif choice == 3 then
    UI:WaitShowDialogue("L'expédition du Mont Venteux... C'était une aventure extraordinaire.")
    UI:WaitShowDialogue("Vous avez gravi les sommets, traversé les tempêtes et affronté le Seigneur des Vents.")
    UI:WaitShowDialogue("Le doyen Penticus m'a dit que votre exploit résonnera longtemps à la guilde.")
    UI:WaitShowDialogue("Mais ce n'était que le début de l'histoire, je le ressens au fond de mes os.")
    UI:WaitShowDialogue("Les flux d'énergie continuent de s'agiter sous la terre, de plus en plus chauds.")
    UI:WaitShowDialogue("Restez forts, mes amis. Le monde a plus que jamais besoin de héros.")
  else
    UI:WaitShowDialogue("D'accord. Prenez soin de vous sur les sentiers et dans les donjons.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Wooper_Boy_GossipTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Oh, vous revoilà ! J'ai encore entendu d'étranges rumeurs...", "Normal")
  UI:WaitShowDialogue("On dit que la Team Dazzling n'est pas là pour faire du secours, mais pour un secret...")
  UI:WaitShowDialogue("Elles fouillent les recoins du village et de la guilde, murmurant entre elles.")
  UI:WaitShowDialogue("Même les marchands du marché les trouvent suspectes, malgré leur éclat.")
  UI:WaitShowDialogue("Qu'en pensez-vous ? Pensez-vous qu'elles complotent quelque chose de louche ?")
  UI:BeginChoiceMenu("Que lui dites-vous ?", {"Elles complotent", "Elles sont juste fières", "Je ne sais pas"}, 1, 3)
  UI:WaitForChoice()
  local result = UI:ChoiceResult()
  if result == 1 then
    UI:WaitShowDialogue("Je le savais ! Leurs mines mystérieuses et leurs messes basses ne trompent personne.")
    UI:WaitShowDialogue("Même le Doyen Penticus les surveille du coin de l'œil, je l'ai vu hier.")
    UI:WaitShowDialogue("Faites bien attention si vous les croisez dans la Forêt Lugubre.")
  elseif result == 2 then
    UI:WaitShowDialogue("C'est possible. Les équipes de la côte ont toujours cette fierté un peu agaçante.")
    UI:WaitShowDialogue("Après tout, elles ont une grande réputation à tenir, mais quand même...")
    UI:WaitShowDialogue("Ne relâchez pas votre attention pour autant. On ne sait jamais.")
  else
    UI:WaitShowDialogue("La prudence est mère de sûreté, comme on dit toujours à la guilde.")
    UI:WaitShowDialogue("Nous verrons bien ce que l'avenir nous réserve. Restons concentrés.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Wooper_Boy_RaidTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous entendu les rumeurs sur les pilleurs nocturnes ?", "Worried")
  UI:WaitShowDialogue("On dit que des spectres rodent dans les ombres de la ville dès que la nuit tombe...")
  UI:WaitShowDialogue("Ils forcent les coffres, pillent les stands et s'enfuient sans laisser de traces.")
  UI:WaitShowDialogue("La place entière retient son souffle dès que le soleil se couche.")
  UI:WaitShowDialogue("Si vous veillez de nuit, soyez extrêmement prudents. Ils sont redoutables.")
  UI:WaitShowDialogue("Mais je sais que votre équipe a le courage de défendre notre ville de Metano !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Wooper_Boy_PrepTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avant de repartir en mission, assurez-vous d'être bien préparés !", "Normal")
  UI:WaitShowDialogue("La Forêt Lugubre ne pardonne pas le manque d'organisation.")
  UI:WaitShowDialogue("Prenez toujours des Baies Oran, des Baies Ceriz et des Échapporbes en cas de besoin.")
  UI:WaitShowDialogue("L'entrepôt de la guilde est là pour stocker vos trésors précieux.")
  UI:WaitShowDialogue("Même l'équipe la plus forte peut faillir sans un bon équipement.")
  UI:WaitShowDialogue("Faites-moi confiance, la préparation est la clé de toute grande aventure !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Wooper_Boy_RelaxTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'ambiance au café est si relaxante en ce moment...", "Normal")
  UI:WaitShowDialogue("C'est l'endroit idéal pour faire une pause et discuter avec les autres.")
  UI:WaitShowDialogue("Après une longue journée dans les donjons, rien ne vaut une bonne boisson chaude.")
  UI:WaitShowDialogue("Même les rumeurs les plus folles se partagent ici autour d'une table.")
  UI:WaitShowDialogue("Prenez le temps de souffler un peu avant de retourner affronter la jungle.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Wooper_Boy_DazzlingChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, que pensez-vous de chaque membre des Dazzling ?", "Normal")
  UI:BeginChoiceMenu("Qui souhaitez-vous évaluer ?", {"Adagio", "Aria", "Sonata", "Toutes"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Adagio est d'une élégance rare, mais ses yeux brillent d'une ambition froide.")
  elseif res == 2 then
    UI:WaitShowDialogue("Aria ne fait que s'exciter et provoquer tout le monde. C'est insupportable.")
  elseif res == 3 then
    UI:WaitShowDialogue("Sonata est tellement théâtrale ! Ses grands gestes amusent la galerie.")
  else
    UI:WaitShowDialogue("Elles forment un groupe redoutable. Ne sous-estimez jamais leur union.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Wooper_Boy_ExpeditionChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "L'expédition reste le plus grand événement de l'année !", "Normal")
  UI:WaitShowDialogue("Chacun de nous en garde un souvenir marquant et impérissable.")
  UI:WaitShowDialogue("Pour certains, c'était la première fois qu'ils voyaient de si grandes montagnes.")
  UI:WaitShowDialogue("Et pour vous, quel reste le plus beau souvenir de cette ascension ?")
  UI:BeginChoiceMenu("Votre moment favori :", {"Le feu de camp", "La tempête", "Le sommet"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Le feu de camp était si convivial, à partager des rumeurs au milieu de la nuit !")
  elseif res == 2 then
    UI:WaitShowDialogue("La tempête était terrifiante, mais elle a montré toute la force de notre guilde !")
  else
    UI:WaitShowDialogue("Le sommet Venteux était d'une majesté absolue. On y touchait le ciel !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Wooper_Boy_StoryDazzlingTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La Team Dazzling fait sensation à Metano Town...", "Normal")
  UI:WaitShowDialogue("Leurs voix magiques s'entendent jusqu'aux confins de la forêt.")
  UI:WaitShowDialogue("On dit qu'elles préparent un grand spectacle pour fêter leur prochaine victoire.")
  UI:WaitShowDialogue("Mais certains érudits pensent qu'il y a une magie ancienne derrière leur chant.")
  UI:WaitShowDialogue("Nous verrons bien si elles parviennent à apaiser le roi de la jungle !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Wooper_Boy_ExpeditionBivouacTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les récits de votre bivouac au Mont Venteux sont incroyables...", "Normal")
  UI:WaitShowDialogue("Dormir sous les étoiles, à l'écoute du chant mystique de la montagne...")
  UI:WaitShowDialogue("C'est le genre d'expérience qui forge l'âme d'un véritable aventurier.")
  UI:WaitShowDialogue("Toute la ville est fière de voir votre équipe progresser si vite !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Meditite_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est une magnifique journée d'histoire.", "Normal")
  UI:WaitShowDialogue("Le Chapitre 6 est plein d'aventures et de rumeurs mystérieuses dans la Forêt Lugubre.")
  UI:WaitShowDialogue("Certains disent avoir vu une ombre gigantesque courir à travers les lianes...")
  UI:WaitShowDialogue("...Serait-ce le terrible Zeraora ? Personne n'ose s'en approcher de trop près.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Forêt Lugubre", "La Team Dazzling", "L'expédition", "Rien"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Forêt Lugubre est située juste au nord du village. L'air y est très lourd.")
    UI:WaitShowDialogue("On raconte que les arbres bougent tout seuls et que les lianes emprisonnent les intrus.")
    UI:WaitShowDialogue("Si vous y entrez, restez sur vos gardes. Ne laissez jamais votre partenaire seul.")
    UI:WaitShowDialogue("Et surtout... méfiez-vous du cri de la jungle. Il annonce la colère de son roi.")
    UI:WaitShowDialogue("Je crois que même la guilde n'a pas encore cartographié tout le donjon.")
    UI:WaitShowDialogue("Mais avec votre courage, je sais que vous pourrez y arriver et sauver le petit !")
  elseif choice == 2 then
    UI:WaitShowDialogue("La Team Dazzling... Elles sont arrivées de la côte il y a quelques jours seulement.")
    UI:WaitShowDialogue("Adagio est si polie mais on sent toute sa supériorité dans ses paroles.")
    UI:WaitShowDialogue("Aria est très provocatrice, elle passe son temps à sauter de joie et à se moquer.")
    UI:WaitShowDialogue("Et Sonata... elle est tellement théâtrale avec ses mimiques et ses colères !")
    UI:WaitShowDialogue("Elles se croient déjà au sommet, prétendant que ce sauvetage n'est qu'un jeu pour elles.")
    UI:WaitShowDialogue("Ne les laissez pas vous intimider. Montrez-leur de quel bois vous vous chauffez !")
    UI:WaitShowDialogue("Toute la ville attend de voir qui ramènera le Chenipent en premier.")
  elseif choice == 3 then
    UI:WaitShowDialogue("L'expédition du Mont Venteux... C'était une aventure extraordinaire.")
    UI:WaitShowDialogue("Vous avez gravi les sommets, traversé les tempêtes et affronté le Seigneur des Vents.")
    UI:WaitShowDialogue("Le doyen Penticus m'a dit que votre exploit résonnera longtemps à la guilde.")
    UI:WaitShowDialogue("Mais ce n'était que le début de l'histoire, je le ressens au fond de mes os.")
    UI:WaitShowDialogue("Les flux d'énergie continuent de s'agiter sous la terre, de plus en plus chauds.")
    UI:WaitShowDialogue("Restez forts, mes amis. Le monde a plus que jamais besoin de héros.")
  else
    UI:WaitShowDialogue("D'accord. Prenez soin de vous sur les sentiers et dans les donjons.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Meditite_GossipTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Oh, vous revoilà ! J'ai encore entendu d'étranges rumeurs...", "Normal")
  UI:WaitShowDialogue("On dit que la Team Dazzling n'est pas là pour faire du secours, mais pour un secret...")
  UI:WaitShowDialogue("Elles fouillent les recoins du village et de la guilde, murmurant entre elles.")
  UI:WaitShowDialogue("Même les marchands du marché les trouvent suspectes, malgré leur éclat.")
  UI:WaitShowDialogue("Qu'en pensez-vous ? Pensez-vous qu'elles complotent quelque chose de louche ?")
  UI:BeginChoiceMenu("Que lui dites-vous ?", {"Elles complotent", "Elles sont juste fières", "Je ne sais pas"}, 1, 3)
  UI:WaitForChoice()
  local result = UI:ChoiceResult()
  if result == 1 then
    UI:WaitShowDialogue("Je le savais ! Leurs mines mystérieuses et leurs messes basses ne trompent personne.")
    UI:WaitShowDialogue("Même le Doyen Penticus les surveille du coin de l'œil, je l'ai vu hier.")
    UI:WaitShowDialogue("Faites bien attention si vous les croisez dans la Forêt Lugubre.")
  elseif result == 2 then
    UI:WaitShowDialogue("C'est possible. Les équipes de la côte ont toujours cette fierté un peu agaçante.")
    UI:WaitShowDialogue("Après tout, elles ont une grande réputation à tenir, mais quand même...")
    UI:WaitShowDialogue("Ne relâchez pas votre attention pour autant. On ne sait jamais.")
  else
    UI:WaitShowDialogue("La prudence est mère de sûreté, comme on dit toujours à la guilde.")
    UI:WaitShowDialogue("Nous verrons bien ce que l'avenir nous réserve. Restons concentrés.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Meditite_RaidTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous entendu les rumeurs sur les pilleurs nocturnes ?", "Worried")
  UI:WaitShowDialogue("On dit que des spectres rodent dans les ombres de la ville dès que la nuit tombe...")
  UI:WaitShowDialogue("Ils forcent les coffres, pillent les stands et s'enfuient sans laisser de traces.")
  UI:WaitShowDialogue("La place entière retient son souffle dès que le soleil se couche.")
  UI:WaitShowDialogue("Si vous veillez de nuit, soyez extrêmement prudents. Ils sont redoutables.")
  UI:WaitShowDialogue("Mais je sais que votre équipe a le courage de défendre notre ville de Metano !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Meditite_PrepTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avant de repartir en mission, assurez-vous d'être bien préparés !", "Normal")
  UI:WaitShowDialogue("La Forêt Lugubre ne pardonne pas le manque d'organisation.")
  UI:WaitShowDialogue("Prenez toujours des Baies Oran, des Baies Ceriz et des Échapporbes en cas de besoin.")
  UI:WaitShowDialogue("L'entrepôt de la guilde est là pour stocker vos trésors précieux.")
  UI:WaitShowDialogue("Même l'équipe la plus forte peut faillir sans un bon équipement.")
  UI:WaitShowDialogue("Faites-moi confiance, la préparation est la clé de toute grande aventure !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Meditite_RelaxTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'ambiance au café est si relaxante en ce moment...", "Normal")
  UI:WaitShowDialogue("C'est l'endroit idéal pour faire une pause et discuter avec les autres.")
  UI:WaitShowDialogue("Après une longue journée dans les donjons, rien ne vaut une bonne boisson chaude.")
  UI:WaitShowDialogue("Même les rumeurs les plus folles se partagent ici autour d'une table.")
  UI:WaitShowDialogue("Prenez le temps de souffler un peu avant de retourner affronter la jungle.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Meditite_DazzlingChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, que pensez-vous de chaque membre des Dazzling ?", "Normal")
  UI:BeginChoiceMenu("Qui souhaitez-vous évaluer ?", {"Adagio", "Aria", "Sonata", "Toutes"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Adagio est d'une élégance rare, mais ses yeux brillent d'une ambition froide.")
  elseif res == 2 then
    UI:WaitShowDialogue("Aria ne fait que s'exciter et provoquer tout le monde. C'est insupportable.")
  elseif res == 3 then
    UI:WaitShowDialogue("Sonata est tellement théâtrale ! Ses grands gestes amusent la galerie.")
  else
    UI:WaitShowDialogue("Elles forment un groupe redoutable. Ne sous-estimez jamais leur union.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Meditite_ExpeditionChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "L'expédition reste le plus grand événement de l'année !", "Normal")
  UI:WaitShowDialogue("Chacun de nous en garde un souvenir marquant et impérissable.")
  UI:WaitShowDialogue("Pour certains, c'était la première fois qu'ils voyaient de si grandes montagnes.")
  UI:WaitShowDialogue("Et pour vous, quel reste le plus beau souvenir de cette ascension ?")
  UI:BeginChoiceMenu("Votre moment favori :", {"Le feu de camp", "La tempête", "Le sommet"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Le feu de camp était si convivial, à partager des rumeurs au milieu de la nuit !")
  elseif res == 2 then
    UI:WaitShowDialogue("La tempête était terrifiante, mais elle a montré toute la force de notre guilde !")
  else
    UI:WaitShowDialogue("Le sommet Venteux était d'une majesté absolue. On y touchait le ciel !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Meditite_StoryDazzlingTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La Team Dazzling fait sensation à Metano Town...", "Normal")
  UI:WaitShowDialogue("Leurs voix magiques s'entendent jusqu'aux confins de la forêt.")
  UI:WaitShowDialogue("On dit qu'elles préparent un grand spectacle pour fêter leur prochaine victoire.")
  UI:WaitShowDialogue("Mais certains érudits pensent qu'il y a une magie ancienne derrière leur chant.")
  UI:WaitShowDialogue("Nous verrons bien si elles parviennent à apaiser le roi de la jungle !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Meditite_ExpeditionBivouacTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les récits de votre bivouac au Mont Venteux sont incroyables...", "Normal")
  UI:WaitShowDialogue("Dormir sous les étoiles, à l'écoute du chant mystique de la montagne...")
  UI:WaitShowDialogue("C'est le genre d'expérience qui forge l'âme d'un véritable aventurier.")
  UI:WaitShowDialogue("Toute la ville est fière de voir votre équipe progresser si vite !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Machamp_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est une magnifique journée d'histoire.", "Normal")
  UI:WaitShowDialogue("Le Chapitre 6 est plein d'aventures et de rumeurs mystérieuses dans la Forêt Lugubre.")
  UI:WaitShowDialogue("Certains disent avoir vu une ombre gigantesque courir à travers les lianes...")
  UI:WaitShowDialogue("...Serait-ce le terrible Zeraora ? Personne n'ose s'en approcher de trop près.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Forêt Lugubre", "La Team Dazzling", "L'expédition", "Rien"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Forêt Lugubre est située juste au nord du village. L'air y est très lourd.")
    UI:WaitShowDialogue("On raconte que les arbres bougent tout seuls et que les lianes emprisonnent les intrus.")
    UI:WaitShowDialogue("Si vous y entrez, restez sur vos gardes. Ne laissez jamais votre partenaire seul.")
    UI:WaitShowDialogue("Et surtout... méfiez-vous du cri de la jungle. Il annonce la colère de son roi.")
    UI:WaitShowDialogue("Je crois que même la guilde n'a pas encore cartographié tout le donjon.")
    UI:WaitShowDialogue("Mais avec votre courage, je sais que vous pourrez y arriver et sauver le petit !")
  elseif choice == 2 then
    UI:WaitShowDialogue("La Team Dazzling... Elles sont arrivées de la côte il y a quelques jours seulement.")
    UI:WaitShowDialogue("Adagio est si polie mais on sent toute sa supériorité dans ses paroles.")
    UI:WaitShowDialogue("Aria est très provocatrice, elle passe son temps à sauter de joie et à se moquer.")
    UI:WaitShowDialogue("Et Sonata... elle est tellement théâtrale avec ses mimiques et ses colères !")
    UI:WaitShowDialogue("Elles se croient déjà au sommet, prétendant que ce sauvetage n'est qu'un jeu pour elles.")
    UI:WaitShowDialogue("Ne les laissez pas vous intimider. Montrez-leur de quel bois vous vous chauffez !")
    UI:WaitShowDialogue("Toute la ville attend de voir qui ramènera le Chenipent en premier.")
  elseif choice == 3 then
    UI:WaitShowDialogue("L'expédition du Mont Venteux... C'était une aventure extraordinaire.")
    UI:WaitShowDialogue("Vous avez gravi les sommets, traversé les tempêtes et affronté le Seigneur des Vents.")
    UI:WaitShowDialogue("Le doyen Penticus m'a dit que votre exploit résonnera longtemps à la guilde.")
    UI:WaitShowDialogue("Mais ce n'était que le début de l'histoire, je le ressens au fond de mes os.")
    UI:WaitShowDialogue("Les flux d'énergie continuent de s'agiter sous la terre, de plus en plus chauds.")
    UI:WaitShowDialogue("Restez forts, mes amis. Le monde a plus que jamais besoin de héros.")
  else
    UI:WaitShowDialogue("D'accord. Prenez soin de vous sur les sentiers et dans les donjons.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Machamp_GossipTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Oh, vous revoilà ! J'ai encore entendu d'étranges rumeurs...", "Normal")
  UI:WaitShowDialogue("On dit que la Team Dazzling n'est pas là pour faire du secours, mais pour un secret...")
  UI:WaitShowDialogue("Elles fouillent les recoins du village et de la guilde, murmurant entre elles.")
  UI:WaitShowDialogue("Même les marchands du marché les trouvent suspectes, malgré leur éclat.")
  UI:WaitShowDialogue("Qu'en pensez-vous ? Pensez-vous qu'elles complotent quelque chose de louche ?")
  UI:BeginChoiceMenu("Que lui dites-vous ?", {"Elles complotent", "Elles sont juste fières", "Je ne sais pas"}, 1, 3)
  UI:WaitForChoice()
  local result = UI:ChoiceResult()
  if result == 1 then
    UI:WaitShowDialogue("Je le savais ! Leurs mines mystérieuses et leurs messes basses ne trompent personne.")
    UI:WaitShowDialogue("Même le Doyen Penticus les surveille du coin de l'œil, je l'ai vu hier.")
    UI:WaitShowDialogue("Faites bien attention si vous les croisez dans la Forêt Lugubre.")
  elseif result == 2 then
    UI:WaitShowDialogue("C'est possible. Les équipes de la côte ont toujours cette fierté un peu agaçante.")
    UI:WaitShowDialogue("Après tout, elles ont une grande réputation à tenir, mais quand même...")
    UI:WaitShowDialogue("Ne relâchez pas votre attention pour autant. On ne sait jamais.")
  else
    UI:WaitShowDialogue("La prudence est mère de sûreté, comme on dit toujours à la guilde.")
    UI:WaitShowDialogue("Nous verrons bien ce que l'avenir nous réserve. Restons concentrés.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Machamp_RaidTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous entendu les rumeurs sur les pilleurs nocturnes ?", "Worried")
  UI:WaitShowDialogue("On dit que des spectres rodent dans les ombres de la ville dès que la nuit tombe...")
  UI:WaitShowDialogue("Ils forcent les coffres, pillent les stands et s'enfuient sans laisser de traces.")
  UI:WaitShowDialogue("La place entière retient son souffle dès que le soleil se couche.")
  UI:WaitShowDialogue("Si vous veillez de nuit, soyez extrêmement prudents. Ils sont redoutables.")
  UI:WaitShowDialogue("Mais je sais que votre équipe a le courage de défendre notre ville de Metano !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Machamp_PrepTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avant de repartir en mission, assurez-vous d'être bien préparés !", "Normal")
  UI:WaitShowDialogue("La Forêt Lugubre ne pardonne pas le manque d'organisation.")
  UI:WaitShowDialogue("Prenez toujours des Baies Oran, des Baies Ceriz et des Échapporbes en cas de besoin.")
  UI:WaitShowDialogue("L'entrepôt de la guilde est là pour stocker vos trésors précieux.")
  UI:WaitShowDialogue("Même l'équipe la plus forte peut faillir sans un bon équipement.")
  UI:WaitShowDialogue("Faites-moi confiance, la préparation est la clé de toute grande aventure !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Machamp_RelaxTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'ambiance au café est si relaxante en ce moment...", "Normal")
  UI:WaitShowDialogue("C'est l'endroit idéal pour faire une pause et discuter avec les autres.")
  UI:WaitShowDialogue("Après une longue journée dans les donjons, rien ne vaut une bonne boisson chaude.")
  UI:WaitShowDialogue("Même les rumeurs les plus folles se partagent ici autour d'une table.")
  UI:WaitShowDialogue("Prenez le temps de souffler un peu avant de retourner affronter la jungle.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Machamp_DazzlingChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, que pensez-vous de chaque membre des Dazzling ?", "Normal")
  UI:BeginChoiceMenu("Qui souhaitez-vous évaluer ?", {"Adagio", "Aria", "Sonata", "Toutes"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Adagio est d'une élégance rare, mais ses yeux brillent d'une ambition froide.")
  elseif res == 2 then
    UI:WaitShowDialogue("Aria ne fait que s'exciter et provoquer tout le monde. C'est insupportable.")
  elseif res == 3 then
    UI:WaitShowDialogue("Sonata est tellement théâtrale ! Ses grands gestes amusent la galerie.")
  else
    UI:WaitShowDialogue("Elles forment un groupe redoutable. Ne sous-estimez jamais leur union.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Machamp_ExpeditionChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "L'expédition reste le plus grand événement de l'année !", "Normal")
  UI:WaitShowDialogue("Chacun de nous en garde un souvenir marquant et impérissable.")
  UI:WaitShowDialogue("Pour certains, c'était la première fois qu'ils voyaient de si grandes montagnes.")
  UI:WaitShowDialogue("Et pour vous, quel reste le plus beau souvenir de cette ascension ?")
  UI:BeginChoiceMenu("Votre moment favori :", {"Le feu de camp", "La tempête", "Le sommet"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Le feu de camp était si convivial, à partager des rumeurs au milieu de la nuit !")
  elseif res == 2 then
    UI:WaitShowDialogue("La tempête était terrifiante, mais elle a montré toute la force de notre guilde !")
  else
    UI:WaitShowDialogue("Le sommet Venteux était d'une majesté absolue. On y touchait le ciel !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Machamp_StoryDazzlingTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La Team Dazzling fait sensation à Metano Town...", "Normal")
  UI:WaitShowDialogue("Leurs voix magiques s'entendent jusqu'aux confins de la forêt.")
  UI:WaitShowDialogue("On dit qu'elles préparent un grand spectacle pour fêter leur prochaine victoire.")
  UI:WaitShowDialogue("Mais certains érudits pensent qu'il y a une magie ancienne derrière leur chant.")
  UI:WaitShowDialogue("Nous verrons bien si elles parviennent à apaiser le roi de la jungle !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Machamp_ExpeditionBivouacTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les récits de votre bivouac au Mont Venteux sont incroyables...", "Normal")
  UI:WaitShowDialogue("Dormir sous les étoiles, à l'écoute du chant mystique de la montagne...")
  UI:WaitShowDialogue("C'est le genre d'expérience qui forge l'âme d'un véritable aventurier.")
  UI:WaitShowDialogue("Toute la ville est fière de voir votre équipe progresser si vite !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Luxray_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est une magnifique journée d'histoire.", "Normal")
  UI:WaitShowDialogue("Le Chapitre 6 est plein d'aventures et de rumeurs mystérieuses dans la Forêt Lugubre.")
  UI:WaitShowDialogue("Certains disent avoir vu une ombre gigantesque courir à travers les lianes...")
  UI:WaitShowDialogue("...Serait-ce le terrible Zeraora ? Personne n'ose s'en approcher de trop près.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Forêt Lugubre", "La Team Dazzling", "L'expédition", "Rien"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Forêt Lugubre est située juste au nord du village. L'air y est très lourd.")
    UI:WaitShowDialogue("On raconte que les arbres bougent tout seuls et que les lianes emprisonnent les intrus.")
    UI:WaitShowDialogue("Si vous y entrez, restez sur vos gardes. Ne laissez jamais votre partenaire seul.")
    UI:WaitShowDialogue("Et surtout... méfiez-vous du cri de la jungle. Il annonce la colère de son roi.")
    UI:WaitShowDialogue("Je crois que même la guilde n'a pas encore cartographié tout le donjon.")
    UI:WaitShowDialogue("Mais avec votre courage, je sais que vous pourrez y arriver et sauver le petit !")
  elseif choice == 2 then
    UI:WaitShowDialogue("La Team Dazzling... Elles sont arrivées de la côte il y a quelques jours seulement.")
    UI:WaitShowDialogue("Adagio est si polie mais on sent toute sa supériorité dans ses paroles.")
    UI:WaitShowDialogue("Aria est très provocatrice, elle passe son temps à sauter de joie et à se moquer.")
    UI:WaitShowDialogue("Et Sonata... elle est tellement théâtrale avec ses mimiques et ses colères !")
    UI:WaitShowDialogue("Elles se croient déjà au sommet, prétendant que ce sauvetage n'est qu'un jeu pour elles.")
    UI:WaitShowDialogue("Ne les laissez pas vous intimider. Montrez-leur de quel bois vous vous chauffez !")
    UI:WaitShowDialogue("Toute la ville attend de voir qui ramènera le Chenipent en premier.")
  elseif choice == 3 then
    UI:WaitShowDialogue("L'expédition du Mont Venteux... C'était une aventure extraordinaire.")
    UI:WaitShowDialogue("Vous avez gravi les sommets, traversé les tempêtes et affronté le Seigneur des Vents.")
    UI:WaitShowDialogue("Le doyen Penticus m'a dit que votre exploit résonnera longtemps à la guilde.")
    UI:WaitShowDialogue("Mais ce n'était que le début de l'histoire, je le ressens au fond de mes os.")
    UI:WaitShowDialogue("Les flux d'énergie continuent de s'agiter sous la terre, de plus en plus chauds.")
    UI:WaitShowDialogue("Restez forts, mes amis. Le monde a plus que jamais besoin de héros.")
  else
    UI:WaitShowDialogue("D'accord. Prenez soin de vous sur les sentiers et dans les donjons.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Luxray_GossipTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Oh, vous revoilà ! J'ai encore entendu d'étranges rumeurs...", "Normal")
  UI:WaitShowDialogue("On dit que la Team Dazzling n'est pas là pour faire du secours, mais pour un secret...")
  UI:WaitShowDialogue("Elles fouillent les recoins du village et de la guilde, murmurant entre elles.")
  UI:WaitShowDialogue("Même les marchands du marché les trouvent suspectes, malgré leur éclat.")
  UI:WaitShowDialogue("Qu'en pensez-vous ? Pensez-vous qu'elles complotent quelque chose de louche ?")
  UI:BeginChoiceMenu("Que lui dites-vous ?", {"Elles complotent", "Elles sont juste fières", "Je ne sais pas"}, 1, 3)
  UI:WaitForChoice()
  local result = UI:ChoiceResult()
  if result == 1 then
    UI:WaitShowDialogue("Je le savais ! Leurs mines mystérieuses et leurs messes basses ne trompent personne.")
    UI:WaitShowDialogue("Même le Doyen Penticus les surveille du coin de l'œil, je l'ai vu hier.")
    UI:WaitShowDialogue("Faites bien attention si vous les croisez dans la Forêt Lugubre.")
  elseif result == 2 then
    UI:WaitShowDialogue("C'est possible. Les équipes de la côte ont toujours cette fierté un peu agaçante.")
    UI:WaitShowDialogue("Après tout, elles ont une grande réputation à tenir, mais quand même...")
    UI:WaitShowDialogue("Ne relâchez pas votre attention pour autant. On ne sait jamais.")
  else
    UI:WaitShowDialogue("La prudence est mère de sûreté, comme on dit toujours à la guilde.")
    UI:WaitShowDialogue("Nous verrons bien ce que l'avenir nous réserve. Restons concentrés.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Luxray_RaidTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous entendu les rumeurs sur les pilleurs nocturnes ?", "Worried")
  UI:WaitShowDialogue("On dit que des spectres rodent dans les ombres de la ville dès que la nuit tombe...")
  UI:WaitShowDialogue("Ils forcent les coffres, pillent les stands et s'enfuient sans laisser de traces.")
  UI:WaitShowDialogue("La place entière retient son souffle dès que le soleil se couche.")
  UI:WaitShowDialogue("Si vous veillez de nuit, soyez extrêmement prudents. Ils sont redoutables.")
  UI:WaitShowDialogue("Mais je sais que votre équipe a le courage de défendre notre ville de Metano !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Luxray_PrepTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avant de repartir en mission, assurez-vous d'être bien préparés !", "Normal")
  UI:WaitShowDialogue("La Forêt Lugubre ne pardonne pas le manque d'organisation.")
  UI:WaitShowDialogue("Prenez toujours des Baies Oran, des Baies Ceriz et des Échapporbes en cas de besoin.")
  UI:WaitShowDialogue("L'entrepôt de la guilde est là pour stocker vos trésors précieux.")
  UI:WaitShowDialogue("Même l'équipe la plus forte peut faillir sans un bon équipement.")
  UI:WaitShowDialogue("Faites-moi confiance, la préparation est la clé de toute grande aventure !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Luxray_RelaxTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'ambiance au café est si relaxante en ce moment...", "Normal")
  UI:WaitShowDialogue("C'est l'endroit idéal pour faire une pause et discuter avec les autres.")
  UI:WaitShowDialogue("Après une longue journée dans les donjons, rien ne vaut une bonne boisson chaude.")
  UI:WaitShowDialogue("Même les rumeurs les plus folles se partagent ici autour d'une table.")
  UI:WaitShowDialogue("Prenez le temps de souffler un peu avant de retourner affronter la jungle.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Luxray_DazzlingChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, que pensez-vous de chaque membre des Dazzling ?", "Normal")
  UI:BeginChoiceMenu("Qui souhaitez-vous évaluer ?", {"Adagio", "Aria", "Sonata", "Toutes"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Adagio est d'une élégance rare, mais ses yeux brillent d'une ambition froide.")
  elseif res == 2 then
    UI:WaitShowDialogue("Aria ne fait que s'exciter et provoquer tout le monde. C'est insupportable.")
  elseif res == 3 then
    UI:WaitShowDialogue("Sonata est tellement théâtrale ! Ses grands gestes amusent la galerie.")
  else
    UI:WaitShowDialogue("Elles forment un groupe redoutable. Ne sous-estimez jamais leur union.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Luxray_ExpeditionChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "L'expédition reste le plus grand événement de l'année !", "Normal")
  UI:WaitShowDialogue("Chacun de nous en garde un souvenir marquant et impérissable.")
  UI:WaitShowDialogue("Pour certains, c'était la première fois qu'ils voyaient de si grandes montagnes.")
  UI:WaitShowDialogue("Et pour vous, quel reste le plus beau souvenir de cette ascension ?")
  UI:BeginChoiceMenu("Votre moment favori :", {"Le feu de camp", "La tempête", "Le sommet"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Le feu de camp était si convivial, à partager des rumeurs au milieu de la nuit !")
  elseif res == 2 then
    UI:WaitShowDialogue("La tempête était terrifiante, mais elle a montré toute la force de notre guilde !")
  else
    UI:WaitShowDialogue("Le sommet Venteux était d'une majesté absolue. On y touchait le ciel !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Luxray_StoryDazzlingTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La Team Dazzling fait sensation à Metano Town...", "Normal")
  UI:WaitShowDialogue("Leurs voix magiques s'entendent jusqu'aux confins de la forêt.")
  UI:WaitShowDialogue("On dit qu'elles préparent un grand spectacle pour fêter leur prochaine victoire.")
  UI:WaitShowDialogue("Mais certains érudits pensent qu'il y a une magie ancienne derrière leur chant.")
  UI:WaitShowDialogue("Nous verrons bien si elles parviennent à apaiser le roi de la jungle !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Luxray_ExpeditionBivouacTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les récits de votre bivouac au Mont Venteux sont incroyables...", "Normal")
  UI:WaitShowDialogue("Dormir sous les étoiles, à l'écoute du chant mystique de la montagne...")
  UI:WaitShowDialogue("C'est le genre d'expérience qui forge l'âme d'un véritable aventurier.")
  UI:WaitShowDialogue("Toute la ville est fière de voir votre équipe progresser si vite !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Gloom_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est une magnifique journée d'histoire.", "Normal")
  UI:WaitShowDialogue("Le Chapitre 6 est plein d'aventures et de rumeurs mystérieuses dans la Forêt Lugubre.")
  UI:WaitShowDialogue("Certains disent avoir vu une ombre gigantesque courir à travers les lianes...")
  UI:WaitShowDialogue("...Serait-ce le terrible Zeraora ? Personne n'ose s'en approcher de trop près.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Forêt Lugubre", "La Team Dazzling", "L'expédition", "Rien"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Forêt Lugubre est située juste au nord du village. L'air y est très lourd.")
    UI:WaitShowDialogue("On raconte que les arbres bougent tout seuls et que les lianes emprisonnent les intrus.")
    UI:WaitShowDialogue("Si vous y entrez, restez sur vos gardes. Ne laissez jamais votre partenaire seul.")
    UI:WaitShowDialogue("Et surtout... méfiez-vous du cri de la jungle. Il annonce la colère de son roi.")
    UI:WaitShowDialogue("Je crois que même la guilde n'a pas encore cartographié tout le donjon.")
    UI:WaitShowDialogue("Mais avec votre courage, je sais que vous pourrez y arriver et sauver le petit !")
  elseif choice == 2 then
    UI:WaitShowDialogue("La Team Dazzling... Elles sont arrivées de la côte il y a quelques jours seulement.")
    UI:WaitShowDialogue("Adagio est si polie mais on sent toute sa supériorité dans ses paroles.")
    UI:WaitShowDialogue("Aria est très provocatrice, elle passe son temps à sauter de joie et à se moquer.")
    UI:WaitShowDialogue("Et Sonata... elle est tellement théâtrale avec ses mimiques et ses colères !")
    UI:WaitShowDialogue("Elles se croient déjà au sommet, prétendant que ce sauvetage n'est qu'un jeu pour elles.")
    UI:WaitShowDialogue("Ne les laissez pas vous intimider. Montrez-leur de quel bois vous vous chauffez !")
    UI:WaitShowDialogue("Toute la ville attend de voir qui ramènera le Chenipent en premier.")
  elseif choice == 3 then
    UI:WaitShowDialogue("L'expédition du Mont Venteux... C'était une aventure extraordinaire.")
    UI:WaitShowDialogue("Vous avez gravi les sommets, traversé les tempêtes et affronté le Seigneur des Vents.")
    UI:WaitShowDialogue("Le doyen Penticus m'a dit que votre exploit résonnera longtemps à la guilde.")
    UI:WaitShowDialogue("Mais ce n'était que le début de l'histoire, je le ressens au fond de mes os.")
    UI:WaitShowDialogue("Les flux d'énergie continuent de s'agiter sous la terre, de plus en plus chauds.")
    UI:WaitShowDialogue("Restez forts, mes amis. Le monde a plus que jamais besoin de héros.")
  else
    UI:WaitShowDialogue("D'accord. Prenez soin de vous sur les sentiers et dans les donjons.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Gloom_GossipTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Oh, vous revoilà ! J'ai encore entendu d'étranges rumeurs...", "Normal")
  UI:WaitShowDialogue("On dit que la Team Dazzling n'est pas là pour faire du secours, mais pour un secret...")
  UI:WaitShowDialogue("Elles fouillent les recoins du village et de la guilde, murmurant entre elles.")
  UI:WaitShowDialogue("Même les marchands du marché les trouvent suspectes, malgré leur éclat.")
  UI:WaitShowDialogue("Qu'en pensez-vous ? Pensez-vous qu'elles complotent quelque chose de louche ?")
  UI:BeginChoiceMenu("Que lui dites-vous ?", {"Elles complotent", "Elles sont juste fières", "Je ne sais pas"}, 1, 3)
  UI:WaitForChoice()
  local result = UI:ChoiceResult()
  if result == 1 then
    UI:WaitShowDialogue("Je le savais ! Leurs mines mystérieuses et leurs messes basses ne trompent personne.")
    UI:WaitShowDialogue("Même le Doyen Penticus les surveille du coin de l'œil, je l'ai vu hier.")
    UI:WaitShowDialogue("Faites bien attention si vous les croisez dans la Forêt Lugubre.")
  elseif result == 2 then
    UI:WaitShowDialogue("C'est possible. Les équipes de la côte ont toujours cette fierté un peu agaçante.")
    UI:WaitShowDialogue("Après tout, elles ont une grande réputation à tenir, mais quand même...")
    UI:WaitShowDialogue("Ne relâchez pas votre attention pour autant. On ne sait jamais.")
  else
    UI:WaitShowDialogue("La prudence est mère de sûreté, comme on dit toujours à la guilde.")
    UI:WaitShowDialogue("Nous verrons bien ce que l'avenir nous réserve. Restons concentrés.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Gloom_RaidTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous entendu les rumeurs sur les pilleurs nocturnes ?", "Worried")
  UI:WaitShowDialogue("On dit que des spectres rodent dans les ombres de la ville dès que la nuit tombe...")
  UI:WaitShowDialogue("Ils forcent les coffres, pillent les stands et s'enfuient sans laisser de traces.")
  UI:WaitShowDialogue("La place entière retient son souffle dès que le soleil se couche.")
  UI:WaitShowDialogue("Si vous veillez de nuit, soyez extrêmement prudents. Ils sont redoutables.")
  UI:WaitShowDialogue("Mais je sais que votre équipe a le courage de défendre notre ville de Metano !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Gloom_PrepTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avant de repartir en mission, assurez-vous d'être bien préparés !", "Normal")
  UI:WaitShowDialogue("La Forêt Lugubre ne pardonne pas le manque d'organisation.")
  UI:WaitShowDialogue("Prenez toujours des Baies Oran, des Baies Ceriz et des Échapporbes en cas de besoin.")
  UI:WaitShowDialogue("L'entrepôt de la guilde est là pour stocker vos trésors précieux.")
  UI:WaitShowDialogue("Même l'équipe la plus forte peut faillir sans un bon équipement.")
  UI:WaitShowDialogue("Faites-moi confiance, la préparation est la clé de toute grande aventure !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Gloom_RelaxTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'ambiance au café est si relaxante en ce moment...", "Normal")
  UI:WaitShowDialogue("C'est l'endroit idéal pour faire une pause et discuter avec les autres.")
  UI:WaitShowDialogue("Après une longue journée dans les donjons, rien ne vaut une bonne boisson chaude.")
  UI:WaitShowDialogue("Même les rumeurs les plus folles se partagent ici autour d'une table.")
  UI:WaitShowDialogue("Prenez le temps de souffler un peu avant de retourner affronter la jungle.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Gloom_DazzlingChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, que pensez-vous de chaque membre des Dazzling ?", "Normal")
  UI:BeginChoiceMenu("Qui souhaitez-vous évaluer ?", {"Adagio", "Aria", "Sonata", "Toutes"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Adagio est d'une élégance rare, mais ses yeux brillent d'une ambition froide.")
  elseif res == 2 then
    UI:WaitShowDialogue("Aria ne fait que s'exciter et provoquer tout le monde. C'est insupportable.")
  elseif res == 3 then
    UI:WaitShowDialogue("Sonata est tellement théâtrale ! Ses grands gestes amusent la galerie.")
  else
    UI:WaitShowDialogue("Elles forment un groupe redoutable. Ne sous-estimez jamais leur union.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Gloom_ExpeditionChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "L'expédition reste le plus grand événement de l'année !", "Normal")
  UI:WaitShowDialogue("Chacun de nous en garde un souvenir marquant et impérissable.")
  UI:WaitShowDialogue("Pour certains, c'était la première fois qu'ils voyaient de si grandes montagnes.")
  UI:WaitShowDialogue("Et pour vous, quel reste le plus beau souvenir de cette ascension ?")
  UI:BeginChoiceMenu("Votre moment favori :", {"Le feu de camp", "La tempête", "Le sommet"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Le feu de camp était si convivial, à partager des rumeurs au milieu de la nuit !")
  elseif res == 2 then
    UI:WaitShowDialogue("La tempête était terrifiante, mais elle a montré toute la force de notre guilde !")
  else
    UI:WaitShowDialogue("Le sommet Venteux était d'une majesté absolue. On y touchait le ciel !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Gloom_StoryDazzlingTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La Team Dazzling fait sensation à Metano Town...", "Normal")
  UI:WaitShowDialogue("Leurs voix magiques s'entendent jusqu'aux confins de la forêt.")
  UI:WaitShowDialogue("On dit qu'elles préparent un grand spectacle pour fêter leur prochaine victoire.")
  UI:WaitShowDialogue("Mais certains érudits pensent qu'il y a une magie ancienne derrière leur chant.")
  UI:WaitShowDialogue("Nous verrons bien si elles parviennent à apaiser le roi de la jungle !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Gloom_ExpeditionBivouacTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les récits de votre bivouac au Mont Venteux sont incroyables...", "Normal")
  UI:WaitShowDialogue("Dormir sous les étoiles, à l'écoute du chant mystique de la montagne...")
  UI:WaitShowDialogue("C'est le genre d'expérience qui forge l'âme d'un véritable aventurier.")
  UI:WaitShowDialogue("Toute la ville est fière de voir votre équipe progresser si vite !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Oddish_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est une magnifique journée d'histoire.", "Normal")
  UI:WaitShowDialogue("Le Chapitre 6 est plein d'aventures et de rumeurs mystérieuses dans la Forêt Lugubre.")
  UI:WaitShowDialogue("Certains disent avoir vu une ombre gigantesque courir à travers les lianes...")
  UI:WaitShowDialogue("...Serait-ce le terrible Zeraora ? Personne n'ose s'en approcher de trop près.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Forêt Lugubre", "La Team Dazzling", "L'expédition", "Rien"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Forêt Lugubre est située juste au nord du village. L'air y est très lourd.")
    UI:WaitShowDialogue("On raconte que les arbres bougent tout seuls et que les lianes emprisonnent les intrus.")
    UI:WaitShowDialogue("Si vous y entrez, restez sur vos gardes. Ne laissez jamais votre partenaire seul.")
    UI:WaitShowDialogue("Et surtout... méfiez-vous du cri de la jungle. Il annonce la colère de son roi.")
    UI:WaitShowDialogue("Je crois que même la guilde n'a pas encore cartographié tout le donjon.")
    UI:WaitShowDialogue("Mais avec votre courage, je sais que vous pourrez y arriver et sauver le petit !")
  elseif choice == 2 then
    UI:WaitShowDialogue("La Team Dazzling... Elles sont arrivées de la côte il y a quelques jours seulement.")
    UI:WaitShowDialogue("Adagio est si polie mais on sent toute sa supériorité dans ses paroles.")
    UI:WaitShowDialogue("Aria est très provocatrice, elle passe son temps à sauter de joie et à se moquer.")
    UI:WaitShowDialogue("Et Sonata... elle est tellement théâtrale avec ses mimiques et ses colères !")
    UI:WaitShowDialogue("Elles se croient déjà au sommet, prétendant que ce sauvetage n'est qu'un jeu pour elles.")
    UI:WaitShowDialogue("Ne les laissez pas vous intimider. Montrez-leur de quel bois vous vous chauffez !")
    UI:WaitShowDialogue("Toute la ville attend de voir qui ramènera le Chenipent en premier.")
  elseif choice == 3 then
    UI:WaitShowDialogue("L'expédition du Mont Venteux... C'était une aventure extraordinaire.")
    UI:WaitShowDialogue("Vous avez gravi les sommets, traversé les tempêtes et affronté le Seigneur des Vents.")
    UI:WaitShowDialogue("Le doyen Penticus m'a dit que votre exploit résonnera longtemps à la guilde.")
    UI:WaitShowDialogue("Mais ce n'était que le début de l'histoire, je le ressens au fond de mes os.")
    UI:WaitShowDialogue("Les flux d'énergie continuent de s'agiter sous la terre, de plus en plus chauds.")
    UI:WaitShowDialogue("Restez forts, mes amis. Le monde a plus que jamais besoin de héros.")
  else
    UI:WaitShowDialogue("D'accord. Prenez soin de vous sur les sentiers et dans les donjons.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Oddish_GossipTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Oh, vous revoilà ! J'ai encore entendu d'étranges rumeurs...", "Normal")
  UI:WaitShowDialogue("On dit que la Team Dazzling n'est pas là pour faire du secours, mais pour un secret...")
  UI:WaitShowDialogue("Elles fouillent les recoins du village et de la guilde, murmurant entre elles.")
  UI:WaitShowDialogue("Même les marchands du marché les trouvent suspectes, malgré leur éclat.")
  UI:WaitShowDialogue("Qu'en pensez-vous ? Pensez-vous qu'elles complotent quelque chose de louche ?")
  UI:BeginChoiceMenu("Que lui dites-vous ?", {"Elles complotent", "Elles sont juste fières", "Je ne sais pas"}, 1, 3)
  UI:WaitForChoice()
  local result = UI:ChoiceResult()
  if result == 1 then
    UI:WaitShowDialogue("Je le savais ! Leurs mines mystérieuses et leurs messes basses ne trompent personne.")
    UI:WaitShowDialogue("Même le Doyen Penticus les surveille du coin de l'œil, je l'ai vu hier.")
    UI:WaitShowDialogue("Faites bien attention si vous les croisez dans la Forêt Lugubre.")
  elseif result == 2 then
    UI:WaitShowDialogue("C'est possible. Les équipes de la côte ont toujours cette fierté un peu agaçante.")
    UI:WaitShowDialogue("Après tout, elles ont une grande réputation à tenir, mais quand même...")
    UI:WaitShowDialogue("Ne relâchez pas votre attention pour autant. On ne sait jamais.")
  else
    UI:WaitShowDialogue("La prudence est mère de sûreté, comme on dit toujours à la guilde.")
    UI:WaitShowDialogue("Nous verrons bien ce que l'avenir nous réserve. Restons concentrés.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Oddish_RaidTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous entendu les rumeurs sur les pilleurs nocturnes ?", "Worried")
  UI:WaitShowDialogue("On dit que des spectres rodent dans les ombres de la ville dès que la nuit tombe...")
  UI:WaitShowDialogue("Ils forcent les coffres, pillent les stands et s'enfuient sans laisser de traces.")
  UI:WaitShowDialogue("La place entière retient son souffle dès que le soleil se couche.")
  UI:WaitShowDialogue("Si vous veillez de nuit, soyez extrêmement prudents. Ils sont redoutables.")
  UI:WaitShowDialogue("Mais je sais que votre équipe a le courage de défendre notre ville de Metano !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Oddish_PrepTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avant de repartir en mission, assurez-vous d'être bien préparés !", "Normal")
  UI:WaitShowDialogue("La Forêt Lugubre ne pardonne pas le manque d'organisation.")
  UI:WaitShowDialogue("Prenez toujours des Baies Oran, des Baies Ceriz et des Échapporbes en cas de besoin.")
  UI:WaitShowDialogue("L'entrepôt de la guilde est là pour stocker vos trésors précieux.")
  UI:WaitShowDialogue("Même l'équipe la plus forte peut faillir sans un bon équipement.")
  UI:WaitShowDialogue("Faites-moi confiance, la préparation est la clé de toute grande aventure !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Oddish_RelaxTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'ambiance au café est si relaxante en ce moment...", "Normal")
  UI:WaitShowDialogue("C'est l'endroit idéal pour faire une pause et discuter avec les autres.")
  UI:WaitShowDialogue("Après une longue journée dans les donjons, rien ne vaut une bonne boisson chaude.")
  UI:WaitShowDialogue("Même les rumeurs les plus folles se partagent ici autour d'une table.")
  UI:WaitShowDialogue("Prenez le temps de souffler un peu avant de retourner affronter la jungle.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Oddish_DazzlingChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, que pensez-vous de chaque membre des Dazzling ?", "Normal")
  UI:BeginChoiceMenu("Qui souhaitez-vous évaluer ?", {"Adagio", "Aria", "Sonata", "Toutes"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Adagio est d'une élégance rare, mais ses yeux brillent d'une ambition froide.")
  elseif res == 2 then
    UI:WaitShowDialogue("Aria ne fait que s'exciter et provoquer tout le monde. C'est insupportable.")
  elseif res == 3 then
    UI:WaitShowDialogue("Sonata est tellement théâtrale ! Ses grands gestes amusent la galerie.")
  else
    UI:WaitShowDialogue("Elles forment un groupe redoutable. Ne sous-estimez jamais leur union.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Oddish_ExpeditionChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "L'expédition reste le plus grand événement de l'année !", "Normal")
  UI:WaitShowDialogue("Chacun de nous en garde un souvenir marquant et impérissable.")
  UI:WaitShowDialogue("Pour certains, c'était la première fois qu'ils voyaient de si grandes montagnes.")
  UI:WaitShowDialogue("Et pour vous, quel reste le plus beau souvenir de cette ascension ?")
  UI:BeginChoiceMenu("Votre moment favori :", {"Le feu de camp", "La tempête", "Le sommet"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Le feu de camp était si convivial, à partager des rumeurs au milieu de la nuit !")
  elseif res == 2 then
    UI:WaitShowDialogue("La tempête était terrifiante, mais elle a montré toute la force de notre guilde !")
  else
    UI:WaitShowDialogue("Le sommet Venteux était d'une majesté absolue. On y touchait le ciel !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Oddish_StoryDazzlingTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La Team Dazzling fait sensation à Metano Town...", "Normal")
  UI:WaitShowDialogue("Leurs voix magiques s'entendent jusqu'aux confins de la forêt.")
  UI:WaitShowDialogue("On dit qu'elles préparent un grand spectacle pour fêter leur prochaine victoire.")
  UI:WaitShowDialogue("Mais certains érudits pensent qu'il y a une magie ancienne derrière leur chant.")
  UI:WaitShowDialogue("Nous verrons bien si elles parviennent à apaiser le roi de la jungle !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Oddish_ExpeditionBivouacTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les récits de votre bivouac au Mont Venteux sont incroyables...", "Normal")
  UI:WaitShowDialogue("Dormir sous les étoiles, à l'écoute du chant mystique de la montagne...")
  UI:WaitShowDialogue("C'est le genre d'expérience qui forge l'âme d'un véritable aventurier.")
  UI:WaitShowDialogue("Toute la ville est fière de voir votre équipe progresser si vite !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Numel_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est une magnifique journée d'histoire.", "Normal")
  UI:WaitShowDialogue("Le Chapitre 6 est plein d'aventures et de rumeurs mystérieuses dans la Forêt Lugubre.")
  UI:WaitShowDialogue("Certains disent avoir vu une ombre gigantesque courir à travers les lianes...")
  UI:WaitShowDialogue("...Serait-ce le terrible Zeraora ? Personne n'ose s'en approcher de trop près.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Forêt Lugubre", "La Team Dazzling", "L'expédition", "Rien"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Forêt Lugubre est située juste au nord du village. L'air y est très lourd.")
    UI:WaitShowDialogue("On raconte que les arbres bougent tout seuls et que les lianes emprisonnent les intrus.")
    UI:WaitShowDialogue("Si vous y entrez, restez sur vos gardes. Ne laissez jamais votre partenaire seul.")
    UI:WaitShowDialogue("Et surtout... méfiez-vous du cri de la jungle. Il annonce la colère de son roi.")
    UI:WaitShowDialogue("Je crois que même la guilde n'a pas encore cartographié tout le donjon.")
    UI:WaitShowDialogue("Mais avec votre courage, je sais que vous pourrez y arriver et sauver le petit !")
  elseif choice == 2 then
    UI:WaitShowDialogue("La Team Dazzling... Elles sont arrivées de la côte il y a quelques jours seulement.")
    UI:WaitShowDialogue("Adagio est si polie mais on sent toute sa supériorité dans ses paroles.")
    UI:WaitShowDialogue("Aria est très provocatrice, elle passe son temps à sauter de joie et à se moquer.")
    UI:WaitShowDialogue("Et Sonata... elle est tellement théâtrale avec ses mimiques et ses colères !")
    UI:WaitShowDialogue("Elles se croient déjà au sommet, prétendant que ce sauvetage n'est qu'un jeu pour elles.")
    UI:WaitShowDialogue("Ne les laissez pas vous intimider. Montrez-leur de quel bois vous vous chauffez !")
    UI:WaitShowDialogue("Toute la ville attend de voir qui ramènera le Chenipent en premier.")
  elseif choice == 3 then
    UI:WaitShowDialogue("L'expédition du Mont Venteux... C'était une aventure extraordinaire.")
    UI:WaitShowDialogue("Vous avez gravi les sommets, traversé les tempêtes et affronté le Seigneur des Vents.")
    UI:WaitShowDialogue("Le doyen Penticus m'a dit que votre exploit résonnera longtemps à la guilde.")
    UI:WaitShowDialogue("Mais ce n'était que le début de l'histoire, je le ressens au fond de mes os.")
    UI:WaitShowDialogue("Les flux d'énergie continuent de s'agiter sous la terre, de plus en plus chauds.")
    UI:WaitShowDialogue("Restez forts, mes amis. Le monde a plus que jamais besoin de héros.")
  else
    UI:WaitShowDialogue("D'accord. Prenez soin de vous sur les sentiers et dans les donjons.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Numel_GossipTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Oh, vous revoilà ! J'ai encore entendu d'étranges rumeurs...", "Normal")
  UI:WaitShowDialogue("On dit que la Team Dazzling n'est pas là pour faire du secours, mais pour un secret...")
  UI:WaitShowDialogue("Elles fouillent les recoins du village et de la guilde, murmurant entre elles.")
  UI:WaitShowDialogue("Même les marchands du marché les trouvent suspectes, malgré leur éclat.")
  UI:WaitShowDialogue("Qu'en pensez-vous ? Pensez-vous qu'elles complotent quelque chose de louche ?")
  UI:BeginChoiceMenu("Que lui dites-vous ?", {"Elles complotent", "Elles sont juste fières", "Je ne sais pas"}, 1, 3)
  UI:WaitForChoice()
  local result = UI:ChoiceResult()
  if result == 1 then
    UI:WaitShowDialogue("Je le savais ! Leurs mines mystérieuses et leurs messes basses ne trompent personne.")
    UI:WaitShowDialogue("Même le Doyen Penticus les surveille du coin de l'œil, je l'ai vu hier.")
    UI:WaitShowDialogue("Faites bien attention si vous les croisez dans la Forêt Lugubre.")
  elseif result == 2 then
    UI:WaitShowDialogue("C'est possible. Les équipes de la côte ont toujours cette fierté un peu agaçante.")
    UI:WaitShowDialogue("Après tout, elles ont une grande réputation à tenir, mais quand même...")
    UI:WaitShowDialogue("Ne relâchez pas votre attention pour autant. On ne sait jamais.")
  else
    UI:WaitShowDialogue("La prudence est mère de sûreté, comme on dit toujours à la guilde.")
    UI:WaitShowDialogue("Nous verrons bien ce que l'avenir nous réserve. Restons concentrés.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Numel_RaidTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous entendu les rumeurs sur les pilleurs nocturnes ?", "Worried")
  UI:WaitShowDialogue("On dit que des spectres rodent dans les ombres de la ville dès que la nuit tombe...")
  UI:WaitShowDialogue("Ils forcent les coffres, pillent les stands et s'enfuient sans laisser de traces.")
  UI:WaitShowDialogue("La place entière retient son souffle dès que le soleil se couche.")
  UI:WaitShowDialogue("Si vous veillez de nuit, soyez extrêmement prudents. Ils sont redoutables.")
  UI:WaitShowDialogue("Mais je sais que votre équipe a le courage de défendre notre ville de Metano !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Numel_PrepTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avant de repartir en mission, assurez-vous d'être bien préparés !", "Normal")
  UI:WaitShowDialogue("La Forêt Lugubre ne pardonne pas le manque d'organisation.")
  UI:WaitShowDialogue("Prenez toujours des Baies Oran, des Baies Ceriz et des Échapporbes en cas de besoin.")
  UI:WaitShowDialogue("L'entrepôt de la guilde est là pour stocker vos trésors précieux.")
  UI:WaitShowDialogue("Même l'équipe la plus forte peut faillir sans un bon équipement.")
  UI:WaitShowDialogue("Faites-moi confiance, la préparation est la clé de toute grande aventure !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Numel_RelaxTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'ambiance au café est si relaxante en ce moment...", "Normal")
  UI:WaitShowDialogue("C'est l'endroit idéal pour faire une pause et discuter avec les autres.")
  UI:WaitShowDialogue("Après une longue journée dans les donjons, rien ne vaut une bonne boisson chaude.")
  UI:WaitShowDialogue("Même les rumeurs les plus folles se partagent ici autour d'une table.")
  UI:WaitShowDialogue("Prenez le temps de souffler un peu avant de retourner affronter la jungle.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Numel_DazzlingChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, que pensez-vous de chaque membre des Dazzling ?", "Normal")
  UI:BeginChoiceMenu("Qui souhaitez-vous évaluer ?", {"Adagio", "Aria", "Sonata", "Toutes"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Adagio est d'une élégance rare, mais ses yeux brillent d'une ambition froide.")
  elseif res == 2 then
    UI:WaitShowDialogue("Aria ne fait que s'exciter et provoquer tout le monde. C'est insupportable.")
  elseif res == 3 then
    UI:WaitShowDialogue("Sonata est tellement théâtrale ! Ses grands gestes amusent la galerie.")
  else
    UI:WaitShowDialogue("Elles forment un groupe redoutable. Ne sous-estimez jamais leur union.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Numel_ExpeditionChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "L'expédition reste le plus grand événement de l'année !", "Normal")
  UI:WaitShowDialogue("Chacun de nous en garde un souvenir marquant et impérissable.")
  UI:WaitShowDialogue("Pour certains, c'était la première fois qu'ils voyaient de si grandes montagnes.")
  UI:WaitShowDialogue("Et pour vous, quel reste le plus beau souvenir de cette ascension ?")
  UI:BeginChoiceMenu("Votre moment favori :", {"Le feu de camp", "La tempête", "Le sommet"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Le feu de camp était si convivial, à partager des rumeurs au milieu de la nuit !")
  elseif res == 2 then
    UI:WaitShowDialogue("La tempête était terrifiante, mais elle a montré toute la force de notre guilde !")
  else
    UI:WaitShowDialogue("Le sommet Venteux était d'une majesté absolue. On y touchait le ciel !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Numel_StoryDazzlingTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La Team Dazzling fait sensation à Metano Town...", "Normal")
  UI:WaitShowDialogue("Leurs voix magiques s'entendent jusqu'aux confins de la forêt.")
  UI:WaitShowDialogue("On dit qu'elles préparent un grand spectacle pour fêter leur prochaine victoire.")
  UI:WaitShowDialogue("Mais certains érudits pensent qu'il y a une magie ancienne derrière leur chant.")
  UI:WaitShowDialogue("Nous verrons bien si elles parviennent à apaiser le roi de la jungle !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Numel_ExpeditionBivouacTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les récits de votre bivouac au Mont Venteux sont incroyables...", "Normal")
  UI:WaitShowDialogue("Dormir sous les étoiles, à l'écoute du chant mystique de la montagne...")
  UI:WaitShowDialogue("C'est le genre d'expérience qui forge l'âme d'un véritable aventurier.")
  UI:WaitShowDialogue("Toute la ville est fière de voir votre équipe progresser si vite !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Bellossom_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est une magnifique journée d'histoire.", "Normal")
  UI:WaitShowDialogue("Le Chapitre 6 est plein d'aventures et de rumeurs mystérieuses dans la Forêt Lugubre.")
  UI:WaitShowDialogue("Certains disent avoir vu une ombre gigantesque courir à travers les lianes...")
  UI:WaitShowDialogue("...Serait-ce le terrible Zeraora ? Personne n'ose s'en approcher de trop près.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Forêt Lugubre", "La Team Dazzling", "L'expédition", "Rien"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Forêt Lugubre est située juste au nord du village. L'air y est très lourd.")
    UI:WaitShowDialogue("On raconte que les arbres bougent tout seuls et que les lianes emprisonnent les intrus.")
    UI:WaitShowDialogue("Si vous y entrez, restez sur vos gardes. Ne laissez jamais votre partenaire seul.")
    UI:WaitShowDialogue("Et surtout... méfiez-vous du cri de la jungle. Il annonce la colère de son roi.")
    UI:WaitShowDialogue("Je crois que même la guilde n'a pas encore cartographié tout le donjon.")
    UI:WaitShowDialogue("Mais avec votre courage, je sais que vous pourrez y arriver et sauver le petit !")
  elseif choice == 2 then
    UI:WaitShowDialogue("La Team Dazzling... Elles sont arrivées de la côte il y a quelques jours seulement.")
    UI:WaitShowDialogue("Adagio est si polie mais on sent toute sa supériorité dans ses paroles.")
    UI:WaitShowDialogue("Aria est très provocatrice, elle passe son temps à sauter de joie et à se moquer.")
    UI:WaitShowDialogue("Et Sonata... elle est tellement théâtrale avec ses mimiques et ses colères !")
    UI:WaitShowDialogue("Elles se croient déjà au sommet, prétendant que ce sauvetage n'est qu'un jeu pour elles.")
    UI:WaitShowDialogue("Ne les laissez pas vous intimider. Montrez-leur de quel bois vous vous chauffez !")
    UI:WaitShowDialogue("Toute la ville attend de voir qui ramènera le Chenipent en premier.")
  elseif choice == 3 then
    UI:WaitShowDialogue("L'expédition du Mont Venteux... C'était une aventure extraordinaire.")
    UI:WaitShowDialogue("Vous avez gravi les sommets, traversé les tempêtes et affronté le Seigneur des Vents.")
    UI:WaitShowDialogue("Le doyen Penticus m'a dit que votre exploit résonnera longtemps à la guilde.")
    UI:WaitShowDialogue("Mais ce n'était que le début de l'histoire, je le ressens au fond de mes os.")
    UI:WaitShowDialogue("Les flux d'énergie continuent de s'agiter sous la terre, de plus en plus chauds.")
    UI:WaitShowDialogue("Restez forts, mes amis. Le monde a plus que jamais besoin de héros.")
  else
    UI:WaitShowDialogue("D'accord. Prenez soin de vous sur les sentiers et dans les donjons.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Bellossom_GossipTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Oh, vous revoilà ! J'ai encore entendu d'étranges rumeurs...", "Normal")
  UI:WaitShowDialogue("On dit que la Team Dazzling n'est pas là pour faire du secours, mais pour un secret...")
  UI:WaitShowDialogue("Elles fouillent les recoins du village et de la guilde, murmurant entre elles.")
  UI:WaitShowDialogue("Même les marchands du marché les trouvent suspectes, malgré leur éclat.")
  UI:WaitShowDialogue("Qu'en pensez-vous ? Pensez-vous qu'elles complotent quelque chose de louche ?")
  UI:BeginChoiceMenu("Que lui dites-vous ?", {"Elles complotent", "Elles sont juste fières", "Je ne sais pas"}, 1, 3)
  UI:WaitForChoice()
  local result = UI:ChoiceResult()
  if result == 1 then
    UI:WaitShowDialogue("Je le savais ! Leurs mines mystérieuses et leurs messes basses ne trompent personne.")
    UI:WaitShowDialogue("Même le Doyen Penticus les surveille du coin de l'œil, je l'ai vu hier.")
    UI:WaitShowDialogue("Faites bien attention si vous les croisez dans la Forêt Lugubre.")
  elseif result == 2 then
    UI:WaitShowDialogue("C'est possible. Les équipes de la côte ont toujours cette fierté un peu agaçante.")
    UI:WaitShowDialogue("Après tout, elles ont une grande réputation à tenir, mais quand même...")
    UI:WaitShowDialogue("Ne relâchez pas votre attention pour autant. On ne sait jamais.")
  else
    UI:WaitShowDialogue("La prudence est mère de sûreté, comme on dit toujours à la guilde.")
    UI:WaitShowDialogue("Nous verrons bien ce que l'avenir nous réserve. Restons concentrés.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Bellossom_RaidTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous entendu les rumeurs sur les pilleurs nocturnes ?", "Worried")
  UI:WaitShowDialogue("On dit que des spectres rodent dans les ombres de la ville dès que la nuit tombe...")
  UI:WaitShowDialogue("Ils forcent les coffres, pillent les stands et s'enfuient sans laisser de traces.")
  UI:WaitShowDialogue("La place entière retient son souffle dès que le soleil se couche.")
  UI:WaitShowDialogue("Si vous veillez de nuit, soyez extrêmement prudents. Ils sont redoutables.")
  UI:WaitShowDialogue("Mais je sais que votre équipe a le courage de défendre notre ville de Metano !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Bellossom_PrepTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avant de repartir en mission, assurez-vous d'être bien préparés !", "Normal")
  UI:WaitShowDialogue("La Forêt Lugubre ne pardonne pas le manque d'organisation.")
  UI:WaitShowDialogue("Prenez toujours des Baies Oran, des Baies Ceriz et des Échapporbes en cas de besoin.")
  UI:WaitShowDialogue("L'entrepôt de la guilde est là pour stocker vos trésors précieux.")
  UI:WaitShowDialogue("Même l'équipe la plus forte peut faillir sans un bon équipement.")
  UI:WaitShowDialogue("Faites-moi confiance, la préparation est la clé de toute grande aventure !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Bellossom_RelaxTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'ambiance au café est si relaxante en ce moment...", "Normal")
  UI:WaitShowDialogue("C'est l'endroit idéal pour faire une pause et discuter avec les autres.")
  UI:WaitShowDialogue("Après une longue journée dans les donjons, rien ne vaut une bonne boisson chaude.")
  UI:WaitShowDialogue("Même les rumeurs les plus folles se partagent ici autour d'une table.")
  UI:WaitShowDialogue("Prenez le temps de souffler un peu avant de retourner affronter la jungle.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Bellossom_DazzlingChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, que pensez-vous de chaque membre des Dazzling ?", "Normal")
  UI:BeginChoiceMenu("Qui souhaitez-vous évaluer ?", {"Adagio", "Aria", "Sonata", "Toutes"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Adagio est d'une élégance rare, mais ses yeux brillent d'une ambition froide.")
  elseif res == 2 then
    UI:WaitShowDialogue("Aria ne fait que s'exciter et provoquer tout le monde. C'est insupportable.")
  elseif res == 3 then
    UI:WaitShowDialogue("Sonata est tellement théâtrale ! Ses grands gestes amusent la galerie.")
  else
    UI:WaitShowDialogue("Elles forment un groupe redoutable. Ne sous-estimez jamais leur union.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Bellossom_ExpeditionChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "L'expédition reste le plus grand événement de l'année !", "Normal")
  UI:WaitShowDialogue("Chacun de nous en garde un souvenir marquant et impérissable.")
  UI:WaitShowDialogue("Pour certains, c'était la première fois qu'ils voyaient de si grandes montagnes.")
  UI:WaitShowDialogue("Et pour vous, quel reste le plus beau souvenir de cette ascension ?")
  UI:BeginChoiceMenu("Votre moment favori :", {"Le feu de camp", "La tempête", "Le sommet"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Le feu de camp était si convivial, à partager des rumeurs au milieu de la nuit !")
  elseif res == 2 then
    UI:WaitShowDialogue("La tempête était terrifiante, mais elle a montré toute la force de notre guilde !")
  else
    UI:WaitShowDialogue("Le sommet Venteux était d'une majesté absolue. On y touchait le ciel !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Bellossom_StoryDazzlingTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La Team Dazzling fait sensation à Metano Town...", "Normal")
  UI:WaitShowDialogue("Leurs voix magiques s'entendent jusqu'aux confins de la forêt.")
  UI:WaitShowDialogue("On dit qu'elles préparent un grand spectacle pour fêter leur prochaine victoire.")
  UI:WaitShowDialogue("Mais certains érudits pensent qu'il y a une magie ancienne derrière leur chant.")
  UI:WaitShowDialogue("Nous verrons bien si elles parviennent à apaiser le roi de la jungle !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Bellossom_ExpeditionBivouacTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les récits de votre bivouac au Mont Venteux sont incroyables...", "Normal")
  UI:WaitShowDialogue("Dormir sous les étoiles, à l'écoute du chant mystique de la montagne...")
  UI:WaitShowDialogue("C'est le genre d'expérience qui forge l'âme d'un véritable aventurier.")
  UI:WaitShowDialogue("Toute la ville est fière de voir votre équipe progresser si vite !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Zigzagoon_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est une magnifique journée d'histoire.", "Normal")
  UI:WaitShowDialogue("Le Chapitre 6 est plein d'aventures et de rumeurs mystérieuses dans la Forêt Lugubre.")
  UI:WaitShowDialogue("Certains disent avoir vu une ombre gigantesque courir à travers les lianes...")
  UI:WaitShowDialogue("...Serait-ce le terrible Zeraora ? Personne n'ose s'en approcher de trop près.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Forêt Lugubre", "La Team Dazzling", "L'expédition", "Rien"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Forêt Lugubre est située juste au nord du village. L'air y est très lourd.")
    UI:WaitShowDialogue("On raconte que les arbres bougent tout seuls et que les lianes emprisonnent les intrus.")
    UI:WaitShowDialogue("Si vous y entrez, restez sur vos gardes. Ne laissez jamais votre partenaire seul.")
    UI:WaitShowDialogue("Et surtout... méfiez-vous du cri de la jungle. Il annonce la colère de son roi.")
    UI:WaitShowDialogue("Je crois que même la guilde n'a pas encore cartographié tout le donjon.")
    UI:WaitShowDialogue("Mais avec votre courage, je sais que vous pourrez y arriver et sauver le petit !")
  elseif choice == 2 then
    UI:WaitShowDialogue("La Team Dazzling... Elles sont arrivées de la côte il y a quelques jours seulement.")
    UI:WaitShowDialogue("Adagio est si polie mais on sent toute sa supériorité dans ses paroles.")
    UI:WaitShowDialogue("Aria est très provocatrice, elle passe son temps à sauter de joie et à se moquer.")
    UI:WaitShowDialogue("Et Sonata... elle est tellement théâtrale avec ses mimiques et ses colères !")
    UI:WaitShowDialogue("Elles se croient déjà au sommet, prétendant que ce sauvetage n'est qu'un jeu pour elles.")
    UI:WaitShowDialogue("Ne les laissez pas vous intimider. Montrez-leur de quel bois vous vous chauffez !")
    UI:WaitShowDialogue("Toute la ville attend de voir qui ramènera le Chenipent en premier.")
  elseif choice == 3 then
    UI:WaitShowDialogue("L'expédition du Mont Venteux... C'était une aventure extraordinaire.")
    UI:WaitShowDialogue("Vous avez gravi les sommets, traversé les tempêtes et affronté le Seigneur des Vents.")
    UI:WaitShowDialogue("Le doyen Penticus m'a dit que votre exploit résonnera longtemps à la guilde.")
    UI:WaitShowDialogue("Mais ce n'était que le début de l'histoire, je le ressens au fond de mes os.")
    UI:WaitShowDialogue("Les flux d'énergie continuent de s'agiter sous la terre, de plus en plus chauds.")
    UI:WaitShowDialogue("Restez forts, mes amis. Le monde a plus que jamais besoin de héros.")
  else
    UI:WaitShowDialogue("D'accord. Prenez soin de vous sur les sentiers et dans les donjons.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Zigzagoon_GossipTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Oh, vous revoilà ! J'ai encore entendu d'étranges rumeurs...", "Normal")
  UI:WaitShowDialogue("On dit que la Team Dazzling n'est pas là pour faire du secours, mais pour un secret...")
  UI:WaitShowDialogue("Elles fouillent les recoins du village et de la guilde, murmurant entre elles.")
  UI:WaitShowDialogue("Même les marchands du marché les trouvent suspectes, malgré leur éclat.")
  UI:WaitShowDialogue("Qu'en pensez-vous ? Pensez-vous qu'elles complotent quelque chose de louche ?")
  UI:BeginChoiceMenu("Que lui dites-vous ?", {"Elles complotent", "Elles sont juste fières", "Je ne sais pas"}, 1, 3)
  UI:WaitForChoice()
  local result = UI:ChoiceResult()
  if result == 1 then
    UI:WaitShowDialogue("Je le savais ! Leurs mines mystérieuses et leurs messes basses ne trompent personne.")
    UI:WaitShowDialogue("Même le Doyen Penticus les surveille du coin de l'œil, je l'ai vu hier.")
    UI:WaitShowDialogue("Faites bien attention si vous les croisez dans la Forêt Lugubre.")
  elseif result == 2 then
    UI:WaitShowDialogue("C'est possible. Les équipes de la côte ont toujours cette fierté un peu agaçante.")
    UI:WaitShowDialogue("Après tout, elles ont une grande réputation à tenir, mais quand même...")
    UI:WaitShowDialogue("Ne relâchez pas votre attention pour autant. On ne sait jamais.")
  else
    UI:WaitShowDialogue("La prudence est mère de sûreté, comme on dit toujours à la guilde.")
    UI:WaitShowDialogue("Nous verrons bien ce que l'avenir nous réserve. Restons concentrés.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Zigzagoon_RaidTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous entendu les rumeurs sur les pilleurs nocturnes ?", "Worried")
  UI:WaitShowDialogue("On dit que des spectres rodent dans les ombres de la ville dès que la nuit tombe...")
  UI:WaitShowDialogue("Ils forcent les coffres, pillent les stands et s'enfuient sans laisser de traces.")
  UI:WaitShowDialogue("La place entière retient son souffle dès que le soleil se couche.")
  UI:WaitShowDialogue("Si vous veillez de nuit, soyez extrêmement prudents. Ils sont redoutables.")
  UI:WaitShowDialogue("Mais je sais que votre équipe a le courage de défendre notre ville de Metano !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Zigzagoon_PrepTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avant de repartir en mission, assurez-vous d'être bien préparés !", "Normal")
  UI:WaitShowDialogue("La Forêt Lugubre ne pardonne pas le manque d'organisation.")
  UI:WaitShowDialogue("Prenez toujours des Baies Oran, des Baies Ceriz et des Échapporbes en cas de besoin.")
  UI:WaitShowDialogue("L'entrepôt de la guilde est là pour stocker vos trésors précieux.")
  UI:WaitShowDialogue("Même l'équipe la plus forte peut faillir sans un bon équipement.")
  UI:WaitShowDialogue("Faites-moi confiance, la préparation est la clé de toute grande aventure !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Zigzagoon_RelaxTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'ambiance au café est si relaxante en ce moment...", "Normal")
  UI:WaitShowDialogue("C'est l'endroit idéal pour faire une pause et discuter avec les autres.")
  UI:WaitShowDialogue("Après une longue journée dans les donjons, rien ne vaut une bonne boisson chaude.")
  UI:WaitShowDialogue("Même les rumeurs les plus folles se partagent ici autour d'une table.")
  UI:WaitShowDialogue("Prenez le temps de souffler un peu avant de retourner affronter la jungle.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Zigzagoon_DazzlingChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, que pensez-vous de chaque membre des Dazzling ?", "Normal")
  UI:BeginChoiceMenu("Qui souhaitez-vous évaluer ?", {"Adagio", "Aria", "Sonata", "Toutes"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Adagio est d'une élégance rare, mais ses yeux brillent d'une ambition froide.")
  elseif res == 2 then
    UI:WaitShowDialogue("Aria ne fait que s'exciter et provoquer tout le monde. C'est insupportable.")
  elseif res == 3 then
    UI:WaitShowDialogue("Sonata est tellement théâtrale ! Ses grands gestes amusent la galerie.")
  else
    UI:WaitShowDialogue("Elles forment un groupe redoutable. Ne sous-estimez jamais leur union.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Zigzagoon_ExpeditionChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "L'expédition reste le plus grand événement de l'année !", "Normal")
  UI:WaitShowDialogue("Chacun de nous en garde un souvenir marquant et impérissable.")
  UI:WaitShowDialogue("Pour certains, c'était la première fois qu'ils voyaient de si grandes montagnes.")
  UI:WaitShowDialogue("Et pour vous, quel reste le plus beau souvenir de cette ascension ?")
  UI:BeginChoiceMenu("Votre moment favori :", {"Le feu de camp", "La tempête", "Le sommet"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Le feu de camp était si convivial, à partager des rumeurs au milieu de la nuit !")
  elseif res == 2 then
    UI:WaitShowDialogue("La tempête était terrifiante, mais elle a montré toute la force de notre guilde !")
  else
    UI:WaitShowDialogue("Le sommet Venteux était d'une majesté absolue. On y touchait le ciel !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Zigzagoon_StoryDazzlingTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La Team Dazzling fait sensation à Metano Town...", "Normal")
  UI:WaitShowDialogue("Leurs voix magiques s'entendent jusqu'aux confins de la forêt.")
  UI:WaitShowDialogue("On dit qu'elles préparent un grand spectacle pour fêter leur prochaine victoire.")
  UI:WaitShowDialogue("Mais certains érudits pensent qu'il y a une magie ancienne derrière leur chant.")
  UI:WaitShowDialogue("Nous verrons bien si elles parviennent à apaiser le roi de la jungle !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Zigzagoon_ExpeditionBivouacTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les récits de votre bivouac au Mont Venteux sont incroyables...", "Normal")
  UI:WaitShowDialogue("Dormir sous les étoiles, à l'écoute du chant mystique de la montagne...")
  UI:WaitShowDialogue("C'est le genre d'expérience qui forge l'âme d'un véritable aventurier.")
  UI:WaitShowDialogue("Toute la ville est fière de voir votre équipe progresser si vite !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Nidoking_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est une magnifique journée d'histoire.", "Normal")
  UI:WaitShowDialogue("Le Chapitre 6 est plein d'aventures et de rumeurs mystérieuses dans la Forêt Lugubre.")
  UI:WaitShowDialogue("Certains disent avoir vu une ombre gigantesque courir à travers les lianes...")
  UI:WaitShowDialogue("...Serait-ce le terrible Zeraora ? Personne n'ose s'en approcher de trop près.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Forêt Lugubre", "La Team Dazzling", "L'expédition", "Rien"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Forêt Lugubre est située juste au nord du village. L'air y est très lourd.")
    UI:WaitShowDialogue("On raconte que les arbres bougent tout seuls et que les lianes emprisonnent les intrus.")
    UI:WaitShowDialogue("Si vous y entrez, restez sur vos gardes. Ne laissez jamais votre partenaire seul.")
    UI:WaitShowDialogue("Et surtout... méfiez-vous du cri de la jungle. Il annonce la colère de son roi.")
    UI:WaitShowDialogue("Je crois que même la guilde n'a pas encore cartographié tout le donjon.")
    UI:WaitShowDialogue("Mais avec votre courage, je sais que vous pourrez y arriver et sauver le petit !")
  elseif choice == 2 then
    UI:WaitShowDialogue("La Team Dazzling... Elles sont arrivées de la côte il y a quelques jours seulement.")
    UI:WaitShowDialogue("Adagio est si polie mais on sent toute sa supériorité dans ses paroles.")
    UI:WaitShowDialogue("Aria est très provocatrice, elle passe son temps à sauter de joie et à se moquer.")
    UI:WaitShowDialogue("Et Sonata... elle est tellement théâtrale avec ses mimiques et ses colères !")
    UI:WaitShowDialogue("Elles se croient déjà au sommet, prétendant que ce sauvetage n'est qu'un jeu pour elles.")
    UI:WaitShowDialogue("Ne les laissez pas vous intimider. Montrez-leur de quel bois vous vous chauffez !")
    UI:WaitShowDialogue("Toute la ville attend de voir qui ramènera le Chenipent en premier.")
  elseif choice == 3 then
    UI:WaitShowDialogue("L'expédition du Mont Venteux... C'était une aventure extraordinaire.")
    UI:WaitShowDialogue("Vous avez gravi les sommets, traversé les tempêtes et affronté le Seigneur des Vents.")
    UI:WaitShowDialogue("Le doyen Penticus m'a dit que votre exploit résonnera longtemps à la guilde.")
    UI:WaitShowDialogue("Mais ce n'était que le début de l'histoire, je le ressens au fond de mes os.")
    UI:WaitShowDialogue("Les flux d'énergie continuent de s'agiter sous la terre, de plus en plus chauds.")
    UI:WaitShowDialogue("Restez forts, mes amis. Le monde a plus que jamais besoin de héros.")
  else
    UI:WaitShowDialogue("D'accord. Prenez soin de vous sur les sentiers et dans les donjons.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Nidoking_GossipTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Oh, vous revoilà ! J'ai encore entendu d'étranges rumeurs...", "Normal")
  UI:WaitShowDialogue("On dit que la Team Dazzling n'est pas là pour faire du secours, mais pour un secret...")
  UI:WaitShowDialogue("Elles fouillent les recoins du village et de la guilde, murmurant entre elles.")
  UI:WaitShowDialogue("Même les marchands du marché les trouvent suspectes, malgré leur éclat.")
  UI:WaitShowDialogue("Qu'en pensez-vous ? Pensez-vous qu'elles complotent quelque chose de louche ?")
  UI:BeginChoiceMenu("Que lui dites-vous ?", {"Elles complotent", "Elles sont juste fières", "Je ne sais pas"}, 1, 3)
  UI:WaitForChoice()
  local result = UI:ChoiceResult()
  if result == 1 then
    UI:WaitShowDialogue("Je le savais ! Leurs mines mystérieuses et leurs messes basses ne trompent personne.")
    UI:WaitShowDialogue("Même le Doyen Penticus les surveille du coin de l'œil, je l'ai vu hier.")
    UI:WaitShowDialogue("Faites bien attention si vous les croisez dans la Forêt Lugubre.")
  elseif result == 2 then
    UI:WaitShowDialogue("C'est possible. Les équipes de la côte ont toujours cette fierté un peu agaçante.")
    UI:WaitShowDialogue("Après tout, elles ont une grande réputation à tenir, mais quand même...")
    UI:WaitShowDialogue("Ne relâchez pas votre attention pour autant. On ne sait jamais.")
  else
    UI:WaitShowDialogue("La prudence est mère de sûreté, comme on dit toujours à la guilde.")
    UI:WaitShowDialogue("Nous verrons bien ce que l'avenir nous réserve. Restons concentrés.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Nidoking_RaidTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous entendu les rumeurs sur les pilleurs nocturnes ?", "Worried")
  UI:WaitShowDialogue("On dit que des spectres rodent dans les ombres de la ville dès que la nuit tombe...")
  UI:WaitShowDialogue("Ils forcent les coffres, pillent les stands et s'enfuient sans laisser de traces.")
  UI:WaitShowDialogue("La place entière retient son souffle dès que le soleil se couche.")
  UI:WaitShowDialogue("Si vous veillez de nuit, soyez extrêmement prudents. Ils sont redoutables.")
  UI:WaitShowDialogue("Mais je sais que votre équipe a le courage de défendre notre ville de Metano !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Nidoking_PrepTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avant de repartir en mission, assurez-vous d'être bien préparés !", "Normal")
  UI:WaitShowDialogue("La Forêt Lugubre ne pardonne pas le manque d'organisation.")
  UI:WaitShowDialogue("Prenez toujours des Baies Oran, des Baies Ceriz et des Échapporbes en cas de besoin.")
  UI:WaitShowDialogue("L'entrepôt de la guilde est là pour stocker vos trésors précieux.")
  UI:WaitShowDialogue("Même l'équipe la plus forte peut faillir sans un bon équipement.")
  UI:WaitShowDialogue("Faites-moi confiance, la préparation est la clé de toute grande aventure !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Nidoking_RelaxTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'ambiance au café est si relaxante en ce moment...", "Normal")
  UI:WaitShowDialogue("C'est l'endroit idéal pour faire une pause et discuter avec les autres.")
  UI:WaitShowDialogue("Après une longue journée dans les donjons, rien ne vaut une bonne boisson chaude.")
  UI:WaitShowDialogue("Même les rumeurs les plus folles se partagent ici autour d'une table.")
  UI:WaitShowDialogue("Prenez le temps de souffler un peu avant de retourner affronter la jungle.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Nidoking_DazzlingChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, que pensez-vous de chaque membre des Dazzling ?", "Normal")
  UI:BeginChoiceMenu("Qui souhaitez-vous évaluer ?", {"Adagio", "Aria", "Sonata", "Toutes"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Adagio est d'une élégance rare, mais ses yeux brillent d'une ambition froide.")
  elseif res == 2 then
    UI:WaitShowDialogue("Aria ne fait que s'exciter et provoquer tout le monde. C'est insupportable.")
  elseif res == 3 then
    UI:WaitShowDialogue("Sonata est tellement théâtrale ! Ses grands gestes amusent la galerie.")
  else
    UI:WaitShowDialogue("Elles forment un groupe redoutable. Ne sous-estimez jamais leur union.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Nidoking_ExpeditionChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "L'expédition reste le plus grand événement de l'année !", "Normal")
  UI:WaitShowDialogue("Chacun de nous en garde un souvenir marquant et impérissable.")
  UI:WaitShowDialogue("Pour certains, c'était la première fois qu'ils voyaient de si grandes montagnes.")
  UI:WaitShowDialogue("Et pour vous, quel reste le plus beau souvenir de cette ascension ?")
  UI:BeginChoiceMenu("Votre moment favori :", {"Le feu de camp", "La tempête", "Le sommet"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Le feu de camp était si convivial, à partager des rumeurs au milieu de la nuit !")
  elseif res == 2 then
    UI:WaitShowDialogue("La tempête était terrifiante, mais elle a montré toute la force de notre guilde !")
  else
    UI:WaitShowDialogue("Le sommet Venteux était d'une majesté absolue. On y touchait le ciel !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Nidoking_StoryDazzlingTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La Team Dazzling fait sensation à Metano Town...", "Normal")
  UI:WaitShowDialogue("Leurs voix magiques s'entendent jusqu'aux confins de la forêt.")
  UI:WaitShowDialogue("On dit qu'elles préparent un grand spectacle pour fêter leur prochaine victoire.")
  UI:WaitShowDialogue("Mais certains érudits pensent qu'il y a une magie ancienne derrière leur chant.")
  UI:WaitShowDialogue("Nous verrons bien si elles parviennent à apaiser le roi de la jungle !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Nidoking_ExpeditionBivouacTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les récits de votre bivouac au Mont Venteux sont incroyables...", "Normal")
  UI:WaitShowDialogue("Dormir sous les étoiles, à l'écoute du chant mystique de la montagne...")
  UI:WaitShowDialogue("C'est le genre d'expérience qui forge l'âme d'un véritable aventurier.")
  UI:WaitShowDialogue("Toute la ville est fière de voir votre équipe progresser si vite !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Roselia_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est une magnifique journée d'histoire.", "Normal")
  UI:WaitShowDialogue("Le Chapitre 6 est plein d'aventures et de rumeurs mystérieuses dans la Forêt Lugubre.")
  UI:WaitShowDialogue("Certains disent avoir vu une ombre gigantesque courir à travers les lianes...")
  UI:WaitShowDialogue("...Serait-ce le terrible Zeraora ? Personne n'ose s'en approcher de trop près.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Forêt Lugubre", "La Team Dazzling", "L'expédition", "Rien"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Forêt Lugubre est située juste au nord du village. L'air y est très lourd.")
    UI:WaitShowDialogue("On raconte que les arbres bougent tout seuls et que les lianes emprisonnent les intrus.")
    UI:WaitShowDialogue("Si vous y entrez, restez sur vos gardes. Ne laissez jamais votre partenaire seul.")
    UI:WaitShowDialogue("Et surtout... méfiez-vous du cri de la jungle. Il annonce la colère de son roi.")
    UI:WaitShowDialogue("Je crois que même la guilde n'a pas encore cartographié tout le donjon.")
    UI:WaitShowDialogue("Mais avec votre courage, je sais que vous pourrez y arriver et sauver le petit !")
  elseif choice == 2 then
    UI:WaitShowDialogue("La Team Dazzling... Elles sont arrivées de la côte il y a quelques jours seulement.")
    UI:WaitShowDialogue("Adagio est si polie mais on sent toute sa supériorité dans ses paroles.")
    UI:WaitShowDialogue("Aria est très provocatrice, elle passe son temps à sauter de joie et à se moquer.")
    UI:WaitShowDialogue("Et Sonata... elle est tellement théâtrale avec ses mimiques et ses colères !")
    UI:WaitShowDialogue("Elles se croient déjà au sommet, prétendant que ce sauvetage n'est qu'un jeu pour elles.")
    UI:WaitShowDialogue("Ne les laissez pas vous intimider. Montrez-leur de quel bois vous vous chauffez !")
    UI:WaitShowDialogue("Toute la ville attend de voir qui ramènera le Chenipent en premier.")
  elseif choice == 3 then
    UI:WaitShowDialogue("L'expédition du Mont Venteux... C'était une aventure extraordinaire.")
    UI:WaitShowDialogue("Vous avez gravi les sommets, traversé les tempêtes et affronté le Seigneur des Vents.")
    UI:WaitShowDialogue("Le doyen Penticus m'a dit que votre exploit résonnera longtemps à la guilde.")
    UI:WaitShowDialogue("Mais ce n'était que le début de l'histoire, je le ressens au fond de mes os.")
    UI:WaitShowDialogue("Les flux d'énergie continuent de s'agiter sous la terre, de plus en plus chauds.")
    UI:WaitShowDialogue("Restez forts, mes amis. Le monde a plus que jamais besoin de héros.")
  else
    UI:WaitShowDialogue("D'accord. Prenez soin de vous sur les sentiers et dans les donjons.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Roselia_GossipTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Oh, vous revoilà ! J'ai encore entendu d'étranges rumeurs...", "Normal")
  UI:WaitShowDialogue("On dit que la Team Dazzling n'est pas là pour faire du secours, mais pour un secret...")
  UI:WaitShowDialogue("Elles fouillent les recoins du village et de la guilde, murmurant entre elles.")
  UI:WaitShowDialogue("Même les marchands du marché les trouvent suspectes, malgré leur éclat.")
  UI:WaitShowDialogue("Qu'en pensez-vous ? Pensez-vous qu'elles complotent quelque chose de louche ?")
  UI:BeginChoiceMenu("Que lui dites-vous ?", {"Elles complotent", "Elles sont juste fières", "Je ne sais pas"}, 1, 3)
  UI:WaitForChoice()
  local result = UI:ChoiceResult()
  if result == 1 then
    UI:WaitShowDialogue("Je le savais ! Leurs mines mystérieuses et leurs messes basses ne trompent personne.")
    UI:WaitShowDialogue("Même le Doyen Penticus les surveille du coin de l'œil, je l'ai vu hier.")
    UI:WaitShowDialogue("Faites bien attention si vous les croisez dans la Forêt Lugubre.")
  elseif result == 2 then
    UI:WaitShowDialogue("C'est possible. Les équipes de la côte ont toujours cette fierté un peu agaçante.")
    UI:WaitShowDialogue("Après tout, elles ont une grande réputation à tenir, mais quand même...")
    UI:WaitShowDialogue("Ne relâchez pas votre attention pour autant. On ne sait jamais.")
  else
    UI:WaitShowDialogue("La prudence est mère de sûreté, comme on dit toujours à la guilde.")
    UI:WaitShowDialogue("Nous verrons bien ce que l'avenir nous réserve. Restons concentrés.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Roselia_RaidTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous entendu les rumeurs sur les pilleurs nocturnes ?", "Worried")
  UI:WaitShowDialogue("On dit que des spectres rodent dans les ombres de la ville dès que la nuit tombe...")
  UI:WaitShowDialogue("Ils forcent les coffres, pillent les stands et s'enfuient sans laisser de traces.")
  UI:WaitShowDialogue("La place entière retient son souffle dès que le soleil se couche.")
  UI:WaitShowDialogue("Si vous veillez de nuit, soyez extrêmement prudents. Ils sont redoutables.")
  UI:WaitShowDialogue("Mais je sais que votre équipe a le courage de défendre notre ville de Metano !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Roselia_PrepTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avant de repartir en mission, assurez-vous d'être bien préparés !", "Normal")
  UI:WaitShowDialogue("La Forêt Lugubre ne pardonne pas le manque d'organisation.")
  UI:WaitShowDialogue("Prenez toujours des Baies Oran, des Baies Ceriz et des Échapporbes en cas de besoin.")
  UI:WaitShowDialogue("L'entrepôt de la guilde est là pour stocker vos trésors précieux.")
  UI:WaitShowDialogue("Même l'équipe la plus forte peut faillir sans un bon équipement.")
  UI:WaitShowDialogue("Faites-moi confiance, la préparation est la clé de toute grande aventure !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Roselia_RelaxTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'ambiance au café est si relaxante en ce moment...", "Normal")
  UI:WaitShowDialogue("C'est l'endroit idéal pour faire une pause et discuter avec les autres.")
  UI:WaitShowDialogue("Après une longue journée dans les donjons, rien ne vaut une bonne boisson chaude.")
  UI:WaitShowDialogue("Même les rumeurs les plus folles se partagent ici autour d'une table.")
  UI:WaitShowDialogue("Prenez le temps de souffler un peu avant de retourner affronter la jungle.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Roselia_DazzlingChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, que pensez-vous de chaque membre des Dazzling ?", "Normal")
  UI:BeginChoiceMenu("Qui souhaitez-vous évaluer ?", {"Adagio", "Aria", "Sonata", "Toutes"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Adagio est d'une élégance rare, mais ses yeux brillent d'une ambition froide.")
  elseif res == 2 then
    UI:WaitShowDialogue("Aria ne fait que s'exciter et provoquer tout le monde. C'est insupportable.")
  elseif res == 3 then
    UI:WaitShowDialogue("Sonata est tellement théâtrale ! Ses grands gestes amusent la galerie.")
  else
    UI:WaitShowDialogue("Elles forment un groupe redoutable. Ne sous-estimez jamais leur union.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Roselia_ExpeditionChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "L'expédition reste le plus grand événement de l'année !", "Normal")
  UI:WaitShowDialogue("Chacun de nous en garde un souvenir marquant et impérissable.")
  UI:WaitShowDialogue("Pour certains, c'était la première fois qu'ils voyaient de si grandes montagnes.")
  UI:WaitShowDialogue("Et pour vous, quel reste le plus beau souvenir de cette ascension ?")
  UI:BeginChoiceMenu("Votre moment favori :", {"Le feu de camp", "La tempête", "Le sommet"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Le feu de camp était si convivial, à partager des rumeurs au milieu de la nuit !")
  elseif res == 2 then
    UI:WaitShowDialogue("La tempête était terrifiante, mais elle a montré toute la force de notre guilde !")
  else
    UI:WaitShowDialogue("Le sommet Venteux était d'une majesté absolue. On y touchait le ciel !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Roselia_StoryDazzlingTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La Team Dazzling fait sensation à Metano Town...", "Normal")
  UI:WaitShowDialogue("Leurs voix magiques s'entendent jusqu'aux confins de la forêt.")
  UI:WaitShowDialogue("On dit qu'elles préparent un grand spectacle pour fêter leur prochaine victoire.")
  UI:WaitShowDialogue("Mais certains érudits pensent qu'il y a une magie ancienne derrière leur chant.")
  UI:WaitShowDialogue("Nous verrons bien si elles parviennent à apaiser le roi de la jungle !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Roselia_ExpeditionBivouacTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les récits de votre bivouac au Mont Venteux sont incroyables...", "Normal")
  UI:WaitShowDialogue("Dormir sous les étoiles, à l'écoute du chant mystique de la montagne...")
  UI:WaitShowDialogue("C'est le genre d'expérience qui forge l'âme d'un véritable aventurier.")
  UI:WaitShowDialogue("Toute la ville est fière de voir votre équipe progresser si vite !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Spinda_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est une magnifique journée d'histoire.", "Normal")
  UI:WaitShowDialogue("Le Chapitre 6 est plein d'aventures et de rumeurs mystérieuses dans la Forêt Lugubre.")
  UI:WaitShowDialogue("Certains disent avoir vu une ombre gigantesque courir à travers les lianes...")
  UI:WaitShowDialogue("...Serait-ce le terrible Zeraora ? Personne n'ose s'en approcher de trop près.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Forêt Lugubre", "La Team Dazzling", "L'expédition", "Rien"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Forêt Lugubre est située juste au nord du village. L'air y est très lourd.")
    UI:WaitShowDialogue("On raconte que les arbres bougent tout seuls et que les lianes emprisonnent les intrus.")
    UI:WaitShowDialogue("Si vous y entrez, restez sur vos gardes. Ne laissez jamais votre partenaire seul.")
    UI:WaitShowDialogue("Et surtout... méfiez-vous du cri de la jungle. Il annonce la colère de son roi.")
    UI:WaitShowDialogue("Je crois que même la guilde n'a pas encore cartographié tout le donjon.")
    UI:WaitShowDialogue("Mais avec votre courage, je sais que vous pourrez y arriver et sauver le petit !")
  elseif choice == 2 then
    UI:WaitShowDialogue("La Team Dazzling... Elles sont arrivées de la côte il y a quelques jours seulement.")
    UI:WaitShowDialogue("Adagio est si polie mais on sent toute sa supériorité dans ses paroles.")
    UI:WaitShowDialogue("Aria est très provocatrice, elle passe son temps à sauter de joie et à se moquer.")
    UI:WaitShowDialogue("Et Sonata... elle est tellement théâtrale avec ses mimiques et ses colères !")
    UI:WaitShowDialogue("Elles se croient déjà au sommet, prétendant que ce sauvetage n'est qu'un jeu pour elles.")
    UI:WaitShowDialogue("Ne les laissez pas vous intimider. Montrez-leur de quel bois vous vous chauffez !")
    UI:WaitShowDialogue("Toute la ville attend de voir qui ramènera le Chenipent en premier.")
  elseif choice == 3 then
    UI:WaitShowDialogue("L'expédition du Mont Venteux... C'était une aventure extraordinaire.")
    UI:WaitShowDialogue("Vous avez gravi les sommets, traversé les tempêtes et affronté le Seigneur des Vents.")
    UI:WaitShowDialogue("Le doyen Penticus m'a dit que votre exploit résonnera longtemps à la guilde.")
    UI:WaitShowDialogue("Mais ce n'était que le début de l'histoire, je le ressens au fond de mes os.")
    UI:WaitShowDialogue("Les flux d'énergie continuent de s'agiter sous la terre, de plus en plus chauds.")
    UI:WaitShowDialogue("Restez forts, mes amis. Le monde a plus que jamais besoin de héros.")
  else
    UI:WaitShowDialogue("D'accord. Prenez soin de vous sur les sentiers et dans les donjons.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Spinda_GossipTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Oh, vous revoilà ! J'ai encore entendu d'étranges rumeurs...", "Normal")
  UI:WaitShowDialogue("On dit que la Team Dazzling n'est pas là pour faire du secours, mais pour un secret...")
  UI:WaitShowDialogue("Elles fouillent les recoins du village et de la guilde, murmurant entre elles.")
  UI:WaitShowDialogue("Même les marchands du marché les trouvent suspectes, malgré leur éclat.")
  UI:WaitShowDialogue("Qu'en pensez-vous ? Pensez-vous qu'elles complotent quelque chose de louche ?")
  UI:BeginChoiceMenu("Que lui dites-vous ?", {"Elles complotent", "Elles sont juste fières", "Je ne sais pas"}, 1, 3)
  UI:WaitForChoice()
  local result = UI:ChoiceResult()
  if result == 1 then
    UI:WaitShowDialogue("Je le savais ! Leurs mines mystérieuses et leurs messes basses ne trompent personne.")
    UI:WaitShowDialogue("Même le Doyen Penticus les surveille du coin de l'œil, je l'ai vu hier.")
    UI:WaitShowDialogue("Faites bien attention si vous les croisez dans la Forêt Lugubre.")
  elseif result == 2 then
    UI:WaitShowDialogue("C'est possible. Les équipes de la côte ont toujours cette fierté un peu agaçante.")
    UI:WaitShowDialogue("Après tout, elles ont une grande réputation à tenir, mais quand même...")
    UI:WaitShowDialogue("Ne relâchez pas votre attention pour autant. On ne sait jamais.")
  else
    UI:WaitShowDialogue("La prudence est mère de sûreté, comme on dit toujours à la guilde.")
    UI:WaitShowDialogue("Nous verrons bien ce que l'avenir nous réserve. Restons concentrés.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Spinda_RaidTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous entendu les rumeurs sur les pilleurs nocturnes ?", "Worried")
  UI:WaitShowDialogue("On dit que des spectres rodent dans les ombres de la ville dès que la nuit tombe...")
  UI:WaitShowDialogue("Ils forcent les coffres, pillent les stands et s'enfuient sans laisser de traces.")
  UI:WaitShowDialogue("La place entière retient son souffle dès que le soleil se couche.")
  UI:WaitShowDialogue("Si vous veillez de nuit, soyez extrêmement prudents. Ils sont redoutables.")
  UI:WaitShowDialogue("Mais je sais que votre équipe a le courage de défendre notre ville de Metano !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Spinda_PrepTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avant de repartir en mission, assurez-vous d'être bien préparés !", "Normal")
  UI:WaitShowDialogue("La Forêt Lugubre ne pardonne pas le manque d'organisation.")
  UI:WaitShowDialogue("Prenez toujours des Baies Oran, des Baies Ceriz et des Échapporbes en cas de besoin.")
  UI:WaitShowDialogue("L'entrepôt de la guilde est là pour stocker vos trésors précieux.")
  UI:WaitShowDialogue("Même l'équipe la plus forte peut faillir sans un bon équipement.")
  UI:WaitShowDialogue("Faites-moi confiance, la préparation est la clé de toute grande aventure !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Spinda_RelaxTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'ambiance au café est si relaxante en ce moment...", "Normal")
  UI:WaitShowDialogue("C'est l'endroit idéal pour faire une pause et discuter avec les autres.")
  UI:WaitShowDialogue("Après une longue journée dans les donjons, rien ne vaut une bonne boisson chaude.")
  UI:WaitShowDialogue("Même les rumeurs les plus folles se partagent ici autour d'une table.")
  UI:WaitShowDialogue("Prenez le temps de souffler un peu avant de retourner affronter la jungle.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Spinda_DazzlingChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, que pensez-vous de chaque membre des Dazzling ?", "Normal")
  UI:BeginChoiceMenu("Qui souhaitez-vous évaluer ?", {"Adagio", "Aria", "Sonata", "Toutes"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Adagio est d'une élégance rare, mais ses yeux brillent d'une ambition froide.")
  elseif res == 2 then
    UI:WaitShowDialogue("Aria ne fait que s'exciter et provoquer tout le monde. C'est insupportable.")
  elseif res == 3 then
    UI:WaitShowDialogue("Sonata est tellement théâtrale ! Ses grands gestes amusent la galerie.")
  else
    UI:WaitShowDialogue("Elles forment un groupe redoutable. Ne sous-estimez jamais leur union.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Spinda_ExpeditionChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "L'expédition reste le plus grand événement de l'année !", "Normal")
  UI:WaitShowDialogue("Chacun de nous en garde un souvenir marquant et impérissable.")
  UI:WaitShowDialogue("Pour certains, c'était la première fois qu'ils voyaient de si grandes montagnes.")
  UI:WaitShowDialogue("Et pour vous, quel reste le plus beau souvenir de cette ascension ?")
  UI:BeginChoiceMenu("Votre moment favori :", {"Le feu de camp", "La tempête", "Le sommet"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Le feu de camp était si convivial, à partager des rumeurs au milieu de la nuit !")
  elseif res == 2 then
    UI:WaitShowDialogue("La tempête était terrifiante, mais elle a montré toute la force de notre guilde !")
  else
    UI:WaitShowDialogue("Le sommet Venteux était d'une majesté absolue. On y touchait le ciel !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Spinda_StoryDazzlingTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La Team Dazzling fait sensation à Metano Town...", "Normal")
  UI:WaitShowDialogue("Leurs voix magiques s'entendent jusqu'aux confins de la forêt.")
  UI:WaitShowDialogue("On dit qu'elles préparent un grand spectacle pour fêter leur prochaine victoire.")
  UI:WaitShowDialogue("Mais certains érudits pensent qu'il y a une magie ancienne derrière leur chant.")
  UI:WaitShowDialogue("Nous verrons bien si elles parviennent à apaiser le roi de la jungle !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Spinda_ExpeditionBivouacTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les récits de votre bivouac au Mont Venteux sont incroyables...", "Normal")
  UI:WaitShowDialogue("Dormir sous les étoiles, à l'écoute du chant mystique de la montagne...")
  UI:WaitShowDialogue("C'est le genre d'expérience qui forge l'âme d'un véritable aventurier.")
  UI:WaitShowDialogue("Toute la ville est fière de voir votre équipe progresser si vite !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Ludicolo_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est une magnifique journée d'histoire.", "Normal")
  UI:WaitShowDialogue("Le Chapitre 6 est plein d'aventures et de rumeurs mystérieuses dans la Forêt Lugubre.")
  UI:WaitShowDialogue("Certains disent avoir vu une ombre gigantesque courir à travers les lianes...")
  UI:WaitShowDialogue("...Serait-ce le terrible Zeraora ? Personne n'ose s'en approcher de trop près.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Forêt Lugubre", "La Team Dazzling", "L'expédition", "Rien"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Forêt Lugubre est située juste au nord du village. L'air y est très lourd.")
    UI:WaitShowDialogue("On raconte que les arbres bougent tout seuls et que les lianes emprisonnent les intrus.")
    UI:WaitShowDialogue("Si vous y entrez, restez sur vos gardes. Ne laissez jamais votre partenaire seul.")
    UI:WaitShowDialogue("Et surtout... méfiez-vous du cri de la jungle. Il annonce la colère de son roi.")
    UI:WaitShowDialogue("Je crois que même la guilde n'a pas encore cartographié tout le donjon.")
    UI:WaitShowDialogue("Mais avec votre courage, je sais que vous pourrez y arriver et sauver le petit !")
  elseif choice == 2 then
    UI:WaitShowDialogue("La Team Dazzling... Elles sont arrivées de la côte il y a quelques jours seulement.")
    UI:WaitShowDialogue("Adagio est si polie mais on sent toute sa supériorité dans ses paroles.")
    UI:WaitShowDialogue("Aria est très provocatrice, elle passe son temps à sauter de joie et à se moquer.")
    UI:WaitShowDialogue("Et Sonata... elle est tellement théâtrale avec ses mimiques et ses colères !")
    UI:WaitShowDialogue("Elles se croient déjà au sommet, prétendant que ce sauvetage n'est qu'un jeu pour elles.")
    UI:WaitShowDialogue("Ne les laissez pas vous intimider. Montrez-leur de quel bois vous vous chauffez !")
    UI:WaitShowDialogue("Toute la ville attend de voir qui ramènera le Chenipent en premier.")
  elseif choice == 3 then
    UI:WaitShowDialogue("L'expédition du Mont Venteux... C'était une aventure extraordinaire.")
    UI:WaitShowDialogue("Vous avez gravi les sommets, traversé les tempêtes et affronté le Seigneur des Vents.")
    UI:WaitShowDialogue("Le doyen Penticus m'a dit que votre exploit résonnera longtemps à la guilde.")
    UI:WaitShowDialogue("Mais ce n'était que le début de l'histoire, je le ressens au fond de mes os.")
    UI:WaitShowDialogue("Les flux d'énergie continuent de s'agiter sous la terre, de plus en plus chauds.")
    UI:WaitShowDialogue("Restez forts, mes amis. Le monde a plus que jamais besoin de héros.")
  else
    UI:WaitShowDialogue("D'accord. Prenez soin de vous sur les sentiers et dans les donjons.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Ludicolo_GossipTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Oh, vous revoilà ! J'ai encore entendu d'étranges rumeurs...", "Normal")
  UI:WaitShowDialogue("On dit que la Team Dazzling n'est pas là pour faire du secours, mais pour un secret...")
  UI:WaitShowDialogue("Elles fouillent les recoins du village et de la guilde, murmurant entre elles.")
  UI:WaitShowDialogue("Même les marchands du marché les trouvent suspectes, malgré leur éclat.")
  UI:WaitShowDialogue("Qu'en pensez-vous ? Pensez-vous qu'elles complotent quelque chose de louche ?")
  UI:BeginChoiceMenu("Que lui dites-vous ?", {"Elles complotent", "Elles sont juste fières", "Je ne sais pas"}, 1, 3)
  UI:WaitForChoice()
  local result = UI:ChoiceResult()
  if result == 1 then
    UI:WaitShowDialogue("Je le savais ! Leurs mines mystérieuses et leurs messes basses ne trompent personne.")
    UI:WaitShowDialogue("Même le Doyen Penticus les surveille du coin de l'œil, je l'ai vu hier.")
    UI:WaitShowDialogue("Faites bien attention si vous les croisez dans la Forêt Lugubre.")
  elseif result == 2 then
    UI:WaitShowDialogue("C'est possible. Les équipes de la côte ont toujours cette fierté un peu agaçante.")
    UI:WaitShowDialogue("Après tout, elles ont une grande réputation à tenir, mais quand même...")
    UI:WaitShowDialogue("Ne relâchez pas votre attention pour autant. On ne sait jamais.")
  else
    UI:WaitShowDialogue("La prudence est mère de sûreté, comme on dit toujours à la guilde.")
    UI:WaitShowDialogue("Nous verrons bien ce que l'avenir nous réserve. Restons concentrés.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Ludicolo_RaidTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous entendu les rumeurs sur les pilleurs nocturnes ?", "Worried")
  UI:WaitShowDialogue("On dit que des spectres rodent dans les ombres de la ville dès que la nuit tombe...")
  UI:WaitShowDialogue("Ils forcent les coffres, pillent les stands et s'enfuient sans laisser de traces.")
  UI:WaitShowDialogue("La place entière retient son souffle dès que le soleil se couche.")
  UI:WaitShowDialogue("Si vous veillez de nuit, soyez extrêmement prudents. Ils sont redoutables.")
  UI:WaitShowDialogue("Mais je sais que votre équipe a le courage de défendre notre ville de Metano !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Ludicolo_PrepTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avant de repartir en mission, assurez-vous d'être bien préparés !", "Normal")
  UI:WaitShowDialogue("La Forêt Lugubre ne pardonne pas le manque d'organisation.")
  UI:WaitShowDialogue("Prenez toujours des Baies Oran, des Baies Ceriz et des Échapporbes en cas de besoin.")
  UI:WaitShowDialogue("L'entrepôt de la guilde est là pour stocker vos trésors précieux.")
  UI:WaitShowDialogue("Même l'équipe la plus forte peut faillir sans un bon équipement.")
  UI:WaitShowDialogue("Faites-moi confiance, la préparation est la clé de toute grande aventure !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Ludicolo_RelaxTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'ambiance au café est si relaxante en ce moment...", "Normal")
  UI:WaitShowDialogue("C'est l'endroit idéal pour faire une pause et discuter avec les autres.")
  UI:WaitShowDialogue("Après une longue journée dans les donjons, rien ne vaut une bonne boisson chaude.")
  UI:WaitShowDialogue("Même les rumeurs les plus folles se partagent ici autour d'une table.")
  UI:WaitShowDialogue("Prenez le temps de souffler un peu avant de retourner affronter la jungle.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Ludicolo_DazzlingChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, que pensez-vous de chaque membre des Dazzling ?", "Normal")
  UI:BeginChoiceMenu("Qui souhaitez-vous évaluer ?", {"Adagio", "Aria", "Sonata", "Toutes"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Adagio est d'une élégance rare, mais ses yeux brillent d'une ambition froide.")
  elseif res == 2 then
    UI:WaitShowDialogue("Aria ne fait que s'exciter et provoquer tout le monde. C'est insupportable.")
  elseif res == 3 then
    UI:WaitShowDialogue("Sonata est tellement théâtrale ! Ses grands gestes amusent la galerie.")
  else
    UI:WaitShowDialogue("Elles forment un groupe redoutable. Ne sous-estimez jamais leur union.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Ludicolo_ExpeditionChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "L'expédition reste le plus grand événement de l'année !", "Normal")
  UI:WaitShowDialogue("Chacun de nous en garde un souvenir marquant et impérissable.")
  UI:WaitShowDialogue("Pour certains, c'était la première fois qu'ils voyaient de si grandes montagnes.")
  UI:WaitShowDialogue("Et pour vous, quel reste le plus beau souvenir de cette ascension ?")
  UI:BeginChoiceMenu("Votre moment favori :", {"Le feu de camp", "La tempête", "Le sommet"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Le feu de camp était si convivial, à partager des rumeurs au milieu de la nuit !")
  elseif res == 2 then
    UI:WaitShowDialogue("La tempête était terrifiante, mais elle a montré toute la force de notre guilde !")
  else
    UI:WaitShowDialogue("Le sommet Venteux était d'une majesté absolue. On y touchait le ciel !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Ludicolo_StoryDazzlingTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La Team Dazzling fait sensation à Metano Town...", "Normal")
  UI:WaitShowDialogue("Leurs voix magiques s'entendent jusqu'aux confins de la forêt.")
  UI:WaitShowDialogue("On dit qu'elles préparent un grand spectacle pour fêter leur prochaine victoire.")
  UI:WaitShowDialogue("Mais certains érudits pensent qu'il y a une magie ancienne derrière leur chant.")
  UI:WaitShowDialogue("Nous verrons bien si elles parviennent à apaiser le roi de la jungle !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Ludicolo_ExpeditionBivouacTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les récits de votre bivouac au Mont Venteux sont incroyables...", "Normal")
  UI:WaitShowDialogue("Dormir sous les étoiles, à l'écoute du chant mystique de la montagne...")
  UI:WaitShowDialogue("C'est le genre d'expérience qui forge l'âme d'un véritable aventurier.")
  UI:WaitShowDialogue("Toute la ville est fière de voir votre équipe progresser si vite !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Jigglypuff_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est une magnifique journée d'histoire.", "Normal")
  UI:WaitShowDialogue("Le Chapitre 6 est plein d'aventures et de rumeurs mystérieuses dans la Forêt Lugubre.")
  UI:WaitShowDialogue("Certains disent avoir vu une ombre gigantesque courir à travers les lianes...")
  UI:WaitShowDialogue("...Serait-ce le terrible Zeraora ? Personne n'ose s'en approcher de trop près.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Forêt Lugubre", "La Team Dazzling", "L'expédition", "Rien"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Forêt Lugubre est située juste au nord du village. L'air y est très lourd.")
    UI:WaitShowDialogue("On raconte que les arbres bougent tout seuls et que les lianes emprisonnent les intrus.")
    UI:WaitShowDialogue("Si vous y entrez, restez sur vos gardes. Ne laissez jamais votre partenaire seul.")
    UI:WaitShowDialogue("Et surtout... méfiez-vous du cri de la jungle. Il annonce la colère de son roi.")
    UI:WaitShowDialogue("Je crois que même la guilde n'a pas encore cartographié tout le donjon.")
    UI:WaitShowDialogue("Mais avec votre courage, je sais que vous pourrez y arriver et sauver le petit !")
  elseif choice == 2 then
    UI:WaitShowDialogue("La Team Dazzling... Elles sont arrivées de la côte il y a quelques jours seulement.")
    UI:WaitShowDialogue("Adagio est si polie mais on sent toute sa supériorité dans ses paroles.")
    UI:WaitShowDialogue("Aria est très provocatrice, elle passe son temps à sauter de joie et à se moquer.")
    UI:WaitShowDialogue("Et Sonata... elle est tellement théâtrale avec ses mimiques et ses colères !")
    UI:WaitShowDialogue("Elles se croient déjà au sommet, prétendant que ce sauvetage n'est qu'un jeu pour elles.")
    UI:WaitShowDialogue("Ne les laissez pas vous intimider. Montrez-leur de quel bois vous vous chauffez !")
    UI:WaitShowDialogue("Toute la ville attend de voir qui ramènera le Chenipent en premier.")
  elseif choice == 3 then
    UI:WaitShowDialogue("L'expédition du Mont Venteux... C'était une aventure extraordinaire.")
    UI:WaitShowDialogue("Vous avez gravi les sommets, traversé les tempêtes et affronté le Seigneur des Vents.")
    UI:WaitShowDialogue("Le doyen Penticus m'a dit que votre exploit résonnera longtemps à la guilde.")
    UI:WaitShowDialogue("Mais ce n'était que le début de l'histoire, je le ressens au fond de mes os.")
    UI:WaitShowDialogue("Les flux d'énergie continuent de s'agiter sous la terre, de plus en plus chauds.")
    UI:WaitShowDialogue("Restez forts, mes amis. Le monde a plus que jamais besoin de héros.")
  else
    UI:WaitShowDialogue("D'accord. Prenez soin de vous sur les sentiers et dans les donjons.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Jigglypuff_GossipTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Oh, vous revoilà ! J'ai encore entendu d'étranges rumeurs...", "Normal")
  UI:WaitShowDialogue("On dit que la Team Dazzling n'est pas là pour faire du secours, mais pour un secret...")
  UI:WaitShowDialogue("Elles fouillent les recoins du village et de la guilde, murmurant entre elles.")
  UI:WaitShowDialogue("Même les marchands du marché les trouvent suspectes, malgré leur éclat.")
  UI:WaitShowDialogue("Qu'en pensez-vous ? Pensez-vous qu'elles complotent quelque chose de louche ?")
  UI:BeginChoiceMenu("Que lui dites-vous ?", {"Elles complotent", "Elles sont juste fières", "Je ne sais pas"}, 1, 3)
  UI:WaitForChoice()
  local result = UI:ChoiceResult()
  if result == 1 then
    UI:WaitShowDialogue("Je le savais ! Leurs mines mystérieuses et leurs messes basses ne trompent personne.")
    UI:WaitShowDialogue("Même le Doyen Penticus les surveille du coin de l'œil, je l'ai vu hier.")
    UI:WaitShowDialogue("Faites bien attention si vous les croisez dans la Forêt Lugubre.")
  elseif result == 2 then
    UI:WaitShowDialogue("C'est possible. Les équipes de la côte ont toujours cette fierté un peu agaçante.")
    UI:WaitShowDialogue("Après tout, elles ont une grande réputation à tenir, mais quand même...")
    UI:WaitShowDialogue("Ne relâchez pas votre attention pour autant. On ne sait jamais.")
  else
    UI:WaitShowDialogue("La prudence est mère de sûreté, comme on dit toujours à la guilde.")
    UI:WaitShowDialogue("Nous verrons bien ce que l'avenir nous réserve. Restons concentrés.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Jigglypuff_RaidTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous entendu les rumeurs sur les pilleurs nocturnes ?", "Worried")
  UI:WaitShowDialogue("On dit que des spectres rodent dans les ombres de la ville dès que la nuit tombe...")
  UI:WaitShowDialogue("Ils forcent les coffres, pillent les stands et s'enfuient sans laisser de traces.")
  UI:WaitShowDialogue("La place entière retient son souffle dès que le soleil se couche.")
  UI:WaitShowDialogue("Si vous veillez de nuit, soyez extrêmement prudents. Ils sont redoutables.")
  UI:WaitShowDialogue("Mais je sais que votre équipe a le courage de défendre notre ville de Metano !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Jigglypuff_PrepTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avant de repartir en mission, assurez-vous d'être bien préparés !", "Normal")
  UI:WaitShowDialogue("La Forêt Lugubre ne pardonne pas le manque d'organisation.")
  UI:WaitShowDialogue("Prenez toujours des Baies Oran, des Baies Ceriz et des Échapporbes en cas de besoin.")
  UI:WaitShowDialogue("L'entrepôt de la guilde est là pour stocker vos trésors précieux.")
  UI:WaitShowDialogue("Même l'équipe la plus forte peut faillir sans un bon équipement.")
  UI:WaitShowDialogue("Faites-moi confiance, la préparation est la clé de toute grande aventure !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Jigglypuff_RelaxTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'ambiance au café est si relaxante en ce moment...", "Normal")
  UI:WaitShowDialogue("C'est l'endroit idéal pour faire une pause et discuter avec les autres.")
  UI:WaitShowDialogue("Après une longue journée dans les donjons, rien ne vaut une bonne boisson chaude.")
  UI:WaitShowDialogue("Même les rumeurs les plus folles se partagent ici autour d'une table.")
  UI:WaitShowDialogue("Prenez le temps de souffler un peu avant de retourner affronter la jungle.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Jigglypuff_DazzlingChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, que pensez-vous de chaque membre des Dazzling ?", "Normal")
  UI:BeginChoiceMenu("Qui souhaitez-vous évaluer ?", {"Adagio", "Aria", "Sonata", "Toutes"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Adagio est d'une élégance rare, mais ses yeux brillent d'une ambition froide.")
  elseif res == 2 then
    UI:WaitShowDialogue("Aria ne fait que s'exciter et provoquer tout le monde. C'est insupportable.")
  elseif res == 3 then
    UI:WaitShowDialogue("Sonata est tellement théâtrale ! Ses grands gestes amusent la galerie.")
  else
    UI:WaitShowDialogue("Elles forment un groupe redoutable. Ne sous-estimez jamais leur union.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Jigglypuff_ExpeditionChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "L'expédition reste le plus grand événement de l'année !", "Normal")
  UI:WaitShowDialogue("Chacun de nous en garde un souvenir marquant et impérissable.")
  UI:WaitShowDialogue("Pour certains, c'était la première fois qu'ils voyaient de si grandes montagnes.")
  UI:WaitShowDialogue("Et pour vous, quel reste le plus beau souvenir de cette ascension ?")
  UI:BeginChoiceMenu("Votre moment favori :", {"Le feu de camp", "La tempête", "Le sommet"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Le feu de camp était si convivial, à partager des rumeurs au milieu de la nuit !")
  elseif res == 2 then
    UI:WaitShowDialogue("La tempête était terrifiante, mais elle a montré toute la force de notre guilde !")
  else
    UI:WaitShowDialogue("Le sommet Venteux était d'une majesté absolue. On y touchait le ciel !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Jigglypuff_StoryDazzlingTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La Team Dazzling fait sensation à Metano Town...", "Normal")
  UI:WaitShowDialogue("Leurs voix magiques s'entendent jusqu'aux confins de la forêt.")
  UI:WaitShowDialogue("On dit qu'elles préparent un grand spectacle pour fêter leur prochaine victoire.")
  UI:WaitShowDialogue("Mais certains érudits pensent qu'il y a une magie ancienne derrière leur chant.")
  UI:WaitShowDialogue("Nous verrons bien si elles parviennent à apaiser le roi de la jungle !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Jigglypuff_ExpeditionBivouacTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les récits de votre bivouac au Mont Venteux sont incroyables...", "Normal")
  UI:WaitShowDialogue("Dormir sous les étoiles, à l'écoute du chant mystique de la montagne...")
  UI:WaitShowDialogue("C'est le genre d'expérience qui forge l'âme d'un véritable aventurier.")
  UI:WaitShowDialogue("Toute la ville est fière de voir votre équipe progresser si vite !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Marill_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est une magnifique journée d'histoire.", "Normal")
  UI:WaitShowDialogue("Le Chapitre 6 est plein d'aventures et de rumeurs mystérieuses dans la Forêt Lugubre.")
  UI:WaitShowDialogue("Certains disent avoir vu une ombre gigantesque courir à travers les lianes...")
  UI:WaitShowDialogue("...Serait-ce le terrible Zeraora ? Personne n'ose s'en approcher de trop près.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Forêt Lugubre", "La Team Dazzling", "L'expédition", "Rien"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Forêt Lugubre est située juste au nord du village. L'air y est très lourd.")
    UI:WaitShowDialogue("On raconte que les arbres bougent tout seuls et que les lianes emprisonnent les intrus.")
    UI:WaitShowDialogue("Si vous y entrez, restez sur vos gardes. Ne laissez jamais votre partenaire seul.")
    UI:WaitShowDialogue("Et surtout... méfiez-vous du cri de la jungle. Il annonce la colère de son roi.")
    UI:WaitShowDialogue("Je crois que même la guilde n'a pas encore cartographié tout le donjon.")
    UI:WaitShowDialogue("Mais avec votre courage, je sais que vous pourrez y arriver et sauver le petit !")
  elseif choice == 2 then
    UI:WaitShowDialogue("La Team Dazzling... Elles sont arrivées de la côte il y a quelques jours seulement.")
    UI:WaitShowDialogue("Adagio est si polie mais on sent toute sa supériorité dans ses paroles.")
    UI:WaitShowDialogue("Aria est très provocatrice, elle passe son temps à sauter de joie et à se moquer.")
    UI:WaitShowDialogue("Et Sonata... elle est tellement théâtrale avec ses mimiques et ses colères !")
    UI:WaitShowDialogue("Elles se croient déjà au sommet, prétendant que ce sauvetage n'est qu'un jeu pour elles.")
    UI:WaitShowDialogue("Ne les laissez pas vous intimider. Montrez-leur de quel bois vous vous chauffez !")
    UI:WaitShowDialogue("Toute la ville attend de voir qui ramènera le Chenipent en premier.")
  elseif choice == 3 then
    UI:WaitShowDialogue("L'expédition du Mont Venteux... C'était une aventure extraordinaire.")
    UI:WaitShowDialogue("Vous avez gravi les sommets, traversé les tempêtes et affronté le Seigneur des Vents.")
    UI:WaitShowDialogue("Le doyen Penticus m'a dit que votre exploit résonnera longtemps à la guilde.")
    UI:WaitShowDialogue("Mais ce n'était que le début de l'histoire, je le ressens au fond de mes os.")
    UI:WaitShowDialogue("Les flux d'énergie continuent de s'agiter sous la terre, de plus en plus chauds.")
    UI:WaitShowDialogue("Restez forts, mes amis. Le monde a plus que jamais besoin de héros.")
  else
    UI:WaitShowDialogue("D'accord. Prenez soin de vous sur les sentiers et dans les donjons.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Marill_GossipTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Oh, vous revoilà ! J'ai encore entendu d'étranges rumeurs...", "Normal")
  UI:WaitShowDialogue("On dit que la Team Dazzling n'est pas là pour faire du secours, mais pour un secret...")
  UI:WaitShowDialogue("Elles fouillent les recoins du village et de la guilde, murmurant entre elles.")
  UI:WaitShowDialogue("Même les marchands du marché les trouvent suspectes, malgré leur éclat.")
  UI:WaitShowDialogue("Qu'en pensez-vous ? Pensez-vous qu'elles complotent quelque chose de louche ?")
  UI:BeginChoiceMenu("Que lui dites-vous ?", {"Elles complotent", "Elles sont juste fières", "Je ne sais pas"}, 1, 3)
  UI:WaitForChoice()
  local result = UI:ChoiceResult()
  if result == 1 then
    UI:WaitShowDialogue("Je le savais ! Leurs mines mystérieuses et leurs messes basses ne trompent personne.")
    UI:WaitShowDialogue("Même le Doyen Penticus les surveille du coin de l'œil, je l'ai vu hier.")
    UI:WaitShowDialogue("Faites bien attention si vous les croisez dans la Forêt Lugubre.")
  elseif result == 2 then
    UI:WaitShowDialogue("C'est possible. Les équipes de la côte ont toujours cette fierté un peu agaçante.")
    UI:WaitShowDialogue("Après tout, elles ont une grande réputation à tenir, mais quand même...")
    UI:WaitShowDialogue("Ne relâchez pas votre attention pour autant. On ne sait jamais.")
  else
    UI:WaitShowDialogue("La prudence est mère de sûreté, comme on dit toujours à la guilde.")
    UI:WaitShowDialogue("Nous verrons bien ce que l'avenir nous réserve. Restons concentrés.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Marill_RaidTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous entendu les rumeurs sur les pilleurs nocturnes ?", "Worried")
  UI:WaitShowDialogue("On dit que des spectres rodent dans les ombres de la ville dès que la nuit tombe...")
  UI:WaitShowDialogue("Ils forcent les coffres, pillent les stands et s'enfuient sans laisser de traces.")
  UI:WaitShowDialogue("La place entière retient son souffle dès que le soleil se couche.")
  UI:WaitShowDialogue("Si vous veillez de nuit, soyez extrêmement prudents. Ils sont redoutables.")
  UI:WaitShowDialogue("Mais je sais que votre équipe a le courage de défendre notre ville de Metano !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Marill_PrepTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avant de repartir en mission, assurez-vous d'être bien préparés !", "Normal")
  UI:WaitShowDialogue("La Forêt Lugubre ne pardonne pas le manque d'organisation.")
  UI:WaitShowDialogue("Prenez toujours des Baies Oran, des Baies Ceriz et des Échapporbes en cas de besoin.")
  UI:WaitShowDialogue("L'entrepôt de la guilde est là pour stocker vos trésors précieux.")
  UI:WaitShowDialogue("Même l'équipe la plus forte peut faillir sans un bon équipement.")
  UI:WaitShowDialogue("Faites-moi confiance, la préparation est la clé de toute grande aventure !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Marill_RelaxTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'ambiance au café est si relaxante en ce moment...", "Normal")
  UI:WaitShowDialogue("C'est l'endroit idéal pour faire une pause et discuter avec les autres.")
  UI:WaitShowDialogue("Après une longue journée dans les donjons, rien ne vaut une bonne boisson chaude.")
  UI:WaitShowDialogue("Même les rumeurs les plus folles se partagent ici autour d'une table.")
  UI:WaitShowDialogue("Prenez le temps de souffler un peu avant de retourner affronter la jungle.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Marill_DazzlingChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, que pensez-vous de chaque membre des Dazzling ?", "Normal")
  UI:BeginChoiceMenu("Qui souhaitez-vous évaluer ?", {"Adagio", "Aria", "Sonata", "Toutes"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Adagio est d'une élégance rare, mais ses yeux brillent d'une ambition froide.")
  elseif res == 2 then
    UI:WaitShowDialogue("Aria ne fait que s'exciter et provoquer tout le monde. C'est insupportable.")
  elseif res == 3 then
    UI:WaitShowDialogue("Sonata est tellement théâtrale ! Ses grands gestes amusent la galerie.")
  else
    UI:WaitShowDialogue("Elles forment un groupe redoutable. Ne sous-estimez jamais leur union.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Marill_ExpeditionChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "L'expédition reste le plus grand événement de l'année !", "Normal")
  UI:WaitShowDialogue("Chacun de nous en garde un souvenir marquant et impérissable.")
  UI:WaitShowDialogue("Pour certains, c'était la première fois qu'ils voyaient de si grandes montagnes.")
  UI:WaitShowDialogue("Et pour vous, quel reste le plus beau souvenir de cette ascension ?")
  UI:BeginChoiceMenu("Votre moment favori :", {"Le feu de camp", "La tempête", "Le sommet"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Le feu de camp était si convivial, à partager des rumeurs au milieu de la nuit !")
  elseif res == 2 then
    UI:WaitShowDialogue("La tempête était terrifiante, mais elle a montré toute la force de notre guilde !")
  else
    UI:WaitShowDialogue("Le sommet Venteux était d'une majesté absolue. On y touchait le ciel !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Marill_StoryDazzlingTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La Team Dazzling fait sensation à Metano Town...", "Normal")
  UI:WaitShowDialogue("Leurs voix magiques s'entendent jusqu'aux confins de la forêt.")
  UI:WaitShowDialogue("On dit qu'elles préparent un grand spectacle pour fêter leur prochaine victoire.")
  UI:WaitShowDialogue("Mais certains érudits pensent qu'il y a une magie ancienne derrière leur chant.")
  UI:WaitShowDialogue("Nous verrons bien si elles parviennent à apaiser le roi de la jungle !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Marill_ExpeditionBivouacTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les récits de votre bivouac au Mont Venteux sont incroyables...", "Normal")
  UI:WaitShowDialogue("Dormir sous les étoiles, à l'écoute du chant mystique de la montagne...")
  UI:WaitShowDialogue("C'est le genre d'expérience qui forge l'âme d'un véritable aventurier.")
  UI:WaitShowDialogue("Toute la ville est fière de voir votre équipe progresser si vite !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Spheal_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est une magnifique journée d'histoire.", "Normal")
  UI:WaitShowDialogue("Le Chapitre 6 est plein d'aventures et de rumeurs mystérieuses dans la Forêt Lugubre.")
  UI:WaitShowDialogue("Certains disent avoir vu une ombre gigantesque courir à travers les lianes...")
  UI:WaitShowDialogue("...Serait-ce le terrible Zeraora ? Personne n'ose s'en approcher de trop près.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Forêt Lugubre", "La Team Dazzling", "L'expédition", "Rien"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Forêt Lugubre est située juste au nord du village. L'air y est très lourd.")
    UI:WaitShowDialogue("On raconte que les arbres bougent tout seuls et que les lianes emprisonnent les intrus.")
    UI:WaitShowDialogue("Si vous y entrez, restez sur vos gardes. Ne laissez jamais votre partenaire seul.")
    UI:WaitShowDialogue("Et surtout... méfiez-vous du cri de la jungle. Il annonce la colère de son roi.")
    UI:WaitShowDialogue("Je crois que même la guilde n'a pas encore cartographié tout le donjon.")
    UI:WaitShowDialogue("Mais avec votre courage, je sais que vous pourrez y arriver et sauver le petit !")
  elseif choice == 2 then
    UI:WaitShowDialogue("La Team Dazzling... Elles sont arrivées de la côte il y a quelques jours seulement.")
    UI:WaitShowDialogue("Adagio est si polie mais on sent toute sa supériorité dans ses paroles.")
    UI:WaitShowDialogue("Aria est très provocatrice, elle passe son temps à sauter de joie et à se moquer.")
    UI:WaitShowDialogue("Et Sonata... elle est tellement théâtrale avec ses mimiques et ses colères !")
    UI:WaitShowDialogue("Elles se croient déjà au sommet, prétendant que ce sauvetage n'est qu'un jeu pour elles.")
    UI:WaitShowDialogue("Ne les laissez pas vous intimider. Montrez-leur de quel bois vous vous chauffez !")
    UI:WaitShowDialogue("Toute la ville attend de voir qui ramènera le Chenipent en premier.")
  elseif choice == 3 then
    UI:WaitShowDialogue("L'expédition du Mont Venteux... C'était une aventure extraordinaire.")
    UI:WaitShowDialogue("Vous avez gravi les sommets, traversé les tempêtes et affronté le Seigneur des Vents.")
    UI:WaitShowDialogue("Le doyen Penticus m'a dit que votre exploit résonnera longtemps à la guilde.")
    UI:WaitShowDialogue("Mais ce n'était que le début de l'histoire, je le ressens au fond de mes os.")
    UI:WaitShowDialogue("Les flux d'énergie continuent de s'agiter sous la terre, de plus en plus chauds.")
    UI:WaitShowDialogue("Restez forts, mes amis. Le monde a plus que jamais besoin de héros.")
  else
    UI:WaitShowDialogue("D'accord. Prenez soin de vous sur les sentiers et dans les donjons.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Spheal_GossipTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Oh, vous revoilà ! J'ai encore entendu d'étranges rumeurs...", "Normal")
  UI:WaitShowDialogue("On dit que la Team Dazzling n'est pas là pour faire du secours, mais pour un secret...")
  UI:WaitShowDialogue("Elles fouillent les recoins du village et de la guilde, murmurant entre elles.")
  UI:WaitShowDialogue("Même les marchands du marché les trouvent suspectes, malgré leur éclat.")
  UI:WaitShowDialogue("Qu'en pensez-vous ? Pensez-vous qu'elles complotent quelque chose de louche ?")
  UI:BeginChoiceMenu("Que lui dites-vous ?", {"Elles complotent", "Elles sont juste fières", "Je ne sais pas"}, 1, 3)
  UI:WaitForChoice()
  local result = UI:ChoiceResult()
  if result == 1 then
    UI:WaitShowDialogue("Je le savais ! Leurs mines mystérieuses et leurs messes basses ne trompent personne.")
    UI:WaitShowDialogue("Même le Doyen Penticus les surveille du coin de l'œil, je l'ai vu hier.")
    UI:WaitShowDialogue("Faites bien attention si vous les croisez dans la Forêt Lugubre.")
  elseif result == 2 then
    UI:WaitShowDialogue("C'est possible. Les équipes de la côte ont toujours cette fierté un peu agaçante.")
    UI:WaitShowDialogue("Après tout, elles ont une grande réputation à tenir, mais quand même...")
    UI:WaitShowDialogue("Ne relâchez pas votre attention pour autant. On ne sait jamais.")
  else
    UI:WaitShowDialogue("La prudence est mère de sûreté, comme on dit toujours à la guilde.")
    UI:WaitShowDialogue("Nous verrons bien ce que l'avenir nous réserve. Restons concentrés.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Spheal_RaidTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous entendu les rumeurs sur les pilleurs nocturnes ?", "Worried")
  UI:WaitShowDialogue("On dit que des spectres rodent dans les ombres de la ville dès que la nuit tombe...")
  UI:WaitShowDialogue("Ils forcent les coffres, pillent les stands et s'enfuient sans laisser de traces.")
  UI:WaitShowDialogue("La place entière retient son souffle dès que le soleil se couche.")
  UI:WaitShowDialogue("Si vous veillez de nuit, soyez extrêmement prudents. Ils sont redoutables.")
  UI:WaitShowDialogue("Mais je sais que votre équipe a le courage de défendre notre ville de Metano !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Spheal_PrepTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avant de repartir en mission, assurez-vous d'être bien préparés !", "Normal")
  UI:WaitShowDialogue("La Forêt Lugubre ne pardonne pas le manque d'organisation.")
  UI:WaitShowDialogue("Prenez toujours des Baies Oran, des Baies Ceriz et des Échapporbes en cas de besoin.")
  UI:WaitShowDialogue("L'entrepôt de la guilde est là pour stocker vos trésors précieux.")
  UI:WaitShowDialogue("Même l'équipe la plus forte peut faillir sans un bon équipement.")
  UI:WaitShowDialogue("Faites-moi confiance, la préparation est la clé de toute grande aventure !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Spheal_RelaxTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'ambiance au café est si relaxante en ce moment...", "Normal")
  UI:WaitShowDialogue("C'est l'endroit idéal pour faire une pause et discuter avec les autres.")
  UI:WaitShowDialogue("Après une longue journée dans les donjons, rien ne vaut une bonne boisson chaude.")
  UI:WaitShowDialogue("Même les rumeurs les plus folles se partagent ici autour d'une table.")
  UI:WaitShowDialogue("Prenez le temps de souffler un peu avant de retourner affronter la jungle.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Spheal_DazzlingChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, que pensez-vous de chaque membre des Dazzling ?", "Normal")
  UI:BeginChoiceMenu("Qui souhaitez-vous évaluer ?", {"Adagio", "Aria", "Sonata", "Toutes"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Adagio est d'une élégance rare, mais ses yeux brillent d'une ambition froide.")
  elseif res == 2 then
    UI:WaitShowDialogue("Aria ne fait que s'exciter et provoquer tout le monde. C'est insupportable.")
  elseif res == 3 then
    UI:WaitShowDialogue("Sonata est tellement théâtrale ! Ses grands gestes amusent la galerie.")
  else
    UI:WaitShowDialogue("Elles forment un groupe redoutable. Ne sous-estimez jamais leur union.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Spheal_ExpeditionChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "L'expédition reste le plus grand événement de l'année !", "Normal")
  UI:WaitShowDialogue("Chacun de nous en garde un souvenir marquant et impérissable.")
  UI:WaitShowDialogue("Pour certains, c'était la première fois qu'ils voyaient de si grandes montagnes.")
  UI:WaitShowDialogue("Et pour vous, quel reste le plus beau souvenir de cette ascension ?")
  UI:BeginChoiceMenu("Votre moment favori :", {"Le feu de camp", "La tempête", "Le sommet"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Le feu de camp était si convivial, à partager des rumeurs au milieu de la nuit !")
  elseif res == 2 then
    UI:WaitShowDialogue("La tempête était terrifiante, mais elle a montré toute la force de notre guilde !")
  else
    UI:WaitShowDialogue("Le sommet Venteux était d'une majesté absolue. On y touchait le ciel !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Spheal_StoryDazzlingTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La Team Dazzling fait sensation à Metano Town...", "Normal")
  UI:WaitShowDialogue("Leurs voix magiques s'entendent jusqu'aux confins de la forêt.")
  UI:WaitShowDialogue("On dit qu'elles préparent un grand spectacle pour fêter leur prochaine victoire.")
  UI:WaitShowDialogue("Mais certains érudits pensent qu'il y a une magie ancienne derrière leur chant.")
  UI:WaitShowDialogue("Nous verrons bien si elles parviennent à apaiser le roi de la jungle !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Spheal_ExpeditionBivouacTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les récits de votre bivouac au Mont Venteux sont incroyables...", "Normal")
  UI:WaitShowDialogue("Dormir sous les étoiles, à l'écoute du chant mystique de la montagne...")
  UI:WaitShowDialogue("C'est le genre d'expérience qui forge l'âme d'un véritable aventurier.")
  UI:WaitShowDialogue("Toute la ville est fière de voir votre équipe progresser si vite !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Bagon_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est une magnifique journée d'histoire.", "Normal")
  UI:WaitShowDialogue("Le Chapitre 6 est plein d'aventures et de rumeurs mystérieuses dans la Forêt Lugubre.")
  UI:WaitShowDialogue("Certains disent avoir vu une ombre gigantesque courir à travers les lianes...")
  UI:WaitShowDialogue("...Serait-ce le terrible Zeraora ? Personne n'ose s'en approcher de trop près.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Forêt Lugubre", "La Team Dazzling", "L'expédition", "Rien"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Forêt Lugubre est située juste au nord du village. L'air y est très lourd.")
    UI:WaitShowDialogue("On raconte que les arbres bougent tout seuls et que les lianes emprisonnent les intrus.")
    UI:WaitShowDialogue("Si vous y entrez, restez sur vos gardes. Ne laissez jamais votre partenaire seul.")
    UI:WaitShowDialogue("Et surtout... méfiez-vous du cri de la jungle. Il annonce la colère de son roi.")
    UI:WaitShowDialogue("Je crois que même la guilde n'a pas encore cartographié tout le donjon.")
    UI:WaitShowDialogue("Mais avec votre courage, je sais que vous pourrez y arriver et sauver le petit !")
  elseif choice == 2 then
    UI:WaitShowDialogue("La Team Dazzling... Elles sont arrivées de la côte il y a quelques jours seulement.")
    UI:WaitShowDialogue("Adagio est si polie mais on sent toute sa supériorité dans ses paroles.")
    UI:WaitShowDialogue("Aria est très provocatrice, elle passe son temps à sauter de joie et à se moquer.")
    UI:WaitShowDialogue("Et Sonata... elle est tellement théâtrale avec ses mimiques et ses colères !")
    UI:WaitShowDialogue("Elles se croient déjà au sommet, prétendant que ce sauvetage n'est qu'un jeu pour elles.")
    UI:WaitShowDialogue("Ne les laissez pas vous intimider. Montrez-leur de quel bois vous vous chauffez !")
    UI:WaitShowDialogue("Toute la ville attend de voir qui ramènera le Chenipent en premier.")
  elseif choice == 3 then
    UI:WaitShowDialogue("L'expédition du Mont Venteux... C'était une aventure extraordinaire.")
    UI:WaitShowDialogue("Vous avez gravi les sommets, traversé les tempêtes et affronté le Seigneur des Vents.")
    UI:WaitShowDialogue("Le doyen Penticus m'a dit que votre exploit résonnera longtemps à la guilde.")
    UI:WaitShowDialogue("Mais ce n'était que le début de l'histoire, je le ressens au fond de mes os.")
    UI:WaitShowDialogue("Les flux d'énergie continuent de s'agiter sous la terre, de plus en plus chauds.")
    UI:WaitShowDialogue("Restez forts, mes amis. Le monde a plus que jamais besoin de héros.")
  else
    UI:WaitShowDialogue("D'accord. Prenez soin de vous sur les sentiers et dans les donjons.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Bagon_GossipTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Oh, vous revoilà ! J'ai encore entendu d'étranges rumeurs...", "Normal")
  UI:WaitShowDialogue("On dit que la Team Dazzling n'est pas là pour faire du secours, mais pour un secret...")
  UI:WaitShowDialogue("Elles fouillent les recoins du village et de la guilde, murmurant entre elles.")
  UI:WaitShowDialogue("Même les marchands du marché les trouvent suspectes, malgré leur éclat.")
  UI:WaitShowDialogue("Qu'en pensez-vous ? Pensez-vous qu'elles complotent quelque chose de louche ?")
  UI:BeginChoiceMenu("Que lui dites-vous ?", {"Elles complotent", "Elles sont juste fières", "Je ne sais pas"}, 1, 3)
  UI:WaitForChoice()
  local result = UI:ChoiceResult()
  if result == 1 then
    UI:WaitShowDialogue("Je le savais ! Leurs mines mystérieuses et leurs messes basses ne trompent personne.")
    UI:WaitShowDialogue("Même le Doyen Penticus les surveille du coin de l'œil, je l'ai vu hier.")
    UI:WaitShowDialogue("Faites bien attention si vous les croisez dans la Forêt Lugubre.")
  elseif result == 2 then
    UI:WaitShowDialogue("C'est possible. Les équipes de la côte ont toujours cette fierté un peu agaçante.")
    UI:WaitShowDialogue("Après tout, elles ont une grande réputation à tenir, mais quand même...")
    UI:WaitShowDialogue("Ne relâchez pas votre attention pour autant. On ne sait jamais.")
  else
    UI:WaitShowDialogue("La prudence est mère de sûreté, comme on dit toujours à la guilde.")
    UI:WaitShowDialogue("Nous verrons bien ce que l'avenir nous réserve. Restons concentrés.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Bagon_RaidTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous entendu les rumeurs sur les pilleurs nocturnes ?", "Worried")
  UI:WaitShowDialogue("On dit que des spectres rodent dans les ombres de la ville dès que la nuit tombe...")
  UI:WaitShowDialogue("Ils forcent les coffres, pillent les stands et s'enfuient sans laisser de traces.")
  UI:WaitShowDialogue("La place entière retient son souffle dès que le soleil se couche.")
  UI:WaitShowDialogue("Si vous veillez de nuit, soyez extrêmement prudents. Ils sont redoutables.")
  UI:WaitShowDialogue("Mais je sais que votre équipe a le courage de défendre notre ville de Metano !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Bagon_PrepTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avant de repartir en mission, assurez-vous d'être bien préparés !", "Normal")
  UI:WaitShowDialogue("La Forêt Lugubre ne pardonne pas le manque d'organisation.")
  UI:WaitShowDialogue("Prenez toujours des Baies Oran, des Baies Ceriz et des Échapporbes en cas de besoin.")
  UI:WaitShowDialogue("L'entrepôt de la guilde est là pour stocker vos trésors précieux.")
  UI:WaitShowDialogue("Même l'équipe la plus forte peut faillir sans un bon équipement.")
  UI:WaitShowDialogue("Faites-moi confiance, la préparation est la clé de toute grande aventure !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Bagon_RelaxTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'ambiance au café est si relaxante en ce moment...", "Normal")
  UI:WaitShowDialogue("C'est l'endroit idéal pour faire une pause et discuter avec les autres.")
  UI:WaitShowDialogue("Après une longue journée dans les donjons, rien ne vaut une bonne boisson chaude.")
  UI:WaitShowDialogue("Même les rumeurs les plus folles se partagent ici autour d'une table.")
  UI:WaitShowDialogue("Prenez le temps de souffler un peu avant de retourner affronter la jungle.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Bagon_DazzlingChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, que pensez-vous de chaque membre des Dazzling ?", "Normal")
  UI:BeginChoiceMenu("Qui souhaitez-vous évaluer ?", {"Adagio", "Aria", "Sonata", "Toutes"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Adagio est d'une élégance rare, mais ses yeux brillent d'une ambition froide.")
  elseif res == 2 then
    UI:WaitShowDialogue("Aria ne fait que s'exciter et provoquer tout le monde. C'est insupportable.")
  elseif res == 3 then
    UI:WaitShowDialogue("Sonata est tellement théâtrale ! Ses grands gestes amusent la galerie.")
  else
    UI:WaitShowDialogue("Elles forment un groupe redoutable. Ne sous-estimez jamais leur union.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Bagon_ExpeditionChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "L'expédition reste le plus grand événement de l'année !", "Normal")
  UI:WaitShowDialogue("Chacun de nous en garde un souvenir marquant et impérissable.")
  UI:WaitShowDialogue("Pour certains, c'était la première fois qu'ils voyaient de si grandes montagnes.")
  UI:WaitShowDialogue("Et pour vous, quel reste le plus beau souvenir de cette ascension ?")
  UI:BeginChoiceMenu("Votre moment favori :", {"Le feu de camp", "La tempête", "Le sommet"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Le feu de camp était si convivial, à partager des rumeurs au milieu de la nuit !")
  elseif res == 2 then
    UI:WaitShowDialogue("La tempête était terrifiante, mais elle a montré toute la force de notre guilde !")
  else
    UI:WaitShowDialogue("Le sommet Venteux était d'une majesté absolue. On y touchait le ciel !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Bagon_StoryDazzlingTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La Team Dazzling fait sensation à Metano Town...", "Normal")
  UI:WaitShowDialogue("Leurs voix magiques s'entendent jusqu'aux confins de la forêt.")
  UI:WaitShowDialogue("On dit qu'elles préparent un grand spectacle pour fêter leur prochaine victoire.")
  UI:WaitShowDialogue("Mais certains érudits pensent qu'il y a une magie ancienne derrière leur chant.")
  UI:WaitShowDialogue("Nous verrons bien si elles parviennent à apaiser le roi de la jungle !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Bagon_ExpeditionBivouacTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les récits de votre bivouac au Mont Venteux sont incroyables...", "Normal")
  UI:WaitShowDialogue("Dormir sous les étoiles, à l'écoute du chant mystique de la montagne...")
  UI:WaitShowDialogue("C'est le genre d'expérience qui forge l'âme d'un véritable aventurier.")
  UI:WaitShowDialogue("Toute la ville est fière de voir votre équipe progresser si vite !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Doduo_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est une magnifique journée d'histoire.", "Normal")
  UI:WaitShowDialogue("Le Chapitre 6 est plein d'aventures et de rumeurs mystérieuses dans la Forêt Lugubre.")
  UI:WaitShowDialogue("Certains disent avoir vu une ombre gigantesque courir à travers les lianes...")
  UI:WaitShowDialogue("...Serait-ce le terrible Zeraora ? Personne n'ose s'en approcher de trop près.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Forêt Lugubre", "La Team Dazzling", "L'expédition", "Rien"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Forêt Lugubre est située juste au nord du village. L'air y est très lourd.")
    UI:WaitShowDialogue("On raconte que les arbres bougent tout seuls et que les lianes emprisonnent les intrus.")
    UI:WaitShowDialogue("Si vous y entrez, restez sur vos gardes. Ne laissez jamais votre partenaire seul.")
    UI:WaitShowDialogue("Et surtout... méfiez-vous du cri de la jungle. Il annonce la colère de son roi.")
    UI:WaitShowDialogue("Je crois que même la guilde n'a pas encore cartographié tout le donjon.")
    UI:WaitShowDialogue("Mais avec votre courage, je sais que vous pourrez y arriver et sauver le petit !")
  elseif choice == 2 then
    UI:WaitShowDialogue("La Team Dazzling... Elles sont arrivées de la côte il y a quelques jours seulement.")
    UI:WaitShowDialogue("Adagio est si polie mais on sent toute sa supériorité dans ses paroles.")
    UI:WaitShowDialogue("Aria est très provocatrice, elle passe son temps à sauter de joie et à se moquer.")
    UI:WaitShowDialogue("Et Sonata... elle est tellement théâtrale avec ses mimiques et ses colères !")
    UI:WaitShowDialogue("Elles se croient déjà au sommet, prétendant que ce sauvetage n'est qu'un jeu pour elles.")
    UI:WaitShowDialogue("Ne les laissez pas vous intimider. Montrez-leur de quel bois vous vous chauffez !")
    UI:WaitShowDialogue("Toute la ville attend de voir qui ramènera le Chenipent en premier.")
  elseif choice == 3 then
    UI:WaitShowDialogue("L'expédition du Mont Venteux... C'était une aventure extraordinaire.")
    UI:WaitShowDialogue("Vous avez gravi les sommets, traversé les tempêtes et affronté le Seigneur des Vents.")
    UI:WaitShowDialogue("Le doyen Penticus m'a dit que votre exploit résonnera longtemps à la guilde.")
    UI:WaitShowDialogue("Mais ce n'était que le début de l'histoire, je le ressens au fond de mes os.")
    UI:WaitShowDialogue("Les flux d'énergie continuent de s'agiter sous la terre, de plus en plus chauds.")
    UI:WaitShowDialogue("Restez forts, mes amis. Le monde a plus que jamais besoin de héros.")
  else
    UI:WaitShowDialogue("D'accord. Prenez soin de vous sur les sentiers et dans les donjons.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Doduo_GossipTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Oh, vous revoilà ! J'ai encore entendu d'étranges rumeurs...", "Normal")
  UI:WaitShowDialogue("On dit que la Team Dazzling n'est pas là pour faire du secours, mais pour un secret...")
  UI:WaitShowDialogue("Elles fouillent les recoins du village et de la guilde, murmurant entre elles.")
  UI:WaitShowDialogue("Même les marchands du marché les trouvent suspectes, malgré leur éclat.")
  UI:WaitShowDialogue("Qu'en pensez-vous ? Pensez-vous qu'elles complotent quelque chose de louche ?")
  UI:BeginChoiceMenu("Que lui dites-vous ?", {"Elles complotent", "Elles sont juste fières", "Je ne sais pas"}, 1, 3)
  UI:WaitForChoice()
  local result = UI:ChoiceResult()
  if result == 1 then
    UI:WaitShowDialogue("Je le savais ! Leurs mines mystérieuses et leurs messes basses ne trompent personne.")
    UI:WaitShowDialogue("Même le Doyen Penticus les surveille du coin de l'œil, je l'ai vu hier.")
    UI:WaitShowDialogue("Faites bien attention si vous les croisez dans la Forêt Lugubre.")
  elseif result == 2 then
    UI:WaitShowDialogue("C'est possible. Les équipes de la côte ont toujours cette fierté un peu agaçante.")
    UI:WaitShowDialogue("Après tout, elles ont une grande réputation à tenir, mais quand même...")
    UI:WaitShowDialogue("Ne relâchez pas votre attention pour autant. On ne sait jamais.")
  else
    UI:WaitShowDialogue("La prudence est mère de sûreté, comme on dit toujours à la guilde.")
    UI:WaitShowDialogue("Nous verrons bien ce que l'avenir nous réserve. Restons concentrés.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Doduo_RaidTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous entendu les rumeurs sur les pilleurs nocturnes ?", "Worried")
  UI:WaitShowDialogue("On dit que des spectres rodent dans les ombres de la ville dès que la nuit tombe...")
  UI:WaitShowDialogue("Ils forcent les coffres, pillent les stands et s'enfuient sans laisser de traces.")
  UI:WaitShowDialogue("La place entière retient son souffle dès que le soleil se couche.")
  UI:WaitShowDialogue("Si vous veillez de nuit, soyez extrêmement prudents. Ils sont redoutables.")
  UI:WaitShowDialogue("Mais je sais que votre équipe a le courage de défendre notre ville de Metano !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Doduo_PrepTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avant de repartir en mission, assurez-vous d'être bien préparés !", "Normal")
  UI:WaitShowDialogue("La Forêt Lugubre ne pardonne pas le manque d'organisation.")
  UI:WaitShowDialogue("Prenez toujours des Baies Oran, des Baies Ceriz et des Échapporbes en cas de besoin.")
  UI:WaitShowDialogue("L'entrepôt de la guilde est là pour stocker vos trésors précieux.")
  UI:WaitShowDialogue("Même l'équipe la plus forte peut faillir sans un bon équipement.")
  UI:WaitShowDialogue("Faites-moi confiance, la préparation est la clé de toute grande aventure !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Doduo_RelaxTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'ambiance au café est si relaxante en ce moment...", "Normal")
  UI:WaitShowDialogue("C'est l'endroit idéal pour faire une pause et discuter avec les autres.")
  UI:WaitShowDialogue("Après une longue journée dans les donjons, rien ne vaut une bonne boisson chaude.")
  UI:WaitShowDialogue("Même les rumeurs les plus folles se partagent ici autour d'une table.")
  UI:WaitShowDialogue("Prenez le temps de souffler un peu avant de retourner affronter la jungle.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Doduo_DazzlingChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, que pensez-vous de chaque membre des Dazzling ?", "Normal")
  UI:BeginChoiceMenu("Qui souhaitez-vous évaluer ?", {"Adagio", "Aria", "Sonata", "Toutes"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Adagio est d'une élégance rare, mais ses yeux brillent d'une ambition froide.")
  elseif res == 2 then
    UI:WaitShowDialogue("Aria ne fait que s'exciter et provoquer tout le monde. C'est insupportable.")
  elseif res == 3 then
    UI:WaitShowDialogue("Sonata est tellement théâtrale ! Ses grands gestes amusent la galerie.")
  else
    UI:WaitShowDialogue("Elles forment un groupe redoutable. Ne sous-estimez jamais leur union.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Doduo_ExpeditionChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "L'expédition reste le plus grand événement de l'année !", "Normal")
  UI:WaitShowDialogue("Chacun de nous en garde un souvenir marquant et impérissable.")
  UI:WaitShowDialogue("Pour certains, c'était la première fois qu'ils voyaient de si grandes montagnes.")
  UI:WaitShowDialogue("Et pour vous, quel reste le plus beau souvenir de cette ascension ?")
  UI:BeginChoiceMenu("Votre moment favori :", {"Le feu de camp", "La tempête", "Le sommet"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Le feu de camp était si convivial, à partager des rumeurs au milieu de la nuit !")
  elseif res == 2 then
    UI:WaitShowDialogue("La tempête était terrifiante, mais elle a montré toute la force de notre guilde !")
  else
    UI:WaitShowDialogue("Le sommet Venteux était d'une majesté absolue. On y touchait le ciel !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Doduo_StoryDazzlingTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La Team Dazzling fait sensation à Metano Town...", "Normal")
  UI:WaitShowDialogue("Leurs voix magiques s'entendent jusqu'aux confins de la forêt.")
  UI:WaitShowDialogue("On dit qu'elles préparent un grand spectacle pour fêter leur prochaine victoire.")
  UI:WaitShowDialogue("Mais certains érudits pensent qu'il y a une magie ancienne derrière leur chant.")
  UI:WaitShowDialogue("Nous verrons bien si elles parviennent à apaiser le roi de la jungle !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Doduo_ExpeditionBivouacTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les récits de votre bivouac au Mont Venteux sont incroyables...", "Normal")
  UI:WaitShowDialogue("Dormir sous les étoiles, à l'écoute du chant mystique de la montagne...")
  UI:WaitShowDialogue("C'est le genre d'expérience qui forge l'âme d'un véritable aventurier.")
  UI:WaitShowDialogue("Toute la ville est fière de voir votre équipe progresser si vite !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Metapod_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est une magnifique journée d'histoire.", "Normal")
  UI:WaitShowDialogue("Le Chapitre 6 est plein d'aventures et de rumeurs mystérieuses dans la Forêt Lugubre.")
  UI:WaitShowDialogue("Certains disent avoir vu une ombre gigantesque courir à travers les lianes...")
  UI:WaitShowDialogue("...Serait-ce le terrible Zeraora ? Personne n'ose s'en approcher de trop près.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Forêt Lugubre", "La Team Dazzling", "L'expédition", "Rien"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Forêt Lugubre est située juste au nord du village. L'air y est très lourd.")
    UI:WaitShowDialogue("On raconte que les arbres bougent tout seuls et que les lianes emprisonnent les intrus.")
    UI:WaitShowDialogue("Si vous y entrez, restez sur vos gardes. Ne laissez jamais votre partenaire seul.")
    UI:WaitShowDialogue("Et surtout... méfiez-vous du cri de la jungle. Il annonce la colère de son roi.")
    UI:WaitShowDialogue("Je crois que même la guilde n'a pas encore cartographié tout le donjon.")
    UI:WaitShowDialogue("Mais avec votre courage, je sais que vous pourrez y arriver et sauver le petit !")
  elseif choice == 2 then
    UI:WaitShowDialogue("La Team Dazzling... Elles sont arrivées de la côte il y a quelques jours seulement.")
    UI:WaitShowDialogue("Adagio est si polie mais on sent toute sa supériorité dans ses paroles.")
    UI:WaitShowDialogue("Aria est très provocatrice, elle passe son temps à sauter de joie et à se moquer.")
    UI:WaitShowDialogue("Et Sonata... elle est tellement théâtrale avec ses mimiques et ses colères !")
    UI:WaitShowDialogue("Elles se croient déjà au sommet, prétendant que ce sauvetage n'est qu'un jeu pour elles.")
    UI:WaitShowDialogue("Ne les laissez pas vous intimider. Montrez-leur de quel bois vous vous chauffez !")
    UI:WaitShowDialogue("Toute la ville attend de voir qui ramènera le Chenipent en premier.")
  elseif choice == 3 then
    UI:WaitShowDialogue("L'expédition du Mont Venteux... C'était une aventure extraordinaire.")
    UI:WaitShowDialogue("Vous avez gravi les sommets, traversé les tempêtes et affronté le Seigneur des Vents.")
    UI:WaitShowDialogue("Le doyen Penticus m'a dit que votre exploit résonnera longtemps à la guilde.")
    UI:WaitShowDialogue("Mais ce n'était que le début de l'histoire, je le ressens au fond de mes os.")
    UI:WaitShowDialogue("Les flux d'énergie continuent de s'agiter sous la terre, de plus en plus chauds.")
    UI:WaitShowDialogue("Restez forts, mes amis. Le monde a plus que jamais besoin de héros.")
  else
    UI:WaitShowDialogue("D'accord. Prenez soin de vous sur les sentiers et dans les donjons.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Metapod_GossipTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Oh, vous revoilà ! J'ai encore entendu d'étranges rumeurs...", "Normal")
  UI:WaitShowDialogue("On dit que la Team Dazzling n'est pas là pour faire du secours, mais pour un secret...")
  UI:WaitShowDialogue("Elles fouillent les recoins du village et de la guilde, murmurant entre elles.")
  UI:WaitShowDialogue("Même les marchands du marché les trouvent suspectes, malgré leur éclat.")
  UI:WaitShowDialogue("Qu'en pensez-vous ? Pensez-vous qu'elles complotent quelque chose de louche ?")
  UI:BeginChoiceMenu("Que lui dites-vous ?", {"Elles complotent", "Elles sont juste fières", "Je ne sais pas"}, 1, 3)
  UI:WaitForChoice()
  local result = UI:ChoiceResult()
  if result == 1 then
    UI:WaitShowDialogue("Je le savais ! Leurs mines mystérieuses et leurs messes basses ne trompent personne.")
    UI:WaitShowDialogue("Même le Doyen Penticus les surveille du coin de l'œil, je l'ai vu hier.")
    UI:WaitShowDialogue("Faites bien attention si vous les croisez dans la Forêt Lugubre.")
  elseif result == 2 then
    UI:WaitShowDialogue("C'est possible. Les équipes de la côte ont toujours cette fierté un peu agaçante.")
    UI:WaitShowDialogue("Après tout, elles ont une grande réputation à tenir, mais quand même...")
    UI:WaitShowDialogue("Ne relâchez pas votre attention pour autant. On ne sait jamais.")
  else
    UI:WaitShowDialogue("La prudence est mère de sûreté, comme on dit toujours à la guilde.")
    UI:WaitShowDialogue("Nous verrons bien ce que l'avenir nous réserve. Restons concentrés.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Metapod_RaidTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous entendu les rumeurs sur les pilleurs nocturnes ?", "Worried")
  UI:WaitShowDialogue("On dit que des spectres rodent dans les ombres de la ville dès que la nuit tombe...")
  UI:WaitShowDialogue("Ils forcent les coffres, pillent les stands et s'enfuient sans laisser de traces.")
  UI:WaitShowDialogue("La place entière retient son souffle dès que le soleil se couche.")
  UI:WaitShowDialogue("Si vous veillez de nuit, soyez extrêmement prudents. Ils sont redoutables.")
  UI:WaitShowDialogue("Mais je sais que votre équipe a le courage de défendre notre ville de Metano !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Metapod_PrepTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avant de repartir en mission, assurez-vous d'être bien préparés !", "Normal")
  UI:WaitShowDialogue("La Forêt Lugubre ne pardonne pas le manque d'organisation.")
  UI:WaitShowDialogue("Prenez toujours des Baies Oran, des Baies Ceriz et des Échapporbes en cas de besoin.")
  UI:WaitShowDialogue("L'entrepôt de la guilde est là pour stocker vos trésors précieux.")
  UI:WaitShowDialogue("Même l'équipe la plus forte peut faillir sans un bon équipement.")
  UI:WaitShowDialogue("Faites-moi confiance, la préparation est la clé de toute grande aventure !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Metapod_RelaxTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'ambiance au café est si relaxante en ce moment...", "Normal")
  UI:WaitShowDialogue("C'est l'endroit idéal pour faire une pause et discuter avec les autres.")
  UI:WaitShowDialogue("Après une longue journée dans les donjons, rien ne vaut une bonne boisson chaude.")
  UI:WaitShowDialogue("Même les rumeurs les plus folles se partagent ici autour d'une table.")
  UI:WaitShowDialogue("Prenez le temps de souffler un peu avant de retourner affronter la jungle.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Metapod_DazzlingChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, que pensez-vous de chaque membre des Dazzling ?", "Normal")
  UI:BeginChoiceMenu("Qui souhaitez-vous évaluer ?", {"Adagio", "Aria", "Sonata", "Toutes"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Adagio est d'une élégance rare, mais ses yeux brillent d'une ambition froide.")
  elseif res == 2 then
    UI:WaitShowDialogue("Aria ne fait que s'exciter et provoquer tout le monde. C'est insupportable.")
  elseif res == 3 then
    UI:WaitShowDialogue("Sonata est tellement théâtrale ! Ses grands gestes amusent la galerie.")
  else
    UI:WaitShowDialogue("Elles forment un groupe redoutable. Ne sous-estimez jamais leur union.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Metapod_ExpeditionChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "L'expédition reste le plus grand événement de l'année !", "Normal")
  UI:WaitShowDialogue("Chacun de nous en garde un souvenir marquant et impérissable.")
  UI:WaitShowDialogue("Pour certains, c'était la première fois qu'ils voyaient de si grandes montagnes.")
  UI:WaitShowDialogue("Et pour vous, quel reste le plus beau souvenir de cette ascension ?")
  UI:BeginChoiceMenu("Votre moment favori :", {"Le feu de camp", "La tempête", "Le sommet"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Le feu de camp était si convivial, à partager des rumeurs au milieu de la nuit !")
  elseif res == 2 then
    UI:WaitShowDialogue("La tempête était terrifiante, mais elle a montré toute la force de notre guilde !")
  else
    UI:WaitShowDialogue("Le sommet Venteux était d'une majesté absolue. On y touchait le ciel !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Metapod_StoryDazzlingTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La Team Dazzling fait sensation à Metano Town...", "Normal")
  UI:WaitShowDialogue("Leurs voix magiques s'entendent jusqu'aux confins de la forêt.")
  UI:WaitShowDialogue("On dit qu'elles préparent un grand spectacle pour fêter leur prochaine victoire.")
  UI:WaitShowDialogue("Mais certains érudits pensent qu'il y a une magie ancienne derrière leur chant.")
  UI:WaitShowDialogue("Nous verrons bien si elles parviennent à apaiser le roi de la jungle !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Metapod_ExpeditionBivouacTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les récits de votre bivouac au Mont Venteux sont incroyables...", "Normal")
  UI:WaitShowDialogue("Dormir sous les étoiles, à l'écoute du chant mystique de la montagne...")
  UI:WaitShowDialogue("C'est le genre d'expérience qui forge l'âme d'un véritable aventurier.")
  UI:WaitShowDialogue("Toute la ville est fière de voir votre équipe progresser si vite !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Silcoon_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est une magnifique journée d'histoire.", "Normal")
  UI:WaitShowDialogue("Le Chapitre 6 est plein d'aventures et de rumeurs mystérieuses dans la Forêt Lugubre.")
  UI:WaitShowDialogue("Certains disent avoir vu une ombre gigantesque courir à travers les lianes...")
  UI:WaitShowDialogue("...Serait-ce le terrible Zeraora ? Personne n'ose s'en approcher de trop près.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Forêt Lugubre", "La Team Dazzling", "L'expédition", "Rien"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Forêt Lugubre est située juste au nord du village. L'air y est très lourd.")
    UI:WaitShowDialogue("On raconte que les arbres bougent tout seuls et que les lianes emprisonnent les intrus.")
    UI:WaitShowDialogue("Si vous y entrez, restez sur vos gardes. Ne laissez jamais votre partenaire seul.")
    UI:WaitShowDialogue("Et surtout... méfiez-vous du cri de la jungle. Il annonce la colère de son roi.")
    UI:WaitShowDialogue("Je crois que même la guilde n'a pas encore cartographié tout le donjon.")
    UI:WaitShowDialogue("Mais avec votre courage, je sais que vous pourrez y arriver et sauver le petit !")
  elseif choice == 2 then
    UI:WaitShowDialogue("La Team Dazzling... Elles sont arrivées de la côte il y a quelques jours seulement.")
    UI:WaitShowDialogue("Adagio est si polie mais on sent toute sa supériorité dans ses paroles.")
    UI:WaitShowDialogue("Aria est très provocatrice, elle passe son temps à sauter de joie et à se moquer.")
    UI:WaitShowDialogue("Et Sonata... elle est tellement théâtrale avec ses mimiques et ses colères !")
    UI:WaitShowDialogue("Elles se croient déjà au sommet, prétendant que ce sauvetage n'est qu'un jeu pour elles.")
    UI:WaitShowDialogue("Ne les laissez pas vous intimider. Montrez-leur de quel bois vous vous chauffez !")
    UI:WaitShowDialogue("Toute la ville attend de voir qui ramènera le Chenipent en premier.")
  elseif choice == 3 then
    UI:WaitShowDialogue("L'expédition du Mont Venteux... C'était une aventure extraordinaire.")
    UI:WaitShowDialogue("Vous avez gravi les sommets, traversé les tempêtes et affronté le Seigneur des Vents.")
    UI:WaitShowDialogue("Le doyen Penticus m'a dit que votre exploit résonnera longtemps à la guilde.")
    UI:WaitShowDialogue("Mais ce n'était que le début de l'histoire, je le ressens au fond de mes os.")
    UI:WaitShowDialogue("Les flux d'énergie continuent de s'agiter sous la terre, de plus en plus chauds.")
    UI:WaitShowDialogue("Restez forts, mes amis. Le monde a plus que jamais besoin de héros.")
  else
    UI:WaitShowDialogue("D'accord. Prenez soin de vous sur les sentiers et dans les donjons.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Silcoon_GossipTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Oh, vous revoilà ! J'ai encore entendu d'étranges rumeurs...", "Normal")
  UI:WaitShowDialogue("On dit que la Team Dazzling n'est pas là pour faire du secours, mais pour un secret...")
  UI:WaitShowDialogue("Elles fouillent les recoins du village et de la guilde, murmurant entre elles.")
  UI:WaitShowDialogue("Même les marchands du marché les trouvent suspectes, malgré leur éclat.")
  UI:WaitShowDialogue("Qu'en pensez-vous ? Pensez-vous qu'elles complotent quelque chose de louche ?")
  UI:BeginChoiceMenu("Que lui dites-vous ?", {"Elles complotent", "Elles sont juste fières", "Je ne sais pas"}, 1, 3)
  UI:WaitForChoice()
  local result = UI:ChoiceResult()
  if result == 1 then
    UI:WaitShowDialogue("Je le savais ! Leurs mines mystérieuses et leurs messes basses ne trompent personne.")
    UI:WaitShowDialogue("Même le Doyen Penticus les surveille du coin de l'œil, je l'ai vu hier.")
    UI:WaitShowDialogue("Faites bien attention si vous les croisez dans la Forêt Lugubre.")
  elseif result == 2 then
    UI:WaitShowDialogue("C'est possible. Les équipes de la côte ont toujours cette fierté un peu agaçante.")
    UI:WaitShowDialogue("Après tout, elles ont une grande réputation à tenir, mais quand même...")
    UI:WaitShowDialogue("Ne relâchez pas votre attention pour autant. On ne sait jamais.")
  else
    UI:WaitShowDialogue("La prudence est mère de sûreté, comme on dit toujours à la guilde.")
    UI:WaitShowDialogue("Nous verrons bien ce que l'avenir nous réserve. Restons concentrés.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Silcoon_RaidTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous entendu les rumeurs sur les pilleurs nocturnes ?", "Worried")
  UI:WaitShowDialogue("On dit que des spectres rodent dans les ombres de la ville dès que la nuit tombe...")
  UI:WaitShowDialogue("Ils forcent les coffres, pillent les stands et s'enfuient sans laisser de traces.")
  UI:WaitShowDialogue("La place entière retient son souffle dès que le soleil se couche.")
  UI:WaitShowDialogue("Si vous veillez de nuit, soyez extrêmement prudents. Ils sont redoutables.")
  UI:WaitShowDialogue("Mais je sais que votre équipe a le courage de défendre notre ville de Metano !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Silcoon_PrepTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avant de repartir en mission, assurez-vous d'être bien préparés !", "Normal")
  UI:WaitShowDialogue("La Forêt Lugubre ne pardonne pas le manque d'organisation.")
  UI:WaitShowDialogue("Prenez toujours des Baies Oran, des Baies Ceriz et des Échapporbes en cas de besoin.")
  UI:WaitShowDialogue("L'entrepôt de la guilde est là pour stocker vos trésors précieux.")
  UI:WaitShowDialogue("Même l'équipe la plus forte peut faillir sans un bon équipement.")
  UI:WaitShowDialogue("Faites-moi confiance, la préparation est la clé de toute grande aventure !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Silcoon_RelaxTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'ambiance au café est si relaxante en ce moment...", "Normal")
  UI:WaitShowDialogue("C'est l'endroit idéal pour faire une pause et discuter avec les autres.")
  UI:WaitShowDialogue("Après une longue journée dans les donjons, rien ne vaut une bonne boisson chaude.")
  UI:WaitShowDialogue("Même les rumeurs les plus folles se partagent ici autour d'une table.")
  UI:WaitShowDialogue("Prenez le temps de souffler un peu avant de retourner affronter la jungle.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Silcoon_DazzlingChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, que pensez-vous de chaque membre des Dazzling ?", "Normal")
  UI:BeginChoiceMenu("Qui souhaitez-vous évaluer ?", {"Adagio", "Aria", "Sonata", "Toutes"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Adagio est d'une élégance rare, mais ses yeux brillent d'une ambition froide.")
  elseif res == 2 then
    UI:WaitShowDialogue("Aria ne fait que s'exciter et provoquer tout le monde. C'est insupportable.")
  elseif res == 3 then
    UI:WaitShowDialogue("Sonata est tellement théâtrale ! Ses grands gestes amusent la galerie.")
  else
    UI:WaitShowDialogue("Elles forment un groupe redoutable. Ne sous-estimez jamais leur union.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Silcoon_ExpeditionChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "L'expédition reste le plus grand événement de l'année !", "Normal")
  UI:WaitShowDialogue("Chacun de nous en garde un souvenir marquant et impérissable.")
  UI:WaitShowDialogue("Pour certains, c'était la première fois qu'ils voyaient de si grandes montagnes.")
  UI:WaitShowDialogue("Et pour vous, quel reste le plus beau souvenir de cette ascension ?")
  UI:BeginChoiceMenu("Votre moment favori :", {"Le feu de camp", "La tempête", "Le sommet"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Le feu de camp était si convivial, à partager des rumeurs au milieu de la nuit !")
  elseif res == 2 then
    UI:WaitShowDialogue("La tempête était terrifiante, mais elle a montré toute la force de notre guilde !")
  else
    UI:WaitShowDialogue("Le sommet Venteux était d'une majesté absolue. On y touchait le ciel !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Silcoon_StoryDazzlingTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La Team Dazzling fait sensation à Metano Town...", "Normal")
  UI:WaitShowDialogue("Leurs voix magiques s'entendent jusqu'aux confins de la forêt.")
  UI:WaitShowDialogue("On dit qu'elles préparent un grand spectacle pour fêter leur prochaine victoire.")
  UI:WaitShowDialogue("Mais certains érudits pensent qu'il y a une magie ancienne derrière leur chant.")
  UI:WaitShowDialogue("Nous verrons bien si elles parviennent à apaiser le roi de la jungle !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Silcoon_ExpeditionBivouacTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les récits de votre bivouac au Mont Venteux sont incroyables...", "Normal")
  UI:WaitShowDialogue("Dormir sous les étoiles, à l'écoute du chant mystique de la montagne...")
  UI:WaitShowDialogue("C'est le genre d'expérience qui forge l'âme d'un véritable aventurier.")
  UI:WaitShowDialogue("Toute la ville est fière de voir votre équipe progresser si vite !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Mareep_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est une magnifique journée d'histoire.", "Normal")
  UI:WaitShowDialogue("Le Chapitre 6 est plein d'aventures et de rumeurs mystérieuses dans la Forêt Lugubre.")
  UI:WaitShowDialogue("Certains disent avoir vu une ombre gigantesque courir à travers les lianes...")
  UI:WaitShowDialogue("...Serait-ce le terrible Zeraora ? Personne n'ose s'en approcher de trop près.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Forêt Lugubre", "La Team Dazzling", "L'expédition", "Rien"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Forêt Lugubre est située juste au nord du village. L'air y est très lourd.")
    UI:WaitShowDialogue("On raconte que les arbres bougent tout seuls et que les lianes emprisonnent les intrus.")
    UI:WaitShowDialogue("Si vous y entrez, restez sur vos gardes. Ne laissez jamais votre partenaire seul.")
    UI:WaitShowDialogue("Et surtout... méfiez-vous du cri de la jungle. Il annonce la colère de son roi.")
    UI:WaitShowDialogue("Je crois que même la guilde n'a pas encore cartographié tout le donjon.")
    UI:WaitShowDialogue("Mais avec votre courage, je sais que vous pourrez y arriver et sauver le petit !")
  elseif choice == 2 then
    UI:WaitShowDialogue("La Team Dazzling... Elles sont arrivées de la côte il y a quelques jours seulement.")
    UI:WaitShowDialogue("Adagio est si polie mais on sent toute sa supériorité dans ses paroles.")
    UI:WaitShowDialogue("Aria est très provocatrice, elle passe son temps à sauter de joie et à se moquer.")
    UI:WaitShowDialogue("Et Sonata... elle est tellement théâtrale avec ses mimiques et ses colères !")
    UI:WaitShowDialogue("Elles se croient déjà au sommet, prétendant que ce sauvetage n'est qu'un jeu pour elles.")
    UI:WaitShowDialogue("Ne les laissez pas vous intimider. Montrez-leur de quel bois vous vous chauffez !")
    UI:WaitShowDialogue("Toute la ville attend de voir qui ramènera le Chenipent en premier.")
  elseif choice == 3 then
    UI:WaitShowDialogue("L'expédition du Mont Venteux... C'était une aventure extraordinaire.")
    UI:WaitShowDialogue("Vous avez gravi les sommets, traversé les tempêtes et affronté le Seigneur des Vents.")
    UI:WaitShowDialogue("Le doyen Penticus m'a dit que votre exploit résonnera longtemps à la guilde.")
    UI:WaitShowDialogue("Mais ce n'était que le début de l'histoire, je le ressens au fond de mes os.")
    UI:WaitShowDialogue("Les flux d'énergie continuent de s'agiter sous la terre, de plus en plus chauds.")
    UI:WaitShowDialogue("Restez forts, mes amis. Le monde a plus que jamais besoin de héros.")
  else
    UI:WaitShowDialogue("D'accord. Prenez soin de vous sur les sentiers et dans les donjons.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Mareep_GossipTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Oh, vous revoilà ! J'ai encore entendu d'étranges rumeurs...", "Normal")
  UI:WaitShowDialogue("On dit que la Team Dazzling n'est pas là pour faire du secours, mais pour un secret...")
  UI:WaitShowDialogue("Elles fouillent les recoins du village et de la guilde, murmurant entre elles.")
  UI:WaitShowDialogue("Même les marchands du marché les trouvent suspectes, malgré leur éclat.")
  UI:WaitShowDialogue("Qu'en pensez-vous ? Pensez-vous qu'elles complotent quelque chose de louche ?")
  UI:BeginChoiceMenu("Que lui dites-vous ?", {"Elles complotent", "Elles sont juste fières", "Je ne sais pas"}, 1, 3)
  UI:WaitForChoice()
  local result = UI:ChoiceResult()
  if result == 1 then
    UI:WaitShowDialogue("Je le savais ! Leurs mines mystérieuses et leurs messes basses ne trompent personne.")
    UI:WaitShowDialogue("Même le Doyen Penticus les surveille du coin de l'œil, je l'ai vu hier.")
    UI:WaitShowDialogue("Faites bien attention si vous les croisez dans la Forêt Lugubre.")
  elseif result == 2 then
    UI:WaitShowDialogue("C'est possible. Les équipes de la côte ont toujours cette fierté un peu agaçante.")
    UI:WaitShowDialogue("Après tout, elles ont une grande réputation à tenir, mais quand même...")
    UI:WaitShowDialogue("Ne relâchez pas votre attention pour autant. On ne sait jamais.")
  else
    UI:WaitShowDialogue("La prudence est mère de sûreté, comme on dit toujours à la guilde.")
    UI:WaitShowDialogue("Nous verrons bien ce que l'avenir nous réserve. Restons concentrés.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Mareep_RaidTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous entendu les rumeurs sur les pilleurs nocturnes ?", "Worried")
  UI:WaitShowDialogue("On dit que des spectres rodent dans les ombres de la ville dès que la nuit tombe...")
  UI:WaitShowDialogue("Ils forcent les coffres, pillent les stands et s'enfuient sans laisser de traces.")
  UI:WaitShowDialogue("La place entière retient son souffle dès que le soleil se couche.")
  UI:WaitShowDialogue("Si vous veillez de nuit, soyez extrêmement prudents. Ils sont redoutables.")
  UI:WaitShowDialogue("Mais je sais que votre équipe a le courage de défendre notre ville de Metano !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Mareep_PrepTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avant de repartir en mission, assurez-vous d'être bien préparés !", "Normal")
  UI:WaitShowDialogue("La Forêt Lugubre ne pardonne pas le manque d'organisation.")
  UI:WaitShowDialogue("Prenez toujours des Baies Oran, des Baies Ceriz et des Échapporbes en cas de besoin.")
  UI:WaitShowDialogue("L'entrepôt de la guilde est là pour stocker vos trésors précieux.")
  UI:WaitShowDialogue("Même l'équipe la plus forte peut faillir sans un bon équipement.")
  UI:WaitShowDialogue("Faites-moi confiance, la préparation est la clé de toute grande aventure !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Mareep_RelaxTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'ambiance au café est si relaxante en ce moment...", "Normal")
  UI:WaitShowDialogue("C'est l'endroit idéal pour faire une pause et discuter avec les autres.")
  UI:WaitShowDialogue("Après une longue journée dans les donjons, rien ne vaut une bonne boisson chaude.")
  UI:WaitShowDialogue("Même les rumeurs les plus folles se partagent ici autour d'une table.")
  UI:WaitShowDialogue("Prenez le temps de souffler un peu avant de retourner affronter la jungle.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Mareep_DazzlingChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, que pensez-vous de chaque membre des Dazzling ?", "Normal")
  UI:BeginChoiceMenu("Qui souhaitez-vous évaluer ?", {"Adagio", "Aria", "Sonata", "Toutes"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Adagio est d'une élégance rare, mais ses yeux brillent d'une ambition froide.")
  elseif res == 2 then
    UI:WaitShowDialogue("Aria ne fait que s'exciter et provoquer tout le monde. C'est insupportable.")
  elseif res == 3 then
    UI:WaitShowDialogue("Sonata est tellement théâtrale ! Ses grands gestes amusent la galerie.")
  else
    UI:WaitShowDialogue("Elles forment un groupe redoutable. Ne sous-estimez jamais leur union.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Mareep_ExpeditionChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "L'expédition reste le plus grand événement de l'année !", "Normal")
  UI:WaitShowDialogue("Chacun de nous en garde un souvenir marquant et impérissable.")
  UI:WaitShowDialogue("Pour certains, c'était la première fois qu'ils voyaient de si grandes montagnes.")
  UI:WaitShowDialogue("Et pour vous, quel reste le plus beau souvenir de cette ascension ?")
  UI:BeginChoiceMenu("Votre moment favori :", {"Le feu de camp", "La tempête", "Le sommet"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Le feu de camp était si convivial, à partager des rumeurs au milieu de la nuit !")
  elseif res == 2 then
    UI:WaitShowDialogue("La tempête était terrifiante, mais elle a montré toute la force de notre guilde !")
  else
    UI:WaitShowDialogue("Le sommet Venteux était d'une majesté absolue. On y touchait le ciel !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Mareep_StoryDazzlingTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La Team Dazzling fait sensation à Metano Town...", "Normal")
  UI:WaitShowDialogue("Leurs voix magiques s'entendent jusqu'aux confins de la forêt.")
  UI:WaitShowDialogue("On dit qu'elles préparent un grand spectacle pour fêter leur prochaine victoire.")
  UI:WaitShowDialogue("Mais certains érudits pensent qu'il y a une magie ancienne derrière leur chant.")
  UI:WaitShowDialogue("Nous verrons bien si elles parviennent à apaiser le roi de la jungle !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Mareep_ExpeditionBivouacTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les récits de votre bivouac au Mont Venteux sont incroyables...", "Normal")
  UI:WaitShowDialogue("Dormir sous les étoiles, à l'écoute du chant mystique de la montagne...")
  UI:WaitShowDialogue("C'est le genre d'expérience qui forge l'âme d'un véritable aventurier.")
  UI:WaitShowDialogue("Toute la ville est fière de voir votre équipe progresser si vite !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Cranidos_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est une magnifique journée d'histoire.", "Normal")
  UI:WaitShowDialogue("Le Chapitre 6 est plein d'aventures et de rumeurs mystérieuses dans la Forêt Lugubre.")
  UI:WaitShowDialogue("Certains disent avoir vu une ombre gigantesque courir à travers les lianes...")
  UI:WaitShowDialogue("...Serait-ce le terrible Zeraora ? Personne n'ose s'en approcher de trop près.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Forêt Lugubre", "La Team Dazzling", "L'expédition", "Rien"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Forêt Lugubre est située juste au nord du village. L'air y est très lourd.")
    UI:WaitShowDialogue("On raconte que les arbres bougent tout seuls et que les lianes emprisonnent les intrus.")
    UI:WaitShowDialogue("Si vous y entrez, restez sur vos gardes. Ne laissez jamais votre partenaire seul.")
    UI:WaitShowDialogue("Et surtout... méfiez-vous du cri de la jungle. Il annonce la colère de son roi.")
    UI:WaitShowDialogue("Je crois que même la guilde n'a pas encore cartographié tout le donjon.")
    UI:WaitShowDialogue("Mais avec votre courage, je sais que vous pourrez y arriver et sauver le petit !")
  elseif choice == 2 then
    UI:WaitShowDialogue("La Team Dazzling... Elles sont arrivées de la côte il y a quelques jours seulement.")
    UI:WaitShowDialogue("Adagio est si polie mais on sent toute sa supériorité dans ses paroles.")
    UI:WaitShowDialogue("Aria est très provocatrice, elle passe son temps à sauter de joie et à se moquer.")
    UI:WaitShowDialogue("Et Sonata... elle est tellement théâtrale avec ses mimiques et ses colères !")
    UI:WaitShowDialogue("Elles se croient déjà au sommet, prétendant que ce sauvetage n'est qu'un jeu pour elles.")
    UI:WaitShowDialogue("Ne les laissez pas vous intimider. Montrez-leur de quel bois vous vous chauffez !")
    UI:WaitShowDialogue("Toute la ville attend de voir qui ramènera le Chenipent en premier.")
  elseif choice == 3 then
    UI:WaitShowDialogue("L'expédition du Mont Venteux... C'était une aventure extraordinaire.")
    UI:WaitShowDialogue("Vous avez gravi les sommets, traversé les tempêtes et affronté le Seigneur des Vents.")
    UI:WaitShowDialogue("Le doyen Penticus m'a dit que votre exploit résonnera longtemps à la guilde.")
    UI:WaitShowDialogue("Mais ce n'était que le début de l'histoire, je le ressens au fond de mes os.")
    UI:WaitShowDialogue("Les flux d'énergie continuent de s'agiter sous la terre, de plus en plus chauds.")
    UI:WaitShowDialogue("Restez forts, mes amis. Le monde a plus que jamais besoin de héros.")
  else
    UI:WaitShowDialogue("D'accord. Prenez soin de vous sur les sentiers et dans les donjons.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Cranidos_GossipTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Oh, vous revoilà ! J'ai encore entendu d'étranges rumeurs...", "Normal")
  UI:WaitShowDialogue("On dit que la Team Dazzling n'est pas là pour faire du secours, mais pour un secret...")
  UI:WaitShowDialogue("Elles fouillent les recoins du village et de la guilde, murmurant entre elles.")
  UI:WaitShowDialogue("Même les marchands du marché les trouvent suspectes, malgré leur éclat.")
  UI:WaitShowDialogue("Qu'en pensez-vous ? Pensez-vous qu'elles complotent quelque chose de louche ?")
  UI:BeginChoiceMenu("Que lui dites-vous ?", {"Elles complotent", "Elles sont juste fières", "Je ne sais pas"}, 1, 3)
  UI:WaitForChoice()
  local result = UI:ChoiceResult()
  if result == 1 then
    UI:WaitShowDialogue("Je le savais ! Leurs mines mystérieuses et leurs messes basses ne trompent personne.")
    UI:WaitShowDialogue("Même le Doyen Penticus les surveille du coin de l'œil, je l'ai vu hier.")
    UI:WaitShowDialogue("Faites bien attention si vous les croisez dans la Forêt Lugubre.")
  elseif result == 2 then
    UI:WaitShowDialogue("C'est possible. Les équipes de la côte ont toujours cette fierté un peu agaçante.")
    UI:WaitShowDialogue("Après tout, elles ont une grande réputation à tenir, mais quand même...")
    UI:WaitShowDialogue("Ne relâchez pas votre attention pour autant. On ne sait jamais.")
  else
    UI:WaitShowDialogue("La prudence est mère de sûreté, comme on dit toujours à la guilde.")
    UI:WaitShowDialogue("Nous verrons bien ce que l'avenir nous réserve. Restons concentrés.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Cranidos_RaidTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous entendu les rumeurs sur les pilleurs nocturnes ?", "Worried")
  UI:WaitShowDialogue("On dit que des spectres rodent dans les ombres de la ville dès que la nuit tombe...")
  UI:WaitShowDialogue("Ils forcent les coffres, pillent les stands et s'enfuient sans laisser de traces.")
  UI:WaitShowDialogue("La place entière retient son souffle dès que le soleil se couche.")
  UI:WaitShowDialogue("Si vous veillez de nuit, soyez extrêmement prudents. Ils sont redoutables.")
  UI:WaitShowDialogue("Mais je sais que votre équipe a le courage de défendre notre ville de Metano !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Cranidos_PrepTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avant de repartir en mission, assurez-vous d'être bien préparés !", "Normal")
  UI:WaitShowDialogue("La Forêt Lugubre ne pardonne pas le manque d'organisation.")
  UI:WaitShowDialogue("Prenez toujours des Baies Oran, des Baies Ceriz et des Échapporbes en cas de besoin.")
  UI:WaitShowDialogue("L'entrepôt de la guilde est là pour stocker vos trésors précieux.")
  UI:WaitShowDialogue("Même l'équipe la plus forte peut faillir sans un bon équipement.")
  UI:WaitShowDialogue("Faites-moi confiance, la préparation est la clé de toute grande aventure !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Cranidos_RelaxTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'ambiance au café est si relaxante en ce moment...", "Normal")
  UI:WaitShowDialogue("C'est l'endroit idéal pour faire une pause et discuter avec les autres.")
  UI:WaitShowDialogue("Après une longue journée dans les donjons, rien ne vaut une bonne boisson chaude.")
  UI:WaitShowDialogue("Même les rumeurs les plus folles se partagent ici autour d'une table.")
  UI:WaitShowDialogue("Prenez le temps de souffler un peu avant de retourner affronter la jungle.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Cranidos_DazzlingChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, que pensez-vous de chaque membre des Dazzling ?", "Normal")
  UI:BeginChoiceMenu("Qui souhaitez-vous évaluer ?", {"Adagio", "Aria", "Sonata", "Toutes"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Adagio est d'une élégance rare, mais ses yeux brillent d'une ambition froide.")
  elseif res == 2 then
    UI:WaitShowDialogue("Aria ne fait que s'exciter et provoquer tout le monde. C'est insupportable.")
  elseif res == 3 then
    UI:WaitShowDialogue("Sonata est tellement théâtrale ! Ses grands gestes amusent la galerie.")
  else
    UI:WaitShowDialogue("Elles forment un groupe redoutable. Ne sous-estimez jamais leur union.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Cranidos_ExpeditionChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "L'expédition reste le plus grand événement de l'année !", "Normal")
  UI:WaitShowDialogue("Chacun de nous en garde un souvenir marquant et impérissable.")
  UI:WaitShowDialogue("Pour certains, c'était la première fois qu'ils voyaient de si grandes montagnes.")
  UI:WaitShowDialogue("Et pour vous, quel reste le plus beau souvenir de cette ascension ?")
  UI:BeginChoiceMenu("Votre moment favori :", {"Le feu de camp", "La tempête", "Le sommet"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Le feu de camp était si convivial, à partager des rumeurs au milieu de la nuit !")
  elseif res == 2 then
    UI:WaitShowDialogue("La tempête était terrifiante, mais elle a montré toute la force de notre guilde !")
  else
    UI:WaitShowDialogue("Le sommet Venteux était d'une majesté absolue. On y touchait le ciel !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Cranidos_StoryDazzlingTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La Team Dazzling fait sensation à Metano Town...", "Normal")
  UI:WaitShowDialogue("Leurs voix magiques s'entendent jusqu'aux confins de la forêt.")
  UI:WaitShowDialogue("On dit qu'elles préparent un grand spectacle pour fêter leur prochaine victoire.")
  UI:WaitShowDialogue("Mais certains érudits pensent qu'il y a une magie ancienne derrière leur chant.")
  UI:WaitShowDialogue("Nous verrons bien si elles parviennent à apaiser le roi de la jungle !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Cranidos_ExpeditionBivouacTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les récits de votre bivouac au Mont Venteux sont incroyables...", "Normal")
  UI:WaitShowDialogue("Dormir sous les étoiles, à l'écoute du chant mystique de la montagne...")
  UI:WaitShowDialogue("C'est le genre d'expérience qui forge l'âme d'un véritable aventurier.")
  UI:WaitShowDialogue("Toute la ville est fière de voir votre équipe progresser si vite !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Growlithe_Desk_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est une magnifique journée d'histoire.", "Normal")
  UI:WaitShowDialogue("Le Chapitre 6 est plein d'aventures et de rumeurs mystérieuses dans la Forêt Lugubre.")
  UI:WaitShowDialogue("Certains disent avoir vu une ombre gigantesque courir à travers les lianes...")
  UI:WaitShowDialogue("...Serait-ce le terrible Zeraora ? Personne n'ose s'en approcher de trop près.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Forêt Lugubre", "La Team Dazzling", "L'expédition", "Rien"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Forêt Lugubre est située juste au nord du village. L'air y est très lourd.")
    UI:WaitShowDialogue("On raconte que les arbres bougent tout seuls et que les lianes emprisonnent les intrus.")
    UI:WaitShowDialogue("Si vous y entrez, restez sur vos gardes. Ne laissez jamais votre partenaire seul.")
    UI:WaitShowDialogue("Et surtout... méfiez-vous du cri de la jungle. Il annonce la colère de son roi.")
    UI:WaitShowDialogue("Je crois que même la guilde n'a pas encore cartographié tout le donjon.")
    UI:WaitShowDialogue("Mais avec votre courage, je sais que vous pourrez y arriver et sauver le petit !")
  elseif choice == 2 then
    UI:WaitShowDialogue("La Team Dazzling... Elles sont arrivées de la côte il y a quelques jours seulement.")
    UI:WaitShowDialogue("Adagio est si polie mais on sent toute sa supériorité dans ses paroles.")
    UI:WaitShowDialogue("Aria est très provocatrice, elle passe son temps à sauter de joie et à se moquer.")
    UI:WaitShowDialogue("Et Sonata... elle est tellement théâtrale avec ses mimiques et ses colères !")
    UI:WaitShowDialogue("Elles se croient déjà au sommet, prétendant que ce sauvetage n'est qu'un jeu pour elles.")
    UI:WaitShowDialogue("Ne les laissez pas vous intimider. Montrez-leur de quel bois vous vous chauffez !")
    UI:WaitShowDialogue("Toute la ville attend de voir qui ramènera le Chenipent en premier.")
  elseif choice == 3 then
    UI:WaitShowDialogue("L'expédition du Mont Venteux... C'était une aventure extraordinaire.")
    UI:WaitShowDialogue("Vous avez gravi les sommets, traversé les tempêtes et affronté le Seigneur des Vents.")
    UI:WaitShowDialogue("Le doyen Penticus m'a dit que votre exploit résonnera longtemps à la guilde.")
    UI:WaitShowDialogue("Mais ce n'était que le début de l'histoire, je le ressens au fond de mes os.")
    UI:WaitShowDialogue("Les flux d'énergie continuent de s'agiter sous la terre, de plus en plus chauds.")
    UI:WaitShowDialogue("Restez forts, mes amis. Le monde a plus que jamais besoin de héros.")
  else
    UI:WaitShowDialogue("D'accord. Prenez soin de vous sur les sentiers et dans les donjons.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Growlithe_Desk_GossipTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Oh, vous revoilà ! J'ai encore entendu d'étranges rumeurs...", "Normal")
  UI:WaitShowDialogue("On dit que la Team Dazzling n'est pas là pour faire du secours, mais pour un secret...")
  UI:WaitShowDialogue("Elles fouillent les recoins du village et de la guilde, murmurant entre elles.")
  UI:WaitShowDialogue("Même les marchands du marché les trouvent suspectes, malgré leur éclat.")
  UI:WaitShowDialogue("Qu'en pensez-vous ? Pensez-vous qu'elles complotent quelque chose de louche ?")
  UI:BeginChoiceMenu("Que lui dites-vous ?", {"Elles complotent", "Elles sont juste fières", "Je ne sais pas"}, 1, 3)
  UI:WaitForChoice()
  local result = UI:ChoiceResult()
  if result == 1 then
    UI:WaitShowDialogue("Je le savais ! Leurs mines mystérieuses et leurs messes basses ne trompent personne.")
    UI:WaitShowDialogue("Même le Doyen Penticus les surveille du coin de l'œil, je l'ai vu hier.")
    UI:WaitShowDialogue("Faites bien attention si vous les croisez dans la Forêt Lugubre.")
  elseif result == 2 then
    UI:WaitShowDialogue("C'est possible. Les équipes de la côte ont toujours cette fierté un peu agaçante.")
    UI:WaitShowDialogue("Après tout, elles ont une grande réputation à tenir, mais quand même...")
    UI:WaitShowDialogue("Ne relâchez pas votre attention pour autant. On ne sait jamais.")
  else
    UI:WaitShowDialogue("La prudence est mère de sûreté, comme on dit toujours à la guilde.")
    UI:WaitShowDialogue("Nous verrons bien ce que l'avenir nous réserve. Restons concentrés.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Growlithe_Desk_RaidTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous entendu les rumeurs sur les pilleurs nocturnes ?", "Worried")
  UI:WaitShowDialogue("On dit que des spectres rodent dans les ombres de la ville dès que la nuit tombe...")
  UI:WaitShowDialogue("Ils forcent les coffres, pillent les stands et s'enfuient sans laisser de traces.")
  UI:WaitShowDialogue("La place entière retient son souffle dès que le soleil se couche.")
  UI:WaitShowDialogue("Si vous veillez de nuit, soyez extrêmement prudents. Ils sont redoutables.")
  UI:WaitShowDialogue("Mais je sais que votre équipe a le courage de défendre notre ville de Metano !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Growlithe_Desk_PrepTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avant de repartir en mission, assurez-vous d'être bien préparés !", "Normal")
  UI:WaitShowDialogue("La Forêt Lugubre ne pardonne pas le manque d'organisation.")
  UI:WaitShowDialogue("Prenez toujours des Baies Oran, des Baies Ceriz et des Échapporbes en cas de besoin.")
  UI:WaitShowDialogue("L'entrepôt de la guilde est là pour stocker vos trésors précieux.")
  UI:WaitShowDialogue("Même l'équipe la plus forte peut faillir sans un bon équipement.")
  UI:WaitShowDialogue("Faites-moi confiance, la préparation est la clé de toute grande aventure !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Growlithe_Desk_RelaxTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'ambiance au café est si relaxante en ce moment...", "Normal")
  UI:WaitShowDialogue("C'est l'endroit idéal pour faire une pause et discuter avec les autres.")
  UI:WaitShowDialogue("Après une longue journée dans les donjons, rien ne vaut une bonne boisson chaude.")
  UI:WaitShowDialogue("Même les rumeurs les plus folles se partagent ici autour d'une table.")
  UI:WaitShowDialogue("Prenez le temps de souffler un peu avant de retourner affronter la jungle.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Growlithe_Desk_DazzlingChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, que pensez-vous de chaque membre des Dazzling ?", "Normal")
  UI:BeginChoiceMenu("Qui souhaitez-vous évaluer ?", {"Adagio", "Aria", "Sonata", "Toutes"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Adagio est d'une élégance rare, mais ses yeux brillent d'une ambition froide.")
  elseif res == 2 then
    UI:WaitShowDialogue("Aria ne fait que s'exciter et provoquer tout le monde. C'est insupportable.")
  elseif res == 3 then
    UI:WaitShowDialogue("Sonata est tellement théâtrale ! Ses grands gestes amusent la galerie.")
  else
    UI:WaitShowDialogue("Elles forment un groupe redoutable. Ne sous-estimez jamais leur union.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Growlithe_Desk_ExpeditionChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "L'expédition reste le plus grand événement de l'année !", "Normal")
  UI:WaitShowDialogue("Chacun de nous en garde un souvenir marquant et impérissable.")
  UI:WaitShowDialogue("Pour certains, c'était la première fois qu'ils voyaient de si grandes montagnes.")
  UI:WaitShowDialogue("Et pour vous, quel reste le plus beau souvenir de cette ascension ?")
  UI:BeginChoiceMenu("Votre moment favori :", {"Le feu de camp", "La tempête", "Le sommet"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Le feu de camp était si convivial, à partager des rumeurs au milieu de la nuit !")
  elseif res == 2 then
    UI:WaitShowDialogue("La tempête était terrifiante, mais elle a montré toute la force de notre guilde !")
  else
    UI:WaitShowDialogue("Le sommet Venteux était d'une majesté absolue. On y touchait le ciel !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Growlithe_Desk_StoryDazzlingTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La Team Dazzling fait sensation à Metano Town...", "Normal")
  UI:WaitShowDialogue("Leurs voix magiques s'entendent jusqu'aux confins de la forêt.")
  UI:WaitShowDialogue("On dit qu'elles préparent un grand spectacle pour fêter leur prochaine victoire.")
  UI:WaitShowDialogue("Mais certains érudits pensent qu'il y a une magie ancienne derrière leur chant.")
  UI:WaitShowDialogue("Nous verrons bien si elles parviennent à apaiser le roi de la jungle !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Growlithe_Desk_ExpeditionBivouacTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les récits de votre bivouac au Mont Venteux sont incroyables...", "Normal")
  UI:WaitShowDialogue("Dormir sous les étoiles, à l'écoute du chant mystique de la montagne...")
  UI:WaitShowDialogue("C'est le genre d'expérience qui forge l'âme d'un véritable aventurier.")
  UI:WaitShowDialogue("Toute la ville est fière de voir votre équipe progresser si vite !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Butterfree_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est une magnifique journée d'histoire.", "Normal")
  UI:WaitShowDialogue("Le Chapitre 6 est plein d'aventures et de rumeurs mystérieuses dans la Forêt Lugubre.")
  UI:WaitShowDialogue("Certains disent avoir vu une ombre gigantesque courir à travers les lianes...")
  UI:WaitShowDialogue("...Serait-ce le terrible Zeraora ? Personne n'ose s'en approcher de trop près.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Forêt Lugubre", "La Team Dazzling", "L'expédition", "Rien"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Forêt Lugubre est située juste au nord du village. L'air y est très lourd.")
    UI:WaitShowDialogue("On raconte que les arbres bougent tout seuls et que les lianes emprisonnent les intrus.")
    UI:WaitShowDialogue("Si vous y entrez, restez sur vos gardes. Ne laissez jamais votre partenaire seul.")
    UI:WaitShowDialogue("Et surtout... méfiez-vous du cri de la jungle. Il annonce la colère de son roi.")
    UI:WaitShowDialogue("Je crois que même la guilde n'a pas encore cartographié tout le donjon.")
    UI:WaitShowDialogue("Mais avec votre courage, je sais que vous pourrez y arriver et sauver le petit !")
  elseif choice == 2 then
    UI:WaitShowDialogue("La Team Dazzling... Elles sont arrivées de la côte il y a quelques jours seulement.")
    UI:WaitShowDialogue("Adagio est si polie mais on sent toute sa supériorité dans ses paroles.")
    UI:WaitShowDialogue("Aria est très provocatrice, elle passe son temps à sauter de joie et à se moquer.")
    UI:WaitShowDialogue("Et Sonata... elle est tellement théâtrale avec ses mimiques et ses colères !")
    UI:WaitShowDialogue("Elles se croient déjà au sommet, prétendant que ce sauvetage n'est qu'un jeu pour elles.")
    UI:WaitShowDialogue("Ne les laissez pas vous intimider. Montrez-leur de quel bois vous vous chauffez !")
    UI:WaitShowDialogue("Toute la ville attend de voir qui ramènera le Chenipent en premier.")
  elseif choice == 3 then
    UI:WaitShowDialogue("L'expédition du Mont Venteux... C'était une aventure extraordinaire.")
    UI:WaitShowDialogue("Vous avez gravi les sommets, traversé les tempêtes et affronté le Seigneur des Vents.")
    UI:WaitShowDialogue("Le doyen Penticus m'a dit que votre exploit résonnera longtemps à la guilde.")
    UI:WaitShowDialogue("Mais ce n'était que le début de l'histoire, je le ressens au fond de mes os.")
    UI:WaitShowDialogue("Les flux d'énergie continuent de s'agiter sous la terre, de plus en plus chauds.")
    UI:WaitShowDialogue("Restez forts, mes amis. Le monde a plus que jamais besoin de héros.")
  else
    UI:WaitShowDialogue("D'accord. Prenez soin de vous sur les sentiers et dans les donjons.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Butterfree_GossipTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Oh, vous revoilà ! J'ai encore entendu d'étranges rumeurs...", "Normal")
  UI:WaitShowDialogue("On dit que la Team Dazzling n'est pas là pour faire du secours, mais pour un secret...")
  UI:WaitShowDialogue("Elles fouillent les recoins du village et de la guilde, murmurant entre elles.")
  UI:WaitShowDialogue("Même les marchands du marché les trouvent suspectes, malgré leur éclat.")
  UI:WaitShowDialogue("Qu'en pensez-vous ? Pensez-vous qu'elles complotent quelque chose de louche ?")
  UI:BeginChoiceMenu("Que lui dites-vous ?", {"Elles complotent", "Elles sont juste fières", "Je ne sais pas"}, 1, 3)
  UI:WaitForChoice()
  local result = UI:ChoiceResult()
  if result == 1 then
    UI:WaitShowDialogue("Je le savais ! Leurs mines mystérieuses et leurs messes basses ne trompent personne.")
    UI:WaitShowDialogue("Même le Doyen Penticus les surveille du coin de l'œil, je l'ai vu hier.")
    UI:WaitShowDialogue("Faites bien attention si vous les croisez dans la Forêt Lugubre.")
  elseif result == 2 then
    UI:WaitShowDialogue("C'est possible. Les équipes de la côte ont toujours cette fierté un peu agaçante.")
    UI:WaitShowDialogue("Après tout, elles ont une grande réputation à tenir, mais quand même...")
    UI:WaitShowDialogue("Ne relâchez pas votre attention pour autant. On ne sait jamais.")
  else
    UI:WaitShowDialogue("La prudence est mère de sûreté, comme on dit toujours à la guilde.")
    UI:WaitShowDialogue("Nous verrons bien ce que l'avenir nous réserve. Restons concentrés.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Butterfree_RaidTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous entendu les rumeurs sur les pilleurs nocturnes ?", "Worried")
  UI:WaitShowDialogue("On dit que des spectres rodent dans les ombres de la ville dès que la nuit tombe...")
  UI:WaitShowDialogue("Ils forcent les coffres, pillent les stands et s'enfuient sans laisser de traces.")
  UI:WaitShowDialogue("La place entière retient son souffle dès que le soleil se couche.")
  UI:WaitShowDialogue("Si vous veillez de nuit, soyez extrêmement prudents. Ils sont redoutables.")
  UI:WaitShowDialogue("Mais je sais que votre équipe a le courage de défendre notre ville de Metano !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Butterfree_PrepTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avant de repartir en mission, assurez-vous d'être bien préparés !", "Normal")
  UI:WaitShowDialogue("La Forêt Lugubre ne pardonne pas le manque d'organisation.")
  UI:WaitShowDialogue("Prenez toujours des Baies Oran, des Baies Ceriz et des Échapporbes en cas de besoin.")
  UI:WaitShowDialogue("L'entrepôt de la guilde est là pour stocker vos trésors précieux.")
  UI:WaitShowDialogue("Même l'équipe la plus forte peut faillir sans un bon équipement.")
  UI:WaitShowDialogue("Faites-moi confiance, la préparation est la clé de toute grande aventure !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Butterfree_RelaxTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'ambiance au café est si relaxante en ce moment...", "Normal")
  UI:WaitShowDialogue("C'est l'endroit idéal pour faire une pause et discuter avec les autres.")
  UI:WaitShowDialogue("Après une longue journée dans les donjons, rien ne vaut une bonne boisson chaude.")
  UI:WaitShowDialogue("Même les rumeurs les plus folles se partagent ici autour d'une table.")
  UI:WaitShowDialogue("Prenez le temps de souffler un peu avant de retourner affronter la jungle.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Butterfree_DazzlingChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, que pensez-vous de chaque membre des Dazzling ?", "Normal")
  UI:BeginChoiceMenu("Qui souhaitez-vous évaluer ?", {"Adagio", "Aria", "Sonata", "Toutes"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Adagio est d'une élégance rare, mais ses yeux brillent d'une ambition froide.")
  elseif res == 2 then
    UI:WaitShowDialogue("Aria ne fait que s'exciter et provoquer tout le monde. C'est insupportable.")
  elseif res == 3 then
    UI:WaitShowDialogue("Sonata est tellement théâtrale ! Ses grands gestes amusent la galerie.")
  else
    UI:WaitShowDialogue("Elles forment un groupe redoutable. Ne sous-estimez jamais leur union.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Butterfree_ExpeditionChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "L'expédition reste le plus grand événement de l'année !", "Normal")
  UI:WaitShowDialogue("Chacun de nous en garde un souvenir marquant et impérissable.")
  UI:WaitShowDialogue("Pour certains, c'était la première fois qu'ils voyaient de si grandes montagnes.")
  UI:WaitShowDialogue("Et pour vous, quel reste le plus beau souvenir de cette ascension ?")
  UI:BeginChoiceMenu("Votre moment favori :", {"Le feu de camp", "La tempête", "Le sommet"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Le feu de camp était si convivial, à partager des rumeurs au milieu de la nuit !")
  elseif res == 2 then
    UI:WaitShowDialogue("La tempête était terrifiante, mais elle a montré toute la force de notre guilde !")
  else
    UI:WaitShowDialogue("Le sommet Venteux était d'une majesté absolue. On y touchait le ciel !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Butterfree_StoryDazzlingTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La Team Dazzling fait sensation à Metano Town...", "Normal")
  UI:WaitShowDialogue("Leurs voix magiques s'entendent jusqu'aux confins de la forêt.")
  UI:WaitShowDialogue("On dit qu'elles préparent un grand spectacle pour fêter leur prochaine victoire.")
  UI:WaitShowDialogue("Mais certains érudits pensent qu'il y a une magie ancienne derrière leur chant.")
  UI:WaitShowDialogue("Nous verrons bien si elles parviennent à apaiser le roi de la jungle !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Butterfree_ExpeditionBivouacTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les récits de votre bivouac au Mont Venteux sont incroyables...", "Normal")
  UI:WaitShowDialogue("Dormir sous les étoiles, à l'écoute du chant mystique de la montagne...")
  UI:WaitShowDialogue("C'est le genre d'expérience qui forge l'âme d'un véritable aventurier.")
  UI:WaitShowDialogue("Toute la ville est fière de voir votre équipe progresser si vite !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Venipede_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est une magnifique journée d'histoire.", "Normal")
  UI:WaitShowDialogue("Le Chapitre 6 est plein d'aventures et de rumeurs mystérieuses dans la Forêt Lugubre.")
  UI:WaitShowDialogue("Certains disent avoir vu une ombre gigantesque courir à travers les lianes...")
  UI:WaitShowDialogue("...Serait-ce le terrible Zeraora ? Personne n'ose s'en approcher de trop près.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Forêt Lugubre", "La Team Dazzling", "L'expédition", "Rien"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Forêt Lugubre est située juste au nord du village. L'air y est très lourd.")
    UI:WaitShowDialogue("On raconte que les arbres bougent tout seuls et que les lianes emprisonnent les intrus.")
    UI:WaitShowDialogue("Si vous y entrez, restez sur vos gardes. Ne laissez jamais votre partenaire seul.")
    UI:WaitShowDialogue("Et surtout... méfiez-vous du cri de la jungle. Il annonce la colère de son roi.")
    UI:WaitShowDialogue("Je crois que même la guilde n'a pas encore cartographié tout le donjon.")
    UI:WaitShowDialogue("Mais avec votre courage, je sais que vous pourrez y arriver et sauver le petit !")
  elseif choice == 2 then
    UI:WaitShowDialogue("La Team Dazzling... Elles sont arrivées de la côte il y a quelques jours seulement.")
    UI:WaitShowDialogue("Adagio est si polie mais on sent toute sa supériorité dans ses paroles.")
    UI:WaitShowDialogue("Aria est très provocatrice, elle passe son temps à sauter de joie et à se moquer.")
    UI:WaitShowDialogue("Et Sonata... elle est tellement théâtrale avec ses mimiques et ses colères !")
    UI:WaitShowDialogue("Elles se croient déjà au sommet, prétendant que ce sauvetage n'est qu'un jeu pour elles.")
    UI:WaitShowDialogue("Ne les laissez pas vous intimider. Montrez-leur de quel bois vous vous chauffez !")
    UI:WaitShowDialogue("Toute la ville attend de voir qui ramènera le Chenipent en premier.")
  elseif choice == 3 then
    UI:WaitShowDialogue("L'expédition du Mont Venteux... C'était une aventure extraordinaire.")
    UI:WaitShowDialogue("Vous avez gravi les sommets, traversé les tempêtes et affronté le Seigneur des Vents.")
    UI:WaitShowDialogue("Le doyen Penticus m'a dit que votre exploit résonnera longtemps à la guilde.")
    UI:WaitShowDialogue("Mais ce n'était que le début de l'histoire, je le ressens au fond de mes os.")
    UI:WaitShowDialogue("Les flux d'énergie continuent de s'agiter sous la terre, de plus en plus chauds.")
    UI:WaitShowDialogue("Restez forts, mes amis. Le monde a plus que jamais besoin de héros.")
  else
    UI:WaitShowDialogue("D'accord. Prenez soin de vous sur les sentiers et dans les donjons.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Venipede_GossipTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Oh, vous revoilà ! J'ai encore entendu d'étranges rumeurs...", "Normal")
  UI:WaitShowDialogue("On dit que la Team Dazzling n'est pas là pour faire du secours, mais pour un secret...")
  UI:WaitShowDialogue("Elles fouillent les recoins du village et de la guilde, murmurant entre elles.")
  UI:WaitShowDialogue("Même les marchands du marché les trouvent suspectes, malgré leur éclat.")
  UI:WaitShowDialogue("Qu'en pensez-vous ? Pensez-vous qu'elles complotent quelque chose de louche ?")
  UI:BeginChoiceMenu("Que lui dites-vous ?", {"Elles complotent", "Elles sont juste fières", "Je ne sais pas"}, 1, 3)
  UI:WaitForChoice()
  local result = UI:ChoiceResult()
  if result == 1 then
    UI:WaitShowDialogue("Je le savais ! Leurs mines mystérieuses et leurs messes basses ne trompent personne.")
    UI:WaitShowDialogue("Même le Doyen Penticus les surveille du coin de l'œil, je l'ai vu hier.")
    UI:WaitShowDialogue("Faites bien attention si vous les croisez dans la Forêt Lugubre.")
  elseif result == 2 then
    UI:WaitShowDialogue("C'est possible. Les équipes de la côte ont toujours cette fierté un peu agaçante.")
    UI:WaitShowDialogue("Après tout, elles ont une grande réputation à tenir, mais quand même...")
    UI:WaitShowDialogue("Ne relâchez pas votre attention pour autant. On ne sait jamais.")
  else
    UI:WaitShowDialogue("La prudence est mère de sûreté, comme on dit toujours à la guilde.")
    UI:WaitShowDialogue("Nous verrons bien ce que l'avenir nous réserve. Restons concentrés.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Venipede_RaidTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous entendu les rumeurs sur les pilleurs nocturnes ?", "Worried")
  UI:WaitShowDialogue("On dit que des spectres rodent dans les ombres de la ville dès que la nuit tombe...")
  UI:WaitShowDialogue("Ils forcent les coffres, pillent les stands et s'enfuient sans laisser de traces.")
  UI:WaitShowDialogue("La place entière retient son souffle dès que le soleil se couche.")
  UI:WaitShowDialogue("Si vous veillez de nuit, soyez extrêmement prudents. Ils sont redoutables.")
  UI:WaitShowDialogue("Mais je sais que votre équipe a le courage de défendre notre ville de Metano !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Venipede_PrepTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avant de repartir en mission, assurez-vous d'être bien préparés !", "Normal")
  UI:WaitShowDialogue("La Forêt Lugubre ne pardonne pas le manque d'organisation.")
  UI:WaitShowDialogue("Prenez toujours des Baies Oran, des Baies Ceriz et des Échapporbes en cas de besoin.")
  UI:WaitShowDialogue("L'entrepôt de la guilde est là pour stocker vos trésors précieux.")
  UI:WaitShowDialogue("Même l'équipe la plus forte peut faillir sans un bon équipement.")
  UI:WaitShowDialogue("Faites-moi confiance, la préparation est la clé de toute grande aventure !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Venipede_RelaxTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'ambiance au café est si relaxante en ce moment...", "Normal")
  UI:WaitShowDialogue("C'est l'endroit idéal pour faire une pause et discuter avec les autres.")
  UI:WaitShowDialogue("Après une longue journée dans les donjons, rien ne vaut une bonne boisson chaude.")
  UI:WaitShowDialogue("Même les rumeurs les plus folles se partagent ici autour d'une table.")
  UI:WaitShowDialogue("Prenez le temps de souffler un peu avant de retourner affronter la jungle.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Venipede_DazzlingChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, que pensez-vous de chaque membre des Dazzling ?", "Normal")
  UI:BeginChoiceMenu("Qui souhaitez-vous évaluer ?", {"Adagio", "Aria", "Sonata", "Toutes"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Adagio est d'une élégance rare, mais ses yeux brillent d'une ambition froide.")
  elseif res == 2 then
    UI:WaitShowDialogue("Aria ne fait que s'exciter et provoquer tout le monde. C'est insupportable.")
  elseif res == 3 then
    UI:WaitShowDialogue("Sonata est tellement théâtrale ! Ses grands gestes amusent la galerie.")
  else
    UI:WaitShowDialogue("Elles forment un groupe redoutable. Ne sous-estimez jamais leur union.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Venipede_ExpeditionChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "L'expédition reste le plus grand événement de l'année !", "Normal")
  UI:WaitShowDialogue("Chacun de nous en garde un souvenir marquant et impérissable.")
  UI:WaitShowDialogue("Pour certains, c'était la première fois qu'ils voyaient de si grandes montagnes.")
  UI:WaitShowDialogue("Et pour vous, quel reste le plus beau souvenir de cette ascension ?")
  UI:BeginChoiceMenu("Votre moment favori :", {"Le feu de camp", "La tempête", "Le sommet"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Le feu de camp était si convivial, à partager des rumeurs au milieu de la nuit !")
  elseif res == 2 then
    UI:WaitShowDialogue("La tempête était terrifiante, mais elle a montré toute la force de notre guilde !")
  else
    UI:WaitShowDialogue("Le sommet Venteux était d'une majesté absolue. On y touchait le ciel !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Venipede_StoryDazzlingTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La Team Dazzling fait sensation à Metano Town...", "Normal")
  UI:WaitShowDialogue("Leurs voix magiques s'entendent jusqu'aux confins de la forêt.")
  UI:WaitShowDialogue("On dit qu'elles préparent un grand spectacle pour fêter leur prochaine victoire.")
  UI:WaitShowDialogue("Mais certains érudits pensent qu'il y a une magie ancienne derrière leur chant.")
  UI:WaitShowDialogue("Nous verrons bien si elles parviennent à apaiser le roi de la jungle !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Venipede_ExpeditionBivouacTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les récits de votre bivouac au Mont Venteux sont incroyables...", "Normal")
  UI:WaitShowDialogue("Dormir sous les étoiles, à l'écoute du chant mystique de la montagne...")
  UI:WaitShowDialogue("C'est le genre d'expérience qui forge l'âme d'un véritable aventurier.")
  UI:WaitShowDialogue("Toute la ville est fière de voir votre équipe progresser si vite !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Adagio_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est une magnifique journée d'histoire.", "Normal")
  UI:WaitShowDialogue("Le Chapitre 6 est plein d'aventures et de rumeurs mystérieuses dans la Forêt Lugubre.")
  UI:WaitShowDialogue("Certains disent avoir vu une ombre gigantesque courir à travers les lianes...")
  UI:WaitShowDialogue("...Serait-ce le terrible Zeraora ? Personne n'ose s'en approcher de trop près.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Forêt Lugubre", "La Team Dazzling", "L'expédition", "Rien"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Forêt Lugubre est située juste au nord du village. L'air y est très lourd.")
    UI:WaitShowDialogue("On raconte que les arbres bougent tout seuls et que les lianes emprisonnent les intrus.")
    UI:WaitShowDialogue("Si vous y entrez, restez sur vos gardes. Ne laissez jamais votre partenaire seul.")
    UI:WaitShowDialogue("Et surtout... méfiez-vous du cri de la jungle. Il annonce la colère de son roi.")
    UI:WaitShowDialogue("Je crois que même la guilde n'a pas encore cartographié tout le donjon.")
    UI:WaitShowDialogue("Mais avec votre courage, je sais que vous pourrez y arriver et sauver le petit !")
  elseif choice == 2 then
    UI:WaitShowDialogue("La Team Dazzling... Elles sont arrivées de la côte il y a quelques jours seulement.")
    UI:WaitShowDialogue("Adagio est si polie mais on sent toute sa supériorité dans ses paroles.")
    UI:WaitShowDialogue("Aria est très provocatrice, elle passe son temps à sauter de joie et à se moquer.")
    UI:WaitShowDialogue("Et Sonata... elle est tellement théâtrale avec ses mimiques et ses colères !")
    UI:WaitShowDialogue("Elles se croient déjà au sommet, prétendant que ce sauvetage n'est qu'un jeu pour elles.")
    UI:WaitShowDialogue("Ne les laissez pas vous intimider. Montrez-leur de quel bois vous vous chauffez !")
    UI:WaitShowDialogue("Toute la ville attend de voir qui ramènera le Chenipent en premier.")
  elseif choice == 3 then
    UI:WaitShowDialogue("L'expédition du Mont Venteux... C'était une aventure extraordinaire.")
    UI:WaitShowDialogue("Vous avez gravi les sommets, traversé les tempêtes et affronté le Seigneur des Vents.")
    UI:WaitShowDialogue("Le doyen Penticus m'a dit que votre exploit résonnera longtemps à la guilde.")
    UI:WaitShowDialogue("Mais ce n'était que le début de l'histoire, je le ressens au fond de mes os.")
    UI:WaitShowDialogue("Les flux d'énergie continuent de s'agiter sous la terre, de plus en plus chauds.")
    UI:WaitShowDialogue("Restez forts, mes amis. Le monde a plus que jamais besoin de héros.")
  else
    UI:WaitShowDialogue("D'accord. Prenez soin de vous sur les sentiers et dans les donjons.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Adagio_GossipTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Oh, vous revoilà ! J'ai encore entendu d'étranges rumeurs...", "Normal")
  UI:WaitShowDialogue("On dit que la Team Dazzling n'est pas là pour faire du secours, mais pour un secret...")
  UI:WaitShowDialogue("Elles fouillent les recoins du village et de la guilde, murmurant entre elles.")
  UI:WaitShowDialogue("Même les marchands du marché les trouvent suspectes, malgré leur éclat.")
  UI:WaitShowDialogue("Qu'en pensez-vous ? Pensez-vous qu'elles complotent quelque chose de louche ?")
  UI:BeginChoiceMenu("Que lui dites-vous ?", {"Elles complotent", "Elles sont juste fières", "Je ne sais pas"}, 1, 3)
  UI:WaitForChoice()
  local result = UI:ChoiceResult()
  if result == 1 then
    UI:WaitShowDialogue("Je le savais ! Leurs mines mystérieuses et leurs messes basses ne trompent personne.")
    UI:WaitShowDialogue("Même le Doyen Penticus les surveille du coin de l'œil, je l'ai vu hier.")
    UI:WaitShowDialogue("Faites bien attention si vous les croisez dans la Forêt Lugubre.")
  elseif result == 2 then
    UI:WaitShowDialogue("C'est possible. Les équipes de la côte ont toujours cette fierté un peu agaçante.")
    UI:WaitShowDialogue("Après tout, elles ont une grande réputation à tenir, mais quand même...")
    UI:WaitShowDialogue("Ne relâchez pas votre attention pour autant. On ne sait jamais.")
  else
    UI:WaitShowDialogue("La prudence est mère de sûreté, comme on dit toujours à la guilde.")
    UI:WaitShowDialogue("Nous verrons bien ce que l'avenir nous réserve. Restons concentrés.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Adagio_RaidTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous entendu les rumeurs sur les pilleurs nocturnes ?", "Worried")
  UI:WaitShowDialogue("On dit que des spectres rodent dans les ombres de la ville dès que la nuit tombe...")
  UI:WaitShowDialogue("Ils forcent les coffres, pillent les stands et s'enfuient sans laisser de traces.")
  UI:WaitShowDialogue("La place entière retient son souffle dès que le soleil se couche.")
  UI:WaitShowDialogue("Si vous veillez de nuit, soyez extrêmement prudents. Ils sont redoutables.")
  UI:WaitShowDialogue("Mais je sais que votre équipe a le courage de défendre notre ville de Metano !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Adagio_PrepTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avant de repartir en mission, assurez-vous d'être bien préparés !", "Normal")
  UI:WaitShowDialogue("La Forêt Lugubre ne pardonne pas le manque d'organisation.")
  UI:WaitShowDialogue("Prenez toujours des Baies Oran, des Baies Ceriz et des Échapporbes en cas de besoin.")
  UI:WaitShowDialogue("L'entrepôt de la guilde est là pour stocker vos trésors précieux.")
  UI:WaitShowDialogue("Même l'équipe la plus forte peut faillir sans un bon équipement.")
  UI:WaitShowDialogue("Faites-moi confiance, la préparation est la clé de toute grande aventure !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Adagio_RelaxTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'ambiance au café est si relaxante en ce moment...", "Normal")
  UI:WaitShowDialogue("C'est l'endroit idéal pour faire une pause et discuter avec les autres.")
  UI:WaitShowDialogue("Après une longue journée dans les donjons, rien ne vaut une bonne boisson chaude.")
  UI:WaitShowDialogue("Même les rumeurs les plus folles se partagent ici autour d'une table.")
  UI:WaitShowDialogue("Prenez le temps de souffler un peu avant de retourner affronter la jungle.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Adagio_DazzlingChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, que pensez-vous de chaque membre des Dazzling ?", "Normal")
  UI:BeginChoiceMenu("Qui souhaitez-vous évaluer ?", {"Adagio", "Aria", "Sonata", "Toutes"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Adagio est d'une élégance rare, mais ses yeux brillent d'une ambition froide.")
  elseif res == 2 then
    UI:WaitShowDialogue("Aria ne fait que s'exciter et provoquer tout le monde. C'est insupportable.")
  elseif res == 3 then
    UI:WaitShowDialogue("Sonata est tellement théâtrale ! Ses grands gestes amusent la galerie.")
  else
    UI:WaitShowDialogue("Elles forment un groupe redoutable. Ne sous-estimez jamais leur union.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Adagio_ExpeditionChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "L'expédition reste le plus grand événement de l'année !", "Normal")
  UI:WaitShowDialogue("Chacun de nous en garde un souvenir marquant et impérissable.")
  UI:WaitShowDialogue("Pour certains, c'était la première fois qu'ils voyaient de si grandes montagnes.")
  UI:WaitShowDialogue("Et pour vous, quel reste le plus beau souvenir de cette ascension ?")
  UI:BeginChoiceMenu("Votre moment favori :", {"Le feu de camp", "La tempête", "Le sommet"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Le feu de camp était si convivial, à partager des rumeurs au milieu de la nuit !")
  elseif res == 2 then
    UI:WaitShowDialogue("La tempête était terrifiante, mais elle a montré toute la force de notre guilde !")
  else
    UI:WaitShowDialogue("Le sommet Venteux était d'une majesté absolue. On y touchait le ciel !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Adagio_StoryDazzlingTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La Team Dazzling fait sensation à Metano Town...", "Normal")
  UI:WaitShowDialogue("Leurs voix magiques s'entendent jusqu'aux confins de la forêt.")
  UI:WaitShowDialogue("On dit qu'elles préparent un grand spectacle pour fêter leur prochaine victoire.")
  UI:WaitShowDialogue("Mais certains érudits pensent qu'il y a une magie ancienne derrière leur chant.")
  UI:WaitShowDialogue("Nous verrons bien si elles parviennent à apaiser le roi de la jungle !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Adagio_ExpeditionBivouacTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les récits de votre bivouac au Mont Venteux sont incroyables...", "Normal")
  UI:WaitShowDialogue("Dormir sous les étoiles, à l'écoute du chant mystique de la montagne...")
  UI:WaitShowDialogue("C'est le genre d'expérience qui forge l'âme d'un véritable aventurier.")
  UI:WaitShowDialogue("Toute la ville est fière de voir votre équipe progresser si vite !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Aria_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est une magnifique journée d'histoire.", "Normal")
  UI:WaitShowDialogue("Le Chapitre 6 est plein d'aventures et de rumeurs mystérieuses dans la Forêt Lugubre.")
  UI:WaitShowDialogue("Certains disent avoir vu une ombre gigantesque courir à travers les lianes...")
  UI:WaitShowDialogue("...Serait-ce le terrible Zeraora ? Personne n'ose s'en approcher de trop près.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Forêt Lugubre", "La Team Dazzling", "L'expédition", "Rien"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Forêt Lugubre est située juste au nord du village. L'air y est très lourd.")
    UI:WaitShowDialogue("On raconte que les arbres bougent tout seuls et que les lianes emprisonnent les intrus.")
    UI:WaitShowDialogue("Si vous y entrez, restez sur vos gardes. Ne laissez jamais votre partenaire seul.")
    UI:WaitShowDialogue("Et surtout... méfiez-vous du cri de la jungle. Il annonce la colère de son roi.")
    UI:WaitShowDialogue("Je crois que même la guilde n'a pas encore cartographié tout le donjon.")
    UI:WaitShowDialogue("Mais avec votre courage, je sais que vous pourrez y arriver et sauver le petit !")
  elseif choice == 2 then
    UI:WaitShowDialogue("La Team Dazzling... Elles sont arrivées de la côte il y a quelques jours seulement.")
    UI:WaitShowDialogue("Adagio est si polie mais on sent toute sa supériorité dans ses paroles.")
    UI:WaitShowDialogue("Aria est très provocatrice, elle passe son temps à sauter de joie et à se moquer.")
    UI:WaitShowDialogue("Et Sonata... elle est tellement théâtrale avec ses mimiques et ses colères !")
    UI:WaitShowDialogue("Elles se croient déjà au sommet, prétendant que ce sauvetage n'est qu'un jeu pour elles.")
    UI:WaitShowDialogue("Ne les laissez pas vous intimider. Montrez-leur de quel bois vous vous chauffez !")
    UI:WaitShowDialogue("Toute la ville attend de voir qui ramènera le Chenipent en premier.")
  elseif choice == 3 then
    UI:WaitShowDialogue("L'expédition du Mont Venteux... C'était une aventure extraordinaire.")
    UI:WaitShowDialogue("Vous avez gravi les sommets, traversé les tempêtes et affronté le Seigneur des Vents.")
    UI:WaitShowDialogue("Le doyen Penticus m'a dit que votre exploit résonnera longtemps à la guilde.")
    UI:WaitShowDialogue("Mais ce n'était que le début de l'histoire, je le ressens au fond de mes os.")
    UI:WaitShowDialogue("Les flux d'énergie continuent de s'agiter sous la terre, de plus en plus chauds.")
    UI:WaitShowDialogue("Restez forts, mes amis. Le monde a plus que jamais besoin de héros.")
  else
    UI:WaitShowDialogue("D'accord. Prenez soin de vous sur les sentiers et dans les donjons.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Aria_GossipTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Oh, vous revoilà ! J'ai encore entendu d'étranges rumeurs...", "Normal")
  UI:WaitShowDialogue("On dit que la Team Dazzling n'est pas là pour faire du secours, mais pour un secret...")
  UI:WaitShowDialogue("Elles fouillent les recoins du village et de la guilde, murmurant entre elles.")
  UI:WaitShowDialogue("Même les marchands du marché les trouvent suspectes, malgré leur éclat.")
  UI:WaitShowDialogue("Qu'en pensez-vous ? Pensez-vous qu'elles complotent quelque chose de louche ?")
  UI:BeginChoiceMenu("Que lui dites-vous ?", {"Elles complotent", "Elles sont juste fières", "Je ne sais pas"}, 1, 3)
  UI:WaitForChoice()
  local result = UI:ChoiceResult()
  if result == 1 then
    UI:WaitShowDialogue("Je le savais ! Leurs mines mystérieuses et leurs messes basses ne trompent personne.")
    UI:WaitShowDialogue("Même le Doyen Penticus les surveille du coin de l'œil, je l'ai vu hier.")
    UI:WaitShowDialogue("Faites bien attention si vous les croisez dans la Forêt Lugubre.")
  elseif result == 2 then
    UI:WaitShowDialogue("C'est possible. Les équipes de la côte ont toujours cette fierté un peu agaçante.")
    UI:WaitShowDialogue("Après tout, elles ont une grande réputation à tenir, mais quand même...")
    UI:WaitShowDialogue("Ne relâchez pas votre attention pour autant. On ne sait jamais.")
  else
    UI:WaitShowDialogue("La prudence est mère de sûreté, comme on dit toujours à la guilde.")
    UI:WaitShowDialogue("Nous verrons bien ce que l'avenir nous réserve. Restons concentrés.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Aria_RaidTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous entendu les rumeurs sur les pilleurs nocturnes ?", "Worried")
  UI:WaitShowDialogue("On dit que des spectres rodent dans les ombres de la ville dès que la nuit tombe...")
  UI:WaitShowDialogue("Ils forcent les coffres, pillent les stands et s'enfuient sans laisser de traces.")
  UI:WaitShowDialogue("La place entière retient son souffle dès que le soleil se couche.")
  UI:WaitShowDialogue("Si vous veillez de nuit, soyez extrêmement prudents. Ils sont redoutables.")
  UI:WaitShowDialogue("Mais je sais que votre équipe a le courage de défendre notre ville de Metano !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Aria_PrepTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avant de repartir en mission, assurez-vous d'être bien préparés !", "Normal")
  UI:WaitShowDialogue("La Forêt Lugubre ne pardonne pas le manque d'organisation.")
  UI:WaitShowDialogue("Prenez toujours des Baies Oran, des Baies Ceriz et des Échapporbes en cas de besoin.")
  UI:WaitShowDialogue("L'entrepôt de la guilde est là pour stocker vos trésors précieux.")
  UI:WaitShowDialogue("Même l'équipe la plus forte peut faillir sans un bon équipement.")
  UI:WaitShowDialogue("Faites-moi confiance, la préparation est la clé de toute grande aventure !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Aria_RelaxTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'ambiance au café est si relaxante en ce moment...", "Normal")
  UI:WaitShowDialogue("C'est l'endroit idéal pour faire une pause et discuter avec les autres.")
  UI:WaitShowDialogue("Après une longue journée dans les donjons, rien ne vaut une bonne boisson chaude.")
  UI:WaitShowDialogue("Même les rumeurs les plus folles se partagent ici autour d'une table.")
  UI:WaitShowDialogue("Prenez le temps de souffler un peu avant de retourner affronter la jungle.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Aria_DazzlingChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, que pensez-vous de chaque membre des Dazzling ?", "Normal")
  UI:BeginChoiceMenu("Qui souhaitez-vous évaluer ?", {"Adagio", "Aria", "Sonata", "Toutes"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Adagio est d'une élégance rare, mais ses yeux brillent d'une ambition froide.")
  elseif res == 2 then
    UI:WaitShowDialogue("Aria ne fait que s'exciter et provoquer tout le monde. C'est insupportable.")
  elseif res == 3 then
    UI:WaitShowDialogue("Sonata est tellement théâtrale ! Ses grands gestes amusent la galerie.")
  else
    UI:WaitShowDialogue("Elles forment un groupe redoutable. Ne sous-estimez jamais leur union.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Aria_ExpeditionChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "L'expédition reste le plus grand événement de l'année !", "Normal")
  UI:WaitShowDialogue("Chacun de nous en garde un souvenir marquant et impérissable.")
  UI:WaitShowDialogue("Pour certains, c'était la première fois qu'ils voyaient de si grandes montagnes.")
  UI:WaitShowDialogue("Et pour vous, quel reste le plus beau souvenir de cette ascension ?")
  UI:BeginChoiceMenu("Votre moment favori :", {"Le feu de camp", "La tempête", "Le sommet"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Le feu de camp était si convivial, à partager des rumeurs au milieu de la nuit !")
  elseif res == 2 then
    UI:WaitShowDialogue("La tempête était terrifiante, mais elle a montré toute la force de notre guilde !")
  else
    UI:WaitShowDialogue("Le sommet Venteux était d'une majesté absolue. On y touchait le ciel !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Aria_StoryDazzlingTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La Team Dazzling fait sensation à Metano Town...", "Normal")
  UI:WaitShowDialogue("Leurs voix magiques s'entendent jusqu'aux confins de la forêt.")
  UI:WaitShowDialogue("On dit qu'elles préparent un grand spectacle pour fêter leur prochaine victoire.")
  UI:WaitShowDialogue("Mais certains érudits pensent qu'il y a une magie ancienne derrière leur chant.")
  UI:WaitShowDialogue("Nous verrons bien si elles parviennent à apaiser le roi de la jungle !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Aria_ExpeditionBivouacTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les récits de votre bivouac au Mont Venteux sont incroyables...", "Normal")
  UI:WaitShowDialogue("Dormir sous les étoiles, à l'écoute du chant mystique de la montagne...")
  UI:WaitShowDialogue("C'est le genre d'expérience qui forge l'âme d'un véritable aventurier.")
  UI:WaitShowDialogue("Toute la ville est fière de voir votre équipe progresser si vite !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Sonata_AdventureTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Bonjour ! C'est une magnifique journée d'histoire.", "Normal")
  UI:WaitShowDialogue("Le Chapitre 6 est plein d'aventures et de rumeurs mystérieuses dans la Forêt Lugubre.")
  UI:WaitShowDialogue("Certains disent avoir vu une ombre gigantesque courir à travers les lianes...")
  UI:WaitShowDialogue("...Serait-ce le terrible Zeraora ? Personne n'ose s'en approcher de trop près.")
  UI:BeginChoiceMenu("Que souhaitez-vous lui demander ?", {"La Forêt Lugubre", "La Team Dazzling", "L'expédition", "Rien"}, 1, 4)
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  if choice == 1 then
    UI:WaitShowDialogue("La Forêt Lugubre est située juste au nord du village. L'air y est très lourd.")
    UI:WaitShowDialogue("On raconte que les arbres bougent tout seuls et que les lianes emprisonnent les intrus.")
    UI:WaitShowDialogue("Si vous y entrez, restez sur vos gardes. Ne laissez jamais votre partenaire seul.")
    UI:WaitShowDialogue("Et surtout... méfiez-vous du cri de la jungle. Il annonce la colère de son roi.")
    UI:WaitShowDialogue("Je crois que même la guilde n'a pas encore cartographié tout le donjon.")
    UI:WaitShowDialogue("Mais avec votre courage, je sais que vous pourrez y arriver et sauver le petit !")
  elseif choice == 2 then
    UI:WaitShowDialogue("La Team Dazzling... Elles sont arrivées de la côte il y a quelques jours seulement.")
    UI:WaitShowDialogue("Adagio est si polie mais on sent toute sa supériorité dans ses paroles.")
    UI:WaitShowDialogue("Aria est très provocatrice, elle passe son temps à sauter de joie et à se moquer.")
    UI:WaitShowDialogue("Et Sonata... elle est tellement théâtrale avec ses mimiques et ses colères !")
    UI:WaitShowDialogue("Elles se croient déjà au sommet, prétendant que ce sauvetage n'est qu'un jeu pour elles.")
    UI:WaitShowDialogue("Ne les laissez pas vous intimider. Montrez-leur de quel bois vous vous chauffez !")
    UI:WaitShowDialogue("Toute la ville attend de voir qui ramènera le Chenipent en premier.")
  elseif choice == 3 then
    UI:WaitShowDialogue("L'expédition du Mont Venteux... C'était une aventure extraordinaire.")
    UI:WaitShowDialogue("Vous avez gravi les sommets, traversé les tempêtes et affronté le Seigneur des Vents.")
    UI:WaitShowDialogue("Le doyen Penticus m'a dit que votre exploit résonnera longtemps à la guilde.")
    UI:WaitShowDialogue("Mais ce n'était que le début de l'histoire, je le ressens au fond de mes os.")
    UI:WaitShowDialogue("Les flux d'énergie continuent de s'agiter sous la terre, de plus en plus chauds.")
    UI:WaitShowDialogue("Restez forts, mes amis. Le monde a plus que jamais besoin de héros.")
  else
    UI:WaitShowDialogue("D'accord. Prenez soin de vous sur les sentiers et dans les donjons.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Sonata_GossipTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Oh, vous revoilà ! J'ai encore entendu d'étranges rumeurs...", "Normal")
  UI:WaitShowDialogue("On dit que la Team Dazzling n'est pas là pour faire du secours, mais pour un secret...")
  UI:WaitShowDialogue("Elles fouillent les recoins du village et de la guilde, murmurant entre elles.")
  UI:WaitShowDialogue("Même les marchands du marché les trouvent suspectes, malgré leur éclat.")
  UI:WaitShowDialogue("Qu'en pensez-vous ? Pensez-vous qu'elles complotent quelque chose de louche ?")
  UI:BeginChoiceMenu("Que lui dites-vous ?", {"Elles complotent", "Elles sont juste fières", "Je ne sais pas"}, 1, 3)
  UI:WaitForChoice()
  local result = UI:ChoiceResult()
  if result == 1 then
    UI:WaitShowDialogue("Je le savais ! Leurs mines mystérieuses et leurs messes basses ne trompent personne.")
    UI:WaitShowDialogue("Même le Doyen Penticus les surveille du coin de l'œil, je l'ai vu hier.")
    UI:WaitShowDialogue("Faites bien attention si vous les croisez dans la Forêt Lugubre.")
  elseif result == 2 then
    UI:WaitShowDialogue("C'est possible. Les équipes de la côte ont toujours cette fierté un peu agaçante.")
    UI:WaitShowDialogue("Après tout, elles ont une grande réputation à tenir, mais quand même...")
    UI:WaitShowDialogue("Ne relâchez pas votre attention pour autant. On ne sait jamais.")
  else
    UI:WaitShowDialogue("La prudence est mère de sûreté, comme on dit toujours à la guilde.")
    UI:WaitShowDialogue("Nous verrons bien ce que l'avenir nous réserve. Restons concentrés.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Sonata_RaidTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avez-vous entendu les rumeurs sur les pilleurs nocturnes ?", "Worried")
  UI:WaitShowDialogue("On dit que des spectres rodent dans les ombres de la ville dès que la nuit tombe...")
  UI:WaitShowDialogue("Ils forcent les coffres, pillent les stands et s'enfuient sans laisser de traces.")
  UI:WaitShowDialogue("La place entière retient son souffle dès que le soleil se couche.")
  UI:WaitShowDialogue("Si vous veillez de nuit, soyez extrêmement prudents. Ils sont redoutables.")
  UI:WaitShowDialogue("Mais je sais que votre équipe a le courage de défendre notre ville de Metano !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Sonata_PrepTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Avant de repartir en mission, assurez-vous d'être bien préparés !", "Normal")
  UI:WaitShowDialogue("La Forêt Lugubre ne pardonne pas le manque d'organisation.")
  UI:WaitShowDialogue("Prenez toujours des Baies Oran, des Baies Ceriz et des Échapporbes en cas de besoin.")
  UI:WaitShowDialogue("L'entrepôt de la guilde est là pour stocker vos trésors précieux.")
  UI:WaitShowDialogue("Même l'équipe la plus forte peut faillir sans un bon équipement.")
  UI:WaitShowDialogue("Faites-moi confiance, la préparation est la clé de toute grande aventure !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Sonata_RelaxTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, l'ambiance au café est si relaxante en ce moment...", "Normal")
  UI:WaitShowDialogue("C'est l'endroit idéal pour faire une pause et discuter avec les autres.")
  UI:WaitShowDialogue("Après une longue journée dans les donjons, rien ne vaut une bonne boisson chaude.")
  UI:WaitShowDialogue("Même les rumeurs les plus folles se partagent ici autour d'une table.")
  UI:WaitShowDialogue("Prenez le temps de souffler un peu avant de retourner affronter la jungle.")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Sonata_DazzlingChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Mmm, que pensez-vous de chaque membre des Dazzling ?", "Normal")
  UI:BeginChoiceMenu("Qui souhaitez-vous évaluer ?", {"Adagio", "Aria", "Sonata", "Toutes"}, 1, 4)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Adagio est d'une élégance rare, mais ses yeux brillent d'une ambition froide.")
  elseif res == 2 then
    UI:WaitShowDialogue("Aria ne fait que s'exciter et provoquer tout le monde. C'est insupportable.")
  elseif res == 3 then
    UI:WaitShowDialogue("Sonata est tellement théâtrale ! Ses grands gestes amusent la galerie.")
  else
    UI:WaitShowDialogue("Elles forment un groupe redoutable. Ne sous-estimez jamais leur union.")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Sonata_ExpeditionChoiceTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "L'expédition reste le plus grand événement de l'année !", "Normal")
  UI:WaitShowDialogue("Chacun de nous en garde un souvenir marquant et impérissable.")
  UI:WaitShowDialogue("Pour certains, c'était la première fois qu'ils voyaient de si grandes montagnes.")
  UI:WaitShowDialogue("Et pour vous, quel reste le plus beau souvenir de cette ascension ?")
  UI:BeginChoiceMenu("Votre moment favori :", {"Le feu de camp", "La tempête", "Le sommet"}, 1, 3)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  if res == 1 then
    UI:WaitShowDialogue("Le feu de camp était si convivial, à partager des rumeurs au milieu de la nuit !")
  elseif res == 2 then
    UI:WaitShowDialogue("La tempête était terrifiante, mais elle a montré toute la force de notre guilde !")
  else
    UI:WaitShowDialogue("Le sommet Venteux était d'une majesté absolue. On y touchait le ciel !")
  end
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Sonata_StoryDazzlingTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "La Team Dazzling fait sensation à Metano Town...", "Normal")
  UI:WaitShowDialogue("Leurs voix magiques s'entendent jusqu'aux confins de la forêt.")
  UI:WaitShowDialogue("On dit qu'elles préparent un grand spectacle pour fêter leur prochaine victoire.")
  UI:WaitShowDialogue("Mais certains érudits pensent qu'il y a une magie ancienne derrière leur chant.")
  UI:WaitShowDialogue("Nous verrons bien si elles parviennent à apaiser le roi de la jungle !")
  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Sonata_ExpeditionBivouacTalk(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GeneralFunctions.StartConversation(chara, "Les récits de votre bivouac au Mont Venteux sont incroyables...", "Normal")
  UI:WaitShowDialogue("Dormir sous les étoiles, à l'écoute du chant mystique de la montagne...")
  UI:WaitShowDialogue("C'est le genre d'expérience qui forge l'âme d'un véritable aventurier.")
  UI:WaitShowDialogue("Toute la ville est fière de voir votre équipe progresser si vite !")
  GeneralFunctions.EndConversation(chara)
end

return metano_town_ch_6
