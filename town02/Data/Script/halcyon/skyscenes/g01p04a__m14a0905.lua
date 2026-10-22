-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/m14a0905.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_G01P04A) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_G01P04A, 'UM14') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(5) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- supervision_Acting(2) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 432, 216, Direction.DownRight, "NPC_PERAPPU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 480, 216, Direction.Down, "NPC_PUKURIN")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 360, 256, Direction.Right, "NPC_GUREGGURU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yep, that's right. No mistake.", french=" Oui, c'est bien ça.", german=" Ja, das stimmt. Ganz richtig.", italian=" Sì. È così. ", spanish=" Exacto."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Yes, there's no mistake.", french=" Oui, c'est bien ça.", german=" Ja, das ist ganz richtig.", italian=" Sì. È così. ", spanish=" Exacto."})
  else
  SkySceneKit.say({english=" Yes, you're not mistaken.", french=" Oui, c'est bien ça.", german=" Ja, das ist richtig.", italian=" Sì. È così. ", spanish=" Exacto."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(4, -3) [neutre/état moteur]
  local npc_npc_yonowaaru = SkySceneKit.spawn_npc("dusknoir", 400, 232, Direction.DownRight, "NPC_YONOWAARU")
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" But the name [CS:N]Azelf[CR]...?", french=" Et le nom de [CS:N]Créfadet[CR]...?", german=" Aber [CS:N]Tobutz[CR]?", italian="In quell'occasione, ha forse\nnominato [CS:N]Azelf[CR]?", spanish=" ¿Pero el nombre de [CS:N]Azelf[CR]...?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I've never heard it before.", french=" Jamais entendu parler.", german="Diesen Namen habe ich noch nie\ngehört.", italian="No. Non l'avevo mai sentito\nprima.", spanish=" Nunca lo había oído."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I've never heard it before.", french=" Jamais entendu parler.", german="Diesen Namen habe ich noch nie\ngehört.", italian="No. Non l'avevo mai sentito\nprima.", spanish=" Nunca lo había oído."})
  else
  SkySceneKit.say({english=" I've never heard it before.", french=" Jamais entendu parler.", german="Diesen Namen habe ich noch nie\ngehört.", italian="No. Non l'avevo mai sentito\nprima.", spanish=" Nunca lo había oído."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I mean, I only know the name\n[CS:N]Azelf[CR] because you just said it, [CS:N]Dusknoir[CR], sir.", french="Enfin, je ne connais ce nom\nque parce que vous venez de le mentionner,\nmessire [CS:N]Noctunoir[CR].", german="Ich meine, ich kenne den Namen\n[CS:N]Tobutz[CR] erst, seitdem du ihn uns gesagt hast,\n[CS:N]Zwirrfinst[CR].", italian="Ho sentito il nome di [CS:N]Azelf[CR] per\nla prima volta da lei, signor [CS:N]Dusknoir[CR]!", spanish="Quiero decir que solo conozco\nel nombre de [CS:N]Azelf[CR] porque tú lo dijiste,\n[CS:N]Dusknoir[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="The name [CS:N]Azelf[CR] is new to me.\nI only heard it today from you, [CS:N]Dusknoir[CR], sir.", french="Enfin, je ne connais ce nom\nque parce que vous venez de le mentionner,\nmessire [CS:N]Noctunoir[CR].", german="Der Name [CS:N]Tobutz[CR] ist mir neu.\nIch habe ihn erst heute von dir erfahren,\n[CS:N]Zwirrfinst[CR].", italian="Ho sentito il nome di [CS:N]Azelf[CR] per\nla prima volta da lei, signor [CS:N]Dusknoir[CR]!", spanish="Quiero decir que solo conozco\nel nombre de [CS:N]Azelf[CR] porque tú lo dijiste,\n[CS:N]Dusknoir[CR]."})
  else
  SkySceneKit.say({english="I mean, I only know the name\n[CS:N]Azelf[CR] because you just said it, [CS:N]Dusknoir[CR], sir.", french="Enfin, je ne connais ce nom\nque parce que vous venez de le mentionner,\nmessire [CS:N]Noctunoir[CR].", german="Ich kenne den Namen [CS:N]Tobutz[CR]\nerst, seitdem du ihn uns gesagt hast,\n[CS:N]Zwirrfinst[CR].", italian="Ho sentito il nome di [CS:N]Azelf[CR] per\nla prima volta da lei, signor [CS:N]Dusknoir[CR]!", spanish="Quiero decir que solo conozco\nel nombre de [CS:N]Azelf[CR] porque tú lo dijiste,\n[CS:N]Dusknoir[CR]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8965) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(4, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Then there's still a chance!", french=" Alors tout n'est pas perdu!", german=" Dann gibt es noch eine Chance!", italian="In questo caso, esiste ancora una\nsperanza!", spanish="¡Entonces todavía tenemos\nuna oportunidad!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_perappu, Direction.DownLeft)
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 448, 256, Direction.DownRight, "NPC_KIMAWARI")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_yonowaaru, 4) end)
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 448, 272, Direction.Right, "NPC_DIGUDA")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_yonowaaru, 4) end)
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 464, 232, Direction.Down, "NPC_BIPPA")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_yonowaaru, 4) end)
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 424, 272, Direction.Right, "NPC_DOGOOMU")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_yonowaaru, 4) end)
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 392, 256, Direction.Right, "NPC_CHIRIIN")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_yonowaaru, 4) end)
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 392, 272, Direction.Right, "NPC_HEIGANI")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_yonowaaru, 4) end)
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 360, 272, Direction.Right, "NPC_DAGUTORIO")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, npc_npc_yonowaaru, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="If [CS:N]Mesprit[CR] claimed that [CS:N]Azelf[CR]\nhad alerted her about the stolen Time Gear...", french="Si [CS:N]Créfollet[CR] a affirmé que\n[CS:N]Créfadet[CR] avait donné l'alerte...", german="Hätte [CS:N]Vesprit[CR] gesagt, dass es\ndurch [CS:N]Tobutz[CR] von dem gestohlenen Zahnrad der\nZeit erfahren habe...", italian="Se [CS:N]Mesprit[CR] avesse detto di\nessere stata avvertita da [CS:N]Azelf[CR] del furto\ndell'Ingranaggio del Tempo...", spanish="Si [CS:N]Mesprit[CR] hubiera dicho que\n[CS:N]Azelf[CR] la había alertado sobre el robo de\nsu Engranaje del Tiempo..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Then [hero]'s Dimensional\nScream would surely be from the past...", french="Alors la vision de [hero]\nviendrait sans doute du passé...", german="Dann käme der Dimensionale\nSchrei von [hero] mit Sicherheit aus\nder Vergangenheit...", italian="... allora la visione scatenata\ndallo Squarcio Dimensionale di [hero]\nsarebbe certamente riferita al passato...", spanish="Entonces, la visión que\n[hero] tuvo con la Percepción de\nCronos tendría que ser del pasado..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" But that was not the case.", french=" Mais ce n'est pas le cas.", german=" Aber das hat es nicht gesagt.", italian=" Ma non è andata così.", spanish=" Pero no fue así."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="[CS:N]Mesprit[CR] did not mention\n[CS:N]Azelf[CR]...[K] Therefore...", french="[CS:N]Créfollet[CR] n'a pas évoqué\n[CS:N]Créfadet[CR]...[K] Par conséquent...", german="[CS:N]Vesprit[CR] hat [CS:N]Tobutz[CR] nicht\nerwähnt...[K] Hmm...", italian="[CS:N]Mesprit[CR] non ha parlato di\n[CS:N]Azelf[CR].", spanish="[CS:N]Mesprit[CR] no mencionó a [CS:N]Azelf[CR]...[K]\nPor tanto..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="It's possible that the event\nhappens in the future!", french="Il se peut que la vision concerne\nun événement à venir!", german="Es ist also möglich, dass das\nEreignis erst in der Zukunft geschieht!", italian="Pertanto è possibile che\nquell'avvenimento non sia ancora accaduto!", spanish="¡Es posible que esos hechos\nsucedan en el futuro!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" I see...", french=" Je vois...", german=" Ich verstehe...", italian=" Ha ragione...", spanish=" Ya entiendo..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(4, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="One more point.[K] And this is a\nsure thing.", french="Autre chose.[K] Une chose dont\nnous avons la certitude.", german="Da ist noch eine Sache.[K] Und die\nist ganz eindeutig.", italian=" Un'altra cosa.[K] E questo è certo.", spanish=" Una cosa más.[K] Y esto es seguro."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Upon touching the crystal,\n[hero] experienced the Dimensional\nScream.", french="En touchant le cristal, le Cri\nDimensionnel de [hero] s'est déclenché.", german="Der Kristall hat bei\n[hero] den Dimensionalen Schrei\nbewirkt.", italian="[hero] ha sentito lo\nSquarcio Dimensionale quando ha toccato il\ncristallo.", spanish="Cuando [hero] tocó el\ncristal sintió la Percepción de Cronos."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="The vision indicated the presence\nof a Time Gear, which means...", french="La vision indiquait la présence\nd'un Rouage du Temps, ce qui signifie...", german="Die Vision deutet auf die\nPräsenz eines Zahnrads der Zeit hin.\nDas heißt...", italian="La visione ha mostrato la\npresenza di un Ingranaggio del Tempo.\nQuesto significa...", spanish="La visión indicaba la presencia\nde un Engranaje del Tiempo, y por tanto..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Maybe what we seek is in\n[CS:P]Crystal Cave[CR]!", french="... que ce que nous cherchons\nse trouve peut-être dans la [CS:P]Caverne Cristal[CR]!", german="Vielleicht ist das, was wir\nsuchen, in der [CS:P]Kristallhöhle[CR]!", italian="... che quello che stiamo\ncercando potrebbe trovarsi nella [CS:P]Grotta di[CR]\n[CS:P]Cristallo[CR]!", spanish="Tal vez lo que buscamos esté\nen la [CS:P]Cueva Cristal[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Perhaps there is a passage there\nthat leads to a Time Gear.", french="Il est possible qu'un passage\nmenant au Rouage du Temps se trouve là-bas.", german="Vielleicht gibt es dort einen\nDurchgang, der zum Zahnrad der Zeit führt.", italian="Forse c'è un passaggio nascosto\nche conduce verso un Ingranaggio del Tempo.", spanish="Tal vez allí se oculte algún\npasaje que nos lleve al Engranaje del Tiempo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" Yeah! Maybe it IS there!", french="Ouais! Il y est peut-être BEL\nET BIEN!", german=" Ja! Vielleicht IST es dort!", italian=" Sì! Potrebbe essere, no?", spanish=" ¡Sí! ¡Podría ser así!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  GROUND:EntTurn(npc_npc_bippa, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_kimawari, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_guregguru, Direction.Down)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.UpRight)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_diguda, Direction.Left)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Right)
  GROUND:EntTurn(npc_npc_chiriin, Direction.DownLeft)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_heigani, Direction.Left)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.UpRight)
  GAME:WaitFrames(15)
  GROUND:EntTurn(npc_npc_bippa, Direction.DownRight)
  GROUND:EntTurn(npc_npc_kimawari, Direction.DownRight)
  GROUND:EntTurn(npc_npc_guregguru, Direction.Right)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.Left)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.UpRight)
  GROUND:EntTurn(npc_npc_diguda, Direction.Up)
  GROUND:EntTurn(npc_npc_chiriin, Direction.Left)
  GROUND:EntTurn(npc_npc_heigani, Direction.Right)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  GAME:WaitFrames(15)
  -- message_FacePositionOffset(4, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Of course, we may already be\ntoo late.", french="Bien entendu, il se peut que nous\narrivions trop tard.", german="Natürlich könnte es sein, dass\nwir schon zu spät kommen.", italian="Chiaramente, dobbiamo mettere\nin conto l'eventualità che sia troppo tardi.", spanish="Por supuesto, puede que ya sea\ndemasiado tarde."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Or we may still have time!", french="Comme il est possible que nous\nayons encore du temps devant nous!", german=" Oder wir haben doch noch Zeit!", italian="Tuttavia, potremmo essere\nancora in tempo!", spanish="¡Pero puede que aún estemos\na tiempo!"})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="As long as a chance remains,\nwe must never give up! It's our only option!", french="Mais tant qu'il subsiste\nune chance, nous ne devons point baisser\nles bras! C'est notre seul espoir!", german="Solange die Chance besteht,\ndürfen wir nicht aufgeben! Es ist die\neinzige Möglichkeit!", italian="Finché esiste anche solo una\nsperanza, non dobbiamo arrenderci!", spanish="Mientras nos quede alguna\noportunidad, no debemos rendirnos.\n¡Es nuestra única opción!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_perappu, Direction.DownLeft)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, npc_npc_yonowaaru, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, "happy", 1) end)
  -- SetAnimation(4) [anim idle native]
  GAME:WaitFrames(30)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" Hey, hey! Absolutely!", french=" Eh dis donc, c'est bien vrai, ça!", german=" Hey, hey! Absolut richtig!", italian=" Ehi, ehi! È vero!", spanish="¡Oye, oye! ¡Totalmente de\nacuerdo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="There's no other choice. We\nhave to pin our hopes on this!", french="Nous n'avons pas le choix.\nTous nos espoirs reposent sur\ncette possibilité!", german="Wir haben keine andere Wahl.\nWir müssen alles auf diese Karte setzen!", italian="Non c'è altra cosa da fare!\nDobbiamo sperare che sia così.", spanish="No nos queda otra posibilidad.\nEsperemos que sea como dices."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Good thinking, [CS:N]Dusknoir[CR], sir!\nYup yup!", french="Bien dit, m'sieur [CS:N]Noctunoir[CR]!\nPour sûr!", german="Gut kombiniert, [CS:N]Zwirrfinst[CR]!\nJawollja!", italian="Il signor [CS:N]Dusknoir[CR] ha ragione,\nsissignore!", spanish="¡Qué gran razonamiento,\n[CS:N]Dusknoir[CR]! ¡Sí, señor!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="Oh my gosh! I'm all fired up\nwith excitement!", french="Ben mince alors! Je brûle\nd'enthousiasme!", german="Auweia! Ich platze gleich\nvor Aufregung!", italian=" Shock! Che emozione!", spanish=" ¡Ay, ay! ¡Estoy superemocionada!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="Let's GO, everyone! Let's search\n[CS:P]Crystal Cave[CR]!", french="EN ROUTE, tout le monde!\nAllons inspecter la [CS:P]Caverne Cristal[CR]!", german="LOS, Leute! Lasst uns die\n[CS:P]Kristallhöhle[CR] durchsuchen!", italian="CORAGGIO, gente!\nAndiamo tutti alla [CS:P]Grotta di Cristallo[CR]!", spanish="Vamos todos a buscar\na la [CS:P]Cueva Cristal[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" [CS:N]Dusknoir[CR], sir!", french=" Messire [CS:N]Noctunoir[CR]!", german=" [CS:N]Zwirrfinst[CR]!", italian=" Signor [CS:N]Dusknoir[CR]!", spanish=" [CS:N]Dusknoir[CR]..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="There's only one thing to do! And\nthat's explore [CS:P]Crystal Cave[CR]! ♪", french="Il n'y a qu'une seule chose\nà faire! Explorer la [CS:P]Caverne Cristal[CR]! ♪", german="Wir können jetzt nur eines tun!\nUnd zwar die [CS:P]Kristallhöhle[CR] erkunden! ♪", italian="C'è solo una cosa da fare.\nEsplorare la [CS:P]Grotta di Cristallo[CR]!", spanish="Está claro lo que hay que hacer.\nDebemos ir a explorar la [CS:P]Cueva Cristal[CR]. ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Let's go! ♪[K] The whole guild will\nbe involved!", french="Allons-y! ♪[K] Que la Guilde\nau grand complet se joigne à l'expédition!", german="Gehen wir! ♪[K] Die ganze Gilde\nsoll teilnehmen!", italian="Andiamo![K] Mobiliteremo tutta la\nGilda!", spanish="¡Vamos! ♪[K] Todo el [CS:N]Pokégremio[CR]\ntiene que ponerse manos a la obra."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Onward to [CS:P]Crystal Cave[CR]!", french="En route pour la [CS:P]Caverne\nCristal[CR]!", german=" Auf zur [CS:P]Kristallhöhle[CR]!", italian=" Tutti alla [CS:P]Grotta di Cristallo[CR]!", spanish="¡Nos pondremos en camino hacia\nla [CS:P]Cueva Cristal[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.Right)
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(2, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Guildmaster![K] Please issue the\ncall to duty!", french=" Maître![K] Battez le rappel!", german="Gildenmeister![K] Erinnere uns an\nunsere Pflicht und führe uns an!", italian="Capitano![K] La prego di indire\nl'adunata generale!", spanish=" ¡Gran Bluff![K] ¡Haz los honores!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, nil, 0) end) -- EFFECT_NONE
  do local p=npc_npc_bippa.Position; GROUND:MoveToPosition(npc_npc_bippa, p.X+(-20), p.Y+(0), false, 2) end
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, nil, 0) end) -- EFFECT_NONE
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GROUND:MoveToPosition(npc_npc_bippa, 420, 248, false, 2)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pukurin, 4) end)
  GROUND:EntTurn(npc_npc_kimawari, Direction.UpRight)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_pukurin, 4) end)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.UpRight)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_pukurin, 4) end)
  GAME:WaitFrames(60)
  pcall(function() SOUND:FadeOutBGM(120) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Guildmaster![K] Hmm...?[K]\nGuildmaster?", french="Maître![K] Hum...?[K]\nMaître?", german="Gildenmeister![K] Hmm...[K]\nGildenmeister?", italian="Capitano![K] Mmm...?[K]\nCapitano?", spanish="¡Gran Bluff![K] ¿Eh?[K]\n¿Gran Bluff?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(16), p.Y+(0), false, 2) end
  GAME:WaitFrames(60)
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(16), p.Y+(20), false, 2) end -- Move2PositionOffset
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(12), p.Y+(0), false, 2) end -- Move2PositionOffset
  GROUND:EntTurn(npc_npc_perappu, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Guildmaster![K] Are you with us?!", french=" Maître![K] Vous êtes avec nous?!", german=" Gildenmeister![K] Hörst du uns?!?", italian=" Capitano?[K] Mi sente?", spanish="¡Gran Bluff![K]\n¿Estás con nosotros?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" ...[K]Zzzz...", french=" ...[K] Zzzz...", german=" ...[K]Zzzz...", italian=" ...[K] Zzzz...", spanish=" Zzz...[K] Zzz."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Huh?", french=" Hein?", german=" Huch?", italian=" Eh?", spanish=" ¿Eh?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" ...Zzzz...zzzz...", french=" ... Zzzz... zzzz...", german=" ...Zzzz... zzzz...", italian=" ... Zzzz... Zzzz...", spanish=" Zzz... zzz..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" (H-hey, you gotta be kidding!)", french="(Eh dis donc, c'est une blague,\nou quoi?)", german=" (H-hey, ist das ein Scherz?)", italian=" (Ehi-ehi, non è possibile!)", spanish=" (Pe... pero... ¿Será una broma?)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" (No! It looks like...!)", french=" (Non! On dirait bien que...!)", german=" (Nein! Ich glaube, er...)", italian=" (No! Sembra...!)", spanish=" (¡Qué disparate! Parece que...)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="(He's fully asleep![K] With his eyes\nwide open too! Ewww!)", french="(Il dort à poings fermés![K]\nEt les yeux grand ouverts! Hiiiiii!)", german="(Er schläft tief und fest![K]\nMit offenen Augen! Igitt!)", italian="(Completamente addormentato![K]\nE con gli occhi aperti! Shock!)", spanish="(¡Se ha quedado sopa![K]\n¡Y con los ojos abiertos! ¡Ay, ay, ay!)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="(Eeep! The Guildmaster is so\nvery charming...[K]sigh...)", french="(Aaaah... comme le Maître est\nséduisant...[K] haaa...)", german="(Ieep! Der Gildenmeister ist ja\nso charmant...[K] Seufz...)", italian="(Wow! Il Capitano è così...[K]\nCosì...)", spanish="(¡Vaya! El Gran Bluff es que es\nla monda...[K] Ay...)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="(When do you all suppose he\ntook to snoozing?)", french="(A votre avis, ça fait longtemps\nqu'il pionce comme ça, l'Maître?)", german="(Was glaubt ihr, wie lange er\nschon schläft?)", italian="(Ma quand'è che si è\naddormentato?)", spanish="(¿Cuándo creéis que empezó\na dormitar?)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="(You think that maybe he's been\nasleep from the get-go?)", french="(Tu crois qu'il dort depuis\nle début?)", german="(Glaubt ihr, dass er vielleicht\nschon die ganze Zeit schläft?)", italian="(Che stia dormendo fin\ndall'inizio?)", spanish="(¿No os da la impresión de que\nlleva dormido desde el principio?)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  -- GAP: se_Play(8969) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" (Oh no! This just won't do!)", french=" (Oh non! Ça ne va pas du tout!)", german="(Oh nein! Das kann einfach nicht\nsein!)", italian=" (Oh no! Così non va!)", spanish=" (¡Qué faena!)"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="(Everyone might notice that the\nGuildmaster is sleeping...)", french="(Tout le monde va se rendre\ncompte que le Maître est endormi...)", german="(Jemand könnte merken,\ndass der Gildenmeister schläft.)", italian="(Tutti potrebbero accorgersi che\nil Capitano sta dormendo...)", spanish="(Todos se van a dar cuenta de\nque el Gran Bluff está durmiendo.)"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" (I must rouse him somehow...)", french="(Il faut que je trouve un moyen\nde le réveiller...)", german="(Ich muss ihn irgendwie\nwecken...)", italian="(Devo riuscire a svegliarlo, in\nqualche modo...)", spanish="(Tengo que despertarle de\nalguna forma.)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  -- GAP: SetEffect 438 — VFX sans émote PMDO équivalente
  -- SetAnimation(42) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Guildmaster![K] Guildmaster!", french=" Maître![K] Maître!", german=" Gildenmeister![K] Gildenmeister!", italian=" Capitano![K] Ehi, Capitano!", spanish=" ¡Gran Bluff![K] ¡Gran Bluff!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" ...[K]Huh...?", french=" ...[K] Hein...?", german=" ...[K]Äh?", italian=" ...[K] Mmm...?", spanish=" Eh...[K] ¿Qué?"})
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" GUILDMASTER!", french=" MAITRE!", german=" GILDENMEISTER!", italian=" CAPITANO!", spanish=" ¡GRAN BLUFF!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" [CS:N]Chatot[CR]!", french=" [CS:N]Pijako[CR]!", german=" [CS:N]Plaudagei[CR]!", italian=" [CS:N]Chatot[CR]!", spanish=" ¡[CS:N]Chatot[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, nil, 0) end) -- EFFECT_NONE
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(5)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" YES, GUILDMASTER?", french=" OUI, MAITRE?", german=" JA, GILDENMEISTER?", italian=" SÌ, CAPITANO?", spanish=" ¡¿Cómo dices, Gran Bluff?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_perappu, 448, 212, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_perappu, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_pukurin, Direction.DownLeft)
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Er, I mean...yes, Guildmaster...?", french="Euh, plutôt... oui,\nMaître...?", german="Äh, ich meine...\nJa, Gildenmeister?", italian="Oops, volevo dire... sì,\nCapitano?", spanish="Esto... Quiero decir...\n¿Sí, Gran Bluff?"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Er, to take it from the top...\nthere was...", french="Euh, pour commencer par\nle commencement... il y a eu...", german="Äh, um mich kurz zu fassen...\nEs gab...", italian=" Ehm... Ricapitolando...", spanish="Bueno, tal y como decía,\ntenemos que..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  -- message_FacePositionOffset(0, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Everyone! We're going after\n[CS:N]Grovyle[CR]!", french="Tous ensemble! Poursuivons\n[CS:N]Massko[CR]!", german="Pokémon! Wir machen Jagd auf\n[CS:N]Reptain[CR]!", italian="Gente! Si va all'inseguimento di\n[CS:N]Grovyle[CR]!", spanish="¡Amigos! ¡Vamos todos a buscar\na [CS:N]Grovyle[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" YOOM...TAH!", french=" TA... DAAA!", german=" LUUU... FIII!", italian=" BADABUM!", spanish=" ¡Vamos!"})
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(5)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "shock", 1) end)
  -- SetAnimation(33) [anim idle native]
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(-16), p.Y+(0), false, 2) end -- SlidePositionOffset
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  GROUND:EntTurn(npc_npc_guregguru, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_chiriin, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_heigani, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_bippa, Direction.Up)
  -- SetAnimation(24) [anim idle native]
  GROUND:EntTurn(npc_npc_dogoomu, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_kimawari, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_diguda, Direction.Up)
  -- SetAnimation(25) [anim idle native]
  GROUND:EntTurn(hero, Direction.Up)
  -- SetAnimation(66) [anim idle native]
  GROUND:EntTurn(partner, Direction.Up)
  -- SetAnimation(66) [anim idle native]
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: HOORAY!", french="[CS:N]Tous[CR]: HOURRA!", german="[CS:N]Alle[CR]: HURRA!", italian="[CS:N]Tutti[CR]: SÌÌÌÌÌÌÌ!", spanish="[CS:N]Todos[CR]: ¡HURRA!"})
  -- message_Close
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.Down)
  GROUND:EntTurn(npc_npc_bippa, Direction.DownRight)
  GROUND:EntTurn(npc_npc_kimawari, Direction.Down)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_diguda, Direction.Up)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.UpRight)
  GROUND:EntTurn(npc_npc_chiriin, Direction.Down)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_heigani, Direction.Left)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Right)
  GROUND:EntTurn(npc_npc_guregguru, Direction.DownRight)
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- message_FacePositionOffset(2, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" Let's go to [CS:P]Crystal Cave[CR]!", french=" Allons à la [CS:P]Caverne Cristal[CR]!", german=" Gehen wir zur [CS:P]Kristallhöhle[CR]!", italian=" Si va alla [CS:P]Grotta di Cristallo[CR]!", spanish=" ¡Vamos a la [CS:P]Cueva Cristal[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-5, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Hey, hey! There has to be a\nsecret there somewhere!", french="Eh dis donc, il y a forcément\nun secret là-bas!", german="Hey, hey! Irgendwo dort muss\nes ein Geheimnis geben!", italian="Ehi, ehi! Dev'esserci un segreto\nlà da qualche parte!", spanish="¡Oye, oye! ¡Allí tiene que haber\nalgún secreto en alguna parte!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="Let's get down to business and\nstart our SEARCH!", french="Branle-bas de combat!\nOn entame les RECHERCHES!", german="Machen wir uns an die Arbeit!\nLasst uns SUCHEN!", italian="Dobbiamo darci una mossa e\ntrovare quello che stiamo cercando!", spanish="¡Hay que ponerse manos a\nla obra y buscar a fondo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(4, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="I will accompany you to\n[CS:P]Crystal Cave[CR].", french="Je vous accompagne à\nla [CS:P]Caverne Cristal[CR].", german="Ich werde euch zur [CS:P]Kristallhöhle[CR]\nbegleiten.", italian="Vi accompagnerò alla [CS:P]Grotta di[CR]\n[CS:P]Cristallo[CR] personalmente.", spanish="Yo también os acompañaré a\nla [CS:P]Cueva Cristal[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(hero, Direction.UpLeft)
  GROUND:EntTurn(partner, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_kimawari, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_diguda, Direction.UpLeft)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, npc_npc_yonowaaru, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Let's do our best, everyone.", french="Faisons de notre mieux, mes\nbons amis.", german="Lasst uns alle unser\nBestmögliches tun.", italian=" Facciamo tutti del nostro meglio!", spanish="Tratemos de hacer todo lo que\npodamos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  GAME:WaitFrames(1)
  GROUND:EntTurn(npc_npc_guregguru, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  -- SetAnimation(23) [anim idle native]
  -- SetAnimation(23) [anim idle native]
  -- SetAnimation(24) [anim idle native]
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_kimawari, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_diguda, Direction.Up)
  -- SetAnimation(25) [anim idle native]
  GROUND:EntTurn(hero, Direction.Up)
  -- SetAnimation(66) [anim idle native]
  GROUND:EntTurn(partner, Direction.Up)
  -- SetAnimation(66) [anim idle native]
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: HOORAY!", french="[CS:N]Tous[CR]: HOURRA!", german="[CS:N]Alle[CR]: HURRA!", italian="[CS:N]Tutti[CR]: SÌÌÌÌÌÌÌ!", spanish="[CS:N]Todos[CR]: ¡HURRA!"})
  -- message_Close
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  pcall(function() GAME:MoveCamera(476, 256, 60, false) end) -- performer/caméra
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Down)
  -- SetAnimation(25) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- Destroy() [neutre/état moteur]
  GROUND:EntTurn(npc_npc_diguda, Direction.Down)
  -- SetAnimation(24) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- Destroy() [neutre/état moteur]
  GROUND:EntTurn(hero, Direction.Left)
  GROUND:EntTurn(partner, Direction.Left)
  do local p=npc_npc_yonowaaru.Position; GROUND:MoveToPosition(npc_npc_yonowaaru, p.X+(-24), p.Y+(0), false, 2) end
  GROUND:MoveToPosition(npc_npc_yonowaaru, 324, 188, false, 2)
  GROUND:MoveToPosition(npc_npc_guregguru, 224, 252, false, 2)
  GROUND:MoveToPosition(npc_npc_chiriin, 324, 188, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(npc_npc_heigani, 324, 188, false, 2)
  GROUND:MoveToPosition(npc_npc_dogoomu, 240, 272, false, 2)
  GROUND:MoveToPosition(npc_npc_bippa, 324, 188, false, 2)
  do local p=npc_npc_kimawari.Position; GROUND:MoveToPosition(npc_npc_kimawari, p.X+(-32), p.Y+(0), false, 2) end -- Move2PositionOffset
  GROUND:MoveToPosition(npc_npc_kimawari, 324, 188, false, 2)
  GROUND:MoveToPosition(npc_npc_chiriin, 324, 132, false, 2)
  GROUND:MoveToPosition(npc_npc_heigani, 324, 132, false, 2)
  GROUND:MoveToPosition(npc_npc_bippa, 324, 132, false, 2)
  GAME:WaitFrames(60)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" ........................", french=" ........................", german=" ........................", italian=" ........................", spanish=" ..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's get going too,\n[hero]!", french="Allons-y nous aussi,\n[hero]!", german="Machen wir uns auch auf den\nWeg, [hero]!", italian="Mettiamoci in marcia anche noi,\n[hero]!", spanish="¡Pongámonos en marcha,\n[hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's get going too,\n[hero]!", french="Allons-y nous aussi,\n[hero]!", german="Machen wir uns auch auf den\nWeg, [hero]!", italian="Mettiamoci in marcia anche noi,\n[hero]!", spanish="¡Pongámonos en marcha,\n[hero]!"})
  else
  SkySceneKit.say({english="Let's head out too,\n[hero]!", french="Allons-y nous aussi,\n[hero]!", german="Machen wir uns auch auf den\nWeg, [hero]!", italian="Mettiamoci in marcia anche noi,\n[hero]!", spanish="¡Pongámonos en marcha,\n[hero]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" On to [CS:P]Crystal Cave[CR]!", french="En route pour la [CS:P]Caverne\nCristal[CR]!", german=" Auf zur [CS:P]Kristallhöhle[CR]!", italian=" Alla [CS:P]Grotta di Cristallo[CR]!", spanish=" ¡Vamos a la [CS:P]Cueva Cristal[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" On to [CS:P]Crystal Cave[CR]!", french="En route pour la [CS:P]Caverne\nCristal[CR]!", german=" Auf zur [CS:P]Kristallhöhle[CR]!", italian=" Alla [CS:P]Grotta di Cristallo[CR]!", spanish=" ¡Vamos a la [CS:P]Cueva Cristal[CR]!"})
  else
  SkySceneKit.say({english=" On to [CS:P]Crystal Cave[CR]!", french="En route pour la [CS:P]Caverne\nCristal[CR]!", german=" Auf zur [CS:P]Kristallhöhle[CR]!", italian=" Alla [CS:P]Grotta di Cristallo[CR]!", spanish=" ¡Vamos a la [CS:P]Cueva Cristal[CR]!"})
  end
  -- message_Close
  GAME:FadeOut(false, 60)
  -- SetAnimation(2) [anim idle native]
  GROUND:TeleportTo(hero, 436, 268, Direction.Down)
  GROUND:TeleportTo(partner, 408, 268, Direction.Down)
  GROUND:TeleportTo(npc_npc_pukurin, 388, 196, Direction.Down)
  GROUND:TeleportTo(npc_npc_perappu, 456, 220, Direction.Down)
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(partner, Direction.Up)
  GROUND:EntTurn(npc_npc_pukurin, Direction.Down)
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  pcall(function() GAME:MoveCamera(0, 0, 1, true) end) -- caméra défaut
  GAME:WaitFrames(30)
  GAME:FadeIn(30)
  SkyProg.set(15, 4) -- $SCENARIO_MAIN = scn[15,4] (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[24] = 1 -- dungeon_mode(24) = DMODE_OPEN (ROM)
  SkySceneKit.cleanup_npcs()
end
