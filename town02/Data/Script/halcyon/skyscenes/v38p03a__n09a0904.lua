-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V38P03A/n09a0904.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_TEMPORAL_PINNACLE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_V38P03A) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- camera_SetMyself() [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetAnimation(1) [anim idle native]
  -- GAP: se_Play(10759) — id SE NDS sans portage PMDO identifié
  GAME:FadeIn(30)
  GAME:WaitFrames(10)
  -- Destroy() [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetAnimation(1) [anim idle native]
  GAME:WaitFrames(5)
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(10)
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetAnimation(1) [anim idle native]
  GAME:WaitFrames(40)
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(10)
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetAnimation(1) [anim idle native]
  GAME:WaitFrames(5)
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(10)
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetAnimation(1) [anim idle native]
  GAME:WaitFrames(15)
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(10)
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetAnimation(1) [anim idle native]
  GAME:WaitFrames(60)
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(10)
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetAnimation(1) [anim idle native]
  GAME:WaitFrames(5)
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(10)
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetAnimation(1) [anim idle native]
  -- se_ChangeVolume(10759, 60, 128) [canal SE NDS: one-shots PMDO, volume non scriptable]
  GAME:FadeOut(false, 30)
  GAME:WaitFrames(30)
  -- Destroy() [neutre/état moteur]
end
