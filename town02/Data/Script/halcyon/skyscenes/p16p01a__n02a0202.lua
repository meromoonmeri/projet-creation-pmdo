-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P16P01A/n02a0202.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Heartwarming.ogg", true) end)
  -- back_SetGround(LEVEL_P16P01A) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_P16P01A, 'UN02') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_muchuuru = SkySceneKit.spawn_npc("smoochum", 232, 168, Direction.Up, "NPC_MUCHUURU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_subomii = SkySceneKit.spawn_npc("budew", 264, 160, Direction.Left, "NPC_SUBOMII")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_upaa = SkySceneKit.spawn_npc("wooper", 200, 160, Direction.Right, "NPC_UPAA")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_subomii) end)
  SkySceneKit.say({english=" Hey, what should we play today?", french=" Hé, on joue à quoi aujourd'hui?", german="Hey, was sollen wir\nheute spielen?", italian=" Ehi, a cosa giochiamo oggi?", spanish=" Eh, ¿a qué jugamos hoy?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_upaa, "happy", 1) end)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_muchuuru, Direction.UpLeft)
  GAME:WaitFrames(4)
  GROUND:EntTurn(hero, Direction.DownLeft)
  pcall(function() UI:SetSpeaker(npc_npc_upaa) end)
  SkySceneKit.say({english=" Let's play in the mud!", french=" Et si on se roulait dans la boue!", german=" Lasst uns im Schlamm spielen!", italian=" Giochiamo con il fango!", spanish=" ¡Vamos a jugar en el barro!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(npc_npc_upaa, nil, 0) end) -- EFFECT_NONE
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_upaa, Direction.DownRight)
  GAME:WaitFrames(4)
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_subomii, Direction.DownLeft)
  pcall(function() UI:SetSpeaker(npc_npc_muchuuru) end)
  SkySceneKit.say({english=" Yuck! I don't want to!", french=" Pouah! Pas envie!", german=" Igitt! Das möchte ich nicht!", italian=" Bleah! Io non voglio!", spanish=" ¡Puaj! ¡No quiero, no quiero!"})
  pcall(function() UI:SetSpeaker(npc_npc_muchuuru) end)
  SkySceneKit.say({english="It's unladylike to get all muddy!\nSmooch!", french="Une fille, ça se roule pas\ndans la boue! Et smack!", german="Im Schlamm zu spielen\ngehört sich nicht für eine Dame! Knutsch!", italian="Non sta bene che una ragazza\nsi sporchi tutta di fango! Smooch!", spanish="¡Una señorita no se ensucia!\n¡Ni pensarlo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I brought some Gummis. Would\nyou guys like one?", french="J'ai apporté des gelées.\nVous en voulez, mes copains?", german="Ich habe ein paar Gummibonbons\ndabei. Möchte jemand von euch eins?", italian="Ho portato delle Gomme.\nNe volete una?", spanish=" He traído gomis, ¿queréis una?"})
  GROUND:EntTurn(npc_npc_muchuuru, Direction.Up)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_subomii, Direction.UpLeft)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_upaa, Direction.UpRight)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_upaa, "happy", 1) end)
  -- SetAnimation(5) [anim idle native]
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharSetEmote(npc_npc_muchuuru, "happy", 1) end)
  -- SetAnimation(5) [anim idle native]
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharSetEmote(npc_npc_subomii, "happy", 1) end)
  -- SetAnimation(4) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_subomii) end)
  SkySceneKit.say({english=" Yay!", french=" Ouais!", german=" Au ja!", italian=" Evviva!", spanish=" ¡Ya te digo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_upaa) end)
  SkySceneKit.say({english=" I want one!", french=" Moi aussi!", german=" Ich möchte eins!", italian=" Io ne voglio una!", spanish=" ¡Quiero una!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(5) [anim idle native]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_muchuuru) end)
  SkySceneKit.say({english="I love Gummis! ♪\nSo, so much! Smooooches! ♪", french="J'adoooore les gelées! ♪\nJ'adore, j'adore! Gros bisou! ♪", german="Gummibonbons! Wie schön! ♪\nWie lecker! Knuuuutsch! ♪", italian="Adoro le Gomme! ♪\nTanto, tanto! Smooooches! ♪", spanish="¡Me encantan las gomis! ♪\n¡Qué ricas! ¡Ji, ji! ♪"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(5) [anim idle native]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GROUND:MoveToPosition(npc_npc_upaa, 212, 144, false, 2)
  GAME:WaitFrames(4)
  GROUND:MoveToPosition(npc_npc_muchuuru, 228, 152, false, 2)
  GAME:WaitFrames(4)
  GROUND:MoveToPosition(npc_npc_subomii, 244, 144, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(100)
  -- screen2_FadeOut [sub déjà caché]
  GAME:FadeOut(false, 30)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  pcall(function() GROUND:CharSetEmote(npc_npc_upaa, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_muchuuru, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_subomii, nil, 0) end) -- EFFECT_NONE
  pcall(function() GAME:MoveCamera(0, 0, 1, true) end) -- caméra défaut
  GAME:WaitFrames(30)
  GAME:FadeIn(30)
  SkySceneKit.cleanup_npcs()
end
