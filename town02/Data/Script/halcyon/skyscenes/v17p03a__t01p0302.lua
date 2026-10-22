-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V17P03A/t01p0302.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_V17P03A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(30) -- WaitBgmSignal (signal SMD NDS sans équivalent: join fixe documenté)
  GAME:FadeIn(5)
  pcall(function() GAME:MoveCamera(352, 156, 60, false) end) -- performer/caméra
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(240), g.ViewCenter.Y+(0), 120, false) end) -- back_SetBackScrollSpeed(2.0,0.0) px/frame -> caméra continue (pilote scroll)
  GAME:WaitFrames(230)
  -- back_SetBackScrollSpeed(0,0): arrêt du défilement
  GAME:FadeOut(false, 5)
  GAME:FadeIn(5)
  GAME:WaitFrames(90)
  GAME:FadeOut(false, 5)
end
