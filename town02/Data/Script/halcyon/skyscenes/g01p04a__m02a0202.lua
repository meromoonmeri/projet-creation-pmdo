-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/m02a0202.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_G01P04A2) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_G01P04A, 'UM02') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(99) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(4) [neutre/état moteur]
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 456, 224, Direction.Down, "NPC_PERAPPU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 424, 272, Direction.Up, "NPC_DOGOOMU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 456, 272, Direction.Up, "NPC_DIGUDA")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 360, 256, Direction.UpRight, "NPC_GUREGGURU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(20)
  GROUND:MoveToPosition(partner, 496, 284, false, 2)
  GROUND:MoveToPosition(hero, 512, 276, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(partner, 484, 272, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(hero, 484, 252, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.Left)
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 392, 272, Direction.Up, "NPC_HEIGANI")
  GROUND:EntTurn(npc_npc_heigani, Direction.Right)
  GROUND:EntTurn(npc_npc_diguda, Direction.Right)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.Right)
  GAME:WaitFrames(5)
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 424, 256, Direction.Up, "NPC_BIPPA")
  GROUND:EntTurn(npc_npc_bippa, Direction.Right)
  GROUND:EntTurn(npc_npc_guregguru, Direction.Right)
  GAME:WaitFrames(5)
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 392, 256, Direction.Up, "NPC_CHIRIIN")
  GROUND:EntTurn(npc_npc_chiriin, Direction.Right)
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 456, 256, Direction.Up, "NPC_KIMAWARI")
  GROUND:EntTurn(npc_npc_kimawari, Direction.Right)
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 360, 272, Direction.UpRight, "NPC_DAGUTORIO")
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(20)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '3', '0')
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" You're LATE, rookies!", french="Vous êtes en RETARD, les\nnovices!", german="Ihr HABT euch VERSPÄTET,\nNeulinge!", italian=" Siete in RITARDO, reclute!", spanish=" ¡LLEGÁIS TARDE, APRENDICES!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitSe
  -- camera_SetEffect(0): arrêt d'effet caméra
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_perappu, 4) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_perappu, 4) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, npc_npc_perappu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Hush!", french=" Silence!", german=" Kusch!", italian=" Shhh!", spanish=" ¡Silencio!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Your voice is ridiculously loud!", french="Ta voix est si forte que c'en est\nridicule!", german="Du hast eine geradezu lächerlich\nlaute Stimme!", italian=" Non c'è bisogno di urlare!", spanish=" ¡Gritas demasiado!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "sweatdrop", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" Humph...", french=" Grrr...", german=" Hmpf...", italian=" Bah...", spanish=" Hum..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  GROUND:EntTurn(npc_npc_perappu, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GROUND:EntTurn(partner, Direction.UpLeft)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Everyone seems to be present.", french="Apparemment, tout le monde est\nprésent.", german=" Alle scheinen anwesend zu sein.", italian=" Sembra che ci siate tutti.", spanish=" Parece que estamos todos."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Very well. ♪ Let us conduct our\nmorning address.", french="Bien. ♪ Faisons l'allocution\ndu matin.", german="Sehr gut. ♪ Kommen wir zur\nmorgendlichen Ansprache.", italian="Benissimo. ♪ È il momento del\ndiscorso mattutino.", spanish="Estupendo. ♪ Empecemos,\nentonces, con el discurso matinal."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Guildmaster! ♪ The guild is in\nfull attendance! ♪", french="Maître! ♪ La Guilde est\nau complet! ♪", german="Gildenmeister! ♪ Die Gilde ist\nkomplett anwesend! ♪", italian="Capitano! ♪ La Gilda è presente\nal completo! ♪", spanish="¡Gran Bluff! ♪ ¡Todo el\n[CS:N]Pokégremio[CR] está presente! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:WaitFrames(2) -- join WaitBgm
  -- GAP: se_Play(8711) — id SE NDS sans portage PMDO identifié
  -- back_ChangeGround(LEVEL_G01P04A) [décor déjà chargé par EnterZone PMDO]
  GAME:WaitFrames(30)
  -- supervision_Acting(2) [neutre/état moteur]
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 424, 184, Direction.Down, "NPC_PUKURIN")
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_pukurin, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(npc_npc_pukurin, 420, 208, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(45)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Thank you, Guildmaster! ♪\nPlease address the crew.", french="Merci infiniment, Maître! ♪\nVeuillez vous adresser à notre équipe.", german="Vielen Dank, Gildenmeister! ♪\nWende dich bitte an die Gildencrew.", italian="Prego, Capitano! ♪\nPuò rivolgersi ai membri.", spanish="¡Muchas gracias, Gran Bluff! ♪\nYa puedes dirigirte a nuestros miembros."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Zzzz... Zzzz... Snorfle... Zzz...", french=" Zzzz... Zzzz... Zzzz...", german=" Zzzz... Zzzz... Schnarch... Zzz...", italian=" Zzzz... Zzzz... Snorfle... Zzz...", spanish=" Zzz... Zzz... Zzz..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBGM("Guildmaster Wigglytuff.ogg", true) end)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="[CS:N]Apprentice[CR]: (Psst...! Guildmaster [CS:N]Wigglytuff[CR]\nnever ceases to amaze me!)", french="[CS:N]Apprenti[CR]: (Waouh! Le Maître, [CS:N]Grodoudou[CR],\nme surprendra toujours!)", german="[CS:N]Lehrling[CR]: (Psst! Gildenmeister [CS:N]Knuddeluff[CR]\nüberrascht mich immer wieder!)", italian="[CS:N]Apprendista[CR]: (Psst...! Il Capitano [CS:N]Wigglytuff[CR]\nnon finisce mai di stupirmi!)", spanish="[CS:N]Aprendiz[CR]: (¡Ji, ji, ji! ¡El Gran Bluff nunca deja\nde sorprenderme!)"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="[CS:N]Apprentice[CR]: (Yeah, you got that right!)", french="[CS:N]Apprenti[CR]: (Oui, t'as raison!)", german="[CS:N]Lehrling[CR]: (Ja, allerdings!)", italian="[CS:N]Apprendista[CR]: (Già, è proprio vero!)", spanish="[CS:N]Aprendiz[CR]: (¡Ya te digo!)"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="[CS:N]Apprentice[CR]: (Yup, looks like he's wide awake.)", french="[CS:N]Apprenti[CR]: (Ouais, on dirait qu'il est éveillé.)", german="[CS:N]Lehrling[CR]: (Jep, er wirkt hellwach.)", italian="[CS:N]Apprendista[CR]: (Sì, sembra sveglio.)", spanish="[CS:N]Aprendiz[CR]: (Hasta parece despierto, la verdad...)"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="[CS:N]Apprentice[CR]: (Eek! His eyes are wide open!\nBut he's fast asleep!)", french="[CS:N]Apprenti[CR]: (Hum! Ses yeux sont grand ouverts!\nMais il dort!)", german="[CS:N]Lehrling[CR]: (Ieek! Seine Augen sind offen!\nAber er schläft tief und fest!)", italian="[CS:N]Apprendista[CR]: (Wow! Ha gli occhi aperti!\nMa sta dormendo!)", spanish="[CS:N]Aprendiz[CR]: (¡Y tanto! ¡Tiene los ojos abiertos,\npero está durmiendo como un tronco!)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(25) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Thank you, sir! We all value\nyour...[K]words of wisdom! ♪", french="Merci, Maître! Nous apprécions\ntoute la...[K] sagesse de vos paroles! ♪", german="Vielen Dank, Meister! Wir alle\nschätzen deine...[K] deine weisen Worte! ♪", italian="Grazie, Capitano! Apprezziamo\ntutti le sue...[K] sagge parole! ♪", spanish="¡Gracias, maestro! ¡Valoramos\ntus...[K] sabias palabras! ♪"})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(60) end)
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(26) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="OK, Pokémon! ♪ Take our\nGuildmaster's words of wisdom to heart! ♪", french="Alors, mes amis Pokémon! ♪\nPrenez les sages paroles de notre Maître\nà cœur! ♪", german="Okay, Pokémon! ♪ Nehmt euch\ndes Gildenmeisters weise Worte zu Herzen! ♪", italian="Ok, Pokémon! ♪ Facciamo\nnostre le sagge parole del Capitano! ♪", spanish="¡Ya lo habéis oído! ♪ ¡Aprended\nesta valiosa lección del Gran Bluff! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Finally, let's not forget our\nmorning cheers! All together now! ♪", french="Et enfin, n'oublions pas nos\nencouragements matinaux! Allez, tous\nensemble! ♪", german="Und nun, vergesst nicht den\nmorgendlichen Jubelruf! Alle zusammen! ♪", italian="E non dimentichiamo il nostro\nmotto mattutino! Tutti insieme! ♪", spanish="Por último, ¡repasemos nuestras\nconsignas como cada día! ¡Vamos! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: A ONE, A TWO...A ONE-TWO-THREE!", french="[CS:N]Tous[CR]: ET UN, ET DEUX... ET UN, DEUX, TROIS!", german="[CS:N]Alle[CR]: UND EINS, UND ZWEI, UND EINS-ZWEI-\nDREI!", italian="[CS:N]Tutti[CR]: E UNO, DUE E TRE!", spanish="[CS:N]Todos[CR]: ¡TODOS JUNTOS!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: ONE![K] DON'T SHIRK WORK!", french="[CS:N]Tous[CR]: UN![K] SANS TRAVAIL, PAS DE MEDAILLE!", german="[CS:N]Alle[CR]: ERSTENS![K] NICHT DEM PLAGEN ENTSAGEN!", italian="[CS:N]Tutti[CR]: UNO![K] LAVORARE NON FA MALE!", spanish="[CS:N]Todos[CR]: ¡UNO![K] ¡EL BUEN EXPLORADOR\nDEBE SER TRABAJADOR!"})
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, nil, 0) end) -- EFFECT_NONE
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: TWO![K] RUN AWAY AND PAY!", french="[CS:N]Tous[CR]: DEUX![K] LES FROUSSARDS AU PLACARD!", german="[CS:N]Alle[CR]: ZWEITENS![K] WILLST DU KNEIFEN,\nMÜSSEN WIR DICH SCHLEIFEN!", italian="[CS:N]Tutti[CR]: DUE![K] A CHI SCAPPA NIENTE PAPPA!", spanish="[CS:N]Todos[CR]: ¡DOS![K] ¡EL QUE PREFIERE ESCAPAR\nTIENE POCO QUE GANAR!"})
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, nil, 0) end) -- EFFECT_NONE
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: THREE![K] SMILES GO FOR MILES!", french="[CS:N]Tous[CR]: TROIS![K] GARDE LE SOURIRE POUR\nREUSSIR!", german="[CS:N]Alle[CR]: DRITTENS![K] MIT EINEM LACHEN\nWERDEN WIR ES MACHEN!", italian="[CS:N]Tutti[CR]: TRE![K] OGNI SORRISO VA CONDIVISO!", spanish="[CS:N]Todos[CR]: ¡TRES![K] SONRISAS PARA TODOS\n¡Y ENCONTRARÉIS MUCHOS TESOROS!"})
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, nil, 0) end) -- EFFECT_NONE
  -- message_Close
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" OK, Pokémon! Get to work! ♪", french="Allez, mes amis Pokémon!\nAu travail! ♪", german=" Gut, Pokémon! An die Arbeit! ♪", italian=" Ok, Pokémon! Al lavoro! ♪", spanish="¡De acuerdo, Pokémon!\n¡Ahora a trabajar! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
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
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, nil, 0) end) -- EFFECT_NONE
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
  GROUND:MoveToPosition(npc_npc_pukurin, 420, 180, false, 2)
  GROUND:MoveToPosition(npc_npc_guregguru, 224, 252, false, 2)
  GROUND:MoveToPosition(npc_npc_chiriin, 232, 252, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(npc_npc_heigani, 324, 188, false, 2)
  GROUND:MoveToPosition(npc_npc_dogoomu, 240, 272, false, 2)
  GROUND:MoveToPosition(npc_npc_bippa, 324, 188, false, 2)
  do local p=npc_npc_kimawari.Position; GROUND:MoveToPosition(npc_npc_kimawari, p.X+(-32), p.Y+(0), false, 2) end -- Move2PositionOffset
  -- Destroy() [neutre/état moteur]
  GROUND:MoveToPosition(npc_npc_kimawari, 324, 188, false, 2)
  GROUND:MoveToPosition(npc_npc_heigani, 324, 132, false, 2)
  GROUND:MoveToPosition(npc_npc_bippa, 324, 132, false, 2)
  -- Destroy() [neutre/état moteur]
  GROUND:MoveToPosition(npc_npc_kimawari, 324, 132, false, 2)
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  -- supervision_RemoveActing(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveActing(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  SkySceneKit.cleanup_npcs()
end
