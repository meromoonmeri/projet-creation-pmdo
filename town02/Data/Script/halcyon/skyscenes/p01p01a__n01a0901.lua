-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P01P01A/n01a0901.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  SV.SkyScenarioSide = {main=40, sub=3} -- $SCENARIO_SIDE = scn[40,3] (ROM)
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
  -- message_FacePositionOffset(-7, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english=" Looks like we're ready.", french=" Tout est prêt, on dirait.", german=" Wir sind dann wohl so weit.", italian=" A quanto pare siamo pronti.", spanish=" Parece que ya estamos listos."})
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english="All right, let's go explore\n[CS:P]Star Cave[CR].", french="Très bien, en route, allons\nexplorer la [CS:P]Caverne Etoile[CR].", german="Gut, lass uns zusammen die\n[CS:P]Sternenhöhle[CR] erkunden.", italian="Forza, andiamo a esplorare\nla [CS:P]Caverna Stellata[CR].", spanish="Bueno, pues vamos a explorar la\n[CS:P]Cueva Estrella[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english=" I'm a bit nervous...", french=" Je suis un peu nerveux...", german=" Ich bin ein bisschen aufgeregt...", italian=" Sono un po' agitato...", spanish=" Estoy un poquillo nervioso..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(3) [anim idle native]
  do local p=npc_npc_yukikaburi.Position; GROUND:MoveToPosition(npc_npc_yukikaburi, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_yukikaburi.Position; GROUND:MoveToPosition(npc_npc_yukikaburi, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_yukikaburi.Position; GROUND:MoveToPosition(npc_npc_yukikaburi, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_yukikaburi.Position; GROUND:MoveToPosition(npc_npc_yukikaburi, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="It's all right, yup yup![K] We don't\nhave anything to worry about when\nwe're together!", french="Te fais pas d'bile, pardi![K]\nTant qu'on reste ensemble,\non a rien à craindre!", german="Schon okay, jawollja![K] Wir\nmüssen uns keine Gedanken machen, solange\nwir zusammen sind!", italian="Va tutto bene, già, già![K] Non\nabbiamo niente di cui aver paura finché\nsiamo insieme!", spanish="¡No pasa nada![K] No hay de qué\npreocuparse mientras estemos juntos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-7, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english=" Y-yeah!", french=" Heu... ouais!", german=" J-jawoll!", italian=" S-Sì!", spanish=" Ti... tienes razón."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(29) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Let's do our best! Yup yup!", french="Faisons d'notre mieux!\nOuaip ouaip!", german=" Wir schaffen das! Jawollja!", italian="Facciamo del nostro meglio!\nGià, già!", spanish=" ¡A por todas! ¡Sí, señor!"})
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
