-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P27A/enter14.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) or (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) or (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) or (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) or (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) or (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) or (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) or (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) or (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) or (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) or (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) or (SkyProg.cmp(29, 8) >= 0) or (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) or (SkyProg.cmp(29, 4) >= 0) or (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) or (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) or (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) or (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) or (SkyProg.cmp(17, 3) >= 0) or (SkyProg.cmp(17, 1) >= 0) or (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) or (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) or (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) or (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) or (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) or (SkyProg.cmp(12, 1) >= 0) or (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) or (SkyProg.cmp(9, 1) >= 0) or (SkyProg.cmp(8, 7) >= 0) or (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) or (SkyProg.cmp(8, 3) >= 0) or (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) or (SkyProg.cmp(7, 6) >= 0) or (SkyProg.cmp(7, 3) >= 0) or (SkyProg.cmp(7, 2) >= 0) or (SkyProg.cmp(7, 1) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) or (SkyProg.cmp(5, 5) >= 0) or (SkyProg.cmp(4, 7) >= 0) or (SkyProg.cmp(4, 5) >= 0) or (SkyProg.cmp(4, 3) >= 0) or (SkyProg.cmp(4, 2) >= 0) or (SkyProg.cmp(4, 1) >= 0) or (SkyProg.cmp(4, 0) >= 0) or (SkyProg.cmp(3, 1) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  if ((SV.SkyScenarioBitFlags or {})[82] == 1) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[82]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_donmeru = SkySceneKit.spawn_npc("numel", 184, 184, Direction.Down, "NPC_DONMERU")
  pcall(function() UI:SetSpeaker(npc_npc_donmeru) end)
  SkySceneKit.say({english="Thank you for trading with me.\nYou've helped me immensely.", french="Merci d'avoir accepté l'échange.\nTu m'as vraiment été d'un grand secours.", german="Danke für den Tausch.\nDu hast mir immens geholfen.", italian="Grazie per questo scambio.\nSignifica moltissimo per me.", spanish="Gracias por el intercambio,\nme has sido de gran ayuda."})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- item_SetVariable(0, $ITEM_BACKUP_TAKE) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- item_SetVariable(1, $ITEM_BACKUP_GET) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_donmeru) end)
  SkySceneKit.say({english="Oh...\nThat's troubling...", french="Oh...\nC'est étrange...", german="Oh...\nWie unangenehm...", italian="Oh...\nChe guaio...", spanish="Ah...\nEso es inquietante..."})
  pcall(function() UI:SetSpeaker(npc_npc_donmeru) end)
  SkySceneKit.say({english="Just before I got here, I used\nso many [s_item:0] that I don't have any\nmore left...", french="Je suis à court de l'objet\n[s_item:0] depuis mon arrivée ici...", german="Ich habe vor Kurzem das Item\n[s_item:0] in Massen verbraucht. Jetzt\nhabe ich keines mehr übrig...", italian="Poco prima di arrivare qui\nho usato troppi strumenti [s_item:0]\ne non me ne sono rimasti più...", spanish="Antes de venir aquí, usé un\nmontón de [s_item:0] y ya\nno me quedan más..."})
  pcall(function() UI:SetSpeaker(npc_npc_donmeru) end)
  SkySceneKit.say({english="Hey, if you've got some extra\n[s_item:0], I don't suppose you could\nshare them with me?", french="Dis, si tu as un objet\n[s_item:0] en rab, tu ne voudrais\npas partager avec moi?", german="Hey, wenn du von dem Item\n[s_item:0] noch einige übrig hast, magst\ndu sie nicht mit mir teilen?", italian="Ehi, se hai degli strumenti\n[s_item:0] in più, non è che\nli scambieresti con me?", spanish="Oye, si tienes algún objeto\n[s_item:0] de sobra, podrías mostrar\nalgo de generosidad conmigo, ¿no?"})
  pcall(function() UI:SetSpeaker(npc_npc_donmeru) end)
  SkySceneKit.say({english="I'll give you [s_item:1] in\nexchange. C'mon. What do you say?", french="Je te donnerai l'objet\n[s_item:1] en échange. Allez,\nqu'est-ce que t'en dis?", german="Ich gebe dir das Item\n[s_item:1] zum Tausch. Los, was sagst\ndu dazu?", italian="In cambio ti darò questo\nstrumento [s_item:1].\nDai! Che ne dici?", spanish="Te doy [s_item:1]\na cambio. Venga, va, ¿qué me dices?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_donmeru) end)
  SkySceneKit.say({english="[CN]Give [s_item:0]\n[CN]in exchange for [s_item:1]?", french="[CN]Donner l'objet [s_item:0]\n[CN]en échange de l'objet [s_item:1]?", german="[CN][s_item:0] gegen\n[CN][s_item:1] tauschen?", italian="[CN]Vuoi dare lo strumento [s_item:0] in\n[CN]cambio di uno strumento [s_item:1]?", spanish="[CN]¿Cambiar [s_item:0]\n[CN]por [s_item:1]?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_donmeru) end)
  SkySceneKit.say({english="Is that so...\nHmm... What to do...", french="Ah, vraiment...\nHum... que veux-tu...", german="Ach wirklich...\nHmm... Was machen wir da...", italian="Oh, capisco...\nMmmh... Che posso fare?", spanish="En serio... Mmm...\nNo sé qué hacer..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_COUNT_TABLE_ITEM_TYPE_IN_BAG"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_COUNT_TABLE_ITEM_TY) [ProcessSpecial(PROCESS_SPECIAL_COUNT_TABLE_ITEM_TYPE_IN_BAG): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw >= 1 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[82] = 1 -- $SCENARIO_MAIN_BIT_FLAG[82] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_donmeru) end)
  SkySceneKit.say({english="Oh, thank you so much!\nSeriously, this is a huge help!", french="Oh, merci mille fois!\nSérieusement, ça me dépanne vraiment!", german="Oh, ich danke dir vielmals!\nDas ist mir wirklich eine große Hilfe!", italian="Oh, grazie mille! Sei veramente\ndi grande aiuto!", spanish="¡Anda, pues muchas gracias!\n¡La verdad es que me ayudas un montón!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- switch(ProcessSpecial(PROCESS_SPECIAL_REMOVE_TABLE_ITEMS_TYPE_IN_BAG, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(ProcessSpecial(PROCESS_SPECIAL_ADD_TABLE_ITEM_TO_BAG, 1, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- GAP: se_Play(8710) — id SE NDS sans portage PMDO identifié
  pcall(function() UI:SetSpeaker(npc_npc_donmeru) end)
  SkySceneKit.say({english="[CN][player]\n[CN]traded [s_item:0]\n[CN]for [s_item:1]!", french="[CN][player]\n[CN]échange l'objet [s_item:0]\n[CN]contre l'objet [s_item:1]!", german="[CN][player] hat\n[CN]das Item [s_item:0] gegen\n[CN]das Item [s_item:1] getauscht!", italian="[CN][player] ha scambiato\n[CN]lo strumento [s_item:0] con\n[CN]uno strumento [s_item:1]!", spanish="[CN]¡[player]\n[CN]ha cambiado [s_item:0]\n[CN]por [s_item:1]!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- @label_136 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(npc_npc_donmeru) end)
  SkySceneKit.say({english="[CN][player] doesn't\n[CN]have any [s_item:0]...", french="[CN][player] n'a pas d'objet\n[CN][s_item:0]...", german="[CN][player] besitzt\n[CN]das Item [s_item:0] nicht...", italian="[CN][player] non ha\n[CN]nessuno strumento [s_item:0]...", spanish="[CN]¡[player] no tiene\n[CN]ningún objeto [s_item:0]!"})
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
