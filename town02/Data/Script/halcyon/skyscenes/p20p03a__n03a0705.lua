-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P20P03A/n03a0705.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_P20P03A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_BEYOND_THE_DREAM non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(60)
  pcall(function() GAME:MoveCamera(204, 284, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Wow! Amazing! ♪", french=" Ouah! Incroyable! ♪", german=" Oh! Wahnsinn! ♪", italian=" Wow! Grandioso! ♪", spanish=" ¡Guau! ¡Cómo mola! ♪"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="There's so much treasure! ♪\nMaster! ♪", french="Il y a tant de trésors! ♪\nMaître! ♪", german="Dort sind noch viel mehr\nSchätze! ♪ Meister! ♪", italian="Ci sono un sacco di tesori! ♪\nMaestro! ♪", spanish="¡Hay un montón de tesoros, ♪\nmaestro! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  local npc_npc_aamarudo = SkySceneKit.spawn_npc("armaldo", 224, 288, Direction.Up, "NPC_AAMARUDO")
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="All right.[K] Let's take it all back\nwith us.", french="Très bien.[K] On ramène tout ça\navec nous.", german="Na gut.[K]\nLass uns alles mitnehmen.", italian=" Bene.[K] Prendiamoli tutti quanti.", spanish="Bueno...[K] Vamos a llevárnoslos\ntodos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" All right! ♪", french=" D'accord! ♪", german=" Au fein! ♪", italian=" Ok! ♪", spanish=" ¡Muy bien! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(hero, 188, 196, false, 2)
  pcall(function() GAME:MoveCamera(204, 236, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(npc_npc_aamarudo, 220, 248, false, 1)
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="... (He's really something,\nthis kid.)", french="... (Ce n'est vraiment pas\nn'importe qui, ce gamin.)", german="...(Das ist mir wirklich\neiner, dieser Kleine.)", italian="... (Questo bambino\nè prodigioso.)", spanish="Hum... (Este crío es un fuera\nde serie.)"})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="(We've been exploring together\nfor a while...)", french="(Ça fait quelque temps\nmaintenant qu'on part en exploration\nensemble...)", german="(Jetzt sind wir schon eine Weile\ngemeinsam auf Erkundungen unterwegs...)", italian="(È passato un bel po' di tempo\nda quando è diventato il mio apprendista...)", spanish="(Ya llevamos un tiempo\nexplorando juntos...)"})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="(I've never seen anyone with a\nnatural sense for exploring like he has.)", french="(Je n'ai jamais vu quelqu'un\nd'aussi doué pour l'exploration.)", german="(Und ich bin mir sicher: Ich\nhabe noch nie jemanden mit derart\nausgeprägtem Erkunder-Instinkt getroffen.)", italian="(... e non ho mai visto nessuno\ncon un senso dell'esplorazione così sviluppato.)", spanish="(Nunca antes había visto a nadie\ncon tal talento natural para explorar.)"})
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  GROUND:MoveToPosition(hero, 224, 196, false, 2)
  GROUND:EntTurn(hero, Direction.Right)
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" ...[K] (I'm sure...)", french=" ...[K] (J'en suis sûr...)", german=" ...[K](Ich bin mir sicher...)", italian=" ...[K] (Sono sicuro...)", spanish=" Hum...[K] (Estoy seguro...)"})
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  GROUND:MoveToPosition(hero, 224, 164, false, 2)
  GROUND:EntTurn(hero, Direction.UpRight)
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="(I'm sure that this kid...[K]is\nsome kind of exploration prodigy.)", french="(Ce gamin...[K] est un vrai\nsurdoué de l'exploration.)", german="(Ich bin mir sicher, dass dieser\nBengel...[K] eine Art Erkunder-Wunderkind\nsein muss.)", italian="(Sono sicuro che questo\nbambino...[K] sia una specie di genio\ndell'esplorazione.)", spanish="(Estoy seguro de que este crío...[K]\ntiene un talento prodigioso como explorador.)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  -- SetAnimation(2) [anim idle native]
  GROUND:MoveToPosition(hero, 204, 184, false, 2)
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Master, what are you doing?[K]\nHurry, hurry! ♪", french="Maître, vous faites quoi?[K]\nVite, vite, allez! ♪", german="Meister, was machst du denn?[K]\nBeeilung, Beeilung! ♪", italian="Maestro, che stai facendo?[K]\nPresto, presto! ♪", spanish="Maestro, ¿qué haces?[K]\n¡Venga, date prisa! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_aamarudo, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Y-yeah...[K] I'm on my way.", french=" Heu... oui...[K] J'arrive.", german=" J-ja...[K] Ich komme ja schon.", italian=" S-Sì...[K] Arrivo.", spanish=" Sí...[K] Ya voy."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(204, 144, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(npc_npc_aamarudo, 204, 144, false, 2)
  GAME:WaitFrames(20)
  GROUND:MoveToPosition(hero, 184, 148, false, 2)
  GROUND:EntTurn(hero, Direction.UpRight)
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  GAME:WaitFrames(5)
  pcall(function() SOUND:FadeOutBGM(150) end)
  GAME:FadeOut(false, 90)
  GAME:WaitFrames(60)
  SkySceneKit.cleanup_npcs()
end
