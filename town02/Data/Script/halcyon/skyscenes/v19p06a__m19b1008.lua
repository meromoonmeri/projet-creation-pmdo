-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V19P06A/m19b1008.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  -- back_SetGround(LEVEL_V19P06A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- screen2_FadeIn(0, 15) [sub révélé en mode système NDS (aucun décor chargé): pas de contenu narratif - documenté]
  GAME:FadeIn(15)
  -- GAP: se_Play(7438) — id SE NDS sans portage PMDO identifié
  pcall(function() GAME:MoveCamera(468, 120, 1, false) end)
  GAME:WaitFrames(5)
  pcall(function() GAME:MoveCamera(780, 120, 1, false) end)
  GAME:WaitFrames(5)
  pcall(function() GAME:MoveCamera(156, 360, 1, false) end)
  GAME:WaitFrames(5)
  pcall(function() GAME:MoveCamera(468, 360, 1, false) end)
  -- supervision_SpecialActing(10, 0, 0) [cadrage NDS]
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitSe
  GAME:FadeOut(false, 30)
  -- supervision_SpecialActing(3, 0, 0) [cadrage NDS]
end
