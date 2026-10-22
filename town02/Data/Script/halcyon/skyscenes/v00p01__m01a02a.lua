-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V00P01/m01a02a.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_S13P03A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- Slide2PositionMark 0 [cible sans placement SSA zone: glissement non joué]
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(240), g.ViewCenter.Y+(120), 120, false) end) -- back_SetBackScrollSpeed(2.0,1.0) px/frame -> caméra continue (pilote scroll)
  GAME:FadeIn(30)
  GAME:WaitFrames(320)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(960), g.ViewCenter.Y+(240), 120, false) end) -- back_SetBackScrollSpeed(8.0,2.0) px/frame -> caméra continue (pilote scroll)
  GAME:WaitFrames(320)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(1920), g.ViewCenter.Y+(480), 120, false) end) -- back_SetBackScrollSpeed(16.0,4.0) px/frame -> caméra continue (pilote scroll)
  GAME:WaitFrames(320)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(3840), g.ViewCenter.Y+(960), 120, false) end) -- back_SetBackScrollSpeed(32.0,8.0) px/frame -> caméra continue (pilote scroll)
  GAME:WaitFrames(320)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(7680), g.ViewCenter.Y+(1920), 120, false) end) -- back_SetBackScrollSpeed(64.0,16.0) px/frame -> caméra continue (pilote scroll)
  GAME:WaitFrames(320)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(15360), g.ViewCenter.Y+(3840), 120, false) end) -- back_SetBackScrollSpeed(128.0,32.0) px/frame -> caméra continue (pilote scroll)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Loop Scroll Test", french="Loop Scroll Test", german="Loop Scroll Test", italian="Loop Scroll Test", spanish="Loop Scroll Test"})
  -- message_Close
  GAME:FadeOut(false, 30)
  -- back2_SetMode(5) [mode d'affichage sub NDS: géré par SubScreen]
  -- back_SetGround(LEVEL_S13P05A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- back_SetBackEffect(4) [état de lecture des palettes animées NDS: autotiles PMDO animés en boucle - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(240), g.ViewCenter.Y+(120), 120, false) end) -- back_SetBackScrollSpeed(2.0,1.0) px/frame -> caméra continue (pilote scroll)
  -- screen2_FadeIn(0, 30) [sub révélé en mode système NDS (aucun décor chargé): pas de contenu narratif - documenté]
  GAME:FadeIn(30)
  -- back_SetBackEffect(5) [état de lecture des palettes animées NDS: autotiles PMDO animés en boucle - documenté]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Scroll Test", french="Test défilement", german="Scroll Test", italian="Scroll Test", spanish="Scroll Test"})
  -- message_Close
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 30)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  -- back_SetGround(LEVEL_V24P03A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(-480), g.ViewCenter.Y+(0), 120, false) end) -- back_SetBackScrollSpeed(-4.0,0.0) px/frame -> caméra continue (pilote scroll)
  GAME:FadeIn(30)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Loop Scroll Test 2", french="Loop Scroll Test 2", german="Loop Scroll Test 2", italian="Loop Scroll Test 2", spanish="Loop Scroll Test 2"})
  -- message_Close
  GAME:FadeOut(false, 30)
  -- back_SetGround(LEVEL_P13P01A) [neutre/état moteur]
  pcall(function() GAME:MoveCamera(240, 220, 1, false) end)
  GAME:FadeIn(30)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(480), g.ViewCenter.Y+(0), 120, false) end) -- back_SetBackScrollSpeed(4.0,0.0) px/frame -> caméra continue (pilote scroll)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Loop Scroll Test 3A", french="Loop Scroll Test 3A", german="Loop Scroll Test 3A", italian="Loop Scroll Test 3A", spanish="Loop Scroll Test 3A"})
  -- message_Close
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(-480), g.ViewCenter.Y+(0), 120, false) end) -- back_SetBackScrollSpeed(-4.0,0.0) px/frame -> caméra continue (pilote scroll)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Loop Scroll Test 3B", french="Loop Scroll Test 3B", german="Loop Scroll Test 3B", italian="Loop Scroll Test 3B", spanish="Loop Scroll Test 3B"})
  -- message_Close
  GAME:FadeOut(false, 30)
  SkySceneKit.play_scene("t00p01__m01a0100", "t00p01__m01a01", hero, partner) -- supervision_ExecuteStation(LEVEL_T00P01, 'M01A01', 0) [chaînage scène ROM]
  GAME:WaitFrames(1) -- hold
end
