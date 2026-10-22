-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P01P01A/n01a1401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  GAME:FadeOut(false, 30)
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GROUND:EntTurn(hero, Direction.Right)
  GROUND:TeleportTo(hero, 404, 192, Direction.Down)
  GAME:WaitFrames(30)
  GAME:FadeIn(30)
  local npc_npc_yukikaburi = SkySceneKit.spawn_npc("snover", 216, 304, Direction.Up, "NPC_YUKIKABURI")
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end) -- message_SetActor(ACTOR_NPC_YUKIKABURI)
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english=" [CS:Y]Bidoof[CR]!", french=" [CS:Y]Keunotor[CR]!", german=" [CS:Y]Bidiza[CR]!", italian=" [CS:Y]Bidoof[CR]!", spanish=" ¡[CS:Y]Bidoof[CR]!"})
  -- message_Close
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GROUND:MoveToPosition(npc_npc_yukikaburi, 220, 264, false, 2)
  GROUND:EntTurn(hero, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(npc_npc_yukikaburi, 220, 216, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Left)
  GROUND:MoveToPosition(npc_npc_yukikaburi, 220, 192, false, 2)
  GROUND:MoveToPosition(npc_npc_yukikaburi, 372, 192, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(5)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Today we'll definitely make it\nthrough [CS:P]Star Cave[CR], yup yup.", french="Aujourd'hui, on va réussir à\nexplorer la [CS:P]Caverne Etoile[CR], pardi!", german="Heute werden wir es auf jeden\nFall durch die [CS:P]Sternenhöhle[CR] schaffen, jawollja.", italian="Oggi riusciremo sicuramente\na esplorare la [CS:P]Caverna Stellata[CR] fino in\nfondo, già, già.", spanish="Hoy vamos a conseguir\natravesar la [CS:P]Cueva Estrella[CR], sí, señor."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" We'll do our best! Yup yup!", french="On va faire d'not' mieux!\nOuaip ouaip!", german=" Wir schaffen das! Jawollja!", italian="Facciamo del nostro meglio!\nGià, già!", spanish=" ¡A por todas! ¡Sí, señor!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-7, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english=" Yeah!", french=" Ouais!", german=" Juchhu!", italian=" Sì!", spanish=" ¡Eso!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(64), p.Y+(0), false, 2) end
  GAME:WaitFrames(5)
  do local p=npc_npc_yukikaburi.Position; GROUND:MoveToPosition(npc_npc_yukikaburi, p.X+(74), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- switch(main_EnterAdventure(250, 30)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
end
