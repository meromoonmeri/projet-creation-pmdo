-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T00P01/m01a0101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="...Fnarff... Yes? I'll open up the shop-related\nmenus for you. Which one would you like?", french="...Fnarff... Yes? I'll open up the shop-related\nmenus for you. Which one would you like?", german="...Fnarff... Yes? I'll open up the shop-related\nmenus for you. Which one would you like?", italian="...Fnarff... Yes? I'll open up the shop-related\nmenus for you. Which one would you like?", spanish="...Fnarff... Yes? I'll open up the shop-related\nmenus for you. Which one would you like?"})
end
