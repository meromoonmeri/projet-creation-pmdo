-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P11A/us2007.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) or (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) or (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) or (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) or (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) or (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) or (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) or (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) or (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) or (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) or (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_sheimi1 = SkySceneKit.spawn_npc("shaymin", 224, 312, Direction.DownRight, "NPC_SHEIMI1")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_sheimi1, 4) end)
  if ((SV.SkyTalkBitFlags or {})[123] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[123]
  -- @label_132 [étiquette de flux ExplorerScript]
  local npc_npc_sheimi = SkySceneKit.spawn_npc("shaymin", 304, 264, Direction.UpLeft, "NPC_SHEIMI")
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Send a [CS:I]Sky Gift[CR] to a friend?", french="Envoyer un [CS:I]Don du Ciel[CR]\nà un ami?", german="Möchtest du ein [CS:I]Himmelspräsent[CR]\nan einen Freund schicken?", italian="Vuoi inviare un [CS:I]Dono Cielo[CR]\na un amico?", spanish=" ¿Quieres enviar un [CS:I]Regalo Cielo[CR]?"})
  do local __choice = SkySceneKit.ask({{english="Send", french="Envoyer", german="Schicken", italian="Invia", spanish="Enviar"}, {english="Info", french="Infos", german="Info", italian="Info", spanish="Información"}, {english="Cancel", french="Annuler", german="Zurück", italian="Annulla", spanish="Salir"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 1 then
  -- @label_133 [étiquette de flux ExplorerScript]
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_BAG"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_) [ProcessSpecial(PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_BAG): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw >= 1 then
  -- @label_136 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Who will you send it to?", french=" A qui voulez-vous l'envoyer?", german=" Wem möchtest du es schicken?", italian=" A chi vuoi inviarlo?", spanish=" ¿A quién quieres enviárselo?"})
  do local __choice = SkySceneKit.ask({{english="Guildmaster", french="Au Maître de la Guilde", german="Gildenmeister", italian="Al Capitano", spanish="Gran Bluff"}, {english="Chatot", french="A Pijako", german="Plaudagei", italian="Chatot", spanish="Chatot"}, {english="Diglett", french="A Taupiqueur", german="Digda", italian="Diglett", spanish="Diglett"}, {english="Dugtrio", french="A Triopikeur", german="Digdri", italian="Dugtrio", spanish="Dugtrio"}, {english="Sunflora", french="A Héliatronc", german="Sonnflora", italian="Sunflora", spanish="Sunflora"}, {english="Loudred", french="A Ramboum", german="Krakeelo", italian="Loudred", spanish="Loudred"}, {english="Corphish", french="A Ecrapince", german="Krebscorps", italian="Corphish", spanish="Corphish"}, {english="Chimecho", french="A Eoko", german="Palimpalim", italian="Chimecho", spanish="Chimecho"}, {english="Bidoof", french="A Keunotor", german="Bidiza", italian="Bidoof", spanish="Bidoof"}, {english="Croagunk", french="A Cradopaud", german="Glibunkel", italian="Croagunk", spanish="Croagunk"}, {english="[partner]", french="A [partner]", german="[partner]", italian="[partner]", spanish="[partner]"}, {english="Cancel", french="Annuler", german="Zurück", italian="Annulla", spanish="Salir"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  if ((SV.SkyScenarioBitFlags or {})[51] == 1) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[51]
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="We are currently sending a gift\nto [CS:N]Chatot[CR].", french="Nous acheminons en ce moment\nle cadeau destiné à [CS:N]Pijako[CR].", german="Wir liefern zurzeit [CS:N]Plaudagei[CR]\nein Präsent aus.", italian="Stiamo inviando un dono\na [CS:N]Chatot[CR].", spanish="Estamos en proceso de enviar\nun regalo a [CS:N]Chatot[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Maybe there will be a reply, so\nplease wait a little while to send another one.", french="Il y aura peut-être une réponse,\nalors veuillez patienter un peu avant d'envoyer\nun autre cadeau.", german="Vielleicht wird es eine Antwort\ngeben, also warte eine Weile, bevor du erneut\neines verschickst.", italian="Forse riceverai una risposta,\nquindi aspetta un po' prima di inviarne un altro.", spanish="Puede que haya respuesta, así\nque debes esperar para enviar otro regalo\nal mismo Pokémon."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="If there is any reply for\nTeam [team:], we will pass it along to\n[CS:N]Spinda[CR] to deliver to you...", french="Si nous recevons une réponse\npour l'Equipe [team:], nous la donnerons à\n[CS:N]Spinda[CR] afin qu'il vous la transmette...", german="Wenn wir eine Antwort für\nTeam [team:] erhalten, geben wir sie\n[CS:N]Pandir[CR], damit sie dich erreicht.", italian="In caso il Team [team:]\nriceva una risposta, potrai leggerla presso\nil Barsucco di [CS:N]Spinda[CR]...", spanish="Si hay alguna respuesta para el\n[CS:X]Equipo[CR] [team:], se la mandaremos a\n[CS:N]Spinda[CR] para que os la entregue..."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Please check with [CS:N]Spinda[CR].", french=" Veuillez consulter [CS:N]Spinda[CR].", german=" Bitte frag bei [CS:N]Pandir[CR] nach.", italian=" Controlla da [CS:N]Spinda[CR].", spanish=" Visita a [CS:N]Spinda[CR] para saberlo."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Is it OK to send it to [CS:N]Chatot[CR]?", french="Voulez-vous vraiment l'envoyer\nà [CS:N]Pijako[CR]?", german="Möchtest du es [CS:N]Plaudagei[CR]\nschicken?", italian=" Vuoi inviarlo a [CS:N]Chatot[CR]?", spanish=" ¿Quieres enviárselo a [CS:N]Chatot[CR]?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- jump @label_136 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[51] = 1 -- $SCENARIO_MAIN_BIT_FLAG[51] = 1 (ROM)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_REMOVE_ITEMS_TYPE_IN_BAG, 180, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="OK. That's one [CS:I]Sky Gift[CR], to be\nsent to [CS:N]Chatot[CR]! ♪", french="Emballez, c'est pesé!\nEt un [CS:I]Don du Ciel[CR] pour [CS:N]Pijako[CR], un! ♪", german="Okay! Ein [CS:I]Himmelspräsent[CR] wurde\nan [CS:N]Plaudagei[CR] verschickt! ♪", italian="Ok. [CS:I]Dono Cielo[CR] da inviare a\n[CS:N]Chatot[CR] pronto per la spedizione! ♪", spanish="De acuerdo. ¡Marchando un\n[CS:I]Regalo Cielo[CR] para [CS:N]Chatot[CR]! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Anything else we can do?", french="Désirez-vous en envoyer\nun autre?", german=" Möchtest du noch eins schicken?", italian=" Vuoi inviarne un altro?", spanish=" ¿Deseas enviar otro?"})
  -- jump @label_152 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  elseif __choice == 3 then
  if ((SV.SkyScenarioBitFlags or {})[52] == 1) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[52]
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="We are currently sending a gift\nto [CS:N]Diglett[CR].", french="Nous acheminons en ce moment\nle cadeau destiné à [CS:N]Taupiqueur[CR].", german="Wir liefern zurzeit [CS:N]Digda[CR]\nein Präsent aus.", italian="Stiamo inviando un dono\na [CS:N]Diglett[CR].", spanish="Estamos en proceso de enviar\nun regalo a [CS:N]Diglett[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Maybe there will be a reply, so\nplease wait a little while to send another one.", french="Il y aura peut-être une réponse,\nalors veuillez patienter un peu avant d'envoyer\nun autre cadeau.", german="Vielleicht wird es eine Antwort\ngeben, also warte eine Weile, bevor du erneut\neines verschickst.", italian="Forse riceverai una risposta,\nquindi aspetta un po' prima di inviarne un altro.", spanish="Puede que haya respuesta, así\nque debes esperar para enviar otro regalo\nal mismo Pokémon."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="If there is any reply for\nTeam [team:], we will pass it along to\n[CS:N]Spinda[CR] to deliver to you...", french="Si nous recevons une réponse\npour l'Equipe [team:], nous la donnerons à\n[CS:N]Spinda[CR] afin qu'il vous la transmette...", german="Wenn wir eine Antwort für\nTeam [team:] erhalten, geben wir sie\n[CS:N]Pandir[CR], damit sie dich erreicht.", italian="In caso il Team [team:]\nriceva una risposta, potrai leggerla presso\nil Barsucco di [CS:N]Spinda[CR]...", spanish="Si hay alguna respuesta para el\n[CS:X]Equipo[CR] [team:], se la mandaremos a\n[CS:N]Spinda[CR] para que os la entregue..."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Please check with [CS:N]Spinda[CR].", french=" Veuillez consulter [CS:N]Spinda[CR].", german=" Bitte frag bei [CS:N]Pandir[CR] nach.", italian=" Controlla da [CS:N]Spinda[CR].", spanish=" Visita a [CS:N]Spinda[CR] para saberlo."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Is it OK to send it to [CS:N]Diglett[CR]?", french="Voulez-vous vraiment l'envoyer\nà [CS:N]Taupiqueur[CR]?", german="Möchtest du es [CS:N]Digda[CR]\nschicken?", italian=" Vuoi inviarlo a [CS:N]Diglett[CR]?", spanish=" ¿Quieres enviárselo a [CS:N]Diglett[CR]?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- jump @label_136 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[52] = 1 -- $SCENARIO_MAIN_BIT_FLAG[52] = 1 (ROM)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_REMOVE_ITEMS_TYPE_IN_BAG, 180, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="OK. That's one [CS:I]Sky Gift[CR], to be\nsent to [CS:N]Diglett[CR]! ♪", french="Emballez, c'est pesé!\nEt un [CS:I]Don du Ciel[CR] pour [CS:N]Taupiqueur[CR], un! ♪", german="Okay! Ein [CS:I]Himmelspräsent[CR] wurde\nan [CS:N]Digda[CR] verschickt! ♪", italian="Ok. [CS:I]Dono Cielo[CR] da inviare a\n[CS:N]Diglett[CR] pronto per la spedizione! ♪", spanish="De acuerdo. ¡Marchando un\n[CS:I]Regalo Cielo[CR] para [CS:N]Diglett[CR]! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Anything else we can do?", french="Désirez-vous en envoyer\nun autre?", german=" Möchtest du noch eins schicken?", italian=" Vuoi inviarne un altro?", spanish=" ¿Deseas enviar otro?"})
  -- jump @label_152 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  elseif __choice == 4 then
  if ((SV.SkyScenarioBitFlags or {})[53] == 1) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[53]
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="We are currently sending a gift\nto [CS:N]Dugtrio[CR].", french="Nous acheminons en ce moment\nle cadeau destiné à [CS:N]Triopikeur[CR].", german="Wir liefern zurzeit [CS:N]Digdri[CR]\nein Präsent aus.", italian="Stiamo inviando un dono\na [CS:N]Dugtrio[CR].", spanish="Estamos en proceso de enviar\nun regalo a [CS:N]Dugtrio[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Maybe there will be a reply, so\nplease wait a little while to send another one.", french="Il y aura peut-être une réponse,\nalors veuillez patienter un peu avant d'envoyer\nun autre cadeau.", german="Vielleicht wird es eine Antwort\ngeben, also warte eine Weile, bevor du erneut\neines verschickst.", italian="Forse riceverai una risposta,\nquindi aspetta un po' prima di inviarne un altro.", spanish="Puede que haya respuesta, así\nque debes esperar para enviar otro regalo\nal mismo Pokémon."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="If there is any reply for\nTeam [team:], we will pass it along to\n[CS:N]Spinda[CR] to deliver to you...", french="Si nous recevons une réponse\npour l'Equipe [team:], nous la donnerons à\n[CS:N]Spinda[CR] afin qu'il vous la transmette...", german="Wenn wir eine Antwort für\nTeam [team:] erhalten, geben wir sie\n[CS:N]Pandir[CR], damit sie dich erreicht.", italian="In caso il Team [team:]\nriceva una risposta, potrai leggerla presso\nil Barsucco di [CS:N]Spinda[CR]...", spanish="Si hay alguna respuesta para el\n[CS:X]Equipo[CR] [team:], se la mandaremos a\n[CS:N]Spinda[CR] para que os la entregue..."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Please check with [CS:N]Spinda[CR].", french=" Veuillez consulter [CS:N]Spinda[CR].", german=" Bitte frag bei [CS:N]Pandir[CR] nach.", italian=" Controlla da [CS:N]Spinda[CR].", spanish=" Visita a [CS:N]Spinda[CR] para saberlo."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Is it OK to send it to [CS:N]Dugtrio[CR]?", french="Voulez-vous vraiment l'envoyer\nà [CS:N]Triopikeur[CR]?", german="Möchtest du es [CS:N]Digdri[CR]\nschicken?", italian=" Vuoi inviarlo a [CS:N]Dugtrio[CR]?", spanish=" ¿Quieres enviárselo a [CS:N]Dugtrio[CR]?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- jump @label_136 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[53] = 1 -- $SCENARIO_MAIN_BIT_FLAG[53] = 1 (ROM)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_REMOVE_ITEMS_TYPE_IN_BAG, 180, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="OK. That's one [CS:I]Sky Gift[CR], to be\nsent to [CS:N]Dugtrio[CR]! ♪", french="Emballez, c'est pesé!\nEt un [CS:I]Don du Ciel[CR] pour [CS:N]Triopikeur[CR], un! ♪", german="Okay! Ein [CS:I]Himmelspräsent[CR] wurde\nan [CS:N]Digdri[CR] verschickt! ♪", italian="Ok. [CS:I]Dono Cielo[CR] da inviare a\n[CS:N]Dugtrio[CR] pronto per la spedizione! ♪", spanish="De acuerdo. ¡Marchando un\n[CS:I]Regalo Cielo[CR] para [CS:N]Dugtrio[CR]! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Anything else we can do?", french="Désirez-vous en envoyer\nun autre?", german=" Möchtest du noch eins schicken?", italian=" Vuoi inviarne un altro?", spanish=" ¿Deseas enviar otro?"})
  -- jump @label_152 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  elseif __choice == 5 then
  if ((SV.SkyScenarioBitFlags or {})[54] == 1) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[54]
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="We are currently sending a gift\nto [CS:N]Sunflora[CR].", french="Nous acheminons en ce moment\nle cadeau destiné à [CS:N]Héliatronc[CR].", german="Wir liefern zurzeit [CS:N]Sonnflora[CR]\nein Präsent aus.", italian="Stiamo inviando un dono\na [CS:N]Sunflora[CR].", spanish="Estamos en proceso de enviar\nun regalo a [CS:N]Sunflora[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Maybe there will be a reply, so\nplease wait a little while to send another one.", french="Il y aura peut-être une réponse,\nalors veuillez patienter un peu avant d'envoyer\nun autre cadeau.", german="Vielleicht wird es eine Antwort\ngeben, also warte eine Weile, bevor du erneut\neines verschickst.", italian="Forse riceverai una risposta,\nquindi aspetta un po' prima di inviarne un altro.", spanish="Puede que haya respuesta, así\nque debes esperar para enviar otro regalo\nal mismo Pokémon."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="If there is any reply for\nTeam [team:], we will pass it along to\n[CS:N]Spinda[CR] to deliver to you...", french="Si nous recevons une réponse\npour l'Equipe [team:], nous la donnerons à\n[CS:N]Spinda[CR] afin qu'il vous la transmette...", german="Wenn wir eine Antwort für\nTeam [team:] erhalten, geben wir sie\n[CS:N]Pandir[CR], damit sie dich erreicht.", italian="In caso il Team [team:]\nriceva una risposta, potrai leggerla presso\nil Barsucco di [CS:N]Spinda[CR]...", spanish="Si hay alguna respuesta para el\n[CS:X]Equipo[CR] [team:], se la mandaremos a\n[CS:N]Spinda[CR] para que os la entregue..."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Please check with [CS:N]Spinda[CR].", french=" Veuillez consulter [CS:N]Spinda[CR].", german=" Bitte frag bei [CS:N]Pandir[CR] nach.", italian=" Controlla da [CS:N]Spinda[CR].", spanish=" Visita a [CS:N]Spinda[CR] para saberlo."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Is it OK to send it to [CS:N]Sunflora[CR]?", french="Voulez-vous vraiment l'envoyer\nà [CS:N]Héliatronc[CR]?", german="Möchtest du es [CS:N]Sonnflora[CR]\nschicken?", italian=" Vuoi inviarlo a [CS:N]Sunflora[CR]?", spanish=" ¿Quieres enviárselo a [CS:N]Sunflora[CR]?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- jump @label_136 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[54] = 1 -- $SCENARIO_MAIN_BIT_FLAG[54] = 1 (ROM)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_REMOVE_ITEMS_TYPE_IN_BAG, 180, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="OK. That's one [CS:I]Sky Gift[CR], to be\nsent to [CS:N]Sunflora[CR]! ♪", french="Emballez, c'est pesé!\nEt un [CS:I]Don du Ciel[CR] pour [CS:N]Héliatronc[CR], un! ♪", german="Okay! Ein [CS:I]Himmelspräsent[CR] wurde\nan [CS:N]Sonnflora[CR] verschickt! ♪", italian="Ok. [CS:I]Dono Cielo[CR] da inviare a\n[CS:N]Sunflora[CR] pronto per la spedizione! ♪", spanish="De acuerdo. ¡Marchando un\n[CS:I]Regalo Cielo[CR] para [CS:N]Sunflora[CR]! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Anything else we can do?", french="Désirez-vous en envoyer\nun autre?", german=" Möchtest du noch eins schicken?", italian=" Vuoi inviarne un altro?", spanish=" ¿Deseas enviar otro?"})
  -- jump @label_152 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  elseif __choice == 6 then
  if ((SV.SkyScenarioBitFlags or {})[55] == 1) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[55]
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="We are currently sending a gift\nto [CS:N]Loudred[CR].", french="Nous acheminons en ce moment\nle cadeau destiné à [CS:N]Ramboum[CR].", german="Wir liefern zurzeit [CS:N]Krakeelo[CR]\nein Präsent aus.", italian="Stiamo inviando un dono\na [CS:N]Loudred[CR].", spanish="Estamos en proceso de enviar\nun regalo a [CS:N]Loudred[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Maybe there will be a reply, so\nplease wait a little while to send another one.", french="Il y aura peut-être une réponse,\nalors veuillez patienter un peu avant d'envoyer\nun autre cadeau.", german="Vielleicht wird es eine Antwort\ngeben, also warte eine Weile, bevor du erneut\neines verschickst.", italian="Forse riceverai una risposta,\nquindi aspetta un po' prima di inviarne un altro.", spanish="Puede que haya respuesta, así\nque debes esperar para enviar otro regalo\nal mismo Pokémon."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="If there is any reply for\nTeam [team:], we will pass it along to\n[CS:N]Spinda[CR] to deliver to you...", french="Si nous recevons une réponse\npour l'Equipe [team:], nous la donnerons à\n[CS:N]Spinda[CR] afin qu'il vous la transmette...", german="Wenn wir eine Antwort für\nTeam [team:] erhalten, geben wir sie\n[CS:N]Pandir[CR], damit sie dich erreicht.", italian="In caso il Team [team:]\nriceva una risposta, potrai leggerla presso\nil Barsucco di [CS:N]Spinda[CR]...", spanish="Si hay alguna respuesta para el\n[CS:X]Equipo[CR] [team:], se la mandaremos a\n[CS:N]Spinda[CR] para que os la entregue..."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Please check with [CS:N]Spinda[CR].", french=" Veuillez consulter [CS:N]Spinda[CR].", german=" Bitte frag bei [CS:N]Pandir[CR] nach.", italian=" Controlla da [CS:N]Spinda[CR].", spanish=" Visita a [CS:N]Spinda[CR] para saberlo."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Is it OK to send it to [CS:N]Loudred[CR]?", french="Voulez-vous vraiment l'envoyer\nà [CS:N]Ramboum[CR]?", german="Möchtest du es [CS:N]Krakeelo[CR]\nschicken?", italian=" Vuoi inviarlo a [CS:N]Loudred[CR]?", spanish=" ¿Quieres enviárselo a [CS:N]Loudred[CR]?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- jump @label_136 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[55] = 1 -- $SCENARIO_MAIN_BIT_FLAG[55] = 1 (ROM)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_REMOVE_ITEMS_TYPE_IN_BAG, 180, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="OK. That's one [CS:I]Sky Gift[CR], to be\nsent to [CS:N]Loudred[CR]! ♪", french="Emballez, c'est pesé!\nEt un [CS:I]Don du Ciel[CR] pour [CS:N]Ramboum[CR], un! ♪", german="Okay! Ein [CS:I]Himmelspräsent[CR] wurde\nan [CS:N]Krakeelo[CR] verschickt! ♪", italian="Ok. [CS:I]Dono Cielo[CR] da inviare a\n[CS:N]Loudred[CR] pronto per la spedizione! ♪", spanish="De acuerdo. ¡Marchando un\n[CS:I]Regalo Cielo[CR] para [CS:N]Loudred[CR]! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Anything else we can do?", french="Désirez-vous en envoyer\nun autre?", german=" Möchtest du noch eins schicken?", italian=" Vuoi inviarne un altro?", spanish=" ¿Deseas enviar otro?"})
  -- jump @label_152 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  elseif __choice == 7 then
  if ((SV.SkyScenarioBitFlags or {})[56] == 1) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[56]
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="We are currently sending a gift\nto [CS:N]Corphish[CR].", french="Nous acheminons en ce moment\nle cadeau destiné à [CS:N]Ecrapince[CR].", german="Wir liefern zurzeit [CS:N]Krebscorps[CR]\nein Präsent aus.", italian="Stiamo inviando un dono\na [CS:N]Corphish[CR].", spanish="Estamos en proceso de enviar\nun regalo a [CS:N]Corphish[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Maybe there will be a reply, so\nplease wait a little while to send another one.", french="Il y aura peut-être une réponse,\nalors veuillez patienter un peu avant d'envoyer\nun autre cadeau.", german="Vielleicht wird es eine Antwort\ngeben, also warte eine Weile, bevor du erneut\neines verschickst.", italian="Forse riceverai una risposta,\nquindi aspetta un po' prima di inviarne un altro.", spanish="Puede que haya respuesta, así\nque debes esperar para enviar otro regalo\nal mismo Pokémon."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="If there is any reply for\nTeam [team:], we will pass it along to\n[CS:N]Spinda[CR] to deliver to you...", french="Si nous recevons une réponse\npour l'Equipe [team:], nous la donnerons à\n[CS:N]Spinda[CR] afin qu'il vous la transmette...", german="Wenn wir eine Antwort für\nTeam [team:] erhalten, geben wir sie\n[CS:N]Pandir[CR], damit sie dich erreicht.", italian="In caso il Team [team:]\nriceva una risposta, potrai leggerla presso\nil Barsucco di [CS:N]Spinda[CR]...", spanish="Si hay alguna respuesta para el\n[CS:X]Equipo[CR] [team:], se la mandaremos a\n[CS:N]Spinda[CR] para que os la entregue..."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Please check with [CS:N]Spinda[CR].", french=" Veuillez consulter [CS:N]Spinda[CR].", german=" Bitte frag bei [CS:N]Pandir[CR] nach.", italian=" Controlla da [CS:N]Spinda[CR].", spanish=" Visita a [CS:N]Spinda[CR] para saberlo."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Is it OK to send it to [CS:N]Corphish[CR]?", french="Voulez-vous vraiment l'envoyer\nà [CS:N]Ecrapince[CR]?", german="Möchtest du es [CS:N]Krebscorps[CR]\nschicken?", italian=" Vuoi inviarlo a [CS:N]Corphish[CR]?", spanish=" ¿Quieres enviárselo a [CS:N]Corphish[CR]?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- jump @label_136 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[56] = 1 -- $SCENARIO_MAIN_BIT_FLAG[56] = 1 (ROM)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_REMOVE_ITEMS_TYPE_IN_BAG, 180, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="OK. That's one [CS:I]Sky Gift[CR], to be\nsent to [CS:N]Corphish[CR]! ♪", french="Emballez, c'est pesé!\nEt un [CS:I]Don du Ciel[CR] pour [CS:N]Ecrapince[CR], un! ♪", german="Okay! Ein [CS:I]Himmelspräsent[CR] wurde\nan [CS:N]Krebscorps[CR] verschickt! ♪", italian="Ok. [CS:I]Dono Cielo[CR] da inviare a\n[CS:N]Corphish[CR] pronto per la spedizione! ♪", spanish="De acuerdo. ¡Marchando un\n[CS:I]Regalo Cielo[CR] para [CS:N]Corphish[CR]! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Anything else we can do?", french="Désirez-vous en envoyer\nun autre?", german=" Möchtest du noch eins schicken?", italian=" Vuoi inviarne un altro?", spanish=" ¿Deseas enviar otro?"})
  -- jump @label_152 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  elseif __choice == 8 then
  if ((SV.SkyScenarioBitFlags or {})[57] == 1) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[57]
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="We are currently sending a gift\nto [CS:N]Chimecho[CR].", french="Nous acheminons en ce moment\nle cadeau destiné à [CS:N]Eoko[CR].", german="Wir liefern zurzeit [CS:N]Palimpalim[CR]\nein Präsent aus.", italian="Stiamo inviando un dono\na [CS:N]Chimecho[CR].", spanish="Estamos en proceso de enviar\nun regalo a [CS:N]Chimecho[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Maybe there will be a reply, so\nplease wait a little while to send another one.", french="Il y aura peut-être une réponse,\nalors veuillez patienter un peu avant d'envoyer\nun autre cadeau.", german="Vielleicht wird es eine Antwort\ngeben, also warte eine Weile, bevor du erneut\neines verschickst.", italian="Forse riceverai una risposta,\nquindi aspetta un po' prima di inviarne un altro.", spanish="Puede que haya respuesta, así\nque debes esperar para enviar otro regalo\nal mismo Pokémon."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="If there is any reply for\nTeam [team:], we will pass it along to\n[CS:N]Spinda[CR] to deliver to you...", french="Si nous recevons une réponse\npour l'Equipe [team:], nous la donnerons à\n[CS:N]Spinda[CR] afin qu'il vous la transmette...", german="Wenn wir eine Antwort für\nTeam [team:] erhalten, geben wir sie\n[CS:N]Pandir[CR], damit sie dich erreicht.", italian="In caso il Team [team:]\nriceva una risposta, potrai leggerla presso\nil Barsucco di [CS:N]Spinda[CR]...", spanish="Si hay alguna respuesta para el\n[CS:X]Equipo[CR] [team:], se la mandaremos a\n[CS:N]Spinda[CR] para que os la entregue..."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Please check with [CS:N]Spinda[CR].", french=" Veuillez consulter [CS:N]Spinda[CR].", german=" Bitte frag bei [CS:N]Pandir[CR] nach.", italian=" Controlla da [CS:N]Spinda[CR].", spanish=" Visita a [CS:N]Spinda[CR] para saberlo."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Send it to [CS:N]Chimecho[CR]?", french="Voulez-vous vraiment l'envoyer\nà [CS:N]Eoko[CR]?", german="Möchtest du es [CS:N]Palimpalim[CR]\nschicken?", italian=" Vuoi inviarlo a [CS:N]Chimecho[CR]?", spanish=" ¿Quieres enviárselo a [CS:N]Chimecho[CR]?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- jump @label_136 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[57] = 1 -- $SCENARIO_MAIN_BIT_FLAG[57] = 1 (ROM)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_REMOVE_ITEMS_TYPE_IN_BAG, 180, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="OK. That's one [CS:I]Sky Gift[CR], to be\nsent to [CS:N]Chimecho[CR]! ♪", french="Emballez, c'est pesé!\nEt un [CS:I]Don du Ciel[CR] pour [CS:N]Eoko[CR], un! ♪", german="Okay! Ein [CS:I]Himmelspräsent[CR] wurde\nan [CS:N]Palimpalim[CR] verschickt! ♪", italian="Ok. [CS:I]Dono Cielo[CR] da inviare a\n[CS:N]Chimecho[CR] pronto per la spedizione! ♪", spanish="De acuerdo. ¡Marchando un\n[CS:I]Regalo Cielo[CR] para [CS:N]Chimecho[CR]! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Anything else we can do?", french="Désirez-vous en envoyer\nun autre?", german=" Möchtest du noch eins schicken?", italian=" Vuoi inviarne un altro?", spanish=" ¿Deseas enviar otro?"})
  -- jump @label_152 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  elseif __choice == 9 then
  if ((SV.SkyScenarioBitFlags or {})[58] == 1) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[58]
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="We are currently sending a gift\nto [CS:N]Bidoof[CR].", french="Nous acheminons en ce moment\nle cadeau destiné à [CS:N]Keunotor[CR].", german="Wir liefern zurzeit [CS:N]Bidiza[CR]\nein Präsent aus.", italian="Stiamo inviando un dono\na [CS:N]Bidoof[CR].", spanish="Estamos en proceso de enviar\nun regalo a [CS:N]Bidoof[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Maybe there will be a reply, so\nplease wait a little while to send another one.", french="Il y aura peut-être une réponse,\nalors veuillez patienter un peu avant d'envoyer\nun autre cadeau.", german="Vielleicht wird es eine Antwort\ngeben, also warte eine Weile, bevor du erneut\neines verschickst.", italian="Forse riceverai una risposta,\nquindi aspetta un po' prima di inviarne un altro.", spanish="Puede que haya respuesta, así\nque debes esperar para enviar otro regalo\nal mismo Pokémon."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="If there is any reply for\nTeam [team:], we will pass it along to\n[CS:N]Spinda[CR] to deliver to you...", french="Si nous recevons une réponse\npour l'Equipe [team:], nous la donnerons à\n[CS:N]Spinda[CR] afin qu'il vous la transmette...", german="Wenn wir eine Antwort für\nTeam [team:] erhalten, geben wir sie\n[CS:N]Pandir[CR], damit sie dich erreicht.", italian="In caso il Team [team:]\nriceva una risposta, potrai leggerla presso\nil Barsucco di [CS:N]Spinda[CR]...", spanish="Si hay alguna respuesta para el\n[CS:X]Equipo[CR] [team:], se la mandaremos a\n[CS:N]Spinda[CR] para que os la entregue..."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Please check with [CS:N]Spinda[CR].", french=" Veuillez consulter [CS:N]Spinda[CR].", german=" Bitte frag bei [CS:N]Pandir[CR] nach.", italian=" Controlla da [CS:N]Spinda[CR].", spanish=" Visita a [CS:N]Spinda[CR] para saberlo."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Is it OK to send it to [CS:N]Bidoof[CR]?", french="Voulez-vous vraiment l'envoyer\nà [CS:N]Keunotor[CR]?", german="Möchtest du es [CS:N]Bidiza[CR]\nschicken?", italian=" Vuoi inviarlo a [CS:N]Bidoof[CR]?", spanish=" ¿Quieres enviárselo a [CS:N]Bidoof[CR]?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- jump @label_136 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[58] = 1 -- $SCENARIO_MAIN_BIT_FLAG[58] = 1 (ROM)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_REMOVE_ITEMS_TYPE_IN_BAG, 180, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="OK. That's one [CS:I]Sky Gift[CR], to be\nsent to [CS:N]Bidoof[CR]! ♪", french="Emballez, c'est pesé!\nEt un [CS:I]Don du Ciel[CR] pour [CS:N]Keunotor[CR], un! ♪", german="Okay! Ein [CS:I]Himmelspräsent[CR] wurde\nan [CS:N]Bidiza[CR] verschickt! ♪", italian="Ok. [CS:I]Dono Cielo[CR] da inviare a\n[CS:N]Bidoof[CR] pronto per la spedizione! ♪", spanish="De acuerdo. ¡Marchando un\n[CS:I]Regalo Cielo[CR] para [CS:N]Bidoof[CR]! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Anything else we can do?", french="Désirez-vous en envoyer\nun autre?", german=" Möchtest du noch eins schicken?", italian=" Vuoi inviarne un altro?", spanish=" ¿Deseas enviar otro?"})
  -- jump @label_152 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  elseif __choice == 10 then
  if ((SV.SkyScenarioBitFlags or {})[59] == 1) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[59]
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="We are currently sending a gift\nto [CS:N]Croagunk[CR].", french="Nous acheminons en ce moment\nle cadeau destiné à [CS:N]Cradopaud[CR].", german="Wir liefern zurzeit [CS:N]Glibunkel[CR]\nein Präsent aus.", italian="Stiamo inviando un dono\na [CS:N]Croagunk[CR].", spanish="Estamos en proceso de enviar\nun regalo a [CS:N]Croagunk[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Maybe there will be a reply, so\nplease wait a little while to send another one.", french="Il y aura peut-être une réponse,\nalors veuillez patienter un peu avant d'envoyer\nun autre cadeau.", german="Vielleicht wird es eine Antwort\ngeben, also warte eine Weile, bevor du erneut\neines verschickst.", italian="Forse riceverai una risposta,\nquindi aspetta un po' prima di inviarne un altro.", spanish="Puede que haya respuesta, así\nque debes esperar para enviar otro regalo\nal mismo Pokémon."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="If there is any reply for\nTeam [team:], we will pass it along to\n[CS:N]Spinda[CR] to deliver to you...", french="Si nous recevons une réponse\npour l'Equipe [team:], nous la donnerons à\n[CS:N]Spinda[CR] afin qu'il vous la transmette...", german="Wenn wir eine Antwort für\nTeam [team:] erhalten, geben wir sie\n[CS:N]Pandir[CR], damit sie dich erreicht.", italian="In caso il Team [team:]\nriceva una risposta, potrai leggerla presso\nil Barsucco di [CS:N]Spinda[CR]...", spanish="Si hay alguna respuesta para el\n[CS:X]Equipo[CR] [team:], se la mandaremos a\n[CS:N]Spinda[CR] para que os la entregue..."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Please check with [CS:N]Spinda[CR].", french=" Veuillez consulter [CS:N]Spinda[CR].", german=" Bitte frag bei [CS:N]Pandir[CR] nach.", italian=" Controlla da [CS:N]Spinda[CR].", spanish=" Visita a [CS:N]Spinda[CR] para saberlo."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Is it OK to send it to [CS:N]Croagunk[CR]?", french="Voulez-vous vraiment l'envoyer\nà [CS:N]Cradopaud[CR]?", german="Möchtest du es [CS:N]Glibunkel[CR]\nschicken?", italian=" Vuoi inviarlo a [CS:N]Croagunk[CR]?", spanish=" ¿Quieres enviárselo a [CS:N]Croagunk[CR]?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- jump @label_136 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[59] = 1 -- $SCENARIO_MAIN_BIT_FLAG[59] = 1 (ROM)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_REMOVE_ITEMS_TYPE_IN_BAG, 180, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="OK. That's one [CS:I]Sky Gift[CR], to be\nsent to [CS:N]Croagunk[CR]! ♪", french="Emballez, c'est pesé!\nEt un [CS:I]Don du Ciel[CR] pour [CS:N]Cradopaud[CR], un! ♪", german="Okay! Ein [CS:I]Himmelspräsent[CR] wurde\nan [CS:N]Glibunkel[CR] verschickt! ♪", italian="Ok. [CS:I]Dono Cielo[CR] da inviare a\n[CS:N]Croagunk[CR] pronto per la spedizione! ♪", spanish="De acuerdo. ¡Marchando un\n[CS:I]Regalo Cielo[CR] para [CS:N]Croagunk[CR]! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Anything else we can do?", french="Désirez-vous en envoyer\nun autre?", german=" Möchtest du noch eins schicken?", italian=" Vuoi inviarne un altro?", spanish=" ¿Deseas enviar otro?"})
  -- jump @label_152 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  elseif __choice == 11 then
  if ((SV.SkyScenarioBitFlags or {})[60] == 1) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[60]
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="We are currently sending a gift\nto [partner].", french="Nous acheminons en ce moment\nle cadeau destiné à [partner].", german="Wir liefern zurzeit\n[partner] ein Präsent aus.", italian="Stiamo inviando un dono\na [partner].", spanish="Estamos en proceso de enviar\nun regalo a [partner]."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Maybe there will be a reply, so\nplease wait a little while to send another one.", french="Il y aura peut-être une réponse,\nalors veuillez patienter un peu avant d'envoyer\nun autre cadeau.", german="Vielleicht wird es eine Antwort\ngeben, also warte eine Weile, bevor du erneut\neines verschickst.", italian="Forse riceverai una risposta,\nquindi aspetta un po' prima di inviarne un altro.", spanish="Puede que haya respuesta, así\nque debes esperar para enviar otro regalo\nal mismo Pokémon."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="If there is any reply for\nTeam [team:], we will pass it along to\n[CS:N]Spinda[CR] to deliver to you...", french="Si nous recevons une réponse\npour l'Equipe [team:], nous la donnerons à\n[CS:N]Spinda[CR] afin qu'il vous la transmette...", german="Wenn wir eine Antwort für\nTeam [team:] erhalten, geben wir sie\n[CS:N]Pandir[CR], damit sie dich erreicht.", italian="In caso il Team [team:]\nriceva una risposta, potrai leggerla presso\nil Barsucco di [CS:N]Spinda[CR]...", spanish="Si hay alguna respuesta para el\n[CS:X]Equipo[CR] [team:], se la mandaremos a\n[CS:N]Spinda[CR] para que os la entregue..."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Please check with [CS:N]Spinda[CR].", french=" Veuillez consulter [CS:N]Spinda[CR].", german=" Bitte frag bei [CS:N]Pandir[CR] nach.", italian=" Controlla da [CS:N]Spinda[CR].", spanish=" Visita a [CS:N]Spinda[CR] para saberlo."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Is it OK to send it to\n[partner]?", french="Voulez-vous vraiment l'envoyer\nà [partner]?", german="Möchtest du es [partner]\nschicken?", italian=" Vuoi inviarlo a [partner]?", spanish="¿Quieres enviárselo a\n[partner]?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- jump @label_136 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[60] = 1 -- $SCENARIO_MAIN_BIT_FLAG[60] = 1 (ROM)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_REMOVE_ITEMS_TYPE_IN_BAG, 180, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="OK. That's one [CS:I]Sky Gift[CR], to be\nsent to [partner]! ♪", french="Emballez, c'est pesé!\nEt un [CS:I]Don du Ciel[CR] pour [partner], un! ♪", german="Okay! Ein [CS:I]Himmelspräsent[CR] wurde\nan [partner] verschickt! ♪", italian="Ok. [CS:I]Dono Cielo[CR] da inviare a\n[partner] pronto per la spedizione! ♪", spanish="De acuerdo. ¡Marchando un\n[CS:I]Regalo Cielo[CR] para [partner]! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Anything else we can do?", french="Désirez-vous en envoyer\nun autre?", german=" Möchtest du noch eins schicken?", italian=" Vuoi inviarne un altro?", spanish=" ¿Deseas enviar otro?"})
  -- jump @label_152 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  elseif __choice == 12 then
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Come back anytime you want to\nsend a gift! ♪", french="N'hésitez pas à repasser dès\nque vous désirez envoyer un cadeau! ♪", german="Komm zurück, wann immer du\nein Präsent verschicken möchtest! ♪", italian="Torna pure quando vuoi per\nspedire un dono! ♪", spanish="¡Vuelve siempre que quieras\nenviar un regalo! ♪"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  if ((SV.SkyScenarioBitFlags or {})[50] == 1) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[50]
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="We are currently sending a gift\nto the Guildmaster.", french="Nous acheminons en ce moment\nle cadeau destiné au Maître de la Guilde.", german="Wir liefern zurzeit dem\nGildenmeister ein Präsent aus.", italian="Stiamo inviando un dono\nal Capitano.", spanish="Estamos en proceso de enviar\nun regalo al Gran Bluff."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Maybe there will be a reply, so\nplease wait a little while to send another one.", french="Il y aura peut-être une réponse,\nalors veuillez patienter un peu avant d'envoyer\nun autre cadeau.", german="Vielleicht wird es eine Antwort\ngeben, also warte eine Weile, bevor du erneut\neines verschickst.", italian="Forse riceverai una risposta,\nquindi aspetta un po' prima di inviarne un altro.", spanish="Puede que haya respuesta, así\nque debes esperar para enviar otro regalo\nal mismo Pokémon."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="If there is any reply for\nTeam [team:], we will pass it along to\n[CS:N]Spinda[CR] to deliver to you...", french="Si nous recevons une réponse\npour l'Equipe [team:], nous la donnerons à\n[CS:N]Spinda[CR] afin qu'il vous la transmette...", german="Wenn wir eine Antwort für\nTeam [team:] erhalten, geben wir sie\n[CS:N]Pandir[CR], damit sie dich erreicht.", italian="In caso il Team [team:]\nriceva una risposta, potrai leggerla presso\nil Barsucco di [CS:N]Spinda[CR]...", spanish="Si hay alguna respuesta para el\n[CS:X]Equipo[CR] [team:], se la mandaremos a\n[CS:N]Spinda[CR] para que os la entregue..."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Please check with [CS:N]Spinda[CR].", french=" Veuillez consulter [CS:N]Spinda[CR].", german=" Bitte frag bei [CS:N]Pandir[CR] nach.", italian=" Controlla da [CS:N]Spinda[CR].", spanish=" Visita a [CS:N]Spinda[CR] para saberlo."})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Is it OK to send it to the\nGuildmaster?", french="Voulez-vous vraiment l'envoyer\nau Maître de la Guilde?", german="Möchtest du es dem\nGildenmeister schicken?", italian=" Vuoi inviarlo al Capitano?", spanish="¿Quieres enviárselo\nal Gran Bluff?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- jump @label_136 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[50] = 1 -- $SCENARIO_MAIN_BIT_FLAG[50] = 1 (ROM)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_REMOVE_ITEMS_TYPE_IN_BAG, 180, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="OK. That's one [CS:I]Sky Gift[CR], to be\nsent to the Guildmaster! ♪", french="Emballez, c'est pesé!\nEt un [CS:I]Don du Ciel[CR] pour le Maître de\nla Guilde, un! ♪", german="Okay! Ein [CS:I]Himmelspräsent[CR] wurde\nan den Gildenmeister verschickt! ♪", italian="Ok. [CS:I]Dono Cielo[CR] da inviare al\nCapitano pronto per la spedizione! ♪", spanish="De acuerdo. ¡Marchando un\n[CS:I]Regalo Cielo[CR] para el Gran Bluff! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Anything else we can do?", french="Désirez-vous en envoyer\nun autre?", german=" Möchtest du noch eins schicken?", italian=" Vuoi inviarne un altro?", spanish=" ¿Deseas enviar otro?"})
  -- @label_152 [étiquette de flux ExplorerScript]
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SEND_SKY_GIFT_TO_GUILDMASTER, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 1 then
  -- jump @label_133 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Come back anytime you want to\nsend a gift. ♪", french="N'hésitez pas à repasser dès\nque vous désirez envoyer un cadeau! ♪", german="Komm zurück, wann immer du\nein Präsent verschicken möchtest! ♪", italian="Torna pure quando vuoi per\nspedire un dono! ♪", spanish="Vuelve siempre que quieras\nenviar un regalo. ♪"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  end
  end
  end
  elseif true then -- default
  -- @label_137 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Oh? I'm afraid you don't\nhave any [CS:I]Sky Gift[CR]s.", french="Oh? J'ai bien peur\nque vous n'ayez aucun [CS:I]Don du Ciel[CR].", german="Oh, leider besitzt du kein\n[CS:I]Himmelspräsent[CR].", italian="Oh? Temo che tu non abbia\nnessun [CS:I]Dono Cielo[CR].", spanish="Vaya, me temo que no tienes\nningún [CS:I]Regalo Cielo[CR]."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif __choice == 2 then
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="[CS:K]Shaymin[CR]'s Delivery Service\nwill send [CS:I]Sky Gift[CR]s to your friends for you.", french="Le [CS:K]Service de Livraison\nShaymin[CR] distribue en votre nom\ndes [CS:I]Dons du Ciel[CR] à vos amis.", german="Der [CS:K]Shaymin-Lieferservice[CR]\nliefert [CS:I]Himmelspräsente[CR] an deine Freunde.", italian="Il Servizio Consegne [CS:K]Shaymin[CR]\nsi occupa di inviare [CS:I]Doni Cielo[CR] ai tuoi amici.", spanish="[CS:K]Repartos Shaymin[CR]\nenvía [CS:I]Regalos Cielo[CR] a tus amigos."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Handing out gifts in person is so\nvery exciting...", french="Livrer les cadeaux en personne,\nc'est si excitant.", german="Präsente zu überbringen\nist so unglaublich aufregend...", italian="Regalare qualcosa di persona\nè molto emozionante...", spanish="Entregar regalos en persona\nes tan emocionante..."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="But delivering a gift that is\nunexpected is also a wonderful surprise,\ndon't you think?", french="Mais livrer un cadeau inattendu\nest aussi une surprise merveilleuse,\nvous ne pensez pas?", german="Aber ein unerwartetes Präsent\nzu überbringen ist erst recht eine wundervolle\nÜberraschung, nicht wahr?", italian="Ma ricevere un dono inaspettato\nè una sorpresa altrettanto meravigliosa,\nnon credi?", spanish="Pero entregar un regalo\ninesperado también es una sorpresa\nmaravillosa, ¿no crees?"})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="To a person you like, or to\nsomeone that's helped you...", french="A une personne que vous\nappréciez ou qui vous a donné\nun coup de main...", german="An eine Person, die du magst\noder die dir geholfen hat...", italian="Può essere qualcuno che ti piace\noppure che ti ha offerto il suo aiuto...", spanish="A alguien que te guste o que\nte haya ayudado..."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Anytime you want to send a gift,\nyou can count on [CS:K]Shaymin[CR]'s Delivery Service\nto get it there! ♪", french="Chaque fois que vous désirez\nenvoyer un cadeau, vous pouvez compter sur\nle [CS:K]Service de Livraison Shaymin[CR]! ♪", german="Willst du ein Präsent versenden,\ndann kannst du auf den [CS:K]Shaymin-Lieferservice[CR]\nvertrauen, es zuverlässig auszuliefern! ♪", italian="Ogni volta che vuoi spedire\nun dono, vai sul sicuro! Affidati al Servizio\nConsegne [CS:K]Shaymin[CR]! ♪", spanish="¡Siempre que quieras enviar uno,\npodrás contar con que [CS:K]Repartos Shaymin[CR]\nlo entregue sin demora! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="If the person Team [team:]\nsent a gift to sends a reply in return...", french="Si la personne à laquelle\nl'Equipe [team:] a envoyé un cadeau\nrépond...", german="Wenn die Person, der Team\n[team:] ein Präsent geschickt hat, eine\nAntwort schickt...", italian="Se il Pokémon che ha ricevuto\nun dono dal Team [team:] decide di\ninviare una risposta...", spanish="Si quien recibe el regalo del\n[CS:X]Equipo[CR] [team:] envía una respuesta..."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="We'll pass that reply on to\n[CS:N]Spinda[CR] to deliver, so please check with\nhim, OK?", french="... nous confierons cette\nréponse à [CS:N]Spinda[CR] pour qu'il vous la transmette,\nalors n'hésitez pas à le consulter.", german="Dann wird diese an [CS:N]Pandir[CR]\nweitergeleitet. Also vergiss nicht, bei ihm\nnachzusehen!", italian="... la consegneremo al Barsucco\ndi [CS:N]Spinda[CR] affinché te la consegni, quindi\nchiedi a lui, va bene?", spanish="Se la daremos a [CS:N]Spinda[CR]\npara que la entregue, así que id a visitarlo,\n¿de acuerdo?"})
  -- jump @label_132 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Come back anytime you want to\nsend a gift! ♪", french="N'hésitez pas à repasser dès\nque vous désirez envoyer un cadeau! ♪", german="Komm zurück, wann immer du\nein Präsent verschicken möchtest! ♪", italian="Torna pure quando vuoi per\nspedire un dono! ♪", spanish="¡Vuelve siempre que quieras\nenviar un regalo! ♪"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[123] = 1 -- $SCENARIO_TALK_BIT_FLAG[123] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Sorry to have kept you waiting!\nThis is [CS:K]Shaymin[CR]'s Delivery Service!", french="Désolée de vous avoir fait\nattendre! Bienvenue au [CS:K]Service de\nLivraison Shaymin[CR]!", german="Entschuldige bitte die Warterei!\nHerzlich willkommen beim\n[CS:K]Shaymin-Lieferservice[CR]!", italian="Ti ringraziamo per la pazienza!\nQuesto è il Servizio Consegne [CS:K]Shaymin[CR]!", spanish="Siento haberte hecho esperar.\nEstás en [CS:K]Repartos Shaymin[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="We are a delivery service that\nwill send [CS:I]Sky Gift[CR]s to your friends for you.", french="Nous sommes un service de\nlivraison chargé de distribuer en votre\nnom les [CS:I]Dons du Ciel[CR] à vos amis.", german="Wir sind ein Lieferservice, der\n[CS:I]Himmelspräsente[CR] an deine Freunde ausliefert.", italian="Siamo un servizio di spedizioni\nche si occupa di inviare [CS:I]Doni Cielo[CR]\nai tuoi amici.", spanish="Somos un servicio de reparto\ndedicado a la entrega de [CS:I]Regalos Cielo[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="To a person you like, or to\nsomeone that's helped you...", french="A une personne que vous\nappréciez ou qui vous a donné\nun coup de main...", german="An eine Person, die du magst\noder die dir geholfen hat...", italian="Può essere qualcuno che ti piace\noppure che ti ha offerto il suo aiuto...", spanish="Podemos entregarlos a alguien\nque te guste o que te haya ayudado..."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Anytime you want to send a gift,\nyou can count on [CS:K]Shaymin[CR]'s Delivery Service\nto get it there! ♪", french="Chaque fois que vous désirez\nenvoyer un cadeau, vous pouvez compter sur\nle [CS:K]Service de Livraison Shaymin[CR]! ♪", german="Willst du ein Präsent versenden,\ndann kannst du auf den [CS:K]Shaymin-Lieferservice[CR]\nvertrauen, es zuverlässig auszuliefern! ♪", italian="Ogni volta che vuoi spedire\nun dono, vai sul sicuro! Affidati al Servizio\nConsegne [CS:K]Shaymin[CR]! ♪", spanish="¡Siempre que quieras enviar uno,\npodrás contar con que [CS:K]Repartos Shaymin[CR]\nlo entregue sin demora! ♪"})
  -- jump @label_132 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 16] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_sheimi1, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Hi there, travelers!", french=" Holà, voyageurs!", german=" Hallo, Reisende!", italian=" Salve, viaggiatori!", spanish=" ¡Hola, trotamundos!"})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="This is [CS:K]Shaymin[CR]'s Delivery\nService.", french="Bienvenue au\n[CS:K]Service de Livraison Shaymin[CR].", german="Das hier ist der\n[CS:K]Shaymin-Lieferservice[CR].", italian="Questo è il Servizio Consegne\n[CS:K]Shaymin[CR].", spanish=" Estás en [CS:K]Repartos Shaymin[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="But right now we're in the\nmiddle of opening preparations. Please come\nback later.", french="Hélas, en ce moment, nous\nfaisons les derniers préparatifs avant\nl'ouverture. Veuillez repasser plus tard.", german="Wir bereiten gerade noch die\nEröffnung vor. Bitte kommt später wieder.", italian="Ma attualmente siamo ancora in\nfase di allestimento. Ripassate più tardi.", spanish="Pero justo ahora estamos\npreparándonos para la inauguración.\nVuelve más tarde, por favor."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 8) >= 0) or (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) or (SkyProg.cmp(29, 4) >= 0) or (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) or (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) or (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) or (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) or (SkyProg.cmp(17, 3) >= 0) or (SkyProg.cmp(17, 1) >= 0) or (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) or (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) or (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) or (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) or (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) or (SkyProg.cmp(12, 1) >= 0) or (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) or (SkyProg.cmp(9, 1) >= 0) or (SkyProg.cmp(8, 7) >= 0) or (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) or (SkyProg.cmp(8, 3) >= 0) or (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) or (SkyProg.cmp(7, 6) >= 0) or (SkyProg.cmp(7, 3) >= 0) or (SkyProg.cmp(7, 2) >= 0) or (SkyProg.cmp(7, 1) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) or (SkyProg.cmp(5, 5) >= 0) or (SkyProg.cmp(4, 7) >= 0) or (SkyProg.cmp(4, 5) >= 0) or (SkyProg.cmp(4, 3) >= 0) or (SkyProg.cmp(4, 2) >= 0) or (SkyProg.cmp(4, 1) >= 0) or (SkyProg.cmp(4, 0) >= 0) or (SkyProg.cmp(3, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 8] || scn($SCENARIO_MAIN) >= [29
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
