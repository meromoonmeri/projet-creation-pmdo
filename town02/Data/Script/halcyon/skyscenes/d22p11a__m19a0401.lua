-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D22P11A/m19a0401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  GAME:FadeOut(false, 30)
  -- back_SetGround(LEVEL_D22P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(30)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 280, 144, Direction.Up, "NPC_JUPUTORU")
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" You seem to be finally prepared.", french="Vous avez enfin fini de vous\npréparer, semble-t-il.", german="Eure Vorbereitung scheint\nabgeschlossen zu sein.", italian="Alla fine sembra tutto pronto\nper la partenza.", spanish=" Parece que ya estáis."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Let's go, then.[K] We'll find [CS:N]Celebi[CR]\nand return to the past.", french="Allez, on y va.[K] Trouvons [CS:N]Celebi[CR]\net retournons dans le passé.", german="Dann lasst uns gehen.[K] Wir\nwerden [CS:N]Celebi[CR] finden und in die Vergangenheit\nzurückkehren.", italian="Andiamo, allora.[K] Troviamo\n[CS:N]Celebi[CR] e torniamo nel passato.", spanish="Entonces vámonos.[K] Buscaremos a\n[CS:N]Celebi[CR] para poder regresar al pasado."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Let's go.", french=" En route.", german=" Gehen wir.", italian=" Andiamo.", spanish=" Adelante."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_juputoru, 276, 84, false, 2)
  GAME:WaitFrames(20)
  GROUND:EntTurn(partner, Direction.UpRight)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:FadeOutBGM(160) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Wait a sec! Hold on!", french=" Une seconde! Attends!", german=" Momentchen mal! Langsam!", italian=" Un momento! Aspetta!", spanish=" ¡Un momento! ¡Espera!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh, wait! Don't go!", french=" Une seconde! Attends!", german=" Oh, warte! Geh noch nicht!", italian=" Oh, aspetta! Fermo!", spanish=" ¡Un momento! ¡No sigas!"})
  else
  SkySceneKit.say({english=" Oh, wait! Hold on!", french=" Une seconde! Attends!", german=" Oh, warte mal einen Moment!", italian=" Oh, aspetta! Fermo!", spanish=" ¡Un momento! ¡Espera!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_juputoru, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" What is it?", french=" Qu'est-ce qu'il y a?", german=" Was ist los?", italian=" Cosa c'è?", spanish=" ¿Qué pasa?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="If the three of us could get back\nto our world...", french="Si on arrive à regagner notre\nmonde...", german="Wenn wir drei in unsere Welt\nzurückkehren könnten...", italian="Se noi tre possiamo tornare nel\nnostro mondo...", spanish=" Si regresamos al pasado..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="If the three of us do return to\nour world...", french="Si on arrive à regagner notre\nmonde...", german="Wenn wir drei in unsere Welt\nzurückkehren...", italian="Se noi tre torniamo nel nostro\nmondo...", spanish=" Si regresamos al pasado..."})
  else
  SkySceneKit.say({english="If the three of us manage to go\nback to our world...", french="Si on arrive à regagner notre\nmonde...", german="Wenn wir drei es schaffen, in\nunsere Welt zurückzukehren...", italian="Se noi tre riusciamo a tornare\nnel nostro mondo...", spanish=" Si regresamos al pasado..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[CS:N]Grovyle[CR], will you...[K]keep stealing\nTime Gears like you did before?", french="[CS:N]Massko[CR], est-ce que...[K]\ntu te remettras à voler les Rouages du Temps?", german="[CS:N]Reptain[CR], wirst du dann...[K]\nWirst du dann weiterhin Zahnräder der Zeit\nstehlen?", italian="[CS:N]Grovyle[CR], tu...[K] continuerai a\nrubare gli Ingranaggi del Tempo come\nfacevi prima?", spanish="¿Vas a...?[K] ¿Vas a seguir robando\nlos Engranajes del Tiempo igual que antes,\n[CS:N]Grovyle[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[CS:N]Grovyle[CR], will you...[K]steal the Time\nGears like you did before?", french="[CS:N]Massko[CR], est-ce que...[K]\ntu te remettras à voler les Rouages du Temps?", german="[CS:N]Reptain[CR], wirst du dann...[K]\nWirst du wie bisher Zahnräder der Zeit\nstehlen?", italian="[CS:N]Grovyle[CR], tu...[K] ruberai\ngli Ingranaggi del Tempo come facevi\nprima?", spanish="¿Vas a...?[K] ¿Vas a seguir robando\nlos Engranajes del Tiempo igual que antes,\n[CS:N]Grovyle[CR]?"})
  else
  SkySceneKit.say({english="[CS:N]Grovyle[CR], will you...[K]keep stealing\nthe Time Gears like you were doing before?", french="[CS:N]Massko[CR], est-ce que...[K]\ntu te remettras à voler les Rouages du Temps?", german="[CS:N]Reptain[CR], wirst du dann...[K]\nWirst du dann weiterhin Zahnräder der Zeit\nstehlen?", italian="[CS:N]Grovyle[CR], tu...[K] continuerai a\nrubare gli Ingranaggi del Tempo come\nfacevi prima?", spanish="¿Vas a...?[K] ¿Vas a seguir robando\nlos Engranajes del Tiempo igual que antes,\n[CS:N]Grovyle[CR]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Well...[K]yes, I will.", french=" Eh bien... [K]oui, je recommencerai.", german=" Nun...[K] Ja, das werde ich.", italian=" Beh...[K] Sì, lo farò.", spanish=" Pues...[K] Sí, por supuesto."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Otherwise, the planet's paralysis\ncan't be stopped.", french="Autrement, la planète sera\nparalysée.", german="Anders kann die Lähmung des\nPlaneten nicht aufgehalten werden.", italian="È l'unico modo per bloccare la\nparalisi del pianeta.", spanish="No hay otra forma de revertir\nla parálisis del planeta."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" But I...", french=" Mais je...", german=" Aber ich...", italian=" Ma io...", spanish=" Pero es que yo..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" But I...", french=" Mais je...", german=" Aber ich...", italian=" Ma io...", spanish=" Pero es que yo..."})
  else
  SkySceneKit.say({english=" But I...", french=" Mais je...", german=" Aber ich...", italian=" Ma io...", spanish=" Pero es que yo..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]Grovyle[CR], I'm not convinced yet.", french="[CS:N]Massko[CR], je ne suis pas encore\ntotalement convaincu.", german="[CS:N]Reptain[CR], ich bin noch nicht\nüberzeugt.", italian="[CS:N]Grovyle[CR], non sono ancora\nconvinto.", spanish="[CS:N]Grovyle[CR], aún no estoy convencido\ndel todo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]Grovyle[CR], I'm not convinced yet.", french="[CS:N]Massko[CR], je ne suis pas encore\ntotalement convaincu.", german="[CS:N]Reptain[CR], ich bin noch nicht\nüberzeugt.", italian="[CS:N]Grovyle[CR], non sono ancora\nconvinto.", spanish="[CS:N]Grovyle[CR], aún no estoy convencido\ndel todo."})
  else
  SkySceneKit.say({english=" [CS:N]Grovyle[CR], I'm not convinced yet.", french="[CS:N]Massko[CR], je ne suis pas encore\ntotalement convaincue.", german="[CS:N]Reptain[CR], ich bin noch nicht\nüberzeugt.", italian="[CS:N]Grovyle[CR], non sono ancora\nconvinta.", spanish="[CS:N]Grovyle[CR], aún no estoy convencida\ndel todo."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Don't assume that you have my\ncomplete trust.", french="Ne va pas t'imaginer que tu as\ntoute ma confiance.", german="Du solltest nicht annehmen, dass\nich dir voll vertraue.", italian="Non credere che io mi fidi\nciecamente di te.", spanish=" No confío plenamente en ti."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I don't completely trust you yet.", french="Ne va pas t'imaginer que tu as\ntoute ma confiance.", german="Ich vertraue dir noch nicht\nvöllig.", italian="Non mi fido ancora del tutto\ndi te.", spanish=" No confío plenamente en ti."})
  else
  SkySceneKit.say({english=" I don't completely trust you.", french="Ne va pas t'imaginer que tu as\ntoute ma confiance.", german="Ich vertraue dir noch nicht\nganz.", italian=" Non mi fido del tutto di te.", spanish=" No confío plenamente en ti."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I'm only traveling with you\nbecause I want to get back to our world.", french="Je voyage avec toi uniquement\ndans l'espoir de regagner notre monde.", german="Ich reise nur mit dir, weil ich\nwieder in unsere eigene Welt zurück will.", italian="Sono in viaggio con te solo\nperché voglio tornare nel nostro mondo.", spanish="Solo viajo contigo porque quiero\nvolver a mi mundo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I'm only cooperating with you\nbecause I want to return to our world.", french="Je voyage avec toi uniquement\ndans l'espoir de regagner notre monde.", german="Ich arbeite nur mit dir\nzusammen, weil ich wieder in unsere eigene\nWelt zurück will.", italian="Sto collaborando con te perché\nvoglio tornare nel nostro mondo.", spanish="Solo viajo contigo porque quiero\nvolver a mi mundo."})
  else
  SkySceneKit.say({english="I'm only traveling with you\nbecause I want to go back to our world.", french="Je voyage avec toi uniquement\ndans l'espoir de regagner notre monde.", german="Ich reise nur mit dir, weil ich\nwieder in unsere eigene Welt zurück will.", italian="Sono in viaggio con te solo\nperché voglio tornare nel nostro mondo.", spanish="Solo viajo contigo porque quiero\nvolver a mi mundo."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" If we do get back, [CS:N]Grovyle[CR]...", french="Si on réussit à rentrer,\n[CS:N]Massko[CR]...", german="Wenn wir es zurück schaffen,\n[CS:N]Reptain[CR]...", italian=" Se torniamo indietro, [CS:N]Grovyle[CR]...", spanish="Si conseguimos regresar,\n[CS:N]Grovyle[CR]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" If we do return, [CS:N]Grovyle[CR]...", french="Si on réussit à rentrer,\n[CS:N]Massko[CR]...", german="Wenn wir es schaffen\nzurückzukommen, [CS:N]Reptain[CR]...", italian=" Se torniamo, [CS:N]Grovyle[CR]...", spanish=" Si logramos regresar, [CS:N]Grovyle[CR]..."})
  else
  SkySceneKit.say({english=" If we do go back, [CS:N]Grovyle[CR]...", french="Si on réussit à rentrer,\n[CS:N]Massko[CR]...", german="Wenn wir wirklich\nzurückkommen, [CS:N]Reptain[CR]...", italian=" Se torniamo indietro, [CS:N]Grovyle[CR]...", spanish=" Si logramos regresar, [CS:N]Grovyle[CR]..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I'll find out if you really were\nstealing those Time Gears to prevent the\nplanet's paralysis.", french="Je saurai si c'était vraiment\npour empêcher la Paralysie de la Planète que\ntu volais les Rouages du Temps.", german="Dann werde ich herausfinden, ob\ndu die Zahnräder der Zeit wirklich gestohlen\nhast, um die Lähmung des Planeten zu stoppen.", italian="Scoprirò se stavi davvero\nrubando gli Ingranaggi del Tempo per\nprevenire la paralisi del pianeta.", spanish="Averiguaré si realmente estabas\nrobando los Engranajes del Tiempo para evitar\nla parálisis del planeta."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I'll investigate if you really\nwere stealing those Time Gears to prevent the\nplanet's paralysis.", french="Je saurai si c'était vraiment\npour empêcher la Paralysie de la Planète que\ntu volais les Rouages du Temps.", german="Dann werde ich herausfinden, ob\ndu die Zahnräder der Zeit wirklich gestohlen\nhast, um die Lähmung des Planeten zu stoppen.", italian="Indagherò per scoprire se\ndavvero stavi rubando gli Ingranaggi del Tempo\nper prevenire la paralisi del pianeta.", spanish="Averiguaré si realmente estabas\nrobando los Engranajes del Tiempo para evitar\nla parálisis del planeta."})
  else
  SkySceneKit.say({english="I'll find out if you really were\nstealing those Time Gears to prevent the\nplanet's paralysis.", french="Je saurai si c'était vraiment\npour empêcher la Paralysie de la Planète que\ntu volais les Rouages du Temps.", german="Dann werde ich herausfinden, ob\ndu die Zahnräder der Zeit wirklich gestohlen\nhast, um die Lähmung des Planeten zu stoppen.", italian="Scoprirò se stavi davvero\nrubando gli Ingranaggi del Tempo per\nprevenire la paralisi del pianeta.", spanish="Averiguaré si realmente estabas\nrobando los Engranajes del Tiempo para evitar\nla parálisis del planeta."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[CS:N]Grovyle[CR], if I end up thinking\nyou're wrong for stealing the Time Gears...", french="[CS:N]Massko[CR], si je m'aperçois\ndu contraire... Si tu as eu tort de voler\nles Rouages du Temps...", german="[CS:N]Reptain[CR], wenn ich zu dem\nSchluss kommen sollte, dass du die Zahnräder\nder Zeit zu Unrecht gestohlen hast...", italian="[CS:N]Grovyle[CR], se capirò che stavi\nsbagliando a rubare gli Ingranaggi del Tempo...", spanish="Si llego a la conclusión de que\nno deberías robar los Engranajes del Tiempo..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[CS:N]Grovyle[CR], if I decide that you're\nwrong for stealing the Time Gears...", french="[CS:N]Massko[CR], si je m'aperçois\ndu contraire... Si tu as eu tort de voler\nles Rouages du Temps...", german="[CS:N]Reptain[CR], wenn ich zu dem\nSchluss kommen sollte, dass du die Zahnräder\nder Zeit zu Unrecht gestohlen hast...", italian="[CS:N]Grovyle[CR], se capirò che stavi\nsbagliando a rubare gli Ingranaggi del Tempo...", spanish="Si llego a la conclusión de que\nno deberías robar los Engranajes del Tiempo..."})
  else
  SkySceneKit.say({english="[CS:N]Grovyle[CR], if I decide that you're\nwrong for stealing the Time Gears...", french="[CS:N]Massko[CR], si je m'aperçois\ndu contraire... Si tu as eu tort de voler\nles Rouages du Temps...", german="[CS:N]Reptain[CR], wenn ich zu dem\nSchluss kommen sollte, dass du die Zahnräder\nder Zeit zu Unrecht gestohlen hast...", italian="[CS:N]Grovyle[CR], se capirò che stavi\nsbagliando a rubare gli Ingranaggi del Tempo...", spanish="Si llego a la conclusión de que\nno deberías robar los Engranajes del Tiempo..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I'm going to stop you, [CS:N]Grovyle[CR]!", french=" Je ferai tout pour t'arrêter!", german="Dann werde ich dich aufhalten,\n[CS:N]Reptain[CR]!", italian=" Beh, ti fermerò, [CS:N]Grovyle[CR]!", spanish=" Tendré que detenerte, [CS:N]Grovyle[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I'm going to stop you, [CS:N]Grovyle[CR]!", french=" Je ferai tout pour t'arrêter!", german="Dann werde ich dich aufhalten,\n[CS:N]Reptain[CR]!", italian=" Beh, ti fermerò, [CS:N]Grovyle[CR]!", spanish=" Tendré que detenerte, [CS:N]Grovyle[CR]."})
  else
  SkySceneKit.say({english=" I'm going to stop you, [CS:N]Grovyle[CR]!", french=" Je ferai tout pour t'arrêter!", german="Dann werde ich dich aufhalten,\n[CS:N]Reptain[CR]!", italian=" Beh, ti fermerò, [CS:N]Grovyle[CR]!", spanish=" Tendré que detenerte, [CS:N]Grovyle[CR]."})
  end
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Humph! Do as you will. But keep\nthis in mind...", french="Pfff! Fais comme tu veux. Mais\nn'oublie pas...", german="Hmpf! Tu, was du nicht lassen\nkannst. Aber denk daran...", italian="Uff! Fai come vuoi.\nMa ricordati una cosa.", spanish="Hum... Haz lo que consideres\noportuno. Pero recuerda esto..."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="What's important now is getting\nourselves safely back to your world.", french="Ce qui compte maintenant, c'est\nde réussir à retourner indemnes dans\nvotre monde.", german="Das Wichtigste ist jetzt, dass\nwir wieder sicher in eure Welt gelangen.", italian="L'importante ora è riuscire a\nritornare nel presente sani e salvi.", spanish="Lo importante ahora es regresar\nsanos y salvos a tu mundo."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="So for the time being...[K]focus on\ngetting back home.", french="Alors pour l'instant...[K]\nconcentre-toi là-dessus.", german="Also fürs Erste[K] solltet ihr\neuch darauf konzentrieren, sicher nach Hause\nzu kommen.", italian="Quindi per ora...[K] concentrati\nsu come tornare a casa.", spanish="Así que de momento...[K]\nNo pienses en nada más."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Let's go.", french=" Allons-y.", german=" Gehen wir.", italian=" Andiamo.", spanish=" Vámonos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_juputoru, 276, 4, false, 2)
  GAME:WaitFrames(20)
  GROUND:MoveToPosition(partner, 252, 60, false, 1)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(hero, 300, 92, false, 1)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(............)", french="(............)", german="(............)", italian="(............)", spanish="(...)"})
  else
  SkySceneKit.say({english="(............)", french="(............)", german="(............)", italian="(............)", spanish="(...)"})
  end
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I feel it...)", french="(Je le sens...)", german="(Ich kann es spüren...)", italian="(Lo sento...)", spanish="(Puedo sentirlo...)"})
  else
  SkySceneKit.say({english="(I feel it...)", french="(Je le sens...)", german="(Ich kann es spüren...)", italian="(Lo sento...)", spanish="(Puedo sentirlo...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I am sensing something strange...)", french="(Je ressens quelque chose d'étrange...)", german="(Ich fühle etwas Seltsames...)", italian="(Sento qualcosa di strano...)", spanish="(Noto algo extraño...)"})
  else
  SkySceneKit.say({english="(I am sensing something strange...)", french="(Je ressens quelque chose d'étrange...)", german="(Ich fühle etwas Seltsames...)", italian="(Sento qualcosa di strano...)", spanish="(Noto algo extraño...)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-3, 0) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hm?[K] What's up, [hero]?", french="Hein?[K] Qu'est-ce qui se passe,\n[hero]?", german=" Hm?[K] Was ist los, [hero]?", italian=" Eh?[K] Cosa c'è, [hero]?", spanish=" ¿Eh?[K] ¿Qué pasa, [hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Hm?[K] What's the matter,\n[hero]?", french="Hein?[K] Qu'est-ce qui se passe,\n[hero]?", german="Hm?[K] Was gibt es,\n[hero]?", italian="Eh?[K] Qual è il problema,\n[hero]?", spanish=" ¿Eh?[K] ¿Qué pasa, [hero]?"})
  else
  SkySceneKit.say({english=" Hm?[K] What is it, [hero]?", french="Hein?[K] Qu'est-ce qui se passe,\n[hero]?", german="Hm?[K] Was gibt es,\n[hero]?", italian=" Eh?[K] Cosa c'è, [hero]?", spanish=" ¿Eh?[K] ¿Qué pasa, [hero]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I just know it!)", french="(Je connais cette sensation!)", german="(Ich weiß es einfach!)", italian="(La conosco!)", spanish="(¡Estoy seguro!)"})
  else
  SkySceneKit.say({english="(I just know it!)", french="(Je connais cette sensation!)", german="(Ich weiß es einfach!)", italian="(La conosco!)", spanish="(¡Estoy segura!)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I've felt something like this before...)", french="(Ce n'est pas la première fois que je la\nressens...)", german="(Ich habe schon einmal so etwas gespürt.)", italian="(Ho già provato una sensazione del genere...)", spanish="(He notado algo así antes...)"})
  else
  SkySceneKit.say({english="(I've felt something like this before...)", french="(Ce n'est pas la première fois que je la\nressens...)", german="(Ich habe schon einmal so etwas gespürt.)", italian="(Ho già provato una sensazione del genere...)", spanish="(He notado algo así antes...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(It was...)", french="(C'était...)", german="(Es war...)", italian="(Era...)", spanish="(Sucedió cuando...)"})
  else
  SkySceneKit.say({english="(It was...)", french="(C'était...)", german="(Es war...)", italian="(Era...)", spanish="(Sucedió cuando...)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitSe
  -- GAP: BGM BGM_I_SAW_SOMETHING_AGAIN non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(That's it![K] It was when...)", french="(J'y suis![K] C'était quand...)", german="(Das ist es![K] Es war, als...)", italian="(Ecco![K] Era quando...)", spanish="(¡Eso es![K] Sucedió cuando...)"})
  else
  SkySceneKit.say({english="(That's it![K] It was when...)", french="(J'y suis![K] C'était quand...)", german="(Das ist es![K] Es war, als...)", italian="(Ecco![K] È stato quando...)", spanish="(¡Eso es![K] Sucedió cuando...)"})
  end
  -- message_Close
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
end
