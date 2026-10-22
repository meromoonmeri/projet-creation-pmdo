-- GÉNÉRÉ par dev/tools/red_compile_cinematics.py (V2 séquence ROM) — NE PAS ÉDITER À LA MAIN.
-- Station canonique PMD Red EU : ground d02p01 — ordre = commands des scripts EU décodés (adresses ROM).
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() SOUND:PlayBGM("Thunderwave Cave.ogg", true) end) -- 0x44 music_id 14 (ROM)
  SkySceneKit.say({english="OH, YOU ARE HERE. BZBZBZZ!", french="OH, VOUS ETES LA. BZBZBZZ!", german="OH, IHR SEID HIER. BZBZBZZ!", italian="OH, SIETE QUI. BZBZBZZ!", spanish="OH, YA ESTÁIS AQUÍ. ¡BZBZBZZ!"})
  SkySceneKit.say({english="MY FRIENDS ARE IN THIS CAVERN. BZBZBZZ.", french="MES AMIS SONT DANS CETTE GROTTE. BZBZBZZ.", german="MEINE FREUNDE SIND IN DIESER HÖHLE. BZBZBZZ.", italian="I MIEI AMICI SONO IN QUESTA GROTTA. BZBZBZZ.", spanish="MIS AMIGOS ESTÁN EN ESA GRUTA. BZBZBZZ."})
  SkySceneKit.say({english="MY FRIENDS SHOULD BE ON BF. PLEASE HELP THEM! BZBZBZZZT!", french="MES AMIS DEVRAIENT ETRE A L'ETAGE -. S'IL VOUS PLAIT, AIDEZ-LES! BZBZBZZZT!", german="MEINE FREUNDE SOLLTEN IN EBENE U SEIN. BITTE HELFT IHNEN! BZBZBZZZT!", italian="DOVREBBERO TROVARSI AL P. -. HANNO BISOGNO DI AIUTO! BZBZBZZZT!", spanish="MIS AMIGOS DEBEN DE ESTAR EN EL NIVEL -. ¡AYUDADLES, POR FAVOR! ¡BZBZBZZZT!"})
  pcall(function() SOUND:PlayBGM("Thunderwave Cave.ogg", true) end) -- 0x44 music_id 14 (ROM)
  SkySceneKit.say({english="The are in there somewhere.", french="Les sont quelque part là-dedans.", german="Die sind irgendwo dort drin.", italian="I devono trovarsi lì dentro da qualche parte.", spanish="Los están por aquí en algún lado."})
  SkySceneKit.say({english="Let's give it our best and rescue them [hero]!", french="Faisons de notre mieux et secourons-les, [hero]!", german="Geben wir unser Bestes und retten sie, [hero]!", italian="[hero], facciamo del nostro meglio per salvarli!", spanish="¡Vamos a rescatarlos! ¡Adelante, [hero]!"})
  SkySceneKit.say({english="Let's do our best to rescue them, [hero]!", french="Faisons de notre mieux pour les secourir, [hero]!", german="Lass sie uns retten, [hero]!", italian="[hero], dobbiamo fare il possibile per salvarli!", spanish="¡Vamos a darlo todo para rescatarlos, [hero]!"})
  pcall(function() SOUND:PlayBGM("A Successful Rescue.ogg", true) end) -- 0x44 music_id 103 (ROM)
  SkySceneKit.say({english="OUR BODIES SEPARATED. BZBZBZZ. REJOICE! BZBZBZZT!", french="NOS CORPS SONT SEPARES. BZBZBZZ. JOIE! BZBZBZZT!", german="UNSERE KÖRPER GETRENNT. BZBZBZZ. FREUDE! BZBZBZZT!", italian="I NOSTRI CORPI SI SONO SEPARATI. BZBZBZZ... GIOIA! BZBZBZZT!", spanish="NUESTROS CUERPOS SE HAN SEPARADO. BZBZBZZ. ¡VIVA! ¡BZBZBZZT!"})
  SkySceneKit.say({english="YAY! BZBZBZZT!", french="OUAIS! BZBZBZZT!", german="HURRA! BZBZBZZT!", italian="URRÀ! BZBZBZZT!", spanish="¡HURRA! ¡BZBZBZZT!"})
  SkySceneKit.say({english="YAY! BZBZBZZT!", french="OUAIS! BZBZBZZT!", german="HURRA! BZBZBZZT!", italian="URRÀ! BZBZBZZT!", spanish="¡HURRA! ¡BZBZBZZT!"})
  SkySceneKit.say({english="BE THANKFUL, YOU TWO.", french="SOYEZ RECONNAISSANTS, VOUS DEUX.", german="WIR DANKEN EUCH BEIDEN.", italian="VOI DUE, RINGRAZIATE.", spanish="DEBÉIS DARLES LAS GRACIAS."})
  SkySceneKit.say({english="YOU ARE OUR HERO. THANK YOU. BZBZBZZ!", french="VOUS NOUS AVEZ SAUVES. MERCI. BZBZBZZ!", german="IHR SEID HELDEN. DANKE. BZBZBZZ!", italian="SIETE GRANDI. GRAZIE. BZBZBZZ!", spanish="¡SOIS GENIALES! ¡MUCHAS GRACIAS! ¡BZBZBZZ!"})
end
