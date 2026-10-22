-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/S01P01A/m05a0202.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  -- worldmap_SetMode(4) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetLevel(1) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- back2_SetMode(3) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  -- worldmap_SetCamera(184) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  GAME:WaitFrames(30)
  -- worldmap_SetMark(184) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetArrow(184) [flèche carte du monde: UI moteur NDS - équivalent géré par le menu voyage PMDO]
  pcall(function() UI:SetSpeaker("Chatot", true, "chatot", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_PERAPPU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Treasure Town is here.", french=" Bourg-Trésor est ici.", german=" Hier liegt Schatzstadt.", italian=" Borgo Tesoro è qui.", spanish=" Aldea Tesoro está aquí."})
  -- message_KeyWait
  -- worldmap_DeleteArrow [flèche carte moteur NDS]
  pcall(function() UI:SetSpeaker("Chatot", true, "chatot", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_PERAPPU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="And...over here is where we\nwould like you to investigate.", french="Et... j'aimerais que vous\nexploriez cet endroit-là.", german="Und dort drüben ist der Ort, den\nihr erkunden sollt.", italian="E... questo è il luogo che\nvorremmo farvi perlustrare.", spanish="Y... aquí es donde me gustaría que\nfuerais a investigar."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- worldmap_MoveCamera(7) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  -- worldmap_SetArrow(7) [flèche carte du monde: UI moteur NDS - équivalent géré par le menu voyage PMDO]
  pcall(function() UI:SetSpeaker("Chatot", true, "chatot", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_PERAPPU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="See? There is a waterfall\nflowing here. ♪", french="Vous voyez? Il y a une cascade\nà cet endroit. ♪", german="Seht ihr? An dieser Stelle ist\nein Wasserfall. ♪", italian=" Vedete? Qui c'è una cascata. ♪", spanish=" ¿Veis? Hay una cascada. ♪"})
  pcall(function() UI:SetSpeaker("Chatot", true, "chatot", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_PERAPPU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="By all appearances, it's just an\nordinary waterfall.", french="A première vue, c'est une\ncascade des plus ordinaires.", german="Allem Anschein nach ist es nur\nein gewöhnlicher Wasserfall.", italian="Al primo sguardo, sembra una\nnormale cascata.", spanish="Cualquiera diría que se trata de una\ncascada común y corriente."})
  pcall(function() UI:SetSpeaker("Chatot", true, "chatot", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_PERAPPU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="But we've received intelligence\nthat the waterfall may conceal a secret.", french="Mais nous avons reçu des\ninformations selon lesquelles cette\ncascade cacherait un secret.", german="Aber unseren Informationen\nzufolge soll der Wasserfall ein Geheimnis\nbergen.", italian="Ma abbiamo informazioni secondo\nle quali la cascata potrebbe nascondere un\nsegreto.", spanish="Pero nos han informado de que puede\nocultar un secreto. Algo que no se percibe a\nsimple vista."})
  pcall(function() UI:SetSpeaker("Chatot", true, "chatot", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_PERAPPU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="And that's where you come in.\nWe want you lot to investigate the waterfall\nand determine what's there.", french="Et c'est là que vous entrez en\njeu. Nous voulons que vous exploriez cette\ncascade afin de découvrir son secret.", german="Und da kommt ihr ins Spiel.\nWir wollen, dass ihr den Wasserfall erkundet\nund herausfindet, was dort ist.", italian="Ed è qui che entrate in gioco\nvoi. Vogliamo che indaghiate presso la cascata\nper stabilire se le voci sono vere.", spanish="Y ahí entráis en juego. Queremos que\nvayáis a investigar la cascada para averiguar\nqué esconde."})
  -- message_Close
  -- GAP: se_Play(6667) — id SE NDS sans portage PMDO identifié
  -- screen2_FadeOut [sub déjà caché]
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
end
