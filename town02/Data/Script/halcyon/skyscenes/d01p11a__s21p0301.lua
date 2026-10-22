-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D01P11A/s21p0301.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SkyProg.set(29, 80) -- $SCENARIO_MAIN = scn[29,80] (ROM)
  -- back_SetGround(LEVEL_D01P11A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Hey, [CS:N]Lapras[CR].[K] There's something\nwe want to ask you.", french="Salut, [CS:N]Lokhlass[CR].[K] On voudrait\nte poser une question.", german="Hey, [CS:N]Lapras[CR].[K] Wir müssen dich\netwas fragen.", italian="Ehi, [CS:N]Lapras[CR].[K] Vorremmo\nchiederti una cosa.", spanish="Hola, [CS:N]Lapras[CR].[K] Queríamos\nhacerte una pregunta."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Excuse me, [CS:N]Lapras[CR].[K] There's\nsomething we'd like to ask you.", french="Salut, [CS:N]Lokhlass[CR].[K] On voudrait\nte poser une question.", german="Entschuldigung, [CS:N]Lapras[CR].[K] Es gibt\netwas, das wir dich gerne fragen würden.", italian="Ciao, [CS:N]Lapras[CR].[K] Vorremmo\nchiederti una cosa.", spanish="Hola, [CS:N]Lapras[CR].[K] Queríamos\nhacerte una pregunta."})
  else
  SkySceneKit.say({english="Say, [CS:N]Lapras[CR].[K] There's something\nwe want to ask you.", french="Salut, [CS:N]Lokhlass[CR].[K] On voudrait\nte poser une question.", german="Hör mal, [CS:N]Lapras[CR].[K] Es gibt etwas,\ndas wir dich gerne fragen würden.", italian="Scusa, [CS:N]Lapras[CR].[K] Vorremmo\nchiederti una cosa.", spanish="Hola, [CS:N]Lapras[CR].[K] Queríamos\nhacerte una pregunta."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We're investigating the\ndistortions in the fabric of space.", french="Nous enquêtons sur la distorsion\nde la trame de l'espace.", german="Wir untersuchen die Verzerrung\nim Raumgefüge.", italian="Stiamo indagando sulla\ndistorsione della struttura dello spazio.", spanish="Estamos investigando la\ndeformación en la estructura del espacio."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We're investigating the\ndistortions in the fabric of space.", french="Nous enquêtons sur la distorsion\nde la trame de l'espace.", german="Wir untersuchen die Verzerrung\nim Raumgefüge.", italian="Stiamo indagando sulla\ndistorsione della struttura dello spazio.", spanish="Estamos investigando la\ndeformación en la estructura del espacio."})
  else
  SkySceneKit.say({english="We're investigating the\ndistortions in the fabric of space.", french="Nous enquêtons sur la distorsion\nde la trame de l'espace.", german="Wir untersuchen die Verzerrung\nim Raumgefüge.", italian="Stiamo indagando sulla\ndistorsione della struttura dello spazio.", spanish="Estamos investigando la\ndeformación en la estructura del espacio."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_rapurasu = SkySceneKit.spawn_npc("lapras", 504, 152, Direction.Down, "NPC_RAPURASU")
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english=" The distortion of space itself...", french=" La distorsion de l'espace...", german="Die Verzerrung des Raumes\nselbst...", italian=" La distorsione dello spazio...", spanish=" La deformación del espacio..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Yup. And we'd like to learn\nanything that you might know about it, [CS:N]Lapras[CR].", french="Oui. Et nous voudrions apprendre\ntout ce que tu sais sur ce sujet, [CS:N]Lokhlass[CR].", german="Ja. Und wir würden gerne\nalles wissen, was du darüber weißt, [CS:N]Lapras[CR].", italian="Già. E vorremmo sapere tutto\nquello che sai in proposito, [CS:N]Lapras[CR].", spanish="Sí. Nos gustaría que nos\ncontaras todo lo que sepas al respecto,\n[CS:N]Lapras[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Yes. And we'd like to learn\nanything that you might know about it, [CS:N]Lapras[CR].", french="Oui. Et nous voudrions apprendre\ntout ce que tu sais sur ce sujet, [CS:N]Lokhlass[CR].", german="Ja. Und wir würden gerne\nalles wissen, was du darüber weißt, [CS:N]Lapras[CR].", italian="Sì. E vorremmo sapere tutto\nquello che sai in proposito, [CS:N]Lapras[CR].", spanish="Sí. Nos gustaría que nos\ncontaras todo lo que sepas al respecto,\n[CS:N]Lapras[CR]."})
  else
  SkySceneKit.say({english="Yes. And we'd like to learn\nanything that you might know about it, [CS:N]Lapras[CR].", french="Oui. Et nous voudrions apprendre\ntout ce que tu sais sur ce sujet, [CS:N]Lokhlass[CR].", german="Ja. Und wir würden gerne\nalles wissen, was du darüber weißt, [CS:N]Lapras[CR].", italian="Sì. E vorremmo sapere tutto\nquello che sai in proposito, [CS:N]Lapras[CR].", spanish="Sí. Nos gustaría que nos\ncontaras todo lo que sepas al respecto,\n[CS:N]Lapras[CR]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english=" Hmm...", french=" Hum...", german=" Hmm...", italian=" Mmm...", spanish=" Hum..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="S-so, how about it?[K] Do you\nknow anything about it?", french="Alors, tu peux nous aider?[K]\nTu sais quelque chose là-dessus?", german="W-wie sieht es aus?[K] Weißt du\nirgendetwas darüber?", italian="Q-Quindi?[K] Ne sai\nqualcosa?", spanish="¿Puedes ayudarnos?[K]\n¿Sabes algo?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="C-can you help us?[K] Do you know\nanything?", french="Alors, tu peux nous aider?[K]\nTu sais quelque chose là-dessus?", german="K-kannst du uns helfen?[K] Weißt\ndu irgendwas?", italian="P-Puoi aiutarci?[K] Ne sai\nqualcosa?", spanish="¿Puedes ayudarnos?[K]\n¿Sabes algo?"})
  else
  SkySceneKit.say({english="C-can you help us?[K] Do you know\nanything?", french="Alors, tu peux nous aider?[K]\nTu sais quelque chose là-dessus?", german="K-kannst du uns helfen?[K] Weißt\ndu irgendwas?", italian="P-Puoi aiutarci?[K] Ne sai\nqualcosa?", spanish="¿Puedes ayudarnos?[K]\n¿Sabes algo?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english=" ...[K]I'm sorry to say...", french=" ...[K] Je suis désolé, mais...", german=" ...[K]Tut mir leid...", italian=" ...[K] Mi spiace dirvelo...", spanish=" Pues...[K] lamento deciros..."})
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english="I don't know anything about the\nspace distortions.", french="... je ne sais absolument rien\nsur la distorsion de l'espace.", german="Ich weiß nichts über die\nVerzerrung des Raumes.", italian="Ma non so niente riguardo alla\ndistorsione dello spazio.", spanish="Que no sé nada sobre las\ndeformaciones del espacio."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oh. I see...", french=" Oh. Je vois...", german=" Oh. Verstehe...", italian=" Oh. Capisco.", spanish=" Ah, vaya..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh. I see...", french=" Oh. Je vois...", german=" Oh. Verstehe...", italian=" Oh. Capisco.", spanish=" Ah, vaya..."})
  else
  SkySceneKit.say({english=" Oh. I see...", french=" Oh. Je vois...", german=" Oh. Verstehe...", italian=" Oh. Capisco.", spanish=" Ah, vaya..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english="However...[K] I do know of a being\nthat embodies space itself.", french="En revanche...[K] je sais qu'il existe\nun être qui incarne l'espace lui-même.", german="Allerdings...[K] Ich kenne ein\nWesen, das den Raum selbst verkörpert.", italian="Tuttavia...[K] So che esiste un\nessere che incarna lo spazio stesso.", spanish="No obstante...[K] Conozco a un\nser que representa el mismísimo espacio."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Huh?![K] A being that embodies\nspace itself?!", french="Hein?![K] Un être qui incarne\nl'espace lui-même?!", german="Äh?!?[K] Ein Wesen, das den Raum\nselbst verkörpert?!?", italian="Eh?![K] Un essere che incarna lo\nspazio?!", spanish="¿Qué?[K] ¿Un ser que representa\nel espacio?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="What?![K] A being that embodies\nspace itself?!", french="Hein?![K] Un être qui incarne\nl'espace lui-même?!", german="Was?!?[K] Ein Wesen, das den\nRaum selbst verkörpert?!?", italian="Eh?![K] Un essere che incarna lo\nspazio?!", spanish="¿Qué?[K] ¿Un ser que representa\nel espacio?"})
  else
  SkySceneKit.say({english="Pardon?![K] A being that embodies\nspace itself?!", french="Hein?![K] Un être qui incarne\nl'espace lui-même?!", german="Wie bitte?!?[K] Ein Wesen, das den\nRaum selbst verkörpert?!?", italian="Eh?![K] Un essere che incarna lo\nspazio?!", spanish="¿Qué?[K] ¿Un ser que representa\nel espacio?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- bgm_ChangeVolume(90,128) [volume BGM non scriptable en Lua PMDO: piste maintenue - documenté]
  -- bgm2_PlayFadeIn(BGM_TIME_GEAR_REMIX) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english="Yes.[K] Time and space are\ndeeply connected.", french="Oui.[K] Le temps et l'espace sont\nintimement liés.", german="Ja.[K] Zeit und Raum sind eng\nmiteinander verbunden.", italian="Sì.[K] Il tempo e lo spazio sono\nstrettamente collegati.", spanish="Sí.[K] Tiempo y espacio están\nmuy vinculados."})
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english="So, just as [CS:N]Dialga[CR] governs\ntime itself...", french="Donc, de la même manière que\n[CS:N]Dialga[CR] gouverne le temps...", german="Also so, wie [CS:N]Dialga[CR] über die Zeit\nselbst gebietet...", italian="Quindi, come [CS:N]Dialga[CR] governa\nil tempo...", spanish="Igual que [CS:N]Dialga[CR] gobierna\nel tiempo..."})
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english="So, too, there is a being that\ngoverns the fabric of space.", french="... il existe un être qui régit\nla trame de l'espace.", german="So gibt es ein Wesen, das über\ndas Raumgefüge wacht.", italian="... allo stesso modo esiste un\nessere che governa la struttura dello spazio.", spanish="También hay un ser que gobierna\nel espacio."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Th-that being...[K] Who is it?", french=" Cet être...[K] qui est-ce?", german=" D-dieses Wesen...[K] Wer ist es?", italian=" Q-Questo essere...[K] Chi è?", spanish=" Y...[K] ¿Quién es?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Th-that being...[K] Who is it?", french=" Cet être...[K] qui est-ce?", german=" D-dieses Wesen...[K] Wer ist es?", italian=" Q-Questo essere...[K] Chi è?", spanish=" Y...[K] ¿Quién es?"})
  else
  SkySceneKit.say({english=" Th-that being...[K] Who is it?", french=" Cet être...[K] qui est-ce?", german=" D-dieses Wesen...[K] Wer ist es?", italian=" Q-Questo essere...[K] Chi è?", spanish=" Y...[K] ¿Quién es?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english=" Its name is [CS:N]Palkia[CR].", french=" Son nom est [CS:N]Palkia[CR].", german=" Sein Name ist [CS:N]Palkia[CR].", italian=" Si chiama [CS:N]Palkia[CR].", spanish=" Se llama [CS:N]Palkia[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english="This being is said to possess the\nability to distort space itself.", french="On raconte qu'il possède\nla capacité de distordre l'espace.", german="Diesem Wesen sagt man die\nFähigkeit nach, den Raum selbst verzerren zu\nkönnen.", italian="Si dice che questo essere sia\ncapace di provocare distorsioni dello spazio.", spanish="Se dice que es capaz de\ndeformar el espacio."})
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english="And [CS:P]Spacial Rift[CR] is said to be\nits domain.", french="Et selon les rumeurs, la [CS:P]Faille\nSpatiale[CR] serait son domaine.", german="Und die [CS:P]Raumspalte[CR] soll sein\nReich sein.", italian="E si dice che il suo regno sia\nla [CS:P]Valle Dimensionale[CR].", spanish="Lo podréis encontrar en la\n[CS:P]Grieta Espacial[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(The being that governs space...[K] [CS:N]Palkia[CR]...)", french="(L'être qui régit l'espace...[K] [CS:N]Palkia[CR]...)", german="(Dieses Wesen, das über den Raum gebietet...[K]\n[CS:N]Palkia[CR]...)", italian="(L'essere che governa lo spazio...[K] [CS:N]Palkia[CR]...)", spanish="(El ser que gobierna el espacio...[K] [CS:N]Palkia[CR]...)"})
  else
  SkySceneKit.say({english="(The being that governs space...[K] [CS:N]Palkia[CR]...)", french="(L'être qui régit l'espace...[K] [CS:N]Palkia[CR]...)", german="(Dieses Wesen, das über den Raum gebietet...[K]\n[CS:N]Palkia[CR]...)", italian="(L'essere che governa lo spazio...[K] [CS:N]Palkia[CR]...)", spanish="(El ser que gobierna el espacio...[K] [CS:N]Palkia[CR]...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Another being...[K]like [CS:N]Dialga[CR]...)", french="(Un autre être...[K] tel que [CS:N]Dialga[CR]...)", german="(Noch ein Wesen...[K] wie [CS:N]Dialga[CR]...)", italian="(Un altro essere...[K] come [CS:N]Dialga[CR]...)", spanish="(Es...[K] como [CS:N]Dialga[CR]...)"})
  else
  SkySceneKit.say({english="(Another being...[K]like [CS:N]Dialga[CR]...)", french="(Un autre être...[K] tel que [CS:N]Dialga[CR]...)", german="(Noch ein Wesen...[K] wie [CS:N]Dialga[CR]...)", italian="(Un altro essere...[K] come [CS:N]Dialga[CR]...)", spanish="(Es...[K] como [CS:N]Dialga[CR]...)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="If we meet [CS:N]Palkia[CR]...[K]we might be\nable to learn more about the space distortions!", french="Si nous rencontrons [CS:N]Palkia[CR]...[K]\nnous pourrons en apprendre plus sur\nla distorsion de l'espace!", german="Wenn wir [CS:N]Palkia[CR] treffen...[K]\nkönnten wir vielleicht etwas über die\nRaumverzerrung erfahren!", italian="Se incontrassimo [CS:N]Palkia[CR]...[K]\npotremmo scoprire qualcosa in più sulla\ndistorsione dello spazio!", spanish="Si hablamos con [CS:N]Palkia[CR]...[K] tal\nvez podamos comprender la deformación\ndel espacio."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="If we meet [CS:N]Palkia[CR]...[K]we might be\nable to learn more about the space distortions!", french="Si nous rencontrons [CS:N]Palkia[CR]...[K]\nnous pourrons en apprendre plus sur\nla distorsion de l'espace!", german="Wenn wir [CS:N]Palkia[CR] treffen...[K]\nkönnten wir vielleicht etwas über die\nRaumverzerrung erfahren!", italian="Se incontrassimo [CS:N]Palkia[CR]...[K]\npotremmo scoprire qualcosa in più sulla\ndistorsione dello spazio!", spanish="Si hablamos con [CS:N]Palkia[CR]...[K] tal\nvez podamos comprender la deformación\ndel espacio."})
  else
  SkySceneKit.say({english="If we meet [CS:N]Palkia[CR]...[K]we might be\nable to learn more about the space distortions!", french="Si nous rencontrons [CS:N]Palkia[CR]...[K]\nnous pourrons en apprendre plus sur\nla distorsion de l'espace!", german="Wenn wir [CS:N]Palkia[CR] treffen...[K]\nkönnten wir vielleicht etwas über die\nRaumverzerrung erfahren!", italian="Se incontrassimo [CS:N]Palkia[CR]...[K]\npotremmo scoprire qualcosa in più sulla\ndistorsione dello spazio!", spanish="Si hablamos con [CS:N]Palkia[CR]...[K] tal\nvez podamos comprender la deformación\ndel espacio."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="So, uh...[K] How do we get to\n[CS:P]Spacial Rift[CR]?", french="Euh...[K] comment on fait pour aller\ndans la [CS:P]Faille Spatiale[CR]?", german="Also, äh...[K] Wie gelangen wir zur\n[CS:P]Raumspalte[CR]?", italian="Eh, allora...[K] come arriviamo\nalla [CS:P]Valle Dimensionale[CR]?", spanish="Esto...[K] ¿Y cómo se va a la\n[CS:P]Grieta Espacial[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="So, uh...[K] How do we get to\n[CS:P]Spacial Rift[CR]?", french="Euh...[K] comment on fait pour aller\ndans la [CS:P]Faille Spatiale[CR]?", german="Also, äh...[K] Wie gelangen wir zur\n[CS:P]Raumspalte[CR]?", italian="Eh, allora...[K] come arriviamo\nalla [CS:P]Valle Dimensionale[CR]?", spanish="Esto...[K] ¿Y cómo se va a la\n[CS:P]Grieta Espacial[CR]?"})
  else
  SkySceneKit.say({english="So, uh...[K] How do we get to\n[CS:P]Spacial Rift[CR]?", french="Euh...[K] comment on fait pour aller\ndans la [CS:P]Faille Spatiale[CR]?", german="Also, äh...[K] Wie gelangen wir zur\n[CS:P]Raumspalte[CR]?", italian="Eh, allora...[K] come arriviamo\nalla [CS:P]Valle Dimensionale[CR]?", spanish="Esto...[K] ¿Y cómo se va a la\n[CS:P]Grieta Espacial[CR]?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Can you travel there, [CS:N]Lapras[CR]?\nJust like you can go to the [CS:P]Hidden Land[CR]?", french="Tu peux t'y rendre, [CS:N]Lokhlass[CR]?\nComme tu peux aller aux [CS:P]Terres Illusoires[CR]?", german="Kannst du dorthin reisen,\n[CS:N]Lapras[CR]? Genauso wie zum [CS:P]Verborgenen Land[CR]?", italian="Sei capace di arrivarci, [CS:N]Lapras[CR]?\nSiccome sai andare alla [CS:P]Terra Nascosta[CR],\nforse...", spanish="¿Puedes ir hasta allí, [CS:N]Lapras[CR]?\n¿Tienes acceso a ella como a la [CS:P]Tierra Oculta[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Can you travel there, [CS:N]Lapras[CR]?\nJust like you can go to the [CS:P]Hidden Land[CR]?", french="Tu peux t'y rendre, [CS:N]Lokhlass[CR]?\nComme tu peux aller aux [CS:P]Terres Illusoires[CR]?", german="Kannst du dorthin reisen,\n[CS:N]Lapras[CR]? Genauso wie zum [CS:P]Verborgenen Land[CR]?", italian="Sei capace di arrivarci, [CS:N]Lapras[CR]?\nSiccome sai andare alla [CS:P]Terra Nascosta[CR],\nforse...", spanish="¿Puedes ir hasta allí, [CS:N]Lapras[CR]?\n¿Tienes acceso a ella como a la [CS:P]Tierra Oculta[CR]?"})
  else
  SkySceneKit.say({english="Can you travel there, [CS:N]Lapras[CR]?\nJust like you can go to the [CS:P]Hidden Land[CR]?", french="Tu peux t'y rendre, [CS:N]Lokhlass[CR]?\nComme tu peux aller aux [CS:P]Terres Illusoires[CR]?", german="Kannst du dorthin reisen,\n[CS:N]Lapras[CR]? Genauso wie zum [CS:P]Verborgenen Land[CR]?", italian="Sei capace di arrivarci, [CS:N]Lapras[CR]?\nSiccome sai andare alla [CS:P]Terra Nascosta[CR],\nforse...", spanish="¿Puedes ir hasta allí, [CS:N]Lapras[CR]?\n¿Tienes acceso a ella como a la [CS:P]Tierra Oculta[CR]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- bgm_ChangeVolume(90,256) [volume BGM non scriptable en Lua PMDO: piste maintenue - documenté]
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english="I hate to disappoint, but...[K]I can't\ntravel to [CS:P]Spacial Rift[CR]. I don't even know where\nit is.", french="Je suis navré de vous décevoir,\nmais...[K] je ne peux pas aller dans la [CS:P]Faille\nSpatiale[CR]. Je ne sais même pas où c'est.", german="Ich enttäusche euch ungern,\naber...[K] Ich kann nicht zur [CS:P]Raumspalte[CR] reisen.\nIch weiß nicht mal, wo sie liegt.", italian="Mi spiace deludervi, ma...[K] non\nso arrivare alla [CS:P]Valle Dimensionale[CR]. Non so\nnemmeno dove si trovi.", spanish="Siento decepcionaros, pero...[K] no\nsé ir a la [CS:P]Grieta Espacial[CR]. Ni siquiera sé\ndónde está exactamente."})
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english=" That is all I can tell you.", french="C'est tout ce que je peux vous\ndire.", german=" Mehr kann ich euch nicht sagen.", italian=" È tutto quello che posso dirvi.", spanish=" Eso es todo lo que puedo deciros."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oh... All right...", french=" Ah... D'accord...", german=" Oh... Na gut...", italian=" Oh... Va bene...", spanish=" Ah, vale..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh... All right...", french=" Ah... D'accord...", german=" Oh... Na gut...", italian=" Oh... Va bene...", spanish=" Ah, vale..."})
  else
  SkySceneKit.say({english=" Oh... All right...", french=" Ah... D'accord...", german=" Oh... Na gut...", italian=" Oh... Va bene...", spanish=" Ah, vale..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english=" I'm sorry, [partner].", french=" Désolé, [partner].", german=" Es tut mir leid, [partner].", italian=" Mi dispiace, [partner].", spanish=" Lo siento, [partner]."})
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english=" I'm sorry that I'm not much help.", french="Je suis confus de ne pas pouvoir\nvous aider davantage.", german="Tut mir leid, dass ich keine\ngroße Hilfe bin.", italian="Mi dispiace non potervi essere\nd'aiuto.", spanish=" Siento no ser de mucha ayuda."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_HEAD_SHAKE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" No, no...not at all...", french=" Non, non... ce n'est rien...", german=" Nein, nein. Das macht nichts...", italian=" No, no... affatto...", spanish=" No, no, en absoluto..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" No, no...not at all...", french=" Non, non... ce n'est rien...", german=" Nein, nein. Das macht nichts...", italian=" No, no... affatto...", spanish=" No, no, en absoluto..."})
  else
  SkySceneKit.say({english=" No, no...not at all...", french=" Non, non... ce n'est rien...", german=" Nein, nein. Das macht nichts...", italian=" No, no... affatto...", spanish=" No, no, en absoluto..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Learning about the existence of\n[CS:N]Palkia[CR] is a big help for us.", french="Tu nous as appris l'existence\nde [CS:N]Palkia[CR], c'est déjà beaucoup.", german="Es ist eine große Hilfe, dass wir\nvon [CS:N]Palkia[CR] wissen.", italian="Apprendere dell'esistenza di\n[CS:N]Palkia[CR] ci è stato di grande aiuto.", spanish="Saber de la existencia de [CS:N]Palkia[CR]\nya nos ayuda mucho."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Learning about the existence of\n[CS:N]Palkia[CR] is a big help for us.", french="Tu nous as appris l'existence\nde [CS:N]Palkia[CR], c'est déjà beaucoup.", german="Es ist eine große Hilfe, dass wir\nvon [CS:N]Palkia[CR] wissen.", italian="Apprendere dell'esistenza di\n[CS:N]Palkia[CR] ci è stato di grande aiuto.", spanish="Saber de la existencia de [CS:N]Palkia[CR]\nya nos ayuda mucho."})
  else
  SkySceneKit.say({english="Learning about the existence of\n[CS:N]Palkia[CR] is a big help for us.", french="Tu nous as appris l'existence\nde [CS:N]Palkia[CR], c'est déjà beaucoup.", german="Es ist eine große Hilfe, dass wir\nvon [CS:N]Palkia[CR] wissen.", italian="Apprendere dell'esistenza di\n[CS:N]Palkia[CR] ci è stato di grande aiuto.", spanish="Saber de la existencia de [CS:N]Palkia[CR]\nya nos ayuda mucho."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_rapurasu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_rapurasu, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Thank you, [CS:N]Lapras[CR].", french=" Merci, [CS:N]Lokhlass[CR].", german=" Danke, [CS:N]Lapras[CR].", italian=" Grazie, [CS:N]Lapras[CR].", spanish=" Gracias, [CS:N]Lapras[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Thank you, [CS:N]Lapras[CR].", french=" Merci, [CS:N]Lokhlass[CR].", german=" Danke, [CS:N]Lapras[CR].", italian=" Grazie, [CS:N]Lapras[CR].", spanish=" Gracias, [CS:N]Lapras[CR]."})
  else
  SkySceneKit.say({english=" Thank you, [CS:N]Lapras[CR].", french=" Merci, [CS:N]Lokhlass[CR].", german=" Danke, [CS:N]Lapras[CR].", italian=" Grazie, [CS:N]Lapras[CR].", spanish=" Gracias, [CS:N]Lapras[CR]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We'll investigate on our own\nfrom here.", french=" On va continuer nos recherches.", german="Wir forschen ab hier allein\nweiter.", italian="Da qui in poi continueremo\na indagare con i nostri mezzi.", spanish="Investigaremos por nuestra\ncuenta."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We'll investigate on our own\nfrom now.", french=" On va continuer nos recherches.", german="Wir forschen ab hier allein\nweiter.", italian="Da qui in poi continueremo\na indagare con i nostri mezzi.", spanish="Investigaremos por nuestra\ncuenta."})
  else
  SkySceneKit.say({english="We'll investigate on our own\nfrom now.", french=" On va continuer nos recherches.", german="Wir forschen ab hier allein\nweiter.", italian="Da qui in poi continueremo\na indagare con i nostri mezzi.", spanish="Investigaremos por nuestra\ncuenta."})
  end
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(2) -- join WaitBgm
  SkySceneKit.cleanup_npcs()
end
