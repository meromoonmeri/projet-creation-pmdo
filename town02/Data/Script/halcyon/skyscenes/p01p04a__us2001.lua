-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P01P04A/us2001.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) or (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_bariyaado = SkySceneKit.spawn_npc("mr_mime", 496, 184, Direction.Up, "NPC_BARIYAADO")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bariyaado, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english="Sometimes Bottles with\nMessages in them wash up on the beach.", french="Parfois, des bouteilles contenant\nun message s'échouent sur le rivage.", german="Manchmal werden am Strand\nFlaschen mit Nachrichten angespült.", italian="A volte sulla spiaggia puoi\ntrovare delle bottiglie con dei messaggi\nall'interno.", spanish="A veces llegan a la playa frascos\ncon mensajes dentro."})
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english=" It's kind of romantic...", french=" Romantique, n'est-il pas...?", german=" Ach, wie romantisch...", italian=" È così romantico...", spanish=" Me parece muy romántico..."})
  -- message_Close
  -- @label_131 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 85] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bariyaado, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english="It's become pretty busy in here\nnow that everyone's back.", french="L'ambiance est plutôt frénétique\nici, maintenant que tout le monde est de retour.", german="Jetzt, wo alle wieder da sind,\nist es wieder recht geschäftig geworden.", italian="Ora che sono tornati tutti, il\nlocale è sempre stracolmo.", spanish="Hay mucho ambientillo por aquí,\nahora que ha vuelto todo el mundo."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) or (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 71] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bariyaado, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english="All the café patrons haven't\nreturned from [CS:P]Sky Peak[CR] yet.", french="Les habitués ne sont pas encore\ntous revenus du [CS:P]Pic Céleste[CR].", german="Es sind noch nicht alle Café-\nGäste vom [CS:P]Himmelsgipfel[CR] zurück.", italian="I clienti del Caffè non sono\nancora tornati dal [CS:P]Picco del Cielo[CR].", spanish="Los clientes de la cafetería aún\nno han vuelto de la [CS:P]Cumbre del Cielo[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english="As long as they don't become\nmissing Pokémon! Ha ha ha!", french="Well, tant qu'ils ne disparaissent\npas complètement! Ha ha ha!", german="Na, solange sie nicht zu\nvermissten Pokémon werden! Ha ha ha!", italian=" Che frane! Ah ah ah!", spanish="Mientras no se conviertan en\nPokémon desaparecidos... ¡Ja, ja, ja!"})
  pcall(function() GROUND:CharSetEmote(npc_npc_bariyaado, "happy", 1) end)
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(npc_npc_bariyaado, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english=" Well... That wasn't really funny.", french="Hem... ce n'était pas très\namusant, sorry.", german="Ähm...\nDas war eigentlich nicht lustig.", italian="Mmmh... Non era affatto\ndivertente.", spanish=" Sí, ya sé que no tiene gracia."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 54] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bariyaado, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english="Huh? I wonder what happened.\nThere are hardly any customers...", french="What? Que s'est-il passé ici?\nIl n'y a presque aucun client...", german="Hmm? Ich frage mich, was los\nist. Kaum Kunden unterwegs...", italian="Uh? Che cosa sarà successo?\nNon c'è l'ombra di un cliente...", spanish="Hum, ¿qué habrá pasado?\nApenas hay clientes..."})
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english=" I wonder where everyone went.", french=" Mais où sont-ils donc passés?", german=" Wo die wohl alle hin sind?", italian="Mi chiedo che fine abbiano fatto\ntutti...", spanish=" ¿Dónde se habrán metido todos?"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 41] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bariyaado, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english="My goodness! You two are\nsomething else!", french="Oh my! Vous faites une sacrée\npaire, vous deux!", german="Du meine Güte! Ihr zwei seid\nschon ein Team!", italian="Accipicchia! Voi due\nnon siete come tutti gli altri!", spanish="¡Madre mía! ¡Sois de lo que no\nhay!"})
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english="To rescue an explorer of such\nlegendary status as [CS:N]Scizor[CR]...!", french="Vous avez réussi à sauver\nun explorateur de la trempe de [CS:N]Cizayox[CR]...!\nOh yes, je suis très impressionné!", german="Um einen so legendären Erkunder\nwie [CS:N]Scherox[CR] zu befreien!", italian="Riuscire a soccorrere un\nleggendario esploratore come [CS:N]Scizor[CR]...!", spanish="¡Rescatar a un legendario\nexplorador como [CS:N]Scizor[CR]!"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 33) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 33]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bariyaado, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english="I understand that [CS:P]Blizzard Island[CR]\nis a terribly harsh place. I wish you luck!", french="A ce qu'on dit, l'[CS:P]Ile Blizzard[CR]\nest une contrée terriblement hostile. Je vous\nsouhaite bonne chance! Good luck!", german="Mir ist bewusst, dass die\n[CS:P]Blizzardinsel[CR] ein schrecklich rauer Ort ist.\nIch wünsche euch Glück!", italian="So che l'[CS:P]Isola Tormenta[CR] è un\nposto terribilmente ostile. Vi auguro ogni bene!", spanish="Creo que la [CS:P]Isla Ventisca[CR] es\nun lugar horrible. ¡Os deseo suerte!"})
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english="For your sakes, I hope you find\nthe treasure that has so far eluded that\nexplorer extraordinaire [CS:N]Scizor[CR].", french="J'espère que vous mettrez la\nmain sur le trésor qui a jusque-là échappé à\n[CS:N]Cizayox[CR], l'explorateur extraordinaire.", german="Um euretwillen hoffe ich,\ndass ihr den Schatz findet, der bislang dem\naußergewöhnlichen [CS:N]Scherox[CR] vorenthalten blieb.", italian="Spero per voi che recuperiate il\ntesoro che lo straordinario esploratore [CS:N]Scizor[CR]\nnon ha mai trovato.", spanish="Espero que logréis encontrar el\ntesoro que tanto tiempo se le resistió\nal extraordinario explorador [CS:N]Scizor[CR]."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 32) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 32]
  -- supervision_ExecuteCommon(CORO_EVENT_S02_01) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 31) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 31]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english="The climb was not an easy one,\nbut this view makes everything worth it.\nI feel rejuvenated.", french="Ce n'était pas une mince affaire\nde grimper jusqu'ici. Mais la vue en vaut\nvraiment la peine. Yes, je me sens requinqué!", german="Der Aufstieg war wirklich\nhappig, aber diese Aussicht macht alles wett!\nJetzt fühle ich mich wieder fit.", italian="È stata dura arrivare in cima,\nma ne valeva la pena per assistere a questo\nspettacolo mozzafiato. Mi sento rinvigorito.", spanish="La subida ha sido complicada,\npero esta vista bien lo valía.\nMe siento rejuvenecer."})
  -- message_KeyWait
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bariyaado, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english="I'm glad I didn't give up\nhalfway up the mountain!", french="Je suis content de ne pas avoir\nabandonné à mi-chemin, really!", german="Ich bin froh, dass ich nicht auf\nhalbem Wege schlapp gemacht habe!", italian="Sono contento di non aver\ngettato la spugna a metà del cammino!", spanish="¡Me alegro de no haberme dado\npor vencido a medio camino!"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 30] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english=" Ugh... So cold!", french=" Oh dear... il fait si froid!", german=" Umpf... Wie kalt!", italian=" Brrr... Che freddo!", spanish=" Uf... ¡Qué rasca!"})
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english="Is it really true that someone\nfainted here?", french="Est-il vrai que quelqu'un s'est\névanoui ici?", german="Stimmt es, dass hier jemand K.O.\ngegangen ist?", italian="Ma è vero che qualcuno è finito\nKO in questo posto?", spanish="¿Es cierto que alguien se\ndebilitó en este lugar?"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) or (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 28] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english="From here on, the mountain is\ncovered in snow...", french="La montagne est recouverte\nde neige à partir d'ici...", german="Von hier an ist der Berg mit\nSchnee bedeckt...", italian="Da questo punto in avanti,\nla montagna è ricoperta di neve...", spanish="A partir de aquí la montaña está\ncubierta de nieve..."})
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english="I was thinking of heading back\ndown to the base and getting supplies.", french="Je pensais revenir au pied de la\nmontagne pour me ravitailler.", german="Ich dachte daran, zurück ins\nLager zu gehen, um Vorräte zu holen.", italian="Quasi quasi torno indietro\ne faccio rifornimento di strumenti.", spanish="Me estoy planteando bajar al pie\nde la montaña a por provisiones."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) or (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 22] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english=" [CS:I]Sky Gifts[CR]...", french=" Des [CS:I]Dons du Ciel[CR]...", german=" [CS:I]Himmelspräsente[CR]...", italian=" [CS:I]Doni Cielo[CR]...", spanish=" Los [CS:I]Regalos Cielo[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english="Speaking of... One of my friends\nis celebrating a birthday soon. I should give\nthem one as a present...", french="A propos... un de mes amis\nfête son anniversaire bientôt. Yes, je devrais\nlui en offrir un...", german="Wo wir gerade darüber reden...\nEiner meiner Freunde hat bald Geburtstag. Das\nwäre ein guter Anlass, eins zu verschenken...", italian="Ora che ci penso... tra poco è\nil compleanno di un mio amico. Dovrei\nregalargliene uno...", spanish="Eso me recuerda que pronto será\nel cumpleaños de un amigo... Debería regalarle\nuno, a ver si le gusta..."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 15] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english="It makes me a little nervous\nthat I can't rely on a Friend Rescue here.", french="Ça ne me rassure pas de savoir\nque personne ne peut venir me secourir ici.", german="Es macht mich ein wenig nervös,\ndass ich dort nicht auf eine Freundrettung\nvertrauen kann.", italian="Sapere che nessuno può venire\na salvarmi se mi trovo nei guai, mi rende un\npo' nervoso.", spanish="Me inquieta no poder contar con\nel rescate de amigos en este lugar."})
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english="But, in a way, it has a certain\nthrill to it.", french="Mais d'un autre côté,\nça ajoute un peu de piment.", german="Aber auf eine gewisse Weise\nmacht es das auch reizvoll.", italian="Ma in un certo senso è anche\npiuttosto emozionante.", spanish="Pero supongo que eso también le\nda emoción al asunto."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 11] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bariyaado, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english="We can't request a Friend\nRescue on [CS:P]Sky Peak[CR] because the path was\ndestroyed by an earthquake, or so I've heard.", french="Le sentier ayant été détruit par\nun séisme, inutile d'espérer un Sauvetage Ami\nsur le [CS:P]Pic Céleste[CR] en cas de pépin.", german="Wir können auf dem\n[CS:P]Himmelsgipfel[CR] keine Freundrettung anfordern.\nDer Grund ist anscheinend ein Erdbeben.", italian="Non è possibile richiedere\nmissioni di Pronto Intervento sul [CS:P]Picco del[CR]\n[CS:P]Cielo[CR]... Un terremoto ha distrutto il sentiero.", spanish="No se puede solicitar un rescate\nde amigos en la [CS:P]Cumbre del Cielo[CR] porque\npor lo visto un terremoto destruyó el sendero."})
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english="[CS:P]Sky Peak[CR] is quite inaccessible,\nI've been told.", french="C'est dire si cette montagne\nest inaccessible, n'est-il pas?", german="Der [CS:P]Himmelsgipfel[CR] ist äußerst\nunzugänglich, wie mir berichtet wurde.", italian="Mi hanno detto che scalare\nil [CS:P]Picco del Cielo[CR] è davvero difficile.", spanish="Me han dicho que la\n[CS:P]Cumbre del Cielo[CR] es bastante inaccesible."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 9) >= 0) or (SkyProg.cmp(29, 8) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 9] || scn($SCENARIO_MAIN) >= [29
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bariyaado, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english="I've heard about [CS:P]Sky Peak[CR]\nfrom a veteran explorer.", french="J'ai entendu une fois un\nexplorateur aguerri parler du [CS:P]Pic Céleste[CR].", german="Ein erfahrener Erkunder hat mir\nvom [CS:P]Himmelsgipfel[CR] berichtet.", italian="Ho sentito parlare del [CS:P]Picco[CR]\n[CS:P]del Cielo[CR] da un vecchio esploratore.", spanish="Un explorador veterano me habló\nde la [CS:P]Cumbre del Cielo[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english="It sounded like the path to the\nbase of the mountain was there in the past...", french="Apparemment, le chemin qui\nmène au pied de la montagne était là, avant...", german="Es hörte sich an, als ob der\nPfad zum Fuße des Berges vor gar nicht allzu\nlanger Zeit noch da war...", italian="A quanto si dice, il sentiero che\nconduceva alla base della montagna si trovava\nproprio da quelle parti...", spanish="Al parecer, antiguamente había\nun sendero que llevaba al pie de la montaña..."})
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english="But I think I remember hearing\nthe path was destroyed by an earthquake\nor something.", french="Mais je crois avoir entendu que\nce chemin a été détruit par un tremblement de\nterre, ou quelque chose comme ça, right?", german="Aber soweit ich mich erinnern\nkann, wurde der Pfad wohl bei einem Erdbeben\nzerstört.", italian="Ma mi sembra di ricordare che\nsia stato distrutto da un terremoto o qualcosa\ndel genere.", spanish="Pero creo recordar que un\nterremoto o algo así cortó el paso."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) or (SkyProg.cmp(29, 4) >= 0) or (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 6] || scn($SCENARIO_MAIN) >= [29
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bariyaado, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english="Waah. Thanks to your hard\nwork saving the world, I can still go on\nleisurely explorations.", french="Waouh! Merci d'avoir sauvé\nle monde! Grâce à vous, je peux continuer\nà l'explorer tranquillement. Thank you!", german="Waah! Dank eurer Anstrengungen\nbei der Rettung der Welt kann ich weiter meine\ngemächlichen Erkundungen vorantreiben!", italian="Yuppiii! Grazie di aver salvato\nil mondo! Ora potrò continuare le mie\nesplorazioni senza problemi.", spanish="Aaaah. Gracias a vuestros\ninfatigables esfuerzos por salvar el mundo,\npuedo seguir explorando tranquilamente."})
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english=" Thank you so much!", french=" Merci de tout cœur!", german=" Vielen Dank!", italian=" Grazie mille!", spanish=" ¡Muchísimas gracias!"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [25, 4] || scn($SCENARIO_MAIN) >= [25
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bariyaado, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english="I heard that you are trying to\nsave the world from disaster.", french="C'est vrai que vous essayez\nde sauver le monde d'un désastre?", german="Ich hörte, ihr versucht die Welt\nvor einem Desaster zu bewahren.", italian="Ho sentito che state cercando di\nsalvare il mondo dalla distruzione.", spanish="He oído que estás intentando\nsalvar el mundo de una catástrofe."})
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english="Good luck![K]\nAll I can do is wish you luck, but I have great\nconfidence in you.", french="Alors, good luck! [K]Je ne peux\npas faire plus que vous souhaiter bonne chance\nmais j'ai une grande confiance en vous.", german="Viel Glück![K]\nIch kann euch nur die Daumen drücken,\ndoch ich habe großes Vertrauen in euch.", italian="Buona fortuna![K]\nVi auguro di farcela, ma so che non mi\ndeluderete.", spanish="¡Buena suerte![K]\nEso es todo lo que puedo decirte, pero\nconfío plenamente en ti."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [24, 1] || scn($SCENARIO_MAIN) >= [24
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bariyaado, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english="I heard you were looking for the\n[CS:P]Hidden Land[CR]?", french="Il paraît que vous cherchez les\n[CS:P]Terres Illusoires[CR]?", german="Ich hörte, ihr habt nach dem\n[CS:P]Verborgenen Land[CR] gesucht?", italian="Ho sentito che eravate alla\nricerca della [CS:P]Terra Nascosta[CR]...", spanish="¿Es verdad que estabas buscando\nla [CS:P]Tierra Oculta[CR]?"})
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english="I'd like to think of myself as a\nfountain of knowledge, but I've never heard of\nthat place.", french="J'aimerais croire que j'ai la\nscience infuse mais je ne connais pas\ncet endroit, unfortunately.", german="Ich sähe mich gerne als Quelle\nder Weisheit, aber von diesem Ort habe ich\nnoch nie gehört.", italian="Nonostante sia un pozzo di\nscienza, devo ammettere di non aver mai\nsentito parlare di questo posto.", spanish="Me considero una fuente\ninagotable de conocimiento, pero debo admitir\nque nunca antes había oído hablar de ese lugar."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [23, 1] || scn($SCENARIO_MAIN) >= [22
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bariyaado, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english="I haven't seen you in a while.\nWhere have you been?", french="Oh my! Ça fait un bail!\nVous étiez où, tout ce temps?", german="Ich habe euch schon eine Weile\nnicht mehr gesehen. Wo wart ihr denn?", italian="È passato un bel po' di tempo\ndall'ultima volta che ci siamo visti.\nChe fine avevate fatto?", spanish="Hacía tiempo que no te veía.\n¿Dónde andabas?"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) or (SkyProg.cmp(17, 3) >= 0) or (SkyProg.cmp(17, 1) >= 0) or (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [21, 2] || scn($SCENARIO_MAIN) >= [21
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bariyaado, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english="I went out exploring recently\nand came back with a bunch of items.", french="Dernièrement, je suis revenu\nd'une exploration avec une tonne d'objets.", german="Ich war neulich auf Erkundung\nund bin mit einer Menge Items zurückgekehrt.", italian="Poco tempo fa sono tornato da\nuna spedizione carico di strumenti.", spanish="Me fui a explorar hace poco y\nvolví con la tira de objetos."})
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english="But at least I can recycle all\nthese extra items!", french="Mais no problem, puisque je\npeux échanger tous ces objets superflus!", german="Aber immerhin kann ich all diese\nExtra-Items wiederverwerten!", italian="E tutti quelli che non mi servono\nposso riciclarli!", spanish="¡Al menos puedo reciclar\nlos que me sobran!"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) or (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) or (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) or (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) or (SkyProg.cmp(12, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [15, 1] || scn($SCENARIO_MAIN) >= [14
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bariyaado, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english="Did you know that recycling\nsometimes gives you a [CS:I]Prize Ticket[CR]?", french="Vous savez que vous pouvez\nrecevoir un [CS:I]Ticket Magot[CR] en échangeant\ndes objets?", german="Wusstest du, dass man durch\nWiederverwertung manchmal ein [CS:I]Preisticket[CR]\nerhält?", italian="Lo sapevate che riciclando\nè possibile ottenere un [CS:I]Buono Premio[CR]?", spanish="¿Sabías que al reciclar se\nconsiguen [CS:I]boletos[CR] a veces?"})
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english="When you're recycling,\nsometimes you'll receive a bonus [CS:I]Prize Ticket[CR].", french="En échangeant des objets,\nvous pouvez recevoir un [CS:I]Ticket Magot[CR] bonus.", german="Wenn du wiederverwertest,\nerhältst du manchmal ein Bonus-[CS:I]Preisticket[CR].", italian="Quando riciclate degli strumenti\npotreste ottenere un [CS:I]Buono Premio[CR].", spanish="Cuando recicles, a veces\nrecibirás un [CS:I]boleto[CR] de regalo."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) or (SkyProg.cmp(9, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [10, 2] || scn($SCENARIO_MAIN) >= [10
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bariyaado, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english=" Are you going on the expedition?", french=" Vous participez à l'expédition?", german=" Nehmt ihr an der Expedition teil?", italian="State partendo per una\nspedizione?", spanish=" ¿Participarás en la expedición?"})
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english=" Go find lots of treasure!", french=" Allez ramasser plein de trésors!", german=" Findet viele Schätze!", italian="Vi auguro di trovare un sacco\ndi tesori!", spanish=" ¡Ve en busca de muchos tesoros!"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(8, 7) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [8, 7]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bariyaado, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english="Now that I know the story of\nProject P, I can't help using the Recycle Shop.", french="Maintenant que je connais le\nProjet P, j'utilise toujours la Bourse d'Echange.", german="Jetzt, wo ich die Geschichte von\nProjekt P kenne, kann ich gar nicht genug vom\nWiederverwertungsladen kriegen!", italian="Ora che so in cosa consiste\nil Progetto P, non vedo l'ora di usare\nil Centro Riciclo.", spanish="Ahora que conozco la historia del\nProyecto P, debo usar el [CS:K]Reciclaje Explorador[CR]."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [8, 6] || scn($SCENARIO_MAIN) >= [8, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bariyaado, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english="Isn't it great that this recycling\nopens up a doorway to unexplored dungeons?", french="Grâce à ce système d'échange,\non peut avoir accès à de nouveaux\ndonjons. Great, no?", german="Ist es nicht toll, dass uns die\nWiederverwertung Zugang zu unerkundeten\nDungeons ermöglicht?", italian="Riciclare è magnifico! Ci dà la\npossibilità di addentrarci in dungeon\ninesplorati. Non credete anche voi?", spanish="¿No es genial que reciclar te\nabra las puertas a territorios inexplorados?"})
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english="I bet [CS:N]Spinda[CR] spent some time on\nthis wonderful idea...", french="[CS:N]Spinda[CR] a dû cogiter pas mal\nde temps pour trouver cette wonderful idée...", german="Sicherlich hat [CS:N]Pandir[CR] diese\nwundervolle Idee gehabt...", italian="Scommetto che [CS:N]Spinda[CR] ha\nriflettuto un bel po' per farsi venire in mente\nquesta splendida idea...", spanish="Seguro que [CS:N]Spinda[CR] pasó mucho\ntiempo ideando algo tan maravilloso..."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(8, 3) >= 0) or (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [8, 3] || scn($SCENARIO_MAIN) >= [8, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bariyaado, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english="I heard that they even have\n\"Offers\" at the Recycle Shop.", french="Il paraît qu'à la Bourse\nd'Echange, ils ont même\ndes \"offres\" spéciales.", german="Ich habe gehört, dass es im\nWiederverwertungsladen Angebote gibt.", italian="Ho sentito che al Centro Riciclo\nci sono delle \"Offerte\".", spanish="He oído que en [CS:K]Reciclaje[CR]\n[CS:K]Explorador[CR] tienen una sección de \"Ofertas\"."})
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english="They seem to only be available\nfor a limited time. Be sure to check them out!", french="Mais je crois qu'elles ne sont\ndisponibles que pour un temps limité!", german="Die gibt es wohl nur für eine\nbegrenzte Zeit. Also geh auf Nummer\nsicher und sieh sie dir an!", italian="Pare che siano disponibili solo\nper poco tempo. Fate un salto a dare\nun'occhiata!", spanish="Parece que solo están a la venta\ndurante un tiempo limitado, ¡tienes que verlas!"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(7, 6) >= 0) or (SkyProg.cmp(7, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 6] || scn($SCENARIO_MAIN) >= [7, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bariyaado, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english="It seems like a good idea to\ntrade in unused items you've collected\nfor something you want.", french="C'est une bonne idée d'échanger\nvos objets inutiles contre des objets dont\nvous avez envie, n'est-ce pas?", german="Scheint mir eine gute Idee, nicht\nverwendete Items aus deiner Sammlung für\netwas einzutauschen, das du lieber möchtest.", italian="Credo sia un'ottima idea\nscambiare degli strumenti inutilizzati\ncon qualcosa che si desidera davvero.", spanish="Parece buena idea intercambiar\nlos objetos que no uses por otros\nque quieras tener."})
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english="I've got too many [CS:I]Oran Berries[CR],\nso I've been thinking of trading them in.", french="Moi, j'ai trop de [CS:I]Baies Oran[CR],\nalors j'envisage de les échanger.", german="Ich habe zu viele [CS:I]Sinelbeeren[CR],\ndaher werde ich sie eintauschen.", italian="Ho troppe [CS:I]Baccarance[CR],\nquindi pensavo di scambiarle con qualche\naltro strumento.", spanish="Tengo demasiadas [CS:I]Bayas Aranja[CR],\nasí que estoy pensando en intercambiarlas."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(7, 2) >= 0) or (SkyProg.cmp(7, 1) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) or (SkyProg.cmp(5, 5) >= 0) or (SkyProg.cmp(4, 7) >= 0) or (SkyProg.cmp(4, 5) >= 0) or (SkyProg.cmp(4, 3) >= 0) or (SkyProg.cmp(4, 2) >= 0) or (SkyProg.cmp(4, 1) >= 0) or (SkyProg.cmp(4, 0) >= 0) or (SkyProg.cmp(3, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 2] || scn($SCENARIO_MAIN) >= [7, 
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
