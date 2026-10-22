-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V26P05A/m26a0701.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V26P06A) [décor sub chargé: Sub_v26p06a]
  -- back_SetGround(LEVEL_V26P05A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- SetOutputAttribute(2048) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 19, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- supervision_SpecialActing(23, 600, 0) [cadrage NDS]
  -- supervision2_SpecialActing(23, 600, 0) [acting sub NDS: décor déjà reproduit par SubScreen, acteurs sub non simulés - trace]
  -- switch(message_Menu(MENU_STAFF_CREDITS1)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  GAME:WaitFrames(30) -- WaitBgmSignal (signal SMD NDS sans équivalent: join fixe documenté)
  SkySubScreen.Show("v26p06a", 120, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(120)
  GAME:WaitFrames(2) -- join WaitBgm
  -- GAP: BGM BGM_ENDING_THEME non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- switch(message_Menu(MENU_STAFF_CREDITS2)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  GAME:WaitFrames(180)
  -- switch(message_Menu(MENU_STAFF_CREDITS2)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- switch(message_Menu(MENU_STAFF_CREDITS2)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- switch(message_Menu(MENU_STAFF_CREDITS3)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  pcall(function() SOUND:FadeOutBGM(210) end)
  SkySubScreen.Hide(180) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 180)
  GAME:WaitFrames(60)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  -- supervision_SpecialActing(3, 0, 0) [cadrage NDS]
  -- supervision2_SpecialActing(3, 0, 0) [acting sub NDS: décor déjà reproduit par SubScreen, acteurs sub non simulés - trace]
  GAME:WaitFrames(2) -- join WaitBgm
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
