-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D04P11A/m05d0314.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_D04P11A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  do local __sw = 1 -- switch(sector()) [sector(): acting principal (kit PMDO)]
  if __sw == 1 then
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:FadeIn(5)
  GAME:WaitFrames(30)
  GAME:WaitFrames(80)
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- @label_0 [étiquette de flux ExplorerScript]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  -- GAP: BGM BGM_THAT_SHAPE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  GAME:WaitFrames(40)
  -- @label_2 [étiquette de flux ExplorerScript]
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(40), 40, false) end) -- MovePositionOffset performer/caméra
  local npc_npc_dark_pukurin = SkySceneKit.spawn_npc("wigglytuff", 256, 224, Direction.Up, "NPC_DARK_PUKURIN")
  GROUND:MoveToPosition(npc_npc_dark_pukurin, 252, 260, false, 2)
  GROUND:EntTurn(npc_npc_dark_pukurin, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(60)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(-64), 26, false) end) -- MovePositionOffset performer/caméra
  GROUND:MoveToPosition(npc_npc_dark_pukurin, 252, 196, false, 2)
  -- ResetOutputAttribute(256) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  GROUND:MoveToPosition(npc_npc_dark_pukurin, 252, 164, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetOutputAttribute(4) [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  do local __sw = 1 -- switch(sector()) [sector(): acting principal (kit PMDO)]
  if __sw == 1 then
  GAME:WaitFrames(15)
  GAME:FadeOut(true, 5) -- screen_WhiteOut
  -- jump @label_5 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  GAME:FadeOut(false, 30)
  -- @label_5 [étiquette de flux ExplorerScript]
  GAME:FadeIn(0) -- screen_FlushIn
  end
  end
  end
  end
  SkySceneKit.cleanup_npcs()
end
