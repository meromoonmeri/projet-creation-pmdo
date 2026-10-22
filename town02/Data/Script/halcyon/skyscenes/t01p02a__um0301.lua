-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P02A/um0301.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_yarukimono = SkySceneKit.spawn_npc("vigoroth", 184, 232, Direction.Right, "NPC_YARUKIMONO")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yarukimono, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english=" Yo! You two sure showed them!", french=" Yo! Vous les avez laminés!", german="Hey! Ihr zwei habt es denen echt\ngezeigt!", italian=" Avete fatto vedere chi siete!", spanish=" ¡Eh! ¡Menuda lección les disteis!"})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="We can go on like this without\nbeing scared again!", french="La vie peut reprendre son cours!\nPersonne aura plus jamais peur!", german="Wir können so weiterleben wie\nbisher, ohne wieder Angst haben zu müssen!", italian=" Non dovremo più avere paura!", spanish="Por fin, vamos a poder respirar\ntranquilos sin más sustos de este tipo."})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english=" You get my thanks for that!", french=" Merci à vous!", german=" Dafür möchte ich euch danken!", italian=" Grazie di tutto!", spanish=" ¡Os lo agradezco!"})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 91] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yarukimono, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="You show that [CS:N]Darkrai[CR] he picked\nthe wrong bunch to mess with!", french="Montrez à ce [CS:N]Darkrai[CR] qu'il a mal\nchoisi ses adversaires!", german="Zeigt diesem [CS:N]Darkrai[CR], dass es\nsich dieses Mal mit der falschen Truppe\nangelegt hat!", italian="[CS:N]Darkrai[CR]  si è messo contro\nil gruppo di Pokémon sbagliato.", spanish="¡Tenéis que darle un buen\nescarmiento a ese tal [CS:N]Darkrai[CR]!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 85] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yarukimono, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="Yo! I heard from the\nguild's crew...", french="Yo! Les membres de la Guilde\nm'ont raconté...", german="Hey! Ich habe es von der\nGildencrew erfahren.", italian="Ciao! Ho saputo da quelli della\nGilda...", spanish="¡Eh! Me han puesto al día los\ndel [CS:N]Pokégremio[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="Sounds like there's bad trouble\nbrewing again...", french="On dirait qu'il va encore y avoir\ndu grabuge...", german="Klingt, als würde sich wieder\netwas Schlimmes zusammenbrauen.", italian="Pare che ci siano di nuovo grossi\nguai in vista...", spanish="Parece que volvemos a estar\nen problemas..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 76] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yarukimono, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="What's that?![K] Go into a dream?!\nWhat is that about?!", french="Qu'est-ce que vous dites?![K]\nEntrer dans un rêve?! Qu'est-ce que ça veut\ndire?!", german="Wie war das?!?[K] Einen Traum\nbetreten? Was soll das denn bedeuten?!?", italian="Che cosa?![K] Entrare in un\nsogno?! Mai sentita una cosa del genere!", spanish="¡¿Cómo?![K] ¡¿Meterse en un\nsueño?! ¡¿Y eso cómo se hace?!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 73] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yarukimono, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="Little [CS:N]Azurill[CR]'s asleep and no one\ncan wake him up?", french="Le petit [CS:N]Azurill[CR] dort et personne\narrive à le réveiller?", german="Der kleine [CS:N]Azurill[CR] ist in einen\nSchlaf gefallen und niemand kann ihn mehr\naufwecken?", italian="Il piccolo [CS:N]Azurill[CR] è addormentato\ne nessuno riesce a svegliarlo?", spanish="¿Así que el pequeño [CS:N]Azurill[CR]\nestá dormido y nadie puede despertarle?"})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="...What do you suppose happened\nto that tyke...?", french="... Qu'est-ce qui lui est arrivé à\nce môme, d'après vous...?", german="Was glaubt ihr, ist mit dem\nKleinen geschehen?", italian="Cosa pensate che sia successo a\nquella birba...?", spanish="¿Qué le habrá pasado a ese\npequeñín?"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 71] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yarukimono, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="...Oh.[K] So Team [CS:X]Charm[CR]\nleft already...", french="... Oh.[K] Alors l'Equipe [CS:X]Charme[CR]\nest déjà partie...", german="...Oh.[K] Team [CS:X]Charme[CR] ist also\nschon wieder aufgebrochen.", italian="Ah.[K] Allora il Team [CS:X]Malia[CR] se n'è\ngià andato...", spanish="¡Ah![K] Así que el [CS:X]Equipo Carisma[CR]\nya se ha marchado..."})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="Hey, did they say anything about\ncoming back to Treasure Town ever?", french="Hé, est-ce qu'elles ont parlé de\nrevenir à Bourg-Trésor un jour?", german="Hey, haben sie etwas darüber\nerwähnt, ob sie jemals nach Schatzstadt\nzurückkehren werden?", italian="Ehi, non vi hanno detto se prima\no poi torneranno a Borgo Tesoro?", spanish="¿Y han dicho algo de si\nvolverían alguna vez a Aldea Tesoro?"})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english=" ...Oh.[K] They never mentioned it...", french=" ... Oh.[K] Elles en ont pas parlé...", german="Oh.[K] Sie haben nichts\ndergleichen erwähnt.", italian=" Ah.[K] Non ne hanno parlato...", spanish=" Oh...[K] No lo mencionaron..."})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english=" ...[K]Rrrroar.", french=" ... [K]Rrrroar.", german=" ...[K]Rrrroar.", italian=" ...[K] Rrrroar.", spanish=" Vaya...[K] Grrrr..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 56] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yarukimono, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="What?![K] You say Team [CS:X]Charm[CR]\npaid a visit to the guild?!", french="Quoi?![K] Vous dites que l'Equipe\n[CS:X]Charme[CR] est venue à la Guilde?!", german="Was?!?[K] Team [CS:X]Charme[CR] hat der\nGilde einen Besuch abgestattet, sagt ihr?", italian="Cosa?![K] Avete detto che il Team\n[CS:X]Malia[CR] è stato alla Gilda?", spanish="¡¿Qué?![K] ¡¿Que el [CS:X]Equipo Carisma[CR]\nha visitado el [CS:N]Pokégremio[CR]?!"})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="Rrrroar! I should've gone to\nthe guild!", french=" Rrrroar! J'aurais dû y aller!", german="Rrrroar! Ich hätte zur Gilde\ngehen sollen!", italian="Rrrroar! Sarei dovuto andare\nalla Gilda!", spanish="¡Grrr! ¡Tendría que haberme\npasado por allí!"})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english=" I'm a huge fan of Team [CS:X]Charm[CR]!", french="Je suis le plus grand fan de\nl'Equipe [CS:X]Charme[CR]!", german="Ich bin ein Riesenanhänger von\nTeam [CS:X]Charme[CR]!", italian="Sono un grande fan del Team\n[CS:X]Malia[CR]!", spanish="Soy un gran admirador del\n[CS:X]Equipo Carisma[CR]."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 54] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yarukimono, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="Yo! Let's face another day with\nour heads held high!", french="Yo! Attaquons cette nouvelle\njournée la tête haute!", german="Hey! Stellen wir uns einem\nweiteren Tag mit erhobenen Häuptern!", italian="Ciao! Un altro giorno da\naffrontare a testa alta!", spanish="¡Eh! ¡Vamos a afrontar un día\nmás con la cabeza bien alta!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 52) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 52]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yarukimono, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english=" Yo! Come on, cheer up!", french="Yo! Allez, reprenez du poil de\nla bête, quoi!", german=" Hey! Kommt schon, Kopf hoch!", italian=" Forza e coraggio!", spanish=" ¡Eh! ¡Arriba ese ánimo!"})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="When I see you two down, it\nbrings me down too...", french="Quand je vous vois dans cet état\nabattu, ça me rend triste moi aussi...", german="Wenn ich euch zwei so\nniedergeschlagen sehe, dann werde ich auch\nganz traurig.", italian="Quando vi vedo giù, mi deprimo\nanch'io...", spanish="Que al veros así, yo también me\ndeprimo..."})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="Come on now![K] Do it for me![K]\nGive me a smile and cheer up!", french="Allez![K] Faites-le pour moi![K]\nSouriez et reprenez courage, quoi!", german="Los jetzt![K] Tut es für mich![K]\nLasst mich ein Lächeln sehen und Kopf hoch!", italian="Forza adesso![K] Fatelo per me![K]\nSorridete e su col morale!", spanish="¡Animaos![K] ¡Hacedlo por mí![K]\n¡Venga, sonreíd y alegrad esa cara!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 50] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yarukimono, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="Yo! Did you end up finding that\ncute baby?", french="Yo! Vous avez fini par le\nretrouver, ce petit bébé?", german="Hey! Habt ihr das süße Kleine\nwiedergefunden?", italian="Ciao! Alla fine l'avete trovato\nil piccino?", spanish="¡Eh! ¿Habéis encontrado al\npequeñuelo?"})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="...[K]Huh?[K] What?![K] Th-the baby's\nfallen sick now?!", french="... [K]Hein?[K] Quoi?![K] Le bébé est\ntombé malade maintenant?!", german="...[K]Wie?[K] Was?!?[K] D-das Kleine\nist krank geworden?", italian="...[K] Eh?[K] Cosa?![K] Il piccolo si è\nammalato ora?", spanish="Vaya...[K] ¿En serio?[K] ¡Qué pena![K]\n¡¿Ahora el pequeñín ha enfermado?!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 48] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yarukimono, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="Yo! Aren't you bringing that cute\nbaby around today?", french="Yo! Le bébé est pas avec vous\naujourd'hui?", german="Hey! Habt ihr heute das Kleine\nnicht dabei?", italian="Ciao! Oggi non portate a spasso\nil monellino?", spanish="¡Eh! ¿Hoy no os traéis a ese\nsimpático pequeñuelo?"})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="...[K]Huh?[K] What?![K] Th-that baby\nwandered off somewhere?!", french="... [K]Hein?[K] Quoi?![K] Il-il est parti\nquelque part, tout seul?!", german="...[K]Wie?[K] Was?!?[K] D-das Kleine\nist verschwunden?", italian="...[K] Eh?[K] Cosa?![K] Q-Quel piccino\nse n'è andato da solo da qualche parte?!", spanish="Vaya...[K] ¿Cómo decís?[K] ¡¿Qué?![K]\n¡¿El pequeñín se ha marchado?!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 46) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 46]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yarukimono, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="Yo! You taking that cute tyke\nout on a stroll?", french="Yo! Vous emmenez ce petit gars\nen balade?", german="Hey! Nehmt ihr das Kleine mit\nauf einen Spaziergang?", italian="Ciao! Portate quel monello a\nfare due passi?", spanish="¿Qué? ¿Os lleváis al muchachito\nde paseo?"})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english=" Yep, that's a cute little baby!", french="Ouaip, il est bien mignon ce\npetit-là!", german="Ja, das ist ein süßer kleiner\nKerl!", italian=" Sì, è proprio un bel piccino!", spanish=" ¡Sí, qué pequeño más lindo!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 45] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yarukimono, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="Yo! I heard your exploring took\nyou out to the sea this time, huh?", french="Yo! On dit que vos explorations\nvous ont fait traverser la mer cette fois-ci?", german="Hey! Ich habe gehört, dass euch\neure Erkundungen dieses Mal hinaus aufs Meer\ngeführt haben, wie?", italian="Ciao! Ho sentito che questa volta\navete esplorato il mare, eh?", spanish="¡Eh! He oído que esta vez os\nfuisteis a explorar el mar, ¿no?"})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="That's stupendous![K] There's\nnowhere that you won't go!", french="C'est sensationnel![K] Vous reculez\njamais devant le danger, vous!", german="Das ist erstaunlich![K] Ihr reist\nwirklich ausnahmslos überall hin!", italian="È stupendo![K] Certo che voi\nandreste veramente dappertutto!", spanish="¡Es formidable![K] ¡No hay sitio\nal que no podáis ir!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 41] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yarukimono, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="Yo! I heard you two went off\nexploring somewhere chilly, is that right?", french="Yo! Il paraît que vous avez\nexploré une région glaciale, c'est vrai?", german="Hey! Ich habe gehört, dass ihr\nan einem kalten Ort auf Erkundung wart, ist\ndas richtig?", italian="Ciao! Ho sentito che avete\nesplorato un posto freddo, è vero?", spanish="¡Eh! He oído que habéis ido a\nexplorar a un sitio muy frío, ¿verdad?"})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="You'll have to tell me all about\nit later!", french="Il faudra que vous me racontiez\nça un de ces jours, quoi!", german="Ihr müsst mir später alles\ndarüber erzählen!", italian=" Poi dovete raccontarmi tutto!", spanish=" ¡Ya me lo contaréis todo!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) or (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) or (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) or (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) or (SkyProg.cmp(29, 8) >= 0) or (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 33] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yarukimono, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="Yo! You passed your graduation\nexam, did you?", french="Yo! Vous avez réussi l'examen,\npas vrai?", german="Hey! Ihr habt eure\nAbschlussprüfung bestanden, nicht wahr?", italian=" Ciao! Avete superato l'esame?", spanish="¡Eh! Habéis superado el reto,\n¿verdad?"})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english=" You did it! Congratulations!", french=" Vous avez réussi! Bravo!", german="Ihr habt es geschafft!\nGlückwunsch!", italian=" Ce l'avete fatta! Congratulazioni!", spanish=" ¡Lo lograsteis! ¡Enhorabuena!"})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="I recognized that you two\nwere something else. And I was right!", french="J'avais bien senti que vous\nfaisiez la paire! J'avais raison, quoi!", german="Ich habe erkannt, dass ihr zwei\nschon welche seid. Und ich habe recht\nbehalten!", italian="Sentivo che voi due eravate\nqualcosa di speciale. E avevo ragione!", spanish="Enseguida me di cuenta de que\nerais especiales. ¡Y tenía razón!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 4) >= 0) or (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 4] || scn($SCENARIO_MAIN) >= [29
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yarukimono, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="Yo! I heard what's going on with\nyou two!", french="Yo! J'ai appris ce qui vous\narrive!", german="Hey! Ich habe gehört, was mit\neuch beiden los ist!", italian="Ciao! Ho saputo cosa state\nper fare!", spanish="¡Eh! ¡Ya me han contado lo\nvuestro!"})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="You're taking the guild's\ngraduation exam? You give it your all!", french="Vous allez passer l'examen de\nla Guilde, c'est ça?! Faites de votre mieux!", german="Ihr absolviert die\nGildenabschlussprüfung? Gebt alles!", italian="Darete l'esame della Gilda?\nMettetecela tutta!", spanish="¿Vais a realizar el gran reto\ndel [CS:N]Pokégremio[CR]? ¡Tenéis que esforzaros\ntodo lo que podáis!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [25, 4] || scn($SCENARIO_MAIN) >= [25
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yarukimono, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="Yo! You two![K] Rrrroar!\nRrrrooooarrrr!", french="Yo! Vous deux![K] Rrrroar!\nRrrrooooarrrr!", german="Hey! Ihr zwei![K] Rrrroar!\nRrrrooooarrrr!", italian="Ciao! Voi due![K] Rrrroar!\nRrrrooooarrrr!", spanish="¡Eh! ¡Escuchadme![K] ¡Grrr!\n¡Grrrrrrrrrr!"})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="You two give it everything\nyou've got!", french="Donnez tout ce que vous avez!\nA fond, à fond, à fond!", german="Gebt alles, was ihr habt,\nihr zwei!", italian=" Mettetecela tutta!", spanish=" ¡Tenéis que emplearos a fondo!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [24, 1] || scn($SCENARIO_MAIN) >= [24
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yarukimono, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english=" Yo! I've heard!", french=" Yo! J'ai appris la nouvelle!", german=" Hey! Ich habe es gehört!", italian=" Ciao! L'ho saputo!", spanish=" ¡Hola! ¡Me acabo de enterar!"})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="The planet's going to be\nparalyzed if nothing's done?!", french="La planète va se paralyser\nsi on fait rien?!", german="Der Planet wird gelähmt werden,\nwenn nichts unternommen wird?!?", italian="Se non si fa nulla, il pianeta\nrimarrà paralizzato?!", spanish="¿Así que el planeta va a quedar\nparalizado si nadie lo impide?"})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english=" That's bad news! Bad, bad, bad!", french="Pour une mauvaise nouvelle,\nc'est une mauvaise nouvelle, quoi!", german="Das sind schlechte Neuigkeiten!\nSchlecht, schlecht, schlecht!", italian="Che brutta notizia! Brutta,\nbrutta, brutta!", spanish=" ¡Qué malas noticias! ¡Pésimas!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [23, 1] || scn($SCENARIO_MAIN) >= [22
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yarukimono, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english=" Yo! You two are safe!", french="Yo! Vous êtes indemnes\nvous deux!", german=" Hey! Ihr zwei seid in Sicherheit!", italian=" Ciao! Vedo che state bene!", spanish=" ¡Eh! ¡Estáis a salvo!"})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="And they say you came back\nfrom the future...", french="Et il paraît que vous revenez\ndu futur...", german="Und man erzählt, ihr wärt aus\nder Zukunft zurückgekehrt.", italian="E dicono che siate di ritorno\ndal futuro...", spanish="Y dicen que regresasteis del\nfuturo..."})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english=" That's amazing stuff, you two!", french=" C'est incroyable!", german="Das ist echt beeindruckend, ihr\nzwei!", italian=" Questa storia è formidabile!", spanish=" ¡Es tremendo!"})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english=" Your gutsiness... I like it!", french="Vous avez du cran, quoi...\nJ'aime ça!", german="Eure Selbstsicherheit... Das\ngefällt mir!", italian=" Il vostro coraggio... mi piace!", spanish=" Menudo arrojo... ¡Así me gusta!"})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="I have faith in you!\nNever give up!", french="J'ai foi en vous! N'abandonnez\njamais!", german="Ich glaube an euch! Gebt niemals\nauf!", italian=" Credo in voi! Tenete duro!", spanish="¡Sé que podéis conseguir lo que\nos propongáis! ¡No debéis rendiros!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) or (SkyProg.cmp(17, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [21, 2] || scn($SCENARIO_MAIN) >= [21
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yarukimono, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="Yo! Have you heard back about\n[CS:N]Dusknoir[CR], [CS:N]Azelf[CR], and the others?", french="Yo! Vous avez des nouvelles de\n[CS:N]Noctunoir[CR], [CS:N]Créfadet[CR] et compagnie?", german="Hey! Habt ihr von [CS:N]Zwirrfinst[CR],\n[CS:N]Tobutz[CR] und den anderen gehört?", italian="Ciao! Avete notizie di [CS:N]Dusknoir[CR],\n[CS:N]Azelf[CR] e degli altri?", spanish="¡Eh! ¿Habéis tenido noticias de\n[CS:N]Dusknoir[CR], [CS:N]Azelf[CR] y los demás?"})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english=" ...[K]OK. Nothing yet.", french="... [K]Compris. Toujours rien,\nquoi.", german=" ...[K]Okay. Bisher noch nicht.", italian=" ...[K] Ok. Ancora niente.", spanish=" Ah...[K] Todavía no."})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="There's been no word from\nthem, I hear...[K] It makes for anxious waiting.", french="Ils ont toujours pas donné signe\nde vie, à ce qu'on dit...[K] C'est\ninquiétant d'attendre sans savoir.", german="Wie ich höre, gibt es noch keine\nNeuigkeiten von ihnen.[K] Besorgtes Warten ist\nalso angesagt.", italian="Non si sa ancora nulla...[K]\nUn'attesa snervante.", spanish="Así que aún no se sabe nada de\nellos...[K] La espera me mata."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(17, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [17, 1]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yarukimono, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="Yo! I'm out and about spreading\nthat rumor for you!", french="Yo! Me voilà sur le pied de\nguerre, prêt à répandre cette rumeur\npour vous!", german="Hey! Ich mache mich auf und\nverbreite das Gerücht für euch!", italian="Ciao! Sto facendo girare la voce\nper voi.", spanish="¿Qué hay? Yo también estoy\nextendiendo ese rumor para ayudaros."})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="About how [CS:N]Azelf[CR] and his friends\nare sealing away the Time Gear!", french="Comme quoi [CS:N]Créfadet[CR] et ses\namis seraient en train de sceller les Rouages\ndu Temps!", german="Darüber, wie [CS:N]Tobutz[CR] und seine\nFreunde die Zahnräder der Zeit versiegeln!", italian="Di come [CS:N]Azelf[CR] e i suoi amici\nPokémon cerchino di proteggere gli Ingranaggi\ndel Tempo.", spanish="Todo el mundo creerá que [CS:N]Azelf[CR]\ny sus amigos van a sellar el Engranaje del\nTiempo."})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english=" You're getting my best effort!", french="J'y mettrai toute mon énergie,\net j'en ai à revendre!", german=" Für euch tue ich mein Bestes!", italian=" Sto facendo del mio meglio!", spanish="Me estoy esforzando todo lo\nque puedo."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [16, 2] || scn($SCENARIO_MAIN) >= [16
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yarukimono, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="Yo! This time, you're off to\nexplore [CS:P]Crystal Cave[CR], huh?", french="Yo! Cette fois-ci, vous partez\nexplorer la [CS:P]Caverne Cristal[CR], hein?", german="Hey! Dieses Mal macht ihr euch\nauf, um die [CS:P]Kristallhöhle[CR] zu erkunden, wie?", italian="Ciao! Questa volta, state andando\na esplorare la [CS:P]Grotta di Cristallo[CR], eh?", spanish="Esta vez os vais a explorar\nla [CS:P]Cueva Cristal[CR], ¿eh?"})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="That sounds rough.[K] But you do\nthe best you can!", french="Ça a pas l'air facile.[K] Mais\nfaites de votre mieux!", german="Das klingt nach einem\nschwierigen Vorhaben.[K] Aber gebt euer Bestes!", italian="Sembra impegnativo.[K] Ma fate\ndel vostro meglio!", spanish="Suena complicado.[K] ¡Ánimo y\nesforzaos mucho!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [15, 1] || scn($SCENARIO_MAIN) >= [14
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yarukimono, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="Yo! I heard! You're on the hunt\nfor a Pokémon named [CS:N]Grovyle[CR]?", french="Yo! J'ai appris la nouvelle!\nVous êtes à la poursuite d'un Pokémon appelé\n[CS:N]Massko[CR]?", german="Hey! Ich habe es gehört! Ihr\nseid auf der Jagd nach einem Pokémon namens\n[CS:N]Reptain[CR]!", italian="Ciao! Ho saputo! Siete sulle\ntracce di un Pokémon chiamato [CS:N]Grovyle[CR]?", spanish="¡Eh! Me he enterado de que vais\ntras un Pokémon llamado [CS:N]Grovyle[CR], ¿no?"})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="I can't figure it out, though...[K]\nWhat would make that [CS:N]Grovyle[CR] steal Time\nGears?", french="Je capte pas...[K] Qu'est-ce qui\npeut bien pousser ce [CS:N]Massko[CR] à voler\nles Rouages du Temps?", german="Ich verstehe es einfach nicht.[K]\nWeshalb stiehlt [CS:N]Reptain[CR] nur Zahnräder\nder Zeit?", italian="Non riesco a capire...[K] Cos'è che\nha spinto [CS:N]Grovyle[CR] a rubare gli Ingranaggi\ndel Tempo?", spanish="Hay algo que no me cuadra...[K]\n¿Para qué iba a ponerse ese tal [CS:N]Grovyle[CR] a\nrobar Engranajes del Tiempo?"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [14, 4] || scn($SCENARIO_MAIN) >= [14
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yarukimono, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="Yo! You know, everyone seems\nto be busy and stressed out...", french="Yo! Vous savez, tout le monde a\nl'air occupé et stressé...", german="Hey! Wisst ihr, alle scheinen\nbeschäftigt und im Stress zu sein.", italian="Ciao! Ehi, sembrano tutti tesi\ne indaffarati...", spanish="¡Eh! Últimamente todos parecen\nandar muy ocupados y agobiados..."})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english=" Is something the matter?", french=" Il y a un problème?", german=" Ist irgendetwas los?", italian=" Qual è il problema?", spanish=" ¿Ocurre algo?"})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="I saw all those [CS:N]Pelipper[CR] in the\nsky too...", french="Moi aussi, j'ai vu tous ces\n[CS:N]Bekipan[CR] dans le ciel...", german="Ich habe all die [CS:N]Pelipper[CR] am\nHimmel gesehen.", italian="Ho visto anche tutti quei\n[CS:N]Pelipper[CR] nel cielo...", spanish="Yo también vi a todos esos\n[CS:N]Pelipper[CR] en el cielo..."})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="There's no fooling me. Something\nis happening, and it's bad...", french="On me la fait pas, à moi.\nIl se passe quelque chose et c'est pas\ntrès réjouissant, quoi...", german="Mich kann man nicht veräppeln.\nIrgendetwas geht hier vor, und es ist nichts\nGutes.", italian="Non prendetemi in giro. Sta\nsuccedendo qualcosa, ed è qualcosa di brutto...", spanish="A mí no me engañan. Está\npasando algo, y no precisamente bueno..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) or (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) or (SkyProg.cmp(12, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [13, 2] || scn($SCENARIO_MAIN) >= [13
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yarukimono, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="Yo![K] Hey, I'm advertising yet\nanother shop today!", french="Yo![K] Hé, je fais de la pub pour\nune autre boutique aujourd'hui!", german="Hey![K] Heute werbe ich für einen\nweiteren Laden!", italian="Ciao![K] Ehi, sto di nuovo\npubblicizzando un negozio!", spanish="¡Hola![K] Hoy estoy promocionando\notra tienda."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yarukimono, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Down)
  GROUND:EntTurn(partner, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="It's a shop down from here...[K]\n[CS:K]Xatu[CR] Appraisal is the place.", french="C'est juste en bas...[K]\nÇa s'appelle [CS:K]Expertise Xatu[CR].", german="Es ist ein Laden unterhalb von\nhier.[K] Ich rede von der [CS:K]Xatu-Begutachtung[CR].", italian="È un negozio poco lontano...[K]\nÈ l'Ufficio Perizie di [CS:K]Xatu[CR].", spanish="Se encuentra por allí abajo...[K]\nEl [CS:K]Anticuario Xatu[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yarukimono, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_yarukimono, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yarukimono, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="Have you two picked up any\nstrange treasure boxes in dungeons?\nYou know, ones you can't open?", french="Vous avez déjà ramassé des\ncoffres bizarres dans les donjons? Vous savez,\nceux que vous arrivez pas à ouvrir?", german="Habt ihr irgendwelche komischen\nSchatzboxen in Dungeons gesammelt? Ihr wisst\nschon, solche, die ihr nicht öffnen könnt?", italian="Voi due, avete raccolto qualche\nforziere strano nei dungeon? Voglio dire,\nqualcosa che non riuscite ad aprire?", spanish="¿No os habéis encontrado con\nunos extraños cofres al ir de aventuras?\nYa sabéis, esos que no hay forma de abrirlos..."})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="[CS:N]Xatu[CR] has the ability to pop open\nboxes like that and take out whatever's inside.", french="[CS:N]Xatu[CR] est capable d'ouvrir\nce genre de coffres. Il peut en extraire\nle contenu, quoi.", german="[CS:N]Xatu[CR] verfügt über die Fähigkeit,\neine Box wie diese zu öffnen und den Inhalt zu\nbergen.", italian="[CS:N]Xatu[CR] può aprire i forzieri\ne darvi il loro contenuto.", spanish="[CS:N]Xatu[CR] es un experto en esos\ntemas. Os lo abrirá en un periquete y os dará\nlo que contenga."})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="There's just one thing. He's...[K]\na little weird.", french="Il y a juste une chose. Disons\nqu'il est...[K] un peu bizarre, quoi.", german="Nur eine Sache! Er ist...[K]\nein wenig schräg.", italian="Solo una cosa. Lui è...[K] un po'\nstrano.", spanish="Pero, eso sí...[K] El tío es un\npoco raro."})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="Anyway, if you find a treasure\nbox you can't open, [CS:N]Xatu[CR] is the one to visit!", french="Enfin bref, si jamais vous\ntrouvez un coffre que vous arrivez pas\nà ouvrir, allez voir [CS:N]Xatu[CR]!", german="Wie auch immer, wenn ihr eine\nSchatzbox findet, die ihr nicht öffnen könnt,\nsolltet ihr bei [CS:N]Xatu[CR] vorbeischauen!", italian="Comunque, se trovate un\nforziere che non potete aprire, andate da [CS:N]Xatu[CR]!", spanish="De todas formas, ya sabéis.\nSi os encontráis algún cofre imposible de\nabrir, ¡solo tenéis que visitar a [CS:N]Xatu[CR]!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) or (SkyProg.cmp(9, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [10, 2] || scn($SCENARIO_MAIN) >= [10
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yarukimono, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="Yo! Congrats for making the\nexpedition party!", french="Yo! Bravo, vous avez réussi\nà obtenir votre billet pour l'expédition!", german="Hey! Meinen Glückwunsch dazu,\ndass ihr an der Expedition teilnehmen dürft!", italian="Ciao! Congratulazioni, ho saputo\nche farete parte della spedizione!", spanish="¡Eh! ¡Enhorabuena por poder ir\na la expedición!"})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="Come back with lots of\nsouvenirs!", french="Revenez-nous avec des tas de\nsouvenirs!", german="Kommt mit reichlich Mitbringseln\nzurück!", italian=" Tornate con un po' di souvenir!", spanish=" ¡Traed algo de recuerdo!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(8, 7) >= 0) or (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) or (SkyProg.cmp(8, 3) >= 0) or (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [8, 7] || scn($SCENARIO_MAIN) >= [8, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yarukimono, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="Yo![K] Hey, I'm advertising another\nshop today!", french="Yo![K] Hé, je fais de la pub pour\nune autre boutique aujourd'hui!", german="Hey![K] Heute werbe ich für einen\nweiteren Laden!", italian="Ciao![K] Ehi, oggi pubblicizzo\nun altro negozio!", spanish="¡Eh![K] ¡Hola! Hoy estoy anunciando\notra tienda."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_erekiburu = SkySceneKit.spawn_npc("electivire", 184, 168, Direction.Down, "NPC_EREKIBURU")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yarukimono, npc_npc_erekiburu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_erekiburu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_erekiburu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english=" See![K] See that shop there?", french="Regardez![K] Vous voyez cette\nboutique, là-bas?", german="Seht mal her![K] Seht ihr den Laden\ndort drüben?", italian="Guardate![K] Vedete quel negozio\nlì?", spanish=" ¡Mirad![K] ¿Veis aquella de allí?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yarukimono, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_yarukimono, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yarukimono, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="That place's called the [CS:K]Electivire[CR]\nLink Shop.", french="Ça s'appelle le [CS:K]Stand Chaîne\nElekable[CR].", german="Jener Ort wird [CS:K]Elevoltek-Link[CR]\ngenannt.", italian="Si chiama la Combiteca\n[CS:K]Electivire[CR].", spanish=" Es la tienda [CS:K]Enlaces Electivire[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="That shop can link two moves\ntogether for you!", french="Vous pouvez y faire lier des\ncapacités!", german="In jenem Laden könnt ihr zwei\nAttacken kombinieren lassen!", italian="In quel negozio possono\ncombinarvi due mosse insieme!", spanish="¡Allí se pueden enlazar varios\nmovimientos!"})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="You see, linked moves are used\none after the other in the same turn.", french="Les capacités liées sont\nutilisées les unes après les autres en un seul\net même tour, vous voyez.", german="Kombinierte Attacken können\nkurz nacheinander in derselben Runde\neingesetzt werden.", italian="Sapete, le mosse combinate\ncolpiscono una dopo l'altra nello stesso turno.", spanish="Al enlazar movimientos podrás\nutilizar uno detrás de otro en el mismo\nturno."})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="Put a smart combo together and\nyou can make awesome strikes!", french="Créez-vous un combo sympa\net vos attaques feront des ravages, quoi!", german="Stellt euch eine gewiefte\nKombination zusammen, und ihr könnt starke\nSchläge ausführen!", italian="Se preparate una combinazione\nintelligente potrete realizzare attacchi\nmicidiali!", spanish="¡Haz una combinación inteligente\ny ya verás qué ataques más alucinantes!"})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="Why not pay the shop a visit and\nsee what I mean about linking moves?", french="Pourquoi ne pas faire un tour à\nla boutique pour en savoir plus sur les chaînes\nde capacités?", german="Warum schaut ihr nicht in dem\nLaden vorbei und seht euch an, was ich mit\ndem Kombinieren von Attacken meine?", italian="Perché non fate visita al negozio\nper capire cosa vuol dire combinare le mosse?", spanish="¿Por qué no hacéis una visita\na la tienda para ver a qué me refiero?"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(7, 6) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 6]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yarukimono, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="Yo! I hear explorers are staying\naway from this place because that stench\nwon't go away.", french="Yo! Il paraît que les\nexplorateurs évitent cet endroit à cause\nde cette puanteur persistante.", german="Hey! Ich habe gehört, dass sich\nErkunder von diesem Ort fernhalten, weil der\nGestank einfach nicht verfliegen will.", italian="Ciao! Si dice che gli esploratori\nsi tengano alla larga da qui perché la puzza\nnon va via.", spanish="He oído que ningún explorador\nquiere venir por aquí porque este mal olor\nno acaba de desaparecer."})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="If you were to ask me...[K]\nYou'd have to be pretty soft to let a little\nsmell put you off!", french="Si vous voulez mon avis...[K] Faut\nêtre une vraie chochotte pour être gêné par\nune petite odeur de rien du tout, quoi!", german="Wenn ihr mich fragt,[K]\nmüsst ihr recht verweichlicht sein, wenn ihr\neuch von ein wenig Gestank abschrecken lasst!", italian="Se volete la mia opinione...[K]\nDevi essere un rammollito per farti stendere\nda un po' di puzza!", spanish="Si queréis saber mi opinión...[K]\n¡Hay que ser un blandengue para que\nte espante un mal olor de nada!"})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="You two keep up with your\ntraining!", french="Continuez l'entraînement,\nvous deux!", german="Ihr zwei fahrt mit eurem\nTraining fort!", italian="Continuate ad allenarvi!", spanish=" ¡Seguid así, entrenando duro!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(7, 3) >= 0) or (SkyProg.cmp(7, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 3] || scn($SCENARIO_MAIN) >= [7, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yarukimono, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="After a day of work, nothing\nbeats the Hot Spring.", french="Après une dure journée de\ntravail, la Source Chaude, c'est le pied,\nquoi!", german="Nach einem arbeitsamen Tag\nkommt nichts an die Heiße Quelle heran.", italian="Dopo un giorno di lavoro, non c'è\nniente di meglio della Sorgente Termale.", spanish="Tras un día de trabajo,\nno hay nada mejor que la Terma."})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="Hoooo... It doesn't get better\nthan this! ♪", french="Hoooo... Y'a rien de\nmieux que ça! ♪", german="Huuuu... An das hier kommt so\nschnell nichts heran! Besser geht es nicht! ♪", italian="Ooooh... Non potrebbe andar\nmeglio di così! ♪", spanish="¡Sí, no hay nada mejor que\nesto! ♪"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(7, 1) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 1] || scn($SCENARIO_MAIN) >= [6, 
  if ((SV.SkyTalkBitFlags or {})[48] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[48]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yarukimono, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="You can sharpen your skills as\nexplorers at [CS:K]Marowak[CR] Dojo.", french="Vous pouvez améliorer les\ntalents de votre équipe d'exploration\nau [CS:K]Dojo Ossatueur[CR].", german="Ihr könnt eure Fähigkeiten als\nErkunder im [CS:K]Knogga-Dojo[CR] verbessern.", italian="Potete affinare le vostre abilità\ndi esploratori al Dojo [CS:K]Marowak[CR].", spanish="Podéis entrenaros para mejorar\ncomo equipo explorador en el [CS:K]Dojo Marowak[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yarukimono, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english=" It's just down from here.", french=" C'est juste en bas.", german=" Es ist direkt unterhalb von hier.", italian=" È proprio giù di qui.", spanish=" Solo hay que bajar por aquí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yarukimono, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="You two are an exploration\nteam, right? Why don't you go test yourselves\nat the dojo?", french="Vous êtes une équipe\nd'exploration, pas vrai? Pourquoi ne pas aller\ntester vos talents au dojo?", german="Ihr seid ein Erkundungsteam,\nrichtig? Warum stellt ihr nicht eure\nFähigkeiten im Dojo auf die Probe?", italian="Voi due siete una squadra\nd'esplorazione, vero? Perché non andate\na mettervi alla prova al Dojo?", spanish="Sois un equipo explorador, ¿no?\n¿Por qué no vais a poneros a prueba\nen el dojo?"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[48] = 1 -- $SCENARIO_TALK_BIT_FLAG[48] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yarukimono, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english=" Yo! Another great day!", french=" Yo! Encore une super journée!", german=" Hey! Ein weiterer toller Tag!", italian=" Ciao! Un altro grande giorno!", spanish=" ¡Eh! ¡Otro gran día!"})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="By the way, you two![K] Do you\nknow [CS:K]Marowak[CR] Dojo?", french="Au fait, vous deux![K] Vous\nconnaissez le [CS:K]Dojo Ossatueur[CR]?", german="Übrigens, ihr zwei![K] Kennt ihr\ndas [CS:K]Knogga-Dojo[CR]?", italian="A proposito, voi due![K] Conoscete\nil Dojo [CS:K]Marowak[CR]?", spanish="¡Eh, por cierto...![K] ¿Conocéis\nel [CS:K]Dojo Marowak[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:K]Marowak[CR] Dojo?", french=" Le [CS:K]Dojo Ossatueur[CR]?", german=" [CS:K]Knogga-Dojo[CR]?", italian=" Il Dojo [CS:K]Marowak[CR]?", spanish=" ¿El [CS:K]Dojo Marowak[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:K]Marowak[CR] Dojo?", french=" Le [CS:K]Dojo Ossatueur[CR]?", german=" [CS:K]Knogga-Dojo[CR]?", italian=" Il Dojo [CS:K]Marowak[CR]?", spanish=" ¿El [CS:K]Dojo Marowak[CR]?"})
  else
  SkySceneKit.say({english=" [CS:K]Marowak[CR] Dojo?", french=" Le [CS:K]Dojo Ossatueur[CR]?", german=" [CS:K]Knogga-Dojo[CR]?", italian=" Il Dojo [CS:K]Marowak[CR]?", spanish=" ¿El [CS:K]Dojo Marowak[CR]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="[CS:K]Marowak[CR] Dojo is a place where\nexploration teams go to hone their skills.", french="Le [CS:K]Dojo Ossatueur[CR] permet\naux équipes d'exploration d'affûter\nleurs techniques de combat.", german="Im [CS:K]Knogga-Dojo[CR] verbessern\nErkundungsteams ihre Fähigkeiten.", italian="Il Dojo [CS:K]Marowak[CR] è un posto in\ncui le squadre d'esplorazione vanno ad affinare\nle loro abilità.", spanish="El [CS:K]Dojo Marowak[CR] es un lugar\nal que van los equipos de exploración para\nentrenarse un poco."})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="Actually, when everything was\npeaceful, there wasn't much need for its\nservices...", french="En fait, tant que le monde était\nen paix, on avait pas vraiment besoin de\nses services, quoi...", german="Eigentlich gab es in Zeiten des\nFriedens keine große Nachfrage im Hinblick\nauf das Angebot.", italian="A dire il vero, quando tutto era\ntranquillo, non c'era realmente bisogno di\nquesto servizio...", spanish="En realidad, cuando había paz\npor estas tierras sus servicios no tuvieron\nmucha demanda."})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="The sensei couldn't pay for its\nupkeep...[K]and it eventually collapsed.", french="Le sensei du dojo manquait\nd'argent pour l'entretenir... [K]et il a fini par\ns'effondrer, quoi.", german="Der Meister konnte seine\nInstandhaltung nicht finanzieren,[K] weshalb es\nletzten Endes einstürzte.", italian="Il maestro non poteva pagare\nle spese di gestione...[K] e alla fine è\nfallito.", spanish="El maestro del dojo no pudo pagar\nsu mantenimiento...[K] y acabó en la ruina."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh?!", french=" Hein?!", german=" Wie?!?", italian=" Eh?!", spanish=" ¡¿Qué?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?!", french=" Hein?!", german=" Was?!?", italian=" Cosa?!", spanish=" ¡¿Qué?!"})
  else
  SkySceneKit.say({english=" Pardon?!", french=" Hein?!", german=" Bitte?!?", italian=" Scusa?!", spanish=" ¡¿Qué?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="But...[K]let there be rejoicing![K]\nThat [CS:K]Marowak[CR] Dojo...", french="Mais... [K]réjouissons-nous![K]\nLe [CS:K]Dojo Ossatueur[CR]...", german="Aber [K]lasst uns jubeln![K]\nDas [CS:K]Knogga-Dojo[CR]...", italian="Ma...[K] c'è da rallegrarsi![K]\nIl Dojo [CS:K]Marowak[CR]...", spanish="Pero...[K] ¡ya podemos alegrarnos![K]\nEl [CS:K]Dojo Marowak[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="It's been resurrected from the\nrubble![K] Back and better than ever!", french="... vient de renaître de ses\ncendres, tel le phénix![K] Il revient, plus\nfort que jamais!", german="Es hat sich aus dem Schutt neu\nerhoben![K] Und es hat wieder geöffnet und ist\nzudem besser als je zuvor!", italian="È risorto dalle macerie![K]\nDi nuovo aperto e migliore che mai!", spanish="¡Ha resurgido de sus cenizas![K]\nEstá otra vez en funcionamiento ¡y mejor\nque nunca!"})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="...And, uh, I'm going around\nadvertising the dojo's reopening for my\nsponsor, [CS:N]Marowak[CR].", french="... Et moi... euh... je fais de la\npub pour la réouverture du dojo, au service\nde mon sponsor [CS:N]Ossatueur[CR], quoi.", german="...Und, äh, ich ziehe umher und\nwerbe für das wiedereröffnete Dojo meines\nSponsors [CS:N]Knogga[CR].", italian="Ehm, io sto andando in giro a\npubblicizzare la riapertura per conto del mio\nfinanziatore, [CS:N]Marowak[CR].", spanish="[CS:N]Marowak[CR] es mi patrocinador,\npor eso estoy anunciando la noticia de la\nreapertura del dojo a bombo y platillo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yarukimono, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="[CS:K]Marowak[CR] Dojo is straight down\nfrom here.", french="Le [CS:K]Dojo Ossatueur[CR] est juste en\nbas, vous voyez?", german="Das [CS:K]Knogga-Dojo[CR] befindet sich\nvon hier aus in gerader Linie nach unten.", italian="Trovate il Dojo [CS:K]Marowak[CR]\nlaggiù.", spanish="Al [CS:K]Dojo Marowak[CR] se va bajando\npor allí, todo recto."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yarukimono, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="You two are an exploration\nteam, right? Why don't you go test yourselves\nat the dojo?", french="Vous êtes une équipe\nd'exploration, pas vrai? Pourquoi pas aller\ntester vos talents au dojo?", german="Ihr seid ein Erkundungsteam,\nrichtig? Warum stellt ihr nicht eure\nFähigkeiten im Dojo auf die Probe?", italian="Voi due siete una squadra\nd'esplorazione, vero? Perché non andate\na mettervi alla prova al Dojo?", spanish="Sois un equipo explorador, ¿no?\n¿Por qué no vais a poneros a prueba\nen el dojo?"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(5, 5) >= 0) or (SkyProg.cmp(4, 7) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [5, 5] || scn($SCENARIO_MAIN) >= [4, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yarukimono, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english=" Yo! Another great day!", french=" Yo! Encore une super journée!", german=" Hey! Ein weiterer toller Tag!", italian=" Ciao! Un altro grande giorno!", spanish=" ¡Eh! ¡Otro gran día!"})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="Good luck with your guild\ntraining!", french="Bonne chance pour votre\nentraînement à la Guilde!", german="Viel Glück bei eurem\nGildentraining!", italian="Buona fortuna con il vostro\nallenamento alla Gilda!", spanish="¡Buena suerte con vuestro\nentrenamiento!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 5) >= 0) or (SkyProg.cmp(4, 3) >= 0) or (SkyProg.cmp(4, 2) >= 0) or (SkyProg.cmp(4, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 5] || scn($SCENARIO_MAIN) >= [4, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yarukimono, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="Yo![K] Are you two the new\napprentices at the guild?", french="Yo![K] Il paraît qu'il y a de\nnouveaux apprentis à la Guilde! C'est vous?", german="Hey![K] Seid ihr zwei die neuen\nGildenlehrlinge?", italian="Ciao![K] Siete voi due le nuove\nreclute della Gilda?", spanish="¡Eh![K] ¿Sois el nuevo par de\naprendices del [CS:N]Pokégremio[CR]?"})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="Then, hello! The name's\n[CS:N]Vigoroth[CR]!", french="Alors, salut! Moi, je m'appelle\n[CS:N]Vigoroth[CR], quoi!", german="Na dann hallo! Ich heiße\n[CS:N]Muntier[CR]!", italian=" Allora, ciao! Mi chiamo [CS:N]Vigoroth[CR]!", spanish="Entonces... ¡hola! ¡Me llamo\n[CS:N]Vigoroth[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="I'm no good at sitting still.[K]\nI'm always bursting with energy![K]\nGreat to meet ya!", french="Je tiens pas en place.[K]\nJe déborde d'énergie, quoi![K] Content de\nvous connaître!", german="Stillsitzen ist nicht meine\nStärke.[K] Ich sprudele immer nur so vor\nEnergie![K] Schön, euch zu treffen!", italian="Non riesco a star tranquillo.[K]\nSono sempre pieno d'energia![K]\nFelice di conoscervi!", spanish="No se me da bien lo de estarme\nquieto.[K] ¡Siempre estoy cargado de energía![K]\n¡Encantado de conoceros!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 0) >= 0) or (SkyProg.cmp(3, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 0] || scn($SCENARIO_MAIN) >= [3, 
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
