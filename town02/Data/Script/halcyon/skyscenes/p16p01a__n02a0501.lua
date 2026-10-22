-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P16P01A/n02a0501.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SV.SkyScenarioSide = {main=41, sub=4} -- $SCENARIO_SIDE = scn[41,4] (ROM)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V24P08A) [décor sub chargé: Sub_v24p08a]
  -- back_SetGround(LEVEL_P16P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 19, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  SkySubScreen.Show("v24p08a", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  local npc_npc_muchuuru = SkySceneKit.spawn_npc("smoochum", 216, 168, Direction.Up, "NPC_MUCHUURU")
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_upaa = SkySceneKit.spawn_npc("wooper", 184, 168, Direction.UpRight, "NPC_UPAA")
  pcall(function() GROUND:CharSetEmote(npc_npc_upaa, "shock", 1) end)
  local npc_npc_subomii = SkySceneKit.spawn_npc("budew", 248, 168, Direction.UpLeft, "NPC_SUBOMII")
  pcall(function() GROUND:CharSetEmote(npc_npc_subomii, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_muchuuru) end)
  SkySceneKit.say({english=" Huh?!", french=" Hein?!", german=" Hmmm?!?", italian=" Uh?!", spanish=" ¡¿Eh?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_upaa) end)
  SkySceneKit.say({english=" You want to play explorers?!", french="Vous voulez jouer\naux explorateurs?!", german=" Ihr wollt Erkunder spielen?!?", italian=" Vuoi giocare agli esploratori?!", spanish=" ¡¿Que queréis jugar a explorar?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_jupetta = SkySceneKit.spawn_npc("banette", 216, 144, Direction.Down, "NPC_JUPETTA")
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english=" Yeah, let's play explorers.", french=" Ouais, jouons aux explorateurs!", german="Ja genau, lasst uns gemeinsam\nErkunder spielen!", italian=" Sì, giochiamo agli esploratori.", spanish=" Eso, vamos a jugar a explorar."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_sukorupi = SkySceneKit.spawn_npc("skorupi", 248, 144, Direction.Down, "NPC_SUKORUPI")
  GROUND:EntTurn(npc_npc_sukorupi, Direction.DownLeft)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_muchuuru, Direction.UpRight)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_subomii, Direction.Up)
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_sukorupi) end)
  SkySceneKit.say({english="We want to become an\nexploration team in the future...", french="Plus tard, on veut devenir une\néquipe d'exploration...", german="Wir wollen in der Zukunft ein\nErkundungsteam gründen.", italian="Se in futuro vogliamo creare\nuna squadra d'esplorazione...", spanish="De mayores queremos formar un\nequipo explorador..."})
  pcall(function() UI:SetSpeaker(npc_npc_sukorupi) end)
  SkySceneKit.say({english="So we should go out and explore\nunknown areas![K] What do you think?\nIt's great, right?", french="Alors on devrait partir explorer\ndes endroits inconnus![K] Vous en dites quoi?\nCe serait cool, non?", german="Also sollten wir trainieren und\nunerforschte Gebiete erkunden![K] Was meint\nihr? Tolle Idee, nicht wahr?", italian="... allora dobbiamo andare in giro\na scoprire luoghi inesplorati![K] Che ne dite?\nNon è grandioso?", spanish="Así que deberíamos explorar\nsitios desconocidos.[K] ¿Qué os parece?\n¿A que mola?"})
  pcall(function() GROUND:CharSetEmote(npc_npc_sukorupi, "happy", 1) end)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(npc_npc_sukorupi, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(15)
  GROUND:EntTurn(npc_npc_subomii, Direction.UpLeft)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_muchuuru, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_subomii) end)
  SkySceneKit.say({english="So...[K] This unknown place...[K]\nWhere are we going?", french="Mais alors...[K] Un endroit\ninconnu...[K] C'est où, ça?", german="Aha...[K] Ein unerforschtes Gebiet...[K]\nWohin soll es denn gehen?", italian="Allora...[K] questo luogo\ninesplorato...[K] Dove dovremmo andare?", spanish="Y...[K] ese sitio desconocido que queréis\nexplorar,[K] ¿dónde está?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_jupetta, Direction.DownRight)
  GAME:WaitFrames(2)
  GROUND:EntTurn(npc_npc_sukorupi, Direction.Down)
  GAME:WaitFrames(3)
  GROUND:EntTurn(npc_npc_upaa, Direction.Right)
  GAME:WaitFrames(2)
  GROUND:EntTurn(npc_npc_muchuuru, Direction.Right)
  GAME:WaitFrames(3)
  GROUND:EntTurn(hero, Direction.Left)
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english="Hmm. That's a good question.[K]\nYou'd make a good apprentice explorer, [CS:N]Budew[CR].", french="Mmh. Bonne question.[K]\nTu ferais une super apprentie exploratrice,\n[CS:N]Rozbouton[CR].", german="Hmm. Das ist eine gute Frage.[K]\nDu würdest wirklich einen guten Erkunder-\nLehrling abgeben, [CS:N]Knospi[CR].", italian="Uhm. Ottima domanda.[K] Saresti\nuna bravissima apprendista esploratrice,\n[CS:N]Budew[CR].", spanish="Hum, buena pregunta.[K] Creo que serías\nuna gran exploradora, [CS:N]Budew[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english="We decided on a place...[K]\n[CS:P]Murky Forest[CR].", french="On a déjà choisi l'endroit...[K]\nLa [CS:P]Forêt Glauque[CR].", german="Wir haben uns bereits für einen\nOrt entschieden...[K] Den [CS:P]Trübwald[CR].", italian="Conosciamo noi il posto giusto...[K]\nLa [CS:P]Foresta Tenebrosa[CR].", spanish="Nos hemos decidido por...[K]\nel [CS:P]Bosque Oscuro[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GROUND:EntTurn(npc_npc_muchuuru, Direction.Up)
  pcall(function() GROUND:CharSetEmote(npc_npc_muchuuru, "shock", 1) end)
  GAME:WaitFrames(2)
  GROUND:EntTurn(npc_npc_upaa, Direction.UpRight)
  pcall(function() GROUND:CharSetEmote(npc_npc_upaa, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: BGM BGM_MURKY_FOREST non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() UI:SetSpeaker(npc_npc_upaa) end)
  SkySceneKit.say({english="Whaat?[K]\n[CS:P]M[CR]...[K][CS:P]Murky Forest[CR]? Is that what you said?", french="Heiiin?[K]\nLa [CS:P]Fo[CR]... [K][CS:P]Forêt Glauque[CR]? C'est ce que tu as dit?", german="Waaas?[K]\n[CS:P]T-[CR][K][CS:P]Trübwald[CR]? Habe ich richtig gehört?", italian="Cooosa?[K]\nL-La [CS:P]F[CR]...[K] [CS:P]Foresta Tenebrosa[CR]?\nState dicendo sul serio?", spanish="¿Quée?[K] ¿El [CS:P]Bos[CR]...[K] [CS:P]Bosque Oscuro[CR]?\n¿Has dicho eso?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_jupetta, Direction.Down)
  GAME:WaitFrames(3)
  GROUND:EntTurn(npc_npc_sukorupi, Direction.DownLeft)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_subomii, Direction.Left)
  GAME:WaitFrames(3)
  GROUND:EntTurn(npc_npc_upaa, Direction.Right)
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_muchuuru) end)
  SkySceneKit.say({english="Smooches! No way!\nI don't want to!", french="Smack! Pas question!\nJe veux pas!", german="Knutsch! Ohne mich! Das will\nich nicht!", italian="Smooches! No e no!\nNon ci penso nemmeno!", spanish="¡Qué dices, ni hablar!\n¡No me da la gana!"})
  pcall(function() UI:SetSpeaker(npc_npc_muchuuru) end)
  SkySceneKit.say({english="Going to that forest is not\nallowed at all! My mommy even said so!", french="On a pas le droit d'aller dans\ncette forêt! Ma maman m'a toujours dit ça!", german="Es ist streng verboten, diesen\nWald zu betreten! Das hat mir meine Mami\ngesagt!", italian="È assolutamente vietato\nandare in quella foresta. La mia mamma\nme lo dice sempre!", spanish="¡Tengo prohibidísimo ir a ese\nbosque! ¡Mi mami me lo dijo bien clarito!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_subomii, Direction.UpLeft)
  pcall(function() UI:SetSpeaker(npc_npc_subomii) end)
  SkySceneKit.say({english="There's even a rumor that\na big, scary monster lives in the forest!", french="Même qu'y a une rumeur qui dit\nqu'un gros méchant monstre habite là-bas!", german="Es geht sogar das Gerücht um,\ndass ein großes, furchteinflößendes Monster\nin dem Wald haust!", italian="E poi gira voce che in quella\nforesta ci sia un mostro terribile!", spanish="¡Hasta corre el rumor de que\nun monstruo grande y feo vive en el bosque!"})
  pcall(function() UI:SetSpeaker(npc_npc_subomii) end)
  SkySceneKit.say({english=" Why do you want to go there?", french=" Pourquoi tu veux y aller?", german=" Warum wollt ihr dorthin gehen?", italian=" Perché volete andare laggiù?", spanish=" ¿Por qué queréis ir ahí?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_jupetta, Direction.DownRight)
  GAME:WaitFrames(3)
  GROUND:EntTurn(npc_npc_sukorupi, Direction.Down)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_upaa, Direction.UpRight)
  GAME:WaitFrames(3)
  GROUND:EntTurn(hero, Direction.UpLeft)
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english="Doesn't it seem like the type of\nplace that exploration teams would go?", french="Ben, c'est le genre d'endroit où\nva une équipe d'exploration, non?", german="Denkst du nicht auch, dass\nErkundungsteams gerade einen solchen Ort\nbesuchen würden?", italian="Beh, mi pare il posto perfetto\nda visitare per una squadra d'esplorazione...", spanish="¿No suena como el típico sitio\nal que iría un equipo explorador?"})
  -- message_KeyWait
  GROUND:EntTurn(npc_npc_jupetta, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english="Don't tell me...[K] Does\nthat mean that you're scared to go?", french="Me dites pas que...[K] vous avez\nles chocottes d'y aller?", german="Aber nun sagt bloß...[K] Bedeutet\ndas etwa, dass ihr Angst habt, dorthin\nmitzukommen?", italian="Ora ho capito...[K] Avete paura\ndi andare laggiù, vero?", spanish="No me digas...[K] ¿Me estás diciendo\nque te da miedo ir?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_muchuuru) end)
  SkySceneKit.say({english=" N-no...[K] I'm not scared!", french="N'im... n'importe quoi...[K]\nJ'ai pas les chocottes!", german=" N-nein...[K] Ich habe keine Angst!", italian=" N-No...[K] Non ho paura!", spanish=" No, no...[K] ¡Qué voy a tener miedo!"})
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_subomii, Direction.Left)
  GAME:WaitFrames(3)
  GROUND:EntTurn(npc_npc_sukorupi, Direction.DownLeft)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_upaa, Direction.Right)
  GAME:WaitFrames(3)
  GROUND:EntTurn(hero, Direction.Left)
  pcall(function() UI:SetSpeaker(npc_npc_muchuuru) end)
  SkySceneKit.say({english="It's just that you shouldn't go\nplaces you've been told not to go!", french="C'est juste que d'aller dans des\nendroits où on nous a dit qu'y fallait pas\naller, c'est pas bien!", german="Es ist nur, dass man sich nicht\nan Orte begeben sollte, die einem verboten\nworden sind!", italian="È solo che non dovremmo\ndisubbidire ai nostri genitori quando\nci vietano di andare da qualche parte!", spanish="Es que no hay que ir a sitios\ndonde te han dicho que no vayas."})
  pcall(function() UI:SetSpeaker(npc_npc_muchuuru) end)
  SkySceneKit.say({english=" I-I don't like it! I'm not going!", french="J-j'aime pas ça!\nMoi, j'y vais pas!", german="D-das mag ich nicht! Ihr könnt\nallein gehen!", italian="N-Non me la sento!\nIo non vengo!", spanish=" No me gusta, yo paso de ir."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_muchuuru, 212, 288, false, 2)
  GAME:WaitFrames(10)
  GROUND:EntTurn(npc_npc_upaa, Direction.Down)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_subomii, Direction.Down)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_sukorupi, Direction.Down)
  GAME:WaitFrames(4)
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(80)
  GROUND:EntTurn(npc_npc_upaa, Direction.UpRight)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_subomii, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GROUND:EntTurn(npc_npc_sukorupi, Direction.DownLeft)
  GAME:WaitFrames(4)
  GROUND:EntTurn(hero, Direction.Left)
  pcall(function() UI:SetSpeaker(npc_npc_upaa) end)
  SkySceneKit.say({english="M-me neither. I'm staying\nout of it...", french="M-moi non plus. Sans moi,\nles gars...", german="I-ich auch nicht. Ich halte mich\nda lieber raus...", italian="N-Nemmeno io. Non contate\nsu di me...", spanish=" Yo también paso..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_subomii) end)
  SkySceneKit.say({english=" Same here!", french=" Pareil!", german=" Dasselbe gilt für mich!", italian=" Io nemmeno!", spanish=" ¡Lo mismo digo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_upaa, 184, 284, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(npc_npc_subomii, 244, 288, false, 2)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_jupetta, Direction.Down)
  GAME:WaitFrames(4)
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_sukorupi, Direction.Down)
  GAME:WaitFrames(100)
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english="What's this?[K] They're all a bunch\nof cowards.", french=" Oh là là...[K] Les poules mouillées!", german="Wie bitte?[K] Was für ein\nschöner Haufen Feiglinge!", italian="Ma guardali![K] Sono solo un branco\ndi fifoni.", spanish="¿Pero cómo es posible?[K] Son todos\nuna panda de cobardicas."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_jupetta, Direction.Right)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_sukorupi, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english="They're scared and making up\nall these lame excuses. It's pathetic.", french="Ils ont la trouille, alors ils\ninventent des excuses bidon. C'est pathétique.", german="Haben vor Angst die Hosen voll\nund kommen dann mit diesen peinlichen\nEntschuldigungen... Das ist doch lächerlich!", italian="Hanno paura e allora si inventano\nun sacco di scuse per non venire. È ridicolo!", spanish="Lo que pasa es que se inventan\nexcusas para no admitir que les da miedo.\nEs patético."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.UpLeft)
  pcall(function() UI:SetSpeaker(npc_npc_sukorupi) end)
  SkySceneKit.say({english="I doubt they'll ever be a real\nexploration team when they grow up.\nNot at all likely.", french="Ça m'étonnerait qu'ils\ndeviennent une vraie équipe d'exploration\nun jour, franchement.", german="Sie werden wohl kaum ein echtes\nErkundungsteam werden, wenn sie mal groß\nsind. Mit dieser Einstellung wird das nichts...", italian="Dubito che faranno parte di una\nvera squadra d'esplorazione quando saranno\ngrandi. Non ce la farebbero mai.", spanish="No creo que nunca puedan formar\nun auténtico equipo explorador. Mal lo tienen."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(150) end)
  GROUND:MoveToPosition(hero, 228, 164, false, 2)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Hey, what's an exploration team?", french="Hé, c'est quoi une équipe\nd'exploration?", german="Hey, was ist eigentlich\nein Erkundungsteam?", italian="Ehi, che cos'è una squadra\nd'esplorazione?", spanish=" Oye, ¿qué es un equipo explorador?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_jupetta, Direction.Down)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_sukorupi, Direction.Down)
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english="What?![K] You don't know what an\nexploration team is?", french="Quoi?![K] Tu sais pas ce que c'est,\nune équipe d'exploration?", german="Wie bitte?!?[K] Du weißt nicht\neinmal, was ein Erkundungsteam ist?", italian="Come?![K] Non sai che cos'è\nuna squadra d'esplorazione?", spanish="¡¿Qué?![K] ¿Que no sabes lo que es\nun equipo explorador?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Nope. ♪", french=" Ben nan. ♪", german=" Öh, nein. ♪", italian=" No. ♪", spanish=" Pues no. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english="But you're still here, so that\nmeans...[K] That means you've got the courage?", french="Mais quand même, t'es resté\nlà...[K] Ça veut peut-être dire que t'as du cran.", german="Aber du bist immer noch hier...[K]\nHeißt das, dass du mutig genug bist?", italian="Ma tu sei ancora qui, quindi...[K]\nSignifica che hai coraggio, piccolo.", spanish="Pero sigues aquí, así que eso\nsignifica...[K] ¿que tienes valor para ir?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yep. I do. ♪", french=" Voui. Bien sûr. ♪", german=" Ja, genau. ♪", italian=" Eccome. ♪", spanish=" Pues sí, eso mismo. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(15)
  GROUND:EntTurn(npc_npc_jupetta, Direction.Right)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_sukorupi, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_jupetta, "sweatdrop", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_sukorupi, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  GROUND:EntTurn(npc_npc_jupetta, Direction.Down)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_sukorupi, Direction.Down)
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english="...[K]All right.[K]\nYou'll do. Come along.", french="...[K] D'acc.[K]\nOn fera avec. Viens avec nous.", german="...[K]Okay.[K]\nNa, dann lass uns gehen.", italian="...[K] E va bene.[K]\nLo vedremo. Vieni con noi.", spanish="Hum...[K] Pues vale.[K] No nos vendrás\nmal, así que te dejamos que vengas."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yay, thanks! Friends. ♪", french="Youhou, merci!\nCopains de moi. ♪", german=" Au ja, super! Meine Freunde. ♪", italian=" Evviva! Grazie amici! ♪", spanish=" ¡Yupi! Gracias, amigos. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(10)
  -- GAP: BGM BGM_A_FUN_EXPLORATION non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english=" All right![K] Everyone, line up!", french="Très bien![K]\nEn formation, les gars!", german="Also gut![K] Alle zusammen,\nAufstellung einnehmen!", italian=" Ok![K] Tutti in riga!", spanish=" ¡De acuerdo![K] ¡Todos a formar!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(hero, 212, 168, false, 2)
  GAME:WaitFrames(4)
  GROUND:MoveToPosition(npc_npc_sukorupi, 244, 168, false, 2)
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(npc_npc_sukorupi, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(npc_npc_jupetta, 228, 140, false, 2)
  GROUND:EntTurn(npc_npc_jupetta, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english="All right.[K] From now on, we're an\nexploration team headed for [CS:P]Murky Forest[CR].", french="O.K.[K] A partir de maintenant,\non est une équipe d'exploration en route\npour la [CS:P]Forêt Glauque[CR].", german="Sehr gut.[K] Ab jetzt sind wir ein\nErkundungsteam auf dem Weg zum [CS:P]Trübwald[CR].", italian="Bene.[K] Da adesso in poi, siamo\nuna squadra d'esplorazione diretta\nalla [CS:P]Foresta Tenebrosa[CR].", spanish="Muy bien.[K] A partir de ahora somos\nun equipo explorador que va al [CS:P]Bosque Oscuro[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english="Gather up your courage and\nlet's go!", french="On rassemble son courage,\net en avant!", german="Nehmt allen Mut zusammen und\nschon kann es losgehen!", italian="Andiamo! Facciamo vedere\nquanto siamo coraggiosi!", spanish=" ¡Armaos de valor, que allá vamos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
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
  SkySceneKit.say({english=" Yeah. ♪", french=" Ouais. ♪", german=" Juchhu. ♪", italian=" Sì. ♪", spanish=" Eso. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(20)
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english=" Yay![K] Yay!", french=" Yahou![K] Youhou!", german=" Ja![K] Ja!", italian=" Forza![K] Forza!", spanish=" ¡Bien![K] ¡Yupi!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english=" Oooooh!", french=" Oooooh!", german=" Oooooh!", italian=" Ooooooh!", spanish=" ¡Cómo va a molar!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_sukorupi, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_sukorupi) end)
  SkySceneKit.say({english=" OOoooohhhh!", french=" OOooooooh!", german=" Ooooooh!", italian=" OOOooohhh!", spanish=" ¡Vamos ya, que no aguanto más!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(24) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" OOOhhhhh! ♪", french=" OOOoooh. ♪", german=" Oooh! ♪", italian=" OOOhhh! ♪", spanish=" ¡En marcha, amigos! ♪"})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(60) end)
  SkySubScreen.Hide(60) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 60)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[128] = 1 -- dungeon_mode(128) = DMODE_OPEN (ROM)
  -- main_EnterDungeon(128, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(main_EnterAdventure(250, 30)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
