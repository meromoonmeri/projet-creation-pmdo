-- GÉNÉRÉ par dev/tools/sky_compile_hub_npcs.py — NE PAS ÉDITER À LA MAIN.
-- NPC résidents canoniques du hub d73p31a (enter.sse ROM Sky EU: placements SSA exacts,
-- dialogues enterNN.ssb 5 langues; talk=nil = script ROM sans dialogue compilable, tracé).
local SkySceneKit = require 'halcyon.skyscenes.kit'
local function talk_npc_watakko(hero, partner)
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english="I love finding and then giving\n[CS:I]Sky Gift[CR]s.", french="J'adore trouver et offrir\ndes [CS:I]Dons du Ciel[CR].", german="Ich liebe es, [CS:I]Himmelspräsente[CR] zu\nsuchen und sie dann weiterzugeben.", italian="Adoro trovare i [CS:I]Doni Cielo[CR] e poi\ndarli a qualcuno.", spanish="Me encanta encontrar y repartir\n[CS:I]Regalos Cielo[CR]."})
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english="It makes me smile to see\nothers' happy reactions.", french="Ça m'amuse de lire la joie\nsur le visage de ceux qui les reçoivent.", german="Es macht mich glücklich, die\nfrohen Gesichter der Beschenkten zu sehen.", italian="Vedere le reazioni felici\ndegli altri mi mette di buonumore.", spanish="Ver la cara de felicidad de los\ndemás me hace sonreír."})
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english=" Hello!", french=" Bonjour!", german=" Hallo!", italian=" Salve!", spanish=" ¡Hola!"})
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english="Since I found these things called\n[CS:I]Sky Gift[CR]s on the mountain here...", french="Depuis que j'ai trouvé ces\ntrucs qu'on appelle [CS:I]Dons du Ciel[CR] ici,\nsur la montagne...", german="Ich habe hier auf dem Berg\ndiese Dinger gefunden, die [CS:I]Himmelspräsente[CR]\ngenannt werden...", italian="Da quando ho trovato questi\n[CS:I]Doni Cielo[CR] qui sulla montagna...", spanish="Desde que encontré los [CS:I]Regalos[CR]\n[CS:I]Cielo[CR] en esta montaña..."})
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english="I am finding sending a gift to\nothers so delightful! It's so much fun!", french="... je prends un réel plaisir\nà envoyer des cadeaux à tout le monde!\nC'est si amusant!", german="Seitdem verschicke ich diese\nPräsente nur zu gern! Das macht so einen\nSpaß!", italian="... mi diverto un sacco\na spedirli a tutti! È davvero spassoso!", spanish="Encuentro mucho más divertido\nenviar regalos a los demás. ¡Mola mucho!"})
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english="I found a bunch of them today\ntoo, so would you accept one from me?", french="Aujourd'hui, j'en ai encore\ntrouvé un paquet, alors je pourrais\nt'en offrir un, non?", german="Ich habe heute wieder ein paar\ngefunden. Würdest du ein Präsent von\nmir annehmen?", italian="Oggi ne ho trovati un bel po',\nquindi ti andrebbe di accettarne uno?", spanish="Hoy también he encontrado\nun montón, ¿quieres uno?"})
end
return {
  {species="jumpluff", x=176, y=320, dir=Direction.Down, name="NPC_WATAKKO", talk=talk_npc_watakko},
}
