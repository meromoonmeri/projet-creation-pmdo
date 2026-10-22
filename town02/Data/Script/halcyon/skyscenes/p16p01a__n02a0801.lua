-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P16P01A/n02a0801.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V24P08A) [décor sub chargé: Sub_v24p08a]
  -- back_SetGround(LEVEL_P16P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 19, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  -- GAP: BGM BGM_A_FUN_EXPLORATION non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  SkySubScreen.Show("v24p08a", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_jupetta = SkySceneKit.spawn_npc("banette", 232, 144, Direction.Down, "NPC_JUPETTA")
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english=" All right, guys?", french=" O.K., les gars?", german=" Alles klar bei euch?", italian=" Tutto a posto, gente?", spanish=" ¿Todo bien, chicos?"})
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english="This time we're going to explore\nto the depths of [CS:P]Murky Forest[CR]!", french="Ce coup-ci on va explorer le\ncœur de la [CS:P]Forêt Glauque[CR]!", german="Dieses Mal erkunden wir die\nTiefen des [CS:P]Trübwalds[CR]!", italian="Questa volta esploreremo\nla [CS:P]Foresta Tenebrosa[CR] fino in fondo!", spanish="Esta vez vamos a llegar hasta\nlo más profundo del [CS:P]Bosque Oscuro[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_sukorupi = SkySceneKit.spawn_npc("skorupi", 248, 168, Direction.Up, "NPC_SUKORUPI")
  pcall(function() GROUND:CharSetEmote(npc_npc_sukorupi, "happy", 1) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_sukorupi) end)
  SkySceneKit.say({english=" Yeah!", french=" Ouais!", german=" Jawoll!", italian=" Sì!", spanish=" ¡Eso!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(npc_npc_sukorupi, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yeah! ♪", french=" Ouais! ♪", german=" Juchhu. ♪", italian=" Sì. ♪", spanish=" ¡Eso! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(20)
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english=" Let's go![K] Yay![K] Yay!", french=" C'est parti![K] Yahou![K] Youhou!", german=" Auf geht's![K] Ja![K] Ja!", italian=" Andiamo![K] Forza![K] Forza!", spanish=" ¡Venga![K] ¡Bien![K] ¡Yupi!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english=" Oooooh!", french=" Oooooh!", german=" Oooooh!", italian=" Ooooooh!", spanish=" ¡Oooooh!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_sukorupi, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_sukorupi) end)
  SkySceneKit.say({english=" OOoooohhhh!", french=" OOooooooh!", german=" OOooooh!", italian=" OOOooohhh!", spanish=" ¡Oooooh!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(24) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" OOOhhhhh! ♪", french=" OOOoooh. ♪", german=" Oooh! ♪", italian=" OOOhhh. ♪", spanish=" Ooooooh. ♪"})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(60) end)
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 30)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  -- main_EnterDungeon(128, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(main_EnterAdventure(250, 30)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
