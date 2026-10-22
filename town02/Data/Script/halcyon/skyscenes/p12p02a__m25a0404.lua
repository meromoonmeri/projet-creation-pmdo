-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P12P02A/m25a0404.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Time Gear Remix.ogg", true) end)
  -- back_SetGround(LEVEL_P12P02A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(3) [anim idle native]
  -- SetAnimation(3) [anim idle native]
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- Move2PositionMark<object OBJECT_D28P33A3_68> [prop décor NDS, géré par le rendu du ground]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-128), p.Y+(-64), false, 2) end -- Slide2PositionOffset
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-128), p.Y+(-64), false, 2) end -- Slide2PositionOffset
  GAME:FadeIn(30)
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D28P33A3_68) [routine d'objet NDS non simulée - documenté]
  -- GAP: se_Play(8450) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  GAME:WaitFrames(20)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(60)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GROUND:MoveToPosition(partner, 440, 220, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  GROUND:MoveToPosition(partner, 420, 220, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(hero, 440, 220, false, 2)
  GAME:WaitFrames(20)
  GROUND:MoveToPosition(partner, 360, 220, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.Right)
  GAME:WaitFrames(20)
  GROUND:MoveToPosition(hero, 420, 220, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  GROUND:MoveToPosition(hero, 392, 220, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-80), p.Y+(0), false, 2) end
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-100), p.Y+(0), false, 2) end
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 30)
end
