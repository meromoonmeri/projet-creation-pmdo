-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P21P02A/n03a0706.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V24P08A) [décor sub chargé: Sub_v24p08a]
  -- back_SetGround(LEVEL_P21P02A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 19, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() GAME:MoveCamera(148, 156, 60, false) end) -- performer/caméra
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  local npc_npc_aamarudo = SkySceneKit.spawn_npc("armaldo", 464, 144, Direction.Left, "NPC_AAMARUDO")
  GROUND:MoveToPosition(npc_npc_aamarudo, 140, 144, false, 2)
  GAME:WaitFrames(15)
  GROUND:MoveToPosition(hero, 164, 168, false, 2)
  -- GAP: BGM BGM_AT_THE_END_OF_THE_DAY non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  SkySubScreen.Show("v24p08a", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  GAME:WaitFrames(50)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="We found a lot today,\ndidn't we? ♪[K] Hee hee! ♪\nSuccess, success! ♪", french="Belle moisson de trésors\naujourd'hui, pas vrai? ♪[K] Hi hi! ♪\nVictoire, victoire! ♪", german="Heute haben wir eine Menge\nentdeckt, nicht wahr? ♪[K] Hihi! ♪\nErfolg! Erfolg! ♪", italian="Quante cose abbiamo\ntrovato oggi, vero? ♪[K] Eh eh! ♪\nSuccesso, successo! ♪", spanish="Hoy hemos encontrado de todo,\n¿eh? ♪[K] ¡Ji, ji! ♪ ¡Somos los mejores! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Hey, Master.", french=" Dites, Maître.", german=" Hey, Meister.", italian=" Ehi, maestro.", spanish=" Oye, maestro."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_aamarudo, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- SetAnimation(4) [anim idle native]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Where are we going to\nexplore tomorrow?", french=" On va où demain?", german="Wohin werden wir morgen auf\nErkundung gehen?", italian="Domani cosa andiamo\na esplorare?", spanish=" ¿Qué vamos a explorar mañana?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_aamarudo, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="Wh-what?[K] We just finished\ntoday's exploration, and already you're talking\nabout tomorrow's?", french="Co-comment?[K] On vient à peine\nde finir notre exploration du jour, que tu\nparles déjà de celle de demain?", german="W-wie bitte?[K] Wir haben gerade\ndie heutige Erkundung beendet und du planst\nschon für morgen?", italian="C-Cosa?[K] Abbiamo appena finito\nquesta esplorazione e vuoi già sapere\ncosa faremo domani?", spanish="¿Có... cómo?[K] Pero si acabamos\nde terminar la exploración de hoy... ¿y ya\npiensas en la de mañana?"})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="You're getting a little ahead\nof yourself.", french=" Tu es un peu trop impatient.", german="Du scheinst mir langsam ein\nwenig zu aufgekratzt!", italian=" Stai correndo un po' troppo.", spanish=" No adelantemos acontecimientos."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="That said...[K] I'll bet that\ntomorrow's location will be even better to us\nthan today's.", french="Ceci étant dit...[K] je parie que\nnotre destination de demain sera encore plus\nfructueuse que celle d'aujourd'hui.", german="Wobei...[K] Ich denke sogar, dass\ndie morgige Erkundung noch mehr zu bieten\nhaben wird als die heutige.", italian="E comunque...[K] Scommetto che\nil posto che visiteremo domani sarà ancora\npiù interessante di questo.", spanish="Pero...[K] seguro que donde vayamos\nmañana será incluso mejor que\ndonde hemos ido hoy."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" R-really?!", french=" V-vraiment?!", german=" W-wirklich?!?", italian=" D-Davvero?!", spanish=" ¡¿En... En serio?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="Yes.[K] Tomorrow, we're going to\n[CS:P]Fortune Ravine[CR]...", french="Oui.[K] Demain, nous allons au\n[CS:P]Ravin Aubaine[CR]...", german="Ja.[K] Morgen werden wir uns zur\n[CS:P]Schicksalsschlucht[CR] begeben...", italian="Sì.[K] Domani andremo a esplorare\nla [CS:P]Gola del Tesoro[CR]...", spanish="Sí.[K] Mañana vamos a ir al\n[CS:P]Risco Fortuna[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="Rumor has it that there's a lot\nof treasure there.", french="Une rumeur laisse à penser\nqu'il y aurait une tonne de trésors là-bas.", german="Gerüchte lassen auf eine Menge\nSchätze hoffen.", italian="Si dice che quel luogo trabocchi\ndi tesori.", spanish="Se rumorea que allí hay\nmuchos tesoros."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" A-amazing![K] I can't wait! ♪", french="Oh, merveilleux![K] Je suis pressé\nd'y être! ♪", german="Oh, w-wunderbar![K] Ich kann es\nkaum erwarten! ♪", italian=" F-Fantastico![K] Non vedo l'ora! ♪", spanish=" ¡Qué pasada![K] ¡Estoy deseando ir! ♪"})
  -- message_KeyWait
  -- SetAnimation(4) [anim idle native]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Let's go tomorrow![K]\nDefinitely. ♪", french="C'est là qu'on va demain![K]\nSûr, sûr. ♪", german="Lass uns das morgen machen![K]\nAuf jeden Fall. ♪", italian="Andiamo domani![K]\nDi corsa. ♪", spanish=" ¡Vamos mañana![K] Tenemos que ir. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Yeah.", french=" Ouais.", german=" Ja.", italian=" Sì.", spanish=" Sí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_aamarudo, Direction.Down)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_aamarudo, Direction.DownLeft)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_aamarudo, Direction.Left)
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_aamarudo, Direction.UpLeft)
  GAME:WaitFrames(40)
  GROUND:EntTurn(npc_npc_aamarudo, Direction.DownLeft)
  GAME:WaitFrames(50)
  GROUND:EntTurn(npc_npc_aamarudo, Direction.Down)
  GAME:WaitFrames(7)
  GROUND:EntTurn(npc_npc_aamarudo, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="Will you be all right getting\nhome from here by yourself?", french="Tu arriveras à retrouver ton\nchemin à partir d'ici?", german="Ist es okay für dich, von hier\naus allein nach Hause zu gehen?", italian="Sei sicuro di riuscire a tornare\na casa da solo da qui?", spanish="¿Sabrás volver a casa tú solo\ndesde aquí?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yep. ♪[K] I'm fine. ♪", french=" Voui. ♪[K] Pas de problème. ♪", german=" Natürlich. ♪[K] Kein Problem. ♪", italian=" Certo. ♪[K] Nessun problema. ♪", spanish=" Sí. ♪[K] Me las arreglaré. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="All right, see you at my\nplace tomorrow.", french="Soit, dans ce cas, on se\nretrouve chez moi demain.", german="Alles klar. Also sehen wir uns\nmorgen bei mir...", italian="Va bene, ci vediamo domani\nda me.", spanish="Muy bien, pues nos vemos\nmañana en mi casa."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="And then we'll head out for\n[CS:P]Fortune Ravine[CR].", french="Et nous nous rendrons ensemble\nau [CS:P]Ravin Aubaine[CR].", german="Wir machen uns dann auf zur\n[CS:P]Schicksalsschlucht[CR].", italian="Poi partiremo per\nla [CS:P]Gola del Tesoro[CR].", spanish="Y desde allí saldremos hacia el\n[CS:P]Risco Fortuna[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yep! ♪", french=" Voui! ♪", german=" Au fein! ♪", italian=" Sì! ♪", spanish=" ¡Vale! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-48), p.Y+(0), false, 2) end
  GAME:WaitFrames(10)
  GROUND:EntTurn(npc_npc_aamarudo, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Bye-bye, Master![K]\nSee you tomorrow! ♪", french="Au revoir, Maître![K]\nA demain! ♪", german="Tschüss, Meister![K]\nDann bis morgen! ♪", italian="Ciao ciao, maestro![K]\nCi vediamo domani! ♪", spanish=" ¡Adiós, maestro![K] ¡Hasta mañana! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-180), p.Y+(0), false, 2) end
  GAME:WaitFrames(12)
  GROUND:EntTurn(npc_npc_aamarudo, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(130)
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="Phew. Same as ever...[K]\nHe's always so cheerful.", french="Pfiou. Il ne change pas,\ncelui-là...[K] Toujours aussi guilleret.", german="Puh. Alles wie immer...[K]\nEr ist immer so fröhlich...", italian="Fiuuu. Non cambia mai...[K]\nÈ sempre vivace e pieno di allegria.", spanish="Buf. Como siempre...[K] No hay\ndía en que no esté radiante de felicidad."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Cheerful is good, but...", french=" Etre guilleret, c'est bien, mais...", german=" Es ist gut, fröhlich zu sein...", italian="È un bene che abbia tutte\nqueste energie, ma...", spanish="Me parece bien que esté\ncontento, pero..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_aamarudo, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="He's so cheerful that it tires me\nright out. Phew...", french="... lui, il l'est tellement que ça\nm'épuise. Pfiou...", german="Aber er ist so fröhlich,\ndass es mich ermüdet.", italian="... stargli dietro è davvero\nstancante. Puff pant...", spanish="Tanta alegría me deja totalmente\nagotado. Buf..."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="I should go home. I'm exhausted,\nbut I have to admit cheerfulness is\nkind of contagious. Phew...", french="Je devrais rentrer. Je suis\nexténué, mais il faut bien admettre que la\ngaieté, c'est contagieux. Pfiou...", german="Ich mache mich besser auf den\nHeimweg. Diese Fröhlichkeit hat irgendwie\netwas Ansteckendes... Puuuh...", italian="Meglio che vada a casa, sono\nesausto. Però devo ammettere che la sua\nallegria è contagiosa. Fiuuu...", spanish="Debería irme a casa. Estoy hecho\npolvo, pero tengo que admitir que la alegría\nes contagiosa. Buf..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  pcall(function() SOUND:FadeOutBGM(210) end)
  do local p=npc_npc_aamarudo.Position; GROUND:MoveToPosition(npc_npc_aamarudo, p.X+(-180), p.Y+(0), false, 2) end
  GAME:WaitFrames(250)
  -- SetOutputAttribute(4) [neutre/état moteur]
  pcall(function() GAME:MoveCamera(236, 156, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(60)
  -- supervision_Acting(1) [neutre/état moteur]
  local npc_npc_nidokingu = SkySceneKit.spawn_npc("nidoking", 280, 128, Direction.Left, "NPC_NIDOKINGU")
  -- SetAnimation(2) [anim idle native]
  do local p=npc_npc_nidokingu.Position; GROUND:MoveToPosition(npc_npc_nidokingu, p.X+(-48), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_nidokingu.Position; GROUND:MoveToPosition(npc_npc_nidokingu, p.X+(-20), p.Y+(16), false, 2) end -- Move2PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_nidokingu, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  -- message_ResetActor() [neutre/état moteur]
  -- message_FacePositionOffset(-4, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_nidokingu) end)
  SkySceneKit.say({english=" That Pokémon...", french=" Ce Pokémon...", german=" Dieses Pokémon...", italian=" Quel Pokémon...", spanish=" Ese Pokémon..."})
  pcall(function() UI:SetSpeaker(npc_npc_nidokingu) end)
  SkySceneKit.say({english=" That Pokémon...[K] Was that...", french=" Pas de doute...[K] C'était...", german=" Dieses Pokémon...[K] War das vielleicht...", italian=" Quel Pokémon...[K] era...", spanish=" Ese Pokémon...[K] era..."})
  -- message_Close
  SkySubScreen.Hide(90) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 90)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(60)
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
