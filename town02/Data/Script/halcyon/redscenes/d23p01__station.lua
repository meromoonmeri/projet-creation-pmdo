-- GÉNÉRÉ par dev/tools/red_compile_cinematics.py (V2 séquence ROM) — NE PAS ÉDITER À LA MAIN.
-- Station canonique PMD Red EU : ground d23p01 — ordre = commands des scripts EU décodés (adresses ROM).
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() SOUND:PlayBGM("In the Depths of the Pit (Rescue Team).ogg", true) end) -- 0x44 music_id 114 (ROM)
  SkySceneKit.say({english="Look. Over there. Let's get this rescue done.", french="Regarde! Là-bas. Occupons-nous de ce sauvetage.", german="Sieh mal dort. Da drüben. Bringen wir den Auftrag hinter uns.", italian="Guarda! Portiamo a termine la missione!", spanish="Mira. Allí. Terminemos con este rescate."})
  SkySceneKit.say({english="Look, there's our Pokémon. We can get this rescue done.", french="Regarde, il y a notre Pokémon. Nous pouvons nous occuper de ce sauvetage.", german="Sieh mal, da ist das Pokémon. Wir werden es retten können.", italian="Guarda! Il nostro Pokémon! Possiamo farcela!", spanish="Mira, ahí está el Pokémon que buscábamos. Ya podemos terminar este rescate."})
end
