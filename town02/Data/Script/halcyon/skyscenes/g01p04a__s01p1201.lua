-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/s01p1201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 456, 224, Direction.Down, "NPC_PERAPPU")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Ah, you two.", french=" Ah, vous deux.", german=" Ah, ihr zwei.", italian=" Ah, voi due.", spanish=" Ah, aquí estáis."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_perappu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="You two should focus on your\ngraduation exam.", french="Vous devez vous concentrer sur\nl'examen.", german="Ihr beiden solltet euch auf eure\nAbschlussprüfung konzentrieren.", italian="Dovreste concentrarvi sul\nvostro esame.", spanish="Deberíais centraros en superar\nel reto."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="This is what you must do. Go to\nthe deepest part of [CS:P]Mystifying Forest[CR].", french="Voici ce que vous devez faire.\nAllez dans les profondeurs de la\n[CS:P]Forêt Trompeuse[CR].", german="Hier ist eure Aufgabe. Geht in\ndie tiefsten Tiefen des [CS:P]Verwirrwaldes[CR].", italian="Dovete andare qui, nel cuore\ndella [CS:P]Foresta Inganno[CR].", spanish="Como sabéis, debéis adentraros\nen el [CS:P]Bosque Misterio[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="There you will find a place\ncalled [CS:P]Luminous Spring[CR].", french="Là-bas, vous trouverez\nun endroit appelé la [CS:P]Source Lumineuse[CR].", german="Dort findet ihr einen Ort namens\n[CS:P]Glitzerquelle[CR].", italian="Lì troverete un luogo chiamato\n[CS:P]Sorgente Luccichio[CR].", spanish="Allí encontraréis un lugar\nllamado [CS:P]Manantial Luminoso[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Bring back the treasure of\n[CS:P]Luminous Spring[CR] and you will graduate! ♪", french="Rapportez le trésor de la\n[CS:P]Source Lumineuse[CR] pour réussir l'examen! ♪", german="Bringt den Schatz der\n[CS:P]Glitzerquelle[CR] zurück, und ihr habt\nbestanden! ♪", italian="Riportate qui il tesoro della\n[CS:P]Sorgente Luccichio[CR] e l'esame sarà superato! ♪", spanish="¡Regresad con el tesoro del\n[CS:P]Manantial Luminoso[CR] y habréis superado\nel reto! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" I wish you the best of luck! ♪", french="Je vous souhaite bonne\nchance! ♪", german=" Ich wünsche euch viel Glück! ♪", italian=" Buona fortuna! ♪", spanish=" ¡Mucha suerte! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's ace this graduation exam,\n[hero]!", french="Il faut réussir cet examen,\n[hero]!", german="Lass uns die Abschlussprüfung\nmit Bravour bestehen, [hero]!", italian="Facciamo di tutto per superare\nl'esame, [hero]!", spanish="¡A por el gran reto,\n[hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's get through this graduation\nexam, [hero]!", french="Il faut réussir cet examen,\n[hero]!", german="Lass uns die Abschlussprüfung\nerfolgreich durchziehen, [hero]!", italian="Facciamo di tutto per superare\nl'esame, [hero]!", spanish="¡Hay que superar el gran reto,\n[hero]!"})
  else
  SkySceneKit.say({english="Let's do our best on the\ngraduation exam, [hero]!", french="Il faut réussir cet examen,\n[hero]!", german="Geben wir unser Bestes für\ndie Abschlussprüfung, [hero]!", italian="Facciamo di tutto per superare\nl'esame, [hero]!", spanish="¡A por el gran reto,\n[hero]!"})
  end
  -- message_Close
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.cleanup_npcs()
end
