-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P02P01A/us0201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) or (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) or (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) or (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) or (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) or (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) or (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) or (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) or (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) or (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) or (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) or (SkyProg.cmp(29, 8) >= 0) or (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) or (SkyProg.cmp(29, 4) >= 0) or (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_kootasu = SkySceneKit.spawn_npc("torkoal", 320, 136, Direction.DownLeft, "NPC_KOOTASU")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kootasu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english=" I thank you sincerely.", french=" Je vous remercie sincèrement.", german=" Ich danke euch zutiefst.", italian=" Vi ringrazio di tutto cuore.", spanish=" Muchas gracias."})
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english="It was your doing that brought\npeace to our world.", french="C'est grâce à vous que la paix\nde notre monde a été restaurée.", german="Eure Taten waren es, die der\nWelt Frieden gebracht haben.", italian="Grazie a voi è tornata la pace\nnel nostro mondo.", spanish="Habéis traído la paz a nuestro\nmundo."})
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english="The fact that I can lounge on the\nrocks here... That's your doing too. Ho-ho-ho!", french="Si je peux me prélasser sur\nces rochers... c'est également grâce à vous.\nHo ho ho!", german="Die Tatsache, dass ich hier auf\nden Felsen faulenzen kann... Das habe ich auch\neuch zu verdanken. Hehehe!", italian="Se posso oziare su queste\nrocce... lo devo a voi. Oh-oh-oh!", spanish="Y por eso puedo quedarme aquí\nen las rocas de relax... ¡Jo, jo, jo!"})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [25, 4] || scn($SCENARIO_MAIN) >= [25
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kootasu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english="Oh, my goodness gracious![K]\nYou say you made it to the [CS:P]Hidden Land[CR]?!", french="Oh, merveille des merveilles![K]\nVous dites que vous avez réussi à atteindre\nles [CS:P]Terres Illusoires[CR]?!", german="Ach, du meine Güte![K] Ihr sagt, ihr\nhabt einen Weg in das [CS:P]Verborgene Land[CR]\ngefunden?!?", italian="Caspiterina![K] Dite che avete\nraggiunto la [CS:P]Terra Nascosta[CR]?!", spanish="¡Me habéis dejado de piedra![K]\n¿Así que estuvisteis en la [CS:P]Tierra Oculta[CR]?"})
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english="Who would have thought it? The\n[CS:P]Hidden Land[CR] really did exist!", french="Qui l'eût cru? Les [CS:P]Terres\nIllusoires[CR] existent bel et bien, alors!", german="Wer hätte das gedacht? Das\n[CS:P]Verborgene Land[CR] existiert also wirklich!", italian="Chi l'avrebbe detto? La [CS:P]Terra[CR]\n[CS:P]Nascosta[CR] esiste davvero!", spanish="¡Increíble! ¡La [CS:P]Tierra Oculta[CR]\nexiste!"})
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english="Well, I daresay you're most\nremarkable. Ho-ho-ho!", french="Eh bien, vous êtes vraiment\nadmirables, sans aucun doute. Ho ho ho!", german="Nun, ich wage zu sagen, dass ihr\nziemlich bemerkenswert seid. Hehehe!", italian="Bene, oserei dire che siete\ndi un'abilità fuori dal comune!", spanish="Debo admitir que sois una pareja\nde grandes exploradores. ¡Jo, jo, jo!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) or (SkyProg.cmp(23, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [24, 1] || scn($SCENARIO_MAIN) >= [24
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [22, 3] || scn($SCENARIO_MAIN) >= [22
  -- @label_82 [étiquette de flux ExplorerScript]
  -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
  -- supervision_ExecuteCommon(CORO_EVENT_M21_06) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- continue [contrôle de boucle forever NDS: une itération compilée]
  -- may be redundant
  elseif (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) or (SkyProg.cmp(17, 3) >= 0) or (SkyProg.cmp(17, 1) >= 0) or (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) or (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) or (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) or (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) or (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) or (SkyProg.cmp(12, 1) >= 0) or (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) or (SkyProg.cmp(9, 1) >= 0) or (SkyProg.cmp(8, 7) >= 0) or (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) or (SkyProg.cmp(8, 3) >= 0) or (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) or (SkyProg.cmp(7, 6) >= 0) or (SkyProg.cmp(7, 3) >= 0) or (SkyProg.cmp(7, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [21, 2] || scn($SCENARIO_MAIN) >= [21
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kootasu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english="I can't soak in the Hot Spring\nmyself...", french="Moi, je ne peux pas faire\ntrempette dans la Source Chaude...", german="Ich kann mich nicht von der\nHeißen Quelle durchweichen lassen.", italian="Non posso immergermi nella\nSorgente Termale...", spanish=" No puedo bañarme en la Terma..."})
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english="Instead, I lounge about on the\nheated rocks here. Ho-ho-ho!", french="Au lieu de ça, je me prélasse\nsur les rochers chauffés par le soleil.\nHo ho ho!", german="Stattdessen faulenze ich hier auf\nden aufgeheizten Felsen. Hehehe!", italian="E così, ozio qui sulle rocce\nriscaldate. Oh-oh-oh!", spanish="Pero me quedo aquí en las rocas\ncalientes, relajándome. ¡Jo, jo, jo!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(7, 1) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) or (SkyProg.cmp(5, 5) >= 0) or (SkyProg.cmp(4, 7) >= 0) or (SkyProg.cmp(4, 5) >= 0) or (SkyProg.cmp(4, 3) >= 0) or (SkyProg.cmp(4, 2) >= 0) or (SkyProg.cmp(4, 1) >= 0) or (SkyProg.cmp(4, 0) >= 0) or (SkyProg.cmp(3, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 1] || scn($SCENARIO_MAIN) >= [6, 
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
