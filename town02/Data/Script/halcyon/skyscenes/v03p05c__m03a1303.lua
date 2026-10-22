-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V03P05C/m03a1303.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_V03P05C) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  pcall(function() GAME:MoveCamera(140, 140, 1, false) end)
  -- GAP: SetEffect EFFECT_VERY_HEAVY_RAIN — VFX sans émote PMDO équivalente
  -- GAP: BGM BGM_STORM non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GAME:WaitFrames(120)
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  -- GAP: se_Play(6424) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(120)
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(2) -- join WaitBgm
  -- GAP: SetEffect EFFECT_NONE sur PNJ non résolu (v2 cast SSA)
end
