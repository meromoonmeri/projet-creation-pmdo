-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H02P99A/m22a0602.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_H02P99A) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_H02P99A, 'UM22') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(4) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(2) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(60)
  -- supervision_Acting(0) [neutre/état moteur]
  pcall(function() GAME:MoveCamera(276, 196, 60, false) end) -- performer/caméra
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(hero, 276, 204, false, 1)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(partner, 276, 164, false, 1)
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]Grovyle[CR]'s not here...", french=" [CS:N]Massko[CR] n'est pas là...", german=" [CS:N]Reptain[CR] ist nicht hier...", italian=" [CS:N]Grovyle[CR] qui non c'è...", spanish=" [CS:N]Grovyle[CR] no está aquí..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]Grovyle[CR] isn't here...", french=" [CS:N]Massko[CR] n'est pas là...", german=" [CS:N]Reptain[CR] ist nicht hier...", italian=" [CS:N]Grovyle[CR] non è qui...", spanish=" [CS:N]Grovyle[CR] no está aquí..."})
  else
  SkySceneKit.say({english=" [CS:N]Grovyle[CR] isn't here...", french=" [CS:N]Massko[CR] n'est pas là...", german=" [CS:N]Reptain[CR] ist nicht hier...", italian=" [CS:N]Grovyle[CR] non è qui...", spanish=" [CS:N]Grovyle[CR] no está aquí..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Right)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey! Over there!", french=" Eh! Regarde là!", german=" Hey! Hier drüben!", italian=" Ehi! Guarda!", spanish=" ¡Mira! ¡Allí!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey! Over there!", french=" Eh! Regarde là!", german=" Hey! Hier drüben!", italian=" Ehi! Guarda!", spanish=" ¡Mira! ¡Allí!"})
  else
  SkySceneKit.say({english=" Oh! Over there!", french=" Eh! Regarde là!", german=" Oh! Da drüben!", italian=" Ehi! Guarda!", spanish=" ¡Mira! ¡Allí!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(348, 196, 60, false) end) -- performer/caméra
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(16), p.Y+(16), false, 2) end
  GROUND:MoveToPosition(hero, 324, 204, false, 2)
  GROUND:MoveToPosition(partner, 348, 180, false, 2)
  GROUND:EntTurn(hero, Direction.UpRight)
  GROUND:EntTurn(partner, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" There's a sheet of paper!", french=" Il y a un morceau de papier!", german=" Da liegt ein Stück Papier!", italian=" C'è un foglio di carta!", spanish=" ¡Hay una hoja de papel!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" There's a sheet of paper!", french=" Il y a un morceau de papier!", german=" Da liegt ein Stück Papier!", italian=" C'è un foglio di carta!", spanish=" ¡Hay una hoja de papel!"})
  else
  SkySceneKit.say({english=" There's a sheet of paper here!", french=" Il y a un morceau de papier!", german=" Da liegt ein Stück Papier!", italian=" Qui c'è un foglio di carta!", spanish=" ¡Hay una hoja de papel!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="There's something written on it\nin footprint runes.", french="Il y a quelque chose d'écrit!\nCe sont des runes-empreintes.", german="Da steht etwas in\nFußabdruckrunen drauf geschrieben.", italian="C'è scritto qualcosa in\nPokéroglifici.", spanish="Hay algo escrito en inscripciones\nrúnicas."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="There's something written on it\nin footprint runes.", french="Il y a quelque chose d'écrit!\nCe sont des runes-empreintes.", german="Da steht etwas in\nFußabdruckrunen drauf geschrieben.", italian="C'è scritto qualcosa in\nPokéroglifici.", spanish="Hay algo escrito en inscripciones\nrúnicas."})
  else
  SkySceneKit.say({english="There's something written on it\nin footprint runes.", french="Il y a quelque chose d'écrit!\nCe sont des runes-empreintes.", german="Da steht etwas in\nFußabdruckrunen drauf geschrieben.", italian="C'è scritto qualcosa in\nPokéroglifici.", spanish="Hay algo escrito en inscripciones\nrúnicas."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" This is a letter from [CS:N]Grovyle[CR]!", french=" C'est une lettre de [CS:N]Massko[CR]!", german=" Das ist ein Brief von [CS:N]Reptain[CR]!", italian=" È una lettera di [CS:N]Grovyle[CR]!", spanish=" ¡Es una carta de [CS:N]Grovyle[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" This is a letter from [CS:N]Grovyle[CR]!", french=" C'est une lettre de [CS:N]Massko[CR]!", german=" Das ist ein Brief von [CS:N]Reptain[CR]!", italian=" È una lettera di [CS:N]Grovyle[CR]!", spanish=" ¡Es una carta de [CS:N]Grovyle[CR]!"})
  else
  SkySceneKit.say({english=" This is a letter from [CS:N]Grovyle[CR]!", french=" C'est une lettre de [CS:N]Massko[CR]!", german=" Das ist ein Brief von [CS:N]Reptain[CR]!", italian=" È una lettera di [CS:N]Grovyle[CR]!", spanish=" ¡Es una carta de [CS:N]Grovyle[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpRight)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It must be a message for us.[K]\nI'll read it.", french="Ça doit être un message\npour nous.[K] Je vais le lire.", german="Das muss eine Mitteilung für\nuns sein.[K] Ich lese ihn vor.", italian="Dev'essere un messaggio per\nnoi.[K] Lo leggo.", spanish="Supongo que nos contará las\núltimas novedades.[K] Voy a leerla."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It must be a message for us.[K]\nI'll read it.", french="Ça doit être un message\npour nous.[K] Je vais le lire.", german="Das muss eine Mitteilung für\nuns sein.[K] Ich lese ihn vor.", italian="Dev'essere un messaggio per\nnoi.[K] Lo leggo.", spanish="Supongo que nos contará las\núltimas novedades.[K] Voy a leerla."})
  else
  SkySceneKit.say({english="It must be a message for us.[K]\nI'll read it.", french="Ça doit être un message\npour nous.[K] Je vais le lire.", german="Das muss eine Mitteilung für\nuns sein.[K] Ich lese ihn vor.", italian="Dev'essere un messaggio per\nnoi.[K] Lo leggo.", spanish="Supongo que nos contará las\núltimas novedades.[K] Voy a leerla."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(120) end) -- bgm_ChangeVolume vers 0 (silence)
  GROUND:EntTurn(partner, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpRight)
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN][partner] began reading\n[CN]the letter from [CS:N]Grovyle[CR].", french="[CN][partner] commence à lire\n[CN]la lettre de [CS:N]Massko[CR].", german="[CN][partner] liest den Brief\n[CN]von [CS:N]Reptain[CR] vor.", italian="[CN][partner] comincia a leggere\n[CN]la lettera di [CS:N]Grovyle[CR].", spanish="[CN][partner] empezó a leer\n[CN]la carta de [CS:N]Grovyle[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- bgm2_PlayFadeIn(BGM_TIME_GEAR_REMIX) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="\"To [hero] and [partner]:[K]\nHow are you doing?\"", french="\"[hero] et [partner],[K]\nComment ça va, vous autres?", german="[F:S2]An [hero] und [partner]:[K]\nWie geht es euch?[F:E2]", italian="\"Per [hero] e [partner]:[K]\nCome va?\"", spanish="\"A [hero] y [partner]:[K]\n¿Qué tal os va?\""})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="\\\"How goes your search for the [CS:P]Hidden Land[CR]?\\\"", french="Où en sont vos recherches au sujet des [CS:P]Terres\nIllusoires[CR]?", german="[F:S2]Wie läuft eure Suche nach dem\n[CS:P]Verborgenen Land[CR]?[F:E2]", italian="\"Come prosegue la vostra ricerca della\n[CS:P]Terra Nascosta[CR]?\"", spanish="\\\"¿Cómo va la búsqueda de la [CS:P]Tierra Oculta[CR]?\\\""})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="\"Things are going well on my end. I've already\ncollected three Time Gears.\"", french="Tout va bien de mon côté. J'ai déjà récupéré\ntrois Rouages du Temps.", german="[F:S2]Für mich läuft es ganz gut. Ich habe schon\ndrei Zahnräder der Zeit eingesammelt.[F:E2]", italian="\"A me le cose stanno andando bene. Ho già\nraccolto tre Ingranaggi del Tempo.\"", spanish="\"A mí las cosas me van bien. Ya he recogido\ntres Engranajes del Tiempo.\""})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="\\\"I have to find only two more Time Gears.\\\"", french="Il n'en reste plus que deux à trouver.", german="[F:S2]Ich muss nur noch zwei Zahnräder der Zeit\nfinden.[F:E2]", italian="\\\"Devo trovarne solo altri due.\\\"", spanish="\\\"Solo me falta encontrar otros dos.\\\""})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="\\\"I plan to join you when I've collected all five.\\\"", french="Je vous rejoindrai dès que je les aurai tous\nles cinq.", german="[F:S2]Und ich habe vor, wieder zu euch zu stoßen,\nsobald ich alle fünf Zahnräder der Zeit habe.[F:E2]", italian="\"Pensavo di raggiungervi quando li avrò tutti\ne cinque.\"", spanish="\\\"Nos reuniremos cuando tenga los cinco.\\\""})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="\"Plans have proceeded smoothly. [CS:N]Azelf[CR] and his\nfriends understood the situation. And they have\nfully cooperated.\"", french="Le plan fonctionne parfaitement. [CS:N]Créfadet[CR]\net ses amis ont compris la situation, et m'ont\napporté leur entière coopération.", german="[F:S2]Alles läuft nach Plan. [CS:N]Tobutz[CR] und seine\nFreunde haben die Situation verstanden und\nkooperieren.[F:E2]", italian="\"Il piano procede senza intoppi. [CS:N]Azelf[CR] e i suoi\namici hanno compreso la situazione. E hanno\ncooperato pienamente.\"", spanish="\"El plan va como estaba previsto. [CS:N]Azelf[CR] y\nsus amigos han entendido la situación y\nhan prestado toda su ayuda.\""})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="\"[CS:N]Azelf[CR] told me that members of your guild let\nthem know I was coming. Thank you.\"", french="[CS:N]Créfadet[CR] m'a dit que des membres de votre\nGuilde les avaient avertis de ma venue.\nMerci beaucoup.", german="[F:S2][CS:N]Tobutz[CR] erzählte mir, dass Mitglieder eurer\nGilde sie wissen ließen, dass ich käme. Vielen\nDank dafür.[F:E2]", italian="\"[CS:N]Azelf[CR] mi ha detto che i membri della vostra\nGilda gli avevano comunicato che sarei\npassato. Grazie.\"", spanish="\"[CS:N]Azelf[CR] me dijo que los miembros del\n[CS:N]Pokégremio[CR] le advirtieron de que iba para allá.\nGracias.\""})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="\"It's heartening to know that more and more\nPokémon are coming to trust us.\"", french="Ça fait chaud au cœur de savoir que de plus\nen plus de Pokémon croient en nous.", german="[F:S2]Es ist ermutigend, dass immer mehr Pokémon\ndazu übergehen, mir zu vertrauen.[F:E2]", italian="\"È incoraggiante sapere che sempre più\nPokémon cominciano a credere in noi.\"", spanish="\"Es reconfortante saber que cada vez hay\nmás Pokémon que entienden la situación.\""})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="\"However, I will continue to stay away from\nTreasure Town and the guild.\"", french="Cependant, je vais continuer à me tenir\nà l'écart de Bourg-Trésor et de la Guilde.", german="[F:S2]Trotzdem werde ich mich von Schatzstadt\nund der Gilde fernhalten.[F:E2]", italian="\"Comunque, continuerò a tenermi lontano da\nBorgo Tesoro e dalla Gilda.\"", spanish="\"Sin embargo, seguiré sin acercarme\na Aldea Tesoro ni al [CS:N]Pokégremio[CR].\""})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="\"First, I'm not certain if the Pokémon in this\nworld trust me entirely or not.\"", french="D'abord parce que je ne suis pas certain que\nles Pokémon de ce monde aient totalement\nconfiance en moi.", german="[F:S2]Zunächst einmal, weil ich nicht weiß, ob mir\ndie Pokémon in dieser Welt völlig vertrauen.[F:E2]", italian="\"Innanzitutto, non sono sicuro che in questo\nmondo tutti i Pokémon si fidino completamente\ndi me.\"", spanish="\"Para empezar, no estoy seguro de que\nlos Pokémon de este mundo confíen del\ntodo en mí.\""})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="\"But there's something more troubling\nthan that.\"", french="Mais il y a autre chose qui me tracasse encore\nplus.", german="[F:S2]Aber es gibt noch etwas Beunruhigenderes.[F:E2]", italian="\\\"Ma c'è qualcosa che mi preoccupa di più.\\\"", spanish="\\\"Y hay algo mucho más inquietante.\\\""})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="\"[CS:N]Dusknoir[CR] is liable to return from the future\nat any time.\"", french="[CS:N]Noctunoir[CR] est susceptible de revenir du futur\nà n'importe quel moment.\"", german="[F:S2]Es ist damit zu rechnen, dass [CS:N]Zwirrfinst[CR]\njederzeit aus der Zukunft zurückkommen\nkann.[F:E2]", italian="\"[CS:N]Dusknoir[CR] potrebbe tornare dal futuro\nin qualsiasi momento.\"", spanish="\"[CS:N]Dusknoir[CR] puede volver del futuro en cualquier\nmomento.\""})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]Dusknoir[CR]?!", french=" [CS:N]Noctunoir[CR]?!", german=" [CS:N]Zwirrfinst[CR]?!?", italian=" [CS:N]Dusknoir[CR]?!", spanish=" ¡¿[CS:N]Dusknoir[CR]?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]Dusknoir[CR]?!", french=" [CS:N]Noctunoir[CR]?!", german=" [CS:N]Zwirrfinst[CR]?!?", italian=" [CS:N]Dusknoir[CR]?!", spanish=" ¡¿[CS:N]Dusknoir[CR]?!"})
  else
  SkySceneKit.say({english=" [CS:N]Dusknoir[CR]?!", french=" [CS:N]Noctunoir[CR]?!", german=" [CS:N]Zwirrfinst[CR]?!?", italian=" [CS:N]Dusknoir[CR]?!", spanish=" ¡¿[CS:N]Dusknoir[CR]?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpRight)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Come to think of it...", french=" Réflexion faite...", german=" Wenn man darüber nachdenkt...", italian=" Ora che ci penso...", spanish=" Ahora que lo pienso..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Come to think of it...", french=" Réflexion faite...", german=" Wenn man darüber nachdenkt...", italian=" Ora che ci penso...", spanish=" Ahora que lo pienso..."})
  else
  SkySceneKit.say({english=" Come to think of it...", french=" Réflexion faite...", german=" Wenn man darüber nachdenkt...", italian=" Ora che ci penso...", spanish=" Ahora que lo pienso..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[CS:N]Dusknoir[CR] failed to get rid of us\nin the future.", french="[CS:N]Noctunoir[CR] n'a pas réussi\nà se débarrasser de nous dans le futur.", german="[CS:N]Zwirrfinst[CR] ist uns in der\nZukunft nicht endgültig losgeworden.", italian="[CS:N]Dusknoir[CR] non è riuscito\na liberarsi di noi nel futuro.", spanish="[CS:N]Dusknoir[CR] no consiguió librarse\nde nosotros en el futuro."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[CS:N]Dusknoir[CR] failed to get rid of us\nin the future.", french="[CS:N]Noctunoir[CR] n'a pas réussi\nà se débarrasser de nous dans le futur.", german="[CS:N]Zwirrfinst[CR] ist uns in der\nZukunft nicht endgültig losgeworden.", italian="[CS:N]Dusknoir[CR] non è riuscito\na liberarsi di noi nel futuro.", spanish="[CS:N]Dusknoir[CR] no consiguió librarse\nde nosotros en el futuro."})
  else
  SkySceneKit.say({english="[CS:N]Dusknoir[CR] failed to get rid of us\nin the future.", french="[CS:N]Noctunoir[CR] n'a pas réussi\nà se débarrasser de nous dans le futur.", german="[CS:N]Zwirrfinst[CR] ist uns in der\nZukunft nicht endgültig losgeworden.", italian="[CS:N]Dusknoir[CR] non è riuscito\na liberarsi di noi nel futuro.", spanish="[CS:N]Dusknoir[CR] no consiguió librarse\nde nosotros en el futuro."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It makes sense that he'd come\nback to our world after us.", french="Ce serait logique qu'il revienne\ndans notre monde pour finir le boulot.", german="Es ergäbe Sinn für ihn, uns in\ndiese Welt nachzufolgen.", italian="È possibile che voglia tornare\nnel nostro mondo per cercarci.", spanish="Es lógico que vuelva a nuestro\nmundo a intentar acabar lo que empezó."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I wouldn't put it past him to\nchase us here. He still wants us gone.", french="Ce serait logique qu'il revienne\ndans notre monde pour finir le boulot.", german="Ich würde nicht ausschließen,\ndass er uns hier jagen würde. Er will uns\nimmer noch beseitigen.", italian="È possibile che voglia tornare\nnel nostro mondo per cercarci.", spanish="Si ya vino una vez, es lógico\nque lo intente de nuevo. Y esta vez no\ntendrá contemplaciones."})
  else
  SkySceneKit.say({english="I wouldn't put it past him to\nchase us here. He still wants us gone.", french="Ce serait logique qu'il revienne\ndans notre monde pour finir le boulot.", german="Ich würde nicht ausschließen,\ndass er uns hier jagen würde. Er will uns\nimmer noch beseitigen.", italian="È possibile che voglia tornare\nnel nostro mondo per cercarci.", spanish="Es lógico que vuelva a nuestro\nmundo a intentar acabar lo que empezó."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpRight)
  GAME:WaitFrames(15)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" All right, let me keep reading.", french=" Bon, je continue.", german="Alles klar, lass mich\nweiterlesen.", italian=" Ok, continuo a leggere.", spanish=" Muy bien. Seguiré leyendo..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" OK, I'll keep reading.", french=" Bon, je continue.", german=" Okay, ich lese weiter.", italian=" Ok, continuo a leggere.", spanish=" Muy bien. Seguiré leyendo..."})
  else
  SkySceneKit.say({english=" OK, I'll finish reading.", french=" Bon, je continue.", german=" Okay, ich lese noch zu Ende.", italian=" Ok, continuo a leggere.", spanish=" Muy bien. Seguiré leyendo..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="\"Since [CS:N]Dusknoir[CR] will be coming, we should keep\na low profile.\"", french="\"Puisque [CS:N]Noctunoir[CR] va sûrement revenir,\non ferait mieux de garder profil bas.", german="[F:S2]Da [CS:N]Zwirrfinst[CR] kommen wird, sollten wir uns\nunauffällig verhalten.[F:E2]", italian="\"Dal momento che [CS:N]Dusknoir[CR] potrebbe tornare,\ndobbiamo tenere un profilo basso.\"", spanish="\"Como [CS:N]Dusknoir[CR] vendrá tarde o temprano,\nlo mejor será no llamar mucho la atención.\""})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="\"This is another reason I should stay away\nfrom Treasure Town and the guild.\"", french="Raison de plus pour que je garde mes distances\navec Bourg-Trésor et la Guilde.", german="[F:S2]Dies ist ein anderer Grund, warum ich\nSchatzstadt und die Gilde meiden werde.[F:E2]", italian="\"Questa è un'altra ragione per cui mi tengo\nalla larga da Borgo Tesoro e dalla Gilda.\"", spanish="\"Ese es otro motivo por el que no quiero\nacercarme ni al [CS:N]Pokégremio[CR] ni a Aldea Tesoro.\""})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="\"I may instead come back to Sharpedo Bluff or\nthe beach.\"", french="Je vous attendrai plutôt à la Falaise Sharpedo\nou sur la plage.", german="[F:S2]Stattdessen werde ich vielleicht zur\nTohaido-Klippe oder zum Strand kommen.[F:E2]", italian="\"Invece potrei tornare al Promontorio Sharpedo\no in spiaggia.\"", spanish="\"Si vuelvo, estaré en el Risco Sharpedo\no en la playa.\""})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="\"If we should meet, we can then exchange\ninformation.\"", french="Si jamais on se retrouve, on pourra échanger\ndes informations plus précises.", german="[F:S2]Falls wir uns treffen, können wir dann\nInformationen austauschen.[F:E2]", italian="\"Se ci incontriamo, possiamo scambiarci\nqualche informazione.\"", spanish="\"Cuando nos encontremos, intercambiaremos\ninformación.\""})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="\\\"Good luck on your end.\\\"", french="Bonne chance à vous.", german="[F:S2]Euch in jedem Fall viel Glück.[F:E2]", italian="\\\"Buona fortuna per tutto.\\\"", spanish="\\\"Que tengáis mucha suerte.\\\""})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="\"Together, we shall stop the planet's paralysis.\"\n- From [CS:N]Grovyle[CR]", french="Ensemble, on empêchera la Paralysie\nde la Planète.\"\n- [CS:N]Massko[CR]", german="[F:S2]Wir stoppen die Lähmung des Planeten!\n- Von [CS:N]Reptain[CR][F:E2]", italian="\"Insieme, possiamo fermare la paralisi del\npianeta.\"\n- Il vostro [CS:N]Grovyle[CR] -", spanish="\"Juntos, detendremos la parálisis del planeta.\"\nFirmado: [CS:N]Grovyle[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="...[K]OK, it sounds like [CS:N]Grovyle[CR] is\nhard at work.", french="... [K]Bon, on dirait que [CS:N]Massko[CR]\nne chôme pas.", german="...[K]Okay, scheint, als wäre\n[CS:N]Reptain[CR] sehr beschäftigt.", italian="...[K] Ok, sembra che [CS:N]Grovyle[CR] si\nstia impegnando al massimo.", spanish="Vaya...[K] Es evidente que [CS:N]Grovyle[CR]\nno ha perdido el tiempo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="...[K]OK, it sounds like [CS:N]Grovyle[CR] is\nhard at work.", french="... [K]Bon, on dirait que [CS:N]Massko[CR]\nne chôme pas.", german="...[K]Okay, scheint, als wäre\n[CS:N]Reptain[CR] sehr beschäftigt.", italian="...[K] Ok, sembra che [CS:N]Grovyle[CR] si\nstia impegnando al massimo.", spanish="Vaya...[K] Es evidente que [CS:N]Grovyle[CR]\nno ha perdido el tiempo."})
  else
  SkySceneKit.say({english="...[K]OK, it sounds like [CS:N]Grovyle[CR] is\nhard at work.", french="... [K]Bon, on dirait que [CS:N]Massko[CR]\nne chôme pas.", german="...[K]Okay, scheint, als wäre\n[CS:N]Reptain[CR] sehr beschäftigt.", italian="...[K] Ok, sembra che [CS:N]Grovyle[CR] si\nstia impegnando al massimo.", spanish="Vaya...[K] Es evidente que [CS:N]Grovyle[CR]\nno ha perdido el tiempo."})
  end
  -- bgm_ChangeVolume(60,256) [volume BGM non scriptable en Lua PMDO: piste maintenue - documenté]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpRight)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We'd better hold up our end too.", french="On ferait mieux de tenir notre\npromesse nous aussi.", german="Wir tragen besser auch unseren\nTeil zu einem Erfolg bei.", italian="Sarà meglio che anche noi\ncerchiamo di raggiungere il nostro obiettivo.", spanish="Nosotros también tendremos que\nestar a la altura."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" We'd better not fail on our end.", french="On ferait mieux de tenir notre\npromesse nous aussi.", german="Wir sollten mit unserer Aufgabe\nbesser auch nicht scheitern.", italian="Non dobbiamo fallire il nostro\nobiettivo.", spanish="Nosotros también tendremos que\nestar a la altura."})
  else
  SkySceneKit.say({english=" We can't fail on our end.", french="On ferait mieux de tenir notre\npromesse nous aussi.", german="Wir dürfen mit unserem Teil\nnicht scheitern.", italian="Non possiamo fallire il nostro\nobiettivo.", spanish="Nosotros también tendremos que\nestar a la altura."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpRight)
  GAME:WaitFrames(15)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="According to this letter...[K][CS:N]Grovyle[CR]\nwill show up either here or at the beach.", french="D'après ce qu'il dit dans\nsa lettre... [K][CS:N]Massko[CR] nous attendra ici\nou sur la plage.", german="Diesem Brief nach[K] taucht\n[CS:N]Reptain[CR] entweder hier oder am Strand wieder\nauf.", italian="A quanto dice in questa\nlettera...[K] [CS:N]Grovyle[CR] si farà vedere qui\no in spiaggia.", spanish="Según esta carta...[K] [CS:N]Grovyle[CR]\npodría volver aquí o a la playa."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="According to this letter...[K][CS:N]Grovyle[CR]\nwill show up either here or at the beach.", french="D'après ce qu'il dit dans\nsa lettre... [K][CS:N]Massko[CR] nous attendra ici\nou sur la plage.", german="Diesem Brief nach[K] taucht\n[CS:N]Reptain[CR] entweder hier oder am Strand wieder\nauf.", italian="A quanto dice in questa\nlettera...[K] [CS:N]Grovyle[CR] si farà vedere qui\no in spiaggia.", spanish="Según esta carta...[K] [CS:N]Grovyle[CR]\npodría volver aquí o a la playa."})
  else
  SkySceneKit.say({english="According to this letter...[K][CS:N]Grovyle[CR]\nwill show up either here or at the beach.", french="D'après ce qu'il dit dans\nsa lettre... [K][CS:N]Massko[CR] nous attendra ici\nou sur la plage.", german="Diesem Brief nach[K] taucht\n[CS:N]Reptain[CR] entweder hier oder am Strand wieder\nauf.", italian="A quanto dice in questa\nlettera...[K] [CS:N]Grovyle[CR] si farà vedere qui\no in spiaggia.", spanish="Según esta carta...[K] [CS:N]Grovyle[CR]\npodría volver aquí o a la playa."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpRight)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Maybe we will see [CS:N]Grovyle[CR] if we\ngo down to the beach.", french="Peut-être qu'on le verra\nsi on va à la plage.", german="Vielleicht treffen wir [CS:N]Reptain[CR],\nfalls wir zum Strand gehen.", italian="Forse possiamo incontrare\n[CS:N]Grovyle[CR] se scendiamo in spiaggia.", spanish="Bajemos a la playa a ver si\nestá..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="If we go down to the beach,\nmaybe we will see [CS:N]Grovyle[CR] there.", french="Peut-être qu'on le verra\nsi on va à la plage.", german="Falls wir runter zum Strand\ngehen, sehen wir [CS:N]Reptain[CR] dort vielleicht.", italian="Se scendiamo in spiaggia, forse\npossiamo incontrare [CS:N]Grovyle[CR].", spanish="Bajemos a la playa a ver si\nestá..."})
  else
  SkySceneKit.say({english="If we go down to the beach,\nmaybe we will see [CS:N]Grovyle[CR] there.", french="Peut-être qu'on le verra\nsi on va à la plage.", german="Falls wir runter zum Strand\ngehen, sehen wir [CS:N]Reptain[CR] dort vielleicht.", italian="Forse, se scendiamo in spiaggia,\nincontreremo [CS:N]Grovyle[CR].", spanish="Bajemos a la playa a ver si\nestá..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's go down to the beach\nbefore we go back to the guild.", french="Passons par la plage\nen retournant à la Guilde.", german="Lass uns zum Strand gehen,\nbevor wir zurück zur Gilde gehen.", italian="Andiamo in spiaggia prima\ndi tornare alla Gilda.", spanish="Podemos pasarnos antes de\nvolver al [CS:N]Pokégremio[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We should go down to the beach\nbefore we go back to the guild.", french="Passons par la plage\nen retournant à la Guilde.", german="Wir sollten zum Strand gehen,\nbevor wir zurück zur Gilde gehen.", italian="Possiamo passare dalla spiaggia\nprima di tornare alla Gilda.", spanish="Podemos pasarnos antes de\nvolver al [CS:N]Pokégremio[CR]."})
  else
  SkySceneKit.say({english="Let's go to the beach before we\ngo back to the guild.", french="Passons par la plage\nen retournant à la Guilde.", german="Lass uns zum Strand gehen,\nbevor wir zurück zur Gilde gehen.", italian="Andiamo in spiaggia prima\ndi tornare alla Gilda.", spanish="Podemos pasarnos antes de\nvolver al [CS:N]Pokégremio[CR]."})
  end
  -- message_Close
end
