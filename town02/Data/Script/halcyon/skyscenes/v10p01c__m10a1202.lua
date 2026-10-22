-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V10P01C/m10a1202.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_TIME_GEAR non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_V10P01C) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() GAME:MoveCamera(440, 156, 60, false) end) -- performer/caméra
  -- MovePositionOffset<object OBJECT_V10P01C2_231> [prop décor NDS, géré par le rendu du ground]
  -- MovePositionOffset<object OBJECT_V10P01C1_225> [prop décor NDS, géré par le rendu du ground]
  -- MovePositionOffset<object OBJECT_V10P01C1_226> [prop décor NDS, géré par le rendu du ground]
  -- MovePositionOffset<object OBJECT_V10P01C3_238> [prop décor NDS, géré par le rendu du ground]
  -- MovePositionOffset<object OBJECT_V10P01C1_227> [prop décor NDS, géré par le rendu du ground]
  -- MovePositionOffset<object OBJECT_V10P01C2_233> [prop décor NDS, géré par le rendu du ground]
  -- MovePositionOffset<object OBJECT_V10P01C3_239> [prop décor NDS, géré par le rendu du ground]
  GAME:FadeIn(30)
  GAME:WaitFrames(180)
  -- supervision_Acting(1) [neutre/état moteur]
  -- Move2PositionMark<object OBJECT_V10P01C3_237> [prop décor NDS, géré par le rendu du ground]
  GAME:WaitFrames(180)
  -- supervision_Acting(2) [neutre/état moteur]
  -- Move2PositionMark<object OBJECT_V10P01C2_232> [prop décor NDS, géré par le rendu du ground]
  GAME:WaitFrames(30)
  GAME:FadeOut(false, 30)
end
