-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T00P01/m01a04a.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- debug_Print('acting_M01A04A') [neutre/état moteur]
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="An Acting Test will be conducted.", french="An Acting Test will be conducted.", german="An Acting Test will be conducted.", italian="An Acting Test will be conducted.", spanish="An Acting Test will be conducted."})
  -- message_Close
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1) -- with(...){hold} NDS
  GAME:WaitFrames(1) -- with(...){hold} NDS
  GAME:WaitFrames(1) -- with(...){hold} NDS
  GAME:WaitFrames(1) -- with(...){hold} NDS
  local npc_npc_test005 = SkySceneKit.spawn_npc("lombre", 568, 360, Direction.UpLeft, "NPC_TEST005")
  do local p=npc_npc_test005.Position; GROUND:MoveToPosition(npc_npc_test005, p.X+(32), p.Y+(0), false, 2) end -- Move2PositionOffset
  GAME:WaitFrames(1) -- with(...){hold} NDS
  do local p=npc_npc_test005.Position; GROUND:MoveToPosition(npc_npc_test005, p.X+(0), p.Y+(32), false, 2) end -- Move2PositionOffset
  do local p=npc_npc_test005.Position; GROUND:MoveToPosition(npc_npc_test005, p.X+(-32), p.Y+(0), false, 2) end -- Move2PositionOffset
  do local p=npc_npc_test005.Position; GROUND:MoveToPosition(npc_npc_test005, p.X+(0), p.Y+(-32), false, 2) end -- Move2PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="The Event Test is finished.", french="The Event Test is finished.", german="The Event Test is finished.", italian="The Event Test is finished.", spanish="The Event Test is finished."})
  -- message_Close
  -- supervision_Suspend(-2) [neutre/état moteur]
  -- supervision_RemoveActing(-2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  SkySceneKit.cleanup_npcs()
end
