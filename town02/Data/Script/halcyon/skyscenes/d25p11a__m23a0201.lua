-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D25P11A/m23a0201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D25P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- bgm2_PlayFadeIn(BGM_OCEAN1) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- message_FacePositionOffset(-2, -1) [neutre/état moteur]
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 256, 192, Direction.Down, "NPC_PERAPPU")
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Now listen, everyone.", french=" Ecoutez bien, vous autres.", german=" Hört mir mal alle zu.", italian=" Ora ascoltatemi tutti.", spanish=" Ahora escuchadme todos."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="This is the entrance to [CS:P]Brine\nCave[CR].", french="Voici l'entrée de la [CS:P]Caverne\nSaline[CR].", german="Dies ist der Eingang zur\n[CS:P]Salzwasserhöhle[CR].", italian="Questo è l'ingresso della [CS:P]Grotta[CR]\n[CS:P]Salmastra[CR].", spanish="Esta es la entrada a\nla [CS:P]Cueva Aguamar[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Your objective is to reach the\ndeepest part of this dungeon.", french="Votre objectif est d'en atteindre\nle fond.", german="Euer Ziel ist es, auf die tiefste\nEbene dieses Dungeons zu gelangen.", italian="Il vostro obiettivo è di\nraggiungere il cuore del dungeon.", spanish="Vuestro objetivo es llegar a\nlo más profundo de este territorio."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="That is where one will find the\nsame odd pattern inscribed on the Relic\nFragment that [partner] has.", french="C'est là que vous trouverez\nle même symbole étrange que celui gravé\nsur le Fragment de Relique de [partner].", german="Dort findet man die gleichen\nseltsamen Muster wie auf dem Reliktfragment,\ndas [partner] hat.", italian="Laggiù troverete lo stesso\nstrano disegno che è inciso sul Frammento\nAntico di [partner].", spanish="Allí se encuentra el extraño\ndibujo que también tiene la Reliquia de\nPiedra de [partner]."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="However, it is there where\nan extremely vicious Pokémon lurks.", french="Cependant, c'est là aussi que\nse cache une horrible fripouille.", german="Allerdings lauert dort ein extrem\nboshaftes Pokémon.", italian="Comunque, è lì che si\nnasconde quel Pokémon estremamente\nmalvagio.", spanish="Sin embargo, un Pokémon\nparticularmente despiadado puede acechar\nen esa parte de la cueva."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 288, 224, Direction.UpLeft, "NPC_BIPPA")
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" E-extremely vicious?", french=" Une horrible fripouille?", german=" E-extrem boshaft?", italian=" E-Estremamente malvagio?", spanish=" ¿Particularmente despiadado?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_bippa.Position; GROUND:MoveToPosition(npc_npc_bippa, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=npc_npc_bippa.Position; GROUND:MoveToPosition(npc_npc_bippa, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=npc_npc_bippa.Position; GROUND:MoveToPosition(npc_npc_bippa, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=npc_npc_bippa.Position; GROUND:MoveToPosition(npc_npc_bippa, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=npc_npc_bippa.Position; GROUND:MoveToPosition(npc_npc_bippa, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=npc_npc_bippa.Position; GROUND:MoveToPosition(npc_npc_bippa, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=npc_npc_bippa.Position; GROUND:MoveToPosition(npc_npc_bippa, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=npc_npc_bippa.Position; GROUND:MoveToPosition(npc_npc_bippa, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Golly, that sounds scary! Gulp!", french="Sapristi, ça m'fiche la frousse!\nGloups!", german="Donnerwetter, das hört sich\nschrecklich an! Schluck!", italian=" Ohibò, che paura! Gulp!", spanish=" ¡Glup! ¡Huyuyuy, qué miedo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 256, 232, Direction.Up, "NPC_HEIGANI")
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" Hey, hey! [CS:N]Chatot[CR]!", french=" Eh dis donc, [CS:N]Pijako[CR]!", german=" Hey, hey! [CS:N]Plaudagei[CR]!", italian=" Ehi, ehi! [CS:N]Chatot[CR]!", spanish=" ¡Oye, oye! ¡[CS:N]Chatot[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-2, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" What is it?", french=" Qu'est-ce qui se passe?", german=" Was gibt es?", italian=" Cosa c'è?", spanish=" ¿Qué pasa?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Yesterday, Guildmaster said\nsomething about that vicious Pokémon.", french="Hier, le Maître nous a parlé\nde ce Pokémon sans foi ni loi.", german="Gestern hat der Gildenmeister\netwas über dieses Pokémon erzählt.", italian="Ieri il Capitano ha detto\nqualcosa a proposito di quel Pokémon cattivo.", spanish="Ayer, el Gran Bluff dijo algo\nsobre ese malvado Pokémon."})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="But, [CS:N]Chatot[CR], you seem to know\njust as much about this dungeon, hey, hey?", french="Mais dis donc, [CS:N]Pijako[CR], on dirait\nque tu en sais autant que lui sur ce donjon...", german="Aber du, [CS:N]Plaudagei[CR], scheinst\ngenauso viel über diesen Dungeon zu wissen,\nhey, hey?", italian="Ma, [CS:N]Chatot[CR], sembra che tu\nne sappia altrettanto a proposito di questo\ndungeon, ehi, ehi!", spanish="Pero, tú también pareces saber\nmucho sobre este territorio."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(2, 0) [neutre/état moteur]
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 224, 256, Direction.UpRight, "NPC_CHIRIIN")
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="[CS:N]Chatot[CR], is it possible that you've\nbeen here before?", french="[CS:N]Pijako[CR], se pourrait-il\nque tu sois déjà venu ici?", german="[CS:N]Plaudagei[CR], ist es möglich, dass\ndu hier schon einmal warst?", italian="[CS:N]Chatot[CR], non è che sei già\nstato qui prima?", spanish=" ¿Has estado aquí antes, [CS:N]Chatot[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-2, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="That's right.[K] I have come\nhere before.", french="C'est exact.[K] Je suis déjà\nvenu ici.", german="So ist es.[K] Ich bin schon einmal\nhierhergekommen.", italian=" È vero.[K] Ci sono già stato.", spanish=" Sí.[K] Ya he estado aquí antes."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="I explored here a long time ago.\nWith the Guildmaster.", french="Il y a bien longtemps, le Maître\net moi-même avons exploré cet endroit\nensemble.", german="Ich habe hier vor langer Zeit\neine Erkundung durchgeführt. Zusammen mit\ndem Gildenmeister.", italian="L'ho esplorato molto tempo fa.\nCon il Capitano.", spanish="Exploré este lugar hace mucho\ntiempo, con el Gran Bluff."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="It was deep in this cave that we\nsaw the peculiar pattern.", french="Et c'est tout au fond de cette\ncaverne que nous avons vu ce symbole\nétrange.", german="Tief in dieser Höhle haben wir\ndieses seltsame Muster gesehen.", italian="Quel disegno particolare\nl'abbiamo visto in fondo alla grotta.", spanish="Fue en el interior de esta\ncaverna donde encontramos ese extraño\ndibujo."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" It was then, however...", french=" C'est à ce moment-là...", german=" Damals...", italian=" Comunque, è stato allora...", spanish=" Aunque también fue aquí..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Those tough Pokémon appeared.", french="... que des Pokémon très\ncoriaces ont fait leur apparition.", german="Damals erschienen diese brutalen\nPokémon.", italian="Che sono apparsi quei\nPokémon.", spanish="Donde aparecieron aquellos\npeligrosos Pokémon."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 192, 248, Direction.UpRight, "NPC_DOGOOMU")
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "sweatdrop", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="Gulp...[K] S-so, what were they\nlike? Tough, you say?", french="Gloups...[K] Alors, comment\nils étaient? Coriaces, tu dis?", german="Schluck...[K] A-also, wie waren die\ndenn so? Brutal, sagst du?", italian="Gulp...[K] A-Allora, com'erano?\nForti, dicevi?", spanish="¡Glup![K] Y... ¿cómo eran?\n¿Peligrosos, dices?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-2, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Uh...[K]I don't remember at all.", french="Euh...[K] je ne m'en souviens pas du\ntout.", german="Äh...[K] Das weiß ich gar nicht\nmehr.", italian=" Ah...[K] Non mi ricordo più nulla.", spanish=" Pues...[K] No lo recuerdo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "shock", 1) end)
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 312, 248, Direction.UpLeft, "NPC_DAGUTORIO")
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "shock", 1) end)
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 280, 256, Direction.Up, "NPC_GUREGGURU")
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "exclaim", 1) end)
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 312, 216, Direction.Left, "NPC_KIMAWARI")
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" Huh?![K] You don't REMEMBER?!", french=" Hein?![K] Tu ne t'en souviens PAS?!", german="Häh?!?[K] Das weißt du NICHT\nMEHR?!?", italian=" Eh?![K] Non ti RICORDI?!", spanish="¡¿Qué?![K] ¿Cómo que no lo\nrecuerdas?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-2, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Yes, but I'm loath to admit it.", french="Oui, bien qu'il m'en coûte\nde l'admettre.", german="Ja, aber ich schäme mich, das\nzuzugeben.", italian=" Sì, ma odio ammetterlo.", spanish=" Me da vergüenza admitirlo."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="They attacked with no warning\nout of nowhere.", french="Ils nous sont tombés dessus\nsans crier gare.", german="Sie haben uns ohne Vorwarnung\naus dem Nichts angegriffen.", italian="Sono spuntati dal nulla e ci hanno\nattaccato.", spanish="Atacaron sin previo aviso,\nno sé de dónde salieron."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="I was knocked out before I could\ndo a thing.", french="J'ai été mis K.O. avant d'avoir\npu faire quoi que ce soit.", german="Ich ging zu Boden, bevor ich\nirgendetwas tun konnte.", italian="Sono andato KO senza avere il\ntempo di far niente.", spanish="Quedé fuera de combate antes\nde poder mover ni una pluma."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="When I came to, the Guildmaster\nwas tending to my wounds.", french="Quand je suis revenu à moi,\nle Maître était en train de panser\nmes blessures.", german="Als ich zu mir kam, versorgte\nder Gildenmeister meine Wunden.", italian="Quando mi sono ripreso, il\nCapitano si stava occupando delle mie ferite.", spanish="Cuando me desperté, el Gran\nBluff estaba curando mis heridas."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="But I had no memory of events\nbefore that.", french="Mais je ne me souvenais pas\ncomment j'étais arrivé là.", german="Aber ich kann mich an die davor\nliegenden Ereignisse nicht erinnern.", italian="Ma non ricordo nulla di quello\nche è successo.", spanish=" Pero no recuerdo nada más."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="So I couldn't tell you what the\nattackers were like.[K] Sigh...", french="Alors je ne peux pas vous\nen dire plus au sujet de nos assaillants.[K]\nPfff...", german="Also kann ich euch nichts\nNäheres über die Angreifer sagen.[K] Seufz...", italian="Quindi non so dirvi com'erano\ni Pokémon che ci hanno attaccato.[K] Sigh...", spanish="Así que no puedo deciros cómo\neran.[K] Lo siento."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" That gives us nothing to go on.", french="Voilà qui ne nous avance pas\nbeaucoup.", german=" Damit kommen wir nicht weiter.", italian="Quindi non abbiamo nessun\nindizio.", spanish="Pues eso no nos da mucho\nmargen de maniobra."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="So we don't know the kind of\nenemy we're facing? We'll have to make our\nway slowly...", french="Et alors, on ne sait pas à quel\ngenre d'ennemis on a affaire? On n'aura qu'à\navancer prudemment...", german="Wir wissen also nicht, mit\nwelcher Art von Gegner wir es zu tun haben?\nDann sollten wir vorsichtig vorgehen...", italian="Non sappiamo che tipo di nemici\naffronteremo? Dovremo fare molta\nattenzione...", spanish="Así que no sabemos contra qué\nenemigo nos enfrentamos... ¡Pues tendremos\nque avanzar con cautela!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(20), p.Y+(-12), false, 2) end
  GROUND:EntTurn(partner, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-3, -1) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Wait a second.", french=" Attendez une seconde.", german=" Wartet mal.", italian=" Aspettate un secondo.", spanish=" Esperad un momento."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wait a second.", french=" Attendez une seconde.", german=" Wartet mal.", italian=" Aspettate un secondo.", spanish=" Esperad un momento."})
  else
  SkySceneKit.say({english=" Wait, please.", french=" Attendez une seconde.", german=" Wartet mal, bitte.", italian=" Aspettate, per favore.", spanish=" Esperad un momento."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, partner, 4) end)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_bippa, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.UpRight)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, partner, 4) end)
  GAME:WaitFrames(5)
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 248, 256, Direction.Up, "NPC_DIGUDA")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, partner, 4) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  GROUND:EntTurn(partner, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey, [CS:N]Chatot[CR].", french=" Dis, [CS:N]Pijako[CR].", german=" Hey, [CS:N]Plaudagei[CR].", italian=" Ehi, [CS:N]Chatot[CR].", spanish=" Oye, [CS:N]Chatot[CR]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey, [CS:N]Chatot[CR].", french=" Dis, [CS:N]Pijako[CR].", german=" Hey, [CS:N]Plaudagei[CR].", italian=" Ehi, [CS:N]Chatot[CR].", spanish=" Oye, [CS:N]Chatot[CR]..."})
  else
  SkySceneKit.say({english=" Say, [CS:N]Chatot[CR].", french=" Dis, [CS:N]Pijako[CR].", german=" Sag mal, [CS:N]Plaudagei[CR].", italian=" Ehi, [CS:N]Chatot[CR].", spanish=" Oye, [CS:N]Chatot[CR]..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="At first you said there was one\nvicious Pokémon. But then you said \"they\"\nattacked you. There's more than one?", french="Au début, tu as parlé d'une\nhorrible fripouille. Et ensuite tu as dit qu'\"ils\"\nvous avaient attaqués. Ils sont plusieurs?", german="Zuerst sagtest du, es gebe dort\nein boshaftes Pokémon. Dann sagtest du, [F:S2]sie[F:E2]\nhätten dich angegriffen. Gibt es mehr als eins?", italian="Prima avevi detto che c'era un\nPokémon malvagio. Poi hai detto che ti \"hanno\"\nattaccato. Ce n'è più di uno?", spanish="He notado que primero hablabas\nde \"un\" Pokémon despiadado. Y luego dijiste\nque había más. ¿En qué quedamos?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="At first you said there was one\nvicious Pokémon. But then you said \"they\"\nattacked you. There's more than one?", french="Au début, tu as parlé d'une\nhorrible fripouille. Et ensuite tu as dit qu'\"ils\"\nvous avaient attaqués. Ils sont plusieurs?", german="Zuerst sagtest du, es gebe dort\nein boshaftes Pokémon. Dann sagtest du, [F:S2]sie[F:E2]\nhätten dich angegriffen. Gibt es mehr als eins?", italian="Prima avevi detto che c'era un\nPokémon malvagio. Poi hai detto che ti \"hanno\"\nattaccato. Ce n'è più di uno?", spanish="He notado que primero hablabas\nde \"un\" Pokémon despiadado. Y luego dijiste que\neran varios. Entonces, ¿hay uno o son más?"})
  else
  SkySceneKit.say({english="At first you said there was one\nvicious Pokémon. But then you said \"they\"\nattacked you. There's more than one?", french="Au début, tu as parlé d'une\nhorrible fripouille. Et ensuite tu as dit qu'\"ils\"\nvous avaient attaqués. Ils sont plusieurs?", german="Zuerst sagtest du, es gebe dort\nein boshaftes Pokémon. Dann sagtest du, [F:S2]sie[F:E2]\nhätten dich angegriffen. Gibt es mehr als eins?", italian="Prima avevi detto che c'era un\nPokémon malvagio. Poi hai detto che ti \"hanno\"\nattaccato. Ce n'è più di uno?", spanish="He notado que primero hablabas\nde \"un\" Pokémon despiadado. Y luego dijiste que\neran varios. Entonces, ¿hay uno o son más?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-2, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" ...[K]No, it wasn't just one.", french=" ... [K]Oui, ils sont plusieurs.", german=" ...[K]Nein, es war nicht nur eins.", italian=" ...[K] Sì, proprio così.", spanish=" Esto...[K] Eran varios."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="There was one extremely vicious\nPokémon. But it wasn't alone.", french="Il y en avait un qui était\nparticulièrement féroce, c'est vrai.\nMais il n'était pas seul.", german="Es gab da ein extrem boshaftes\nPokémon. Aber es war nicht allein.", italian="C'era un Pokémon estremamente\ncattivo, ma non era da solo.", spanish="Había uno particularmente\ndespiadado, pero no estaba solo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="When they attacked...[K]\nOh, I remember now!", french="Quand ils nous ont attaqués...[K]\nOh, ça y est, je me souviens!", german="Als sie angriffen...[K]\nOh, jetzt erinnere ich mich!", italian="Quando hanno attaccato...[K]\nAh, ora ricordo!", spanish="Cuando atacaron...[K]\nAh, ¡ya lo recuerdo!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="They attacked all at once...[K]\nI recall getting slammed with water...[K]\nLike a tidal wave!", french="Ils nous sont tous tombés\ndessus d'un seul coup...[K] J'ai été emporté par\nde l'eau...[K] Une sorte de raz-de-marée!", german="Sie griffen alle auf einmal an...[K]\nWasser schlug auf mich ein...[K]\nWie eine Flutwelle!", italian="Hanno attaccato tutti assieme...[K]\nE ricordo di essere stato colpito con l'acqua...[K]\nCome da una violenta ondata!", spanish="Atacaron todos a la vez...[K]\nRecuerdo haber sido golpeado por el agua...[K]\n¡Por una especie de ola gigante!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Down)
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(npc_npc_bippa, Direction.UpRight)
  GROUND:EntTurn(npc_npc_kimawari, Direction.DownLeft)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_diguda, Direction.Up)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.DownRight)
  GROUND:EntTurn(npc_npc_chiriin, Direction.UpLeft)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_heigani, Direction.Down)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Left)
  GROUND:EntTurn(npc_npc_guregguru, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" Like a tidal wave?", french=" Une sorte de raz-de-marée?", german=" Wie eine Flutwelle?", italian=" Come da una violenta ondata?", spanish=" ¿Una especie de ola gigante?"})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="That could mean Water-type\nmoves.", french="Ça voudrait dire que c'était\ndes capacités de type Eau.", german="Das könnte Attacken vom Typ\nWasser bedeuten.", italian="Forse si trattava di mosse di\ntipo Acqua.", spanish="O sea, que se trataba de\nun movimiento de tipo Agua."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="We're a Ground type. We don't\nlike water at all.", french="Nous détestons l'eau.\nNous sommes de type Sol.", german="Wir Boden-Pokémon mögen\nWasser überhaupt nicht.", italian="Noi siamo di tipo Terra. L'acqua\nnon ci fa per niente bene.", spanish="Nosotros somos de tipo Tierra,\nasí que lo llevamos claro..."})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="I hope we don't have to fight\nenemies like that.", french="Nous espérons ne pas être\nconfrontés à des ennemis de cet acabit.", german="Ich hoffe, wir müssen gegen\nkeine solchen Gegner kämpfen.", italian="Spero che non dovremo\nfronteggiare nemici del genere.", spanish="Espero que no tengamos que\nenfrentarnos a ellos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="It would be awfully dangerous to\nmake a go of it alone.", french="Ce serait terriblement dangereux\nd'y aller seul.", german="Es wäre furchtbar gefährlich,\nes auf eigene Faust zu versuchen.", italian="Sarebbe decisamente pericoloso\nandare da soli.", spanish="Sería espantosamente peligroso\nentrar ahí solos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-2, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" That's right.", french=" Exact.", german=" Das stimmt.", italian=" Ha ragione.", spanish=" Es cierto."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_perappu, 4) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_perappu, 4) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_perappu, 4) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_perappu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="We should make several groups\nto explore the cave.", french="C'est pour ça que nous allons\nnous répartir en plusieurs équipes.", german="Wir sollten uns zur Erkundung\nder Höhle in mehrere Gruppen aufteilen.", italian="Dobbiamo formare diversi gruppi\nper esplorare la grotta.", spanish="Por eso debemos formar grupos\npara explorar la cueva."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" We'll do that, sir! Yup yup!", french="C'est bien c'qu'on va\nfaire! Ouaip ouaip!", german="Jawollja! Das machen wir!\nDonnerwetter!", italian=" Lo faremo, sissignore! Già, già!", spanish=" ¡Sí, señor! ¡Eso haremos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Hey, hey! We should form teams\nthat don't bunch up types.", french="Eh dis donc, on devrait organiser\nles équipes en mélangeant les types.", german="Hey, hey! Wir sollten Teams\nbilden, die nicht nur aus einem bestimmten\nTyp bestehen.", italian="Ehi, ehi! Dobbiamo formare\nsquadre con Pokémon di tipi diversi.", spanish="¡Oye, oye! Hay que escoger bien\nqué tipos vamos a combinar."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-2, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" You two!", french=" Vous deux!", german=" Ihr beiden!", italian=" Voi due!", spanish=" A ver, ¡escuchadme!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Remember what the Guildmaster\nsaid yesterday.", french="Souvenez-vous de ce que\nle Maître a dit hier.", german="Erinnert euch daran, was der\nGildenmeister gestern sagte.", italian="Vi ricordate cosa ha detto il\nCapitano ieri?", spanish="Supongo que recordáis lo que\ndijo ayer el Gran Bluff."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="The two members from Team\n[team:] must be in my group.", french="Pour cette exploration, je vais\nme joindre à l'Equipe [team:].", german="Die zwei Mitglieder von Team\n[team:] müssen in meiner Gruppe sein.", italian="Io devo andare con il\nTeam [team:].", spanish="Los dos miembros del\n[CS:X]Equipo[CR] [team:] han de venir conmigo."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Therefore, you two shall\naccompany me when exploring this cave.", french="Par conséquent, vous\nm'accompagnerez pendant toute la durée\nde l'exploration.", german="Deswegen werdet ihr mich\nbegleiten, wenn wir diese Höhle erkunden.", italian="Quindi, dovete accompagnarmi\ndurante l'esplorazione della grotta.", spanish="Por tanto, los tres formaremos\nequipo para explorar esta cueva."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Understood?", french=" Compris?", german=" Verstanden?", italian=" Capito?", spanish=" ¿Entendido?"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="I trust you won't hold me up\ntoo much?", french="Je compte sur vous pour ne pas\nme ralentir.", german="Ich kann mich darauf verlassen,\ndass ihr mich nicht zu sehr aufhaltet?", italian="Spero che non vi appoggerete\ntroppo a me, eh?", spanish="Supongo que no me estorbaréis\nmucho, ¿verdad?"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Oh, you must not expect me to\ndo everything for you!", french="Et ne vous attendez pas non plus\nà ce que je fasse tout le travail à votre place!", german="Oh, erwartet nicht, dass ich\nalles für euch erledige!", italian="Ehi, non aspettatevi che faccia\ntutto anche per voi!", spanish="No esperaréis que os haga de\nniñera."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="It's up to you to look after\nyourselves.", french="A vous de surveiller\nvos arrières.", german="Ihr müsst schon auf euch selbst\naufpassen.", italian="Cercate almeno di badare alla\nvostra salute.", spanish="Es vuestra obligación defenderos\nallí dentro."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-3, -1) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Urk! Yeah, OK.", french=" Argh! Compris.", german=" Umpf! Jaja, okay.", italian=" Uh! Sì, ok.", spanish=" ¡Vale, vale!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urk! Understood.", french=" Argh! Compris.", german=" Umpf! Verstanden.", italian=" Uh! Capito.", spanish=" ¡Vale, vale!"})
  else
  SkySceneKit.say({english=" Urk! Understood.", french=" Argh! Compris.", german=" Umpf! Verstanden.", italian=" Uh! Capito.", spanish=" ¡Vale, vale!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-2, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="All right, everyone![K] We're off\nto conquer [CS:P]Brine Cave[CR]!", french="Très bien, vous autres![K] Partons\nà la conquête de la [CS:P]Caverne Saline[CR]!", german="Alles klar, Leute![K] Erobern wir\ndie [CS:P]Salzwasserhöhle[CR]!", italian="Va bene, gente![K] Andiamo alla\nconquista della [CS:P]Grotta Salmastra[CR]!", spanish="¡Muy bien![K] ¡Nos vamos a\nconquistar la [CS:P]Cueva Aguamar[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Let's give it our all!", french=" Donnons notre maximum!", german=" Lasst uns alles geben!", italian=" Dobbiamo mettercela tutta!", spanish=" ¡Hay que emplearse a fondo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, "happy", 1) end)
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
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: HOORAY!", french="[CS:N]Tous[CR]: HOURRA!", german="[CS:N]Alle[CR]: HURRA!", italian="[CS:N]Tutti[CR]: URRÀ!", spanish="[CS:N]Todos[CR]: ¡HURRA!"})
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
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(30)
  -- GAP: se_Play(6916) — id SE NDS sans portage PMDO identifié
  GROUND:MoveToPosition(npc_npc_perappu, 252, 156, false, 2)
  GAME:WaitFrames(7)
  GROUND:MoveToPosition(partner, 252, 156, false, 2)
  GAME:WaitFrames(2)
  GROUND:MoveToPosition(hero, 252, 156, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(npc_npc_kimawari, 252, 156, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(npc_npc_heigani, 252, 156, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(npc_npc_bippa, 252, 156, false, 2)
  GROUND:MoveToPosition(npc_npc_guregguru, 252, 156, false, 2)
  GROUND:MoveToPosition(npc_npc_dogoomu, 252, 156, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(npc_npc_chiriin, 252, 156, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(npc_npc_diguda, 252, 156, false, 2)
  GROUND:MoveToPosition(npc_npc_dagutorio, 252, 156, false, 2)
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  -- se_FadeOut(6916, 90) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  pcall(function() SOUND:FadeOutBGM(180) end)
  GAME:FadeOut(false, 30)
  GAME:WaitFrames(60)
  GAME:WaitFrames(2) -- join WaitBgm
  pcall(function() UI:SetSpeaker("Zubat", true, "zubat", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_ZUBATTO (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Heh-heh-heh, Chief![K] Looks like\nthose louts from the guild are already inside.", french="Hin hin hin, chef![K] On dirait que\nces blaireaux de la Guilde sont déjà\nà l'intérieur.", german="Hehehe, Boss![K] Sieht so aus,\nals wären die Lümmel aus der Gilde alle\nschon drinnen.", italian="Eh-eh-eh, capo![K] Sembra che\nquelle schiappe della Gilda siano ancora dentro.", spanish="Jue, jue, jue... ¡Jefe![K] Parece que\nesos zoquetes del [CS:N]Pokégremio[CR] ya han entrado."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Koffing", true, "koffing", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_DOGAASU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Whoa-ho-ho![K] Should we\nfollow them?", french="Mouarf mouarf mouarf![K]\nOn les suit?", german="Whoahoho![K] Sollen wir ihnen\nfolgen?", italian="Uooh-oh-oh![K] Dobbiamo andare\nanche noi?", spanish="¡Jo, jo, jo![K]\n¿Les seguimos?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Skuntank", true, "skuntank", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_SUKATANKU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Chaw-haw-haw! Sounds good.[K]\nWe'll track them, but let's keep out of sight.", french="Gnark gnark gnark! Ça va\nvaloir le détour.[K] On les suit, mais sans\nse faire voir.", german="Cha-ha-ha! Hört sich gut an.[K]\nWir verfolgen sie, aber lasst uns dabei\nunentdeckt bleiben.", italian="Ahr-ahr-ahr! Buona idea.[K]\nAndiamo, ma senza farci vedere.", spanish="¡Jua, jua, jua! ¡Gran idea![K]\nLes seguiremos, pero sin dejarnos ver."})
  pcall(function() UI:SetSpeaker("Skuntank", true, "skuntank", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_SUKATANKU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="When the right time comes along\nsomewhere in the cave...", french="Et quand le moment viendra,\ndans un recoin obscur de cette caverne...", german="Wenn die Zeit gekommen ist,\nirgendwo im Inneren der Höhle...", italian="Quando sarà il momento giusto,\nall'interno della grotta...", spanish="Cuando llegue el momento\noportuno..."})
  pcall(function() UI:SetSpeaker("Skuntank", true, "skuntank", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_SUKATANKU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="that's when we'll grab that\nwimpy [partner]'s Relic Fragment!", french="... on s'emparera du Fragment\nde Relique de cette poule mouillée\nde [partner]!", german="Dann schnappen wir uns dieses\nerbärmliche Reliktfragment von [partner]!", italian="Prenderemo il Frammento\nAntico da quella mezza calzetta di\n[partner].", spanish="¡Le quitaremos la Reliquia de\nPiedra a [partner]!"})
  pcall(function() UI:SetSpeaker("Skuntank", true, "skuntank", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_SUKATANKU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Then we'll hightail it to the\ndeepest part of the cave.[K] We'll grab all the\nglory of solving this mystery.", french="Ensuite on ira en vitesse au\nfond de la caverne.[K] Et alors, à nous la gloire\npour avoir résolu ce mystère!", german="Danach flitzen wir zum tiefsten\nTeil der Höhle.[K] Wir werden allen Ruhm für die\nLösung des Rätsels einsacken.", italian="Poi ci dirigeremo a tutto gas\nverso il fondo della grotta.[K] Ci prenderemo\ntutti i meriti della risoluzione del mistero.", spanish="Entonces saldremos corriendo\nhacia el fondo de la cueva.[K] Y nos quedaremos\ncon toda la gloria al resolver el misterio."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Zubat", true, "zubat", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_ZUBATTO (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Heh-heh! Brilliant, Chief![K]\nYour plan's perfect!", french="Hin hin! Brillant, chef![K]\nC'est le plan parfait!", german="Hehe! Brillant, Boss![K]\nDein Plan ist perfekt!", italian="Eh-eh! Grandioso, capo![K]\nIl tuo piano è perfetto!", spanish="¡Jue, jue! ¡Brillante, Jefe![K]\n¡Tu plan es perfecto!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Skuntank", true, "skuntank", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_SUKATANKU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Chaw-haw-haw! Naturally!", french="Gnark gnark gnark!\nNaturellement, il est de moi!", german=" Cha-ha-ha! Natürlich!", italian=" Ahr-ahr-ahr! Naturalmente!", spanish=" ¡Jua, jua, jua! Naturalmente."})
  pcall(function() UI:SetSpeaker("Skuntank", true, "skuntank", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_SUKATANKU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Anyway...", french=" Bref...", german=" Sei es drum...", italian=" Comunque...", spanish=" En cualquier caso..."})
  pcall(function() UI:SetSpeaker("Skuntank", true, "skuntank", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_SUKATANKU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="It will be us! Team [CS:X]Skull[CR]! We'll\nbe the ones going to the [CS:P]Hidden Land[CR]!", french="C'est nous, l'Equipe [CS:X]Crâne[CR]!\nNous, qui irons dans les [CS:P]Terres Illusoires[CR]!", german="Wir werden es sein! Team\n[CS:X]Totenkopf[CR]! Wir werden diejenigen sein, die\nzum [CS:P]Verborgenen Land[CR] gehen werden!", italian="Saremo noi del Team [CS:X]Teschio[CR]\ngli unici ad andare nella [CS:P]Terra[CR]\n[CS:P]Nascosta[CR]!", spanish="¡Seremos nosotros, el [CS:X]Equipo\nCalavera[CR], los que tengamos el privilegio de\nir a la [CS:P]Tierra Oculta[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Zubat", true, "zubat", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_ZUBATTO (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Heh-heh-heh!", french=" Hin hin hin!", german=" Hehehe!", italian=" Eh-eh-eh!", spanish=" ¡Jue, jue, jue!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Koffing", true, "koffing", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_DOGAASU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Whoa-ho-ho!", french=" Mouarf mouarf mouarf!", german=" Whoahoho!", italian=" Uooh-oh-oh!", spanish=" ¡Jo, jo, jo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Skuntank", true, "skuntank", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_SUKATANKU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Chaw-haw!", french=" Gnark gnark!", german=" Cha-ha!", italian=" Ahr-ahr!", spanish=" ¡Jua, jua, jua!"})
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- main_EnterDungeon(35, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
end
