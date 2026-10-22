-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P01P04A/s30a0202.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_P01P04A) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_P01P04A, 'UM06') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(35) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(36) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  local npc_npc_pachirisu = SkySceneKit.spawn_npc("pachirisu", 208, 184, Direction.Up, "NPC_PACHIRISU")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_bariyaado = SkySceneKit.spawn_npc("mr_mime", 496, 184, Direction.Up, "NPC_BARIYAADO")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_okutan = SkySceneKit.spawn_npc("octillery", 432, 232, Direction.Down, "NPC_OKUTAN")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_herakurosu = SkySceneKit.spawn_npc("heracross", 224, 264, Direction.Right, "NPC_HERAKUROSU")
  -- SetAnimation(4) [anim idle native]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_SPINDAS_CAFE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GROUND:MoveToPosition(hero, 364, 292, false, 2)
  GROUND:MoveToPosition(partner, 332, 292, false, 2)
  local npc_npc_soonano = SkySceneKit.spawn_npc("wynaut", 360, 456, Direction.Down, "NPC_SOONANO")
  GROUND:MoveToPosition(npc_npc_soonano, 348, 328, false, 2)
  local npc_npc_soonansu = SkySceneKit.spawn_npc("wobbuffet", 336, 488, Direction.Down, "NPC_SOONANSU")
  GROUND:MoveToPosition(npc_npc_soonansu, 348, 328, false, 2)
  GROUND:MoveToPosition(npc_npc_soonano, 400, 296, false, 2)
  GROUND:MoveToPosition(npc_npc_soonansu, 400, 296, false, 2)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_herakurosu, Direction.Left)
  -- GAP: se_Play(8963) — id SE NDS sans portage PMDO identifié
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(18)
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_soonano, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_soonansu, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Whoa! This place is pretty big!", french=" Waouh! C'est grand, ici!", german=" Wow! Ganz schön groß!", italian=" Wow! Questo posto è enorme!", spanish=" ¡Guau! ¡Qué grande es este sitio!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wow! This is a big place!", french=" Waouh! C'est grand, ici!", german=" Wow! Ganz schön geräumig!", italian=" Wow! Che grande questo posto!", spanish=" ¡Caray! ¡Qué sitio tan grande!"})
  else
  SkySceneKit.say({english=" Wow! This place is so large!", french=" Waouh! C'est grand, ici!", german=" Wow! Hier ist so viel Platz!", italian="Wow! Questo posto è davvero\ngrande!", spanish=" ¡Vaya! ¡Este sitio es enorme!"})
  end
  -- message_Close
  pcall(function() GAME:MoveCamera(348, 164, 60, false) end) -- performer/caméra
  local npc_npc_patchiiru = SkySceneKit.spawn_npc("spinda", 352, 176, Direction.Down, "NPC_PATCHIIRU")
  pcall(function() GROUND:CharSetEmote(npc_npc_patchiiru, "happy", 1) end)
  GAME:WaitFrames(130)
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_patchiiru, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_patchiiru, "happy", 1) end)
  -- GAP: se_Play(11023) — id SE NDS sans portage PMDO identifié
  SkySceneKit.spin(npc_npc_patchiiru, 3, 2, 1) -- Turn3 (rotation partielle)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_patchiiru, nil, 0) end) -- EFFECT_NONE
  -- SetAnimation(26) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  -- SetAnimation(2) [anim idle native]
  pcall(function() GAME:MoveCamera(348, 292, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(npc_npc_patchiiru, 348, 272, false, 2)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- SetAnimation(23) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_patchiiru, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="Hello and welcome to\n[CS:K]Spinda[CR]'s Café!", french="Bonjour et bienvenue au\n[CS:K]Café Spinda[CR]!", german="Hallo und willkommen im\n[CS:K]Pandir-Café[CR]!", italian="Salve! Vi do il benvenuto\nal Caffè di [CS:K]Spinda[CR]!", spanish="¡Hola, os doy la bienvenida a la\n[CS:K]Cafetería Spinda[CR]!"})
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(npc_npc_patchiiru, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="My name is [CS:N]Spinda[CR]. I am the\nowner of this café.", french="Mon nom est [CS:N]Spinda[CR].\nJe suis le propriétaire de ce café.", german="Mein Name ist [CS:N]Pandir[CR].\nMir gehört dieses Café.", italian="Mi chiamo [CS:N]Spinda[CR] e sono\nil proprietario.", spanish="Me llamo [CS:N]Spinda[CR] y soy el dueño\nde la cafetería."})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="This is a café for explorers\nwho enjoy finding new things every day and\nwho are constantly challenging themselves.", french="C'est un café qui accueille les\nexplorateurs avides de découvertes et prompts\nà relever régulièrement de nouveaux défis.", german="Ein Café für Erkunder, die ohne\nUnterlass auf der Jagd nach Neuigkeiten sind\nund ständig neue Herausforderungen suchen.", italian="Questo è un caffè per\nesploratori che adorano scoprire nuove\ncose e vogliono sempre mettersi alla prova.", spanish="Esta es una cafetería para aquellos\nexploradores que disfrutan con cada hallazgo\ny que siempre buscan nuevos retos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" A café for explorers?", french="Un café destiné\naux explorateurs?", german=" Ein Café für Erkunder?", italian=" Un caffè per esploratori?", spanish="¿Una cafetería para\nexploradores?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" A café for explorers?", french="Un café destiné\naux explorateurs?", german=" Ein Café für Erkunder?", italian=" Un caffè per esploratori?", spanish="¿Una cafetería para\nexploradores?"})
  else
  SkySceneKit.say({english=" A café for explorers?", french="Un café destiné\naux explorateurs?", german=" Ein Café für Erkunder?", italian=" Un caffè per esploratori?", spanish="¿Una cafetería para\nexploradores?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="That's right.[K] It's natural to\nwant to refresh yourself with a hearty,\ndelicious drink after exploring...", french="Parfaitement.[K] Quoi de plus\nnaturel que de vouloir se rafraîchir avec une\ndélicieuse boisson après une rude exploration?", german="Ganz genau.[K] Nach den Strapazen\neiner Erkundung ist es das Schönste auf Erden,\neinen leckeren und gesunden Drink zu genießen.", italian="Esatto.[K] A tutti piace prendersi\nuna pausa con una sana e deliziosa bevanda\ndopo una lunga giornata di esplorazione...", spanish="Eso es.[K] Es de lo más normal\nquerer refrescarse con una deliciosa bebida\ntras una agotadora exploración..."})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="So we are delighted to provide\nthis service to explorers, and we trust it\nwill bring them happiness.", french="Ainsi, nous nous réjouissons\nd'offrir ce service aux explorateurs et nous\nespérons qu'il leur apportera joie et réconfort.", german="Deswegen ist es uns eine Ehre,\nErkundern diesen Service bieten zu können,\nund wir hoffen, sie damit zu beglücken.", italian="... e noi siamo lieti di offrire\nquesto servizio agli esploratori, con\nla speranza di renderli tutti più felici.", spanish="Así que nos complace proporcionar\neste servicio a los exploradores y confiamos\nen que les dé muchas alegrías."})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="Today is our grand opening!\nAllow me to show you around the premises.", french="Aujourd'hui, c'est l'inauguration!\nPermettez-moi de vous faire faire le tour\ndu propriétaire.", german="Heute ist die große Eröffnung!\nErlaubt mir, euch herumzuführen.", italian="Oggi è il giorno della grande\ninaugurazione! Venite, vi faccio fare\nun giro.", spanish="¡Hoy es la inauguración!\nPermitidme que os enseñe las instalaciones."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(300, 196, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(npc_npc_patchiiru, 300, 184, false, 2)
  GAME:WaitFrames(20)
  GROUND:EntTurn(npc_npc_herakurosu, Direction.Up)
  -- SetAnimation(4) [anim idle native]
  GROUND:MoveToPosition(hero, 316, 208, false, 2)
  GAME:WaitFrames(20)
  GROUND:MoveToPosition(partner, 300, 240, false, 2)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  -- SetAnimation(2) [anim idle native]
  GROUND:MoveToPosition(npc_npc_soonano, 340, 224, false, 2)
  GROUND:MoveToPosition(npc_npc_soonansu, 316, 248, false, 2)
  GROUND:EntTurn(npc_npc_patchiiru, Direction.Down)
  GROUND:EntTurn(npc_npc_okutan, Direction.Right)
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(partner, Direction.Up)
  GROUND:EntTurn(npc_npc_soonano, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_soonansu, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english=" This is the Juice Bar.", french=" Ici, vous avez le Bar à Jus.", german=" Das ist die Saftbar.", italian=" Questo è il Barsucco.", spanish="En esta zona están los\nZumos Spinda."})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="You've undoubtedly collected\nGummis and [CS:I]Apples[CR] during your explorations,\nam I right?", french="Vous avez sûrement ramassé\ndes gelées et des [CS:I]Pommes[CR] lors de vos\nexplorations, n'ai-je pas raison?", german="Ihr habt doch auf euren\nErkundungen garantiert bereits Gummis und\n[CS:I]Äpfel[CR] gefunden, nicht wahr?", italian="Di sicuro avrete raccolto Gomme\ne [CS:I]Mele[CR] durante le vostre esplorazioni.\nNon è così?", spanish="Sin duda habréis recogido gomis\ny alguna que otra [CS:I]Manzanita[CR] durante\nvuestras exploraciones, ¿me equivoco?"})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="Here, those edibles can become\ndelicious drink sensations.", french="A ce bar, vos objets comestibles\npeuvent être transformés en une harmonie\nde sensations gustatives.", german="Hier werden aus diesen Dingen\ndie leckersten Drink-Kreationen.", italian="Bene, questi cibi possono\nessere trasformati in bevande deliziose.", spanish="Pues pueden ser ingredientes\ndeliciosos para una bebida refrescante."})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="I, [CS:N]Spinda[CR], will take your\ningredient and use my incredible skills to\ncreate a delectable drink for you.", french="Moi, [CS:N]Spinda[CR], je prends vos\ningrédients pour vous préparer de délicieuses\nboissons grâce à mon incomparable talent.", german="Ihr gebt mir, [CS:N]Pandir[CR], einfach die\nZutat und ich verwende mein Können, um euch\neinen köstlichen Drink zu mixen.", italian="Io, [CS:N]Spinda[CR], prenderò i vostri\ningredienti e grazie alle mie capacità fuori dal\ncomune vi preparerò una bevanda squisita.", spanish="Yo, [CS:N]Spinda[CR], cogeré ese\ningrediente y, con mis increíbles habilidades,\ncrearé una deliciosa bebida."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Really? So if we brought you an\n[CS:I]Apple[CR], you'd make some Apple Juice, is\nthat what you're saying?", french="Vraiment? Tu veux dire que si\non t'apporte une [CS:I]Pomme[CR], tu nous prépares un\njus de pommes?", german="Wirklich? Bringen wir dir einen\n[CS:I]Apfel[CR], würdest du also einen Apfeldrink daraus\nmachen, wenn ich dich richtig verstehe?", italian="Davvero? Quindi se ti portiamo\nuna [CS:I]Mela[CR] ci preparerai del Succo Mela, giusto?", spanish="¿En serio? ¿Así que si te\ntraemos una [CS:I]Manzanita[CR] nos prepararás un\nzumo? ¿Es eso lo que quieres decir?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Really? So if we brought you an\n[CS:I]Apple[CR], you'd make some Apple Juice, is\nthat what you're saying?", french="Vraiment? Tu veux dire que si\non t'apporte une [CS:I]Pomme[CR], tu nous prépares un\njus de pommes?", german="Wirklich? Bringen wir dir einen\n[CS:I]Apfel[CR], würdest du also einen Apfeldrink daraus\nmachen, wenn ich dich richtig verstehe?", italian="Davvero? Quindi se ti portiamo\nuna [CS:I]Mela[CR] ci preparerai del Succo Mela, giusto?", spanish="¿En serio? ¿Así que si te\ntrajéramos una [CS:I]Manzanita[CR] nos harías\nun zumo? ¿Es eso lo que quieres decir?"})
  else
  SkySceneKit.say({english="Really? So if we brought you an\n[CS:I]Apple[CR], you'd make some Apple Juice, is\nthat what you're saying?", french="Vraiment? Tu veux dire que si\non t'apporte une [CS:I]Pomme[CR], tu nous prépares un\njus de pommes?", german="Wirklich? Bringen wir dir einen\n[CS:I]Apfel[CR], würdest du also einen Apfeldrink daraus\nmachen, wenn ich dich richtig verstehe?", italian="Davvero? Quindi se ti portiamo\nuna [CS:I]Mela[CR] ci preparerai del Succo Mela, giusto?", spanish="¿En serio? ¿Así que si te\ntrajéramos una [CS:I]Manzanita[CR] nos harías\nun zumo? ¿Se trata de eso?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_patchiiru, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="That's right! That is exactly\nright. That's how it works.", french="Exactement! C'est tout à fait\nça! C'est le principe.", german=" Stimmt! Ganz genau so geht das.", italian="Già! È esattamente così.\nFunziona proprio in questo modo.", spanish="¡Eso es! Así es exactamente\ncomo funciona."})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="While you're enjoying a\nnutritious drink, you can sit back and share\nexploration stories.", french="Et, tout en vous délectant d'une\nboisson nutritive, vous pouvez vous détendre\net partager vos récits d'exploration.", german="Und während ihr euch des Drinks\nerfreut, könnt ihr entspannen und Erkundungs-\nGeschichten mit den anderen austauschen.", italian="E mentre vi gustate una bella\nbevanda nutriente, potete sedervi e parlare\ndelle vostre avventure con gli altri esploratori.", spanish="Mientras disfrutáis de una\nnutritiva bebida, podéis relajaros y compartir\nlas batallitas de vuestras exploraciones."})
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(npc_npc_patchiiru, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english=" Here's the next facility...", french=" Passons au comptoir suivant...", german="Kommen wir zur\nnächsten Einrichtung...", italian=" Proseguiamo il giro...", spanish=" Aquí está el siguiente espacio..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(436, 196, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(npc_npc_patchiiru, 436, 184, false, 2)
  GAME:WaitFrames(20)
  GROUND:EntTurn(npc_npc_okutan, Direction.Left)
  -- SetAnimation(4) [anim idle native]
  GROUND:MoveToPosition(hero, 452, 208, false, 2)
  GROUND:MoveToPosition(partner, 420, 208, false, 2)
  GAME:WaitFrames(20)
  GROUND:EntTurn(npc_npc_soonano, Direction.UpRight)
  GROUND:EntTurn(npc_npc_soonansu, Direction.UpRight)
  GAME:WaitFrames(60)
  GROUND:MoveToPosition(npc_npc_soonano, 412, 180, false, 2)
  GROUND:MoveToPosition(npc_npc_soonansu, 388, 180, false, 2)
  GROUND:EntTurn(npc_npc_patchiiru, Direction.Down)
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(partner, Direction.Up)
  GROUND:EntTurn(npc_npc_bariyaado, Direction.Left)
  GAME:WaitFrames(5)
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_soonano, Direction.Down)
  GROUND:EntTurn(npc_npc_soonansu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="This is the centerpiece of our\nplace, the Recycle Shop.", french="C'est un peu la cerise sur le\ngâteau de ce magasin: la \"Bourse d'Echange\".", german="Hier ist das Herzstück des\nGanzen, der Wiederverwertungsladen.", italian="Questo è il cuore del mio\nlocale, il Centro Riciclo.", spanish="Este es el centro de nuestro\nestablecimiento, el Reciclaje Explorador."})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="I'll bet you have a bunch\nof items in storage that you picked up in your\ntravels and have little use for, am I right?", french="Je parie que, pendant vos\naventures, vous avez amassé plein d'objets de\npeu d'intérêt, n'ai-je pas raison?", german="Ich wette, ihr habt bereits\neinige Items von euren Reisen mitgebracht, die\neuch kaum weiterhelfen, nicht wahr?", italian="Immagino che durante i vostri\nviaggi abbiate trovato un bel po' di strumenti\nche non usate e avete messo nel deposito, eh?", spanish="Seguro que tenéis un montón de\nobjetos almacenados que habéis reunido durante\nvuestros viajes y no os sirven de mucho, ¿no?"})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="Sometimes you have to\nthrow out your extra items to make room...", french="Parfois, quand votre inventaire\nest plein, vous devez vous débarrasser de\ncertains objets...", german="Manchmal müsst ihr vielleicht\nsogar Items wegwerfen, nur um wieder Platz\nzu schaffen...", italian="E qualche volta dovete buttarne\nvia qualcuno per fare spazio...", spanish="En ocasiones tenéis que tirar\nlos que os sobran para hacer sitio..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(11024) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_patchiiru, "happy", 1) end)
  -- SetAnimation(26) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(11) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_soonano, "sweating", 1) end)
  GROUND:EntTurn(npc_npc_soonano, Direction.DownRight)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_soonansu, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_soonano, Direction.DownLeft)
  GAME:WaitFrames(3)
  GROUND:EntTurn(npc_npc_soonansu, Direction.DownRight)
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english=" Doesn't that seem wasteful?", french=" Quel immense gâchis!", german=" Ist das nicht verschwenderisch?", italian=" Non vi sembra uno spreco?", spanish=" ¿No os parece un despilfarro?"})
  pcall(function() GROUND:CharSetEmote(npc_npc_soonano, "sweating", 1) end)
  GROUND:EntTurn(npc_npc_soonano, Direction.DownRight)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_soonansu, Direction.DownRight)
  GROUND:EntTurn(npc_npc_soonano, Direction.DownLeft)
  GAME:WaitFrames(3)
  GROUND:EntTurn(npc_npc_soonansu, Direction.DownLeft)
  pcall(function() GROUND:CharSetEmote(npc_npc_soonano, "sweating", 1) end)
  GROUND:EntTurn(npc_npc_soonano, Direction.DownRight)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_soonansu, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_soonano, Direction.DownLeft)
  GAME:WaitFrames(3)
  GROUND:EntTurn(npc_npc_soonansu, Direction.DownRight)
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="There could be explorers in\ndungeons out there who are desperately in need\nof the very things you have locked in storage.", french="Dire qu'au milieu d'un donjon, un\nexplorateur pourrait avoir besoin de ces objets\nque vous avez relégués dans la réserve!", german="Dabei sind mit Sicherheit andere\nErkunder unterwegs, denen genau ein solches\nItem aus der Patsche helfen könnte!", italian="Nei dungeon potrebbero esserci\ndegli esploratori che magari hanno un disperato\nbisogno degli strumenti che avete depositato.", spanish="Podría haber un explorador en algún\nterritorio que necesitara desesperadamente\njusto eso que no usáis."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_patchiiru, nil, 0) end) -- EFFECT_NONE
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_soonano, Direction.Down)
  GROUND:EntTurn(npc_npc_soonansu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweatdrop", 1) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharSetEmote(partner, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="That's what we thought too.\nThat's why we established this facility.", french="C'est en pensant à cela que nous\navons décidé de mettre ce stand en place.", german="Aus diesem Gedanken heraus\nhaben wir diese Einrichtung gegründet.", italian="È quello che pensiamo anche noi.\nEcco perché abbiamo creato questa struttura.", spanish="Fue con esa idea en mente que\ncreamos este espacio."})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="You can bring your extra items\nhere and trade them for items you want.\nHow does that sound?", french="Vous pouvez amener ici vos\nobjets superflus et les échanger contre des\nobjets qui vous tentent. Qu'en dites-vous?", german="Bringt eure überflüssigen Items\nhierher und tauscht sie gegen etwas Nützliches\nein. Klingt gut, oder nicht?", italian="Qui potete portare gli strumenti\nin più che avete e scambiarli con quelli che\nvi servono. Niente male, eh?", spanish="Podéis traer los objetos que os\nsobren y cambiarlos por otros que queráis.\n¿Qué os parece?"})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="One Pokémon's trash is another\nPokémon's treasure, am I right?", french="Les déchets des uns font le\nbonheur des autres, n'ai-je pas raison?", german="Was dem einen Pokémon nichts\nist, ist dem anderen Pokémon alles. Stimmt's?", italian="Ciò che non serve a un Pokémon\npuò rivelarsi estremamente prezioso per\nun altro Pokémon, dico bene?", spanish="Lo que para un Pokémon es\ninservible puede ser un tesoro para otro,\n¿no creéis?"})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="I thought it would be fun\nfor explorers to gather and trade items\nwith one another.", french="J'ai pensé qu'un explorateur\npourrait apprécier de collecter puis\nd'échanger des objets avec ses pairs.", german="Ich dachte, das ist doch lustig,\nErkundern einen Treffpunkt zu bieten, an dem\nsie Items miteinander tauschen können.", italian="Ho pensato che gli esploratori\npotrebbero divertirsi a raccogliere\nstrumenti e scambiarli tra di loro.", spanish="Pensé que sería divertido que\nlos exploradores se reunieran e intercambiaran\nobjetos unos con otros."})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="You'll never have to throw out\nanother item. You'll never have to say,\n\"What a waste!\"[K] That's my goal.", french="Vous n'aurez plus jamais à jeter\nle moindre objet. Fini, les cas de conscience![K]\nVoilà mon objectif.", german="Niemand soll mehr ein Item\nwegwerfen müssen und dabei denken: [F:S2]Was\nfür eine Verschwendung![F:E2] [K]Darum geht es.", italian="Basta buttare via gli strumenti.\nDiamo un taglio agli sprechi![K]\nQuesto è il mio obiettivo.", spanish="Ya nunca tendréis que malgastar\nni un objeto más. Nunca tendréis que decir:\n\"¡Qué despilfarro!\".[K] Ese es mi objetivo."})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="So if you've got a collection of\nitems you don't need, please make use of our\nRecycle Shop.", french="En résumé, si vous avez une\nsérie d'objets superflus, n'hésitez pas à\nutiliser les services de la Bourse d'Echange.", german="Wenn ihr also eine Ansammlung\nentbehrlicher Items habt, macht Gebrauch\nvom Wiederverwertungsladen!", italian="Quindi, se avete degli strumenti\nche non vi servono, venite al nostro\nCentro Riciclo.", spanish="Así que, si tenéis objetos\ninservibles a porrillo, usad nuestro\nReciclaje Explorador."})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="You can even get a bonus\n[CS:I]Prize Ticket[CR] when recycling items.\nIt's a lot of fun.", french="Vous pouvez même obtenir un\n[CS:I]Ticket Magot[CR] bonus en échangeant des objets.\nC'est amusant comme tout.", german="Und das Tollste ist: Für das\nWiederverwerten gibt es manchmal sogar\n[CS:I]Preistickets[CR]. Die machen eine Menge Spaß!", italian="Riciclando gli strumenti potete\nanche ottenere un [CS:I]Buono Premio[CR]. È davvero\nspassoso.", spanish="¡Si es que hasta podéis\nconseguir un [CS:I]boleto[CR] reciclando! ¡Es de traca!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="...I know that was a whirlwind\ntour, but I hope you've got an idea\nof what kind of a place this is.", french="... Je sais, c'était une visite\néclair, mais j'espère que vous avez pu vous\nfaire une idée de ce que nous proposons ici.", german="...Ich weiß, das war jetzt ein\nganz schön hastiger Rundgang, aber ich hoffe,\nihr habt einen Eindruck gewinnen können.", italian="È stato un giro molto rapido,\nlo so, ma spero sia servito a farvi capire\nche tipo di luogo è questo.", spanish="Ya sé que ha sido una visita\nrelámpago, pero espero que os hayáis hecho\nuna idea del tipo de lugar en el que estáis."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Wow. Seems like a pretty\ncool shop.", french="Waouh, ça m'a l'air sympathique,\ncomme endroit.", german="Wow. Der Laden sieht ziemlich\ncool aus.", italian="Wow. Ha tutta l'aria di essere\nun locale niente male.", spanish=" Vaya... Qué tienda tan guay."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Wow. Seems like a really\nfun shop.", french="Waouh, ça m'a l'air sympathique,\ncomme endroit.", german="Wow. Der Laden sieht ziemlich\nspaßig aus.", italian="Wow. Sembra un locale\ndavvero divertente.", spanish=" Oye, este sitio no está mal..."})
  else
  SkySceneKit.say({english=" Ooh, sounds like such a fun shop!", french="Waouh, ça m'a l'air sympathique,\ncomme endroit.", german="Oh, klingt nach einem\nwitzigen Laden!", italian="Oooh, sembra proprio un locale\nspassoso!", spanish=" ¡Jo, esta tienda es una pasada!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_patchiiru, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english=" Thank you very much!", french=" Merci beaucoup!", german=" Ich danke euch!", italian=" Grazie mille!", spanish=" ¡Muchas gracias!"})
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(npc_npc_patchiiru, nil, 0) end) -- EFFECT_NONE
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="It is my goal to have a café of\nhopes and dreams, where many explorers\ncan gather.", french="C'est mon objectif, de proposer\nun café où les rêves se réalisent et où les\nexplorateurs peuvent se retrouver.", german="Mein Ziel ist es, einen Raum\nder Hoffnungen und Träume zu bieten, in dem\nsich Erkunder treffen und austauschen.", italian="Desidero con tutto il cuore\navere un caffè pieno di sogni e di speranze,\ndove gli esploratori possano incontrarsi.", spanish="Mi objetivo es que esta sea una\ncafetería de ensueño en la que se reúnan\nmuchos exploradores."})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="I hope to see you again soon\nhere at [CS:K]Spinda[CR]'s Café.", french="J'espère vous revoir bientôt\nau [CS:K]Café Spinda[CR].", german="Ich hoffe, euch bald wieder hier\nim [CS:K]Pandir-Café[CR] begrüßen zu dürfen!", italian="Spero di rivedervi presto qui\nal Caffè di [CS:K]Spinda[CR].", spanish="Espero volver a veros pronto\npor la [CS:K]Cafetería Spinda[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(11025) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(23) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(40)
  GAME:FadeOut(false, 30)
  pcall(function() GAME:MoveCamera(0, 0, 1, true) end) -- caméra défaut
  GROUND:TeleportTo(hero, 364, 236, Direction.Down)
  GROUND:TeleportTo(partner, 332, 236, Direction.Down)
  GROUND:EntTurn(hero, Direction.Down)
  GROUND:EntTurn(partner, Direction.Down)
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(10) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(11) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(12) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(13) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_LoadStation(LEVEL_P01P04A, 'UM06') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(35) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(36) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(30)
  GAME:FadeIn(30)
  SkySceneKit.cleanup_npcs()
end
