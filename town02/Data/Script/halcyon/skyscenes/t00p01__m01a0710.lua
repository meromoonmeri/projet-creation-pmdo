-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T00P01/m01a0710.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  GAME:WaitFrames(1) -- with(...){hold} NDS
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="There's nothing here.", french="There's nothing here.", german="There's nothing here.", italian="There's nothing here.", spanish="There's nothing here."})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
end
