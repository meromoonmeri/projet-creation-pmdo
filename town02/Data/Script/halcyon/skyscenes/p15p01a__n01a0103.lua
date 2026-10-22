-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P15P01A/n01a0103.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Sympathy.ogg", true) end)
  -- back_SetGround(LEVEL_P15P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() GAME:MoveCamera(284, 164, 60, false) end) -- performer/caméra
  GAME:FadeIn(60)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]To do that...[K]I've come to\n[CN]the most famous place among explorers...", french="[CN]Et donc...[K] j'suis venu ici,\n[CN]à l'endroit l'plus réputé qui soit parmi\n[CN]les explorateurs...", german="[CN]Dafür...[K] habe ich mich zu dem Ort begeben,\n[CN]der unter Erkundern den besten Ruf genießt...", italian="[CN]Per riuscirci...[K] sono venuto\n[CN]nel posto più conosciuto dagli esploratori...", spanish="[CN]Y para conseguirlo...[K] he venido al lugar\n[CN]más famoso entre los exploradores..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]I've come to train at Guildmaster\n[CN][CS:N]Wigglytuff[CR]'s Guild! Yup yup!", french="[CN]J'suis venu m'entraîner à la Guilde de Maître\n[CN][CS:N]Grodoudou[CR]! Ouaip!", german="[CN]Ich bin zur [CS:N]Knuddeluff-Gilde[CR]\n[CN]des Gildenmeisters gestoßen! Jawollja!", italian="[CN]Sono venuto ad allenarmi alla Gilda\n[CN]di [CS:N]Wigglytuff[CR]! Già, già!", spanish="[CN]He venido a entrenarme al\n[CN][CS:N]Pokégremio de Exploradores[CR]. ¡Sí, señor!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(30)
  GROUND:EntTurn(hero, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  GROUND:EntTurn(hero, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Well, I'm off!", french=" Bon, j'me sauve!", german="Na gut, dann mach ich mich mal\nauf den Weg!", italian=" Beh, io vado!", spanish=" Bueno, me voy."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_biidaru = SkySceneKit.spawn_npc("bibarel", 312, 160, Direction.Left, "NPC_BIIDARU")
  do local p=npc_npc_biidaru.Position; GROUND:MoveToPosition(npc_npc_biidaru, p.X+(-8), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_biidaru) end)
  SkySceneKit.say({english="Please say hello to everyone in\nthe guild for me. Yup yup!", french="Pense à passer l'bonjour\nd'la part d'ta maman à tout ce p'tit monde\nde la Guilde, pardi!", german="Bitte grüße mir die\nGildenmitglieder ganz herzlich. Jawollja!", italian="Porta i miei saluti a tutta\nla Gilda. Già, già!", spanish="Saluda de mi parte a todo el\n[CS:N]Pokégremio[CR], ¿vale?"})
  pcall(function() UI:SetSpeaker(npc_npc_biidaru) end)
  SkySceneKit.say({english=" Oh... And be careful!", french="Oh... et fais attention\nà toi!", german=" Oh... Und pass auf dich auf!", italian=" Oh... E sii prudente!", spanish=" Ah... ¡Y ten cuidado!"})
  pcall(function() UI:SetSpeaker(npc_npc_biidaru) end)
  SkySceneKit.say({english="You're kind of a big eater...[K]\nDon't you go eating anything weird!", french="T'es du genre à t'goinfrer\ntout l'temps...[K]\nNe va pas nous gober un truc pas net!", german="Du bist ein kleiner\nVielfraß...[K] Nicht, dass du irgendetwas\nKomisches futterst!", italian="Sei un tale mangione... [K]\nCerca di non abbuffarti con qualcosa di strano!", spanish="Tienes un apetito voraz...[K]\n¡No vayas a comerte nada raro!"})
  pcall(function() UI:SetSpeaker(npc_npc_biidaru) end)
  SkySceneKit.say({english="Remember...[K] If you get in\ntrouble, you can always come back home to us.", french="Et souviens-toi...[K]\nAu moindre problème, tu pourras toujours\nrev'nir vivre ici.", german="Denk daran...[K] Solltest du in\nSchwierigkeiten geraten, kannst du immer noch\nzu uns zurückkehren.", italian="Ricorda...[K] Se dovessi\ntrovarti in difficoltà, puoi sempre tornare\nqui a casa da noi.", spanish="No lo olvides...[K] Si te ves\nen apuros, siempre podrás volver a casa."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Sniff... [K]M-Mama...", french=" Snif... [K]M-M'man...", german=" Schnüff... [K]M-mama...", italian=" Sniff...[K] M-Mamma...", spanish=" Buaaa...[K] Ma... mamá..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_bippa_bro = SkySceneKit.spawn_npc("bidoof", 296, 136, Direction.DownLeft, "NPC_BIPPA_BRO")
  do local p=npc_npc_bippa_bro.Position; GROUND:MoveToPosition(npc_npc_bippa_bro, p.X+(-4), p.Y+(4), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa_bro) end)
  SkySceneKit.say({english=" Do your best, Big Bro!", french="Fais d'ton mieux,\nle frangin!", german="Gib dein Bestes,\ngroßer Bruder!", italian=" Dacci dentro, fratellone!", spanish=" ¡A por todas, hermano!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_bippa_sis = SkySceneKit.spawn_npc("bidoof", 312, 184, Direction.UpLeft, "NPC_BIPPA_SIS")
  do local p=npc_npc_bippa_sis.Position; GROUND:MoveToPosition(npc_npc_bippa_sis, p.X+(-4), p.Y+(-4), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa_sis) end)
  SkySceneKit.say({english=" Take care!", french=" Fais attention à toi!", german=" Pass auf dich auf!", italian=" Abbi cura di te!", spanish=" ¡Cuídate mucho!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GROUND:EntTurn(hero, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Sniff... You guys...", french=" Snif... Vous...", german=" Schnüff... Ihr...", italian=" Sniff... Ragazzi...", spanish=" Snif... Familia..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  -- SetAnimation(29) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I'm fine![K]\nDon't you worry about me! Yup yup!", french="Ça roule![K]\nVous faites pas d'bile pour moi, sapristi!", german="Es geht schon![K] Macht euch keine\nSorgen! Jawollja!", italian="È tutto ok! [K]\nNon preoccupatevi per me! Già, già!", spanish=" ¡Estaré bien![K] ¡No os preocupéis!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="When I come home,[K]\nI'll be big! I'll make you proud of me!", french="Quand j'rentrerai,[K]\nj'serai un vrai héros!\nVous s'rez fiers de moi!", german="Wenn ich wiederkomme,[K] werde\nich berühmt sein! Ich werde euch stolz\nmachen!", italian="Quando tornerò a casa,[K] sarò\ncresciuto! Vi renderò fieri di me!", spanish="Cuando vuelva a casa...[K] ¡seré grande!\n¡Vais a estar orgullosos de mí!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Just wait and see!", french="Un peu d'patience\net vous verrez!", german=" Wartet nur ab!", italian=" Aspettate e vedrete!", spanish=" ¡Ya lo veréis!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(-64), g.ViewCenter.Y+(0), 128, false) end) -- MovePositionOffset performer/caméra
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-64), p.Y+(0), false, 1) end
  GAME:WaitFrames(15)
  GROUND:EntTurn(npc_npc_bippa_bro, Direction.Left)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_bippa_sis, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(45)
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="By golly, everyone![K]\nI'm off!", french="Assez d'parlotte, cette fois...[K]\nj'déguerpis!", german="Donnerwetter, ihr alle![K]\nIch bin dann mal weg!", italian="Ohibò![K]\nVi saluto!", spanish=" Bueno, gente...[K] ¡Me voy!"})
  -- message_Close
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-160), p.Y+(0), false, 2) end
  GAME:WaitFrames(30)
  do local p=npc_npc_bippa_bro.Position; GROUND:MoveToPosition(npc_npc_bippa_bro, p.X+(-64), p.Y+(0), false, 2) end
  GAME:WaitFrames(5)
  do local p=npc_npc_bippa_sis.Position; GROUND:MoveToPosition(npc_npc_bippa_sis, p.X+(-32), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa_bro, "happy", 1) end)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CS:N]Bidoof's Family[CR]: Do your best!", french="[CS:N]Famille de Keunotor[CR]: Fais d'ton mieux!", german="[CS:N]Familie von Bidiza[CR]: Alles Gute!", italian="[CS:N]Famiglia di Bidoof[CR]: Fai del tuo meglio!", spanish="[CS:N]Familia de Bidoof[CR]: ¡A por todas! ¡Hasta pronto!"})
  -- message_Close
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa_bro, nil, 0) end) -- EFFECT_NONE
  -- SetAnimation(51) [anim idle native]
  GAME:WaitFrames(7)
  -- SetAnimation(42) [anim idle native]
  GAME:WaitFrames(5)
  -- SetAnimation(42) [anim idle native]
  GAME:WaitFrames(120)
  pcall(function() SOUND:FadeOutBGM(120) end)
  -- screen2_FadeOut [sub déjà caché]
  GAME:FadeOut(false, 60)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(90)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]So I left my hometown...", french="[CN]Alors j'ai quitté mon p'tit chez moi...", german="[CN]Also habe ich meinen Heimatort verlassen...", italian="[CN]E così ho lasciato la mia casa...", spanish="[CN]Así que dejé atrás mi hogar..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]And entered the Guildmaster's\n[CN]guild as an apprentice.", french="[CN]... pour entrer comme apprenti\n[CN]à la Guilde.", german="[CN]Bin als Lehrling in die Gilde des\n[CN]Gildenmeisters eingetreten.", italian="[CN]... e sono entrato nella Gilda\n[CN]del Capitano come apprendista.", spanish="[CN]Y empecé como aprendiz\n[CN]en el [CS:N]Pokégremio[CR]."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]But the training at the guild...\n[CN]For me, was...", french="[CN]Mais voilà, pour moi, l'entraînement\n[CN]à la Guilde s'est avéré...", german="[CN]Aber das Training in der Gilde...", italian="[CN]Ma per me l'allenamento alla Gilda... era...", spanish="[CN]Pero el entrenamiento\n[CN]del [CS:N]Pokégremio[CR] me resultaba..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]More difficult than I thought...", french="[CN]... plus balaise que je l'pensais...", german="[CN]Es war schwieriger, als ich erwartet hatte...", italian="[CN]Più duro di quanto pensassi...", spanish="[CN]Más difícil de lo que había imaginado..."})
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
