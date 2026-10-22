-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/n01a0101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  if true --[[BranchDebug: retail EU]] then -- if ROM: not debug
  -- @label_0 [étiquette de flux ExplorerScript]
  SV.SkyScenarioSide = {main=40, sub=1} -- $SCENARIO_SIDE = scn[40,1] (ROM)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 456, 224, Direction.Down, "NPC_PERAPPU")
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" All right! Here we go today! ♪", french="Très bien!\nUne nouvelle journée qui commence! ♪", german="Alles klar!\nLasst uns den Tag angemessen beginnen! ♪", italian=" Bene! Eccoci qua! ♪", spanish=" ¡De acuerdo, vamos allá! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Our morning cheers![K]\nAll together now! ♪", french="C'est l'heure de nos\nencouragements matinaux!\nAllez, tous ensemble! ♪", german="Unser morgendlicher Jubelruf![K]\nAlle zusammen! ♪", italian="E ora il nostro motto mattutino![K]\nTutti insieme! ♪", spanish="¡Repasemos nuestras consignas![K]\n¡Todo el mundo, vamos! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: ONE![K] DON'T SHIRK WORK!", french="[CS:N]Tous[CR]: UN![K] SANS TRAVAIL, PAS DE MEDAILLE!", german="[CS:N]Alle[CR]: ERSTENS![K] NICHT DEM PLAGEN ENTSAGEN!", italian="[CS:N]Tutti[CR]: UNO![K] LAVORARE NON FA MALE!", spanish="[CS:N]Todos[CR]: ¡UNO![K] ¡EL BUEN EXPLORADOR\nDEBE SER TRABAJADOR!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: TWO![K] RUN AWAY AND PAY!", french="[CS:N]Tous[CR]: DEUX![K] LES FROUSSARDS AU PLACARD!", german="[CS:N]Alle[CR]: ZWEITENS![K] WILLST DU KNEIFEN,\nMÜSSEN WIR DICH SCHLEIFEN!", italian="[CS:N]Tutti[CR]: DUE![K] A CHI SCAPPA NIENTE PAPPA!", spanish="[CS:N]Todos[CR]: ¡DOS![K] ¡EL QUE PREFIERE ESCAPAR\nTIENE POCO QUE GANAR!"})
  -- message_Close
  -- back_SetGround(LEVEL_G01P04A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- supervision_Acting(2) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 360, 256, Direction.UpRight, "NPC_GUREGGURU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  GAME:WaitFrames(30)
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 360, 272, Direction.UpRight, "NPC_DAGUTORIO")
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "happy", 1) end)
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 424, 272, Direction.Up, "NPC_DOGOOMU")
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "happy", 1) end)
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 392, 256, Direction.Up, "NPC_CHIRIIN")
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "happy", 1) end)
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 456, 256, Direction.Up, "NPC_KIMAWARI")
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: THREE![K] SMILES GO FOR MILES!", french="[CS:N]Tous[CR]: TROIS![K] GARDE LE SOURIRE POUR\nREUSSIR!", german="[CS:N]Alle[CR]: DRITTENS![K] MIT EINEM LACHEN\nWERDEN WIR ES MACHEN!", italian="[CS:N]Tutti[CR]: TRE![K] OGNI SORRISO VA CONDIVISO!", spanish="[CS:N]Todos[CR]: ¡TRES![K] ¡SONRISAS PARA TODOS\nY ENCONTRARÉIS MUCHOS TESOROS!"})
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  -- message_Close
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" OK, Pokémon! Get to work! ♪", french="Allez, mes amis Pokémon!\nAu travail! ♪", german=" Gut, Pokémon! An die Arbeit! ♪", italian=" Ok, Pokémon! Al lavoro! ♪", spanish="¡De acuerdo, Pokémon!\n¡Ahora a trabajar! ♪"})
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
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 392, 272, Direction.Up, "NPC_HEIGANI")
  -- SetAnimation(23) [anim idle native]
  -- SetAnimation(24) [anim idle native]
  -- SetAnimation(23) [anim idle native]
  -- SetAnimation(23) [anim idle native]
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 456, 272, Direction.Up, "NPC_DIGUDA")
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
  pcall(function() local p=hero.Position; GAME:MoveCamera(p.X, p.Y, 60, false) end) -- MovePositionLives performer/caméra vers ACTOR_NPC_HERO_FIRST
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
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 424, 208, Direction.Down, "NPC_PUKURIN")
  GROUND:MoveToPosition(npc_npc_pukurin, 420, 180, false, 2)
  GROUND:MoveToPosition(npc_npc_guregguru, 224, 252, false, 2)
  GROUND:MoveToPosition(npc_npc_chiriin, 324, 188, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(npc_npc_heigani, 324, 188, false, 2)
  GROUND:MoveToPosition(npc_npc_dogoomu, 240, 272, false, 2)
  GROUND:MoveToPosition(hero, 324, 188, false, 2)
  do local p=npc_npc_kimawari.Position; GROUND:MoveToPosition(npc_npc_kimawari, p.X+(-32), p.Y+(0), false, 2) end -- Move2PositionOffset
  -- Destroy() [neutre/état moteur]
  GROUND:MoveToPosition(npc_npc_kimawari, 324, 188, false, 2)
  GROUND:MoveToPosition(npc_npc_chiriin, 324, 132, false, 2)
  GROUND:MoveToPosition(npc_npc_heigani, 324, 132, false, 2)
  GAME:WaitFrames(45)
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GROUND:EntTurn(hero, Direction.DownRight)
  GROUND:TeleportTo(npc_npc_dogoomu, 216, 308, Direction.Down)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.DownLeft)
  -- SetAnimation(4) [anim idle native]
  GROUND:TeleportTo(npc_npc_guregguru, 228, 220, Direction.Down)
  GROUND:EntTurn(npc_npc_guregguru, Direction.Down)
  -- SetAnimation(4) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[c_name:NPC_HERO_FIRST]![K] Let's do our best\non our guild assignments today!", french="[c_name:NPC_HERO_FIRST]![K] Faisons de notre\nmieux pour remplir les tâches que la Guilde\nnous a confiées aujourd'hui!", german="[c_name:NPC_HERO_FIRST]![K] Lass uns heute\nunser Bestes bei den Gildenaufgaben geben!", italian="[c_name:NPC_HERO_FIRST]![K] Facciamo\ndel nostro meglio anche oggi!", spanish="¡[c_name:NPC_HERO_FIRST]![K] ¡Tenemos que\nhacer nuestras tareas lo mejor posible!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[c_name:NPC_HERO_FIRST]![K] Let's do our best\non our guild assignments today!", french="[c_name:NPC_HERO_FIRST]![K] Faisons de notre\nmieux pour remplir les tâches que la Guilde\nnous a confiées aujourd'hui!", german="[c_name:NPC_HERO_FIRST]![K] Lass uns heute\nunser Bestes bei den Gildenaufgaben geben!", italian="[c_name:NPC_HERO_FIRST]![K] Facciamo\ndel nostro meglio anche oggi!", spanish="¡[c_name:NPC_HERO_FIRST]![K] ¡Hay que\nhacer nuestras tareas lo mejor posible!"})
  else
  SkySceneKit.say({english="[c_name:NPC_HERO_FIRST]![K] Let's do our best\non our guild assignments today!", french="[c_name:NPC_HERO_FIRST]![K] Faisons de notre\nmieux pour remplir les tâches que la Guilde\nnous a confiées aujourd'hui!", german="[c_name:NPC_HERO_FIRST]![K] Lass uns heute\nunser Bestes bei den Gildenaufgaben geben!", italian="[c_name:NPC_HERO_FIRST]![K] Facciamo\ndel nostro meglio anche oggi!", spanish="¡[c_name:NPC_HERO_FIRST]![K] ¡Vamos a\nhacer nuestras tareas lo mejor posible!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  pcall(function() GAME:MoveCamera(324, 252, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[c_name:NPC_HERO_FIRST]'s team...[K]\nThey're so happy today, yup yup!", french="L'Equipe de [c_name:NPC_HERO_FIRST]...[K]\nElle a l'air si joyeuse aujourd'hui, pardi!", german="Das Team von [c_name:NPC_HERO_FIRST]...[K]\nSie sehen heute so fröhlich aus, jawollja!", italian="Ma guarda la squadra di\n[c_name:NPC_HERO_FIRST]...[K] Sono così felici oggi, già, già!", spanish="El equipo de [c_name:NPC_HERO_FIRST]...[K]\n¡Hoy rebosa alegría, sí, señor!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I'm...[K]\nI'm not giving up either! Yup yup!", french="Je...[K]\nFaut pas qu'j'me laisse aller, moi non plus!\nOuaip ouaip!", german="Ich...[K] Ich werde mich auch nicht\nunterkriegen lassen! Jawollja!", italian="Ma...[K]\nAnch'io ce la metterò tutta! Ohibò!", spanish="Pues...[K] Yo tampoco pienso rendirme,\n¡no, señor!"})
  -- message_Close
  -- supervision_SpecialActing(27, 0, 0) [cadrage NDS]
  -- supervision_SpecialActing(28, 130, 78) [cadrage NDS]
  -- supervision_SpecialActing(29, 16, 0) [cadrage NDS]
  -- supervision_SpecialActing(30, 64, 0) [cadrage NDS]
  -- bgm_ChangeVolume(60,128) [volume BGM non scriptable en Lua PMDO: piste maintenue - documenté]
  GAME:WaitFrames(60)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]My name's [CS:Y]Bidoof[CR].[K]\n[CN]I'm an apprentice at the guild.", french="[CN]Mon nom est [CS:Y]Keunotor[CR].[K]\n[CN]Je suis apprenti à la Guilde.", german="[CN]Mein Name ist [CS:Y]Bidiza[CR].[K]\n[CN]Ich bin ein Gildenlehrling.", italian="[CN]Mi chiamo [CS:Y]Bidoof[CR].[K]\n[CN]Sono un apprendista della Gilda.", spanish="[CN]Me llamo [CS:Y]Bidoof[CR].[K]\n[CN]Soy un aprendiz del [CS:N]Pokégremio[CR]."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]Before [c_name:NPC_HERO_FIRST] arrived, I was the\n[CN]newest apprentice here. Yup yup!", french="[CN]Avant l'arrivée de [c_name:NPC_HERO_FIRST], j'étais le\n[CN]p'tit nouveau de service ici, pardi!", german="[CN]Bevor [c_name:NPC_HERO_FIRST] hier ankam, war ich\n[CN]der neueste Lehrling dieser Gilde. Jawollja!", italian="[CN]Prima che arrivasse [c_name:NPC_HERO_FIRST], ero\n[CN]l'ultimo arrivato qui. Già, già!", spanish="[CN]Antes de que llegara el equipo de [c_name:NPC_HERO_FIRST],\n[CN]yo era el novato. ¡Sí, señor!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]My...[K]my dream is...[K]\n[CN]to do my best at the guild...[K]study...", french="[CN]Mon...[K] mon rêve est de...[K]\n[CN]donner l'meilleur d'moi-même à la Guilde...[K]\n[CN]Etudier et travailler dur...", german="[CN]Mein...[K] Mein Traum ist es...[K] Für die Gilde\n[CN]mein Bestes zu geben...[K] Zu lernen...", italian="[CN]Il mio...[K] Il mio sogno è...[K] fare del mio\n[CN]meglio alla Gilda...[K] e studiare...", spanish="[CN]Mi...[K] Mi sueño es...[K] darlo todo\n[CN]en el [CS:N]Pokégremio[CR]...[K] Estudiar..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]And someday...", french="[CN]... pour un jour...", german="[CN]Und eines Tages...", italian="[CN]E un giorno...", spanish="[CN]Y algún día..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- supervision_SpecialActing(31, 64, 0) [cadrage NDS]
  -- bgm_ChangeVolume(60,256) [volume BGM non scriptable en Lua PMDO: piste maintenue - documenté]
  GAME:WaitFrames(60)
  GAME:WaitFrames(30)
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- SetAnimation(29) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]Someday I'll be the best explorer ever!\n[CN]Yup yup!", french="[CN]... devenir le plus grand explorateur\n[CN]de tous les temps, pardi!", german="[CN]Eines Tages werde ich der beste Erkunder\n[CN]aller Zeiten sein! Jawollja!", italian="[CN]Un giorno diventerò il miglior esploratore\n[CN]che sia mai esistito! Già, già!", spanish="[CN]¡Algún día seré el mejor explorador de todos!\n[CN]¡Sí, señor!"})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 60)
  -- supervision_SpecialActing(32, 0, 0) [cadrage NDS]
  GAME:WaitFrames(80)
  else
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[M:D2][CS:C]Start from where?[CR]", french="[M:D2][CS:C]Start from where?[CR]", german="[M:D2][CS:C]Start from where?[CR]", italian="[M:D2][CS:C]Start from where?[CR]", spanish="[M:D2][CS:C]Start from where?[CR]"})
  do local __choice = SkySceneKit.ask({{english="[M:D2]Beginning", french="[M:D2]Beginning", german="[M:D2]Beginning", italian="[M:D2]Beginning", spanish="[M:D2]Beginning"}, {english="[M:D2]SectionA", french="[M:D2]SectionA", german="[M:D2]SectionA", italian="[M:D2]SectionA", spanish="[M:D2]SectionA"}, {english="[M:D2]SectionB", french="[M:D2]SectionB", german="[M:D2]SectionB", italian="[M:D2]SectionB", spanish="[M:D2]SectionB"}, {english="[M:D2]SectionC", french="[M:D2]SectionC", german="[M:D2]SectionC", italian="[M:D2]SectionC", spanish="[M:D2]SectionC"}, {english="[M:D2]SectionD(w/Snover)", french="[M:D2]SectionD(w/Snover)", german="[M:D2]SectionD(w/Snover)", italian="[M:D2]SectionD(w/Snover)", spanish="[M:D2]SectionD(w/Snover)"}, {english="[M:D2]SectionD(w/oSnover)", french="[M:D2]SectionD(w/oSnover)", german="[M:D2]SectionD(w/oSnover)", italian="[M:D2]SectionD(w/oSnover)", spanish="[M:D2]SectionD(w/oSnover)"}, {english="[M:D2]SectionF", french="[M:D2]SectionF", german="[M:D2]SectionF", italian="[M:D2]SectionF", spanish="[M:D2]SectionF"}, {english="[M:D2]SectionG", french="[M:D2]SectionG", german="[M:D2]SectionG", italian="[M:D2]SectionG", spanish="[M:D2]SectionG"}, {english="[M:D2]SectionH", french="[M:D2]SectionH", german="[M:D2]SectionH", italian="[M:D2]SectionH", spanish="[M:D2]SectionH"}, {english="[M:D2]TALK-N01-01", french="[M:D2]TALK-N01-01", german="[M:D2]TALK-N01-01", italian="[M:D2]TALK-N01-01", spanish="[M:D2]TALK-N01-01"}, {english="[M:D2]TALK-N01-02", french="[M:D2]TALK-N01-02", german="[M:D2]TALK-N01-02", italian="[M:D2]TALK-N01-02", spanish="[M:D2]TALK-N01-02"}, {english="[M:D2]TALK-N01-03", french="[M:D2]TALK-N01-03", german="[M:D2]TALK-N01-03", italian="[M:D2]TALK-N01-03", spanish="[M:D2]TALK-N01-03"}, {english="[M:D2]TALK-N01-035", french="[M:D2]TALK-N01-035", german="[M:D2]TALK-N01-035", italian="[M:D2]TALK-N01-035", spanish="[M:D2]TALK-N01-035"}, {english="[M:D2]TALK-N01-04", french="[M:D2]TALK-N01-04", german="[M:D2]TALK-N01-04", italian="[M:D2]TALK-N01-04", spanish="[M:D2]TALK-N01-04"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- message_Close
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE01_BOSS2ND = SV.SkyVars.SIDE01_BOSS2ND or {}; SV.SkyVars.SIDE01_BOSS2ND[0] = 0 -- $SIDE01_BOSS2ND[0] = 0 (ROM)
  SV.SkyScenarioSide = {main=40, sub=1} -- $SCENARIO_SIDE = scn[40,1] (ROM)
  -- main_SetGround(LEVEL_G01P08A) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterGround(LEVEL_G01P03A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 3 then
  -- message_Close
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE01_BOSS2ND = SV.SkyVars.SIDE01_BOSS2ND or {}; SV.SkyVars.SIDE01_BOSS2ND[0] = 0 -- $SIDE01_BOSS2ND[0] = 0 (ROM)
  SV.SkyScenarioSide = {main=40, sub=2} -- $SCENARIO_SIDE = scn[40,2] (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[123] = 1 -- dungeon_mode(123) = DMODE_OPEN (ROM)
  -- main_SetGround(LEVEL_G01P01A) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterGround(LEVEL_P01P01A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 4 then
  -- message_Close
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE01_BOSS2ND = SV.SkyVars.SIDE01_BOSS2ND or {}; SV.SkyVars.SIDE01_BOSS2ND[0] = 0 -- $SIDE01_BOSS2ND[0] = 0 (ROM)
  SV.SkyScenarioSide = {main=40, sub=3} -- $SCENARIO_SIDE = scn[40,3] (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[123] = 1 -- dungeon_mode(123) = DMODE_OPEN (ROM)
  -- main_SetGround(LEVEL_G01P08A) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterGround(LEVEL_G01P03A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 5 then
  -- message_Close
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE01_BOSS2ND = SV.SkyVars.SIDE01_BOSS2ND or {}; SV.SkyVars.SIDE01_BOSS2ND[0] = 0 -- $SIDE01_BOSS2ND[0] = 0 (ROM)
  SV.SkyScenarioSide = {main=40, sub=4} -- $SCENARIO_SIDE = scn[40,4] (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[123] = 1 -- dungeon_mode(123) = DMODE_OPEN (ROM)
  -- main_EnterGround(LEVEL_D42P21A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 6 then
  -- message_Close
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE01_BOSS2ND = SV.SkyVars.SIDE01_BOSS2ND or {}; SV.SkyVars.SIDE01_BOSS2ND[0] = 1 -- $SIDE01_BOSS2ND[0] = 1 (ROM)
  SV.SkyScenarioSide = {main=40, sub=6} -- $SCENARIO_SIDE = scn[40,6] (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[123] = 1 -- dungeon_mode(123) = DMODE_OPEN (ROM)
  -- main_EnterGround(LEVEL_D42P21A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 7 then
  -- message_Close
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE01_BOSS2ND = SV.SkyVars.SIDE01_BOSS2ND or {}; SV.SkyVars.SIDE01_BOSS2ND[0] = 1 -- $SIDE01_BOSS2ND[0] = 1 (ROM)
  SV.SkyScenarioSide = {main=40, sub=6} -- $SCENARIO_SIDE = scn[40,6] (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[123] = 1 -- dungeon_mode(123) = DMODE_OPEN (ROM)
  -- main_SetGround(LEVEL_G01P01A) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterGround(LEVEL_P01P01A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 8 then
  -- message_Close
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE01_BOSS2ND = SV.SkyVars.SIDE01_BOSS2ND or {}; SV.SkyVars.SIDE01_BOSS2ND[0] = 1 -- $SIDE01_BOSS2ND[0] = 1 (ROM)
  SV.SkyScenarioSide = {main=40, sub=7} -- $SCENARIO_SIDE = scn[40,7] (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[123] = 1 -- dungeon_mode(123) = DMODE_OPEN (ROM)
  -- main_SetGround(LEVEL_G01P08A) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterGround(LEVEL_G01P03A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 9 then
  -- message_Close
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE01_BOSS2ND = SV.SkyVars.SIDE01_BOSS2ND or {}; SV.SkyVars.SIDE01_BOSS2ND[0] = 1 -- $SIDE01_BOSS2ND[0] = 1 (ROM)
  SV.SkyScenarioSide = {main=40, sub=8} -- $SCENARIO_SIDE = scn[40,8] (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[123] = 1 -- dungeon_mode(123) = DMODE_OPEN (ROM)
  -- main_SetGround(LEVEL_G01P08A) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterGround(LEVEL_G01P03A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 10 then
  SV.SkyScenarioSide = {main=40, sub=1} -- $SCENARIO_SIDE = scn[40,1] (ROM)
  -- @label_15 [étiquette de flux ExplorerScript]
  -- message_Close
  -- main_EnterGround(LEVEL_P01P01A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 11 then
  SV.SkyScenarioSide = {main=40, sub=2} -- $SCENARIO_SIDE = scn[40,2] (ROM)
  -- jump @label_15 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 12 then
  SV.SkyScenarioSide = {main=40, sub=3} -- $SCENARIO_SIDE = scn[40,3] (ROM)
  -- jump @label_15 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 13 then
  SV.SkyScenarioSide = {main=40, sub=6} -- $SCENARIO_SIDE = scn[40,6] (ROM)
  -- jump @label_15 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 14 then
  SV.SkyScenarioSide = {main=40, sub=7} -- $SCENARIO_SIDE = scn[40,7] (ROM)
  -- jump @label_15 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- message_Close
  -- jump @label_0 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  SkySceneKit.cleanup_npcs()
end
