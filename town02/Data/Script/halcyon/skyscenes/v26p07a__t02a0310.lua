-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V26P07A/t02a0310.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back2_SetMode(5) [mode d'affichage sub NDS: géré par SubScreen]
  -- back_SetGround(LEVEL_V26P07A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- screen2_FadeIn(0, 15) [sub révélé en mode système NDS (aucun décor chargé): pas de contenu narratif - documenté]
  GAME:FadeIn(15)
  -- Destroy() [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_V26P07A1_349) [routine d'objet NDS non simulée - documenté]
  -- Destroy() [neutre/état moteur]
  -- supervision_Acting(2) [neutre/état moteur]
  -- SetOutputAttribute(1024) [neutre/état moteur]
  -- SetAnimation(3) [anim idle native]
  pcall(function() GAME:MoveCamera(156, 92, 60, false) end) -- performer/caméra
  GAME:WaitFrames(30)
  GAME:WaitFrames(25)
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false,  30)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
end
