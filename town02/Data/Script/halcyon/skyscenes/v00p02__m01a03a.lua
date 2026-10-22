-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V00P02/m01a03a.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_H01P99D) [neutre/état moteur]
  pcall(function() GAME:MoveCamera(272, 180, 1, false) end)
  GAME:FadeIn(30)
  GAME:WaitFrames(120)
  -- back_SetBackEffect(3) [état de lecture des palettes animées NDS: autotiles PMDO animés en boucle - documenté]
  GAME:WaitFrames(30)
  -- back_SetBackEffect(4) [état de lecture des palettes animées NDS: autotiles PMDO animés en boucle - documenté]
  GAME:WaitFrames(60)
  -- back_SetBackEffect(5) [état de lecture des palettes animées NDS: autotiles PMDO animés en boucle - documenté]
  GAME:WaitFrames(2) -- WaitBackEffect (join)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 30)
  SkySceneKit.play_scene("t00p01__m01a0100", "t00p01__m01a01", hero, partner) -- supervision_ExecuteStation(LEVEL_T00P01, 'M01A01', 0) [chaînage scène ROM]
  GAME:WaitFrames(1) -- hold
end
