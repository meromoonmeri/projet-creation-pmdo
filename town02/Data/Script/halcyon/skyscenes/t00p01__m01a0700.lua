-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T00P01/m01a0700.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  SkySceneKit.reset_locks()
  SkySceneKit.run_routine(function() -- def 4 for actor ACTOR_NPC_TEST007
    -- @label_0 [étiquette de flux ExplorerScript]
    local npc_npc_test007 = SkySceneKit.spawn_npc("granbull", 464, 360, Direction.Down, "NPC_TEST007")
    do local p=npc_npc_test007.Position; GROUND:MoveToPosition(npc_npc_test007, p.X+(32), p.Y+(0), false, 1) end
    do local p=npc_npc_test007.Position; GROUND:MoveToPosition(npc_npc_test007, p.X+(0), p.Y+(32), false, 1) end
    do local p=npc_npc_test007.Position; GROUND:MoveToPosition(npc_npc_test007, p.X+(-32), p.Y+(0), false, 1) end
    do local p=npc_npc_test007.Position; GROUND:MoveToPosition(npc_npc_test007, p.X+(0), p.Y+(-32), false, 1) end
    -- jump @label_0 [saut final de branche vers l'épilogue commun: flux naturel]
  end)
  -- debug_Print('station_M01A07') [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Suspend(-2) [neutre/état moteur]
  -- supervision_RemoveActing(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  SkySceneKit.cleanup_npcs()
  SkySceneKit.join_routines()
end
