-- GÉNÉRÉ par dev/tools/red_compile_cinematics.py (V2 séquence ROM) — NE PAS ÉDITER À LA MAIN.
-- Station canonique PMD Red EU : ground d12p01 — ordre = commands des scripts EU décodés (adresses ROM).
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
  pcall(function() SOUND:PlayBGM("Magma Cavern (Rescue Team).ogg", true) end) -- 0x44 music_id 108 (ROM)
  SkySceneKit.say({english="So this is it... The underground cavern where is...", french="Alors, nous y voilà... La grotte souterraine où se trouve ...", german="Wir sind da... Dies ist die unterirdische Höhle, in der lebt...", italian="Eccoci qui... La caverna sotterranea dove dimora ...", spanish="Así que es esto... La caverna subterránea donde se encuentra ..."})
  SkySceneKit.say({english="Look at the flowing streams of lava...", french="Regarde ces abondantes coulées de lave...", german="Sieh dir den Lavastrom an...", italian="Guarda i fiumi di lava che scorrono...", spanish="Mira esos ríos de lava..."})
  SkySceneKit.say({english="It wouldn't surprise me if the dungeon is scorching hot...", french="Ça ne me surprendrait pas si ce donjon était d'une chaleur torride...", german="Es würde mich nicht wundern, wenn es in dem Dungeon siedend heiß ist...", italian="Non mi sorprenderebbe affatto se il dungeon fosse rovente...", spanish="No me sorprendería que en este sitio hiciese un calor insufrible..."})
  SkySceneKit.say({english="This must be it... is in this underground cavern.", french="Ça doit être ici... est dans cette grotte souterraine.", german="Hier muss es sein... muss sich in dieser unterirdischen Höhle befinden.", italian="Ci siamo... si trova in questa caverna sotterranea.", spanish="Esto debe de ser... se encuentra en esta caverna subterránea."})
  SkySceneKit.say({english="Whew... Look at the streams of lava.", french="Waouh... Regarde ces coulées de lave.", german="Puh... Sieh dir nur den Lavastrom an...", italian="Wow... Guarda i fiumi di lava.", spanish="Vaya... Mira esos ríos de lava."})
  SkySceneKit.say({english="It's going to be scorching hot in the dungeon, I think.", french="L'intérieur de ce donjon doit être caniculaire.", german="Ich vermute, in dem Dungeon wird es brütend heiß sein.", italian="Nel dungeon farà un caldo da morire.", spanish="Me temo que va a hacer un calor sofocante en la cueva."})
  SkySceneKit.say({english="Other rescue teams should already be inside.", french="D'autres équipes devraient déjà se trouver à l'intérieur.", german="Es müssten sich bereits andere Retterteams im Dungeon befinden.", italian="All'interno dovrebbero già trovarsi altre squadre.", spanish="Ya debería haber otros equipos de rescate dentro."})
  SkySceneKit.say({english="Let's get in there and give it our best!", french="Entrons et faisons de notre mieux!", german="Gehen wir hinein und geben wie immer unser Bestes!", italian="Entriamo e facciamo del nostro meglio!", spanish="¡Vamos adentro a darlo todo!"})
  SkySceneKit.say({english="Other rescue teams should already be here.", french="D'autres équipes de secours doivent déjà se trouver dedans.", german="Es sollten schon andere Retterteams hier sein.", italian="Altre squadre dovrebbero già essere entrate.", spanish="Ya debería haber allí otros equipos de rescate."})
  SkySceneKit.say({english="Let's get going and try our best!", french="Continuons et faisons notre maximum!", german="Legen wir los und geben wir unser Bestes!", italian="Avventuriamoci e diamoci da fare!", spanish="¡Vamos a ponernos manos a la obra y a darlo todo!"})
  SkySceneKit.say({english="There should be other rescue teams making their way through even now.", french="Il devrait y avoir d'autres équipes le traversant en ce moment même.", german="In diesem Moment sollten sich bereits andere Retterteams im Dungeon befinden.", italian="Dovrebbero esserci altre squadre all'interno.", spanish="Puede que ya haya otros equipos de rescate de camino."})
  SkySceneKit.say({english="Let's try our best like always!", french="Faisons de gros efforts, comme toujours!", german="Gehen wir hinein und geben wie immer unser Bestes!", italian="Facciamo del nostro meglio, come sempre!", spanish="¡Vamos a darlo todo, como siempre!"})
  pcall(function() SOUND:PlayBGM("Magma Cavern (Rescue Team).ogg", true) end) -- 0x44 music_id 108 (ROM)
  SkySceneKit.say({english="This time, we'll rescue 's team! Let's get it done!", french="Cette fois, on va secourir l'équipe d'! Allons-y!", german="Dieses Mal werden wir s Team auf jeden Fall retten! Auf geht's!", italian="Questa volta libereremo la squadra di ! Entriamo in azione!", spanish="¡Esta vez rescataremos al equipo de ! ¡Adelante!"})
  SkySceneKit.say({english="This time, we have to rescue 's team! Let's not blow it!", french="Cette fois, on doit aider l'équipe d'! Ne ratons pas notre coup!", german="Dieses Mal müssen wir s Team unbedingt retten! Wir dürfen es nicht vermasseln!", italian="Questa volta libereremo la squadra di ! Non facciamo passi falsi!", spanish="¡Esta vez, tenemos que rescatar al equipo de ! ¡No podemos fallar!"})
end
