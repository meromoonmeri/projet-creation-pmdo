-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P02A/enter12.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_kakureon1 = SkySceneKit.spawn_npc("kecleon", 328, 168, Direction.Down, "NPC_KAKUREON1")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kakureon1, 4) end)
  if ((SV.SkyTalkBitFlags or {})[83] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[83]
  -- @label_131 [étiquette de flux ExplorerScript]
  -- switch(message_Menu(MENU_KECLEON_SHOP)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[83] = 1 -- $SCENARIO_TALK_BIT_FLAG[83] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english=" Ah, yes, I've heard!", french=" Ah oui! J'ai appris la nouvelle!", german=" Ah, ja. Ich habe es gehört!", italian=" Ah, sì, ho sentito!", spanish=" Ah, sí, ¡ya me he enterado!"})
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english=" You've defeated [CS:N]Darkrai[CR]?!", french=" Vous avez vaincu [CS:N]Darkrai[CR]?!", german=" Ihr habt [CS:N]Darkrai[CR] besiegt?!?", italian=" Avete sconfitto [CS:N]Darkrai[CR]?!", spanish=" ¡Han derrotado a [CS:N]Darkrai[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="That's the [hero] and\n[partner] I revere! So fantastic!", french="Voilà les incomparables\n[hero] et [partner]! Formidable!", german="Das sind [hero] und\n[partner]. Ich bewundere euch! Einfach\nfantastisch!", italian="[hero] e [partner],\nvi adoro! Siete grandi!", spanish="¡Mi admiración por ustedes,\n[hero] y [partner], no tiene límites!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 91] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kakureon1, 4) end)
  if ((SV.SkyTalkBitFlags or {})[82] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[82]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[82] = 1 -- $SCENARIO_TALK_BIT_FLAG[82] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="I will wish for your success,\n[hero] and [partner]!", french="Je souhaite de tout cœur que\nvous réussissiez, [hero] et\n[partner]!", german="Ich drücke euch die Daumen\nfür ein erfolgreiches Gelingen, [hero]\nund [partner]!", italian="Vi auguro ogni bene,\n[hero] e [partner]!", spanish="¡Les deseo éxito, [hero] y\n[partner]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 85] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kakureon1, 4) end)
  if ((SV.SkyTalkBitFlags or {})[81] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[81]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[81] = 1 -- $SCENARIO_TALK_BIT_FLAG[81] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="Little [CS:N]Azurill[CR] will not awaken\nfrom a nightmare...?", french="Le petit [CS:N]Azurill[CR] ne peut pas\nsortir de son cauchemar...?", german="Der kleine [CS:N]Azurill[CR] erwacht\neinfach nicht aus einem Albtraum?", italian="Il piccolo [CS:N]Azurill[CR] non si risveglia\ndall'incubo?", spanish="¿El pequeño [CS:N]Azurill[CR] no se\ndespierta de una pesadilla?"})
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="Hmm... That is quite\nworrisome...", french=" Hmm... Voilà qui est inquiétant...", german="Hmm, das ist ziemlich\nbesorgniserregend.", italian="Mmm... È abbastanza\npreoccupante...", spanish="Hum... Eso resulta muy\npreocupante..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 71] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kakureon1, 4) end)
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 67) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 67]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kakureon1, 4) end)
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 56] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kakureon1, 4) end)
  if ((SV.SkyTalkBitFlags or {})[80] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[80]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[80] = 1 -- $SCENARIO_TALK_BIT_FLAG[80] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="Could it be true?[K] Team [CS:X]Charm[CR]\nis truly visiting?!", french="C'est vrai?[K] L'Equipe [CS:X]Charme[CR]\nest ici, à Bourg-Trésor?!", german="Könnte das wahr sein?[K] Team\n[CS:X]Charme[CR] kommt wirklich zu Besuch?", italian="Davvero?[K] Il Team [CS:X]Malia[CR] è qui\nin visita?!", spanish="Vaya, ¿de verdad?[K] ¿El [CS:X]Equipo[CR]\n[CS:X]Carisma[CR] nos visita?"})
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="What am I doing? This is no\ntime for me to worry about this shop!", french="Qu'est-ce que je fais encore ici?\nCe n'est pas le moment de s'enquiquiner\navec cette boutique!", german="Was mache ich denn?!? Das ist\nnicht die richtige Zeit, um mir Sorgen um\ndiesen Laden zu machen!", italian="Cosa sto facendo? Non è il\nmomento di preoccuparsi del negozio!", spanish="¿Qué estoy haciendo? ¡No es\nmomento de preocuparme por la tienda!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) or (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) or (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) or (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) or (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) or (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) or (SkyProg.cmp(29, 8) >= 0) or (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 54] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kakureon1, 4) end)
  if ((SV.SkyTalkBitFlags or {})[79] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[79]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[79] = 1 -- $SCENARIO_TALK_BIT_FLAG[79] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english=" Ah, yes, I've heard!", french=" Ah oui! J'ai appris la nouvelle!", german=" Ah, ja. Ich habe es gehört!", italian=" Ah, sì, ho sentito!", spanish=" Ah, sí, ¡ya me he enterado!"})
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="You have completed the guild's\ngraduation exam?! How fantastic!", french="Vous avez obtenu le diplôme de\nla Guilde?! C'est fantastique!", german="Ihr habt die\nGildenabschlussprüfung bestanden!\nFantastisch!", italian="Avete passato l'esame della\nGilda?! Che notizia fantastica!", spanish="Han completado el gran reto del\n[CS:N]Pokégremio[CR], ¿verdad? ¡Qué maravilla!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(29, 4) >= 0) or (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 4] || scn($SCENARIO_MAIN) >= [29
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kakureon1, 4) end)
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [25, 4] || scn($SCENARIO_MAIN) >= [25
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kakureon1, 4) end)
  if ((SV.SkyTalkBitFlags or {})[78] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[78]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[78] = 1 -- $SCENARIO_TALK_BIT_FLAG[78] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="My thoughts go with you! I do\nhope the best for you!", french="Mes pensées vous accompagnent!\nJe vous souhaite bien de la chance!", german="In Gedanken bin ich bei euch!\nMeine besten Wünsche begleiten euch!", italian="Vi penserò! Vi auguro tutto\nil meglio!", spanish="¡Les deseo lo mejor! ¡Espero que\ntodo vaya muy bien!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [24, 1] || scn($SCENARIO_MAIN) >= [24
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kakureon1, 4) end)
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) or (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [23, 3] || scn($SCENARIO_MAIN) >= [23
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kakureon1, 4) end)
  if ((SV.SkyTalkBitFlags or {})[77] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[77]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[77] = 1 -- $SCENARIO_TALK_BIT_FLAG[77] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english=" Ah, welcome back! ♪", french=" Ah, content de vous revoir! ♪", german=" Ah, willkommen zurück! ♪", italian=" Ah, finalmente di ritorno! ♪", spanish=" Ah, ¡les doy la bienvenida! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="We were very worried about\nyou. No one seemed to know where you went!", french="On était si inquiets pour\nvous! On pensait que vous aviez disparu!", german="Wir haben uns große Sorgen um\neuch gemacht. Niemand schien zu wissen, wo\nihr hingegangen seid!", italian="Eravamo molto preoccupati per\nvoi. Nessuno sapeva dove eravate!", spanish="Estábamos muy preocupados por\nustedes. ¡Nadie sabía dónde podrían estar!"})
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="It is good to see you home safe!\nAnd good to have you shop with us again! ♪", french="Ça fait plaisir de vous voir de\nretour indemnes! Et de faire des affaires\navec vous! ♪", german="Schön, dass ihr wohlbehalten\nzurückgekehrt seid! Und gut, dass ihr wieder\nbei uns einkauft! ♪", italian="È bello vedervi tornare in\nsalute! Ed è bello vedervi di nuovo nel nostro\nnegozio! ♪", spanish="¡Es estupendo que hayan podido\nvolver al fin! ¡Y que se pasen por nuestra\ntienda! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [21, 2] || scn($SCENARIO_MAIN) >= [21
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kakureon1, 4) end)
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(17, 3) >= 0) or (SkyProg.cmp(17, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [17, 3] || scn($SCENARIO_MAIN) >= [17
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kakureon1, 4) end)
  if ((SV.SkyTalkBitFlags or {})[76] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[76]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[76] = 1 -- $SCENARIO_TALK_BIT_FLAG[76] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="Ah, yes, it was very surprising,\nto say the least! ♪", french="Ah oui! Le moins qu'on puisse\ndire, c'est que c'était très surprenant! ♪", german="Oh ja, es gab viele\nÜberraschungen, um es vorsichtig\nauszudrücken! ♪", italian="Ah, sì, è stata una cosa a\ndir poco sorprendente! ♪", spanish="Como mínimo, ¡se puede decir\nque ha sido sorprendente! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="The great [CS:N]Dusknoir[CR] is a Pokémon\nfrom the future! Imagine that!", french="Le grand [CS:N]Noctunoir[CR] vient du\nfutur! Vous vous rendez compte?", german="Der große [CS:N]Zwirrfinst[CR] ist ein\nPokémon aus der Zukunft! Stellt euch das mal\nvor!", italian="Il grande [CS:N]Dusknoir[CR] è un Pokémon\nche viene dal futuro! Ma ve lo immaginate?", spanish="¿El gran [CS:N]Dusknoir[CR] es un Pokémon\ndel futuro? ¡Lo que hay que oír!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) or (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) or (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) or (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [16, 2] || scn($SCENARIO_MAIN) >= [16
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kakureon1, 4) end)
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) or (SkyProg.cmp(12, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [12, 4] || scn($SCENARIO_MAIN) >= [12
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kakureon1, 4) end)
  if ((SV.SkyTalkBitFlags or {})[75] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[75]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[75] = 1 -- $SCENARIO_TALK_BIT_FLAG[75] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english=" Ah, welcome back! ♪", french=" Ah, content de vous revoir! ♪", german=" Ah, willkommen zurück! ♪", italian=" Ah, finalmente di ritorno! ♪", spanish=" Ah, ¡les doy la bienvenida! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="It sounds very much like it was\na fine expedition for your guild! ♪", french="On dirait que l'expédition s'est\nbien passée pour la Guilde! ♪", german="Es klingt danach, als wäre es\neine tolle Expedition für eure Gilde\ngewesen! ♪", italian="Sembra sia stata una spedizione\npositiva per la vostra Gilda! ♪", spanish="¡Parece que ha sido una\nexpedición estupenda! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) or (SkyProg.cmp(9, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [10, 2] || scn($SCENARIO_MAIN) >= [10
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kakureon1, 4) end)
  if ((SV.SkyTalkBitFlags or {})[74] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[74]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[74] = 1 -- $SCENARIO_TALK_BIT_FLAG[74] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english=" Ah, yes, I've heard!", french=" Ah oui! J'ai appris la nouvelle!", german=" Ah, ja. Ich habe es gehört!", italian=" Ah, sì, ho sentito!", spanish=" Ah, sí, ¡ya me he enterado!"})
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="You were chosen for the\nexpedition?!", french="Vous allez participer à\nl'expédition?!", german="Ihr seid für die Expedition\nausgewählt worden!", italian="Vi hanno scelto per la\nspedizione?!", spanish="¿Han tenido suerte? ¿Van a\nparticipar en la expedición?"})
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="Congratulations! I so hope you\ndo very well! ♪", french="Félicitations! J'espère que vous\nvous en sortirez bien! ♪", german="Glückwunsch! Ich hoffe so sehr,\ndass euch alles gut gelingen wird! ♪", italian="Congratulazioni! Spero che andrà\ntutto bene! ♪", spanish="¡Mi enhorabuena! ¡Espero que\nles vaya muy bien! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(8, 7) >= 0) or (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) or (SkyProg.cmp(8, 3) >= 0) or (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) or (SkyProg.cmp(7, 6) >= 0) or (SkyProg.cmp(7, 3) >= 0) or (SkyProg.cmp(7, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [8, 7] || scn($SCENARIO_MAIN) >= [8, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kakureon1, 4) end)
  if ((SV.SkyTalkBitFlags or {})[73] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[73]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[73] = 1 -- $SCENARIO_TALK_BIT_FLAG[73] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english=" Ah, yes, I've heard!", french=" Ah oui! J'ai appris la nouvelle!", german=" Ah, ja. Ich habe es gehört!", italian=" Ah, sì, ho sentito!", spanish=" Ah, sí, ¡ya me he enterado!"})
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="The guild is preparing for an\nexpedition soon?!", french="La Guilde se prépare à partir\nen expédition très prochainement?!", german="Die Gilde bereitet sich\ndemnächst auf eine Expedition vor!", italian="La Gilda si sta preparando\nper una spedizione?", spanish="El [CS:N]Pokégremio[CR] se está preparando\npara una expedición inminente, ¿no?"})
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="Please do try to be chosen\nas members! ♪", french="Essayez à tout prix d'en\nfaire partie! ♪", german="Bitte versucht, als Mitglieder\nausgewählt zu werden! ♪", italian="Dovete fare in modo di andare\nanche voi! ♪", spanish="¡Hagan lo que puedan para poder\ntomar parte en ella! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(7, 1) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) or (SkyProg.cmp(5, 5) >= 0) or (SkyProg.cmp(4, 7) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 1] || scn($SCENARIO_MAIN) >= [6, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kakureon1, 4) end)
  if ((SV.SkyTalkBitFlags or {})[72] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[72]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[72] = 1 -- $SCENARIO_TALK_BIT_FLAG[72] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english=" Ah, yes, I've heard!", french=" Ah oui! J'ai appris la nouvelle!", german=" Ah, ja. Ich habe es gehört!", italian=" Ciao! L'ho saputo!", spanish=" Ah, sí, ¡ya me he enterado!"})
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="You saved that cute [CS:N]Azurill[CR] from\na horrible outlaw?!", french="Vous avez sauvé [CS:N]Azurill[CR] des\ngriffes de cet horrible hors-la-loi?!", german="Ihr habt den süßen [CS:N]Azurill[CR] vor\neinem schrecklichen Ganoven gerettet!", italian="Avete salvato il piccolo [CS:N]Azurill[CR]\nda un orribile criminale?!", spanish="Han salvado al simpático\n[CS:N]Azurill[CR] de un terrible malhechor, ¿eh?"})
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="For that, please accept our\nsincere thanks!", french="Acceptez nos remerciements\nles plus sincères!", german="Dafür gebührt euch unser\naufrichtiger Dank!", italian="Accettate i nostri più sentiti\nringraziamenti!", spanish="Acepten, por ello, nuestro más\nsincero agradecimiento."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(4, 5) >= 0) or (SkyProg.cmp(4, 3) >= 0) or (SkyProg.cmp(4, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 5] || scn($SCENARIO_MAIN) >= [4, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kakureon1, 4) end)
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 1]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kakureon1, 4) end)
  -- switch(message_Menu(MENU_KECLEON_SHOP)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- supervision_ExecuteCommon(CORO_EVENT_M03_03) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 0) >= 0) or (SkyProg.cmp(3, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 0] || scn($SCENARIO_MAIN) >= [3, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kakureon1, 4) end)
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
