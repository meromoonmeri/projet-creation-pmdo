-- GÉNÉRÉ par dev/tools/red_compile_cinematics.py (V2 séquence ROM) — NE PAS ÉDITER À LA MAIN.
-- Station canonique PMD Red EU : ground d17p01 — ordre = commands des scripts EU décodés (adresses ROM).
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() SOUND:PlayBGM("In the Depths of the Pit (Rescue Team).ogg", true) end) -- 0x44 music_id 114 (ROM)
  SkySceneKit.say({english="Gwooooooooooh! ...H-how dare you!", french="Gooooooooooh! C... comment oses-tu!", german="Gwooooooooooh! ...W-welch eine Dreistigkeit!", italian="Gwooooooooooh! ... Come osi?!", spanish="¡Arrrg! ¡¿C-cómo te atreves?!"})
  SkySceneKit.say({english="How... How did this happen...?", french="Comment... comment est-ce arrivé?", german="Wie... Wie ist das möglich...?", italian="Com... Com'è potuto succedere?", spanish="Pero... ¿Cómo ha podido suceder esto...?"})
  SkySceneKit.say({english="But regardless, you have won. Let me hear your wish.", french="Mais j'admets ma défaite. Dis-moi ton souhait.", german="Nun denn. Ich habe verloren. Wie lautet der Wunsch?", italian="Ad ogni modo hai vinto tu. Sentiamo il tuo sogno.", spanish="No obstante, me has vencido. Dime qué deseas."})
  SkySceneKit.say({english="...Hm?! This... This is the IRed Wing...", french="Hum... C'est... la IPlume Vermillon...", german="...Hm?!? Das... Das ist die IRotfeder...", italian="... Hm?! Questa... Questa è la IPiuma Rossa...", spanish="¡¿Eh?! Es... Es la IPluma Roja..."})
  SkySceneKit.say({english="............ You... Stand back!", french="... ... ... ... Bien... Recule!", german="............ Aah... Zurück!", italian="... ... ... ... Tu... stai alla larga!", spanish="... Tú... ¡Apártate!"})
  SkySceneKit.say({english="Raikou's thunderbolt electrified the IRed Wing!", french="La foudre de Raikou électrifie la IPlume Vermillon!", german="Raikous Donnerblitz setzt die IRotfeder unter Strom!", italian="Il fulmine di Raikou trasmette energia alla IPiuma Rossa!", spanish="¡El rayo de Raikou ha electrificado la IPluma Roja!"})
  SkySceneKit.say({english="The IRed Wing... transformed into the ISunset Wing!", french="La IPlume Vermillon... se transforme en IPlume Crépuscule!", german="Die IRotfeder... wird zur IAbendgoldfeder!", italian="La IPiuma Rossa... si trasforma nella IPiuma Tramonto!", spanish="¡La IPluma Roja... se ha transformado en la IPluma Dorada!"})
  pcall(function() SOUND:PlayBGM("In the Depths of the Pit (Rescue Team).ogg", true) end) -- 0x44 music_id 114 (ROM)
  SkySceneKit.say({english="Its subtle gradation of yellow to red is a truly beauteous sight!", french="Son subtil dégradé du jaune au rouge est vraiment de toute beauté!", german="Das sanft durchschimmernde Farbenspiel von Rot und Gold ist wunderschön!", italian="La sua gradazione di giallo che tende al rosso è veramente deliziosa!", spanish="¡Sus bellos reflejos recuerdan a los rayos de sol del atardecer!"})
  SkySceneKit.say({english="Go northeast!", french="Pars vers le nord-est!", german="Der Weg führt in nordöstliche Richtung!", italian="Dirigiti verso nord-est!", spanish="¡Dirígete al noreste!"})
  SkySceneKit.say({english="To a place called the DNorthwind Field.", french="Tu atteindras un endroit appelé les DTerres Blizzard.", german="Zu einem Ort, der DNordwindfeld genannt wird.", italian="Vai in un posto chiamato DCampo Tramontana.", spanish="Ve a un lugar conocido como el DCampo Ventoso."})
  SkySceneKit.say({english="You will find a Pokémon there named Suicune.", french="Là-bas vit un Pokémon du nom de Suicune.", german="Dort lebt ein Pokémon namens Suicune.", italian="Lì troverai un Pokémon chiamato Suicune.", spanish="Allí encontrarás a un Pokémon llamado Suicune."})
  SkySceneKit.say({english="If you are lucky enough to meet Suicune...", french="Si tu as la chance de le rencontrer...", german="Mit etwas Glück zeigt sich Suicune...", italian="Se hai abbastanza fortuna da incontrare Suicune...", spanish="Si tienes la fortuna de encontrar a Suicune..."})
  SkySceneKit.say({english="Perhaps your wish will come true!", french="... peut-être que ton vu se réalisera!", german="Und vielleicht gehen dann Wünsche in Erfüllung!", italian="Forse il tuo sogno si avvererà!", spanish="¡quizá tu deseo se haga realidad!"})
  SkySceneKit.say({english="[hero] received the ISunset Wing.", french="[hero] reçoit la IPlume Crépuscule.", german="[hero] erhält die IAbendgoldfeder.", italian="[hero] riceve la IPiuma Tramonto...", spanish="[hero] ha recibido la IPluma Dorada."})
  SkySceneKit.say({english="And...", french="Et...", german="Und...", italian="In più...", spanish="¡Y además..."})
  SkySceneKit.say({english="Gained access to the DNorthwind Field!", french="... les DTerres Blizzard sont maintenant accessibles!", german="Das DNordwindfeld steht offen!", italian="Il DCampo Tramontana è ora accessibile!", spanish="tiene acceso al DCampo Ventoso!"})
  GAME:WaitFrames(1) -- 0xE7
end
