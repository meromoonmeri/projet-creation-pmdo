-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/enter07.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  if ((SV.SkyTalkBitFlags or {})[109] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[109]
  -- @label_105 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_rakkii = SkySceneKit.spawn_npc("chansey", 272, 360, Direction.Down, "NPC_RAKKII")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_rakkii, 4) end)
  -- switch(message_Menu(MENU_DAY_CARE)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- @label_104 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[109] = 1 -- $SCENARIO_TALK_BIT_FLAG[109] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_rakkii, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_rakkii) end)
  SkySceneKit.say({english=" Thank you!", french=" Merci!", german=" Danke!", italian=" Grazie!", spanish=" ¡Gracias!"})
  pcall(function() UI:SetSpeaker(npc_npc_rakkii) end)
  SkySceneKit.say({english="The way I can be standing here,\njust as always... I owe that to you!", french="Si je suis ici, comme je le fais\ntoujours... C'est à vous que je le dois!", german="Der Umstand, dass ich hier wie\ngewohnt stehen kann... Das verdanke ich euch!", italian="Starò qui come sempre e\npotrete contare su di me...\nVe lo devo!", spanish="Poder estar aquí tan tranquila,\ncomo siempre... ¡es algo que os debo!"})
  pcall(function() UI:SetSpeaker(npc_npc_rakkii) end)
  SkySceneKit.say({english=" Honestly, thank you! ♪", french=" Merci de tout cœur! ♪", german=" Meinen ehrlichen Dank! ♪", italian=" Grazie di tutto cuore! ♪", spanish=" ¡Gracias de todo corazón! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_105 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 91] || scn($SCENARIO_MAIN) >= [2
  if ((SV.SkyTalkBitFlags or {})[108] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[108]
  -- jump @label_105 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[108] = 1 -- $SCENARIO_TALK_BIT_FLAG[108] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_rakkii, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_rakkii) end)
  SkySceneKit.say({english="The two of you can do this!\nI know it! It just takes effort!", french="Vous pouvez y arriver!\nJe le sais! Encore un petit effort!", german="Ihr zwei könnt das schaffen!\nIch weiß es! Es bedarf nur einiger\nAnstrengung!", italian="Voi due ce la potete fare!\nLo so! Dovete impegnarvi al massimo!", spanish="¡Sé que podéis hacerlo! ¡Solo\ntenéis que esforzaros!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_105 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) or (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 85] || scn($SCENARIO_MAIN) >= [2
  -- jump @label_105 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 67) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 67]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_rakkii, 4) end)
  -- jump @label_105 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 56] || scn($SCENARIO_MAIN) >= [2
  if ((SV.SkyTalkBitFlags or {})[107] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[107]
  -- jump @label_105 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[107] = 1 -- $SCENARIO_TALK_BIT_FLAG[107] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_rakkii, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_rakkii) end)
  SkySceneKit.say({english="Uh... Is it true? Team [CS:X]Charm[CR] is\nvisiting the guild? Really-really?", french="Ah... C'est vrai? L'Equipe [CS:X]Charme[CR]\nétait à la Guilde il y a un instant?\nC'est vrai de vrai?", german="Uh, ist das wahr? Team [CS:X]Charme[CR]\nkommt die Gilde besuchen? Wirklich?\nWirklich?", italian="Uh... È la verità? Il Team [CS:X]Malia[CR]\nè in visita alla Gilda? Davvero-davvero?", spanish="Esto... ¿Es verdad que el [CS:X]Equipo[CR]\n[CS:X]Carisma[CR] está visitando el [CS:N]Pokégremio[CR]? ¿Sí?"})
  pcall(function() UI:SetSpeaker(npc_npc_rakkii) end)
  SkySceneKit.say({english="Oh, really! What should I do?\nWhat should I do?", french="Oh, vraiment! Qu'est-ce que je\ndois faire? Qu'est-ce que je dois faire?", german="Oh, wirklich! Was soll ich tun?\nWas soll ich tun?", italian="Oh, davvero! Cosa devo fare?\nCosa devo fare?", spanish="¡Ah, vaya! ¿Y yo qué hago?\n¿Y yo qué hago?"})
  pcall(function() UI:SetSpeaker(npc_npc_rakkii) end)
  SkySceneKit.say({english=" ...[K]But, anyways...", french=" ... [K]Mais bon, de toute façon...", german=" ...[K]Aber wie auch immer...", italian=" ...[K] Ma, ad ogni modo...", spanish=" Pero...[K] la verdad..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_105 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) or (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) or (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) or (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) or (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) or (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) or (SkyProg.cmp(29, 8) >= 0) or (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 54] || scn($SCENARIO_MAIN) >= [2
  if ((SV.SkyTalkBitFlags or {})[106] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[106]
  -- jump @label_105 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[106] = 1 -- $SCENARIO_TALK_BIT_FLAG[106] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_rakkii, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_rakkii) end)
  SkySceneKit.say({english="Eep! I'm happy you graduated! ♪\nCongratulations!", french="Titili! Je suis contente que vous\nayez obtenu votre diplôme! ♪ Félicitations!", german="Iep! Ich bin froh, dass ihr die\nAbschlussprüfung bestanden habt! ♪\nGlückwunsch!", italian="Eeh! Sono felice che abbiate\npassato l'esame! ♪ Congratulazioni!", spanish="¡Huy! ¡Qué bien que superaseis\nel reto! ♪ ¡Enhorabuena!"})
  pcall(function() UI:SetSpeaker(npc_npc_rakkii) end)
  SkySceneKit.say({english="I hope you'll keep up with your\nexploring! ♪", french="J'espère que vous continuerez à\nexplorer! ♪", german="Ich hoffe, dass ihr mit dem\nErkunden fortfahren werdet! ♪", italian="Spero che continuerete con le\nesplorazioni! ♪", spanish="¡Espero que sigáis explorando\nmucho! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_105 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(29, 4) >= 0) or (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 4] || scn($SCENARIO_MAIN) >= [29
  -- jump @label_105 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [25, 4] || scn($SCENARIO_MAIN) >= [25
  if ((SV.SkyTalkBitFlags or {})[105] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[105]
  -- jump @label_105 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[105] = 1 -- $SCENARIO_TALK_BIT_FLAG[105] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_rakkii, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_rakkii) end)
  SkySceneKit.say({english="Please don't fail us! Please save\nthe world!", french="Ne nous laissez pas tomber!\nSauvez le monde, je vous en prie!", german="Bitte enttäuscht uns nicht und\nrettet die Welt!", italian="Vi prego, mettetecela tutta!\nSalvate il mondo!", spanish="¡No nos falléis! ¡Tenéis que\nsalvar el mundo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_105 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [24, 1] || scn($SCENARIO_MAIN) >= [24
  -- jump @label_105 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) or (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [23, 3] || scn($SCENARIO_MAIN) >= [23
  if ((SV.SkyTalkBitFlags or {})[104] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[104]
  -- jump @label_105 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[104] = 1 -- $SCENARIO_TALK_BIT_FLAG[104] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_rakkii, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_rakkii) end)
  SkySceneKit.say({english="I'm glad to see you back safe\nand sound! ♪", french="Je suis contente de vous revoir\nen bonne forme! ♪", german="Ich bin froh, euch heil und\ngesund zurück zu haben! ♪", italian="Sono contenta di vedervi tornare\nbene e in salute! ♪", spanish="¡Me alegro de ver que habéis\nvuelto sin mayores percances! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_rakkii) end)
  SkySceneKit.say({english="When you were gone, everyone\nwas so concerned over you...", french="Tout le monde était si inquiet\npour vous pendant votre absence...", german="Als ihr fort wart, haben sich\nalle große Sorgen um euch gemacht...", italian="Quando non c'eravate, erano tutti\ncosì preoccupati per voi...", spanish="Cuando os fuisteis, todo el\nmundo estaba tan preocupado..."})
  pcall(function() UI:SetSpeaker(npc_npc_rakkii) end)
  SkySceneKit.say({english="Why, it seemed to sap the cheer\nout of all Treasure Town.", french="Sans blague, on aurait dit que\ntoute la joie avait disparu de Bourg-Trésor.", german="Warum? Offenbar ist eure\nAbwesenheit ganz Schatzstadt auf die\nStimmung geschlagen.", italian="Tutti erano più tristi a Borgo\nTesoro...", spanish="En realidad Aldea Tesoro\nestaba bastante desanimada por ello."})
  pcall(function() UI:SetSpeaker(npc_npc_rakkii) end)
  SkySceneKit.say({english="But all that's over now! I'm so\nglad to see you home safe!", french="Mais tout est fini maintenant!\nJe suis si heureuse de vous retrouver\nindemnes!", german="Aber das ist nun alles vorbei!\nIch bin ja so glücklich, euch gesund wieder\ndaheim zu sehen!", italian="Ma ora è tutto passato! Sono\ncosì felice di vedervi tornare in buona salute!", spanish="¡Pero ya ha pasado todo!\n¡Me alegro de veros de vuelta en casa!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_105 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [21, 2] || scn($SCENARIO_MAIN) >= [21
  -- jump @label_105 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(17, 3) >= 0) or (SkyProg.cmp(17, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [17, 3] || scn($SCENARIO_MAIN) >= [17
  if ((SV.SkyTalkBitFlags or {})[103] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[103]
  -- jump @label_105 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[103] = 1 -- $SCENARIO_TALK_BIT_FLAG[103] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_rakkii, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_rakkii) end)
  SkySceneKit.say({english="The great [CS:N]Dusknoir[CR]'s from the\nfuture! Isn't that a startling piece of news!", french="Le grand [CS:N]Noctunoir[CR] vient du\nfutur! Ça pour une surprise, c'est une sacrée\nsurprise!", german="Der große [CS:N]Zwirrfinst[CR] aus der\nZukunft! Was für eine erstaunliche Nachricht!", italian="Il grande [CS:N]Dusknoir[CR] viene dal\nfuturo! Non è una notizia sorprendente?!", spanish="¡El gran [CS:N]Dusknoir[CR] viene del futuro!\n¡Hay que ver las cosas que pasan!"})
  pcall(function() UI:SetSpeaker(npc_npc_rakkii) end)
  SkySceneKit.say({english="But if you think about it, a\nPokémon hatching from an Egg...[K] Wouldn't that\nbe like coming from the future?", french="Mais, quand on y pense, un\nPokémon qui sort de son Œuf...[K] C'est un peu\ncomme s'il venait du futur, non?", german="Aber wenn ein Pokémon aus\neinem Ei schlüpft...[K] Ist das nicht so, als käme\nes aus der Zukunft?", italian="Ma se ci pensate, un Pokémon\nche esce da un Uovo...[K] non è come se\nvenisse dal futuro?", spanish="Pero si lo pensáis bien, un\nPokémon que sale de un Huevo...[K] ¿no es\ncasi como venir del futuro?"})
  pcall(function() UI:SetSpeaker(npc_npc_rakkii) end)
  SkySceneKit.say({english="...Pardon?[K] You didn't\nunderstand that?", french="... Pardon?[K] Vous n'avez pas\ncompris ce que je voulais dire?", german="Bitte?[K] Ihr habt das nicht\nverstanden?", italian=" Scusa?[K] Non hai capito?", spanish="¿Cómo?[K] ¿No lo habéis\nentendido?"})
  pcall(function() UI:SetSpeaker(npc_npc_rakkii) end)
  SkySceneKit.say({english="That is true. It isn't an easy\nidea to grasp.", french="C'est vrai, c'est un concept\ndifficile à saisir.", german="Das ist wahr. Es ist kein\nGedanke, der sich so einfach begreifen lässt.", italian="È vero. Non è un concetto facile\nda capire.", spanish="Admito que no es una idea\nfácil de asimilar."})
  pcall(function() UI:SetSpeaker(npc_npc_rakkii) end)
  SkySceneKit.say({english="I didn't understand it when I\nsaid it, either! ♪[K] Eep! ♪", french="Moi non plus je n'ai pas très\nbien compris, même si c'est moi qui l'ai\ndit! ♪[K] Titili! ♪", german="Ich habe es auch nicht\nverstanden, als ich es gesagt habe! ♪[K] Iep! ♪", italian="Neanch'io l'ho capito, quando l'ho\ndetto! ♪[K] Eeh! ♪", spanish="¡En realidad, yo tampoco\nla he entendido! ♪[K] ¡Huy! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_105 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) or (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) or (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) or (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) or (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) or (SkyProg.cmp(12, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [16, 2] || scn($SCENARIO_MAIN) >= [16
  -- jump @label_105 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_104 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
