-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04C/m24a0107.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_G01P04C) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 424, 280, Direction.Right, "NPC_HEIGANI")
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Hey, hey! So what was that\npromise?", french="Eh dis donc, c'était quoi,\nce pacte?", german="Hey, hey! Was für ein\nVersprechen denn?", italian="Ehi, ehi! Di che patto\nsi trattava?", spanish=" ¡Oye, oye! ¿Qué promesa?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 504, 280, Direction.UpLeft, "NPC_PUKURIN")
  GROUND:EntTurn(npc_npc_pukurin, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="I think [CS:N]Lapras[CR] recognized that\nwe were an exploration team right away.", french="Je pense que [CS:N]Lokhlass[CR] a tout\nde suite compris qu'on était une équipe\nd'exploration.", german="Ich glaube, [CS:N]Lapras[CR] erkannte\nsofort, dass wir ein Erkundungsteam waren.", italian="Penso che [CS:N]Lapras[CR] abbia capito\nsubito che eravamo una squadra d'esplorazione.", spanish="Creo que [CS:N]Lapras[CR] supo de\ninmediato que éramos un equipo explorador."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" So he said to us...", french=" Alors il nous a dit...", german="Daher verfolgte er die folgende\nStrategie...", italian=" Quindi ci ha fatto un discorso.", spanish=" Así que nos dijo que..."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="that he couldn't tell if we were\nbandits with big ambitions...", french="... qu'il ne pouvait pas savoir\nsi nous étions des bandits assoiffés\nde pouvoir...", german="Er sagte, dass er nicht wüsste,\nob wir Banditen mit großem Ehrgeiz seien...", italian="Ha detto che non poteva sapere\nse fossimo banditi con grandi ambizioni...", spanish="No sabía si éramos unos\nsaqueadores ambiciosos..."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="or if we were an exploration\nteam with good intentions...", french="... ou bien une équipe\nd'exploration aux intentions honorables...", german="Oder aber ein Erkundungsteam\nmit guten Absichten...", italian="... o una squadra\nd'esplorazione con buone intenzioni.", spanish="O un equipo explorador con\nbuenas intenciones."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="so he asked, for the sake of the\nworld's peace...", french="Donc, au nom de la paix dans\nle monde, il nous a demandé...", german="Deshalb bat er uns um des\nWeltfriedens Willen...", italian="Quindi ci ha chiesto, per la pace\nnel mondo...", spanish="Así que nos pidió, por el bien\nde la paz del mundo, que..."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="that we please not investigate\nthe peculiar pattern there. [K]That's what he\nasked of us.", french="... de ne pas chercher à en\nsavoir plus à propos de ce symbole dans la\ngrotte.[K] Voilà ce qu'il nous a demandé.", german="Er bat uns, bitte nicht dieses\nseltsame Muster dort zu untersuchen.[K] Darum\nbat er uns.", italian="... di non indagare su quel\ndisegno particolare.[K] È così che sono\nandate le cose.", spanish="No investigásemos el extraño\nsímbolo o dibujo que había en la pared.[K]\nEso fue lo que nos pidió."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 472, 280, Direction.Right, "NPC_CHIRIIN")
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="So...[K]what was your reply,\nGuildmaster?", french="Et...[K] qu'est-ce que vous avez\nrépondu?", german="Und?[K] Was hast du ihm\ngeantwortet, Gildenmeister?", italian="E così...[K] qual è stata la tua\nrisposta, Capitano?", spanish="Y...[K]\n¿Qué respondiste a eso, Gran Bluff?"})
  -- message_Close
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
end
