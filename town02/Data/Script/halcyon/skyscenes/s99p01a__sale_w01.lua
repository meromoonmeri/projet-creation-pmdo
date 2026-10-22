-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/S99P01A/sale_w01.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- screen2_FadeOut [sub déjà caché]
  GAME:FadeOut(false,  0)
  GAME:FadeIn(0)
  -- back2_SetMode(8) [mode d'affichage sub NDS: géré par SubScreen]
end
