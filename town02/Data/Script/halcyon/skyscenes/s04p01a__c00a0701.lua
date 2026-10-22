-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/S04P01A/c00a0701.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(16)
  -- GAP: se_Play(5132) — id SE NDS sans portage PMDO identifié
  -- GAP: SetEffect 621 — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  pcall(function() GAME:MoveCamera(136, 356, 1, false) end) -- SetPositionMark performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:FadeOut(true, 16) -- screen_WhiteOut
end
