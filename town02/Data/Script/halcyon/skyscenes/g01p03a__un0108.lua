-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/un0108.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp_side(40, 7) >= 0) or (SkyProg.cmp_side(40, 3) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [40, 7] || scn($SCENARIO_SIDE) >= [40
  -- @label_3 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp_side(40, 2) >= 0) then -- elseif ROM: scn($SCENARIO_SIDE) >= [40, 2]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_pochiena_b = SkySceneKit.spawn_npc("poochyena", 408, 240, Direction.UpRight, "NPC_POCHIENA_B")
  pcall(function() UI:SetSpeaker(npc_npc_pochiena_b) end)
  SkySceneKit.say({english=" You look strangely happy...", french="Tu m'as l'air\nanormalement heureux...", german="Du siehst auf eigenartige Weise\nfröhlich aus...", italian=" Sei stranamente felice...", spanish=" Se te ve extrañamente feliz..."})
  pcall(function() UI:SetSpeaker(npc_npc_pochiena_b) end)
  SkySceneKit.say({english=" Did something happen?", french=" Il s'est passé quelque chose?", german=" Ist etwas geschehen?", italian=" È successo qualcosa?", spanish=" ¿Es que ha ocurrido algo?"})
  -- message_Close
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
