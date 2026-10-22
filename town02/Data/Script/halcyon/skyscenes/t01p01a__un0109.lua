-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/un0109.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp_side(40, 7) >= 0) or (SkyProg.cmp_side(40, 3) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [40, 7] || scn($SCENARIO_SIDE) >= [40
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_togepii = SkySceneKit.spawn_npc("togepi", 328, 256, Direction.DownLeft, "NPC_TOGEPII")
  pcall(function() UI:SetSpeaker(npc_npc_togepii) end)
  SkySceneKit.say({english="We're Team [CS:X]Glee[CR]![K] We're the\nexploration team that delivers happiness!", french="On est l'Equipe [CS:X]Bonheur[CR]![K]\nL'équipe d'exploration qui répand la joie et\nla bonne humeur!", german="Wir sind Team [CS:X]Frohsinn[CR]![K] Wir\nsind das Erkundungsteam, das Fröhlichkeit\nverbreitet!", italian="Siamo il Team [CS:X]Allegria[CR]![K] Siamo\nla squadra d'esplorazione che porta la felicità!", spanish="¡Somos el [CS:X]Equipo Alegría[CR]![K]\n¡El equipo explorador que reparte\nfelicidad!"})
  -- message_Close
  -- @label_3 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp_side(40, 2) >= 0) then -- elseif ROM: scn($SCENARIO_SIDE) >= [40, 2]
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
