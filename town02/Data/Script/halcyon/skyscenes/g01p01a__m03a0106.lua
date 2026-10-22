-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P01A/m03a0106.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  -- back_SetGround(LEVEL_G01P01A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- supervision_Acting(1) [neutre/état moteur]
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 240, 152, Direction.Down, "NPC_BIPPA")
  do local p=npc_npc_bippa.Position; GROUND:MoveToPosition(npc_npc_bippa, p.X+(0), p.Y+(140), false, 2) end
  GAME:WaitFrames(30)
  -- supervision_Acting(2) [neutre/état moteur]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(140), false, 2) end
  GAME:WaitFrames(30)
  -- supervision_Acting(3) [neutre/état moteur]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(140), false, 2) end
  GAME:WaitFrames(45)
  pcall(function() SOUND:FadeOutBGM(60) end)
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
end
