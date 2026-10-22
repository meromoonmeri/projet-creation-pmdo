-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P02A/us2005.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_madatsubomi = SkySceneKit.spawn_npc("bellsprout", 320, 296, Direction.Up, "NPC_MADATSUBOMI")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_madatsubomi, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_madatsubomi) end)
  SkySceneKit.say({english="So everything was\ntied together...", french=" Ainsi donc, tout était lié...", german="Also war alles miteinander\nverwoben...", italian=" Quindi era tutto collegato...", spanish=" Así que todo estaba relacionado."})
  pcall(function() UI:SetSpeaker(npc_npc_madatsubomi) end)
  SkySceneKit.say({english="It was one vast conspiracy\nby [CS:N]Darkrai[CR]...[K] It's quite astounding.", french="Tout ça n'était qu'une immonde\nconspiration ourdie par ce [CS:N]Darkrai[CR]...[K]\nC'est stupéfiant.", german="Es war ein Riesenkomplott von\n[CS:N]Darkrai[CR].[K] Ziemlich erstaunlich.", italian="Era un'immensa cospirazione di\n[CS:N]Darkrai[CR]...[K]\nIncredibile...", spanish="Se trataba de una conspiración\nurdida por [CS:N]Darkrai[CR]...[K] Asombroso."})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) or (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) or (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) or (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 91] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_madatsubomi, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_madatsubomi) end)
  SkySceneKit.say({english="Team [CS:X]Raider[CR] is a legendary\nexploration team.", french="L'Equipe [CS:X]As[CR] est une\nvéritable légende de l'exploration.", german="Team [CS:X]Schatzsucher[CR] ist ein\nlegendäres Erkundungsteam.", italian="Il Team [CS:X]Asso[CR] è una leggendaria\nsquadra d'esplorazione.", spanish="El [CS:X]Equipo As[CR] es un equipo\nexplorador legendario."})
  pcall(function() UI:SetSpeaker(npc_npc_madatsubomi) end)
  SkySceneKit.say({english="The team consists of three\nmembers: [CS:N]Gallade[CR], [CS:N]Roserade[CR], and [CS:N]Rhyperior[CR].", french="L'équipe est composée de trois\nmembres: [CS:N]Gallame[CR], [CS:N]Roserade[CR] et [CS:N]Rhinastoc[CR].", german="Das Team besteht aus drei\nMitgliedern: [CS:N]Galagladi[CR], [CS:N]Roserade[CR] und [CS:N]Rihornior[CR].", italian="La squadra è formata da tre\nPokémon: [CS:N]Gallade[CR], [CS:N]Roserade[CR] e [CS:N]Rhyperior[CR].", spanish="Tiene tres miembros: [CS:N]Gallade[CR],\n[CS:N]Roserade[CR] y [CS:N]Rhyperior[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_madatsubomi) end)
  SkySceneKit.say({english="They're said to never be denied\nfrom getting the treasures they target.", french="On dit que quand ils jettent leur\ndévolu sur un trésor, ils n'échouent jamais:\nils finissent toujours par l'obtenir.", german="Man sagt, sie bekommen immer\ndie Schätze, auf die sie es abgesehen haben.", italian="Si dice che siano sempre riusciti\na ottenere i tesori su cui avevano messo gli\nocchi.", spanish="Se dice que siempre consiguen\ntodo lo que se proponen."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) or (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) or (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) or (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) or (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) or (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) or (SkyProg.cmp(29, 8) >= 0) or (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) or (SkyProg.cmp(29, 4) >= 0) or (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 54] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_madatsubomi, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_madatsubomi) end)
  SkySceneKit.say({english="You've brought peace to the\nworld at last!", french="Vous avez enfin restauré la\npaix en ce monde!", german="Ihr habt der Welt endlich\nFrieden gebracht!", italian="Alla fine avete riportato la pace\nnel mondo!", spanish="¡Al fin habéis devuelto la paz a\neste mundo!"})
  pcall(function() UI:SetSpeaker(npc_npc_madatsubomi) end)
  SkySceneKit.say({english=" Thank you!", french=" Merci!", german=" Danke!", italian=" Grazie!", spanish=" ¡Muchas gracias!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [25, 4] || scn($SCENARIO_MAIN) >= [25
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_madatsubomi, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_madatsubomi) end)
  SkySceneKit.say({english="Team [team:] is up for the\nchallenge! I'm sure of it!", french="L'Equipe [team:] est de\ntaille à relever le défi! Ça ne fait\naucun doute!", german="Team [team:] ist bereit\nfür die Herausforderung! Da bin ich mir\nsicher!", italian="Il Team [team:] è\nall'altezza della sfida! È sicuro!", spanish="¡Estoy seguro de que el [CS:X]Equipo[CR]\n[team:] está a la altura de este reto!\n¡No me cabe la menor duda!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) or (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) or (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) or (SkyProg.cmp(17, 3) >= 0) or (SkyProg.cmp(17, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [24, 1] || scn($SCENARIO_MAIN) >= [24
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_madatsubomi, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_madatsubomi) end)
  SkySceneKit.say({english="Learning about [CS:N]Grovyle[CR]'s wicked\nplan has hardened our resolve.[K] He must not get\naway with this.", french="Depuis qu'on sait ce que\nmanigance [CS:N]Massko[CR], on est encore plus\ndéterminés.[K] On ne peut pas le laisser faire!", german="Die Kenntnis des üblen Plans\nvon [CS:N]Reptain[CR] hat unsere Entschlossenheit\ngefestigt.[K] Er darf damit nicht durchkommen.", italian="Apprendere del malvagio piano di\n[CS:N]Grovyle[CR] ci ha temprato lo spirito.[K] Non gli\npermetteremo di sfuggire.", spanish="Al enterarnos del malvado plan\nde [CS:N]Grovyle[CR] nuestra determinación se ha visto\nreforzada.[K] No se saldrá con la suya."})
  pcall(function() UI:SetSpeaker(npc_npc_madatsubomi) end)
  SkySceneKit.say({english="[CS:N]Grovyle[CR] is sure to strike at\n[CS:P]Crystal Cave[CR] again.", french="[CS:N]Massko[CR] va sûrement encore\ntenter sa chance à la [CS:P]Caverne Cristal[CR].", german="[CS:N]Reptain[CR] schlägt ganz bestimmt\nnoch einmal in der [CS:P]Kristallhöhle[CR] zu.", italian="[CS:N]Grovyle[CR] colpirà sicuramente\ndi nuovo nella [CS:P]Grotta di Cristallo[CR].", spanish="[CS:N]Grovyle[CR] volverá, sin duda,\na la [CS:P]Cueva Cristal[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_madatsubomi) end)
  SkySceneKit.say({english="We therefore decided that we\nshould go there too![K] However...", french="C'est pour cette raison qu'on\nvoulait y aller nous aussi![K] Cependant...", german="Deshalb haben wir entschieden,\ndass auch wir uns dorthin begeben sollten![K]\nAllerdings gibt es da noch etwas...", italian="Quindi abbiamo deciso che ci\nandremo anche noi![K] Però...", spanish="Por eso, habíamos decidido ir.[K]\nSin embargo..."})
  pcall(function() UI:SetSpeaker(npc_npc_madatsubomi) end)
  SkySceneKit.say({english="Officer [CS:N]Magnezone[CR] informed us\nthat [CS:P]Crystal Cave[CR] is now off limits.", french="... le shérif [CS:N]Magnézone[CR] nous a\ninformés que l'accès à la [CS:P]Caverne Cristal[CR] est\ndésormais interdit.", german="Unser Oberwachtmeister\n[CS:N]Magnezone[CR] hat uns informiert, dass die\n[CS:P]Kristallhöhle[CR] jetzt tabu ist.", italian="Il Commissario [CS:N]Magnezone[CR] ci ha\ninformato che per ora la [CS:P]Grotta di Cristallo[CR]\nè inaccessibile.", spanish="El agente [CS:N]Magnezone[CR] nos ha\ninformado de que ahora está prohibido\nacceder a esa cueva."})
  pcall(function() UI:SetSpeaker(npc_npc_madatsubomi) end)
  SkySceneKit.say({english=" Is there a reason for that?", french=" Vous savez pourquoi, vous?", german=" Gibt es einen Grund dafür?", italian=" Per quale motivo?", spanish=" ¿Hay algún motivo?"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [16, 2] || scn($SCENARIO_MAIN) >= [16
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_madatsubomi, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_madatsubomi) end)
  SkySceneKit.say({english=" I'm sorry.", french=" Je vous prie de nous excuser.", german=" Es tut mir leid.", italian=" Sono spiacente.", spanish=" Lo siento."})
  pcall(function() UI:SetSpeaker(npc_npc_madatsubomi) end)
  SkySceneKit.say({english="We've been trying to gather\nnews about [CS:N]Grovyle[CR], but...", french="Nous avons essayé de recueillir\ndes informations au sujet de [CS:N]Massko[CR], mais...", german="Wir haben versucht, Neuigkeiten\nüber [CS:N]Reptain[CR] zu sammeln, aber...", italian="Abbiamo cercato di raccogliere\nnotizie su [CS:N]Grovyle[CR], ma...", spanish="Hemos intentado averiguar todo\nlo posible sobre [CS:N]Grovyle[CR], pero..."})
  pcall(function() UI:SetSpeaker(npc_npc_madatsubomi) end)
  SkySceneKit.say({english="We've had no success finding\nuseful information...", french=" ... rien qui soit vraiment utile...", german="Leider konnten wir dabei keine\nnützlichen Informationen finden.", italian="Non siamo riusciti a trovare\ninformazioni utili...", spanish="No hemos conseguido dar con\nnada..."})
  pcall(function() UI:SetSpeaker(npc_npc_madatsubomi) end)
  SkySceneKit.say({english=" But we promise we'll keep at it!", french="Nous allons persévérer, c'est\npromis!", german="Aber wir versprechen, dass wir\nam Ball bleiben werden!", italian="Ma promettiamo di continuare\na cercare!", spanish="¡Eso sí, prometemos seguir\nintentándolo!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) or (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [15, 1] || scn($SCENARIO_MAIN) >= [14
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_madatsubomi, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_madatsubomi) end)
  SkySceneKit.say({english="We of Team [CS:X]Flame[CR] will\nparticipate in the hunt for [CS:N]Grovyle[CR]!", french="Nous, l'Equipe [CS:X]Flamme[CR], nous\nallons participer à la poursuite de [CS:N]Massko[CR]!", german="Wir von Team [CS:X]Flamme[CR] werden\nuns an der Jagd auf [CS:N]Reptain[CR] beteiligen!", italian="Anche noi del Team [CS:X]Fiamma[CR]\ndaremo la caccia a [CS:N]Grovyle[CR]!", spanish="¡El [CS:X]Equipo Llameante[CR] piensa\nunirse a la caza de [CS:N]Grovyle[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_madatsubomi) end)
  SkySceneKit.say({english=" I'll work up my courage for this!", french="C'est une tâche importante!\nJe vais rassembler tout mon courage pour\ny arriver!", german="Ich werde dafür meinen Mut\nzusammennehmen!", italian="Farò del mio meglio per\ndiventare più coraggioso!", spanish="¡Voy a intentar ser valiente\nen esta misión!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) or (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) or (SkyProg.cmp(12, 1) >= 0) or (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) or (SkyProg.cmp(9, 1) >= 0) or (SkyProg.cmp(8, 7) >= 0) or (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) or (SkyProg.cmp(8, 3) >= 0) or (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) or (SkyProg.cmp(7, 6) >= 0) or (SkyProg.cmp(7, 3) >= 0) or (SkyProg.cmp(7, 2) >= 0) or (SkyProg.cmp(7, 1) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [13, 2] || scn($SCENARIO_MAIN) >= [13
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_madatsubomi, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_madatsubomi) end)
  SkySceneKit.say({english="We're Team [CS:X]Flame[CR].\nI'm the leader.", french="On est l'Equipe [CS:X]Flamme[CR]. C'est moi\nle meneur.", german="Wir sind Team [CS:X]Flamme[CR]. Ich bin\nder Anführer.", italian="Noi siamo il Team [CS:X]Fiamma[CR].\nIo sono il leader.", spanish="Somos el [CS:X]Equipo Llameante[CR].\nEl líder soy yo."})
  pcall(function() UI:SetSpeaker(npc_npc_madatsubomi) end)
  SkySceneKit.say({english="I don't like to admit it, but I'm\nvery timid...", french="Ça me gêne de l'avouer, mais\nje suis très peureux...", german="Ich gebe das nicht gerne zu,\naber ich bin sehr ängstlich...", italian="Mi vergogno ad ammetterlo, ma\nsono un po' fifone...", spanish="No me gusta admitirlo, pero\nsoy algo temeroso..."})
  pcall(function() UI:SetSpeaker(npc_npc_madatsubomi) end)
  SkySceneKit.say({english="When my team members start\nfighting with fire, I can't do a thing but stand\nback and hope I don't get hit...", french="Quand mes coéquipiers se\nmettent à utiliser des attaques de type Feu, je\ndois rester à l'écart pour éviter d'être touché.", german="Wenn meine Team-Mitglieder mit\nFeuer kämpfen, kann ich nur dastehen und\nhoffen, dass ich nicht getroffen werde.", italian="Quando la mia squadra lotta\ncon il fuoco, non posso far altro che stare\nindietro e sperare che non mi colpiscano...", spanish="Cuando mis compañeros lanzan\nsus ataques de tipo Fuego, lo único que\npuedo hacer es apartarme..."})
  pcall(function() UI:SetSpeaker(npc_npc_madatsubomi) end)
  SkySceneKit.say({english=" Ugh...[K]I feel so pathetic...", french="Pfff... [K]Je me trouve\npitoyable...", german="Uff,[K] ich fühle mich so\nerbärmlich.", italian=" Uh...[K] Mi sento così patetico...", spanish="Y confiar en que no me quemen.[K]\nQué patético resulto..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(5, 5) >= 0) or (SkyProg.cmp(4, 7) >= 0) or (SkyProg.cmp(4, 5) >= 0) or (SkyProg.cmp(4, 3) >= 0) or (SkyProg.cmp(4, 2) >= 0) or (SkyProg.cmp(4, 1) >= 0) or (SkyProg.cmp(4, 0) >= 0) or (SkyProg.cmp(3, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [5, 5] || scn($SCENARIO_MAIN) >= [4, 
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
