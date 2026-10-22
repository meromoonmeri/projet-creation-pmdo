-- GÉNÉRÉ par dev/tools/red_compile_cinematics.py (V2 séquence ROM) — NE PAS ÉDITER À LA MAIN.
-- Station canonique PMD Red EU : ground a02p03 — ordre = commands des scripts EU décodés (adresses ROM).
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Gasp... Gasp...", french="Oh... Oh...", german="Keuch... Schnauf...", italian="Gasp... gasp...", spanish="Uf..."})
  SkySceneKit.say({english="Oh, no! Look!", french="Oh, non! Là!", german="Oh, nein! Da!", italian="Oh, no! Guarda!", spanish="¡Eh! ¡Mira!"})
  pcall(function() SOUND:PlayBGM("The Mountain of Fire.ogg", true) end) -- 0x44 music_id 38 (ROM)
  SkySceneKit.say({english="Look at them go! They're running for Mt. Blaze!", french="Là-bas! C'est la route du Mt Ardent!", german="Seht! Da laufen sie! Sie wollen zum Feuerberg!", italian="Guardate! Vanno in direzione del Monte Vampa!", spanish="¡Allí van! ¡Van hacia el Monte Ígneo!"})
  SkySceneKit.say({english="Are they insane? Mt. Blaze is doomed desolation!", french="Mais c'est de la folie! Le Mt Ardent n'est que ruine et dévastation!", german="Sind die verrückt?!? Der Feuerberg ist die Hölle!", italian="Che follia! Il Monte Vampa è invalicabile!", spanish="¡Qué locura! ¡Ese monte es un infierno de lava!"})
  SkySceneKit.say({english="No one's ever come this far before!", french="Personne n'est jamais allé aussi loin auparavant!", german="So weit ist noch nie jemand vorgedrungen!", italian="Nessuno ce l'ha mai fatta!", spanish="¡Nadie había llegado tan lejos hasta ahora!"})
  SkySceneKit.say({english="I don't wanna go anywhere like that.", french="Je ne veux pas aller dans un endroit pareil.", german="Da will ich nicht hin!", italian="Non voglio andare in un posto del genere!", spanish="Yo no quiero ir allí."})
  SkySceneKit.say({english="It can't be helped. Only those brave enough will give chase!", french="On ne peut pas faire autrement. Seuls les plus courageux leur donneront la chasse!", german="Es hilft alles nichts. Nur die Mutigen setzen die Jagd fort!", italian="Non c'è niente da fare. Ci vuole fegato per continuare con l'inseguimento.", spanish="No nos queda más remedio. Solo los mejores podrán darles caza."})
  SkySceneKit.say({english="It... It's a mountain of fire!", french="C'est... c'est une montagne de feu!", german="Der... Der Berg steht in Flammen!", italian="È... una montagna di fuoco!", spanish="¡Es una montaña de fuego!"})
  SkySceneKit.say({english="Look at all that lava pouring from the crater...", french="Regarde toute la lave qui sort de ce cratère...", german="Sieh mal! All die Lava, die aus dem Krater fließt...", italian="Guarda la lava che fuoriesce dal cratere...", spanish="Mira toda esa lava que rebosa del cráter..."})
  SkySceneKit.say({english="Can we even make it through there?", french="Est-ce qu'on va s'en sortir?", german="Ob wir hier überhaupt weiterkommen?", italian="Non credo che ce la faremo...", spanish="¿Seremos capaces de pasar por ahí?"})
  SkySceneKit.say({english="But they're catching up to us...", french="Ils nous rattrapent...", german="Sie werden uns bald eingeholt haben...", italian="Però ormai ci stanno alle costole...", spanish="Pero nos están dando alcance..."})
  SkySceneKit.say({english="What'll we do, [hero]?", french="Que va-t-on faire, [hero]?", german="Was sollen wir tun, [hero]?", italian="Che cosa facciamo, [hero]?", spanish="¿Qué hacemos, [hero]?"})
  SkySceneKit.say({english="Look! There they are!", french="Regardez! Les voilà!", german="Seht mal! Da sind sie!", italian="Guardate! Sono là!", spanish="¡Mirad! ¡Ahí están!"})
  SkySceneKit.say({english="Get them!", french="Attrapez-les!", german="Schnappt sie euch!", italian="All'attacco!", spanish="¡Que no escapen!"})
  SkySceneKit.say({english="There's no choice now!", french="On n'a pas le choix!", german="Uns bleibt nichts anderes übrig!", italian="Non abbiamo altra scelta!", spanish="¡No tenemos alternativa!"})
  SkySceneKit.say({english="Let's go, [hero]!", french="Allons-y, [hero]!", german="Komm, gehen wir, [hero]!", italian="Andiamo, [hero]!", spanish="¡Vamos, [hero]!"})
end
