-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P27A/enter13.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) or (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) or (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) or (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) or (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) or (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) or (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) or (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) or (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) or (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) or (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) or (SkyProg.cmp(29, 8) >= 0) or (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) or (SkyProg.cmp(29, 4) >= 0) or (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) or (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) or (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) or (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) or (SkyProg.cmp(17, 3) >= 0) or (SkyProg.cmp(17, 1) >= 0) or (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) or (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) or (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) or (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) or (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) or (SkyProg.cmp(12, 1) >= 0) or (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) or (SkyProg.cmp(9, 1) >= 0) or (SkyProg.cmp(8, 7) >= 0) or (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) or (SkyProg.cmp(8, 3) >= 0) or (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) or (SkyProg.cmp(7, 6) >= 0) or (SkyProg.cmp(7, 3) >= 0) or (SkyProg.cmp(7, 2) >= 0) or (SkyProg.cmp(7, 1) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) or (SkyProg.cmp(5, 5) >= 0) or (SkyProg.cmp(4, 7) >= 0) or (SkyProg.cmp(4, 5) >= 0) or (SkyProg.cmp(4, 3) >= 0) or (SkyProg.cmp(4, 2) >= 0) or (SkyProg.cmp(4, 1) >= 0) or (SkyProg.cmp(4, 0) >= 0) or (SkyProg.cmp(3, 1) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  if ((SV.SkyScenarioBitFlags or {})[88] == 1) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[88]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_watakko = SkySceneKit.spawn_npc("jumpluff", 296, 240, Direction.Down, "NPC_WATAKKO")
  pcall(function() UI:SetSpeaker(npc_npc_watakko) end)
  SkySceneKit.say({english="I love finding and then giving\n[CS:I]Sky Gift[CR]s.", french="J'adore trouver et offrir\ndes [CS:I]Dons du Ciel[CR].", german="Ich liebe es, [CS:I]Himmelspräsente[CR] zu\nsuchen und sie dann weiterzugeben.", italian="Adoro trovare i [CS:I]Doni Cielo[CR] e poi\ndarli a qualcuno.", spanish="Me encanta encontrar y repartir\n[CS:I]Regalos Cielo[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_watakko) end)
  SkySceneKit.say({english="It makes me smile to see\nothers' happy reactions.", french="Ça m'amuse de lire la joie\nsur le visage de ceux qui les reçoivent.", german="Es macht mich glücklich, die\nfrohen Gesichter der Beschenkten zu sehen.", italian="Vedere le reazioni felici\ndegli altri mi mette di buonumore.", spanish="Ver la cara de felicidad de los\ndemás me hace sonreír."})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_watakko) end)
  SkySceneKit.say({english=" Hello!", french=" Bonjour!", german=" Hallo!", italian=" Salve!", spanish=" ¡Hola!"})
  pcall(function() UI:SetSpeaker(npc_npc_watakko) end)
  SkySceneKit.say({english="Since I found these things called\n[CS:I]Sky Gift[CR]s on the mountain here...", french="Depuis que j'ai trouvé ces\ntrucs qu'on appelle [CS:I]Dons du Ciel[CR] ici,\nsur la montagne...", german="Ich habe hier auf dem Berg\ndiese Dinger gefunden, die [CS:I]Himmelspräsente[CR]\ngenannt werden...", italian="Da quando ho trovato questi\n[CS:I]Doni Cielo[CR] qui sulla montagna...", spanish="Desde que encontré los [CS:I]Regalos[CR]\n[CS:I]Cielo[CR] en esta montaña..."})
  pcall(function() UI:SetSpeaker(npc_npc_watakko) end)
  SkySceneKit.say({english="I am finding sending a gift to\nothers so delightful! It's so much fun!", french="... je prends un réel plaisir\nà envoyer des cadeaux à tout le monde!\nC'est si amusant!", german="Seitdem verschicke ich diese\nPräsente nur zu gern! Das macht so einen\nSpaß!", italian="... mi diverto un sacco\na spedirli a tutti! È davvero spassoso!", spanish="Encuentro mucho más divertido\nenviar regalos a los demás. ¡Mola mucho!"})
  pcall(function() UI:SetSpeaker(npc_npc_watakko) end)
  SkySceneKit.say({english="I found a bunch of them today\ntoo, so would you accept one from me?", french="Aujourd'hui, j'en ai encore\ntrouvé un paquet, alors je pourrais\nt'en offrir un, non?", german="Ich habe heute wieder ein paar\ngefunden. Würdest du ein Präsent von\nmir annehmen?", italian="Oggi ne ho trovati un bel po',\nquindi ti andrebbe di accettarne uno?", spanish="Hoy también he encontrado\nun montón, ¿quieres uno?"})
  do local __choice = SkySceneKit.ask({{english="Thank you!", french="Merci!", german="Danke sehr!", italian="Sì, grazie!", spanish="¡Gracias!"}, {english="No, thanks.", french="Non, merci.", german="Lieber nicht.", italian="No, grazie.", spanish="No, gracias."}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  pcall(function() UI:SetSpeaker(npc_npc_watakko) end)
  SkySceneKit.say({english="Oh, that's all right.\nDon't worry about it.", french=" Oh, pas de problème.", german="Oh, schon in Ordnung!\nMach dir deswegen keine Sorgen.", italian="Oh, va tutto bene.\nNon preoccuparti.", spanish="Bueno, no pasa nada.\nNo te preocupes."})
  pcall(function() UI:SetSpeaker(npc_npc_watakko) end)
  SkySceneKit.say({english="Just come talk to me if you\never want one.", french="Tu n'as qu'à venir me parler\nsi tu en veux un plus tard.", german="Wenn du eins willst, komm\neinfach vorbei und sprich mit mir.", italian="Se cambiassi idea, torna pure\nda me.", spanish="Pero ven a hablar conmigo si\nalguna vez quieres uno."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  pcall(function() UI:SetSpeaker(npc_npc_watakko) end)
  SkySceneKit.say({english="Oh, thank you.\nHere you go! ♪", french="Oh, merci.\nVoilà pour toi! ♪", german="Oh, wie schön!\nDa hast du es! ♪", italian="Oh, bene.\nEcco qua! ♪", spanish="Ah, gracias.\n¡Aquí tienes! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_IS_BAG_FULL"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_IS_BAG_FULL, 0, 0)) [ProcessSpecial(PROCESS_SPECIAL_IS_BAG_FULL): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 0 then
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[88] = 1 -- $SCENARIO_MAIN_BIT_FLAG[88] = 1 (ROM)
  -- item_SetTableData(0, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- switch(ProcessSpecial(PROCESS_SPECIAL_ADD_TABLE_ITEM_TO_BAG, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- GAP: se_Play(8710) — id SE NDS sans portage PMDO identifié
  pcall(function() UI:SetSpeaker(npc_npc_watakko) end)
  SkySceneKit.say({english="[CN][player] received\n[CN]a [CS:I]Sky Gift[CR].", french="[CN][player] reçoit\n[CN]un [CS:I]Don du Ciel[CR].", german="[CN][player] erhält\n[CN]ein [CS:I]Himmelspräsent[CR].", italian="[CN][player] ha ricevuto\n[CN]un [CS:I]Dono Cielo[CR].", spanish="[CN][player] ha obtenido\n[CN]un [CS:I]Regalo Cielo[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_watakko) end)
  SkySceneKit.say({english="[CN]You gently open the lid...", french="[CN]Vous ouvrez délicatement le couvercle...", german="[CN]Du öffnest behutsam den Deckel...", italian="[CN]Apri lentamente il pacchetto...", spanish="[CN]Abres la tapa con cuidado..."})
  -- message_Close
  -- GAP: se_Play(11021) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() UI:SetSpeaker(npc_npc_watakko) end)
  SkySceneKit.say({english="[CN]Inside was the\n[CN][s_item:0]!", french="[CN]A l'intérieur se trouve l'objet\n[CN][s_item:0]!", german="[CN]Im Paket liegt das Item\n[CN][s_item:0]!", italian="[CN]... e al suo interno trovi lo strumento\n[CN][s_item:0]!", spanish="[CN]¡Había un objeto\n[CN][s_item:0] dentro!"})
  pcall(function() UI:SetSpeaker(npc_npc_watakko) end)
  SkySceneKit.say({english="[CN]A warm and fuzzy feeling falls over you...", french="[CN]Que c'est agréable de recevoir un cadeau...", german="[CN]Ein warmes, angenehmes Kribbeln\n[CN]überkommt dich...", italian="[CN]Una dolce sensazione di calore ti investe...", spanish="[CN]Te invade una sensación de calidez..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_watakko, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_watakko) end)
  SkySceneKit.say({english="Huh?\nYou've got too many items?\nWell, I'll give it to you another time. ♪", french="Hein?\nTu as trop d'objets? Dans ce cas,\nje te le donnerai une prochaine fois. ♪", german="Hmm... Du hast wohl zu viele\nItems? Okay, ich werde es dir ein andermal\ngeben. ♪", italian="Eh?\nHai troppi strumenti, dici?\nVabbè, facciamo la prossima volta allora. ♪", spanish="¿Cómo? ¿Que tienes\ndemasiados objetos? Bueno, pues ya\nte lo daré en otro momento. ♪"})
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
