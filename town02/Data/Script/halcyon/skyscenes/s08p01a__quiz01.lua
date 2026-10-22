-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/S08P01A/quiz01.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- screen2_FadeOut [sub déjà caché]
  GAME:FadeOut(false, 30)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V04P03A) [décor sub chargé: Sub_v04p03a]
  -- back_SetGround(LEVEL_S08P01A) [neutre/état moteur]
  pcall(function() GAME:MoveCamera(128, 84, 1, false) end)
  -- camera2_SetPositionMark(Position<'m1', 19.5, 16.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
end
