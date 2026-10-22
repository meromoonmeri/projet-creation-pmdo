-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P15P01A/t02a0301.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_P15P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() GAME:MoveCamera(236, 164, 1, false) end) -- SetPositionMark performer/caméra
  local npc_npc_bippa_bro = SkySceneKit.spawn_npc("bidoof", 296, 136, Direction.DownLeft, "NPC_BIPPA_BRO")
  GROUND:EntTurn(npc_npc_bippa_bro, Direction.Left)
  local npc_npc_bippa_sis = SkySceneKit.spawn_npc("bidoof", 312, 184, Direction.UpLeft, "NPC_BIPPA_SIS")
  GROUND:EntTurn(npc_npc_bippa_sis, Direction.Left)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-160), p.Y+(0), false, 2) end
  GAME:FadeIn(15)
  GAME:WaitFrames(10)
  do local p=npc_npc_bippa_bro.Position; GROUND:MoveToPosition(npc_npc_bippa_bro, p.X+(-64), p.Y+(0), false, 2) end
  GAME:WaitFrames(5)
  do local p=npc_npc_bippa_sis.Position; GROUND:MoveToPosition(npc_npc_bippa_sis, p.X+(-32), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa_bro, "happy", 1) end)
  -- SetAnimation(51) [anim idle native]
  GAME:WaitFrames(7)
  -- SetAnimation(42) [anim idle native]
  GAME:WaitFrames(5)
  local npc_npc_biidaru = SkySceneKit.spawn_npc("bibarel", 312, 160, Direction.Left, "NPC_BIIDARU")
  -- SetAnimation(42) [anim idle native]
  GAME:WaitFrames(34)
  GAME:FadeOut(false, 15)
  SkySceneKit.cleanup_npcs()
end
