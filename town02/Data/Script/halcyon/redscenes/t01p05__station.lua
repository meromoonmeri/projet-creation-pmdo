-- GÉNÉRÉ par dev/tools/red_compile_cinematics.py (V2 séquence ROM) — NE PAS ÉDITER À LA MAIN.
-- Station canonique PMD Red EU : ground t01p05 — ordre = commands des scripts EU décodés (adresses ROM).
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() UI:ResetSpeaker() end)
  GAME:WaitFrames(1) -- 0xE7
  GAME:WaitFrames(1) -- 0xE7
  GAME:WaitFrames(6) -- 0xE7
  GAME:WaitFrames(6) -- 0xE7
  pcall(function() SOUND:PlayBGM("Pokemon Square.ogg", true) end) -- 0x44 music_id 7 (ROM)
  GAME:WaitFrames(1) -- 0xE7
  SkySceneKit.say({english="There appears to be no one inside.", french="Il n'y a personne à l'intérieur.", german="Es ist niemand da.", italian="Sembra non esserci nessuno.", spanish="Parece que no hay nadie."})
  SkySceneKit.say({english="............! There is a notice posted in the back.", french="... ... ... ... ... ... ... ... ... ... ... ... Il y a un mot accroché sur la porte.", german="............! Da ist eine Notiz angebracht.", italian="... ... ... ...! C'è un cartello.", spanish="¡Anda!... Hay una nota colgada aquí."})
  SkySceneKit.say({english="Under Construction - Keep Out - Makuhita Dojo -", french="En construction - Ne pas entrer - Dojo Makuhita -", german="Im Umbau - Zutritt verboten - Makuhita-Dojo -", italian="Lavori in corso - Non avvicinarsi - Dojo Makuhita -", spanish="Estamos en obras. No pasar. - Dojo Makuhita -"})
  pcall(function() SOUND:PlayBGM("Pokemon Square.ogg", true) end) -- 0x44 music_id 7 (ROM)
  GAME:WaitFrames(5) -- 0xE7
  pcall(function() SOUND:PlayBGM("Pokemon Square.ogg", true) end) -- 0x44 music_id 7 (ROM)
  pcall(function() SOUND:PlayBGM("Pokemon Square.ogg", true) end) -- 0x44 music_id 7 (ROM)
  pcall(function() SOUND:PlayBGM("Pokemon Square.ogg", true) end) -- 0x44 music_id 7 (ROM)
end
