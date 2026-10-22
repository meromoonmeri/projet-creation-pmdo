-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P23A/enter12.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) or (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) or (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) or (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) or (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) or (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) or (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) or (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) or (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) or (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) or (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) or (SkyProg.cmp(29, 8) >= 0) or (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) or (SkyProg.cmp(29, 4) >= 0) or (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) or (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) or (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) or (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) or (SkyProg.cmp(17, 3) >= 0) or (SkyProg.cmp(17, 1) >= 0) or (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) or (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) or (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) or (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) or (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) or (SkyProg.cmp(12, 1) >= 0) or (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) or (SkyProg.cmp(9, 1) >= 0) or (SkyProg.cmp(8, 7) >= 0) or (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) or (SkyProg.cmp(8, 3) >= 0) or (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) or (SkyProg.cmp(7, 6) >= 0) or (SkyProg.cmp(7, 3) >= 0) or (SkyProg.cmp(7, 2) >= 0) or (SkyProg.cmp(7, 1) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) or (SkyProg.cmp(5, 5) >= 0) or (SkyProg.cmp(4, 7) >= 0) or (SkyProg.cmp(4, 5) >= 0) or (SkyProg.cmp(4, 3) >= 0) or (SkyProg.cmp(4, 2) >= 0) or (SkyProg.cmp(4, 1) >= 0) or (SkyProg.cmp(4, 0) >= 0) or (SkyProg.cmp(3, 1) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  if ((SV.SkyScenarioBitFlags or {})[61] == 1) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[61]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_pinpuku = SkySceneKit.spawn_npc("happiny", 160, 216, Direction.Right, "NPC_PINPUKU")
  pcall(function() UI:SetSpeaker(npc_npc_pinpuku) end)
  SkySceneKit.say({english=" I won't forget this kindness!", french="Je n'oublierai jamais\nun acte si généreux!", german="Diese Freundlichkeit werde ich\nniemals vergessen!", italian="Non mi dimenticherò\ndella tua generosità!", spanish=" ¡Nunca olvidaré tal amabilidad!"})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- item_SetVariable(0, $ITEM_BACKUP_KUREKURE) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_pinpuku) end)
  SkySceneKit.say({english=" Um... Excuse me.", french=" Heu... Excuse-moi.", german=" Äh... Entschuldige.", italian=" Ehm... Scusa.", spanish=" Esto... Disculpa."})
  pcall(function() UI:SetSpeaker(npc_npc_pinpuku) end)
  SkySceneKit.say({english="Um... On the way up, while I\nwas climbing...I seem to have dropped my\n[s_item:0]...", french="Heu... En chemin, pendant mon\nascension... je crois que j'ai perdu mon\nobjet [s_item:0]...", german="Äh... Auf dem Weg nach oben,\nwährend des Kletterns, habe ich anscheinend\ndas Item [s_item:0] fallengelassen...", italian="Ehm... Mentre salivo verso\nla cima... credo di aver perduto il mio\nstrumento [s_item:0]...", spanish="Resulta que... mientras subía...\nno sé cómo, pero por lo visto he perdido mi\nobjeto [s_item:0] y no sé qué hacer..."})
  pcall(function() UI:SetSpeaker(npc_npc_pinpuku) end)
  SkySceneKit.say({english=" It's probably too much trouble...", french=" C'est sûrement trop demander...", german="Möglicherweise bereitet das\nzu viel Ärger...", italian=" Mi dispiace disturbarti così...", spanish=" No querría importunarte..."})
  pcall(function() UI:SetSpeaker(npc_npc_pinpuku) end)
  SkySceneKit.say({english="But if you've got an extra\n[s_item:0], do you think I could possibly\nhave it? If it's OK with you?", french="... mais si tu en as assez,\ntu accepterais de me donner un\nobjet [s_item:0]?", german="Aber denkst du, du hast\nvielleicht ein Item [s_item:0] für mich\nübrig? Wäre das für dich in Ordnung?", italian="... ma se avessi uno strumento\n[s_item:0] in più, potresti darmelo?\nSarebbe un problema per te?", spanish="Pero, si por casualidad no te\nimportara darme algún objeto [s_item:0]\nque te sobre... si no es mucha molestia..."})
  do local __choice = SkySceneKit.ask({{english="Here you go!", french="Tiens, c'est pour toi!", german="Hier hast du es!", italian="Ecco qua!", spanish="¡Aquí tienes!"}, {english="I can't do that...", french="Je ne peux pas...", german="Leider nicht...", italian="Non posso...", spanish="No puedo hacerlo..."}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  pcall(function() UI:SetSpeaker(npc_npc_pinpuku) end)
  SkySceneKit.say({english=" I see... Makes sense, really...", french="Je vois...\nPas grave, je comprends...", german="Ach so... Kann ich verstehen,\nwirklich...", italian="Capisco... non ti preoccupare,\ndavvero...", spanish=" Entiendo... Pues tiene sentido..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_COUNT_TABLE_ITEM_TYPE_IN_BAG"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_COUNT_TABLE_ITEM_TY) [ProcessSpecial(PROCESS_SPECIAL_COUNT_TABLE_ITEM_TYPE_IN_BAG): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw >= 1 then
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[61] = 1 -- $SCENARIO_MAIN_BIT_FLAG[61] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_pinpuku) end)
  SkySceneKit.say({english=" Really?", french=" Vraiment?", german=" Im Ernst?", italian=" Davvero?", spanish=" ¿En serio?"})
  pcall(function() UI:SetSpeaker(npc_npc_pinpuku) end)
  SkySceneKit.say({english="Oh, thank you! Thank you ever so\nmuch! I really appreciate it!", french="Oh, merci! Merci infiniment!\nÇa me touche vraiment!", german="Oh, danke schön! Das ist so\nnett von dir! Das macht mich wirklich froh!", italian="Oh, grazie! Grazie mille!\nLo apprezzo molto!", spanish="¡Anda, muchas gracias! ¡No\nsabes cuantísimo te lo agradezco!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- switch(ProcessSpecial(PROCESS_SPECIAL_REMOVE_TABLE_ITEMS_TYPE_IN_BAG, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- GAP: se_Play(8710) — id SE NDS sans portage PMDO identifié
  pcall(function() UI:SetSpeaker(npc_npc_pinpuku) end)
  SkySceneKit.say({english="[CN][player] handed over\n[CN]the [s_item:0].", french="[CN][player] donne l'objet\n[CN][s_item:0].", german="[CN][player] übergibt das\n[CN]Item [s_item:0].", italian="[CN][player] ha consegnato\n[CN]lo strumento [s_item:0].", spanish="[CN]¡[player] ha entregado\n[CN]su objeto [s_item:0]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pinpuku) end)
  SkySceneKit.say({english=" I won't forget this kindness!", french="Je n'oublierai jamais\nun acte si généreux!", german="Diese Freundlichkeit werde ich\nniemals vergessen!", italian="Non mi dimenticherò\ndella tua generosità!", spanish=" ¡Nunca olvidaré tal amabilidad!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- @label_136 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pinpuku) end)
  SkySceneKit.say({english="[CN][player] doesn't have\n[CN]any [s_item:0]...", french="[CN][player] n'a pas d'objet\n[CN][s_item:0]...", german="[CN][player] hat kein\n[CN]Item [s_item:0]...", italian="[CN][player] non ha nessuno strumento\n[CN][s_item:0]...", spanish="[CN]¡[player] no tiene\n[CN][s_item:0]!"})
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
