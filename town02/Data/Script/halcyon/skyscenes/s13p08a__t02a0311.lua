-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/S13P08A/t02a0311.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(S13P07A) [décor sub chargé: Sub_s13p07a]
  -- back_SetGround(LEVEL_S13P08A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- camera2_SetPositionMark(Position<'m0', 20, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(2) [anim idle native]
  GROUND:TeleportTo(hero, 156, 156, Direction.Down)
  GROUND:TeleportTo(partner, 156, 156, Direction.Down)
  SkySceneKit.offset_pos(hero, 0, 138)
  SkySceneKit.offset_pos(partner, 0, 90)
  GROUND:MoveToPosition(hero, 156, 156, false, 2)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(-90), false, 2) end -- Move2PositionOffset
  SkySubScreen.Show("s13p07a", 60, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(60)
  GROUND:MoveToPosition(partner, 120, 124, false, 2)
  GROUND:EntTurn(partner, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(hero, 156, 140, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(partner, 128, 124, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  -- GAP: SetEffect 652 — VFX sans émote PMDO équivalente
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(45)
  SkySubScreen.Hide(30) -- screen2_WhiteOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(true, 30) -- screen_WhiteOutAll
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:FadeOut(true, 0) -- screen_WhiteOut
  GAME:FadeIn(0)
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
