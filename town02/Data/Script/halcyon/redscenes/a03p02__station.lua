-- GÉNÉRÉ par dev/tools/red_compile_cinematics.py (V2 séquence ROM) — NE PAS ÉDITER À LA MAIN.
-- Station canonique PMD Red EU : ground a03p02 — ordre = commands des scripts EU décodés (adresses ROM).
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() SOUND:PlayBGM("Escape Through the Snow.ogg", true) end) -- 0x44 music_id 36 (ROM)
  SkySceneKit.say({english="Wow! The snow is like frozen powder!", french="Waouh! La neige ressemble à du coton!", german="Wow! Der Schnee sieht aus wie gefrorener Puder!", italian="Wow! La neve sembra polvere ghiacciata!", spanish="¡Mira eso! ¡La nieve es como polvo helado!"})
  SkySceneKit.say({english="It looks pretty, but... It must be harsh there...", french="C'est joli, mais... ça doit être difficile de vivre ici...", german="Das sieht sehr schön aus... Aber das Leben hier muss sehr hart sein...", italian="È bello, ma... dev'essere dura vivere qui...", spanish="Es muy hermoso, pero debe de ser duro vivir aquí..."})
end
