-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/S13P04B/t02a0203.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(S13P04A) [décor sub chargé: Sub_s13p04a]
  -- back_SetGround(LEVEL_S13P04B) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 16.5, 13.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() GAME:MoveCamera(232, 108, 60, false) end) -- performer/caméra
  -- camera2_MovePositionMark(0.2969, Position<'m2', 29, 13.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(120), g.ViewCenter.Y+(0), 120, false) end) -- back_SetBackScrollSpeed(1.0,0.0) px/frame -> caméra continue (pilote scroll)
  -- back2_SetBackScrollSpeed(1, 0) [effet du canal sub NDS: nappe Sub_ statique, effet non simulé - documenté]
  GAME:WaitFrames(30) -- WaitBgmSignal (signal SMD NDS sans équivalent: join fixe documenté)
  SkySubScreen.Show("s13p04a", 15, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(15)
  GAME:WaitFrames(315)
  SkySubScreen.Hide(60) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 60)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
