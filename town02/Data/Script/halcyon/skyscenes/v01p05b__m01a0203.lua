-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V01P05B/m01a0203.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- bgm2_PlayFadeIn(BGM_OCEAN1) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  -- back_SetGround(LEVEL_V01P05B) [neutre/état moteur]
  -- supervision_SpecialActing(5, -2, 4) [cadrage NDS]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_ON_THE_BEACH_AT_DUSK non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(150)
  GAME:FadeOut(false, 30)
  -- supervision_SpecialActing(3, 0, 0) [cadrage NDS]
end
