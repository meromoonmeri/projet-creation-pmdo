-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D54P11A/n06a0201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]The treasure hunters--Team [CS:X]Charm[CR]--\n[CN]are a very famous exploration team.", french="[CN]Les chasseuses de trésor de l'Equipe [CS:X]Charme[CR]\n[CN]sont très célèbres.", german="[CN]Die Schatzjäger von Team [CS:X]Charme[CR]\n[CN]sind ein berühmtes Erkundungsteam.", italian="[CN]Le cacciatrici di tesori, il Team [CS:X]Malia[CR], sono\n[CN]una squadra d'esplorazione molto famosa.", spanish="[CN]El [CS:X]Equipo Carisma[CR] lo componen buscadoras de\n[CN]tesoros y es un equipo explorador muy famoso."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]They're not only famous for being Master Rank\n[CN]and having a great reputation...", french="[CN]Pas seulement pour leur Grade Maître\n[CN]et leurs prouesses...", german="[CN]Für sie spricht ihr Meister-Rang und ein\n[CN]fabelhafter Ruf unter Erkundern.", italian="[CN]E non solo perché sono di Rango Master\n[CN]e godono di una grande reputazione...", spanish="[CN]No solo son conocidas por tener Rango Experto\n[CN]y por su intachable reputación..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]But also for their splendid ability to find\n[CN]treasure, which is admired by everyone.", french="[CN]... mais aussi pour leur flair incroyable quand\n[CN]il s'agit de dénicher des trésors. Leurs\n[CN]multiples talents forcent l'admiration de tous.", german="[CN]Aber vor allem ihr Talent, versteckte Schätze\n[CN]aufzuspüren, wird von allen geschätzt.", italian="[CN]Ma anche per la loro incredibile abilità,\n[CN]riconosciuta e ammirata da tutti,\n[CN]di riportare alla luce i tesori perduti.", spanish="[CN]Sino también por su increíble habilidad para\n[CN]hallar tesoros, algo que todos admiran."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]However... This story takes place\n[CN]a little earlier...", french="[CN]Cependant... notre histoire se déroule\n[CN]un peu plus tôt...", german="[CN]Wie dem auch sei... Diese Geschichte\n[CN]beginnt ein wenig früher...", italian="[CN]Tuttavia, questa storia si\n[CN]svolge qualche tempo fa...", spanish="[CN]Sin embargo... esta historia tuvo lugar\n[CN]un poco antes de eso..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]It's a story that takes place before\n[CN]Team [CS:X]Charm[CR] became famous.", french="[CN]Avant que l'Equipe [CS:X]Charme[CR]\n[CN]ne devienne célèbre.", german="[CN]Diese Geschichte spielt zu der Zeit,\n[CN]bevor Team [CS:X]Charme[CR] berühmt wurde.", italian="[CN]Quando il Team [CS:X]Malia[CR] non\n[CN]era ancora diventato famoso.", spanish="[CN]Es algo que sucedió antes de que\n[CN]el [CS:X]Equipo Carisma[CR] se hiciera famoso."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]The Team [CS:X]Charm[CR] that always gets\n[CN]the treasure they're aiming for...", french="[CN]L'Equipe [CS:X]Charme[CR] qui réussit toujours à mettre\n[CN]la main sur les trésors qu'elle vise...", german="[CN]Jenes Team [CS:X]Charme[CR], das jeden Schatz\n[CN]bekommt, auf den es aus ist...", italian="[CN]Il Team [CS:X]Malia[CR] ottiene sempre\n[CN]il tesoro che sta cercando...", spanish="[CN]El [CS:X]Equipo Carisma[CR], que siempre consigue\n[CN]el tesoro que quiere..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Their next target is...", french="[CN]Leur prochaine cible, c'est...", german="[CN]Ihr nächstes Ziel ist...", italian="[CN]E questa volta l'obiettivo è...", spanish="[CN]En aquella ocasión tenía como objetivo..."})
  -- message_Close
  GAME:FadeOut(false, 30)
  -- back_SetGround(LEVEL_D54P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  local npc_npc_chaaremu = SkySceneKit.spawn_npc("medicham", 224, 368, Direction.Up, "NPC_CHAAREMU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_saanaito = SkySceneKit.spawn_npc("gardevoir", 288, 368, Direction.Up, "NPC_SAANAITO")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_metamon_kireihana = SkySceneKit.spawn_npc("bellossom", 256, 120, Direction.Down, "NPC_METAMON_KIREIHANA")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_SOUTHERN_JUNGLE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(hero, 252, 228, false, 2)
  GAME:WaitFrames(15)
  GROUND:MoveToPosition(npc_npc_saanaito, 284, 244, false, 2)
  GAME:WaitFrames(75)
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" W-wait...[K]for me!", french=" Attendez...[K] Attendez-moi!", german=" W-wartet...[K] auf mich!", italian=" Ehi...[K] A-Aspettatemi!", spanish=" Es...[K] ¡esperadme!"})
  -- message_Close
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(npc_npc_chaaremu, 220, 244, false, 2)
  GAME:WaitFrames(24)
  GROUND:EntTurn(npc_npc_saanaito, Direction.Left)
  GAME:WaitFrames(9)
  GROUND:EntTurn(hero, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(45) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" Haa haa...[K] W-we've...", french=" Haaaa...[K] Ça fait...", german=" Ha ha...[K] W-wir sind...", italian=" Pant pant...[K] A-Abbiamo...", spanish=" Ja, ja...[K] He... hemos..."})
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" We've come pretty far...", french=" ... un moment qu'on marche...", german=" Wir sind schon ziemlich weit.", italian=" Abbiamo fatto parecchia strada...", spanish=" Hemos avanzado bastante..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chaaremu, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="Are we anywhere near our\ndestination yet?", french=" On est bientôt arrivées?", german="Sind wir schon in Reichweite\nunseres Ziels?", italian=" Manca ancora molto?", spanish="¿Falta mucho para que lleguemos\na nuestro destino?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" Just a little farther, [CS:N]Medicham[CR].", french="Encore un petit effort,\n[CS:N]Charmina[CR].", german=" Ein bisschen noch, [CS:N]Meditalis[CR].", italian=" Ci siamo quasi, [CS:N]Medicham[CR].", spanish=" Solo un poquito más, [CS:N]Medicham[CR]."})
  -- message_Close
  GROUND:EntTurn(npc_npc_saanaito, Direction.Up)
  GAME:WaitFrames(9)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_saanaito, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chaaremu, npc_npc_saanaito, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="According to my research, once\nwe get out of this jungle...", french="D'après mes recherches,\nune fois que nous aurons traversé\ncette jungle...", german="Unser Ziel ist nicht mehr weit,\nsobald wir diesen Dschungel verlassen...", italian="Secondo le mie ricerche, quando\nsaremo fuori da questa giungla...", spanish="Por lo que he podido averiguar,\nen cuanto salgamos de esta selva..."})
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="Our destination...[K]is\n[CS:P]Boulder Quarry[CR].", french="... nous devrons prendre la\ndirection...[K] de la [CS:P]Carrière Rocher[CR].", german="Es ist ein Ort...[K] namens\n[CS:P]Geröllbruch[CR]. Das ergaben zumindest meine\nRecherchen.", italian="... avremo raggiunto la nostra\nmeta...[K] La [CS:P]Cava Rocciosa[CR].", spanish="Llegaremos a nuestro destino:[K]\nel [CS:P]Roquedal[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Deep in [CS:P]Boulder Quarry[CR], there's\nsupposed to be a legendary treasure...", french="On dit qu'un trésor légendaire\nse cache au fin fond de la [CS:P]Carrière Rocher[CR]...", german="Tief im [CS:P]Geröllbruch[CR] soll es einen\nlegendären Schatz geben.", italian="Si narra che nei profondi\nrecessi della [CS:P]Cava Rocciosa[CR] si celi\nun tesoro leggendario...", spanish="En las profundidades del [CS:P]Roquedal[CR],\nse supone que hay un tesoro legendario..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="It's said to be so beautiful that\nmere words cannot express it.", french="A ce qu'on raconte, il est si\néblouissant qu'aucun mot ne suffit\nà le décrire.", german="Man sagt von ihm, er sei\nso schön, dass man es nicht in Worte\nfassen könne.", italian="Dicono che sia talmente\nmeraviglioso da non poter essere\ndescritto a parole.", spanish="Se dice que es tan hermoso que\nno hay palabras que puedan describirlo."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="A beautiful treasure...[K]\nHee-hee-hee!", french=" Un trésor éblouissant...[K] Hi hi hi!", german="Ein wunderschöner Schatz...[K]\nHi-hi-hi-hi!", italian="Un tesoro meraviglioso...[K]\nIh ih ih!", spanish=" Un tesoro hermoso...[K] ¡Ji, ji, ji!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Sounds like it will fit\nus perfectly! [M:H8]", french=" Il nous ira à merveille! [M:H8]", german="Klingt fast, als würde er gut zu\nuns passen! [M:H8]", italian="Sembra una missione fatta\napposta per noi! [M:H8]", spanish="¡Parece que nos va a ir\nque ni pintado! [M:H8]"})
  -- message_Close
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_saanaito, hero, 4) end)
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="I-is...[K]that so? ♪[K] When I hear\nthat, it makes me so very happy! ♪", french="Vrai...[K] vraiment? ♪[K] Tes paroles\nme ravissent! ♪", german="I-ist...[K] das so? ♪[K] Wenn ich das\nso höre, macht es mich irre glücklich! ♪", italian="D-[K]Davvero? ♪[K] Solo a sentirlo,\nnon sto nella pelle dalla gioia! ♪", spanish="¿En...[K] En serio? ♪[K] ¡Oír eso\nme hace superfeliz! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="All right, let's do our best and\nget through this jungle! ♪", french="Faisons de notre mieux pour\ntraverser cette jungle au plus vite! ♪", german="Na gut. Lasst uns unser Bestes\ngeben und diesen Dschungel durchqueren! ♪", italian="Ok, mettiamocela tutta e\nsuperiamo la giungla! ♪", spanish="Bueno, vamos a darlo todo, hay\nque atravesar esta selva. ♪"})
  -- message_Close
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "happy", 1) end)
  GAME:WaitFrames(90)
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, nil, 0) end) -- EFFECT_NONE
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" U-um...", french=" Hum hum...", german=" Ä-ähem...", italian=" U-Uhm...", spanish=" E... ejem..."})
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "exclaim", 1) end)
  GAME:WaitFrames(6)
  pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, "exclaim", 1) end)
  GAME:WaitFrames(4)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_chaaremu, Direction.Up)
  GAME:WaitFrames(6)
  GROUND:EntTurn(npc_npc_saanaito, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_Close
  GROUND:MoveToPosition(npc_npc_metamon_kireihana, 252, 196, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" Wh-who are you?", french=" Qui es-tu?", german=" W-wer bist du?", italian=" C-Chi sei tu?", spanish=" ¿Qui... quién eres?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_metamon_kireihana) end)
  SkySceneKit.say({english="I'm [CS:N]Bellossom[CR].[K]\nI live in this jungle.", french="Je m'appelle [CS:N]Joliflor[CR].[K]\nJe vis dans cette jungle.", german="Ich bin [CS:N]Blubella[CR].[K]\nIch lebe in diesem Dschungel.", italian="Mi chiamo [CS:N]Bellossom[CR].[K] Vivo in questa\ngiungla.", spanish="Soy [CS:N]Bellossom[CR].[K]\nVivo en esta selva."})
  pcall(function() UI:SetSpeaker(npc_npc_metamon_kireihana) end)
  SkySceneKit.say({english="If you're talking about the\ntreasure in [CS:P]Boulder Quarry[CR]...", french="Si vous parlez du trésor de la\n[CS:P]Carrière Rocher[CR]...", german="Falls ihr gerade über den\nSchatz im [CS:P]Geröllbruch[CR] gesprochen habt...", italian="Se state parlando del tesoro\ndella [CS:P]Cava Rocciosa[CR]...", spanish="Si estáis hablando del tesoro\ndel [CS:P]Roquedal[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_metamon_kireihana) end)
  SkySceneKit.say({english=" You really should give up.", french="... vous feriez mieux\nd'abandonner.", german=" Gebt besser auf.", italian="... fareste meglio a lasciar\nperdere.", spanish=" Será mejor que lo olvidéis."})
  -- message_Close
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" Wh-what...?[K] Why?", french=" Hein...?[K] Pourquoi ça?", german=" W-was...[K] Warum sollten wir?", italian=" C-Come...?[K] Perché?", spanish=" ¿Có... cómo...?[K] ¿Y eso por qué?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_metamon_kireihana) end)
  SkySceneKit.say({english="That treasure has been sought by\nmany exploration groups, but...", french="Bien des équipes d'exploration\nont tenté de s'en emparer...", german="Eine Menge Erkundungsteams\nwaren bereits hinter diesem Schatz her...", italian="Molte squadre d'esplorazione\nsono partite alla ricerca di quel tesoro, ma...", spanish="Muchos grupos exploradores\nhan ido a la caza de ese tesoro, pero..."})
  pcall(function() UI:SetSpeaker(npc_npc_metamon_kireihana) end)
  SkySceneKit.say({english=" So far, nobody's found it.", french="... mais aucune n'a jamais réussi\nà mettre la main dessus.", german="Aber bis jetzt hat ihn noch\nniemand entdeckt.", italian="... finora nessuno lo ha mai\nscovato.", spanish=" Por ahora nadie lo ha hallado."})
  pcall(function() UI:SetSpeaker(npc_npc_metamon_kireihana) end)
  SkySceneKit.say({english="Everyone knows that it's\nimpossible to find...", french="Tout le monde sait qu'il est\nintrouvable...", german="Alle wissen, dass es unmöglich\nist, ihn zu finden.", italian="Tutti sanno che è impossibile\nda trovare...", spanish="Todo el mundo sabe que es\nimposible de encontrar..."})
  pcall(function() UI:SetSpeaker(npc_npc_metamon_kireihana) end)
  SkySceneKit.say({english=" And lately, we... That is...", french=" Et depuis quelque temps...", german=" Und seit Kurzem glauben wir...", italian=" E ultimamente noi, cioè...", spanish="Y últimamente nosotros...\nEs decir..."})
  pcall(function() UI:SetSpeaker(npc_npc_metamon_kireihana) end)
  SkySceneKit.say({english=" Those of us who live here...", french="... nous, les habitants de la\nrégion...", german="Also die von uns, die hier\nleben...", italian=" Quelli di noi che vivono qui...", spanish=" Los que vivimos aquí..."})
  pcall(function() UI:SetSpeaker(npc_npc_metamon_kireihana) end)
  SkySceneKit.say({english="Think that there might not\nactually be anything there to begin with.", french="... en sommes venus à croire\nqu'il n'existe pas.", german="Wir glauben, dass es wohl nie\neinen Schatz gegeben hat.", italian="... hanno cominciato a pensare\nche in realtà non esista nessun tesoro.", spanish="Creemos que puede que\nni siquiera haya nada que buscar."})
  pcall(function() UI:SetSpeaker(npc_npc_metamon_kireihana) end)
  SkySceneKit.say({english="So, don't you think you\nshould give up as well?", french="Vous devriez laisser tomber,\nvous ne croyez pas?", german="Glaubt ihr nicht, dass ihr auch\naufgeben solltet?", italian="Allora, che ne pensate? Forse\nanche voi dovreste lasciar perdere...", spanish="Así que... ¿no creéis que\nestáis perdiendo el tiempo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Thank you, [CS:N]Bellossom[CR]...[K]\nBut we're not giving up.", french="Merci, [CS:N]Joliflor[CR]...[K] Mais il est\nhors de question qu'on laisse tomber.", german="Vielen Dank, [CS:N]Blubella[CR]...[K]\nAber wir geben niemals auf.", italian="Grazie, [CS:N]Bellossom[CR]...[K] Ma non\nabbiamo intenzione di farlo.", spanish="Gracias, [CS:N]Bellossom[CR]...[K]\nPero vamos a seguir buscando."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_metamon_kireihana) end)
  SkySceneKit.say({english=" Huh?", french=" Hein?", german=" Ach ja?", italian=" Uh?", spanish=" ¿Y eso por qué?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="That kind of treasure...[K]sounds\nexactly like the kind of thing we like\nto look for! [M:H8]", french="Ce genre de trésor...[K] correspond\nexactement à ce qu'on recherche! [M:H8]", german="Diese Art Schatz...[K] klingt\ngenau nach dem, wonach wir am liebsten\nsuchen! [M:H8]", italian="Un tesoro simile...[K] è proprio\nil genere di sfida che fa per noi! [M:H8]", spanish="Ese tesoro...[K] ¡parece justo\nde la clase que nos encanta buscar! [M:H8]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="We always find and acquire\nthe treasure we're looking for...", french="Aucun des trésors sur lesquels\nnous avons jeté notre dévolu n'a jamais\nréussi à nous échapper...", german="Wir finden immer, wonach wir\nsuchen. Und das sind meistens Schätze...", italian="E poi, quando vogliamo qualcosa,\nnulla può impedirci di ottenerla...", spanish="Siempre encontramos y nos\nquedamos el tesoro que queremos..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="After all, we are the alluring\ntreasure hunters--[K]Team [CS:X]Charm[CR]!", french="Après tout, nous sommes les\nchasseuses de trésor super-classes de...[K]\nl'Equipe [CS:X]Charme[CR]!", german="Wir sind immer noch die\ncharmanten Schatzjäger [K]Team [CS:X]Charme[CR]!", italian="Dopo tutto noi siamo\nle affascinanti cacciatrici di tesori,[K]\nil Team [CS:X]Malia[CR]!", spanish="Al fin y al cabo, somos las bellas\nbuscadoras de tesoros...[K] ¡El [CS:X]Equipo Carisma[CR]!"})
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
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_saanaito, hero, 4) end)
  GAME:WaitFrames(6)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chaaremu, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="Hey, [CS:Y]Lopunny[CR]...[K]once you've\nprepared, let's head out.", french="[CS:Y]Lockpin[CR]...[K] Nous partons dès\nque tu es prête.", german="Hey, [CS:Y]Schlapor[CR]...[K]\nSobald du fertig bist, ziehen wir weiter.", italian="Ehi, [CS:Y]Lopunny[CR]...[K] Quando siamo\npronte, andiamo.", spanish="Eh, [CS:Y]Lopunny[CR]...[K] Cuando estés lista,\nnos vamos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" To the other side of the jungle!", french=" Nous allons traverser la jungle!", german=" Quer durch den Dschungel!", italian="Forza, oltrepassiamo la\ngiungla!", spanish=" ¡Al otro extremo de la selva!"})
  -- message_Close
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="[CN]The Special Episode\n[CN]\"Here Comes Team Charm!\"\n[CN]stars [CS:Y]Lopunny[CR] as the main character.", french="[CN][CS:Y]Lockpin[CR] est le personnage principal\n[CN]de l'Episode Spécial intitulé\n[CN]\"Voilà l'Equipe Charme!\".", german="[CN]Die Bonusepisode\n[CN][F:S2]Platz für Team Charme![F:E2]\n[CN]mit [CS:Y]Schlapor[CR] in der Hauptrolle.", italian="[CN]L'episodio speciale\n[CN]\"Arriva il Team Malia!\"\n[CN]ha come protagonista [CS:Y]Lopunny[CR].", spanish="[CN]El capítulo especial\n[CN]\"¡Llega el Equipo Carisma!\"\n[CN]tiene a [CS:Y]Lopunny[CR] por protagonista."})
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="[CN]You will progress through the story with\n[CN][CS:Y]Lopunny[CR] as the playable character.", french="[CN]Vous incarnerez [CS:Y]Lockpin[CR].", german="[CN]Du wirst die Geschichte mit [CS:Y]Schlapor[CR]\n[CN]als spielbarem Charakter bestreiten.", italian="[CN]In questa storia impersonerai [CS:Y]Lopunny[CR].", spanish="[CN]Avanzarás en la historia\n[CN]con [CS:Y]Lopunny[CR]."})
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
