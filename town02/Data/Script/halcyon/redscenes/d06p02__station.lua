-- GÉNÉRÉ par dev/tools/red_compile_cinematics.py (V2 séquence ROM) — NE PAS ÉDITER À LA MAIN.
-- Station canonique PMD Red EU : ground d06p02 — ordre = commands des scripts EU décodés (adresses ROM).
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
  pcall(function() SOUND:PlayBGM("Mt Thunder.ogg", true) end) -- 0x44 music_id 111 (ROM)
  SkySceneKit.say({english="Would you like to go on?", french="Voulez-vous continuer?", german="Möchtest du weitergehen?", italian="Vuoi proseguire?", spanish="¿Quieres continuar?"})
  SkySceneKit.say({english="Yes.", french="Oui", german="Ja", italian="Sì", spanish="Sí"})
  SkySceneKit.say({english="*No.", french="*Non", german="*Nein", italian="*No", spanish="*No"})
  SkySceneKit.say({english="Return to the rescue team base?", french="Retourner à la base de l'équipe de secours?", german="Zurück zur Retterteam-Basis?", italian="Vuoi tornare alla base della Squadra di Soccorso?", spanish="¿Quieres volver a la base del equipo de rescate?"})
  SkySceneKit.say({english="Yes.", french="Oui", german="Ja", italian="Sì", spanish="Sí"})
  SkySceneKit.say({english="*No.", french="*Non", german="*Nein", italian="*No", spanish="*No"})
  pcall(function() SOUND:PlayBGM("Mt Thunder.ogg", true) end) -- 0x44 music_id 111 (ROM)
  SkySceneKit.say({english="Hmm... Things didn't go right for us...", french="Hum... Les choses ne se sont pas bien passées pour nous...", german="Hmm... Es läuft nicht gut für uns...", italian="Hmm... Ci è andata male...", spanish="Mmm... Las cosas no nos han salido bien..."})
  SkySceneKit.say({english="Hmm... Things didn't turn out in our favor...", french="Hum... Les choses n'ont pas tourné en notre faveur...", german="Hmm... Es lief nicht so, wie wir gehofft hatten...", italian="Hmm... Le cose non sono andate come dovevano...", spanish="Mmm... No han salido las cosas como queríamos..."})
  SkySceneKit.say({english="But we should be getting close. Let's keep going hard at it!", french="Mais on peut y arriver. Continuons nos efforts!", german="Aber wir kommen der Sache immer näher. Wir müssen uns weiter anstrengen!", italian="Ma dovremmo quasi esserci. Continuiamo ad impegnarci a fondo!", spanish="Pero ya nos queda menos. ¡Vamos a darlo todo!"})
  SkySceneKit.say({english="But we shouldn't be far. Let's keep doing our best!", french="Mais nous y étions presque. Continuons à faire notre maximum!", german="Es kann nicht mehr weit sein. Lass uns unser Bestes geben!", italian="Ma dovrebbe mancare poco. Continuiamo a fare del nostro meglio!", spanish="No debemos de estar muy lejos. ¡Vamos a esforzarnos!"})
  SkySceneKit.say({english="But we shouldn't be far. Let's keep doing our best!", french="Mais nous y étions presque. Continuons à faire de notre mieux!", german="Es kann nicht mehr weit sein. Geben wir unser Bestes!", italian="Ma dovrebbe mancare poco. Continuiamo a fare del nostro meglio!", spanish="Ya no nos queda mucho. ¡Vamos allá!"})
end
