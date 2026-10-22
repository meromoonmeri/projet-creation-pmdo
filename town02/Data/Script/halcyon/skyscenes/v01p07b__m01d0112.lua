-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V01P07B/m01d0112.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_V01P07B) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(-180), g.ViewCenter.Y+(0), 452, false) end) -- MovePositionOffset performer/caméra
  -- GAP: SetEffect EFFECT_VERY_HEAVY_RAIN — VFX sans émote PMDO équivalente
  -- GAP: BGM BGM_STORM non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(60)
  GAME:WaitFrames(60)
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(90)
  GAME:WaitFrames(150)
  GAME:FadeOut(false, 30)
  -- GAP: SetEffect EFFECT_NONE sur PNJ non résolu (v2 cast SSA)
end
