-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V03P12A/m08a0203.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Time Gear Remix.ogg", true) end)
  -- back_SetGround(LEVEL_V03P12A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(15)
  GAME:WaitFrames(30)
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Three more Time Gears remain. I must\nhave them...", french="Il reste encore trois Rouages du Temps.\nIl me les faut...", german="Nun bleiben noch drei Zahnräder der Zeit.\nIch muss sie holen.", italian=" Ne rimangono altri tre. Devo averli...", spanish="Me quedan aún otros tres.\nDebo hacerme con ellos..."})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(190) end)
  GAME:WaitFrames(45)
  GAME:FadeOut(false, 90)
  GAME:WaitFrames(60)
  GAME:WaitFrames(60)
end
