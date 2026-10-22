-- GÉNÉRÉ par dev/tools/red_compile_cinematics.py (V2 séquence ROM) — NE PAS ÉDITER À LA MAIN.
-- Station canonique PMD Red EU : ground d12p02 — ordre = commands des scripts EU décodés (adresses ROM).
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
  pcall(function() SOUND:PlayBGM("Magma Cavern (Rescue Team).ogg", true) end) -- 0x44 music_id 108 (ROM)
  SkySceneKit.say({english="Keep going?", french="Continuer?", german="Weitergehen?", italian="Vuoi proseguire?", spanish="¿Quieres continuar?"})
  SkySceneKit.say({english="Yes.", french="Oui", german="Ja", italian="Sì", spanish="Sí"})
  SkySceneKit.say({english="*No.", french="*Non", german="*Nein", italian="*No", spanish="*No"})
  SkySceneKit.say({english="Return to the rescue team base?", french="Retourner à la base de l'équipe de secours?", german="Zurück zur Retterteam-Basis?", italian="Vuoi tornare alla base della Squadra di Soccorso?", spanish="¿Quieres volver a la base del equipo de rescate?"})
  SkySceneKit.say({english="Yes.", french="Oui", german="Ja", italian="Sì", spanish="Sí"})
  SkySceneKit.say({english="*No.", french="*Non", german="*Nein", italian="*No", spanish="*No"})
  pcall(function() SOUND:PlayBGM("Magma Cavern (Rescue Team).ogg", true) end) -- 0x44 music_id 108 (ROM)
  SkySceneKit.say({english="Hmm... Well, that didn't go well.", french="Hum... Eh bien, ça s'est mal passé.", german="Hmm... Das war ein Schuss in den Ofen.", italian="Hmm... Ci andata storta.", spanish="Mmm... Bueno, no nos ha ido muy bien."})
  SkySceneKit.say({english="Hmm... That didn't work out...", french="Hum... Ça n'a pas marché...", german="Hmm... Es hat nicht geklappt...", italian="Hmm... Poteva andarci meglio...", spanish="Mmm... Hemos fallado..."})
  SkySceneKit.say({english="But we didn't have far to go! Let's give it our best!", french="Mais on était pas loin du but! Faisons de notre mieux!", german="Wir waren schon kurz vor dem Ziel! Strengen wir uns noch mehr an!", italian="Ma per un soffio non ce la facevamo! Facciamo del nostro meglio!", spanish="¡Pero nos hemos quedado cerca! ¡Vamos a por todas!"})
  SkySceneKit.say({english="But we were very close! Let's keep trying our best!", french="Mais on était tout près! Donnons notre maximum!", german="Wir waren schon ganz dicht dran! Versuchen wir es noch einmal!", italian="Sarebbe bastato poco. Continuiamo a dare il massimo!", spanish="¡Pero no nos faltaba mucho! ¡Vamos a por todas!"})
end
