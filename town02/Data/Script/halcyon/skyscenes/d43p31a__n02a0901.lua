-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D43P31A/n02a0901.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SV.SkyScenarioSide = {main=42, sub=0} -- $SCENARIO_SIDE = scn[42,0] (ROM)
  local npc_npc_jupetta = SkySceneKit.spawn_npc("banette", 184, 408, Direction.Down, "NPC_JUPETTA")
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english=" We...[K] We've come pretty far...", french="On...[K] on est allés\nvachement loin...", german="Wir...[K] Wir sind ziemlich\nweit gekommen...", italian="Abbiamo...[K] Abbiamo fatto\nparecchia strada...", spanish=" Hemos...[K] llegado bastante lejos..."})
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english=" It's a really dark place, this is...", french="C'est vraiment sombre, ici,\nc'est...", german="Das ist wirklich ein ganz schön\ndunkler Ort...", italian=" Certo che qui è proprio buio...", spanish=" Este sitio está oscurísimo..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_sukorupi = SkySceneKit.spawn_npc("skorupi", 224, 416, Direction.Down, "NPC_SUKORUPI")
  pcall(function() UI:SetSpeaker(npc_npc_sukorupi) end)
  SkySceneKit.say({english=" Sniff...[K] Ooohh...", french=" Gloups...[K] Ooohh...", german=" Schnief...[K] Oooh...", italian=" Sniff...[K] Ooohhh...", spanish=" Jo...[K] No me mola la oscuridad..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english=" Huh?[K] What's wrong, [CS:N]Skorupi[CR]?", french=" Hein?[K] Qu'est-ce qu'y a, [CS:N]Rapion[CR]?", german="Nanu![K] Was ist passiert,\n[CS:N]Pionskora[CR]?", italian=" Eh?[K] Che succede, [CS:N]Skorupi[CR]?", spanish=" ¿Eh?[K] ¿Qué pasa, [CS:N]Skorupi[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_sukorupi) end)
  SkySceneKit.say({english="B-but...[K] This is that place that\neveryone says you're not supposed to go...", french="B-ben...[K] C'est cet endroit où\ny faut pas aller...", german="D-das hier...[K] ist der Ort, den\nman wirklich nicht betreten sollte...", italian="M-Ma...[K] Questo è il posto in cui\ntutti si raccomandano di non andare...", spanish="Pues que...[K] este es el sitio al\nque todo el mundo dice que no hay que ir."})
  pcall(function() UI:SetSpeaker(npc_npc_sukorupi) end)
  SkySceneKit.say({english="The...[K] The depths of\nthis forest...", french=" Le...[K] cœur de cette forêt...", german=" Die...[K] Die Tiefen dieses Waldes...", italian="Le...[K] Le profondità\ndella foresta...", spanish=" El...[K] El corazón del bosque..."})
  pcall(function() UI:SetSpeaker(npc_npc_sukorupi) end)
  SkySceneKit.say({english="And the rumor that there's a\nterrible monster living here...", french="Et la rumeur qui dit qu'y a\nun monstre terrifiant qui vit ici...", german="Und das Gerücht, dass hier ein\nschreckliches Monster haust...", italian="E le voci secondo cui\nci vivrebbe un orribile mostro...", spanish="Y encima se dice que aquí habita\nun monstruo horrible."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english=" What is it...", french=" Quoi encore...", german=" Was soll das...", italian=" Che ti succede...?", spanish=" Pero bueno..."})
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english="Are you suddenly afraid now that\nwe're here?[K] I've got no sympathy...", french="On vient jusqu'ici et tu\ncommences tout d'un coup à avoir\nla trouille?[K] C'est pas cool...", german="Jetzt, wo wir hier sind,\nbekommst du plötzlich Angst?[K]\nDafür habe ich kein Verständnis...", italian="Ora che siamo arrivati qui\nti è venuta improvvisamente paura?[K]\nNon credere di impietosirmi...", spanish="¿Te entra el miedo ahora que ya\nhemos llegado?[K] No hay quien te entienda."})
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english=" If you say that...", french=" A cause de toi...", german=" Aber... Schluck...", italian=" Se fai così...", spanish=" Encima, si empiezas así..."})
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english=" I-if you say that...", french=" A c-cause d-de toi...", german=" J-jetzt, wo du es sagst...", italian=" S-Se fai così...", spanish=" Si... Si dices esas cosas..."})
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english="You...[K] You're making me\nstart to feel scared...", french="Je...[K] je vais commencer à avoir\nla trouille, moi aussi...", german="Da fange...[K] fange ich auch\nplötzlich an, Angst zu haben...", italian="Comincio...[K] Comincio ad avere\npaura anch'io...", spanish="Vas...[K] Vas a conseguir que yo\ntambién me asuste..."})
  -- message_Close
  -- back_SetGround(LEVEL_D43P31A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- bgm2_PlayFadeIn(BGM_OCEAN3) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(npc_npc_jupetta, 188, 272, false, 2)
  GAME:WaitFrames(50)
  GROUND:MoveToPosition(npc_npc_sukorupi, 220, 284, false, 2)
  GAME:WaitFrames(20)
  GROUND:MoveToPosition(hero, 204, 304, false, 2)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(30)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(30)
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(40)
  GROUND:MoveToPosition(npc_npc_jupetta, 188, 180, false, 2)
  pcall(function() GAME:MoveCamera(200, 188, 60, false) end) -- performer/caméra
  GROUND:EntTurn(hero, Direction.DownLeft)
  GAME:WaitFrames(45)
  do local p=npc_npc_sukorupi.Position; GROUND:MoveToPosition(npc_npc_sukorupi, p.X+(0), p.Y+(-8), false, 1) end
  GAME:WaitFrames(5)
  GROUND:EntTurn(hero, Direction.DownRight)
  GAME:WaitFrames(35)
  GROUND:MoveToPosition(npc_npc_sukorupi, 220, 180, false, 2)
  GAME:WaitFrames(10)
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(20)
  GROUND:EntTurn(npc_npc_jupetta, Direction.UpRight)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(hero, 204, 200, false, 2)
  GAME:WaitFrames(35)
  GROUND:EntTurn(npc_npc_jupetta, Direction.UpLeft)
  GAME:WaitFrames(45)
  GROUND:EntTurn(npc_npc_jupetta, Direction.Up)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_sukorupi, Direction.UpRight)
  GAME:WaitFrames(45)
  GROUND:EntTurn(npc_npc_sukorupi, Direction.Right)
  GAME:WaitFrames(7)
  GROUND:EntTurn(npc_npc_sukorupi, Direction.DownRight)
  GAME:WaitFrames(10)
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_sukorupi, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  do local p=npc_npc_sukorupi.Position; GROUND:MoveToPosition(npc_npc_sukorupi, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=npc_npc_sukorupi.Position; GROUND:MoveToPosition(npc_npc_sukorupi, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=npc_npc_sukorupi.Position; GROUND:MoveToPosition(npc_npc_sukorupi, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=npc_npc_sukorupi.Position; GROUND:MoveToPosition(npc_npc_sukorupi, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=npc_npc_sukorupi.Position; GROUND:MoveToPosition(npc_npc_sukorupi, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=npc_npc_sukorupi.Position; GROUND:MoveToPosition(npc_npc_sukorupi, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=npc_npc_sukorupi.Position; GROUND:MoveToPosition(npc_npc_sukorupi, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=npc_npc_sukorupi.Position; GROUND:MoveToPosition(npc_npc_sukorupi, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(25)
  pcall(function() UI:SetSpeaker(npc_npc_sukorupi) end)
  SkySceneKit.say({english=" Sniff...[K] Scary...", french=" Gloups...[K] Ça craint...", german=" Schnief...[K] Wie gruselig...", italian=" Sniff...[K] Che paura...", spanish=" Buaa...[K] Tengo miedo."})
  pcall(function() UI:SetSpeaker(npc_npc_sukorupi) end)
  SkySceneKit.say({english=" There's something here, though...", french="Y'a quelque chose ici,\nje le sens...", german=" Da ist irgendetwas...", italian=" C'è qualcosa qui, lo sento...", spanish=" Creo que aquí hay algo..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_jupetta, Direction.Right)
  GAME:WaitFrames(4)
  GROUND:EntTurn(hero, Direction.UpRight)
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english=" Don't...[K] Don't say that! You!", french=" Dis...[K] dis pas ça! Idiot!", german=" Sag...[K] Sag so was nicht! Du!", italian=" S...[K] Smettila! Non ci provare!", spanish=" No...[K] ¡No digas eso!"})
  -- message_KeyWait
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english=" You coward!", french=" Trouillard!", german=" Du Feigling!", italian=" Codardo!", spanish=" ¡Eres un cobardica!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_sukorupi, Direction.Left)
  pcall(function() UI:SetSpeaker(npc_npc_sukorupi) end)
  SkySceneKit.say({english=" Wh-what is it?!", french=" T... tiens?!", german=" W-was ist es?!?", italian=" C-Come?!", spanish=" ¡¿Pero por qué dices eso?!"})
  pcall(function() UI:SetSpeaker(npc_npc_sukorupi) end)
  SkySceneKit.say({english="Now that you say it... [CS:N]Banette[CR],\nyou're really scared, aren't you!", french="Tu fais moins le malin,\nmaintenant... Tu as les chocottes aussi,\npas vrai [CS:N]Branette[CR]?", german="Jetzt, wo du es sagst... [CS:N]Banette[CR],\ndu hast auch richtig Angst, oder?", italian="Ora che ti guardo... [CS:N]Banette[CR],\nhai davvero l'aria spaventata, lo sai?!", spanish="Ahora que lo dices... [CS:N]Banette[CR],\n¡estás asustadísimo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_jupetta, "sweating", 1) end)
  GROUND:EntTurn(hero, Direction.UpLeft)
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english="S-scared?[K]\nMe...[K] Wh-what nonsense!", french="Les cho-chocottes?[K]\nMoi?[K] Ri-ridicule!", german="A-angst?[K] Ich...[K]\nW-was für ein Unsinn!", italian="S-Spaventato?[K] Io...[K]\nC-Che assurdità!", spanish="¿A... asustado?[K] ¿Yo...?[K]\n¡Me... menuda chorrada!"})
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_sukorupi) end)
  SkySceneKit.say({english=" Don't pretend to be tough!", french=" Arrête de jouer aux durs!", german="Hör auf, hier den Tapferen\nzu spielen!", italian=" Non far finta di essere forte!", spanish=" ¡Venga, no te hagas el duro!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_sukorupi) end)
  SkySceneKit.say({english="Even while you're talking, I can\nsee tears welling up in your eyes!", french="Tu dis ça, mais tu as les\nlarmes aux yeux!", german="Obwohl du etwas anderes sagst,\nsehe ich die Angst in deinen Augen!", italian="Anche se ci provi, hai gli occhi\npieni di lacrime! L'ho visto, sai?!", spanish="¡Si tienes los ojos llorosos\ny solo te falta hacer pucheros!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_jupetta, "shock", 1) end)
  GAME:WaitFrames(4)
  GROUND:EntTurn(hero, Direction.UpLeft)
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english="Gulp![K] N-no, that's not true.[K]\nThat's just not true!", french="Gloups![K] N'im... n'importe quoi.[K]\nTu délires!", german="Schluck...[K] N-nein, das stimmt\nnicht.[K] Das stimmt einfach nicht!", italian="Gulp![K] N-No, non è vero.[K]\nNon è così, ti dico!", spanish="¡Anda ya![K] No... No, mentira.[K]\n¡Mentira podrida!"})
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english=" I-I'll show you I'm not scared!", french=" T-tu vas voir si j'ai peur, moi!", german="I-ich werde euch beweisen,\ndass ich keine Angst habe!", italian="T-Ti faccio vedere io\nchi è spaventato!", spanish="Te... Te voy a demostrar\nque no tengo miedo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  GROUND:EntTurn(npc_npc_jupetta, Direction.Up)
  do local p=npc_npc_jupetta.Position; GROUND:MoveToPosition(npc_npc_jupetta, p.X+(0), p.Y+(-21), false, 2) end
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_sukorupi, Direction.UpLeft)
  GAME:WaitFrames(4)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharSetEmote(npc_npc_sukorupi, "shock", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english="Hey! Hey, you terrible monster![K]\nCan you hear me?!", french="Hé! Oh, le gros méchant\nmonstre![K] Tu m'entends?!", german="Hey! Hey, du schreckliches\nMonster![K] Hörst du mich?!?", italian="Ehi! Ehi, brutto mostro![K]\nMi senti?!", spanish="¡Eh! ¡Oye, monstruo horrible![K]\n¡¿Me oyes?!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_sukorupi, "sweating", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_sukorupi) end)
  SkySceneKit.say({english=" Wh-what?!", french=" Que... quoi?!", german=" W-was?!?", italian=" C-Cosa?!", spanish=" ¡¿Có... cómo?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english="I'm the great [CS:N]Banette[CR]![K]\nI'm an explorer!", french="Je suis le grand [CS:N]Branette[CR]![K]\nJe suis explorateur!", german="Ich bin der große [CS:N]Banette[CR]![K]\nIch bin ein Erkunder!", italian="Sono il grande esploratore\n[CS:N]Banette[CR]!", spanish="¡Soy [CS:N]Banette[CR], el explorador![K]\n¡Soy uno de los mejores!"})
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english="We've come to beat you![K] So quit\nhiding and come on out!", french="On est venus te mettre\nla pâtée![K] Alors sors de ton trou\net viens un peu par ici!", german="Wir sind gekommen, um dich zu\nschlagen![K] Also Schluss mit dem Versteckspiel!\nKomm schon raus da!", italian="Siamo venuti qui per\nsconfiggerti![K] Smettila di nasconderti\ne fatti vedere!", spanish="¡Hemos venido a vencerte![K]\n¡Más vale que salgas de tu escondrijo!"})
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  pcall(function() GAME:MoveCamera(200, 144, 60, false) end) -- performer/caméra
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_sukorupi, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(80)
  pcall(function() GAME:MoveCamera(200, 188, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(60)
  do local p=npc_npc_sukorupi.Position; GROUND:MoveToPosition(npc_npc_sukorupi, p.X+(0), p.Y+(-6), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- GAP: se_Play(8963) — id SE NDS sans portage PMDO identifié
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_sukorupi) end)
  SkySceneKit.say({english=" ...[K]It's...[K]not coming out...", french=" ...[K] Y...[K] y sort pas...", german=" ...[K]Es...[K] kommt nicht heraus...", italian=" ...[K] Non...[K] viene fuori...", spanish=" Hum...[K] Pues...[K] no sale."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english=" ...[K]Wh-what's this...[K] Not here...", french="...[K] C'est quoi, cette histoire?[K]\nPersonne...", german="...[K]W-was soll das denn...[K]\nHier ist nichts...", italian="...[K] C-Cosa succede...[K] Non c'è\nnessuno...", spanish=" Pues...[K] va a ser que...[K] no está."})
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english="I-I knew it.[K] I knew it all\nalong--from the start.", french="J-je le savais.[K] Je le savais,\ndepuis le début.", german="I-ich wusste es.[K]\nIch wusste es von Anfang an.", italian="L-Lo sapevo.[K] Lo sapevo fin\ndall'inizio.", spanish="Lo... Lo sabía.[K] Vamos, estaba\nclarísimo desde el principio."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_jupetta, Direction.DownRight)
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english="I knew that it was just a simple\nrumor, nothing more.", french="Je savais que c'était qu'une\nrumeur, rien de plus.", german="Ich wusste, dass es sich um\nnichts als ein einfaches Gerücht handelt.", italian="Lo sapevo che erano solo delle\ndicerie, niente di più.", spanish="Sabía que no era nada más que\nun rumor infundado."})
  GROUND:EntTurn(npc_npc_sukorupi, Direction.UpLeft)
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english="There was no monster here...\nThere never was one.[K] Ha ha...[K] Ha ha ha.", french="Pas de monstre à signaler...\nY'en a jamais eu.[K] Ha ha...[K] Ha ha ha.", german="Hier gibt es kein Monster...\nHier war niemals eins.[K] Haha...[K] Hahaha.", italian="Qui non c'è nessun mostro...\nNon c'è mai stato.[K] Ah ah...[K] Ah ah ah.", spanish="Aquí no hay ningún monstruo...\nNunca lo ha habido.[K] Ja, ja...[K] Ja, ja, ja."})
  pcall(function() GROUND:CharSetEmote(npc_npc_jupetta, "happy", 1) end)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_sukorupi) end)
  SkySceneKit.say({english=" I-is that so...[K] Ha ha ha ha ha.", french=" V-vraiment...?[K] Ha ha ha ha ha.", german=" I-ist das so...[K] Hahahahaha.", italian=" S-Sì, è così...[K] Ah ah ah ah ah.", spanish=" Pues vaya...[K] Je, je, je, je."})
  pcall(function() GROUND:CharSetEmote(npc_npc_sukorupi, "happy", 1) end)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Ha ha ha. ♪", french=" Ha ha ha. ♪", german=" Hahaha. ♪", italian=" Ah ah ah. ♪", spanish=" ¡Ja, ja, ja! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(60)
  pcall(function() GROUND:CharSetEmote(npc_npc_jupetta, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_sukorupi, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(40)
  GROUND:EntTurn(npc_npc_jupetta, Direction.Right)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_jupetta, Direction.UpRight)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_jupetta, Direction.Up)
  GAME:WaitFrames(45)
  GROUND:EntTurn(npc_npc_jupetta, Direction.UpRight)
  GAME:WaitFrames(45)
  GROUND:EntTurn(npc_npc_jupetta, Direction.UpLeft)
  GAME:WaitFrames(45)
  GROUND:EntTurn(npc_npc_jupetta, Direction.Up)
  GAME:WaitFrames(45)
  GROUND:EntTurn(npc_npc_jupetta, Direction.UpRight)
  GAME:WaitFrames(6)
  GROUND:EntTurn(npc_npc_jupetta, Direction.Right)
  GAME:WaitFrames(6)
  GROUND:EntTurn(npc_npc_jupetta, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english="All right.[K] I guess this\nexploration is done.", french="O.K.[K] Je pense qu'on a bouclé\nnotre exploration.", german="Nun gut.[K] Anscheinend ist diese\nErkundung damit vorüber.", italian="Bene.[K] Credo che questa\nesplorazione sia finita.", spanish="Bueno.[K] Pues supongo que esta\nexploración ya se ha acabado."})
  -- message_KeyWait
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english=" Everyone, let's go home!", french=" On rentre, les gars!", german="Alle miteinander, lasst uns nach\nHause gehen!", italian=" Forza, andiamo a casa!", spanish=" Vámonos a casa."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_sukorupi, "happy", 1) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_sukorupi) end)
  SkySceneKit.say({english=" Yeah!", french=" Ouais!", german=" Jawoll!", italian=" Sì!", spanish=" ¡Eso!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(npc_npc_sukorupi, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yeah! ♪", french=" Ouais! ♪", german=" Au fein! ♪", italian=" Sì! ♪", spanish=" ¡Eso! ♪"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(15)
  GROUND:EntTurn(npc_npc_jupetta, Direction.Down)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_sukorupi, Direction.Down)
  GAME:WaitFrames(4)
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(16), 32, false) end) -- MovePositionOffset performer/caméra
  do local p=npc_npc_jupetta.Position; GROUND:MoveToPosition(npc_npc_jupetta, p.X+(0), p.Y+(18), false, 1) end
  GAME:WaitFrames(4)
  do local p=npc_npc_sukorupi.Position; GROUND:MoveToPosition(npc_npc_sukorupi, p.X+(0), p.Y+(16), false, 1) end
  GAME:WaitFrames(4)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(14), false, 1) end
  GAME:WaitFrames(20)
  -- GAP: se_Play(9474) — id SE NDS sans portage PMDO identifié
  SkySceneKit.say({english="[CS:N]???[CR]: GARURURURURURURUHHHHH...", french="[CS:N]???[CR]: GROAOUROUROUROUROUROUROUUUUH...", german="[CS:N]???[CR]: GARURURURURURURUH...", italian="[CS:N]???[CR]: GGGRRRRRROOOAAARRRRRR...", spanish="[CS:N](?)[CR]: Groooooooooaaaaar..."}) -- message_ImitationSound (onomatopée)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitSe
  -- message_CloseEnforce
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_jupetta, Direction.DownRight)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_sukorupi, Direction.Left)
  GAME:WaitFrames(4)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english=" ...[K]Did you just hear something?", french="...[K] Dites, vous avez pas entendu\nquelque chose?", german=" ...[K]Habt ihr das auch gehört?", italian=" ...[K] Ehi, avete sentito?", spanish=" Esto...[K] ¿Habéis oído algo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_sukorupi, Direction.UpLeft)
  GAME:WaitFrames(4)
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_sukorupi) end)
  SkySceneKit.say({english="Some...[K] I think I heard some kind\nof growl...", french="Un...[K] Je crois que j'ai entendu\nun genre de grognement...", german="Ich...[K] Ich habe eine Art\nKnurren gehört...", italian="Sembrava...[K] una specie\ndi ruggito...", spanish="Creo...[K] que he oído un gruñido\no algo así..."})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  -- GAP: se_Play(9475) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  SkySceneKit.say({english="[CS:N]???[CR]: GARURURURURURURUHHHHH...", french="[CS:N]???[CR]: GROAOUROUROUROUROUROUROUUUUH...", german="[CS:N]???[CR]: GARURURURURURURUH...", italian="[CS:N]???[CR]: GGGRRRRRROOOAAARRRRRR...", spanish="[CS:N](?)[CR]: Groooooooooaaaaar..."}) -- message_ImitationSound (onomatopée)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(2) -- join WaitSe
  -- message_CloseEnforce
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(6)
  pcall(function() GROUND:CharSetEmote(npc_npc_jupetta, "shock", 1) end)
  GROUND:EntTurn(npc_npc_jupetta, Direction.Up)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharSetEmote(npc_npc_sukorupi, "shock", 1) end)
  GROUND:EntTurn(npc_npc_sukorupi, Direction.Up)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBGM("Rising Fear.ogg", true) end)
  GAME:WaitFrames(15)
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_sukorupi) end)
  SkySceneKit.say({english=" Hey, you over there!", french=" Hé, vous, là-bas!", german=" Hey, ihr dort!", italian=" Ehi, voi laggiù!", spanish=" ¡Eh, vosotros!"})
  pcall(function() UI:SetSpeaker(npc_npc_sukorupi) end)
  SkySceneKit.say({english=" Didn't you say you're an exploration team?!", french="Vous prétendez être une équipe\nd'exploration?!", german="Sagtet ihr nicht, ihr seid\nein Erkundungsteam?!?", italian="Avete detto di essere una squadra\nd'esplorazione, vero?!", spanish="¡¿No habéis dicho que sois\nun equipo explorador?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(9477) — id SE NDS sans portage PMDO identifié
  SkySceneKit.say({english="[CN]GASAGASAGASAGASAGASAGASA!!", french="[CN]GASAGASAGASAGASAGASAGASA!!", german="[CN]GASAGASAGASAGASAGASAGASA!!!", italian="[CN]GRUUUOOOOOOAAARRRRRRRRR!!!", spanish="[CN]¡¡Graaaaaaaaaaaaar!!"}) -- message_ImitationSound (onomatopée)
  GAME:WaitFrames(2) -- join WaitSe
  -- message_CloseEnforce
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_jupetta, "sweating", 1) end)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharSetEmote(npc_npc_sukorupi, "sweating", 1) end)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_jupetta.Position; GROUND:MoveToPosition(npc_npc_jupetta, p.X+(0), p.Y+(8), false, 1) end -- SlidePositionOffset
  GAME:WaitFrames(6)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_sukorupi.Position; GROUND:MoveToPosition(npc_npc_sukorupi, p.X+(0), p.Y+(6), false, 1) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english=" Ulp...[K] Waaaaahhhh...", french=" Gloups...[K] Ouaaaaah...!", german=" Urfff...[K] Waaaaah...", italian=" Gulp...[K] Uaaaaaahhh...", spanish=" Uf...[K] Aaaaaaaah..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(9475) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '3', '0')
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english=" Get out of here!", french=" Quittez ces lieux!", german=" Verschwindet!", italian=" Andatevene!", spanish=" ¡Largaos!"})
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(4)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english=" Coming in here...", french=" Oser venir ici...", german=" Hier reinzukommen...", italian=" Venire fino a qui...", spanish=" Mira que venir aquí..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(npc_npc_jupetta, "sweating", 1) end)
  GAME:WaitFrames(8)
  -- ExecuteCommon(CORO_LOOK_AROUND_FAST_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharSetEmote(npc_npc_sukorupi, "sweating", 1) end)
  GAME:WaitFrames(8)
  -- ExecuteCommon(CORO_LOOK_AROUND_FAST_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(20)
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- GAP: se_Play(9477) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(1) [neutre/état moteur]
  local npc_npc_aamarudo = SkySceneKit.spawn_npc("armaldo", 208, 112, Direction.Down, "NPC_AAMARUDO")
  -- SetAnimation(2) [anim idle native]
  GROUND:MoveToPosition(npc_npc_aamarudo, 204, 164, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_sukorupi, "shock", 1) end)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_sukorupi.Position; GROUND:MoveToPosition(npc_npc_sukorupi, p.X+(0), p.Y+(6), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharSetEmote(npc_npc_jupetta, "shock", 1) end)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_jupetta.Position; GROUND:MoveToPosition(npc_npc_jupetta, p.X+(0), p.Y+(12), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitBgm
  -- GAP: BGM BGM_THE_POWER_OF_DARKNESS non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- GAP: se_Play(9478) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(12) [anim idle native]
  GAME:WaitFrames(10)
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '2', '0')
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(16), 6, false) end) -- MovePositionOffset performer/caméra
  -- SetAnimation(5) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(18), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2)
  do local p=npc_npc_jupetta.Position; GROUND:MoveToPosition(npc_npc_jupetta, p.X+(0), p.Y+(16), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2)
  do local p=npc_npc_sukorupi.Position; GROUND:MoveToPosition(npc_npc_sukorupi, p.X+(0), p.Y+(12), false, 2) end -- SlidePositionOffset
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- camera_SetEffect(0): arrêt d'effet caméra
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="I don't know who in the world you\nthink you are!", french="Qui que vous soyez, préparez-vous à\nmordre la poussière!", german="Wer in aller Welt glaubt ihr\neigentlich zu sein?!?", italian=" Ma chi vi credete di essere?!", spanish=" ¡No sé quién narices pensáis que sois!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  -- GAP: se_Play(9479) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(9) [anim idle native]
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(25)
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  -- SetAnimation(22) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" GAOOOOOOoooooooooOOOOOOOOO!!!", french=" GRAOUUUUUUuuuuuuuuuuUUUUUUUUUUUH!!!", german=" GAOOOOOOoooooooooOOOOOOOOO!!!", italian=" GRAOOOOOOoooooooooOOOOOOOOO!!!", spanish=" ¡¡¡Gruoooooooooooorrr!!!"})
  GAME:WaitFrames(2) -- join WaitSe
  -- message_CloseEnforce
  -- camera_SetEffect(0): arrêt d'effet caméra
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_jupetta, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_sukorupi, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(15)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(npc_npc_jupetta, "sweating", 1) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_2") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english=" WAAAAaaaaaaaaahhhhh!", french=" OUAAAaaaaaaaaaah!", german=" WAAAAaaaaaaaaah!", italian=" UAAAaaaaaaaaahhh!", spanish=" ¡Aaaaaaaaaaaaah!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_sukorupi, "sweating", 1) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_sukorupi) end)
  SkySceneKit.say({english=" H-he's heeeeeerrrrrre!", french=" Il... est là!!!", german=" D-das Monnnnsssteeerrrr!", italian=" È quiiiiiiiiiiii!", spanish=" ¡Está aquíiiiiiiiiiiiiiiiiiii!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(160) end)
  -- GAP: se_Play(7430) — id SE NDS sans portage PMDO identifié
  do local p=npc_npc_jupetta.Position; GROUND:MoveToPosition(npc_npc_jupetta, p.X+(-4), p.Y+(180), false, 2) end
  GAME:WaitFrames(4)
  do local p=npc_npc_sukorupi.Position; GROUND:MoveToPosition(npc_npc_sukorupi, p.X+(4), p.Y+(180), false, 2) end
  GAME:WaitFrames(30)
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(90)
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(15)
  do local p=npc_npc_aamarudo.Position; GROUND:MoveToPosition(npc_npc_aamarudo, p.X+(0), p.Y+(12), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitBgm
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" What's this? A bunch of kids...", french="Qu'est-ce que c'est que ça?\nUne bande de gamins...", german=" Was soll das? Ein Haufen Gören...", italian=" Ma cosa...? Dei bambini...?", spanish=" ¿Pero qué es esto? Una panda de críos..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Huh? Weren't there more of you?", french=" Il en manque deux!", german=" Huch! Wart ihr nicht gerade noch mehr?", italian=" Beh, per fortuna se ne sono andati...", spanish=" ¿Eh? ¿No había nadie más?"})
  -- message_KeyWait
  GAME:WaitFrames(8)
  GROUND:EntTurn(hero, Direction.Up)
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="You too, Junior![K] You better run\naway quick!", french="Toi aussi, petit![K] Je te conseille de fuir\nle plus vite possible!", german="Auch du, Junior![K]\nLauf besser schnell davon!", italian="Ehi, piccolo![K] Faresti meglio a dartela\na gambe anche tu!", spanish="¡Tú también, chaval![K] ¡Será mejor que\ncorras!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_aamarudo.Position; GROUND:MoveToPosition(npc_npc_aamarudo, p.X+(0), p.Y+(10), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  -- GAP: se_Play(9479) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(9) [anim idle native]
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(25)
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  -- SetAnimation(22) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" GAAAOOOOOOOoooooooooOOOOOOOOO!!!", french=" GRAOUUUUUUuuuuuuuuuuUUUUUUUUUUUH!!!", german=" GAAAOOOOOOOoooooooooOOOOOOOOO!!!", italian=" GRAAAOOOOOOOoooooooooOOOOOOOOO!!!", spanish=" ¡¡¡Graaaaaaaaaaaaaaaaaaar!!!"})
  GAME:WaitFrames(2) -- join WaitSe
  -- message_CloseEnforce
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(30)
  -- GAP: se_Play(9478) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(12) [anim idle native]
  GAME:WaitFrames(10)
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="If you stay here, something bad\nwill happen!", french="Si tu restes ici, tu vas avoir de\ngros problèmes!", german="Wenn du hierbleibst, wird etwas\nSchlimmes passieren!", italian="Se rimani qui, ti accadrà qualcosa\ndi brutto!", spanish="¡Si te quedas, va a pasar algo muy,\npero que muy malo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(9479) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(9) [anim idle native]
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(25)
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  -- SetAnimation(22) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" GAOOOOOOoooooooooooOOOOOOO!!!", french=" GRAOUUUUUUuuuuuuuuuuUUUUUUUUUUUH!!!", german=" GAOOOOOOoooooooooooOOOOOOO!!!", italian=" GRAOOOOOOoooooooooooOOOOOOO!!!", spanish=" ¡¡¡Grooooooooooooor!!!"})
  GAME:WaitFrames(2) -- join WaitSe
  -- message_CloseEnforce
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" ...[K]Hey, mister.", french=" ...[K] Hé, m'sieur.", german=" ...[K]Entschuldigung, Onkel.", italian=" ...[K] Ehi, signore.", spanish=" Esto...[K] Oye, señor."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="What are you doing\nhere, mister?", french=" Vous faites quoi ici, m'sieur?", german=" Was machst du hier, Onkel?", italian=" Che ci fai qui, signore?", spanish=" ¿Qué es lo que haces aquí?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_aamarudo, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="Aren't...[K] Aren't you scared?[K]\nAren't you scared of me?!", french="Mais tu...[K] tu n'as pas peur?[K]\nTu n'as pas peur de moi?!", german="Hast du...[K] Hast du etwa keine Angst?[K]\nHast du keine Angst vor mir?!?", italian="Non...[K] Non sei spaventato?[K]\nNon hai paura di me?!", spanish="Pero...[K] ¿No tienes miedo?[K]\n¡¿Es que no te doy miedo?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBGM("Guildmaster Wigglytuff.ogg", true) end)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Nope. ♪ Not scared! ♪", french=" Ben nan. ♪ Pas peur! ♪", german=" Nein. ♪ Keine Angst! ♪", italian=" No. ♪ Per niente! ♪", spanish=" Pues no. ♪ ¡Nada de miedo! ♪"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="So what are you doing here\nanyway, mister?", french="Alors, vous faites quoi ici,\nm'sieur?", german="Aber was machst du denn\nhier, Onkel?", italian=" Allora? Che ci fai qui, signore?", spanish=" Pues eso, ¿qué haces aquí?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_aamarudo, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" He...[K]he's a strange little fellow...", french=" Quel...[K] quel drôle de petit bonhomme...", german="Was...[K] Was für ein eigenartiger\nkleiner Geselle...", italian=" Che...[K] tipetto strano...", spanish=" Es...[K] Es un chavalín bastante raro..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-12), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(4) [anim idle native]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Hey, tell me?[K] Tell, tell...", french="Hein, alors?[K]\nDites-moi, hein, dites...", german=" Nun sag schon![K] Sag, sag...", italian=" Ehi, me lo dici?[K] Dai, dai, dai...", spanish=" Venga, cuéntamelo...[K] Porfi, vaa..."})
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(4) [anim idle native]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" I told you to go home!", french=" Je t'ai dit de rentrer chez toi!", german="Ich habe dir doch gesagt,\ndu sollst nach Hause gehen!", italian=" Ti ho detto di andare a casa!", spanish=" ¡Te he dicho que te vayas a casa!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-12), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(4)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-12), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(4) [anim idle native]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="If you answer me, I'll go home.[K]\nAnswer, answer...", french="Si vous me répondez, je rentre.[K]\nAlors, vous me dites, hein, dites-moi, dites...", german="Wenn du mir antwortest, geh ich\nauch.[K] Antworte, antworte...", italian="Se me lo dici, me ne torno\na casa.[K] Dimmelo, dimmelo, dimmelo...", spanish="Si me respondes me iré a casa.[K]\nPorfi, respóndeme..."})
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(4) [anim idle native]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" No way! Go home!", french=" Pas question! Rentre chez toi!", german=" Auf keinen Fall! Verschwinde!", italian=" No! Vattene!", spanish=" ¡Que no! ¡Vete a casa!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="A short answer is fine.[K]\nFinally fine.", french="Juste une p'tite réponse.[K]\nUne toute p'tite, hein, dites, hein,\nvous me dites...?", german="Eine kurze Antwort reicht\nschon.[K] Reicht reichlich.", italian="Mi bastano due parole.[K]\nGiurin giurello.", spanish="Una respuesta cortita me sirve.[K]\nDe verdad de la buena."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_aamarudo, "sweating", 1) end)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_aamarudo.Position; GROUND:MoveToPosition(npc_npc_aamarudo, p.X+(0), p.Y+(-8), false, 1) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Ugh...[K] You're persistent...", french=" Arf...[K] Tu es têtu...", german=" Hmm...[K] Du lässt nicht locker...", italian=" Urgh...[K] Quanto sei testardo...", spanish=" Uf...[K] Eres insistente..."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="...[K]I guess I've got no choice. I'll tell\nyou a little.", french="...[K] Je pense que je n'ai pas le choix.\nJe vais te raconter un peu.", german="...[K]Nun gut, anscheinend habe ich keine\nWahl. Ich werde dir von mir erzählen.", italian="...[K] Immagino di non avere scelta...\nE va bene, te lo dirò.", spanish="Bueno...[K] Supongo que no me queda otro\nremedio. Voy a contarte una cosilla."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Come with me.", french=" Suis-moi.", german=" Komm mit.", italian=" Vieni con me.", spanish=" Ven conmigo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_aamarudo, 204, 112, false, 2)
  GAME:WaitFrames(20)
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yay! ♪", french=" Youhou! ♪", german=" Au ja! ♪", italian=" Urrà! ♪", spanish=" ¡Yupi! ♪"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_Close
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  GROUND:MoveToPosition(hero, 204, 112, false, 2)
  GAME:WaitFrames(40)
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
end
