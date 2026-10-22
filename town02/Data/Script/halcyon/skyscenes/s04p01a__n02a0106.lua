-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/S04P01A/n02a0106.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- GAP: se_Play(9487) — id SE NDS sans portage PMDO identifié
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Igglybuff the Prodigy", french="Toudoudou le Surdoué", german="Wundersamer Fluffeluff", italian="Igglybuff il genio", spanish="Igglybuff es un prodigio"}) -- bannière d'épisode spécial (titre ROM)
  GAME:FadeIn(0)
  GAME:WaitFrames(160)
  GAME:FadeOut(false, 45)
  GAME:WaitFrames(15)
  GAME:WaitFrames(30)
end
