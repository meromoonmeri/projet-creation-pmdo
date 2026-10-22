-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P41A/s31a3701.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.REQUEST_CLEAR_COUNT = 0 -- $REQUEST_CLEAR_COUNT = 0 (ROM)
  SkyProg.set(29, 31) -- $SCENARIO_MAIN = scn[29,31] (ROM)
  -- back_SetGround(LEVEL_D73P41A) [neutre/état moteur]
  -- supervision_Acting(2) [neutre/état moteur]
  -- supervision_Acting(3) [neutre/état moteur]
  -- supervision_Acting(4) [neutre/état moteur]
  -- supervision_Acting(5) [neutre/état moteur]
  -- supervision_Acting(6) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- supervision_RemoveActing(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveActing(3) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveActing(4) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveActing(5) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveActing(6) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_betobetaa = SkySceneKit.spawn_npc("grimer", 168, 272, Direction.DownRight, "NPC_BETOBETAA")
  -- SetAnimation(42) [anim idle native]
  local npc_npc_betobetaa2 = SkySceneKit.spawn_npc("grimer", 216, 256, Direction.Down, "NPC_BETOBETAA2")
  -- SetAnimation(42) [anim idle native]
  local npc_npc_betobeton = SkySceneKit.spawn_npc("muk", 256, 256, Direction.Down, "NPC_BETOBETON")
  -- SetAnimation(42) [anim idle native]
  GAME:WaitFrames(3)
  local npc_npc_betobetaa3 = SkySceneKit.spawn_npc("grimer", 256, 224, Direction.Down, "NPC_BETOBETAA3")
  -- SetAnimation(42) [anim idle native]
  local npc_npc_betobetaa4 = SkySceneKit.spawn_npc("grimer", 296, 256, Direction.Down, "NPC_BETOBETAA4")
  -- SetAnimation(42) [anim idle native]
  local npc_npc_betobeton2 = SkySceneKit.spawn_npc("muk", 200, 232, Direction.Down, "NPC_BETOBETON2")
  -- SetAnimation(42) [anim idle native]
  GAME:WaitFrames(3)
  local npc_npc_betobetaa5 = SkySceneKit.spawn_npc("grimer", 344, 272, Direction.DownLeft, "NPC_BETOBETAA5")
  -- SetAnimation(42) [anim idle native]
  local npc_npc_betobeton3 = SkySceneKit.spawn_npc("muk", 312, 232, Direction.Down, "NPC_BETOBETON3")
  -- SetAnimation(42) [anim idle native]
  -- back_SetWeather(11) [météo visuelle ground NDS - documenté]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_betobetaa2, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_betobetaa) end)
  SkySceneKit.say({english=" Uwaaaah!", french=" Shlouarfff!", german=" Uwaaaah!", italian=" Aaaaaah!", spanish=" ¡Uaaaaa!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_betobetaa4, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_betobetaa) end)
  SkySceneKit.say({english=" So stroooong!", french=" Trooop cochtauds!", german=" So staaaark!", italian=" Che foooooorti!", spanish=" ¡Qué fuerteeees!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_sheimi = SkySceneKit.spawn_npc("shaymin", 256, 288, Direction.Up, "NPC_SHEIMI")
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Have you come to your senses\nyet, [CS:N]Grimer[CR] and [CS:N]Muk[CR]?", french="Alors, vous êtes revenus à la\nraison, les [CS:N]Tadmorv[CR] et les [CS:N]Grotadmorv[CR]?", german="Seid ihr endlich wieder zur\nVernunft gekommen, [CS:N]Sleima[CR] und [CS:N]Sleimok[CR]?", italian="Adesso siete tornati in voi,\n[CS:N]Grimer[CR] e [CS:N]Muk[CR]?", spanish="Escuchad, [CS:N]Grimer[CR] y [CS:N]Muk[CR],\n¿habéis entrado ya en razón?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(5)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2)
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(5)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(7)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(10)
  -- GAP: se_Play(8963) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_betobetaa, "question", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_betobetaa3, "question", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_betobetaa4, "question", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_betobeton, "question", 1) end)
  GAME:WaitFrames(7)
  pcall(function() GROUND:CharSetEmote(npc_npc_betobeton2, "question", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_betobeton3, "question", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_betobetaa2, "question", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_betobetaa5, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_betobetaa) end)
  SkySceneKit.say({english=" Huh?", french=" Heinch?", german=" Äh?", italian=" Uh?", spanish=" ¿Eh?"})
  pcall(function() UI:SetSpeaker(npc_npc_betobetaa) end)
  SkySceneKit.say({english=" H-huhhh?", french=" Q-quoich?", german=" Ä-ähhh?", italian=" U-Uuuh?", spanish=" ¿Eeeeh?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8969) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_betobetaa, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_betobetaa3, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_betobetaa4, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_betobeton, "shock", 1) end)
  GAME:WaitFrames(7)
  pcall(function() GROUND:CharSetEmote(npc_npc_betobeton2, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_betobeton3, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_betobetaa2, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_betobetaa5, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_betobetaa) end)
  SkySceneKit.say({english=" Oh! [CS:N]Shaymin[CR]!", french=" Oh! [CS:N]Shaymin[CR]!", german=" Oh! [CS:N]Shaymin[CR]!", italian=" Oh! [CS:N]Shaymin[CR]!", spanish=" ¡Oh! ¡[CS:N]Shaymin[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="What happened while I was\naway for so long?", french="Que s'est-il passé ici\npendant mon absence?", german="Was ist nur während meiner\nAbwesenheit passiert?", italian="Cos'è successo durante\nla mia lunga assenza?", spanish="¿Qué es lo que ha sucedido\ndurante mi larga ausencia?"})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="You know that this isn't your\nhome, right?", french="Vous savez bien que ce n'est\npas chez vous ici, pas vrai?", german="Ihr wisst doch, dass hier nicht\neuer Zuhause ist, oder?", italian="Lo sapete che non potete stare\nqui, vero?", spanish="Sabéis perfectamente que este\nno es vuestro hogar, ¿verdad?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_betobetaa, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_betobetaa3, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_betobetaa4, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_betobeton, "shock", 1) end)
  GAME:WaitFrames(7)
  pcall(function() GROUND:CharSetEmote(npc_npc_betobeton2, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_betobeton3, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_betobetaa2, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_betobetaa5, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_betobetaa) end)
  SkySceneKit.say({english="H-huhhh?\nThis is so our hoooome...", french="Heinch?\nMais ch'est notre maijon...", german="Ä-ähhh?\nHier ist unser Zuhauuuse...", italian="U-Uuuh?\nQuesta è la nostra caaaaaasa...", spanish=" ¿Eeeh? Sí que esss nuestro hogaaar..."})
  pcall(function() UI:SetSpeaker(npc_npc_betobetaa) end)
  SkySceneKit.say({english="Seeee?\nIt's all dirty and griiiiiimy...", french="Regardez, ch'est tout chale\net tout poicheux...", german="Seeeeht ihr?\nAlles dreckig und eeeeeklig...", italian="Veeedi?\nÈ tutto così sporco e viiiiiiscido...", spanish=" ¿Lo ves? Está sucio y asquerosssooo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Dirty and grimy...", french=" \\\"Chale et poicheux\\\"...", german=" Dreckig und eeeeeklig...", italian=" Sporco e viiiiiiscido...", spanish=" Sucio y asqueroso..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_sheimi, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBGM("Sympathy.ogg", true) end)
  GAME:WaitFrames(20)
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" I see...", french=" Je vois...", german=" Ich verstehe...", italian=" Capisco...", spanish=" Entiendo..."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Nobody's come here for so long...", french="Ça fait si longtemps que\npersonne n'est venu...", german="Hier ist schon lange\nniemand mehr gewesen...", italian="È da tanto tempo che da queste\nparti non arriva qualcuno...", spanish="Hacía tanto que nadie venía\npor aquí..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(20)
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="I'm sorry, [CS:N]Grimer[CR] and [CS:N]Muk[CR].\nThis is the mountain summit.", french="Je suis désolée, les [CS:N]Tadmorv[CR]\net les [CS:N]Grotadmorv[CR]. Ici, c'est le sommet de\nla montagne.", german="Es tut uns leid, [CS:N]Sleima[CR] und\n[CS:N]Sleimok[CR], aber das hier ist der Berggipfel.", italian="Mi spiace, [CS:N]Grimer[CR] e [CS:N]Muk[CR].\nQuesta è la cima della montagna.", spanish="[CS:N]Grimer[CR], [CS:N]Muk[CR], lo siento, pero\nesta es la cima de la montaña."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_betobetaa, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_betobetaa3, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_betobetaa4, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_betobeton, "shock", 1) end)
  GAME:WaitFrames(7)
  pcall(function() GROUND:CharSetEmote(npc_npc_betobeton2, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_betobeton3, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_betobetaa2, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_betobetaa5, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_betobetaa) end)
  SkySceneKit.say({english="H-huhhhh?!\nThe summit?!", french="Q-quoi qu'est-che?!\nLe chommet?!", german="Ä-ähhh?!?\nDer Gipfel?!?", italian="U-Uuuh?!\nLa cima?!", spanish="¡¿Eeeeeeh?!\n¡¿La cima?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_betobetaa) end)
  SkySceneKit.say({english=" It can't be...!", french=" Impochible...!", german=" Kann nicht sein!", italian=" Non può esssere...!", spanish=" ¡No es posible!..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="I think it fell into disrepair\nbecause nobody visited for so long...", french="Je pense qu'il s'est dégradé\nparce qu'il a été laissé à l'abandon\npendant si longtemps.", german="Anscheinend ist er verfallen,\nweil so lange keiner mehr hier gewesen ist...", italian="Credo sia finita in rovina\nperché nessuno vi ha messo piede\nper lungo tempo...", spanish="Supongo que está en tan mal estado\nporque nadie ha venido en mucho tiempo..."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="But we can't leave the summit\nin this condition. Will you please return to your\nrightful home?", french="Mais nous ne pouvons pas\nlaisser le sommet dans cet état.\nAcceptez-vous de retourner chez vous?", german="Aber wir können den Gipfel\nnicht wieder so verlassen. Würdet ihr bitte\nzu eurem richtigen Zuhause zurückkehren?", italian="Ma non possiamo lasciare\nla cima in questo stato. Potreste tornare\nalla vostra vera casa?", spanish="Pero no podemos dejar que la cima\nsiga así. ¿Nos haréis el favor de volver\na vuestro legítimo hogar?"})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Please? I'm asking you.", french="S'il vous plaît, je vous\nle demande.", german=" Würdet ihr? Ich bitte euch.", italian=" Vi prego.", spanish=" Os lo pido por favor."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_betobetaa) end)
  SkySceneKit.say({english="Wh-what?\nThis is the summmmit?\nI didn't notiiiiice.", french="C-commench?\nCh'est le chommet?\nCh'avais pas remarchqué.", german="W-was?\nHier ist der Giiiipfel?\nHaben wir nicht bemeeeeerkt.", italian="Co-Cosa?\nQuesta è la ciiiiiima?\nNon l'avevo notaaaaaato.", spanish="Entonces... ¿Estamos en la cima?\nNo me había dado cuentaaaa."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_betobetaa) end)
  SkySceneKit.say({english=" Sorry, [CS:N]Shaymin[CR].", french=" Déjolé, [CS:N]Shaymin[CR].", german=" Entschuldige, [CS:N]Shaymin[CR].", italian=" Scusaciii, [CS:N]Shaymin[CR].", spanish=" Perdona, [CS:N]Shaymin[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_betobetaa) end)
  SkySceneKit.say({english=" We'll go home...", french=" On r'part chez nouch, alors...", german=" Wir werden nach Hause gehen...", italian=" Torneremo a caaasa...", spanish=" Nos iremos a casa..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" All right. Thank you!", french=" A la bonne heure, merci!", german=" In Ordnung, ich danke euch!", italian=" Bene, grazie mille!", spanish=" De acuerdo, ¡muchas gracias!"})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="I'll come visit with a token of\nthanks later![K] Bye!", french="Je viendrai vous rendre visite\nplus tard avec un cadeau de remerciement![K]\nAu revoir!", german="Ich werde euch später ein\nZeichen meiner Dankbarkeit überbringen![K]\nWiedersehen!", italian="Più tardi verrò a trovarvi per\nringraziarvi come si deve![K] Arrivederci!", spanish="Ya volveré con un regalo como\nmuestra de agradecimiento.[K] ¡Adiós!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_betobetaa) end)
  SkySceneKit.say({english=" OK. Bye-byyyye!", french=" Cha marche! Chalut à touch!", german=" Okay. Tschüüüüüss!", italian=" Ok. Ciao ciaaao!", spanish=" Muy bien, ¡adióoos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(180) end)
  do local p=npc_npc_betobetaa.Position; GROUND:MoveToPosition(npc_npc_betobetaa, p.X+(-88), p.Y+(0), false, 1) end -- Move2PositionOffset
  do local p=npc_npc_betobetaa3.Position; GROUND:MoveToPosition(npc_npc_betobetaa3, p.X+(0), p.Y+(-88), false, 1) end -- Move2PositionOffset
  GAME:WaitFrames(5)
  do local p=npc_npc_betobetaa5.Position; GROUND:MoveToPosition(npc_npc_betobetaa5, p.X+(88), p.Y+(0), false, 1) end -- Move2PositionOffset
  do local p=npc_npc_betobeton2.Position; GROUND:MoveToPosition(npc_npc_betobeton2, p.X+(-40), p.Y+(-88), false, 1) end -- Move2PositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_betobeton3.Position; GROUND:MoveToPosition(npc_npc_betobeton3, p.X+(40), p.Y+(-88), false, 1) end -- Move2PositionOffset
  GAME:WaitFrames(7)
  do local p=npc_npc_betobetaa2.Position; GROUND:MoveToPosition(npc_npc_betobetaa2, p.X+(-40), p.Y+(-100), false, 1) end -- Move2PositionOffset
  do local p=npc_npc_betobetaa4.Position; GROUND:MoveToPosition(npc_npc_betobetaa4, p.X+(40), p.Y+(-100), false, 1) end -- Move2PositionOffset
  do local p=npc_npc_betobeton.Position; GROUND:MoveToPosition(npc_npc_betobeton, p.X+(0), p.Y+(-100), false, 1) end -- Move2PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GAME:MoveCamera(252, 316, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(45)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_sheimi, 4) end)
  GAME:WaitFrames(5)
  do local __slot = SkySceneKit.team_member(1); if __slot then pcall(function() GROUND:CharTurnToCharAnimated(__slot, npc_npc_sheimi, 4) end) end end
  local npc_npc_kuchiito = SkySceneKit.spawn_npc("mawile", 192, 304, Direction.Up, "NPC_KUCHIITO")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kuchiito, npc_npc_sheimi, 4) end)
  GAME:WaitFrames(5)
  local npc_npc_goorikii = SkySceneKit.spawn_npc("machoke", 216, 320, Direction.Up, "NPC_GOORIKII")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_goorikii, npc_npc_sheimi, 4) end)
  do local __slot = SkySceneKit.team_member(2); if __slot then pcall(function() GROUND:CharTurnToCharAnimated(__slot, npc_npc_sheimi, 4) end) end end
  local npc_npc_kinogassa = SkySceneKit.spawn_npc("breloom", 248, 328, Direction.Up, "NPC_KINOGASSA")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kinogassa, npc_npc_sheimi, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Where were we...", french=" Bon, où en étions-nous...", german=" Wo waren wir gerade...", italian=" Dove eravamo...", spanish=" Bueno, ¿por dónde íbamos?..."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="We have to clean this place up,\nrestore it...", french="Ah oui, il faut nettoyer cet\nendroit et tout remettre en ordre...", german="Wir müssen hier aufräumen\nund diesen Ort wiederherstellen...", italian="Dobbiamo pulire questo posto,\nrimetterlo a nuovo...", spanish="Tenemos que limpiar este sitio\npara devolverle todo su esplendor..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_kuchiito.Position; GROUND:MoveToPosition(npc_npc_kuchiito, p.X+(16), p.Y+(-16), false, 2) end -- Move2PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kuchiito, npc_npc_sheimi, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kuchiito) end)
  SkySceneKit.say({english="Restore it? It's so dirty, how\ncould we possibly...", french="Tout remettre en ordre? Avec\ntoute cette crasse, comment espères-tu...", german="Ihn wiederherstellen?\nEs ist so schmutzig, wie könnten wir...", italian="Rimetterlo a nuovo? Come\npossiamo fare, è talmente sporco...", spanish="¿Su esplendor? Pero si está\nsucísimo. ¿Cómo vamos a...?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_sheimi, npc_npc_kuchiito, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="We [CS:K]Shaymin[CR] have a special\npower to clean up the land by absorbing dirt\nand things.", french="Nous, les [CS:K]Shaymin[CR], nous avons\nun pouvoir spécial qui nous permet de nettoyer\nla nature en absorbant toute la saleté.", german="Wir [CS:K]Shaymin[CR] besitzen die Gabe,\nSchmutz und Staub zu absorbieren, und so das\nLand zu säubern.", italian="Noi [CS:K]Shaymin[CR] abbiamo un potere\nspeciale che ci permette di ripulire un luogo\nassorbendone lo sporco e i detriti.", spanish="Los [CS:K]Shaymin[CR] tenemos un poder\nespecial que nos permite regenerar la tierra\nabsorbiendo todo tipo de suciedad."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Yet cleaning up this\nmess is no small task...", french="Ceci étant, même avec un tel\npouvoir, nettoyer un bazar pareil\nne va pas être une mince affaire...", german="Trotz alledem ist die Beseitigung\ndieses Drecks hier kein Zuckerschlecken...", italian="Detto questo, ripulire un simile\ndisastro non sarà facile...", spanish="Aun así, limpiar este desastre\nno será moco de pavo..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_sheimi, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Here goes nothing...", french=" Tout doit disparaître...", german=" Na, dann wollen wir mal...", italian=" Ora ci provo...", spanish=" Bueno, manos a la obra..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- supervision_Acting(2) [neutre/état moteur]
  -- GAP: se_Play(11014) — id SE NDS sans portage PMDO identifié
  -- SetOutputAttribute(1) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_goorikii, "shock", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_kuchiito, "shock", 1) end)
  do local __slot = SkySceneKit.team_member(2); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "shock", 1) end) end end
  -- SetAnimation(5) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(8), p.Y+(8), false, 2) end -- Slide2PositionOffset
  do local p=SkySceneKit.team_member(1).Position; GROUND:MoveToPosition(SkySceneKit.team_member(1), p.X+(8), p.Y+(8), false, 2) end -- Slide2PositionOffset
  GAME:WaitFrames(5)
  -- SetAnimation(5) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_kuchiito.Position; GROUND:MoveToPosition(npc_npc_kuchiito, p.X+(-8), p.Y+(0), false, 2) end -- Slide2PositionOffset
  do local p=npc_npc_goorikii.Position; GROUND:MoveToPosition(npc_npc_goorikii, p.X+(-8), p.Y+(8), false, 2) end -- Slide2PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(3)
  -- SetAnimation(5) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_kinogassa.Position; GROUND:MoveToPosition(npc_npc_kinogassa, p.X+(0), p.Y+(8), false, 2) end -- Slide2PositionOffset
  do local p=SkySceneKit.team_member(2).Position; GROUND:MoveToPosition(SkySceneKit.team_member(2), p.X+(8), p.Y+(0), false, 2) end -- Slide2PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D73P41A1_413) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(10)
  -- SetAnimation(19) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D73P41A1_413) [routine d'objet NDS non simulée - documenté]
  -- Destroy() [neutre/état moteur]
  pcall(function() GROUND:CharSetEmote(npc_npc_kinogassa, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kinogassa) end)
  SkySceneKit.say({english=" Wow!!", french=" Ouah!!", german=" Boah!", italian=" Wow!!!", spanish=" ¡¡Guau!!"})
  -- GAP: BGM BGM_EARTHQUAKE1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  -- SetAnimation(42) [anim idle native]
  GROUND:EntTurn(npc_npc_sheimi, Direction.DownRight)
  -- supervision_Acting(3) [neutre/état moteur]
  -- SetOutputAttribute(4) [neutre/état moteur]
  -- GAP: se_Play(11015) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D73P41A3_415) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(60)
  -- message_CloseEnforce
  GAME:WaitFrames(180) -- back_SetEffect(17, 180) [transition couches décor NDS: durée ROM préservée, bascule documentée]
  GROUND:EntTurn(npc_npc_sheimi, Direction.Down)
  -- supervision_Acting(4) [neutre/état moteur]
  -- SetOutputAttribute(1) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D73P41A4_416) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(3) [anim idle native]
  GROUND:EntTurn(npc_npc_sheimi, Direction.DownRight)
  GAME:WaitFrames(60)
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Get down, please!", french=" Baissez-vous, je vous prie!", german=" Duckt euch, bitte!", italian=" State indietro, per favore!", spanish=" Apartaos, por favor."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_goorikii, "shock", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_kuchiito, "shock", 1) end)
  do local __slot = SkySceneKit.team_member(2); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "shock", 1) end) end end
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(8), p.Y+(8), false, 2) end -- Slide2PositionOffset
  do local p=SkySceneKit.team_member(1).Position; GROUND:MoveToPosition(SkySceneKit.team_member(1), p.X+(8), p.Y+(8), false, 2) end -- Slide2PositionOffset
  GAME:WaitFrames(5)
  do local p=npc_npc_kuchiito.Position; GROUND:MoveToPosition(npc_npc_kuchiito, p.X+(-8), p.Y+(0), false, 2) end -- Slide2PositionOffset
  do local p=npc_npc_goorikii.Position; GROUND:MoveToPosition(npc_npc_goorikii, p.X+(-8), p.Y+(8), false, 2) end -- Slide2PositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_kinogassa.Position; GROUND:MoveToPosition(npc_npc_kinogassa, p.X+(0), p.Y+(8), false, 2) end -- Slide2PositionOffset
  do local p=SkySceneKit.team_member(2).Position; GROUND:MoveToPosition(SkySceneKit.team_member(2), p.X+(8), p.Y+(0), false, 2) end -- Slide2PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(11016) — id SE NDS sans portage PMDO identifié
  -- bgm2_PlayFadeIn(BGM_EARTHQUAKE3) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('1', '1', '1', '0')
  -- supervision_Acting(5) [neutre/état moteur]
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D73P41A2_414) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(90)
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(60)
  -- Destroy() [neutre/état moteur]
  -- SetAnimation(19) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(19) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D73P41A2_414) [routine d'objet NDS non simulée - documenté]
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D73P41A3_415) [routine d'objet NDS non simulée - documenté]
  -- Destroy() [neutre/état moteur]
  pcall(function() SOUND:FadeOutBGM(30) end)
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  -- camera_SetEffect(0): arrêt d'effet caméra
  -- SetAnimation(11) [anim idle native]
  GROUND:EntTurn(npc_npc_sheimi, Direction.Down)
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  pcall(function() GROUND:CharSetEmote(npc_npc_kinogassa, "exclaim", 1) end)
  GAME:WaitFrames(3)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_RIGHT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_kuchiito, "exclaim", 1) end)
  GAME:WaitFrames(30)
  -- SetAnimation(23) [anim idle native]
  -- supervision_Acting(6) [neutre/état moteur]
  -- SetAnimation(18) [anim idle native]
  -- SetOutputAttribute(4) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D73P41A5_417) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(19) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(8), p.Y+(8), false, 2) end -- Slide2PositionOffset
  do local p=SkySceneKit.team_member(1).Position; GROUND:MoveToPosition(SkySceneKit.team_member(1), p.X+(8), p.Y+(8), false, 2) end -- Slide2PositionOffset
  GAME:WaitFrames(5)
  do local p=npc_npc_kuchiito.Position; GROUND:MoveToPosition(npc_npc_kuchiito, p.X+(-8), p.Y+(0), false, 2) end -- Slide2PositionOffset
  do local p=npc_npc_goorikii.Position; GROUND:MoveToPosition(npc_npc_goorikii, p.X+(-8), p.Y+(8), false, 2) end -- Slide2PositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_kinogassa.Position; GROUND:MoveToPosition(npc_npc_kinogassa, p.X+(0), p.Y+(8), false, 2) end -- Slide2PositionOffset
  do local p=SkySceneKit.team_member(2).Position; GROUND:MoveToPosition(SkySceneKit.team_member(2), p.X+(8), p.Y+(0), false, 2) end -- Slide2PositionOffset
  -- screen2_WhiteOut [sub déjà caché]
  GAME:FadeOut(true, 30) -- screen_WhiteOut
  GAME:WaitFrames(160)
  SkySceneKit.cleanup_npcs()
end
