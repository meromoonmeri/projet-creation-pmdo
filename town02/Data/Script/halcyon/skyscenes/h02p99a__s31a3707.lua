-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H02P99A/s31a3707.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]The next day...", french="[CN]Le jour suivant...", german="[CN]Am nächsten Tag...", italian="[CN]Il giorno dopo...", spanish="[CN]Al día siguiente..."})
  -- message_Close
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V24P08A) [décor sub chargé: Sub_v24p08a]
  -- back_SetGround(LEVEL_H02P99A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- camera2_SetPositionMark(Position<'m0', 19, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  GROUND:EntTurn(hero, Direction.Right)
  GROUND:EntTurn(partner, Direction.Left)
  -- SetAnimation(76) [anim idle native]
  -- SetAnimation(76) [anim idle native]
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  SkySubScreen.Show("v24p08a", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- SetAnimation(63) [anim idle native]
  GAME:WaitFrames(5)
  -- SetAnimation(63) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(hero, Direction.Down)
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(partner, Direction.Down)
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" It's late, [hero]!", french=" Il se fait tard, [hero]!", german=" Es ist an der Zeit, [hero]!", italian=" È tardi, [hero]!", spanish=" ¡Qué tarde es, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" It's late, [hero]!", french=" Il se fait tard, [hero]!", german=" Es ist an der Zeit, [hero]!", italian=" È tardi, [hero]!", spanish=" ¡Es tarde, [hero]!"})
  else
  SkySceneKit.say({english=" It's late, [hero]!", french=" Il se fait tard, [hero]!", german=" Es ist an der Zeit, [hero]!", italian=" È tardi, [hero]!", spanish=" ¡Mira qué horas, [hero]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yesterday was so much fun!", french="On a vraiment passé un bon\nmoment, hier soir!", german="Gestern hatten wir so\nviel Spaß!", italian=" Ieri è stato uno spasso!", spanish=" ¡Lo de ayer fue divertidísimo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Yesterday was so much fun!", french="On a vraiment passé un bon\nmoment, hier soir!", german="Gestern hatten wir so\nviel Spaß!", italian=" Ieri è stato davvero divertente!", spanish=" ¡Lo de ayer fue una gozada!"})
  else
  SkySceneKit.say({english=" Yesterday was so much fun!", french="On a vraiment passé un bon\nmoment, hier soir!", german="Gestern hatten wir so\nviel Spaß!", italian=" Ieri è stato davvero divertente!", spanish=" ¡Lo de ayer fue una pasada!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I'm kind of tired from staying up\nall night talking...", french="Passer toute la nuit à discuter,\nça m'a épuisé...", german="Die Nacht durchzuplaudern\nwar ganz schön ermüdend...", italian="Rimanere in piedi tutta la notte\na parlare mi ha distrutto...", spanish="Me caigo de cansancio, nos\npasamos la noche en vela hablando..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I'm kind of tired from staying up\nall night talking...", french="Passer toute la nuit à discuter,\nça m'a épuisé...", german="Die Nacht durchzuplaudern\nwar ganz schön ermüdend...", italian="Rimanere in piedi tutta la notte\na parlare mi ha distrutto...", spanish="Me caigo de cansancio, nos\npasamos la noche en vela charlando..."})
  else
  SkySceneKit.say({english="I'm kind of tired from staying up\nall night talking...", french="Passer toute la nuit à discuter,\nça m'a épuisée...", german="Die Nacht durchzuplaudern\nwar ganz schön ermüdend...", italian="Rimanere in piedi tutta la notte\na parlare mi ha distrutta...", spanish="Me caigo de sueño, nos\npasamos la noche en vela hablando..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I won't be able to forget\neveryone's smiling faces!", french="Mais je n'oublierai pas la mine\nréjouie des invités!", german="Aber die vielen lächelnden\nGesichter bleiben unvergesslich!", italian="... ma non dimenticherò mai\nil sorriso stampato sul volto di chi ci\nascoltava!", spanish="¡Nunca me olvidaré de la sonrisa\nque todos tenían en la cara!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I won't be able to forget\neveryone's smiling faces!", french="Mais je n'oublierai pas la mine\nréjouie des invités!", german="Aber die vielen lächelnden\nGesichter bleiben unvergesslich!", italian="... ma non dimenticherò mai\nil sorriso stampato sul volto di chi ci\nascoltava!", spanish="¡Nunca me olvidaré de la sonrisa\nque todos tenían en la cara!"})
  else
  SkySceneKit.say({english="I won't be able to forget\neveryone's smiling faces!", french="Mais je n'oublierai pas la mine\nréjouie des invités!", german="Aber die vielen lächelnden\nGesichter bleiben unvergesslich!", italian="... ma non dimenticherò mai\nil sorriso stampato sul volto di chi ci\nascoltava!", spanish="¡Nunca me olvidaré de la sonrisa\nque todos tenían en la cara!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey, [hero].", french=" Hé, [hero].", german=" Hey, [hero].", italian=" Ehi, [hero].", spanish=" Oye, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey, [hero].", french=" Hé, [hero].", german=" Hey, [hero].", italian=" Ehi, [hero].", spanish=" Oye, [hero]."})
  else
  SkySceneKit.say({english=" Hey, [hero].", french=" Hé, [hero].", german=" Hey, [hero].", italian=" Ehi, [hero].", spanish=" Oye, [hero]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I've asked you this before, but...", french="Je sais que je t'ai déjà posé\ncette question, mais...", german="Ich habe dich das\nschon einmal gefragt, aber...", italian=" So di avertelo già chiesto, ma...", spanish="Sé que ya te lo había dicho,\npero..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I've asked you this before, but...", french="Je sais que je t'ai déjà posé\ncette question, mais...", german="Ich habe dich das\nschon einmal gefragt, aber...", italian=" So di avertelo già chiesto, ma...", spanish="Sé que ya te lo había\npreguntado, pero..."})
  else
  SkySceneKit.say({english=" I've asked you this before, but...", french="Je sais que je t'ai déjà posé\ncette question, mais...", german="Ich habe dich das\nschon einmal gefragt, aber...", italian=" So di avertelo già chiesto, ma...", spanish="Lo sé, ya te lo había dicho,\npero..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Exploring is so much fun,\nisn't it?", french="Les explorations, c'est vraiment\nsympa, non?", german="Auf Erkundung gehen macht\neine Menge Spaß, nicht wahr?", italian="... esplorare è davvero\ndivertente, non è vero?", spanish="Explorar mola mogollón,\n¿a que sí?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Exploring is so much fun,\nisn't it?", french="Les explorations, c'est vraiment\nsympa, non?", german="Auf Erkundung gehen macht\neine Menge Spaß, nicht wahr?", italian="... esplorare è davvero\ndivertente, non è vero?", spanish="Explorar mola un montón,\n¿a que sí?"})
  else
  SkySceneKit.say({english="Exploring is so much fun,\nisn't it?", french="Les explorations, c'est vraiment\nsympa, non?", german="Auf Erkundung gehen macht\neine Menge Spaß, nicht wahr?", italian="... esplorare è davvero\ndivertente, non è vero?", spanish="Explorar es superguay,\n¿a que sí?"})
  end
  do local __choice = SkySceneKit.ask({{english="Yeah!", french="Ouais!", german="Genau!", italian="Certo!", spanish="¡Sí!"}, {english="Nope...", french="Bof...", german="Nö...", italian="No...", spanish="No..."}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 1 then
  -- @label_0 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Right!", french=" C'est vrai, non?", german=" Genau!", italian=" Già!", spanish=" ¿A que sí?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Right!", french=" C'est vrai, non?", german=" Genau!", italian=" Già!", spanish=" ¿A que sí?"})
  else
  SkySceneKit.say({english=" Right!", french=" C'est vrai, non?", german=" Genau!", italian=" Già!", spanish=" ¿A que sí?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- @label_2 [étiquette de flux ExplorerScript]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="All right! Let's go have fun\nexploring today!", french="Très bien! C'est parti pour une\nnouvelle et passionnante journée d'exploration!", german="Nun gut! Lass uns heute\nviel Spaß beim Erkunden haben!", italian="Ok! Divertiamoci a esplorare\nanche oggi!", spanish="Bueno, pues vamos a seguir\ndivirtiéndonos explorando."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="All right! Let's go have fun\nexploring today!", french="Très bien! C'est parti pour une\nnouvelle et passionnante journée d'exploration!", german="Nun gut! Lass uns heute\nviel Spaß beim Erkunden haben!", italian="Ok! Divertiamoci a esplorare\nanche oggi!", spanish="Bueno, vamos a seguir\ndivirtiéndonos explorando."})
  else
  SkySceneKit.say({english="All right! Let's go have fun\nexploring today!", french="Très bien! C'est parti pour une\nnouvelle et passionnante journée d'exploration!", german="Nun gut! Lass uns heute\nviel Spaß beim Erkunden haben!", italian="Ok! Divertiamoci a esplorare\nanche oggi!", spanish="Bueno, pues vamos a seguir\ndivirtiéndonos explorando."})
  end
  -- message_Close
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  GROUND:EntTurn(hero, Direction.Down)
  GROUND:EntTurn(partner, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  -- SetAnimation(66) [anim idle native]
  -- SetAnimation(66) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(80)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(45)
  pcall(function() SOUND:FadeOutBGM(120) end)
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 30)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(90)
  pcall(function() SOUND:PlayFanfare("Fanfare/Note") end) -- me_Play(7) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]A message has arrived from the\n[CN]Exploration Team Federation...[W:30]", french="[CN]La Fédération des Equipes d'Exploration\n[CN]a envoyé un message...[W:30]", german="[CN]Eine Nachricht vom Erkundungsteamverband\n[CN]ist für euch angekommen...[W:30]", italian="[CN]È arrivato un messaggio\n[CN]dalla Federazione Squadre d'Esplorazione...[W:30]", spanish="[CN]Ha llegado un mensaje de la\n[CN]Federación de Exploradores.[W:30]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]If you want to hear that song again...", french="[CN]Il est possible de réécouter ce morceau...", german="[CN]Wenn du dieses Lied noch einmal anhören\n[CN]möchtest, kannst du dies von jetzt an tun.", italian="[CN]Se vuoi ascoltare di nuovo quella canzone...", spanish="[CN]Si quieres volver a escuchar esa canción..."})
  -- message_KeyWait
  pcall(function() SOUND:PlayFanfare("Fanfare/LevelUp") end) -- me_Play(1) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]There's now a machine available for you to\n[CN]listen to the game music anytime!\n[CN]The Sky Jukebox is now available![W:100]", french="[CN]Vous pouvez désormais utiliser un appareil\n[CN]pour écouter les musiques du jeu à loisir!\n[CN]Le Juke-box Céleste est disponible![W:100]", german="[CN]Es gibt nun eine Einrichtung, um die Musik\n[CN]des Spiels jederzeit anhören zu können!\n[CN]Die Himmels-Jukebox wurde freigeschaltet![W:100]", italian="[CN]... da adesso è possibile! Con il nuovo\n[CN]Jukebox Cielo a disposizione, puoi ascoltare\n[CN]la colonna sonora del gioco quando vuoi![W:100]", spanish="[CN]¡Ahora puedes escuchar todas las canciones\n[CN]del juego siempre que quieras!\n[CN]¡Ya puedes usar la Gramola celeste![W:100]"})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]To access the Sky Jukebox, select\n[CN]Other from the Top Menu.", french="[CN]Pour accéder au Juke-box Céleste,\n[CN]sélectionnez Autres dans le menu principal.", german="[CN]Um die Himmels-Jukebox zu starten,\n[CN]wähle im Hauptmenü SONSTIGES aus.", italian="[CN]Per accedere al Jukebox Cielo,\n[CN]seleziona Altro dal menu principale.", spanish="[CN]Para acceder a la Gramola celeste,\n[CN]selecciona \"Otros\" en el menú principal."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]To use the Sky Jukebox, save your adventure\n[CN]and return to the Top Menu.", french="[CN]Pour utiliser le Juke-box Céleste, sauvegardez\n[CN]votre aventure et retournez au menu principal.", german="[CN]Um die Himmels-Jukebox zu verwenden,\n[CN]speichere dein Abenteuer und kehre\n[CN]zum Hauptmenü zurück.", italian="[CN]Per utilizzare il Jukebox Cielo, salva\n[CN]la tua avventura e torna al menu principale.", spanish="[CN]Para usarla, guarda la aventura y\n[CN]vuelve al menú principal."})
  -- message_Close
  GAME:WaitFrames(30)
  pcall(function() GAME:MoveCamera(0, 0, 1, true) end) -- caméra défaut
  SkySubScreen.Show("v24p08a", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  -- GAP: BGM BGM_DO_YOUR_BEST_AS_ALWAYS non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  else -- default/annulation
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Ah ha ha ha ha ha!\nStayed up too late. Still half asleep!", french="Ah ha ha ha ha ha!\nTu as veillé trop tard!\nTu dors encore à moitié!", german="Hahahahaha! Bist wohl zu lange\naufgeblieben. Noch völlig verschlafen!", italian="Ah ah ah ah ah ah!\nAbbiamo fatto troppo tardi, eh?!\nSei ancora nel mondo dei sogni, vero?", spanish="¡Ja, ja, ja, ja, ja!\n¡Por lo visto aún no te has despertado!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Ah ha ha ha ha ha!\nStayed up too late. Still half asleep!", french="Ah ha ha ha ha ha!\nTu as veillé trop tard!\nTu dors encore à moitié!", german="Hahahahaha! Bist wohl zu lange\naufgeblieben. Noch völlig verschlafen!", italian="Ah ah ah ah ah ah!\nAbbiamo fatto troppo tardi, eh?!\nSei ancora nel mondo dei sogni, vero?", spanish="¡Ja, ja, ja, ja, ja!\n¡Veo que aún no te has despertado!"})
  else
  SkySceneKit.say({english="Ah ha ha ha ha ha!\nStayed up too late. Still half asleep!", french="Ah ha ha ha ha ha!\nTu as veillé trop tard!\nTu dors encore à moitié!", german="Hahahahaha! Bist wohl zu lange\naufgeblieben. Noch völlig verschlafen!", italian="Ah ah ah ah ah ah!\nAbbiamo fatto troppo tardi, eh?!\nSei ancora nel mondo dei sogni, vero?", spanish="¡Ja, ja, ja, ja, ja!\n¡Parece que aún no te has despertado!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
