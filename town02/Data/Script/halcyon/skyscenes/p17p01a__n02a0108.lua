-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P17P01A/n02a0108.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Heartwarming.ogg", true) end)
  -- back_SetGround(LEVEL_P17P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 19, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() GAME:MoveCamera(152, 120, 60, false) end) -- performer/caméra
  -- screen2_FadeIn(0, 30) [sub révélé en mode système NDS (aucun décor chargé): pas de contenu narratif - documenté]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- message_SetWaitMode(190, 80) [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]I was raised in that little house...", french="[CN]Et dans cette prairie,\n[CN]la petite maison où je fus élevé...", german="[CN]Ich wuchs in diesem kleinen Haus auf...", italian="[CN]Abitavo in una piccola casetta...", spanish="[CN]Me crie en una casita..."})
  -- message_KeyWait
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]I lived happily there with my parents.", french="[CN]Je vécus des années heureuses, là,\n[CN]avec mes parents.", german="[CN]Fröhlich, zusammen mit meinen Eltern.", italian="[CN]... accudito amorevolmente dai miei genitori.", spanish="[CN]Era de lo más feliz viviendo con mis padres."})
  -- message_Close
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 30)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  -- message_SetWaitMode(-1, -1) [neutre/état moteur]
end
