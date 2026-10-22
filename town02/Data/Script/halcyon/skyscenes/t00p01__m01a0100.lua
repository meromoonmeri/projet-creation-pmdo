-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T00P01/m01a0100.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  SkySceneKit.reset_locks()
  SkySceneKit.run_routine(function() -- def 5 for actor ACTOR_NPC_TEST007
    local npc_npc_test007 = SkySceneKit.spawn_npc("granbull", 464, 360, Direction.Down, "NPC_TEST007")
    -- ResetFunctionAttribute(8) [attribut interne de l'interpréteur SSB NDS - sans objet PMDO]
    -- @label_1 [étiquette de flux ExplorerScript]
    -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
    do local p=npc_npc_test007.Position; GROUND:MoveToPosition(npc_npc_test007, p.X+(32), p.Y+(0), false, 1) end
    do local p=npc_npc_test007.Position; GROUND:MoveToPosition(npc_npc_test007, p.X+(0), p.Y+(32), false, 1) end
    do local p=npc_npc_test007.Position; GROUND:MoveToPosition(npc_npc_test007, p.X+(-32), p.Y+(0), false, 1) end
    do local p=npc_npc_test007.Position; GROUND:MoveToPosition(npc_npc_test007, p.X+(0), p.Y+(-32), false, 1) end
    -- continue [contrôle de boucle forever NDS: une itération compilée]
    -- may be redundant
  end)
  -- debug_Print('station_M01A01') [neutre/état moteur]
  do local __sw = 1 -- switch(sector()) [sector(): acting principal (kit PMDO)]
  if __sw == 1 then
  -- @label_0 [étiquette de flux ExplorerScript]
  -- supervision_Station(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif true then -- default
  -- back_SetGround(LEVEL_T00P01) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:FadeIn(30)
  end
  end
  SkySceneKit.cleanup_npcs()
  SkySceneKit.join_routines()
end
