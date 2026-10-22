-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V14P04A/m14a0803.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_V14P04A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- supervision_SpecialActing(18, 0, 0) [cadrage NDS]
  GAME:FadeIn(0)
  pcall(function() GAME:MoveCamera(664, 148, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- se_FadeOut(7174, 60) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  GAME:FadeOut(false,  15)
  -- supervision_SpecialActing(3, 0, 0) [cadrage NDS]
  GAME:WaitFrames(30)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
end
