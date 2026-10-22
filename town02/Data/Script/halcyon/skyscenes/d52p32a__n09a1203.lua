-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D52P32A/n09a1203.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D52P32A) [neutre/état moteur]
  -- supervision_ActingInvisible(5) [acting caché superviseur NDS]
  -- supervision_ActingInvisible(4) [acting caché superviseur NDS]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_serebii = SkySceneKit.spawn_npc("celebi", 256, 144, Direction.Down, "NPC_SEREBII")
  -- SetAnimation(23) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetOutputAttribute(1) [neutre/état moteur]
  local npc_npc_mikaruge = SkySceneKit.spawn_npc("spiritomb", 256, 160, Direction.Down, "NPC_MIKARUGE")
  -- SetAnimation(26) [anim idle native]
  -- SetOutputAttribute(8) [neutre/état moteur]
  -- bgm2_PlayFadeIn(BGM_STATIC_NOISE) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  GAME:FadeIn(30)
  GROUND:MoveToPosition(hero, 252, 276, false, 2)
  local npc_npc_yonowaaru_n9 = SkySceneKit.spawn_npc("dusknoir", 280, 472, Direction.Up, "NPC_YONOWAARU_N9")
  GROUND:MoveToPosition(npc_npc_yonowaaru_n9, 276, 328, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Ah![K] That is--", french=" Ah![K] C'est...", german=" Oh![K] Das ist...", italian=" Ah![K] M-Ma è...", spanish=" ¡Ah![K] Pero si es..."})
  -- message_Close
  pcall(function() GAME:MoveCamera(252, 164, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  pcall(function() SOUND:PlayBGM("Rising Fear.ogg", true) end)
  pcall(function() UI:SetSpeaker(hero) end) -- message_SetActor(ACTOR_PLAYER_FUTURE)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" [CS:N]Ce-[K]Celebi[CR]!", french=" [CS:N]Ce-[K]Celebi[CR]!", german=" [CS:N]C-[CR][K][CS:N]Celebi[CR]!", italian=" [CS:N]C-[CR][K][CS:N]Celebi[CR]!", spanish=" [CS:N]Ce[CR]...[K] ¡[CS:N]Celebi[CR]!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CS:N]Celebi[CR]! Can you hear me?![K]\nIt's me! It's [CS:Y]Grovyle[CR]!", french="[CS:N]Celebi[CR]! Tu m'entends?![K]\nC'est moi! [CS:Y]Massko[CR]!", german="[CS:N]Celebi[CR]! Kannst du mich hören?!?[K]\nIch bin's, [CS:Y]Reptain[CR]!", italian="[CS:N]Celebi[CR]! Riesci a sentirmi?![K]\nSono io! [CS:Y]Grovyle[CR]!", spanish="¡[CS:N]Celebi[CR]! ¡¿Me oyes?![K]\n¡Soy yo! ¡Soy [CS:Y]Grovyle[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" .........", french=" .........", german=" .........", italian=" .........", spanish=" ..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(252, 228, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(hero, 252, 244, false, 2)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Is someone holding you back?", french=" On te retient prisonnière?", german=" Hält dich jemand gefangen?", italian=" Qualcuno ti ha immobilizzata?", spanish=" ¿Alguien te está reteniendo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8965) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="There's an Odd Keystone\nnearby...[K] That means...", french="Une Clé de Voûte...[K]\nAutrement dit...", german="Warte mal... Ein Spiritkern\ngleich nebendran...[K] Das bedeutet...", italian="Vedo una Roccianima qui vicino...[K]\nSignifica che...", spanish="Hay una Piedra Espíritu al lado...[K]\nEso significa que..."})
  -- message_Close
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-8), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" [CS:N]Spiritomb[CR]!", french=" [CS:N]Spiritomb[CR]!", german=" [CS:N]Kryppuk[CR]!", italian=" [CS:N]Spiritomb[CR]!", spanish=" ¡[CS:N]Spiritomb[CR]!"})
  -- message_Close
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(-40), 40, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  -- MoveHeight(2, 8) [élévation d'objet NDS non simulée - documenté]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(1)
  -- MoveHeight(2, 0) [élévation d'objet NDS non simulée - documenté]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_mikaruge) end) -- message_SetActor(ACTOR_NPC_MIKARUGE)
  pcall(function() UI:SetSpeaker(npc_npc_mikaruge) end)
  SkySceneKit.say({english=" HEE-hee!", french=" HEE hee!", german=" HEEhee!", italian=" EHH-Eh!", spanish=" ¡Ji, ji, ji...!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(7427) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(23) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_mikaruge, "sweating", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_mikaruge) end)
  SkySceneKit.say({english=" HEE-hee HEE-hee HEE-hee!", french=" HEE hee HEE hee HEE hee!", german=" HEEhee HEEhee HEEhee!", italian=" EHH-Eh EHH-Eh EHH-Eh!", spanish=" ¡Ji, ji, ji...! ¡Ji, ji, ji...!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(40), 40, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" [CS:N]Spiritomb[CR]![K] You!", french=" [CS:N]Spiritomb[CR]![K] Toi ici!", german=" [CS:N]Kryppuk[CR]![K] Du!", italian=" [CS:N]Spiritomb[CR]![K] Tu!", spanish=" ¡[CS:N]Spiritomb[CR]![K] ¡Malvado!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Why have you done\nthis to [CS:N]Celebi[CR]?!", french=" Pourquoi t'en prendre à [CS:N]Celebi[CR]?!", german="Warum hast du [CS:N]Celebi[CR]\ndas angetan?!?", italian="Perché hai fatto questo a\n[CS:N]Celebi[CR]?!", spanish="¡¿Por qué le has hecho esto\na [CS:N]Celebi[CR]?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_mikaruge, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_mikaruge) end)
  SkySceneKit.say({english="HEE-hee HEE hee! You're wrong![K]\nYou're wrong!", french="HEE hee... HEE hee!\nTu te trompes![K] Tu te trompes!", german="HEEhee HEEhee! Du liegst falsch![K]\nGanz falsch!", italian="EHH-Eh EHH-Eh! Ti sbagli![K]\nTi sbagli!", spanish="¡Ji, ji, ji...! ¡Ji, ji, ji...!\n¡Te equivocas![K] ¡Te equivocas!"})
  pcall(function() UI:SetSpeaker(npc_npc_mikaruge) end)
  SkySceneKit.say({english="This was...[K] This was not\nOUR doing!", french=" Ce n'est...[K] pas de NOTRE fait!", german="Das war...[K]\nDas war nicht UNSERE Tat!", italian=" Non è...[K] Non è opera NOSTRA!", spanish=" Esto...[K] ¡no lo hemos hecho nosotros!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Don't lie!", french=" Mensonges!", german=" Schluss mit der Herumlügerei!", italian=" Non mentire!", spanish=" ¡No mientas! ¿Crees que soy tonto?"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Explain why [CS:N]Celebi[CR] is like this...", french="Explique-toi, pourquoi [CS:N]Celebi[CR]\nest-elle dans cette posture?", german="Erkläre uns lieber, warum [CS:N]Celebi[CR]\nso daliegt...", italian="Spiegami perché [CS:N]Celebi[CR]\nè in questo stato...", spanish="Explícame por qué [CS:N]Celebi[CR] está\nasí..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="You've done this to me before,\nso I know it's you!", french="Tu m'as déjà fait le coup,\nje sais que c'est toi!", german="Das hast du mir früher\nauch schon einmal angetan, daher\nweiß ich, dass du es warst!", italian="So che sei tu il responsabile,\nmi hai fatto la stessa cosa!", spanish="Ya me has hecho esto antes,\n¡así que sé que has sido tú!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Besides, if you didn't do this to\n[CS:N]Celebi[CR], then who else could have...", french=" Si ce n'est pas toi, alors qui?", german="Wenn nicht du [CS:N]Celebi[CR] so\nzugerichtet hast, wer soll es dann\ngewesen sein?!?", italian="E poi se non sei stato tu a fare\ntutto questo a [CS:N]Celebi[CR], chi altri potrebbe...?", spanish="Además, si tú no le has hecho\nesto a [CS:N]Celebi[CR], ¿quién iba a...?"})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(30) end)
  GAME:WaitFrames(15)
  -- SetOutputAttribute(8) [neutre/état moteur]
  -- SetupOutputAttributeAndAnimation<object OBJECT_D52P32A9_559> [prop décor NDS, rendu du ground]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- GAP: se_Play(10764) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D52P32A9_559) [routine d'objet NDS non simulée - documenté]
  -- supervision_RemoveActing(4) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(20)
  -- GAP: BGM BGM_ON_THE_CEILING non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" ...! (Wh-[K]what?!)", french=" ...! (Hein?[K] Quoi?!)", german=" ...(W-[K]was?!?)", italian=" ...! (C-[K]Cosa?!)", spanish=" ¡Ah...! (¡¿Pero...[K] qué pasa?!)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" (What is this sensation...)", french=" (Quelle est cette sensation...)", german="(Irgendetwas fühlt sich hier\ngerade komisch an...)", italian=" (Che cos'è questa sensazione...?)", spanish=" (¿Qué es esta sensación?)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="(Why...[K] I don't\nunderstand why...)", french="(Pourquoi...[K] Je ne comprends\npas...)", german="(Warum nur...[K]\nIch verstehe nicht, warum...)", italian=" (Perché...[K] Non capisco perché...)", spanish=" (¿Por qué...?[K] No entiendo por qué...)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="(Every nerve in my body\nis bristling!)", french="(Tous les nerfs de mon corps\ntressaillent!)", german="(Als ob jeder Nerv meines\nKörpers zu kribbeln anfängt!)", italian=" (Ho tutti i nervi del corpo tesi!)", spanish="(¡Se me ha puesto la carne\nde gallina!)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" (Th-this is a bad sign!)", french=" (C'est mauvais signe!)", german="(D-das ist\nein schlechtes Zeichen!)", italian=" (È-È un brutto segno!)", spanish=" (¡Esto es muy mala señal!)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="(My instincts are screaming out\nthat something's very wrong!)", french="(Mon instinct me dit qu'il y a\nquelque chose de pas clair, là-dedans!)", german="(Meine Instinkte sagen mir,\ndass etwas gerade ganz verkehrt läuft!)", italian="(Il mio istinto mi dice che sta\nper accadere qualcosa di terribile!)", spanish="(¡Tengo la sensación de que aquí\nhay algo que no marcha nada bien!)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="(But...[K]where is this feeling\ncoming from?!)", french="(Mais...[K] d'où vient\nce sentiment?!)", german="(Nur...[K] Woher kommt\ndieses Gefühl?!?)", italian="(Ma...[K] da dove nasce questa\nsensazione?!)", spanish="(Pero...[K] ¡¿de dónde proviene\nesa sensación?!)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_2") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_mikaruge) end)
  SkySceneKit.say({english="HEE-hee! You're wrong![K] Please\nbelieve us!", french="HEE hee! Tu te trompes![K]\nCrois-nous!", german="HEEhee! Du liegst FALSCH![K]\nBitte glaube uns!", italian="EHH-Eh! Ti sbagli![K] Ti prego\ndi crederci!", spanish="¡Ji, ji, ji...! ¡Te equivocas![K]\n¡Tienes que creernos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="... (What is it trying to tell me,\nthis overpowering sense of dread?!)", french="... (Quelque chose ne va pas,\nje le sens, mais quoi?!)", german="...(Will mir dieses übermäßige\nGefühl der Furcht etwas mitteilen?!?)", italian="... (Questa fortissima sensazione\ndi paura... cosa significa?!)", spanish="Ah... (¡¿Qué significará ese miedo\nque siento?!)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="(What have I failed to\nunderstand?![K] What am I wrong about?!)", french="(Qu'ai-je mal compris?![K]\nA propos de quoi je me trompe?!)", german="(Was genau habe ich noch nicht\nverstanden?!?[K] Woran habe ich nicht\ngedacht?!?)", italian="(Che cos'è che mi sfugge?![K]\nChe sbaglio sto commettendo?!)", spanish="(¡¿Qué es lo que no he conseguido\nentender?![K] ¡¿En qué me equivoco?!)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_serebii, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" ...![K] [CS:Y]G-Grovyle[CR]!", french=" ...![K] [CS:Y]Ma-Massko[CR]!", german=" ...[K][CS:Y]R-Reptain[CR]!", italian=" ...![K] [CS:Y]G-Grovyle[CR]!", spanish=" ¡Ah!...[K] [CS:Y]Gro[CR]... ¡[CS:Y]Grovyle[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_mikaruge, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_mikaruge, Direction.Up)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" [CS:N]Celebi[CR]![K] You're awake!", french="[CS:N]Celebi[CR]![K] Tu as repris\nconnaissance!", german=" [CS:N]Celebi[CR]![K] Du bist aufgewacht!", italian=" [CS:N]Celebi[CR]![K] Ti sei ripresa!", spanish=" ¡[CS:N]Celebi[CR]![K] ¡Estás despierta!"})
  -- message_Close
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(-40), 27, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_mikaruge, "angry", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_mikaruge) end)
  SkySceneKit.say({english="Y-you![K] You SURE picked a\nstrange time to wake up!", french="Toi![K] Le moment est MAL choisi\npour te réveiller!", german="D-du![K] Da hast du dir aber eine\nSONDERBARE Zeit zum Aufwachen ausgesucht!", italian="T-Tu![K] Hai scelto un momento\nDAVVERO strano per svegliarti!", spanish="¡Tú![K] ¡Has escogido un momento\nmuy raro para despertarte!"})
  pcall(function() UI:SetSpeaker(npc_npc_mikaruge) end)
  SkySceneKit.say({english=" If we'd let you FLEE, we...", french="Si nous t'avions\nlaissée t'ECHAPPER...", german="Würden wir dich\nFLIEHEN lassen, dann...", italian="Se ti avessi lasciata SCAPPARE,\nnoi...", spanish=" Si te hubiéramos dejado huir..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_mikaruge, nil, 0) end) -- EFFECT_NONE
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(40), 27, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Let [CS:N]Celebi[CR] go, [CS:N]Spiritomb[CR]!", french=" Libère [CS:N]Celebi[CR], [CS:N]Spiritomb[CR]!", german=" Lass [CS:N]Celebi[CR] gehen, [CS:N]Kryppuk[CR]!", italian=" Lascia andare [CS:N]Celebi[CR], [CS:N]Spiritomb[CR]!", spanish=" ¡Suelta a [CS:N]Celebi[CR], [CS:N]Spiritomb[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_mikaruge, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_mikaruge, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="If you won't let her go, I'll knock\nyou out![K] Don't make me use force!", french="Sinon, je te fais ta fête![K]\nNe m'oblige pas à utiliser la force!", german="Wenn du es nicht gehen lässt,\nwirst du was erleben![K] Zwinge uns nicht,\nGewalt anzuwenden!", italian="Se non lo fai, te la vedrai\nbrutta![K] Non costringermi a usare la forza!", spanish="Si no dejas que se vaya, ¡te daré\ntu merecido![K] ¡No me hagas usar la fuerza!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(hero, 252, 216, false, 2)
  pcall(function() SOUND:FadeOutBGM(30) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_serebii, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" D-don't come near!", french=" N'approche pas!", german=" N-nicht näherkommen!", italian=" N-Non avvicinarti!", spanish=" ¡No te acerques!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Wh...", french=" Quoi...", german=" Wa...", italian=" Per...", spanish=" ¿Por qué...?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(10765) — id SE NDS sans portage PMDO identifié
  -- supervision_ActingInvisible(2) [acting caché superviseur NDS]
  -- SetAnimation(10) [anim idle native]
  -- SetOutputAttribute(8) [neutre/état moteur]
  -- SetupOutputAttributeAndAnimation<object OBJECT_D52P32A4_460> [prop décor NDS, rendu du ground]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- ExecuteCommon(CORO_LOOK_AROUND_FAST_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D52P32A4_460) [routine d'objet NDS non simulée - documenté]
  -- SetOutputAttribute(8) [neutre/état moteur]
  -- SetAnimation(1) [anim idle native]
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- SetOutputAttribute(128) [neutre/état moteur]
  -- supervision_Acting(3) [neutre/état moteur]
  -- SetOutputAttribute(8) [neutre/état moteur]
  -- SetOutputAttribute(1) [neutre/état moteur]
  -- GAP: se_Play(10767) — id SE NDS sans portage PMDO identifié
  -- bgm2_PlayFadeIn(BGM_ANOTHER_STATIC_NOISE) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  -- SetOutputAttribute(128) [neutre/état moteur]
  -- SetupOutputAttributeAndAnimation<object OBJECT_D52P32A5_461> [prop décor NDS, rendu du ground]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" GWAAAAAAAAaaaaaaaaaaaaahh!", french=" Aaaaaaaaaaaaaaaahhhh!", german=" GWAAAAAAAAaaaaaaaaaaaaah!", italian=" GUAAAAAAAAaaaaaaaaaaaaahh!", spanish=" ¡¡Aaay!!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- se_FadeOut(10767, 30) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  GAME:WaitFrames(30)
  -- ResetOutputAttribute(128) [neutre/état moteur]
  -- SetOutputAttribute(128) [neutre/état moteur]
  -- SetAnimation(1) [anim idle native]
  GAME:WaitFrames(45)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_mikaruge) end)
  SkySceneKit.say({english=" Hya! We did it![K] HYA hya hya!", french=" Oui! Nous AVONS réussi![K] Réussi!", german="Hya! Haben wir DICH![K]\nHya hya hya!", italian="Urrà! Ce l'abbiamo fatta![K]\nYuppiii! Evviva! Urrà!", spanish="¡Jua, jua! ¡Lo conseguimos![K]\n¡Jua, jua, jua! ¡Pardillo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" GWAAA![K] Y-YOU!!", french=" AAAAH![K] INFAME SCELERAT!!", german=" GWAAA![K] D-DU!!!", italian=" GUAAAH![K] T-TU!!!", spanish=" ¡¡Aaay!![K] ¡¡Tú!!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="ARGH! (My strength...[K] I'm losing\nmy strength!)", french="ARGH! (Ma force...[K] ma force\nm'abandonne!)", german="ARGH! (Meine Kraft...[K]\nIch verliere meine Kraft!)", italian="ARGH! (Le mie forze...[K] Sto\nperdendo le forze!)", spanish="¡¡Aaay!! (Mis fuerzas...[K]\n¡Noto que me estoy debilitando!)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" ... (Th...[K] This is...)", french=" ... (C'est...[K] c'est...)", german=" ...(D-[K]das ist...)", italian=" ... (Q-[K]Questo è...)", spanish=" Ay... (Esto...[K] Esto es...)"})
  -- message_Close
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(-24), 24, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_mikaruge) end)
  SkySceneKit.say({english=" Um...[K] We can GO now, right?", french="Euh...[K] nous pouvons y ALLER,\nmaintenant?", german="Ähm...[K]\nWir können jetzt GEHEN, oder?", italian="Uhm...[K] Ora possiamo andare,\nVERO?", spanish=" Esto...[K] Podemos irnos ya, ¿no?"})
  pcall(function() UI:SetSpeaker(npc_npc_mikaruge) end)
  SkySceneKit.say({english="We're all done here, so we'll just\nbe on our WAY... [K]But behind [CS:Y]Grovyle[CR] is...", french="Nous avons REMPLI notre\nmission, alors nous vous quittons...\n[K]Mais derrière [CS:Y]Massko[CR] c'est...", german="Unser Job hier ist erledigt,\nalso machen wir uns auf den WEG...[K]\nOh, dort hinter [CS:Y]Reptain[CR]...", italian="Abbiamo fatto quello che\ndovevamo, quindi ce ne ANDIAMO...[K]\nUn attimo, dietro [CS:Y]Grovyle[CR] c'è...", spanish="Ya no se nos necesita, así que\nnos iremos...[K] Pero detrás de [CS:Y]Grovyle[CR] está..."})
  pcall(function() UI:SetSpeaker(npc_npc_mikaruge) end)
  SkySceneKit.say({english=" [CS:N]Dusknoir[CR]...[K] We can GO, right?", french="[CS:N]Noctunoir[CR]![K] Nous POUVONS y\naller, n'est-ce pas?", german="Es ist [CS:N]Zwirrfinst[CR]...[K]\nWir können GEHEN, nicht wahr?", italian="[CS:N]Dusknoir[CR]...[K] Possiamo\nANDARCENE, vero?", spanish=" [CS:N]Dusknoir[CR]...[K] Nos podemos ir ya, ¿no?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" What...[K] What are you saying?!", french="Qu'est-ce...[K] qu'est-ce que\ntu dis?!", german=" Was...[K] Was sagst du da?!?", italian=" Cosa...[K] Cosa stai dicendo?!", spanish=" ¿Qué...?[K] ¡¿Qué dices?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(252, 284, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(npc_npc_yonowaaru_n9, 252, 288, false, 1)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- SetAnimation(39) [anim idle native]
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Heh heh heh.[K] Get hold of\nyourself, [CS:N]Spiritomb[CR].", french="Ha ha ha ho ho ho.[K] Patience,\n[CS:N]Spiritomb[CR].", german="Hehehe.[K]\nReiß dich zusammen, [CS:N]Kryppuk[CR].", italian=" Eh eh eh![K] Aspetta, [CS:N]Spiritomb[CR].", spanish="¡Ja, ja, ja![K] No te apures tanto,\n[CS:N]Spiritomb[CR]."})
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Remain with us a little longer!", french="Fais-nous l'honneur de ta\ncompagnie encore quelques instants!", german="Bleib doch noch\nein bisschen bei uns!", italian=" Rimani con noi ancora un po'!", spanish=" ¡Quédate un poquito más!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="[CS:N]Sableye[CR]: Wheh-heh-heh!", french="[CS:N]Ténéfix[CR]: Whé hé hé!", german="[CS:N]Zobiris[CR]: Wähähäh!", italian="[CS:N]Sableye[CR]: Meh-eh-eh!", spanish="[CS:N]Sableye[CR]: ¡Je, je, je!"})
  -- message_Close
  -- GAP: se_Play(6420) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_yamirami4 = SkySceneKit.spawn_npc("sableye", 200, 384, Direction.Up, "NPC_YAMIRAMI4")
  GROUND:MoveToPosition(npc_npc_yamirami4, 200, 292, false, 2)
  local npc_npc_yamirami5 = SkySceneKit.spawn_npc("sableye", 256, 432, Direction.Up, "NPC_YAMIRAMI5")
  GROUND:MoveToPosition(npc_npc_yamirami5, 252, 316, false, 2)
  local npc_npc_yamirami6 = SkySceneKit.spawn_npc("sableye", 312, 408, Direction.Up, "NPC_YAMIRAMI6")
  GROUND:MoveToPosition(npc_npc_yamirami6, 308, 292, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- se_FadeOut(6420, 30) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  pcall(function() GAME:MoveCamera(252, 164, 60, false) end) -- performer/caméra
  GAME:WaitFrames(60)
  -- GAP: se_Play(6420) — id SE NDS sans portage PMDO identifié
  local npc_npc_yamirami = SkySceneKit.spawn_npc("sableye", 200, 40, Direction.Down, "NPC_YAMIRAMI")
  GROUND:MoveToPosition(npc_npc_yamirami, 200, 124, false, 2)
  local npc_npc_yamirami2 = SkySceneKit.spawn_npc("sableye", 256, 8, Direction.Down, "NPC_YAMIRAMI2")
  GROUND:MoveToPosition(npc_npc_yamirami2, 252, 108, false, 2)
  local npc_npc_yamirami3 = SkySceneKit.spawn_npc("sableye", 312, 56, Direction.Down, "NPC_YAMIRAMI3")
  GROUND:MoveToPosition(npc_npc_yamirami3, 308, 124, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- se_FadeOut(6420, 30) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  GROUND:EntTurn(npc_npc_mikaruge, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_mikaruge.Position; GROUND:MoveToPosition(npc_npc_mikaruge, p.X+(0), p.Y+(12), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- ExecuteCommon(CORO_LOOK_AROUND_FAST_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_mikaruge, "sweating", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_mikaruge) end)
  SkySceneKit.say({english=" HEE-hee![K] HEE-hee HEE-hee!", french=" HEE hee![K] HEE hee HEE hee!", german=" HEEhee![K] HEEhee HEEhee!", italian=" EHH-Eh![K] EHH-Eh EHH-Eh!", spanish=" ¡Ji, ji, ji...![K] ¡Ji, ji, ji...!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(252, 284, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  pcall(function() SOUND:PlayBGM("Hidden Highland.ogg", true) end)
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="...[K]Heh heh heh.[K]\nHEH HA HA HA HA HA HA HA HA HA HA HA HA!", french="...[K] Ho ho ho.[K]\nHA HA HA HA HA HA HA HA HA HA HA HA!", german="...[K]Hehehe.[K]\nHEH HAHAHAH HAHAHAHAH HAHAHAHAHAHAHA!", italian="...[K] Eh eh eh![K]\nEH AH AH AH AH AH AH AH AH AH!", spanish="Ja, ja...[K] Ja, ja, ja.[K]\n¡¡¡Jua, jua, jua!!!"})
  -- SetAnimation(39) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CS:N]Dusknoir[CR]! YOU![K]\nWhat's going on?!", french="[CS:N]Noctunoir[CR]! Explique-toi![K]\nQue se passe-t-il?!", german="[CS:N]Zwirrfinst[CR]! DU![K]\nWas geht hier vor sich?!?", italian="[CS:N]Dusknoir[CR]! TU![K]\nChe sta succedendo?!", spanish="¡[CS:N]Dusknoir[CR]! ¡¡Tú!![K]\n¡¿Qué está pasando?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Listen,[K] [CS:Y]Grovyle[CR]!", french=" Ecoute,[K] [CS:Y]Massko[CR]!", german=" Hör gut zu,[K] [CS:Y]Reptain[CR]!", italian=" Ascolta,[K] [CS:Y]Grovyle[CR]!", spanish=" ¡Escucha...[K] [CS:Y]Grovyle[CR]!"})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Master [CS:N]Dialga[CR]'s new henchman...[K]\nFrom the start, it was never revealed...", french="Le nouveau bras droit de Maître\n[CS:N]Dialga[CR]...[K] Tout ce temps, son identité est\nrestée un mystère...", german="Dieser neue Gehilfe von Meister\n[CS:N]Dialga[CR]...[K] Niemand hat eine Ahnung, wer er ist...", italian="Il nuovo servitore del Maestro\n[CS:N]Dialga[CR]...[K] Fin dall'inizio, la sua identità non\nè mai stata svelata...", spanish="¿No te extrañaba no saber nada\nde la nueva mano derecha de [CS:N]Dialga[CR]?[K]\n¿Te parecía normal?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" What?!", french=" Quoi?!", german=" Was?!?", italian=" Come?!", spanish=" ¡¿Qué?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Everything...[K] Everything has\ngone according to my plan.", french="Tout s'est déroulé selon\nmon plan.", german="Alles...[K] Wirklich alles ist so\ngelaufen, wie ich es geplant hatte.", italian="Ogni cosa...[K] è andata secondo\ni miei piani.", spanish="Jua...[K] Me encanta que los planes\nsalgan bien."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yonowaaru_n9, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_yonowaaru_n9, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_yonowaaru_n9, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="This [CS:P]Icicle Forest[CR] is a\nspecial place...", french="La [CS:P]Forêt Glaçon[CR] est un endroit\ntrès particulier...", german="Der [CS:P]Eiszapfenwald[CR]\nist ein besonderer Ort...", italian="Questo [CS:P]Bosco Gelido[CR] è un posto\nspeciale...", spanish="El [CS:P]Bosque Carámbano[CR] es un lugar\nespecial..."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="If you're hit by the electrical\ndischarge of these ice pillars, your spirit\nwill be melted away.", french="Le pauvre bougre qui est touché\npar l'électricité émise par ces piliers voit\ntous ses souvenirs se désintégrer un à un.", german="Wenn du lange genug den\nEntladungen dieser Eissäulen ausgesetzt bist,\nbleibt dein Körper als leere Hülle zurück.", italian="Chi viene colpito dalla scarica\nelettrica di queste colonne di ghiaccio, vedrà\nla propria coscienza svanire gradualmente.", spanish="Si te alcanza la descarga\neléctrica de estas columnas de hielo,\npoco a poco te irás debilitando."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="It was surprisingly easy to get\nyou to stand in the center of these\nfour pillars...", french="Je suis surpris par la facilité\navec laquelle tu t'es laissé prendre au piège\nde ces piliers...", german="Dich in die Mitte der vier Säulen\nzu lotsen, war überraschend einfach...", italian="Spingerti al centro di queste\nquattro colonne è stato facile come bere\nun bicchier d'acqua...", spanish="Ha sido sorprendentemente fácil\nconseguir que te pusieras justo entre\nestas cuatro columnas..."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="That's where the power is the\nmost concentrated.", french="Tu te trouves précisément au\npoint de convergence de leur pouvoir.", german="An der Stelle ist die Kraft\nam konzentriertesten.", italian="È in quel punto che si concentra\ntutta l'energia.", spanish="Ahí es donde se concentra\ncasi toda la energía."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Ulp! (M-my spirit...[K]will be\nmelted away?!)", french="Gulp! (Mes souvenirs...[K]\ndésintégrés?!)", german="Ulp! (L-leere...[K]\nHülle?!?)", italian="Ulp! (L-La mia coscienza...[K]\nsvanirà gradualmente?!)", spanish="¡Ah! (Entonces...[K] ¡¿me iré debilitando\npoco a poco?!)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="My plan, elegant and useful...[K]\nIt's this...", french="Perfection et élégance, voilà qui\nrésume très bien mon plan...[K] Je m'en vais\nte l'expliquer sur-le-champ...", german="Mein Plan, so effizient\nund elegant...[K] Großartig!", italian="Niente male il mio piano, eh?[K]\nSemplice e geniale...", spanish="Mi plan, sofisticado y eficaz...[K]\nconsistía en eso."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="[CS:Y]Grovyle[CR]...[K] I lured you here\nfor this purpose.", french="[CS:Y]Massko[CR]...[K] Je t'ai attiré ici\nà dessein.", german="[CS:Y]Reptain[CR]...[K]\nIch habe dich hier hingelockt.", italian="[CS:Y]Grovyle[CR]...[K] Ti ho attirato qui con\nl'inganno per uno scopo ben preciso.", spanish="[CS:Y]Grovyle[CR]...[K] Te atraje aquí\ncon esa intención."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="After your spirit has been\nmelted away, I will use your body...", french="Une fois tous tes souvenirs\ndésintégrés, je m'emparerai de ton corps...", german="Sobald dein Körper nur\nnoch eine leere Hülle ist, werde ich\nvon ihm Besitz ergreifen...", italian="Dopo che la tua coscienza sarà\nsvanita, mi approprierò del tuo corpo...", spanish="En cuanto te hayas debilitado,\nusaré tu cuerpo y suplantaré tu identidad..."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="And in your place...[K] I will return\nto the past.", french="Et, dissimulé sous tes traits...[K]\nje retournerai dans le passé.", german="Und in deiner Gestalt...[K]\nwerde ich in die Vergangenheit zurückkehren.", italian="E spacciandomi per te...[K] tornerò\nnel passato.", spanish="Volveré al pasado...[K]\nocupando tu lugar."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Wh-what?!", french=" Quoi?!", german=" W-was?!?", italian=" C-Come?!", spanish=" ¡¿Qué?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yonowaaru_n9, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="If [CS:Y]Grovyle[CR] goes back to\nthe past...", french="Si [CS:Y]Massko[CR] retourne\ndans le passé...", german="Wenn [CS:Y]Reptain[CR] in die\nVergangenheit zurückkehrt...", italian=" Se [CS:Y]Grovyle[CR] ritorna nel passato...", spanish=" [CS:Y]Grovyle[CR], si regresas al pasado..."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="[c_name:NPC_HERO_FIRST] and [c_name:NPC_PARTNER_FIRST]\nwill be so incredibly happy, don't you agree?", french="[c_name:NPC_HERO_FIRST] et [c_name:NPC_PARTNER_FIRST]\nseront euphoriques, n'est-ce pas?", german="Dann werden [c_name:NPC_HERO_FIRST] und\n[c_name:NPC_PARTNER_FIRST] sich wahnsinnig freuen,\nglaubst du nicht auch?", italian="[c_name:NPC_HERO_FIRST] e [c_name:NPC_PARTNER_FIRST]\nfaranno i salti di gioia, non credi?", spanish="[c_name:NPC_HERO_FIRST] y [c_name:NPC_PARTNER_FIRST]\nse alegrarán muchísimo de verte, ¿no crees?"})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="They won't be the slightest bit\nsuspicious...[K] They will accept you as\ntheir friend.", french="J'aurai toute leur confiance...[K]\nSous tes traits, j'apparaîtrai comme leur ami.", german="Sie werden keinen Verdacht\nschöpfen und dich, oder wohl eher mich,\nals alten Freund willkommen heißen.", italian="Non avranno il minimo sospetto...[K]\nE ti accoglieranno come loro amico.", spanish="No sospecharán lo más mínimo...[K]\nTe aceptarán como amigo suyo."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Sadly, the two innocents will be\nunaware of one flaw in their happiness.", french="Hélas, dans leur innocence, ces\ndeux Pokémon seront loin de se douter de\nla supercherie.", german="Wie bedauernswert, dass die\nbeiden den Schönheitsfehler vor lauter\nFreude gar nicht mitbekommen werden.", italian="Purtroppo, la loro felicità sarà\ndi breve durata.", spanish="Por desgracia, en su inocencia\nno sabrán que hay un pequeño detalle\nque no les provocará muchas alegrías."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="The body will be [CS:Y]Grovyle[CR]'s...[K]but\nthe consciousness will be--me!", french="Car, sous l'enveloppe de [CS:Y]Massko[CR],[K]\nc'est moi qui serai à leurs côtés!", german="Der Körper von [CS:Y]Reptain[CR] wird...[K]\ndurch mein Bewusstsein gesteuert werden!", italian="Il corpo sarà il tuo, [CS:Y]Grovyle[CR]...[K]\nma la coscienza sarà la mia!", spanish="El cuerpo será el de [CS:Y]Grovyle[CR],\npero su mente será...[K] ¡la mía!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yonowaaru_n9, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Everything we've done has been\nin preparation for this.", french="Tout ce chemin parcouru pour en\narriver là.", german="Alles, was wir bisher gemacht\nhaben, hat das hier nur vorbereitet.", italian="Tutto ciò che abbiamo fatto\nfinora serviva a questo.", spanish="Todo lo que hemos hecho ha sido\ncon vistas a llegar hasta aquí."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" The new agent...[K] In fact--", french="Le nouveau bras droit...[K]\nEn réalité...", german="Um ehrlich zu sein, ist der\nneue Gehilfe...", italian=" Il nuovo agente...[K] in realtà...", spanish="De hecho...[K] el Pokémon\nque enviaremos al pasado..."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" [CS:Y]Grovyle[CR]![K] It's you!", french=" C'est toi![K] [CS:Y]Massko[CR]!", german="Es ist dein Körper, [CS:Y]Reptain[CR]![K]\nGenau, im Grunde genommen bist du es!", italian=" [CS:Y]Grovyle[CR]![K] Sei tu!", spanish=" ¡Eres tú, [CS:Y]Grovyle[CR]![K] ¡Tú!"})
  -- message_KeyWait
  -- SetAnimation(39) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Uwah ha ha ha ha ha ha!", french=" Mwah ha ha ha ha ha!", german=" Uwahaha hahahaha!", italian=" Uah ah ah ah ah ah ah!", spanish=" ¡Jua, jua, jua, jua, jua!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="No, oh no! [CS:N]Dusknoir[CR]![K]\nThis can't be real!", french="Non! [CS:N]Noctunoir[CR]![K] Je ne peux\npas le croire!", german="Nein, oh nein! [CS:N]Zwirrfinst[CR]![K]\nDas kann nicht wahr sein!", italian="No, oh no! [CS:N]Dusknoir[CR]![K]\nNon può essere vero!", spanish="¡Oh, no! ¡No! ¡[CS:N]Dusknoir[CR]![K]\n¡Esto no puede ser cierto!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I mean...[K] When did you plan...", french="Je veux dire...[K] Quand as-tu mis\nce plan au point?", german="Ich meine...[K]\nWann hast du das alles geplant...", italian="Insomma...[K] Quando hai ideato\nquesto piano...?", spanish="¿Pero cómo...?[K] ¿Cuándo\npudiste planear todo esto?"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Y-you and I returned together to\nthis world from the past.", french="Toi et moi avons regagné\nce monde ensemble.", german="D-du und ich sind zusammen aus\nder Vergangenheit in diese Welt zurückgekehrt.", italian="T-Tu e io siamo ritornati qui\ndal passato insieme.", spanish="¡Tú y yo volvimos juntos\na este mundo desde el pasado!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="There wasn't any time when you\ncould have told this plan to the [CS:N]Sableye[CR].", french="A aucun moment tu n'as eu\nl'occasion d'en parler aux [CS:N]Ténéfix[CR].", german="Du hattest doch gar nicht\ngenügend Zeit, die [CS:N]Zobiris[CR] einzuweihen!", italian="Non avresti mai avuto il tempo\ndi comunicare questo piano ai [CS:N]Sableye[CR].", spanish="No has tenido ningún momento\npara explicar tu plan a los [CS:N]Sableye[CR]."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" So how did you...", french=" Alors comment?", german=" Wie hast du also...", italian=" Quindi come ci sei...?", spanish=" Entonces, ¿cómo has podido...?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="...![K] No, there was time.[K]\nThat time...", french=" ...![K] A moins que...", german="...[K]Doch, es gab einen Zeitpunkt.[K]\nIn dem Augenblick...", italian="...![K] No, in realtà hai avuto\nil tempo necessario.[K] Quella volta...", spanish="¡No...![K] Claro que hubo tiempo.[K]\nPrecisamente..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="When we returned to this\nworld...[K] And saw the [CS:N]Sableye[CR] the first time.", french="A notre arrivée dans ce monde...[K]\nLe premier [CS:N]Ténéfix[CR] que nous avons vu...", german="Nach unserer Ankunft in dieser\nWelt...[K] Als wir den [CS:N]Zobiris[CR] zum ersten\nMal begegneten...", italian="Quando siamo ritornati in questo\nmondo...[K] e ho visto i [CS:N]Sableye[CR] per la prima\nvolta.", spanish="Cuando regresamos a este mundo...[K]\ny vimos por primera vez a los [CS:N]Sableye[CR]."})
  -- message_Close
  GAME:FadeOut(true, 30) -- screen_WhiteOut
  GAME:WaitFrames(30)
  SkySceneKit.cleanup_npcs()
end
