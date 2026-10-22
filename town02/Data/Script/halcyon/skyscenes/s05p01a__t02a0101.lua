-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/S05P01A/t02a0101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  if true --[[BranchVariation: ROM Sky EU]] then -- if ROM: variation
  -- @label_0 [étiquette de flux ExplorerScript]
  -- screen2_WhiteOut [sub déjà caché]
  GAME:FadeOut(true, 0) -- screen_WhiteOutAll
  -- back2_SetMode(5) [mode d'affichage sub NDS: géré par SubScreen]
  -- back_SetGround(LEVEL_S05P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- switch(message_Menu(MENU_DEMO_SEQUENCE1)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- screen2_FadeIn(0, 30) [sub révélé en mode système NDS (aucun décor chargé): pas de contenu narratif - documenté]
  GAME:FadeIn(30)
  GAME:WaitFrames(90)
  SkySubScreen.Hide(30) -- screen2_WhiteOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(true, 30) -- screen_WhiteOutAll
  -- @label_1 [étiquette de flux ExplorerScript]
  GAME:WaitFrames(10)
  pcall(function() GAME:MoveCamera(396, 300, 1, false) end) -- SetPositionMark performer/caméra
  -- screen2_FadeIn(0, 30) [sub révélé en mode système NDS (aucun décor chargé): pas de contenu narratif - documenté]
  GAME:FadeIn(30)
  GAME:WaitFrames(90)
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false,  30)
  GAME:WaitFrames(10)
  pcall(function() GAME:MoveCamera(660, 300, 1, false) end) -- SetPositionMark performer/caméra
  -- screen2_FadeIn(0, 30) [sub révélé en mode système NDS (aucun décor chargé): pas de contenu narratif - documenté]
  GAME:FadeIn(30)
  GAME:WaitFrames(90)
  -- switch(message_Menu(MENU_DEMO_SEQUENCE2)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false,  30)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  else
  -- back2_SetMode(5) [mode d'affichage sub NDS: géré par SubScreen]
  -- back_SetGround(LEVEL_S05P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- switch(message_Menu(MENU_DEMO_SEQUENCE1)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  end
end
