-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/m12a0101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  SkyProg.set(13, 1) -- $SCENARIO_MAIN = scn[13,1] (ROM)
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(99) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 456, 224, Direction.Down, "NPC_PERAPPU")
  -- SetAnimation(2) [anim idle native]
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 192, 296, Direction.Right, "NPC_DOGOOMU")
  -- SetAnimation(2) [anim idle native]
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 232, 224, Direction.Down, "NPC_GUREGGURU")
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GAME:MoveCamera(484, 252, 1, false) end) -- SetPositionMark performer/caméra
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, hero, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's do our best, [hero]!\nJust like we always do!", french="Faisons de notre mieux,\n[hero], comme toujours!", german="Geben wir unser Bestes,\n[hero]! So wie immer!", italian=" Diamoci dentro, [hero]!", spanish="¡Esforcémonos al máximo,\n[hero]! ¡Como siempre!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's do our best, [hero]!\nJust like we always do!", french="Faisons de notre mieux,\n[hero], comme toujours!", german="Geben wir unser Bestes,\n[hero]! So wie immer!", italian="Facciamo del nostro meglio come\nsempre, [hero]!", spanish="¡Esforcémonos al máximo,\n[hero]! ¡Como siempre!"})
  else
  SkySceneKit.say({english="Let's do our best, [hero]!\nJust like we always do!", french="Faisons de notre mieux,\n[hero], comme toujours!", german="Geben wir unser Bestes,\n[hero]! So wie immer!", italian="Facciamo del nostro meglio come\nsempre, [hero]!", spanish="¡Esforcémonos al máximo,\n[hero]! ¡Como siempre!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(10) end)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end) -- message_SetActor(ACTOR_NPC_DOGOOMU)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" WHAT? What's going on?!", french=" QUOI? Qu'est-ce qui se passe?!", german=" WAS? Was ist los?!?", italian=" COSA? Cosa sta succedendo?", spanish=" ¿Cómo? ¿Qué pasa?"})
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.DownLeft)
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(5)
  GROUND:EntTurn(partner, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" ...OK. Got it![K] Hold on!", french="... D'accord, c'est pigé![K]\nUne minute!", german=" ...Okay, verstanden![K] Wartet!", italian="... Ricevuto![K] Aspetta un\nmomento!", spanish=" Vale. ¡Entendido![K] ¡Un segundo!"})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" You two! Team [team:]!", french="Vous deux! L'Equipe\n[team:]!", german=" Ihr zwei! Team [team:]!", italian=" Ehi, voi! Team [team:]!", spanish=" ¡Escuchad! ¡[CS:X]Equipo[CR] [team:]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh? What?", french=" Hein? Quoi?", german=" Wie? Was?", italian=" Uh? Cosa c'è?", spanish=" ¿Eh? ¿Qué?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Huh? Excuse me?", french=" Hein? Quoi?", german=" Was? Wie?", italian=" Sì? Cosa c'è?", spanish=" ¿Qué? ¿Cómo?"})
  else
  SkySceneKit.say({english=" Huh? Pardon me?", french=" Hein? Quoi?", german=" Ähem? Wie bitte?", italian=" Sì? Cosa c'è?", spanish=" ¿Eh? ¿Qué?"})
  end
  -- message_Close
  pcall(function() GAME:MoveCamera(216, 252, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(partner, 272, 272, false, 2)
  GAME:WaitFrames(15)
  GROUND:MoveToPosition(hero, 248, 252, false, 2)
  pcall(function() GAME:MoveCamera(216, 292, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(partner, 248, 292, false, 2)
  GROUND:MoveToPosition(hero, 224, 276, false, 2)
  GROUND:EntTurn(partner, Direction.Left)
  GROUND:EntTurn(hero, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What's up?", french=" Qu'est-ce qui se passe?", german=" Was gibt es?", italian=" Dicci tutto!", spanish=" ¿Qué pasa?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" You called?", french=" Qu'est-ce qui se passe?", german=" Du hast uns gerufen?", italian=" Ci hai chiamato?", spanish=" ¿Nos llamabas?"})
  else
  SkySceneKit.say({english=" What's up?", french=" Qu'est-ce qui se passe?", german=" Was gibt es?", italian=" Possiamo aiutarti?", spanish=" ¿Qué pasa?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="You've got yourselves some\nvisitors.", french=" Vous avez de la visite.", german=" Es ist Besuch für euch da.", italian=" C'è una visita per voi.", spanish=" Parece que tenéis visita."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Visitors?", french=" De la visite?", german=" Besuch?", italian=" Una visita?", spanish=" ¿Visita?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Visitors?", french=" De la visite?", german=" Besuch?", italian=" Una visita?", spanish=" ¿Visita?"})
  else
  SkySceneKit.say({english=" Visitors?", french=" De la visite?", german=" Besuch?", italian=" Una visita?", spanish=" ¿Visita?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="They're waiting at the guild\nentrance.[K] Go see them.", french="Ils vous attendent à l'entrée\nde la Guilde.[K] Allez les voir.", german="Sie warten am Gildeneingang.[K]\nGeht zu ihnen.", italian="Vi aspettano all'ingresso della\nGilda.[K] Andate da loro.", spanish="Os están esperando en la entrada\ndel [CS:N]Pokégremio[CR].[K] Id a ver."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I wonder who it is...", french=" Qui ça peut bien être?", german=" Ich frage mich, wer das ist...", italian=" Mah! Chi sarà mai...?", spanish=" Me pregunto quién será..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Who could it be?", french=" Qui ça peut bien être?", german=" Wer könnte das sein?", italian=" Chi potrebbe mai essere?", spanish=" ¿Quién puede ser?"})
  else
  SkySceneKit.say({english=" I wonder who it is...", french=" Qui ça peut bien être?", german=" Ich frage mich, wer das ist...", italian=" Chi potrebbe mai essere?", spanish=" Me pregunto quién será..."})
  end
  -- message_Close
  GAME:FadeOut(false, 60)
  SkySceneKit.cleanup_npcs()
end
