-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/um1408.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94]
  -- @label_0 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_rediba = SkySceneKit.spawn_npc("ledyba", 416, 200, Direction.Left, "NPC_REDIBA")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_rediba, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_rediba) end)
  SkySceneKit.say({english=" It's superfun! ♪", french=" C'est super marrant! ♪", german=" Es ist ein Riesenspaß! ♪", italian=" È uno spasso! ♪", spanish=" ¡Es supergenial! ♪"})
  -- message_Close
  -- @label_131 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) or (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 93] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_rediba, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_rediba) end)
  SkySceneKit.say({english=" Good luck!", french=" Bonne chance!", german=" Viel Glück!", italian=" Buona fortuna!", spanish=" ¡Buena suerte!"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) or (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 85] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_rediba, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_rediba) end)
  SkySceneKit.say({english="A [CS:I]Wonder Gummi[CR] is a very rare\nGummi found somewhere in the world! ♪", french="La [CS:I]Gelée Miracle[CR] est une gelée\ntrès rare qu'on peut trouver quelque part dans\nle monde! ♪", german="Ein [CS:I]Wundergummi[CR] ist ein Gummi,\ndas man in der Welt nur sehr selten findet! ♪", italian="La [CS:I]Gommaincanto[CR] è una Gomma\nmolto rara! ♪", spanish="Una de las gomis más raras que\npuedes encontrarte es la [CS:I]Gomi Ingenio[CR]. ♪"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 56] || scn($SCENARIO_MAIN) >= [2
  -- SetAnimation(2) [anim idle native]
  local npc_npc_nyorotono = SkySceneKit.spawn_npc("politoed", 400, 184, Direction.Left, "NPC_NYOROTONO")
  -- SetAnimation(2) [anim idle native]
  local npc_npc_togepii = SkySceneKit.spawn_npc("togepi", 328, 256, Direction.DownLeft, "NPC_TOGEPII")
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_rediba, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_rediba) end)
  SkySceneKit.say({english=" Oh, wow! How nice! ♪", french=" Oh, waouh! Trop bien! ♪", german=" Oh, wow! Wie toll! ♪", italian=" Oh, wow! Che bello! ♪", spanish=" ¡Vaya! ¡Qué maravilla! ♪"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 54] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_rediba, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_rediba) end)
  SkySceneKit.say({english="It was so much fun talking with\n[CS:N]Shaymin[CR]! ♪ Ha ha ha!", french="C'était vraiment sympa de parler\navec [CS:N]Shaymin[CR]! ♪ Ha ha ha!", german="Mit den [CS:N]Shaymin[CR] zu reden, hat\nmir wirklich Spaß gemacht! ♪ Ha ha ha!", italian="È stato così divertente parlare\ncon [CS:N]Shaymin[CR]! ♪ Ah ah ah!", spanish="¡Ha sido divertidísimo hablar con\n[CS:N]Shaymin[CR]! ♪ ¡Ja, ja, ja!"})
  pcall(function() GROUND:CharSetEmote(npc_npc_rediba, "happy", 1) end)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_rediba, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) or (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 41] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_rediba, 4) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_rediba, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_rediba) end)
  SkySceneKit.say({english="This is only the base of the\nmountain. Ha ha ha!", french="On n'est qu'au pied de la\nmontagne. Ha ha ha!", german="Dies ist erst der Fuß des\nBerges. Ha ha ha!", italian="Questa è solo la base della\nmontagna... Ah ah ah!", spanish="Este es solo el pie\nde la montaña. ¡Ja, ja, ja!"})
  -- message_Close
  pcall(function() GROUND:CharSetEmote(npc_npc_rediba, nil, 0) end) -- EFFECT_NONE
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 30] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_rediba, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_rediba) end)
  SkySceneKit.say({english="Those [CS:N]Shaymin[CR] have a wide\nknowledge of many things! ♪", french="Ces [CS:N]Shaymin[CR] en connaissent\nun rayon sur tout un tas de sujets! ♪", german="Diese [CS:N]Shaymin[CR] besitzen ein\ngroßes Wissen über viele Dinge! ♪", italian="Questi Pokémon [CS:N]Shaymin[CR]\nconoscono davvero un sacco di cose! ♪", spanish="Esos [CS:N]Shaymin[CR] saben\nun montón sobre muchas cosas diferentes. ♪"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 26] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_rediba, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_rediba) end)
  SkySceneKit.say({english="I wonder who made the\nSecret Room.", french="Je me demande qui a construit\nla Salle Secrète.", german="Ich frage mich, wer diesen\nGeheimraum wohl gebaut hat?", italian=" Chi avrà creato la Sala Segreta?", spanish="Me pregunto quién construiría\nla Cámara Secreta."})
  pcall(function() UI:SetSpeaker(npc_npc_rediba) end)
  SkySceneKit.say({english=" It's so mysterious! ♪", french=" C'est si mystérieux, tout ça! ♪", german=" Wie mysteriös! ♪", italian=" Che mistero affascinante! ♪", spanish=" ¡Eso sí que es un misterio! ♪"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 20] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_rediba, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_rediba) end)
  SkySceneKit.say({english=" Wow! ♪ A flower garden! ♪", french=" Waouh! Des fleurs partout! ♪", german=" Wow! ♪ Ein Blumengarten! ♪", italian="Wow! ♪ Un giardino pieno\ndi fiori! ♪", spanish="¡Anda! ♪\n¡Un jardín de flores! ♪"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 10) >= 0) or (SkyProg.cmp(29, 9) >= 0) or (SkyProg.cmp(29, 8) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 10] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_rediba, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_rediba) end)
  SkySceneKit.say({english="That mountain almost reaches\npast the sky! I can't wait to climb it! ♪", french="Cette montagne est plus haute\nque le ciel! Je suis trop pressé d'y monter! ♪", german="Dieser Berg scheint den Himmel\nzu berühren! Ich kann es gar nicht erwarten,\nihn zu besteigen! ♪", italian="Quella montagna è immensa,\nnon se ne vede la cima! Non vedo l'ora\ndi scalarla! ♪", spanish="¡Esa montaña prácticamente toca\nlas nubes! ¡Qué ganas tengo de subir! ♪"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) or (SkyProg.cmp(29, 4) >= 0) or (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 6] || scn($SCENARIO_MAIN) >= [29
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_rediba, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_rediba) end)
  SkySceneKit.say({english=" Thank you for saving the world!", french=" Merci d'avoir sauvé le monde!", german="Danke, dass ihr die Welt\ngerettet habt!", italian="Grazie per aver salvato il\nmondo!", spanish=" ¡Gracias por salvar el mundo!"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) or (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) or (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) or (SkyProg.cmp(17, 3) >= 0) or (SkyProg.cmp(17, 1) >= 0) or (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [25, 4] || scn($SCENARIO_MAIN) >= [25
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_rediba, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_rediba) end)
  SkySceneKit.say({english="For sure! Happy-happy! ♪[K]\nTee-hee! ♪", french="C'est sûr! Quelle joie! ♪[K]\nYahouu! ♪", german="Auf jeden Fall!\nFröhlich-fröhlich! ♪[K] Tii-hii! ♪", italian="Sicuro! Felice-felice! ♪[K]\nTeeeeh! ♪", spanish="¡Desde luego! ¡Qué chachi! ♪[K]\n¡Ji, ji! ♪"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) or (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [15, 1] || scn($SCENARIO_MAIN) >= [14
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_rediba, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_rediba) end)
  SkySceneKit.say({english="I wonder what you get when you\nwin big?", french="Je me demande ce qu'on gagne\nquand on tire le gros lot.", german="Ich frage mich, was es wohl\ngibt, wenn man so richtig abräumt.", italian="Chissà cosa ti danno quando fai\nuna grossa vincita...", spanish="Me pregunto qué será el premio\ngordo... ¡qué curiosidad!"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) or (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) or (SkyProg.cmp(12, 1) >= 0) or (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) or (SkyProg.cmp(9, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [13, 2] || scn($SCENARIO_MAIN) >= [13
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_rediba, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_rediba) end)
  SkySceneKit.say({english="Going out with the whole gang\nis really what fun's all about! ♪", french="Partir avec tout le groupe, c'est\nça qui est amusant! ♪", german="Mit der ganzen Gruppe\nloszuziehen, ist wirklich der Inbegriff von\nSpaß! ♪", italian="Andare con tutti gli amici\nè veramente divertente! ♪", spanish="¡Ir con toda la pandilla es lo\ndivertido! ♪"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(8, 7) >= 0) or (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [8, 7] || scn($SCENARIO_MAIN) >= [8, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_rediba, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_rediba) end)
  SkySceneKit.say({english="Well, as long as they're paying...\nHa ha ha!", french="Bon, du moment qu'ils payent...\nHa ha ha!", german="Nun gut, solange sie bezahlen...\nHa ha ha!", italian="Beh, finché ci pagano...\nAh ah ah!", spanish="Bueno, mientras paguen...\n¡Ja, ja, ja!"})
  pcall(function() GROUND:CharSetEmote(npc_npc_rediba, "happy", 1) end)
  -- message_Close
  pcall(function() GROUND:CharSetEmote(npc_npc_rediba, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(8, 3) >= 0) or (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) or (SkyProg.cmp(7, 6) >= 0) or (SkyProg.cmp(7, 3) >= 0) or (SkyProg.cmp(7, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [8, 3] || scn($SCENARIO_MAIN) >= [8, 
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_rediba, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_rediba) end)
  SkySceneKit.say({english=" Tee-hee!", french=" Yahouuu!", german=" Tii-hii!", italian=" Teeeeh!", spanish=" ¡Ji, ji!"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(7, 1) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) or (SkyProg.cmp(5, 5) >= 0) or (SkyProg.cmp(4, 7) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 1] || scn($SCENARIO_MAIN) >= [6, 
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_rediba, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_rediba) end)
  SkySceneKit.say({english=" We're like a garden of flowers!", french="On est comme un jardin en\nfleurs!", german=" Wir sind wie ein Blumengarten!", italian=" Siamo come un giardino di fiori!", spanish="¡Somos como un jardín de\nflores!"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 5) >= 0) or (SkyProg.cmp(4, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 5] || scn($SCENARIO_MAIN) >= [4, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_rediba, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_rediba) end)
  SkySceneKit.say({english="So many Pokémon in need!\nJust look at those boards!", french="Tant de Pokémon sont en\ndanger! Jetez donc un coup d'œil à ces\ntableaux d'affichage!", german="So viele Pokémon in Not!\nSeht euch nur diese Infobretter an!", italian="Guardate su queste Bacheche\nquanti Pokémon hanno bisogno di soccorso!", spanish="¡Cuántos Pokémon en problemas!\n¡Mirad cómo están esos tablones!"})
  pcall(function() UI:SetSpeaker(npc_npc_rediba) end)
  SkySceneKit.say({english=" We have to help them!", french=" On doit absolument les aider!", german=" Wir müssen ihnen helfen!", italian=" Dobbiamo aiutarli!", spanish=" ¡Tenemos que ayudarles!"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 2) >= 0) or (SkyProg.cmp(4, 1) >= 0) or (SkyProg.cmp(4, 0) >= 0) or (SkyProg.cmp(3, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 2] || scn($SCENARIO_MAIN) >= [4, 
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
