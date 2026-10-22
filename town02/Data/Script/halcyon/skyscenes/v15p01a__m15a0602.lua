-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V15P01A/m15a0602.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back2_SetMode(5) [mode d'affichage sub NDS: géré par SubScreen]
  -- back_SetGround(LEVEL_V15P01A) [neutre/état moteur]
  -- back2_SetGround(V15P01A) [décor sub chargé: Sub_v15p01a]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 16, 30)) end) -- camera_SetEffect('2', '8', '1', '0')
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(-240), 1, false) end) -- back_SetBackScrollOffset px NDS (pilote scroll)
  -- GAP: BGM BGM_EARTHQUAKE3 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  SkySubScreen.Show("v15p01a", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  -- GAP: se_Play(7177) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(30)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(1200), 120, false) end) -- back_SetBackScrollSpeed(0.0,10.0) px/frame -> caméra continue (pilote scroll)
  GAME:WaitFrames(180)
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(2) [neutre/état moteur]
  GAME:WaitFrames(95)
  -- back_SetBackScrollSpeed(0,0): arrêt du défilement
  pcall(function() SOUND:FadeOutBGM(30) end)
  -- se_FadeOut(7177, 10) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  -- GAP: se_Play(7197) — id SE NDS sans portage PMDO identifié
  -- camera_SetEffect(0): arrêt d'effet caméra
  -- camera2_SetEffect(0, 0, 0) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  GAME:WaitFrames(2) -- join WaitSe
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 30)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
