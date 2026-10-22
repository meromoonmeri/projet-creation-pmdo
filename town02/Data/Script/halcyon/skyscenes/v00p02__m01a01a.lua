-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V00P02/m01a01a.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  -- back2_SetMode(1) [mode d'affichage sub NDS: géré par SubScreen]
  -- screen2_FadeOut [sub déjà caché]
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V01P02A) [décor sub chargé: Sub_v01p02a]
  -- back2_SetWeather(4) [effet du canal sub NDS: nappe Sub_ statique, effet non simulé - documenté]
  -- back_SetGround(LEVEL_V00P02) [neutre/état moteur]
  -- back_SetWeather(5) [météo visuelle ground NDS - documenté]
  -- supervision_Acting(0) [neutre/état moteur]
  pcall(function() GAME:MoveCamera(160, 116, 1, false) end)
  -- camera2_SetPositionMark(Position<'m1', 17, 14.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  GAME:FadeIn(30)
  SkySubScreen.Show("v01p02a", 30, true) -- screen2_FadeIn: BOTH_FOCUS (timeline ROM)
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 16, 30)) end) -- camera_SetEffect('1', '8', '2', '0')
  -- camera2_SetEffect(1, 8, 2.0) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  GAME:FadeOut(true, 60) -- screen_WhiteOut
  SkySubScreen.Hide(60) -- screen2_WhiteOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:FadeIn(30)
  SkySubScreen.Show("v01p02a", 30, true) -- screen2_FadeIn: BOTH_FOCUS (timeline ROM)
  SkySubScreen.Hide(20) -- screen2_WhiteOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V01P02A) [décor sub chargé: Sub_v01p02a]
  -- back2_SetWeather(4) [effet du canal sub NDS: nappe Sub_ statique, effet non simulé - documenté]
  -- camera2_SetPositionMark(Position<'m2', 17, 14.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  SkySubScreen.Show("v01p02a", 20, true) -- screen2_FadeIn: BOTH_FOCUS (timeline ROM)
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_V01P02A1_197) [routine d'objet NDS non simulée - documenté]
  GAME:WaitFrames(60)
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_V01P02A1_197) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_V01P02A1_197) [routine d'objet NDS non simulée - documenté]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CS:W]Memo: Raging storm at night[CR].", french="[CS:W]Memo: Raging storm at night[CR].", german="[CS:W]Memo: Raging storm at night[CR].", italian="[CS:W]Memo: Raging storm at night[CR].", spanish="[CS:W]Memo: Raging storm at night[CR]."})
  -- camera_SetEffect(0): arrêt d'effet caméra
  -- camera2_SetEffect(0, 0, 0) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- SetOutputAttribute(2048) [neutre/état moteur]
  -- SetAnimation(1) [anim idle native]
  GAME:WaitFrames(30)
  -- camera2_SetPositionMark(Position<'m3', 53, 14.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  GAME:WaitFrames(20)
  -- camera2_SetPositionMark(Position<'m4', 17, 14.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  GAME:WaitFrames(30)
  -- camera2_SetPositionMark(Position<'m5', 53, 14.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  GAME:WaitFrames(20)
  -- camera2_SetPositionMark(Position<'m6', 17, 14.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- SetAnimation(2048) [anim idle native]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CS:W]Memo: Two lightning flashes. They reveal the\nsilhouette of Sharpedo Bluff.[CR]", french="[CS:W]Memo: Two lightning flashes. They reveal the\nsilhouette of Sharpedo Bluff.[CR]", german="[CS:W]Memo: Two lightning flashes. They reveal the\nsilhouette of Sharpedo Bluff.[CR]", italian="[CS:W]Memo: Two lightning flashes. They reveal the\nsilhouette of Sharpedo Bluff.[CR]", spanish="[CS:W]Memo: Two lightning flashes. They reveal the\nsilhouette of Sharpedo Bluff.[CR]"})
  -- message_Close
  -- @label_0 [étiquette de flux ExplorerScript]
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 30)
  -- back2_SetMode(-1) [mode d'affichage sub NDS: géré par SubScreen]
  SkySceneKit.play_scene("t00p01__m01a0100", "t00p01__m01a01", hero, partner) -- supervision_ExecuteStation(LEVEL_T00P01, 'M01A01', 0) [chaînage scène ROM]
  GAME:WaitFrames(1) -- hold
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
