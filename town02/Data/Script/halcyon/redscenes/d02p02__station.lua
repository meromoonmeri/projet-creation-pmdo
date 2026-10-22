-- GÉNÉRÉ par dev/tools/red_compile_cinematics.py (V2 séquence ROM) — NE PAS ÉDITER À LA MAIN.
-- Station canonique PMD Red EU : ground d02p02 — ordre = commands des scripts EU décodés (adresses ROM).
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() SOUND:PlayBGM("In the Depths of the Pit (Rescue Team).ogg", true) end) -- 0x44 music_id 114 (ROM)
  SkySceneKit.say({english="Oh, hey, there they are. Let's get them out.", french="Oh, hé, ils sont là. Sortons-les de là.", german="Oh, hey, da sind sie ja. Holen wir sie hier heraus.", italian="Oh... eccoli lì. Aiutiamoli ad uscire.", spanish="Oh, mira, ahí están. Saquémoslos de aquí."})
  SkySceneKit.say({english="Oh, there they are! Let's get them out safely.", french="Oh, les voilà! Sortons-les de là.", german="Oh, da sind sie! Bringen wir sie sicher hier heraus.", italian="Oh... eccoli lì! Portiamoli in salvo.", spanish="Oh, ¡aquí están! Saquémoslos de aquí."})
end
