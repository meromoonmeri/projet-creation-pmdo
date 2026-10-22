-- GÉNÉRÉ par dev/tools/red_compile_cinematics.py (V2 séquence ROM) — NE PAS ÉDITER À LA MAIN.
-- Station canonique PMD Red EU : ground d13p02 — ordre = commands des scripts EU décodés (adresses ROM).
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() UI:ResetSpeaker() end)
  GAME:WaitFrames(1) -- 0xE7
  GAME:WaitFrames(1) -- 0xE7
  GAME:WaitFrames(2) -- 0xE7
  GAME:WaitFrames(5) -- 0xE7
  GAME:WaitFrames(6) -- 0xE7
  GAME:WaitFrames(6) -- 0xE7
  GAME:WaitFrames(6) -- 0xE7
  pcall(function() SOUND:PlayBGM("Sky Tower (Rescue Team).ogg", true) end) -- 0x44 music_id 22 (ROM)
  SkySceneKit.say({english="Keep going?", french="Continuer?", german="Weitergehen?", italian="Vuoi proseguire?", spanish="¿Quieres continuar?"})
  SkySceneKit.say({english="Yes.", french="Oui", german="Ja", italian="Sì", spanish="Sí"})
  SkySceneKit.say({english="*No.", french="*Non", german="*Nein", italian="*No", spanish="*No"})
  SkySceneKit.say({english="Return to the rescue team base?", french="Retourner à la base de l'équipe de secours?", german="Zurück zur Retterteam-Basis?", italian="Vuoi tornare alla base della Squadra di Soccorso?", spanish="¿Quieres volver a la base del equipo de rescatadores?"})
  SkySceneKit.say({english="Yes.", french="Oui", german="Ja", italian="Sì", spanish="Sí"})
  SkySceneKit.say({english="*No.", french="*Non", german="*Nein", italian="*No", spanish="*No"})
  pcall(function() SOUND:PlayBGM("Sky Tower (Rescue Team).ogg", true) end) -- 0x44 music_id 22 (ROM)
  SkySceneKit.say({english="Hmm... Well, that didn't go well.", french="Hum... Eh bien, ça s'est mal passé.", german="Hmm... Na, das hat nicht geklappt.", italian="Hmm... Ci è andata storta.", spanish="Mmm... Vaya, no nos ha ido muy bien."})
  SkySceneKit.say({english="Hmm... That didn't work out...", french="Hum... Ça s'est mal passé...", german="Hmm... Das lief schief...", italian="Hmm... Poteva andarci meglio...", spanish="Mmm... No nos ha salido como queríamos..."})
  SkySceneKit.say({english="But we didn't have far to go! Let's give it our best!", french="Mais il ne manquait pas grand-chose! Faisons de notre mieux!", german="Aber wir hätten nicht mehr weit gehen müssen! Geben wir unser Bestes!", italian="Ma per un soffio non ce la facevamo! Facciamo del nostro meglio!", spanish="¡Pero nos faltaba poco! ¡Debemos esforzarnos más!"})
  SkySceneKit.say({english="But we were very close! Let's keep trying our best!", french="Mais on était tout près! Continuons à faire de notre mieux!", german="Wir waren fast am Ziel! Lass es uns noch einmal mit aller Kraft versuchen!", italian="Sarebbe bastato poco. Continuiamo a dare il massimo!", spanish="¡Pero nos quedamos cerca! ¡Vamos a seguir esforzándonos!"})
  SkySceneKit.say({english="But we were very close! Let's keep trying our best!", french="Mais nous étions tout près! Continuons à faire de notre mieux!", german="Wir waren fast am Ziel! Lass es uns noch einmal mit aller Kraft versuchen!", italian="Sarebbe bastato poco. Continuiamo a dare il massimo!", spanish="¡Qué poco nos ha faltado! ¡Vamos a seguir esforzándonos!"})
end
