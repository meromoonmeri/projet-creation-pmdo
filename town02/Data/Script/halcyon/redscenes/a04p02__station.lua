-- GÉNÉRÉ par dev/tools/red_compile_cinematics.py (V2 séquence ROM) — NE PAS ÉDITER À LA MAIN.
-- Station canonique PMD Red EU : ground a04p02 — ordre = commands des scripts EU décodés (adresses ROM).
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() SOUND:PlayBGM("Sky Tower (Rescue Team).ogg", true) end) -- 0x44 music_id 22 (ROM)
  SkySceneKit.say({english="It's a huge tower of clouds...", french="C'est une tour énorme faite de nuages...", german="Das ist ein hoher Turm aus Wolken...", italian="È un'enorme torre di nuvole...", spanish="Es como una gran torre de nubes..."})
end
