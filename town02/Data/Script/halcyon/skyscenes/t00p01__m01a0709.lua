-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T00P01/m01a0709.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  GAME:WaitFrames(1) -- with(...){hold} NDS
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="This dungeon is closed because of story\nevents.", french="This dungeon is closed because of story\nevents.", german="This dungeon is closed because of story\nevents.", italian="This dungeon is closed because of story\nevents.", spanish="This dungeon is closed because of story\nevents."})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
end
