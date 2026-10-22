-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D31P11A/s01p0701.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  GAME:FadeIn(0)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ugh...[K] What a wipeout.", french="Argh...[K] Quelle raclée on s'est\nprise.", german=" Uff...[K] Was für eine Klatsche.", italian=" Ugh...[K] Che batosta.", spanish=" Uf...[K] ¡Qué desastre!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ugh...[K] That ended terribly.", french="Argh...[K] Quelle raclée on s'est\nprise.", german=" Uff...[K] Das ging böse aus.", italian="Ugh...[K] Non è finita affatto\nbene.", spanish=" Uf...[K] Qué mal hemos acabado..."})
  else
  SkySceneKit.say({english=" Urk![K] We paid for our mistakes!", french="Argh...[K] Quelle raclée on s'est\nprise.", german="Umpf![K] Unsere Fehler haben sich\ngerächt!", italian="Ah![K] Abbiamo pagato per i\nnostri errori!", spanish="¡Vaya![K] ¡Nuestros errores nos\nhan salido caros!"})
  end
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D31P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1)
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Mystifying Forest.ogg", true) end)
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitLockLives
  SkySceneKit.unlock(5) -- Unlock(5) NDS
  GAME:WaitFrames(15)
  SkySceneKit.unlock(7) -- Unlock(7) NDS
  SkySceneKit.lock(3) -- Lock(3) NDS
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Urk![K] I guess we got too cocky.", french="Ouille...[K] On a pris\ntrop de risques.", german="Umpf![K] Wir waren wohl zu\nvorwitzig.", italian="Urk![K] Non abbiamo fatto\nabbastanza attenzione.", spanish="Uf...[K] Nos pusimos demasiado\ngallitos."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Urk![K] We need to be\nmore cautious.", french="Ouille...[K] On a pris\ntrop de risques.", german="Umpf![K] Wir müssen vorsichtiger\nsein.", italian="Urk![K] Non abbiamo fatto\nabbastanza attenzione.", spanish="¡Uf![K] Habrá que ir con más\ncuidado."})
  else
  SkySceneKit.say({english="Urk![K] We were too careless,\nI think.", french="Ouille...[K] On a pris\ntrop de risques.", german="Umpf![K] Wir waren zu\nunvorsichtig, denke ich.", italian="Urk![K] Non abbiamo fatto\nabbastanza attenzione.", spanish="¡Uf![K] Creo que nos hemos\ndejado llevar demasiado."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" But that grand master...", french=" Mais ce grand maître...", german=" Aber dieser Großmeister...", italian=" Ma Sua Malvagità...", spanish=" Pero el gran malo..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" But that grand master...", french=" Mais ce grand maître...", german=" Aber dieser Großmeister...", italian=" Ma Sua Malvagità...", spanish=" Pero el gran malo..."})
  else
  SkySceneKit.say({english=" But that grand master...", french=" Mais ce grand maître...", german=" Aber dieser Großmeister...", italian=" Ma Sua Malvagità...", spanish=" Pero el gran malo..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Are you telling me that wasn't\n[CS:N]Wigglytuff[CR]...?", french="C'était [CS:N]Grodoudou[CR], ça ne\nfait aucun doute.", german="Sagst du etwa, das war gar\nnicht [CS:N]Knuddeluff[CR]?", italian="Vuoi dire che quello non era\n[CS:N]Wigglytuff[CR]...?", spanish="Era [CS:N]Wigglytuff[CR]...\nComo que me llamo [partner]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" That was obviously [CS:N]Wigglytuff[CR]...", french="C'était [CS:N]Grodoudou[CR], ça ne\nfait aucun doute.", german="Das war ganz offensichtlich\n[CS:N]Knuddeluff[CR]...", italian="Quello ovviamente era\n[CS:N]Wigglytuff[CR]...", spanish=" ¿Acaso no era [CS:N]Wigglytuff[CR]...?"})
  else
  SkySceneKit.say({english="That was [CS:N]Wigglytuff[CR], without\na doubt.", french="C'était [CS:N]Grodoudou[CR], ça ne\nfait aucun doute.", german="Das war [CS:N]Knuddeluff[CR], ohne\nZweifel.", italian="Quello era [CS:N]Wigglytuff[CR], non c'è\nalcun dubbio.", spanish="Era [CS:N]Wigglytuff[CR], sin duda\nalguna..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Besides, the minions were all\nthe guild's members...[K] What are they trying\nto prove?", french="En plus, ses sbires, c'étaient\nles apprentis de la Guilde...[K] A quoi ils\njouent?", german="Außerdem waren die\nUntergebenen alles Gildenmitglieder...[K] Was\nversuchen sie zu beweisen?", italian="Inoltre, gli sgherri erano tutti\nmembri della Gilda...[K] Cosa stanno cercando\ndi dimostrare?", spanish="Además, los secuaces eran todos\nlos miembros del [CS:N]Pokégremio[CR]...[K] ¿A quién\nquieren engañar?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Besides, the minions were all\nthe guild's members...[K] Who are they trying\nto fool?", french="En plus, ses sbires, c'étaient\nles apprentis de la Guilde...[K] A quoi ils\njouent?", german="Außerdem waren die\nUntergebenen alles Gildenmitglieder...[K] Was\nversuchen sie zu beweisen?", italian="Inoltre, gli sgherri erano tutti\nmembri della Gilda...[K] Cosa stanno cercando\ndi dimostrare?", spanish="Además, los secuaces eran todos\nlos miembros del [CS:N]Pokégremio[CR]...[K] ¿A quién\nquieren engañar?"})
  else
  SkySceneKit.say({english="Besides, the minions were all\nguild members...[K] What are they trying\nto prove?", french="En plus, ses sbires, c'étaient\nles apprentis de la Guilde...[K] A quoi ils\njouent?", german="Außerdem waren die\nUntergebenen alles Gildenmitglieder...[K] Was\nversuchen sie zu beweisen?", italian="Inoltre, gli sgherri erano tutti\nmembri della Gilda...[K] Cosa stanno cercando\ndi dimostrare?", spanish="Además, los secuaces eran todos\nlos miembros del [CS:N]Pokégremio[CR]...[K] ¿A quién\nquieren engañar?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Well, anyway...[K] Let's go graduate\nfrom the guild!", french="Eh bien! De toute façon...[K]\nil faut qu'on réussisse cet examen!", german="Nun, sei es drum...[K] Holen wir\nuns unseren Gildenabschluss!", italian="Beh, comunque...[K] Andiamo e\ncerchiamo di superare l'esame!", spanish="Bueno, da igual...[K] ¡Tenemos que\nsuperar el reto!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Well, anyway...[K] We should still\ntry to graduate from the guild!", french="Eh bien! De toute façon...[K]\nil faut qu'on réussisse cet examen!", german="Nun, wie auch immer...[K] Wir\nsollten versuchen, unsere Prüfung zu\nschaffen!", italian="Beh, comunque...[K] Andiamo e\ncerchiamo di superare l'esame!", spanish="Bueno, da igual...[K] ¡Hay que\nsuperar el gran reto!"})
  else
  SkySceneKit.say({english="Well, anyway...[K] Let's go graduate\nfrom the guild!", french="Eh bien! De toute façon...[K]\nil faut qu'on réussisse cet examen!", german="Nun, sei es drum...[K] Holen wir\nuns unseren Gildenabschluss!", italian="Beh, comunque...[K] Andiamo e\ncerchiamo di superare l'esame!", spanish="Bueno, da igual...[K] ¡Tenemos que\nsuperar el reto!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's keep moving forward,\n[hero]!", french="Il faut avancer,\n[hero]!", german="Los, vorwärts,\n[hero]!", italian="Continuiamo ad andare avanti,\n[hero]!", spanish="¡Sigamos avanzando,\n[hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's keep at this, [hero]!", french="Il faut avancer,\n[hero]!", german="Lass uns dranbleiben,\n[hero]!", italian="Continuiamo ad andare avanti,\n[hero]!", spanish="¡Sigamos avanzando,\n[hero]!"})
  else
  SkySceneKit.say({english="We have to keep at this,\n[hero]!", french="Il faut avancer,\n[hero]!", german="Wir müssen dranbleiben,\n[hero]!", italian="Continuiamo ad andare avanti,\n[hero]!", spanish="¡Tenemos que esforzarnos,\n[hero]!"})
  end
  -- message_Close
end
