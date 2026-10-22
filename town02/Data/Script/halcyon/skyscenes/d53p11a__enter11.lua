-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D53P11A/enter11.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  do local __sw = ((SV.SkyVars or {}).GROUND_ENTER or -1) -- switch($GROUND_ENTER) [GameVar GROUND_ENTER: point d'entrée du ground]
  if __sw == 113 or __sw == 114 or __sw == 117 or __sw == 118 or __sw == 119 or __sw == 50 or __sw == 121 or __sw == 122 or __sw == 123 or __sw == 125 then
  -- @label_12 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __sw == 129 then
  if (SkyProg.cmp_side(48, 9) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [48, 9]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_yamirami = SkySceneKit.spawn_npc("sableye", 280, 144, Direction.Down, "NPC_YAMIRAMI")
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english="We're ready to accept what\nwill happen to us!", french="Nous sommes prêts à accepter\nnotre sort!", german="Wir sind bereit, unser Schicksal\nanzunehmen!", italian="Siamo pronti ad affrontare\nciò che accadrà!", spanish="Estamos listos para aceptar lo\nque nos suceda."})
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english="Please, [CS:Y]Grovyle[CR]![K]\nStop Master [CS:N]Dialga[CR]!", french="S'il te plaît, [CS:Y]Massko[CR]![K]\nArrête Maître [CS:N]Dialga[CR]!", german="[CS:Y]Reptain[CR], bitte![K]\nHalte Meister [CS:N]Dialga[CR] auf!", italian="Per favore, [CS:Y]Grovyle[CR]![K]\nFerma il Maestro [CS:N]Dialga[CR]!", spanish="Por favor, [CS:Y]Grovyle[CR]...[K]\nDebes detener al maestro [CS:N]Dialga[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english=" For the future!", french=" Pour le futur!", german=" Für die Zukunft!", italian=" Per il futuro!", spanish=" ¡Por el futuro!"})
  -- message_Close
  -- jump @label_12 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp_side(48, 6) >= 0) then -- elseif ROM: scn($SCENARIO_SIDE) >= [48, 6]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english="We're ready to accept what\nwill happen to us!", french="Nous sommes prêts à accepter\nnotre sort!", german="Wir sind bereit, unser Schicksal\nanzunehmen!", italian="Siamo pronti ad affrontare\nciò che accadrà!", spanish="Estamos listos para aceptar lo\nque nos suceda."})
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english="Please, [CS:Y]Grovyle[CR]![K]\nStop Master [CS:N]Dialga[CR]!", french="S'il te plaît, [CS:Y]Massko[CR]![K]\nArrête Maître [CS:N]Dialga[CR]!", german="[CS:Y]Reptain[CR], bitte![K]\nHalte Meister [CS:N]Dialga[CR] auf!", italian="Per favore, [CS:Y]Grovyle[CR]![K]\nFerma il Maestro [CS:N]Dialga[CR]!", spanish="Por favor, [CS:Y]Grovyle[CR]...[K]\nDebes detener al maestro [CS:N]Dialga[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english=" For the future!", french=" Pour le futur!", german=" Für die Zukunft!", italian=" Per il futuro!", spanish=" ¡Por el futuro!"})
  -- message_Close
  -- jump @label_12 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english="We're ready to accept what\nwill happen to us!", french="Nous sommes prêts à accepter\nnotre sort!", german="Wir sind bereit, unser Schicksal\nanzunehmen!", italian="Siamo pronti ad affrontare\nciò che accadrà!", spanish="Estamos listos para aceptar lo\nque nos suceda."})
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english="Please, [CS:Y]Grovyle[CR]![K]\nStop Master [CS:N]Dialga[CR]!", french="S'il te plaît, [CS:Y]Massko[CR]![K]\nArrête Maître [CS:N]Dialga[CR]!", german="[CS:Y]Reptain[CR], bitte![K]\nHalte Meister [CS:N]Dialga[CR] auf!", italian="Per favore, [CS:Y]Grovyle[CR]![K]\nFerma il Maestro [CS:N]Dialga[CR]!", spanish="Por favor, [CS:Y]Grovyle[CR]...[K]\nDebes detener al maestro [CS:N]Dialga[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english=" For the future!", french=" Pour le futur!", german=" Für die Zukunft!", italian=" Per il futuro!", spanish=" ¡Por el futuro!"})
  -- message_Close
  -- jump @label_12 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif __sw == 131 then
  if (SkyProg.cmp_side(48, 9) >= 0) or (SkyProg.cmp_side(48, 8) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [48, 9] || scn($SCENARIO_SIDE) >= [48
  -- jump @label_12 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_12 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif true then -- default
  -- jump @label_12 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  SkySceneKit.cleanup_npcs()
end
