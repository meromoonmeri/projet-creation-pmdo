-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D42P41A/n01a1904.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE01_BOSS2ND = SV.SkyVars.SIDE01_BOSS2ND or {}; SV.SkyVars.SIDE01_BOSS2ND[0] = 1 -- $SIDE01_BOSS2ND[0] = 1 (ROM)
  SV.SkyScenarioSide = {main=40, sub=6} -- $SCENARIO_SIDE = scn[40,6] (ROM)
  -- back_SetGround(LEVEL_D42P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  local npc_npc_yukikaburi = SkySceneKit.spawn_npc("snover", 256, 224, Direction.Down, "NPC_YUKIKABURI")
  -- SetAnimation(23) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(10)
  -- GAP: se_Play(5121) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(7)
  GROUND:EntTurn(hero, Direction.Left)
  -- SetAnimation(27) [anim idle native]
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GAME:MoveCamera(252, 276, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(hero, 252, 276, false, 2) -- SlidePositionMark (glissement)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Sniff...[K] It's too tough...", french=" Snif...[K] C'est trop balaise...", german="Schnief...[K]\nDas ist härter als erwartet...", italian=" Sniff...[K] È troppo difficile...", spanish=" Aaaay...[K] Abusones..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBGM("Rising Fear.ogg", true) end)
  GROUND:MoveToPosition(npc_npc_yukikaburi, 252, 244, false, 2)
  GAME:WaitFrames(10)
  local npc_npc_tatsubei = SkySceneKit.spawn_npc("bagon", 232, 200, Direction.Down, "NPC_TATSUBEI")
  GROUND:MoveToPosition(npc_npc_tatsubei, 228, 228, false, 2)
  GAME:WaitFrames(7)
  local npc_npc_guraigaa = SkySceneKit.spawn_npc("gligar", 280, 200, Direction.Down, "NPC_GURAIGAA")
  GROUND:MoveToPosition(npc_npc_guraigaa, 276, 228, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_tatsubei) end)
  SkySceneKit.say({english="Humph...[K] Even though you're\nweak, you're going to resist and make us ask?", french="Humph...[K] Tu es faible et sans\ndéfense, et malgré tout, tu veux nous résister\net nous forcer à te le demander?", german="Grmpf...[K] Trotz deiner Schwäche\nlehnst du ab, damit wir auch noch fragen\nmüssen?", italian="Bah...[K] Sei così debole, eppure\nosi opporti a noi?", spanish="Pero bueno...[K] Con lo flojucho que eres,\n¿aún piensas resistirte?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_guraigaa) end)
  SkySceneKit.say({english="Hurry up and give us\nyour money!", french=" Ton argent, et plus vite que ça!", german="Nun mach schon und gib uns\ndas Geld!", italian="Sbrigati e dacci subito\nquei soldi!", spanish=" ¡Danos ya las pelas!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" N...[K]no...", french=" N...[K] non...", german=" Nein...[K] Nein...", italian=" N-[K]No...", spanish=" Eh...[K] No..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="That money...[K]is very important\nto me...", french="Cet argent...[K]\ncompte beaucoup pour moi...", german="Das Geld...[K] ist mir wirklich\nsehr wichtig...", italian="Quei soldi...[K] sono molto\nimportanti per me...", spanish="Este dinero...[K] es muy importante\npara mí..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Who do you think you are...?", french=" Pour qui vous vous prenez...?", german=" Was glaubst du, wer du bist?", italian=" Chi vi credete di essere...?", spanish=" ¡Ni hablar!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english=" Argh![K] This one's really stubborn!", french="Argh![K] Il est borné celui-là,\nma parole!", german=" Argh![K] Ein wahrer Dickkopf!", italian=" Argh![K] Ha proprio la testa dura!", spanish=" ¡Uf![K] ¡Mira que tiene la cabeza dura!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yukikaburi, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  GROUND:EntTurn(npc_npc_yukikaburi, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english="Hey! You![K]\nWe'll take it by force if we have to!", french="Ecoute-moi bien, mon gars![K]\nOn prendra ton argent par la force,\ns'il le faut!", german="Hey! Zum letzten Mal![K] Wir\nnehmen es uns mit Gewalt, wenn wir müssen!", italian="Ehi, voi![K] Se dobbiamo, ce li\nprenderemo con la forza!", spanish="¡Oye, tú![K] ¡Te lo quitaremos\npor la fuerza si hace falta!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english="[CS:N]Bagon[CR] & [CS:N]Gligar[CR]: YEAH!", french="[CS:N]Draby[CR] & [CS:N]Scorplane[CR]: OUAIS!", german="[CS:N]Kindwurm[CR] und [CS:N]Skorgla[CR]: JAWOLL!", italian="[CS:N]Bagon[CR] e [CS:N]Gligar[CR]: SÌ!", spanish="[CS:N]Bagon[CR] y [CS:N]Gligar[CR]: ¡No lo dudes!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_yukikaburi, 252, 252, false, 2)
  GAME:WaitFrames(2)
  GROUND:MoveToPosition(npc_npc_tatsubei, 228, 236, false, 2)
  GAME:WaitFrames(3)
  GROUND:MoveToPosition(npc_npc_guraigaa, 276, 236, false, 2)
  pcall(function() SOUND:FadeOutBGM(30) end)
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english=" WAAAAIT!!", french=" PLUS UN GESTE!!", german=" WAAARTET!!!", italian=" FEEERMI!!!", spanish=" ¡¡Un momentoooo!!"})
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yukikaburi, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_tatsubei, "shock", 1) end)
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_guraigaa, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_Close
  -- GAP: se_Play(9218) — id SE NDS sans portage PMDO identifié
  GAME:FadeIn(30) -- screen_FadeChange vers alpha 192 (éclaircissement, adaptation)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(12)
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(4)
  -- ExecuteCommon(CORO_LOOK_AROUND_DOWN_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english=" Huh?! What?!", french=" Hein?! Quoi?!", german=" Wie?!? Was?!?", italian=" Eh?! Cosa?!", spanish=" ¡¿Eh?! ¡¿Qué?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(9219) — id SE NDS sans portage PMDO identifié
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english="One![K]\nDon't shirk work!", french="Un![K]\nSans travail, pas de médaille!", german=" Erstens![K] Nicht dem Plagen entsagen!", italian="Uno![K]\nLavorare non fa male!", spanish="¡Uno![K] ¡El buen explorador\ndebe ser trabajador!"})
  GAME:WaitFrames(2) -- join WaitSe
  -- message_KeyWait
  -- GAP: se_Play(9220) — id SE NDS sans portage PMDO identifié
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english="Two![K]\nRun away and pay!", french="Deux![K]\nLes froussards au placard!", german="Zweitens![K] Willst du kneifen, müssen wir\ndich schleifen!", italian="Due![K]\nA chi scappa niente pappa!", spanish="¡Dos![K] ¡El que prefiere escapar\ntiene poco que ganar!"})
  GAME:WaitFrames(2) -- join WaitSe
  -- message_KeyWait
  -- GAP: se_Play(9221) — id SE NDS sans portage PMDO identifié
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english="Three![K]\nSmiles go for miles!", french="Trois![K]\nGarde le sourire pour réussir!", german="Drittens![K] Mit einem Lachen werden wir\nes machen!", italian="Tre![K]\nOgni sorriso va condiviso!", spanish="¡Tres![K] ¡Sonrisas para todos\ny encontraréis muchos tesoros!"})
  GAME:WaitFrames(2) -- join WaitSe
  -- message_Close
  -- GAP: se_Play(6403) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 30) -- screen_WhiteOut
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(100)
  GAME:FadeIn(30)
  GAME:WaitFrames(20)
  -- GAP: se_Play(9222) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_yukikaburi, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_tatsubei, "shock", 1) end)
  GROUND:EntTurn(npc_npc_tatsubei, Direction.Up)
  pcall(function() GROUND:CharSetEmote(npc_npc_guraigaa, "shock", 1) end)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_tatsubei.Position; GROUND:MoveToPosition(npc_npc_tatsubei, p.X+(0), p.Y+(16), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_guraigaa.Position; GROUND:MoveToPosition(npc_npc_guraigaa, p.X+(0), p.Y+(16), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitSe
  -- GAP: BGM BGM_ONE_FOR_ALL_ALL_FOR_ONE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- message_FacePositionOffset(4, 0) [neutre/état moteur]
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 296, 216, Direction.DownLeft, "NPC_PERAPPU")
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" [CS:N]Wigglytuff[CR]'s Guild is here!", french="La Guilde de [CS:N]Grodoudou[CR]\npour vous servir!", german=" Die [CS:N]Knuddeluff-Gilde[CR] ist da!", italian=" La Gilda di [CS:N]Wigglytuff[CR] è qui!", spanish="¡Aquí llega el\n[CS:N]Pokégremio de Exploradores[CR]!"})
  -- message_Close
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(5)
  -- ExecuteCommon(CORO_LOOK_AROUND_FAST_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(4)
  -- ExecuteCommon(CORO_LOOK_AROUND_FAST_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_tatsubei, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- message_FacePositionOffset(-2, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_tatsubei) end)
  SkySceneKit.say({english=" Uh-oh!", french=" Oh, oh!", german=" Ah-oh!", italian=" Uh oh!", spanish=" ¡Uf!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Left)
  -- SetAnimation(28) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(10)
  -- GAP: se_Play(8963) — id SE NDS sans portage PMDO identifié
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" E-everyone...", french=" Les... les gars!", german=" I-ihr alle...", italian=" G-Gente...", spanish=" Ha... habéis venido todos..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "angry", 1) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(4, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="You! Don't you dare pick on\nour apprentice!", french="Misérables! Osez seulement\nvous en prendre à notre apprenti!", german="Ihr! Wagt es nicht, unseren\nLehrling anzufassen!", italian="Ehi voi! Non vi azzardate\na prendervela con il nostro apprendista!", spanish="¡Eh, vosotros! ¡Ni se os ocurra\nmeteros con nuestro aprendiz!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, nil, 0) end) -- EFFECT_NONE
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '3', '0')
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 216, 216, Direction.DownRight, "NPC_DOGOOMU")
  -- SetAnimation(19) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  -- camera_SetEffect(0): arrêt d'effet caméra
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "angry", 1) end)
  -- message_FacePositionOffset(-3, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" You BETTER be READY!", french=" Ça VA être VOTRE FETE!", german=" MACHT euch BESSER bereit!", italian=" ORA ve la VEDRETE con NOI!", spanish=" ¡Será mejor que os preparéis!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_tatsubei, npc_npc_yukikaburi, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guraigaa, npc_npc_yukikaburi, 4) end)
  -- message_FacePositionOffset(2, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_guraigaa) end)
  SkySceneKit.say({english=" Huh! What do we do?!", french=" Heu... Qu'est-ce qu'on fait?!", german=" Hmm... Was machen wir nun?!?", italian=" Uh! Cosa facciamo?!", spanish="¡Ahí va! ¡¿Y ahora qué hacemos?!\n¡Esto no mola nada!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-2, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_tatsubei) end)
  SkySceneKit.say({english="Going up against the famous\n[CS:N]Wigglytuff[CR]'s Guild...", french="Affronter la fameuse Guilde de\n[CS:N]Grodoudou[CR]...", german="Gegen die berühmte\n[CS:N]Knuddeluff-Gilde[CR] anzutreten...", italian="Mettersi contro la famosa\nGilda di [CS:N]Wigglytuff[CR]...", spanish="¿Cómo nos vamos a enfrentar\nal famoso [CS:N]Pokégremio de Exploradores[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english=" W-wait! Don't run away!", french="M-mais! Attendez!\nVous allez où, là?", german=" W-wartet! Lauft nicht davon!", italian="A-Aspettate! Non fatevi\nprendere dal panico!", spanish="¡Un... Un momento!\n¡Ni se os ocurra huir!"})
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english="Don't believe the worldwide\nreputation and rumors!", french="Vous n'allez quand même pas\nvous fier à leur réputation!", german="Das sind doch nur billigste\nGerüchte über den legendären Ruf dieser Gilde!", italian="Non credete a tutte le dicerie\no alla loro reputazione!", spanish="¡No os dejéis impresionar por\nlos rumores y su reputación!"})
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english="[CS:N]Jirachi[CR]'s not in this cave!\nNever has been!", french="[CS:N]Jirachi[CR], par exemple...\nil n'est pas dans cette caverne!", german="Genau wie das, nach dem hier\n[CS:N]Jirachi[CR] wohnt! Tut es nicht! Hat es nie!\nVersteht ihr? Gerüchte!!!", italian="[CS:N]Jirachi[CR] non è in questa caverna!\nNon c'è mai stato!", spanish="[CS:N]Jirachi[CR] no está en esta cueva.\nNunca lo ha estado."})
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english="Y-you're just scared of\n[CS:N]Wigglytuff[CR]'s reputation of being really strong!", french="Leur réputation? C'est pareil,\ndes rumeurs! La Guilde de [CS:N]Grodoudou[CR]\nn'est pas invulnérable!", german="I-ihr lasst euch einschüchtern\nvon dem Gerücht, dass die [CS:N]Knuddeluff-Gilde[CR]\nungeheuer stark sein soll?!?", italian="Siete solo spaventati da quello\nche si dice sulla forza di [CS:N]Wigglytuff[CR]!", spanish="¡Lo que os da miedo es solo la\nreputación del [CS:N]Pokégremio de Exploradores[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english="Let's go, you guys![K]\nWe'll take them on too!", french="En avant, les gars![K]\nOn peut tous les battre!", german="Wir machen sie fertig![K]\nZeigt, was ihr draufhabt!", italian="Forza ragazzi![K]\nPossiamo battere anche loro!", spanish=" ¡Vamos, chicos![K] ¡Podemos con ellos!"})
  -- message_Close
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(7)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english="[CS:N]Bagon[CR] & [CS:N]Gligar[CR]: YEAH!", french="[CS:N]Draby[CR] & [CS:N]Scorplane[CR]: OUAIS!", german="[CS:N]Kindwurm[CR] und [CS:N]Skorgla[CR]: JUCHHU!", italian="[CS:N]Bagon[CR] e [CS:N]Gligar[CR]: SÌ!", spanish="[CS:N]Bagon[CR] y [CS:N]Gligar[CR]: ¡Sí!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_tatsubei, Direction.Down)
  GROUND:EntTurn(npc_npc_guraigaa, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 256, 208, Direction.Down, "NPC_PUKURIN")
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Let's go, everyone!", french=" Tous ensemble, chargez!", german=" Alle zusammen, los geht's!", italian=" Addosso gente!", spanish=" ¡Vamos allá!"})
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" YOOM...TAH!", french=" TA-DAAAAA!", german=" LUUUU... FIIII!", italian=" BADABUM!", spanish=" ¡Genial!"})
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(5)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  -- message_CloseEnforce
  GAME:WaitFrames(2) -- join WaitSe
  -- GAP: se_Play(5136) — id SE NDS sans portage PMDO identifié
  -- CallCommon CORO_BOSS_WIPE_FUNC (fermeture/attente message: géré par say())
  -- main_EnterDungeon(125, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
end
