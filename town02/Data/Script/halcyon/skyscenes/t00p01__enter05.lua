-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T00P01/enter05.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Welcome!\n[CN]This is the fun Treasure Town!", french="[CN]Welcome!\n[CN]This is the fun Treasure Town!", german="[CN]Welcome!\n[CN]This is the fun Treasure Town!", italian="[CN]Benvenuti!\n[CN]Questo è il fantastico Borgo Tesoro.", spanish="[CN]Welcome!\n[CN]This is the fun Treasure Town!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Whiscash Pond ↑\n[S:80][CS:N]Pelipper[CR] Post Office →", french="Whiscash Pond ↑\n[S:80][CS:N]Pelipper[CR] Post Office →", german="Whiscash Pond ↑\n[S:80][CS:N]Pelipper[CR] Post Office →", italian="Laghetto Whiscash  ↑\nUfficio Postale [S:80][CS:N]Pelipper[CR] →", spanish="Whiscash Pond ↑\n[S:80][CS:N]Pelipper[CR] Post Office →"})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
end
