-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V03P11A/m03a1310.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- bgm2_PlayFadeIn(BGM_STORM) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  pcall(function() SOUND:PlayBGM("Time Gear Remix.ogg", true) end)
  -- back_SetGround(LEVEL_V03P11A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(-1440), g.ViewCenter.Y+(0), 120, false) end) -- back_SetBackScrollSpeed(-12.0,0.0) px/frame -> caméra continue (pilote scroll)
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 472, 240, Direction.Left, "NPC_JUPUTORU")
  -- SetAnimation(42) [anim idle native]
  -- GAP: SetEffect EFFECT_VERY_HEAVY_RAIN — VFX sans émote PMDO équivalente
  GAME:FadeIn(15)
  GAME:WaitFrames(60)
  -- GAP: se_Play(6401) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(3)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(3)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitSe
  -- GAP: se_Play(6420) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(1024) [anim idle native]
  do local p=npc_npc_juputoru.Position; GROUND:MoveToPosition(npc_npc_juputoru, p.X+(-400), p.Y+(0), false, 2) end
  GAME:WaitFrames(90)
  -- se_FadeOut(6420, 15) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  -- bgm2_ChangeVolume(30, 128) [effet du canal sub NDS: nappe Sub_ statique, effet non simulé - documenté]
  GAME:FadeOut(false, 15)
  SkySceneKit.cleanup_npcs()
end
