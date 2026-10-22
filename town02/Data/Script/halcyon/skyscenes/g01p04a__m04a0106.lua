-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/m04a0106.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  -- back_SetGround(LEVEL_G01P04A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1)
  -- supervision_StationCommon(99) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 360, 256, Direction.UpRight, "NPC_GUREGGURU")
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_guregguru, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- message_FacePositionOffset(-3, 0) [neutre/état moteur]
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 168, 296, Direction.DownRight, "NPC_DOGOOMU")
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="Look, all you two have to do is\ninspect the footprints of visitors, then tell me\nwhat Pokémon they are.", french="Tout ce que vous avez à faire,\nc'est inspecter les empreintes des visiteurs\net me dire de quel Pokémon il s'agit.", german="Also, ihr müsst nur die\nFußabdrücke der Besucher inspizieren und mir\nsagen, was für Pokémon sie sind.", italian="Tutto ciò che dovete fare è\nispezionare le zampe dei visitatori e dirmi\na quali Pokémon appartengono.", spanish="Lo único que tenéis que hacer\nes inspeccionar las huellas de los visitantes,\ny luego decirme de qué Pokémon se trata."})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" All right? Understood?", french=" C'est bon? Vous avez compris?", german=" In Ordnung? Verstanden?", italian=" Va bene? Tutto chiaro?", spanish=" ¿Entendido?"})
  do local __choice = SkySceneKit.ask({{english="Understood", french="Compris!", german="Verstanden", italian="Tutto chiaro", spanish="Entendido"}, {english="Please explain again", french="Tu pourrais réexpliquer?", german="Bitte noch mal erklären", italian="Spiega di nuovo", spanish="Explícanoslo otra vez"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 1 then
  -- @label_0 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" Good! Then let's get to WORK!", french=" Super! Alors AU TRAVAIL!", german=" Gut! Dann an die ARBEIT!", italian=" Molto bene! Allora, al LAVORO!", spanish=" Estupendo. Ahora, ¡a trabajar!"})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" Buck up and do a GOOD job!", french="Soyez à la hauteur et faites\ndu BON boulot!", german=" Los, und macht eure Sache GUT!", italian="Rimboccatevi le maniche e fate\nun BUON LAVORO!", spanish=" ¡Espabilad y hacedlo bien!"})
  -- message_Close
  GROUND:EntTurn(hero, Direction.DownLeft)
  GROUND:EntTurn(partner, Direction.Left)
  GROUND:MoveToPosition(hero, 200, 292, false, 2)
  GROUND:MoveToPosition(partner, 224, 316, false, 2)
  GROUND:MoveToPosition(hero, 192, 300, false, 2)
  GROUND:MoveToPosition(partner, 208, 300, false, 2)
  GAME:FadeOut(false, 30)
  SkyProg.set(5, 2) -- $SCENARIO_MAIN = scn[5,2] (ROM)
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:WaitFrames(60)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Waah! It's pitch black in here,\n[hero]...", french="Ouah! C'est bien sombre\nlà-dedans, [hero]...", german="Waah! Es ist stockdunkel hier\ndrin, [hero].", italian="Waah! Non c'è un filo di luce\nqui, [hero]...", spanish="¡Aah! Aquí está muy oscuro,\n[hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Ack! It's pitch black in here,\n[hero]...", french="Ouah! C'est bien sombre\nlà-dedans, [hero]...", german="Argh! Es ist stockdunkel hier\ndrin, [hero].", italian="Aaah! Non c'è un filo di luce\nqui, [hero]...", spanish="¡Aah! Aquí está muy oscuro,\n[hero]."})
  else
  SkySceneKit.say({english="Yow! It's pitch black in here,\n[hero]...", french="Ouah! C'est bien sombre\nlà-dedans, [hero]...", german="Oje! Es ist stockdunkel hier\ndrin, [hero].", italian="Aaah! Non c'è un filo di luce\nqui, [hero]...", spanish="¡Aah! Aquí está muy oscuro,\n[hero]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We'll have to feel our way...", french=" Il faut y aller à tâtons...", german=" Wir müssen uns vorantasten.", italian=" Dovremo procedere a tentoni...", spanish="Tendremos que buscar el camino\na tientas."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" We'll have to feel our way...", french=" Il faut y aller à tâtons...", german=" Wir müssen uns vorantasten.", italian=" Dovremo procedere a tentoni...", spanish="Tendremos que buscar el camino\na tientas."})
  else
  SkySceneKit.say({english=" We'll have to feel our way...", french=" Il faut y aller à tâtons...", german=" Wir müssen uns vorantasten.", italian=" Dovremo procedere a tentoni...", spanish="Tendremos que buscar el camino\na tientas."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(20)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ...", french=" ...", german=" ...", italian=" ...", spanish=" ..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ...", french=" ...", german=" ...", italian=" ...", spanish=" ..."})
  else
  SkySceneKit.say({english=" ...", french=" ...", german=" ...", italian=" ...", spanish=" ..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ......", french=" ......", german=" ......", italian=" ......", spanish=" ... ..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ......", french=" ......", german=" ......", italian=" ......", spanish=" ... ..."})
  else
  SkySceneKit.say({english=" ......", french=" ......", german=" ......", italian=" ......", spanish=" ... ..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Well, we should be getting close\nto the sentry post...", french="Le poste de guet ne devrait\nplus être loin...", german="Tja, wir müssten uns langsam\ndem Wachposten nähern.", italian="Beh, ormai dovremmo essere nei\npressi del posto di guardia...", spanish="Ya debemos de estar cerca\ndel puesto vigía."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Well, we should be getting close\nto the sentry post...", french="Le poste de guet ne devrait\nplus être loin...", german="Tja, wir müssten uns langsam\ndem Wachposten nähern.", italian="Beh, ormai dovremmo essere nei\npressi del posto di guardia...", spanish="Ya debemos de estar cerca\ndel puesto vigía."})
  else
  SkySceneKit.say({english="Well, we should be getting close\nto the sentry post...", french="Le poste de guet ne devrait\nplus être loin...", german="Tja, wir müssten uns langsam\ndem Wachposten nähern.", italian="Beh, ormai dovremmo essere nei\npressi del posto di guardia...", spanish="Ya debemos de estar cerca\ndel puesto vigía."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  GAME:WaitFrames(2) -- join WaitSe
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Hey![K] There![K] I see light,\n[hero]!", french="Hé![K] Là![K] De la lumière!\n[hero]!", german="Hey![K] Da![K] Ich sehe Licht,\n[hero]!", italian="Ehi![K] Laggiù![K] Vedo della\nluce, [hero]!", spanish="¡Eh![K] ¡Por ahí![K]\n¡Veo luz, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Oh![K] There![K] I see light,\n[hero]!", french="Hé![K] Là![K] De la lumière!\n[hero]!", german="Hey![K] Da![K] Ich sehe Licht,\n[hero]!", italian="Ehi![K] Laggiù![K] Vedo della\nluce, [hero]!", spanish="¡Eh![K] ¡Por ahí![K]\n¡Veo luz, [hero]!"})
  else
  SkySceneKit.say({english="Oh![K] There it is![K] I see light,\n[hero]!", french="Hé![K] Là![K] De la lumière!\n[hero]!", german="Hey![K] Da![K] Ich sehe Licht,\n[hero]!", italian="Ehi![K] Laggiù![K] Vedo della\nluce, [hero]!", spanish="¡Eh![K] ¡Es por ahí![K]\n¡Veo luz, [hero]!"})
  end
  -- message_Close
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V04P02A) [décor sub chargé: Sub_v04p02a]
  -- camera2_SetPositionMark(Position<'m4', 19.5, 16>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  SkySubScreen.Show("v04p02a", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="HOW'S IT GOING?![K] Have you\ntaken position at the sentry post?!", french="COMMENT ÇA VA?![K] Vous avez\npris vos positions au poste de guet?!", german="ALLES KLAR?!?[K] Habt ihr Position\nunter dem Gitter bezogen?!?", italian="E ALLORA?![K] Avete trovato il\nposto di guardia?!", spanish="¿Qué tal va?[K] ¿Habéis ocupado\nvuestro lugar en el puesto vigía?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yup! We're here!", french=" Ouais! On y est!", german=" Ja! Wir sind hier!", italian=" Sì! Ci siamo!", spanish=" ¡Sí! ¡Aquí estamos!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Yes! We're in position!", french=" Ouais! On y est!", german=" Ja! Wir sind auf Posten!", italian=" Sì! Ci siamo!", spanish=" ¡Sí! ¡Ya estamos allí!"})
  else
  SkySceneKit.say({english=" Yep! We're here!", french=" Ouais! On y est!", german=" Ja! Wir sind hier!", italian=" Sì! Ci siamo!", spanish=" ¡Sí! ¡Aquí estamos!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" GOOD!", french=" BIEN!", german=" GUT!", italian=" OTTIMO!", spanish=" ¡BIEN!"})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="Pokémon visitors will step onto\nthe grill above the sentry post!", french="Les Pokémon visiteurs vont se\nplacer sur la grille au-dessus du poste\nde guet!", german="Besuchende Pokémon werden auf\ndas Gitter über dem Wachposten treten!", italian="I Pokémon che vengono in visita\nsi metteranno sulla griglia sopra il posto di\nguardia!", spanish="¡Los Pokémon que nos visiten\nse pondrán sobre la rejilla que tenéis encima!"})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="Identify them by footprint, then\ninform me![K] Got that?!", french="Identifiez leurs empreintes et\ninformez-moi![K] Compris?!", german="Identifiziert sie anhand des\nFußabdrucks und informiert mich![K] Kapiert?!?", italian="Identificateli in base alla forma\ndella zampa, poi informatemi![K] Capito?!", spanish="¡Identificadlos por su huella,\ny luego informadme![K] ¡¿Habéis entendido?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yup! Got it!", french=" D'accord! Compris!", german=" Ja! Kapiert!", italian=" Sì! Tutto chiaro!", spanish=" ¡Sí! ¡Entendido!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Yes! Understood!", french=" D'accord! Compris!", german=" Ja! Verstanden!", italian=" Sì! Abbiamo capito!", spanish=" ¡Sí! ¡Entendido!"})
  else
  SkySceneKit.say({english=" Yep! We got it!", french=" D'accord! Compris!", german=" Ja! Haben wir!", italian=" Sì! Tutto a posto!", spanish=" ¡Sí! ¡Entendido!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" GOOD! Let's get started!", french=" BIEN! C'est parti!", german=" GUT! Es kann losgehen!", italian="MOLTO BENE! Potete\ncominciare.", spanish=" ¡Bien! ¡Empecemos ya!"})
  -- message_Close
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 30)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  else -- default/annulation
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "angry", 1) end)
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '3', '0')
  -- SetAnimation(19) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "angry", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  -- SetAnimation(68) [anim idle native]
  -- SetAnimation(68) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitSe
  -- camera_SetEffect(0): arrêt d'effet caméra
  -- message_FacePositionOffset(-3, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="Really?! You're not just messing\nwith me, ARE you?", french="Vraiment?! Vous êtes pas en\ntrain de vous payer ma TETE, hein?", german="Wirklich?!? Ihr nehmt mich\nnicht auf den Arm, ODER?", italian="Cosa?! Non è che per caso\nmi state prendendo in giro, VERO?", spanish="¡A ver si os enteráis!\n¡Qué inútiles!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(9) [anim idle native]
  -- SetAnimation(9) [anim idle native]
  GAME:WaitFrames(20)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "happy", 1) end)
  -- message_FacePositionOffset(-3, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="All right. I've got a BIG heart.\nI'll explain as much as you want.", french="D'accord. Je vous\nexpliquerai autant de fois que vous voulez,\nmais c'est bien parce que j'ai BON cœur.", german="Na gut. Weil ich so GÜTIG bin,\nwerde ich es so oft erklären, wie ihr wollt.", italian="Va bene. Sono TROPPO buono.\nVe lo spiegherò quante volte volete.", spanish="Tenéis suerte de que sea buena\npersona. Os explicaré esto tanto como queráis."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweatdrop", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:FadeOut(false, 15)
  end
  end
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
