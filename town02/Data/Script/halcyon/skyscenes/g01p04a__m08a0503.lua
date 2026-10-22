-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/m08a0503.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  -- back_SetGround(LEVEL_G01P04A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 456, 224, Direction.Down, "NPC_PERAPPU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  GAME:FadeIn(15)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="I shall announce those groups\nnow.", french="Voici la répartition des\ngroupes...", german="Ich werde diese Gruppen jetzt\nbekanntgeben.", italian=" Annuncerò adesso i gruppi.", spanish="Anunciaré dichos grupos\na continuación."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="The first group is [CS:N]Sunflora[CR],\n[CS:N]Loudred[CR], [CS:N]Diglett[CR], and [CS:N]Croagunk[CR].", french="Le premier groupe est\nconstitué de [CS:N]Taupiqueur[CR], [CS:N]Héliatronc[CR], [CS:N]Ramboum[CR]\net [CS:N]Cradopaud[CR].", german="Zur ersten Gruppe gehören\n[CS:N]Sonnflora[CR], [CS:N]Krakeelo[CR], [CS:N]Digda[CR] und [CS:N]Glibunkel[CR].", italian="Il primo gruppo è composto da\n[CS:N]Sunflora[CR], [CS:N]Loudred[CR], [CS:N]Diglett[CR] e [CS:N]Croagunk[CR].", spanish="En el primer grupo irán\n[CS:N]Sunflora[CR], [CS:N]Loudred[CR], [CS:N]Diglett[CR] y [CS:N]Croagunk[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Left)
  GROUND:EntTurn(partner, Direction.Left)
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 424, 256, Direction.Up, "NPC_BIPPA")
  GROUND:EntTurn(npc_npc_bippa, Direction.Right)
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 392, 272, Direction.Up, "NPC_HEIGANI")
  GROUND:EntTurn(npc_npc_heigani, Direction.Right)
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 392, 256, Direction.Up, "NPC_CHIRIIN")
  GROUND:EntTurn(npc_npc_chiriin, Direction.Right)
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 360, 256, Direction.UpRight, "NPC_GUREGGURU")
  GROUND:EntTurn(npc_npc_guregguru, Direction.Right)
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 360, 272, Direction.UpRight, "NPC_DAGUTORIO")
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Right)
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 456, 256, Direction.Up, "NPC_KIMAWARI")
  GROUND:EntTurn(npc_npc_kimawari, Direction.Down)
  GAME:WaitFrames(5)
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 456, 272, Direction.Up, "NPC_DIGUDA")
  GROUND:EntTurn(npc_npc_diguda, Direction.Left)
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 424, 272, Direction.Up, "NPC_DOGOOMU")
  GROUND:EntTurn(npc_npc_dogoomu, Direction.Right)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_guregguru, Direction.Right)
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_kimawari, Direction.DownLeft)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_diguda, Direction.Up)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.UpRight)
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="You guys! You'd better NOT hold\nme back!", french="Hé les gars! Vous avez PAS\nINTERET à traîner, compris?", german="Nur dass ihr es wisst, ich lasse\nmich von euch NICHT aufhalten!", italian="Ehi ragazzi! Cercate di non\nrallentarmi, d'accordo?", spanish="¡Chicos! ¡Espero que no seáis\nuna carga!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" You should talk!", french="Non mais, tu t'es vu? Tu es mal\nplacé pour nous faire la morale! Lui alors,\nil me fait hal-lu-ci-ner, quoi!", german=" Das sagt der Richtige!", italian=" Senti chi parla!", spanish=" ¡No será para tanto!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="The next group is [CS:N]Dugtrio[CR],\n[CS:N]Chimecho[CR], and [CS:N]Corphish[CR].", french="Le deuxième groupe se compose\nde [CS:N]Triopikeur[CR], [CS:N]Eoko[CR] et [CS:N]Ecrapince[CR].", german="Zur nächsten Gruppe gehören\n[CS:N]Digdri[CR], [CS:N]Palimpalim[CR] und [CS:N]Krebscorps[CR].", italian="Il secondo gruppo è composto da\n[CS:N]Dugtrio[CR], [CS:N]Chimecho[CR] e [CS:N]Corphish[CR].", spanish="En el siguiente grupo\nestarán [CS:N]Dugtrio[CR], [CS:N]Chimecho[CR] y [CS:N]Corphish[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_bippa, Direction.Left)
  GROUND:EntTurn(npc_npc_guregguru, Direction.DownRight)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.UpRight)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_chiriin, Direction.Down)
  GROUND:EntTurn(npc_npc_heigani, Direction.Left)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" We're a solid group!", french=" Nous formons un bon groupe!", german=" Wir sind eine stramme Truppe!", italian=" Siamo un bel gruppo!", spanish=" ¡Tenemos un buen grupo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(2, 2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" I promise to try my best!", french="Je promets de faire de mon\nmieux!", german="Ich verspreche, dass ich mein\nBestes geben werde!", italian=" Prometto di fare del mio meglio!", spanish=" ¡Me esforzaré todo lo posible!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(1, 3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" Hey, hey, likewise!", french=" Eh dis donc, moi aussi!", german=" Hey, hey, ich ebenso!", italian=" Ehi, ehi, anche io!", spanish=" Oye, ¡lo mismo digo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Erm... Let's see...", french=" Hum... Voyons voir...", german=" Äh... Mal sehen...", italian=" Erm... Vediamo...", spanish=" Esto... Veamos..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_perappu, 4) end)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.UpRight)
  local npc_npc_sukatanku = SkySceneKit.spawn_npc("skuntank", 336, 232, Direction.Right, "NPC_SUKATANKU")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_sukatanku, npc_npc_perappu, 4) end)
  local npc_npc_zubatto = SkySceneKit.spawn_npc("zubat", 312, 224, Direction.DownRight, "NPC_ZUBATTO")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_zubatto, npc_npc_perappu, 4) end)
  local npc_npc_dogaasu = SkySceneKit.spawn_npc("koffing", 312, 248, Direction.Right, "NPC_DOGAASU")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogaasu, npc_npc_perappu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_perappu, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 424, 208, Direction.Down, "NPC_PUKURIN")
  GROUND:EntTurn(npc_npc_pukurin, Direction.DownRight)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="The Guildmaster and I shall\ntravel as a pair...[K] That is acceptable, yes?", french="Le Maître et moi-même allons\nvoyager ensemble...[K] si cela vous convient,\nMaître.", german="Der Gildenmeister und ich\nwerden zu zweit gehen.[K] Das ist akzeptabel,\nnicht?", italian="Io e il Capitano viaggeremo\nin coppia...[K] Va bene, vero?", spanish="El Gran Bluff y yo viajaremos\nen pareja...[K] Ningún problema con eso, ¿no?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Awwwww?! I have to go with\n[CS:N]Chatot[CR]?!", french="Heiiiiiiiin?! Je dois me coltiner\n[CS:N]Pijako[CR]?!", german="Oooch, ich muss mit [CS:N]Plaudagei[CR]\ngehen?!?", italian="Awwwww?! Mi tocca andare con\n[CS:N]Chatot[CR]?!", spanish="¡Aaaayyy! ¡¿Tengo que\nir con [CS:N]Chatot[CR]?!"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" That's so boooooring!", french="Oh là là, c'est pas vrai! On va\ns'ennuyer comme c'est pas permis!", german=" Das ist sooooo langweilig!", italian=" Che noiaaaaaaa!", spanish=" ¡Qué aburridooooo!"})
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "sweating", 1) end)
  -- ExecuteCommon(CORO_HEAD_SHAKE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Please don't be difficult. This is\na key element of our strategy.", french="S'il vous plaît, ne faites pas le\ndifficile. C'est un élément-clé de notre\nstratégie.", german="Bitte sei nicht so anstrengend.\nDas ist ein wichtiger Teil unserer Strategie.", italian="Non faccia il difficile. È un\nelemento chiave della nostra strategia.", spanish="Por favor, no pongas pegas. Esto\nes un elemento clave de nuestra estrategia."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" ...[K]Meanie.", french=" ...[K] Méchant!", german=" ...[K]Gemein ist das.", italian=" ...[K] Uffi.", spanish=" ¡Vaya![K] Menudo plan."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Our guests, Team [CS:X]Skull[CR], should\ntravel independent of us as their own group.", french="Nos invités de l'Equipe [CS:X]Crâne[CR]\nvoyageront indépendamment et formeront\nleur propre groupe.", german="Unsere Gäste, Team [CS:X]Totenkopf[CR],\nsollten unabhängig von uns als eigene Gruppe\nreisen.", italian="I nostri ospiti, i Pokémon del\nTeam [CS:X]Teschio[CR], viaggeranno come\ngruppo indipendente.", spanish="Nuestros invitados, el\n[CS:X]Equipo Calavera[CR], viajarán de forma\nindependiente formando su propio grupo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english=" Understood. Chaw-haw-haw!", french=" Compris. Gnark gnark gnark!", german=" Verstanden. Cha-ha-ha!", italian=" Benissimo. Ahr-ahr-ahr!", spanish=" Entendido. ¡Jua, jua, jua!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="And the final group is\n[partner], [hero], and [CS:N]Bidoof[CR].", french="Et le dernier groupe est\nconstitué de [CS:N]Keunotor[CR], [partner]\net [hero].", german="Und die letzte Gruppe bilden\n[partner], [hero] und [CS:N]Bidiza[CR].", italian="E l'ultimo gruppo è composto da\n[partner], [hero] e [CS:N]Bidoof[CR].", spanish="Y el grupo final estará formado\npor [partner], [hero] y [CS:N]Bidoof[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_kimawari, Direction.Right)
  GROUND:EntTurn(npc_npc_diguda, Direction.Right)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.UpRight)
  GROUND:EntTurn(npc_npc_heigani, Direction.Right)
  GROUND:EntTurn(npc_npc_chiriin, Direction.Right)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Right)
  GROUND:EntTurn(npc_npc_guregguru, Direction.Right)
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(5)
  GROUND:EntTurn(partner, Direction.Left)
  GROUND:EntTurn(npc_npc_bippa, Direction.Right)
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="We're in the same group! I hope\nI can keep up. Yup yup!", french="On est dans l'même groupe!\nJ'espère que j'serai à la hauteur. Ouaip\nouaip!", german="Wir sind in einer Gruppe! Ich\nhoffe, ich kann mit euch mithalten! Jawollja!", italian="Siamo nello stesso gruppo! Spero\ndi riuscire a stare al vostro passo. Già, già!", spanish="Estamos en el mismo grupo.\n¡Sí, señor! Espero estar a la altura..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey, same here, [CS:N]Bidoof[CR]!", french=" Ha ha ha! Moi aussi, [CS:N]Keunotor[CR]!", german=" Hey, mir geht es genauso, [CS:N]Bidiza[CR]!", italian=" Ehi, anch'io, [CS:N]Bidoof[CR]!", spanish=" ¡Lo mismo digo, [CS:N]Bidoof[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ha ha ha! Same here, [CS:N]Bidoof[CR]!", french=" Ha ha ha! Moi aussi, [CS:N]Keunotor[CR]!", german="Hahaha! Mir geht es genauso,\n[CS:N]Bidiza[CR]!", italian=" Ehi, anch'io, [CS:N]Bidoof[CR]!", spanish=" ¡Je, je! Lo mismo digo, [CS:N]Bidoof[CR]."})
  else
  SkySceneKit.say({english=" Same here, [CS:N]Bidoof[CR]!", french=" Ha ha ha! Moi aussi, [CS:N]Keunotor[CR]!", german=" Mir geht es genauso, [CS:N]Bidiza[CR]!", italian=" Ehi, anch'io, [CS:N]Bidoof[CR]!", spanish=" ¡Oh, lo mismo digo, [CS:N]Bidoof[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(90) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Well then...", french=" Alors...", german=" Nun gut...", italian=" Bene, gente...", spanish=" Pues ya está..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_pukurin, Direction.Down)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GROUND:EntTurn(partner, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_kimawari, Direction.Up)
  GROUND:EntTurn(npc_npc_diguda, Direction.Up)
  GROUND:EntTurn(npc_npc_bippa, Direction.Up)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.Up)
  GROUND:EntTurn(npc_npc_chiriin, Direction.Up)
  GROUND:EntTurn(npc_npc_heigani, Direction.Up)
  GROUND:EntTurn(npc_npc_guregguru, Direction.UpRight)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.UpRight)
  GROUND:EntTurn(npc_npc_sukatanku, Direction.Right)
  GROUND:EntTurn(npc_npc_zubatto, Direction.Right)
  GROUND:EntTurn(npc_npc_dogaasu, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitBgm
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Everyone, let's get to it and\nmove out! ♪", french="Vous tous, allons-y!\nMettons-nous en route! ♪", german="Lasst es uns anpacken, machen\nwir uns auf den Weg! ♪", italian=" Mettiamoci in moto! ♪", spanish="Venga, ¡es la hora de partir!\n¡Vamos todos! ♪"})
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
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
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
  GROUND:MoveToPosition(npc_npc_sukatanku, 324, 132, false, 2)
  GROUND:MoveToPosition(npc_npc_zubatto, 324, 132, false, 2)
  GROUND:MoveToPosition(npc_npc_dogaasu, 324, 132, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(npc_npc_guregguru, 324, 132, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(npc_npc_chiriin, 324, 188, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(npc_npc_heigani, 324, 188, false, 2)
  GROUND:MoveToPosition(npc_npc_dogoomu, 324, 132, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(npc_npc_bippa, 324, 188, false, 2)
  do local p=npc_npc_kimawari.Position; GROUND:MoveToPosition(npc_npc_kimawari, p.X+(-32), p.Y+(0), false, 2) end -- Move2PositionOffset
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-64), p.Y+(0), false, 2) end -- Move2PositionOffset
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-64), p.Y+(0), false, 2) end -- Move2PositionOffset
  GROUND:MoveToPosition(npc_npc_kimawari, 324, 188, false, 2)
  pcall(function() SOUND:FadeOutBGM(190) end)
  GAME:FadeOut(false, 30)
  GAME:WaitFrames(90)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CN] And thus...", french="[CN]Et c'est ainsi que...", german="[CN]Und so begann es...", italian="[CN]E così...", spanish="[CN]Y así..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CN]The guild's expedition party began\n[CN]making its way toward [CS:P]Fogbound Lake[CR].", french="[CN]... débuta l'expédition de la Guilde.\n[CN]Chacun partit vers le [CS:P]Lac des Brumes[CR].", german="[CN]Das Gildenexpeditionsteam startete\n[CN]seine Reise zum [CS:P]Nebelsee[CR].", italian="[CN]... i Pokémon della Gilda si mettono in\n[CN]cammino in direzione del [CS:P]Lago Foschia[CR].", spanish="[CN]La expedición del [CS:N]Pokégremio[CR] emprendió\n[CN]la marcha hacia el [CS:P]Lago Velado[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CN]According to plan, the party was\n[CN]split into the designated groups.", french="[CN]Comme prévu, l'expédition fut\n[CN]divisée en groupes.", german="[CN]Wie geplant wurde das Team\n[CN]in einzelne Gruppen unterteilt.", italian="[CN]Come previsto dal piano, i Pokémon\n[CN]si dividono nei gruppi prestabiliti.", spanish="[CN]De acuerdo con el plan, sus miembros\n[CN]se repartieron en los grupos acordados."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CN]And [hero], [partner], and\n[CN][CS:N]Bidoof[CR]'s group plotted its course.", french="[CN]Le groupe de [hero], [partner] et\n[CN][CS:N]Keunotor[CR] convint d'un itinéraire.", german="[CN]Die Gruppe von [hero], [partner]\n[CN]und [CS:N]Bidiza[CR] plante daraufhin ihre Route.", italian="[CN]E il gruppo di [hero], [partner] e\n[CN][CS:N]Bidoof[CR] segue il suo itinerario.", spanish="[CN][hero], [partner] y\n[CN][CS:N]Bidoof[CR] decidieron su ruta."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CN]The group settled on a route along the\n[CN]seacoast to reach the base camp.", french="[CN]Le groupe suivit un chemin le long de la côte\n[CN]afin de rejoindre le camp de base.", german="[CN]Sie einigten sich auf eine Route\n[CN]entlang der Küste, die zum Basislager führte.", italian="[CN]Il gruppo segue un percorso lungo la costa\n[CN]per raggiungere il Campo Base.", spanish="[CN]Acordaron avanzar por la costa\n[CN]hasta alcanzar el campamento base."})
  -- message_Close
  GAME:WaitFrames(60)
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[8] = 1 -- $SCENARIO_MAIN_BIT_FLAG[8] = 1 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.COMPULSORY_SAVE_POINT = 7 -- $COMPULSORY_SAVE_POINT = 7 (ROM)
  -- CallCommon CORO_HANYOU_SAVE_FUNC (fermeture/attente message: géré par say())
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[8] = 1 -- dungeon_mode(8) = DMODE_OPEN (ROM)
  SkySceneKit.cleanup_npcs()
end
