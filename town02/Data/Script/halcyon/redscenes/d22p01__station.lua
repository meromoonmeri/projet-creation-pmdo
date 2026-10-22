-- GÉNÉRÉ par dev/tools/red_compile_cinematics.py (V2 séquence ROM) — NE PAS ÉDITER À LA MAIN.
-- Station canonique PMD Red EU : ground d22p01 — ordre = commands des scripts EU décodés (adresses ROM).
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="............", french="... ... ... ...", german="............", italian="... ... ... ...", spanish="..."})
  SkySceneKit.say({english="...Y-you are...?", french="Tu... tu es?", german="...D-du bist...?", italian="... Tu-Tu sei...", spanish="¿Quién eres...?"})
  SkySceneKit.say({english="...Did you maybe... come to save me?", french="Peut-être es-tu ici... pour me sauver?", german="...Bist du vielleicht... gekommen, um mich zu retten?", italian="... Sei forse qui... per salvarmi?", spanish="¿Has venido... a salvarme?"})
  SkySceneKit.say({english="............ Yes, I'll be fine.", french="... ... ... ... Oui, tout ira bien.", german="............ Ja, es wird schon wieder.", italian="... ... ... ... Sì, è tutto a posto.", spanish="... No te preocupes. Podré aguantar."})
  SkySceneKit.say({english="My wing is still damaged a little, but... I can go.", french="Mon aile est encore un peu abîmée, mais... je peux m'en aller.", german="Mein Flügel ist noch verletzt, aber... ich kann gehen.", italian="La mia ala non è ancora del tutto guarita, ma... posso volare.", spanish="Mi ala sigue estando un poco dolorida, pero... podré seguirte."})
end
