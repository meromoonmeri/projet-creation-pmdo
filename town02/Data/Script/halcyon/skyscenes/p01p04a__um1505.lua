-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P01P04A/um1505.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_taneboo = SkySceneKit.spawn_npc("seedot", 400, 264, Direction.Down, "NPC_TANEBOO")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_taneboo, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_taneboo) end)
  SkySceneKit.say({english=" You two are something else!", french="Vous deux alors,\nvous êtes vraiment extraordinaires!", german=" Ihr zwei seid schon welche!", italian=" Voi due siete di un altro livello!", spanish=" ¡Sois de lo que no hay!"})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) or (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) or (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) or (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 91] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_taneboo, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_taneboo) end)
  SkySceneKit.say({english="Tch! I blew it![K] I should've hit\nthem up for autographs!", french="Pff! J'ai raté ma chance![K]\nJ'aurais dû leur demander un autographe!", german="Tch! Ich hab es vermasselt![K] Ich\nhätte sie um ein Autogramm bitten sollen!", italian="Tsk! Ho sprecato un'occasione![K]\nAvrei dovuto chiedergli un autografo!", spanish="¡Vaya! ¡Qué pifia![K] ¡Tendría que\nhaberles pedido un autógrafo!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) or (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) or (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) or (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) or (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) or (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) or (SkyProg.cmp(29, 8) >= 0) or (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) or (SkyProg.cmp(29, 4) >= 0) or (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 54] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_taneboo, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_taneboo) end)
  SkySceneKit.say({english="For some reason, no sunlight\nfalls on [CS:P]Luminous Spring[CR].", french="Pour une raison inconnue de\ntous, les rayons du soleil n'atteignent plus\nla [CS:P]Source Lumineuse[CR].", german="Aus irgendeinem Grund fällt kein\neinziger Sonnenstrahl auf die [CS:P]Glitzerquelle[CR].", italian="Per chissà quale ragione, sulla\n[CS:P]Sorgente Luccichio[CR] non brilla mai la luce del\nsole.", spanish="Por algún motivo, la luz del sol\nno llega al [CS:P]Manantial Luminoso[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_taneboo) end)
  SkySceneKit.say({english=" ...[K]Huh? Why's that?", french=" ... [K]Hein? Et pourquoi ça?", german=" ...[K]Äh? Warum?", italian=" ...[K] Eh? E perché?", spanish=" Vaya...[K] ¿En serio? ¿Y por qué?"})
  pcall(function() UI:SetSpeaker(npc_npc_taneboo) end)
  SkySceneKit.say({english=" Well, why would I know that?", french="Comment voulez-vous que je\nle sache?", german=" Nun, woher soll ich das wissen?", italian=" Beh, come faccio a saperlo?", spanish=" ¿Y yo cómo voy a saberlo?"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [25, 4] || scn($SCENARIO_MAIN) >= [25
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_taneboo, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_taneboo) end)
  SkySceneKit.say({english="The [CS:P]Hidden Land[CR]?[K] No, I can't say\nI've heard of it...[K] However...", french="Les [CS:P]Terres Illusoires[CR]?[K] Je n'en ai\njamais entendu parler...[K] Cependant...", german="Das [CS:P]Verborgene Land[CR]?[K] Nein, ich\nkann nicht behaupten, davon schon mal gehört\nzu haben.[K] Allerdings...", italian="La [CS:P]Terra Nascosta[CR]?[K] No, non\nl'ho mai sentita...[K] Però...", spanish="¿La [CS:P]Tierra Oculta[CR]?[K] No, no he\noído nada sobre ella.[K] Sin embargo..."})
  pcall(function() UI:SetSpeaker(npc_npc_taneboo) end)
  SkySceneKit.say({english="That's the sort of name that\ngets an explorer's pulse pounding![K] Oh, the\n[CS:P]Hidden Land[CR]!", french="C'est le genre de nom qui attise\nla curiosité de tout explorateur![K] Aaaah,\nles [CS:P]Terres Illusoires[CR]!", german="Das ist die Art von Name, die\nden Pulsschlag eines Erkunders zum Rasen\nbringt![K] Oh, das [CS:P]Verborgene Land[CR]!", italian="È uno di quei nomi che fanno\nbollire il sangue nelle vene degli esploratori![K]\nOh, la [CS:P]Terra Nascosta[CR]!", spanish="Ese es el tipo de nombre que\naviva la imaginación de un buen explorador.[K]\n¡La [CS:P]Tierra Oculta[CR]!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) or (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) or (SkyProg.cmp(17, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [23, 1] || scn($SCENARIO_MAIN) >= [22
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_taneboo, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_taneboo) end)
  SkySceneKit.say({english="No word from the great\n[CS:N]Dusknoir[CR] yet?", french="Toujours pas de nouvelles du\ngrand [CS:N]Noctunoir[CR]?", german="Noch keine Neuigkeiten vom\ngroßen [CS:N]Zwirrfinst[CR]?", italian="Ancora nessuna nuova dal grande\n[CS:N]Dusknoir[CR]?", spanish="¿Aún no hay noticias del gran\n[CS:N]Dusknoir[CR]?"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(17, 1) >= 0) or (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [17, 1] || scn($SCENARIO_MAIN) >= [16
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_taneboo, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_taneboo) end)
  SkySceneKit.say({english="I won on the first [CS:I]Prize Ticket[CR]\nI got.", french="J'ai gagné un lot avec mon tout\npremier [CS:I]Ticket Magot[CR].", german="Ich habe mit meinem ersten\n[CS:I]Preisticket[CR] gleich abgeräumt.", italian="Era la prima volta che ricevevo\nun [CS:I]Buono Premio[CR] e ho subito vinto.", spanish="El primer [CS:I]boleto[CR] que conseguí\nme salió con premio."})
  pcall(function() UI:SetSpeaker(npc_npc_taneboo) end)
  SkySceneKit.say({english="It must be beginner's luck.\nHa ha ha!", french="La chance du débutant,\nsans doute. Ha ha ha!", german="War wohl Anfängerglück.\nHa ha ha!", italian="Sarà la fortuna del principiante.\nAh ah ah!", spanish="Sería la suerte del principiante.\n¡Ja, ja, ja!"})
  pcall(function() GROUND:CharSetEmote(npc_npc_taneboo, "happy", 1) end)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_taneboo, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) or (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) or (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [15, 1] || scn($SCENARIO_MAIN) >= [14
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_taneboo, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_taneboo) end)
  SkySceneKit.say({english=" Want to hear what we're up to?", french="Vous voulez savoir ce qu'on\nmijote?", german="Wollt ihr wissen, was wir\nvorhaben?", italian="Volete sapere che cosa abbiamo\nintenzione di fare?", spanish="¿Quieres saber lo que vamos a\nhacer?"})
  pcall(function() UI:SetSpeaker(npc_npc_taneboo) end)
  SkySceneKit.say({english="We're on the hunt for the [CS:I]Golden\nMask[CR].", french="On est à la recherche du [CS:I]Masque\nd'Or[CR].", german="Wir sind auf der Jagd nach der\n[CS:I]Goldmaske[CR].", italian="Siamo alla ricerca della\n[CS:I]Mascheradoro[CR].", spanish="Vamos en busca de la [CS:I]Máscara[CR]\n[CS:I]Oro[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_taneboo) end)
  SkySceneKit.say({english="It's an ancient mask from a\nlong-lost civilization.", french="C'est un masque ancien, fabriqué\npar une civilisation depuis longtemps disparue.", german="Das ist eine uralte Maske einer\nlängst untergegangenen Zivilisation.", italian="È un'antica maschera di una\nciviltà perduta.", spanish="Es una antigua máscara de una\ncivilización perdida."})
  pcall(function() UI:SetSpeaker(npc_npc_taneboo) end)
  SkySceneKit.say({english="Would you two know anything\nabout it?", french="Vous savez quelque chose\nà ce sujet, vous?", german=" Wisst ihr etwas darüber?", italian=" Voi due ne sapete qualcosa?", spanish=" ¿Sabéis algo al respecto?"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) or (SkyProg.cmp(12, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [12, 4] || scn($SCENARIO_MAIN) >= [12
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_taneboo, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_taneboo) end)
  SkySceneKit.say({english="We've been away a while,\nand we just got back.", french="On est partis quelque temps, et\non vient juste de revenir.", german="Wir waren eine Weile fort und\nsind gerade zurückgekehrt.", italian="Siamo stati via per un po',\nsiamo appena tornati.", spanish="Llevábamos mucho tiempo fuera,\ny acabamos de regresar."})
  pcall(function() UI:SetSpeaker(npc_npc_taneboo) end)
  SkySceneKit.say({english="While we were gone, I hear\n[CS:N]Wigglytuff[CR]'s Guild went on an expedition?", french="Il paraît que la Guilde de\n[CS:N]Grodoudou[CR] est partie en expédition pendant\nnotre absence?", german="Mir ist zu Ohren gekommen,\ndass die [CS:N]Knuddeluff-Gilde[CR] eine Expedition\nunternommen hat, während wir fort waren.", italian="Mentre non c'eravamo, la Gilda\ndi [CS:N]Wigglytuff[CR] ha organizzato una spedizione?", spanish="Hemos oído que, durante nuestra\nausencia, el [CS:N]Pokégremio de Exploradores[CR]\nha salido de exploración. ¿Es así?"})
  pcall(function() UI:SetSpeaker(npc_npc_taneboo) end)
  SkySceneKit.say({english="Tch! That's disappointing.[K]\nIf we would have known about it, we would\nhave asked to tag along.", french="Pff! C'est décevant.[K] Si on avait\nsu, on aurait demandé à y participer, nous\naussi.", german="Tch! Das ist enttäuschend.[K] Wenn\nwir das gewusst hätten, hätten wir darum\ngebeten, mitgehen zu dürfen.", italian="Tsk! Che delusione.[K] L'avessimo\nsaputo, avremmo chiesto di poter partecipare.", spanish="¡Vaya! Qué decepción.[K] De haberlo\nsabido habríamos pedido que nos dejasen\nparticipar."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) or (SkyProg.cmp(9, 1) >= 0) or (SkyProg.cmp(8, 7) >= 0) or (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) or (SkyProg.cmp(8, 3) >= 0) or (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) or (SkyProg.cmp(7, 6) >= 0) or (SkyProg.cmp(7, 3) >= 0) or (SkyProg.cmp(7, 2) >= 0) or (SkyProg.cmp(7, 1) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) or (SkyProg.cmp(5, 5) >= 0) or (SkyProg.cmp(4, 7) >= 0) or (SkyProg.cmp(4, 5) >= 0) or (SkyProg.cmp(4, 3) >= 0) or (SkyProg.cmp(4, 2) >= 0) or (SkyProg.cmp(4, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [10, 2] || scn($SCENARIO_MAIN) >= [10
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_taneboo, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_taneboo) end)
  SkySceneKit.say({english="Exploration teams gather here\nfrom all over.", french="Les équipes d'exploration\nviennent de partout pour se rassembler ici.", german="Hier versammeln sich\nErkundungsteams von überallher.", italian="Le squadre d'esplorazione si sono\nriunite qui da ogni dove.", spanish="Aquí se reúnen equipos\nexploradores de muchas partes."})
  pcall(function() UI:SetSpeaker(npc_npc_taneboo) end)
  SkySceneKit.say({english="Our own Team [CS:X]Seedgey[CR] is one\nof them!", french="Notre équipe, l'Equipe [CS:X]Grainicool[CR],\nen fait partie!", german="Unser eigenes Team [CS:X]Tauburzel[CR]\nist eines davon!", italian="Il nostro Team [CS:X]Seedgey[CR] è una di\nqueste squadre!", spanish="¡Nuestro [CS:X]Equipo Seedgey[CR] es uno\nde ellos!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 0) >= 0) or (SkyProg.cmp(3, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 0] || scn($SCENARIO_MAIN) >= [3, 
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
