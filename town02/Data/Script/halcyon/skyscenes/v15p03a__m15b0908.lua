-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V15P03A/m15b0908.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- bgm2_PlayFadeIn(BGM_EARTHQUAKE3) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  -- back_SetGround(LEVEL_V15P03A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '0', '2', '0')
  -- camera_SetMyself() [neutre/état moteur]
  -- supervision_SpecialActing(14, 25, 1) [cadrage NDS]
  GAME:FadeIn(30)
  GAME:WaitFrames(5)
  -- GAP: se_Play(5144) — id SE NDS sans portage PMDO identifié
  pcall(function() GAME:MoveCamera(592, 140, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(85)
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  GAME:FadeOut(false, 30)
  -- supervision_SpecialActing(3, 0, 0) [cadrage NDS]
  -- camera_SetEffect(0): arrêt d'effet caméra
end
