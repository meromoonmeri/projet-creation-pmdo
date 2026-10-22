-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/S04P01A/n04a0103.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Guildmaster Wigglytuff.ogg", true) end)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Today's \\\"Oh My Gosh\\\"", french="\\\"Ben mince alors!\\\"", german="Das [F:S2]Auweia[F:E2] des Tages", italian="Una giornata da shock", spanish="¡O sea, pero qué fuerte!"}) -- bannière d'épisode spécial (titre ROM)
  GAME:FadeIn(0)
  GAME:WaitFrames(160)
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 45)
  GAME:WaitFrames(15)
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitBgm
  GAME:WaitFrames(30)
end
