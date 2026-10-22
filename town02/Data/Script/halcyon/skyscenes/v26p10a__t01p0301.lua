-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V26P10A/t01p0301.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  GAME:WaitFrames(30) -- WaitBgmSignal (signal SMD NDS sans équivalent: join fixe documenté)
  GAME:FadeIn(5)
  GAME:WaitFrames(70)
  GAME:FadeOut(false, 5)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V24P08A) [décor sub chargé: Sub_v24p08a]
  -- back_SetGround(LEVEL_V26P10A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 19, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  GAME:WaitFrames(30) -- WaitBgmSignal (signal SMD NDS sans équivalent: join fixe documenté)
  SkySubScreen.Show("v24p08a", 5, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(5)
  GAME:WaitFrames(75)
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetAnimation(18) [anim idle native]
  -- back_SetBackEffect(3) [état de lecture des palettes animées NDS: autotiles PMDO animés en boucle - documenté]
  -- back2_SetBackEffect(3) [effet du canal sub NDS: nappe Sub_ statique, effet non simulé - documenté]
  GAME:WaitFrames(180)
  SkySubScreen.Hide(5) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 5)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(30) -- WaitBgmSignal (signal SMD NDS sans équivalent: join fixe documenté)
  GAME:FadeIn(5)
  GAME:WaitFrames(90)
  GAME:FadeOut(false, 5)
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
