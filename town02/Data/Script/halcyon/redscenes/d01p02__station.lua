-- GÉNÉRÉ par dev/tools/red_compile_cinematics.py (V2 séquence ROM) — NE PAS ÉDITER À LA MAIN.
-- Station canonique PMD Red EU : ground d01p02 — ordre = commands des scripts EU décodés (adresses ROM).
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() SOUND:PlayBGM("In the Depths of the Pit (Rescue Team).ogg", true) end) -- 0x44 music_id 114 (ROM)
  SkySceneKit.say({english="Waaaaah...", french="Ouiiiiiiin...", german="Waaaaah...", italian="Uuuuuè...", spanish="Buaaaaa..."})
  SkySceneKit.say({english="Mommy... Where are you...? Sniffle...", french="Maman... Où es-tu? Sniff...", german="Mami... Wo bist du...? Schnüff...", italian="Mamma... dove sei? Sigh...", spanish="Mamá... ¿Dónde estás?... Snif..."})
  SkySceneKit.say({english="We came to rescue you.", french="On est là pour te sauver.", german="Wir sind hier, um dich zu retten.", italian="Siamo qui per salvarti.", spanish="Hemos venido a rescatarte."})
  SkySceneKit.say({english="We came to rescue you.", french="Nous sommes là pour te sauver.", german="Wir sind hier, um dich zu retten.", italian="Siamo qui per salvarti.", spanish="Hola, hemos venido a rescatarte."})
  SkySceneKit.say({english="We came to rescue you.", french="Nous sommes là pour te sauver.", german="Wir sind hier, um dich zu retten.", italian="Siamo qui per salvarti.", spanish="Tranquilízate, pequeñín, hemos venido a rescatarte."})
  SkySceneKit.say({english="Huh?", french="Hein?", german="Huch?", italian="Eh?", spanish="¿Eh?"})
  SkySceneKit.say({english="Your mom's waiting. Let's get you out!", french="Ta maman t'attend. Sortons d'ici!", german="Deine Mami wartet schon auf dich. Komm, gehen wir zu ihr.", italian="La tua mamma ti aspetta. Usciamo di qui!", spanish="Tu mamá te está esperando. ¡Vamos a sacarte de aquí!"})
  SkySceneKit.say({english="OK.", french="D'accord.", german="Okay.", italian="OK!", spanish="¡Yupi!"})
end
