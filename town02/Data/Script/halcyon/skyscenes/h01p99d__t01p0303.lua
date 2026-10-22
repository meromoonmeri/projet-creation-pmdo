-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H01P99D/t01p0303.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  -- back_SetGround(LEVEL_H01P99D) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V21P02A) [décor sub chargé: Sub_v21p02a]
  -- camera2_SetPositionMark(Position<'m0', 20, 18.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(30) -- WaitBgmSignal (signal SMD NDS sans équivalent: join fixe documenté)
  SkySubScreen.Show("v21p02a", 5, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(5)
  -- Move2PositionMark<object OBJECT_V21P02A1_288> [prop décor NDS, géré par le rendu du ground]
  -- back2_SetBackEffect(3) [effet du canal sub NDS: nappe Sub_ statique, effet non simulé - documenté]
  -- back_SetBackEffect(3) [état de lecture des palettes animées NDS: autotiles PMDO animés en boucle - documenté]
  GAME:WaitFrames(45)
  GROUND:EntTurn(partner, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_RIGHT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  GAME:WaitFrames(160)
  SkySubScreen.Hide(5) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 5)
  GAME:FadeIn(5)
  GAME:WaitFrames(220)
  GAME:FadeOut(false, 10)
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
