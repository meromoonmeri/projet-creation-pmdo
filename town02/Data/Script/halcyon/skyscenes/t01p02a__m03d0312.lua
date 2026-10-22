-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P02A/m03d0312.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_T01P02A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  GAME:FadeIn(30)
  local npc_npc_ruriri = SkySceneKit.spawn_npc("azurill", 416, 216, Direction.Right, "NPC_RURIRI")
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- supervision_Acting(2) [neutre/état moteur]
  -- SlidePositionMark OBJECT_P03P02A1_128 [cible sans placement SSA zone: glissement non joué]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(30)
  GROUND:EntTurn(partner, Direction.UpRight)
  local npc_npc_kakureon1 = SkySceneKit.spawn_npc("kecleon", 328, 168, Direction.Down, "NPC_KAKUREON1")
  GROUND:EntTurn(npc_npc_kakureon1, Direction.Down)
  GAME:WaitFrames(4)
  local npc_npc_kakureon2 = SkySceneKit.spawn_npc("kecleon", 352, 168, Direction.DownRight, "NPC_KAKUREON2")
  GROUND:EntTurn(npc_npc_kakureon2, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_P03P02A1_128) [routine d'objet NDS non simulée - documenté]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(20), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(30)
  -- SetAnimation(2) [anim idle native]
  do local p=npc_npc_ruriri.Position; GROUND:MoveToPosition(npc_npc_ruriri, p.X+(-8), p.Y+(-16), false, 2) end -- Move2PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(npc_npc_ruriri, 360, 196, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  -- SetAnimation(23) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_ruriri) end)
  SkySceneKit.say({english="W-we're sorry to bother you.\nThank you so much.", french="M-merci beaucoup... Pardon\npour le dérangement.", german="T-tut uns leid, dass wir gestört\nhaben. Vielen Dank.", italian="C-Ci spiace di averla disturbata.\nGrazie mille.", spanish="Sentimos haberte molestado.\nMuchas gracias."})
  -- message_Close
  GAME:FadeOut(false,  30)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  GAME:FadeIn(0) -- screen_FlushIn
  SkySceneKit.cleanup_npcs()
end
