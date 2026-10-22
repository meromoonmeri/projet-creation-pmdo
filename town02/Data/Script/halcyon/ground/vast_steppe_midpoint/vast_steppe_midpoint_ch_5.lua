--[[
    vast_steppe_midpoint_ch_5.lua
    Relais Grande Steppe — Chapitre 5.
    Contenu : arrivee initiale, etats de retour (mort/repetition), dialogues a
    variantes pour le partenaire, Hyko (Growlithe) et Almotz (Zigzaton),
    cinematique comique de Plum la Rondoudou (Prompt Maitre §3.2 - respiration
    comique), interactions de camp.
    Ground officiel : cliff_camp (792x528). Marker central (388,268).
    Toutes les coordonnees utilisees ici sont verifiees walkables.
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'

vast_steppe_midpoint_ch_5 = {}

--------------------------------------------------------------------
-- Arrivee initiale (premiere traversee de la moitie nord)
--------------------------------------------------------------------
function vast_steppe_midpoint_ch_5.FirstArrival()

	--LE NOIR AVANT TOUT APPEL MOTEUR (correctif d'arrivee, 2026-07-30).
	--Cette scene se joue sous le noir laisse par la carte precedente et ne
	--rallume qu'a son FadeIn final. Mais GAME:FadeOut est BLOQUANT
	--(ScriptGame.cs:1590) et rend la main au moteur : tout appel place
	--avant le premier fondu laisse passer des frames RENDUES, sur une
	--carte chargee mais NON MONTEE (joueur au marqueur par defaut, camera
	--non recadree, decor absent). D'ou l'eclair de zone nue signale en
	--jeu. FadeOut(false,1) sur ecran deja noir = no-op (FadeEffect.cs:63).
	pcall(function() GAME:FadeOut(false, 1) end)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  AI:DisableCharacterAI(partner)
  SOUND:StopBGM()

  -- Ground officiel cliff_camp (792x528 px) : arrivée près du marker central (388,268).
  GROUND:TeleportTo(hero, 404, 300, Direction.Up)
  GROUND:TeleportTo(partner, 372, 300, Direction.Up)
  GAME:MoveCamera(388, 260, 1, false)

  GAME:CutsceneMode(true)
  GAME:WaitFrames(60)

  UI:ResetSpeaker()
  UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 20)
  GAME:WaitFrames(60)
  UI:WaitHideTitle(20)
  GAME:FadeIn(40)

  SOUND:PlayBGM('Cliff Camp.ogg', false)

  GAME:WaitFrames(30)

  local coro1 = TASK:BranchCoroutine(function()
    GROUND:MoveInDirection(partner, Direction.Up, 48, false, 1)
  end)
  local coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(6)
    GROUND:MoveInDirection(hero, Direction.Up, 48, false, 1)
  end)
  TASK:JoinCoroutines({coro1, coro2})

  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue("On a traversé la première moitié de la steppe.[pause=0] Regarde,[pause=10] quelqu'un a aménagé un vrai camp ici.")
  UI:WaitShowDialogue("Des souches taillées,[pause=10] des tentes...[pause=0] Les équipes d'expédition qui nous ont précédés,[pause=10] sûrement.")

  GAME:WaitFrames(15)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue("Cette brume ne se lève toujours pas...[pause=0] et cette voix qu'on a cru entendre dans les herbes hautes...")
  UI:WaitShowDialogue("Plus on avance,[pause=10] plus j'ai l'impression que la steppe nous observe.")

  GAME:WaitFrames(20)
  GeneralFunctions.HeroDialogue(hero, "(On doit rester sur nos gardes.[pause=0] La steppe n'a pas dit son dernier mot.)", "Worried")

  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue("Reposons-nous un peu.[pause=0] Le rocher de Kangourex est là,[pause=10] autant en profiter pour trier nos affaires.")
  UI:WaitShowDialogue("On repartira vers le nord quand on sera prêts.[pause=0] Et cette fois,[pause=10] on ne se laissera pas surprendre.")

  GAME:WaitFrames(40)
  SOUND:FadeOutBGM(60)
  GAME:FadeOut(false, 60)

  SV.Chapter5.PlayedSteppeMidpointIntro = true

  -- Ne pas relancer la même GroundMap depuis son callback Enter : la
  -- transition imbriquée pouvait laisser le relais sous le fondu noir.
  -- La mise en place finale est effectuée sur la carte déjà chargée.
  GAME:CutsceneMode(false)
  vast_steppe_midpoint_ch_5.SetupGround()
  GAME:MoveCamera(0, 0, 1, true)
end

--------------------------------------------------------------------
-- Mise en place des retours (positions des equipiers selon l'etat)
--------------------------------------------------------------------
function vast_steppe_midpoint_ch_5.SetupGround()
  local hyko = CH('Teammate2')
  local almotz = CH('Teammate3')

  if SV.Chapter5.SteppeGuardianLost then
    -- Apres une defaite : les deux recrues sont pres du rocher, en soins.
    if almotz ~= nil then GROUND:TeleportTo(almotz, 660, 232, Direction.Right) end
    if hyko ~= nil then GROUND:TeleportTo(hyko, 732, 260, Direction.Left) end
  else
    -- Disposition de repos ordinaire, autour du camp.
    if almotz ~= nil then GROUND:TeleportTo(almotz, 300, 340, Direction.Down) end
    if hyko ~= nil then GROUND:TeleportTo(hyko, 470, 250, Direction.Down) end
  end

  -- Spawner le PNJ Sentret (Insolourdo/Fouinette inoffensif du relais)
  local sentret = CharacterEssentials.MakeCharactersFromList({
    {'Sentret', 350, 250, Direction.DownRight}
  })
  GROUND:CharSetAnim(sentret, "Idle", true)

  if SV.Chapter5.SteppeGuardianDefeated and not SV.Chapter5.SteppeNightSceneSeen then
    -- Veillee dramatique apres la victoire sur le gardien.
    vast_steppe_midpoint_ch_5.NightWatchScene()
  else
    GAME:FadeIn(20)
  end
end

--------------------------------------------------------------------
-- Partenaire : dialogue a variantes selon la progression
--------------------------------------------------------------------
function vast_steppe_midpoint_ch_5.Partner_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')

  if SV.Chapter5.SteppeGuardianDefeated then
    GeneralFunctions.StartConversation(chara, "Le gardien de la steppe...[pause=0] On l'a vraiment fait reculer.", "Happy")
    UI:WaitShowDialogue("Tu as vu comme les troupeaux se sont calmés,[pause=10] juste après ?[pause=0] Comme si toute la plaine avait retenu son souffle avec lui.")
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue("Le Tunnel Incandescent nous attend au nord.[pause=0] Mais je crois qu'on a gagné le droit de souffler cinq minutes.")
  elseif SV.Chapter5.SteppeGuardianLost then
    GeneralFunctions.StartConversation(chara, "Cet Absol...[pause=0] il ne frappait pas pour nous chasser.[pause=10] Il frappait pour protéger quelque chose.", "Worried")
    UI:WaitShowDialogue("On refera une tentative.[pause=0] Mais cette fois,[pause=10] garde tes distances quand il baisse la tête.[pause=0] J'ai encore les côtes qui sifflent.")
    GeneralFunctions.SetEmotion("Determined")
    UI:WaitShowDialogue("Prépare-toi au rocher de Kangourex.[pause=0] Des Baies,[pause=10] des Orbes...[pause=0] tout ce qu'on peut porter.")
  --MINI-BOSS CH5 RETIRE : deux branches parlaient ici du Mudbray et du
  --Cerfrousse (SteppeMiniBossDefeated / SteppeMiniBossLost). Ces gardiens
  --n'existent plus dans le donjon et les flags ne sont plus jamais ecrits :
  --code mort citant du contenu supprime. Retire ; la replique generique
  --ci-dessous prend le relais.
  else
    GeneralFunctions.StartConversation(chara, "Ce camp est bien placé.[pause=0] Adossé à la falaise,[pause=10] le vent passe au-dessus sans nous frapper.", "Normal")
    UI:WaitShowDialogue("Les anciens de la guilde savaient ce qu'ils faisaient en balisant cette route.")
    GeneralFunctions.SetEmotion("Worried")
    UI:WaitShowDialogue("...J'aimerais juste comprendre pourquoi aucune des équipes précédentes n'a laissé de rapport sur la moitié nord.")
  end
  GeneralFunctions.EndConversation(chara)
end

--------------------------------------------------------------------
-- Hyko (Growlithe) : la recrue loyale, un peu raide, en formation de garde
--------------------------------------------------------------------
function vast_steppe_midpoint_ch_5.Hyko_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if chara == nil then return end

  if SV.Chapter5.SteppeGuardianDefeated then
    GeneralFunctions.StartConversation(chara, "Vous avez été remarquables contre le gardien,[pause=10] wouf ![pause=0] Le Maître de Guilde entendra parler de votre sang-froid.", "Happy")
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue("J'ai consigné le combat dans mon carnet de patrouille.[pause=0] Heure,[pause=10] position,[pause=10] comportement de l'adversaire.[pause=0] La procédure,[pause=10] toujours la procédure.")
    GeneralFunctions.SetEmotion("Worried")
    UI:WaitShowDialogue("...Mais entre nous,[pause=10] un Absol de cette taille,[pause=10] ce n'est pas dans les registres.[pause=0] Rien de tout ça n'est dans les registres.")
  elseif SV.Chapter5.SteppeGuardianLost then
    GeneralFunctions.StartConversation(chara, "Nous ne devons pas perdre espoir,[pause=10] wouf !", "Determined")
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue("À l'entraînement,[pause=10] Tropius répétait :[pause=10] «[pause=5] Une équipe qui se relève est plus dangereuse qu'une équipe qui n'est jamais tombée.[pause=5] »")
    UI:WaitShowDialogue("Je monte la garde pendant que vous vous préparez.[pause=0] Personne ne nous surprendra deux fois.")
  elseif SV.Chapter5.PlayedSteppeMidpointIntro then
    GeneralFunctions.StartConversation(chara, "La moitié nord est balisée jusqu'à la crête,[pause=10] wouf.[pause=0] Après,[pause=10] c'est terrain inconnu.", "Normal")
    UI:WaitShowDialogue("J'ai vérifié le rocher de Kangourex :[pause=10] intact,[pause=10] fonctionnel.[pause=0] Ces relais sont plus vieux que la guilde elle-même,[pause=10] vous saviez ?")
    GeneralFunctions.SetEmotion("Happy")
    UI:WaitShowDialogue("Quelqu'un,[pause=10] il y a très longtemps,[pause=10] a voulu que les voyageurs puissent toujours se reposer quelque part.[pause=0] J'aime cette idée,[pause=10] wouf.")
  else
    GeneralFunctions.StartConversation(chara, "Position sécurisée,[pause=10] wouf ![pause=0] J'ai fait trois fois le tour du camp.[pause=0] Aucun signe hostile.", "Normal")
    UI:WaitShowDialogue("Enfin...[pause=0] aucun signe hostile VISIBLE.[pause=0] Les herbes hautes au nord bougent contre le vent.[pause=10] Contre le vent,[pause=10] vous comprenez ?")
    GeneralFunctions.SetEmotion("Worried")
    UI:WaitShowDialogue("Je ne dormirai que d'un œil.[pause=0] C'est réglementaire de toute façon :[pause=10] un garde dort toujours d'un œil.")
  end
  GeneralFunctions.EndConversation(chara)
end

--------------------------------------------------------------------
-- Almotz (Zigzaton) : la recrue au grand coeur qui pense a sa famille
--------------------------------------------------------------------
function vast_steppe_midpoint_ch_5.Almotz_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if chara == nil then return end

  if SV.Chapter5.SteppeGuardianDefeated then
    GeneralFunctions.StartConversation(chara, "On a réussi...[pause=0] On a vraiment réussi ![pause=0] Attendez que je raconte ça aux petits !", "Happy")
    UI:WaitShowDialogue("Mon frère ne me croira jamais.[pause=0] «[pause=5] Almotz,[pause=10] face à un gardien ?[pause=5] »[pause=0] Il va falloir des témoins.[pause=10] Vous serez mes témoins,[pause=10] hein ?")
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue("...Bon.[pause=0] D'abord le Tunnel,[pause=10] ensuite les histoires de héros.[pause=0] Maman dit toujours qu'il ne faut pas vendre la Baie avant la récolte.")
  elseif SV.Chapter5.SteppeGuardianLost then
    GeneralFunctions.StartConversation(chara, "Aïe aïe aïe...[pause=0] J'ai cru qu'on y restait,[pause=10] cette fois.", "Pain")
    GeneralFunctions.SetEmotion("Worried")
    UI:WaitShowDialogue("Avant de partir,[pause=10] j'ai promis à ma famille que je reviendrais entier.[pause=0] Pas «[pause=5] presque entier[pause=5] ».[pause=0] Entier.")
    GeneralFunctions.SetEmotion("Determined")
    UI:WaitShowDialogue("Alors on va se préparer correctement,[pause=10] et on va gagner.[pause=0] Parce que je ne compte pas mentir à ma mère,[pause=10] moi.")
  elseif SV.Chapter5.PlayedSteppeMidpointIntro then
    GeneralFunctions.StartConversation(chara, "Vous avez vu tous ces troupeaux dans la plaine ?[pause=0] Des Écrémeuh,[pause=10] des Ponyta sauvages...", "Happy")
    UI:WaitShowDialogue("Chez moi,[pause=10] on n'a que les champs et la rivière.[pause=0] Les petits adoreraient voir ça.")
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue("Un jour,[pause=10] quand tout ce sera calmé,[pause=10] je les amènerai ici.[pause=0] En touristes,[pause=10] hein.[pause=0] Pas en expédition.")
  else
    GeneralFunctions.StartConversation(chara, "Vous saviez que les souches,[pause=10] là,[pause=10] ce sont des tables ?[pause=0] Les équipes d'avant mangeaient ici.", "Normal")
    UI:WaitShowDialogue("Ça me rappelle la maison.[pause=0] On est huit à table,[pause=10] chez nous.[pause=0] Huit ![pause=0] Le premier servi a intérêt à manger vite.")
    GeneralFunctions.SetEmotion("Happy")
    UI:WaitShowDialogue("Quand on rentrera,[pause=10] je vous invite.[pause=0] Ma mère fait un gratin de Baies Oran...[pause=10] vous m'en direz des nouvelles.")
  end
  GeneralFunctions.EndConversation(chara)
end

--------------------------------------------------------------------
-- CINEMATIQUE COMIQUE — Plum la Rondoudou (Prompt Maitre §3.2)
-- Une Rondoudou itinerante s'invite au camp et chante. Tout le monde
-- s'endort sauf Hyko qui resiste par devoir... puis s'effondre. La scene
-- se conclut sur une note tendre : Almotz parle de sa famille en dormant.
--------------------------------------------------------------------
function vast_steppe_midpoint_ch_5.PlumSongScene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local hyko = CH('Teammate2')
  local almotz = CH('Teammate3')

  GAME:CutsceneMode(true)
  GAME:FadeIn(30)
  GAME:WaitFrames(20)

  AI:DisableCharacterAI(partner)

  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue("Bon.[pause=0] On vérifie l'équipement,[pause=10] on mange un morceau,[pause=10] et on repart vers...")

  GAME:WaitFrames(10)
  SOUND:PlayBattleSE("EVT_Emote_Confused")
  GROUND:CharSetEmote(partner, "question", 1)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue("...Tu entends ça ?")

  GeneralFunctions.HeroDialogue(hero, "(Un fredonnement ?[pause=0] Ici,[pause=10] en pleine steppe ?)", "Worried")

  -- Entree de Plum par le sud du camp
  local plum = CharacterEssentials.MakeCharactersFromList({{'Jigglypuff', 388, 404, Direction.Up}})
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(plum, 388, 330, false, 2)
  GAME:WaitFrames(10)

  GeneralFunctions.Speak(plum, "Happy")
  UI:WaitShowDialogue("La la laaa ~[pause=0] Oh ![pause=0] Du public !")
  UI:WaitShowDialogue("Vous tombez bien.[pause=0] Je fais la tournée des camps de la steppe.[pause=0] Plum,[pause=10] artiste lyrique itinérante ![pause=0] Enchantée ~")

  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Stunned")
  UI:WaitShowDialogue("Artiste...[pause=10] lyrique ?[pause=0] Ici ?[pause=0] Il n'y a personne à des kilomètres !")

  GeneralFunctions.Speak(plum, "Normal")
  UI:WaitShowDialogue("Détail.[pause=0] Les troupeaux m'adorent.[pause=0] Les Écrémeuh pleurent à la fin.[pause=0] Enfin je crois qu'elles pleurent.[pause=10] Elles s'allongent,[pause=10] en tout cas.")

  if hyko ~= nil then
    GeneralFunctions.Speak(hyko, "Worried")
    UI:WaitShowDialogue("Wouf.[pause=0] Madame,[pause=10] ce camp est une zone de repos réglementée de la guilde,[pause=10] et...")
  end

  GeneralFunctions.Speak(plum, "Happy")
  UI:WaitShowDialogue("Une répétition générale ![pause=0] Quelle merveilleuse idée,[pause=10] petit chien.[pause=0] Public assis,[pause=10] s'il vous plaît !")

  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Shouting")
  UI:WaitShowDialogue("Non non non,[pause=10] attendez ![pause=0] Ne chantez p—")

  -- La chanson commence : notes + endormissement progressif
  SOUND:FadeOutBGM(30)
  GAME:WaitFrames(20)
  BossFX.Particle("Music_Notes", 388, 310, 4)
  SOUND:PlayBattleSE("DUN_Sing")
  GAME:WaitFrames(30)
  BossFX.Particle("Music_Notes", 360, 300, 4)
  BossFX.Particle("Music_Notes", 416, 300, 4)

  -- Almotz tombe le premier, en pleine phrase
  if almotz ~= nil then
    UI:SetSpeaker(almotz)
    GeneralFunctions.SetEmotion("Happy")
    UI:WaitShowDialogue("Oh,[pause=10] j'adore cette chanson ![pause=0] Ma mère la chantait quand on étai...[pause=20][speed=0.5]quand on étai...[speed=1]")
    GROUND:CharSetAnim(almotz, "EventSleep", true)
    BossFX.Particle("Sleep_Z", almotz.Position.X + 8, almotz.Position.Y - 8, 5)
    GAME:WaitFrames(20)
  end

  -- Le heros lutte
  GeneralFunctions.HeroDialogue(hero, "(Non...[pause=10] pas maintenant...[pause=10] mes paupières...)", "Pain")
  GROUND:CharSetAnim(hero, "EventSleep", true)
  BossFX.Particle("Sleep_Z", hero.Position.X + 8, hero.Position.Y - 8, 5)
  GAME:WaitFrames(20)

  -- Le partenaire negocie... puis s'effondre
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue("Madame,[pause=10] c'est très joli,[pause=10] mais on doit vraiment rester éveil...[pause=20][speed=0.4]éveil...lés...[speed=1]")
  GROUND:CharSetAnim(partner, "EventSleep", true)
  BossFX.Particle("Sleep_Z", partner.Position.X + 8, partner.Position.Y - 8, 5)
  GAME:WaitFrames(20)

  -- Hyko resiste par devoir : le dernier debout
  if hyko ~= nil then
    GeneralFunctions.Speak(hyko, "Determined")
    UI:WaitShowDialogue("Un garde...[pause=10] de la guilde...[pause=10] ne dort...[pause=10] JAMAIS...[pause=10] en service...[pause=10] wouf...")
    GAME:WaitFrames(30)
    BossFX.Particle("Music_Notes", hyko.Position.X, hyko.Position.Y - 12, 4)
    UI:WaitShowDialogue("...[pause=20]wouf.[pause=30].....[speed=0.3]zzz.[speed=1]")
    GROUND:CharSetAnim(hyko, "EventSleep", true)
    BossFX.Particle("Sleep_Z", hyko.Position.X + 8, hyko.Position.Y - 8, 5)
    GAME:WaitFrames(30)
  end

  -- Plum, seule, vexee
  GeneralFunctions.Speak(plum, "Stunned")
  UI:WaitShowDialogue(".........")
  GeneralFunctions.SetEmotion("Angry")
  UI:WaitShowDialogue("ENCORE ?![pause=0] Mais c'est pas vrai ![pause=0] TOUS les publics de cette steppe ![pause=0] TOUS !")
  GROUND:CharSetEmote(plum, "angry", 1)
  GAME:WaitFrames(20)
  GeneralFunctions.SetEmotion("Sad")
  UI:WaitShowDialogue("Un jour,[pause=10] quelqu'un écoutera ma chanson jusqu'au bout.[pause=0] Et ce jour-là...[pause=10] ce sera le plus beau jour de ma vie.")

  -- La note tendre : Almotz parle en dormant
  GAME:WaitFrames(30)
  if almotz ~= nil then
    UI:SetSpeaker(almotz)
    UI:WaitShowDialogue("[speed=0.6]...maman...[pause=20] garde-moi du gratin...[pause=20] je rentre bientôt...[speed=1]")
    GAME:WaitFrames(20)
    GeneralFunctions.Speak(plum, "Normal")
    UI:WaitShowDialogue("...Bon.[pause=0] D'accord.[pause=0] Peut-être que ce n'est pas un si mauvais public.")
    UI:WaitShowDialogue("Dors bien,[pause=10] petit rayé.[pause=0] Celle-là,[pause=10] c'était la berceuse préférée de ma mère à moi aussi.")
  end

  -- Sortie discrete de Plum
  GROUND:MoveToPosition(plum, 388, 404, false, 2)
  GROUND:Hide('Jigglypuff')
  GAME:WaitFrames(30)

  -- Reveil en fondu
  GAME:FadeOut(false, 40)
  GAME:WaitFrames(40)
  GROUND:CharEndAnim(hero)
  GROUND:CharEndAnim(partner)
  if hyko ~= nil then GROUND:CharEndAnim(hyko) end
  if almotz ~= nil then GROUND:CharEndAnim(almotz) end
  SOUND:PlayBGM('Cliff Camp.ogg', true)
  GAME:FadeIn(40)

  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Stunned")
  UI:WaitShowDialogue("...Hein ?[pause=0] Quoi ?[pause=0] Combien de temps on a dormi ?!")

  if hyko ~= nil then
    GeneralFunctions.Speak(hyko, "Shouting")
    UI:WaitShowDialogue("JE NE DORMAIS PAS ![pause=0] Je...[pause=10] j'inspectais l'intérieur de mes paupières,[pause=10] wouf ![pause=0] Procédure standard !")
  end

  GeneralFunctions.HeroDialogue(hero, "(Bizarrement...[pause=10] je ne me suis jamais senti aussi reposé.)", "Happy")

  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue("Bon...[pause=0] au moins on est frais pour la suite.[pause=0] Mais si quelqu'un demande,[pause=10] il ne s'est RIEN passé ici.[pause=0] D'accord ?")

  SV.Chapter5.PlumSceneSeen = true
  GAME:CutsceneMode(false)
  AI:EnableCharacterAI(partner)
  AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
end

--------------------------------------------------------------------
-- CINEMATIQUE DRAMATIQUE — La veillee du camp (lot D)
-- Jouee une fois, apres la victoire sur le gardien de la steppe :
-- discussion croisee Hyko x Almotz autour du feu, doutes du partenaire,
-- premiere verbalisation de la "voix" par toute l'equipe. Necrozma et
-- l'Abime ne sont jamais nommes (regle ch5).
--------------------------------------------------------------------
function vast_steppe_midpoint_ch_5.NightWatchScene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local hyko = CH('Teammate2')
  local almotz = CH('Teammate3')
  if hyko == nil or almotz == nil then GAME:FadeIn(20) return end

  GAME:CutsceneMode(true)
  AI:DisableCharacterAI(partner)
  SOUND:StopBGM()
  GROUND:AddMapStatus("darkness")

  -- Le feu de camp au centre, l'equipe autour.
  local campfire = RogueEssence.Content.ObjAnimData('Campfire', 6)
  GAME:GetCurrentGround().Decorations[0].Anims:Add(
    RogueEssence.Ground.GroundAnim(campfire, RogueElements.Loc(380, 292)))

  GROUND:TeleportTo(hero, 360, 332, Direction.Up)
  GROUND:TeleportTo(partner, 420, 332, Direction.Up)
  GROUND:TeleportTo(hyko, 340, 300, Direction.Right)
  GROUND:TeleportTo(almotz, 440, 300, Direction.Left)
  GAME:MoveCamera(388, 290, 1, false)

  GAME:FadeIn(60)
  GAME:WaitFrames(50)

  UI:SetSpeaker(almotz)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue("...Et là,[pause=10] mon frère ouvre le sac,[pause=10] et il n'y avait PLUS RIEN.[pause=0] Huit Baies.[pause=0] Envolées.[pause=0] Le mystère a duré deux ans.")
  UI:WaitShowDialogue("Jusqu'au jour où on a déplacé le buffet.[pause=0] Un nid de Rattata.[pause=10] Les plus gros Rattata de la région.[pause=0] Ils vivaient comme des rois.")

  GeneralFunctions.Speak(hyko, "Happy")
  UI:WaitShowDialogue("Wouf...[pause=0] Chez nous,[pause=10] un vol pareil aurait déclenché une enquête officielle.[pause=0] Rapport,[pause=10] témoins,[pause=10] reconstitution.")

  UI:SetSpeaker(almotz)
  GeneralFunctions.SetEmotion("Happy")
  UI:WaitShowDialogue("C'est POUR ÇA qu'on ne t'invite pas encore aux repas de famille,[pause=10] Hyko.[pause=0] Tu mettrais la moitié des petits en détention.")

  GAME:WaitFrames(30)

  -- Le vent change. La conversation aussi.
  SOUND:PlayBattleSE("DUN_Wind")
  GAME:WaitFrames(20)

  GeneralFunctions.Speak(hyko, "Worried")
  UI:WaitShowDialogue("...Vous l'avez entendue aussi,[pause=10] n'est-ce pas ?[pause=0] Dans les herbes,[pause=10] pendant le combat contre le gardien.")
  UI:WaitShowDialogue("Ce n'était pas le vent.[pause=0] Le vent ne...[pause=10] wouf.[pause=0] Le vent ne murmure pas de mots.")

  UI:SetSpeaker(almotz)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue("J'espérais que c'était juste moi.[pause=0] Franchement,[pause=10] j'espérais TRÈS fort que c'était juste moi.")

  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue("Ce n'était pas juste toi.[pause=0] On l'entend depuis le départ de Metano.[pause=0] " .. hero:GetDisplayName() .. " et moi.")
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue("Elle ne menace pas.[pause=0] C'est presque pire.[pause=0] On dirait qu'elle...[pause=10] observe.[pause=0] Qu'elle prend des notes.")

  GAME:WaitFrames(20)
  GeneralFunctions.HeroDialogue(hero, "(Le gardien ne nous barrait pas la route par territoire.[pause=0] Il montait la garde.[pause=10] Contre quoi ?)", "Worried")

  GAME:WaitFrames(30)

  GeneralFunctions.Speak(hyko, "Determined")
  UI:WaitShowDialogue("Alors voilà ce que je propose,[pause=10] wouf.[pause=0] On consigne tout.[pause=0] Chaque murmure,[pause=10] chaque heure,[pause=10] chaque lieu.")
  UI:WaitShowDialogue("Si cette voix suit un motif,[pause=10] le Maître de Guilde saura le lire.[pause=0] Et sinon...[pause=10] au moins on aura fait notre travail.")

  UI:SetSpeaker(almotz)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue("Et moi je propose qu'on dorme.[pause=0] Une peur,[pause=10] ça se porte mieux avec huit heures de sommeil et un bon petit-déjeuner.")
  GeneralFunctions.SetEmotion("Happy")
  UI:WaitShowDialogue("Maman dit ça.[pause=0] Et maman n'a jamais tort.[pause=0] Sauf sur les Rattata du buffet.[pause=0] Là,[pause=10] elle accusait le voisin.")

  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Happy")
  UI:WaitShowDialogue("Adopté.[pause=0] Premier quart de garde pour moi.[pause=0] " .. hero:GetDisplayName() .. ",[pause=10] tu prends le deuxième ?")
  GeneralFunctions.HeroDialogue(hero, "(Comme si l'un de nous allait vraiment fermer l'œil...)", "Normal")

  GAME:WaitFrames(40)
  SOUND:FadeOutBGM(40)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(30)

  GROUND:RemoveMapStatus("darkness")
  SV.Chapter5.SteppeNightSceneSeen = true
  SOUND:PlayBGM('Cliff Camp.ogg', true)
  GAME:CutsceneMode(false)
  AI:EnableCharacterAI(partner)
  AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
  GAME:FadeIn(40)
end



--------------------------------------------------------------------
-- Réveil après une défaite au-delà du checkpoint (vague 8).
-- Le duo revient à lui près du Terminal, ranimé par ses réserves.
--------------------------------------------------------------------
function vast_steppe_midpoint_ch_5.WipedCutscene()

	--LE NOIR AVANT TOUTE MISE EN PLACE (correctif de retour de boss,
	--2026-07-30). Cette scene est jouee juste apres un EndSegment /
	--EnterZone : le moteur a pose le noir, mais rien ne le REPOSE ici.
	--Elle enchaine pourtant plusieurs appels moteur (creation de PNJ,
	--TeleportTo, MoveCamera, StopBGM) avant son FadeIn. GAME:FadeOut
	--etant bloquant (ScriptGame.cs:1590) et FadeInternal rendant la
	--main a chaque frame (FadeEffect.cs:30-42), ces appels laissent
	--passer des frames RENDUES sur une carte en cours de montage —
	--c'est l'apercu de zone signale en jeu. FadeOut(false,1) sur un
	--ecran deja noir est un no-op (FadeEffect.cs:63) : gratuit si le
	--noir a tenu, salvateur sinon.
	pcall(function() GAME:FadeOut(false, 1) end)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local hyko = CH('Teammate2')
  local almotz = CH('Teammate3')

  GAME:CutsceneMode(true)
  SOUND:StopBGM()
  if partner ~= nil then AI:DisableCharacterAI(partner) end

  -- Fix audit 2026-07-27 : l'ancienne position du partenaire (704,224)
  -- chevauchait le collider du rocher Kangourex (696,216,24x24). Le duo se
  -- réveille désormais SOUS la statue, sur des cases libres vérifiées
  -- (flood-check obstacles). Aucun élément de la map n'est modifié.
  GROUND:TeleportTo(hero, 668, 256, Direction.Left)
  if partner ~= nil then GROUND:TeleportTo(partner, 700, 256, Direction.Right) end
  GROUND:CharSetAnim(hero, "EventSleep", true)
  if partner ~= nil then GROUND:CharSetAnim(partner, "EventSleep", true) end
  -- Hyko et Almotz ont ramené le duo : ils veillent en contrebas.
  if hyko ~= nil then GROUND:TeleportTo(hyko, 640, 296, Direction.UpRight) end
  if almotz ~= nil then GROUND:TeleportTo(almotz, 724, 296, Direction.UpLeft) end
  GAME:MoveCamera(684, 264, 1, false)

  GAME:FadeIn(60)
  SOUND:PlayBGM('Heartwarming.ogg', true)
  GAME:WaitFrames(110)

  local coro1 = TASK:BranchCoroutine(function()
    GeneralFunctions.DoAnimation(hero, 'Wake')
    GAME:WaitFrames(12)
    GROUND:CharAnimateTurnTo(hero, Direction.Down, 4) end)
  local coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(14)
    if partner ~= nil then
      GeneralFunctions.DoAnimation(partner, 'Wake')
      GAME:WaitFrames(12)
      GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
    end end)
  local coro3 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(30)
    if hyko ~= nil then GeneralFunctions.EmoteAndPause(hyko, "Exclaim", false) end end)
  local coro4 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(44)
    if almotz ~= nil then GROUND:CharAnimateTurnTo(almotz, Direction.UpLeft, 4) end end)
  TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
  GAME:WaitFrames(30)

  if hyko ~= nil then
    GeneralFunctions.Speak(hyko, "Happy")
    UI:WaitShowDialogue("Ils se réveillent ![pause=10] Wouf ![pause=0] Chef, ils se réveillent !")
    GAME:WaitFrames(10)
  end

  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Pain")
  UI:WaitShowDialogue("Aïe... aïe aïe aïe...[pause=20] On est... au camp ?")
  GAME:WaitFrames(14)

  if almotz ~= nil then
    UI:SetSpeaker(almotz)
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue("On vous a tirés des herbes hautes par la peau du cou.[pause=20] La prochaine fois, laissez une trace de passage,[pause=10] que je n'aie pas à flairer toute la steppe.")
    GAME:WaitFrames(10)
  end

  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue("C'est Hyko et Almotz qui nous ont traînés jusqu'ici.[pause=20] Les herbes sombres, là-bas...[pause=10] elles nous ont avalés d'un coup.")
  GAME:WaitFrames(14)

  if hyko ~= nil then
    GeneralFunctions.Speak(hyko, "Worried")
    UI:WaitShowDialogue("Le garde du camp signale que les Profondeurs bougent encore,[pause=10] wouf.[pause=0] Reposez-vous d'abord.[pause=0] Ordre du protocole.")
    GAME:WaitFrames(10)
  end

  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue("Les Profondeurs de la Steppe ne pardonnent pas.[pause=20] L'herbe y est plus haute que nous, et deux fois plus affamée.")
  GAME:WaitFrames(14)
  GeneralFunctions.SetEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format("Bon.[pause=10] On souffle, on refait les sacs...[pause=20] et cette fois, {0}, on reste GROUPÉS.", CH('PLAYER'):GetDisplayName()))
  GAME:WaitFrames(14)
  GAME:WaitFrames(20)
  if partner ~= nil then
    AI:EnableCharacterAI(partner)
    AI:SetCharacterAI(partner, 'origin.ai.ground_partner', hero, partner.Position)
    PartnerEssentials.SaveGamePartnerPosition(partner)
  end
  GAME:CutsceneMode(false)
  GAME:FadeIn(1)
end

return vast_steppe_midpoint_ch_5
