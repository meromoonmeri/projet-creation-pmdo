-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/un0104.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp_side(40, 7) >= 0) or (SkyProg.cmp_side(40, 3) >= 0) or (SkyProg.cmp_side(40, 2) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [40, 7] || scn($SCENARIO_SIDE) >= [40
  -- @label_3 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_madatsubomi = SkySceneKit.spawn_npc("bellsprout", 312, 280, Direction.Up, "NPC_MADATSUBOMI")
  pcall(function() UI:SetSpeaker(npc_npc_madatsubomi) end)
  SkySceneKit.say({english="Oh? [K]You're a member of\n[CS:N]Wigglytuff[CR]'s Guild?", french="Oh? [K]Tu es membre de la Guilde\nde [CS:N]Grodoudou[CR]?", german="Oh?[K] Bist du ein Mitglied der\n[CS:N]Knuddeluff-Gilde[CR]?", italian="Oh? [K]Sei un membro della Gilda\ndi [CS:N]Wigglytuff[CR]?", spanish="¿Cómo?[K] ¿Que eres miembro del\n[CS:N]Pokégremio de Exploradores[CR]?"})
  -- message_Close
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
