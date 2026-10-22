-- GÉNÉRÉ par dev/tools/red_compile_cinematics.py (V2 séquence ROM) — NE PAS ÉDITER À LA MAIN.
-- Station canonique PMD Red EU : ground d08p02 — ordre = commands des scripts EU décodés (adresses ROM).
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() SOUND:PlayBGM("Theres Trouble.ogg", true) end) -- 0x44 music_id 10 (ROM)
  SkySceneKit.say({english="Stop right there! Don't let them get away!", french="Arrêtez-vous! Ne les laissez pas s'enfuir!", german="Stehen bleiben! Lasst sie nicht entwischen!", italian="Ehi, voi due, fermatevi! Non devono fuggire!", spanish="¡No os mováis! ¡Que no escapen!"})
  SkySceneKit.say({english="Sure. Like we're really going to wait because they said so.", french="Ouais. Comme si on allait les attendre parce qu'ils nous l'ont demandé!", german="Oh, aber sicher doch! Als ob wir auf sie warten würden, nur weil sie es so wollen!", italian="Poveri illusi! Credono che ci fermeremo per ubbidire ai loro ordini?!", spanish="Qué listo. Cree que diciendo eso vamos a quedarnos aquí esperando."})
  SkySceneKit.say({english="They expect us to stop and wait for them?", french="Ils espèrent qu'on va s'arrêter pour les attendre?", german="Sie erwarten wirklich, dass wir anhalten und auf sie warten?!?", italian="Cosa vogliono? Dobbiamo fermarci per aspettarli?! È ridicolo!", spanish="¿En serio creen que porque nos lo han pedido nos vamos a parar? ¡Ja!"})
  SkySceneKit.say({english="Whew... We finally got through that cave.", french="Pfiou... On a enfin traversé cette grotte.", german="Puh... Endlich haben wir die Höhle hinter uns gelassen.", italian="Era ora! Abbiamo superato la grotta.", spanish="Guau... Por fin atravesamos esa cueva."})
  SkySceneKit.say({english="Whew! Finally, we made it through that cave.", french="Pfiou! On a traversé la grotte.", german="Puh! Endlich haben wir die Höhle hinter uns gelassen!", italian="Finalmente... abbiamo superato la grotta.", spanish="¡Bien! Por fin atravesamos esa cueva."})
  SkySceneKit.say({english="Whew! Finally, we made it through that cave.", french="Pfiou! Nous avons enfin traversé la grotte.", german="Uffz! Endlich haben wir diese dumme Höhle hinter uns gelassen!", italian="Finalmente... abbiamo superato la grotta.", spanish="¡Bien! Por fin lo logramos."})
  SkySceneKit.say({english="Where are the Pokémon who are chasing us?", french="Où sont les Pokémon qui nous pourchassent?", german="Wo sind die Pokémon, die uns verfolgen?", italian="Dove sono i Pokémon che ci stavano inseguendo?", spanish="¿Dónde están los Pokémon que nos perseguían?"})
  SkySceneKit.say({english="Where's the Pokémon mob that's after us?", french="Où est la foule de Pokémon qui est après nous?", german="Und wo sind die Pokémon, die uns die ganze Zeit verfolgt haben?", italian="Dov'è andata a finire quella cricca di Pokémon che ci inseguiva?", spanish="¿Dónde estará esa marabunta que nos perseguía?"})
  SkySceneKit.say({english="Hey, look! There they are! Over there!", french="Hé, regardez! Par là!", german="He, seht nur! Da sind sie ja! Da drüben!", italian="Guardate! Laggiù!", spanish="¡Eh, mira! ¡Ahí están! ¡Allí!"})
  SkySceneKit.say({english="Catch [hero]!", french="Attrapez [hero]!", german="Fangt [hero]!", italian="Prendete [hero]!", spanish="¡Agarrad a [hero]!"})
  SkySceneKit.say({english="Whoa! Here they come! Run!", french="Waouh! Les voilà! Sauve qui peut!", german="Aaah! Da kommen sie! Lauf!!!", italian="Ah! Stanno arrivando! Corri!", spanish="¡Ay, ay! ¡Ahí vienen! ¡A correr!"})
end
