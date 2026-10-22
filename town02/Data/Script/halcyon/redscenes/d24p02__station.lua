-- GÉNÉRÉ par dev/tools/red_compile_cinematics.py (V2 séquence ROM) — NE PAS ÉDITER À LA MAIN.
-- Station canonique PMD Red EU : ground d24p02 — ordre = commands des scripts EU décodés (adresses ROM).
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() SOUND:PlayBGM("Stormy Sea.ogg", true) end) -- 0x44 music_id 21 (ROM)
  SkySceneKit.say({english="You're going to the DMurky Cave?", french="Tu vas à la DGrotte Ténèbres?", german="Gehst du zur DDüsterhöhle?", italian="Ti stai recando alla DGrotta Tenebrosa?", spanish="¿Vas a la DVieja Cueva?"})
  SkySceneKit.say({english="Don't forget to take me, kekeh!", french="N'oublie pas de m'emmener, ec, ec!", german="Vergiss nicht, mich mitzunehmen, kekeh!", italian="Non dimenticare di portare anche me, kekeh!", spanish="¡No olvides llevarme contigo, ueje, je!"})
end
