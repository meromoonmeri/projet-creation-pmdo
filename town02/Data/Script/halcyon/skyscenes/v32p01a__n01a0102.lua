-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V32P01A/n01a0102.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- GAP: se_Play(9487) — id SE NDS sans portage PMDO identifié
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Bidoof's Wish", french="Le vœu de Keunotor", german="Der Wunsch von Bidiza", italian="Il desiderio di Bidoof", spanish="El deseo de Bidoof"}) -- bannière d'épisode spécial (titre ROM)
  GAME:FadeIn(0)
  GAME:WaitFrames(160)
  GAME:FadeOut(false, 45)
  GAME:WaitFrames(15)
  GAME:WaitFrames(30)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]That's right![K] My dream is to\n[CN]be the best explorer!", french="[CN]Et oui![K] C'est mon rêve: devenir\n[CN]un jour le meilleur explorateur au monde!", german="[CN]Ganz genau![K] Mein Traum ist es,\n[CN]der beste Erkunder zu sein!", italian="[CN]Proprio così![K] Il mio sogno è diventare\n[CN]il migliore esploratore del mondo!", spanish="[CN]¡Eso es![K] ¡Mi sueño es llegar a ser\n[CN]el mejor explorador!"})
  -- message_Close
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V24P08A) [décor sub chargé: Sub_v24p08a]
  -- back_SetGround(LEVEL_V32P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 19, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(160), g.ViewCenter.Y+(0), 320, false) end) -- MovePositionOffset performer/caméra
  pcall(function() SOUND:PlayBGM("Sympathy.ogg", true) end)
  SkySubScreen.Show("v24p08a", 60, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(60)
  GAME:WaitFrames(150)
  GAME:FadeOut(false, 60)
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
