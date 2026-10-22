-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D54P11A/enter03.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  do local __sw = ((SV.SkyVars or {}).GROUND_ENTER or -1) -- switch($GROUND_ENTER) [GameVar GROUND_ENTER: point d'entrée du ground]
  if __sw == 138 then
  if (SkyProg.cmp_side(45, 7) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [45, 7]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_chaaremu = SkySceneKit.spawn_npc("medicham", 224, 248, Direction.Up, "NPC_CHAAREMU")
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" We'll get through next time!", french=" On les vaincra la prochaine fois!", german="Nächstes Mal werden wir\ndurchkommen!", italian=" La prossima volta ce la faremo!", spanish=" ¡La próxima vez lo lograremos!"})
  -- message_Close
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp_side(45, 4) >= 0) then -- elseif ROM: scn($SCENARIO_SIDE) >= [45, 4]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="[CS:Y]Lopunny[CR] and [CS:N]Gardevoir[CR]\nsay so, but...", french="C'est ce que [CS:N]Gardevoir[CR] et toi\ndites, mais...", german="Laut dir und [CS:N]Guardevoir[CR]\nist das so, aber...", italian="[CS:Y]Lopunny[CR], non so come tu\ne [CS:N]Gardevoir[CR] riusciate a mantenere\ntutta questa calma...", spanish="Es lo que decís [CS:N]Gardevoir[CR] y tú,\npero..."})
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" I...I am so nervous...", french=" ... je... je suis si nerveuse...", german=" Ich... Ich bin so aufgeregt...", italian=" I-Io sono così nervosa...", spanish=" Yo... estoy de los nervios..."})
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="Why is this?[K] Is it because I'm\nmad at Team [CS:X]AWD[CR]?", french="Pourquoi ça?[K] Est-ce parce que\nl'Equipe [CS:X]DDA[CR] me rend folle de rage?", german="Warum nur?[K] Vielleicht weil ich\nböse auf Team [CS:X]SPA[CR] bin?", italian="Che sia perché...[K] quelli del\nTeam [CS:X]AWD[CR] mi mandano su tutte le furie?", spanish="¿Por qué será?[K] ¿Será porque\nestoy enfadada con el [CS:X]Equipo WAD[CR]?"})
  -- message_Close
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(1)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" Hey! No way can I forgive them!", french="Hé! Impossible de\nleur pardonner!", german="Hey! Das kann ich ihnen auf\nkeinen Fall verzeihen!", italian=" No! Non li perdonerò mai!", spanish="¡Ni hablar del peluquín! ¡No me\nda la gana de perdonarlos!"})
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="I'll defeat them next time\nthey come into my sight!", french="Je les terrasserai la prochaine\nfois que je les vois!", german="Ich werde sie besiegen, wenn sie\ndas nächste Mal in meine Nähe kommen!", italian="La prossima volta che li vedrò,\nli sconfiggerò!", spanish="¡Pienso derrotarlos la próxima\nvez que se me pongan delante!"})
  -- message_Close
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif __sw == 139 then
  if (SkyProg.cmp_side(45, 7) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [45, 7]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" We'll get that [CS:N]Aggron[CR]!", french=" On va l'avoir, ce [CS:N]Galeking[CR]!", german="Wir werden [CS:N]Stolloss[CR]\nschon stellen!", italian=" Sconfiggeremo quell'[CS:N]Aggron[CR]!", spanish=" ¡Pillaremos a ese [CS:N]Aggron[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" We won't lose!", french=" On ne perdra pas!", german=" Wir werden nicht verlieren!", italian=" Ce la faremo!", spanish=" ¡No vamos a perder!"})
  -- message_Close
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" After this, it's the real deal!", french=" Après ça, les jeux seront faits!", german=" Hiernach kommt es drauf an!", italian=" Ora si fa sul serio!", spanish=" ¡La próxima será la buena!"})
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="I love this type of tension![K]\nIt's so exciting! ♪", french="J'adore les situations tendues\ncomme ça![K] Quel suspense! ♪", german="Ich liebe diese Spannung![K]\nDas ist so aufregend! ♪", italian="Adoro questa tensione![K]\nÈ così emozionante! ♪", spanish="Me encanta esta tensión.[K]\n¡Es de lo más emocionante! ♪"})
  -- message_Close
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif __sw == 141 then
  if (SkyProg.cmp_side(45, 13) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [45, 13]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="The next time we meet Team\n[CS:X]AWD[CR], we're going to knock them out!", french="La prochaine fois qu'on tombe\nsur l'Equipe [CS:X]DDA[CR], on leur fait\nmordre la poussière!", german="Wenn wir Team [CS:X]SPA[CR] das\nnächste Mal treffen, werden wir sie umhauen!", italian="La prossima volta che\nincontriamo il Team [CS:X]AWD[CR], lo sconfiggeremo!", spanish="La próxima vez que nos topemos\ncon el [CS:X]Equipo WAD[CR], ¡van a morder el polvo!"})
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" We'll definitely win next time!", french="On les vaincra pour de bon\nla prochaine fois!", german="Nächstes Mal gewinnen wir\nauf jeden Fall!", italian="La prossima volta vinceremo\ndi sicuro!", spanish=" La próxima vez vamos a ganar."})
  -- message_Close
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp_side(45, 10) >= 0) then -- elseif ROM: scn($SCENARIO_SIDE) >= [45, 10]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" We'll get through this time!", french=" On les vaincra cette fois!", german=" Dieses Mal kommen wir durch!", italian=" Questa volta ce la faremo!", spanish=" Esta vez lo lograremos."})
  -- message_Close
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp_side(45, 9) >= 0) then -- elseif ROM: scn($SCENARIO_SIDE) >= [45, 9]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="Come on, let's hurry![K]\nThrough the wall, between the two paths!", french="Allez, dépêchons-nous![K]\nA travers le mur, entre les deux chemins!", german="Kommt schon, beeilt euch![K]\nDurch die Wand, zwischen den beiden Pfaden!", italian="Forza, muoviamoci![K] Dobbiamo\npassare attraverso la parete tra le due\nentrate!", spanish="¡Venga, deprisa![K] ¡Atravesemos\nel muro que hay entre los dos caminos!"})
  -- message_Close
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif ((((SV.SkyVars or {}).SIDE06_ROOM or {})[2] or 0) ~= 0) then -- elseif ROM: $SIDE06_ROOM[2]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(1)
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" We're almost there![K] Aargh!", french=" On y est presque![K] Aargh!", german="Wir haben es fast geschafft![K]\nAargh!", italian=" Manca poco![K] Argh!", spanish=" ¡Ya casi estamos![K] ¡Aah!"})
  -- message_Close
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif ((((SV.SkyVars or {}).SIDE06_ROOM or {})[0] or 0) ~= 0) then -- elseif ROM: $SIDE06_ROOM[0]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" We'll get through this time!", french=" On les vaincra cette fois!", german=" Dieses Mal kommen wir durch!", italian=" Questa volta ce la faremo!", spanish=" Esta vez lo lograremos."})
  -- message_Close
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif ((((SV.SkyVars or {}).SIDE06_ROOM or {})[1] or 0) ~= 0) then -- elseif ROM: $SIDE06_ROOM[1]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" We'll get through this time!", french=" On les vaincra cette fois!", german=" Dieses Mal kommen wir durch!", italian=" Questa volta ce la faremo!", spanish=" Esta vez lo lograremos."})
  -- message_Close
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp_side(45, 8) >= 0) then -- elseif ROM: scn($SCENARIO_SIDE) >= [45, 8]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" We'll get through this time!", french=" On les vaincra cette fois!", german=" Dieses Mal kommen wir durch!", italian=" Questa volta ce la faremo!", spanish=" Esta vez lo lograremos."})
  -- message_Close
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="I think the one on the right\nis the correct path.", french="Je pense que le chemin\nde droite est le bon.", german="Ich denke, der rechte ist der\nkorrekte Pfad.", italian="Penso che il sentiero giusto\nsia quello a destra.", spanish="Creo que el camino correcto\nes el de la derecha."})
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="No![K] Maybe they just want you to\nthink that! Maybe it's really the one on\nthe left!", french="Non![K] C'est ce qu'ils veulent nous\nfaire croire! C'est peut-être celui de gauche!", german="Nein![K] Sie wollen uns das\nvielleicht nur glauben lassen! Vielleicht ist es\nin Wirklichkeit der linke Pfad.", italian="No![K] Forse è quello che vogliono\nfarci credere! Magari è proprio quello\na sinistra!", spanish="¡No![K] ¡Quizá quieran que pienses\neso y el bueno sea el de la izquierda!"})
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="Hmm...[K] Which one is it...\nreally...?[K] Hmm...", french="Hum...[K] Lequel est-ce...\nvraiment...?[K] Hum...", german="Hmm...[K] Also welcher ist es nun...\nwirklich?[K] Hmm...", italian="Mmmh...[K] Quale sarà quello\ngiusto...?[K] Mmmh...", spanish="Hum...[K] ¿Cuál será\nen realidad?...[K] Hum..."})
  -- message_Close
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif __sw == 143 then
  if (SkyProg.cmp_side(45, 13) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [45, 13]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="The next time we meet [CS:X]Team\nAWD[CR], we're going to knock them out!", french="La prochaine fois qu'on tombe\nsur l'Equipe [CS:X]DDA[CR], on leur fait\nmordre la poussière!", german="Wenn wir Team [CS:X]SPA[CR] das\nnächste Mal treffen, werden wir sie umhauen!", italian="La prossima volta che\nincontriamo il Team [CS:X]AWD[CR], lo sconfiggeremo!", spanish="La próxima vez que nos topemos\ncon el [CS:X]Equipo WAD[CR], ¡van a morder el polvo!"})
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" Next time, we'll definitely win!", french="La prochaine fois, on gagnera\nà coup sûr!", german="Nächstes Mal gewinnen wir\nauf jeden Fall!", italian="La prossima volta vinceremo\ndi sicuro!", spanish=" La próxima vez ganaremos."})
  -- message_Close
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp_side(45, 12) >= 0) then -- elseif ROM: scn($SCENARIO_SIDE) >= [45, 12]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="Speaking of...[K] What is Team\n[CS:X]AWD[CR] up to now?", french="A propos... [K]Qu'est-ce qu'elle\npeut bien préparer en ce moment,\nl'Equipe [CS:X]DDA[CR]?", german="Wo wir gerade dabei sind...[K]\nWas macht Team [CS:X]SPA[CR] jetzt wohl?", italian="Uhm... [K]Cosa starà facendo\nil Team [CS:X]AWD[CR] adesso?", spanish="Por cierto...[K] ¿Qué se trae\nentre manos el [CS:X]Equipo WAD[CR]?"})
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" I wonder where they are now...", french="Je me demande où ils\nsont maintenant...", german="Ich frage mich, wo sie jetzt\ngerade sind...", italian=" Mi chiedo dove si trovi...", spanish=" Me pregunto dónde estarán..."})
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="Never mind.[K] Instead of worrying\nabout them, I should be worrying about us!", french="Peu importe.[K] Plutôt que de me\nsoucier de leur sort, je ferais mieux\nde me soucier du nôtre!", german="Ach, egal.[K] Anstatt mir\nSorgen über sie zu machen, sollte ich lieber\nauf uns achtgeben!", italian="Poco importa.[K] Invece di\npreoccuparmi di loro, farei meglio\na pensare a noi!", spanish="Da igual.[K] ¡Debería preocuparme\npor nosotras, y no de ellos!"})
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="[CS:Y]Lopunny[CR]![K] Let's find some\ntreasure this time!", french="[CS:Y]Lockpin[CR]![K]\nTrouvons quelques trésors ce coup-ci!", german="[CS:Y]Schlapor[CR]![K] Lass uns dieses Mal\nein paar Schätze finden!", italian="[CS:Y]Lopunny[CR]![K] Cerchiamo di trovare\nil tesoro!", spanish="¡[CS:Y]Lopunny[CR]![K] ¡Esta vez\ntenemos que encontrar algún tesoro!"})
  -- message_Close
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="Speaking of... [K]What is Team\n[CS:X]AWD[CR] up to now?", french="A propos... [K]Qu'est-ce qu'elle\npeut bien préparer en ce moment,\nl'Equipe [CS:X]DDA[CR]?", german="Wo wir gerade dabei sind...[K]\nWas macht Team [CS:X]SPA[CR] jetzt wohl?", italian="Uhm... [K]Cosa starà facendo\nil Team [CS:X]AWD[CR] adesso?", spanish="Por cierto...[K] ¿Qué se traerá\nentre manos el [CS:X]Equipo WAD[CR]?"})
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" I wonder where they are now...", french="Je me demande où ils\nsont maintenant...", german="Ich frage mich, wo sie jetzt\ngerade sind...", italian=" Mi chiedo dove si trovi...", spanish=" Me pregunto dónde estarán..."})
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="Never mind.[K] Instead of worrying\nabout them, I should be worrying about us!", french="Peu importe.[K] Je ferais mieux\nde me soucier de nous!", german="Ach, egal.[K] Anstatt mir\nSorgen über sie zu machen, sollte ich lieber\nauf uns achtgeben!", italian="Poco importa.[K] Invece di\npreoccuparmi di loro, farei meglio\na pensare a noi!", spanish="Da igual.[K] ¡Debería preocuparme\npor nosotras, y no de ellos!"})
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="[CS:Y]Lopunny[CR]![K] Let's find some\ntreasure this time!", french="[CS:Y]Lockpin[CR]![K]\nTrouvons quelques trésors ce coup-ci!", german="[CS:Y]Schlapor[CR]![K] Lass uns dieses Mal\nein paar Schätze finden!", italian="[CS:Y]Lopunny[CR]![K] Cerchiamo di trovare\nil tesoro!", spanish="¡[CS:Y]Lopunny[CR]![K] ¡Esta vez\ntenemos que encontrar algún tesoro!"})
  -- message_Close
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif true then -- default
  -- @label_0 [étiquette de flux ExplorerScript]
  if (SkyProg.cmp_side(45, 2) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [45, 2]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="It seems like nobody's found the\ntreasure yet...", french="On dirait que personne n'a\nencore trouvé le trésor...", german="Es scheint, niemand hat bisher\nden Schatz gefunden...", italian="Pare che nessuno abbia ancora\ntrovato il tesoro...", spanish="Parece que nadie ha encontrado\nel tesoro aún..."})
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="When that's the situation, we\nget more excited. ♪", french="Dans une situation pareille,\nnous bouillons d'impatience. ♪", german="Wenn dem so ist, macht uns das\nnur noch aufgeregter. ♪", italian="Quando arriverà quel momento,\nsarà davvero emozionante. ♪", spanish="Cuando algo así ocurre nos\nponemos más nerviosas y todo. ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" Let's find more treasure. ♪", french=" Allons trouver ce trésor. ♪", german="Lasst uns noch mehr Schätze\nfinden. ♪", italian="Che bello andare alla ricerca\ndi tesori. ♪", spanish=" Vamos a buscar más tesoros. ♪"})
  -- message_Close
  -- @label_6 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="It seems like nobody's found the\ntreasure yet...", french="On dirait que personne n'a\nencore trouvé le trésor...", german="Es scheint, niemand hat bisher\nden Schatz gefunden...", italian="Pare che nessuno abbia ancora\ntrovato il tesoro...", spanish="Parece que nadie ha encontrado\nel tesoro todavía..."})
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="When that's the situation, we\nget more excited. ♪", french="Dans une situation pareille,\nnous bouillons d'impatience. ♪", german="Wenn dem so ist, steigert das\ndie Aufregung. ♪", italian="Quando arriverà quel momento,\nsarà davvero emozionante. ♪", spanish="Cuando algo así ocurre nos\nponemos más nerviosas y todo. ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" Let's find more treasure. ♪", french=" Allons trouver ce trésor. ♪", german="Lasst uns noch mehr Schätze\nfinden. ♪", italian="Che bello andare alla ricerca\ndi tesori. ♪", spanish="Buscar tesoros misteriosos\nes divertidísimo. ♪"})
  -- message_Close
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  SkySceneKit.cleanup_npcs()
end
