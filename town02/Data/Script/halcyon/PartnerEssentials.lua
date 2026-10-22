require 'halcyon.CharacterEssentials'
PartnerEssentials = {}

--helper function, used if a dialogue bit will be used on multiple maps...
local function in_array(value, array)
    for index = 1, #array do
        if array[index] == value then
            return true
        end
    end

    return false -- We could ommit this part, as nil is like false
end

--This function is called to move partner to a specific marker on loading a new map
function PartnerEssentials.InitializePartnerSpawn(dir, customPosition)
	--Each map has an initial point where the partner spawns.
	--Set the Partner Spawn variable to default to let the partner spawn there
	--My nomenclature, to keep things consistent, is to just copy the player's spawn marker's name,
	--add _Partner to the end for the partner's marker.
	--You can specify the dir parameter for a custom direction to spawn as if you want.
	--This function also assigns ground partner AI to the partner so they actually follow you.

	if GAME:GetPlayerPartyCount() < 2 then return end --do nothing if party is only size 1

	local partner = CH('Teammate1')
	local player = CH('PLAYER')


	--in case a custom position is ever needed
	if customPosition ~= nil then
		dir = dir or partner.Direction
		GROUND:TeleportTo(partner, customPosition.X, customPosition.Y, dir)
	--otherwise use the marker system
	elseif SV.partner.Spawn ~= 'Default' then
		local player = CH('PLAYER')
		local marker = MRKR(SV.partner.Spawn)

		--Failsafe. Sometimes the spawn variable isn't handled properly, and you get to a map with an invalid marker.
		--If this happens, act as though the marker is 'Default'. I.e. do nothing.
		--The bug this failsafe fixes sometimes happens in normal gameplay but typically doesn't cause any visible issues. This is more of an issue with debugging requiring a map reload depending on how you get to it.
		if marker ~= nil then
			dir = dir or marker.Direction or partner.Direction
			GROUND:TeleportTo(partner, marker.Position.X, marker.Position.Y, dir)
		else
			print('partner position marker failsafe hit')
		end
	end


	AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
    partner.CollisionDisabled = true
	partner.InteractOrder = 1--if partner and another NPC overlap, the partner is deprioritized and won't be spoken to, the other npc will

end

--when reloading a save, load the partner back in at the proper coordinates.
function PartnerEssentials.LoadGamePartnerPosition(partner)
	print("loading partner in, activating their AI")
	if partner == nil then return end
	local hero = CH('PLAYER')
	local x = SV.partner.LoadPositionX
	local y = SV.partner.LoadPositionY
	-- Fix audit 2026-07-27 : failsafe. Si la position sauvegardee est invalide
	-- (-1 par defaut) ou aberrante (tres loin du heros = reliquat d'une autre
	-- carte), on repositionne le partenaire a cote du heros au lieu de le
	-- teleporter a un point deconnecte de la scene.
	local valid = (x ~= nil and y ~= nil and x >= 0 and y >= 0)
	if valid and hero ~= nil then
		local dx = x - hero.Position.X
		local dy = y - hero.Position.Y
		if dx * dx + dy * dy > 240 * 240 then valid = false end
	end
	if valid then
		GROUND:TeleportTo(partner, x, y, PartnerEssentials.NumToDir(SV.partner.LoadDirection))--sv doesn't seem to like storing custom classes
	elseif hero ~= nil then
		GROUND:TeleportTo(partner, hero.Position.X + 32, hero.Position.Y, Direction.Left)
	end
	AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
	AI:EnableCharacterAI(partner)
end

--when saving the game, make note of where the partner is and where they're facing so we can reload them that way.
function PartnerEssentials.SaveGamePartnerPosition(partner)
	SV.partner.LoadPositionX = partner.Position.X
	SV.partner.LoadPositionY = partner.Position.Y
	SV.partner.LoadDirection = PartnerEssentials.DirToNum(partner.Direction)--sv doesnt seem to like storing custom classes
end


--assigns a number value to each direction, useful for figuring out how many turn a direction is from another
function PartnerEssentials.DirToNum(dir)
	--up is 0, upright is 1, ... up left is 7
	local num = -1
	if dir == Direction.Up then
		num = 0
	elseif dir == Direction.UpRight then
		num = 1
	elseif dir == Direction.Right then
		num = 2
	elseif dir == Direction.DownRight then
		num = 3
	elseif dir == Direction.Down then
		num = 4
	elseif dir == Direction.DownLeft then
		num = 5
	elseif dir == Direction.Left then
		num = 6
	elseif dir == Direction.UpLeft then
		num = 7
	end

	return num

end


--converts a number to a direction
function PartnerEssentials.NumToDir(num)
	local dir = Direction.None
	if num % 8 == 0 then
		dir = Direction.Up
	elseif num % 8 == 1 then
		dir = Direction.UpRight
	elseif num % 8 == 2 then
		dir = Direction.Right
	elseif num % 8 == 3 then
		dir = Direction.DownRight
	elseif num % 8 == 4 then
		dir = Direction.Down
	elseif num % 8 == 5 then
		dir = Direction.DownLeft
	elseif num % 8 == 6 then
		dir = Direction.Left
	elseif num % 8 == 7 then
		dir = Direction.UpLeft
	end

	return dir
end



--[[
partner's dialogue can be changed by walking over markers that indicate where in a map you're standing. This gives you the ability
to have the partner's dialogue be much more dynamic than the normal PMD games. This command is basically just going to a giant
case statement methinks.
]]--
function PartnerEssentials.GetPartnerDialogue(partner)

	--BUG CORRIGE : cette fonction chargeait « Chapter_<N>_Dialogue » sans
	--verifier son existence. Or seules les variantes 1 a 4 sont ecrites.
	--A partir du chapitre 5, `load` produisait un appel a une valeur nil,
	--pcall renvoyait false, et l'assert levait une erreur Lua — parler au
	--partenaire hors donjon cassait donc le script de la carte (entree du
	--Mont, relais, Foret Lugubre, Ruines...).
	--On resout maintenant la fonction par une vraie recherche de table,
	--avec repli sur la variante la plus recente disponible.
	if partner == nil then return end

	local chapter = SV.ChapterProgression.Chapter or 1
	local fn = PartnerEssentials['Chapter_' .. tostring(chapter) .. '_Dialogue']

	--Repli : on redescend vers le chapitre ecrit le plus proche, pour que
	--le partenaire ait toujours QUELQUE CHOSE a dire plutot que planter.
	if type(fn) ~= 'function' then
		for c = chapter - 1, 1, -1 do
			local alt = PartnerEssentials['Chapter_' .. tostring(c) .. '_Dialogue']
			if type(alt) == 'function' then
				PrintInfo('[PARTENAIRE] aucun dialogue pour le chapitre ' ..
				          tostring(chapter) .. ' -> repli sur le chapitre ' .. tostring(c))
				fn = alt
				break
			end
		end
	end

	if type(fn) ~= 'function' then
		PrintInfo('[PARTENAIRE] aucun dialogue disponible (chapitre ' ..
		          tostring(chapter) .. ')')
		return
	end

	--pcall conserve : une erreur DANS le dialogue ne doit pas figer le
	--joueur en mode conversation. On trace au lieu de laisser filer.
	local ok, err = pcall(fn, partner)
	if not ok then
		PrintInfo('[PARTENAIRE] erreur de dialogue : ' .. tostring(err))
		--Filet de securite : sans ca, le duo resterait bloque en
		--IsInteracting/CharSetAnim si l'erreur survient au milieu.
		pcall(function()
			local hero = CH('PLAYER')
			GROUND:CharEndAnim(partner)
			GROUND:CharEndAnim(hero)
			partner.IsInteracting = false
		end)
	end

end



--subfunctions that contain dialogue used in each chapter for partner follow dialogue
--TODO: Think of a way to make this less Yandere-Dev
--ground names as a key into a table perhaps? Might get kind of funky when it comes to flag or marker conditionals... At least separate by grounds I think.
function PartnerEssentials.Chapter_1_Dialogue(partner)
	local ground = GAME:GetCurrentGround().AssetName--get ground's internal name
	UI:SetSpeaker(partner)
	local hero = CH('PLAYER')
	partner.IsInteracting = true
	GROUND:CharSetAnim(partner, 'None', true)
	GROUND:CharSetAnim(hero, 'None', true)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	GeneralFunctions.SetEmotion('Normal')

	if ground == 'guild_second_floor' then
		--PartnerSecondFloorDialogue flag is 0-3, 0 happens once, 1 is a default message, and 2 and 3 are after speaking to guildmates. it cycles through available dialogues
		if SV.Chapter1.PartnerSecondFloorDialogue == 0 then
			UI:WaitShowDialogue("C'est ici que la guilde publie les offres d'emploi et les demandes d'aventuriers.")
			UI:WaitShowDialogue("De nombreux Pokémon différents se rassemblent ici tous les jours.[pause=0]Je suis sûr que nous rencontrerons toutes sortes de Pokémon ici !")
			GAME:WaitFrames(20)
			UI:WaitShowDialogue("Vous savez...[pause=0]Avant aujourd'hui,[pause=10]c'était la seule partie de l'intérieur de la guilde que j'avais vue.")
			GeneralFunctions.SetEmotion("Sad")
			UI:WaitShowDialogue("Sans partenaire,[pause=10] ils ne m'ont même pas donné la chance de devenir apprenti...")
			UI:WaitShowDialogue("Je n'ai donc jamais vu la zone à l'étage ni le maître de guilde jusqu'à aujourd'hui.")
			GAME:WaitFrames(20)
			GeneralFunctions.SetEmotion("Inspired")
			UI:WaitShowDialogue("Mais ce n'est pas grave ![pause=0]Nous sommes avec la guilde maintenant et c'est tout ce qui compte !")
			UI:WaitShowDialogue("Nous allons former une équipe fantastique " .. hero:GetDisplayName() .. "![pause=0]Je sais que nous allons faire du bien !")
			SV.Chapter1.PartnerSecondFloorDialogue = 1
			if SV.Chapter1.MetCranidosMareep then
				SV.Chapter1.PartnerSecondFloorDialogue = 2
			elseif SV.Chapter1.MetZigzagoon then
				SV.Chapter1.PartnerSecondFloorDialogue = 3
			end
		elseif SV.Chapter1.PartnerSecondFloorDialogue == 1 then
			UI:WaitShowDialogue("C'est ici que la guilde publie les offres d'emploi et les demandes d'aventuriers.")
			UI:WaitShowDialogue("De nombreux Pokémon différents se rassemblent ici tous les jours.[pause=0]Je suis sûr que nous rencontrerons toutes sortes de Pokémon ici !")
			if SV.Chapter1.MetCranidosMareep then
				SV.Chapter1.PartnerSecondFloorDialogue = 2
			elseif SV.Chapter1.MetZigzagoon then
				SV.Chapter1.PartnerSecondFloorDialogue = 3
			end
		elseif SV.Chapter1.PartnerSecondFloorDialogue == 2 then--mareep/cranidos dialogue
			GeneralFunctions.SetEmotion("Angry")
			GROUND:CharSetEmote(partner, "angry", 0)
			UI:WaitShowDialogue("Ce " .. CharacterEssentials.GetCharacterName('Cranidos') .. "...[pause=0]Quel tyran !")
			UI:WaitShowDialogue("Je n'arrive toujours pas à croire à quel point il a été irrespectueux !")
			GAME:WaitFrames(20)
			GROUND:CharSetEmote(partner, "", 0)
			GeneralFunctions.SetEmotion("Normal")
			UI:WaitShowDialogue("Cependant, " .. CharacterEssentials.GetCharacterName('Mareep') .. " était très gentille.[pause=0]Je suis curieux de savoir ce qu'elle a à nous montrer sur les hors-la-loi.")
			GeneralFunctions.SetEmotion("Happy")
			UI:WaitShowDialogue("Elle doit être douée pour gérer les mauvais Pokémon si elle peut garder " .. CharacterEssentials.GetCharacterName('Cranidos') .. " sous contrôle,[pause=10]haha !")
			if SV.Chapter1.MetZigzagoon then
				SV.Chapter1.PartnerSecondFloorDialogue = 3
			else
				SV.Chapter1.PartnerSecondFloorDialogue = 1
			end
		elseif SV.Chapter1.PartnerSecondFloorDialogue == 3 then
			GeneralFunctions.SetEmotion('Worried')
			UI:WaitShowDialogue("Pensez-vous que " .. CharacterEssentials.GetCharacterName('Zigzagoon') .. " va nous mettre dans son almanach ?")
			GeneralFunctions.SetEmotion("Normal")
			UI:WaitShowDialogue("Nous devrons vérifier après un moment pour voir,[pause=10]je suppose.[pause=0]Je veux savoir ce qu'il écrirait sur nous !")
			SV.Chapter1.PartnerSecondFloorDialogue = 1
		end
	elseif ground == 'guild_third_floor_lobby' then
		UI:WaitShowDialogue("Cela ressemble au hall d'entrée...")
		UI:WaitShowDialogue("Mais il semble qu'il n'y ait personne ici.[pause=0]Regardons dans les autres pièces !")
	elseif ground == 'guild_dining_room' then
		if SV.Chapter1.MetSnubbull then
			GeneralFunctions.SetEmotion("Inspired")
			UI:WaitShowDialogue("J'ai hâte de manger un repas avec tous nos nouveaux camarades de guilde !")
			UI:WaitShowDialogue("Je n'ai jamais mangé à une grande table comme celle-ci auparavant !")
			GeneralFunctions.SetEmotion("Normal")
			UI:WaitShowDialogue("J'espère juste que " .. CharacterEssentials.GetCharacterName("Snubbull") .. " est aussi bonne qu'un chef comme elle le prétend.")
		else
			UI:WaitShowDialogue("Oh,[pause=10] ça doit être la salle à manger.[pause=0]Vous pensez que la nourriture ici est bonne ?")
		end

	elseif ground == 'guild_heros_room' then
		if SV.Chapter1.MetSnubbull and SV.Chapter1.MetZigzagoon and SV.Chapter1.MetCranidosMareep and SV.Chapter1.MetBreloomGirafarig and SV.Chapter1.MetAudino then
			UI:WaitShowDialogue("Bâillement...[pause=0]Je commence à avoir sommeil...")
			UI:WaitShowDialogue("Faisons un peu de repos pour être prêts pour le début de notre entraînement demain !")
		else
			GeneralFunctions.SetEmotion("Inspired")
			UI:WaitShowDialogue("Tu peux croire qu'on a une chambre aussi jolie ?")
			UI:WaitShowDialogue("Le reste de la guilde doit être aussi sympa !")
			GeneralFunctions.SetEmotion("Normal")
			UI:WaitShowDialogue("Nous devrions aller explorer la guilde et dire bonjour à tous nos nouveaux camarades de guilde !")
		end
	elseif ground == 'guild_bottom_left_bedroom' then
		if SV.Chapter1.MetBreloomGirafarig then
			GeneralFunctions.SetEmotion("Stunned")
			UI:WaitShowDialogue("Ces deux-là forment de nombreux personnages,[pause=10] n'est-ce pas... ?")
			UI:WaitShowDialogue("Surtout que " .. CharacterEssentials.GetCharacterName("Girafarig") .. "...[pause=0]je ne sais toujours pas quoi penser de lui...")
			GAME:WaitFrames(20)
			GeneralFunctions.SetEmotion("Happy")
			UI:WaitShowDialogue("Eh bien,[pause=10] ils sont tous les deux amicaux de toute façon.[pause=0]Je suppose que c'est tout ce qui compte.")
		else
			UI:WaitShowDialogue("Oh,[pause=10] il y a quelques Pokémon là-bas ![pause=0]Disons bonjour !")
		end

	elseif in_array(ground, {'guild_bottom_right_bedroom',
							 'guild_top_left_bedroom'}) then
		UI:WaitShowDialogue("Cela ressemble à l'une des chambres.")
		UI:WaitShowDialogue("Cependant, personne ne semble être ici en ce moment,[pause=10]vérifions quelques-unes des autres pièces !")

	elseif ground == 'guild_top_right_bedroom' then
		if SV.Chapter1.MetSnubbull and SV.Chapter1.MetZigzagoon and SV.Chapter1.MetCranidosMareep and SV.Chapter1.MetBreloomGirafarig and SV.Chapter1.MetAudino then
			UI:WaitShowDialogue("On dirait que " .. CharacterEssentials.GetCharacterName("Audino") .. " a enfin terminé toutes ses corvées.")
			UI:WaitShowDialogue("Laissez-la dormir,[pause=10] il vaut probablement mieux que nous allions en chercher maintenant aussi.")
		else
			UI:WaitShowDialogue("Cela ressemble à l'une des chambres.")
			UI:WaitShowDialogue("Cependant, personne ne semble être ici en ce moment,[pause=10]vérifions quelques-unes des autres pièces !")
		end

	elseif ground == 'guild_bedroom_hallway' then
		UI:WaitShowDialogue("Je suppose que les pièces sur les côtés du couloir sont les chambres des autres membres de la guilde.")
		GeneralFunctions.SetEmotion("Worried")
		UI:WaitShowDialogue("J'espère que nous ne serions pas intrusifs si nous entrions.")

	elseif ground == 'guild_storage_hallway' then
		GeneralFunctions.SetEmotion("Worried")
		UI:WaitShowDialogue("Pensez-vous que " .. CharacterEssentials.GetCharacterName("Audino") .. " devient aussi fou tous les soirs ?")
		UI:WaitShowDialogue("J'ai l'impression que tu n'es pas le premier Pokémon sur lequel elle s'écrase...")
	elseif ground == 'guild_storage_room' then
		UI:WaitShowDialogue("Cela ressemble à la salle de stockage.[pause=0]Ils gardent probablement la plupart de la nourriture et des fournitures ici.")
		GeneralFunctions.SetEmotion("Worried")
		UI:WaitShowDialogue("Je ne toucherais à rien.[pause=0]Nous ne voulons pas avoir d'ennuis...")

	else
		UI:WaitShowDialogue("Impossible de trouver le chapitre 1 Dialogue pour ce motif. C'est un bug. Dites-le à Palika.")

	end

	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	partner.IsInteracting = false

end


function PartnerEssentials.Chapter_2_Dialogue(partner)
	local ground = GAME:GetCurrentGround().AssetName--get ground's internal name
	UI:SetSpeaker(partner)
	local hero = CH('PLAYER')
	partner.IsInteracting = true
	GROUND:CharSetAnim(partner, 'None', true)
	GROUND:CharSetAnim(hero, 'None', true)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	GeneralFunctions.SetEmotion('Normal')

	--yes i know this is yandere dev shit i dont know how better to structure this. a lua table doesn't really make sense here without having to do a bunch of extra bullshit that i feel makes it less categorized/ordered.
	--can redo this with a better approach if a good one can be figured out.
	if ground == 'guild_heros_room' then
		if SV.TemporaryFlags.JustWokeUp then
			GeneralFunctions.SetEmotion("Happy")
			UI:WaitShowDialogue("Bonjour,[pause=10]" .. hero:GetDisplayName() .. " !")
			if not SV.Chapter2.FirstMorningMeetingDone then
				GeneralFunctions.SetEmotion("Normal")
				UI:WaitShowDialogue("Nous ferions mieux de nous rendre à la réunion du matin avant de rater quelque chose ![pause=0]C'est parti !")
			end
		elseif not SV.Chapter2.FinishedFirstDay then
			GeneralFunctions.SetEmotion("Worried")
			UI:WaitShowDialogue("Cela aurait été bien si nous avions pu dormir un peu plus longtemps...")
			GeneralFunctions.SetEmotion("Normal")
			UI:WaitShowDialogue("Ah bien.[pause=0]Nous avons des choses plus importantes à faire que dormir,[pause=10]de toute façon.")
			UI:WaitShowDialogue("Direction le dojo pour l'entraînement,[pause=10]" .. hero:GetDisplayName() .. ".")
		else
			GeneralFunctions.SetEmotion("Determined")
			local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("illuminant_riverbed")
			UI:WaitShowDialogue("Ce n’est pas le moment de se reposer,[pause=10]" .. hero:GetDisplayName() .. " !")
			GeneralFunctions.SetEmotion("Normal")
			UI:WaitShowDialogue("Nous devons nous rendre à " .. zone:GetColoredName() .. " pour trouver " .. CharacterEssentials.GetCharacterName("Numel") .. "![pause=0]C'est parti !")
		end

	elseif ground == 'guild_bottom_left_bedroom' then
		if not SV.Chapter2.FinishedFirstDay then
			GeneralFunctions.SetEmotion("Worried")
			UI:WaitShowDialogue("Je ne suis toujours pas sûr à cent pour cent de qui a quelle chambre...")
			UI:WaitShowDialogue("Mais étant donné que nous les avons vus ici l'autre jour,[pause=10] je pense que c'est la chambre de " .. CharacterEssentials.GetCharacterName("Breloom") .. " et " .. CharacterEssentials.GetCharacterName("Girafarig") .. ".")
			UI:WaitShowDialogue("... Aussi gentils soient-ils,[pause=10] je suis toujours un peu effrayé par " .. CharacterEssentials.GetCharacterName("Tail") .. ",[pause=10]pour être honnête.")
		else
			local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("illuminant_riverbed")
			GeneralFunctions.SetEmotion("Determined")
			UI:WaitShowDialogue("Allez " .. hero:GetDisplayName() .. " ![pause=0]Nous avons mieux à faire que de fouiner dans la chambre de " .. CharacterEssentials.GetCharacterName("Breloom") .. " et " .. CharacterEssentials.GetCharacterName("Girafarig") .. " !")
			GeneralFunctions.SetEmotion("Normal")
			UI:WaitShowDialogue("Nous devons nous rendre à " .. zone:GetColoredName() .. " pour trouver " .. CharacterEssentials.GetCharacterName("Numel") .. "![pause=0]C'est parti !")
		end
	elseif ground == 'guild_bottom_right_bedroom' then
		if not SV.Chapter2.FinishedFirstDay then
			GeneralFunctions.SetEmotion("Worried")
			UI:WaitShowDialogue("Hmm...[pause=0]Étant donné tous les livres et papiers éparpillés,[pause=10] je suppose que c'est la chambre de " .. CharacterEssentials.GetCharacterName('Zigzagoon') .. ".")
			UI:WaitShowDialogue("Je pense que " .. CharacterEssentials.GetCharacterName("Growlithe") .. " m'a mentionné une fois que " .. CharacterEssentials.GetCharacterName('Zigzagoon') .. " était son partenaire,[pause=10]donc ça doit être aussi sa chambre.")
			GeneralFunctions.SetEmotion("Normal")
			UI:WaitShowDialogue("Pendant que nous sommes ici,[pause=10] pourquoi ne pas jeter un coup d'œil rapide aux almanachs sur lesquels " .. CharacterEssentials.GetCharacterName("Zigzagoon") .. " a travaillé ?")
			UI:WaitShowDialogue("Je parie qu'ils contiennent des connaissances utiles !")
		else
			UI:WaitShowDialogue("Vous regardez les almanachs avant de partir ?[pause=0]Bonne idée !")
			UI:WaitShowDialogue("Je suis sûr que certaines informations qu'ils contiennent pourraient nous aider dans notre sauvetage ![pause=0]Ne prenez pas trop de temps cependant !")
		end
	elseif ground == 'guild_top_left_bedroom' then
		if not SV.Chapter2.FinishedFirstDay then
			GeneralFunctions.SetEmotion("Worried")
			UI:WaitShowDialogue("Étant donné à qui appartiennent les autres chambres,[pause=10] il doit s'agir de la chambre de " .. CharacterEssentials.GetCharacterName("Mareep") .. " et " .. CharacterEssentials.GetCharacterName("Cranidos") .. ".")
			GeneralFunctions.SetEmotion("Pain")
			UI:WaitShowDialogue("Nous ferions mieux de partir.[pause=0]Je ne veux pas me disputer avec " .. CharacterEssentials.GetCharacterName("Cranidos") .. " s'il nous surprend ici...")
		else
			local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("illuminant_riverbed")
			GeneralFunctions.SetEmotion("Determined")
			UI:WaitShowDialogue("Allez " .. hero:GetDisplayName() .. " ![pause=0]Nous avons mieux à faire que de fouiner dans la chambre de " .. CharacterEssentials.GetCharacterName("Mareep") .. " et " .. CharacterEssentials.GetCharacterName("Cranidos") .. " !")
			GeneralFunctions.SetEmotion("Normal")
			UI:WaitShowDialogue("Nous devons nous rendre à " .. zone:GetColoredName() .. " pour trouver " .. CharacterEssentials.GetCharacterName("Numel") .. "![pause=0]C'est parti !")
		end
	elseif ground == 'guild_top_right_bedroom' then
		if not SV.Chapter2.FinishedFirstDay then
			GeneralFunctions.SetEmotion("Worried")
			UI:WaitShowDialogue("Je pense avoir vu " .. CharacterEssentials.GetCharacterName("Snubbull") .. " entrer dans cette pièce hier soir...")
			GeneralFunctions.SetEmotion("Normal")
			UI:WaitShowDialogue("Je pense que " .. CharacterEssentials.GetCharacterName("Audino") .. " est son partenaire,[pause=10]donc ça doit être leur chambre.")
			UI:WaitShowDialogue("Ces deux-là font certainement une grande partie du travail autour de la guilde elle-même,[pause=10] n'est-ce pas ?")
			UI:WaitShowDialogue("C'est peut-être pour ça qu'ils forment une paire.")
		else
			local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("illuminant_riverbed")
			GeneralFunctions.SetEmotion("Determined")
			UI:WaitShowDialogue("Allez " .. hero:GetDisplayName() .. " ![pause=0]Nous avons mieux à faire que de fouiner dans la chambre de " .. CharacterEssentials.GetCharacterName("Audino") .. " et " .. CharacterEssentials.GetCharacterName("Snubbull") .. " !")
			GeneralFunctions.SetEmotion("Normal")
			UI:WaitShowDialogue("Nous devons nous rendre à " .. zone:GetColoredName() .. " pour trouver " .. CharacterEssentials.GetCharacterName("Numel") .. "![pause=0]C'est parti !")
		end
	elseif in_array(ground, {'guild_bedroom_hallway',
							 'guild_third_floor_lobby',
							 'guild_second_floor',
							 'guild_first_floor',
							 'guild_storage_hallway'}) then
		if not SV.Chapter2.FinishedNumelTantrum then
			UI:WaitShowDialogue("Rendons-nous au Ledian Dojo pour notre formation,[pause=10]" .. hero:GetDisplayName() .. " !")
			UI:WaitShowDialogue(CharacterEssentials.GetCharacterName("Noctowl") .. " a indiqué qu'il traversait le pont menant à la guilde,[pause=10]puis descendait une échelle à l'est.")
		elseif not SV.Chapter2.FinishedFirstDay then
			UI:WaitShowDialogue("Montons à l'étage vers la salle à manger et dînons,[pause=10]" .. hero:GetDisplayName() .. "![pause=0]Je meurs de faim !")
		else
			local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("illuminant_riverbed")
			UI:WaitShowDialogue(hero:GetDisplayName() .. "![pause=0]Nous devons sauver " .. CharacterEssentials.GetCharacterName("Numel") .. " !")
			UI:WaitShowDialogue("Nous devrions nous préparer en ville,[pause=10] puis nous diriger vers le nord hors de la ville jusqu'à " .. zone:GetColoredName() .. " pour le trouver !")
		end

	elseif ground == 'guild_dining_room' then
		if not SV.Chapter2.FinishedFirstDay then
			GeneralFunctions.SetEmotion("Happy")
			UI:WaitShowDialogue("J'espère bien que " .. CharacterEssentials.GetCharacterName("Snubbull") .. " fera quelque chose de savoureux ce soir.")
			UI:WaitShowDialogue("Je ne sais pas quel genre de choses elle fait,[pause=10]mais j'espère qu'il y aura des Orans confits pour le dessert.")
			GeneralFunctions.SetEmotion("Joyous")
			UI:WaitShowDialogue("C'est mon dessert préféré !")
		else
			GeneralFunctions.SetEmotion("Happy")
			UI:WaitShowDialogue("Le dîner d'hier soir était génial ![pause=0]" .. CharacterEssentials.GetCharacterName('Snubbull') .. " est un grand chef après tout !")
			UI:WaitShowDialogue("Je sais que nous avons une mission à accomplir maintenant et tout...[br]Mais mon esprit ne peut s'empêcher de penser à ce qu'il y a pour le dîner ce soir pendant que je suis ici !")
		end
	elseif ground == 'guild_guildmasters_room' then
		if not SV.Chapter2.FinishedFirstDay then
			GeneralFunctions.SetEmotion("Inspired")
			UI:WaitShowDialogue("Le maître de guilde était un aventurier extraordinaire qui a voyagé partout dans le monde avant de rejoindre la guilde.")
			UI:WaitShowDialogue("Ses exploits font partie de la raison pour laquelle je voulais tellement devenir un aventurier !")
			GeneralFunctions.SetEmotion("Worried")
			UI:WaitShowDialogue("Je ne sais pas pourquoi il a décidé de créer la guilde.")
			GeneralFunctions.SetEmotion("Joyous")
			UI:WaitShowDialogue("Si j'étais à sa place,[pause=10] je voudrais explorer et aventurer toute ma vie ![pause=0]Haha !")
		elseif not SV.Chapter2.TropiusGaveReviver then
			GeneralFunctions.SetEmotion("Worried")
			UI:WaitShowDialogue("Je me demande si le maître de guilde peut nous aider dans notre mission ?[pause=0]Peut-être qu'il a quelques conseils ou quelque chose du genre.")
		else
			local itemname = RogueEssence.Dungeon.InvItem("seed_reviver"):GetDisplayName()
			GeneralFunctions.SetEmotion("Happy")
			UI:WaitShowDialogue("C'était gentil de la part du Maître de Guilde de nous donner ce " .. itemname .. ".")
			UI:WaitShowDialogue("Cela sera utile si l'un de nous se retrouve dans une mauvaise situation.")
		end
	elseif ground == 'guild_storage_room' then
		if not SV.Chapter2.FinishedFirstDay then
			GeneralFunctions.SetEmotion("Worried")
			UI:WaitShowDialogue("Je sais qu'on ne devrait toucher à rien ici,[pause=10]mais...")
			GeneralFunctions.SetEmotion("Normal")
			UI:WaitShowDialogue("Je ne peux m'empêcher de me demander quel genre de choses sont stockées ici en dehors de la nourriture.")
			UI:WaitShowDialogue("Pensez-vous qu'il y a quelque chose de cool ici ?")
		else
			local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("illuminant_riverbed")
			GeneralFunctions.SetEmotion("Determined")
			UI:WaitShowDialogue("Allez " .. hero:GetDisplayName() .. " ![pause=0]Nous avons des choses plus importantes à faire que de traîner dans le stockage !")
			GeneralFunctions.SetEmotion("Normal")
			UI:WaitShowDialogue("Nous devons nous rendre à " .. zone:GetColoredName() .. " pour trouver " .. CharacterEssentials.GetCharacterName("Numel") .. "![pause=0]C'est parti !")
		end
	elseif ground == 'ledian_dojo' then
		if not SV.Chapter2.FinishedFirstDay then
			GeneralFunctions.SetEmotion("Inspired")
			UI:WaitShowDialogue("Ce dojo est génial ![pause=0]Je suis content qu'il y ait un endroit comme celui-ci pour nous entraîner !")
			UI:WaitShowDialogue("J'ai encore un peu d'énergie si tu veux t'entraîner encore,[pause=10]" .. hero:GetDisplayName() .. " !")
			UI:WaitShowDialogue("Nous devons faire tout notre entraînement possible si nous voulons devenir de grands aventuriers !")
		else
			local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("illuminant_riverbed")
			UI:WaitShowDialogue("Ce serait peut-être une bonne idée de s'échauffer avec un peu d'entraînement ici avant de nous diriger vers " .. zone:GetColoredName() .. ".")
			UI:WaitShowDialogue("Mais nous ne voulons pas prendre trop de temps.[pause=0]" .. CharacterEssentials.GetCharacterName("Numel") .. " a besoin de nous !")
		end
	elseif ground == 'metano_fire_home' then
		if not SV.Chapter2.FinishedFirstDay then
			UI:WaitShowDialogue("Cette maison appartient à la famille qui se disputait dehors.")
			GeneralFunctions.SetEmotion("Worried")
			UI:WaitShowDialogue("J'espère qu'ils pourront bientôt se réconcilier...")
		else
			GeneralFunctions.SetEmotion("Determined")
			UI:WaitShowDialogue("Allez " .. hero:GetDisplayName() .. ".[pause=0]Allons ramener le petit garçon de " .. CharacterEssentials.GetCharacterName("Camerupt") .. " à la maison.")
		end
	elseif ground == 'metano_electric_home' then
		if not SV.Chapter2.FinishedFirstDay then
			UI:WaitShowDialogue("Cette maison appartient à une famille de types électriques.")
			GeneralFunctions.SetEmotion("Worried")
			UI:WaitShowDialogue("Ils sont assez gentils,[pause=10]mais le père est plutôt distant.")
		else
			local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("illuminant_riverbed")
			UI:WaitShowDialogue(hero:GetDisplayName() .. "![pause=0]Nous devons sauver " .. CharacterEssentials.GetCharacterName("Numel") .. " !")
			UI:WaitShowDialogue("Nous devrions nous préparer en ville,[pause=10] puis nous diriger vers le nord hors de la ville jusqu'à " .. zone:GetColoredName() .. " pour le trouver !")
		end
	elseif ground == 'metano_water_home' then
		if not SV.Chapter2.FinishedFirstDay then
			UI:WaitShowDialogue("Une famille de types Eau vit ici.")
			GeneralFunctions.SetEmotion("Happy")
			UI:WaitShowDialogue("Ça doit être agréable d'avoir sa maison juste à côté d'une rivière si vous êtes du type Eau !")
		else
			GeneralFunctions.SetEmotion("Happy")
			UI:WaitShowDialogue("Hé,[pause=10]on dirait que quelqu'un fait des rêves agréables.")
		end
	elseif ground == 'metano_normal_home' then
		if not SV.Chapter2.FinishedFirstDay then
			UI:WaitShowDialogue("Une famille de type Normal est propriétaire de cette maison.")
			UI:WaitShowDialogue("On retrouve généralement le papa en train de faire une sieste au soleil en ville et le nez de la maman dans un livre.")
		else
			local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("illuminant_riverbed")
			UI:WaitShowDialogue(hero:GetDisplayName() .. "![pause=0]Nous devons sauver " .. CharacterEssentials.GetCharacterName("Numel") .. " !")
			UI:WaitShowDialogue("Nous devrions nous préparer en ville,[pause=10] puis nous diriger vers le nord hors de la ville jusqu'à " .. zone:GetColoredName() .. " pour le trouver !")
		end
	elseif ground == 'metano_rock_home' then
		if not SV.Chapter2.FinishedFirstDay then
			UI:WaitShowDialogue("Une famille de type Combattant possède cette maison.")
			UI:WaitShowDialogue("Vous pouvez généralement les voir méditer ou s’entraîner quelque part en ville.")
		else
			local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("illuminant_riverbed")
			UI:WaitShowDialogue(hero:GetDisplayName() .. "![pause=0]Nous devons sauver " .. CharacterEssentials.GetCharacterName("Numel") .. " !")
			UI:WaitShowDialogue("Nous devrions nous préparer en ville,[pause=10] puis nous diriger vers le nord hors de la ville jusqu'à " .. zone:GetColoredName() .. " pour le trouver !")
		end
	elseif ground == 'metano_grass_home' then
		if not SV.Chapter2.FinishedFirstDay then
			UI:WaitShowDialogue("Cette maison appartient à une famille de types Herbe.")
			GeneralFunctions.SetEmotion("Happy")
			UI:WaitShowDialogue("Ils ont un beau jardin devant leur maison,[pause=10] vous ne trouvez pas ?")
		else
			local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("illuminant_riverbed")
			UI:WaitShowDialogue(hero:GetDisplayName() .. "![pause=0]Nous devons sauver " .. CharacterEssentials.GetCharacterName("Numel") .. " !")
			UI:WaitShowDialogue("Nous devrions nous préparer en ville,[pause=10] puis nous diriger vers le nord hors de la ville jusqu'à " .. zone:GetColoredName() .. " pour le trouver !")
		end
	elseif ground == 'metano_inn' then
		if not SV.Chapter2.FinishedFirstDay then
			UI:WaitShowDialogue("C'est une auberge tenue par un couple adorable.[pause=0]Ils sont tous les deux vraiment gentils !")
			UI:WaitShowDialogue("Toutes sortes de Pokémon de passage en ville séjournent ici.[pause=0]C'est un bon endroit pour rencontrer de nouveaux Pokémon !")
		else
			local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("illuminant_riverbed")
			UI:WaitShowDialogue(hero:GetDisplayName() .. "![pause=0]Nous devons sauver " .. CharacterEssentials.GetCharacterName("Numel") .. " !")
			UI:WaitShowDialogue("Nous devrions nous préparer en ville,[pause=10] puis nous diriger vers le nord hors de la ville jusqu'à " .. zone:GetColoredName() .. " pour le trouver !")
		end
	elseif ground == 'metano_cave' then
		if not SV.Chapter2.FinishedFirstDay then
			UI:WaitShowDialogue("Cet ermite vit dans cette grotte depuis longtemps.[pause=0]Je ne sais pas grand-chose d'autre à son sujet.")
			GeneralFunctions.SetEmotion("Worried")
			UI:WaitShowDialogue("Je ne crois pas l'avoir déjà vue dehors...[pause=0]C'est étrange puisque[color=#00FF00]Sunflora[color]profite généralement du soleil.")
		else
			GeneralFunctions.SetEmotion("Worried")
			UI:WaitShowDialogue("Je m'inquiète parfois pour l'ermite ici...[pause=0]Elle est toujours ici après tout.")
			UI:WaitShowDialogue("Pensez-vous qu'elle sait seulement qu'un des enfants de la ville a disparu ?")
		end
	elseif ground == 'metano_altere_transition' then
		if not SV.Chapter2.FinishedFirstDay then
			UI:WaitShowDialogue("C'est la périphérie de la ville.[pause=0]Altere Pond se trouve juste au sud d'ici.")
			UI:WaitShowDialogue("C'est un endroit agréable pour se détendre,[pause=10]loin de l'agitation de la ville.")
		else
			local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("illuminant_riverbed")
			GeneralFunctions.SetEmotion("Worried")
			UI:WaitShowDialogue("Que faisons-nous ici,[pause=10]" .. hero:GetDisplayName() .. " ?")
			GeneralFunctions.SetEmotion("Normal")
			UI:WaitShowDialogue("Nous devons nous rendre à " .. zone:GetColoredName() .. " et trouver " .. CharacterEssentials.GetCharacterName("Numel") .. ".[pause=0]. Nous devons nous diriger vers le nord,[pause=10]et non vers le sud !")
		end
	elseif ground == 'altere_pond' then
		if not SV.Chapter2.FinishedFirstDay then
			local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("relic_forest")
			GeneralFunctions.SetEmotion("Worried")
			UI:WaitShowDialogue("Quoi que vous fassiez...[pause=0]Ne dites pas à " .. CharacterEssentials.GetCharacterName("Relicanth") .. " que nous étions dans " .. zone:GetColoredName() .. ".")
			GeneralFunctions.SetEmotion("Pain")
			UI:WaitShowDialogue("Il va nous harceler pendant des heures s'il le découvre.[pause=0]Croyez-moi,[pause=10] je le sais par expérience.")
		else
			local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("illuminant_riverbed")
			GeneralFunctions.SetEmotion("Worried")
			UI:WaitShowDialogue("Que faisons-nous ici,[pause=10]" .. hero:GetDisplayName() .. " ?")
			GeneralFunctions.SetEmotion("Normal")
			UI:WaitShowDialogue("Nous devons nous rendre à " .. zone:GetColoredName() .. " et trouver " .. CharacterEssentials.GetCharacterName("Numel") .. ".[pause=0]. Nous devons nous diriger vers le nord,[pause=10]et non vers le sud !")
		end
	elseif ground == 'post_office' then
		GeneralFunctions.SetEmotion("Worried")
		UI:WaitShowDialogue("On dirait que notre rang n'est pas encore assez élevé pour utiliser la poste...")
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue("Je suppose que nous devrons revenir lorsque notre rang sera plus élevé.")
	elseif ground == 'metano_town' then
		--metano town uses a series of touch objects to mark where the player/partner is on the map so the partner can comment on specific surroundings.
		local location = SV.metano_town.Locale
		if not SV.Chapter2.FinishedTraining then
			UI:WaitShowDialogue("Rendons-nous au Ledian Dojo pour notre formation,[pause=10]" .. hero:GetDisplayName() .. " !")
			UI:WaitShowDialogue(CharacterEssentials.GetCharacterName("Noctowl") .. " a indiqué qu'il traversait le pont menant à la guilde,[pause=10]puis descendait une échelle à l'est.")
		elseif not SV.Chapter2.FinishedFirstDay then  --day 1
			if location == 'North Houses' or location == 'South Houses' then
				UI:WaitShowDialogue("C'est ici que vivent la plupart des habitants de la ville.")
				if SV.Chapter2.FinishedNumelTantrum then
					GeneralFunctions.SetEmotion("Worried")
					UI:WaitShowDialogue("Cette scène précédente était un peu alarmante...[pause=0]Ce genre de choses arrive rarement dans la ville de Metano.")
					GeneralFunctions.SetEmotion("Normal")
					UI:WaitShowDialogue("Quoi qu'il en soit, les Pokémon[pause=10]ici sont très accueillants,[pause=10]alors n'hésitez pas à entrer chez eux.")
				else
					UI:WaitShowDialogue("Les Pokémon ici sont très accueillants,[pause=10]alors n'hésitez pas à entrer chez eux.")
				end
			elseif location == 'Guild' then
				if not SV.Chapter2.FinishedNumelTantrum then
					UI:WaitShowDialogue("Il nous reste encore du temps avant de devoir retourner à l'intérieur de la guilde.")
					UI:WaitShowDialogue("Allons explorer encore la ville !")
				else
					UI:WaitShowDialogue("Il commence à se faire tard.[pause=0]Retournons à l'intérieur de la guilde pour dîner dès que vous êtes prêt,[pause=10]" .. hero:GetDisplayName() .. ".")
				end
			elseif location == 'Cafe' then
				GeneralFunctions.SetEmotion("Surprised")
				UI:WaitShowDialogue("Oh![pause=0]J'avais presque oublié le café !")
				GeneralFunctions.SetEmotion("Happy")
				UI:WaitShowDialogue("Le café est l'endroit le plus populaire de la ville !")
				UI:WaitShowDialogue("Le propriétaire " .. CharacterEssentials.GetCharacterName("Shuckle") .. " prépare toutes sortes de délicieuses boissons et collations ![pause=0]Ils sont vraiment bons !")
				GeneralFunctions.SetEmotion("Worried")
				UI:WaitShowDialogue("Il semblerait qu'il ne soit pas ouvert pour le moment...[pause=0]C'est dommage...")
				GeneralFunctions.SetEmotion("Inspired")
				UI:WaitShowDialogue("Mais il faudra revenir une fois ouvert ![pause=0]Je vous le dis,[pause=10]c'est délicieux !")
			elseif location == 'Cave' then
				UI:WaitShowDialogue("Un ermite vit dans cette grotte moisie à flanc de falaise.[pause=0]Mais elle n'aime pas beaucoup les visiteurs.")
			elseif location == 'Exploration' then
				UI:WaitShowDialogue("C'est la sortie principale hors de la ville.[pause=0]Pour la plupart de nos futures aventures,[pause=10] nous quitterions la ville par cette voie.")
			elseif location == 'Post' then
				UI:WaitShowDialogue("Ce bâtiment aux formes étranges là-bas est le bureau de poste de Pelipper.[pause=0]Nous pouvons y aller sauver des amis !")
			elseif location == 'Well' then
				UI:WaitShowDialogue("La falaise est un lieu de rencontre commun.[pause=0]Vous pouvez voir toute la ville de Metano d'ici !")
				UI:WaitShowDialogue("Mais les parents n'aiment pas que leurs enfants jouent ici.")
				UI:WaitShowDialogue("Après tout, ils ne veulent pas qu’ils tombent à flanc de falaise !")
			elseif location == 'Merchants' then
				GeneralFunctions.SetEmotion("Worried")
				UI:WaitShowDialogue("Habituellement, il y a deux marchands rivaux ici,[pause=10] qui vendent des articles tout en se chamaillant.")
				UI:WaitShowDialogue("Mais je ne les ai pas vus là-bas depuis quelques jours.[pause=0]Je me demande où ils pourraient être ?")
			elseif location == 'Dojo' then
				if not SV.Chapter2.FinishedTraining then
					UI:WaitShowDialogue("Hé,[pause=10] il y a une échelle là-bas,[pause=10]" .. hero:GetDisplayName() "!")
					UI:WaitShowDialogue("Ce doit être l'entrée du dojo.[pause=0]Allons-y !")
				else
					GeneralFunctions.SetEmotion("Worried")
					UI:WaitShowDialogue("Je n'arrive toujours pas à croire qu'il y ait une caverne entière et un dojo en bas de cette échelle...")
					GeneralFunctions.SetEmotion("Joyous")
					GROUND:CharSetEmote(partner, "glowing", 0)
					UI:WaitShowDialogue("Je suis passé devant lui tellement de fois,[pause=10]mais je n'y suis jamais allé avant aujourd'hui ![pause=0]Haha !")
					GROUND:CharSetEmote(partner, "", 0)
				end
			elseif location == 'Market' then
				UI:WaitShowDialogue("Le marché regorge de toutes sortes de boutiques et de vendeurs sympas !")
				UI:WaitShowDialogue("C'est la partie la plus excitante de la ville ![pause=0]Outre la guilde,[pause=10]bien sûr.")
				UI:WaitShowDialogue("Si nous gagnons de l'argent grâce à l'aventure,[pause=10] c'est probablement là que nous allons le dépenser.")
			else
				UI:WaitShowDialogue("Aucun dialogue assigné pour cette partie de la ville. Faites savoir à Palika où vous avez reçu ce message.")
			end

		else--day 2
			if in_array(location, {'Guild', 'North Houses', 'South Houses', 'Post', 'Merchants', 'Well', 'Exploration', 'Cave'}) then
				local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("illuminant_riverbed")
				UI:WaitShowDialogue(hero:GetDisplayName() .. "![pause=0]Nous devons sauver " .. CharacterEssentials.GetCharacterName("Numel") .. " !")
				UI:WaitShowDialogue("Nous devrions nous préparer en ville,[pause=10] puis nous diriger vers le nord hors de la ville jusqu'à " .. zone:GetColoredName() .. " pour le trouver !")
			elseif location == 'Cafe' then
				GeneralFunctions.SetEmotion("Worried")
				UI:WaitShowDialogue("Le café est toujours fermé,[pause=10] hein ?")
				GeneralFunctions.SetEmotion("Normal")
				UI:WaitShowDialogue("J'espère qu'il sera bientôt de nouveau ouvert.[pause=0]J'ai vraiment envie que vous essayiez certaines de leurs friandises !")
			elseif location == 'Dojo' then
				local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("illuminant_riverbed")
				UI:WaitShowDialogue("Peut-être devrions-nous nous rendre au dojo pour un échauffement avant de nous diriger vers " .. zone:GetColoredName() .. " ?")
			elseif location == 'Market' then
				local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("illuminant_riverbed")
				UI:WaitShowDialogue("Le marché est probablement le meilleur endroit pour faire nos préparatifs.")
				UI:WaitShowDialogue("Quand nous aurons fini ici,[pause=10] dirigeons-nous vers " .. zone:GetColoredName() .. " ![pause=0]" .. CharacterEssentials.GetCharacterName("Numel") .. " a besoin de nous !")
			else
				UI:WaitShowDialogue("Aucun dialogue assigné pour cette partie de la ville. Faites savoir à Palika où vous avez reçu ce message.")
			end
		end


	else
		UI:WaitShowDialogue("Dialogue du chapitre 2 introuvable pour ce terrain/scénario. Veuillez en informer Palika.")
	end

	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	partner.IsInteracting = false
end






function PartnerEssentials.Chapter_3_Dialogue(partner)
	local ground = GAME:GetCurrentGround().AssetName--get ground's internal name
	UI:SetSpeaker(partner)
	local hero = CH('PLAYER')
	partner.IsInteracting = true
	GROUND:CharSetAnim(partner, 'None', true)
	GROUND:CharSetAnim(hero, 'None', true)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	GeneralFunctions.SetEmotion('Normal')

	--yes i know this is yandere dev shit i dont know how better to structure this. a lua table doesn't really make sense here without having to do a bunch of extra bullshit that i feel makes it less categorized/ordered.
	--can redo this with a better approach if a good one can be figured out.
	if ground == 'guild_heros_room' then
		if SV.TemporaryFlags.JustWokeUp then
			GeneralFunctions.SetEmotion("Happy")
			UI:WaitShowDialogue("Bonjour,[pause=10]" .. hero:GetDisplayName() .. " !")

		elseif not SV.Chapter3.EncounteredBoss then
			local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("crooked_cavern")
			UI:WaitShowDialogue("Allez,[pause=10]" .. hero:GetDisplayName() .. " ![pause=0]Nous avons une mission à accomplir !")
			UI:WaitShowDialogue("Nous devons aller à " .. zone:GetColoredName() .. " et capturer ce hors-la-loi " .. CharacterEssentials.GetCharacterName("Sandile") .. " !")
			UI:WaitShowDialogue("Nous devrions aller en ville pour nous préparer, puis nous pourrons partir vers l'est lorsque nous serons prêts.[pause=0]C'est parti !")
		elseif not SV.Chapter3.DefeatedBoss then
			GeneralFunctions.SetEmotion("Determined")
			local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("crooked_cavern")
			UI:WaitShowDialogue("Cette équipe[color=#FFA5FF]Style[color]...[pause=0]Pour qui se prennent-ils ?")
			UI:WaitShowDialogue("Nous devons retourner à " .. zone:GetColoredName() .. " pour vaincre l'équipe[color=#FFA5FF]Style[color]et aider " .. CharacterEssentials.GetCharacterName("Sandile") .. "![pause=0]Allez !")
		else
			UI:WaitShowDialogue("Aujourd'hui,[pause=10]" .. CharacterEssentials.GetCharacterName("Noctowl") .. " souhaite que nous effectuions des travaux affichés sur le Job Bulletin Board et le Outlaw Notice Board.")
			GeneralFunctions.SetEmotion("Sad")
			UI:WaitShowDialogue("Je me sens toujours déprimé à cause de toute cette épreuve avec " .. CharacterEssentials.GetCharacterName("Sandile") .. "...")
			GeneralFunctions.SetEmotion("Normal")
			UI:WaitShowDialogue("Espérons que ce genre de situation ne se reproduira plus avec d'autres emplois que nous accepterons.")
			UI:WaitShowDialogue("Alors continuons notre bon travail,[pause=10]" .. hero:GetDisplayName() .. " !")
		end
	elseif in_array(ground, {'guild_bedroom_hallway',
						     'guild_storage_room',
							 'guild_bottom_left_bedroom',
							 'guild_top_left_bedroom',
							 'guild_top_right_bedroom',
							 'guild_third_floor_lobby',
							 'guild_first_floor',
							 'guild_dining_room',
							 'guild_storage_hallway'}) then
		if not SV.Chapter3.EncounteredBoss then
			local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("crooked_cavern")
			UI:WaitShowDialogue("Allez,[pause=10]" .. hero:GetDisplayName() .. " ![pause=0]Nous avons une mission à accomplir !")
			UI:WaitShowDialogue("Nous devons aller à " .. zone:GetColoredName() .. " et capturer ce hors-la-loi " .. CharacterEssentials.GetCharacterName("Sandile") .. " !")
			UI:WaitShowDialogue("Nous devrions aller en ville pour nous préparer, puis nous pourrons partir vers l'est lorsque nous serons prêts.[pause=0]C'est parti !")
		elseif not SV.Chapter3.DefeatedBoss then
			GeneralFunctions.SetEmotion("Determined")
			local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("crooked_cavern")
			UI:WaitShowDialogue("Cette équipe[color=#FFA5FF]Style[color]...[pause=0]Pour qui se prennent-ils ?")
			UI:WaitShowDialogue("Nous devons retourner à " .. zone:GetColoredName() .. " pour vaincre l'équipe[color=#FFA5FF]Style[color]et aider " .. CharacterEssentials.GetCharacterName("Sandile") .. "![pause=0]Allez !")
		else
			if ground == 'guild_third_floor_lobby' then--special dialogue on the third floor post boss. Changes depending on whether or not you had talked to girafarig/breloom at the cafe preboss
				UI:WaitShowDialogue("Je n'ai pas vu " .. CharacterEssentials.GetCharacterName("Girafarig") .. " ou " .. CharacterEssentials.GetCharacterName("Breloom") .. " à l'adresse ce matin.")
				if SV.Chapter3.BreloomGirafarigConvo then
					UI:WaitShowDialogue("Ils doivent faire partie de cette expédition dont ils parlaient au café l'autre jour.")
				else
					GeneralFunctions.SetEmotion("Worried")
					UI:WaitShowDialogue("Je me demande où ils sont partis ?")
					GeneralFunctions.SetEmotion("Normal")
				end
				UI:WaitShowDialogue("Quoi qu'il en soit,[pause=10]" .. CharacterEssentials.GetCharacterName("Noctowl") .. " veut que nous effectuions les travaux affichés sur le Job Bulletin Board et le Outlaw Notice Board.")
				UI:WaitShowDialogue("Continuons à faire du bon travail comme toujours,[pause=10]" .. hero:GetDisplayName() .. " !")
			else
				UI:WaitShowDialogue("Aujourd'hui,[pause=10]" .. CharacterEssentials.GetCharacterName("Noctowl") .. " souhaite que nous effectuions des travaux affichés sur le Job Bulletin Board et le Outlaw Notice Board.")
				GeneralFunctions.SetEmotion("Sad")
				UI:WaitShowDialogue("Je me sens toujours déprimé à cause de toute cette épreuve avec " .. CharacterEssentials.GetCharacterName("Sandile") .. "...")
				GeneralFunctions.SetEmotion("Normal")
				UI:WaitShowDialogue("Espérons que ce genre de situation ne se reproduira plus avec d'autres emplois que nous accepterons.")
				UI:WaitShowDialogue("Alors continuons notre bon travail,[pause=10]" .. hero:GetDisplayName() .. " !")
			end
		end

	elseif ground == 'guild_bottom_right_bedroom' then
		if not SV.Chapter3.EncounteredBoss then
			UI:WaitShowDialogue("Peut-être que " .. CharacterEssentials.GetCharacterName("Zigzagoon") .. " a des informations sur les hors-la-loi dans l'un de ses almanachs !")
			UI:WaitShowDialogue("Jetons un coup d'oeil ![pause=0]Tout ce que nous pouvons apprendre sur la façon de traiter avec les hors-la-loi pourrait nous aider dans notre mission !")
		elseif not SV.Chapter3.DefeatedBoss then
			GeneralFunctions.SetEmotion("Worried")
			UI:WaitShowDialogue("Pensez-vous qu'il y ait des informations sur l'équipe[color=#FFA5FF]Style[color]dans l'un de ces almanachs ?")
		else
			UI:WaitShowDialogue("Aujourd'hui,[pause=10]" .. CharacterEssentials.GetCharacterName("Noctowl") .. " souhaite que nous effectuions des travaux affichés sur le Job Bulletin Board et le Outlaw Notice Board.")
			GeneralFunctions.SetEmotion("Sad")
			UI:WaitShowDialogue("Je me sens toujours déprimé à cause de toute cette épreuve avec " .. CharacterEssentials.GetCharacterName("Sandile") .. "...")
			GeneralFunctions.SetEmotion("Normal")
			UI:WaitShowDialogue("Espérons que ce genre de situation ne se reproduira plus avec d'autres emplois que nous accepterons.")
			UI:WaitShowDialogue("Alors continuons notre bon travail,[pause=10]" .. hero:GetDisplayName() .. " !")
		end
	elseif ground == 'guild_second_floor' then
		if not SV.Chapter3.EncounteredBoss then
			local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("crooked_cavern")
			UI:WaitShowDialogue("Eh bien,[pause=10] nous avons notre mission du jour.[pause=0]Nous devons nous rendre à " .. zone:GetColoredName() .. " et attraper le hors-la-loi " .. CharacterEssentials.GetCharacterName("Sandile") .. ".")
			GeneralFunctions.SetEmotion("Worried")
			UI:WaitShowDialogue("Je pense que " .. CharacterEssentials.GetCharacterName("Cranidos") .. " a choisi un travail difficile pour nous faire mal paraître...")
			GeneralFunctions.SetEmotion("Normal")
			UI:WaitShowDialogue("Nous devrions faire de notre mieux et lui prouver qu'il a tort ![pause=0]Je sais que nous pouvons le faire,[pause=10]" .. hero:GetDisplayName() .. " !")
			UI:WaitShowDialogue("Si nous avons des problèmes,[pause=10] je parie que " .. CharacterEssentials.GetCharacterName("Mareep") .. " peut également nous aider.")
		elseif not SV.Chapter3.DefeatedBoss then
			GeneralFunctions.SetEmotion("Determined")
			local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("crooked_cavern")
			UI:WaitShowDialogue("Team[color=#FFA5FF]Style[color]...[pause=0]Je n'arrive pas à les croire !")
			GeneralFunctions.SetEmotion("Worried")
			UI:WaitShowDialogue("Cependant...[pause=10]Je pense que c'est quelque chose dont nous devrions essayer de prendre soin nous-mêmes.")
			UI:WaitShowDialogue("Nous ne devrions pas en informer " .. CharacterEssentials.GetCharacterName("Mareep") .. " ou " .. CharacterEssentials.GetCharacterName("Cranidos") .. ".")
			UI:WaitShowDialogue("Sinon, l'équipe[pause=10][color=#FFA5FF]Style[color]pourra toujours garder ça au dessus de nous,[pause=10]et je ne veux pas de ça...")
		else
			UI:WaitShowDialogue("Aujourd'hui,[pause=10]" .. CharacterEssentials.GetCharacterName("Noctowl") .. " veut que nous effectuions des travaux affichés sur les forums ici.")
			GeneralFunctions.SetEmotion("Sad")
			UI:WaitShowDialogue("Je me sens toujours déprimé à cause de toute cette épreuve avec " .. CharacterEssentials.GetCharacterName("Sandile") .. "...")
			GeneralFunctions.SetEmotion("Normal")
			UI:WaitShowDialogue("Espérons que ce genre de situation ne se reproduise plus avec les autres emplois que nous acceptons ici.")
			UI:WaitShowDialogue("Alors continuons notre bon travail,[pause=10]" .. hero:GetDisplayName() .. " !")
		end
	elseif ground == 'guild_guildmasters_room' then
		if not SV.Chapter3.DefeatedBoss then
			if SV.Chapter2.TropiusGaveReviver and not SV.Chapter3.TropiusGaveWand then
				UI:WaitShowDialogue("Le maître de guilde a pu nous aider lors de notre dernière mission...[pause=0]Je parie qu'il pourrait nous aider à nouveau !")
			elseif not SV.Chapter3.TropiusGaveWand then
				GeneralFunctions.SetEmotion("Worried")
				UI:WaitShowDialogue("Je me demande si le maître de guilde peut nous aider dans notre mission ?[pause=0]Peut-être qu'il a quelques conseils ou quelque chose du genre.")
			elseif SV.Chapter3.TropiusGaveWand and not SV.Chapter3.EncounteredBoss then
				local itemname = RogueEssence.Dungeon.InvItem("wand_totter"):GetDisplayName()
				--take off the (0) from the string, then add on the color tag we remove by doing this
				itemname = string.sub(itemname, 1, -12) .. '[color]'
				GeneralFunctions.SetEmotion("Happy")
				UI:WaitShowDialogue("Ces " .. itemname .. " que le Maître de Guilde nous a donnés devraient être très utiles pour notre mission !")
				UI:WaitShowDialogue("Nous pouvons les utiliser pour confondre " .. CharacterEssentials.GetCharacterName("Sandile") .. ", ce qui devrait faciliter sa défaite !")
			else
				GeneralFunctions.SetEmotion("Worried")
				UI:WaitShowDialogue("Euh,[pause=10]" .. hero:GetDisplayName() .. ",[pause=10]Je préfère ne pas parler de l'équipe[color=#FFA5FF]Style[color]au maître de guilde...")
				UI:WaitShowDialogue("Je pense que c'est quelque chose dont nous devrions prendre soin nous-mêmes.")
				UI:WaitShowDialogue("Sinon, l'équipe[pause=10][color=#FFA5FF]Style[color]pourra toujours garder ça au dessus de nous,[pause=10]et je ne veux pas de ça...")
			end
		else
			GeneralFunctions.SetEmotion("Worried")
			UI:WaitShowDialogue("Pensez-vous que le maître de guilde a eu affaire à des équipes comme l'équipe[color=#FFA5FF]Style[color]lorsqu'il était un aventurier actif ?")
			UI:WaitShowDialogue("Je me demande ce qu'il faisait chaque fois qu'il rencontrait des équipes comme celle-là...")
		end
	elseif ground == 'ledian_dojo' then
		if not SV.Chapter3.EncounteredBoss then
			local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("crooked_cavern")
			UI:WaitShowDialogue("Nous devrions nous échauffer dans le dojo avant d'aller au " .. zone:GetColoredName() .. ".")
			UI:WaitShowDialogue("Nous voudrons être prêts au combat puisque nous poursuivons un hors-la-loi.")
		elseif not SV.Chapter3.DefeatedBoss then
			UI:WaitShowDialogue("Peut-être devrions-nous nous entraîner un peu ici avant de combattre à nouveau l'équipe[color=#FFA5FF]Style[color].")
			UI:WaitShowDialogue("Je ne veux pas perdre la prochaine fois que nous les affronterons !")
		else
			UI:WaitShowDialogue("Aujourd'hui,[pause=10]" .. CharacterEssentials.GetCharacterName("Noctowl") .. " souhaite que nous effectuions des travaux affichés sur le Job Bulletin Board et le Outlaw Notice Board.")
			GeneralFunctions.SetEmotion("Sad")
			UI:WaitShowDialogue("Je me sens toujours déprimé à cause de toute cette épreuve avec " .. CharacterEssentials.GetCharacterName("Sandile") .. "...")
			GeneralFunctions.SetEmotion("Normal")
			UI:WaitShowDialogue("Espérons que ce genre de situation ne se reproduira plus avec d'autres emplois que nous accepterons.")
			UI:WaitShowDialogue("Alors continuons notre bon travail,[pause=10]" .. hero:GetDisplayName() .. " !")
		end
	elseif in_array(ground, {'metano_electric_home',
							 'metano_normal_home',
							 'metano_water_home',
							 'metano_grass_home',
							 'metano_inn',
							 'metano_rock_home',
							 'metano_cave',
							 'metano_altere_transition'
								}) then
	    if not SV.Chapter3.EncounteredBoss then
				local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("crooked_cavern")
				UI:WaitShowDialogue("Allez,[pause=10]" .. hero:GetDisplayName() .. " ![pause=0]Nous avons une mission à accomplir !")
				UI:WaitShowDialogue("Nous devons aller à " .. zone:GetColoredName() .. " et capturer ce hors-la-loi " .. CharacterEssentials.GetCharacterName("Sandile") .. " !")
				UI:WaitShowDialogue("Nous devrions nous préparer ici en ville, puis partir vers l'est lorsque nous serons prêts.[pause=0]C'est parti !")
		elseif not SV.Chapter3.DefeatedBoss then
			GeneralFunctions.SetEmotion("Determined")
			local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("crooked_cavern")
			UI:WaitShowDialogue("Je n'arrive toujours pas à croire que l'équipe[color=#FFA5FF]Style[color]![pause=0]pense qu'ils iraient aussi loin qu'ils l'ont fait...")
			UI:WaitShowDialogue("Préparons-nous ici en ville,[pause=10]puis retournons à " .. zone:GetColoredName() .. " pour sauver " .. CharacterEssentials.GetCharacterName("Sandile") .. " de l'équipe[color=#FFA5FF]Style[color]!")
		else
			UI:WaitShowDialogue("Aujourd'hui,[pause=10]" .. CharacterEssentials.GetCharacterName("Noctowl") .. " souhaite que nous effectuions des travaux affichés sur le Job Bulletin Board et le Outlaw Notice Board.")
			GeneralFunctions.SetEmotion("Sad")
			UI:WaitShowDialogue("Je me sens toujours déprimé à cause de toute cette épreuve avec " .. CharacterEssentials.GetCharacterName("Sandile") .. "...")
			GeneralFunctions.SetEmotion("Normal")
			UI:WaitShowDialogue("Espérons que ce genre de situation ne se reproduira plus avec d'autres emplois que nous accepterons.")
			UI:WaitShowDialogue("Alors continuons notre bon travail,[pause=10]" .. hero:GetDisplayName() .. " !")
		end
	elseif ground == 'metano_fire_home' then
		if not SV.Chapter3.DefeatedBoss then
			GeneralFunctions.SetEmotion("Happy")
			UI:WaitShowDialogue("Je suis tellement heureuse que nous ayons pu sauver " .. CharacterEssentials.GetCharacterName("Numel") .. ".[pause=0]. Sa mère était tellement soulagée de le retrouver sain et sauf !")
			GeneralFunctions.SetEmotion("Worried")
			UI:WaitShowDialogue("Bien que le problème avec Luminous Spring me laisse toujours perplexe...")
		else
			UI:WaitShowDialogue("Aujourd'hui,[pause=10]" .. CharacterEssentials.GetCharacterName("Noctowl") .. " souhaite que nous effectuions des travaux affichés sur le Job Bulletin Board et le Outlaw Notice Board.")
			GeneralFunctions.SetEmotion("Sad")
			UI:WaitShowDialogue("Je me sens toujours déprimé à cause de toute cette épreuve avec " .. CharacterEssentials.GetCharacterName("Sandile") .. "...")
			GeneralFunctions.SetEmotion("Normal")
			UI:WaitShowDialogue("Espérons que ce genre de situation ne se reproduira plus avec d'autres emplois que nous accepterons.")
			UI:WaitShowDialogue("Alors continuons notre bon travail,[pause=10]" .. hero:GetDisplayName() .. " !")
		end
	elseif ground == 'altere_pond' then
		if not SV.Chapter3.DefeatedBoss then
			local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("relic_forest")
			UI:WaitShowDialogue(CharacterEssentials.GetCharacterName("Relicanth") .. ",[pause=10]étant aussi vieux que lui,[pause=10]connaît beaucoup d'histoires et de mythes du monde.")
			UI:WaitShowDialogue("Il m'en raconte parfois une, s'il ne m'a pas surprise à me faufiler dans " .. zone:GetColoredName() .. " ces derniers temps.")
			GeneralFunctions.SetEmotion("Inspired")
			UI:WaitShowDialogue("J'adore entendre parler de toutes les différentes légendes qu'il connaît ![pause=0]Elles sont tellement fascinantes !")
			UI:WaitShowDialogue("Il faudra venir voir s'il nous racontera une histoire à tous les deux quand nous ne serons pas occupés !")
			if SV.Chapter3.EncounteredBoss then
				GeneralFunctions.SetEmotion("Sad")
				UI:WaitShowDialogue("...Une histoire m'aidera aussi à me remonter le moral.[pause=0]Nos problèmes avec l'équipe[color=#FFA5FF]Style[color]m'ont bouleversé,[pause=10]à vrai dire...")
			end
		else
			GeneralFunctions.SetEmotion("Inspired")
			UI:WaitShowDialogue("Je veux entendre " .. CharacterEssentials.GetCharacterName("Relicanth") .. " raconter à nouveau la légende des Anima Cores très bientôt !")
			UI:WaitShowDialogue("Il le raconte bien mieux que moi !")
			UI:WaitShowDialogue("Je suis sûr qu'il pourrait même nous en dire plus sur la légende que moi l'autre soir !")

		end
	elseif ground == 'post_office' then
		GeneralFunctions.SetEmotion("Worried")
		UI:WaitShowDialogue("On dirait que notre rang n'est pas encore assez élevé pour utiliser la poste...")
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue("Je suppose que nous devrons revenir lorsque notre rang sera plus élevé.")
	elseif ground == 'metano_cafe' then
		if not SV.Chapter3.EncounteredBoss then
			GeneralFunctions.SetEmotion("Inspired")
			UI:WaitShowDialogue("Que devrions-nous obtenir ?[pause=0]Il y a tellement d'options !")
			UI:WaitShowDialogue("Les boissons peuvent prendre un certain temps à préparer,[pause=10] mais elles valent la peine d'attendre !")
			UI:WaitShowDialogue("Le plat du jour de " .. CharacterEssentials.GetCharacterName("Shuckle") .. " pourrait également valoir la peine d'être acheté ![pause=0]Nous devons voir ce qu'il a !")
		elseif not SV.Chapter3.DefeatedBoss then
			local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("crooked_cavern")
			GeneralFunctions.SetEmotion("Worried")
			UI:WaitShowDialogue("Même si j'aimerais bien prendre un verre en ce moment, autant[pause=10], nous avons quelque chose de plus important à faire !")
			GeneralFunctions.SetEmotion("Normal")
			UI:WaitShowDialogue("Nous devons retourner à " .. zone:GetColoredName() .. " dès que possible pour battre l'équipe[color=#FFA5FF]Style[color]et aider " .. CharacterEssentials.GetCharacterName("Sandile") .. " !")
		else
			UI:WaitShowDialogue("Aujourd'hui,[pause=10]" .. CharacterEssentials.GetCharacterName("Noctowl") .. " souhaite que nous effectuions des travaux affichés sur le Job Bulletin Board et le Outlaw Notice Board.")
			GeneralFunctions.SetEmotion("Sad")
			UI:WaitShowDialogue("Je me sens toujours déprimé à cause de toute cette épreuve avec " .. CharacterEssentials.GetCharacterName("Sandile") .. "...")
			GeneralFunctions.SetEmotion("Normal")
			UI:WaitShowDialogue("Espérons que ce genre de situation ne se reproduira plus avec d'autres emplois que nous accepterons.")
			UI:WaitShowDialogue("Alors continuons notre bon travail,[pause=10]" .. hero:GetDisplayName() .. " !")
		end
	elseif ground == 'metano_town' then
		--metano town uses a series of touch objects to mark where the player/partner is on the map so the partner can comment on specific surroundings.
		local location = SV.metano_town.Locale
		--North Houses
		--South Houses
		--Guild
		--Cafe
		--Well
		--Post
		--Cave
		--Market
		--Dojo
		--Exploration
		--Merchants

		if not SV.Chapter3.EncounteredBoss then
			if location == 'North Houses' or location == 'South Houses' then
				UI:WaitShowDialogue("On dirait que la plupart des habitants sont soulagés maintenant que " .. CharacterEssentials.GetCharacterName("Numel") .. " est de retour chez lui sain et sauf.")
				GeneralFunctions.SetEmotion("Happy")
				UI:WaitShowDialogue("C'est tellement génial que nous ayons pu le sauver !")
				UI:WaitShowDialogue("Après tout, aider les autres était l’une des raisons pour lesquelles je voulais devenir aventurier !")
			elseif in_array(location, {'Guild', 'Cave', 'Well', 'Post', 'Dojo'}) then
				local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("crooked_cavern")
				UI:WaitShowDialogue("Allez,[pause=10]" .. hero:GetDisplayName() .. " ![pause=0]Nous avons une mission à accomplir !")
				UI:WaitShowDialogue("Nous devons aller à " .. zone:GetColoredName() .. " et capturer ce hors-la-loi " .. CharacterEssentials.GetCharacterName("Sandile") .. " !")
				UI:WaitShowDialogue("Nous devrions nous préparer ici en ville, puis partir vers l'est lorsque nous serons prêts.[pause=0]C'est parti !")
			elseif location == 'Cafe' then
				GeneralFunctions.SetEmotion("Inspired")
				UI:WaitShowDialogue("Nous devrions faire un arrêt à l'intérieur du café avant de partir en mission !")
				UI:WaitShowDialogue("Maintenant qu'il est à nouveau ouvert,[pause=10]nous devrions le visiter et nous faire plaisir avant le travail de la journée !")
			elseif location == 'Exploration' then
				local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("crooked_cavern")
				UI:WaitShowDialogue("Si vous pensez que nous sommes prêts,[pause=10] nous pouvons quitter la ville en direction de " .. zone:GetColoredName() .. " en empruntant ce chemin vers l'est.")
			elseif location == 'Merchants' then
				GeneralFunctions.SetEmotion("Worried")
				UI:WaitShowDialogue("Cette équipe[color=#FFA5FF]Style[color]me laisse toujours confus...")
				UI:WaitShowDialogue("Je me demande ce qui les a poussés à agir ainsi envers nous ?")
			elseif location == 'Market' then
				UI:WaitShowDialogue("Nous devrions faire le plein d'articles qui nous aideront à capturer " .. CharacterEssentials.GetCharacterName("Sandile") .. " ici sur le marché.")
				UI:WaitShowDialogue("Nous pouvons utiliser une partie de notre argent de récompense de " .. CharacterEssentials.GetCharacterName("Camerupt") .. " pour les acheter auprès de " .. CharacterEssentials.GetCharacterName("Kecleon") .. " et " .. CharacterEssentials.GetCharacterName("Kecleon_Purple") .. " !")
			else
				UI:WaitShowDialogue("Aucun dialogue assigné pour cette partie de la ville. Faites savoir à Palika où vous avez reçu ce message.")
			end

		elseif not SV.Chapter3.DefeatedBoss then
			if in_array(location, {'Guild', 'Cave', 'Well', 'Post', 'Dojo', 'North Houses', 'South Houses', 'Exploration', 'Cafe'}) then
				GeneralFunctions.SetEmotion("Determined")
				local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("crooked_cavern")
				UI:WaitShowDialogue("Je n'arrive toujours pas à croire que l'équipe[color=#FFA5FF]Style[color]![pause=0]pense qu'ils iraient aussi loin qu'ils l'ont fait...")
				UI:WaitShowDialogue("Préparons-nous ici en ville,[pause=10]puis retournons à " .. zone:GetColoredName() .. " pour sauver " .. CharacterEssentials.GetCharacterName("Sandile") .. " de l'équipe[color=#FFA5FF]Style[color]!")
			elseif location == 'Merchants' then
				GeneralFunctions.SetEmotion("Determined")
				local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("crooked_cavern")
				UI:WaitShowDialogue("Faire un acte comme celui-là...[pause=0]Nous savons maintenant pourquoi l'équipe[color=#FFA5FF]Style[color]a changé d'avis ici plus tôt !")
				UI:WaitShowDialogue(hero:GetDisplayName() .. "![pause=0]Revenons à " .. zone:GetColoredName() .. " et battons l'équipe[color=#FFA5FF]Style[color]afin que nous puissions aider " .. CharacterEssentials.GetCharacterName("Sandile") .. " !")
			elseif location == 'Market' then
				UI:WaitShowDialogue("Nous devrions acheter des articles sur le marché pour nous aider à faire face à l'équipe[color=#FFA5FF]Style[color].")
				GeneralFunctions.SetEmotion("Worried")
				UI:WaitShowDialogue("Même si je ne sais pas quels éléments pourraient être les meilleurs pour cela...")
			else
				UI:WaitShowDialogue("Aucun dialogue assigné pour cette partie de la ville. Faites savoir à Palika où vous avez reçu ce message.")
			end
		else--Mission days
			if in_array(location, {'Guild', 'Cave', 'Well', 'Post', 'Dojo', 'Exploration', 'Cafe', 'Market'}) then
				if location == 'Market' and SV.Chapter3.PostBossSpokeToCranidos then
					GeneralFunctions.SetEmotion("Worried")
					UI:WaitShowDialogue("Je suppose que nous ne pouvons pas impressionner " .. CharacterEssentials.GetCharacterName("Cranidos") .. ", peu importe ce que nous faisons,[pause=10] hein " .. CH('PLAYER'):GetDisplayName() .. " ?")
					GeneralFunctions.SetEmotion("Normal")
					UI:WaitShowDialogue("Eh bien,[pause=10]ne sert à rien de s'énerver à cause de son attitude.")
					UI:WaitShowDialogue("Nous devrons juste travailler dur pour nous impressionner au lieu de Pokémon comme lui !")
				else
					UI:WaitShowDialogue("Aujourd'hui,[pause=10]" .. CharacterEssentials.GetCharacterName("Noctowl") .. " souhaite que nous effectuions des travaux affichés sur le Job Bulletin Board et le Outlaw Notice Board.")
					GeneralFunctions.SetEmotion("Sad")
					UI:WaitShowDialogue("Je me sens toujours déprimé à cause de toute cette épreuve avec " .. CharacterEssentials.GetCharacterName("Sandile") .. "...")
					GeneralFunctions.SetEmotion("Normal")
					UI:WaitShowDialogue("Espérons que ce genre de situation ne se reproduira plus avec d'autres emplois que nous accepterons.")
					UI:WaitShowDialogue("Alors continuons notre bon travail,[pause=10]" .. hero:GetDisplayName() .. " !")
				end
			elseif in_array(location, {'North Houses', 'South Houses'}) then
				GeneralFunctions.SetEmotion("Worried")
				UI:WaitShowDialogue("On dirait que la plupart des citadins s'inquiètent de tous les hors-la-loi qui circulent ces derniers temps...")
				GeneralFunctions.SetEmotion("Normal")
				UI:WaitShowDialogue("Nous devrons alors faire de notre mieux pour arrêter autant de mauvais hors-la-loi que possible !")
				UI:WaitShowDialogue("Prenons autant de tâches que possible au sein du tableau d'affichage des hors-la-loi pour assurer la sécurité de tous !")
			elseif location == 'Merchants' then
				GeneralFunctions.SetEmotion("Worried")
				UI:WaitShowDialogue("Ces deux-là sont définitivement deux personnages...[pause=0]Je ne les comprends toujours pas vraiment...")
				GeneralFunctions.SetEmotion("Normal")
				UI:WaitShowDialogue("Mais les articles qu'ils vendent pourraient nous être utiles ![pause=0]Rendons leur visite tous les jours pour voir ce qu'ils vendent !")
				UI:WaitShowDialogue("Nous devrons choisir soigneusement à qui nous achetons chaque jour, cependant,[pause=10].")
			else
				UI:WaitShowDialogue("Aucun dialogue assigné pour cette partie de la ville. Faites savoir à Palika où vous avez reçu ce message.")
			end
		end


	else
		UI:WaitShowDialogue("Dialogue du chapitre 3 introuvable pour ce terrain/scénario. Veuillez en informer Palika.")
	end

	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	partner.IsInteracting = false
end




function PartnerEssentials.Chapter_4_Dialogue(partner)
	local ground = GAME:GetCurrentGround().AssetName--get ground's internal name
	UI:SetSpeaker(partner)
	local hero = CH('PLAYER')
	partner.IsInteracting = true
	GROUND:CharSetAnim(partner, 'None', true)
	GROUND:CharSetAnim(hero, 'None', true)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	GeneralFunctions.SetEmotion('Normal')

	--yes i know this is yandere dev shit i dont know how better to structure this. a lua table doesn't really make sense here without having to do a bunch of extra bullshit that i feel makes it less categorized/ordered.
	--can redo this with a better approach if a good one can be figured out.
	if ground == 'guild_heros_room' then
		if SV.TemporaryFlags.JustWokeUp then
			GeneralFunctions.SetEmotion("Happy")
			UI:WaitShowDialogue("Bonjour,[pause=10]" .. hero:GetDisplayName() .. " !")

		else
			PartnerEssentials.Default_Partner_Chapter_4_Dialogue()
		end
	elseif in_array(ground, {'guild_bedroom_hallway',
						     'guild_storage_room',
							 'guild_top_left_bedroom',
							 'guild_top_right_bedroom',
							 'guild_third_floor_lobby',
							 'guild_first_floor',
							 'guild_dining_room',
							 'guild_storage_hallway'}) then
		PartnerEssentials.Default_Partner_Chapter_4_Dialogue()
	elseif ground == 'guild_bottom_left_bedroom' then
		if not SV.Chapter4.FinishedGrove then
			if SV.Chapter3.BreloomGirafarigConvo then
				UI:WaitShowDialogue(CharacterEssentials.GetCharacterName("Breloom") .. " et " .. CharacterEssentials.GetCharacterName("Girafarig") .. " explorent les montagnes du nord,[pause=10]comme ils l'avaient dit l'autre jour au café.")
			else
				UI:WaitShowDialogue("L'expédition explique l'absence de " .. CharacterEssentials.GetCharacterName("Breloom") .. " et " .. CharacterEssentials.GetCharacterName("Girafarig") .. " ces derniers jours.[pause=0]Je n'avais aucune idée d'où ils se trouvaient !")
			end
			GeneralFunctions.SetEmotion("Happy")
			UI:WaitShowDialogue("J'espère qu'ils seront bientôt de retour ![pause=0]L'expédition s'annonce très amusante !")
		else
			UI:WaitShowDialogue(CharacterEssentials.GetCharacterName("Breloom") .. " et " .. CharacterEssentials.GetCharacterName("Girafarig") .. " devraient être de retour d’un jour à l’autre !")
			GeneralFunctions.SetEmotion("Worried")
			UI:WaitShowDialogue("Honnêtement,[pause=10] je m'attends à moitié à ce qu'ils reviennent tout de suite,[pause=10]juste à temps pour nous attraper dans leur chambre...")
		end
	elseif ground == 'guild_bottom_right_bedroom' then
		if not SV.Chapter4.FinishedGrove then
			GeneralFunctions.SetEmotion("Worried")
			local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("apricorn_grove")
			UI:WaitShowDialogue("Étant donné que " .. zone:GetColoredName() .. " est inexploré,[pause=10] je ne sais pas si les almanachs de " .. CharacterEssentials.GetCharacterName("Zigzagoon") .. " vont être d'une grande aide...")
			GeneralFunctions.SetEmotion("Normal")
			UI:WaitShowDialogue("Pourtant,[pause=10] cela ne peut pas faire de mal de les examiner.[pause=0]Peut-être qu'il y a des informations dans l'un d'entre eux qui peuvent encore nous aider !")
		else
			PartnerEssentials.Default_Partner_Chapter_4_Dialogue()
		end
	elseif ground == 'guild_second_floor' then
		if not SV.Chapter4.FinishedGrove then
			local audino_species = _DATA:GetMonster('audino'):GetColoredName()
			GeneralFunctions.SetEmotion("Happy")
			UI:WaitShowDialogue("C'est vraiment génial de la part de " .. CharacterEssentials.GetCharacterName("Audino") .. " d'ouvrir son assemblage " .. audino_species .. " !")
			UI:WaitShowDialogue("Il va falloir recruter un maximum de nouveaux coéquipiers pour en profiter !")
		else
			PartnerEssentials.Default_Partner_Chapter_4_Dialogue()
		end
	elseif ground == 'guild_guildmasters_room' then
		if not SV.Chapter4.FinishedGrove then
			if (SV.Chapter2.TropiusGaveReviver or SV.Chapter3.TropiusGaveWand) and not SV.Chapter4.TropiusGaveAdvice and not SV.Chapter4.ReachedGlade then
				UI:WaitShowDialogue("Le maître de guilde a pu nous aider dans nos missions passées...[pause=0]Je suis sûr qu'il pourrait nous aider à nouveau !")
			elseif not SV.Chapter4.TropiusGaveAdvice and not SV.Chapter4.ReachedGlade then
				--GeneralFunctions.SetEmotion("Worried")
				UI:WaitShowDialogue("J'espère que le maître de guilde pourra nous aider d'une manière ou d'une autre dans notre première véritable aventure !")
				UI:WaitShowDialogue("C'est un expert dans ce genre de choses,[pause=10] il devrait donc pouvoir nous aider d'une manière ou d'une autre !")
			elseif SV.Chapter4.TropiusGaveAdvice and not SV.Chapter4.ReachedGlade then
				local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("apricorn_grove")
				UI:WaitShowDialogue("Il va falloir suivre les conseils du Maître de Guilde et recruter autant de Pokémon que possible !")
				UI:WaitShowDialogue("Avec tous les Apricornes qu'il y a dans " .. zone:GetColoredName() .. ",[pause=10]ça ne devrait pas être trop dur !")
			else
				UI:WaitShowDialogue("Ne parlons pas au maître de guilde de l'énorme abricorne que nous avons trouvé tant que nous n'avons pas réussi à le retirer de l'arbre.")
				GeneralFunctions.SetEmotion("Joyous")
				UI:WaitShowDialogue("Je veux le surprendre lorsque nous le lui apporterons ![pause=0]Il sera certainement impressionné !")
			end
		else
			GeneralFunctions.SetEmotion("Happy")
			UI:WaitShowDialogue("C'était si gentil de la part du maître de guilde de nous laisser garder l'Apricorn que nous avons trouvé ![pause=0]C'est notre premier trésor !")
			GeneralFunctions.SetEmotion("Normal")
			UI:WaitShowDialogue("Je me demande quel genre de trésors il a réussi à trouver au cours de sa carrière d'aventurier ?")
		end
	elseif ground == 'ledian_dojo' then
		if not SV.Chapter4.FinishedGrove then
			PartnerEssentials.Default_Partner_Chapter_4_Dialogue()
		else
			UI:WaitShowDialogue("Il ne reste plus beaucoup de temps avant l'expédition.[pause=0]Nous devrions nous entraîner autant que possible d'ici là !")
			UI:WaitShowDialogue("Nous voudrons être prêts à tout lors de l'expédition,[pause=10]après tout !")
		end
	elseif in_array(ground, {'metano_electric_home',
							 'metano_normal_home',
							 'metano_water_home',
							 'metano_grass_home',
							 'metano_inn',
							 'metano_rock_home',
							 'metano_fire_home',
							 'metano_cave',
							 'metano_altere_transition'
								}) then
			PartnerEssentials.Default_Partner_Chapter_4_Dialogue()
	elseif ground == 'altere_pond' then
		local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("apricorn_grove")
		if not SV.Chapter4.FinishedGrove then
			if not SV.Chapter4.SpokeToRelicanthDayOne then
				UI:WaitShowDialogue(CharacterEssentials.GetCharacterName("Relicanth") .. " doit vivre seul dans l'étang.[pause=0]Il est rare de voir d'autres Pokémon venir ici depuis la ville.")
				UI:WaitShowDialogue("Nous devrions lui rendre visite avant de partir pour " .. zone:GetColoredName() .. " aujourd'hui.")
				UI:WaitShowDialogue("Il a l'air grincheux,[pause=10]mais je pense qu'il aime quand des Pokémon viennent lui rendre visite.")
			else
				GeneralFunctions.SetEmotion("Inspired")
				UI:WaitShowDialogue("Cela fait un moment que je n'ai pas entendu une des histoires de " .. CharacterEssentials.GetCharacterName("Relicanth") .. ".[pause=0]Nous avons été trop occupés pour venir en entendre une !")
				UI:WaitShowDialogue("Il faudra revenir écouter son histoire une fois que nous aurons fini d'explorer " .. zone:GetColoredName() .. " !")
			end
		else
			if not SV.Chapter4.HeardRelicanthStory and SV.Chapter4.SpokeToRelicanthDayOne then
				GeneralFunctions.SetEmotion("Inspired")
				UI:WaitShowDialogue("J'ai tellement hâte d'entendre l'histoire de " .. CharacterEssentials.GetCharacterName("Relicanth") .. " ![pause=0]Cela fait trop longtemps depuis la dernière !")
				GeneralFunctions.SetEmotion("Normal")
				UI:WaitShowDialogue("J'espère juste que c'est une de ses histoires que je n'ai jamais entendue auparavant !")
				UI:WaitShowDialogue("Il a tendance à oublier les histoires qu'il m'a déjà racontées.")
			elseif not SV.Chapter4.HeardRelicanthStory then
				UI:WaitShowDialogue("Nous avons un peu de temps libre avant le début de l'expédition.")
				UI:WaitShowDialogue("C'est une excellente occasion d'écouter une des histoires de " .. CharacterEssentials.GetCharacterName("Relicanth") .. " !")
				GeneralFunctions.SetEmotion("Inspired")
				UI:WaitShowDialogue("Parlons-lui et voyons s'il nous en dira une ![pause=0]Je suis sûr que vous l'apprécierez autant que moi !")
			else
				--todo
			end
		end
	elseif ground == 'post_office' then
		local current_rank = _DATA.Save.ActiveTeam.Rank
		UI:WaitShowDialogue("Maintenant que nous sommes[color=#FFA5FF]" .. current_rank:gsub("^%l", string.upper) .. "[color]Rang,[pause=10] nous sommes autorisés à utiliser les services de la poste.")
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue("Cela signifie que nous pouvons échanger et sauver nos amis quand nous le voulons maintenant !")
		UI:WaitShowDialogue("Utilisons cet endroit chaque fois que nous le pouvons,[pause=10]" .. hero:GetDisplayName() .. " !")
	elseif ground == 'metano_cafe' then
		if not SV.Chapter4.FinishedGrove then
			local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("apricorn_grove")
			UI:WaitShowDialogue("On dirait qu'il y a une nouvelle boisson au menu !")
			GeneralFunctions.SetEmotion("Worried")
			UI:WaitShowDialogue("Je me demande si cela pourrait nous aider dans notre exploration de " .. zone:GetColoredName() .. " ?")
		else
			if SV.Chapter4.CranidosBlush then
				GeneralFunctions.SetEmotion("Happy")
				UI:WaitShowDialogue("On dirait que quelqu’un est un peu plus doux qu’il n’aime le dire !")
				UI:WaitShowDialogue("Nous pourrions dire à " .. CharacterEssentials.GetCharacterName("Mareep") .. " ce que " .. CharacterEssentials.GetCharacterName("Cranidos") .. " a dit...[pause=0]Mais je ne veux pas m'abaisser à son niveau.")
				GROUND:CharSetEmote(partner, "glowing", 0)
				GeneralFunctions.SetEmotion("Joyous")
				UI:WaitShowDialogue("C'est assez drôle d'y penser,[pause=10]heeheehee !")
				GROUND:CharSetEmote(partner, "", 0)
			else
				PartnerEssentials.Default_Partner_Chapter_4_Dialogue()
			end
	end
	elseif ground == 'metano_town' then
		--metano town uses a series of touch objects to mark where the player/partner is on the map so the partner can comment on specific surroundings.
		local location = SV.metano_town.Locale
		--North Houses
		--South Houses
		--Guild
		--Cafe
		--Well
		--Post
		--Cave
		--Market
		--Dojo
		--Exploration
		--Merchants

		if not SV.Chapter4.FinishedGrove then
			if in_array(location, {'North Houses', 'South Houses', 'Guild', 'Cafe', 'Well', 'Post', 'Cave', 'Dojo', 'Merchants'}) then
				PartnerEssentials.Default_Partner_Chapter_4_Dialogue()
			elseif location == 'Market' then
				local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("apricorn_grove")
				if not SV.Chapter4.ReachedGlade then
					UI:WaitShowDialogue("Préparons-nous sur le marché ici pour notre exploration.")
					UI:WaitShowDialogue("Nous n'avons aucune idée de ce que nous allons rencontrer dans " .. zone:GetColoredName() .. ",[pause=10] nous voulons donc être aussi préparés que possible !")
				else
					UI:WaitShowDialogue("Préparons-nous sur le marché ici pour faire une randonnée à travers " .. zone:GetColoredName() .. ".")
					UI:WaitShowDialogue("Il va falloir être bien équipé si nous voulons revenir vers cet immense Apricorne !")
				end
			elseif location == 'Exploration' then
				if SV.TemporaryFlags.AudinoSummonCount < 10 then
					GeneralFunctions.SetEmotion("Happy")
					UI:WaitShowDialogue("C'est tellement gentil de la part de " .. CharacterEssentials.GetCharacterName("Audino") .. " d'installer ce panneau pour que nous puissions l'appeler jusqu'ici !")
					--UI:WaitShowDialogue("It's in such a convenient spot,[pause=10] here at the road out of town!")
					GeneralFunctions.SetEmotion("Normal")
					UI:WaitShowDialogue("Faisons quand même attention à ne pas en abuser.[pause=0]Elle court assez comme ça !")
				else
					GeneralFunctions.SetEmotion("Pain")
					UI:WaitShowDialogue("C'était plutôt méchant de notre part,[pause=10] n'est-ce pas... ?[pause=0]Nous ne devrions plus faire ça au pauvre " .. CharacterEssentials.GetCharacterName("Audino") .. ".")
				end
			else--failsafe
				if location == 'Exploration' and SV.TemporaryFlags.AudinoSummonCount >= 10 then
					GeneralFunctions.SetEmotion("Pain")
					UI:WaitShowDialogue("C'était plutôt méchant de notre part,[pause=10] n'est-ce pas... ?[pause=0]Nous ne devrions plus faire ça au pauvre " .. CharacterEssentials.GetCharacterName("Audino") .. ".")
				else
					PartnerEssentials.Default_Partner_Chapter_4_Dialogue()
				end
			end
		else
			PartnerEssentials.Default_Partner_Chapter_4_Dialogue()
		end
	else
		UI:WaitShowDialogue("Dialogue du chapitre 4 introuvable pour ce terrain/scénario. Veuillez en informer Palika.")
	end

	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	partner.IsInteracting = false
end

--------------------------------------------------------------------
-- CHAPITRE 5 — L'EXPEDITION.
-- Le partenaire n'avait aucun dialogue de suivi passe le chapitre 4 :
-- lui parler hors donjon levait une erreur Lua (voir le correctif dans
-- GetPartnerDialogue ci-dessus). Cette variante couvre les cartes de
-- l'expedition, avec un repli propre pour toutes les autres.
--------------------------------------------------------------------
function PartnerEssentials.Chapter_5_Dialogue(partner)
	local ground = GAME:GetCurrentGround().AssetName
	local hero = CH('PLAYER')
	UI:SetSpeaker(partner)
	partner.IsInteracting = true
	GROUND:CharSetAnim(partner, 'None', true)
	GROUND:CharSetAnim(hero, 'None', true)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	GeneralFunctions.SetEmotion('Normal')

	local c5 = SV.Chapter5

	if ground == 'mount_windswept_midpoint' then
		--Relais du Mont : la parole suit l'avancee dans le donjon.
		if c5.MountGuardianDefeated then
			GeneralFunctions.SetEmotion('Determined')
			UI:WaitShowDialogue("Le gardien nous a laissé le passage.[pause=0] Le sommet est ouvert,[pause=10] " .. hero:GetDisplayName() .. ".")
			UI:WaitShowDialogue("Reprends des forces au rocher.[pause=0] Après ça,[pause=10] il n'y aura plus de demi-tour.")
		--MINI-BOSS CH5 RETIRE : la branche « Le Defile est derriere nous »
		--dependait de MountMiniBossDefeated, flag plus jamais ecrit. Le texte
		--evoque une etape du donjon qui n'existe plus : retire.
		elseif c5.MountGuardianLost then
			GeneralFunctions.SetEmotion('Worried')
			UI:WaitShowDialogue("On s'est fait sortir...[pause=0] mais on est vivants,[pause=10] et le camp tient.")
			GeneralFunctions.SetEmotion('Determined')
			UI:WaitShowDialogue("On repart quand tu veux.[pause=0] Cette fois,[pause=10] on saura à quoi s'attendre.")
		else
			UI:WaitShowDialogue("Ce canyon coupe le vent.[pause=0] C'est le seul endroit calme de toute la montagne.")
			UI:WaitShowDialogue("Profites-en pour trier le sac.[pause=0] Le rocher de Kangourex est juste là.")
		end

	elseif ground == 'mount_windswept_entrance' then
		if c5.MountGuardianDefeated then
			GeneralFunctions.SetEmotion('Inspired')
			UI:WaitShowDialogue("Quand je repense à ce qu'on a vu là-haut...[pause=0] J'ai encore du mal à y croire.")
		elseif c5.EnteredMountain then
			UI:WaitShowDialogue("Le Mont Venteux nous attend.[pause=0] On remonte dès que tu es prêt,[pause=10] " .. hero:GetDisplayName() .. ".")
		else
			GeneralFunctions.SetEmotion('Determined')
			UI:WaitShowDialogue("Voilà donc le Mont Venteux.[pause=0] Le dernier morceau de l'expédition.")
		end

	elseif ground == 'searing_tunnel_midpoint' or ground == 'searing_tunnel_entrance' then
		UI:WaitShowDialogue("Cette chaleur me colle à la peau...[pause=0] Mais on avance,[pause=10] c'est l'essentiel.")

	elseif ground == 'vast_steppe_midpoint' or ground == 'vast_steppe_entrance' then
		UI:WaitShowDialogue("La steppe n'en finit pas.[pause=0] Et cette voix dans les herbes...[pause=10] tu l'entends aussi ?")

	else
		--Repli generique d'expedition : jamais de boite vide.
		UI:WaitShowDialogue("L'expédition continue,[pause=10] " .. hero:GetDisplayName() .. ".[pause=0] Reste près de moi.")
	end

	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	partner.IsInteracting = false
end

--Figured this would be a smarter way of handling default dialogue situations from now on.
function PartnerEssentials.Default_Partner_Chapter_4_Dialogue()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	if not SV.Chapter4.ReachedGlade then
		local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("apricorn_grove")
		GeneralFunctions.SetEmotion("Inspired")
		UI:WaitShowDialogue("Je n'arrive toujours pas à y croire,[pause=10]" .. hero:GetDisplayName() .. "![pause=0]Une véritable aventure dans un donjon inexploré !")
		UI:WaitShowDialogue("Allons maintenant sur " .. zone:GetColoredName() .. " et voyons ce que nous pouvons trouver ![pause=0]Je ne peux pas attendre plus longtemps !")
	elseif not SV.Chapter4.FinishedGrove then
		local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("apricorn_grove")
		UI:WaitShowDialogue("Cet énorme Apricorn nous attend toujours,[pause=10]" .. hero:GetDisplayName() .. " !")
		UI:WaitShowDialogue("Revenons à " .. zone:GetColoredName() .. " et ramenons-le à la maison !")
	else
		local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("apricorn_grove")
		GeneralFunctions.SetEmotion("Inspired")
		UI:WaitShowDialogue("Je suis tellement heureux que notre première vraie aventure se soit si bien déroulée ![pause=0]Nous avons également vraiment impressionné le maître de guilde !")
		UI:WaitShowDialogue("Entre ça et l'expédition qui approche,[pause=10]je déborde d'enthousiasme !")
		UI:WaitShowDialogue("J'espère que " .. CharacterEssentials.GetCharacterName("Breloom") .. " et " .. CharacterEssentials.GetCharacterName("Girafarig") .. " reviendront rapidement pour que nous puissions déjà partir en expédition !")
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue("Pendant que nous attendons,[pause=10] nous devrions effectuer les tâches affichées sur le Job Bulletin Board et le Outlaw Notice Board.")
		UI:WaitShowDialogue("Let's work hard as always,[pause=10] " .. hero:GetDisplayName() .. "!")
	end
end


function PartnerEssentials.GetPartnerDungeonDialogue()
end



