-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/um1509.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94]
  -- @label_0 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 520, 240, Direction.Down, "NPC_CHIRIIN")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_chiriin, 4) end)
  -- switch(message_Menu(MENU_TEAM_ASSEMBLY)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 93] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_chiriin, 4) end)
  -- switch(message_Menu(MENU_TEAM_ASSEMBLY)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 91] || scn($SCENARIO_MAIN) >= [2
  if ((SV.SkyTalkBitFlags or {})[22] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[22]
  -- @label_131 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_chiriin, 4) end)
  -- switch(message_Menu(MENU_TEAM_ASSEMBLY)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[22] = 1 -- $SCENARIO_TALK_BIT_FLAG[22] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_chiriin, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" Good luck!", french=" Bonne chance!", german=" Viel Glück!", italian=" Buona fortuna!", spanish=" ¡Buena suerte!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- switch(message_Menu(MENU_TEAM_ASSEMBLY)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 85] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_chiriin, 4) end)
  -- switch(message_Menu(MENU_TEAM_ASSEMBLY)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 76) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 76]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_chiriin, 4) end)
  -- switch(message_Menu(MENU_TEAM_ASSEMBLY)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 75) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 75]
  if ((SV.SkyTalkBitFlags or {})[21] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[21]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[21] = 1 -- $SCENARIO_TALK_BIT_FLAG[21] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_chiriin, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="Oh?[K] You can go into [CS:N]Azurill[CR]'s\ndream?[K] That's wonderful news!", french="Ah bon?[K] Vous pouvez entrer\ndans le rêve d'[CS:N]Azurill[CR]?[K] Excellente nouvelle!", german="Oh?[K] Ihr könnt den Albtraum von\n[CS:N]Azurill[CR] betreten?[K] Das sind wunderbare\nNeuigkeiten!", italian="Eh?[K] Potete entrare nel sogno di\n[CS:N]Azurill[CR]?[K] Che splendida notizia!", spanish="¿Qué?[K] ¿Que podéis entrar en el\nsueño de [CS:N]Azurill[CR]?[K] ¡Eso es estupendo!"})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="I hope you'll get to the root of\nthe problem!", french="J'espère que vous découvrirez\nla cause du problème!", german="Ich hoffe, dass ihr dem Problem\nauf den Grund gehen könnt!", italian="Spero che troverete la radice\ndel problema!", spanish="Espero que lleguéis al quid de la\ncuestión."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- switch(message_Menu(MENU_TEAM_ASSEMBLY)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 73] || scn($SCENARIO_MAIN) >= [2
  if ((SV.SkyTalkBitFlags or {})[20] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[20]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[20] = 1 -- $SCENARIO_TALK_BIT_FLAG[20] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_chiriin, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="I hope you manage to bring\n[CS:N]Drowzee[CR] back!", french="Espérons que vous arriverez à\nramener [CS:N]Soporifik[CR]!", german="Ich hoffe, ihr schafft es,\n[CS:N]Traumato[CR] hierherzubringen!", italian="Spero che riuscirete a\ntornare con [CS:N]Drowzee[CR]!", spanish="¡Espero que podáis traer a\n[CS:N]Drowzee[CR] de vuelta!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- switch(message_Menu(MENU_TEAM_ASSEMBLY)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 71] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_chiriin, 4) end)
  -- switch(message_Menu(MENU_TEAM_ASSEMBLY)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 56) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 56]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_chiriin, 4) end)
  -- switch(message_Menu(MENU_TEAM_ASSEMBLY)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 55) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 55]
  if ((SV.SkyTalkBitFlags or {})[19] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[19]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[19] = 1 -- $SCENARIO_TALK_BIT_FLAG[19] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_chiriin, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="I got to see the one and only\nTeam [CS:X]Charm[CR] with my own eyes...[K] That's more\nthan enough for me!", french="Je l'ai vue de mes propres yeux!\nLa seule, l'unique, l'Equipe [CS:X]Charme[CR]...[K]\nL'émotion m'étreint!", german="Ich muss das einzig wahre Team\n[CS:X]Charme[CR] mit meinen eigenen Augen sehen...[K] Das\nist mehr als genug für mich!", italian="Devo vedere il favoloso, fanta-\nstico, unico Team [CS:X]Malia[CR] coi miei occhi...[K]\nNon chiedo altro!", spanish="Pude ver al auténtico [CS:X]Equipo[CR]\n[CS:X]Carisma[CR] con mis propios ojos...[K] ¡Es más\nque suficiente para mí!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- switch(message_Menu(MENU_TEAM_ASSEMBLY)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) or (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 54] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_chiriin, 4) end)
  -- switch(message_Menu(MENU_TEAM_ASSEMBLY)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) or (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) or (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) or (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) or (SkyProg.cmp(29, 8) >= 0) or (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 33] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_chiriin, 4) end)
  -- switch(message_Menu(MENU_TEAM_ASSEMBLY)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 4) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 4]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_chiriin, 4) end)
  -- switch(message_Menu(MENU_TEAM_ASSEMBLY)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 3] || scn($SCENARIO_MAIN) >= [29
  if ((SV.SkyTalkBitFlags or {})[17] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[17]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[17] = 1 -- $SCENARIO_TALK_BIT_FLAG[17] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_chiriin, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="Good luck on your graduation\nexam!", french="Bonne chance pour votre\nexamen!", german="Viel Glück bei deiner\nAbschlussprüfung!", italian=" In bocca al lupo per il diploma!", spanish=" ¡Buena suerte en el gran reto!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- switch(message_Menu(MENU_TEAM_ASSEMBLY)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [25, 4] || scn($SCENARIO_MAIN) >= [25
  if ((SV.SkyTalkBitFlags or {})[16] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[16]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[16] = 1 -- $SCENARIO_TALK_BIT_FLAG[16] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_chiriin, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="It's not possible to add team\nmembers when exploring the [CS:P]Hidden Land[CR].[K]\nThat's very disappointing...", french="Dommage.[K] On ne peut pas ajouter\nde coéquipiers pour partir explorer les [CS:P]Terres\nIllusoires[CR]... Quelle déception...", german="Es ist nicht möglich,\nTeam-Mitglieder hinzuzufügen, während du das\n[CS:P]Verborgene Land[CR] erkundest.[K] Wie enttäuschend...", italian="Non si possono portare altri\namici quando si esplora la [CS:P]Terra Nascosta[CR]...[K]\nMi dispiace molto...", spanish="No se puede añadir miembros\nal equipo para explorar la [CS:P]Tierra Oculta[CR].[K]\nQué decepción..."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="Don't give up, though! You have\nto succeed!", french="Mais ne laissez pas tomber!\nVous devez réussir!", german="Aber gib nicht auf! Du musst\nerfolgreich sein!", italian="Mettetecela tutta! Dovete\nfarcela!", spanish="¡No os rindáis! ¡No podéis\nfracasar!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- switch(message_Menu(MENU_TEAM_ASSEMBLY)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [24, 1] || scn($SCENARIO_MAIN) >= [24
  if ((SV.SkyTalkBitFlags or {})[15] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[15]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[15] = 1 -- $SCENARIO_TALK_BIT_FLAG[15] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_chiriin, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="I'm going out to [CS:P]Brine Cave[CR]\ntomorrow too!", french="Moi aussi, je pars pour la\n[CS:P]Caverne Saline[CR] demain!", german="Ich begebe mich morgen auch in\ndie [CS:P]Salzwasserhöhle[CR]!", italian="Anch'io domani vado alla\n[CS:P]Grotta Salmastra[CR]!", spanish="¡Yo también voy a la\n[CS:P]Cueva Aguamar[CR] mañana!"})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" Let's do good!", french=" Faisons de notre mieux!", german=" Geben wir unser Bestes!", italian=" Diamo il meglio!", spanish=" ¡Hagamos un buen trabajo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- switch(message_Menu(MENU_TEAM_ASSEMBLY)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [23, 1] || scn($SCENARIO_MAIN) >= [22
  if ((SV.SkyTalkBitFlags or {})[14] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[14]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[14] = 1 -- $SCENARIO_TALK_BIT_FLAG[14] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_chiriin, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="I'm happy to see your team back,\n[hero]!", french="Je suis contente que vous soyez\nde retour, [hero]!", german="Ich freue mich, dass euer Team\nzurück ist, [hero]!", italian="Sono contenta che la tua squadra\nsia tornata, [hero]!", spanish="¡Me alegro de ver a tu equipo\nde vuelta, [hero]!"})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" I hope we can work together!", french="J'espère que nous aurons\nl'occasion de coopérer!", german="Ich hoffe, dass wir\nzusammenarbeiten können!", italian=" Spero di poter lavorare con voi!", spanish="¡Espero que podamos trabajar\njuntos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- switch(message_Menu(MENU_TEAM_ASSEMBLY)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) or (SkyProg.cmp(17, 3) >= 0) or (SkyProg.cmp(17, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [21, 2] || scn($SCENARIO_MAIN) >= [21
  if ((SV.SkyTalkBitFlags or {})[13] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[13]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[13] = 1 -- $SCENARIO_TALK_BIT_FLAG[13] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_chiriin, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="It's back to our regular work\nfor now.", french="Pour l'instant, on doit reprendre\nnotre travail habituel.", german="Fürs Erste gehen wir zurück an\nunsere reguläre Arbeit.", italian="Per ora si ritorna a lavorare\nregolarmente.", spanish=" De vuelta a la rutina diaria."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- switch(message_Menu(MENU_TEAM_ASSEMBLY)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(16, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [16, 2]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_chiriin, 4) end)
  -- switch(message_Menu(MENU_TEAM_ASSEMBLY)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(16, 0) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [16, 0]
  if ((SV.SkyTalkBitFlags or {})[12] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[12]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[12] = 1 -- $SCENARIO_TALK_BIT_FLAG[12] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_chiriin, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" You mustn't give up!", french=" N'abandonnez pas!", german=" Ihr dürft nicht aufgeben!", italian=" Non dovete mollare!", spanish=" ¡No podéis rendiros!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- switch(message_Menu(MENU_TEAM_ASSEMBLY)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(15, 4) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [15, 4]
  if ((SV.SkyTalkBitFlags or {})[11] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[11]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[11] = 1 -- $SCENARIO_TALK_BIT_FLAG[11] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_chiriin, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="I hope you do well on your\n[CS:P]Crystal Cave[CR] exploration!", french="J'espère que vous mènerez\nà bien votre exploration de la [CS:P]Caverne Cristal[CR]!", german="Ich hoffe, ihr habt Erfolg bei\nder Erkundung der [CS:P]Kristallhöhle[CR]!", italian="Spero che la vostra esplorazione\nalla [CS:P]Grotta di Cristallo[CR] vada bene!", spanish="¡Espero que todo vaya bien en la\nexploración de la [CS:P]Cueva Cristal[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- switch(message_Menu(MENU_TEAM_ASSEMBLY)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [15, 1] || scn($SCENARIO_MAIN) >= [14
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_chiriin, 4) end)
  -- switch(message_Menu(MENU_TEAM_ASSEMBLY)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [14, 4] || scn($SCENARIO_MAIN) >= [14
  if ((SV.SkyTalkBitFlags or {})[10] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[10]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[10] = 1 -- $SCENARIO_TALK_BIT_FLAG[10] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_chiriin, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="Good luck catching that criminal\n[CS:N]Grovyle[CR]!", french="Vous partez à la poursuite de\n[CS:N]Massko[CR] le criminel? Bonne chance!", german="Viel Glück dabei, den Ganoven\n[CS:N]Reptain[CR] einzufangen!", italian="Buona fortuna per la cattura di\nquel criminale di [CS:N]Grovyle[CR]!", spanish="¡Buena suerte! Espero que\nlogréis atrapar a ese delincuente de\n[CS:N]Grovyle[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- switch(message_Menu(MENU_TEAM_ASSEMBLY)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(14, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [14, 1]
  if ((SV.SkyTalkBitFlags or {})[9] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[9]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[9] = 1 -- $SCENARIO_TALK_BIT_FLAG[9] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_chiriin, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="Let's be sure to catch that\nhorrid [CS:N]Grovyle[CR]!", french="Faisons en sorte d'attraper\nl'infâme [CS:N]Massko[CR]!", german="Lasst uns sichergehen, dass wir\ndiesen schrecklichen [CS:N]Reptain[CR] dieses Mal\nfangen!", italian="Dobbiamo assolutamente\ncatturare quell'orribile [CS:N]Grovyle[CR]!", spanish="¡Hay que atrapar al malvado\n[CS:N]Grovyle[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- switch(message_Menu(MENU_TEAM_ASSEMBLY)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [13, 2] || scn($SCENARIO_MAIN) >= [13
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_chiriin, 4) end)
  -- switch(message_Menu(MENU_TEAM_ASSEMBLY)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [12, 4] || scn($SCENARIO_MAIN) >= [12
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_chiriin, 4) end)
  -- switch(message_Menu(MENU_TEAM_ASSEMBLY)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(12, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [12, 1]
  if ((SV.SkyTalkBitFlags or {})[8] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[8]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[8] = 1 -- $SCENARIO_TALK_BIT_FLAG[8] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_chiriin, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" Wasn't the expedition fun?!", french="Alors c'était super l'expédition,\npas vrai?!", german="Hat die Expedition nicht Spaß\ngemacht?", italian="Non è stata divertente la\nspedizione?!", spanish="¿A que ha sido divertida la\nexpedición?"})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="Well, we're back to the regular\nguild routine! It's time to work again!", french="Bon, nous voilà revenus à la\nroutine habituelle de la Guilde!\nRemettons-nous au travail!", german="Nun, zurück zur Gildenroutine!\nEs ist Zeit, wieder an die Arbeit zu gehen!", italian="Bene, siamo tornati alla solita\nroutine della Gilda! È di nuovo ora di lavorare!", spanish="Bueno, ya estamos de vuelta\na la rutina del [CS:N]Pokégremio[CR]. ¡A trabajar!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- switch(message_Menu(MENU_TEAM_ASSEMBLY)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) or (SkyProg.cmp(9, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [10, 2] || scn($SCENARIO_MAIN) >= [10
  if ((SV.SkyTalkBitFlags or {})[7] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[7]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[7] = 1 -- $SCENARIO_TALK_BIT_FLAG[7] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_chiriin, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="It's wonderful! It's so nice that\nwe can all go on the expedition together!", french="C'est merveilleux! C'est si\nchouette que nous partions en\nexpédition tous ensemble!", german="Es ist wundervoll! Es ist so\ntoll, dass wir alle zusammen auf die Expedition\ngehen können!", italian="Che meraviglia! È così bello\npartire tutti assieme!", spanish="¡Es magnífico! ¡Es genial que\ntodos podamos ir juntos a la expedición!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- switch(message_Menu(MENU_TEAM_ASSEMBLY)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(8, 7) >= 0) or (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) or (SkyProg.cmp(8, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [8, 7] || scn($SCENARIO_MAIN) >= [8, 
  if ((SV.SkyTalkBitFlags or {})[6] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[6]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[6] = 1 -- $SCENARIO_TALK_BIT_FLAG[6] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_chiriin, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="The expedition is coming up\nsoon!", french="L'expédition approche à grands\npas!", german="Die Expedition rückt mit großen\nSchritten näher!", italian=" Manca poco alla spedizione!", spanish=" ¡Pronto será la expedición!"})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" I hope everyone does their best!", french="J'espère que tout le monde\nfera de son mieux!", german="Ich hoffe, jeder gibt sein\nBestes!", italian="Spero che tutti si impegnino a\nfondo!", spanish="¡Espero que todos se esfuercen\nal máximo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- switch(message_Menu(MENU_TEAM_ASSEMBLY)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [8, 2] || scn($SCENARIO_MAIN) >= [8, 
  if ((SV.SkyTalkBitFlags or {})[5] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[5]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[5] = 1 -- $SCENARIO_TALK_BIT_FLAG[5] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_chiriin, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="The expedition is coming up![K]\nLet's do our best to be chosen!", french="L'expédition approche![K]\nFaisons de notre mieux pour être choisis!", german="Die Expedition rückt näher![K] Tun\nwir unser Bestes, damit wir ausgewählt\nwerden!", italian="La spedizione si avvicina![K]\nSe vogliamo che ci scelgano, dobbiamo fare del\nnostro meglio!", spanish="¡Pronto será la expedición![K]\n¡Hagámoslo lo mejor posible para que nos\nescojan!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- switch(message_Menu(MENU_TEAM_ASSEMBLY)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(7, 6) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 6]
  if ((SV.SkyTalkBitFlags or {})[4] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[4]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[4] = 1 -- $SCENARIO_TALK_BIT_FLAG[4] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_chiriin, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" Ewww... It still reeks...", french=" Pouah... Ça empeste encore...", german=" Puuuh... Das stinkt immer noch...", italian=" Bleah... quanto puzza...", spanish=" Uf... todavía me llega el tufo..."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" But I won't be overcome by it!", french="Mais il faut que je tienne bon,\nmalgré tout!", german="Aber ich lasse mich dadurch\nnicht außer Gefecht setzen!", italian=" Ma resisterò!", spanish=" ¡Pero lo superaré!"})
  -- message_Close
  -- switch(message_Menu(MENU_TEAM_ASSEMBLY)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(7, 3) >= 0) or (SkyProg.cmp(7, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 3] || scn($SCENARIO_MAIN) >= [7, 
  if ((SV.SkyTalkBitFlags or {})[3] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[3]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[3] = 1 -- $SCENARIO_TALK_BIT_FLAG[3] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_chiriin, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" What was that awful stench...?", french="C'est quoi cette ignoble\npuanteur...?", german="Was war denn das für ein\nfürchterlicher Gestank?", italian=" Cos'era quella puzza terribile?", spanish=" ¿Qué era esa peste?"})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="But I won't let that bother me!\nI have my job to do!", french="Je ne peux pas me laisser\ndistraire! J'ai du pain sur la planche!", german="Davon lasse ich mich nicht\nbeeindrucken! Ich muss meinen Job erledigen!", italian="Ma non mi lascerò infastidire!\nHo il mio lavoro da fare!", spanish="¡No permitiré que eso me\nmoleste! ¡Tengo trabajo que hacer!"})
  -- message_Close
  -- switch(message_Menu(MENU_TEAM_ASSEMBLY)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(7, 1) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 1] || scn($SCENARIO_MAIN) >= [6, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_chiriin, 4) end)
  -- switch(message_Menu(MENU_TEAM_ASSEMBLY)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(5, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [5, 5]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_chiriin, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" It's not time for dinner yet.", french="Ce n'est pas encore l'heure\nde dîner.", german="Es ist noch zu früh für die\nEssenszeit.", italian=" Non è ancora ora di cena.", spanish=" Todavía no es la hora de cenar."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="I'll ring for everyone when\ndinner is ready. Please be patient.", french="Patience, je vous prie. Je ferai\nsonner la cloche quand le dîner sera prêt.", german="Ich werde nach allen läuten\nlassen, wenn Essenszeit ist. Bitte habt Geduld.", italian="Chiamerò tutti quando sarà\npronto in tavola. Portate pazienza.", spanish="Ya os avisaré cuando la cena\nesté lista. Tened un poco de paciencia."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" Oh![K] I almost forgot!", french=" Oh![K] J'ai failli oublier!", german=" Oh![K] Fast hätte ich es vergessen!", italian=" Oh![K] Me n'ero quasi dimenticata!", spanish=" ¡Por cierto![K] ¡Casi se me olvida!"})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="The Guildmaster and [CS:N]Chatot[CR]\nasked me to start a new service for the guild.", french="Le Maître et [CS:N]Pijako[CR]\nm'ont demandé de m'occuper d'un nouveau\nservice au sein de la Guilde.", german="Der Gildenmeister und [CS:N]Plaudagei[CR]\nhaben mich gebeten, eine neue Dienstleistung\nfür die Gilde anzubieten.", italian="Il Capitano e [CS:N]Chatot[CR] mi hanno\nchiesto di attivare un nuovo servizio per\nla Gilda.", spanish="El Gran Bluff y [CS:N]Chatot[CR] me han\npedido que ofrezca un nuevo servicio\nal [CS:N]Pokégremio[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="I'm going to start a service for\nassembling larger teams soon! ♪", french="Je vais bientôt ouvrir un\nservice permettant de créer de plus\ngrandes équipes! ♪", german="Bald biete ich eine Dienstleistung\nan, mit der größere Teams zusammengestellt\nwerden können! ♪", italian="Presto sarà attivo un servizio\nche permetterà di formare squadre più\nnumerose! ♪", spanish="¡Pronto ofreceré la posibilidad\nde incorporar nuevos miembros a los\nequipos! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="I'm going to run the Assembly\nservice out of the upper guild level. I hope\nthat you will find it useful! ♪", french="Son nom: le Rassemblement!\nÇa se situera au premier sous-sol de\nla Guilde. J'espère que ça vous sera utile! ♪", german="Ich werde den Treffpunkt von\nder Unteren Gildenebene 1 aus führen. Ich\nhoffe, ihr findet ihn nützlich! ♪", italian="Troverete il Raduno sul piano\ninferiore della Gilda 1. Spero che\nvi sarà utile! ♪", spanish="Voy a dirigir el Registro en la\nplanta -1. ¡Espero que os resulte útil! ♪"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 7) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 7]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_chiriin, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" I'm getting dinner ready now.", french="Je suis en train de préparer\nle dîner.", german="Ich mache jetzt das Essen\nfertig.", italian=" Sto preparando da mangiare.", spanish=" Estoy preparando la cena."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="I'll ring for everyone when\ndinner's ready.", french="Je ferai sonner la cloche quand\nle repas sera prêt.", german="Ich werde nach euch läuten\nlassen, wenn Essenszeit ist.", italian=" Vi chiamerò quando sarà pronto.", spanish="Os avisaré cuando la cena esté\nlista."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="Until then, keep at your work,\nplease! ♪", french="En attendant, vaquez donc\nà vos occupations! ♪", german="Bis dahin solltet ihr weiter an\neurem Training arbeiten! ♪", italian="Intanto, continuate a lavorare,\nper favore! ♪", spanish="¡Hasta entonces, seguid\ntrabajando! ♪"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 5) >= 0) or (SkyProg.cmp(4, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 5] || scn($SCENARIO_MAIN) >= [4, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_chiriin, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" Oh?[K] Hungry already?", french=" Tiens?[K] Vous avez déjà faim?", german=" Oh?[K] Schon hungrig?", italian=" Oh?[K] Avete già fame?", spanish=" ¿Eh?[K] ¿Ya tenéis hambre?"})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" But it's not dinner yet!", french="Mais ce n'est pas encore l'heure\nde dîner!", german="Aber es gibt jetzt noch kein\nEssen!", italian=" Ma non è ancora ora di cena!", spanish="¡Pero si aún no es hora de\ncenar!"})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="I'll ring for everyone when\ndinner is served. Until then, you should keep\nup your training! ♪", french="Je ferai sonner la cloche quand\nle repas sera prêt. En attendant, reprenez\nl'entraînement! ♪", german="Ich werde nach euch läuten\nlassen, wenn Essenszeit ist. Bis dahin solltet\nihr weiter an eurem Training arbeiten! ♪", italian="Suonerò la campana per tutti\nquando sarà pronta la cena. Prima, dovreste\ncontinuare ad allenarvi! ♪", spanish="Os llamaré cuando la cena esté\nlista. ¡Hasta entonces seguid entrenando! ♪"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 2) >= 0) or (SkyProg.cmp(4, 1) >= 0) or (SkyProg.cmp(4, 0) >= 0) or (SkyProg.cmp(3, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 2] || scn($SCENARIO_MAIN) >= [4, 
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
