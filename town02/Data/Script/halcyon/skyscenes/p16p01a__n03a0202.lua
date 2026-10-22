-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P16P01A/n03a0202.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Heartwarming.ogg", true) end)
  -- back_SetGround(LEVEL_P16P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GROUND:MoveToPosition(hero, 212, 156, false, 2)
  pcall(function() GAME:MoveCamera(224, 164, 60, false) end) -- performer/caméra
  GAME:WaitFrames(20)
  local npc_npc_jupetta = SkySceneKit.spawn_npc("banette", 392, 144, Direction.Left, "NPC_JUPETTA")
  GROUND:MoveToPosition(npc_npc_jupetta, 284, 144, false, 2)
  GAME:WaitFrames(4)
  local npc_npc_sukorupi = SkySceneKit.spawn_npc("skorupi", 408, 168, Direction.Left, "NPC_SUKORUPI")
  GROUND:MoveToPosition(npc_npc_sukorupi, 300, 168, false, 2)
  pcall(function() GROUND:CharSetEmote(npc_npc_jupetta, "shock", 1) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_sukorupi, "shock", 1) end)
  GROUND:MoveToPosition(npc_npc_jupetta, 260, 144, false, 2)
  GROUND:MoveToPosition(npc_npc_sukorupi, 276, 168, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(npc_npc_jupetta, 240, 144, false, 1)
  GROUND:MoveToPosition(npc_npc_sukorupi, 256, 168, false, 1)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_jupetta, Direction.DownLeft)
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english=" Hey! [CS:Y]Igglybuff[CR]!", french=" Hé! [CS:Y]Toudoudou[CR]!", german=" Hey! [CS:Y]Fluffeluff[CR]!", italian=" Ehi! [CS:Y]Igglybuff[CR]!", spanish=" ¡Oye, [CS:Y]Igglybuff[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english=" W-were you OK after that?!", french=" T-tu t'en es bien tiré?!", german=" I-ist noch alles gut gelaufen?!?", italian="H-Hai avuto problemi dopo...\nquella cosa?!", spanish="¡¿Fue todo bien después\nde lo que pasó?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yep. ♪", french=" Voui. ♪", german=" Ja. ♪", italian=" No no. ♪", spanish=" Sí. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  GROUND:EntTurn(npc_npc_jupetta, Direction.DownRight)
  GAME:WaitFrames(6)
  GROUND:EntTurn(npc_npc_sukorupi, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_jupetta, "sweating", 1) end)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharSetEmote(npc_npc_sukorupi, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_sukorupi) end)
  SkySceneKit.say({english=" I can't believe you got away!", french="J'arrive pas à croire que tu aies\nréussi à t'échapper!", german="Ich kann kaum glauben, dass du\nentkommen bist!", italian="Non riesco a credere che tu sia\nriuscito a salvarti!", spanish=" ¡Es increíble que lograras huir!"})
  pcall(function() UI:SetSpeaker(npc_npc_sukorupi) end)
  SkySceneKit.say({english="I thought maybe you got eaten by\nthat monster...", french="Je pensais que tu t'étais fait\ngober tout cru par ce monstre...", german="Ich dachte schon, du wurdest\nvon dem Monster verspeist...", italian="Pensavo che quel mostro\nti avesse divorato...", spanish="Pensaba que igual el monstruo\nte habría devorado..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(hero, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="???[K] What monster?[K] I don't know\nwhat you're talking about.", french="???[K] Bah, quel monstre?[K]\nJe vois pas de quoi tu parles.", german="...[K]Welches Monster?[K] Ich\nweiß nicht, wovon du sprichst.", italian="???[K] Quale mostro?[K] Non so\ndi cosa stiate parlando.", spanish="¡¿Eh?![K] ¿Qué monstruo?[K] No sé\nde qué me hablas."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I made a friend. ♪", french=" Je me suis fait un copain. ♪", german="Ich habe einen neuen Freund\ngefunden. ♪", italian="Io ho trovato un nuovo\namico. ♪", spanish=" Ayer hice un nuevo amigo. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_jupetta, "shock", 1) end)
  GROUND:EntTurn(npc_npc_jupetta, Direction.DownLeft)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharSetEmote(npc_npc_sukorupi, "shock", 1) end)
  GROUND:EntTurn(npc_npc_sukorupi, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english=" F-friend?", french=" Un... un copain?", german=" E-einen Freund?", italian=" A-Amico?", spanish=" ¿Un... amigo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yep--a friend. ♪", french=" Voui, voui, un copain. ♪", german=" Ja, einen Freund. ♪", italian=" Sì... Un amico. ♪", spanish=" Pues sí, un amigo. ♪"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I'm headed out to play with my\nfriend again today. ♪[K] See you! ♪", french="Et aujourd'hui je retourne\njouer avec mon copain. ♪[K] A plus! ♪", german="Ich bin gerade auf dem Weg,\nwieder mit ihm zu spielen. ♪[K] Bis dann! ♪", italian="Proprio adesso stavo andando\na giocare di nuovo con lui. ♪[K] Ciao, ciao! ♪", spanish="Y hoy voy a volver a jugar\ncon él. ♪[K] ¡Hasta luego! ♪"})
  -- message_Close
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(180), p.Y+(0), false, 2) end
  GAME:WaitFrames(15)
  GROUND:EntTurn(npc_npc_sukorupi, Direction.Right)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_jupetta, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- screen2_FadeOut [sub déjà caché]
  GAME:FadeOut(false, 30)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(30)
  -- switch(main_EnterAdventure(250, 30)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  SkySceneKit.cleanup_npcs()
end
