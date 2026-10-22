-- GÉNÉRÉ par dev/tools/red_compile_cinematics.py (V2 séquence ROM) — NE PAS ÉDITER À LA MAIN.
-- Station canonique PMD Red EU : ground d03p01 — ordre = commands des scripts EU décodés (adresses ROM).
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() SOUND:PlayBGM("Mt Steel.ogg", true) end) -- 0x44 music_id 120 (ROM)
  SkySceneKit.say({english="So, this is it... DMt. Steel...", french="Alors, c'est là... Le DMt Acier...", german="So, das ist also... Der DStahlberg...", italian="Questo è il DMonte Acciaio...", spanish="Así que este es el... DMonte Acero..."})
  SkySceneKit.say({english="'s been taken to the peak here...", french="a été emporté vers ce pic...", german="wurde zum Gipfel gebracht...", italian="è stato portato sulla vetta...", spanish="Han llevado a a la cima..."})
  SkySceneKit.say({english="Here we are... DMt. Steel...", french="Nous y voilà... Le DMt Acier...", german="Wir sind da... Am DStahlberg...", italian="Eccoci... questo è il DMonte Acciaio...", spanish="Aquí estamos... El DMonte Acero..."})
  SkySceneKit.say({english="So, was whisked to its peak...", french="Alors, a été emmené vers son pic...", german="wurde also zum Gipfel verschleppt...", italian="si trova sulla vetta...", spanish="Así que está en la cima de este monte..."})
  SkySceneKit.say({english="That's right!", french="Exact!", german="Stimmt!", italian="OK!", spanish="¡Eso es!"})
  SkySceneKit.say({english="The peak is F! Thank you for helping! Farewell!", french="Le pic est à l'étage ! Merci de votre aide! Au revoir!", german="Der Gipfel ist auf E! Danke für eure Hilfe! Auf Wiedersehen!", italian="La vetta è al P. ! Grazie dell'aiuto! Buona fortuna!", spanish="¡La cima está en el nivel ! ¡Gracias por su ayuda! ¡Adiós!"})
  SkySceneKit.say({english="...... Well, I guess we go...", french="... ... Eh bien, je crois qu'on va y aller...", german="...... Nun, ich denke, wir sollten dann mal gehen...", italian="... ... Bene, andiamo...", spanish="... Bueno, supongo que tenemos que ir..."})
  SkySceneKit.say({english="...... Uh... Let's go.", french="... ... Euh... Allons-y.", german="...... Äh... Gehen wir.", italian="... ... Uh... andiamo.", spanish="... Mmm... Vamos allá."})
  pcall(function() SOUND:PlayBGM("Mt Steel.ogg", true) end) -- 0x44 music_id 120 (ROM)
  SkySceneKit.say({english="We'll take another shot at DMt. Steel.", french="On va retenter de gravir le DMt Acier.", german="Wir versuchen es noch einmal am DStahlberg.", italian="Facciamo un altro tentativo sul DMonte Acciaio.", spanish="Intentemos coronar de nuevo el DMonte Acero."})
  SkySceneKit.say({english="We'll rescue no matter what it takes!", french="On doit absolument secourir !", german="Wir werden um jeden Preis retten!", italian="Salveremo ! Costi quel che costi!", spanish="¡Rescataremos a cueste lo que cueste!"})
  SkySceneKit.say({english="We have to make another attempt at DMt. Steel.", french="On va réessayer de gravir le DMt Acier.", german="Wir müssen es noch einmal am DStahlberg versuchen.", italian="Dobbiamo fare un altro tentativo sul DMonte Acciaio.", spanish="Debemos intentar de nuevo coronar el DMonte Acero."})
  SkySceneKit.say({english="Whatever it takes, let's rescue !", french="Peu importe ce que ça coûte, allons secourir !", german="Wir müssen unter allen Umständen retten!", italian="Dobbiamo liberare a tutti i costi!", spanish="¡Cueste lo que cueste, rescataremos a !"})
  SkySceneKit.say({english="That's the spirit!", french="Bel état d'esprit!", german="Richtig so!", italian="Questo è lo spirito giusto!", spanish="¡Así se habla!"})
  SkySceneKit.say({english="The peak is F! Thank you for helping! Farewell!", french="Le pic est à l'étage ! Merci pour ton aide! Au revoir!", german="Der Gipfel ist auf E! Danke für eure Hilfe! Auf Wiedersehen!", italian="La vetta è al P. ! Grazie dell'aiuto! Addio!", spanish="¡La cima está en el nivel ! ¡Gracias por su ayuda! ¡Adiós!"})
  SkySceneKit.say({english="...... Well, here we go...", french="... ... Eh bien, en route...", german="...... Nun, dann lass uns gehen...", italian="... ... Bene, andiamo...", spanish="... Bueno, allá vamos..."})
  SkySceneKit.say({english="...... Uh... Let's go.", french="... ... Euh... Allons-y.", german="...... Äh... Gehen wir.", italian="... ... Uh... andiamo.", spanish="... Mmm... Vamos allá."})
end
