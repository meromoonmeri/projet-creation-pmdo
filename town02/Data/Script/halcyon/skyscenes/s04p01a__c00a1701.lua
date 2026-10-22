-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/S04P01A/c00a1701.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(16)
  -- GAP: SetEffect 635 — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  pcall(function() GAME:MoveCamera(136, 100, 1, false) end) -- SetPositionMark performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:FadeOut(false, 16)
end
