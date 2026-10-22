-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V22P03A/m22a1003.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_V22P03A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetOutputAttribute(1024) [neutre/état moteur]
  -- SetOutputAttribute(8) [neutre/état moteur]
  -- MovePositionMark OBJECT_V22P03A2_296 [cible sans placement SSA zone: mouvement non joué]
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  -- MovePositionOffset<object OBJECT_V22P03A2_296> [prop décor NDS, géré par le rendu du ground]
  pcall(function() GAME:MoveCamera(304, 116, 60, false) end) -- performer/caméra
  GAME:WaitFrames(360)
  GAME:FadeOut(false, 60)
end
