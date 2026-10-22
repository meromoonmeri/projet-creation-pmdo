-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V03P07A/t02a0501.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- screen2_WhiteOut [sub déjà caché]
  GAME:FadeOut(true, 0) -- screen_WhiteOut
  -- back_SetGround(LEVEL_V03P07A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
end
