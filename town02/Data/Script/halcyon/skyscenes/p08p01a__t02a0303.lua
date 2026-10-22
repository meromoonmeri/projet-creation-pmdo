-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P08P01A/t02a0303.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_P08P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_yamirami = SkySceneKit.spawn_npc("sableye", 240, 184, Direction.Down, "NPC_YAMIRAMI")
  GROUND:TeleportTo(npc_npc_yamirami, 224, 292, Direction.Down)
  local npc_npc_yamirami2 = SkySceneKit.spawn_npc("sableye", 280, 160, Direction.Down, "NPC_YAMIRAMI2")
  GROUND:TeleportTo(npc_npc_yamirami2, 276, 268, Direction.Down)
  local npc_npc_yamirami3 = SkySceneKit.spawn_npc("sableye", 320, 200, Direction.Down, "NPC_YAMIRAMI3")
  GROUND:TeleportTo(npc_npc_yamirami3, 332, 292, Direction.Down)
  local npc_npc_yamirami4 = SkySceneKit.spawn_npc("sableye", 224, 464, Direction.Up, "NPC_YAMIRAMI4")
  GROUND:TeleportTo(npc_npc_yamirami4, 224, 348, Direction.Down)
  local npc_npc_yamirami5 = SkySceneKit.spawn_npc("sableye", 280, 512, Direction.Up, "NPC_YAMIRAMI5")
  GROUND:TeleportTo(npc_npc_yamirami5, 276, 372, Direction.Down)
  local npc_npc_yamirami6 = SkySceneKit.spawn_npc("sableye", 336, 488, Direction.Up, "NPC_YAMIRAMI6")
  GROUND:TeleportTo(npc_npc_yamirami6, 332, 348, Direction.Down)
  GROUND:TeleportTo(hero, 296, 308, Direction.Down)
  local npc_npc_yonowaaru_n8 = SkySceneKit.spawn_npc("dusknoir", 256, 544, Direction.Up, "NPC_YONOWAARU_N8")
  GROUND:TeleportTo(npc_npc_yonowaaru_n8, 252, 340, Direction.Down)
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(npc_npc_yonowaaru_n8, Direction.Down)
  GROUND:EntTurn(npc_npc_yamirami3, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_yamirami4, Direction.UpRight)
  GROUND:EntTurn(npc_npc_yamirami, Direction.DownRight)
  GROUND:EntTurn(npc_npc_yamirami6, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_yamirami2, Direction.Down)
  GROUND:EntTurn(npc_npc_yamirami5, Direction.Up)
  GAME:FadeIn(30)
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(hero, 276, 308, false, 2) -- SlidePositionMark (glissement)
  GAME:WaitFrames(5)
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(npc_npc_yonowaaru_n8, 276, 340, false, 2) -- SlidePositionMark (glissement)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_yonowaaru_n8, Direction.Down)
  GAME:WaitFrames(20)
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(10)
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- message_Close
  -- SetAnimation(12) [anim idle native]
  GAME:WaitFrames(2)
  -- SetAnimation(12) [anim idle native]
  -- SetAnimation(12) [anim idle native]
  GAME:WaitFrames(2)
  -- SetAnimation(12) [anim idle native]
  -- SetAnimation(12) [anim idle native]
  GAME:WaitFrames(2)
  -- SetAnimation(12) [anim idle native]
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  GAME:FadeOut(false, 15)
  SkySceneKit.cleanup_npcs()
end
