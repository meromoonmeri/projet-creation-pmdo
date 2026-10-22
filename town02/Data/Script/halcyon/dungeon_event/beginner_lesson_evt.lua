require 'origin.common'

beginner_lesson_evt = {}

--ledian is the 3rd party member
function beginner_lesson_evt.FindLedian()
--this check is needed as Ledian joins the team for floor 4 to allow team mode to work
	if GAME:GetPlayerGuestCount() == 0 then
		return GAME:GetPlayerPartyMember(1)
	else
		return GAME:GetPlayerGuestMember(0)
	end
end


--owner is the owner of the effect. For example, if the code is for lefties recovery, then the owner might be say, aqua ring, the item lefties, or the ability regenerator (if it worked like that)
--ownerChar is the character that has the particular status/item/ability/whatever. Whoever has the lefties.
--character is the character with the item/ability/status. Whoever has the lefties, they are the target of the effect
--args is a list of arguments passed to the script (see the arg table in the SingleCharScriptEvent effect)
function beginner_lesson_evt.Floor_1_Intro(owner, ownerChar, character, args)
	--progression flag is the number of speeches given by ledian. the functions in this document follow the order they're given in the dungeon
	local chara = beginner_lesson_evt.FindLedian()
	UI:SetSpeaker(chara)
	UI:WaitShowDialogue("Hwacha![pause=0]Bienvenue dans la zone d'apprentissage du dojo ![pause=0]C'est l'heure de votre première leçon !")
	UI:WaitShowDialogue("Hoiyah![pause=0]À cet étage, vous en apprendrez beaucoup sur les bases de l'exploration des donjons !")
	UI:WaitShowDialogue("Les bénévoles à venir présenteront des sujets d'apprentissage ou constitueront des obstacles à surmonter !")
	UI:WaitShowDialogue("Assurez-vous de lire les signes laissés par mon élève vedette ![pause=0]Ils contiennent des connaissances vitales essentielles à l'exploration des donjons !")
	UI:WaitShowDialogue("Vous pouvez me parler à tout moment pour réinitialiser le parquet si vous vous retrouvez coincé ![pause=0]Ne soyez pas timide,[pause=10]mon élève !")
	UI:WaitShowDialogue("En avant ![pause=0]Il y a beaucoup à apprendre,[pause=10]kya !")
	SV.Tutorial.Progression = 1
end

function beginner_lesson_evt.Floor_2_Intro(owner, ownerChar, character, args)
	local chara = beginner_lesson_evt.FindLedian()
	UI:SetSpeaker(chara)
	UI:WaitShowDialogue("Hwacha![pause=0]À cet étage, vous découvrirez les différents effets de statut que vous rencontrerez au cours de vos voyages !")
	UI:WaitShowDialogue("Les effets de statut sont des buffs ou des débuffs qui affectent la capacité d'un Pokémon à se battre !")
	UI:WaitShowDialogue("Les volontaires devant vous démontreront les mouvements qui appliquent les mouvements de statut ![pause=0]Attaquez-les et ils utiliseront leur mouvement !")
	SV.Tutorial.Progression = 2
end


function beginner_lesson_evt.Floor_3_Intro(owner, ownerChar, character, args)
	local hero = GAME:GetPlayerPartyMember(0)
	if SV.Tutorial.Progression == 3 then --set hunger and belly to 0 if ledian already cut hunger but you haven't passed the trial yet
		--set player hp to half, belly to 0
		hero.HP = hero.MaxHP / 2
		hero.Fullness = 0
	end

	local chara = beginner_lesson_evt.FindLedian()
	if SV.Tutorial.Progression == 2 then
		chara.CharDir = Direction.Up
	end
	UI:SetSpeaker(chara)
	UI:WaitShowDialogue("Hwacha![pause=0]Cet étage vous apprendra à utiliser les objets de manière judicieuse et appropriée !")
	UI:WaitShowDialogue("Wahtah![pause=0]Votre premier essai commence ici !")
	--ledian assaults you, but only on entering the floor
	if SV.Tutorial.Progression == 2 then
		--todo: tidy up when Audino adds calls for dungeon animations
		GAME:WaitFrames(10)
		local ledianAction = RogueEssence.Dungeon.CharAnimAction()
		ledianAction.BaseFrameType = 8 --chop
		ledianAction.AnimLoc = chara.CharLoc
		ledianAction.CharDir = chara.CharDir
		TASK:WaitTask(chara:StartAnim(ledianAction))
		SOUND:PlayBattleSE('DUN_Attack')
		GAME:WaitFrames(10)
		local heroAction = RogueEssence.Dungeon.CharAnimAction()
		heroAction.BaseFrameType = 4 --hurt
		heroAction.AnimLoc = hero.CharLoc
		heroAction.CharDir = hero.CharDir
		TASK:WaitTask(hero:StartAnim(heroAction))
		SOUND:PlayBattleSE('DUN_Hit_Neutral')
		hero.HP = hero.MaxHP / 2
		hero.Fullness = 0
		GAME:WaitFrames(10)
		TASK:WaitTask(hero:StartAnim(heroAction))
		GAME:WaitFrames(10)
		TASK:WaitTask(hero:StartAnim(heroAction))
		GAME:WaitFrames(20)
	end

	UI:WaitShowDialogue("J'ai réduit ta santé de moitié et ton ventre est complètement vide !")
	UI:WaitShowDialogue("Utilisez la nourriture et les baies dans cette pièce pour reprendre des forces afin de pouvoir continuer !")
	SV.Tutorial.Progression = 3
end

function beginner_lesson_evt.Floor_3_Wand_Speech(owner, ownerChar, character, args)
	local chara = beginner_lesson_evt.FindLedian()
	local item = RogueEssence.Dungeon.InvItem('orb_cleanse')
	UI:SetSpeaker(chara)
	UI:WaitShowDialogue("Hwacha![pause=0]Il est maintenant temps d'en apprendre davantage sur les baguettes et les orbes !")
	UI:WaitShowDialogue("Ce sont des objets polyvalents qui peuvent manipuler les ennemis ou être utiles ![pause=0]Utile contre les ennemis que vous ne souhaitez pas combattre.")
	UI:WaitShowDialogue("Hoiyah![pause=0]Le volontaire qui bloque le chemin est très fort ! Vous ne pouvez pas le combattre directement !")
	UI:WaitShowDialogue("Vous devez plutôt utiliser une baguette pour l'écarter ![pause=0]La baguette est cependant collante !")
	UI:WaitShowDialogue("Les objets collants ne peuvent pas être utilisés ![pause=0]Vous devez utiliser un " .. item:GetDisplayName() .. " pour les nettoyer !")
	UI:WaitShowDialogue("Oohcha ![pause=0]Votre prochain essai commence maintenant !")
	SV.Tutorial.Progression = 4
end

function beginner_lesson_evt.Floor_3_HeldItem_Speech(owner, ownerChar, character, args)
	local chara = beginner_lesson_evt.FindLedian()
	local item = RogueEssence.Dungeon.InvItem('held_band_of_passage')
	UI:SetSpeaker(chara)
	UI:WaitShowDialogue("Hwacha ![pause=0]Excellent travail jusqu'à présent, mon élève ![pause=0]Il est maintenant temps d'en apprendre davantage sur les objets retenus !")
	UI:WaitShowDialogue("Wahtah![pause=0]Des objets tels que des bracelets et des écharpes peuvent être donnés à un Pokémon pour obtenir des effets utiles !")
	UI:WaitShowDialogue("Certains objets augmentent les statistiques,[pause=10]tandis que d'autres protègent de certains problèmes de statut !")
	UI:WaitShowDialogue("Hoiyah![pause=0]Pour cet essai,[pause=10]vous devez vous équiper d'un " .. item:GetDisplayName() .. " et continuer à avancer !")
	UI:WaitShowDialogue("Vous ne pourrez pas continuer sans équiper le groupe !")
	SV.Tutorial.Progression = 5
end

function beginner_lesson_evt.Floor_3_ThrownReviver_Speech(owner, ownerChar, character, args)
	local chara = beginner_lesson_evt.FindLedian()
	UI:SetSpeaker(chara)
	local sticks = STRINGS:Format('\\uE0A1')..'[color=#FFCEFF]Sticks[color]'
	local stick = STRINGS:Format('\\uE0A1')..'[color=#FFCEFF]Stick[color]'
	local rock = STRINGS:Format('\\uE0A0')..'[color=#FFCEFF]Gravelerock[color]'
	local seed = STRINGS:Format('\\uE0A4')..'[color=#FFCEFF]Reviver Seeds[color]'
	UI:WaitShowDialogue("Hwacha![pause=0]Certains objets tels que " .. sticks .. " et " .. rock .. " peuvent être lancés sur les ennemis pour infliger des dégâts !")
	UI:WaitShowDialogue("Ils sont utiles pour endommager les ennemis éloignés de vous ![pause=0]Assurez-vous de ne pas les lancer sur vos coéquipiers !")
	UI:WaitShowDialogue("Hoiyah ![pause=0]Je veux aussi vous parler de " .. seed .. " !")
	UI:WaitShowDialogue("Ils sont rares,[pause=10]mais permettent de réanimer un coéquipier qui vient de s'évanouir !")
	UI:WaitShowDialogue("Ils sont inestimables lors des voyages difficiles ![pause=0]Assurez-vous de les utiliser à bon escient !")
	UI:WaitShowDialogue("Wahtah![pause=0]Pour cet essai,[pause=10] vous devez lancer un " .. stick .. " sur le volontaire devant vous !")
	UI:WaitShowDialogue("Après[pause=10], vous devez utiliser " .. seed .. " pour nous ranimer de la puissante contre-attaque du volontaire !")
	UI:WaitShowDialogue("Oohcha ![pause=0]Cela peut faire peur,[pause=10]mais tu ne dois montrer aucune peur face au danger,[pause=10]mon élève !")
	SV.Tutorial.Progression = 6
end

function beginner_lesson_evt.Floor_4_Intro(owner, ownerChar, character, args)
	--move ledian into the actual team for the team mode section
	if SV.Tutorial.Progression < 7 then
		p = GAME:GetPlayerGuestMember(0)
		GAME:RemovePlayerGuest(0)
		GAME:AddPlayerTeam(p)
		p:RefreshTraits()
		--todo: update this when audino adds an update
		_DUNGEON:RegenerateTurnMap()
	end

	local chara = beginner_lesson_evt.FindLedian()
	UI:SetSpeaker(chara)
	UI:WaitShowDialogue("Hwacha![pause=0]Cet étage vous apprendra les types de terrain que vous rencontrerez dans les donjons !")
	UI:WaitShowDialogue("Le terrain comprend des obstacles tels que de l'eau, de la lave et des murs !")
	UI:WaitShowDialogue("Hoiyah![pause=0]Vous devez apprendre comment le terrain affecte la navigation dans les donjons pour réussir en aventurier !")
	SV.Tutorial.Progression = 7
end

function beginner_lesson_evt.Floor_4_Key_Speech(owner, ownerChar, character, args)
	local chara = beginner_lesson_evt.FindLedian()
	UI:SetSpeaker(chara)
	UI:WaitShowDialogue("Hwacha ![pause=0]C'est l'heure de l'essai de cet étage ![pause=0]J'ai rejoint votre groupe pour celui-ci !")
	UI:WaitShowDialogue("Il y a des clés sur différents types de terrains dans cette pièce suivante !")
	UI:WaitShowDialogue("Vous devez utiliser le mode équipe pour me diriger à travers les terrains afin de récupérer les clés afin que vous puissiez progresser !")
	UI:WaitShowDialogue("Hoiyah ![pause=0]Appuyez sur " .. STRINGS:LocalKeyString(7) .. " pour basculer en mode équipe ![pause=0]J'attends vos instructions,[pause=10]mon élève !")
	SV.Tutorial.Progression = 8
end

function beginner_lesson_evt.Floor_5_Intro(owner, ownerChar, character, args)
	--move Ledian back to the guest table
	if SV.Tutorial.Progression < 9 then
		p = GAME:GetPlayerPartyMember(1)
		GAME:RemovePlayerTeam(1)
		GAME:AddPlayerGuest(p)
		p:RefreshTraits()
		--todo: update this when audino adds an update
		_DUNGEON:RegenerateTurnMap()
	end

	local chara = beginner_lesson_evt.FindLedian()
	UI:SetSpeaker(chara)
	UI:WaitShowDialogue("Hwacha ![pause=0]C'est le dernier étage ![pause=0]Votre épreuve finale vous attend !")
	UI:WaitShowDialogue("Utilisez les Apricorns pour recruter le bon volontaire,[pause=10]et demandez-lui d'ouvrir le chemin vers les escaliers !")
	UI:WaitShowDialogue("Vous pouvez le faire,[pause=10]mon élève ![pause=0]Utilisez tout ce que vous avez appris jusqu'à présent et vous réussirez ![pause=0]Hoiyah !")
	SV.Tutorial.Progression = 9
end





--be sure to check function BATTLE_SCRIPT.SenseiInteract(owner, ownerChar, context, args)
--in the event lua for ledian's interact script



