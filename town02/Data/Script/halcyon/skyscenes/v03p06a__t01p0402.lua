-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V03P06A/t01p0402.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  -- back_SetGround(LEVEL_V03P06A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  if true --[[BranchVariation: ROM Sky EU]] then -- if ROM: variation
  -- @label_0 [étiquette de flux ExplorerScript]
  -- supervision_Acting(10) [neutre/état moteur]
  -- @label_1 [étiquette de flux ExplorerScript]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(3) [anim idle native]
  -- SetAnimation(3) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetOutputAttribute(4) [neutre/état moteur]
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(S05P02C) [décor sub chargé: Sub_s05p02c]
  -- camera2_SetPositionMark(Position<'m0', 16.5, 13.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  SkySubScreen.Show("s05p02c", 0, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(0)
  GAME:WaitFrames(2000)
  SkySubScreen.Hide(60) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 60)
  else
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
