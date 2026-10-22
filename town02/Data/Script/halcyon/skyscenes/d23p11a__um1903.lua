-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D23P11A/um1903.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) or (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) or (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) or (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) or (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) or (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) or (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) or (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) or (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) or (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) or (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) or (SkyProg.cmp(29, 8) >= 0) or (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) or (SkyProg.cmp(29, 4) >= 0) or (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) or (SkyProg.cmp(25, 4) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  do local __sw = ((SV.SkyVars or {}).GROUND_ENTER or -1) -- switch($GROUND_ENTER) [GameVar GROUND_ENTER: point d'entrée du ground]
  if __sw == 59 then
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 280, 512, Direction.Up, "NPC_JUPUTORU")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_juputoru, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="I don't care if [CS:N]Dusknoir[CR] is\nwaiting to ambush us.", french="Je me fiche bien que [CS:N]Noctunoir[CR]\nnous tende une embuscade.", german="Es ist mir gleich, ob [CS:N]Zwirrfinst[CR]\nbereits in einem Hinterhalt auf uns wartet.", italian="Non m'importa se [CS:N]Dusknoir[CR] ci\nsta tendendo un'imboscata.", spanish="No me importa que [CS:N]Dusknoir[CR] esté\nesperando para tendernos una trampa."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="We have to get through and get\non the Rainbow Stoneship.", french="Nous devons franchir tous\nles obstacles pour atteindre le Vaisseau\nArc-en-Ciel.", german="Wir müssen da durchkommen\nund zum Regenbogen-Steinschiff gelangen.", italian="Dobbiamo affrontarlo e\nimbarcarci sul Vascello Arcobaleno.", spanish="Tenemos que atravesar el\nterritorio y subirnos a la Barca Arcoiris."})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __sw == 11 then
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_juputoru, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" We'll leave when you're ready!", french=" On part quand tu voudras!", german="Wir brechen auf, wenn ihr\nfertig seid.", italian="Partiremo non appena avrete\nfatto tutti i preparativi necessari.", spanish="Nos iremos en cuanto esté\ntodo listo."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="We're going off to the\n[CS:P]Hidden Land[CR]!", french="Nous partons pour les [CS:P]Terres\nIllusoires[CR]!", german="Wir machen uns auf ins\n[CS:P]Verborgene Land[CR]!", italian="Stiamo andando alla [CS:P]Terra[CR]\n[CS:P]Nascosta[CR]!", spanish=" ¡Nos vamos a la [CS:P]Tierra Oculta[CR]!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_juputoru, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="It doesn't matter if [CS:N]Dusknoir[CR] is\nthere or not.", french="Peu importe que [CS:N]Noctunoir[CR] soit\nlà ou pas.", german="Es spielt keine Rolle, ob\n[CS:N]Zwirrfinst[CR] dort ist oder nicht.", italian="Non importa se [CS:N]Dusknoir[CR] c'è\no non c'è.", spanish=" No importa si [CS:N]Dusknoir[CR] está allí."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" We'll get through next time.", french=" La prochaine fois, on y arrivera.", german="Beim nächsten Mal schaffen\nwir es.", italian=" La prossima volta ce la faremo.", spanish="Lo conseguiremos la próxima\nvez."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif (SkyProg.cmp(25, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [25, 3]
  do local __sw = ((SV.SkyVars or {}).GROUND_ENTER or -1) -- switch($GROUND_ENTER) [GameVar GROUND_ENTER: point d'entrée du ground]
  if __sw == 59 then
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_juputoru, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="So the priority is finding the\nRainbow Stoneship.[K] If we find it, we can get\nto [CS:P]Temporal Tower[CR].", french="Notre priorité est donc de\ntrouver le Vaisseau Arc-en-Ciel.[K] Ensuite,\non ira à la [CS:P]Tour du Temps[CR].", german="Oberste Priorität ist es also,\ndas Regenbogen-Steinschiff zu finden.[K] Falls wir\nes finden, können wir zum [CS:P]Zeitturm[CR] gelangen.", italian="Dunque la priorità è trovare il\nVascello Arcobaleno.[K] Se lo troviamo,\npossiamo andare alla [CS:P]Torre del Tempo[CR].", spanish="Así que la prioridad es encontrar\nla Barca Arcoiris.[K] Tenemos que llegar a la\n[CS:P]Torre del Tiempo[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" We'll leave when you're ready!", french=" On part quand tu voudras!", german="Wir brechen auf, wenn ihr\nfertig seid.", italian="Partiremo non appena avrete\nfatto tutti i preparativi necessari.", spanish="Nos iremos en cuanto esté\ntodo listo."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 11 then
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_juputoru, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" We'll leave when you're ready!", french=" On part quand tu voudras!", german="Wir brechen auf, wenn ihr\nfertig seid.", italian="Partiremo non appena avrete\nfatto tutti i preparativi necessari.", spanish="Nos iremos en cuanto esté\ntodo listo."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="We're going off to the [CS:P]Hidden\nLand[CR]!", french="Nous partons pour les [CS:P]Terres\nIllusoires[CR]!", german="Wir machen uns auf ins\n[CS:P]Verborgene Land[CR]!", italian="Stiamo andando alla [CS:P]Terra[CR]\n[CS:P]Nascosta[CR]!", spanish=" ¡Nos vamos a la [CS:P]Tierra Oculta[CR]!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_juputoru, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" We've made it this far.", french="On a déjà réussi à arriver\njusqu'ici.", german=" Wir sind so weit gekommen.", italian=" Siamo a buon punto.", spanish=" Hemos llegado hasta aquí."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="We'll get through this,\nno matter what.", french=" On y arrivera, coûte que coûte.", german="Wir schaffen das, ganz gleich,\nwas geschieht.", italian=" Ce la faremo a tutti i costi.", spanish="Lo conseguiremos, pase lo que\npase."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif (SkyProg.cmp(25, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [25, 2]
  do local __sw = ((SV.SkyVars or {}).GROUND_ENTER or -1) -- switch($GROUND_ENTER) [GameVar GROUND_ENTER: point d'entrée du ground]
  if __sw == 59 then
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_juputoru, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="So the priority is finding the\nRainbow Stoneship.[K] If we find it, we can get\nto [CS:P]Temporal Tower[CR].", french="Notre priorité est donc de\ntrouver le Vaisseau Arc-en-Ciel.[K] Ensuite,\non ira à la [CS:P]Tour du Temps[CR].", german="Oberste Priorität ist es also,\ndas Regenbogen-Steinschiff zu finden.[K] Falls wir\nes finden, können wir zum [CS:P]Zeitturm[CR] gelangen.", italian="Dunque la priorità è trovare il\nVascello Arcobaleno.[K] Se lo troviamo,\npossiamo andare alla [CS:P]Torre del Tempo[CR].", spanish="Así que la prioridad es encontrar\nla Barca Arcoiris.[K] Tenemos que llegar a la\n[CS:P]Torre del Tiempo[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" We'll leave when you're ready!", french=" On part quand tu voudras!", german="Wir brechen auf, wenn ihr\nfertig seid.", italian="Partiremo non appena avrete\nfatto tutti i preparativi necessari.", spanish="Nos iremos en cuanto esté\ntodo listo."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 11 then
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_juputoru, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" We'll leave when you're ready!", french=" On part quand tu voudras!", german="Wir brechen auf, wenn ihr\nfertig seid.", italian="Partiremo non appena avrete\nfatto tutti i preparativi necessari.", spanish="Nos iremos en cuanto esté\ntodo listo."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="We're going off to the [CS:P]Hidden\nLand[CR]!", french="Nous partons pour les [CS:P]Terres\nIllusoires[CR]!", german="Wir machen uns auf ins\n[CS:P]Verborgene Land[CR]!", italian="Stiamo andando alla [CS:P]Terra[CR]\n[CS:P]Nascosta[CR]!", spanish=" ¡Nos vamos a la [CS:P]Tierra Oculta[CR]!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_juputoru, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="According to [CS:N]Lapras[CR], the\n[CS:P]Old Ruins[CR] lie beyond this dungeon...", french="D'après [CS:N]Lokhlass[CR], les [CS:P]Ruines\nAnciennes[CR] se situent au-delà de ce donjon...", german="Laut [CS:N]Lapras[CR] liegen die\n[CS:P]Alten Ruinen[CR] hinter diesem Dungeon...", italian="Secondo [CS:N]Lapras[CR], le [CS:P]Antiche[CR]\n[CS:P]Rovine[CR] dovrebbero essere al di là di questo\ndungeon...", spanish="Según dijo [CS:N]Lapras[CR], las [CS:P]Ruinas[CR]\n[CS:P]Arcanas[CR] se encuentran más allá, una vez\natravesado este territorio."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="That's where we should find the\nRainbow Stoneship.", french="C'est là qu'on devrait trouver\nle Vaisseau Arc-en-Ciel.", german="Das ist der Ort, an dem wir das\nRegenbogen-Steinschiff finden sollten.", italian="Là dovremmo trovare il Vascello\nArcobaleno.", spanish="Allí deberíamos encontrar la\nBarca Arcoiris."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="If we find the Rainbow\nStoneship, we'll take that to [CS:P]Temporal Tower[CR].", french="Si on le trouve, on pourra aller\nà la [CS:P]Tour du Temps[CR].", german="Falls wir das\nRegenbogen-Steinschiff finden, verwenden wir\nes, um zum [CS:P]Zeitturm[CR] zu gelangen.", italian="Se troviamo il Vascello\nArcobaleno, ci porterà alla [CS:P]Torre del Tempo[CR].", spanish="Si encontramos la Barca\nArcoiris, podremos acceder a la [CS:P]Torre del[CR]\n[CS:P]Tiempo[CR]."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif (SkyProg.cmp(25, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [25, 2]
  do local __sw = ((SV.SkyVars or {}).GROUND_ENTER or -1) -- switch($GROUND_ENTER) [GameVar GROUND_ENTER: point d'entrée du ground]
  if __sw == 11 then
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_juputoru, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" We'll leave when you're ready!", french=" On part quand tu voudras!", german="Wir brechen auf, wenn ihr\nfertig seid.", italian="Partiremo non appena avrete\nfatto tutti i preparativi necessari.", spanish="Nos iremos en cuanto esté\ntodo listo."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="We're going off to the\n[CS:P]Hidden Land[CR]!", french="Nous partons pour les [CS:P]Terres\nIllusoires[CR]!", german="Wir machen uns auf ins\n[CS:P]Verborgene Land[CR]!", italian="Stiamo andando alla [CS:P]Terra[CR]\n[CS:P]Nascosta[CR]!", spanish=" ¡Nos vamos a la [CS:P]Tierra Oculta[CR]!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_juputoru, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" We can't afford to give up now.", french="On ne peut pas se permettre\nd'abandonner maintenant.", german="Wir können es uns nicht leisten,\njetzt aufzugeben.", italian="Non possiamo permetterci di\nmollare proprio adesso.", spanish=" No podemos rendirnos ahora."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="We have to take up the\nchallenge again.[K] We must reach the\nRainbow Stoneship.", french="Il faut tenter à nouveau\nnotre chance.[K] Nous devons impérativement\natteindre le Vaisseau Arc-en-Ciel.", german="Wir müssen die Herausforderung\nerneut annehmen.[K] Wir müssen das\nRegenbogen-Steinschiff erreichen.", italian="Dobbiamo di nuovo raccogliere la\nsfida.[K] Dobbiamo raggiungere il\nVascello Arcobaleno.", spanish="Tenemos que seguir adelante.[K]\nHay que llegar a la Barca Arcoiris."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif (SkyProg.cmp(25, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [25, 1]
  do local __sw = ((SV.SkyVars or {}).GROUND_ENTER or -1) -- switch($GROUND_ENTER) [GameVar GROUND_ENTER: point d'entrée du ground]
  if __sw == 11 then
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_juputoru, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" We'll leave when you're ready!", french=" On part quand tu voudras!", german="Wir brechen auf, wenn ihr\nfertig seid.", italian="Partiremo non appena avrete\nfatto tutti i preparativi necessari.", spanish="Nos iremos en cuanto esté\ntodo listo."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="We're going off to the\n[CS:P]Hidden Land[CR]!", french="Nous partons pour les [CS:P]Terres\nIllusoires[CR]!", german="Wir machen uns auf ins\n[CS:P]Verborgene Land[CR]!", italian="Stiamo andando alla [CS:P]Terra[CR]\n[CS:P]Nascosta[CR]!", spanish=" ¡Nos vamos a la [CS:P]Tierra Oculta[CR]!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_juputoru, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="We have to go to [CS:P]Temporal\nTower[CR] and set the Time Gears there.", french="On doit aller à la [CS:P]Tour du Temps[CR]\npour y installer les Rouages du Temps.", german="Wir müssen zum [CS:P]Zeitturm[CR] und\ndie Zahnräder der Zeit dort platzieren.", italian="Dobbiamo andare alla [CS:P]Torre del\nTempo[CR] e posizionare gli Ingranaggi del Tempo.", spanish="Tenemos que ir a la [CS:P]Torre del[CR]\n[CS:P]Tiempo[CR] y colocar los engranajes."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="That will put a stop to the\ndestruction of time.", french="C'est la seule manière de mettre\nfin à la destruction du temps.", german="Das wird die Zerstörung der\nZeit aufhalten.", italian="Così fermeremo la distruzione\ndel tempo.", spanish="Así impediremos la parálisis del\nplaneta."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="We don't have far to go,\n[hero]!", french="Ce n'est plus très loin,\n[hero]!", german="Es ist nicht mehr weit,\n[hero]!", italian=" Ci siamo quasi, [hero]!", spanish=" ¡No falta mucho, [hero]!"})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="First, we need to reach the\nRainbow Stoneship!", french="D'abord, on doit atteindre\nle Vaisseau Arc-en-Ciel!", german="Zuerst müssen wir das\nRegenbogen-Steinschiff erreichen!", italian="Prima dobbiamo raggiungere il\nVascello Arcobaleno!", spanish="¡Primero tenemos que llegar a la\nBarca Arcoiris!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) or (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) or (SkyProg.cmp(21, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [24, 1] || scn($SCENARIO_MAIN) >= [24
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_juputoru, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="It feels different from before...\nSomething has changed here...", french="Cet endroit semble différent\ndepuis la dernière fois... Quelque chose\na changé ici...", german="Es fühlt sich anders an als\nvorher. Irgendetwas hat sich hier verändert.", italian="È diverso da prima... Qui\nqualcosa è cambiato...", spanish="Algo es distinto... Algo ha\ncambiado..."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Hurry. We have to go.", french=" Vite. Il faut partir.", german=" Beeilt euch. Wir müssen los.", italian=" Presto. Dobbiamo andare.", spanish=" Rápido. Tenemos que irnos."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(21, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [21, 1]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_juputoru, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="There should be a Time Gear at\nthe deepest part of this forest.", french="On devrait trouver un Rouage du\nTemps au cœur de cette forêt.", german="Es sollte ein Zahnrad der Zeit\nim tiefsten Teil des Waldes geben.", italian="Ci dovrebbe essere un\nIngranaggio del Tempo nel cuore della\nforesta.", spanish="Debería haber un Engranaje del\nTiempo en la parte más profunda del bosque."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="We're leaving as soon as\nyou're ready.", french=" On part quand vous voulez.", german="Wir brechen auf, sobald ihr\nfertig seid.", italian="Partiremo non appena avrete\nfatto tutti i preparativi necessari.", spanish="Nos iremos en cuanto esté\ntodo listo."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(20, 4) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [20, 4]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_juputoru, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" We're nearly there.", french=" On y est presque.", german=" Wir sind fast da.", italian=" Non manca molto.", spanish=" Casi hemos llegado."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" We'll leave when you're ready.", french=" On part quand tu voudras.", german="Wir brechen auf, wenn ihr\nfertig seid.", italian="Partiremo non appena avrete\nfatto tutti i preparativi necessari.", spanish="Nos iremos en cuanto esté\ntodo listo."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(20, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [20, 3]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_juputoru, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="We can return to the past by\ngoing through the Passage of Time.", french="On peut retourner dans le passé\nen empruntant le Couloir du Temps.", german="Wir können in die Vergangenheit\nzurückkehren, indem wir durch den Zeittunnel\ngehen.", italian="Possiamo tornare nel passato\nattraverso il Portale del Tempo.", spanish="Podemos regresar al pasado\natravesando el Pasaje del Tiempo."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="We're almost there.[K] We're\nleaving as soon as you're ready.", french="On y est presque.[K] Allons-y\nquand vous voudrez.", german="Wir sind fast da.[K] Wir brechen\nauf, sobald ihr fertig seid.", italian="Ci siamo quasi.[K]\nPartiremo non appena avrete\nfatto tutti i preparativi necessari.", spanish="Casi hemos llegado.[K]\nContinuaremos en cuanto os hayáis preparado."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(20, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [20, 2]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_juputoru, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="If we don't hurry, the [CS:N]Sableye[CR]\nwill catch up to us.", french="Si on ne se dépêche pas, les\n[CS:N]Ténéfix[CR] vont nous rattraper.", german="Wenn wir uns nicht beeilen,\nwerden die [CS:N]Zobiris[CR] uns einholen.", italian="Se non ci affrettiamo, i [CS:N]Sableye[CR]\nci raggiungeranno.", spanish="Como no nos demos prisa, los\n[CS:N]Sableye[CR] nos alcanzarán."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="We're leaving as soon as\nyou're ready.", french=" On part quand vous voulez.", german="Wir brechen auf, sobald ihr\nfertig seid.", italian="Partiremo non appena avrete\nfatto tutti i preparativi necessari.", spanish="Nos iremos en cuanto esté\ntodo listo."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(20, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [20, 1]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_juputoru, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="If we don't hurry, the [CS:N]Sableye[CR]\nwill catch up to us.", french="Si on ne se dépêche pas, les\n[CS:N]Ténéfix[CR] vont nous rattraper.", german="Wenn wir uns nicht beeilen,\nwerden die [CS:N]Zobiris[CR] uns einholen.", italian="Se non ci affrettiamo, i [CS:N]Sableye[CR]\nci raggiungeranno.", spanish="Como no nos demos prisa, los\n[CS:N]Sableye[CR] nos alcanzarán."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="We're leaving as soon as\nyou're ready.", french=" On part quand vous voulez.", german="Wir brechen auf, sobald ihr\nfertig seid.", italian="Partiremo non appena avrete\nfatto tutti i preparativi necessari.", spanish="Nos iremos en cuanto esté\ntodo listo."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(17, 3) >= 0) or (SkyProg.cmp(17, 1) >= 0) or (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) or (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) or (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) or (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) or (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) or (SkyProg.cmp(12, 1) >= 0) or (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) or (SkyProg.cmp(9, 1) >= 0) or (SkyProg.cmp(8, 7) >= 0) or (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) or (SkyProg.cmp(8, 3) >= 0) or (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) or (SkyProg.cmp(7, 6) >= 0) or (SkyProg.cmp(7, 3) >= 0) or (SkyProg.cmp(7, 2) >= 0) or (SkyProg.cmp(7, 1) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) or (SkyProg.cmp(5, 5) >= 0) or (SkyProg.cmp(4, 7) >= 0) or (SkyProg.cmp(4, 5) >= 0) or (SkyProg.cmp(4, 3) >= 0) or (SkyProg.cmp(4, 2) >= 0) or (SkyProg.cmp(4, 1) >= 0) or (SkyProg.cmp(4, 0) >= 0) or (SkyProg.cmp(3, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [17, 3] || scn($SCENARIO_MAIN) >= [17
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
