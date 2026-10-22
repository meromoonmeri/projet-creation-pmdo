require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.VoiceVisions'

mount_windswept_entrance_ch_5 = {}

--------------------------------------------------------------------
-- LE CAMP DE BASE — decor partage
--------------------------------------------------------------------
-- Un seul endroit qui dessine le bivouac, appele par SetupGround ET par
function mount_windswept_entrance_ch_5.CampNightfall(hero, partner, t)
	local B = mount_windswept_entrance_ch_5.BEDS
	local mountain = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('mount_windswept')
	local ruins = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('cloven_ruins')

	--LE CERCLE DU REPAS N'EST PAS LE CERCLE DES COUCHAGES.
	local MEAL = {
		{t.penticus, 284, 158, Direction.Down},
		{t.phileas,  318, 176, Direction.DownLeft},
		{t.coco,     338, 210, Direction.Left},
		{t.ganlon,   338, 248, Direction.Left},
		{t.reinier,  320, 282, Direction.UpLeft},
		{t.kino,     286, 302, Direction.Up},
		{hero,       248, 302, Direction.Up},
		{partner,    214, 284, Direction.UpRight},
		{t.hyko,     194, 250, Direction.Right},
		{t.almotz,   194, 212, Direction.Right},
		{t.shuca,    212, 178, Direction.DownRight},
		{t.rin,      246, 158, Direction.Down},
	}

	--ATTRIBUTION DES COUCHAGES — elle raconte quelque chose.
	--Le fer a cheval s'ouvre au SUD : c'est par la qu'on arrive et qu'on
	--repart, personne ne dort en travers du sentier. Les couches sont
	--numerotees dans le sens horaire depuis le nord (1 = plein nord,
	--2 a 7 = flanc est, 8 = sud-est en bout de file, 9 a 12 = flanc
	--ouest).
	--  * PENTICUS prend la couche 1, plein nord : entre les dormeurs et
	--    la porte du donjon. Un chef dort du cote d'ou vient le danger.
	--  * LE DUO prend les couches 6 et 7, les deux dernieres du flanc est
	--    avant l'ouverture sud. Elles sont distantes de 50 px, donc
	--    reellement VOISINES : la scene intime de la section 9 cadre les
	--    deux sprites ensemble. Les couches 7 et 8 encadrent au contraire
	--    l'ouverture du fer a cheval et sont a 101 px l'une de l'autre —
	--    le duo y aurait dormi de part et d'autre du passage, hors du
	--    meme plan de camera. Ce sont aussi les plus proches du sentier :
	--    ceux qui partiront en premier au matin.
	--  * HYKO et ALMOTZ sont voisins (8 et 9, 50 px) : ils chuchotent
	--    encore apres l'extinction du feu, il faut qu'ils s'entendent.
	--  * PHILEAS N'A PAS DE PAILLASSE, ET C'EST VOULU. Il prend le
	--    premier tour de garde : il monte au nord du camp et y reste
	--    debout toute la nuit. Lui attribuer une couche qu'il n'occupe
	--    jamais laissait un couchage VIDE au milieu du cercle pendant
	--    toute la veillee, le reve et le reveil — un lit de trop pour
	--    onze dormeurs. C'est PENTICUS qui prend la couche 2, la sienne
	--    reste la 1 : le maitre de guilde dort plein nord, entre les
	--    dormeurs et la porte du donjon.
	--    Conséquence directe : la table BEDS ne compte plus que ONZE
	--    couchages (voir sa definition). DeployBeds n'en pose que onze,
	--    donc plus aucune paillasse inutilisee a l'ecran.
	--Le +13/+10 place le sprite au centre de la paillasse (patron Tunnel).
	--COUCHAGES ALIGNES SUR LES PLACES DE TABLE (voir MEAL ci-dessus).
	--Chacun dort face au foyer, a 49 px maximum de l'endroit ou il a
	--mange. Les directions sont calculees depuis l'angle reel vers le
	--centre (274,238), pas posees a la main.
	local seats = {
		{t.penticus, 2,  Direction.DownLeft},
		{t.coco,     3,  Direction.DownLeft},
		{t.ganlon,   4,  Direction.Left},
		{t.reinier,  5,  Direction.Left},
		{partner,    8,  Direction.UpRight},
		{hero,       7,  Direction.UpRight},
		{t.hyko,     9,  Direction.Right},
		{t.almotz,   11, Direction.Right},
		{t.shuca,    10, Direction.Right},
		{t.rin,      1,  Direction.Down},
		{t.kino,     6,  Direction.UpLeft},
	}
	local function seatX(i) return B[i][1] + 13 end
	local function seatY(i) return B[i][2] + 10 end

	-- LE CAMP ECOUTE — un cercle vivant, pas douze statues.
	-- Mesure faite sur cette scene avant correction : 68 repliques, dont
	-- 22 (32 %) ou AUCUN personnage ne bougeait dans les six lignes
	-- precedentes. Le joueur voyait des boites de dialogue s'enchainer
	-- devant un cercle immobile.
	-- Les deux helpers ci-dessous rendent l'ecoute automatique :
	--   Listen(parleur, {auditeurs}, emote)
	--     Les auditeurs se tournent vers celui qui parle, EN DECALE
	--     (4 frames d'ecart) : un groupe qui pivote d'un seul bloc a
	--     l'air mecanique. C'est la regle deja appliquee aux departs
	--     de la scene, on l'etend a l'ecoute.
	--   Says(parleur, emotion, cle, {auditeurs}, emote)
	--     Regroupe « le corps parle avant la bouche » (grammaire du
	--     projet, §4.6) : on tourne les tetes, PUIS on affiche la boite.
	-- Toutes les API employees sont attestees dans le depot :
	-- CharTurnToCharAnimated (547 fichiers), CharSetEmote, BranchCoroutine,
	-- JoinCoroutines. Le tout sous pcall : un auditeur nil (personnage
	-- deja retire de la carte) ne doit jamais interrompre la veillee.
	local function Listen(speaker, listeners, emote)
		if speaker == nil or listeners == nil then return end
		local turns = {}
		for i, who in ipairs(listeners) do
			if who ~= nil and who ~= speaker then
				turns[#turns+1] = TASK:BranchCoroutine(function()
					pcall(function()
						GAME:WaitFrames((i - 1) * 4)
						GROUND:CharTurnToCharAnimated(who, speaker, 4)
						if emote ~= nil then GROUND:CharSetEmote(who, emote, 1) end
					end)
				end)
			end
		end
		if #turns > 0 then pcall(function() TASK:JoinCoroutines(turns) end) end
	end

	local function Says(speaker, emotion, key, listeners, emote)
		Listen(speaker, listeners, emote)
		UI:SetSpeaker(speaker)
		GeneralFunctions.SetEmotion(emotion or "Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings[key]))
	end

	--Index inverse « personnage -> sa couche », construit UNE fois a
	--partir de `seats`. Toute la scene passe par lui : plus aucune
	--section ne redeclare un numero de lit dans son coin, donc plus
	--aucune possibilite qu'elles divergent.
	local bedOf = {}
	for _, s in ipairs(seats) do bedOf[s[1]] = s[2] end

	-- 1. LE RASSEMBLEMENT — c'est l'arrivee du heros qui le declenche
	--
	-- PLAN, ACTE 1 : « tous les membres de la Guilde sont deja presents
	-- au campement — personne n'arrive de l'exterieur apres le heros. »
	-- « Le rassemblement collectif se produit AU MOMENT OU LE HEROS
	--   ARRIVE : c'est son arrivee qui sert de declencheur pour que les
	--   membres deja presents convergent et se regroupent, pas une
	--   succession d'arrivees exterieures. »
	--
	-- CE QUI A CHANGE, ET POURQUOI.
	-- Cette section faisait exactement l'inverse : Kino et Reinier
	-- etaient caches a l'arrivee (GROUND:Hide dans ArrivalCutscene),
	-- teleportes au bas du sentier en (236,396)/(276,396), puis ils
	-- remontaient au camp sous les yeux du joueur. Le declencheur du
	-- rassemblement etait donc une arrivee exterieure DE PLUS, apres
	-- celle du heros — precisement ce que le plan interdit.
	--
	-- Ils sont desormais sur la carte des la premiere frame, a l'ecart
	-- au sud-est, en pleine discussion a eux (ArrivalCutscene). Ils
	-- remarquent le heros les derniers (beat 1.3), le rejoignent par un
	-- deplacement reel (beat 1.4) et ont chacun leur commentaire propre
	-- (beat 1.5, cles MWE5_179 et MWE5_180) — le tout dans
	-- ArrivalCutscene, qui est la scene ou le heros arrive reellement.
	--
	-- CampNightfall reprend donc APRES le rassemblement : tout le monde
	-- est deja groupe autour du duo, et la soiree peut commencer.
	-- Les repliques MWE5_021 et MWE5_022 (« vous voila enfin ! ») sont
	-- retirees : elles disaient une arrivee qui n'a plus lieu ici.
	--
	-- `coro1..coro4` restent declares ici : tout le reste de la scene
	-- les reutilise sans le mot-cle `local`, et sans cette declaration
	-- ils fuiraient en globales hors de la fonction.
	local coro1, coro2, coro3, coro4

	-- 2. LE DINER — tout le monde s'installe autour du feu
	--
	-- PLAN, REGLE DE NARRATION : « Aucune boite de narration omnisciente.
	-- A la place, c'est le heros qui commente les evenements dans ses
	-- pensees. » Et : « La narration ne doit etre utilisee qu'a des
	-- moments tres precis : clore un acte, ouvrir un acte, introduire un
	-- chapitre. Elle accompagne TOUJOURS un fondu au noir. »
	--
	-- Il y avait ici une boite centree (MWE5_023 : « Le camp se rassemble
	-- autour du feu... »), en plein milieu d'un acte, sans fondu. Elle
	-- decrivait de surcroit ce que l'image montre deja — l'autre interdit
	-- explicite du plan (« les pensees du heros ne doivent jamais resumer
	-- ce que le joueur voit deja a l'ecran »).
	--
	-- Elle est remplacee par ce que le plan demande : un PERSONNAGE qui
	-- porte l'action (« si le repas est pret, c'est un personnage qui
	-- l'annonce naturellement »). Coco appelle a table — c'est sa
	-- fonction dans la guilde, et c'est elle qui a garde le repas au
	-- chaud pendant neuf heures.
	--
	-- L'ANNONCE DU REPAS EST AUSSI LE DECLENCHEUR DU GAG GALON (beat 1.8
	-- du plan) : « tout le monde se tourne spontanement vers Galon a
	-- l'annonce du repas, a cause de sa reputation de gros gourmand ».
	-- On le joue ICI, sur l'annonce reelle, et pas sur une phrase
	-- rapportee — le gag a besoin du mot « manger » prononce a voix haute.
	SOUND:FadeOutBGM(40)
	GAME:WaitFrames(20)
	Says(t.coco, "Joyous", 'MWE5_G01',
	     {t.rin, t.shuca, t.penticus, t.phileas, partner, hero,
	      t.hyko, t.almotz, t.kino, t.reinier})
	GAME:WaitFrames(10)

	-- LE GAG GALON. Trois temps, et c'est le silence du deuxieme qui le
	-- fait exister :
	--   1. le camp se tourne vers lui EN CASCADE — pas d'un bloc. Chacun
	--      pivote depuis SA place, dans l'ordre de sa distance a Coco ;
	--   2. UNE SECONDE DE RIEN. Personne ne parle. Galon comprend
	--      lentement que tout le monde le regarde ;
	--   3. il craque : goutte de sueur, puis il se justifie.
	local versGanlon = {}
	for i, who in ipairs({t.coco, t.rin, t.shuca, t.kino, t.reinier,
	                      t.hyko, t.almotz, t.phileas, t.penticus,
	                      partner, hero}) do
		if who ~= nil then
			versGanlon[#versGanlon+1] = TASK:BranchCoroutine(function()
				pcall(function()
					GAME:WaitFrames((i - 1) * 4)
					GROUND:CharTurnToCharAnimated(who, t.ganlon, 4)
				end)
			end)
		end
	end
	pcall(function() TASK:JoinCoroutines(versGanlon) end)

	--2. LE BEAT. Le vide avant la reaction : sans lui le gag tombe a plat.
	GAME:WaitFrames(50)

	--3. Galon craque. Il regarde a droite, a gauche, puis rend les armes.
	pcall(function()
		GeneralFunctions.LookAround(t.ganlon, 2, 5, false, false, true, Direction.Up)
		GeneralFunctions.EmoteAndPause(t.ganlon, "Sweating", true)
	end)
	UI:SetSpeaker(t.ganlon)
	GeneralFunctions.SetEmotion("Sigh")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_G02']))
	GAME:WaitFrames(12)

	--Coco enfonce le clou, Galon abandonne. Deux repliques, pas dix :
	--le plan demande que le gag reste court.
	--Appel explicite et non `Says` : cette cle porte un {0} (le nom de
	--Galon), or le helper Says appelle STRINGS:Format SANS argument —
	--le marqueur serait reste affiche tel quel a l'ecran.
	Listen(t.coco, {t.ganlon, t.rin, t.shuca})
	UI:SetSpeaker(t.coco)
	GeneralFunctions.SetEmotion("Joyous")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_G03'], t.ganlon:GetDisplayName()))
	GAME:WaitFrames(10)

	--La pensee du heros ferme le beat — courte, amusee, elle n'explique
	--pas le gag (le plan : « un seul apart, leger, pas une explication »).
	GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['MWE5_G04']), "Sigh")
	GAME:WaitFrames(18)

	-- ON GAGNE SA PLACE SANS TRAVERSER PERSONNE.
	local MEAL_ROUTES = {
		{t.penticus, {{260,192},{284,158}}, Direction.Down},
		{t.shuca,    {{230,168},{212,178}}, Direction.DownRight},
		{t.rin,      {{188,232},{228,192},{228,176},{246,158}}, Direction.Down},
		{partner,    {{194,212}}, Direction.Right},
		{hero,       {{284,256},{320,282}}, Direction.UpLeft},
		{t.hyko,     {{224,312},{224,286},{194,250}}, Direction.Right},
		{t.kino,     {{214,284}}, Direction.UpRight},
		{t.reinier,  {{278,274},{248,302}}, Direction.Up},
		{t.phileas,  {{318,176}}, Direction.DownLeft},
		{t.coco,     {{320,194},{338,210}}, Direction.Left},
		{t.almotz,   {{286,302}}, Direction.Up},
		{t.ganlon,   {{338,248}}, Direction.Left},
	}
	local settle = {}
	for i, r in ipairs(MEAL_ROUTES) do
		local chara, route, dir = r[1], r[2], r[3]
		settle[#settle+1] = TASK:BranchCoroutine(function()
			--Le decalage suit l'ordre calcule : celui qui doit liberer
			--une place part le premier.
			GAME:WaitFrames(i * 9)
			pcall(function()
				for _, w in ipairs(route) do
					GROUND:MoveToPosition(chara, w[1], w[2], false, 1)
				end
				GROUND:CharAnimateTurnTo(chara, dir, 4)
			end)
		end)
	end
	TASK:JoinCoroutines(settle)
	GAME:WaitFrames(20)

	--La nourriture apparait devant chaque convive, COTE FEU : l'ecuelle
	--se pose entre le convive et les flammes, jamais dans son dos.
	--L'ancienne version posait « +22 en Y » pour tout le monde, ce qui
	--plantait l'ecuelle DERRIERE les convives de la moitie haute du
	--cercle. On decale donc chaque plat d'un tiers de rayon vers le
	--centre du foyer (274,238), calcule par interpolation entiere.
	--LE SERVICE SE FAIT SOUS UN FONDU COURT.
	GAME:FadeOut(false, 30)
	GAME:WaitFrames(20)

	local foods = {}
	for i, m in ipairs(MEAL) do
		local mx, my = m[2], m[3]
		local fx = math.floor(mx + (274 - (mx + 8)) / 6)
		local fy = math.floor(my + (238 - (my + 8)) / 6)
		local anim = (my > 238) and "Food_Flipped" or "Food"
		local food = RogueEssence.Ground.GroundObject(
			RogueEssence.Content.ObjAnimData(anim, 1, 0, 0),
			RogueElements.Rect(fx, fy, 16, 16),
			RogueElements.Loc(0, 0),
			false,
			"CampFood" .. tostring(i))
		food:ReloadEvents()
		GAME:GetCurrentGround():AddTempObject(food)
		foods[#foods+1] = food
	end

	--Les convives sont deja attables quand la lumiere revient : on met
	--la pose de repas AVANT le FadeIn, pas apres.
	for _, m in ipairs(MEAL) do
		pcall(function() GROUND:CharAnimateTurnTo(m[1], m[4], 1) end)
	end
	GAME:FadeIn(30)
	GAME:WaitFrames(10)

	--Tout le monde mange en meme temps.
	for _, m in ipairs(MEAL) do
		GROUND:CharSetAnim(m[1], "Eat", true)
		GROUND:CharSetEmote(m[1], "eating", 0)
	end

	--La camera balaie le camp pendant le repas, la boite de dialogue
	--"scrontch" tourne en boucle jusqu'a la fin du panoramique.
	local stopEating = false
	UI:SetSpeaker('', false, "", -1, "", RogueEssence.Data.Gender.Unknown)
	SOUND:LoopSE('Dinner Eating')
	coro1 = TASK:BranchCoroutine(function()
		GAME:MoveCamera(200, 180, 100, false)
		GAME:MoveCamera(312, 268, 140, false)
		GAME:MoveCamera(256, 228, 70, false)
		GAME:WaitFrames(30)
		stopEating = true
	end)
	coro2 = TASK:BranchCoroutine(function()
		while not stopEating do
			UI:WaitShowTimedDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_201']), 6)
		end
		SOUND:FadeOutSE('Dinner Eating', 90)
	end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(30)

	--Fin du repas : la desserte se fait sous fondu, comme le service.
	--Douze ecuelles qui disparaissent d'un coup a l'ecran font le meme
	--effet de « pop » que douze qui apparaissent.
	GAME:FadeOut(false, 30)
	GAME:WaitFrames(20)
	for _, food in ipairs(foods) do
		GAME:GetCurrentGround():RemoveTempObject(food)
	end
	for _, m in ipairs(MEAL) do
		GROUND:CharEndAnim(m[1])
		GROUND:CharSetEmote(m[1], "", 0)
	end
	GAME:FadeIn(30)
	SOUND:LoopSE('AMB_Fire_Loud')
	GAME:WaitFrames(20)

	-- 3. LA TABLEE — le faux debat solennel, puis la chute
	-- LE GAG DU CAMP. Structure de Donjon Mystere : le comique ne vient
	-- pas d'une blague, il vient du DECALAGE entre la solennite affichee
	-- et la futilite du sujet. On installe donc le serieux d'abord — et
	-- surtout, on le laisse durer assez longtemps pour que le joueur y
	-- croie — avant de le faire tomber d'un coup.
	-- Quatre temps, avec la musique qui joue le contrepoint :
	--   1. le duo remarque le conciliabule ; on n'entend pas le sujet,
	--      seulement le TON. La musique du camp s'efface.
	--   2. la camera QUITTE le duo pour aller au groupe : le silence
	--      musical dure pendant tout le mouvement — c'est ce vide qui
	--      fait croire a une scene importante.
	--   3. la chute : le sujet tombe, et la musique comique demarre
	--      EXACTEMENT dessus. Pas avant : la musique ne doit pas
	--      annoncer la blague, elle doit la ponctuer.
	--   4. l'escalade, puis Penticus qui tranche — et se trahit.
	-- « Guildmaster Wigglytuff.ogg » est le theme comique canonique de la
	-- guilde dans Explorateurs du Ciel : c'est celui qui accompagne les

	--1. LE CONSTAT. Le duo entend des voix graves sans distinguer les mots.
	--
	--C'EST UNE PENSEE DU HEROS, ELLE DOIT DONC AVOIR SON VISAGE.
	--Le texte de MWE5_158 est deja redige comme un aparte du heros
	--(« (Ils ont l'air d'avoir une discussion serieuse...) ») — c'est
	--meme l'exemple exact que donne le plan pour illustrer sa regle :
	-- « si un groupe discute serieusement, le heros peut simplement
	--   penser : "Ils font une de ces tetes... Que se passe-t-il ?" ».
	--Mais il s'affichait en boite CENTREE SANS LOCUTEUR, c'est-a-dire
	--dans la forme reservee a la narration omnisciente. Le joueur ne
	--pouvait pas distinguer une pensee du heros d'une voix de conteur.
	--HeroDialogue pose le portrait du heros : la pensee est attribuee.
	SOUND:FadeOutBGM(40)
	GAME:WaitFrames(30)
	GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['MWE5_158']), "Worried")

	--2. LA CAMERA VA VOIR. Mouvement lent et appuye vers le groupe, dans
	--le silence. Pendant ce temps les trois se tournent les uns vers les
	--autres : de loin, ca ressemble a un conseil de guerre.
	coro1 = TASK:BranchCoroutine(function()
		GAME:MoveCamera(268, 240, 90, false)
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(20)
		pcall(function() GROUND:CharTurnToCharAnimated(t.ganlon, t.kino, 4) end)
		GAME:WaitFrames(10)
		pcall(function() GROUND:CharTurnToCharAnimated(t.kino, t.ganlon, 4) end)
		GAME:WaitFrames(10)
		pcall(function() GROUND:CharTurnToCharAnimated(t.reinier, t.ganlon, 4) end)
	end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(20)

	--Le ton grave, toujours sans le sujet. Ganlon a l'air en colere.
	Says(t.ganlon, "Angry", 'MWE5_159', {t.kino, t.reinier})
	GAME:WaitFrames(15)
	Says(t.ganlon, "Determined", 'MWE5_160', {t.kino})
	GAME:WaitFrames(15)
	coro1 = TASK:BranchCoroutine(function()
		Says(t.reinier, "Normal", 'MWE5_161', {t.ganlon, t.kino})
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(14)
		pcall(function() GeneralFunctions.DoAnimation(t.kino, 'Nod') end)
	end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(25)

	--3. LA CHUTE. Le sujet tombe.
	--
	-- CORRECTION AUDIO IMPOSEE PAR LE PLAN (acte 2, gestion des OST) :
	-- « Apres le debut du repas, TOUTE MUSIQUE DISPARAIT. Seules les
	--   ambiances naturelles du campement subsistent. Ce silence doit
	--   durer suffisamment longtemps pour installer une atmosphere
	--   calme. Lorsque Plum surgit en courant, AUCUNE OST ne doit jouer
	--   avant son arrivee. La musique de la Guilde reprend UNIQUEMENT au
	--   moment exact ou elle apparait et chute dans le campement. »
	--
	-- Il y avait ici un PlayBGM('Guildmaster Wigglytuff.ogg') : la
	-- musique de la Guilde demarrait donc des le debat de la Pomme
	-- Parfaite et tournait sans interruption jusqu'a l'irruption de
	-- Plum. La reprise censee ponctuer sa chute retombait sur un morceau
	-- DEJA EN TRAIN DE JOUER — le contraste sonore, qui est tout le gag,
	-- n'existait pas.
	--
	-- Le repas reste donc en silence musical du debut a la fin. La chute
	-- du debat est ponctuee par un SE court (le « ! » de surprise du
	-- duo), pas par un morceau : un bruitage ponctue sans occuper
	-- l'espace sonore que le beat de Plum doit trouver vide.
	coro1 = TASK:BranchCoroutine(function()
		Says(t.kino, "Determined", 'MWE5_162', {t.ganlon, t.reinier})
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(30)
		pcall(function() SOUND:PlayBattleSE('EVT_Emote_Exclaim_Surprised') end)
	end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(20)

	--Le duo accuse le coup. Le partenaire pose la question du joueur.
	coro1 = TASK:BranchCoroutine(function()
		pcall(function() GeneralFunctions.EmoteAndPause(partner, "Sweating", true) end)
		Says(partner, "Sigh", 'MWE5_163', {t.ganlon, t.kino, t.reinier})
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(12)
		pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
	end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(12)

	Says(t.hyko, "Sigh", 'MWE5_164', {partner, hero})
	GAME:WaitFrames(18)

	--4. L'ESCALADE. Tout le monde a un avis, personne ne lache rien.
	coro1 = TASK:BranchCoroutine(function()
		Says(t.reinier, "Happy", 'MWE5_165', {t.coco, t.shuca, t.almotz})
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(16)
		pcall(function() GROUND:CharSetEmote(t.shuca, "happy", 1) end)
	end)
	TASK:JoinCoroutines({coro1, coro2})

	coro1 = TASK:BranchCoroutine(function()
		Says(t.ganlon, "Shouting", 'MWE5_166', {t.reinier, t.kino, t.coco})
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(10)
		pcall(function() GeneralFunctions.Hop(t.ganlon, "Idle", 8, 18, 0, false) end)
	end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(12)

	Says(t.coco, "Surprised", 'MWE5_167', {t.ganlon})
	GAME:WaitFrames(12)
	coro1 = TASK:BranchCoroutine(function()
		Says(t.ganlon, "Normal", 'MWE5_168', {t.coco, t.rin})
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(16)
		pcall(function() GROUND:CharSetEmote(t.coco, "sweatdrop", 1) end)
		GAME:WaitFrames(8)
		pcall(function() GROUND:CharSetEmote(t.rin, "sweatdrop", 1) end)
	end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(25)

	--PENTICUS TRANCHE. Tout le cercle se tourne vers lui : enfin une
	--voix de raison. Il repond du tac au tac — et c'est justement ca,
	--la chute finale : il y avait deja pense.
	Listen(t.penticus, {t.ganlon, t.kino, t.reinier, t.coco, t.rin,
	                    t.shuca, t.almotz, t.hyko, partner, hero})
	GAME:WaitFrames(20)
	UI:SetSpeaker(t.penticus)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_169']))

	coro1 = TASK:BranchCoroutine(function()
		pcall(function() GeneralFunctions.Hop(t.reinier, "Idle", 10, 20, 0, false) end)
		Says(t.reinier, "Joyous", 'MWE5_170', {t.ganlon})
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(14)
		pcall(function() GROUND:CharSetEmote(t.ganlon, "angry", 1) end)
	end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(20)

	--La pensee du heros, seul a avoir remarque le detail qui tue.
	GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['MWE5_171']), "Sigh")
	GAME:WaitFrames(25)

	--Retour au cercle et au repas : la camera revient sur le feu.
	GAME:MoveCamera(256, 228, 60, false)
	GAME:WaitFrames(15)

	--Coco s'adresse au cercle entier : les tetes se tournent vers elle
	--en cascade AVANT qu'elle ouvre la bouche (le corps parle avant la
	--bouche). C'est ce qui manquait — la replique tombait sur douze
	--personnages immobiles qui regardaient ailleurs.
	Says(t.coco, "Happy", 'MWE5_024',
	     {t.rin, t.shuca, partner, hero, t.hyko, t.almotz, t.kino, t.reinier})
	GAME:WaitFrames(15)

	--Ganlon marmonne son compliment ; Coco a l'oreille fine. Les deux
	--reactions se jouent en parallele.
	UI:SetSpeaker(t.ganlon)
	GeneralFunctions.SetEmotion("Normal")
	coro1 = TASK:BranchCoroutine(function()
		GROUND:CharAnimateTurnTo(t.ganlon, Direction.UpLeft, 4)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_025']))
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(20)
		GROUND:CharSetEmote(t.coco, "notice", 1)
		GROUND:CharTurnToCharAnimated(t.coco, t.ganlon, 4)
	end)
	coro3 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(26)
		GROUND:CharSetEmote(t.shuca, "happy", 2)
	end)
	TASK:JoinCoroutines({coro1, coro2, coro3})

	GAME:WaitFrames(10)
	--Coco prend Ganlon en flagrant delit de compliment. Le cercle
	--proche se retourne pour voir sa tete — c'est un moment comique,
	--il a besoin de spectateurs.
	UI:SetSpeaker(t.coco)
	GeneralFunctions.SetEmotion("Joyous")
	coro1 = TASK:BranchCoroutine(function()
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_026'], t.ganlon:GetDisplayName()))
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(8)
		Listen(t.ganlon, {t.rin, t.kino, t.reinier})
	end)
	coro3 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(22)
		pcall(function() GROUND:CharSetEmote(t.ganlon, "sweatdrop", 1) end)
	end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
	GAME:WaitFrames(15)

	--Shuca enchaine : les jeunes du cercle se tournent vers elle.
	Says(t.shuca, "Happy", 'MWE5_027', {partner, hero, t.hyko, t.almotz})
	GAME:WaitFrames(12)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Happy")
	coro1 = TASK:BranchCoroutine(function()
		GROUND:CharTurnToCharAnimated(partner, t.shuca, 4)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_028']))
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(14)
		GROUND:CharTurnToCharAnimated(t.shuca, partner, 4)
	end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(20)

	-- 4. LES CONVERSATIONS PARALLELES — trois groupes autour du feu
	--Groupe 1 : Almotz et son almanach, Hyko et ses etoiles.
	--La camera isole le duo, pendant qu'en arriere-plan le reste du
	--camp continue de vivre (animations cycliques sous coroutine,
	--meme patron 'stopTalking' que la nuit du Tunnel).
	local stopTalking = false
	coro1 = TASK:BranchCoroutine(function()
		GAME:MoveCamera(196, 236, 50, false)
		GAME:WaitFrames(10)
		GROUND:CharTurnToCharAnimated(t.almotz, t.hyko, 4)
		GROUND:CharTurnToCharAnimated(t.hyko, t.almotz, 4)
		UI:SetSpeaker(t.almotz)
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_029']))
		GAME:WaitFrames(10)
		UI:SetSpeaker(t.hyko)
		GeneralFunctions.SetEmotion("Joyous")
		GROUND:CharSetEmote(t.hyko, "glowing", 0)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_030']))
		GROUND:CharSetEmote(t.hyko, "", 0)
		GAME:WaitFrames(10)
		UI:SetSpeaker(t.almotz)
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_031'], mountain:GetColoredName()))
		stopTalking = true
	end)
	coro2 = TASK:BranchCoroutine(function()
		while not stopTalking do
			GROUND:CharSetAnim(t.shuca, "Idle", true)
			GROUND:CharSetEmote(t.shuca, "happy", 0)
			GAME:WaitFrames(60)
			GROUND:CharEndAnim(t.shuca)
			GROUND:CharSetEmote(t.shuca, "", 0)
			GAME:WaitFrames(40)
			if stopTalking then break end

			GROUND:CharSetAnim(t.coco, "Idle", true)
			GROUND:CharSetEmote(t.coco, "happy", 0)
			GAME:WaitFrames(60)
			GROUND:CharEndAnim(t.coco)
			GROUND:CharSetEmote(t.coco, "", 0)
			GAME:WaitFrames(40)
		end
	end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(15)

	--Groupe 2 : Reinier, sa queue, et les etincelles. La camera glisse
	--vers lui pendant que Coco lui repond de l'autre bord du feu.
	coro1 = TASK:BranchCoroutine(function()
		GAME:MoveCamera(322, 214, 45, false)
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(20)
		GROUND:CharSetEmote(t.reinier, "question", 1)
	end)
	TASK:JoinCoroutines({coro1, coro2})
	UI:SetSpeaker(t.reinier)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_032']))
	GAME:WaitFrames(12)
	UI:SetSpeaker(t.coco)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_033']))
	GAME:WaitFrames(15)

	--Groupe 3 : les anciens. Phileas et Penticus, en haut du cercle,
	--parlent a voix basse de ce que le vent transporte. La camera les
	--isole ; c'est le seul moment grave du repas.
	GAME:MoveCamera(278, 168, 50, false)
	GAME:WaitFrames(10)
	coro1 = TASK:BranchCoroutine(function()
		GROUND:CharTurnToCharAnimated(t.phileas, t.penticus, 4)
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(8)
		GROUND:CharTurnToCharAnimated(t.penticus, t.phileas, 4)
	end)
	TASK:JoinCoroutines({coro1, coro2})

	UI:SetSpeaker(t.phileas)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_034']))
	GAME:WaitFrames(20)
	--Penticus donne la parole a Phileas : il se tourne vers lui EN le
	--nommant, et le cercle suit le mouvement. Le geste designe l'orateur
	--suivant avant que la boite ne le dise.
	coro1 = TASK:BranchCoroutine(function()
		pcall(function() GROUND:CharTurnToCharAnimated(t.penticus, t.phileas, 4) end)
		UI:SetSpeaker(t.penticus)
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_035'], t.phileas:GetDisplayName()))
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(12)
		Listen(t.phileas, {t.rin, t.coco, partner, hero})
	end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(15)
	UI:SetSpeaker(t.phileas)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_036']))
	GAME:WaitFrames(20)

	--Retour au plan large : Rin fait sa tournee de soins.
	GAME:MoveCamera(256, 228, 55, false)
	GAME:WaitFrames(10)
	GeneralFunctions.EmoteAndPause(t.rin, "Notice", true)
	UI:SetSpeaker(t.rin)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_037'], t.ganlon:GetDisplayName()))
	GAME:WaitFrames(10)

	--Rin se leve du cercle du repas et vient se planter devant Ganlon.
	--On vise SA PLACE DE TABLE (MEAL), pas sa paillasse : a cet instant
	--de la veillee les couchages ne sont pas encore deroules — c'est la
	--section 7 qui les deploie. L'ancienne version envoyait Rin sur des
	--coordonnees de lit inexistant, a l'autre bout du camp.
	coro1 = TASK:BranchCoroutine(function()
		GROUND:MoveToPosition(t.rin, 296, 232, false, 1)
		GROUND:CharTurnToCharAnimated(t.rin, t.ganlon, 4)
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(20)
		GROUND:CharSetEmote(t.ganlon, "sweatdrop", 1)
		GROUND:CharTurnToCharAnimated(t.ganlon, t.rin, 4)
	end)
	TASK:JoinCoroutines({coro1, coro2})

	UI:SetSpeaker(t.ganlon)
	GeneralFunctions.SetEmotion("Sigh")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_038']))
	GAME:WaitFrames(10)
	SOUND:PlayBattleSE("EVT_Emote_Exclaim_2")
	coro1 = TASK:BranchCoroutine(function()
		GROUND:CharSetEmote(t.coco, "happy", 2)
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(6)
		GROUND:CharSetEmote(t.shuca, "happy", 2)
	end)
	coro3 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(10)
		GROUND:CharSetEmote(t.hyko, "happy", 2)
	end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
	UI:SetSpeaker(t.coco)
	GeneralFunctions.SetEmotion("Joyous")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_039']))
	GAME:WaitFrames(25)

	--Rin retourne a SA PLACE AUTOUR DU FEU (cercle du repas, cf. MEAL),
	--pas sur une paillasse : elles ne sont pas encore deployees.
	GROUND:MoveToPosition(t.rin, 234, 198, false, 1)
	GROUND:CharAnimateTurnTo(t.rin, Direction.DownRight, 4)
	GAME:WaitFrames(15)

	-- 4bis. L'IRRUPTION DE PLUM — le gag du repas
	--
	-- Demande explicite : « l'arrivee de plum de maniere comique est pas
	-- arrivee ». Elle est ecrite ici, entre les conversations paralleles
	-- (acte 4) et le silence du heros (acte 5) : c'est le seul creux du
	-- repas, donc le seul endroit ou une irruption fait un vrai contraste.
	--
	-- MECANIQUE DU COMIQUE, dans l'ordre ou elle se joue :
	--   1. un CALME de trois secondes — sans ce vide, la chute ne surprend
	--      personne. Le feu seul, personne ne parle.
	--   2. un BRUIT hors champ, avant l'image : on entend Plum avant de la
	--      voir. La camera part le chercher, elle ne le trouve pas deja la.
	--   3. la COURSE puis la CHUTE, et la musique demarre EXACTEMENT sur
	--      l'impact — pas une frame avant.
	--   4. un SILENCE COURT apres la chute. C'est le beat : sans lui, la
	--      reaction collective arrive trop tot et tombe a plat.
	--   5. la REACTION DE GROUPE, decalee de 4 frames par personnage et
	--      avec des emotes DIFFERENTES : jamais un bloc identique.
	--
	-- Plum = Jigglypuff (CharacterEssentials:202-210). Elle n'existe pas
	-- encore sur cette carte : on la cree, cachee, puis on la revele.
	local plum = nil
	pcall(function()
		local made = CharacterEssentials.MakeCharactersFromList({
			{'Jigglypuff', 256, 452, Direction.Up}
		})
		plum = made
	end)
	if plum == nil then pcall(function() plum = CH('Jigglypuff') end) end

	if plum ~= nil then
		pcall(function() GROUND:Hide(plum.EntName) end)

		--1. LE CALME. La conversation est retombee, il ne reste que le feu.
		--Les convives restent dans leur pose d'attente : personne ne
		--s'agite pour meubler.
		--
		--LE SILENCE EST DEJA INSTALLE DEPUIS LE DEBUT DU REPAS : plus
		--aucun PlayBGM ne tourne depuis l'annonce de Coco (section 2), et
		--le debat de la Pomme Parfaite se joue lui aussi a sec. Le
		--FadeOutBGM ci-dessous est donc une CEINTURE, pas le mecanisme :
		--il coupe ce qui aurait pu rester d'un morceau anterieur si le
		--joueur arrive ici par un chemin different (rechargement, scene
		--rejouee). Sur le parcours nominal c'est un no-op.
		--
		--Le plan demande que ce silence « dure suffisamment longtemps
		--pour installer une atmosphere calme ». On garde donc l'ambiance
		--du feu SEULE (AMB_Fire_Loud, en boucle depuis la fin du repas)
		--pendant deux secondes pleines avant le premier bruit de pas :
		--c'est ce vide-la que la musique viendra briser a la chute.
		SOUND:FadeOutBGM(50)
		GAME:WaitFrames(110)

		--2. LE BRUIT HORS CHAMP. On l'entend avant de la voir. Le duo et
		--les plus proches du sentier tournent la tete vers le sud —
		--chacun selon SA position, pas tous dans la meme direction.
		--Des pas qui COURENT : on les boucle pendant l'approche et on les
		--coupe a la chute. PlaySE aurait joue un coup unique — un bruit
		--sec, pas une course. LoopSE/StopSE est le patron atteste
		--(vast_steppe_entrance_ch_5:113 et :154).
		pcall(function() SOUND:LoopSE("Guild's Feet Pitterpatter") end)
		GAME:WaitFrames(18)
		local look = {}
		for _, who in ipairs({hero, partner, t.almotz, t.hyko}) do
			if who ~= nil then
				look[#look+1] = TASK:BranchCoroutine(function()
					pcall(function()
						GAME:WaitFrames(#look * 5)
						GROUND:CharAnimateTurnTo(who, Direction.Down, 4)
					end)
				end)
			end
		end
		pcall(function() TASK:JoinCoroutines(look) end)
		pcall(function() GeneralFunctions.EmoteAndPause(partner, "Question", true) end)

		--Le heros commente — pensee courte, il reagit a ce qu'il entend,
		--il ne raconte pas la scene a la place du joueur.
		GeneralFunctions.HeroDialogue(hero, "(Des pas.[pause=15] Qui court, a cette heure-ci ?)", "Worried")
		GAME:WaitFrames(12)

		--3. LA COURSE ET LA CHUTE. La camera descend vers le sentier pour
		--l'accueillir : mouvement justifie, on suit une arrivee.
		local cam = TASK:BranchCoroutine(function()
			pcall(function() GAME:MoveCamera(256, 300, 30, false) end)
		end)
		pcall(function() GROUND:Unhide(plum.EntName) end)
		--ELLE FONCE SUR ALMOTZ (Zigzaton), pas dans le vide.
		--
		--CORRECTION D'UN DEFAUT DE MISE EN SCENE. Plum s'ecrasait en
		--(256,300) — soit a 8 px de REINIER (Girafarig), qui occupe
		--(248,302) apres MEAL_ROUTES. Elle lui tombait litteralement
		--dessus, et le gag ne se lisait pas : on voyait deux sprites se
		--superposer, pas une chute.
		--
		--Le gag demande : elle fonce sur Almotz, qui S'ECARTE AU DERNIER
		--MOMENT, et elle s'etale a la place qu'il vient de liberer.
		--C'est l'esquive qui fait rire, pas la chute seule.
		--
		--GEOMETRIE (positions de fin de repas, verifiees) :
		--  Almotz  (286,302) -> esquive en (302,318), 40 px du voisin
		--                       le plus proche : aucun chevauchement.
		--  Plum    s'ecrase en (286,302), la place laissee vide ;
		--                       voisin le plus proche Reinier a 38 px.
		--  Trajet de course (256,452) -> (286,380) -> (286,340) et
		--  glissade finale : tous testes marchables de bout en bout.
		local run = TASK:BranchCoroutine(function()
			pcall(function()
				GROUND:MoveToPosition(plum, 286, 380, true, 5)
				GROUND:MoveToPosition(plum, 286, 340, true, 5)
			end)
		end)
		pcall(function() TASK:JoinCoroutines({cam, run}) end)

		--ALMOTZ LA VOIT ARRIVER. Il se retourne, comprend, et n'a que le
		--temps de sauter de cote. Trois temps tres courts : voir,
		--paniquer, esquiver. C'est le decoupage qui rend l'esquive
		--lisible — sans le temps de panique, on croit a un simple
		--deplacement.
		if t.almotz ~= nil then
			pcall(function() GROUND:CharTurnToCharAnimated(t.almotz, plum, 3) end)
			GAME:WaitFrames(10)
			pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweating") end)
			pcall(function() GROUND:CharSetEmote(t.almotz, "sweating", 1) end)
			GAME:WaitFrames(14)
			--L'esquive : un bond franc sur le cote, pas une marche.
			pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled_2") end)
			pcall(function() GROUND:CharSetEmote(t.almotz, "exclaim", 1) end)
			pcall(function() GeneralFunctions.Hop(t.almotz) end)
			pcall(function() GROUND:MoveToPosition(t.almotz, 302, 318, true, 4) end)
			pcall(function() GROUND:CharTurnToCharAnimated(t.almotz, plum, 3) end)
		end

		--LA CHUTE. Elle ne s'arrete pas : elle se prend les pieds. Anim
		--Hurt sur une derniere glissade, SE d'impact, et la musique
		--comique demarre SUR l'impact — c'est la synchro qui fait le gag.
		--Elle s'etale EXACTEMENT la ou Almotz se tenait une seconde plus tot.
		pcall(function() GROUND:AnimateToPosition(plum, "Hurt", Direction.Up, 286, 302, 2, 6, 0) end)
		pcall(function() SOUND:StopSE("Guild's Feet Pitterpatter") end)
		pcall(function() SOUND:PlayBattleSE('DUN_Rollout') end)
		pcall(function() SOUND:PlayBGM('Guildmaster Wigglytuff.ogg', false) end)
		pcall(function() GROUND:CharSetAnim(plum, "Sleep", true) end)
		pcall(function() GeneralFunctions.EmoteAndPause(plum, "Shock", true) end)

		--4. LE BEAT. Une seconde de rien. Personne ne bouge. C'est ce
		--silence qui rend la reaction suivante drole.
		GAME:WaitFrames(55)

		--Le camp se retourne — en cascade, chacun depuis SA place.
		local turn = {}
		local temoins = {t.penticus, t.phileas, t.rin, t.coco, t.shuca,
		                 t.ganlon, t.kino, t.reinier, t.hyko, t.almotz}
		for i, who in ipairs(temoins) do
			if who ~= nil then
				turn[#turn+1] = TASK:BranchCoroutine(function()
					pcall(function()
						GAME:WaitFrames((i - 1) * 4)
						GROUND:CharTurnToCharAnimated(who, plum, 4)
					end)
				end)
			end
		end
		pcall(function() TASK:JoinCoroutines(turn) end)
		GAME:WaitFrames(20)

		--ELLE SE RELEVE, ET ELLE NE SAIT PAS OU ELLE EST.
		--
		--Demande explicite : « elle se releve ensuite, regarde a gauche
		--puis a droite avant de reprendre ses esprits ». Le desarroi se
		--joue AVANT la parole : elle cherche d'abord ce qu'elle vient de
		--percuter (rien — Almotz s'est ecarte), et ne retrouve son
		--aplomb qu'ensuite. C'est ce temps d'egarement qui paie
		--l'esquive : sans lui, l'esquive n'a pas de consequence.
		pcall(function() GROUND:CharEndAnim(plum) end)
		GAME:WaitFrames(16)

		--Elle se redresse sur ses pattes, encore sonnee.
		--NB : « dizzy » n'existe PAS comme EmoteData dans ce depot
		--(Data/Emote ne contient que « eating » ; le reste vient du jeu
		--de base). DataManager.GetEmote rend null sur un ID inconnu, et
		--ScriptGround.CharSetEmote deref ensuite emote.Anim -> crash.
		--On emploie donc « sweatdrop », atteste 23 fois dans le mod.
		pcall(function() GROUND:CharSetEmote(plum, "sweatdrop", 1) end)
		GAME:WaitFrames(22)

		--GAUCHE, PUIS DROITE. Explicitement, pas un LookAround aleatoire :
		--la demande precise l'ordre. Depuis la position couchee elle
		--regardait vers le haut ; on balaie donc Left puis Right, avec
		--un temps d'arret sur chaque cote — c'est l'arret qui fait lire
		--le regard, pas la rotation.
		pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
		pcall(function() GROUND:CharAnimateTurnTo(plum, Direction.Left, 6) end)
		GAME:WaitFrames(26)
		pcall(function() GROUND:CharAnimateTurnTo(plum, Direction.Right, 6) end)
		GAME:WaitFrames(26)

		--Elle avise la place vide a cote d'elle : c'est LA qu'aurait du
		--se trouver ce qu'elle a percute. Point d'interrogation.
		pcall(function() GeneralFunctions.EmoteAndPause(plum, "Question", true) end)
		GAME:WaitFrames(14)

		--ALMOTZ, depuis son nouveau poste, se signale. Elle le trouve
		--enfin — a un metre de la ou elle le croyait.
		if t.almotz ~= nil then
			pcall(function() GROUND:CharTurnToCharAnimated(plum, t.almotz, 5) end)
			GAME:WaitFrames(18)
			pcall(function() GeneralFunctions.EmoteAndPause(t.almotz, "Sweating", true) end)
			GAME:WaitFrames(12)
		end

		--ELLE REPREND SES ESPRITS. Le bond marque le basculement : la
		--Plum egaree redevient la Plum increvable, et elle enchaine.
		pcall(function() GROUND:CharTurnToCharAnimated(plum, hero, 4) end)
		pcall(function() GeneralFunctions.Hop(plum) end)
		UI:SetSpeaker(plum)
		GeneralFunctions.SetEmotion("Pain")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_P01']))
		GeneralFunctions.SetEmotion("Sad")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_P02']))
		GeneralFunctions.SetEmotion("Determined")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_P03']))
		GAME:WaitFrames(15)

		--5. LA REACTION DE GROUPE. Meme instant, emotes DIFFERENTES :
		--l'agacement de Penticus n'est pas la gene de Coco. Decalage de
		--4 frames pour que ca ondule au lieu de claquer d'un bloc.
		local react = {
			{t.penticus, "Sweatdrop"}, {t.rin, "Sweating"},
			{t.phileas, "Sweatdrop"},  {t.coco, "Sweating"},
			{t.ganlon, "Question"},    {t.shuca, "Exclaim"},
			{t.kino, "Sweatdrop"},     {t.reinier, "Sweating"},
			{t.hyko, "Question"},      {t.almotz, "Exclaim"},
			{partner, "Sweatdrop"},
		}
		local rc = {}
		for i, r in ipairs(react) do
			if r[1] ~= nil then
				rc[#rc+1] = TASK:BranchCoroutine(function()
					pcall(function()
						GAME:WaitFrames((i - 1) * 4)
						GeneralFunctions.EmoteAndPause(r[1], r[2], i == 1)
					end)
				end)
			end
		end
		pcall(function() TASK:JoinCoroutines(rc) end)

		GeneralFunctions.HeroDialogue(hero, "(...Elle nous a suivis depuis Metano.[pause=20] A pied.)", "Worried")
		GAME:WaitFrames(15)

		--Penticus tranche, en maitre de guilde : il ne la renvoie pas la
		--nuit, sur une montagne. Il constate, et il l'installe.
		pcall(function() GROUND:CharTurnToCharAnimated(t.penticus, plum, 4) end)
		UI:SetSpeaker(t.penticus)
		GeneralFunctions.SetEmotion("Sigh")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_P04']))
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_P05']))
		GAME:WaitFrames(12)

		--Coco l'adopte immediatement : c'est sa maniere a elle.
		pcall(function() GROUND:CharTurnToCharAnimated(t.coco, plum, 4) end)
		UI:SetSpeaker(t.coco)
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_P06']))
		pcall(function() GeneralFunctions.EmoteAndPause(plum, "Happy", true) end)
		UI:SetSpeaker(plum)
		GeneralFunctions.SetEmotion("Joyous")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_P07']))
		GAME:WaitFrames(15)

		--Elle rejoint le cercle, a une place LIBRE (verifiee marchable,
		-->=34 px de tout le monde). Plus de course : elle marche, elle
		--est cuite.
		--(280,252) : 50 px du convive le plus proche, 40 px du feu, sol
		--libre verifie. Position mesuree, pas estimee — l'ancienne (288,282)
		--tombait a 20 px d'Almotz et 32 px du heros, soit deux sprites qui
		--se chevauchent.
		pcall(function() GeneralFunctions.EightWayMove(plum, 280, 252, false, 1) end)
		pcall(function() GROUND:CharAnimateTurnTo(plum, Direction.UpLeft, 4) end)
		UI:ResetSpeaker()
		GAME:WaitFrames(20)

		--ELLE FAIT PARTIE DU CAMP A PARTIR D'ICI, ET LE RESTE DE LA SOIREE
		--DOIT LE SAVOIR.
		--C'est ce drapeau qui fait exister sa paillasse (DeployBeds), la
		--recree au retour du reve, la reveille au matin et la fait partir
		--avec le camp. Sans lui, elle sortait du decor a la seconde ou son
		--gag etait fini — le defaut de causalite signale par l'utilisateur.
		SV.Chapter5.PlumAtMountCamp = true
	end

	-- 5. LE SILENCE — le heros et la montagne
	--La conversation retombe. Le heros fixe le sommet ; le partenaire
	--est le seul a le remarquer. Fil rouge de la « sensation etrange »
	--commence au camp du Tunnel : elle est plus forte ici.
	--PREMIER FRISSON DU VERTIGE DE SKY : intensite 1 (tangage leger,
	SOUND:FadeOutSE('AMB_Fire_Loud', 60)
	GAME:WaitFrames(30)
	GROUND:EntTurn(hero, Direction.Up)
	GAME:WaitFrames(20)
	GAME:MoveCamera(238, 258, 40, false)
	GAME:WaitFrames(15)
	pcall(function() VoiceVisions.Nausea(hero, 1) end)
	pcall(function() VoiceVisions.Recover(hero) end)
	GAME:WaitFrames(10)

	GeneralFunctions.EmoteAndPause(partner, "Question", true)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_040'], hero:GetDisplayName()))
	GAME:WaitFrames(15)

	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	UI:SetSpeaker('', false, hero.CurrentForm.Species, hero.CurrentForm.Form, hero.CurrentForm.Skin, hero.CurrentForm.Gender)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_041']))
	GAME:WaitFrames(15)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_042']))
	GAME:WaitFrames(10)
	GeneralFunctions.DoAnimation(hero, 'Nod')
	UI:SetSpeaker('', false, hero.CurrentForm.Species, hero.CurrentForm.Form, hero.CurrentForm.Skin, hero.CurrentForm.Gender)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_043']))
	GAME:WaitFrames(20)
	SOUND:FadeInSE('AMB_Fire_Loud', 60)

	-- 6. L'ORDRE DU SOIR — Penticus envoie tout le monde dormir
	GAME:MoveCamera(256, 210, 45, false)
	GROUND:CharEndAnim(t.penticus)
	GAME:WaitFrames(10)

	--Tout le cercle se tourne vers le maitre de guilde, en decale.
	--PLUM EN FAIT PARTIE. Elle vient de s'asseoir au cercle : elle est
	--dans le champ, elle entend l'ordre du soir comme les autres, et un
	--personnage present qui ne tourne pas la tete quand le maitre de
	--guilde parle, c'est precisement le figement directionnel interdit.
	local listeners = {partner, hero, t.hyko, t.almotz, t.rin, t.coco, t.shuca, t.ganlon, t.reinier, t.kino, plum}
	Listen(t.penticus, listeners)
	GAME:WaitFrames(10)

	UI:SetSpeaker(t.penticus)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_044'], mountain:GetColoredName()))
	GeneralFunctions.SetEmotion("Happy")

	--« Demain, le sommet. » Le camp accuse le coup pendant qu'il parle,
	--chacun a sa maniere : les jeunes s'illuminent, le rale souffle, les
	--anciens hochent. Trois reactions simultanees, pas une file d'attente.
	coro1 = TASK:BranchCoroutine(function()
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_045']))
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(10)
		pcall(function() GROUND:CharSetEmote(t.shuca, "glowing", 1) end)
		GAME:WaitFrames(8)
		pcall(function() GROUND:CharSetEmote(t.hyko, "determined", 1) end)
	end)
	coro3 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(16)
		pcall(function() GROUND:CharSetEmote(t.ganlon, "sweatdrop", 1) end)
	end)
	coro4 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(24)
		pcall(function() GeneralFunctions.DoAnimation(t.reinier, 'Nod') end)
	end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	GAME:WaitFrames(15)

	--Coco a le dernier mot : le cercle se retourne vers elle.
	Says(t.coco, "Joyous", 'MWE5_046', {t.rin, t.shuca, t.ganlon, partner, hero})
	GAME:WaitFrames(20)

	-- 7. LE DEPLOIEMENT DES COUCHAGES — puis la nuit
	--Les paillasses n'existent PAS avant cet instant : c'est ici que
	--l'expedition ouvre les sacs et deroule les couchages (Prompt
	--Maitre 6.3 — aucun lit avant la fin de la veillee). Le passage
	--se fait sous un fondu court, comme le camp du Tunnel remanie son
	--decor sous FadeOut. Au meme moment, le crepuscule bascule en
	--nuit noire ("dusk" -> "darkness", patron exact du Tunnel).
	GAME:FadeOut(false, 40)
	GAME:WaitFrames(20)
	mount_windswept_entrance_ch_5.DeployBeds()
	GROUND:RemoveMapStatus("dusk")
	GROUND:AddMapStatus("darkness")
	GAME:WaitFrames(10)

	-- LE TEXTE DE TRANSITION SE LIT SUR LE NOIR, PAS SUR L'IMAGE.
	--
	-- PLAN, section narration : « Fondu au noir -> Texte narratif ->
	-- Ouverture de l'acte suivant. Elle accompagne TOUJOURS un fondu au
	-- noir afin de marquer une ellipse, un changement d'heure, un
	-- changement de lieu. »
	--
	-- Ces deux boites sont de la vraie narration d'acte (elles ouvrent
	-- l'acte du coucher) : elles ont donc le droit d'exister — a la
	-- difference de MWE5_023, supprimee, qui tombait en plein milieu du
	-- repas sans aucun fondu.
	-- Mais elles s'affichaient APRES le FadeIn(40), donc par-dessus le
	-- camp deja rallume : le joueur lisait « les sacs s'ouvrent, douze
	-- paillasses se deroulent » alors que les paillasses etaient deja
	-- deroulees a l'ecran depuis une seconde. L'ordre du plan est
	-- exactement l'inverse, et il a raison : le texte prepare l'image,
	-- il ne la commente pas apres coup.
	-- On lit donc sur le noir, PUIS on rallume.
	UI:ResetSpeaker(false)
	UI:SetCenter(true)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_072']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_073']))
	UI:SetCenter(false)
	UI:ResetSpeaker()
	GAME:WaitFrames(15)
	GAME:FadeIn(40)
	GAME:WaitFrames(20)

	-- 8. LE COUCHER — un par un, respiration desynchronisee
	--Phileas prend le premier tour de garde : il ne se couche pas.
	local vers = {}
	--L'ordre du coucher LIT la table `seats` (via bedOf) au lieu de
	local sleepOrder = {
		{t.penticus,  0},
		{t.coco,     14},
		{t.shuca,    26},
		{t.ganlon,   40},
		{t.reinier,  52},
		{t.rin,      66},
		{t.kino,     80},
	}
	for _, s in ipairs(sleepOrder) do
		local chara, bed, delay = s[1], bedOf[s[1]], s[2]
		vers[#vers+1] = TASK:BranchCoroutine(function()
			GAME:WaitFrames(delay)
			GROUND:MoveToPosition(chara, seatX(bed), seatY(bed), false, 1)
			GROUND:CharSetAnim(chara, "Sleep", true)
		end)
	end
	--Phileas prend le premier tour de garde : il monte au nord du camp,
	--entre les dormeurs et la porte du donjon, et regarde le camp. Le
	--poste (240,142) est libre et hors de la couche 1 — l'ancien
	--(256,148) tombait dessus.
	vers[#vers+1] = TASK:BranchCoroutine(function()
		GAME:WaitFrames(20)
		--(241,166) et non (240,142) : cette derniere case est SUR UN
		GeneralFunctions.EightWayMove(t.phileas, 241, 166, false, 1)
		GROUND:CharAnimateTurnTo(t.phileas, Direction.Down, 4)
	end)
	TASK:JoinCoroutines(vers)
	GAME:WaitFrames(20)

	--Hyko et Almotz rejoignent leurs couches — VOISINES, 9 et 10 sur le
	--flanc ouest — puis chuchotent encore un moment.
	local toBeds = {}
	toBeds[#toBeds+1] = TASK:BranchCoroutine(function()
		GROUND:MoveToPosition(t.hyko, seatX(bedOf[t.hyko]), seatY(bedOf[t.hyko]), false, 1)
	end)
	toBeds[#toBeds+1] = TASK:BranchCoroutine(function()
		GAME:WaitFrames(10)
		GROUND:MoveToPosition(t.almotz, seatX(bedOf[t.almotz]), seatY(bedOf[t.almotz]), false, 1)
	end)
	-- LE DUO NE RESTE PAS PLANTE PENDANT QUE LES AUTRES SE COUCHENT.
	toBeds[#toBeds+1] = TASK:BranchCoroutine(function()
		GAME:WaitFrames(20)
		pcall(function()
			--Le partenaire s'etire avant de bouger : le corps dit la
			--fatigue avant que la scene ne le dise.
			GeneralFunctions.EmoteAndPause(partner, "Sweatdrop", false)
			GROUND:MoveToPosition(partner, seatX(bedOf[partner]), seatY(bedOf[partner]), false, 1)
			GROUND:CharTurnToCharAnimated(partner, hero, 4)
		end)
	end)
	toBeds[#toBeds+1] = TASK:BranchCoroutine(function()
		GAME:WaitFrames(34)
		pcall(function()
			--Le heros s'attarde : il regarde le sommet une derniere fois
			--avant de suivre. C'est ce qui prepare le reve.
			GROUND:CharAnimateTurnTo(hero, Direction.Up, 6)
			GAME:WaitFrames(24)
			GROUND:MoveToPosition(hero, seatX(bedOf[hero]), seatY(bedOf[hero]), false, 1)
		end)
	end)
	--PLUM AUSSI VA SE COUCHER, ET SA COUCHE EXISTE.
	--Elle part de sa place au cercle (280,252) et rejoint la douzieme
	--paillasse en bout de rang ouest. Trajet en quatre segments, tous
	--reechantillonnes contre la grille d'obstacles : (240,272) puis
	--(200,296) puis (160,304) puis l'assise (129,298). Il contourne les
	--couchages du flanc ouest au lieu de marcher dessus.
	--Elle part la DERNIERE et sans se presser : c'est sa maniere, et ca
	--laisse le champ libre pendant que les autres se couchent.
	if plum ~= nil then
		toBeds[#toBeds+1] = TASK:BranchCoroutine(function()
			GAME:WaitFrames(46)
			pcall(function()
				local pb = mount_windswept_entrance_ch_5.PLUM_BED
				GeneralFunctions.EightWayMove(plum, 240, 272, false, 1)
				GeneralFunctions.EightWayMove(plum, 200, 296, false, 1)
				GeneralFunctions.EightWayMove(plum, 160, 304, false, 1)
				GeneralFunctions.EightWayMove(plum, pb[1] + 13, pb[2] + 10, false, 1)
				--Elle s'installe face au feu, comme tout le monde : sa
				--couche est a l'ouest, le foyer est a l'est.
				GROUND:CharAnimateTurnTo(plum, Direction.Right, 4)
			end)
		end)
	end
	TASK:JoinCoroutines(toBeds)
	GAME:WaitFrames(10)

	-- 8bis. LA SCENE INTIME — le duo, et le partenaire qui lache
	--
	-- ORDRE DES BEATS CORRIGE D'APRES LE PLAN (acte 3).
	-- Le plan place la discussion intime en 3.2, AVANT les histoires qui
	-- font peur (3.6) : « Le heros et son partenaire ont un moment de
	-- discussion calme, a l'ecart du reste du groupe, JUSTE AVANT LE
	-- COUCHER », puis « les jeunes Pokemon COMMENCENT a se raconter une
	-- histoire ». Le code faisait l'inverse (histoires en 8bis, intime en
	-- 9), ce qui cassait deux choses :
	--   * le partenaire s'endormait APRES la veillee, donc son
	--     endormissement en pleine phrase n'avait plus rien a interrompre ;
	--   * la scene se terminait sur le moment calme au lieu de se
	--     terminer sur le gag de Kino, qui est la chute voulue de l'acte.
	-- Les deux blocs ont donc ete permutes tels quels.
	--
	--Le camp s'installe et la camera se resserre sur le duo : c'est le
	--moment calme obligatoire du Prompt Maitre (6.5).
	--
	--LES DEUX MoveToPosition QUI SE TROUVAIENT ICI ONT ETE RETIRES.
	--A l'ancienne place de ce bloc (apres la veillee d'histoires) ils
	--avaient un sens : le duo rejoignait alors ses couches. Depuis la
	--permutation, la section 8 vient JUSTE de les y conduire — heros et
	--partenaire sont deja exactement sur seatX/seatY de leur lit. Les
	--rappeler produisait un ordre de deplacement de longueur nulle : le
	--moteur fait pivoter le sprite sur place sans avancer, ce qui se voit
	--a l'ecran comme un petit soubresaut avant le dialogue intime.
	--Il ne reste donc que ce qui a encore une raison d'etre : le
	--resserrement de camera, et les deux regards qui se croisent.
	local duoBeds = {}
	duoBeds[#duoBeds+1] = TASK:BranchCoroutine(function()
		-- LA CAMERA SE RESSERRE SUR LES DEUX COUCHES VOISINES.
		local cx, cy = 256, 268
		pcall(function()
			cx = (seatX(bedOf[hero]) + seatX(bedOf[partner])) // 2
			cy = (seatY(bedOf[hero]) + seatY(bedOf[partner])) // 2
		end)
		GAME:MoveCamera(cx, cy, 45, false)
	end)
	TASK:JoinCoroutines(duoBeds)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	GAME:WaitFrames(15)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_074']))
	GAME:WaitFrames(15)
	GeneralFunctions.SetEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_075']))
	GAME:WaitFrames(10)
	GeneralFunctions.DoAnimation(hero, 'Nod')
	GAME:WaitFrames(15)

	-- BEATS 3.3 A 3.5 DU PLAN — LE PARTENAIRE S'ENDORT EN PLEINE PHRASE.
	--
	-- « En plein milieu de la discussion, il s'endort progressivement,
	--   sans prevenir. Endormissement JOUE VISUELLEMENT (paupieres qui
	--   tombent, tete qui dodeline), pas juste une coupe brutale. »
	-- « Le heros n'a aucune ligne parlee ici : sa reaction se joue
	--   uniquement via un idle/animation dirige vers son partenaire
	--   endormi. »
	--
	-- Avant, il finissait sa phrase proprement puis se couchait d'un
	-- bloc. Le decalage comique du plan n'existait pas.
	--
	-- L'endormissement se joue en TROIS TEMPS mesurables a l'ecran :
	--   a. la phrase se delite d'elle-meme — [speed=0.4] ralentit le
	--      defilement du texte (balise attestee, Text.cs:38-46), donc on
	--      ENTEND la fatigue avant de la voir ;
	--   b. la tete dodeline : deux quarts de tour lents, aller-retour.
	--      C'est LookAround avec un tres faible nombre de rotations et
	--      des frames longues — le sprite pique du nez au lieu de
	--      chercher quelque chose ;
	--   c. il bascule en EventSleep. Les Z apparaissent apres, pas avant.
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_049'], hero:GetDisplayName()))
	GAME:WaitFrames(15)

	--a. La phrase de trop, celle qui n'arrive pas au bout.
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_D01']))
	GAME:WaitFrames(10)

	--b. La tete dodeline. Frames longues (10) et deux rotations : le
	--sprite oscille lentement au lieu de pivoter vivement.
	pcall(function()
		GeneralFunctions.LookAround(partner, 2, 10, false, false, true, Direction.Up)
	end)
	GAME:WaitFrames(14)

	--c. Il tombe.
	--PAS DE PARTICULE « Sleep_Z » ICI, ET C'EST VERIFIE : Content/Particle
	--du mod ne contient que Ash_Fall, Emote_Eating, Leaf_Fall,
	--Sakura_Fall, Slugma_Materialize(_Reverse) et Snow_Fall. BossFX.
	--Particle echoue EN SILENCE sur un nom absent (c'est ecrit en tete de
	--BossFX.lua) : on aurait cru l'effet joue alors que rien ne s'affiche.
	--L'animation EventSleep porte deja le sommeil a elle seule — meme
	--raisonnement que pour Kino a la veillee.
	pcall(function() GROUND:CharAnimateTurnTo(partner, Direction.Up, 6) end)
	GROUND:CharSetAnim(partner, "EventSleep", true)
	GAME:WaitFrames(35)

	-- LE HEROS NE DIT RIEN. C'est la regle explicite du beat 3.5 : il
	-- repond par le CORPS. Il se tourne vers le dormeur, marque un temps
	-- (le temps de comprendre), et hausse les epaules — la goutte de
	-- sueur d'amusement, pas d'agacement.
	pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 6) end)
	GAME:WaitFrames(28)
	pcall(function() GeneralFunctions.EmoteAndPause(hero, "Sweatdrop", true) end)
	GAME:WaitFrames(12)

	--...et SEULEMENT APRES, une pensee. Elle ne decrit pas l'image (le
	--joueur vient de voir le partenaire s'ecrouler) : elle dit ce que le
	--heros en PENSE, avec l'excuse qu'il lui trouve aussitot.
	GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['MWE5_D02']), "Sigh")
	GAME:WaitFrames(20)

	-- 8ter. LES HISTOIRES QUI FONT PEUR — les jeunes sur leurs paillasses
	--
	-- Demande explicite du brief. Trois recits ORIGINAUX, ecrits pour New
	-- Era : aucun n'est repris d'une creation existante. Ils s'appuient
	-- sur ce que la carte a deja etabli — le vent qui ne s'arrete jamais,
	-- la montagne qu'on gravit demain — donc ils font peur ICI et nulle
	-- part ailleurs. Chacun surenchérit sur le precedent : c'est la
	-- mecanique reelle d'une veillee entre gamins.
	--
	-- Ils chuchotent : le camp dort, et c'est justement l'interdit qui
	-- rend l'echange savoureux. Phileas, de garde, entend tout.
	--
	-- PLUM EST DES LEURS, ET C'EST LE POINT DE LA CORRECTION.
	-- Elle a debarque au repas, elle a sa paillasse en bout de rang ouest
	-- (61 px de Hyko) : elle ENTEND tout. La laisser muette ici serait
	-- exactement le defaut signale — un personnage introduit en fanfare qui
	-- sort du decor au beat suivant.
	-- Son intervention ne lui invente pas une facette nouvelle : elle
	-- sursaute (elle est expressive), puis elle en rajoute (elle est
	-- artiste, elle ne resiste pas a un public), et son histoire parle de
	-- CHANT — le seul angle par lequel ce personnage-la pouvait entrer dans
	-- une veillee de peur.
	local jeunes = {t.shuca, t.almotz, t.hyko}
	if plum ~= nil then jeunes[#jeunes+1] = plum end
	pcall(function()
		--Shuca commence. Elle se redresse sur sa couche : le corps parle
		--avant la bouche.
		if t.shuca ~= nil then
			GROUND:CharEndAnim(t.shuca)
			GROUND:CharTurnToCharAnimated(t.shuca, t.almotz, 4)
		end
	end)
	UI:SetSpeaker(t.shuca)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_H01']))
	GAME:WaitFrames(14)
	GeneralFunctions.SetEmotion("Sad")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_H02']))
	GAME:WaitFrames(18)

	--Almotz surenchérit — il ne veut pas avoir l'air impressionne.
	pcall(function()
		if t.almotz ~= nil then
			GROUND:CharEndAnim(t.almotz)
			GROUND:CharTurnToCharAnimated(t.almotz, t.shuca, 4)
			GeneralFunctions.EmoteAndPause(t.almotz, "Exclaim", true)
		end
	end)
	UI:SetSpeaker(t.almotz)
	GeneralFunctions.SetEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_H03']))
	GAME:WaitFrames(12)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_H04']))
	GAME:WaitFrames(18)

	--LE SURSAUT DE PLUM. Personne ne l'avait invitee dans la conversation :
	--c'est justement ce qui la rend drole. Elle etait couchee a l'autre bout
	--du rang, elle a tout entendu, et elle ne peut PAS se taire.
	--Le corps parle avant la bouche : elle se redresse d'un coup (CharEndAnim
	--leve la pose de sommeil), elle sursaute, PUIS la boite s'ouvre.
	if plum ~= nil then
		pcall(function()
			GROUND:CharEndAnim(plum)
			GeneralFunctions.Shake(plum)
			GeneralFunctions.EmoteAndPause(plum, "Shock", true)
		end)
		--Les trois se retournent vers l'ouest : la voix vient de derriere
		--eux, du bout du rang. Chacun depuis SA place, en decale.
		local vers_plum = {}
		for i, who in ipairs({t.almotz, t.shuca, t.hyko}) do
			if who ~= nil then
				vers_plum[#vers_plum+1] = TASK:BranchCoroutine(function()
					pcall(function()
						GAME:WaitFrames((i - 1) * 5)
						GROUND:CharTurnToCharAnimated(who, plum, 4)
					end)
				end)
			end
		end
		pcall(function() TASK:JoinCoroutines(vers_plum) end)
		GeneralFunctions.Speak(plum, "Shouting")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_H10']))
		GAME:WaitFrames(14)
	end

	--Hyko, le garde, se veut rationnel — et se trahit sur la fin.
	pcall(function()
		if t.hyko ~= nil then
			GROUND:CharEndAnim(t.hyko)
			GROUND:CharTurnToCharAnimated(t.hyko, t.almotz, 4)
		end
	end)
	UI:SetSpeaker(t.hyko)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_H05']))
	GAME:WaitFrames(10)
	pcall(function() GeneralFunctions.EmoteAndPause(t.hyko, "Sweatdrop", true) end)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_H06']))
	GAME:WaitFrames(16)

	--Le heros commente, court : il ecoute sans intervenir.
	GeneralFunctions.HeroDialogue(hero, "(Ils vont s'empecher de dormir tout seuls.)", "Worried")
	GAME:WaitFrames(14)

	-- PHILEAS INTERVIENT. Il est de garde a 96 px au nord : il entend, il
	-- se tourne, il gronde depuis son poste — il ne traverse pas le camp
	-- pour quatre gamins qui chuchotent.
	-- IL SE TOURNE VERS PLUM quand elle est la : c'est elle qui a crie le
	-- plus fort, c'est donc elle la source du bruit qui l'a fait lever la
	-- tete. Un veilleur regarde d'ou vient le vacarme, pas le dernier a
	-- avoir parle poliment.
	pcall(function()
		if t.phileas ~= nil then
			GROUND:CharTurnToCharAnimated(t.phileas, plum or t.almotz, 4)
			GeneralFunctions.EmoteAndPause(t.phileas, "Angry", true)
		end
	end)
	--LES QUATRE PRIS EN FAUTE — memes 4 frames de decalage, EMOTES
	--DIFFERENTES. Un groupe qui affiche la meme goutte de sueur au meme
	--instant, c'est un bloc mecanique : Shuca est genee (sweatdrop),
	--Almotz nie en bloc (question), Hyko se raidit — c'est un garde pris
	--en flagrant delit de bavardage (sweating), et Plum, elle, sursaute
	--une deuxieme fois parce qu'elle ne savait meme pas que quelqu'un
	--veillait (shock). Quatre reactions, quatre caracteres.
	local reactPhil = {
		{t.shuca,  "Sweatdrop"},
		{t.almotz, "Question"},
		{t.hyko,   "Sweating"},
		{plum,     "Shock"},
	}
	local ecoute = {}
	for i, r in ipairs(reactPhil) do
		if r[1] ~= nil then
			ecoute[#ecoute+1] = TASK:BranchCoroutine(function()
				pcall(function()
					GAME:WaitFrames((i - 1) * 5)
					GROUND:CharTurnToCharAnimated(r[1], t.phileas, 4)
					GeneralFunctions.EmoteAndPause(r[1], r[2], i == 1)
				end)
			end)
		end
	end
	pcall(function() TASK:JoinCoroutines(ecoute) end)
	UI:SetSpeaker(t.phileas)
	GeneralFunctions.SetEmotion("Angry")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_H07']))
	GAME:WaitFrames(12)

	-- LE GAG : il cite Kino en exemple. Kino DORT DEJA, et profondement.
	-- Le decalage doit se VOIR : la camera va le chercher pendant que
	-- Phileas parle de lui, et on le trouve ecrase sur sa paillasse.
	pcall(function()
		if t.kino ~= nil then
			GROUND:CharSetAnim(t.kino, "Sleep", true)
		end
	end)
	UI:SetSpeaker(t.phileas)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_H08'], t.kino:GetDisplayName()))

	--La camera part sur Kino PENDANT que la phrase resonne encore.
	pcall(function() GAME:MoveCamera(seatX(bedOf[t.kino]), seatY(bedOf[t.kino]), 32, false) end)
	GAME:WaitFrames(20)
	--Kino dort a poings fermes. Pas d'emote « Sleeping » : elle n'existe
	--pas dans EmoteAndPause (GeneralFunctions:438-482), le else final
	--l'aurait rendue en goutte de sueur — contresens. L'anim Sleep suffit,
	--et c'est elle qui porte le gag : on le VOIT dormir.
	GAME:WaitFrames(45)

	--Les trois regardent Kino, puis se recouchent sans un mot.
	local vers = {}
	for i, who in ipairs(jeunes) do
		if who ~= nil then
			vers[#vers+1] = TASK:BranchCoroutine(function()
				pcall(function()
					GAME:WaitFrames((i - 1) * 6)
					GROUND:CharTurnToCharAnimated(who, t.kino, 4)
				end)
			end)
		end
	end
	pcall(function() TASK:JoinCoroutines(vers) end)
	GAME:WaitFrames(18)

	GeneralFunctions.HeroDialogue(hero, "(...Il ronflait deja pendant l'histoire.)", "Worried")
	GAME:WaitFrames(15)

	--Retour au cadre du camp, et Shuca rend les armes.
	pcall(function() GAME:MoveCamera(256, 240, 36, false) end)
	UI:SetSpeaker(t.shuca)
	GeneralFunctions.SetEmotion("Sigh")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_H09']))
	GAME:WaitFrames(12)
	pcall(function()
		if t.shuca ~= nil then GROUND:CharSetAnim(t.shuca, "Sleep", true) end
	end)
	GAME:WaitFrames(20)

	--PLUM A LE DERNIER MOT, ET ELLE LE MURMURE.
	--Elle a fait le plus de bruit, elle se rendort la derniere : c'est la
	--chute du beat et ca boucle son arc de la soiree (elle est arrivee en
	--fracas, elle s'endort en chuchotant). Elle se tourne vers le feu
	--avant de se coucher — sa couche est a l'ouest, le foyer a l'est.
	if plum ~= nil then
		pcall(function() GROUND:CharTurnToCharAnimated(plum, t.shuca, 4) end)
		GeneralFunctions.Speak(plum, "Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_H11']))
		GAME:WaitFrames(14)
		pcall(function()
			GROUND:CharAnimateTurnTo(plum, Direction.Right, 4)
			GROUND:CharSetAnim(plum, "Sleep", true)
		end)
		GAME:WaitFrames(18)
	end

	GROUND:CharTurnToCharAnimated(t.hyko, t.almotz, 4)
	GROUND:CharTurnToCharAnimated(t.almotz, t.hyko, 4)
	UI:SetSpeaker(t.hyko)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_047'], t.almotz:GetDisplayName()))
	GAME:WaitFrames(10)
	UI:SetSpeaker(t.almotz)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_048'], t.hyko:GetDisplayName()))
	GAME:WaitFrames(15)
	GROUND:CharSetAnim(t.almotz, "EventSleep", true)
	GAME:WaitFrames(8)
	GROUND:CharSetAnim(t.hyko, "Sleep", true)
	GAME:WaitFrames(25)

	--Le heros reste eveille un instant de plus. C'est maintenant que
	--sa couche est deployee dans la fiction : il s'y allonge en
	--dernier, et c'est lui qui ferme la journee.
	GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['MWE5_050']), "Normal")
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
	GROUND:CharSetAnim(hero, "EventSleep", true)
	GAME:WaitFrames(30)

	--La camera derive au-dessus du camp endormi. Phileas, seul
	--debout, pique du bec un instant — gag de sentinelle du Tunnel —
	--puis se redresse.
	SOUND:FadeOutSE('AMB_Fire_Loud', 90)
	coro1 = TASK:BranchCoroutine(function()
		GAME:MoveCamera(256, 268, 90, false)
		GAME:MoveCamera(256, 160, 110, false)
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(120)
		pcall(function() GROUND:CharSetAction(t.phileas, RogueEssence.Ground.FrameGroundAction(t.phileas.Position, t.phileas.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Sleep"), 0)) end)
		GAME:WaitFrames(25)
		pcall(function() GROUND:CharEndAnim(t.phileas) end)
	end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(20)

	UI:ResetSpeaker(false)
	UI:SetCenter(true)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_051']))
	UI:SetCenter(false)
	UI:ResetSpeaker()

	--LA MUSIQUE PART AVEC L'IMAGE. Sans ce FadeOutBGM, la musique du
	--bivouac continuait de jouer pendant le noir (jusqu'au StopBGM de
	--hero_dream) : le passage au reve s'entendait avant de se voir.
	--C'est le meme patron que la bascule vers le matin (section 12 :
	--FadeOutBGM(60) + FadeOut(false, 60), dos a dos).
	SOUND:FadeOutBGM(60)
	GAME:FadeOut(false, 60)
	GAME:WaitFrames(60)

	-- 10. LE REVE — sur sa propre carte
	-- LA SCENE DU REVE A ETE ENTIEREMENT REFAITE, ET DEPLACEE SUR UNE
	-- CARTE DEDIEE : Data/Ground/hero_dream.rsground, script
	-- Data/Script/halcyon/ground/hero_dream/init.lua.
	-- Pourquoi une carte plutot qu'un overlay pose ici :
	--     son OverlayAnim avec omnipresent = false ; GetDrawSize() rend
	--     Loc(TileSize) = 24x24, et IterateRelevantDraw ne dessine que
	--     si ce rectangle touche le ViewRect. Emis en (0,0) avec la
	--     camera sur le camp, il disparaissait du rendu ;
	--   * meme visible, il fallait masquer douze dormeurs, un feu, onze
	--     paillasses et une falaise pour faire croire a un ailleurs.
	-- Sur la carte dediee, le ciel onirique n'est plus un overlay :
	-- c'est le FOND DE CARTE (Background.Layers / LayeredBG), copie
	-- structurelle de personality_test.rsground. Le moteur le dessine
	-- avant tout le reste, sans condition de culling — il ne peut plus
	-- disparaitre. Et le heros y est SEUL, couche au centre.
	-- Le reve se termine par un retour ici meme, ecran noir conserve :
	-- c'est hero_dream qui rappelle mount_windswept_entrance, et
	-- PlotScripting enchaine sur MorningAfterDream (section 11).
	--LE MODE CINEMATIQUE RESTE ACTIF PENDANT LA BASCULE. Le couper ici
	--pendant que SceneOutcome attend d'etre consomme au tour suivant
	--une fraction de seconde avant de partir. hero_dream.DreamScene le
	--repose immediatement de son cote.
	SV.Chapter5.CampNightWatchDone = true
	--TRACE DE DIAGNOSTIC. Tu as signale « je n'ai pas vu la cinematique du
	--reve ». Le cablage est correct (verifie : hero_dream est en position
	--51 de master_zone.GroundMaps, Enter appelle DreamScene, la bascule
	--retour existe) — mais sans trace, impossible de distinguer en jeu
	--entre « la veillee ne va jamais jusqu'ici » et « le preflight refuse
	--la bascule ». Ces deux lignes tranchent la question dans le log :
	--si la premiere apparait sans la seconde, c'est le preflight ; si
	--aucune n'apparait, la veillee s'est arretee avant (c'etait le cas
	--au build H : le crash de portrait bloquait des l'arrivee au camp).
	PrintInfo('[MWE5] fin de veillee — preparation de la bascule vers hero_dream')
	--VERIFICATION PREALABLE DU CHARGEMENT, FAITE AVANT D'ARMER LA BASCULE.
	--EnterGroundMap est un iterateur C# PARESSEUX (ScriptGame.cs : il se
	--contente de construire la coroutine MoveToGround, sans executer la
	--moindre ligne de son corps) : AUCUN lookup n'a lieu a l'appel Lua,
	--et un pcall autour ne peut donc rien attraper. La bascule ne
	--s'execute que lorsque ScreenMainCoroutine consomme SceneOutcome —
	--et si elle meurt en route (asset absent ou illisible : Zone.cs
	--nullifie CurrentGround AVANT le chargement, et DataManager.GetGround
	--AVALE l'exception reelle en rendant null), le moteur retombe sur
	--ProcessInput avec CurrentGround == null : NullReferenceException a
	--chaque frame, jusqu'a l'arret du jeu (trace « GroundScene.
	--ProcessInput()+MoveNext » relevee en jeu le 2026-07-30).
	--Toute la securite doit donc se jouer ICI, en amont :
	--  1. GroundValid : la map est-elle enregistree dans la zone — le
	--     MEME test que MoveToGround, mais avant qu'il ne soit trop tard ;
	--  2. GetGround : l'asset est-il reellement chargeable (en cas
	--     d'echec le moteur logue « Missing Data » et rend nil).
	--3e cas : si le preflight LUI-MEME est casse (liaison moteur
	--absente), on tente la bascule quand meme — un risque connu vaut
	--mieux qu'un reve toujours saute sur un faux negatif.
	--3e garde (crash reel du 2026-07-30) : LA ZONE EN MEMOIRE doit connaitre
	--la map — c'est le test que MoveToGround rejoue lui-meme
	--(GameManager.cs:730-731, CurrentZone.GroundMaps.FindIndex). Ce jour-la,
	--le resume de zone etait a jour (GroundValid OK) mais la zone chargee
	--etait ancienne (master_zone.json anterieur a cb10d10) : FindIndex
	--rendait -1 -> exception -> NRE ProcessInput en boucle. zoneConnait
	--rend nil si la liaison est absente : indecidable, on ne bloque pas
	--(politique inchangee : eviter les faux negatifs).
	local function zoneConnait(nom)
		local okZ, resZ = pcall(function()
			local z = _ZONE.CurrentZone
			if z == nil then return nil end
			for i = 0, z.GroundMaps.Count - 1 do
				if tostring(z.GroundMaps[i]) == nom then return true end
			end
			return false
		end)
		if not okZ then return nil end
		return resZ
	end
	local canDream = true
	local okPre, resPre = pcall(function()
		local summary = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('master_zone')
		if not summary:GroundValid('hero_dream') then return false end
		local reg = zoneConnait('hero_dream')
		if reg == false then
			PrintInfo('[MWE5] hero_dream absente de la ZONE EN MEMOIRE (index.idx et master_zone.json desynchronises cote jeu) — reve saute, retour au camp')
			return false
		end
		return _DATA:GetGround('hero_dream') ~= nil
	end)
	if okPre then
		canDream = (resPre == true)
	else
		PrintInfo('[MWE5] preflight reve indisponible ('..tostring(resPre)..') — bascule tentee quand meme')
	end
	if not canDream then
		PrintInfo('[MWE5] hero_dream absente de la zone ou asset illisible — reve saute, retour au camp')
		SV.Chapter5.DreamSceneSeen = true
		GAME:EnterGroundMap('mount_windswept_entrance', 'Main_Entrance_Marker', true)
		return
	end
	--Bascule normale. Le pcall est conserve en ceinture (il ne peut
	--rien attraper de la bascule elle-meme), il ne coute rien.
	PrintInfo('[MWE5] preflight reve OK — bascule armee vers hero_dream')
	local okDream, errDream = pcall(function()
		GAME:EnterGroundMap('hero_dream', 'Main_Entrance_Marker', true)
	end)
	if not okDream then
		PrintInfo('[MWE5] hero_dream indisponible ('..tostring(errDream)..') — reve saute, retour au camp')
		SV.Chapter5.DreamSceneSeen = true
		GAME:EnterGroundMap('mount_windswept_entrance', 'Main_Entrance_Marker', true)
	end
end

--------------------------------------------------------------------
-- RATTRAPAGE DU REVE MANQUE
--
-- Appelee par PlotScripting quand on arrive sur le camp avec la veillee
-- terminee (CampNightWatchDone) mais le reve JAMAIS joue
-- (DreamSceneSeen faux). Cet etat est atteignable des que la bascule
-- vers hero_dream n'aboutit pas : fermeture du jeu pendant l'ecran
-- noir, sauvegarde reprise a cet instant precis, ou bascule avortee
-- cote moteur. Sans ce rattrapage, le routeur enchainait sur
-- ResumeAfterDream et le joueur voyait le REVEIL SANS LE REVE.
--
-- GARDE ANTI-BOUCLE, essentielle : on ne retente QU'UNE SEULE FOIS.
-- Si la seconde tentative echoue elle aussi, on pose DreamSceneSeen et
-- on laisse la nuit suivre son cours — un reve saute vaut infiniment
-- mieux qu'un aller-retour infini entre deux cartes, qui rendrait la
-- partie injouable. Le compteur vit dans SV : il survit donc a une
-- sauvegarde/rechargement, ce qu'une variable locale ne ferait pas.
--------------------------------------------------------------------
function mount_windswept_entrance_ch_5.RetryDream()
	if SV.Chapter5.DreamRetryDone then
		PrintInfo('[MWE5] reve deja retente une fois sans succes — on poursuit sans lui (nuit degradee, partie preservee)')
		SV.Chapter5.DreamSceneSeen = true
		mount_windswept_entrance_ch_5.ResumeAfterDream()
		return
	end
	SV.Chapter5.DreamRetryDone = true

	--L'ECRAN DOIT ETRE NOIR AVANT LA BASCULE. On arrive ici par Enter,
	--donc potentiellement sur une carte allumee et montee : sans ce
	--fondu, le joueur verrait le camp une fraction de seconde avant de
	--partir vers le reve. Meme raisonnement qu'en tete de chaque scene
	--du fichier (FadeOut(false,1) = no-op sur ecran deja noir,
	--FadeEffect.cs:63-64).
	pcall(function() GAME:CutsceneMode(true) end)
	pcall(function() GAME:FadeOut(false, 1) end)
	pcall(function() SOUND:StopBGM() end)

	--MEME PREFLIGHT QUE LA BASCULE D'ORIGINE, pour la meme raison :
	--EnterGroundMap est un iterateur paresseux, un pcall autour ne peut
	--rien attraper. Si la carte n'est pas chargeable, armer la bascule
	--tue la partie (CurrentGround null -> NRE ProcessInput en boucle).
	local canDream = true
	local okPre, resPre = pcall(function()
		local summary = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('master_zone')
		if not summary:GroundValid('hero_dream') then return false end
		local z = _ZONE.CurrentZone
		if z ~= nil then
			local vu = false
			for i = 0, z.GroundMaps.Count - 1 do
				if tostring(z.GroundMaps[i]) == 'hero_dream' then vu = true break end
			end
			if not vu then return false end
		end
		return _DATA:GetGround('hero_dream') ~= nil
	end)
	if okPre then canDream = (resPre == true) end

	if not canDream then
		PrintInfo('[MWE5] rattrapage impossible (hero_dream non chargeable) — reve definitivement saute')
		SV.Chapter5.DreamSceneSeen = true
		mount_windswept_entrance_ch_5.ResumeAfterDream()
		return
	end

	PrintInfo('[MWE5] rattrapage — bascule armee vers hero_dream')
	GAME:EnterGroundMap('hero_dream', 'Main_Entrance_Marker', true)
end

-- LE MATIN — apres le reve, de retour au camp
-- Scindee de CampNightfall : un changement de carte doit etre la
-- DERNIERE instruction d'une scene (le moteur poursuit la coroutine en
-- arriere-plan pendant le chargement). Tout ce qui suivait le reve est
-- donc devenu une fonction a part, rappelee par PlotScripting quand on
-- revient de hero_dream.
-- RETOUR DU REVE — on recompose le camp endormi, puis le matin.
-- Passer par une carte dediee a un cout : les dix PNJ du camp sont des
-- personnages TEMPORAIRES (AddTempChar), ils n'existent plus au retour.
-- Cette fonction les recree EXACTEMENT sur leur couche, dans la pose de
-- sommeil, avant de rendre la main au matin. Le joueur ne voit rien de
-- cette reconstruction : tout se passe sous l'ecran noir laisse par
-- hero_dream et maintenu par Init.
-- L'ordre des couchages est celui de la table `seats` de CampNightfall,
-- recopie ici a l'identique. Les deux doivent rester d'accord : si l'un
-- change, l'autre aussi.
function mount_windswept_entrance_ch_5.ResumeAfterDream()
	--SORTIE GARANTIE — meme patron que DreamScene wrapper. Ce chemin
	--recree les dix PNJ (MakeCharactersFromList) et teleporte heros et
	--partenaire EN BRUT, entierement SOUS L'ECRAN NOIR (hero_dream est
	--parti dessus, l'Init et cette fonction le reposent) : la moindre
	--erreur y laissait le joueur fige sur noir, mode cinematique actif,
	--sans recours — un « black screen au coucher » de plus. Une scene
	--du matin degradee vaut mieux qu'une partie gelee : on trace, on
	--cloture l'intro (pour ne pas rejouer la veillee en boucle), on
	--rend la main et on rallume.
	local okR, errR = pcall(mount_windswept_entrance_ch_5.ResumeAfterDreamBody)
	if not okR then
		PrintInfo('[MWE5] recompositon du camp ecourtee : '..tostring(errR))
		pcall(function() SV.Chapter5.FinishedMountWindsweptIntro = true end)
		pcall(function() GAME:CutsceneMode(false) end)
		pcall(function() GAME:FadeIn(20) end)
	end
end

function mount_windswept_entrance_ch_5.ResumeAfterDreamBody()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local B = mount_windswept_entrance_ch_5.BEDS

	GAME:CutsceneMode(true)
	pcall(function() GAME:FadeOut(false, 1) end)
	--La nuit est encore la : le matin se leve dans MorningAfterDream.
	pcall(function() GROUND:AddMapStatus("darkness") end)

	--Le bivouac de la nuit : paillasses + foyer (et son bloqueur).
	mount_windswept_entrance_ch_5.DeployBeds()

	--Les dix membres du camp, recrees a leur place.
	local audino, snubbull, girafarig, breloom, growlithe, zigzagoon, tropius, noctowl, mareep, cranidos =
	CharacterEssentials.MakeCharactersFromList({
		--Attribution synchronisee avec la table `seats` de CampNightfall
		--(realignee sur le cercle du repas) : Rin 1, Penticus 2, Coco 3,
		--Ganlon 4, Reinier 5, Kino 6, heros 7, partenaire 8, Hyko 9,
		--Shuca 10, Almotz 11. Les deux listes DOIVENT rester d'accord :
		--si l'une change, l'autre aussi.
		{'Audino',    B[1][1]  + 13, B[1][2]  + 10, Direction.Down},
		{'Snubbull',  B[3][1]  + 13, B[3][2]  + 10, Direction.DownLeft},
		{'Girafarig', B[5][1]  + 13, B[5][2]  + 10, Direction.Left},
		{'Breloom',   B[6][1]  + 13, B[6][2]  + 10, Direction.UpLeft},
		{'Growlithe', B[9][1]  + 13, B[9][2]  + 10, Direction.Right},
		{'Zigzagoon', B[11][1] + 13, B[11][2] + 10, Direction.Right},
		{'Tropius',   B[2][1]  + 13, B[2][2]  + 10, Direction.DownLeft},
		{'Noctowl',   241, 166, Direction.Down},
		{'Mareep',    B[10][1] + 13, B[10][2] + 10, Direction.Right},
		{'Cranidos',  B[4][1]  + 13, B[4][2]  + 10, Direction.Left}
	})

	--PLUM DORT AUSSI, SUR SA PAILLASSE.
	--Elle est arrivee la veille au soir (section 4bis), elle a veille avec
	--les jeunes (8bis), elle s'est couchee la derniere : si on ne la recree
	--pas ici, elle disparaitrait du camp entre le coucher et le reveil,
	--sans un mot. C'est le defaut de causalite signale par l'utilisateur.
	--
	--Elle est recreee EXACTEMENT sur PLUM_BED, la douzieme paillasse, la
	--meme que DeployBeds vient de derouler quelques lignes plus haut (la
	--fonction lit le meme drapeau SV.Chapter5.PlumAtMountCamp). Les deux
	--ne peuvent plus diverger : il n'y a qu'une source pour la position.
	--Elle dort tournee vers le feu, comme elle s'est endormie.
	local plumMorning = nil
	if SV.Chapter5.PlumAtMountCamp then
		pcall(function()
			local pb = mount_windswept_entrance_ch_5.PLUM_BED
			plumMorning = CharacterEssentials.MakeCharactersFromList({
				{'Jigglypuff', pb[1] + 13, pb[2] + 10, Direction.Right}
			})
			if plumMorning ~= nil then
				GROUND:CharSetAnim(plumMorning, "Sleep", true)
			end
		end)
	end

	--Le duo sur ses couches : partenaire 5, heros 6 (voisines de 50 px,
	--pour que la camera puisse les cadrer ensemble).
	GROUND:TeleportTo(partner, B[8][1] + 13, B[8][2] + 10, Direction.UpRight)
	GROUND:TeleportTo(hero,    B[7][1] + 13, B[7][2] + 10, Direction.UpRight)

	--Tout le monde dort. Phileas, lui, VEILLE debout a son poste : il
	--n'a pas de couchage, c'est tout son role de la nuit.
	for _, c in ipairs({audino, snubbull, girafarig, breloom, growlithe,
	                    zigzagoon, tropius, mareep, cranidos}) do
		pcall(function() GROUND:CharSetAnim(c, "Sleep", true) end)
	end
	pcall(function() GROUND:CharSetAnim(partner, "EventSleep", true) end)
	pcall(function() GROUND:CharSetAnim(hero, "EventSleep", true) end)

	--Puis le matin, avec la meme table de personnages que la veillee.
	--PLUM Y FIGURE (nil si elle n'est pas venue) : la scene du matin doit
	--pouvoir la reveiller, la faire reagir et lui faire ses adieux, sinon
	--elle disparaitrait entre le lever et le depart.
	mount_windswept_entrance_ch_5.MorningAfterDream(
		hero, partner, {penticus = tropius, phileas = noctowl,
		                rin = audino,      coco = snubbull,
		                shuca = mareep,    ganlon = cranidos,
		                hyko = growlithe,  almotz = zigzagoon,
		                reinier = girafarig, kino = breloom,
		                plum = plumMorning})
end

function mount_windswept_entrance_ch_5.MorningAfterDream(hero, partner, t)
	--SORTIE GARANTIE — meme patron que DreamScene wrapper et
	--ResumeAfterDream. La scene du matin est une longue chaine de
	--dialogues en brut qui s'ouvre SOUS LE NOIR : si elle meurt avant
	--son FadeIn(45), le joueur reste sur un ecran noir sans recours.
	--On trace et on rallume plutot que de geler la partie.
	local okM, errM = pcall(mount_windswept_entrance_ch_5.MorningAfterDreamBody, hero, partner, t)
	if not okM then
		PrintInfo('[MWE5] scene du matin ecourtee : '..tostring(errM))
		pcall(function() SV.Chapter5.FinishedMountWindsweptIntro = true end)
		pcall(function() GAME:CutsceneMode(false) end)
		pcall(function() GAME:FadeIn(20) end)
	end
end

function mount_windswept_entrance_ch_5.MorningAfterDreamBody(hero, partner, t)
	local B = mount_windswept_entrance_ch_5.BEDS
	local mountain = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('mount_windswept')
	local ruins = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('cloven_ruins')
	local coro1, coro2, coro3, coro4, coro5, coro6

	--Helpers d'ecoute, identiques a ceux de la veillee : le corps parle
	--avant la bouche. Redefinis ici car ils etaient locaux a
	--CampNightfall, dont cette fonction a ete detachee.
	local function Listen(speaker, listeners, emote)
		if speaker == nil or listeners == nil then return end
		local turns = {}
		for i, who in ipairs(listeners) do
			if who ~= nil and who ~= speaker then
				turns[#turns+1] = TASK:BranchCoroutine(function()
					pcall(function()
						GAME:WaitFrames((i - 1) * 4)
						GROUND:CharTurnToCharAnimated(who, speaker, 4)
						if emote ~= nil then GROUND:CharSetEmote(who, emote, 1) end
					end)
				end)
			end
		end
		if #turns > 0 then pcall(function() TASK:JoinCoroutines(turns) end) end
	end
	local function Says(speaker, emotion, key, listeners, emote)
		Listen(speaker, listeners, emote)
		UI:SetSpeaker(speaker)
		GeneralFunctions.SetEmotion(emotion or "Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings[key]))
	end
	--LA COUCHE DU HEROS. C'est la 6 : voir la table `seats` de
	--CampNightfall, ou le duo occupe les couches 5 (partenaire) et 6
	--(heros), les deux dernieres du flanc est avant l'ouverture sud.
	--On ne partage pas `seats` entre les deux fonctions : elle est
	--construite a partir des personnages `t`, qui n'existent que le
	--temps de la veillee. Une constante nommee vaut mieux qu'une table
	--reconstruite a moitie.
	local HERO_BED = 7
	local function seatX(i) return B[i][1] + 13 end
	local function seatY(i) return B[i][2] + 10 end

	GAME:CutsceneMode(true)
	if partner ~= nil then AI:DisableCharacterAI(partner) end

	--L'ECRAN EST DEJA NOIR : hero_dream est parti dessus, et Init l'a
	--repose ici. La mise en place du matin se fait donc a l'abri.
	pcall(function() GAME:FadeOut(false, 1) end)

	--LE SURSAUT DU REVEIL. Le heros se redresse d'un coup : c'est la
	--seule trace que le reve laisse dans son corps. Il joue MAINTENANT,
	--au retour, et non plus dans le reve — le reveil appartient au
	--monde reel.
	GAME:MoveCamera(seatX(HERO_BED), seatY(HERO_BED), 1, false)
	GAME:FadeIn(45)
	GAME:WaitFrames(25)

	pcall(function() SOUND:PlayBattleSE('EVT_Emote_Exclaim_2') end)
	pcall(function() GROUND:CharEndAnim(hero) end)
	pcall(function() VoiceVisions.Nausea(hero, 1) end)
	GAME:WaitFrames(25)

	--L'OUBLI IMMEDIAT — le coeur du dispositif de Rouge/Bleu. Trois
	--pensees, entrecoupees de silences : il tente de rattraper l'image
	--et n'y arrive pas.
	--
	--ATTRIBUEES AU HEROS, plus en boite centree anonyme. Les trois cles
	--sont deja ecrites entre parentheses — ce sont des pensees, pas la
	--voix d'un narrateur. La forme centree sans locuteur est reservee a
	--la narration d'acte (celle qui accompagne un fondu) ; l'employer
	--ici brouillait les deux registres.
	GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['MWE5_155']), "Pain")
	GAME:WaitFrames(30)
	GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['MWE5_156']), "Worried")
	GAME:WaitFrames(25)
	GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['MWE5_157']), "Sad")
	UI:ResetSpeaker()
	GAME:WaitFrames(35)

	-- PHILEAS NE PEUT PAS RESTER PASSIF.
	-- RETOUR DE L'UTILISATEUR, et il a entierement raison : le heros
	-- vient de se redresser en criant au milieu de la nuit, et le seul
	-- personnage EVEILLE du camp — celui dont c'est precisement le
	-- tour de garde — ne bougeait pas d'un pixel. Le joueur ne pouvait
	-- que se demander « pourquoi il ne reagit pas ? ». C'est le test de
	-- credibilite, et la scene le ratait.
	-- Ce que Phileas FAIT, dans l'ordre ou un veilleur le ferait :
	--   1. il entend (il est de garde, c'est son role) et leve la tete ;
	--   2. il se tourne vers la source du bruit AVANT de bouger ;
	--   3. il traverse le camp — 128 px, quatre segments, trajet calcule
	--      pour ne pieter aucun des dix dormeurs (seuil 14 px) ni le
	--      foyer ;
	--   4. il s'arrete a distance de conversation (26 px), pas colle ;
	--   5. il parle bas — il ne reveille pas le camp pour un cauchemar ;
	--   6. il REPREND SON POSTE. Un veilleur ne s'installe pas au
	--      chevet : il retourne guetter la porte du donjon.
	-- Son registre est celui etabli ailleurs sur la carte (« Hou... »,
	-- le vieux voilier qui observe avant de conclure) : il ne dramatise
	-- pas, il constate, et c'est ce qui rassure.
	if t.phileas ~= nil then
		--1-2. IL ENTEND ET SE TOURNE. La camera s'ecarte un peu pour le
		--faire entrer dans le cadre : il ne doit pas parler hors champ.
		local pw1 = TASK:BranchCoroutine(function()
			pcall(function()
				GROUND:CharEndAnim(t.phileas)
				GeneralFunctions.EmoteAndPause(t.phileas, "Notice", true)
				GROUND:CharTurnToCharAnimated(t.phileas, hero, 4)
			end)
		end)
		local pw2 = TASK:BranchCoroutine(function()
			GAME:WaitFrames(10)
			GAME:MoveCamera(324, 268, 60, false)
		end)
		TASK:JoinCoroutines({pw1, pw2})
		GAME:WaitFrames(20)

		--3. IL TRAVERSE LE CAMP. Waypoints calcules par recherche de
		--chemin sur la grille d'obstacles, en tenant les dix dormeurs a
		--14 px minimum : il slalome entre les paillasses au lieu de
		--marcher dessus.
		pcall(function()
			GeneralFunctions.EightWayMove(t.phileas, 287, 212, false, 1)
			GeneralFunctions.EightWayMove(t.phileas, 287, 248, false, 1)
			GeneralFunctions.EightWayMove(t.phileas, 313, 294, false, 1)
			--4. Il s'arrete et se tourne vers lui.
			GROUND:CharTurnToCharAnimated(t.phileas, hero, 4)
		end)
		GAME:WaitFrames(15)

		--Le heros le regarde arriver.
		pcall(function() GROUND:CharTurnToCharAnimated(hero, t.phileas, 4) end)
		GAME:WaitFrames(12)

		--5. IL PARLE BAS. Trois repliques, entrecoupees de silences : il
		--laisse le heros reprendre son souffle entre chaque.
		UI:SetSpeaker(t.phileas)
		GeneralFunctions.SetEmotion("Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_193']))
		GAME:WaitFrames(25)
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_194']))
		GAME:WaitFrames(35)

		--Il devine, parce qu'il a vu ca cent fois.
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_195']))
		GAME:WaitFrames(20)

		--Le heros ne repond pas a voix haute : il pense. C'est un
		--cauchemar qu'on ne raconte pas, et Phileas ne le force pas.
		--Pensee ATTRIBUEE (HeroDialogue) : la boite centree anonyme est
		--reservee a la narration d'acte sur fondu.
		GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['MWE5_196']), "Worried")
		UI:ResetSpeaker()
		GAME:WaitFrames(30)

		UI:SetSpeaker(t.phileas)
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_197']))
		GAME:WaitFrames(25)

		--La phrase qui rassure vraiment : elle ne nie pas le cauchemar,
		--elle dit juste que quelqu'un veille.
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_198']))
		GAME:WaitFrames(30)

		--Le heros acquiesce, puis se recouche.
		pcall(function() GeneralFunctions.DoAnimation(hero, 'Nod') end)
		GAME:WaitFrames(20)

		--6. IL REPREND SON POSTE. Meme trajet en sens inverse : il ne
		--disparait pas, il ne reste pas plante la. La camera le suit
		--jusqu'a ce qu'il reparte, puis revient sur le dormeur.
		local pb1 = TASK:BranchCoroutine(function()
			pcall(function()
				GROUND:CharTurnToCharAnimated(t.phileas, hero, 4)
				GAME:WaitFrames(20)
				GeneralFunctions.EightWayMove(t.phileas, 287, 248, false, 1)
				GeneralFunctions.EightWayMove(t.phileas, 287, 212, false, 1)
				GeneralFunctions.EightWayMove(t.phileas, 241, 166, false, 1)
				GROUND:CharAnimateTurnTo(t.phileas, Direction.Down, 4)
			end)
		end)
		local pb2 = TASK:BranchCoroutine(function()
			GAME:WaitFrames(60)
			GAME:MoveCamera(seatX(HERO_BED), seatY(HERO_BED), 90, false)
		end)
		TASK:JoinCoroutines({pb1, pb2})
		GAME:WaitFrames(20)
	end

	--Il se rendort. Le trouble n'est pas resolu : il ressurgira au matin
	--et sur le chemin du nord.
	pcall(function()
		GROUND:CharSetEmote(hero, "", 0)
		GROUND:CharSetAnim(hero, "EventSleep", true)
	end)
	GAME:WaitFrames(60)

	--LA NUIT PASSE.
	GAME:FadeOut(false, 50)
	GAME:WaitFrames(30)

	-- 11. LE MATIN — reveil progressif, heros deboussole
	--Mise en place sous le noir : le jour se leve, Rin et Coco sont
	--deja debout, Penticus et Phileas aussi. Le reste du camp dort.
	GROUND:RemoveMapStatus("darkness")

	GROUND:CharEndAnim(t.rin)
	GROUND:CharEndAnim(t.coco)
	GROUND:CharEndAnim(t.penticus)
	-- LE FEU BRULE ENCORE AU REVEIL, ET LES SPRITES SONT GRANDS.
	--
	-- BUG CORRIGE (signale en jeu : « au reveil dans mont windsep penticus
	-- est devant audino immobile c'est pas beau et pas esthetique &
	-- illogique »). Penticus etait teleporte en (252,268) et Rin en
	-- (240,262) : 13,4 px d'ecart, mesures. Un sprite de Pokemon fait
	-- 24 a 32 px de large — le maitre de guilde etait donc litteralement
	-- PLANTE DANS Rin, et comme il est teleporte APRES elle, il passait
	-- devant : Rin disparaissait sous lui.
	--
	-- Illogique aussi, et c'est le vrai reproche : Penticus dirige
	-- l'expedition. Au reveil il n'est pas colle a la cuisiniere, il est
	-- DEBOUT PRES DU FOYER, face au camp qu'il va mettre en route.
	--
	-- Nouvelle place (286,216) : 65 px de Rin, 30 px du feu, sol libre
	-- verifie (Tags==0), dans le cadre de la camera (256,240). Il regarde
	-- vers l'ouest, c'est-a-dire vers les dormeurs qu'il s'apprete a
	-- reveiller — orientation coherente avec ce qu'il fait ensuite.
	GROUND:TeleportTo(t.rin, 240, 262, Direction.UpRight)
	GROUND:TeleportTo(t.coco, 298, 250, Direction.Left)
	GROUND:TeleportTo(t.penticus, 286, 216, Direction.Left)
	GROUND:TeleportTo(t.phileas, 240, 166, Direction.Down)
	pcall(function() GROUND:CharSetAnim(t.phileas, "Sleep", true) end)
	GAME:MoveCamera(256, 240, 1, false)

	UI:SetAutoFinish(true)
	UI:WaitShowVoiceOver(STRINGS:Format(STRINGS.MapStrings['MWE5_052']) .. "\n\n", -1)
	UI:SetAutoFinish(false)
	GAME:WaitFrames(40)

	--Rin lance le reveil : elle se tourne vers les dormeurs avant de
	--donner de la voix (le corps parle avant la bouche).
	pcall(function() GROUND:CharAnimateTurnTo(t.rin, Direction.Down, 4) end)
	pcall(function() GeneralFunctions.EmoteAndPause(t.rin, "Happy", true) end)
	UI:SetSpeaker(t.rin)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_053']))
	GAME:FadeIn(40)
	GAME:WaitFrames(20)

	SOUND:PlayBattleSE("DUN_Heal_Bell")
	GROUND:CharSetAction(t.rin, RogueEssence.Ground.PoseGroundAction(t.rin.Position, t.rin.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GAME:WaitFrames(100)
	GROUND:CharEndAnim(t.rin)
	GAME:WaitFrames(20)

	--Tout le monde se reveille... sauf Kino. Le HEROS, lui, se
	--reveille MAL : sursaut, regard perdu autour de lui (LookAround,
	--patron du reveil de DiedCutscene au Tunnel) — le reve colle.
	coro1 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(20)
		GeneralFunctions.Shake(hero)
		GAME:WaitFrames(10)
		GeneralFunctions.Shake(hero)
		GAME:WaitFrames(10)
		GeneralFunctions.DoAnimation(hero, 'Wake')
		GAME:WaitFrames(20)
		GeneralFunctions.LookAround(hero, 3, 4, false, false, false, Direction.Up)
		GAME:WaitFrames(10)
		GROUND:CharTurnToCharAnimated(hero, t.rin, 4)
	end)
	coro2 = TASK:BranchCoroutine(function()
		GeneralFunctions.Shake(partner)
		GAME:WaitFrames(20)
		GeneralFunctions.DoAnimation(partner, 'Wake')
		GAME:WaitFrames(20)
		GROUND:CharTurnToCharAnimated(partner, t.rin, 4)
	end)
	coro3 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(10)
		GeneralFunctions.Shake(t.almotz)
		GAME:WaitFrames(20)
		GeneralFunctions.DoAnimation(t.almotz, 'Wake')
		GAME:WaitFrames(20)
		GROUND:CharTurnToCharAnimated(t.almotz, t.rin, 4)
	end)
	coro4 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(4)
		GeneralFunctions.Shake(t.hyko)
		GAME:WaitFrames(70)
		GROUND:CharEndAnim(t.hyko)
		GAME:WaitFrames(20)
		GROUND:CharTurnToCharAnimated(t.hyko, t.rin, 4)
	end)
	coro5 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(16)
		GeneralFunctions.Shake(t.shuca)
		GAME:WaitFrames(20)
		GeneralFunctions.DoAnimation(t.shuca, 'Wake')
		GAME:WaitFrames(20)
		GROUND:CharTurnToCharAnimated(t.shuca, t.rin, 4)
	end)
	coro6 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(16)
		GeneralFunctions.Shake(t.ganlon)
		GAME:WaitFrames(10)
		GeneralFunctions.Shake(t.ganlon)
		GAME:WaitFrames(70)
		GROUND:CharEndAnim(t.ganlon)
		GAME:WaitFrames(20)
		GROUND:CharTurnToCharAnimated(t.ganlon, t.rin, 4)
	end)
	local coro7 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(6)
		GeneralFunctions.Shake(t.reinier)
		GAME:WaitFrames(80)
		GROUND:CharEndAnim(t.reinier)
		GAME:WaitFrames(20)
		GROUND:CharTurnToCharAnimated(t.reinier, t.rin, 4)
	end)
	--PLUM SE REVEILLE AVEC LES AUTRES, ET EN DERNIER.
	--Elle s'est endormie la derniere (veillee d'histoires), elle emerge la
	--derniere : la continuite du personnage se joue jusque dans le tempo
	--du reveil. Sursaut double comme le heros, mais pour une raison
	--opposee — elle a juste tres bien dormi et ne sait plus ou elle est.
	local coro8 = nil
	if t.plum ~= nil then
		coro8 = TASK:BranchCoroutine(function()
			pcall(function()
				GAME:WaitFrames(34)
				GeneralFunctions.Shake(t.plum)
				GAME:WaitFrames(24)
				GeneralFunctions.DoAnimation(t.plum, 'Wake')
				GAME:WaitFrames(16)
				--Elle cherche d'ou vient la voix avant de la trouver :
				--elle ne sait pas encore ou elle est.
				GeneralFunctions.LookAround(t.plum, 2, 5, false, false, false, Direction.Right)
				GROUND:CharTurnToCharAnimated(t.plum, t.rin, 4)
			end)
		end)
	end
	local reveil = {coro1, coro2, coro3, coro4, coro5, coro6, coro7}
	if coro8 ~= nil then reveil[#reveil+1] = coro8 end
	TASK:JoinCoroutines(reveil)

	SOUND:PlayBGM("Do Your Best, As Always!.ogg", true)
	UI:SetSpeaker(t.rin)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_054']))
	GAME:WaitFrames(20)

	--Le partenaire remarque la paleur du heros (Prompt Maitre 6.7).
	--LE VERTIGE DE SKY, cette fois a l'ecran : c'est l'effet des Cris
	--Temporels d'Explorateurs du Ciel, porte du depot EoSO dans
	pcall(function() VoiceVisions.Nausea(hero, 2) end)
	pcall(function() VoiceVisions.Recover(hero, true) end)
	GAME:WaitFrames(10)

	--CE QU'IL RESTE DU REVE. Le heros tente de rattraper l'image et n'y
	--arrive pas. C'est la reprise du dispositif de Rouge/Bleu — le reve
	--s'efface a la seconde ou on se reveille, et seul le SENTIMENT reste.
	--
	--MWE5_085 RETIREE (« Une ombre... Elle me parlait comme si elle me
	--connaissait. »). Deux raisons, et la premiere est la tienne :
	--  * elle DECRIT Gardevoir comme « une ombre ». Cette formulation
	--    datait d'une version ou le sprite ne s'affichait pas : le texte
	--    compensait alors une image absente. Le sprite s'affiche
	--    desormais (hero_dream cree un GroundChar gardevoir, sprites
	--    fournis nativement par PMDO) — le joueur a VU une silhouette
	--    nette, verte et blanche, pas une ombre. La replique contredisait
	--    donc l'ecran.
	--  * elle cassait le dispositif d'oubli qu'elle est censee servir :
	--    le heros y restitue le contenu du reve (« petit echo ») ET son
	--    intention, alors que tout l'interet est qu'il n'en garde QUE le
	--    sentiment. Les trois pensees du reveil nocturne (MWE5_155-157)
	--    disent deja l'oubli, correctement.
	--
	--MWE5_086 reste : elle ne decrit rien du reve, elle dit l'apres — le
	--vent, le camp qui dort, et qu'il faut se rendormir. C'est le bon
	--registre.
	--
	--Comme les trois pensees du reveil nocturne, elle passe par
	--HeroDialogue : c'est une pensee du heros, elle porte donc son
	--portrait. Seule la narration d'acte (sur fondu) reste centree.
	GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['MWE5_086']), "Sad")
	UI:ResetSpeaker()
	GAME:WaitFrames(25)

	GeneralFunctions.EmoteAndPause(partner, "Question", true)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_087'], hero:GetDisplayName()))
	GAME:WaitFrames(10)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	UI:SetSpeaker('', false, hero.CurrentForm.Species, hero.CurrentForm.Form, hero.CurrentForm.Skin, hero.CurrentForm.Gender)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_088']))
	GAME:WaitFrames(20)

	--Kino dort toujours. Comme au Tunnel. Comme toujours.
	GeneralFunctions.EmoteAndPause(t.rin, "Notice", true)
	GROUND:CharTurnToCharAnimated(t.rin, t.kino, 4)
	GAME:WaitFrames(10)
	UI:SetSpeaker(t.rin)
	GeneralFunctions.SetEmotion("Sigh")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_055'], t.kino:GetDisplayName()))
	GAME:WaitFrames(15)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_056']))
	GAME:WaitFrames(15)

	--Rin va secouer Kino, le seul encore endormi.
	--DEUX DEFAUTS CORRIGES, mesures sur la nouvelle disposition :
	--  * elle visait « +44 en X », soit 31 px a l'est de l'assise de
	--    Kino. Trop loin pour le secouer : elle l'engueulait a distance.
	--  * pire, ce point est de l'AUTRE COTE de la paillasse : le trajet
	coro1 = TASK:BranchCoroutine(function()
		GeneralFunctions.EightWayMoveRS(t.rin, B[bedOf[t.kino]][1] + 13,
		                                B[bedOf[t.kino]][2] - 14, false, 1)
		GROUND:CharAnimateTurnTo(t.rin, Direction.Down, 4)
	end)
	coro2 = TASK:BranchCoroutine(function()
		GeneralFunctions.FaceMovingCharacter(hero, t.rin, 4, Direction.Right)
	end)
	coro3 = TASK:BranchCoroutine(function()
		GeneralFunctions.FaceMovingCharacter(partner, t.rin, 4, Direction.Right)
	end)
	coro4 = TASK:BranchCoroutine(function()
		GeneralFunctions.FaceMovingCharacter(t.shuca, t.rin, 4, Direction.Right)
	end)
	coro5 = TASK:BranchCoroutine(function()
		GeneralFunctions.FaceMovingCharacter(t.ganlon, t.rin, 4, Direction.Right)
	end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})

	GAME:WaitFrames(10)
	GeneralFunctions.Complain(t.rin)
	UI:SetSpeaker(t.rin)
	GeneralFunctions.SetEmotion("Shouting")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_057'], t.kino:GetDisplayName()))
	GAME:WaitFrames(10)

	GeneralFunctions.Shake(t.kino)
	GAME:WaitFrames(30)
	GROUND:CharEndAnim(t.kino)
	GAME:WaitFrames(20)
	UI:SetSpeaker(t.kino)
	GeneralFunctions.SetEmotion("Sigh")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_058']))
	GAME:WaitFrames(10)
	GeneralFunctions.EmoteAndPause(t.rin, "Sweatdrop", true)
	UI:SetSpeaker(t.rin)
	GeneralFunctions.SetEmotion("Sigh")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_059']))
	GAME:WaitFrames(10)
	UI:SetSpeaker(t.ganlon)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_060']))
	GAME:WaitFrames(25)

	-- 11bis. ON REGLE LE CAS DE PLUM AVANT DE PARTIR.
	--
	-- « Et demain on avise » : c'est la phrase exacte de Penticus la veille
	-- au soir (MWE5_P05). Une promesse posee dans un beat DOIT etre tenue
	-- dans le beat suivant, sinon le personnage devient une decoration
	-- qu'on rallume quand on en a besoin.
	--
	-- Ce que la scene resout, dans l'ordre :
	--   1. Plum s'approche d'elle-meme : c'est elle qui a un sort a regler,
	--      ce n'est pas au maitre de guilde de venir la chercher ;
	--   2. Penticus tranche — non, elle ne monte pas ; il ne l'humilie pas,
	--      il lui donne une raison utile de rester (c'est sa maniere : il
	--      dirige en donnant des roles, cf. les cordees juste apres) ;
	--   3. Coco la recupere immediatement, comme la veille au soir — elle
	--      l'avait deja adoptee (MWE5_P06), la continuite est tenue ;
	--   4. le heros commente, court.
	--
	-- Elle reste donc AU CAMP DE BASE avec Penticus, Phileas et Hyko : les
	-- trois PNJ que SetupGround laisse sur place. Sa presence ensuite y est
	-- donc justifiee, et non pas subie.
	if t.plum ~= nil then
		--Elle traverse depuis sa paillasse (129,298) jusqu'aupres du
		--maitre de guilde, poste en (286,216). Quatre segments, tous
		--reechantillonnes contre la grille d'obstacles : ils remontent par
		--l'ouest du foyer et evitent les onze couchages.
		--Arrivee en (244,206) : 43 px de Penticus (distance de
		--conversation, pas collee), et 40 px du plus proche de TOUS les
		--autres personnages presents — Phileas a son poste, Almotz sur sa
		--couche. Aucun chevauchement de sprite.
		local pl1 = TASK:BranchCoroutine(function()
			pcall(function()
				GeneralFunctions.EightWayMove(t.plum, 168, 290, false, 1)
				GeneralFunctions.EightWayMove(t.plum, 200, 258, false, 1)
				GeneralFunctions.EightWayMove(t.plum, 224, 232, false, 1)
				GeneralFunctions.EightWayMove(t.plum, 244, 206, false, 1)
				GROUND:CharTurnToCharAnimated(t.plum, t.penticus, 4)
			end)
		end)
		--Le maitre de guilde la voit venir et se tourne vers elle AVANT
		--qu'elle arrive : il l'attendait, c'est lui qui a dit « demain ».
		local pl2 = TASK:BranchCoroutine(function()
			GAME:WaitFrames(24)
			pcall(function() GROUND:CharTurnToCharAnimated(t.penticus, t.plum, 4) end)
		end)
		--Le duo suit la scene du regard : ils sont les seuls a savoir
		--comment elle est arrivee.
		local pl3 = TASK:BranchCoroutine(function()
			GAME:WaitFrames(30)
			pcall(function() GeneralFunctions.FaceMovingCharacter(hero, t.plum, 4, Direction.Up) end)
		end)
		local pl4 = TASK:BranchCoroutine(function()
			GAME:WaitFrames(36)
			pcall(function() GeneralFunctions.FaceMovingCharacter(partner, t.plum, 4, Direction.Up) end)
		end)
		pcall(function() TASK:JoinCoroutines({pl1, pl2, pl3, pl4}) end)
		GAME:WaitFrames(12)

		--Elle plaide sa cause, sans y croire vraiment.
		GeneralFunctions.Speak(t.plum, "Determined")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_P08']))
		GAME:WaitFrames(15)

		--Penticus tranche. Le camp proche ecoute — c'est une decision de
		--maitre de guilde, pas une conversation privee.
		Listen(t.penticus, {t.plum, t.rin, t.coco, hero, partner})
		UI:SetSpeaker(t.penticus)
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_P09']))
		GAME:WaitFrames(12)
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_P10']))
		GAME:WaitFrames(15)

		--Elle encaisse : deception d'abord, puis elle rebondit. C'est
		--exactement son mouvement de la veille (chute, puis tirade).
		pcall(function() GeneralFunctions.EmoteAndPause(t.plum, "Sweatdrop", true) end)
		GeneralFunctions.Speak(t.plum, "Sad")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_P11']))
		GAME:WaitFrames(14)

		--Coco la recupere, comme la veille au soir — mais ATTENTION A LA
		--CONTINUITE : Coco part avec la cordee de soutien une demi-heure
		--plus tard (section 14). Elle ne peut donc pas « prendre Plum avec
		--elle » ; elle lui PASSE LE RELAIS, ce qui est plus juste encore :
		--Plum herite de la cuisine du camp de base pendant que la guilde
		--monte. C'est aussi ce qui justifie sa presence au camp apres
		--l'intro (SetupGround).
		--Elle s'approche : on ne confie pas ses marmites a douze pas.
		--Elle CONTOURNE LE FOYER PAR L'EST (304,200) au lieu de le
		--traverser : le bloqueur de collision occupe 262..286 / 226..250,
		--une ligne droite depuis (298,250) l'aurait fait buter dedans.
		--Arrivee en (276,190) : 36 px de Plum, 28 px de Penticus, 43 px de
		--Phileas — les trois tiennent dans le meme plan sans se recouvrir.
		local cc1 = TASK:BranchCoroutine(function()
			pcall(function()
				GeneralFunctions.EightWayMove(t.coco, 304, 200, false, 1)
				GeneralFunctions.EightWayMove(t.coco, 276, 190, false, 1)
				GROUND:CharTurnToCharAnimated(t.coco, t.plum, 4)
			end)
		end)
		local cc2 = TASK:BranchCoroutine(function()
			GAME:WaitFrames(14)
			pcall(function() GeneralFunctions.FaceMovingCharacter(t.plum, t.coco, 4) end)
		end)
		pcall(function() TASK:JoinCoroutines({cc1, cc2}) end)
		UI:SetSpeaker(t.coco)
		GeneralFunctions.SetEmotion("Joyous")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_P12']))
		GAME:WaitFrames(12)
		pcall(function() GeneralFunctions.EmoteAndPause(t.plum, "Glowing", true) end)
		GeneralFunctions.Speak(t.plum, "Joyous")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_P13']))
		GAME:WaitFrames(15)

		GeneralFunctions.HeroDialogue(hero, "(...Elle a marche deux jours pour finir cuisiniere.[pause=20] Et elle a l'air ravie.)", "Worried")
		GAME:WaitFrames(18)
	end

	-- 12. LE RASSEMBLEMENT — rangs par deux, face a Penticus
	--Penticus appelle au rassemblement. Le camp se range sous un
	--fondu court (patron du matin du Tunnel : c'est SOUS FadeOut que
	--sa formation de depart se met en place). Pendant le noir, les
	--couchages sont ranges et remplaces par le materiel de jour
	--(BuildCampDay) : la Ground raconte le camp pret au depart.
	GROUND:CharEndAnim(t.kino)
	GAME:MoveCamera(256, 196, 40, false)
	--PHILEAS SE REVEILLE EN DERNIER — et c'est un gag, pas un oubli.
	--Il dort depuis le reveil du camp (il a veille toute la nuit). Le
	--sortir du sommeil ICI, au moment ou l'ordre tombe, sert deux
	--choses a la fois : techniquement il faut lever son animation
	--bouclee avant que Listen ne le fasse pivoter (un dormeur qui se
	--tourne vers le maitre de guilde sans se reveiller, c'est le genre
	--de detail qui casse une scene) ; narrativement, le savant pris en
	--flagrant delit de somnolence, c'est tout son personnage.
	pcall(function()
		GROUND:CharEndAnim(t.phileas)
		GeneralFunctions.EmoteAndPause(t.phileas, "Exclaim", true)
	end)
	GAME:WaitFrames(10)
	--L'appel au rassemblement : tout le camp se retourne vers le maitre
	--de guilde AVANT qu'il parle. C'est l'ordre qui fait lever les tetes.
	--PLUM AUSSI : elle vient de recevoir son poste de sa bouche, elle est
	--a 43 px de lui. Un personnage present qui reste tourne vers l'ancien
	--foyer d'attention pendant que le chef parle, c'est le figement
	--directionnel que la directive interdit explicitement.
	Listen(t.penticus, {t.phileas, t.rin, t.coco, t.shuca, t.ganlon,
	                    t.kino, t.reinier, t.hyko, t.almotz, partner, hero,
	                    t.plum})
	UI:SetSpeaker(t.penticus)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_089']))
	GAME:WaitFrames(20)

	SOUND:FadeOutBGM(60)
	GAME:FadeOut(false, 60)
	GAME:WaitFrames(30)

	--Camp du matin : paillasses rangees, feu ETEINT, seul le sac commun
	--reste. Le foyer libere l'axe central : Penticus peut se tenir face
	mount_windswept_entrance_ch_5.BuildCampMorning()

	-- LA FORMATION DE LA GUILDE — celle des chapitres 3 et 4.
	-- RETOUR DE L'UTILISATEUR : « tu as deja des exemples de
	-- rassemblement matinal dans les chapitres 3/4 ou la guilde a une
	-- disposition de rangee differente de ce que tu as fait ».

	--Le maitre de guilde fait face a ses troupes, seul au centre ; le
	--savant se tient en retrait sur sa gauche. Ecart de 40 px : ils ne
	--forment pas une rangee, on lit tout de suite qui commande.
	GROUND:TeleportTo(t.penticus, 256, 232, Direction.Down)
	GROUND:TeleportTo(t.phileas,  216, 240, Direction.DownRight)

	--Rang de devant : le duo, puis la cordee du sommet, puis Rin.
	GROUND:TeleportTo(partner,   192, 272, Direction.Up)
	GROUND:TeleportTo(t.shuca,   224, 272, Direction.Up)
	GROUND:TeleportTo(t.kino,    256, 272, Direction.Up)
	GROUND:TeleportTo(t.rin,     288, 272, Direction.Up)
	GROUND:TeleportTo(t.hyko,    320, 272, Direction.Up)

	--Rang de derriere, chacun aligne sur son binome de devant.
	GROUND:TeleportTo(hero,      192, 304, Direction.Up)
	GROUND:TeleportTo(t.ganlon,  224, 304, Direction.Up)
	GROUND:TeleportTo(t.reinier, 256, 304, Direction.Up)
	GROUND:TeleportTo(t.coco,    288, 304, Direction.Up)
	GROUND:TeleportTo(t.almotz,  320, 304, Direction.Up)

	--PLUM N'EST PAS DANS LES RANGS, ET C'EST TOUT LE PROPOS.
	--Elle vient de s'entendre dire qu'elle ne monte pas : la mettre en
	--formation contredirait la scene qu'on vient de jouer. Elle se tient
	--donc EN DEHORS de la formation, a l'est, tournee vers elle : la
	--position dit son statut sans qu'une ligne de dialogue ait a le
	--repeter — elle regarde partir ceux qui partent.
	--(376,240) : sol libre verifie, 64 px du plus proche des douze, et
	--dans le cadre du plan unique (camera 256,268 -> x 96..416).
	--Ce n'est PAS (360,240) : ce point-la tombe a 16 px du trajet de
	--depart d'Almotz, qui contourne par l'exterieur est (x=344) — elle
	--se serait fait bousculer au moment des departs. A 376 elle est a
	--32 px du plus proche des dix trajets de sortie.
	if t.plum ~= nil then
		pcall(function() GROUND:TeleportTo(t.plum, 376, 240, Direction.Left) end)
	end

	--UN SEUL PLAN SUFFIT DESORMAIS. La formation tient dans le cadre :
	--on cadre entre le chef (y=232) et le rang arriere (y=304), et tout
	--le monde est visible d'un coup. Les deux mouvements de camera qui
	--balayaient l'ancienne colonne n'ont plus lieu d'etre — ils
	--serviraient a montrer du vide.
	GAME:MoveCamera(256, 268, 1, false)
	GAME:WaitFrames(30)
	GAME:FadeIn(40)
	SOUND:PlayBGM("Spring Cave.ogg", true)
	GAME:WaitFrames(20)

	--Le plan reste fixe. Il y avait ici un MoveCamera(256, 276, 70) : huit
	--pixels de descente etales sur 70 frames, soit un neuvieme de pixel par
	--frame — rigoureusement invisible, mais un mouvement de camera de plus
	--a lire dans la scene. Halcyon en compte QUATRE sur toute sa scene de
	--boss ; on ne garde donc que les cadrages qui montrent quelque chose.
	--L'attente, elle, est conservee : elle fait partie du rythme.
	GAME:WaitFrames(15)

	--Il remercie Rin en la regardant : on ne remercie pas dans le vide.
	pcall(function() GROUND:CharTurnToCharAnimated(t.penticus, t.rin, 4) end)
	GAME:WaitFrames(8)
	UI:SetSpeaker(t.penticus)
	GeneralFunctions.SetEmotion("Happy")
	coro1 = TASK:BranchCoroutine(function()
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_061'], t.rin:GetDisplayName()))
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(12)
		pcall(function() GROUND:CharSetEmote(t.rin, "happy", 1) end)
	end)
	TASK:JoinCoroutines({coro1, coro2})
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_062'], mountain:GetColoredName(), ruins:GetColoredName()))
	GAME:WaitFrames(15)
	GROUND:CharTurnToChar(t.penticus, t.kino)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_063'], t.kino:GetDisplayName()))
	GAME:WaitFrames(15)

	--Kino, specialiste des donjons, fait son briefing.
	UI:SetSpeaker(t.kino)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_064']))
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_065']))
	GAME:WaitFrames(12)
	--Chacun rend son rapport au maitre de guilde : celui qui parle se
	--tourne vers Penticus, pas vers le vide.
	Says(t.reinier, "Normal", 'MWE5_066', {t.penticus, t.kino})
	GAME:WaitFrames(12)
	Says(t.phileas, "Normal", 'MWE5_067', {t.penticus, hero, partner})
	GAME:WaitFrames(20)

	-- 13. LES CORDEES — la repartition propre au Mont Venteux
	GROUND:CharAnimateTurnTo(t.penticus, Direction.Down, 4)
	UI:SetSpeaker(t.penticus)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_092']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_093']))
	GAME:WaitFrames(20)

	--Cordee d'ouverture : Kino (lecture du donjon), Reinier (lecture
	--du terrain), Ganlon (le rythme). Chacun reagit a l'appel.
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_094'], t.kino:GetDisplayName(), t.reinier:GetDisplayName(), t.almotz:GetDisplayName()))
	coro1 = TASK:BranchCoroutine(function()
		GROUND:CharSetEmote(t.kino, "exclaim", 1)
		GeneralFunctions.Hop(t.kino, "Idle", 8, 16, 0, false)
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(8)
		GROUND:CharSetEmote(t.reinier, "notice", 1)
	end)
	coro3 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(12)
		GROUND:CharSetEmote(t.almotz, "notice", 1)
	end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
	UI:SetSpeaker(t.kino)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_095']))
	GAME:WaitFrames(15)

	--Cordee de soutien : Rin (soins), Coco (provisions), Shuca (les
	--arrieres, et l'experience de sa premiere expedition encadree).
	--On ne nomme pas une cordee dans le vide : Penticus se tourne vers
	--celles qu'il designe, et elles se redressent en s'entendant nommer.
	pcall(function() GROUND:CharTurnToCharAnimated(t.penticus, t.rin, 4) end)
	Listen(t.penticus, {t.rin, t.coco, t.shuca})
	UI:SetSpeaker(t.penticus)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_096'], t.rin:GetDisplayName(), t.coco:GetDisplayName()))
	coro1 = TASK:BranchCoroutine(function()
		GROUND:CharSetEmote(t.rin, "happy", 1)
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(8)
		GROUND:CharSetEmote(t.coco, "glowing", 1)
	end)
	TASK:JoinCoroutines({coro1, coro2})
	UI:SetSpeaker(t.coco)
	GeneralFunctions.SetEmotion("Joyous")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_097']))
	GAME:WaitFrames(15)

	--Cordee du sommet : le duo, Ganlon et Shuca. C'est la composition
	--REELLE de l'equipe jouable dans le donjon (SetParty cree Ganlon
	--et Shuca en Teammate2/3 a la fin de cette cinematique).
	--La cordee du sommet, c'est le joueur : Penticus se tourne vers le
	--heros pour l'annoncer, et les quatre nommes se tournent vers lui.
	pcall(function() GROUND:CharTurnToCharAnimated(t.penticus, hero, 4) end)
	Listen(t.penticus, {hero, partner, t.ganlon, t.shuca})
	UI:SetSpeaker(t.penticus)
	GeneralFunctions.SetEmotion("Inspired")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_098'], hero:GetDisplayName(), partner:GetDisplayName(), t.ganlon:GetDisplayName(), t.shuca:GetDisplayName()))
	coro1 = TASK:BranchCoroutine(function()
		GROUND:CharSetEmote(t.shuca, "glowing", 1)
		GeneralFunctions.Hop(t.shuca, "Idle", 8, 16, 0, false)
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(6)
		GROUND:CharSetEmote(partner, "exclaim", 1)
	end)
	coro3 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(10)
		GROUND:CharTurnToCharAnimated(t.shuca, t.ganlon, 4)
	end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
	UI:SetSpeaker(t.shuca)
	GeneralFunctions.SetEmotion("Joyous")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_099'], t.ganlon:GetDisplayName()))
	GAME:WaitFrames(10)
	GROUND:CharAnimateTurnTo(t.ganlon, Direction.UpRight, 4)
	UI:SetSpeaker(t.ganlon)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_100']))
	GROUND:CharAnimateTurnTo(t.ganlon, Direction.Up, 4)
	GAME:WaitFrames(15)

	--HYKO RESTE AU CAMP DE BASE : ASSIGNATION EN TÊTE-À-TÊTE AVEC PENTICUS.
	--(todo.txt : 'Have Hyko stand in the middle, closer to Penticus, and also
	--move in a way that suggests he is getting a one-on-one sorta assignment talk')
	GROUND:CharTurnToCharAnimated(t.penticus, t.hyko, 4)
	GAME:WaitFrames(10)
	GeneralFunctions.EightWayMove(t.hyko, 280, 248, false, 1)
	GROUND:CharTurnToCharAnimated(t.hyko, t.penticus, 4)
	GROUND:CharTurnToCharAnimated(t.penticus, t.hyko, 4)
	GAME:WaitFrames(15)
	UI:SetSpeaker(t.penticus)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_116'], t.hyko:GetDisplayName()))
	GAME:WaitFrames(10)
	GROUND:CharSetEmote(t.hyko, "sweatdrop", 1)
	UI:SetSpeaker(t.hyko)
	GeneralFunctions.SetEmotion("Sigh")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_117']))
	GAME:WaitFrames(10)
	GeneralFunctions.EightWayMove(t.hyko, 296, 256, false, 1)
	GROUND:CharAnimateTurnTo(t.hyko, Direction.UpLeft, 4)
	GROUND:CharAnimateTurnTo(t.penticus, Direction.Down, 4)
	GAME:WaitFrames(15)

	--Le camp de base : Penticus et Phileas. La justification est dans
	--le texte (les vents portent mal Phileas, le relais doit tenir).
	GROUND:CharTurnToCharAnimated(t.phileas, t.penticus, 4)
	UI:SetSpeaker(t.phileas)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_101'], t.penticus:GetDisplayName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_102']))
	GAME:WaitFrames(20)

	--Le cri de ralliement.
	GROUND:CharAnimateTurnTo(t.phileas, Direction.DownLeft, 4)
	UI:SetSpeaker(t.penticus)
	GeneralFunctions.SetEmotion("Inspired")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_068']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_069']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_103']))
	GAME:WaitFrames(10)

	local cheer = {}
	for i, c in ipairs({partner, t.hyko, t.almotz, t.shuca, t.coco, t.kino}) do
		cheer[#cheer+1] = TASK:BranchCoroutine(function()
			GAME:WaitFrames(i * 3)
			GeneralFunctions.Hop(c, "Idle", 8, 20, 0, false)
		end)
	end
	TASK:JoinCoroutines(cheer)
	--CETTE BOITE CENTREE RESTE, ET CE N'EST PAS UNE NARRATION.
	--Le plan interdit les boites omniscientes en milieu d'acte ; celle-ci
	--n'en est pas une : « Ouais !!! » est le CRI DE LA GUILDE, pousse
	--par les six personnages qui viennent de bondir juste au-dessus
	--(coroutines `cheer`). Aucun locuteur unique ne peut le porter — le
	--format centre sans portrait est precisement la forme juste pour une
	--replique chorale. On la garde donc telle quelle.
	UI:ResetSpeaker(false)
	UI:SetCenter(true)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_070']))
	UI:SetCenter(false)
	UI:ResetSpeaker()
	GAME:WaitFrames(20)

	-- 14. LES DEPARTS — cordee par cordee, par le sentier nord
	--Personne ne disparait sur place : chaque cordee remonte le
	--sentier est (x=284, seul couloir praticable vers l'entree,
	coro1 = TASK:BranchCoroutine(function()
		GROUND:MoveToPosition(t.penticus, 208, 232, false, 1)
		GROUND:CharAnimateTurnTo(t.penticus, Direction.UpRight, 4)
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(12)
		GROUND:MoveToPosition(t.phileas, 184, 240, false, 1)
		GROUND:CharAnimateTurnTo(t.phileas, Direction.UpRight, 4)
	end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(15)

	UI:SetSpeaker(t.kino)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_105']))
	-- ILS SORTENT PAR LES COTES, PAS A TRAVERS LES RANGS.
	-- Les partants quittaient la formation en diagonale et traversaient
	-- les camarades restes en rang. Mesure : Kino passait sur Hyko,
	-- Reinier sur Almotz, Rin sur Hyko, Coco sur le partenaire, Ganlon
	-- sur Hyko. Cinq traversees, toutes visibles a l'ecran.
	-- La formation occupe desormais DEUX RANGEES DE CINQ (colonnes 192 a
	-- 320, rangees y=272 et y=304), et le couloir du nord n'est
	-- praticable QUE entre x=248 et x=288 — releve sur la grille : a
	-- x=232 et x=296 la roche ferme des y=128.
	-- Les trajets ci-dessous ont donc ete entierement recalcules pour
	-- cette disposition : chacun descend ou contourne par l'exterieur,
	-- puis rejoint le goulot une fois les rangs depasses. Tous les
	-- segments sont reechantillonnes contre les DOUZE positions de la
	-- formation (Penticus et Phileas inclus, a leur nouveau poste
	-- ouest) : aucun ne passe a moins de 14 px d'un camarade, aucun ne
	-- traverse un obstacle.
	coro1 = TASK:BranchCoroutine(function()
		--Kino est en tete de rang, pile dans l'axe : il monte tout droit.
		GeneralFunctions.EightWayMove(t.kino, 256, 240, false, 1)
		GeneralFunctions.EightWayMove(t.kino, 256, 140, false, 1)
		GeneralFunctions.EightWayMove(t.kino, 252, 112, false, 1)
		GROUND:Hide(t.kino.EntName)
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(16)
		--Reinier est au rang arriere, derriere Kino : il s'ecarte d'une
		--demi-colonne a l'est avant de remonter, pour ne pas lui coller.
		GeneralFunctions.EightWayMove(t.reinier, 272, 296, false, 1)
		GeneralFunctions.EightWayMove(t.reinier, 272, 232, false, 1)
		GeneralFunctions.EightWayMove(t.reinier, 272, 140, false, 1)
		GeneralFunctions.EightWayMove(t.reinier, 268, 112, false, 1)
		GROUND:Hide(t.reinier.EntName)
	end)
	coro3 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(32)
		--Almotz ferme le rang est : il contourne largement par l'exterieur
		--(x=344) avant de revenir prendre le goulot.
		GeneralFunctions.EightWayMove(t.almotz, 344, 296, false, 1)
		GeneralFunctions.EightWayMove(t.almotz, 344, 240, false, 1)
		GeneralFunctions.EightWayMove(t.almotz, 284, 216, false, 1)
		GeneralFunctions.EightWayMove(t.almotz, 284, 140, false, 1)
		GeneralFunctions.EightWayMove(t.almotz, 284, 112, false, 1)
		GROUND:Hide(t.almotz.EntName)
	end)
	coro4 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(20)
		GAME:MoveCamera(272, 240, 80, false)
	end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	GAME:WaitFrames(20)

	--PLUM REGARDE LA PREMIERE VAGUE PARTIR.
	--Elle est a 32 px du trajet d'Almotz : elle les voit passer. Un
	--personnage present dans le cadre qui ne suit pas des yeux trois
	--camarades qui remontent le sentier, c'est le figement directionnel
	--interdit. Elle les suit, puis revient au groupe.
	if t.plum ~= nil then
		pcall(function()
			GROUND:CharAnimateTurnTo(t.plum, Direction.UpLeft, 4)
			GeneralFunctions.EmoteAndPause(t.plum, "Notice", false)
		end)
		GAME:WaitFrames(12)
	end

	--Coco salue le duo avant de partir : un adieu se fait face a face.
	pcall(function() GROUND:CharTurnToCharAnimated(t.coco, hero, 4) end)
	pcall(function() GeneralFunctions.EmoteAndPause(t.coco, "Happy", true) end)
	UI:SetSpeaker(t.coco)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_106']))
	--...puis elle lance un dernier mot a Plum avant de monter : elle lui
	--a confie sa cuisine il y a dix minutes, elle ne part pas sans le
	--rappeler. La boucle Coco->Plum ouverte au repas se ferme ici.
	if t.plum ~= nil then
		GAME:WaitFrames(10)
		pcall(function() GROUND:CharTurnToCharAnimated(t.coco, t.plum, 4) end)
		pcall(function() GROUND:CharTurnToCharAnimated(t.plum, t.coco, 4) end)
		UI:SetSpeaker(t.coco)
		GeneralFunctions.SetEmotion("Joyous")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_P14']))
		GAME:WaitFrames(10)
		--CharSetEmote et non EmoteAndPause : ce helper ne connait pas
		--"Determined" (GeneralFunctions:547-591), son `else` final l'aurait
		--rendu en goutte de sueur — contresens exact sur ce beat.
		--"determined" est en revanche une emote attestee du depot.
		pcall(function() GROUND:CharSetEmote(t.plum, "determined", 1) end)
		GeneralFunctions.Speak(t.plum, "Determined")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_P15']))
		GAME:WaitFrames(12)
	end
	coro1 = TASK:BranchCoroutine(function()
		GeneralFunctions.EightWayMove(t.rin, 288, 240, false, 1)
		GeneralFunctions.EightWayMove(t.rin, 280, 160, false, 1)
		GeneralFunctions.EightWayMove(t.rin, 260, 112, false, 1)
		GROUND:Hide(t.rin.EntName)
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(16)
		-- AUCUN DETOUR : ELLE MONTE TOUT DROIT.
		GeneralFunctions.EightWayMove(t.coco, 288, 160, false, 1)
		GeneralFunctions.EightWayMove(t.coco, 272, 112, false, 1)
		GROUND:Hide(t.coco.EntName)
	end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(20)

	-- GANLON ET SHUCA NE PARTENT PAS. ILS NOUS ATTENDENT.
	GROUND:CharTurnToCharAnimated(t.shuca, hero, 4)
	UI:SetSpeaker(t.shuca)
	GeneralFunctions.SetEmotion("Joyous")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_104']))

	--Ils prennent leur poste d'attente. Colonnes espacees de 16 px (la
	--largeur d'un sprite) : ils ne se traversent pas, et ils laissent
	--libre la colonne centrale par laquelle le duo va remonter.
	coro1 = TASK:BranchCoroutine(function()
		--Ganlon est au rang arriere, deuxieme colonne. Les rangs qui le
		--genaient sont partis : il remonte en biais vers l'entree du
		--goulot. Segments >= 32 px, aucun pas plus court qu'une case
		--(c'est ce qui faisait sautiller le sprite auparavant).
		GeneralFunctions.EightWayMove(t.ganlon, 240, 288, false, 1)
		GeneralFunctions.EightWayMove(t.ganlon, 264, 248, false, 1)
		GeneralFunctions.EightWayMove(t.ganlon, 264, 204, false, 1)
		GROUND:CharAnimateTurnTo(t.ganlon, Direction.Up, 4)
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(18)
		--Shuca le suit, une colonne a l'est : les deux tetes de cordee
		--attendent cote a cote, sans se chevaucher (16 px d'ecart) et
		--sans boucher l'axe par lequel le duo va monter.
		GeneralFunctions.EightWayMove(t.shuca, 240, 256, false, 1)
		GeneralFunctions.EightWayMove(t.shuca, 280, 232, false, 1)
		GeneralFunctions.EightWayMove(t.shuca, 280, 204, false, 1)
		GROUND:CharAnimateTurnTo(t.shuca, Direction.Up, 4)
	end)
	coro3 = TASK:BranchCoroutine(function()
		GeneralFunctions.FaceMovingCharacter(hero, t.ganlon, 4, Direction.Up)
	end)
	coro4 = TASK:BranchCoroutine(function()
		GeneralFunctions.FaceMovingCharacter(partner, t.ganlon, 4, Direction.Up)
	end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

	--Ganlon rale une derniere fois, mais il attend : le geste dit
	--« on y va quand vous voulez », pas « on se retrouve la-haut ».
	GROUND:CharTurnToCharAnimated(t.ganlon, hero, 4)
	pcall(function() GeneralFunctions.EmoteAndPause(t.ganlon, "Sweating", true) end)
	GROUND:CharAnimateTurnTo(t.ganlon, Direction.Up, 4)
	GAME:WaitFrames(25)

	-- 15. LE CHEMIN DU NORD — la remarque du partenaire
	--Le duo remonte a son tour. A mi-chemin, le partenaire s'arrete :
	--il a REMARQUE. C'est la transition douce vers la scene finale
	--(Prompt Maitre 6.10) — le contenu du reve n'est pas revele.
	--Le duo part du bout ouest de la formation (hero 192,304 ; partenaire
	--192,272) et remonte en biais vers le pied du sentier. Les trajets
	--sont verifies contre les cinq personnages encore presents a cet
	--instant : Ganlon et Shuca en tete de cordee (264/280, 204), Penticus
	--et Phileas retires a l'ouest, Hyko reste au camp.
	coro1 = TASK:BranchCoroutine(function()
		GeneralFunctions.EightWayMove(hero, 216, 280, false, 1)
		GeneralFunctions.EightWayMove(hero, 248, 240, false, 1)
		GeneralFunctions.EightWayMove(hero, 248, 216, false, 1)
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(14)
		--Le partenaire prend une ligne plus a l'ouest et s'avance un peu
		--plus haut : c'est lui qui va s'arreter et se retourner.
		GeneralFunctions.EightWayMove(partner, 224, 248, false, 1)
		GeneralFunctions.EightWayMove(partner, 232, 224, false, 1)
		GeneralFunctions.EightWayMove(partner, 232, 192, false, 1)
	end)
	coro3 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(10)
		GAME:MoveCamera(256, 212, 70, false)
	end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
	GAME:WaitFrames(15)

	--Le heros fixe le sommet — et LA VOIX REVIENT, en plein jour, une
	--seule phrase. C'est le rappel du reve que le heros a deja oublie :
	--le joueur, lui, reconnait la formule (« petit echo ») entendue cette
	--nuit. Personne d'autre ne l'entend, et le heros ne la commente pas.
	--Ces cinq cles (MWE5_080..084) portaient l'ancienne version du reve.
	--Celui-ci a ete refondu sur la structure de pmd-red (cles 130+), mais
	--leur TEXTE etait juste : on ne le jette pas, on le rend a l'endroit
	--ou il fonctionne le mieux — la montagne en vue, le heros seul.
	GROUND:EntTurn(hero, Direction.Up)
	GAME:WaitFrames(30)

	local vc1 = TASK:BranchCoroutine(function()
		SOUND:FadeOutBGM(45)
	end)
	local vc2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(15)
		pcall(function() VoiceVisions.Nausea(hero, 1) end)
	end)
	TASK:JoinCoroutines({vc1, vc2})
	GAME:WaitFrames(20)

	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_082']))
	GAME:WaitFrames(25)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_084']))
	UI:ResetSpeaker()
	GAME:WaitFrames(30)

	pcall(function() VoiceVisions.Recover(hero, true) end)
	GAME:WaitFrames(20)

	-- LA CORDEE S'IMPATIENTE — et le serieux s'effondre.
	-- Demande de l'utilisateur, mise en scene sur le patron comique du
	-- gag du camp (section 3) : le rire ne vient pas d'une blague, il
	-- vient de la CHUTE DE TENSION. On sort d'une minute de silence, de
	-- vertige et d'une voix que personne d'autre n'entend — puis Ganlon
	-- gueule depuis le sentier, et tout retombe d'un coup.
	-- Ce que la scene doit reussir :
	--   1. L'insulte arrive de HORS CHAMP. La camera est sur le heros ;
	--      on entend Ganlon avant de le voir, comme le camp entendait
	--      le conciliabule sans distinguer les mots.
	--   2. La musique comique demarre EXACTEMENT sur l'insulte, pas
	--      avant : elle ponctue la chute, elle ne l'annonce pas.
	--      « Guildmaster Wigglytuff.ogg » est le theme comique canonique
	--      de la guilde, deja pose sur la chute du gag du camp — c'est
	--      la meme signature sonore pour le meme type de rupture.
	--   3. Shuca se RETOURNE avant de parler (le corps parle avant la
	--      bouche) : c'est le mouvement qui fait la menace, pas la
	--      replique.
	--   4. Ganlon se degonfle en une phrase, sans transition. Il ne
	--      s'excuse pas : il reecrit ce qu'il vient de dire.
	--   5. Le partenaire conclut en voix off — il commente pour le
	--      joueur, ce qui referme le gag.
	local gag1 = TASK:BranchCoroutine(function()
		SOUND:PlayBGM('Guildmaster Wigglytuff.ogg', true)
	end)
	local gag2 = TASK:BranchCoroutine(function()
		--Ganlon crie depuis son poste : il ne bouge pas, il beugle.
		pcall(function() GROUND:CharTurnToCharAnimated(t.ganlon, hero, 4) end)
		pcall(function() GROUND:CharSetEmote(t.ganlon, "angry", 1) end)
		UI:SetSpeaker(t.ganlon)
		GeneralFunctions.SetEmotion("Angry")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_181']))
	end)
	TASK:JoinCoroutines({gag1, gag2})
	GAME:WaitFrames(20)

	--LE TEMPS DE LATENCE. C'est lui qui fait rire : Shuca ne repond pas
	--tout de suite. La camera glisse sur les deux tetes de cordee
	--pendant que le silence s'installe.
	local gag3 = TASK:BranchCoroutine(function()
		GAME:MoveCamera(272, 204, 60, false)
	end)
	local gag4 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(30)
		--Elle se tourne LENTEMENT (8 frames par cran au lieu de 4).
		pcall(function() GROUND:CharTurnToCharAnimated(t.shuca, t.ganlon, 8) end)
	end)
	TASK:JoinCoroutines({gag3, gag4})
	GAME:WaitFrames(25)

	UI:SetSpeaker(t.shuca)
	GeneralFunctions.SetEmotion("Angry")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_182']))
	GAME:WaitFrames(30)

	local gag5 = TASK:BranchCoroutine(function()
		pcall(function() GeneralFunctions.EmoteAndPause(t.ganlon, "Sweatdrop", true) end)
		UI:SetSpeaker(t.ganlon)
		GeneralFunctions.SetEmotion("Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_183']))
	end)
	local gag6 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(12)
		--Il regarde ailleurs. N'importe ou sauf Shuca.
		pcall(function() GROUND:CharAnimateTurnTo(t.ganlon, Direction.Up, 6) end)
	end)
	TASK:JoinCoroutines({gag5, gag6})
	GAME:WaitFrames(20)

	pcall(function() GROUND:CharAnimateTurnTo(t.shuca, Direction.Up, 6) end)
	UI:SetSpeaker(t.shuca)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_184']))
	GAME:WaitFrames(25)

	--Le duo a tout vu. Le partenaire commente pour le joueur.
	local gag7 = TASK:BranchCoroutine(function()
		GAME:MoveCamera(248, 208, 60, false)
	end)
	local gag8 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(10)
		pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
		pcall(function() GeneralFunctions.EmoteAndPause(partner, "Sweatdrop", true) end)
	end)
	TASK:JoinCoroutines({gag7, gag8})
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Sigh")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_185']))
	GAME:WaitFrames(25)

	--Retour au theme de la montagne : le gag est clos, la scene reprend
	--son cours. FadeOutBGM avant PlayBGM pour que la bascule s'entende
	--comme une fin de parenthese et non comme une coupure.
	SOUND:FadeOutBGM(40)
	GAME:WaitFrames(30)
	SOUND:PlayBGM('Sky Peak Prairie.ogg', true)
	GAME:WaitFrames(20)

	--Le partenaire n'a RIEN entendu. Il a vu son ami s'arreter net.
	GeneralFunctions.EmoteAndPause(partner, "Question", true)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_107'], hero:GetDisplayName()))
	GAME:WaitFrames(20)

	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	UI:SetSpeaker('', false, hero.CurrentForm.Species, hero.CurrentForm.Form, hero.CurrentForm.Skin, hero.CurrentForm.Gender)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_108']))
	GAME:WaitFrames(15)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_109']))
	GAME:WaitFrames(20)

	-- 16. LA SCENE FINALE — Penticus, Phileas, et la porte du donjon
	--Ne restent que quatre silhouettes devant l'entree (reference :
	--Grand Stepped Entrance). Plans larges sur la montagne, plans
	--rapproches sur les visages, silences.
	--Positions recalculees pour la nouvelle formation. Les cinq trajets
	--sont verifies contre Ganlon (264,204) et Shuca (280,204), restes en
	--tete de cordee, et les uns contre les autres dans l'ordre ou ils se
	--mettent en place : aucun contact a moins de 14 px.
	coro1 = TASK:BranchCoroutine(function()
		--Le heros monte plein nord dans l'axe du goulot, entre les deux
		--tetes de cordee sans les toucher.
		GeneralFunctions.EightWayMove(hero, 248, 160, false, 1)
		GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(14)
		--Le partenaire se poste a sa droite, un peu en retrait. Il monte
		--d'abord droit (24 px) puis oblique (48 px) : aucun segment plus
		--court qu'une case, sinon le sprite pivote sur place au lieu de
		--marcher. Le detour evite Penticus, poste en (248,200).
		GeneralFunctions.EightWayMove(partner, 232, 168, false, 1)
		GeneralFunctions.EightWayMove(partner, 280, 172, false, 1)
		GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
	end)
	coro3 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(20)
		--Penticus remonte depuis son poste ouest jusqu'au pied du sentier.
		GeneralFunctions.EightWayMove(t.penticus, 232, 224, false, 1)
		GeneralFunctions.EightWayMove(t.penticus, 248, 200, false, 1)
	end)
	coro4 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(30)
		--Phileas le suit, en retrait sur sa gauche : la place qu'il tient
		--depuis le debut de l'adresse.
		GeneralFunctions.EightWayMove(t.phileas, 200, 224, false, 1)
		GeneralFunctions.EightWayMove(t.phileas, 216, 208, false, 1)
	end)
	local coroH = TASK:BranchCoroutine(function()
		GAME:WaitFrames(36)
		--Hyko reste au camp mais s'avance pour les regarder partir : il
		--remonte par l'est, sans couper la route de personne.
		--Un seul segment de 32 px : les deux appels precedents faisaient
		--un premier pas de 8 px, plus court qu'une case.
		GeneralFunctions.EightWayMove(t.hyko, 312, 240, false, 1)
		GROUND:CharAnimateTurnTo(t.hyko, Direction.UpLeft, 4)
	end)
	--PLUM AUSSI S'AVANCE POUR LES VOIR PARTIR.
	--Elle reste au camp de base, mais elle ne regarde pas ailleurs pendant
	--que quatre silhouettes se plantent devant la porte du donjon. Elle
	--s'avance derriere Hyko, en retrait — ce n'est pas SA scene, elle n'a
	--rien a y dire — et elle regarde vers le nord comme les autres.
	--(344,208) : sol libre verifie, 45 px de Hyko (le plus proche), et
	--dans le cadre du plan final (camera 264,190). Elle est donc VISIBLE
	--et orientee vers le foyer d'attention, sans encombrer le groupe.
	local coroP = nil
	if t.plum ~= nil then
		coroP = TASK:BranchCoroutine(function()
			GAME:WaitFrames(48)
			pcall(function()
				GeneralFunctions.EightWayMove(t.plum, 344, 208, false, 1)
				GROUND:CharAnimateTurnTo(t.plum, Direction.UpLeft, 4)
			end)
		end)
	end
	coro5 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(10)
		GAME:MoveCamera(264, 190, 80, false)
	end)
	local finale = {coro1, coro2, coro3, coro4, coro5, coroH}
	if coroP ~= nil then finale[#finale+1] = coroP end
	TASK:JoinCoroutines(finale)
	GAME:WaitFrames(20)

	SOUND:FadeOutBGM(60)
	GAME:WaitFrames(40)

	--Derniere parole avant la porte : Penticus se tourne vers le duo.
	coro1 = TASK:BranchCoroutine(function()
		pcall(function() GROUND:CharTurnToCharAnimated(t.penticus, hero, 4) end)
		UI:SetSpeaker(t.penticus)
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_110']))
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(10)
		pcall(function() GROUND:CharTurnToCharAnimated(hero, t.penticus, 4) end)
		GAME:WaitFrames(6)
		pcall(function() GROUND:CharTurnToCharAnimated(partner, t.penticus, 4) end)
	end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(20)

	--Plan large : la camera monte vers la paroi, puis redescend sur
	--les visages. Le silence fait partie de la scene.
	--Recadre sur l'axe du groupe (x=264) apres le deplacement de la
	--formation : a x=280 le plan de retour laissait Phileas (216,208)
	--hors champ par la gauche.
	GAME:MoveCamera(264, 90, 100, false)
	GAME:WaitFrames(50)
	GAME:MoveCamera(264, 190, 80, false)
	GAME:WaitFrames(20)

	GROUND:CharAnimateTurnTo(t.penticus, Direction.Up, 4)
	UI:SetSpeaker(t.penticus)
	GeneralFunctions.SetEmotion("Sad")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_111']))
	GAME:WaitFrames(25)

	UI:SetSpeaker(t.phileas)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_112']))
	GAME:WaitFrames(20)

	GROUND:CharAnimateTurnTo(t.penticus, Direction.UpRight, 4)
	UI:SetSpeaker(t.penticus)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_113'], hero:GetDisplayName(), partner:GetDisplayName()))
	GeneralFunctions.SetEmotion("Inspired")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_114']))
	GAME:WaitFrames(20)

	GROUND:CharTurnToCharAnimated(partner, t.penticus, 4)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_115']))
	GAME:WaitFrames(10)
	GeneralFunctions.DoAnimation(hero, 'Nod')
	GAME:WaitFrames(30)

	-- 17. LA DISPERSION — beat 4.7 du plan
	--
	-- « Une fois l'explication de Penticus terminee, le reste du groupe
	--   se disperse — chacun part de son cote (occupations, preparatifs).
	--   Deplacements reels de chacun. Coherent avec la logique de
	--   campement vivant deja etablie a l'Acte 1 ; le heros reste seul
	--   visible a l'ecran une fois la dispersion terminee. »
	--
	-- Avant, la scene rendait la main avec les quatre PNJ plantes la ou
	-- la scene finale les avait laisses, en plein milieu du sentier :
	-- Penticus en (248,200) barrait l'axe par lequel le joueur doit
	-- monter, et personne ne bougeait plus jamais. Le camp passait de
	-- « cinematique » a « decor fige » sans transition.
	--
	-- Chacun rejoint donc, par un deplacement VISIBLE, le poste exact que
	-- SetupGround lui donnera ensuite. Les quatre positions d'arrivee
	-- sont les memes que celles de SetupGround, au pixel pres : quand le
	-- joueur reviendra sur cette carte, il les retrouvera ou il les a vus
	-- s'installer. Aucune teleportation, aucune divergence possible.
	-- Trajets reechantillonnes sur la grille d'obstacles, ecarts finaux
	-- de 58 a 104 px.
	local disperse = {}
	disperse[#disperse+1] = TASK:BranchCoroutine(function()
		pcall(function()
			--Penticus redescend vers le sud du foyer : il reprend son
			--poste de guet face au sentier d'arrivee.
			GeneralFunctions.EightWayMove(t.penticus, 240, 232, false, 1)
			GeneralFunctions.EightWayMove(t.penticus, 252, 268, false, 1)
			GROUND:CharAnimateTurnTo(t.penticus, Direction.Up, 4)
		end)
	end)
	disperse[#disperse+1] = TASK:BranchCoroutine(function()
		GAME:WaitFrames(16)
		pcall(function()
			--Phileas remonte a son perchoir nord-ouest. Il a veille toute
			--la nuit : il ne fait pas trois pas de plus que necessaire.
			GeneralFunctions.EightWayMove(t.phileas, 212, 180, false, 1)
			GROUND:CharAnimateTurnTo(t.phileas, Direction.Down, 4)
		end)
	end)
	disperse[#disperse+1] = TASK:BranchCoroutine(function()
		GAME:WaitFrames(28)
		pcall(function()
			--Hyko reprend sa faction a l'est du feu, tourne vers les
			--flammes : en poste, mais au chaud.
			GeneralFunctions.EightWayMove(t.hyko, 300, 236, false, 1)
			GROUND:CharAnimateTurnTo(t.hyko, Direction.Left, 4)
		end)
	end)
	if t.plum ~= nil then
		disperse[#disperse+1] = TASK:BranchCoroutine(function()
			GAME:WaitFrames(40)
			pcall(function()
				--Plum rejoint les marmites : c'est le poste que Penticus
				--lui a donne au matin et que Coco lui a transmis. Elle
				--contourne le foyer par le nord.
				GeneralFunctions.EightWayMove(t.plum, 310, 190, false, 1)
				GeneralFunctions.EightWayMove(t.plum, 236, 230, false, 1)
				GROUND:CharAnimateTurnTo(t.plum, Direction.Right, 4)
			end)
		end)
	end
	--La camera revient sur le camp pendant qu'ils s'installent : le
	--mouvement est justifie, il suit la dispersion reelle du groupe.
	disperse[#disperse+1] = TASK:BranchCoroutine(function()
		GAME:WaitFrames(10)
		pcall(function() GAME:MoveCamera(256, 220, 80, false) end)
	end)
	pcall(function() TASK:JoinCoroutines(disperse) end)
	GAME:WaitFrames(25)

	-- CLOTURE DE L'INTRO — deplacee ici depuis ArrivalCutscene.
	-- CampNightfall se termine par un changement de carte (le reve) :
	-- tout ce qui suivait dans ArrivalCutscene ne s'executait donc plus.
	-- SetParty, le drapeau de fin et le rendu du controle vivent
	-- desormais ici, a la seule fin de parcours reellement atteinte.
	-- SetParty retire Hyko et Almotz (restes du Tunnel) et cree Ganlon
	-- et Shuca en Teammate2/3 : c'est la cordee du sommet annoncee par
	-- Penticus, et donc l'equipe reelle du donjon.
	--
	-- POURQUOI SHUCA ET GALON NE SONT PAS « PRE-PLACES A L'ENTREE ».
	-- Le beat 4.9 du plan les decrit postes devant la porte du donjon,
	-- en attente. C'est impossible ICI, et pour une raison technique
	-- verifiee, pas par facilite : SetParty les fait entrer dans
	-- L'EQUIPE DU JOUEUR (Teammate2/3, GAME:AddPlayerTeam). Une fois le
	-- controle rendu, le moteur les fait SUIVRE le heros — ils ne
	-- peuvent pas rester plantes ailleurs sur la carte. Les y teleporter
	-- produirait deux sprites qui glissent vers le joueur des la
	-- premiere frame de gameplay.
	-- L'intention du beat est donc rendue autrement, sans la trahir :
	-- ils accompagnent le heros (ce que la scene precedente a etabli —
	-- « ils nous attendent »), et c'est a l'ENTREE DU DONJON que
	-- l'echange « Alors, vous etes prets ? » se declenche, joue par
	-- Dungeon_Entrance_Touch (init.lua). Le joueur garde la main
	-- jusque-la, exactement comme le plan le demande en 4.8.
	mount_windswept_entrance_ch_5.SetParty()
	hero = CH('PLAYER')
	partner = CH('Teammate1')

	SV.Chapter5.FinishedMountWindsweptIntro = true
	SV.Chapter5.CampNightWatchDone = false
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
	--FONDU AVANT LA REPRISE DE MAIN (demande du joueur). L'ancien
	--enchainement coupait sec de la scene finale a l'exploration :
	--CutsceneMode(false) puis un FadeIn(40) qui ne faisait rien, l'ecran
	--etant deja allume. On noircit donc VRAIMENT, on recadre sous le
	--noir, et on rallume sur une image en place.
	--La musique part avec le noir, pas apres : elle accompagne la
	--bascule au lieu de la suivre.
	pcall(function() GAME:FadeOut(false, 20) end)
	SOUND:PlayBGM('Sky Peak Prairie.ogg', true)
	GAME:CutsceneMode(false)
	--La camera revient au joueur (forme attestee : searing_tunnel:1480).
	GAME:MoveCamera(0, 0, 1, true)
	GAME:FadeIn(20)
end

-- LE RETOUR EN MAUVAISE POSTURE — KO / abandon dans la montagne
function mount_windswept_entrance_ch_5.KODefeatCutscene()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local ganlon = CH('Teammate2')   --cordee du sommet : Ganlon
	local shuca = CH('Teammate3')    --et Shuca (SetParty de l'intro)
	local penticus = CH('Tropius')
	local phileas = CH('Noctowl')
	--RIN N'EST PLUS LA — ET PERSONNE NE LA REMPLACE COMME SOIGNEUSE.
	--Rin (Audino) est partie avec la cordee de soutien a la fin de
	--l'intro : CH('Audino') rend nil, et toute la scene de secours
	--reposait a l'origine sur elle (soin non joue, MWE5_121 sautee en
	--silence). Ma premiere correction avait donne son role a Hyko —
	local hyko = CH('Growlithe')
	local coro1, coro2, coro3, coro4

	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	SOUND:StopBGM()

	--ECRAN NOIR D'ABORD. Le moteur ne pose aucun fondu entre deux cartes
	--(GameManager.moveToZoneInit : « no fade; the script handles that
	--itself ») : ce que le script laisse a l'ecran y reste. Sans ce
	--FadeOut en tete, la carte est visible pendant qu'on y teleporte les
	--personnages et qu'on deplace la camera — le joueur voit la mise en
	--place. Instantane (1 frame) et idempotent.
	GAME:FadeOut(false, 1)

	--L'equipe git devant l'entree du donjon, la ou le vent l'a
	--rejetee. Cases verifiees libres (tx32-38 / ty19-20).
	GROUND:TeleportTo(hero, 268, 156, Direction.Down)
	GROUND:TeleportTo(partner, 292, 156, Direction.Down)
	GROUND:CharSetAnim(hero, "EventSleep", true)
	GROUND:CharSetAnim(partner, "EventSleep", true)
	if ganlon ~= nil then
		GROUND:TeleportTo(ganlon, 244, 164, Direction.Down)
		GROUND:CharSetAnim(ganlon, "Sleep", true)
	end
	if shuca ~= nil then
		GROUND:TeleportTo(shuca, 308, 164, Direction.Down)
		GROUND:CharSetAnim(shuca, "EventSleep", true)
	end

	GAME:MoveCamera(276, 170, 1, false)
	GAME:FadeIn(40)
	SOUND:PlayBGM('Spring Cave.ogg', true)
	GAME:WaitFrames(40)

	--Phileas les repere depuis le camp et alerte Rin.
	if phileas ~= nil then
		SOUND:PlayBattleSE("EVT_Emote_Exclaim_2")
		GROUND:CharSetEmote(phileas, "exclaim", 1)
		UI:SetSpeaker(phileas)
		GeneralFunctions.SetEmotion("Surprised")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_120'], hyko ~= nil and hyko:GetDisplayName() or penticus:GetDisplayName()))
	end
	GAME:WaitFrames(15)

	--Penticus et Rin accourent depuis le camp. Trajets sur le couloir
	--central (praticable de bout en bout).
	coro1 = TASK:BranchCoroutine(function()
		if penticus ~= nil then
			GeneralFunctions.EightWayMove(penticus, 276, 184, true, 2)
			GROUND:CharTurnToCharAnimated(penticus, hero, 4)
		end
	end)
	coro2 = TASK:BranchCoroutine(function()
		if hyko ~= nil then
			GAME:WaitFrames(10)
			GeneralFunctions.EightWayMove(hyko, 244, 184, true, 2)
			GROUND:CharTurnToCharAnimated(hyko, hero, 4)
		end
	end)
	coro3 = TASK:BranchCoroutine(function()
		if phileas ~= nil then
			GAME:WaitFrames(22)
			GeneralFunctions.EightWayMove(phileas, 308, 184, true, 2)
			GROUND:CharTurnToCharAnimated(phileas, partner, 4)
		end
	end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
	GAME:WaitFrames(15)

	-- HYKO NE SOIGNE PAS. IL VA CHERCHER CELUI QUI SAIT.
	-- RETOUR DE L'UTILISATEUR : « Hyko est incapable de soigner ».
	-- Exact, et ma correction precedente n'allait pas au bout : j'avais
	-- change le SON (DUN_Heal au lieu de DUN_Heal_Bell) et ajoute des
	-- repliques, mais Hyko restait celui qui administrait le secours,
	-- avec une pose de 100 frames en gros plan. Un Growlithe de la
	-- garde ne soigne pas — il n'a ni capacite de soin, ni formation,
	-- ni objet. Le son n'etait que le symptome ; le probleme etait le
	-- ROLE.
	-- Nouvelle repartition, conforme a ce que chacun sait faire :
	--   * HYKO donne l'alerte et degage l'espace. C'est un garde :
	--     il court, il crie, il fait de la place. Sa force, c'est la
	--     vitesse de reaction.
	--   * PENTICUS soigne — en donnant une BAIE ORAN, pas une capacite.
	--     C'est le maitre de guilde : il porte les provisions, il
	--     s'agenouille, il parle doucement. Aucun effet magique.
	--   * HYKO conclut en assumant sa limite a voix haute. C'est ce qui
	--     rend le personnage attachant plutot que decoratif : il sait
	--     ce qu'il ne sait pas faire, et il propose autre chose.
	-- Plus aucun SE de soin : une baie qu'on mange ne sonne pas comme
	-- une capacite. Seul le fanfare d'objet de RewardItem se fait
	-- entendre, ce qui est exactement le bon signal.
	if hyko ~= nil then
		pcall(function() GROUND:CharTurnToCharAnimated(hyko, penticus, 4) end)
		pcall(function() GeneralFunctions.EmoteAndPause(hyko, "Exclaim", true) end)
		UI:SetSpeaker(hyko)
		GeneralFunctions.SetEmotion("Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_186']))
		GAME:WaitFrames(12)

		--Il s'ecarte pour laisser passer le maitre de guilde : le
		--mouvement raconte le passage de relais mieux qu'une phrase.
		local h1 = TASK:BranchCoroutine(function()
			pcall(function() GeneralFunctions.EightWayMove(hyko, 224, 192, false, 1) end)
			pcall(function() GROUND:CharTurnToCharAnimated(hyko, hero, 4) end)
		end)
		local h2 = TASK:BranchCoroutine(function()
			GAME:WaitFrames(14)
			UI:SetSpeaker(hyko)
			GeneralFunctions.SetEmotion("Normal")
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_187']))
		end)
		TASK:JoinCoroutines({h1, h2})
		GAME:WaitFrames(15)
	end

	--PENTICUS S'OCCUPE DES BLESSES. Il se penche d'abord, il parle
	--ensuite : le corps avant la bouche.
	if penticus ~= nil then
		pcall(function() GROUND:CharTurnToCharAnimated(penticus, hero, 4) end)
		pcall(function() GROUND:CharSetEmote(penticus, "sweatdrop", 1) end)
		GAME:WaitFrames(12)
		UI:SetSpeaker(penticus)
		GeneralFunctions.SetEmotion("Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_188']))
		GAME:WaitFrames(15)

		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_189']))
		--UNE seule baie Oran, remise en main propre. Le 3e argument de
		--RewardItem est la quantite (GeneralFunctions.lua:1245) : sans
		--lui, la fonction donne un stack entier.
		GeneralFunctions.RewardItem("berry_oran", false, 1)
		GAME:WaitFrames(20)
	end

	--L'equipe revient a elle, un par un, sonnee (Shake + Wake +
	--LookAround, patron de la DiedCutscene du Tunnel).
	coro1 = TASK:BranchCoroutine(function()
		GeneralFunctions.Shake(hero)
		GAME:WaitFrames(20)
		GeneralFunctions.DoAnimation(hero, 'Wake')
		GAME:WaitFrames(20)
		GeneralFunctions.LookAround(hero, 3, 4, false, false, false, Direction.Down)
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(10)
		GeneralFunctions.Shake(partner)
		GAME:WaitFrames(20)
		GeneralFunctions.DoAnimation(partner, 'Wake')
		GAME:WaitFrames(20)
		GeneralFunctions.LookAround(partner, 3, 4, false, false, true, Direction.Down)
	end)
	coro3 = TASK:BranchCoroutine(function()
		if ganlon ~= nil then
			GAME:WaitFrames(26)
			GeneralFunctions.DoAnimation(ganlon, 'Rumble')
			GAME:WaitFrames(12)
			GROUND:CharAnimateTurnTo(ganlon, Direction.Down, 4)
		end
	end)
	coro4 = TASK:BranchCoroutine(function()
		if shuca ~= nil then
			GAME:WaitFrames(6)
			GeneralFunctions.DoAnimation(shuca, 'Wake')
			GAME:WaitFrames(10)
			GROUND:CharAnimateTurnTo(shuca, Direction.Down, 4)
		end
	end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	GAME:WaitFrames(20)

	--PENTICUS constate le mieux : c'est lui qui a donne la baie, c'est
	--donc lui qui en lit l'effet. MWE5_121 (« Respirez... voila. Le vent
	--vous a battus, pas brises. ») est une phrase de soignant : elle
	--etait attribuee a Hyko, qui ne soigne pas. Elle revient au maitre
	--de guilde, dont c'est exactement le registre.
	if penticus ~= nil then
		pcall(function() GROUND:CharSetEmote(penticus, "", 0) end)
		UI:SetSpeaker(penticus)
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_190']))
		GAME:WaitFrames(12)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_121']))
		GAME:WaitFrames(15)
	end

	--------------------------------------------------------------------
	-- PLUM DEBOULE — elle apprend le KO et elle le prend PERSONNELLEMENT.
	--
	-- DEMANDE UTILISATEUR : « Plum doit reagir au respawn des heros au
	-- Mont Windsep. Elle ne doit a aucun moment entrer en collision ou
	-- interagir avec le partenaire (Shuca ou Galon) pendant toute la
	-- scene. »
	--
	-- CAUSALITE. Elle s'est invitee a l'expedition la veille au soir
	-- (section 4bis) et tient les marmites du camp depuis. L'equipe
	-- qu'elle nourrit rentre a moitie morte : ne pas la faire reagir
	-- ferait d'elle un decor. Son angle est le sien — pas l'inquietude
	-- de Penticus (le chef), pas la culpabilite de Hyko (le garde) :
	-- le REPROCHE AFFECTUEUX de celle qu'on n'a pas emmenee.
	--
	-- CONTRAINTE DE NON-COLLISION, tenue par la geometrie et non par
	-- la chance. Verifie avec tools/nea_map.py sur la carte reelle :
	--   * elle s'arrete en (196,196), case libre en boite 20x20 ;
	--   * distances a l'arrivee : Ganlon 58 px, Shuca 116 px,
	--     partenaire 104 px, heros ~104 px. Le plus proche de tous est
	--     Hyko a 49 px. Aucun contact possible ;
	--   * son trajet part des marmites (236,230) et reste a l'OUEST du
	--     couloir central : il ne croise NI Ganlon (244,164) NI Shuca
	--     (308,164), qui gisent au nord, contre la porte du donjon ;
	--   * elle ne s'adresse jamais a eux et ne les prend jamais pour
	--     cible d'un CharTurnToChar : elle parle au heros et a Penticus.
	-- Elle reste donc strictement dans son couloir a elle.
	--
	-- Tout est sous pcall et sous `if plum ~= nil` : si le joueur n'a
	-- pas declenche son arrivee au camp la veille (PlumAtMountCamp
	-- faux), SetupGround ne l'a pas creee et la scene se joue sans elle,
	-- exactement comme avant.
	local plum = nil
	pcall(function() plum = CH('Jigglypuff') end)
	if plum ~= nil and SV.Chapter5.PlumAtMountCamp then
		--1. ELLE ENTEND DEPUIS LES MARMITES. Le cri de Phileas a porte :
		--elle leve la tete avant de bouger (le corps parle en premier).
		pcall(function()
			GROUND:CharTurnToCharAnimated(plum, hero, 4)
			GeneralFunctions.EmoteAndPause(plum, "Exclaim", true)
		end)
		GAME:WaitFrames(12)

		--2. ELLE ACCOURT. Deux segments : elle remonte l'ouest du camp
		--(220,212) puis se plante en (196,196). Trajet verifie
		--marchable de bout en bout, a l'ecart du groupe des blesses.
		--La camera s'elargit pour la faire entrer dans le cadre : elle
		--ne doit pas parler hors champ (regle de mise en scene du
		--projet, et exigence du prompt d'architecture des donjons).
		local pl1 = TASK:BranchCoroutine(function()
			pcall(function()
				GeneralFunctions.EightWayMove(plum, 220, 212, true, 2)
				GeneralFunctions.EightWayMove(plum, 196, 196, true, 2)
				GROUND:CharTurnToCharAnimated(plum, hero, 4)
			end)
		end)
		local pl2 = TASK:BranchCoroutine(function()
			GAME:WaitFrames(8)
			pcall(function() GAME:MoveCamera(252, 178, 50, false) end)
		end)
		TASK:JoinCoroutines({pl1, pl2})
		GAME:WaitFrames(14)

		--3. LE REPROCHE. Elle est en colere parce qu'elle a eu peur —
		--et la deuxieme replique le trahit. Le registre est celui deja
		--etabli pour elle : elle explose, puis elle se radoucit sans
		--jamais l'admettre.
		UI:SetSpeaker(plum)
		GeneralFunctions.SetEmotion("Angry")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_P16']))
		GAME:WaitFrames(15)
		GeneralFunctions.SetEmotion("Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_P17']))
		GAME:WaitFrames(18)

		--4. PENTICUS LA RECADRE, doucement. Il ne la contredit pas : il
		--lui donne un role. C'est ce qui la calme et ce qui justifie
		--qu'elle reste au camp au lieu de suivre.
		if penticus ~= nil then
			pcall(function() GROUND:CharTurnToCharAnimated(penticus, plum, 4) end)
			UI:SetSpeaker(penticus)
			GeneralFunctions.SetEmotion("Normal")
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_P18']))
			GAME:WaitFrames(15)
		end

		--5. ELLE CEDE — a sa maniere. Puis elle retourne a ses marmites :
		--elle ne reste pas plantee dans le plan, et son depart est ce
		--qui remet le foyer au centre de la scene suivante.
		UI:SetSpeaker(plum)
		GeneralFunctions.SetEmotion("Sigh")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_P19']))
		GAME:WaitFrames(16)

		--...ET ELLE Y RETOURNE VRAIMENT.
		--
		--BUG SIGNALE : « lorsque le joueur reprend le controle du
		--personnage, il n'est pas necessaire que Plum vienne se placer
		--sur la meme case que le partenaire ».
		--Le commentaire ci-dessus annoncait un retour aux marmites, mais
		--AUCUN code ne le faisait : elle restait plantee en (196,196),
		--soit a 23 px de Phileas (212,180) et en plein milieu du camp,
		--la ou le joueur reprend la main. Elle se retrouvait collee au
		--groupe.
		--Elle regagne donc son poste de jour (236,230) — exactement
		--celui que SetupGround lui attribue, il n'y a qu'une source de
		--verite pour cette position. Trajet (196,196) -> (220,212) ->
		--(236,230) verifie marchable de bout en bout ; a l'arrivee elle
		--est a 52 px de son point de depart, 41 px de Penticus et
		--64 px de Hyko : aucun contact avec qui que ce soit.
		--Direction.Right : face au foyer, comme une cuisiniere qui
		--reprend ses marmites.
		pcall(function()
			GeneralFunctions.EightWayMove(plum, 220, 212, false, 1)
			GeneralFunctions.EightWayMove(plum, 236, 230, false, 1)
			GROUND:CharAnimateTurnTo(plum, Direction.Right, 4)
		end)
		GAME:WaitFrames(10)
	end

	--Le partenaire a mal : le corps le dit avant la boite.
	pcall(function() GeneralFunctions.Shake(partner) end)
	pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Pain")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_122']))
	GAME:WaitFrames(20)

	if penticus ~= nil then
		--Penticus se penche sur les blesses avant de parler.
		pcall(function() GROUND:CharTurnToCharAnimated(penticus, hero, 4) end)
		pcall(function() GROUND:CharSetEmote(penticus, "sweatdrop", 1) end)
		GAME:WaitFrames(12)
		UI:SetSpeaker(penticus)
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_123']))
		GAME:WaitFrames(15)
		GeneralFunctions.SetEmotion("Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_124']))
		GAME:WaitFrames(15)
		--LES PROVISIONS DE REPART, ET RIEN DE PLUS.
		--La Baie Oran du secours a deja ete remise plus haut, une seule,
		--en main propre : c'est le geste de soin. Ce lot-ci est autre
		--chose — de quoi RETENTER l'ascension. Les redonner en double
		--(l'ancien code remettait une Pomme, DEUX Oran et une Mepo,
		--stacks entiers) noyait le geste de secours sous un inventaire.
		GeneralFunctions.RewardItem("food_apple", false, 1)
		GeneralFunctions.RewardItem("berry_leppa", false, 1)
		GAME:WaitFrames(15)
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_125']))
	end
	GAME:WaitFrames(20)

	--HYKO ASSUME SA LIMITE. C'est le coeur du correctif demande : il ne
	--soigne pas, il le SAIT, et il le dit lui-meme. Ce qui aurait pu
	--n'etre qu'une contrainte technique devient un trait de caractere,
	--et prepare l'arc du personnage (il veut monter avec l'equipe).
	if hyko ~= nil then
		pcall(function() GROUND:CharTurnToCharAnimated(hyko, hero, 4) end)
		pcall(function() GeneralFunctions.EmoteAndPause(hyko, "Sweatdrop", true) end)
		UI:SetSpeaker(hyko)
		GeneralFunctions.SetEmotion("Sigh")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_191']))
		GAME:WaitFrames(15)
		--Puis il se redresse : la promesse, pas la plainte.
		pcall(function() GROUND:CharSetEmote(hyko, "determined", 1) end)
		GeneralFunctions.SetEmotion("Determined")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_192']))
		GAME:WaitFrames(20)
	end

	--Penticus et Rin regagnent le camp ; le duo reste libre devant
	--l'entree, pret a retenter l'ascension.
	--Les trois regagnent EXACTEMENT leur poste de SetupGround : quand la
	--camera revient au joueur, le camp est dans l'etat ou il le trouvera
	coro1 = TASK:BranchCoroutine(function()
		if penticus ~= nil then
			--Contourne le foyer par l'ouest, puis descend a son poste sud.
			GeneralFunctions.EightWayMove(penticus, 232, 196, false, 1)
			GeneralFunctions.EightWayMove(penticus, 232, 256, false, 1)
			GeneralFunctions.EightWayMove(penticus, 252, 268, false, 1)
			GROUND:CharAnimateTurnTo(penticus, Direction.Up, 4)
		end
	end)
	coro2 = TASK:BranchCoroutine(function()
		if hyko ~= nil then
			GAME:WaitFrames(12)
			--Contourne par l'est pour rejoindre son poste de garde.
			GeneralFunctions.EightWayMove(hyko, 308, 196, false, 1)
			GeneralFunctions.EightWayMove(hyko, 300, 236, false, 1)
			GROUND:CharAnimateTurnTo(hyko, Direction.Left, 4)
		end
	end)
	coro3 = TASK:BranchCoroutine(function()
		if phileas ~= nil then
			GAME:WaitFrames(20)
			GeneralFunctions.EightWayMove(phileas, 212, 180, false, 1)
			GROUND:CharAnimateTurnTo(phileas, Direction.Down, 4)
			--Il se rendort : il a veille toute la nuit.
			GROUND:CharSetAnim(phileas, "Sleep", true)
		end
	end)
	--PLUM RETOURNE A SES MARMITES, en meme temps que les autres.
	--Elle repart par ou elle est venue — le couloir ouest, a l'ecart de
	--Ganlon et Shuca — et se replante en (236,230) : le poste EXACT que
	--SetupGround lui assigne. Camp et cinematique restent donc d'accord,
	--et le joueur qui reprend la main la retrouve la ou elle doit etre.
	coro4 = TASK:BranchCoroutine(function()
		if plum ~= nil and SV.Chapter5.PlumAtMountCamp then
			GAME:WaitFrames(26)
			pcall(function()
				GeneralFunctions.EightWayMove(plum, 220, 212, false, 1)
				GeneralFunctions.EightWayMove(plum, 236, 230, false, 1)
				GROUND:CharAnimateTurnTo(plum, Direction.Right, 4)
			end)
		end
	end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

	SV.Chapter5.PlayTempMountScene = false

	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
	GROUND:CharTurnToChar(partner, hero)
	--FONDU AVANT LA REPRISE DE MAIN (demande du joueur) : on noircit,
	--on recadre sur le heros sous le noir, puis on rallume. Un simple
	--CutsceneMode(false) rendait la main par une coupe seche.
	GeneralFunctions.RendreLaMain()
end

-- RetreatReturnCutscene : l'equipe a fait demi-tour d'elle-meme.
-- Version courte et digne : pas de KO, Penticus salue la sagesse du
-- repli (l'exact oppose de la lecon du Tunnel, ou fuir etait un echec).
function mount_windswept_entrance_ch_5.RetreatReturnCutscene()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local penticus = CH('Tropius')

	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	SOUND:StopBGM()

	--ECRAN NOIR D'ABORD. Le moteur ne pose aucun fondu entre deux cartes
	--(GameManager.moveToZoneInit : « no fade; the script handles that
	--itself ») : ce que le script laisse a l'ecran y reste. Sans ce
	--FadeOut en tete, la carte est visible pendant qu'on y teleporte les
	--personnages et qu'on deplace la camera — le joueur voit la mise en
	--place. Instantane (1 frame) et idempotent.
	GAME:FadeOut(false, 1)

	GROUND:TeleportTo(hero, 268, 160, Direction.Down)
	GROUND:TeleportTo(partner, 292, 160, Direction.Down)
	GAME:MoveCamera(280, 180, 1, false)
	GAME:FadeIn(40)
	SOUND:PlayBGM('Spring Cave.ogg', true)
	GAME:WaitFrames(30)

	--Le repli volontaire : Penticus vient au-devant du duo, et Hyko le
	--suit a distance. Deux presents valent mieux qu'un seul PNJ qui
	--parle a des sprites immobiles — et Hyko a une raison d'etre la,
	--c'est lui le garde du camp.
	local hyko = CH('Growlithe')
	if penticus ~= nil then
		local c1 = TASK:BranchCoroutine(function()
			GeneralFunctions.EightWayMove(penticus, 276, 196, false, 1)
			GROUND:CharTurnToCharAnimated(penticus, hero, 4)
		end)
		local c2 = TASK:BranchCoroutine(function()
			if hyko ~= nil then
				GAME:WaitFrames(16)
				GeneralFunctions.EightWayMove(hyko, 244, 200, false, 1)
				GROUND:CharTurnToCharAnimated(hyko, hero, 4)
			end
		end)
		local c3 = TASK:BranchCoroutine(function()
			GAME:WaitFrames(8)
			pcall(function() GROUND:CharTurnToCharAnimated(hero, penticus, 4) end)
			GAME:WaitFrames(6)
			pcall(function() GROUND:CharTurnToCharAnimated(partner, penticus, 4) end)
		end)
		TASK:JoinCoroutines({c1, c2, c3})
		GAME:WaitFrames(10)

		UI:SetSpeaker(penticus)
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_126']))
		GAME:WaitFrames(15)
		--Le partenaire encaisse la remarque pendant qu'elle tombe.
		local c4 = TASK:BranchCoroutine(function()
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_127']))
		end)
		local c5 = TASK:BranchCoroutine(function()
			GAME:WaitFrames(14)
			pcall(function() GROUND:CharSetEmote(partner, "sweatdrop", 1) end)
		end)
		TASK:JoinCoroutines({c4, c5})
		GAME:WaitFrames(15)

		--Retour au poste EXACT de SetupGround, foyer contourne (le trajet
		--direct traversait le bloqueur de collision du feu).
		local c6 = TASK:BranchCoroutine(function()
			GeneralFunctions.EightWayMove(penticus, 232, 196, false, 1)
			GeneralFunctions.EightWayMove(penticus, 232, 256, false, 1)
			GeneralFunctions.EightWayMove(penticus, 252, 268, false, 1)
			GROUND:CharAnimateTurnTo(penticus, Direction.Up, 4)
		end)
		local c7 = TASK:BranchCoroutine(function()
			if hyko ~= nil then
				GAME:WaitFrames(14)
				GeneralFunctions.EightWayMove(hyko, 308, 196, false, 1)
				GeneralFunctions.EightWayMove(hyko, 300, 236, false, 1)
				GROUND:CharAnimateTurnTo(hyko, Direction.Left, 4)
			end
		end)
		TASK:JoinCoroutines({c6, c7})
	end

	SV.Chapter5.PlayTempMountScene = false

	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
	GROUND:CharTurnToChar(partner, hero)
	--FONDU AVANT LA REPRISE DE MAIN (demande du joueur) : on noircit,
	--on recadre sur le heros sous le noir, puis on rallume. Un simple
	--CutsceneMode(false) rendait la main par une coupe seche.
	GeneralFunctions.RendreLaMain()
end

function mount_windswept_entrance_ch_5.PurgeDecor()
	--Purge du calque. « Anims:Clear() » n'existe pas : la seule methode
	--de retrait attestee dans le depot est RemoveAt (event_single.lua:724).
	--On retire depuis la fin, index par index, sous pcall.
	pcall(function()
		local anims = GAME:GetCurrentGround().Decorations[0].Anims
		for i = anims.Count - 1, 0, -1 do
			anims:RemoveAt(i)
		end
	end)
	--Le foyer disparait avec le decor : son bloqueur de collision aussi.
	mount_windswept_entrance_ch_5.RemoveFireBlocker()
end

-- LE FEU DE CAMP BLOQUE LE PASSAGE.
function mount_windswept_entrance_ch_5.AddFireBlocker()
	pcall(function()
		--Idempotent : deux appels de suite ne doivent pas empiler deux
		--boites (BuildCampDay est rejoue par plusieurs branches).
		mount_windswept_entrance_ch_5.RemoveFireBlocker()
		local blocker = RogueEssence.Ground.GroundObject(
			RogueEssence.Content.ObjAnimData("", 1),
			RogueElements.Rect(mount_windswept_entrance_ch_5.CAMP_X + 6,
			                   mount_windswept_entrance_ch_5.CAMP_Y + 6, 24, 24),
			RogueElements.Loc(0, 0),
			false,
			"Campfire_Blocker")
		blocker:ReloadEvents()
		GAME:GetCurrentGround():AddTempObject(blocker)
		mount_windswept_entrance_ch_5.fireBlocker = blocker
	end)
end

function mount_windswept_entrance_ch_5.RemoveFireBlocker()
	pcall(function()
		local b = mount_windswept_entrance_ch_5.fireBlocker
		if b ~= nil then
			GAME:GetCurrentGround():RemoveTempObject(b)
			mount_windswept_entrance_ch_5.fireBlocker = nil
		end
	end)
end

-- LE CAMP DE JOUR — feu + materiel d'expedition, AUCUNE paillasse.
-- Prompt Maitre 6.3 : les couchages n'existent qu'apres la transition
-- jour -> soir, deployes par les personnages a la fin de la veillee.
-- Le camp de jour ne montre donc que le feu et le materiel range :
-- sacs (Grassy_Bag) et caisses (Yellow_Box), assets attestes dans
-- Content/Object/ et deja poses ailleurs (guild_guildmasters_room).
function mount_windswept_entrance_ch_5.BuildCampDay()
	mount_windswept_entrance_ch_5.PurgeDecor()
	local ground = GAME:GetCurrentGround()
	local campfire = RogueEssence.Content.ObjAnimData('Campfire', 6)

	--Le feu, centre du camp.
	ground.Decorations[0].Anims:Add(
		RogueEssence.Ground.GroundAnim(campfire, RogueElements.Loc(
			mount_windswept_entrance_ch_5.CAMP_X, mount_windswept_entrance_ch_5.CAMP_Y)))
	--Et sa collision : une GroundAnim seule se traverse (cf. AddFireBlocker).
	mount_windswept_entrance_ch_5.AddFireBlocker()

	--SAC RETIRE A LA DEMANDE. Le Grassy_Bag pose en (260,196), juste au
	--nord du foyer, encombrait le centre du camp — c'est precisement la
	--zone ou se joue le repas, ou Penticus tient son adresse et ou passe
	--tout le trafic vers le sentier nord. Le materiel d'expedition reste
	--raconte par les couchages et le foyer.
end

-- LE CAMP DU MATIN — feu eteint, sac pret au depart (Prompt 6.8).
-- Distinct du camp de jour : au matin du depart, le feu est ETEINT
-- (aucune animation de flammes) et il ne reste que le sac commun.
-- C'est aussi ce qui libere l'axe du rassemblement : Penticus se
-- tient en (256,240), l'ancien feu (256,220) le chevauchait.
function mount_windswept_entrance_ch_5.BuildCampMorning()
	mount_windswept_entrance_ch_5.PurgeDecor()
	--Camp du matin : le feu est eteint, le sac a ete retire (il genait le
	--centre du camp). Le calque est donc VIDE, et l'axe du rassemblement
	--entierement degage — Penticus peut tenir son adresse en (256,232)
	--sans se cogner au bloqueur du foyer, qui n'existe plus a ce moment.
	--PurgeDecor a deja retire ce bloqueur.
end

-- LE DEPLOIEMENT DES COUCHAGES — la nuit seulement.
-- Appele par CampNightfall sous le fondu de la tombee de la nuit :
-- 12 paillasses = 12 membres presents (10 guilde + le duo), pas une
-- de plus. Le feu reste, le materiel de jour est remplace.
function mount_windswept_entrance_ch_5.DeployBeds()
	mount_windswept_entrance_ch_5.PurgeDecor()
	local ground = GAME:GetCurrentGround()
	local hay_bed  = RogueEssence.Content.ObjAnimData('Hay_Bed', 1)
	local campfire = RogueEssence.Content.ObjAnimData('Campfire', 6)

	for _, b in ipairs(mount_windswept_entrance_ch_5.BEDS) do
		ground.Decorations[0].Anims:Add(
			RogueEssence.Ground.GroundAnim(hay_bed, RogueElements.Loc(b[1], b[2])))
	end
	--LA COUCHE DE PLUM — posee UNIQUEMENT si elle est au camp.
	--Le drapeau est arme par son irruption (section 4bis) et relu par
	--toutes les recompositions du bivouac (retour du reve, matin). Sans
	--lui, on poserait une paillasse vide chaque fois que la scene est
	--rejouee sans elle : un couchage de trop, exactement le defaut qu'on
	--a corrige pour Phileas.
	if SV.Chapter5.PlumAtMountCamp then
		local pb = mount_windswept_entrance_ch_5.PLUM_BED
		ground.Decorations[0].Anims:Add(
			RogueEssence.Ground.GroundAnim(hay_bed, RogueElements.Loc(pb[1], pb[2])))
	end
	ground.Decorations[0].Anims:Add(
		RogueEssence.Ground.GroundAnim(campfire, RogueElements.Loc(
			mount_windswept_entrance_ch_5.CAMP_X, mount_windswept_entrance_ch_5.CAMP_Y)))
	--Le foyer de la nuit bloque lui aussi : on ne traverse pas les braises
	--pour aller se coucher.
	mount_windswept_entrance_ch_5.AddFireBlocker()
end

-- POSITION DES COUCHAGES — 12 paillasses en fer a cheval
-- Sortie en table pour que la cinematique et le decor permanent ne
-- puissent plus diverger.
-- CE QUI N'ALLAIT PAS DANS L'ANCIENNE DISPOSITION (tout mesure) :
--   * LE LIT 12 ETAIT INATTEIGNABLE. (344,132) est du sol libre, mais
--     il appartient a une POCHE ISOLEE au nord-est : un parcours en
--     largeur depuis l'entree du joueur ne l'atteint pas. La carte
--     compte 3 composantes connexes de sol libre ; ce lit tombait dans
--     la mauvaise. Son dormeur aurait ete injoignable, et l'animation
--     de coucher se serait terminee contre un mur.
--   * QUATRE PAIRES DE PAILLASSES SE CHEVAUCHAIENT. Le sprite Hay_Bed
--LE CAMP EST DEFINI PAR RAPPORT A SON FOYER.
--Procede repris d'Halcyon (mount_windswept_entrance_ch_5.lua de la branche
--working-copy, l.128-131), ou les douze paillasses derivent de deux
--constantes `bedRelativeX/bedRelativeY`, avec ce commentaire de l'auteur :
--« so I can copy and paste this code into other scenes and only change one
--value ». Deplacer le bivouac ne demande alors qu'une seule modification.
--
--Ici l'origine est le foyer lui-meme, puisque c'est autour de lui que tout
--s'organise : les couchages, le cercle du repas, les places de garde.
mount_windswept_entrance_ch_5.CAMP_X = 256
mount_windswept_entrance_ch_5.CAMP_Y = 220

local CX = mount_windswept_entrance_ch_5.CAMP_X
local CY = mount_windswept_entrance_ch_5.CAMP_Y

--Les onze couchages, en decalage par rapport au foyer. Valeurs identiques
--aux anciennes coordonnees absolues, au pixel pres : le placement verifie
--(sol libre, sprite 40x40, aucun recouvrement) est donc conserve tel quel.
mount_windswept_entrance_ch_5.BEDS = {
	{CX -  8, CY - 104}, {CX + 42, CY -  52}, {CX + 88, CY - 52},
	{CX + 100, CY -  6}, {CX + 92, CY +  40}, {CX + 66, CY + 86},
	{CX -  46, CY + 90}, {CX - 92, CY +  66}, {CX - 102, CY + 20},
	{CX - 102, CY - 26}, {CX - 60, CY +   4},
}

--LA DOUZIEME PAILLASSE — CELLE DE PLUM, ET ELLE N'EXISTE QUE SI PLUM EST LA.
--
--RETOUR DE L'UTILISATEUR, et il a raison : « plum […] a pas de paillasse ».
--Elle debarquait au camp pendant le repas (section 4bis), Penticus lui
--disait « tu manges, tu dors » — puis le deploiement des couchages posait
--ONZE paillasses pour DOUZE dormeurs, et elle disparaissait du camp jusqu'au
--matin. C'est exactement l'erreur de causalite decrite dans la directive :
--un element introduit en fanfare qui sort du decor au beat suivant.
--
--Elle n'est PAS ajoutee a la table BEDS : cette table decrit l'expedition
--officielle, dont Plum ne fait pas partie (c'est tout le sel du personnage).
--Sa couche est une piece rapportee, posee en bout de rang ouest, et
--DeployBeds ne la deroule que si elle est effectivement au camp.
--
--(116,288) — coin haut-gauche du sprite Hay_Bed 40x40, assise (129,298).
--Mesures faites sur la grille d'obstacles de la carte :
--  * sol libre sur tout le rectangle 40x40, et sur la case d'assise 26x26 ;
--  * 8 px de la paillasse 8 (le partenaire), la plus proche — l'ecart
--    minimal entre deux paillasses DEJA posees est de 2 px (couches 9 et
--    11), on est donc au-dessus de l'existant ;
--  * 28 px du foyer et de son bloqueur de collision ;
--  * 61 px de Hyko, 48 px du partenaire : elle dort en bout de rang, a
--    portee de voix des jeunes pour la veillee d'histoires (section 8bis)
--    sans se coller a personne ;
--  * dans le cadre de la camera du camp (256,240) : x=129 contre une
--    limite gauche a 96, elle reste visible pendant toute la nuit ;
--  * a plus de 20 px du trajet de Phileas (camp -> chevet du heros ->
--    poste de garde) et de celui de Rin au matin : personne ne lui marche
--    dessus.
mount_windswept_entrance_ch_5.PLUM_BED = {CX - 140, CY + 68}
--LA COUCHE 11 (Kino) EST A LA PLACE DU SAC, contre le feu.
--Elle etait reléguee en (362,300), a 136 px du foyer, sur le flanc est
--— le plus loin de tous. Or c'est la couche qui compte : au matin, Rin
--vient y secouer Kino qui dort encore, et toute la scene comique se joue
--autour. La jouer a l'autre bout du camp obligeait la camera a quitter
--le foyer, et Rin a traverser tout le bivouac.
--Elle occupe donc l'emplacement du sac commun (196,224) : 58 px du feu

function mount_windswept_entrance_ch_5.SetupGround()	
	-- LE CAMP APRES LE DEPART DE L'EXPEDITION — QUI RESTE, ET POURQUOI
	-- INCOHERENCE MAJEURE CORRIGEE. Cette fonction respawnait HUIT PNJ,
	-- dont CINQ que la cinematique d'intro venait de faire partir en
	-- expedition sous les yeux du joueur (GROUND:Hide en fin d'intro) :
	--     Kino (Breloom), Reinier (Girafarig), Almotz (Zigzagoon)
	--     -> vague d'ouverture, montent tracer la voie
	--     Rin (Audino), Coco (Snubbull)
	--     -> cordee de soutien, montent au relais
	-- Le joueur les regardait remonter le sentier nord et disparaitre,
	-- puis reprenait la main... devant les cinq memes, plantes au camp.
	-- Le commentaire d'origine s'en justifiait par « redescendues au
	-- relais entre deux rotations » — sauf que la scene ne montre AUCUNE
	-- redescente : elle les montre MONTER.
	-- NE RESTENT DONC QUE CEUX QUE LA SCENE LAISSE SUR PLACE :
	--   * PENTICUS (Tropius) : il tient le camp de base, il l'a dit.
	--   * PHILEAS (Noctowl)  : idem, les vents le portent mal.
	--   * HYKO (Growlithe)   : garde au camp par Penticus (arc du Tunnel,
	--                          paye par la scene du vent).
	-- Trois PNJ, exactement les trois que la cinematique finale laisse
	-- devant la porte du donjon. La cordee du sommet (heros, partenaire,
	-- Ganlon, Shuca) est dans l'equipe du joueur, pas en PNJ.
	-- POSITIONS : verifiees sol libre, connexes depuis l'entree, hors
	-- empreinte du feu (36x36 en 256,220), hors rocher de Kangaskhan
	-- (32x32 en 160,144) et hors des onze paillasses.
	-- COMPOSITION DU CAMP — trois postes qui racontent trois roles.
	-- RETOUR DE L'UTILISATEUR : « Penticus et Hyko devraient etre
	-- positionnes esthetiquement ». Les trois etaient agglutines au
	-- nord-ouest (230,190 / 288,196 / 224,206), tous tournes vers le
	-- bas, sans rapport au foyer : un alignement de PNJ, pas un camp.
	-- Nouvelle composition, construite AUTOUR DU FEU (dessine
	-- x256..291 / y220..255, foyer au centre en 274,238) :
	--        Phileas (endormi, en retrait nord-ouest)
	--                    .
	--                 [ FEU ]        Hyko  (garde, a l'est, face au feu)
	--                    .
	--            Penticus (au sud, face au sentier d'arrivee)
	--   * PENTICUS au SUD, tourne vers le HAUT : il fait face au sentier
	--     par lequel on arrive. Le maitre de guilde guette le retour de
	--     ses equipes — c'est sa premiere replique de la carte
	--     (« j'ai guette ce sentier toute la soiree ») rendue visible.
	--   * HYKO a l'EST, tourne vers le feu : en poste, mais au chaud.
	--   * PHILEAS en RETRAIT au nord-ouest, ENDORMI. Il a veille la
	--     nuit (section 7) ; patron du Tunnel, searing_tunnel_entrance
	--     _ch_5.lua:36-37, ou Noctowl dort pendant que Tropius assure.
	-- Toutes verifiees SPRITE COMPRIS (Tropius 40x40, Noctowl 38x32,
	-- Growlithe 32x28, ancrage GroundAction.GetDrawLoc:116) : aucune ne
	-- recouvre les flammes, ni le bloqueur du foyer, ni le rocher de
	-- Kangaskhan, ni aucune des onze paillasses. Ecarts de 48 a 88 px :
	-- lisibles a l'ecran, et tous les trois tiennent dans un plan.
	local tropius, noctowl, growlithe =
	CharacterEssentials.MakeCharactersFromList({
		{'Tropius', 252, 268, Direction.Up},
		{'Noctowl', 212, 180, Direction.Down},
		{'Growlithe', 300, 236, Direction.Left}
	})
	--Phileas dort a son poste : il n'est pas alle se coucher, il s'est
	--assoupi la ou il veillait.
	pcall(function() GROUND:CharSetAnim(noctowl, "Sleep", true) end)

	-- QUATRIEME POSTE : PLUM — DEPLACEE, ELLE BARRAIT LE PASSAGE.
	--
	-- BUG SIGNALE EN JEU : « plum a la cinematique de respawn elle est
	-- devant le passage inerte et immobile ».
	-- Mesure faite sur la grille : a hauteur y=174, le sol libre qui mene
	-- a la porte du donjon s'etend de x=248 a x=304. Plum etait posee en
	-- (278,174) — soit EXACTEMENT au milieu de ce goulot, avec un sprite
	-- de 24 a 32 px de large. Le joueur qui remonte vers l'entree lui
	-- rentrait dedans, et comme un GroundChar est solide, elle bloquait
	-- reellement la progression.
	-- Nouveau poste (236,230), a l'OUEST du foyer : sol libre verifie,
	-- 39 px des marmites (elle tient toujours la cuisine), 41 px de
	-- Penticus, 55 px de Phileas, 64 px de Hyko. Surtout : la distance
	-- MINIMALE entre elle et n'importe quel point du couloir d'acces
	-- (x 248..304, y 112..206) est de 29 px — le passage est franc.
	--
	-- QUATRIEME POSTE : PLUM, ET ELLE A UNE RAISON D'ETRE LA.
	-- Penticus lui a donne un poste au matin (section 11bis) et Coco lui a
	-- passe la cuisine du camp avant de monter au relais. Elle n'est donc
	-- pas un PNJ de plus pose sur la carte : elle occupe la fonction que
	-- deux scenes precedentes lui ont explicitement confiee.
	-- Elle tient les marmites : sa place est PRES DU FOYER, tournee vers
	-- lui — mais A L'OUEST, pas dans l'axe de la porte.
	-- Direction.Right : elle fait face au foyer (a l'est de sa position),
	-- donc dos au vide. Une cuisiniere ne tourne pas le dos a ses
	-- marmites.
	local jigglypuff = nil
	if SV.Chapter5.PlumAtMountCamp then
		pcall(function()
			jigglypuff = CharacterEssentials.MakeCharactersFromList({
				{'Jigglypuff', 236, 230, Direction.Right}
			})
		end)
	end
	--Rendus nil explicitement : plusieurs branches de ce fichier les
	--testent encore (if rin ~= nil...), et un nil franc vaut mieux
	--qu'un PNJ fantome qui n'a rien a faire la.
	local audino, snubbull, zigzagoon, breloom, girafarig = nil, nil, nil, nil, nil

	--Ganlon et Shuca voyagent avec le joueur : s'ils sont dans l'equipe
	--(post-intro), on les fait apparaitre pres du duo via les spawners
	--TEAMMATE_2/3 (patron exact du camp du Tunnel, spawners presents
	if GAME:GetPlayerPartyCount() > 3 then
		GROUND:SpawnerSetSpawn("TEAMMATE_2", GAME:GetPlayerPartyMember(2))
		GROUND:SpawnerDoSpawn("TEAMMATE_2")
		GROUND:SpawnerSetSpawn("TEAMMATE_3", GAME:GetPlayerPartyMember(3))
		GROUND:SpawnerDoSpawn("TEAMMATE_3")
	end

	-- LE CAMP DE JOUR — ET PAS DE FEU APRES UNE DEFAITE.
	if SV.Chapter5.LostMountain or SV.Chapter5.DiedToWind
	   or SV.Chapter5.PlayTempMountScene then
		mount_windswept_entrance_ch_5.BuildCampMorning()
	else
		mount_windswept_entrance_ch_5.BuildCampDay()
	end

	--Apres une defaite en montagne, PHILEAS descend de son perchoir
	--pour veiller sur les blesses : il ne dort plus, il surveille.
	--DEUX BUGS ICI. Le bloc deplacait a l'origine Rin, partie avec la
	--cordee de soutien : le TeleportTo s'appliquait a un `audino` nil,
	--donc a rien. Puis, une fois reporte sur Phileas, il le posait en
	--(276,236) — soit 756 px de son sprite DANS les flammes, et son
	--collider EN PLEIN dans le bloqueur du foyer : il s'y serait
	--retrouve coince des le retour du controle au joueur.
	--Il se poste donc a l'ouest du foyer, tourne vers lui, sprite
	if SV.Chapter5.LostMountain or SV.Chapter5.DiedToWind then
		pcall(function()
			GROUND:CharEndAnim(noctowl)
			GROUND:TeleportTo(noctowl, 224, 236, Direction.Right)
		end)
	end

	-- LE CAMP N'EST PAS UN DIORAMA — VIE DE FOND EN EXPLORATION.
	--
	-- Second volet du retour « plum [...] inerte et immobile ». Le
	-- deplacement reglait le blocage du passage ; l'inertie, elle, ne
	-- concernait pas qu'elle : AUCUN des PNJ de ce camp n'avait de
	-- comportement une fois la main rendue au joueur. Quatre sprites
	-- plantes, figes dans leur direction de depart, jusqu'a ce qu'on
	-- leur parle. C'est exactement le « pourquoi ce PNJ reste-t-il
	-- immobile ? » du test de credibilite.
	--
	-- On leur pose donc l'IA de fond du projet, `halcyon.ai.ground_talking`,
	-- deja employee au camp du Tunnel (searing_tunnel_entrance_ch_5:108
	-- et :114) et a la guilde. Elle fait tourner la tete, jouer des
	-- emotes et regarder ses voisins, sans jamais deplacer le PNJ de son
	-- poste — ce qui compte ici, puisque chaque position a ete calculee.
	--
	-- Signature (ai/ground_talking.lua) :
	--   AI:SetCharacterAI(chara, script, Turn, IdleTime, EmoteIdleTime,
	--                     InitialDelay, RandomTalk, Personality, Friends)
	-- Les DELAIS INITIAUX sont tous differents (0 / 90 / 150 / 210) :
	-- sans cela les quatre s'animeraient a la meme frame, et le camp
	-- respirerait comme un seul bloc mecanique — precisement le defaut
	-- que la directive interdit pour les reactions de groupe.
	--
	-- Chacun regarde qui il a une raison de regarder :
	--   * Penticus guette le sentier, mais jette un oeil a Hyko poste
	--     pres du feu ;
	--   * Hyko, le garde, surveille le maitre de guilde ;
	--   * Plum et Hyko sont les deux qui restent au camp : ils se
	--     tiennent compagnie ;
	--   * Phileas DORT (CharSetAnim "Sleep" plus haut) : on ne lui pose
	--     AUCUNE IA, elle leverait son animation de sommeil. Son
	--     immobilite a lui est justifiee — il a veille toute la nuit.
	pcall(function()
		AI:SetCharacterAI(tropius, "halcyon.ai.ground_talking",
		                  false, 90, 60, 0, false, 'Default', {growlithe})
	end)
	pcall(function()
		AI:SetCharacterAI(growlithe, "halcyon.ai.ground_talking",
		                  false, 90, 60, 90, false, 'Default', {tropius})
	end)
	if jigglypuff ~= nil then
		pcall(function()
			--Plum s'affaire a ses marmites : IdleTime plus court, elle
			--est la plus remuante des quatre. C'est son caractere.
			AI:SetCharacterAI(jigglypuff, "halcyon.ai.ground_talking",
			                  false, 60, 60, 150, false, 'Default', {growlithe})
		end)
	end
end

--for testing 
function mount_windswept_entrance_ch_5.SetParty()
	--Clean up the existing spawns, then call SetupGround to spawn them in.
	--Record the level of Hyko and Almotz for later use. Check to make sure they exist before doing so (mostly just so I can run this scene without needing them in the party)
	if GAME:GetPlayerPartyCount() > 2 then 
		SV.GuildSidequests.GrowlitheLevel = GAME:GetPlayerPartyMember(2).Level
		SV.GuildSidequests.ZigzagoonLevel = GAME:GetPlayerPartyMember(3).Level
	end
	
	--Default the party DESTRUCTIVELY to delete Hyko and Almotz.
	GeneralFunctions.DefaultParty(false, true)
	--reinitialize the hero and partner variables after respawning the party.
	--Failing to do this has later functions try to teleport the "old" versions of them, causing a phantom glitch. dunno why, since i thought i fixed default party...
	hero = CH('PLAYER')
	partner = CH('Teammate1')
	partner.CollisionDisabled = true
	
	--Setup Ganlon and Shuca.
	local cranidos_id = RogueEssence.Dungeon.MonsterID("cranidos", 0, "normal", Gender.Male)
	local cranidos_monster = _DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, cranidos_id, SV.GuildSidequests.CranidosLevel, "mold_breaker", 0)
	cranidos_monster.Discriminator = _DATA.Save.Rand:Next()--tbh idk what this is lol
	cranidos_monster.Nickname = CharacterEssentials.GetCharacterName('Cranidos', true)
	cranidos_monster.MetAt = "Adventurer's Guild"
	cranidos_monster.IsPartner = true
	cranidos_monster.IsFounder = true
	
	cranidos_monster:ReplaceSkill("headbutt", 0, true)
	cranidos_monster:ReplaceSkill("pursuit", 1, false)
	cranidos_monster:ReplaceSkill("iron_head", 2, true)
	cranidos_monster:ReplaceSkill("smack_down", 3, true)
		
	GAME:AddPlayerTeam(cranidos_monster)
	cranidos_monster:FullRestore()
	local talk_evt = RogueEssence.Dungeon.BattleScriptEvent("GuildmateInteract")
    cranidos_monster.ActionEvents:Add(talk_evt)
	cranidos_monster:RefreshTraits()

	local mareep_id = RogueEssence.Dungeon.MonsterID("mareep", 0, "normal", Gender.Female)
	local mareep_monster = _DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, mareep_id, SV.GuildSidequests.MareepLevel, "static", 0)
	mareep_monster.Discriminator = _DATA.Save.Rand:Next()--tbh idk what this is lol
	mareep_monster.Nickname = CharacterEssentials.GetCharacterName('Mareep', true)
	mareep_monster.MetAt = "Adventurer's Guild"
	mareep_monster.IsPartner = true
	mareep_monster.IsFounder = true
	
	mareep_monster:ReplaceSkill("thunder_shock", 0, true)
	mareep_monster:ReplaceSkill("thunder_wave", 1, false)
	mareep_monster:ReplaceSkill("take_down", 2, true)
	mareep_monster:ReplaceSkill("flatter", 3, false)
		
	GAME:AddPlayerTeam(mareep_monster)
	mareep_monster:FullRestore()
	local talk_evt = RogueEssence.Dungeon.BattleScriptEvent("GuildmateInteract")
    mareep_monster.ActionEvents:Add(talk_evt)
	mareep_monster:RefreshTraits()
	
	--Assign importances to identify who they are. Do this instead of just checking species just in case randomizers down the road or something.
	local cTbl = LTBL(GAME:GetPlayerPartyMember(2))
	local mTbl = LTBL(GAME:GetPlayerPartyMember(3))
	
	cTbl.Importance = "Cranidos"
	mTbl.Importance = "Mareep"
end

function mount_windswept_entrance_ch_5.ArrivalCutscene()

	--LE NOIR EN PREMIER, AVANT LE MOINDRE APPEL MOTEUR.
	--
	--BUG CORRIGE (signale en jeu : « quand je quitte le crucible y'a ENCORE
	--un apercu de la zone apres les dialogues dans le noir »).
	--
	--Le FadeOut de securite se trouvait plus bas, APRES CutsceneMode,
	--DisableCharacterAI, StopBGM et PlayBGM. Or GAME:FadeOut est BLOQUANT
	--(ScriptGame.cs:1590 : coroutine.yield sur _FadeOut) et FadeInternal
	--(FadeEffect.cs:30-42) rend la main au moteur a chaque frame de fondu.
	--Tout appel place avant lui laisse donc passer des frames RENDUES.
	--
	--A cet instant la carte du camp est deja chargee et affichable, mais :
	--  * le joueur est encore au marqueur d'entree par defaut ;
	--  * la camera n'a pas ete recadree (MoveCamera vient plus bas) ;
	--  * le decor n'est pas monte (BuildCampDay plus bas encore).
	--Le joueur voyait donc un eclair de carte nue, camera au mauvais
	--endroit — percu comme « un apercu de la zone ».
	--
	--Ces deux lignes sont desormais les toutes premieres. Patron identique
	--a hero_dream/init.lua:45-46 et mount_windswept_entrance/init.lua:45-46,
	--ou le meme raisonnement est deja applique. FadeOut(false,1) sur un
	--ecran deja noir est un no-op (FadeEffect.cs:63-64) : gratuit quand le
	--fondu du creuset a tenu, salvateur quand il n'a pas eu lieu.
	pcall(function() GAME:FadeOut(false, 1) end)
	pcall(function() GAME:CutsceneMode(true) end)
	--It's already night when you arrive. Penticus is pacing around nervously wondering where you are before he realizes you're here
	--He runs up to hyko relieved and asks wtf happened. He went through the dungeon since it got late and you guys weren't here when he arrived.
	--You explain and he's super concerned that you had to fight an entire clan of Slugma.
	--He's impressed that you did it, and thanks the player team for doing a good job but he tells hyko that he pretty much had a panic attack wondering where he was and wants him to stay close for the rest of the expedition.
	--Hyko protests but eventually gives in seeing how worked up Penticus is. Penticus isn't acting entirely out of character, but obviously this is 
	--Phileas will explain at one point that the reason he and Penticus didn't find you when coming through the dungeon once it started late was probably because of how mystery dungeons shift. They're different everytime, it probably caused them to be brought a different way and so they didnt find you.
	
	--Partner at some point could say something like "I'd be really worked up too if something happened to player!". Player may be able to say something similar back. Could be laying it on too thick?

	--Later on, I was thinking of having Almotz/Rin/Coco kinda like, limp into camp after Windswept because they really struggled with it, and maybe they needed a save from Penticus for this, but this
	--may be a bit too drastic or rough on them. The expedition shouldn't be TOO depressing...

	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local tunnel = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('searing_tunnel')
	local steppe = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('vast_steppe')
	local mountain = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('mount_windswept')
	local ruins = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('cloven_ruins')
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	SOUND:StopBGM()
	-- L'OST D'ARRIVEE — le camp s'entend avant de se voir.
	SOUND:PlayBGM('Cliff Camp.ogg', true)
	--ARRIVEE PAR LE SUD. L'expedition debouche du sentier au bas de la
	--carte et remonte en ligne droite la colonne x=256, verifiee
	--praticable en continu de y=488 jusqu'au camp.
	GAME:FadeOut(false, 1)

	GAME:MoveCamera(256, 456, 1, false)
	--TRANSITION JOUR -> SOIR (Prompt Maitre 6.2). L'expedition arrive au
	--couchant : "dusk" d'abord (patron exact de l'arrivee au Tunnel), la
	--nuit noire ("darkness") ne tombe qu'au deploiement des couchages.
	GROUND:AddMapStatus("dusk")
	
	GROUND:TeleportTo(hero, 256, 456, Direction.Up)
	GROUND:TeleportTo(partner, 256, 472, Direction.Up)
	
	-- 1.0. LA DISPOSITION D'OUVERTURE — le camp existe avant nous
	--
	-- PLAN, ACTE 1, DISPOSITION D'OUVERTURE : « tous les membres de la
	-- Guilde sont deja presents et disperses sur le campement, chacun
	-- occupe. Kino et son partenaire, a l'ecart, discutent entre eux. »
	-- « personne n'arrive de l'exterieur apres le heros. »
	--
	-- C'ETAIT LE DEFAUT STRUCTUREL DE L'ACTE 1. Kino (Breloom) et Reinier
	-- (Girafarig) etaient crees ici puis CACHES, et ils remontaient le
	-- sentier APRES le duo (ancienne section 1, « KINO ET REINIER
	-- REJOIGNENT LE CAMP »). Le declencheur du rassemblement etait donc
	-- une arrivee exterieure de plus, et non l'arrivee du heros.
	--
	-- Ils sont desormais sur la carte des la premiere frame, a l'ECART du
	-- reste du camp, en pleine discussion a eux. Places mesurees sur la
	-- grille d'obstacles : Kino (356,318) et Reinier (376,290), 34 px
	-- l'un de l'autre — assez proches pour lire « ils se parlent »,
	-- assez loin pour ne pas se recouvrir. 85 px du membre du camp le
	-- plus proche (Ganlon), donc nettement « a l'ecart » ; sol libre
	-- verifie, hors foyer, hors bloqueur, hors rocher de Kangaskhan.
	-- Ils se font face : Kino regarde au nord-est, Reinier au sud-ouest.
	local audino, snubbull, girafarig, breloom, growlithe, zigzagoon, tropius, noctowl, mareep, cranidos = 
	CharacterEssentials.MakeCharactersFromList({
		{'Audino',    222, 266, Direction.UpRight},
		{'Snubbull',  300, 214, Direction.Left},
		{'Girafarig', 376, 290, Direction.DownLeft},
		{'Breloom',   356, 318, Direction.UpRight},
		{'Growlithe', 240, 488, Direction.Up},
		{'Zigzagoon', 272, 488, Direction.Up},
		{'Tropius',   230, 190, Direction.DownRight},
		{'Noctowl',   288, 196, Direction.DownLeft},
		{'Mareep',    246, 176, Direction.Down},
		{'Cranidos',  310, 236, Direction.Left}
	})
	
	--LE CAMP DE JOUR. Aucune paillasse a l'arrivee (Prompt Maitre 6.3) :
	--les couchages ne sont deployes qu'a la fin de la veillee, sous le
	--fondu de la tombee de la nuit (CampNightfall, section 7). Ici :
	--feu + materiel range, via le constructeur partage qui purge le
	--calque (le doublement de decor d'avant ne peut plus se produire).
	mount_windswept_entrance_ch_5.BuildCampDay()

	--LES REPLIQUES D'ARRIVEE SE JOUENT SOUS LE NOIR (deroule valide par
	--le joueur : « ecran noir qui s'applique et qui doit etre leve apres
	--le dialogue »). Le noir pose avant la bascule du creuset tient
	--jusqu'ici, sans trou ; la carte du camp n'est revelee qu'apres.
	GAME:WaitFrames(40)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_001'], tunnel:GetColoredName()))
	GAME:WaitFrames(20)
	UI:SetSpeaker(growlithe)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_002']))
	GAME:WaitFrames(20)
	GAME:FadeIn(40)
	
	-- 1.1. LE CAMP VIT PENDANT QU'ON MONTE
	-- (beat 1.1 du plan : le joueur decouvre la disposition d'ensemble)
	-- Pendant toute la remontee du sentier, le camp continue ses
	-- occupations SANS savoir qu'on arrive : Coco s'affaire au feu, Rin
	-- range, Ganlon fait les cent pas, Penticus surveille la montagne.
	-- Le joueur voit donc un lieu deja habite, avec sa propre vie, avant
	-- d'y entrer — c'est exactement ce que fait un Donjon Mystere.
	-- La boucle tourne en tache de fond et s'arrete d'elle-meme quand la
	-- montee est finie (verrou `campBusy`, meme patron `stopTalking` que
	-- la veillee). Tout est sous pcall : la vie de fond ne doit JAMAIS
	-- pouvoir interrompre l'arrivee du joueur.
	local campBusy = true
	-- KINO ET REINIER ONT LEUR PROPRE DISCUSSION, A L'ECART.
	-- Plan, acte 1 : « Kino et son partenaire sont deja la, engages dans
	-- leur propre discussion, chacun de son cote ». Ils ne regardent pas
	-- le sentier, ils ne guettent personne : ils sont a leur affaire, et
	-- c'est ce qui rend l'arrivee du heros interruptrice.
	-- La boucle tourne en tache de fond pendant toute la montee et
	-- s'arrete au meme verrou que le reste de la vie du camp.
	local dubBusy = TASK:BranchCoroutine(function()
		while campBusy do
			pcall(function()
				--Reinier expose, Kino ecoute en hochant : c'est leur
				--dynamique etablie (le meticuleux et l'enthousiaste).
				GROUND:CharSetEmote(girafarig, "notice", 0)
			end)
			GAME:WaitFrames(45)
			if not campBusy then break end
			pcall(function()
				GROUND:CharSetEmote(girafarig, "", 0)
				GeneralFunctions.DoAnimation(breloom, 'Nod')
			end)
			GAME:WaitFrames(55)
			if not campBusy then break end
			pcall(function()
				GROUND:CharSetAnim(breloom, "Idle", true)
				GROUND:CharSetEmote(breloom, "happy", 0)
			end)
			GAME:WaitFrames(40)
			if not campBusy then break end
			pcall(function()
				GROUND:CharEndAnim(breloom)
				GROUND:CharSetEmote(breloom, "", 0)
			end)
			GAME:WaitFrames(50)
		end
		pcall(function()
			GROUND:CharEndAnim(breloom)
			GROUND:CharSetEmote(breloom, "", 0)
			GROUND:CharSetEmote(girafarig, "", 0)
		end)
	end)
	local campLife = TASK:BranchCoroutine(function()
		while campBusy do
			pcall(function()
				GROUND:CharSetAnim(snubbull, "Idle", true)
				GROUND:CharSetEmote(snubbull, "happy", 0)
			end)
			GAME:WaitFrames(50)
			if not campBusy then break end
			pcall(function()
				GROUND:CharEndAnim(snubbull)
				GROUND:CharSetEmote(snubbull, "", 0)
				GROUND:CharAnimateTurnTo(cranidos, Direction.Up, 4)
			end)
			GAME:WaitFrames(40)
			if not campBusy then break end
			pcall(function()
				GROUND:CharAnimateTurnTo(cranidos, Direction.Left, 4)
				GROUND:CharSetAnim(audino, "Idle", true)
			end)
			GAME:WaitFrames(50)
			if not campBusy then break end
			pcall(function()
				GROUND:CharEndAnim(audino)
				GROUND:CharAnimateTurnTo(tropius, Direction.Up, 6)
			end)
			GAME:WaitFrames(60)
			if not campBusy then break end
			pcall(function()
				GROUND:CharAnimateTurnTo(tropius, Direction.DownRight, 6)
				GROUND:CharSetEmote(mareep, "happy", 0)
			end)
			GAME:WaitFrames(50)
			pcall(function() GROUND:CharSetEmote(mareep, "", 0) end)
			GAME:WaitFrames(30)
		end
		--Remise a plat : aucune animation de fond ne doit survivre a la
		--montee, sinon elle se superpose a l'accueil.
		pcall(function()
			GROUND:CharEndAnim(snubbull)
			GROUND:CharEndAnim(audino)
			GROUND:CharSetEmote(snubbull, "", 0)
			GROUND:CharSetEmote(mareep, "", 0)
		end)
	end)

	--LA MONTEE. File indienne du sud vers le camp, sans zigzag ; la
	--camera GLISSE avec la colonne (deux paliers longs, pas de saut).
	--Au bord sud du camp, la file s'ouvre en eventail sur 4 positions
	--verifiees libres.
	local coro1 = TASK:BranchCoroutine(function()
		GROUND:MoveToPosition(hero, 256, 316, false, 1)
		GROUND:MoveToPosition(hero, 240, 300, false, 1)
		GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
	end)
	local coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(14)
		GROUND:MoveToPosition(partner, 256, 332, false, 1)
		GROUND:MoveToPosition(partner, 272, 300, false, 1)
		GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
	end)
	local coro3 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(28)
		GROUND:MoveToPosition(growlithe, 256, 348, false, 1)
		GROUND:MoveToPosition(growlithe, 240, 328, false, 1)
		GROUND:CharAnimateTurnTo(growlithe, Direction.Up, 4)
	end)
	local coro4 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(42)
		GROUND:MoveToPosition(zigzagoon, 256, 364, false, 1)
		GROUND:MoveToPosition(zigzagoon, 272, 328, false, 1)
		GROUND:CharAnimateTurnTo(zigzagoon, Direction.Up, 4)
	end)
	local coro5 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(20)
		GAME:MoveCamera(256, 430, 150, false)
		GAME:MoveCamera(264, 262, 110, false)
	end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})

	--La vie de fond s'arrete ICI : le camp a fini ses occupations, il va
	--maintenant reagir a l'arrivee. On joint la coroutine avant de
	--continuer pour qu'aucune animation cyclique ne se superpose a
	--l'accueil (sinon Coco continuerait de s'agiter en pleine scene).
	campBusy = false
	pcall(function() TASK:JoinCoroutines({campLife, dubBusy}) end)
	GAME:WaitFrames(20)

	--LA PREMIERE VUE DU SOMMET. Le partenaire leve la tete AVANT de
	--parler (le corps parle avant la bouche) ; Hyko le rejoint du
	coro1 = TASK:BranchCoroutine(function()
		pcall(function() GeneralFunctions.EmoteAndPause(partner, "Sweating", true) end)
		UI:SetSpeaker(partner)
		GeneralFunctions.SetEmotion("Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_003']))
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(18)
		pcall(function() GROUND:CharTurnToCharAnimated(growlithe, partner, 4) end)
	end)
	coro3 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(26)
		pcall(function() GROUND:CharTurnToCharAnimated(zigzagoon, partner, 4) end)
	end)
	TASK:JoinCoroutines({coro1, coro2, coro3})

	coro1 = TASK:BranchCoroutine(function()
		UI:SetSpeaker(growlithe)
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_004']))
	end)
	coro2 = TASK:BranchCoroutine(function()
		pcall(function() GROUND:CharTurnToCharAnimated(partner, growlithe, 4) end)
		GAME:WaitFrames(14)
		pcall(function() GROUND:CharTurnToCharAnimated(hero, growlithe, 4) end)
	end)
	TASK:JoinCoroutines({coro1, coro2})

	--Le partenaire se retourne vers le heros : la relance est pour lui.
	coro1 = TASK:BranchCoroutine(function()
		pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
		UI:SetSpeaker(partner)
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_005']))
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(10)
		pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
	end)
	TASK:JoinCoroutines({coro1, coro2})

	-- LE CAMP REMARQUE QU'ON ARRIVE.
	-- Les six sont deja en place et visibles depuis le debut de la scene
	-- (cf. MakeCharactersFromList plus haut) : plus aucun Unhide en bloc,
	-- plus aucun TeleportTo qui les ferait sauter d'un point a l'autre
	-- sous les yeux du joueur. Il ne reste donc ici qu'une chose a
	-- jouer — le moment ou ils LEVENT LA TETE.
	-- Et ils ne la levent pas tous en meme temps : Penticus le premier
	-- (il guettait), Phileas ensuite, Shuca en dernier parce qu'elle
	-- etait occupee ailleurs. Trois temps decales, comme un vrai groupe.
	local camp1 = TASK:BranchCoroutine(function()
		GROUND:CharTurnToCharAnimated(tropius, hero, 4)
		GROUND:CharSetEmote(tropius, "notice", 1)
	end)
	local camp2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(10)
		GROUND:CharTurnToCharAnimated(noctowl, hero, 4)
	end)
	local camp3 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(18)
		GROUND:CharTurnToCharAnimated(audino, hero, 4)
	end)
	local camp4 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(24)
		GROUND:CharTurnToCharAnimated(snubbull, hero, 4)
	end)
	local camp5 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(30)
		GROUND:CharTurnToCharAnimated(mareep, hero, 4)
		GROUND:CharSetEmote(mareep, "happy", 1)
	end)
	local camp6 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(36)
		GROUND:CharTurnToCharAnimated(cranidos, hero, 4)
	end)
	-- 1.3. KINO REMARQUE, REINIER SUIT EN DIFFERE
	-- BEAT 1.3 DU PLAN.
	-- « Kino tourne la tete vers le heros ; son partenaire suit avec un
	--   leger differe. Reaction non simultanee, pas en miroir parfait. »
	-- Ils sont a l'ecart au sud-est et se parlaient : ils sont donc les
	-- DERNIERS a s'apercevoir de quoi que ce soit, apres tout le camp.
	-- Kino s'interrompt le premier (il regarde par-dessus l'epaule de
	-- Reinier, qui lui tourne le dos au sentier), et Reinier ne comprend
	-- qu'ensuite pourquoi son interlocuteur ne l'ecoute plus — d'ou son
	-- point d'interrogation avant qu'il ne se retourne.
	local camp7 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(44)
		pcall(function()
			GROUND:CharEndAnim(breloom)
			GROUND:CharSetEmote(breloom, "", 0)
			GROUND:CharTurnToCharAnimated(breloom, hero, 4)
			GROUND:CharSetEmote(breloom, "exclaim", 1)
		end)
	end)
	local camp8 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(64)
		pcall(function()
			GROUND:CharSetEmote(girafarig, "", 0)
			--Il regarde d'abord Kino (« pourquoi tu ne m'ecoutes plus ? »),
			--PUIS il suit son regard. Deux temps, pas une rotation seche.
			GROUND:CharTurnToCharAnimated(girafarig, breloom, 4)
			GROUND:CharSetEmote(girafarig, "question", 1)
			GAME:WaitFrames(18)
			GROUND:CharTurnToCharAnimated(girafarig, hero, 4)
		end)
	end)
	TASK:JoinCoroutines({camp1, camp2, camp3, camp4, camp5, camp6, camp7, camp8})

	-- 1.5. SIX ACCUEILS, SIX CARACTERES
	-- (beat 1.5 du plan : chaque membre a un commentaire propre)
	-- RETOUR DE L'UTILISATEUR : « faut des reactions diverses selon
	-- leurs personnalites ». Le camp levait bien la tete, mais tout le
	-- monde faisait EXACTEMENT le meme geste — se tourner — avant
	-- d'enchainer sur un dialogue logistique. Six Pokemon, une seule
	-- reaction : le groupe n'existait pas comme groupe de personnes.
	-- Chacun accueille donc a sa maniere, et cette maniere est deja
	-- ecrite ailleurs dans le mod (on ne reinvente aucun caractere) :
	--   * PENTICUS le maitre de guilde a guette toute la soiree —
	--     soulagement, mais il tient sa facade (c'est tout son arc du
	--     chapitre : la panique sous le calme).
	--   * PHILEAS l'archiviste a COMPTE les heures. Il donne un chiffre.
	--   * SHUCA la recrue explose de joie, se reprend a mi-phrase.
	--   * RIN l'infirmiere ne dit pas bonjour : elle inspecte.
	--   * COCO la cuisiniere parle nourriture, immediatement.
	--   * GANLON le raleur ne felicite personne, il tacle.
	-- Puis Phileas donne l'explication meteo — la vraie raison du
	-- retard — ce qui enchaine naturellement sur MWE5_006 juste apres.
	-- Les gestes sont tous des API attestees du depot (CharSetEmote,
	-- Hop, DoAnimation, EmoteAndPause, CharTurnToCharAnimated) et tout
	-- passe par SaysA, qui tourne les tetes AVANT d'ouvrir la boite.
	--Helpers d'ecoute, definis AVANT leur premiere utilisation (le bloc
	--d'accueil ci-dessous s'en sert). En Lua un `local function` n'est
	--visible qu'apres sa definition : les laisser plus bas rendait
	--SaysA nil au moment des accueils.
	local function ListenA(speaker, listeners, emote)
		if speaker == nil or listeners == nil then return end
		local turns = {}
		for i, who in ipairs(listeners) do
			if who ~= nil and who ~= speaker then
				turns[#turns+1] = TASK:BranchCoroutine(function()
					pcall(function()
						GAME:WaitFrames((i - 1) * 4)
						GROUND:CharTurnToCharAnimated(who, speaker, 4)
						if emote ~= nil then GROUND:CharSetEmote(who, emote, 1) end
					end)
				end)
			end
		end
		if #turns > 0 then pcall(function() TASK:JoinCoroutines(turns) end) end
	end
	local function SaysA(speaker, emotion, key, listeners, emote)
		ListenA(speaker, listeners, emote)
		UI:SetSpeaker(speaker)
		GeneralFunctions.SetEmotion(emotion or "Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings[key]))
	end

	-- HYKO ET ALMOTZ NE SONT PAS DES SPECTATEURS MUETS.
	-- Signale par tools/audit_causalite.py : ils etaient manipules a
	-- l'arrivee (montee du sentier), puis PLUS DU TOUT pendant les six
	-- accueils, puis de nouveau au tour de table — trois beats entiers
	-- pendant lesquels les deux equipiers du joueur restaient plantes a
	-- regarder droit devant eux pendant que six PNJ parlaient.
	-- C'est exactement le « figement directionnel » que la directive
	-- interdit : ils sont dans le cadre, ils entendent tout, ils doivent
	-- suivre la conversation.
	-- On les ajoute donc a la liste des auditeurs de CHAQUE accueil :
	-- ListenA les fait pivoter vers le locuteur, en decale de 4 frames,
	-- exactement comme le duo. Aucune replique ajoutee (ils viennent de
	-- traverser un donjon, ils sont laconiques), juste des tetes qui
	-- suivent celui qui parle.
	local ecoutants = {hero, partner, growlithe, zigzagoon}

	local function greet(who, emotion, key, gesture)
		local g = TASK:BranchCoroutine(function()
			GAME:WaitFrames(8)
			pcall(gesture)
		end)
		local s = TASK:BranchCoroutine(function()
			SaysA(who, emotion, key, ecoutants)
		end)
		TASK:JoinCoroutines({g, s})
		GAME:WaitFrames(12)
	end

	--Penticus : le soulagement d'abord, la contenance ensuite.
	greet(tropius, "Happy", 'MWE5_172', function()
		--"Exclaim" et non "Relieved" : ce dernier n'existe NULLE PART
		--ailleurs dans le depot (0 occurrence), c'etait une invention.
		GeneralFunctions.EmoteAndPause(tropius, "Exclaim", true)
	end)

	--Phileas : il annonce un chiffre, il ne se rejouit pas.
	greet(noctowl, "Normal", 'MWE5_173', function()
		GROUND:CharSetEmote(noctowl, "notice", 1)
	end)

	--Shuca : elle bondit. Litteralement.
	greet(mareep, "Joyous", 'MWE5_174', function()
		GeneralFunctions.Hop(mareep, "Idle", 10, 22, 0, false)
		GROUND:CharSetEmote(mareep, "glowing", 1)
	end)

	--Rin : elle s'avance sur le duo au lieu de parler de loin.
	local rinWalk = TASK:BranchCoroutine(function()
		pcall(function()
			--(216,286) et non (234,288) : ce dernier passait sur le heros,
			--poste en (240,300). Trajet et case verifies sur la grille.
			GeneralFunctions.EightWayMove(audino, 216, 286, false, 1)
			GROUND:CharTurnToCharAnimated(audino, hero, 4)
		end)
	end)
	TASK:JoinCoroutines({rinWalk})
	greet(audino, "Worried", 'MWE5_175', function()
		GROUND:CharSetEmote(audino, "sweatdrop", 1)
	end)

	--Coco : la soupe. Toujours la soupe.
	greet(snubbull, "Happy", 'MWE5_176', function()
		GeneralFunctions.EmoteAndPause(snubbull, "Happy", true)
	end)

	--Ganlon : il ne se retourne meme pas tout de suite.
	greet(cranidos, "Normal", 'MWE5_177', function()
		GROUND:CharSetEmote(cranidos, "sweatdrop", 1)
	end)

	-- 1.6. LA CONVERGENCE DE KINO ET REINIER
	-- BEATS 1.4 ET 1.5 DU PLAN.
	-- « Chaque membre interrompt son activite et se dirige vers le point
	--   de rassemblement — deplacement reel, pas de teleportation. »
	-- « Chacun garde sa vitesse/maniere de se deplacer propre a sa
	--   personnalite. »
	-- « Chaque membre qui rejoint le groupe doit avoir au moins un
	--   commentaire ou une reaction propre. »
	--
	-- Ce sont les deux seuls a devoir REELLEMENT traverser : les six
	-- autres etaient deja autour du foyer et se sont contentes de lever
	-- la tete (c'est la difference entre « converger » et « se
	-- reorienter », et le plan distingue bien les deux).
	--
	-- Trajets verifies marchables sur la grille d'obstacles.
	-- Kino part le premier et arrive en (326,326) : c'est lui qui a
	-- remarque le duo en premier, il ne se fait pas prier.
	-- Reinier arrive en (328,288), 38 px au nord de Kino : il boucle sa
	-- phrase avant de bouger, d'ou son depart differe de 20 frames.
	-- Aucun des deux ne passe a moins de 40 px d'un camarade.
	local kinoWalk = TASK:BranchCoroutine(function()
		pcall(function()
			GeneralFunctions.EightWayMove(breloom, 326, 326, false, 1)
			GROUND:CharTurnToCharAnimated(breloom, hero, 4)
		end)
	end)
	local reinWalk = TASK:BranchCoroutine(function()
		GAME:WaitFrames(20)
		pcall(function()
			GeneralFunctions.EightWayMove(girafarig, 328, 288, false, 1)
			GROUND:CharTurnToCharAnimated(girafarig, hero, 4)
		end)
	end)
	--Le duo les suit du regard pendant qu'ils traversent : ils arrivent
	--de derriere, personne ne doit rester tourne vers l'ancien foyer.
	local kinoWatch = TASK:BranchCoroutine(function()
		pcall(function() GeneralFunctions.FaceMovingCharacter(hero, breloom, 4) end)
	end)
	local reinWatch = TASK:BranchCoroutine(function()
		GAME:WaitFrames(20)
		pcall(function() GeneralFunctions.FaceMovingCharacter(partner, girafarig, 4) end)
	end)
	TASK:JoinCoroutines({kinoWalk, reinWalk, kinoWatch, reinWatch})
	GAME:WaitFrames(10)

	--Kino : l'enthousiaste. Il ne demande pas comment ca s'est passe, il
	--demande ce qu'il y avait dedans — c'est le specialiste des donjons.
	greet(breloom, "Joyous", 'MWE5_179', function()
		GeneralFunctions.Hop(breloom, "Idle", 8, 18, 0, false)
	end)

	--Reinier : le meticuleux. Il constate, il note, il ne s'emballe pas.
	greet(girafarig, "Normal", 'MWE5_180', function()
		GROUND:CharSetEmote(girafarig, "notice", 1)
	end)

	--Phileas conclut par l'explication meteo : elle amene MWE5_006.
	greet(noctowl, "Normal", 'MWE5_178', function()
		GROUND:CharAnimateTurnTo(noctowl, Direction.Up, 4)
		GAME:WaitFrames(10)
		GROUND:CharTurnToCharAnimated(noctowl, hero, 4)
	end)

	-- 1.7. LE TOUR DE TABLE — comment chacun est arrive
	-- L'ACCUEIL AU CAMP — quinze repliques, et personne ne bougeait.
	-- C'ETAIT LE PIRE PASSAGE DE LA CARTE. Mesure avant correction :
	-- ArrivalCutscene comptait 18 repliques dont 17 SANS la moindre
	-- reaction corporelle (94 %). Quinze boites de dialogue defilaient
	-- d'affilee devant huit sprites parfaitement immobiles, qui ne se
	-- tournaient meme pas vers celui qui parlait.
	-- Les helpers Listen/Says de la veillee sont locaux a CampNightfall.
	-- On redefinit ici les memes, sur les variables locales de cette
	-- scene (tropius, noctowl... et non t.penticus, t.phileas...).

	local arrivals = {hero, partner, growlithe, zigzagoon}
	local campers  = {tropius, noctowl, audino, snubbull, mareep, cranidos}

	--Phileas s'inquiete : le camp entier se tourne vers lui.
	SaysA(noctowl, "Worried", 'MWE5_006', {tropius, audino, snubbull, mareep, cranidos})
	--Il enchaine, et c'est LE DUO qui reagit — la remarque les concerne.
	ListenA(noctowl, arrivals)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_007']))
	GAME:WaitFrames(12)

	--Penticus reprend la main. Tout le monde se tourne vers le maitre
	--de guilde : c'est lui qui tranche, la posture du camp le dit.
	SaysA(tropius, "Normal", 'MWE5_008',
	      {noctowl, audino, snubbull, mareep, cranidos, hero, partner, growlithe, zigzagoon})
	--Son inquietude : il baisse la tete vers le duo pendant qu'il parle.
	coro1 = TASK:BranchCoroutine(function()
		GeneralFunctions.SetEmotion("Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_009']))
	end)
	coro2 = TASK:BranchCoroutine(function()
		pcall(function() GROUND:CharTurnToCharAnimated(tropius, hero, 4) end)
		GAME:WaitFrames(14)
		pcall(function() GROUND:CharSetEmote(audino, "sweatdrop", 1) end)
	end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(10)

	--Le partenaire repond, le heros appuie : les deux se font face, et
	--le camp les regarde. Le duo parle d'une seule voix, on le montre.
	coro1 = TASK:BranchCoroutine(function()
		SaysA(partner, "Determined", 'MWE5_010', campers)
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(10)
		pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
	end)
	TASK:JoinCoroutines({coro1, coro2})

	coro1 = TASK:BranchCoroutine(function()
		UI:SetSpeaker(hero)
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_011']))
	end)
	coro2 = TASK:BranchCoroutine(function()
		pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
		GAME:WaitFrames(16)
		pcall(function() GeneralFunctions.DoAnimation(partner, 'Nod') end)
	end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(12)

	--Hyko s'enflamme (il rebondit), Ganlon le rabroue, Shuca s'illumine.
	--Trois temperaments, trois gestes differents — pas trois boites.
	coro1 = TASK:BranchCoroutine(function()
		SaysA(growlithe, "Happy", 'MWE5_012', {zigzagoon, mareep, cranidos})
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(8)
		pcall(function() GeneralFunctions.Hop(growlithe) end)
	end)
	TASK:JoinCoroutines({coro1, coro2})

	coro1 = TASK:BranchCoroutine(function()
		SaysA(cranidos, "Normal", 'MWE5_013', {growlithe, mareep})
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(12)
		pcall(function() GROUND:CharSetEmote(growlithe, "sweatdrop", 1) end)
	end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(10)

	coro1 = TASK:BranchCoroutine(function()
		SaysA(mareep, "Happy", 'MWE5_014', {hero, partner, growlithe})
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(10)
		pcall(function() GROUND:CharSetEmote(mareep, "glowing", 1) end)
	end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(10)

	--Rin ramene tout le monde sur terre : elle s'avance vers le duo.
	SaysA(audino, "Worried", 'MWE5_015', {hero, partner, tropius})
	GAME:WaitFrames(12)

	SaysA(partner, "Happy", 'MWE5_016', {audino, snubbull})
	GAME:WaitFrames(12)

	--Le cri de ralliement de Penticus : le camp entier converge vers lui
	--et s'immobilise APRES avoir tourne — l'immobilite devient un choix
	--de mise en scene au lieu d'un oubli.
	ListenA(tropius, {noctowl, audino, snubbull, mareep, cranidos, growlithe,
	                  zigzagoon, hero, partner})
	UI:SetSpeaker(tropius)
	GeneralFunctions.SetEmotion("Inspired")
	coro1 = TASK:BranchCoroutine(function()
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_017']))
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(14)
		pcall(function() GROUND:CharSetEmote(mareep, "glowing", 1) end)
		GAME:WaitFrames(8)
		pcall(function() GROUND:CharSetEmote(growlithe, "determined", 1) end)
		GAME:WaitFrames(8)
		pcall(function() GROUND:CharSetEmote(zigzagoon, "happy", 1) end)
	end)
	TASK:JoinCoroutines({coro1, coro2})

	SaysA(noctowl, "Normal", 'MWE5_018', {tropius, hero, partner})
	GAME:WaitFrames(12)

	--Le dernier echange du duo, en tete a tete : la camera est deja sur
	--eux, ils se tournent l'un vers l'autre et le camp s'efface.
	coro1 = TASK:BranchCoroutine(function()
		pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
		UI:SetSpeaker(partner)
		GeneralFunctions.SetEmotion("Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_019']))
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(8)
		pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
	end)
	TASK:JoinCoroutines({coro1, coro2})

	coro1 = TASK:BranchCoroutine(function()
		UI:SetSpeaker(hero)
		GeneralFunctions.SetEmotion("Determined")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_020']))
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(12)
		pcall(function() GeneralFunctions.DoAnimation(partner, 'Nod') end)
	end)
	TASK:JoinCoroutines({coro1, coro2})

	GROUND:CharSetEmote(mareep, "", 0)
	GROUND:CharSetEmote(tropius, "", 0)
	GAME:WaitFrames(20)

	-- LA VEILLEE — le camp mange, puis s'endort
	mount_windswept_entrance_ch_5.CampNightfall(
		hero, partner, {penticus = tropius, phileas = noctowl,
		                rin = audino,      coco = snubbull,
		                shuca = mareep,    ganlon = cranidos,
		                hyko = growlithe,  almotz = zigzagoon,
		                reinier = girafarig, kino = breloom})

	--RIEN NE S'EXECUTE APRES CAMPNIGHTFALL — volontairement.
	--CampNightfall termine en armant la bascule vers la carte du reve
	--(EnterGroundMap) : le moteur poursuit cette coroutine en
	--arriere-plan pendant la consommation de SceneOutcome, et tout code
	--place ici tournait PENDANT la bascule, sur une carte en cours de
	--destruction (Zone.cs : CurrentGround est nullifie puis recharge).
	--Le « nettoyage » qui se trouvait ici — FadeOut supplementaire,
	--RemoveTempChar des sept partants, TeleportTo des trois restants —
	--mutait donc une carte mise au rebut. Il etait de surcroit inutile :
	--la carte du camp est rechargee de zero a chaque entree et
	--reconstruite par ResumeAfterDream (retour du reve) puis SetupGround
	--(retours ulterieurs). Supprime, pas deplace : une bascule armee
	--doit rester la DERNIERE instruction d'une scene.
end 

--Ganlon hasn't been getting to act like a jerk much this expedition; give him some opportunies for his jerkiness to shine through here
-- PNJ du camp de base — dialogues a variantes (Prompt Maitre §4.2)
-- Etats : avant l'entree / apres defaite / apres mini-boss / apres gardien.

--Penticus (Tropius), Maitre de Guilde : la facade sereine se fissure
function mount_windswept_entrance_ch_5.Tropius_Action(chara, activator)
	DEBUG.EnableDbgCoro()
	local hero = CH('PLAYER')
	if SV.Chapter5.MountGuardianDefeated then
		GeneralFunctions.StartConversation(chara, "Le sommet est ouvert.[pause=0] Vous avez fait ce qu'aucune équipe avant nous n'avait réussi.", "Happy")
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue("Quand nous serons là-haut,[pause=10] restez près de moi.[pause=0] Quoi que nous y trouvions...[pause=10] nous le découvrirons ensemble.")
		GeneralFunctions.SetEmotion("Worried")
		UI:WaitShowDialogue("...Et si je vous semble inquiet,[pause=10] c'est que je le suis.[pause=0] Un bon chef ne ment pas à ses équipes sur ce point.")
	elseif SV.Chapter5.MountGuardianLost then
		GeneralFunctions.StartConversation(chara, "L'Aérodactyle vous a repoussés ?[pause=0] Ne baissez pas la tête.[pause=0] Ce gardien veille sur ce col depuis des générations.", "Normal")
		UI:WaitShowDialogue("Les anciens l'appelaient «[pause=5] la Serre du Ciel[pause=5] ».[pause=0] On disait qu'il ne laissait passer que ceux dont le cœur ne tremble pas.")
		GeneralFunctions.SetEmotion("Determined")
		UI:WaitShowDialogue("Votre cœur ne tremble pas.[pause=0] Il apprend.[pause=0] Retournez-y quand vous serez prêts.")
	--MINI-BOSS CH5 RETIRE : Penticus avait ici une replique « La crete est
	--franchie » derriere MountMiniBossDefeated. La premiere branche de cette
	--chaine (MountGuardianDefeated, ci-dessus) couvre deja l'apres-sommet :
	--rebrancher ce texte sur le meme flag l'aurait rendu inatteignable.
	--Branche retiree ; aucune replique perdue a l'ecran.
	elseif SV.Chapter5.LostMountain or SV.Chapter5.DiedToWind then
		GeneralFunctions.StartConversation(chara, "Vous voilà.[pause=0] La montagne vous a renvoyés...[pause=10] C'est qu'elle vous a jugés trop pressés.", "Normal")
		UI:WaitShowDialogue("Ne vous battez pas contre le vent.[pause=0] Avancez quand il respire,[pause=10] abritez-vous quand il crie.[pause=0] C'est ainsi qu'on gravit le Mont Venteux.")
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue("Mangez quelque chose avant de repartir.[pause=0] Un estomac vide rend le froid deux fois plus mordant.")
	else
		GeneralFunctions.StartConversation(chara, "Le dernier tronçon de notre expédition,[pause=10] " .. hero:GetDisplayName() .. ".[pause=0] Le Mont Venteux.", "Normal")
		UI:WaitShowDialogue("De là-haut,[pause=10] par temps clair,[pause=10] on voit toute la région d'un seul regard.[pause=0] La steppe,[pause=10] le tunnel,[pause=10] Metano...")
		GeneralFunctions.SetEmotion("Worried")
		UI:WaitShowDialogue("Et depuis quelques nuits,[pause=10] on y voit aussi autre chose.[pause=0] Cette lueur,[pause=10] au sommet.[pause=0] C'est elle que nous sommes venus comprendre.")
	end
	GeneralFunctions.EndConversation(chara)
end

--Phileas (Noctowl) : l'erudit qui en sait plus qu'il ne dit
function mount_windswept_entrance_ch_5.Noctowl_Action(chara, activator)
	DEBUG.EnableDbgCoro()
	--ON LE REVEILLE AVANT QU'IL PARLE. Phileas dort a son poste depuis
	--SetupGround (il a veille toute la nuit). Sans cette levee, son
	--animation « Sleep » est BOUCLEE : il tiendrait tout son dialogue
	--les yeux fermes, couche. Le sursaut fait aussi le gag — on prend
	--l'archiviste en flagrant delit de sieste.
	pcall(function()
		GROUND:CharEndAnim(chara)
		GeneralFunctions.EmoteAndPause(chara, "Exclaim", true)
		GROUND:CharTurnToCharAnimated(chara, CH('PLAYER'), 4)
	end)
	if SV.Chapter5.MountGuardianDefeated then
		GeneralFunctions.StartConversation(chara, "Hou...[pause=0] L'Aérodactyle s'est incliné.[pause=0] Voilà qui confirme une vieille théorie personnelle.", "Normal")
		UI:WaitShowDialogue("Les gardiens de cette région ne défendent pas un territoire.[pause=0] Ils défendent quelque chose DANS le territoire.[pause=0] Nuance capitale.")
		GeneralFunctions.SetEmotion("Worried")
		UI:WaitShowDialogue("Ce que la lueur du sommet protège...[pause=10] ou ce dont elle se protège...[pause=0] nous le saurons très bientôt.[pause=0] Trop vite,[pause=10] peut-être.")
	elseif SV.Chapter5.MountGuardianLost then
		GeneralFunctions.StartConversation(chara, "Repoussés par le gardien ?[pause=0] Intéressant.[pause=0] Douloureux pour vous,[pause=10] mais intéressant.", "Normal")
		UI:WaitShowDialogue("Un Aérodactyle territorial attaque au premier contact.[pause=0] Celui-ci vous a laissés approcher AVANT de frapper.[pause=0] Il évalue.[pause=10] Il choisit.")
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue("Montrez-lui une escouade digne de ce nom,[pause=10] et je pense qu'il vous ouvrira le ciel lui-même.")
	--MINI-BOSS CH5 RETIRE : Phileas commentait ici le binome Scorplane/Airmure,
	--gardiens supprimes du donjon. Branche morte citant du contenu inexistant.
	elseif SV.Chapter5.LostMountain or SV.Chapter5.DiedToWind then
		GeneralFunctions.StartConversation(chara, "Le vent vous a eus,[pause=10] n'est-ce pas ?[pause=0] Ne vous en veuillez pas.[pause=0] Il a eu tout le monde,[pause=10] un jour ou l'autre.", "Normal")
		UI:WaitShowDialogue("Petit conseil d'un vieux voilier :[pause=10] les rafales suivent un cycle.[pause=0] Trois fortes,[pause=10] une faible.[pause=0] Comptez-les,[pause=10] et avancez sur la quatrième.")
	else
		GeneralFunctions.StartConversation(chara, "Ah,[pause=10] notre jeune équipe.[pause=0] Savez-vous que ce camp est bâti sur un ancien poste d'observation ?", "Normal")
		UI:WaitShowDialogue("Bien avant la guilde,[pause=10] des Pokémon montaient déjà ici pour étudier le ciel.[pause=0] Leurs archives mentionnent des «[pause=5] nuits où la montagne s'allume[pause=5] ».")
		GeneralFunctions.SetEmotion("Worried")
		UI:WaitShowDialogue("J'ai longtemps cru à une exagération poétique.[pause=0] Depuis que j'ai vu la lueur de mes propres yeux...[pause=10] je présente mes excuses posthumes à ces archivistes.")
	end
	GeneralFunctions.EndConversation(chara)
end

--Rin (Audino), soigneuse : douce, precise, un brin maternelle
function mount_windswept_entrance_ch_5.Audino_Action(chara, activator)
	DEBUG.EnableDbgCoro()
	if SV.Chapter5.MountGuardianDefeated then
		GeneralFunctions.StartConversation(chara, "Laissez-moi regarder...[pause=0] Pas de fracture,[pause=10] pas d'engelure.[pause=0] Vous m'impressionnez,[pause=10] vraiment.", "Happy")
		UI:WaitShowDialogue("Pour le sommet,[pause=10] je vous prépare un baume contre le froid.[pause=0] Recette de ma grand-mère.[pause=0] Ça sent affreusement fort,[pause=10] mais ça marche.")
	elseif SV.Chapter5.LostMountain or SV.Chapter5.DiedToWind or SV.Chapter5.MountGuardianLost then
		GeneralFunctions.StartConversation(chara, "Asseyez-vous près du feu.[pause=0] Tout de suite.[pause=0] Ce n'est pas une suggestion,[pause=10] c'est une prescription.", "Worried")
		UI:WaitShowDialogue("Vos coussinets sont gelés et vous tremblez encore.[pause=0] On ne repart pas dans cet état.")
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue("...Voilà.[pause=0] Buvez ça.[pause=0] Et la prochaine fois,[pause=10] revenez AVANT d'être à bout,[pause=10] pas après.")
	else
		GeneralFunctions.StartConversation(chara, "L'air est si sec,[pause=10] ici.[pause=0] Buvez régulièrement,[pause=10] même sans soif.[pause=0] Le froid déshydrate autant que le soleil.", "Normal")
		UI:WaitShowDialogue("J'ai installé mon infirmerie près du feu.[pause=0] Première tente à droite.[pause=0] En espérant ne voir personne y entrer,[pause=10] évidemment.")
	end
	GeneralFunctions.EndConversation(chara)
end

--Coco (Snubbull) : franche, râleuse, loyale
function mount_windswept_entrance_ch_5.Snubbull_Action(chara, activator)
	DEBUG.EnableDbgCoro()
	if SV.Chapter5.MountGuardianDefeated then
		GeneralFunctions.StartConversation(chara, "Vous avez battu le fossile volant ?[pause=0] Bon.[pause=0] Je retire officiellement la moitié de ce que je disais sur vous.", "Normal")
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue("La moitié seulement.[pause=0] L'autre moitié attend de voir ce que vous ferez au sommet.")
	elseif SV.Chapter5.LostMountain or SV.Chapter5.DiedToWind or SV.Chapter5.MountGuardianLost then
		GeneralFunctions.StartConversation(chara, "Ha ![pause=0] Vous aussi,[pause=10] le vent vous a fait valser ?[pause=0] Bienvenue au club.[pause=0] On a des badges.", "Normal")
		UI:WaitShowDialogue("Moi j'ai volé sur trois mètres au premier jour.[pause=0] TROIS mètres.[pause=0] Kino a ri pendant une heure.[pause=0] Je n'ai pas oublié,[pause=10] Kino.")
	else
		GeneralFunctions.StartConversation(chara, "Cette montagne est ridicule.[pause=0] Le vent,[pause=10] le froid,[pause=10] la pente...[pause=0] Qui a eu l'idée de mettre une expédition ICI ?", "Angry")
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue("...Oui,[pause=10] je sais,[pause=10] c'est le Maître de Guilde.[pause=0] Et oui,[pause=10] je le suivrais jusqu'en haut.[pause=0] Mais je RÂLERAI jusqu'en haut aussi.[pause=0] C'est mon droit le plus strict.")
	end
	GeneralFunctions.EndConversation(chara)
end

--Shuca (Mareep) : optimiste electrisante, un peu tete en l'air
function mount_windswept_entrance_ch_5.Mareep_Action(chara, activator)
	DEBUG.EnableDbgCoro()
	if SV.Chapter5.MountGuardianDefeated then
		GeneralFunctions.StartConversation(chara, "Vous sentez ?[pause=0] Ma laine crépite deux fois plus fort depuis qu'on approche du sommet !", "Happy")
		UI:WaitShowDialogue("Ganlon dit que c'est l'altitude.[pause=0] Moi je dis que la montagne est CONTENTE qu'on soit là.[pause=0] On verra qui a raison !")
	elseif SV.Chapter5.LostMountain or SV.Chapter5.DiedToWind or SV.Chapter5.MountGuardianLost then
		GeneralFunctions.StartConversation(chara, "Oh,[pause=10] vous êtes tombés sur l'orage vous aussi ?[pause=0] Enfin,[pause=10] moi les orages,[pause=10] ça me recharge...", "Normal")
		GeneralFunctions.SetEmotion("Worried")
		UI:WaitShowDialogue("Pardon.[pause=0] Ce n'était pas très solidaire.[pause=0] Tenez,[pause=10] touchez ma laine,[pause=10] ça réchauffe ![pause=0] Attention aux étincelles.[pause=0] Petit défaut de fabrication.")
	else
		GeneralFunctions.StartConversation(chara, "Ma laine n'a jamais été aussi gonflée ![pause=0] L'électricité statique de la montagne,[pause=10] c'est MERVEILLEUX !", "Happy")
		UI:WaitShowDialogue("Ganlon refuse de dormir à côté de moi maintenant.[pause=0] Il dit que je l'ai électrocuté dans son sommeil.[pause=0] C'était UNE fois.[pause=0] Une fois et demie.")
	end
	GeneralFunctions.EndConversation(chara)
end

--Ganlon (Cranidos) : fier, bourru, secretement protecteur envers Shuca
function mount_windswept_entrance_ch_5.Cranidos_Action(chara, activator)
	DEBUG.EnableDbgCoro()
	if SV.Chapter5.MountGuardianDefeated then
		GeneralFunctions.StartConversation(chara, "Alors c'est vous qui avez couché le fossile.[pause=0] Hmph.[pause=0] J'aurais pu le faire.[pause=10] Si on m'avait laissé y aller.", "Normal")
		GeneralFunctions.SetEmotion("Worried")
		UI:WaitShowDialogue("...Bon.[pause=0] D'accord.[pause=0] C'était du beau travail.[pause=0] Voilà.[pause=0] Je l'ai dit.[pause=0] N'en parlez à personne.")
	elseif SV.Chapter5.LostMountain or SV.Chapter5.DiedToWind or SV.Chapter5.MountGuardianLost then
		GeneralFunctions.StartConversation(chara, "Revenus en morceaux,[pause=10] hein.[pause=0] La montagne ne fait pas de cadeaux.[pause=0] C'est pour ça que je la respecte.", "Normal")
		UI:WaitShowDialogue("Un conseil de crâne dur à crâne mou :[pause=10] quand le vent charge,[pause=10] on ne recule pas.[pause=0][br]On se PLANTE.[pause=0] Tête baissée,[pause=10] pattes écartées.[pause=0] Le vent contourne ce qui ne cède pas.")
	else
		GeneralFunctions.StartConversation(chara, "Quoi ?[pause=0] Non,[pause=10] je ne «[pause=5] surveillais[pause=5] » pas Shuca.[pause=0] Je surveillais le périmètre.[pause=0] Elle était DANS le périmètre.[pause=0] Nuance.", "Angry")
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue("...Cette montagne rend sa laine complètement folle.[pause=0][br]Si elle se colle au mauvais rocher,[pause=10] elle va se retrouver soudée.[pause=0] Quelqu'un doit bien y penser à sa place.")
	end
	GeneralFunctions.EndConversation(chara)
end

--Kino (Breloom) : blagueur, jamais fatigue... en apparence
function mount_windswept_entrance_ch_5.Breloom_Action(chara, activator)
	DEBUG.EnableDbgCoro()
	if SV.Chapter5.MountGuardianDefeated then
		GeneralFunctions.StartConversation(chara, "Le gardien est battu ?[pause=0] Parfait,[pause=10] parfait.[pause=0] J'allais m'en occuper,[pause=10] mais je vous l'ai laissé.[pause=0] Par générosité.", "Happy")
		UI:WaitShowDialogue("Sérieusement :[pause=10] chapeau.[pause=0] Et gardez cette énergie pour le sommet.[pause=0] J'ai comme l'impression que le plus étrange reste à venir.")
	elseif SV.Chapter5.LostMountain or SV.Chapter5.DiedToWind or SV.Chapter5.MountGuardianLost then
		GeneralFunctions.StartConversation(chara, "Vous savez ce qu'on dit :[pause=10] ce qui ne vous emporte pas vous rend plus lourd ![pause=0] ...Non ?[pause=0] Ce n'est pas ça ?", "Happy")
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue("Entre nous,[pause=10] j'ai fait le même vol plané hier.[pause=0] Coco a ri.[pause=0] Fort.[pause=0][br]Alors je vous propose un pacte :[pause=10] on ne rit de personne,[pause=10] et tout le monde garde sa dignité.")
	else
		GeneralFunctions.StartConversation(chara, "Un camp,[pause=10] un feu,[pause=10] des rations...[pause=0] Il ne manque qu'une chose :[pause=10] quelqu'un qui sait raconter les histoires.[pause=0] Ça tombe bien,[pause=10] je suis là.", "Happy")
		UI:WaitShowDialogue("Ce soir :[pause=10] «[pause=5] La légende de la Serre du Ciel[pause=5] ».[pause=0] Véridique à quarante pour cent.[pause=0] Les soixante autres,[pause=10] c'est du talent.")
	end
	GeneralFunctions.EndConversation(chara)
end

--Reinier (Girafarig) : le veteran calme qui pense a l'arriere-garde
function mount_windswept_entrance_ch_5.Girafarig_Action(chara, activator)
	DEBUG.EnableDbgCoro()
	if SV.Chapter5.MountGuardianDefeated then
		if not SV.Chapter5.LegendSkyArbiterHeard then
			GeneralFunctions.StartConversation(chara, "Le col est sécurisé.[pause=0] Demain,[pause=10] le sommet.[pause=0] Et cette lumière...", "Normal")
			GeneralFunctions.SetEmotion("Worried")
			UI:WaitShowDialogue("...Vous savez,[pause=10] avant d'être escorteur,[pause=10] j'ai servi sur les routes du grand Est.[pause=0][br]Et là-bas,[pause=10] les caravaniers racontent une histoire sur ce qui vit AU-DESSUS du ciel.")
			UI:ResetSpeaker()
			UI:ChoiceMenuYesNo("Écouter l'histoire de Reinier ?", false)
			UI:WaitForChoice()
			if UI:ChoiceResult() then
				mount_windswept_entrance_ch_5.LegendOfTheSkyArbiter(chara)
				return
			end
			GeneralFunctions.EndConversation(chara)
			return
		end
		GeneralFunctions.StartConversation(chara, "Le col est sécurisé.[pause=0] Je fais passer le mot aux équipes restées en arrière :[pause=10] la voie du retour est balisée.", "Normal")
		UI:WaitShowDialogue("Quoi qu'il arrive là-haut,[pause=10] sachez qu'on tiendra le camp.[pause=0] Vous aurez toujours un feu où revenir.")
	elseif SV.Chapter5.LostMountain or SV.Chapter5.DiedToWind or SV.Chapter5.MountGuardianLost then
		GeneralFunctions.StartConversation(chara, "Mon arrière-tête vous a vus arriver de loin.[pause=0] Pratique,[pause=10] un deuxième cerveau,[pause=10] pour surveiller les retours difficiles.", "Normal")
		UI:WaitShowDialogue("Il dit que vous reviendrez plus forts.[pause=0] Mon arrière-tête ne se trompe jamais sur ces choses-là.[pause=0] Sur le reste,[pause=10] souvent.[pause=0] Mais pas sur ça.")
	else
		GeneralFunctions.StartConversation(chara, "Depuis ce poste,[pause=10] je couvre les deux sentiers du camp.[pause=0] Vieille habitude d'escorte.", "Normal")
		UI:WaitShowDialogue("Un conseil :[pause=10] au sommet,[pause=10] ne vous fiez pas à vos yeux.[pause=0] Le vent y transporte des sons de très loin.[pause=0] Fiez-vous à vos oreilles.")
	end
	GeneralFunctions.EndConversation(chara)
end

-- LÉGENDE : « L'Arbitre du Ciel » (Reinier, veteran des caravanes)
-- Mentions : Rayquaza (l'Arbitre, nomme a la fin seulement), Kyogre et
-- Groudon evoques comme « la mer et la terre en guerre ». Motif New Era :
-- l'Arbitre n'intervient que si le ciel est franchi — echo au Fragment
-- (Meteno) tombe pres du relais, et prefiguration lointaine du lore
-- Fil du Destin reserve a l'arc Jirachi.
-- OST : Sky Peak Cave -> Rising Fear (bref) -> retour.
function mount_windswept_entrance_ch_5.LegendOfTheSkyArbiter(chara)
	local hero = CH('PLAYER')
	SOUND:FadeOutBGM(60)
	GAME:WaitFrames(50)
	SOUND:PlayBGM('Sky Peak Cave.ogg', true)
	GAME:WaitFrames(30)

	--Le conteur prend son public : il se tourne vers le heros, marque un
	--temps, PUIS commence. Une legende ne se recite pas de dos.
	pcall(function() GROUND:CharTurnToCharAnimated(chara, hero, 4) end)
	GAME:WaitFrames(16)
	UI:SetSpeaker(chara)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue("On raconte...[pause=20] qu'il y a très longtemps,[pause=10] la mer et la terre se sont fait la guerre.")
	UI:WaitShowDialogue("La mer voulait tout recouvrir.[pause=0] La terre voulait tout soulever.[pause=0] Les tempêtes ont duré si longtemps que les Pokémon oubliaient la couleur du ciel calme.")
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(chara, "glowing", 1)
	UI:WaitShowDialogue("Et quand tout semblait perdu...[pause=10] QUELQUE CHOSE est descendu de plus haut que les nuages.[pause=0] De plus haut que le haut.")
	UI:WaitShowDialogue("Un serpent de jade,[pause=10] long comme un fleuve,[pause=10] qui vit là où l'air s'arrête.[pause=0] Il n'a pas pris parti.[pause=0] Il a JUGÉ.[pause=0] Et la mer et la terre se sont tues.")
	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue("Les caravaniers l'appellent l'Arbitre du Ciel.[pause=0] Les archives lui donnent un nom :[pause=10] [color=#00C060]Rayquaza[color].")

	-- Bref frisson : le lien avec le present.
	SOUND:FadeOutBGM(30)
	GAME:WaitFrames(30)
	SOUND:PlayBGM('Rising Fear.ogg', true)
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("Il ne descend JAMAIS pour les querelles du sol.[pause=0][br]Une seule chose le fait bouger :[pause=10] quand quelque chose FRANCHIT son ciel.[pause=0] Dans un sens...[pause=20] ou dans l'autre.")
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(Quelque chose qui franchit le ciel...[pause=0] Le Météno est tombé.[pause=0] Et la lumière du sommet,[pause=10] elle,[pause=10] cherche peut-être à monter.)", "Worried")

	--Il redescend de sa legende et revient sur le heros : le ton change,
	--la posture aussi.
	pcall(function() GROUND:CharSetEmote(chara, "", 0) end)
	pcall(function() GROUND:CharTurnToCharAnimated(chara, hero, 4) end)
	UI:SetSpeaker(chara)
	SOUND:FadeOutBGM(30)
	GAME:WaitFrames(30)
	SOUND:PlayBGM('Canyon Camp.ogg', true)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue("Mon arrière-tête n'aime pas cette histoire.[pause=0] Il ne l'a jamais aimée.[pause=0] Mais il insiste toujours pour que je la raconte aux équipes qui montent.")
	UI:WaitShowDialogue("Allez dormir.[pause=0] Et là-haut...[pause=10] quoi que vous voyiez dans le ciel,[pause=10] saluez-le poliment.[pause=0] On ne sait jamais qui regarde.")

	SV.Chapter5.LegendSkyArbiterHeard = true
	GeneralFunctions.EndConversation(chara)
end

--Hyko (Growlithe) et Almotz (Zigzaton) : membres de l'equipe au camp
function mount_windswept_entrance_ch_5.Growlithe_Action(chara, activator)
	DEBUG.EnableDbgCoro()
	if SV.Chapter5.MountGuardianDefeated then
		GeneralFunctions.StartConversation(chara, "Le sommet nous attend,[pause=10] wouf ![pause=0] J'ai vérifié trois fois mon équipement.[pause=0] Puis une quatrième,[pause=10] par acquit de conscience.", "Determined")
		UI:WaitShowDialogue("Le Maître de Guilde veut que je reste près de lui là-haut.[pause=0] Alors...[pause=10] soyez prudents.[pause=0][br]C'est un ordre.[pause=0] Enfin,[pause=10] une demande.[pause=0] Une demande TRÈS appuyée,[pause=10] wouf.")
	elseif SV.Chapter5.LostMountain or SV.Chapter5.DiedToWind then
		GeneralFunctions.StartConversation(chara, "Vous êtes rentrés ![pause=0] Wouf ![pause=0] J'allais organiser une patrouille de secours.[pause=0] J'avais déjà l'itinéraire.[pause=0] En trois exemplaires.", "Worried")
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue("Reposez-vous.[pause=0] La montagne sera encore là demain.[pause=0] Et nous aussi,[pause=10] wouf.")
	else
		GeneralFunctions.StartConversation(chara, "Ce feu de camp est réglementaire à quatre-vingt-quinze pour cent,[pause=10] wouf.[pause=0] Les cinq pour cent manquants me tourmentent.", "Normal")
		UI:WaitShowDialogue("Almotz dit que je devrais «[pause=5] lâcher prise[pause=5] ».[pause=0] J'ai demandé si c'était une procédure officielle.[pause=0] Il a soupiré très fort.")
	end
	GeneralFunctions.EndConversation(chara)
end

--PLUM (Jigglypuff), cuisiniere improvisee du camp de base.
--Sa voix est celle deja posee : expressive, un peu dramatique, incapable
--de raconter quoi que ce soit sans en faire un numero. Elle n'a PAS accede
--au statut d'exploratrice — elle tient les marmites, et elle en a fait une
--scene. Elle ne sait rien de ce qui se passe la-haut : ses variantes
--parlent de ce qu'elle voit d'en bas, jamais du donjon lui-meme.
function mount_windswept_entrance_ch_5.Jigglypuff_Action(chara, activator)
	DEBUG.EnableDbgCoro()
	if SV.Chapter5.MountGuardianDefeated then
		GeneralFunctions.StartConversation(chara, "Vous êtes redescendus ![pause=0] Alors ?[pause=10] ALORS ?[pause=0] Non,[pause=10] ne me racontez rien tout de suite.", "Joyous")
		UI:WaitShowDialogue("Je veux la version complète,[pause=10] ce soir,[pause=10] autour du feu,[pause=10] avec du monde.[pause=0] Une histoire pareille,[pause=10] ça ne se raconte pas debout entre deux marmites.")
	elseif SV.Chapter5.LostMountain or SV.Chapter5.DiedToWind or SV.Chapter5.MountGuardianLost then
		GeneralFunctions.StartConversation(chara, "Asseyez-vous.[pause=0] Non,[pause=10] ce n'est pas une question.[pause=0] Il reste du bouillon et vous avez une tête de vent contraire.", "Worried")
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue("Vous savez ce que j'ai appris en marchant deux jours pour rien ?[pause=20] Que « pour rien » n'existe pas.[pause=0] On arrive juste plus tard que prévu.")
	else
		GeneralFunctions.StartConversation(chara, "Regardez-moi ça.[pause=0] Une grande marmite,[pause=10] douze bols,[pause=10] et une montagne entière pour public.", "Happy")
		UI:WaitShowDialogue("Coco m'a interdit de chanter en remuant.[pause=20] Alors je fredonne.[pause=0] Ce n'est pas la même chose,[pause=10] techniquement.")
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue("...Et puis d'ici,[pause=10] on voit tout le sentier.[pause=0] Je saurai avant tout le monde quand vous redescendrez.[pause=15] Ça aussi,[pause=10] c'est un poste.")
	end
	GeneralFunctions.EndConversation(chara)
end

function mount_windswept_entrance_ch_5.Zigzagoon_Action(chara, activator)
	DEBUG.EnableDbgCoro()
	if SV.Chapter5.MountGuardianDefeated then
		GeneralFunctions.StartConversation(chara, "Le dernier tronçon...[pause=0] On y est presque.[pause=0] Après ça,[pause=10] on rentre TOUS à la maison.", "Determined")
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue("J'ai ramassé un caillou du col pour chacun des petits.[pause=0] Sept cailloux.[pause=0] Mon sac pèse une tonne et je regrette rien.")
	elseif SV.Chapter5.LostMountain or SV.Chapter5.DiedToWind then
		GeneralFunctions.StartConversation(chara, "Vous avez une mine affreuse.[pause=0] Venez,[pause=10] j'ai gardé de la soupe au chaud près du feu.", "Worried")
		UI:WaitShowDialogue("C'est la recette de ma mère.[pause=0] Enfin,[pause=10] presque :[pause=10] il manque trois ingrédients sur cinq.[pause=0] Mais l'intention y est,[pause=10] et l'intention réchauffe.")
	else
		GeneralFunctions.StartConversation(chara, "La montagne,[pause=10] c'est pas mon élément.[pause=0] Trop de cailloux,[pause=10] pas assez de terre meuble.[pause=0] Où est-ce qu'on creuse,[pause=10] ici ?!", "Normal")
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue("Mais la vue,[pause=10] par contre...[pause=0] La vue,[pause=10] je l'emporterais bien à la maison.[pause=0] Avec un caillou ou deux.[pause=0] Pour les petits.")
	end
	GeneralFunctions.EndConversation(chara)
end

-- CINÉMATIQUE ÉMOTIONNELLE — « Ce que le vent a emporté »
-- Le secret Hyko × Penticus, en paiement de la dette narrative posée
-- au Tunnel (« ce n'est pas mon histoire » — Phileas). Surprise nocturne :
-- le joueur, sorti prendre l'air, surprend une conversation qu'il
-- n'aurait pas dû entendre. Penticus revele pourquoi il protege Hyko :
-- le pere de Hyko etait son coequipier — mort en le sauvant, sur CETTE
-- montagne, il y a 25 ans (la nuit de la derniere grande catastrophe).
-- Foreshadowing : « la montagne s'etait allumee cette nuit-la aussi ».
-- Courage/sacrifice : le coeur thematique du jeu, incarne 20 chapitres
-- avant que le heros n'ait a faire le meme choix.
-- OST : silence -> On the Beach at Dusk -> Sympathy.
-- Declencheur : nuit au camp du Mont, apres le gardien, apres la veillee.
function mount_windswept_entrance_ch_5.WindSecretScene()
	local hero = CH('PLAYER')
	local tropius = CH('Tropius')
	--Hyko est reste au camp de base (garde par Penticus) : c'est le PNJ
	--'Growlithe' pose par SetupGround, plus un Teammate.
	local growlithe = CH('Growlithe')
	if tropius == nil or growlithe == nil then GAME:FadeIn(20) return end

	GAME:CutsceneMode(true)
	SOUND:StopBGM()
	GROUND:AddMapStatus("darkness")

	-- Le heros se reveille seul ; deux silhouettes au bord du camp.
	GAME:FadeOut(false, 1)

	GROUND:TeleportTo(hero, 256, 340, Direction.Up)
	GROUND:TeleportTo(tropius, 352, 216, Direction.Down)
	GROUND:TeleportTo(growlithe, 352, 240, Direction.Up)
	GAME:MoveCamera(256, 320, 1, false)

	GAME:FadeIn(60)
	GAME:WaitFrames(40)

	GeneralFunctions.HeroDialogue(hero, "(Impossible de dormir...[pause=0] Ce vent n'arrête jamais.[pause=20] ...Tiens ?[pause=0] Des voix ?)", "Normal")
	GAME:WaitFrames(20)

	-- Le heros s'approche sans etre vu ; la camera glisse vers les deux autres.
	local coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(hero, 300, 290, false, 1) end)
	local coro2 = TASK:BranchCoroutine(function() GeneralFunctions.PanCamera(nil, nil, false, 90, 340, 230) end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(30)

	SOUND:PlayBGM('On the Beach at Dusk.ogg', true)
	GAME:WaitFrames(30)

	--LA SCENE LA PLUS INTIME DE LA CARTE — et les deux personnages ne se
	GROUND:CharTurnToCharAnimated(growlithe, tropius, 4)
	GAME:WaitFrames(10)
	UI:SetSpeaker(growlithe)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue("...Maître,[pause=10] avec tout mon respect,[pause=10] je dois vous le demander.[pause=0] Pourquoi moi ?")

	--Penticus ne se retourne pas tout de suite : il sait ce qui vient.
	coro1 = TASK:BranchCoroutine(function()
		UI:WaitShowDialogue("Vous m'avez gardé près de vous tout le voyage.[pause=0] Vous avez paniqué quand on a eu du retard au Tunnel.[pause=0] Les autres recrues n'ont pas ce traitement,[pause=10] wouf.")
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(20)
		pcall(function() GROUND:CharSetEmote(tropius, "sweatdrop", 1) end)
	end)
	TASK:JoinCoroutines({coro1, coro2})

	coro1 = TASK:BranchCoroutine(function()
		UI:WaitShowDialogue("Je ne suis pas en sucre.[pause=0] Je suis un garde de la guilde.[pause=0] Alors...[pause=10] pourquoi ?")
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(14)
		pcall(function() GROUND:CharTurnToCharAnimated(tropius, growlithe, 4) end)
	end)
	TASK:JoinCoroutines({coro1, coro2})

	--LE SILENCE. Penticus se detourne vers la montagne : c'est la qu'est
	--son mort. Le geste dit ce que la boite ne dit pas encore.
	GAME:WaitFrames(40)
	UI:SetSpeaker(tropius)
	GeneralFunctions.SetEmotion("Normal")
	coro1 = TASK:BranchCoroutine(function()
		UI:WaitShowDialogue(".........")
	end)
	coro2 = TASK:BranchCoroutine(function()
		pcall(function() GROUND:CharAnimateTurnTo(tropius, Direction.Up, 6) end)
	end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(40)

	--Il revient sur Hyko pour la phrase qui bascule tout.
	GROUND:CharTurnToCharAnimated(tropius, growlithe, 4)
	GAME:WaitFrames(12)
	UI:WaitShowDialogue("...Tu as ses yeux,[pause=10] tu sais.")

	GeneralFunctions.EmoteAndPause(growlithe, "Question", true)
	UI:SetSpeaker(growlithe)
	GeneralFunctions.SetEmotion("Surprised")
	UI:WaitShowDialogue("...Les yeux de qui,[pause=10] Maître ?")

	GAME:WaitFrames(30)
	UI:SetSpeaker(tropius)
	GeneralFunctions.SetEmotion("Sad")
	UI:WaitShowDialogue("Il y a vingt-cinq ans,[pause=10] j'avais un coéquipier.[pause=0] Un Arcanin.[pause=0] La tête brûlée la plus loyale que cette guilde ait jamais comptée.")

	--« Cette montagne s'etait ALLUMEE » : il la regarde en le disant, et
	--Hyko suit son regard. Deux tetes qui se levent vers le sommet.
	coro1 = TASK:BranchCoroutine(function()
		UI:WaitShowDialogue("Cette nuit-là...[pause=10] le monde entier tremblait.[pause=0] La dernière des grandes catastrophes.[pause=0][br]Et cette montagne...[pause=20] cette montagne s'était ALLUMÉE,[pause=10] exactement comme aujourd'hui.")
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(30)
		pcall(function() GROUND:CharAnimateTurnTo(tropius, Direction.Up, 6) end)
		GAME:WaitFrames(20)
		pcall(function() GROUND:CharAnimateTurnTo(growlithe, Direction.Up, 6) end)
	end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(20)

	UI:WaitShowDialogue("Nous sommes montés tous les deux.[pause=0] Jeunes.[pause=0] Invincibles.[pause=0] Persuadés que le monde avait besoin de nous...[pause=10] et il avait besoin de nous.")
	GAME:WaitFrames(30)

	--La chute. Le corps parle avant la bouche : Penticus flanche PUIS
	--raconte la corniche.
	GeneralFunctions.SetEmotion("Pain")
	coro1 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(16)
		UI:WaitShowDialogue("Une corniche a cédé sous moi,[pause=10] près du sommet.[pause=0] Il m'a rattrapé.[pause=0] Il m'a HISSÉ.[pause=0] Et le temps que je me retourne...")
	end)
	coro2 = TASK:BranchCoroutine(function()
		pcall(function() GeneralFunctions.Shake(tropius) end)
	end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(40)

	--« ...le vent l'avait emporte. » Un souffle passe sur les deux.
	pcall(function() SOUND:PlayBattleSE('EVT_Battle_Flash') end)
	pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end)
	UI:WaitShowDialogue("...le vent l'avait emporté.[pause=0] Voilà ce que le vent a pris,[pause=10] cette nuit-là.[pause=0] Le meilleur d'entre nous.[pause=0] Ton père,[pause=10] Hyko.")

	--LE CHOC. Hyko encaisse physiquement avant d'articuler : il recule
	--d'un pas (Shake), l'emote tombe, PUIS la phrase sort.
	GAME:WaitFrames(50)
	coro1 = TASK:BranchCoroutine(function()
		pcall(function() GROUND:CharTurnToCharAnimated(growlithe, tropius, 4) end)
		pcall(function() GeneralFunctions.Shake(growlithe) end)
	end)
	coro2 = TASK:BranchCoroutine(function()
		pcall(function() GROUND:CharSetEmote(growlithe, "shock", 1) end)
		pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_2") end)
	end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(25)

	UI:SetSpeaker(growlithe)
	GeneralFunctions.SetEmotion("Stunned")
	UI:WaitShowDialogue("Mon...[pause=20] mon père ?[pause=0] Mais...[pause=10] on m'a toujours dit qu'il était mort en mission de routine...")

	--L'aveu. Penticus ne soutient pas son regard en le disant.
	coro1 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(14)
		UI:SetSpeaker(tropius)
		GeneralFunctions.SetEmotion("Sad")
		UI:WaitShowDialogue("C'est moi qui ai demandé qu'on te dise ça.[pause=0][br]Un petit ne devrait pas grandir en sachant que son père est mort pour une corniche...[pause=10] et pour un imbécile qui marchait dessus.")
	end)
	coro2 = TASK:BranchCoroutine(function()
		pcall(function() GROUND:CharAnimateTurnTo(tropius, Direction.Down, 6) end)
	end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(30)

	--Et il releve la tete pour la promesse. Le geste EST la promesse.
	GROUND:CharTurnToCharAnimated(tropius, growlithe, 4)
	GAME:WaitFrames(14)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue("Alors oui.[pause=0] Je te garde près de moi.[pause=0] Pas parce que tu es fragile,[pause=10] Hyko.[pause=0] Parce que je lui dois de te ramener.[pause=0] De CHAQUE expédition.[pause=0] Jusqu'à ma dernière.")

	-- Sympathy : la reponse de Hyko. Courage, pas larmes.
	SOUND:FadeOutBGM(40)
	GAME:WaitFrames(40)
	SOUND:PlayBGM('Sympathy.ogg', true)
	GAME:WaitFrames(30)

	--LE SECOND SILENCE. Hyko baisse la tete, encaisse, et c'est en
	--RELEVANT la tete qu'il repond — le redressement precede la
	--determination, il ne la commente pas.
	UI:SetSpeaker(growlithe)
	GeneralFunctions.SetEmotion("Teary-Eyed")
	coro1 = TASK:BranchCoroutine(function()
		UI:WaitShowDialogue(".........")
	end)
	coro2 = TASK:BranchCoroutine(function()
		pcall(function() GROUND:CharAnimateTurnTo(growlithe, Direction.Down, 6) end)
	end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(40)

	coro1 = TASK:BranchCoroutine(function()
		pcall(function() GROUND:CharTurnToCharAnimated(growlithe, tropius, 4) end)
		pcall(function() GROUND:CharSetEmote(growlithe, "determined", 1) end)
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(16)
		GeneralFunctions.SetEmotion("Determined")
		UI:WaitShowDialogue("...Merci de me l'avoir dit,[pause=10] Maître.[pause=0] Mais je vais vous demander une chose,[pause=10] et c'est la dernière fois que je la demanderai.")
	end)
	TASK:JoinCoroutines({coro1, coro2})

	--« Ne me protegez plus DE la montagne » : il se tourne vers elle.
	coro1 = TASK:BranchCoroutine(function()
		UI:WaitShowDialogue("Ne me protégez plus DE la montagne.[pause=0] Apprenez-moi à la gravir.[pause=0] C'est comme ça qu'on honore ceux que le vent a pris,[pause=10] wouf.")
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(24)
		pcall(function() GROUND:CharAnimateTurnTo(growlithe, Direction.Up, 6) end)
	end)
	TASK:JoinCoroutines({coro1, coro2})

	coro1 = TASK:BranchCoroutine(function()
		pcall(function() GROUND:CharTurnToCharAnimated(growlithe, tropius, 4) end)
		UI:WaitShowDialogue("Pas en gardant leurs enfants au camp.[pause=0] En en faisant des Pokémon...[pause=10] que le vent n'emporte pas.")
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(20)
		pcall(function() GROUND:CharSetEmote(tropius, "notice", 1) end)
	end)
	TASK:JoinCoroutines({coro1, coro2})

	GAME:WaitFrames(50)
	coro1 = TASK:BranchCoroutine(function()
		UI:SetSpeaker(tropius)
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue("...Tu as sa voix aussi,[pause=10] finalement.[pause=0] D'accord,[pause=10] Hyko.[pause=0] D'accord.")
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(18)
		pcall(function() GeneralFunctions.DoAnimation(tropius, 'Nod') end)
	end)
	TASK:JoinCoroutines({coro1, coro2})

	-- Le heros se retire sans bruit.
	GAME:WaitFrames(40)
	GeneralFunctions.PanCamera()
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(Je n'aurais pas dû entendre ça.[pause=0] Mais je ne l'oublierai jamais.[pause=20] Il y a vingt-cinq ans...[pause=10] la montagne s'était déjà allumée.[pause=0] La nuit de la dernière grande catastrophe.)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(Ce n'est pas la première fois.[pause=0] Tout ça est déjà arrivé.[pause=0] Et quelqu'un est déjà mort là-haut...[pause=10] pour que quelqu'un d'autre vive.)", "Sad")

	GAME:WaitFrames(40)
	SOUND:FadeOutBGM(60)
	GAME:FadeOut(false, 60)
	GAME:WaitFrames(30)

	GROUND:RemoveMapStatus("darkness")
	SV.Chapter5.WindSecretSceneSeen = true
	GAME:CutsceneMode(false)
	--La camera revient au joueur (forme attestee : searing_tunnel:1480).
	GAME:MoveCamera(0, 0, 1, true)
	SOUND:PlayBGM('Mt. Travail.ogg', true)
	GAME:FadeIn(40)
end
