-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/us0105.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94]
  -- @label_0 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_togepii = SkySceneKit.spawn_npc("togepi", 328, 256, Direction.DownLeft, "NPC_TOGEPII")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_togepii, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_togepii) end)
  SkySceneKit.say({english=" I'm having so much fun! ♪", french="Je m'amuse comme un petit\nfou, pas vrai, les copains? ♪", german=" Ich habe so viel Spaß! ♪", italian=" Mi sto divertendo un mondo! ♪", spanish="¡Me estoy divirtiendo un\nmontón! ♪"})
  -- message_Close
  -- @label_131 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) or (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 93] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_togepii, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_togepii) end)
  SkySceneKit.say({english="Be strong for us![K] And go bring\npeace to the world!", french="Faites preuve de courage![K]\nPartez ramener la paix dans le monde!", german="Seid stark für uns![K] Und bringt\nder Welt Frieden!", italian="Forza![K] Riportate la pace nel\nmondo!", spanish="¡Sed fuertes por nosotros![K]\n¡Y traed la paz a este mundo!"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) or (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 85] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_togepii, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_togepii) end)
  SkySceneKit.say({english="Do you know about the [CS:I]Wonder\nGummi[CR]?", french="Vous connaissez la [CS:I]Gelée\nMiracle[CR]?", german="Wisst ihr über das\n[CS:I]Wundergummi[CR] Bescheid?", italian="Sapete niente della\n[CS:I]Gommaincanto[CR]?", spanish="¿Habéis oído hablar de la [CS:I]Gomi[CR]\n[CS:I]Ingenio[CR]?"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 56] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_togepii, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_togepii) end)
  SkySceneKit.say({english="I went to meet Team [CS:X]Charm[CR] and\ngot their autographs! ♪", french="Je suis allé voir l'Equipe [CS:X]Charme[CR]\net j'ai eu leur autographe! ♪", german="Ich bin zu Team [CS:X]Charme[CR]\ngegangen und habe mir ihre Autogramme geben\nlassen! ♪", italian="Voglio incontrare il Team [CS:X]Malia[CR] e\nchiedere i loro autografi! ♪", spanish="Fui a conocer al [CS:X]Equipo Carisma[CR],\n¡y me dieron sus autógrafos! ♪"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 54] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_togepii, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_togepii) end)
  SkySceneKit.say({english="We ended up coming back home\nbefore climbing the whole [CS:P]Sky Peak[CR]!", french="Finalement on a rebroussé\nchemin avant d'avoir atteint le sommet du\n[CS:P]Pic Céleste[CR]!", german="So sind wir nach Hause\nzurückgekehrt, ohne den [CS:P]Himmelsgipfel[CR]\nbestiegen zu haben!", italian="E così alla fine siamo tornati\nindietro senza raggiungere la cima del\n[CS:P]Picco del Cielo[CR]!", spanish="¡Acabábamos volviendo a casa\nantes de escalar toda la [CS:P]Cumbre del Cielo[CR]!"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) or (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 41] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_togepii, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_togepii) end)
  SkySceneKit.say({english="I heard from [CS:N]Shaymin[CR] earlier,\nbut this isn't the mountain's summit...", french="J'avais déjà entendu parler des\n[CS:N]Shaymin[CR], alors on est venus.\nMais ce n'est pas le sommet, ici...", german="Ich habe vorhin von [CS:N]Shaymin[CR]\ngehört. Aber das hier ist noch nicht der\nBerggipfel...", italian="Prima ho sentito dire da [CS:N]Shaymin[CR]\nche questa non è la cima della montagna...", spanish="[CS:N]Shaymin[CR] me lo había dicho,\nresulta que esta no es la cima de la montaña..."})
  pcall(function() UI:SetSpeaker(npc_npc_togepii) end)
  SkySceneKit.say({english="We always thought that this was\nthe top of the mountain. Ha ha ha!", french="Au début, on pensait que c'était\nle sommet de la montagne. Ha ha ha!", german="Wir haben immer gedacht, dass\ndas hier schon der höchste Punkt sei. Ha ha ha!", italian="E dire che abbiamo sempre\ncreduto che lo fosse. Ah ah ah!", spanish="Siempre pensábamos que\nhabíamos alcanzado la cima, ¡ja, ja, ja!"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 30] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_togepii, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_togepii) end)
  SkySceneKit.say({english=" Mountains are so beautiful! ♪", french=" Les montagnes, c'est si joli! ♪", german=" Berge sind so schön! ♪", italian=" La montagna è meravigliosa! ♪", spanish=" ¡Las montañas son preciosas! ♪"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 26] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_togepii, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_togepii) end)
  SkySceneKit.say({english="I wonder where the Secret\nRoom that [CS:N]Shaymin[CR] was talking\nabout is.", french="Je me demande ce que ce\n[CS:N]Shaymin[CR] entendait par\n\"Salle Secrète\".", german="Ich frage mich, wo wohl der\nGeheimraum ist, von dem dieses [CS:N]Shaymin[CR]\ngesprochen hat?", italian="Mi domando dove sia questa\nSala Segreta di cui parlava [CS:N]Shaymin[CR]...", spanish="Me pregunto dónde estará la\nCámara Secreta de la que hablaba [CS:N]Shaymin[CR]."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 20] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_togepii, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_togepii) end)
  SkySceneKit.say({english="[CS:N]Shaymin[CR] all look so much alike.\nIt's almost impossible to tell them apart...", french="Les [CS:N]Shaymin[CR] se ressemblent\ntous. Il est quasiment impossible de les\ndistinguer les uns des autres.", german="Alle [CS:N]Shaymin[CR] sehen so gleich\naus, dass es fast unmöglich ist, sie\nauseinanderzuhalten...", italian="I Pokémon [CS:N]Shaymin[CR] sono tutti\nuguali. È praticamente impossibile distinguerli\ngli uni dagli altri...", spanish="Todos los [CS:N]Shaymin[CR] se parecen un\nmontón, es casi imposible distinguirlos..."})
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(npc_npc_togepii, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_togepii) end)
  SkySceneKit.say({english=" Ha ha ha!", french=" Ha ha ha!", german=" Hahaha!", italian=" Ah ah ah!", spanish=" ¡Ja, ja, ja!"})
  -- message_Close
  pcall(function() GROUND:CharSetEmote(npc_npc_togepii, nil, 0) end) -- EFFECT_NONE
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 10) >= 0) or (SkyProg.cmp(29, 9) >= 0) or (SkyProg.cmp(29, 8) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 10] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_togepii, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_togepii) end)
  SkySceneKit.say({english=" Let's go! Let's go! ♪", french=" C'est parti! C'est parti! ♪", german=" Los geht's! Los geht's! ♪", italian=" Forza! Forza! ♪", spanish=" ¡Venga! ¡Vamos! ♪"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) or (SkyProg.cmp(29, 4) >= 0) or (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 6] || scn($SCENARIO_MAIN) >= [29
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_togepii, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_togepii) end)
  SkySceneKit.say({english="You're the team that went to the\n[CS:P]Hidden Land[CR] and stopped the planet's paralysis?", french="C'est vous, l'équipe qui est allée\ndans les [CS:P]Terres Illusoires[CR] pour empêcher\nla Paralysie de la Planète?", german="Ihr seid das Team, das in das\n[CS:P]Verborgene Land[CR] gereist ist und die Lähmung\ndes Planeten aufgehalten hat?", italian="Voi siete la squadra che è stata\nalla [CS:P]Terra Nascosta[CR] e ha scongiurato\nla paralisi del pianeta?", spanish="¿Sois el equipo que fue a la\n[CS:P]Tierra Oculta[CR] y detuvo la parálisis del\nplaneta?"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) or (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) or (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) or (SkyProg.cmp(17, 3) >= 0) or (SkyProg.cmp(17, 1) >= 0) or (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [25, 4] || scn($SCENARIO_MAIN) >= [25
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_nyorotono = SkySceneKit.spawn_npc("politoed", 400, 184, Direction.Left, "NPC_NYOROTONO")
  -- SetAnimation(2) [anim idle native]
  local npc_npc_rediba = SkySceneKit.spawn_npc("ledyba", 416, 200, Direction.Left, "NPC_REDIBA")
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_togepii, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_togepii) end)
  SkySceneKit.say({english="[CS:K]Chansey[CR] Day Care will look after\nany Egg for you.", french="La [CS:K]Garderie Leveinard[CR] veillera\nsur vos Œufs pour vous.", german="Die [CS:K]Chaneira-Tagesstätte[CR] wird\nauf jedes eurer Eier achtgeben.", italian="La Pensione [CS:K]Chansey[CR] si prende\ncura delle Uova.", spanish="En la [CS:K]Guardería Chansey[CR] se\nencargarán de cuidar cualquier Huevo\nque tengáis."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) or (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [15, 1] || scn($SCENARIO_MAIN) >= [14
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_togepii, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_togepii) end)
  SkySceneKit.say({english="I hear that when you win big on\na [CS:I]Prize Ticket[CR], there's a celebratory dance!", french="Il paraît qu'en cas de gros lot à\nMéga Magot, il y a une danse pour\nféliciter le gagnant!", german="Es gibt wohl einen Freudentanz,\nwenn du mit einem [CS:I]Preisticket[CR] groß abräumst!", italian="Ho sentito che quando ottieni una\ngrossa vincita con un [CS:I]Buono Premio[CR], parte una\ndanza celebrativa!", spanish="He oído que, cuando alguien gana\nalgún premio gordo, se festeja bailando."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) or (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) or (SkyProg.cmp(12, 1) >= 0) or (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) or (SkyProg.cmp(9, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [13, 2] || scn($SCENARIO_MAIN) >= [13
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_togepii, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_togepii) end)
  SkySceneKit.say({english="Everyone in the guild is going\nout on an expedition?", french="Tous les membres de la Guilde\npartent en expédition?", german="Jeder aus der Gilde wird auf\neine Expedition gehen?", italian="Parteciperà tutta la Gilda alla\nspedizione?", spanish="¿Todo el [CS:N]Pokégremio[CR] va a salir\nde expedición?"})
  pcall(function() UI:SetSpeaker(npc_npc_togepii) end)
  SkySceneKit.say({english=" Ooh, that's so cool! ♪", french=" Oooh, c'est trop cool! ♪", german=" Ooh, das ist so cool! ♪", italian=" Ooh, che bello! ♪", spanish=" ¡Vaya, cómo mola! ♪"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(8, 7) >= 0) or (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [8, 7] || scn($SCENARIO_MAIN) >= [8, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_togepii, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_togepii) end)
  SkySceneKit.say({english="I don't really get it, but it\nsounds great, I guess! ♪", french="Je ne comprends pas tout\nmais ça a l'air extra, non? ♪", german="Ich verstehe es zwar nicht\nganz, aber es hört sich wohl klasse an! ♪", italian="Non sono sicuro di aver capito,\nma va bene così... credo! ♪", spanish="¡No lo entiendo muy bien, pero\nsupongo que suena estupendo! ♪"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(8, 3) >= 0) or (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) or (SkyProg.cmp(7, 6) >= 0) or (SkyProg.cmp(7, 3) >= 0) or (SkyProg.cmp(7, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [8, 3] || scn($SCENARIO_MAIN) >= [8, 
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_togepii, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_togepii) end)
  SkySceneKit.say({english="We're the exploration team that\ndelivers happiness! We're Team [CS:X]Glee[CR]!", french="On est l'Equipe [CS:X]Bonheur[CR]![K]\nL'équipe d'exploration qui répand la joie et\nla bonne humeur!", german="Wir sind das Erkundungsteam,\ndas Fröhlichkeit verbreitet! Wir sind Team\n[CS:X]Frohsinn[CR]!", italian="Siamo la squadra d'esplorazione\nche porta la felicità! Siamo il Team [CS:X]Allegria[CR]!", spanish="¡Somos el equipo explorador\nque reparte felicidad! ¡El [CS:X]Equipo Alegría[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_togepii) end)
  SkySceneKit.say({english="Hey, gang! What kind of items\nshould we buy today?", french="Hé, les copains! Quel genre\nd'objets on va acheter aujourd'hui?", german="Hey Leute! Was für Items\nsollen wir heute kaufen?", italian="Ehi, amici! Che tipo di strumenti\ndovremmo comprare oggi?", spanish="¡Eh, pandilla! ¿Qué objetos\ncompramos hoy?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_nyorotono) end)
  SkySceneKit.say({english=" I want a [CS:I]Blue Gummi[CR]!", french=" Je veux une [CS:I]Gelée Bleue[CR]!", german=" Ich will ein [CS:I]Blaugummi[CR]!", italian=" Io voglio una [CS:I]Gommablu[CR]!", spanish=" ¡Yo quiero una [CS:I]Gomi Azul[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_rediba) end)
  SkySceneKit.say({english=" I want a [CS:I]Green Gummi[CR]!", french=" Je veux une [CS:I]Gelée Verte[CR]!", german=" Ich will ein [CS:I]Grüngummi[CR]!", italian=" Io voglio una [CS:I]Gommaverde[CR]!", spanish=" ¡Yo quiero una [CS:I]Gomi Verde[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_rediba) end)
  SkySceneKit.say({english=" But wait...![K] Hold on a second!", french="Mais, attendez...![K]\nAttendez une seconde!", german="Stopp![K] Wartet mal eine\nSekunde!", italian="Ma aspetta...![K] Aspetta un\nsecondo!", spanish="Pero, ¡esperad![K] ¡Esperad un\nminuto!"})
  pcall(function() UI:SetSpeaker(npc_npc_rediba) end)
  SkySceneKit.say({english="Let's think about it for a second!\nWe don't have any money, do we?", french="Réfléchissons une minute,\nles copains! On n'a pas du tout d'argent,\npas vrai?", german="Denken wir doch mal eine\nSekunde drüber nach! Wir haben kein Geld,\noder?", italian="Pensiamoci un attimo! Non\nabbiamo soldi, vero?", spanish="Vamos a pensar seriamente un\nmomento. No tenemos dinero, ¿verdad?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_togepii) end)
  SkySceneKit.say({english=" Oh! You're so right!", french="Mais oui, c'est vrai, on n'y avait\npas pensé!", german=" Oh! Du hast ja so recht!", italian=" Oh! Hai proprio ragione!", spanish=" ¡Vaya, es verdad!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_nyorotono) end)
  SkySceneKit.say({english=" That's so silly of us!", french="Qu'est-ce qu'on est bêtes, hein,\nles copains?", german=" Das war ja so dumm von uns!", italian=" Che sciocco da parte nostra!", spanish=" ¡Vaya tontos que somos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_togepii, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_nyorotono, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_rediba, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_togepii) end)
  SkySceneKit.say({english=" Ha ha ha!", french=" Ha ha ha!", german=" Hahaha!", italian=" Ah ah ah!", spanish=" ¡Ja, ja, ja!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_nyorotono) end)
  SkySceneKit.say({english=" Ha ha ha!", french=" Hé hé hé!", german=" Hahaha!", italian=" Ah ah ah!", spanish=" ¡Ja, ja, ja!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_rediba) end)
  SkySceneKit.say({english=" Ha ha ha! Ha ha ha!", french=" Ha ha ha! Hé hé hé!", german=" Hahaha! Hahaha!", italian=" Ah ah ah! Ah ah ah!", spanish=" ¡Ja, ja, ja! ¡Ja, ja, ja!"})
  -- message_Close
  pcall(function() GROUND:CharSetEmote(npc_npc_togepii, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_nyorotono, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_rediba, nil, 0) end) -- EFFECT_NONE
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(7, 1) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) or (SkyProg.cmp(5, 5) >= 0) or (SkyProg.cmp(4, 7) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 1] || scn($SCENARIO_MAIN) >= [6, 
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_togepii, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_togepii) end)
  SkySceneKit.say({english="We're the exploration team that\ndelivers happiness! We're Team [CS:X]Glee[CR]!", french="On est l'Equipe [CS:X]Bonheur[CR]![K]\nL'équipe d'exploration qui répand la joie et\nla bonne humeur!", german="Wir sind das Erkundungsteam,\ndas Fröhlichkeit verbreitet! Wir sind Team\n[CS:X]Frohsinn[CR]!", italian="Siamo la squadra d'esplorazione\nche porta la felicità! Siamo il Team [CS:X]Allegria[CR]!", spanish="¡Somos el equipo explorador\nque reparte felicidad! ¡El [CS:X]Equipo Alegría[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_togepii) end)
  SkySceneKit.say({english="Hey, gang! Where should we go\nexploring today?", french="Hé, les copains! On va explorer\nquoi aujourd'hui?", german="Hey, Leute! Wo sollen wir heute\nauf Erkundung gehen?", italian="Ehi, amici! Oggi dove dobbiamo\nandare a esplorare?", spanish="¡Eh, pandilla! ¿Adónde podemos\nir a explorar hoy?"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 5) >= 0) or (SkyProg.cmp(4, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 5] || scn($SCENARIO_MAIN) >= [4, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_togepii, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_togepii) end)
  SkySceneKit.say({english="We're Team [CS:X]Glee[CR]![K] We're the\nexploration team that delivers happiness!", french="On est l'Equipe [CS:X]Bonheur[CR]![K]\nL'équipe d'exploration qui répand la joie et\nla bonne humeur!", german="Wir sind Team [CS:X]Frohsinn[CR]![K] Wir\nsind das Erkundungsteam, das Fröhlichkeit\nverbreitet!", italian="Siamo il Team [CS:X]Allegria[CR]![K] Siamo\nla squadra d'esplorazione che porta la felicità!", spanish="¡Somos el [CS:X]Equipo Alegría[CR]![K]\n¡El equipo explorador que reparte\nfelicidad!"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 2) >= 0) or (SkyProg.cmp(4, 1) >= 0) or (SkyProg.cmp(4, 0) >= 0) or (SkyProg.cmp(3, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 2] || scn($SCENARIO_MAIN) >= [4, 
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
