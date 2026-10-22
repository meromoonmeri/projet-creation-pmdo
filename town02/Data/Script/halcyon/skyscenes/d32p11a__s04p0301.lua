-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D32P11A/s04p0301.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SkyProg.set(29, 58) -- $SCENARIO_MAIN = scn[29,58] (ROM)
  -- back_SetGround(LEVEL_D32P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GROUND:MoveToPosition(hero, 228, 308, false, 2)
  GAME:WaitFrames(15)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 252, 324, false, 2) end end
  GAME:WaitFrames(5)
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 204, 324, false, 2) end end
  GAME:WaitFrames(5)
  do local __slot = SkySceneKit.team_member(3); if __slot then GROUND:MoveToPosition(__slot, 228, 332, false, 2) end end
  GAME:WaitFrames(15)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  local npc_npc_mimiroppu = SkySceneKit.spawn_npc("lopunny", 232, 280, Direction.Up, "NPC_MIMIROPPU")
  pcall(function() GROUND:CharSetEmote(npc_npc_mimiroppu, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  local npc_npc_chaaremu = SkySceneKit.spawn_npc("medicham", 208, 272, Direction.UpRight, "NPC_CHAAREMU")
  GROUND:EntTurn(npc_npc_chaaremu, Direction.DownRight)
  local npc_npc_saanaito = SkySceneKit.spawn_npc("gardevoir", 256, 272, Direction.UpLeft, "NPC_SAANAITO")
  GROUND:EntTurn(npc_npc_saanaito, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_mimiroppu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english="Oh, Team [team:].[K]\nYou've ended up back here like us.", french="Oh, Equipe [team:].[K]\nVous en êtes au même point que nous.", german="Oh, Team [team:].[K]\nIhr seid auch hier hinten gelandet, wie wir.", italian="Oh, Team [team:].[K]\nAnche voi qui!", spanish="Vaya, [CS:X]Equipo[CR] [team:].[K]\nHabéis acabado aquí, igual que nosotras."})
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english="You have to solve a mystery to\nmove ahead, it seems. This is vexing.", french="Apparemment, il faut résoudre\nune énigme pour avancer. Que c'est\ncontrariant.", german="Man muss ein Rätsel lösen, um\nweiterzukommen, wie es scheint. Das ist\närgerlich.", italian="Sembra che per proseguire sia\nnecessario risolvere un mistero. È irritante.", spanish="Hay que resolver un misterio\npara poder avanzar. Qué fastidio."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_saanaito, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="I would assume this stone\nmarker holds the key.", french="Je suppose que cette stèle\nest la clé.", german="Ich nehme mal an, dieser\nSteinwegweiser enthält den Schlüssel\nzur Lösung.", italian="Questa Stele deve essere\nla chiave.", spanish="Pienso que en esta losa\nestá la clave."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_chaaremu, Direction.UpRight)
  GROUND:EntTurn(npc_npc_mimiroppu, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="The surface of the stone marker\nis scored by deep grooves shaped like [CS:K]Unown[CR].", french="La surface de la stèle est\ncreusée de profonds sillons en forme\nde [CS:K]Zarbi[CR].", german="In die Oberfläche dieses\nSteinwegweisers sind tiefe Rillen eingeritzt,\ndie die Form eines [CS:K]Icognito[CR] haben.", italian="La superficie della Stele è\npiena di profondi solchi a forma di [CS:K]Unown[CR].", spanish="La superficie está llena de\ninscripciones con forma de [CS:K]Unown[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="The cave is filled by hordes of\n[CS:K]Unown[CR]...", french="La grotte grouille de hordes de\n[CS:K]Zarbi[CR]...", german="Die Höhle ist voll mit Horden\nvon [CS:K]Icognito[CR]...", italian="La caverna è strapiena\ndi [CS:K]Unown[CR]...", spanish="Y esta cueva está plagada\nde [CS:K]Unown[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="There most certainly is a\nconnection between those facts.", french="Il y a très certainement un\nrapport entre ces deux éléments.", german="Ich bin mir fast sicher, dass es\neinen Zusammenhang zwischen diesen Tatsachen\ngibt.", italian="Ci deve sicuramente essere un\nlegame tra le due cose.", spanish="Seguro que hay algún tipo\nde conexión entre ambas cosas."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english="\"If you seek passage, close your\neyes, then submit your proof.\" Well, that's not\nmuch to go on.", french="\"Si vous cherchez un passage,\nfermez les yeux et présentez vos preuves.\"\nC'est un peu mince.", german="[F:S2]Ersuchst du Durchlass,\nschließe deine Augen und reiche deine\nBerechtigung ein.[F:E2] Hilft uns nicht sehr weiter.", italian="\"Se desiderate passare, chiudete\ngli occhi e mostrate la prova.\" Beh, non è un\ngranché come indizio.", spanish="\"Si buscas un pasadizo, cierra\nlos ojos y sométete a la prueba.\" Bueno,\nmuchas pistas no da, la verdad."})
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english="Well, I closed my eyes, but that\ndid nothing. We must be overlooking something.", french="J'ai fermé les yeux, mais il ne\ns'est rien passé. Nous devons sûrement oublier\nun détail.", german="Nun, ich habe meine Augen\ngeschlossen, aber es ist nichts passiert. Wir\nmüssen etwas übersehen haben.", italian="Beh, io ho chiuso gli occhi, ma\nnon è successo niente. Ci dev'essere qualcosa\nche ci sfugge.", spanish="He cerrado los ojos pero no\nha servido de nada. Debemos haber pasado\npor alto algún detalle."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_mimiroppu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_chaaremu, Direction.DownRight)
  GROUND:EntTurn(npc_npc_saanaito, Direction.DownLeft)
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english="We'll go into the cave and\nsearch again.", french="Nous retournons dans la grotte\npour poursuivre les recherches.", german="Wir gehen noch mal in die Höhle\nund suchen weiter.", italian="Torniamo nella caverna\ne cerchiamo di nuovo.", spanish="Entremos en la cueva y sigamos\nbuscando."})
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english=" See you again.", french=" Au plaisir.", german=" Man sieht sich.", italian=" Ci vediamo.", spanish=" Hasta luego."})
  -- message_Close
  GROUND:MoveToPosition(npc_npc_chaaremu, 188, 228, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(npc_npc_saanaito, 268, 228, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(npc_npc_mimiroppu, 268, 228, false, 2)
  GROUND:MoveToPosition(npc_npc_chaaremu, 228, 180, false, 2)
  GROUND:MoveToPosition(npc_npc_saanaito, 228, 180, false, 2)
  GROUND:MoveToPosition(npc_npc_mimiroppu, 228, 180, false, 2)
  GROUND:MoveToPosition(npc_npc_chaaremu, 228, 124, false, 2)
  GROUND:MoveToPosition(npc_npc_saanaito, 228, 124, false, 2)
  GROUND:MoveToPosition(npc_npc_mimiroppu, 228, 124, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 268, 308, false, 2) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 184, 308, false, 2) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then GROUND:MoveToPosition(__slot, 208, 324, false, 2) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then GROUND:EntTurn(__slot, Direction.Up) end end
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:EntTurn(__slot, Direction.UpLeft) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:EntTurn(__slot, Direction.UpRight) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.cleanup_npcs()
end
