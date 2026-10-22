-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/S13P06A/t02a0205.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- screen2_WhiteOut [sub déjà caché]
  GAME:FadeOut(true, 0) -- screen_WhiteOut
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
end
