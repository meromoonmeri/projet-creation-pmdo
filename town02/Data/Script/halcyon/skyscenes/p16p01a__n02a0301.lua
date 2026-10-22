-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P16P01A/n02a0301.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SV.SkyScenarioSide = {main=41, sub=3} -- $SCENARIO_SIDE = scn[41,3] (ROM)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V24P08A) [décor sub chargé: Sub_v24p08a]
  -- back_SetGround(LEVEL_P16P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 19, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  local npc_npc_upaa = SkySceneKit.spawn_npc("wooper", 216, 144, Direction.UpRight, "NPC_UPAA")
  -- SetAnimation(2) [anim idle native]
  local npc_npc_muchuuru = SkySceneKit.spawn_npc("smoochum", 232, 152, Direction.Up, "NPC_MUCHUURU")
  -- SetAnimation(2) [anim idle native]
  local npc_npc_subomii = SkySceneKit.spawn_npc("budew", 248, 144, Direction.UpLeft, "NPC_SUBOMII")
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_upaa, "happy", 1) end)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharSetEmote(npc_npc_muchuuru, "happy", 1) end)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharSetEmote(npc_npc_subomii, "happy", 1) end)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  -- camera_SetMyself() [neutre/état moteur]
  SkySubScreen.Show("v24p08a", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  GAME:WaitFrames(60)
  pcall(function() GROUND:CharSetEmote(npc_npc_upaa, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_muchuuru, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_subomii, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" Hey! You guys!", french=" Hé! Vous!", german=" Hey! Ihr da!", italian=" Ehi voi!", spanish=" ¡Eh, gente!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_subomii, "exclaim", 1) end)
  GROUND:EntTurn(npc_npc_subomii, Direction.Right)
  GAME:WaitFrames(4)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_RIGHT — VFX sans émote PMDO équivalente
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharSetEmote(npc_npc_muchuuru, "exclaim", 1) end)
  GROUND:EntTurn(npc_npc_muchuuru, Direction.Right)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharSetEmote(npc_npc_upaa, "exclaim", 1) end)
  GROUND:EntTurn(npc_npc_upaa, Direction.Right)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" You guys! [K]What are you doing there?", french=" Alors! [K]Qu'est-ce que vous fabriquez?", german=" Genau ihr![K] Was macht ihr da?", italian=" Sì, voi![K] Che state facendo?", spanish=" ¡Vosotros![K] ¿Qué hacéis aquí?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- supervision_Acting(1) [neutre/état moteur]
  local npc_npc_jupetta = SkySceneKit.spawn_npc("banette", 384, 136, Direction.Down, "NPC_JUPETTA")
  -- SetAnimation(2) [anim idle native]
  local npc_npc_sukorupi = SkySceneKit.spawn_npc("skorupi", 408, 160, Direction.Down, "NPC_SUKORUPI")
  -- SetAnimation(2) [anim idle native]
  pcall(function() GAME:MoveCamera(272, 156, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(npc_npc_jupetta, 304, 136, false, 2)
  GROUND:MoveToPosition(npc_npc_sukorupi, 324, 160, false, 2)
  GAME:WaitFrames(50)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_upaa, "sweating", 1) end)
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(npc_npc_upaa, 180, 144, false, 2) -- SlidePositionMark (glissement)
  GAME:WaitFrames(6)
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(npc_npc_muchuuru, 196, 152, false, 2) -- SlidePositionMark (glissement)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharSetEmote(npc_npc_subomii, "shock", 1) end)
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(npc_npc_subomii, 212, 144, false, 2) -- SlidePositionMark (glissement)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_upaa, Direction.Right)
  GROUND:EntTurn(npc_npc_muchuuru, Direction.Right)
  GROUND:EntTurn(npc_npc_subomii, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: BGM BGM_MURKY_FOREST non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(20)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_upaa, "shock", 1) end)
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_upaa) end)
  SkySceneKit.say({english=" Th-them?!", french=" Eux...?!", german=" D-die?!?", italian=" O-Oh no!", spanish=" ¡¿Son... ellos?!"})
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- message_FacePositionOffset(2, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_muchuuru) end)
  SkySceneKit.say({english="The bullies, [CS:N]Banette[CR]\nand [CS:N]Skorupi[CR]!", french="C'est les sales brutes\n[CS:N]Branette[CR] et [CS:N]Rapion[CR]!", german="Die beiden Schlitzohren\n[CS:N]Banette[CR] und [CS:N]Pionskora[CR]!", italian="Sono quei prepotenti di [CS:N]Banette[CR]\ne [CS:N]Skorupi[CR]!", spanish="Esos abusones, [CS:N]Banette[CR]\ny [CS:N]Skorupi[CR]."})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(224, 156, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(npc_npc_jupetta, 256, 136, false, 2)
  GAME:WaitFrames(4)
  GROUND:MoveToPosition(npc_npc_sukorupi, 256, 160, false, 2)
  GAME:WaitFrames(25)
  GROUND:MoveToPosition(npc_npc_upaa, 156, 136, false, 2)
  GAME:WaitFrames(4)
  GROUND:MoveToPosition(npc_npc_muchuuru, 132, 152, false, 2)
  GAME:WaitFrames(8)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_subomii, "sweating", 1) end)
  GROUND:MoveToPosition(npc_npc_subomii, 156, 164, false, 2)
  GROUND:EntTurn(npc_npc_upaa, Direction.Right)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_muchuuru, Direction.Right)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_subomii, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_jupetta, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english=" Oh!", french=" Oh!", german=" Oh!", italian=" Oh!", spanish=" ¡Anda!"})
  GROUND:EntTurn(npc_npc_sukorupi, Direction.UpLeft)
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english="Hey, [CS:Y]Igglybuff[CR].[K]\nYou've got Gummis?", french="Hé, [CS:Y]Toudoudou[CR].[K]\nT'as des gelées?", german="Hallo [CS:Y]Fluffeluff[CR].[K]\nDu hast also Gummibonbons?", italian="Ehi, [CS:Y]Igglybuff[CR].[K]\nHai delle Gomme?", spanish=" Oye, [CS:Y]Igglybuff[CR].[K] Tienes gomis, ¿no?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  do local p=npc_npc_sukorupi.Position; GROUND:MoveToPosition(npc_npc_sukorupi, p.X+(-8), p.Y+(0), false, 1) end -- Move2PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_sukorupi, Direction.UpLeft)
  GAME:WaitFrames(4)
  GROUND:EntTurn(hero, Direction.DownRight)
  pcall(function() UI:SetSpeaker(npc_npc_sukorupi) end)
  SkySceneKit.say({english=" Give us some Gummis too.", french=" File-nous des gelées, vas-y.", german=" Wir wollen auch welche.", italian=" Danne una anche a noi.", spanish=" Nosotros también queremos."})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Right)
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english="Lots.[K] Bunches.[K]\nHeaps of them.", french="Plein.[K] Des tas.[K]\nOn en veut des sacs entiers.", german="Und zwar viele.[K] In Mengen.[K]\nHaufenweise Gummibonbons.", italian="Daccene tante.[K] Un sacco.[K]\nA valanghe.", spanish="Montones.[K] Puñados.[K]\nLas queremos a mogollón."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Yep, sure! ♪[K]\nFriendly friends! ♪", french="Mais oui, bien sûr! ♪[K]\nCopains de moi! ♪", german="Aber natürlich! ♪[K]\nLiebe Freunde! ♪", italian="Sì, certo! ♪[K]\nAmicissimi! ♪", spanish="¡Sí, claro! ♪[K]\n¡Los amigos son lo mejor! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  do local p=npc_npc_jupetta.Position; GROUND:MoveToPosition(npc_npc_jupetta, p.X+(-10), p.Y+(0), false, 2) end -- Move2PositionOffset
  GAME:WaitFrames(4)
  do local p=npc_npc_sukorupi.Position; GROUND:MoveToPosition(npc_npc_sukorupi, p.X+(-8), p.Y+(-6), false, 2) end -- Move2PositionOffset
  GAME:WaitFrames(6)
  GROUND:EntTurn(hero, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_sukorupi, Direction.UpLeft)
  pcall(function() GROUND:CharSetEmote(npc_npc_jupetta, "happy", 1) end)
  GAME:WaitFrames(8)
  pcall(function() GROUND:CharSetEmote(npc_npc_sukorupi, "happy", 1) end)
  GAME:WaitFrames(15)
  pcall(function() GAME:MoveCamera(156, 156, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(15)
  -- message_FacePositionOffset(0, 1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_muchuuru) end)
  SkySceneKit.say({english="Why is [CS:Y]Igglybuff[CR] making friends\nwith those bullies?", french="Pourquoi est-ce que [CS:Y]Toudoudou[CR]\nfait ami-ami avec eux?", german="Warum lässt sich [CS:Y]Fluffeluff[CR]\nmit diesen Schlitzohren ein?", italian="Perché mai [CS:Y]Igglybuff[CR] stringe\namicizia con quei bulletti?", spanish="¿Por qué se porta tan bien\n[CS:Y]Igglybuff[CR] con esos abusones?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_upaa, Direction.DownLeft)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_muchuuru, Direction.UpRight)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_subomii, Direction.UpLeft)
  pcall(function() UI:SetSpeaker(npc_npc_upaa) end)
  SkySceneKit.say({english="I sometimes play with\n[CS:N]Banette[CR]'s group...", french="Des fois, je joue avec la bande à\n[CS:N]Branette[CR]...", german="Ich habe schon mal mit [CS:N]Banette[CR]\nund seinen Freunden gespielt...", italian="Qualche volta mi capita\ndi giocare con il gruppo di [CS:N]Banette[CR]...", spanish="A veces juego con la pandilla\nde [CS:N]Banette[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_upaa) end)
  SkySceneKit.say({english="But they always boss me\naround...[K] And if you cross them,\nthey're really mean...[K] Sniff...", french="Mais y font rien qu'à me\ncommander...[K] Et si tu t'amuses à les\ncontredire, y te font ta fête...[K] Snif...", german="Aber sie wollten immer alles\nbestimmen...[K] Und wenn man sie allein trifft,\nkönnen sie echt gemein sein...[K] Schnief...", italian="Ma sono sempre così prepotenti\ncon me...[K] E se li incroci per strada,\niniziano a prenderti in giro...[K] Sniff...", spanish="Pero son unos mandones\ninsoportables...[K] Y si los haces enfadar,[K]\nse portan fatal, jo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_upaa, Direction.Right)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_muchuuru, Direction.Right)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_subomii, Direction.Right)
  pcall(function() UI:SetSpeaker(npc_npc_subomii) end)
  SkySceneKit.say({english="Maybe [CS:Y]Igglybuff[CR] isn't scared of\nthose two?", french="Peut-être que [CS:Y]Toudoudou[CR],\nil a pas peur d'eux?", german="Anscheinend hat [CS:Y]Fluffeluff[CR] keine\nAngst vor den beiden...", italian="Forse [CS:Y]Igglybuff[CR] non ha paura\ndi quei due...", spanish="Igual a [CS:Y]Igglybuff[CR] no le dan miedo\nesos dos, ¿no?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(224, 156, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(npc_npc_jupetta, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_sukorupi, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_jupetta, "happy", 1) end)
  -- message_FacePositionOffset(2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english="Gummis are so delicious!\nChew-chew...[K] (It's kind of weird that this guy\nisn't the slightest bit scared of us...)", french="Les gelées, c'est dément!\nMiam-miam...[K] (Bizarre qu'il ait pas\ndu tout peur de nous...)", german="Gummibonbons sind so lecker!\nMampf-Mampf...[K] (Sonderbar, dass dieser kleine\nrosa Farbklecks keine Angst vor uns hat...)", italian="Le Gomme sono così buone!\nGnam gnam...[K] (Strano che non abbia\nla benché minima paura di noi due...)", spanish="¡Qué ricas están las gomis!\nÑam, ñam...[K] (Es rarísimo que a este no\nle demos nada de miedo...)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(npc_npc_jupetta, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_sukorupi, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_sukorupi) end)
  SkySceneKit.say({english="Yeah, they are so yummy!\nChew-chew...[K] (...But it's fine as long as we\ncan boss him around! Heh-heh-heh!)", french="Ouais, tu l'as dit, bouffi!\nMiam-miam...[K] (... Pas grave, du moment qu'il\nnous obéit gentiment! Hé hé hé!)", german="Oh ja, sie schmecken so köstlich!\nMampf-Mampf...[K] (...Ist ja auch egal, solange\nwir über ihn bestimmen können! Hehehehe!)", italian="Sì, sono proprio deliziose!\nChomp chomp...[K] (Ma finché fa quello che\ngli diciamo, non c'è problema! Ih ih ih!)", spanish="¡Sí, están de vicio! Ñam, ñam...[K]\n(En fin, mientras podamos mangonearle, a mí,\nplim. ¡Je, je, je!)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(npc_npc_sukorupi, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(20)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- message_FacePositionOffset(2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english=" Hey, gimme another Gummi!", french=" Hé, une autre gelée, vite!", german="Hey, gib mir noch ein\nGummibonbon!", italian=" Ehi, dammene un'altra!", spanish=" ¡Eh, dame otra gomi!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_sukorupi) end)
  SkySceneKit.say({english=" Me too!", french=" Pour moi aussi!", german=" Mir auch!", italian=" Anche a me!", spanish=" ¡Y a mí también!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yep! ♪", french=" Voui, voui! ♪", german=" Aber gerne! ♪", italian=" Sì! ♪", spanish=" ¡Vale! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(hero, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" ...[K]Huh?", french=" ...[K] Oh?", german=" ...[K]Huch!", italian=" ...[K] Uh?", spanish=" Huy...[K] Ahí va..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I'm all out of Gummis.", french=" Terminé, je n'ai plus de gelées.", german=" Ich habe gar keine mehr.", italian=" Ho finito tutte le Gomme.", spanish=" Pues me he quedado sin gomis."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I had so many of them too...[K]\nI wonder what happened.", french="Pourtant j'en avais tout\nun paquet...[K] Où elles ont bien pu passer?", german="Dabei hatte ich doch so viele...[K]\nWas wohl mit ihnen passiert ist?", italian="E pensare che ne avevo\ncosì tante...[K] Che fine avranno fatto?", spanish="Y mira que tenía un montón...[K]\n¿Qué habrá pasado?"})
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Sorry. Hee-hee-hee. ♪", french=" Oups, désolé. Hi hi hi. ♪", german=" Tut mir leid. Hi-hi-hi. ♪", italian=" Mi spiace. Eh eh eh. ♪", spanish=" Lo siento. Ji, ji, ji. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(15)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_jupetta.Position; GROUND:MoveToPosition(npc_npc_jupetta, p.X+(10), p.Y+(0), false, 2) end -- Slide2PositionOffset
  GAME:WaitFrames(4)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_sukorupi.Position; GROUND:MoveToPosition(npc_npc_sukorupi, p.X+(8), p.Y+(6), false, 2) end -- Slide2PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english="It's all right. (Wow! I mean,\nwe ate up all of them. Didn't he notice?)", french="Ça ira. (Ouah! On a tout becté\net il a rien remarqué?)", german="Ist schon okay... (Wow!\nImmerhin haben wir alle weggefuttert.\nHat er das gar nicht gemerkt?)", italian="Ok, va bene. (Wow! Ce le siamo\nmangiate tutte noi. Possibile che non\nse ne sia accorto?)", spanish="Da igual. (¡Yo flipo! Nos las hemos\ncomido todas, este no se cosca de nada.)"})
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english=" It's all right...[K] We'll forgive you.", french=" Ça ira...[K] pour cette fois.", german="Geht schon...[K]\nWir vergeben dir noch einmal.", italian="Non c'è problema...[K]\nTi perdoniamo.", spanish=" No pasa nada,[K] te perdonamos."})
  pcall(function() UI:SetSpeaker(npc_npc_jupetta) end)
  SkySceneKit.say({english="Just bring more Gummis\nnext time.", french="Mais ramène-nous plus de\ngelées la prochaine fois.", german="Aber bring nächstes Mal\ngefälligst ein paar mehr mit!", italian="Ma la prossima volta ne devi\nportare di più.", spanish="A condición de que traigas más\ngomis el próximo día."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Right)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yep. ♪ Friendly friends. ♪", french=" Voui. ♪ Copains de moi. ♪", german=" Na klar. ♪ Liebe Freunde. ♪", italian=" Sì. ♪ Amicissimi. ♪", spanish=" ¡Vale! ♪ ¡Amigos! ¡Amigos! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(8)
  pcall(function() GROUND:CharSetEmote(npc_npc_jupetta, "happy", 1) end)
  GAME:WaitFrames(8)
  pcall(function() GROUND:CharSetEmote(npc_npc_sukorupi, "happy", 1) end)
  GAME:WaitFrames(4)
  GROUND:EntTurn(hero, Direction.DownRight)
  GAME:WaitFrames(30)
  pcall(function() GAME:MoveCamera(156, 156, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_subomii) end)
  SkySceneKit.say({english="Ah...[K] Doesn't [CS:Y]Igglybuff[CR] realize\nhe's being played by [CS:N]Banette[CR]?", french="Bah...[K] [CS:Y]Toudoudou[CR] voit pas qu'il\nest en train de se faire avoir par [CS:N]Branette[CR]?", german="Oh...[K] Merkt [CS:Y]Fluffeluff[CR] gar nicht,\nwie [CS:N]Banette[CR] ihn ausnutzt?", italian="Ah...[K] Ma [CS:Y]Igglybuff[CR] non si rende\nconto che [CS:N]Banette[CR] lo prende in giro?", spanish="Ay...[K] ¿Es que [CS:Y]Igglybuff[CR] no se entera\nde que [CS:N]Banette[CR] le está tomando el pelo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, 1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_muchuuru) end)
  SkySceneKit.say({english=" I hate that![K] I won't forgive this!", french="C'est insupportable![K]\nJe peux pas accepter ça!", german="So ein Verhalten kann ich nicht\nleiden![K] Das ist doch nicht auszuhalten!", italian="Non lo sopporto![K]\nNon li perdonerò!", spanish=" ¡Qué rabia![K] ¡Esto no lo consiento!"})
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_upaa, "shock", 1) end)
  GROUND:EntTurn(npc_npc_upaa, Direction.DownLeft)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharSetEmote(npc_npc_subomii, "shock", 1) end)
  GROUND:EntTurn(npc_npc_subomii, Direction.UpLeft)
  GAME:WaitFrames(10)
  do local p=npc_npc_muchuuru.Position; GROUND:MoveToPosition(npc_npc_muchuuru, p.X+(8), p.Y+(0), false, 2) end -- Move2PositionOffset
  GAME:WaitFrames(5)
  do local p=npc_npc_upaa.Position; GROUND:MoveToPosition(npc_npc_upaa, p.X+(0), p.Y+(8), false, 2) end
  GAME:WaitFrames(4)
  do local p=npc_npc_subomii.Position; GROUND:MoveToPosition(npc_npc_subomii, p.X+(0), p.Y+(-8), false, 2) end -- Move2PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_upaa, Direction.Left)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_subomii, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_subomii, "sweating", 1) end)
  GAME:WaitFrames(8)
  pcall(function() GROUND:CharSetEmote(npc_npc_upaa, "sweating", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_upaa) end)
  SkySceneKit.say({english=" Y-you shouldn't get involved!", french="M-mais... vaut mieux pas\ns'en mêler!", german=" M-misch dich besser nicht ein!", italian=" M-Meglio non immischiarsi!", spanish=" ¡Mejor no te metas!"})
  GAME:WaitFrames(2) -- join WaitEffect
  pcall(function() UI:SetSpeaker(npc_npc_upaa) end)
  SkySceneKit.say({english=" They're really big and scary!", french="Y sont vraiment affreux\net balaises!", german="Sie sind größer als wir\nund wirklich furchteinflößend!", italian=" Sono troppo grossi e minacciosi!", spanish=" ¡Son grandotes y dan miedo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_muchuuru, "sweating", 1) end)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_muchuuru.Position; GROUND:MoveToPosition(npc_npc_muchuuru, p.X+(-8), p.Y+(0), false, 1) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitEffect
  -- message_FacePositionOffset(0, 1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_muchuuru) end)
  SkySceneKit.say({english=" Sniff...", french=" Snif...", german=" Schnief...", italian=" Sniff...", spanish=" Jo..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:FadeOutBGM(210) end)
  GAME:WaitFrames(15)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_upaa.Position; GROUND:MoveToPosition(npc_npc_upaa, p.X+(0), p.Y+(-8), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(4)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_subomii.Position; GROUND:MoveToPosition(npc_npc_subomii, p.X+(0), p.Y+(8), false, 2) end -- Slide2PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_muchuuru, Direction.Right)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_upaa, Direction.DownLeft)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_subomii, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_subomii, Direction.Up)
  GAME:WaitFrames(40)
  GROUND:EntTurn(npc_npc_subomii, Direction.UpLeft)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_subomii) end)
  SkySceneKit.say({english=" Hey, everyone.", french=" Hé, les gars.", german=" Hey, alle miteinander.", italian=" Ehi, gente.", spanish=" Eh, tengo una idea."})
  GROUND:EntTurn(npc_npc_muchuuru, Direction.DownRight)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_upaa, Direction.Down)
  pcall(function() UI:SetSpeaker(npc_npc_subomii) end)
  SkySceneKit.say({english="We should go talk to [CS:Y]Igglybuff[CR]'s\n[CS:N]Mama[CR]. She'll know what to do.", french="On devrait aller voir la [CS:N]Maman[CR]\nde [CS:Y]Toudoudou[CR]. Elle saura quoi faire.", german="Wir sollten mit der [CS:N]Mama[CR] von\n[CS:Y]Fluffeluff[CR] sprechen. Sie wird wissen, was zu\ntun ist.", italian="Dovremmo avvertire la [CS:N]mamma[CR]\ndi [CS:Y]Igglybuff[CR]. Lei saprà cosa fare.", spanish="Deberíamos ir a hablar con la [CS:N]mamá[CR]\nde [CS:Y]Igglybuff[CR]. Ella sabrá qué podemos hacer."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, 1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_muchuuru) end)
  SkySceneKit.say({english=" Yep.", french=" D'acc.", german=" Ja!", italian=" Già.", spanish=" Pues sí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_upaa) end)
  SkySceneKit.say({english=" Yeah.", french=" Ouais.", german=" Genau.", italian=" È vero.", spanish=" Es verdad."})
  -- message_Close
  SkySubScreen.Hide(90) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 90)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(60)
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
