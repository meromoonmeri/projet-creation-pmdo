-- GÉNÉRÉ par dev/tools/red_compile_cinematics.py (V2 séquence ROM) — NE PAS ÉDITER À LA MAIN.
-- Station canonique PMD Red EU : ground d04p02 — ordre = commands des scripts EU décodés (adresses ROM).
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() SOUND:PlayBGM("In the Depths of the Pit (Rescue Team).ogg", true) end) -- 0x44 music_id 114 (ROM)
  SkySceneKit.say({english="Owowowow... You'll pay for this! Don't you forget it!", french="Ouille, ouille, ouille... Vous me paierez ça! N'oubliez pas!", german="Auauauauau... Das werdet ihr bereuen! Darauf könnt ihr euch verlassen!", italian="Ohhhhh... La pagherete! Promesso!", spanish="Vaya, vaya, vaya... ¡Pagaréis por esto! ¡Que no se os olvide!"})
  SkySceneKit.say({english="Well, those pests are gone. Let's find .", french="Eh bien, ces fléaux sont partis. Allons trouver .", german="Die Nervensägen sind weg. Jetzt müssen wir nur noch finden.", italian="Quelle pesti se ne sono andate. Troviamo .", spanish="Bueno, nos deshicimos de esos matones. Busquemos a ."})
  SkySceneKit.say({english="No one should hold us back now. Let's find .", french="Plus personne ne devrait nous gêner maintenant. Allons retrouver .", german="Niemand wird uns jetzt noch aufhalten. Suchen wir .", italian="Ora nessuno può fermarci. Troviamo .", spanish="Ya nada nos retiene. Busquemos a ."})
  SkySceneKit.say({english="No one should hold us back now. Let's find .", french="Plus personne ne devrait nous gêner maintenant. Allons retrouver .", german="Niemand wird uns jetzt noch aufhalten. Suchen wir .", italian="Ora nessuno può fermarci. Troviamo .", spanish="Parece que ya podemos seguir buscando a ."})
  SkySceneKit.say({english="Um, excuse me...", french="Hum, excusez-moi...", german="Äh, Entschuldigung...", italian="Uhm, scusatemi...", spanish="Eh... Perdonad..."})
  SkySceneKit.say({english="Did you maybe come looking for me?", french="Etes-vous à ma recherche?", german="Sucht ihr vielleicht nach mir?", italian="Siete qui per cercare me?", spanish="¿Habéis venido a salvarme?"})
  SkySceneKit.say({english="You must be .", french="Tu dois être .", german="Du bist bestimmt .", italian="Devi essere .", spanish="Tú debes de ser ."})
  SkySceneKit.say({english="Let's get you home. Caterpie was worried about you.", french="Nous allons te ramener à la maison. Chenipan s'inquiétait pour toi.", german="Komm, wir bringen dich nach Hause. Raupy ist schon ganz krank vor Sorge.", italian="Siamo qui per riportarti a casa. Caterpie è preoccupato.", spanish="Vamos a casa. Caterpie está preocupado por ti."})
  SkySceneKit.say({english="Yay!", french="Ouais!", german="Hurra!", italian="Ah!", spanish="¡Bravo!"})
  SkySceneKit.say({english="I was scared, so I kept my shell hardened...and waited and waited.", french="J'avais peur, alors j'ai fait une armure de ma coquille... Puis j'ai attendu, attendu...", german="Ich hatte Angst, also habe ich meinen Panzer gehärtet... und gewartet und gewartet.", italian="Avevo così tanta paura che ho indurito la mia corazza e sono stato qui ad aspettare.", spanish="Tenía miedo, así que endurecí mi coraza y esperé."})
  SkySceneKit.say({english="Thank you!", french="Merci!", german="Danke!", italian="Grazie!", spanish="¡Gracias!"})
end
