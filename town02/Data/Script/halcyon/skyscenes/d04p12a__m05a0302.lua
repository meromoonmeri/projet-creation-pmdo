-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D04P12A/m05a0302.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D04P12A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:FadeIn(15)
  GAME:WaitFrames(30)
  local npc_npc_dark_pukurin = SkySceneKit.spawn_npc("wigglytuff", 208, 536, Direction.Up, "NPC_DARK_PUKURIN")
  -- SetAnimation(42) [anim idle native]
  GROUND:MoveToPosition(npc_npc_dark_pukurin, 204, 396, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(npc_npc_dark_pukurin, 204, 164, false, 2)
  pcall(function() GAME:MoveCamera(204, 164, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(80)
  -- GAP: se_Play(5139) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 5) -- screen_WhiteOut
  GAME:FadeIn(0) -- screen_FlushIn
  SkySceneKit.cleanup_npcs()
end
