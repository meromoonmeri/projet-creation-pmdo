-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D56P41A/n06a3401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SV.SkyScenarioSide = {main=45, sub=13} -- $SCENARIO_SIDE = scn[45,13] (ROM)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(157, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  local npc_npc_chaaremu = SkySceneKit.spawn_npc("medicham", 200, 424, Direction.Up, "NPC_CHAAREMU")
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="We've come pretty far...[K] How\nmuch longer till we find the treasure?", french="Nous marchons depuis si\nlongtemps...[K] Le trésor est-il encore loin?", german="Jetzt sind wir schon so weit...[K]\nWie weit noch bis zum Schatz?", italian="Abbiamo fatto molta strada...[K]\nQuanto ci vorrà ancora per raggiungere\nil tesoro?", spanish="Hemos avanzado bastante...[K]\n¿Faltará mucho para llegar hasta el tesoro?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_saanaito = SkySceneKit.spawn_npc("gardevoir", 256, 424, Direction.Up, "NPC_SAANAITO")
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="Don't be so impatient, [CS:N]Medicham[CR].[K]\nWe'll get it sooner or later.", french="Patience, [CS:N]Charmina[CR].[K]\nOn le trouvera tôt ou tard.", german="Nicht so ungeduldig, [CS:N]Meditalis[CR].[K]\nFrüher oder später werden wir schon da sein.", italian="Non essere impaziente,\n[CS:N]Medicham[CR].[K] Prima o poi ci arriveremo.", spanish="No seas impaciente, [CS:N]Medicham[CR].[K]\nLo encontraremos tarde o temprano."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Everyone! Look![K]\nThere's a light over there!", french=" Regardez![K] De la lumière, là-bas!", german="Seht mal! Dort![K]\nDa ist ein Licht!", italian="Ehi! Guardate![K]\nC'è una luce laggiù!", spanish=" ¡Eh, mirad eso![K] ¡Ahí hay una luz!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" YAY![K] Wh-what is it?!", french=" YOUHOU![K] Qu'est-ce que c'est?!", german=" JUCHHU![K] W-was ist es?!?", italian=" OOOH![K] C-Cosa ci sarà?!", spanish=" ¡Yupi![K] Qué... ¡¿Qué es eso?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" Let's go and find out!", french=" Allons voir!", german=" Lasst es uns herausfinden!", italian=" Andiamo a vedere!", spanish=" ¡Habrá que averiguarlo!"})
  -- message_Close
  -- back_SetGround(LEVEL_D56P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1)
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(9) [anim idle native]
  -- bgm2_PlayFadeIn(BGM_CAVE_AMBIANCE) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  GAME:FadeIn(30)
  GROUND:MoveToPosition(npc_npc_saanaito, 256, 284, false, 2)
  GAME:WaitFrames(15)
  GROUND:MoveToPosition(npc_npc_chaaremu, 200, 284, false, 2)
  GAME:WaitFrames(24)
  GROUND:MoveToPosition(hero, 228, 308, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="[CS:N]Medicham[CR]! [CS:Y]Lopunny[CR]![K]\nThere's a treasure chest over there!", french="[CS:N]Charmina[CR]! [CS:Y]Lockpin[CR]![K]\nVous voyez ce que je vois? Un coffre!", german="[CS:N]Meditalis[CR]! [CS:Y]Schlapor[CR]![K]\nDort ist eine Schatztruhe!", italian="[CS:N]Medicham[CR]! [CS:Y]Lopunny[CR]![K]\nC'è un forziere laggiù!", spanish="¡[CS:N]Medicham[CR], [CS:Y]Lopunny[CR]![K]\n¡Ahí hay un cofre!"})
  -- message_Close
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  pcall(function() GAME:MoveCamera(228, 148, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(npc_npc_saanaito, 256, 136, false, 2)
  GAME:WaitFrames(9)
  GROUND:MoveToPosition(npc_npc_chaaremu, 200, 136, false, 2)
  GAME:WaitFrames(12)
  GROUND:MoveToPosition(hero, 228, 152, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_saanaito, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_chaaremu, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: BGM BGM_BEYOND_THE_DREAM non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="Wow![K] That treasure chest\nis HUGE!", french=" Waouh![K] Il est ENORME!", german="Wow![K]\nDiese Schatztruhe ist RIESIG!", italian=" Wow![K] È un forziere ENORME!", spanish=" ¡Anda![K] ¡Ese cofre es enorme!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="The rumors of a treasure in the\ndepths of [CS:P]Boulder Quarry[CR]...seem to be true...", french="Ainsi donc, la rumeur disait vrai.\nIl y a bel et bien un trésor au fin fond de\nla [CS:P]Carrière Rocher[CR]...", german="Die Gerüchte über einen Schatz\nin den Tiefen des [CS:P]Geröllbruchs[CR]...\nSie sind also wahr.", italian="Le voci su un tesoro nascosto\nnelle profondità della [CS:P]Cava Rocciosa[CR]...\nsembrano corrispondere al vero...", spanish="Los rumores sobre un tesoro en\nlas profundidades del [CS:P]Roquedal[CR]... Parece\nque eran ciertos..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="...You said it. Looks like treasure\nto me...", french="... En effet, ça m'a tout l'air\nd'un trésor...", german="...Du sagst es. Das sieht mir\nnach einem schönen Schatz aus...", italian="... Eccome. A me sembra proprio\nun tesoro questo...", spanish="Tú lo has dicho... A mí me parece\nun tesoro..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chaaremu, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="[CS:Y]Lopunny[CR]! Open it![K] Quick!\nI can't wait!", french="[CS:Y]Lockpin[CR]! Ouvre-le![K] Vite!\nJe meurs d'impatience!", german="[CS:Y]Schlapor[CR]! Öffne die Kiste![K]\nSchnell! Ich kann es kaum erwarten!", italian="[CS:Y]Lopunny[CR]! Aprilo![K] Forza!\nNon resisto più!", spanish="¡Ábrelo, [CS:Y]Lopunny[CR]![K] ¡Deprisa!\n¡Aish, qué intriga!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_chaaremu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Hee hee![K] Patience is a virtue,\n[CS:N]Medicham[CR]!", french="Hi hi![K] La patience est une vertu,\n[CS:N]Charmina[CR]!", german=" Hihi![K] Eile mit Weile, [CS:N]Meditalis[CR]!", italian="Ih ih![K] La calma è la virtù\ndei forti, [CS:N]Medicham[CR]!", spanish="¡Ji, ji![K] La paciencia es\nla madre de la ciencia, [CS:N]Medicham[CR]."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Opening a treasure chest should\nbe done with grace and splendor...", french="L'ouverture d'un coffre au\ntrésor doit se faire avec grâce et solennité...", german="Eine Schatztruhe sollte man\nimmer mit Anmut und Hingabe öffnen.", italian="Aprire un forziere è un gesto\nche richiede grazia e delicatezza...", spanish="Un cofre debe abrirse\ncon elegancia y estilo..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="After all, aren't we\nTeam [CS:X]Charm[CR]? [M:H8]", french="Après tout, nous sommes\nl'Equipe [CS:X]Charme[CR], n'est-ce pas? [M:H8]", german="Wir sind doch nicht umsonst\nTeam [CS:X]Charme[CR]... [M:H8]", italian="Dopo tutto siamo o non siamo\nil Team [CS:X]Malia[CR]? [M:H8]", spanish="Al fin y al cabo, ¡somos el\n[CS:X]Equipo Carisma[CR]! [M:H8]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" I know, I know, but...", french=" Je sais, je sais, mais...", german=" Ja doch, ja doch, aber...", italian=" Lo so, lo so, però...", spanish=" Sí, ya lo sé, pero..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_2") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="Argh! The suspense is\ngetting to me!", french="Argh! Le suspense est\ninsoutenable!", german="Argh! Diese Spannung halte ich\nnicht aus!", italian="Argh! Non riesco più a reggere\nla tensione!", spanish="¡Ay! ¡Es que el suspense\nme está afectando!"})
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="Forget the graces, [CS:Y]Lopunny[CR]![K] Just\nhurry up!", french="Oublie le décorum, [CS:Y]Lockpin[CR]![K]\nDépêche-toi!", german="Vergiss deine Anmut, [CS:Y]Schlapor[CR]![K]\nBeeile dich!", italian="Lascia perdere la grazia,\n[CS:Y]Lopunny[CR]![K] Sbrigati e basta!", spanish="¡Déjate de gentilezas, [CS:Y]Lopunny[CR]![K]\n¡Y date prisa!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Hee hee![K] Can you be a little\nmore mindful? A little less rash?", french=" Hi hi![K] Ne sois pas si brusque!", german="Hihi![K] Verhaltet euch doch bitte\nein kleines bisschen feierlicher! Das hier ist\ndoch kein Wettrennen!", italian="Ih ih![K] Calmati un po', non essere\ncosì precipitosa.", spanish="¡Ji, ji![K] ¿Podrías ser un poco\nmenos brusca? Algo de dulzura nunca va mal."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_chaaremu, Direction.Right)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" All right, all right. I'll open it!", french=" Ça va, ça va! Je l'ouvre!", german="Schon gut, schon gut.\nIch mache sie ja schon auf!", italian=" Ok, ok, adesso lo apro!", spanish=" En fin, ya voy. Lo abro ya."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Ta dah...[K] The moment this\ntreasure chest is opened...", french="Tadaaaaam...[K] Voyons quelle\nmerveille va s'offrir à nos yeux...", german="Tadah...[K] In just diesem Moment\nwird diese legendäre Schatztruhe geöffnet...", italian="Ci siamo...[K] Nel momento in cui\naprirò questo scrigno...", spanish="Tachán...[K] Ha llegado la hora\nde la verdad..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="What kind of treasure will be\nrevealed to our eyes...", french="... en ouvrant le coffre\nau trésor...", german="Was für einen Schatz sie\nunseren neugierigen Blicken wohl die ganze\nZeit vorenthalten hat...", italian=" Quale tesoro potremo ammirare?", spanish="Qué tipo de tesoro se revelará\nante nuestros ojos..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="What wealth of beautiful things\nwill we find...", french="Quelles richesses\néblouissantes...", german="Welch ein Reichtum wunderbarer\nDinge wird in unseren Besitz übergehen...", italian="Quale sorta di meraviglie\ntroveremo?", spanish=" Qué cúmulo de belleza hallaremos..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="That thought is filling me with\nexcitement...", french="Cette seule pensée me tient\nen haleine...", german="Diese Gedanken füllen unsere\nHerzen mit Wärme...", italian="Al solo pensarci tremo\ndall'emozione...", spanish="Esa incertidumbre hace que\nla emoción me invada..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Oh![K] Truly...[K] Truly...[K] Please...", french="Oh![K] Par pitié...[K] je t'en prie...[K]\nmon joli coffre...", german="Oh![K] Und die Wahrheit...[K]\nDie Wahrheit...[K] Oh, bitte...", italian="Oh![K] Ti prego...[K] dal profondo...[K]\ndel mio cuore...", spanish="¡Uf![K] Espero...[K] de verdad...[K] que,\npor favor..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Don't disappoint\nme! [M:H8]", french=" Ne me déçois pas! [M:H8]", german=" Enttäusche mich nicht! [M:H8]", italian=" Non... deludermi! [M:H8]", spanish=" ¡No me decepcione! [M:H8]"})
  -- message_Close
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chaaremu, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "angry", 1) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="I don't care about all that!\nOpen it already, [CS:Y]Lopunny[CR]!", french="Mais tu vas l'ouvrir ce\ncoffre, [CS:Y]Lockpin[CR]?!", german="Das ist mir alles egal!\nNun mach das Ding schon auf, [CS:Y]Schlapor[CR]!", italian="Insomma! Basta con tutte queste\nchiacchiere, [CS:Y]Lopunny[CR]! Apri quel forziere!", spanish="¡Bueno, ya te estás pasando!\n¡Ábrelo de una vez, [CS:Y]Lopunny[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_chaaremu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:FadeOutBGM(60) end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Here...\ngoes! [M:H8]", french=" Et... voilà! [M:H8]", german=" Und... los! [M:H8]", italian=" Ecco... qua! [M:H8]", spanish=" ¡Allá voy! [M:H8]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(10)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(6)
  GROUND:EntTurn(npc_npc_chaaremu, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, nil, 0) end) -- EFFECT_NONE
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN][CS:Y]Lopunny[CR] opened the treasure chest!", french="[CN][CS:Y]Lockpin[CR] ouvre le coffre au trésor!", german="[CN][CS:Y]Schlapor[CR] öffnet die Schatztruhe!", italian="[CN][CS:Y]Lopunny[CR] apre il forziere!", spanish="[CN][CS:Y]Lopunny[CR] abre el cofre."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(10254) — id SE NDS sans portage PMDO identifié
  -- GAP: SetEffect 652 — VFX sans émote PMDO équivalente
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(38)
  GAME:FadeOut(true, 30) -- screen_WhiteOutAll
  GAME:FadeOut(true, 0) -- screen_WhiteOut
  GAME:FadeIn(0)
  GAME:WaitFrames(8) -- WaitEndAnimation (join anim)
  -- SetAnimation(10) [anim idle native]
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" Ta dah![K] What...", french=" Tadaaaam![K] Quel...", german=" Tadah![K] Was...", italian=" Et voilà![K] Quale...", spanish=" ¡Tachán![K] Qué..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" What kind of treasure...", french=" Quel genre de trésor...", german=" Was für ein Schatz...", italian=" Quale tesoro...", spanish=" ¿Qué clase de tesoro...?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Is...\ninside? [M:H8]", french=" ... se cache... à l'intérieur? [M:H8]", german="Was für ein Schatz\nist darin? [M:H8]", italian=" ... ci sarà al suo interno? [M:H8]", spanish=" ¿Hay dentro? [M:H8]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetOutputAttribute(1) [neutre/état moteur]
  -- SetOutputAttribute(1) [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, "shock", 1) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" N...[K] NOTHING?!", french=" V...[K] VIDE?!", german=" N-[K]NICHTS?!?", italian=" È...[K] È VUOTO?!", spanish=" Arg...[K] ¡¿Nada?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" The treasure chest!", french=" Le coffre!", german=" Die Schatztruhe!", italian=" Il forziere!", spanish=" ¡Vaya con el cofre!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" There's nothing in it!", french=" Il est vide!", german=" Sie ist leer!", italian=" Dentro non c'è nulla!", spanish=" ¡No contiene nada!"})
  -- message_Close
  -- GAP: se_Play(8969) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="It's totally empty![K] I don't\nbelieve this!", french="Complètement vide![K]\nJe n'en crois pas mes yeux!", german="Ohne Inhalt![K] Ich kann es nicht\nglauben!", italian="È assolutamente vuoto![K]\nNon posso crederci!", spanish="¡Está totalmente vacío![K] ¡No me\nlo puedo creer!"})
  -- message_Close
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" Maybe I'm simply exhausted?", french=" Serait-ce la fatigue?", german=" Bin ich einfach nur übermüdet?", italian="Che abbia le allucinazioni\ndalla stanchezza?", spanish="¿Será una alucinación\nprovocada por el agotamiento?"})
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" Maybe I'm simply imagining this?", french="Mon imagination qui me joue\ndes tours?", german=" Bilde ich mir das nur ein?", italian=" Che mi stia immaginando tutto?", spanish=" Igual me lo estoy imaginando..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" It is not your imagination.", french=" Rien à voir avec ton imagination.", german="Es entspringt leider nicht\ndeiner Vorstellungskraft.", italian=" No, non è la tua immaginazione.", spanish=" No, no son imaginaciones tuyas."})
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="There is absolutely nothing inside\nthat treasure chest...", french=" Le coffre est bel et bien vide...", german="Es befindet sich schlicht und\neinfach gar nichts in dieser Schatztruhe.", italian="In questo forziere non c'è\nproprio nulla...", spanish="En este cofre no hay\nnada de nada..."})
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" But...[K] Why not?...", french=" Mais...[K] comment ça se fait...?", german=" Aber...[K] Warum denn nicht?", italian=" Ma...[K] com'è possibile...?", spanish=" Pero...[K] ¿Por qué no?..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "exclaim", 1) end)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, "shock", 1) end)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" Y-YOU!!", french=" V-VOUS!!", german=" I-IHR!!!", italian=" V-VOI!!!", spanish=" Pero... ¡¡Si sois vosotras!!"})
  GAME:WaitFrames(2) -- join WaitEffect
  GROUND:EntTurn(npc_npc_chaaremu, Direction.Down)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_saanaito, Direction.Down)
  GAME:WaitFrames(3)
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_Close
  pcall(function() SOUND:PlayBGM("Growing Anxiety.ogg", true) end)
  pcall(function() GAME:MoveCamera(228, 212, 60, false) end) -- performer/caméra
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_manyuura = SkySceneKit.spawn_npc("weavile", 232, 352, Direction.Up, "NPC_MANYUURA")
  GROUND:MoveToPosition(npc_npc_manyuura, 228, 224, false, 2)
  GAME:WaitFrames(12)
  local npc_npc_dorapion = SkySceneKit.spawn_npc("drapion", 264, 376, Direction.Up, "NPC_DORAPION")
  GROUND:MoveToPosition(npc_npc_dorapion, 264, 228, false, 2)
  GAME:WaitFrames(12)
  local npc_npc_aabokku = SkySceneKit.spawn_npc("arbok", 192, 376, Direction.Up, "NPC_AABOKKU")
  GROUND:MoveToPosition(npc_npc_aabokku, 192, 232, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "shock", 1) end)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, "shock", 1) end)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" Team [CS:X]AWD[CR]?!", french=" L'Equipe [CS:X]DDA[CR]?!", german=" Team [CS:X]SPA[CR]?!?", italian=" Il Team [CS:X]AWD[CR]?!", spanish=" ¡¿El [CS:X]Equipo WAD[CR]?!"})
  -- message_Close
  -- GAP: se_Play(8969) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_dorapion, "shock", 1) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharSetEmote(npc_npc_manyuura, "exclaim", 1) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharSetEmote(npc_npc_aabokku, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dorapion) end)
  SkySceneKit.say({english=" Aaaah![K] Th-the treasure!", french=" Aaaah![K] Le trésor!", german=" Aaaah![K] D-der Schatz!", italian=" Aaah![K] I-Il tesoro!", spanish=" ¡Aaaah![K] El... ¡El tesoro!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_aabokku) end)
  SkySceneKit.say({english="Did you already ssssneak off\nwith it?!", french=" Vous l'avez sssubtilisé?!", german="Habt ihr ihn euch ssschon unter\nden Nagel gerissssssen?!?", italian=" Avete già aperto lo ssscrigno?!", spanish=" ¡¿Ya lo habéisss garrapiñado?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english="Humph![K] Looks like we were\ntoo late.", french="Pfff![K] Il semblerait que\nnous arrivions trop tard!", german="Humpf![K] Sieht fast so aus,\nals seien wir zu spät.", italian="Umpf![K] A quanto pare siamo\narrivati tardi.", spanish="¡Bah![K] Por lo visto llegamos\ndemasiado tarde."})
  -- message_Close
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "shock", 1) end)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, "shock", 1) end)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" N-no! Hang on!", french=" N-non! Attendez!", german=" N-nein! Wartet!", italian=" N-No! Aspettate!", spanish=" ¡No, no! ¡Un momento!"})
  -- message_Close
  GROUND:MoveToPosition(hero, 228, 180, false, 2)
  GAME:WaitFrames(9)
  GROUND:MoveToPosition(npc_npc_saanaito, 256, 172, false, 2)
  GAME:WaitFrames(9)
  GROUND:MoveToPosition(npc_npc_chaaremu, 200, 172, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="We're not the ones who took\nthe treasure!", french="Ce n'est pas nous qui avons pris\nle trésor!", german="Wir sind nicht diejenigen, die\nden Schatz genommen haben!", italian="Non siamo state noi a prendere\nil tesoro!", spanish="Nosotras no hemos cogido\nel tesoro."})
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="When we opened the\ntreasure chest...", french=" Quand nous l'avons ouvert...", german="Als wir die Schatztruhe\nöffneten...", italian="Quando abbiamo aperto\nil forziere...", spanish=" Hemos abierto el cofre y..."})
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" It was totally empty!", french=" ... le coffre était vide!", german=" Sie war total leer!", italian=" Era completamente vuoto!", spanish=" ¡Ya estaba vacío!"})
  -- message_Close
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dorapion, "angry", 1) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharSetEmote(npc_npc_aabokku, "angry", 1) end)
  GAME:WaitFrames(6)
  pcall(function() UI:SetSpeaker(npc_npc_dorapion) end)
  SkySceneKit.say({english=" Don't lie! You cheater!", french=" Mensonges! Tricheuses!", german="Hört auf zu lügen!\nIhr Schummler!", italian=" Bugiarda! Non mentire!", spanish=" ¡No mientas, lianta!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_dorapion, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_aabokku, nil, 0) end) -- EFFECT_NONE
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" It's not a lie![K] It's the truth!", french="Ce n'est pas un mensonge![K]\nC'est la pure vérité!", german="Wir lügen nicht![K]\nDas ist die Wahrheit!", italian=" Non sta mentendo![K] È la verità!", spanish=" ¡Que no es mentira![K] ¡En serio!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english=" ...[K]Humph!", french=" ...[K] Pfff!", german=" ...[K]Humpf!", italian=" ...[K] Umpf!", spanish=" Hum...[K] ¡Ja!"})
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english="If you're going to lie, could you\nat least be a tiny little bit more convincing?", french="Tu pourrais au moins essayer\nd'être un peu plus convaincante, d'accord?", german="Wenn ihr schon lügen müsst,\nwarum tut ihr es auf so plumpe Art?", italian="Se proprio dovete raccontare\nbugie, non potreste cercare di essere\nun po' più convincenti?", spanish="Puestas a mentir, ¿no podríais\nser al menos un pelín más convincentes?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" What...?!", french=" Quoi...?!", german=" Wie bitte?!?", italian=" Cosa...?!", spanish=" ¡¿Qué...?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english="If you're going to keep lying\nlike that...", french=" Mentir de la sorte...", german=" Wenn ihr weiter so lügt...", italian="Se avete intenzione di continuare\na mentire in questo modo...", spanish="Si pensáis seguir echándole\nteatro de una forma tan descarada..."})
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english="Then you're not a real\nexploration team!", french="... n'est pas digne d'une\néquipe d'exploration!", german="Dann seid ihr kein echtes\nErkundungsteam!", italian="... allora non siete una vera\nsquadra d'esplorazione!", spanish="Es que no sois un auténtico\nequipo explorador."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" What'd you say?!", french=" Répète un peu, pour voir!", german=" Was hast du gerade gesagt?!?", italian=" Cosa vuoi dire?!", spanish=" ¡¿Qué acabas de decir?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english="You're underqualified to obtain\nthat treasure!", french="Vous n'êtes pas dignes d'obtenir\nce trésor!", german="Ihr seid nicht qualifiziert genug,\ndiesen Schatz an euch zu nehmen!", italian="Non siete degne di prendere\nquel tesoro!", spanish=" ¡No os merecéis ese tesoro!"})
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english="I guess we'll just have to take it\nby force then!", french="Il va donc falloir qu'on vous\nle prenne de force!", german="Wenn ihr weiter auf stur\nschaltet, müssen wir Gewalt anwenden!", italian="Quindi credo proprio che\ndovremo sottrarvelo con la forza!", spanish="Así que supongo que tendremos\nque arrebatároslo a la fuerza."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(60) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "angry", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" Humph![K] You're all talk!", french="Pfff![K] Qu'est-ce qu'il\nne faut pas entendre!", german=" Humpf![K] Ihr redet doch nur!", italian="Umpf![K] Siete bravi solo\na chiacchierare!", spanish=" ¡Bah![K] ¡Eso es todo palabrería!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Attacking us with false\naccusations...", french="Porter de telles accusations\ncontre nous, c'est honteux...", german="Werft mit falschen\nAnschuldigungen um euch...", italian="Attaccarci con queste false\naccuse...", spanish="Cómo te atreves a atacarnos\ncon falsas acusaciones..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I knew the rumors were true.\nYou're just villains!", french="Je savais bien que la rumeur\ndisait vrai! Vous n'êtes qu'un ramassis\nde bandits!", german="Ich wusste doch, dass die\nGerüchte stimmen. Ihr seid Schufte!", italian="Lo sapevo che le voci erano\nvere. Siete solo dei tipacci!", spanish="Sabía que el rumor era cierto.\n¡No sois más que una panda de maleantes!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="We just can't forgive an\nexploration team like you!", french="Vos méfaits ne resteront\npas impunis!", german="Bei einem Erkundungsteam wie\neurem können wir keine Gnade walten lassen!", italian="Non possiamo perdonare una\nsquadra d'esplorazione come la vostra!", spanish="¡No podemos hacer la vista gorda\nante un equipo explorador de tal calaña!"})
  -- message_Close
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, nil, 0) end) -- EFFECT_NONE
  -- GAP: BGM BGM_TEAM_CHARMS_THEME non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="We made a promise to [CS:N]Sentret[CR]\ntoo. Looks like we'll be able to keep it!", french="Nous avons fait une promesse à\n[CS:N]Fouinette[CR]. Et nous allons la tenir!", german="Wir haben [CS:N]Wiesor[CR] vorhin ein\nVersprechen gegeben. Nun sieht es fast so aus,\nals könnten wir es halten!", italian="Abbiamo anche fatto una\npromessa a [CS:N]Sentret[CR]. E ora pare proprio\nche riusciremo a mantenerla!", spanish="Y se lo prometimos a [CS:N]Sentret[CR].\n¡Parece que vamos a cumplir nuestra promesa!"})
  -- message_Close
  -- GAP: se_Play(5127) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="We're the treasure hunters--\nTeam [CS:X]Charm[CR]!", french="Nous sommes les chasseuses de\ntrésor de l'Equipe [CS:X]Charme[CR]!", german="Wir sind die Schatzjäger\nTeam [CS:X]Charme[CR]!", italian="Noi siamo le cacciatrici\ndi tesori... il Team [CS:X]Malia[CR]!", spanish="Somos buscadoras de tesoros...\n¡El [CS:X]Equipo Carisma[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="You![K] We're going to punish you,\nso get ready!", french="En garde![K] Vous allez recevoir\nla correction que vous méritez!", german="Ihr da![K] Jetzt bekommt ihr\neine Lektion erteilt. Also macht euch bereit!", italian="Attenti a voi![K] Ora ve la faremo\npagare, quindi preparatevi!", spanish="¡Eh, vosotros![K] ¡Os vamos a dar\npara el pelo, así que preparaos!"})
  GROUND:EntTurn(hero, Direction.Down)
  GROUND:EntTurn(npc_npc_chaaremu, Direction.Down)
  GROUND:EntTurn(npc_npc_saanaito, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(24) [anim idle native]
  -- SetAnimation(24) [anim idle native]
  -- SetAnimation(27) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(5127) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5127) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitSe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english=" Humph!", french=" Pfff!", german=" Humpf!", italian=" Umpf!", spanish=" ¡Bah!"})
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english="I knew it would come to this\nfrom the moment we first met you!", french="Dès notre première rencontre,\nj'ai su que l'affrontement était inévitable!", german="Ich wusste vom ersten\nAugenblick an, dass es so weit kommen würde!", italian="Sapevo che prima o poi ci\nsaremmo scontrati, fin dal nostro\nprimo incontro!", spanish="Sabía que esto acabaría así\ndesde el momento en que os vi."})
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english="You've never come up against a\nband of thieves like Team [CS:X]AWD[CR].\nPrepare to feel our true terribleness...", french="L'Equipe [CS:X]DDA[CR] est au-delà de tout\nce que vous avez connu jusqu'à présent.\nPréparez-vous à prendre la raclée du siècle!", german="Gegen eine Diebesbande wie\nTeam [CS:X]SPA[CR] habt ihr keine Chance! Macht euch\nbereit, unsere wahre Bosheit zu spüren...", italian="Non avete mai affrontato\nuna banda di ladri come il Team [CS:X]AWD[CR].\nPreparatevi ad assaggiare la nostra forza...", spanish="Os aviso de que nunca os habéis\nenfrentado a una banda de ladrones como el\n[CS:X]Equipo WAD[CR]. Somos terribles..."})
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english=" Make sure you savor it!", french="Prosternez-vous devant\nnotre puissance!", german=" Lasst euch Zeit, sie zu genießen!", italian="E sarà un boccone molto amaro\nper voi!", spanish=" ¡Vais a comprobarlo ya mismo!"})
  -- message_Close
  -- GAP: se_Play(5127) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english="[CS:N]Arbok[CR]! [CS:N]Drapion[CR]!\nLet's go!", french="[CS:N]Arbok[CR]! [CS:N]Drascore[CR]!\nA l'attaque!", german="[CS:N]Arbok[CR]! [CS:N]Piondragi[CR]!\nLos geht's!", italian="[CS:N]Arbok[CR]! [CS:N]Drapion[CR]!\nAddosso!", spanish="¡[CS:N]Arbok[CR], [CS:N]Drapion[CR]!\n¡A por ellas!"})
  -- message_Close
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(3)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_aabokku, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dorapion, "happy", 1) end)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english="[CS:N]Arbok[CR] & [CS:N]Drapion[CR]: YEAH!", french="[CS:N]Arbok[CR] & [CS:N]Drascore[CR]: OUAIS!", german="[CS:N]Arbok[CR] und [CS:N]Piondragi[CR]: JUCHHU!", italian="[CS:N]Arbok[CR] e [CS:N]Drapion[CR]: SÌ!", spanish="[CS:N]Arbok[CR] y [CS:N]Drapion[CR]: ¡Eso!"})
  GAME:WaitFrames(18)
  pcall(function() GROUND:CharSetEmote(npc_npc_aabokku, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_dorapion, nil, 0) end) -- EFFECT_NONE
  -- message_Close
  -- GAP: se_Play(5127) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5127) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitSe
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="[CS:N]Medicham[CR]! [CS:Y]Lopunny[CR]!\nHere they come!", french="[CS:N]Charmina[CR]! [CS:Y]Lockpin[CR]!\nIls arrivent!", german="[CS:N]Meditalis[CR]! [CS:Y]Schlapor[CR]!\nNehmt euch in Acht, wir werden angegriffen!", italian="[CS:N]Medicham[CR]! [CS:Y]Lopunny[CR]!\nTenetevi pronte!", spanish="¡[CS:N]Medicham[CR], [CS:Y]Lopunny[CR]!\n¡Preparaos, que vienen!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" Anytime!", french=" Je les attends de pied ferme!", german=" Allzeit bereit!", italian=" Mettiamocela tutta!", spanish=" ¡Venga!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="OK.\nLet's go! [M:H8]", french=" O.K. C'est parti! [M:H8]", german=" Auf geht's! [M:H8]", italian=" Ok. Andiamo! [M:H8]", spanish=" De acuerdo. ¡Vamos! [M:H8]"})
  -- message_Close
  -- supervision_SpecialActing(24, 0, 0) [cadrage NDS]
  -- supervision_SpecialActing(25, 0, 0) [cadrage NDS]
  -- GAP: se_Play(10249) — id SE NDS sans portage PMDO identifié
  -- supervision_SpecialActing(26, 0, 0) [cadrage NDS]
  GAME:WaitFrames(120)
  GAME:FadeOut(true, 30) -- screen_WhiteOutAll
  -- supervision_SpecialActing(3, 0, 0) [cadrage NDS]
  -- main_EnterDungeon(157, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  SkySceneKit.cleanup_npcs()
end
