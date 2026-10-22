-- GÉNÉRÉ par dev/tools/sky_compile_hub_npcs.py — NE PAS ÉDITER À LA MAIN.
-- NPC résidents canoniques du hub t01p01a (enter.sse ROM Sky EU: placements SSA exacts,
-- dialogues enterNN.ssb 5 langues; talk=nil = script ROM sans dialogue compilable, tracé).
local SkySceneKit = require 'halcyon.skyscenes.kit'
local function talk_npc_yomawaru(hero, partner)
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english="Thank you so much,\n[hero] and [partner]!", french="Merci mille fois,\n[hero] et [partner]!", german="Vielen Dank, [hero] und\n[partner]!", italian="Grazie molte, [hero] e\n[partner]!", spanish="¡Muchísimas gracias,\n[hero] y [partner]!"})
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english="This gives me the peace of mind\nto run the bank properly!", french="Ainsi, je peux gérer la\nbanque l'âme en paix!", german="Das gibt mir den Seelenfrieden,\nden ich benötige, um die Bank ordentlich zu\nführen!", italian="Ora che il mondo è salvo, ho la\npace mentale necessaria per occuparmi\nadeguatamente della banca.", spanish="Me habéis tranquilizado lo\nsuficiente como para llevar este\nbanco como debe ser."})
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english=" Best of luck! Do take care!", french="Bonne chance! Prenez soin de\nvous!", german=" Viel Glück! Gebt auf euch acht!", italian=" Auguri! Fate attenzione!", spanish=" ¡Buena suerte! ¡Cuidaos!"})
end
local function talk_npc_erekiburu(hero, partner)
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english=" All right! You two are heroes!", french="Super! Vous êtes de véritables\nhéros!", german="In Ordnung! Ihr zwei seid\nHelden!", italian=" Wow, siete due Pokémon eroici!", spanish="La verdad es que siempre nos\nayudáis cuando hace falta."})
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english="It'll get peaceful in Treasure\nTown too. Thanks for that!", french="Grâce à vous, la paix va\nrevenir à Bourg-Trésor aussi! Merci!", german="Auch in Schatzstadt wird es\nfriedlich werden. Dafür danke ich euch!", italian="Tornerà la pace anche a Borgo\nTesoro. Grazie!", spanish="Por fin podremos respirar\ntranquilos en Aldea Tesoro. Os lo\nagradezco."})
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english="You throw everything you have\ninto this, you two!", french="Donnez tout ce que vous avez,\nvous deux!", german="Legt alles in diese Sache, was\nihr habt, ihr zwei!", italian=" Mettetecela tutta, voi due!", spanish=" ¡Empleaos a fondo con esto!"})
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english=" You set that [CS:N]Darkrai[CR] straight!", french="Donnez une bonne leçon à ce\n[CS:N]Darkrai[CR]!", german="Rückt diesem [CS:N]Darkrai[CR] den Kopf\nzurecht!", italian=" Fategliela vedere a quel [CS:N]Darkrai[CR]!", spanish="¡Tenéis que darle una lección\na ese [CS:N]Darkrai[CR]!"})
end
local function talk_npc_rakkii(hero, partner)
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english=" Thank you!", french=" Merci!", german=" Danke!", italian=" Grazie!", spanish=" ¡Gracias!"})
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english="The way I can be standing here,\njust as always... I owe that to you!", french="Si je suis ici, comme je le fais\ntoujours... C'est à vous que je le dois!", german="Der Umstand, dass ich hier wie\ngewohnt stehen kann... Das verdanke ich euch!", italian="Starò qui come sempre e\npotrete contare su di me...\nVe lo devo!", spanish="Poder estar aquí tan tranquila,\ncomo siempre... ¡es algo que os debo!"})
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english=" Honestly, thank you! ♪", french=" Merci de tout cœur! ♪", german=" Meinen ehrlichen Dank! ♪", italian=" Grazie di tutto cuore! ♪", spanish=" ¡Gracias de todo corazón! ♪"})
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english="The two of you can do this!\nI know it! It just takes effort!", french="Vous pouvez y arriver!\nJe le sais! Encore un petit effort!", german="Ihr zwei könnt das schaffen!\nIch weiß es! Es bedarf nur einiger\nAnstrengung!", italian="Voi due ce la potete fare!\nLo so! Dovete impegnarvi al massimo!", spanish="¡Sé que podéis hacerlo! ¡Solo\ntenéis que esforzaros!"})
end
return {
  {species="duskull", x=520, y=168, dir=Direction.Down, name="NPC_YOMAWARU", talk=talk_npc_yomawaru},
  {species="electivire", x=184, y=168, dir=Direction.Down, name="NPC_EREKIBURU", talk=talk_npc_erekiburu},
  {species="chansey", x=272, y=360, dir=Direction.Down, name="NPC_RAKKII", talk=talk_npc_rakkii},
}
