-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P11A/us3107.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) or (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) or (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) or (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) or (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) or (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) or (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) or (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_sheimi2 = SkySceneKit.spawn_npc("shaymin", 392, 240, Direction.DownLeft, "NPC_SHEIMI2")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_sheimi2, 4) end)
  if ((SV.SkyScenarioBitFlags or {})[94] == 1) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[94]
  local npc_npc_sheimi = SkySceneKit.spawn_npc("shaymin", 304, 264, Direction.UpLeft, "NPC_SHEIMI")
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="When we [CS:K]Shaymin[CR] use a\n[CS:I]Gracidea[CR], we can change our appearance.", french="Quand nous, les [CS:K]Shaymin[CR], nous\nutilisons une [CS:I]Gracidée[CR], nous changeons\nd'apparence.", german="Wenn wir [CS:K]Shaymin[CR] eine [CS:I]Gracidea[CR]\nverwenden, können wir unsere Erscheinung\nverändern.", italian="Quando noi [CS:K]Shaymin[CR] usiamo una\n[CS:I]Gracidea[CR], possiamo mutare il nostro aspetto.", spanish="Cuando los [CS:K]Shaymin[CR] usamos una\n[CS:I]Gracídea[CR], podemos cambiar de apariencia."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Our appearance changes pretty\ndrastically, so please don't be surprised.", french="Notre apparence change\ndu tout au tout, alors ne vous étonnez pas.", german="Unsere Erscheinung ändert sich\nrecht drastisch, also bitte nicht erschrecken!", italian="Il cambiamento è piuttosto\nradicale, quindi non spaventarti.", spanish="Cambiamos de una forma muy\ndrástica, así que no te sorprendas mucho."})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Would you like a [CS:I]Gracidea[CR]?", french=" Aimeriez-vous une [CS:I]Gracidée[CR]?", german=" Möchtest du eine [CS:I]Gracidea[CR]?", italian=" Vuoi una [CS:I]Gracidea[CR]?", spanish=" ¿Quieres una [CS:I]Gracídea[CR]?"})
  do local __choice = SkySceneKit.ask({{english="Yes, please.", french="Oui, s'il vous plaît.", german="Oh ja, gerne.", italian="Sì, grazie.", spanish="Sí, por favor."}, {english="No, thanks.", french="Non, merci.", german="Nein, danke.", italian="No, grazie.", spanish="No, gracias."}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="I see.\nWell, you're still welcome to one if you change\nyour mind.", french="Je vois.\nHé bien, si vous changez d'avis,\nn'hésitez pas à venir me voir.", german="Verstehe. Ich gebe dir gerne\neine, solltest du deine Entscheidung ändern.", italian="Capisco.\nBeh, torna pure nel caso dovessi\ncambiare idea.", spanish="Entiendo.\nBueno, aquí te estará esperando una\nsi cambias de idea."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Here you go.", french=" Voilà pour vous.", german=" Bitte schön.", italian=" Ecco qua.", spanish=" Aquí tienes."})
  -- message_KeyWait
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_IS_BAG_FULL"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_IS_BAG_FULL, 0, 0)) [ProcessSpecial(PROCESS_SPECIAL_IS_BAG_FULL): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 0 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[94] = 1 -- $SCENARIO_MAIN_BIT_FLAG[94] = 1 (ROM)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_ADD_ITEM_TO_BAG, 179, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  pcall(function() SOUND:PlayFanfare("Fanfare/Item") end) -- me_Play(4) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="[CN][hero] received\n[CN]a [CS:I]Gracidea[CR]!", french="[CN][hero] reçoit\n[CN]une [CS:I]Gracidée[CR]!", german="[CN][hero] erhält\n[CN]eine [CS:I]Gracidea[CR]!", italian="[CN][hero] ha ricevuto\n[CN]una [CS:I]Gracidea[CR]!", spanish="[CN]¡[hero] ha obtenido\n[CN]una [CS:I]Gracídea[CR]!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Oh? It seems you're carrying too\nmany items.", french="Oh? On dirait que vous\ntransportez trop d'objets.", german="Oh? Anscheinend trägst du\nzu viele Items mit dir herum.", italian="Oh? Sembra che tu abbia troppi\nstrumenti con te.", spanish="Vaya, parece que llevas\ndemasiados objetos."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  end
  elseif (SkyProg.cmp(29, 31) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 31]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_sheimi2, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="I heard a [CS:I]Gracidea[CR] was used to\nget down from the summit.", french="J'ai entendu dire qu'une [CS:I]Gracidée[CR]\na été utilisée pour descendre du sommet.", german="Ich habe gehört, dass [CS:I]Gracidea[CR]\ndafür verwendet wurde, vom Gipfel\nherunterzukommen.", italian="Ho sentito che per scendere\ndalla cima è stata usata una [CS:I]Gracidea[CR].", spanish="He oído que se usó una [CS:I]Gracídea[CR]\npara bajar de la cima."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="That's right. Using this flower,\nwe can change our appearance.", french="C'est vrai, en utilisant cette\nfleur, nous pouvons changer d'apparence.", german="Das stimmt. Mithilfe dieser\nBlume können wir unsere Erscheinung ändern.", italian="Proprio così. Grazie a questo\nfiore è possibile mutare il proprio aspetto.", spanish="Eso es, con esta flor podemos\ncambiar de apariencia."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Our appearance changes pretty\ndrastically, so please don't be surprised.", french="Notre apparence change du\ntout au tout, alors ne vous étonnez pas.", german="Unsere Erscheinung ändert sich\nrecht drastisch, also bitte nicht erschrecken!", italian="Il cambiamento è piuttosto\nradicale, quindi non spaventarti.", spanish="Cambiamos de una forma muy\ndrástica, así que no te sorprendas mucho."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) or (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) or (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 30] || scn($SCENARIO_MAIN) >= [2
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_sheimi2, 4) end)
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_sheimi2, 4) end)
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="The flower that blooms here is\ncalled the [CS:I]Gracidea[CR]...", french="La fleur qui pousse ici s'appelle\n[CS:I]Gracidée[CR]...", german="Die Blume, die hier blüht, nennt\nman [CS:I]Gracidea[CR].", italian="Il fiore che sboccia in questo\nluogo si chiama [CS:I]Gracidea[CR]...", spanish="Aquí brota una flor llamada\n[CS:I]Gracídea[CR]..."})
  -- message_KeyWait
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_sheimi2, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="It's a very special flower\nfor us.", french="C'est une fleur très spéciale\nà nos yeux.", german="Für uns ist es eine sehr\nbedeutsame Blume.", italian="Per noi è un fiore molto\nspeciale.", spanish="Es una flor muy especial\npara nosotros."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 8) >= 0) or (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) or (SkyProg.cmp(29, 4) >= 0) or (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) or (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) or (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) or (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) or (SkyProg.cmp(17, 3) >= 0) or (SkyProg.cmp(17, 1) >= 0) or (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) or (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) or (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) or (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) or (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) or (SkyProg.cmp(12, 1) >= 0) or (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) or (SkyProg.cmp(9, 1) >= 0) or (SkyProg.cmp(8, 7) >= 0) or (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) or (SkyProg.cmp(8, 3) >= 0) or (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) or (SkyProg.cmp(7, 6) >= 0) or (SkyProg.cmp(7, 3) >= 0) or (SkyProg.cmp(7, 2) >= 0) or (SkyProg.cmp(7, 1) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) or (SkyProg.cmp(5, 5) >= 0) or (SkyProg.cmp(4, 7) >= 0) or (SkyProg.cmp(4, 5) >= 0) or (SkyProg.cmp(4, 3) >= 0) or (SkyProg.cmp(4, 2) >= 0) or (SkyProg.cmp(4, 1) >= 0) or (SkyProg.cmp(4, 0) >= 0) or (SkyProg.cmp(3, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 8] || scn($SCENARIO_MAIN) >= [29
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
