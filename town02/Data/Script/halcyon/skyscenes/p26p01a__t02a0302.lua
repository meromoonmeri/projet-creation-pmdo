-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P26P01A/t02a0302.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_P26P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- supervision_Acting(2) [neutre/état moteur]
  -- supervision_Acting(3) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() GAME:MoveCamera(204, 160, 1, false) end) -- SetPositionMark performer/caméra
  local npc_npc_goroon = SkySceneKit.spawn_npc("graveler", 208, 368, Direction.Up, "NPC_GOROON")
  GROUND:TeleportTo(npc_npc_goroon, 204, 160, Direction.Down)
  GAME:FadeIn(15)
  GAME:WaitFrames(20)
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(8) -- WaitEndAnimation (join anim)
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(4) [neutre/état moteur]
  local npc_npc_chaaremu = SkySceneKit.spawn_npc("medicham", 160, 128, Direction.Up, "NPC_CHAAREMU")
  GROUND:EntTurn(npc_npc_chaaremu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.spin(npc_npc_chaaremu, 1, 1, 1) -- Turn3 (rotation partielle)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(8) -- WaitEndAnimation (join anim)
  -- supervision_RemoveActing(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(5) [neutre/état moteur]
  local npc_npc_saanaito = SkySceneKit.spawn_npc("gardevoir", 256, 128, Direction.Up, "NPC_SAANAITO")
  GROUND:EntTurn(npc_npc_saanaito, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.spin(npc_npc_saanaito, 1, 1, 1) -- Turn3 (rotation partielle)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(8) -- WaitEndAnimation (join anim)
  -- supervision_RemoveActing(3) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(6) [neutre/état moteur]
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.spin(hero, 1, 1, 1) -- Turn3 (rotation partielle)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(24) [anim idle native]
  -- SetAnimation(24) [anim idle native]
  -- SetAnimation(27) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(npc_npc_goroon, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_goroon.Position; GROUND:MoveToPosition(npc_npc_goroon, p.X+(0), p.Y+(16), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(29)
  GAME:FadeOut(false, 5)
  SkySceneKit.cleanup_npcs()
end
