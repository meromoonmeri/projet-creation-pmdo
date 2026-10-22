-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04C/m24a0103.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_G01P04C) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 432, 232, Direction.UpRight, "NPC_DOGOOMU")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 384, 224, Direction.DownRight, "NPC_BIPPA")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 408, 248, Direction.UpLeft, "NPC_KIMAWARI")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 384, 272, Direction.DownRight, "NPC_HEIGANI")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 456, 216, Direction.DownLeft, "NPC_DIGUDA")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 408, 296, Direction.UpLeft, "NPC_DAGUTORIO")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 480, 240, Direction.DownRight, "NPC_GUREGGURU")
  -- SetAnimation(4) [anim idle native]
  GAME:FadeIn(30)
  GAME:WaitFrames(90)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 440, 280, Direction.Right, "NPC_CHIRIIN")
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" Oh! Guildmaster!", french=" Oh! Maître!", german=" Oh! Gildenmeister!", italian=" Oh! Capitano!", spanish=" ¡Oh! ¡Gran Bluff!"})
  -- message_Close
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, "exclaim", 1) end)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.DownRight)
  GROUND:EntTurn(npc_npc_diguda, Direction.DownRight)
  GROUND:EntTurn(npc_npc_bippa, Direction.Right)
  GROUND:EntTurn(npc_npc_kimawari, Direction.Right)
  GROUND:EntTurn(npc_npc_heigani, Direction.Right)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Right)
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 632, 280, Direction.Left, "NPC_PUKURIN")
  GROUND:MoveToPosition(npc_npc_pukurin, 504, 276, false, 2)
  GAME:WaitFrames(45)
  pcall(function() GAME:MoveCamera(464, 268, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(npc_npc_chiriin, 472, 276, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(npc_npc_dagutorio, 448, 284, false, 2)
  GROUND:MoveToPosition(npc_npc_heigani, 424, 276, false, 2)
  GROUND:MoveToPosition(npc_npc_kimawari, 448, 260, false, 2)
  GROUND:MoveToPosition(npc_npc_bippa, 416, 252, false, 2)
  GROUND:MoveToPosition(npc_npc_dogoomu, 440, 236, false, 2)
  GROUND:MoveToPosition(npc_npc_diguda, 464, 228, false, 2)
  GROUND:MoveToPosition(npc_npc_guregguru, 488, 236, false, 2)
  GROUND:EntTurn(npc_npc_guregguru, Direction.DownRight)
  GROUND:EntTurn(npc_npc_diguda, Direction.DownRight)
  GROUND:EntTurn(npc_npc_kimawari, Direction.DownRight)
  GROUND:EntTurn(npc_npc_bippa, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="How is [CS:N]Chatot[CR]? Will he be all\nright?", french="Comment va [CS:N]Pijako[CR]? Il va\ns'en sortir?", german="Wie geht es [CS:N]Plaudagei[CR]? Kommt\ner wieder auf die Beine?", italian="Come sta [CS:N]Chatot[CR]? Si rimetterà\npresto?", spanish="¿Cómo está [CS:N]Chatot[CR]?\n¿Se recuperará?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Yep! ♪", french=" Oui! ♪", german=" Jep! ♪", italian=" Certo! ♪", spanish=" Sí. ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="He needs to sleep and recover\ntonight. I think he'll be fine tomorrow! ♪", french="Il a besoin d'une bonne nuit\nde sommeil réparateur. Il devrait aller mieux\ndemain! ♪", german="Er muss heute Nacht schlafen\nund sich erholen. Ich denke, es wird ihm\nmorgen besser gehen! ♪", italian="Stanotte ha bisogno di dormire\nper recuperare le forze. Penso che domani\nstarà bene! ♪", spanish="Esta noche necesita dormir\nbien y descansar... pero mañana estará\ncomo nuevo. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "sweating", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, "sweating", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "sweating", 1) end)
  pcall(function() SOUND:PlayBGM("Goodnight.ogg", true) end)
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" YEAH!", french=" OUAIS!", german=" JAAA!", italian=" SÌ!", spanish=" ¡BIEN!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(4) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english=" I'm glad to hear that!", french=" Excellente nouvelle!", german=" Ich freue mich, das zu hören!", italian=" Meno male, mi fa piacere!", spanish=" ¡Me alegra saberlo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "sweating", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Yup yup, that's a load off my\nmind, by golly.", french="Sapristi, j'suis vachement\nsoulagé, pour sûr.", german="Jawollja, das ist eine echte\nErleichterung. Donnerwetter.", italian="Mi togli un peso dal cuore,\nohibò.", spanish="Córcholis, se me quita\nun gran peso de encima... ¡Sí, señor!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Hey, hey! That's great! [CS:N]Chatot[CR]\nwill be OK! Hey, hey!", french="Eh dis donc, c'est super! [CS:N]Pijako[CR]\nva s'en sortir, dis donc!", german="Hey, hey! Das ist super!\n[CS:N]Plaudagei[CR] wird wieder gesund! Hey, hey!", italian="Ehi, ehi! È grandioso! [CS:N]Chatot[CR]\nstarà presto meglio! Ehi, ehi!", spanish="¡Oye, oye! ¡Eso es genial!\n¡[CS:N]Chatot[CR] se recuperará!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" Guildmaster...?", french=" Maître...?", german=" Gildenmeister?", italian=" Capitano...?", spanish=" ¿Gran Bluff...?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_pukurin, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Up)
  GROUND:EntTurn(npc_npc_diguda, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_guregguru, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_chiriin, Direction.UpLeft)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "question", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" What is it, [CS:N]Sunflora[CR]?", french=" Qu'est-ce qu'il y a, [CS:N]Héliatronc[CR]?", german=" Was gibt es, [CS:N]Sonnflora[CR]?", italian=" Cosa c'è, [CS:N]Sunflora[CR]?", spanish=" ¿Qué pasa, [CS:N]Sunflora[CR]?"})
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="Guildmaster, you said [CS:N]Chatot[CR]\nsaved you at that cave long ago. Can you tell\nus about it?", french="Maître, vous avez dit que [CS:N]Pijako[CR]\nvous avait sauvé la vie dans cette grotte\nil y a longtemps. Racontez-nous!", german="Gildenmeister, du sagtest,\n[CS:N]Plaudagei[CR] hätte dich in dieser Höhle vor langer\nZeit gerettet. Kannst du uns davon erzählen?", italian="Capitano, hai detto che tanto\ntempo fa in quella grotta [CS:N]Chatot[CR] ti ha salvato.\nPerché non ce lo racconti?", spanish="Gran Bluff, nos dijiste que\n[CS:N]Chatot[CR] te salvó en esa cueva tiempo atrás.\n¿Puedes contarnos lo que sucedió?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Yep! This is what happened...", french="D'accord! Voilà comment\nça s'est passé...", german="Jep! Folgendes geschah\ndamals...", italian=" Già! È andata così...", spanish="¡Claro! Pues lo que pasó fue\nque..."})
  -- message_Close
  GROUND:EntTurn(npc_npc_chiriin, Direction.Right)
  GROUND:EntTurn(npc_npc_guregguru, Direction.DownRight)
  GROUND:EntTurn(npc_npc_diguda, Direction.DownRight)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.UpRight)
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
end
