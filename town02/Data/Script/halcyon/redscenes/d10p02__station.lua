-- GÉNÉRÉ par dev/tools/red_compile_cinematics.py (V2 séquence ROM) — NE PAS ÉDITER À LA MAIN.
-- Station canonique PMD Red EU : ground d10p02 — ordre = commands des scripts EU décodés (adresses ROM).
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() UI:ResetSpeaker() end)
  GAME:WaitFrames(2) -- 0xE7
  GAME:WaitFrames(2) -- 0xE7
  GAME:WaitFrames(2) -- 0xE7
  GAME:WaitFrames(3) -- 0xE7
  GAME:WaitFrames(6) -- 0xE7
  GAME:WaitFrames(7) -- 0xE7
  GAME:WaitFrames(7) -- 0xE7
  GAME:WaitFrames(7) -- 0xE7
  pcall(function() SOUND:PlayBGM("Frosty Forest.ogg", true) end) -- 0x44 music_id 104 (ROM)
  SkySceneKit.say({english="Keep going?", french="Continuer?", german="Weitergehen?", italian="Vuoi proseguire?", spanish="¿Quieres continuar?"})
  SkySceneKit.say({english="Yes.", french="Oui", german="Ja", italian="Sì", spanish="Sí"})
  SkySceneKit.say({english="*No.", french="*Non", german="*Nein", italian="*No", spanish="*No"})
  SkySceneKit.say({english="Return to the rescue team base?", french="Retourner à la base de l'équipe de secours?", german="Zurück zur Retterteam-Basis?", italian="Vuoi ritornare alla base della Squadra di Soccorso?", spanish="¿Quieres volver a la base del equipo de rescate?"})
  SkySceneKit.say({english="Yes.", french="Oui", german="Ja", italian="Sì", spanish="Sí"})
  SkySceneKit.say({english="*No.", french="*Non", german="*Nein", italian="*No", spanish="*No"})
  SkySceneKit.say({english="Return to the entrance?", french="Retourner à l'entrée?", german="Zurück zum Eingang?", italian="Vuoi ritornare all'ingresso?", spanish="¿Quieres volver a la entrada?"})
  SkySceneKit.say({english="Yes.", french="Oui", german="Ja", italian="Sì", spanish="Sí"})
  SkySceneKit.say({english="*No.", french="*Non", german="*Nein", italian="*No", spanish="*No"})
  pcall(function() SOUND:PlayBGM("Frosty Forest.ogg", true) end) -- 0x44 music_id 104 (ROM)
  SkySceneKit.say({english="Hmm... Well, that didn't go well.", french="Hum... Eh bien, ça ne s'est pas bien passé.", german="Hmm... Das lief schief.", italian="Uhm... Ci è andata storta.", spanish="Mmm... Bueno, no nos ha salido bien."})
  SkySceneKit.say({english="Hmm... That didn't work out...", french="Hum... Ça n'a pas marché...", german="Hmm... Das hat nicht funktioniert...", italian="Ehm... Qualcosa non ha funzionato...", spanish="Mmm... No nos ha salido bien..."})
  SkySceneKit.say({english="This is a tough place...", french="C'est un endroit difficile...", german="Dies ist ein unwirtlicher Ort...", italian="È un luogo molto ostile...", spanish="Es difícil pasar..."})
  SkySceneKit.say({english="This is as tough as we expected...", french="C'est encore plus difficile que l'on ne s'y attendait...", german="Es ist genauso schwer, wie wir es erwartet haben...", italian="Proprio come pensavamo, questo posto è molto ostile...", spanish="Es tan complicado como nos temíamos..."})
  SkySceneKit.say({english="But let's give it our best and get through this, [hero]!", french="Mais faisons un effort et traversons, [hero]!", german="Geben wir unser Bestes und bringen es hinter uns, [hero]!", italian="Cerchiamo di farcela dando il meglio di noi, [hero]!", spanish="¡Pero vamos a esforzarnos para pasar, [hero]!"})
  SkySceneKit.say({english="But let's keep trying our best and get through this, [hero]!", french="Mais continuons de notre mieux et traversons, [hero]!", german="Geben wir unser Bestes und bringen es hinter uns, [hero]!", italian="Non desistiamo e cerchiamo di fare del nostro meglio, [hero]!", spanish="¡Pero vamos a seguir intentándolo hasta pasar, [hero]!"})
  pcall(function() SOUND:PlayBGM("Frosty Forest.ogg", true) end) -- 0x44 music_id 104 (ROM)
  SkySceneKit.say({english="Hmmm... Well, that didn't go well.", french="Hum... Eh bien, ça s'est mal déroulé.", german="Hmmm... Wir haben es nicht geschafft.", italian="Uhm... Non abbiamo fatto bella figura.", spanish="Mmmm... Bueno, no se puede decir que nos fuera muy bien."})
  SkySceneKit.say({english="Hmm... We didn't do well at all...", french="Hum... On n'a pas du tout réussi...", german="Hmm... Das haben wir nicht gerade gut hinbekommen...", italian="Uhm... Potevamo impegnarci di più...", spanish="Mmm... No lo hemos hecho nada bien..."})
  SkySceneKit.say({english="That ... He's one tough customer.", french="Cet ... C'est un dur à cuire.", german="Dieser ... Der ist ein harter Brocken.", italian="Quell' è proprio un tipo tosto...", spanish="Ese es duro de pelar..."})
  SkySceneKit.say({english="But why aren't we allowed to go into this forest?", french="Mais pourquoi n'a-t-on pas la permission de traverser cette forêt?", german="Aber warum dürfen wir nicht in diesen Wald hinein?", italian="Ma perché non possiamo entrare in questa foresta?", spanish="¿Pero por qué no nos dejan ir a ese bosque?"})
  SkySceneKit.say({english="It doesn't matter anyway. Let's give it our best, [hero]!", french="Enfin, ce n'est pas grave. Faisons de notre mieux, [hero]!", german="...Es spielt wohl keine Rolle. Geben wir unser Bestes, [hero]!", italian="... Poco importa. Facciamo del nostro meglio, [hero]!", spanish="Bueno, no importa. ¡Vamos a por todas, [hero]!"})
  SkySceneKit.say({english="That Pokémon, , is pretty tough.", french="Ce Pokémon, , est plutôt difficile.", german="Dieser ist wirklich sehr stark.", italian="Quel Pokémon, , è un tipo tosto.", spanish="Ese Pokémon, , es duro de pelar."})
  SkySceneKit.say({english="But why are we forbidden from entering this forest?", french="Mais pourquoi ne peut-on pas entrer dans cette forêt?", german="Aber warum hat man uns verboten, diesen Wald zu betreten?", italian="Perché non ci è permesso entrare in questa foresta?", spanish="¿Pero por qué no nos dejan entrar en ese bosque?"})
  SkySceneKit.say({english="It makes no difference. [hero], let's try our best!", french="Ça n'a pas d'importance. [hero], faisons de notre mieux!", german="Aber das ändert gar nichts. [hero], strengen wir uns besonders an!", italian="Beh... che differenza fa? [hero], diamoci da fare!", spanish="No importa. ¡[hero], vamos a darlo todo!"})
end
