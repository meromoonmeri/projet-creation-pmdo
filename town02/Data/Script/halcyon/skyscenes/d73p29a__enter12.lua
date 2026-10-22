-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P29A/enter12.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) or (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) or (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) or (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) or (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) or (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) or (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) or (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) or (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) or (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) or (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) or (SkyProg.cmp(29, 8) >= 0) or (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) or (SkyProg.cmp(29, 4) >= 0) or (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) or (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) or (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) or (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) or (SkyProg.cmp(17, 3) >= 0) or (SkyProg.cmp(17, 1) >= 0) or (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) or (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) or (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) or (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) or (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) or (SkyProg.cmp(12, 1) >= 0) or (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) or (SkyProg.cmp(9, 1) >= 0) or (SkyProg.cmp(8, 7) >= 0) or (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) or (SkyProg.cmp(8, 3) >= 0) or (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) or (SkyProg.cmp(7, 6) >= 0) or (SkyProg.cmp(7, 3) >= 0) or (SkyProg.cmp(7, 2) >= 0) or (SkyProg.cmp(7, 1) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) or (SkyProg.cmp(5, 5) >= 0) or (SkyProg.cmp(4, 7) >= 0) or (SkyProg.cmp(4, 5) >= 0) or (SkyProg.cmp(4, 3) >= 0) or (SkyProg.cmp(4, 2) >= 0) or (SkyProg.cmp(4, 1) >= 0) or (SkyProg.cmp(4, 0) >= 0) or (SkyProg.cmp(3, 1) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  if ((SV.SkyScenarioBitFlags or {})[90] == 1) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[90]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_deribaado = SkySceneKit.spawn_npc("delibird", 176, 232, Direction.Down, "NPC_DERIBAADO")
  pcall(function() UI:SetSpeaker(npc_npc_deribaado) end)
  SkySceneKit.say({english="How is it?\nSomething good inside?", french="Alors?\nIl y a quelque chose de bien à l'intérieur?", german="Und, wie ist es?\nWar etwas Gutes darin?", italian="Come va?\nHai qualcosa di bello con te?", spanish="¿Qué tal?\n¿Hay algo bueno dentro?"})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_deribaado) end)
  SkySceneKit.say({english="Hello.\nMy name is [CS:N]Delibird[CR].\nI live on this mountain.", french="Bonjour.\nMon nom est [CS:N]Cadoizo[CR].\nJe vis sur cette montagne.", german="Hallo. Mein Name ist [CS:N]Botogel[CR].\nIch lebe auf diesem Berg.", italian="Salve.\nMi chiamo [CS:N]Delibird[CR].\nVivo su questa montagna.", spanish="Hola.\nMe llamo [CS:N]Delibird[CR] y vivo en esta montaña."})
  pcall(function() UI:SetSpeaker(npc_npc_deribaado) end)
  SkySceneKit.say({english=" I love to give out presents.", french=" J'adore offrir des cadeaux.", german="Ich liebe es, Geschenke\nzu verteilen.", italian=" Adoro fare regali.", spanish=" Me encanta regalar cosas."})
  pcall(function() UI:SetSpeaker(npc_npc_deribaado) end)
  SkySceneKit.say({english="Here, take this as a\nwelcoming gift!", french="Tiens, considère ceci comme\nun cadeau de bienvenue!", german="Hier, nehmt dies als\nWillkommensgeschenk!", italian="Ecco, prendi questo come dono\ndi benvenuto!", spanish="Toma, un regalo de\nbienvenida."})
  do local __choice = SkySceneKit.ask({{english="Thank you!", french="Merci!", german="Vielen Dank!", italian="Grazie!", spanish="¡Gracias!"}, {english="No, thanks.", french="Non, merci.", german="Nein, danke.", italian="No, grazie.", spanish="No, gracias."}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  pcall(function() UI:SetSpeaker(npc_npc_deribaado) end)
  SkySceneKit.say({english="Oh, really?\nThat's too bad...", french="Oh, vraiment?\nQuel dommage...", german="Oh, wirklich?\nDas ist zu schade...", italian="Oh, davvero?\nChe peccato...", spanish="¿De verdad?\nEs una auténtica lástima..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  pcall(function() UI:SetSpeaker(npc_npc_deribaado) end)
  SkySceneKit.say({english=" Here you go.", french=" Et voilà.", german=" Bitte schön.", italian=" Ecco qui.", spanish=" Aquí tienes."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_IS_BAG_FULL"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_IS_BAG_FULL, 0, 0)) [ProcessSpecial(PROCESS_SPECIAL_IS_BAG_FULL): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 0 then
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[90] = 1 -- $SCENARIO_MAIN_BIT_FLAG[90] = 1 (ROM)
  -- item_SetTableData(0, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- switch(ProcessSpecial(PROCESS_SPECIAL_ADD_TABLE_ITEM_TO_BAG, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- GAP: se_Play(8710) — id SE NDS sans portage PMDO identifié
  pcall(function() UI:SetSpeaker(npc_npc_deribaado) end)
  SkySceneKit.say({english="[CN][player] received\n[CN]a [CS:I]Sky Gift[CR].", french="[CN][player] reçoit\n[CN]un [CS:I]Don du Ciel[CR].", german="[CN][player] erhält\n[CN]ein [CS:I]Himmelspräsent[CR].", italian="[CN][player] ha ricevuto\n[CN]un [CS:I]Dono Cielo[CR].", spanish="[CN][player] ha obtenido\n[CN]un [CS:I]Regalo Cielo[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_deribaado) end)
  SkySceneKit.say({english="[CN]You gently open the lid...", french="[CN]Vous ouvrez délicatement le couvercle...", german="[CN]Du öffnest behutsam den Deckel...", italian="[CN]Apri lentamente il pacchetto...", spanish="[CN]Abres la tapa con cuidado..."})
  -- message_Close
  -- GAP: se_Play(11021) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() UI:SetSpeaker(npc_npc_deribaado) end)
  SkySceneKit.say({english="[CN]Inside was the\n[CN][s_item:0]!", french="[CN]A l'intérieur se trouve l'objet\n[CN][s_item:0]!", german="[CN]Im Paket liegt das Item\n[CN][s_item:0]!", italian="[CN]... e al suo interno trovi lo strumento\n[CN][s_item:0]!", spanish="[CN]¡Había un objeto\n[CN][s_item:0] dentro!"})
  pcall(function() UI:SetSpeaker(npc_npc_deribaado) end)
  SkySceneKit.say({english="[CN]A warm and fuzzy feeling falls over you...", french="[CN]Que c'est agréable de recevoir un cadeau...", german="[CN]Ein warmes, angenehmes Kribbeln\n[CN]überkommt dich...", italian="[CN]Una dolce sensazione di calore ti investe...", spanish="[CN]Te invade una sensación de calidez..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_deribaado, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_deribaado) end)
  SkySceneKit.say({english="What?\nYou've got too many items or something?", french="Quoi? Tu transportes\ntrop d'objets ou quelque chose comme ça?", german="Wie bitte? Hast du etwa zu\nviele Items, oder was ist da los?", italian="Come?\nNon hai abbastanza spazio?", spanish="¿Cómo?\n¿Es que ya tienes demasiados objetos?"})
  pcall(function() UI:SetSpeaker(npc_npc_deribaado) end)
  SkySceneKit.say({english=" That's really too bad.", french=" C'est vraiment dommage.", german=" Wirklich zu schade.", italian=" Che peccato.", spanish=" Es una pena."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  end
  else
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
