-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P12P01A/m25a0402.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  SkySceneKit.reset_locks()
  SkySceneKit.run_routine(function() -- def 1 for object OBJECT_P12P01A1_147
    -- SetAnimation(17) [anim idle native]
    -- @label_0 [étiquette de flux ExplorerScript]
    -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
    -- Move2PositionMark OBJECT_P12P01A1_147 [cible sans placement SSA zone: mouvement non joué]
    -- SetPositionMark OBJECT_P12P01A1_147 [cible sans placement SSA zone: placement non joué]
    -- continue [contrôle de boucle forever NDS: une itération compilée]
    -- may be redundant
  end)
  SkySceneKit.run_routine(function() -- def 2 for object OBJECT_P12P01A1_148
    -- SetAnimation(18) [anim idle native]
    -- @label_1 [étiquette de flux ExplorerScript]
    -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
    -- Move2PositionMark OBJECT_P12P01A1_148 [cible sans placement SSA zone: mouvement non joué]
    -- SetPositionMark OBJECT_P12P01A1_148 [cible sans placement SSA zone: placement non joué]
    -- continue [contrôle de boucle forever NDS: une itération compilée]
    -- may be redundant
  end)
  SkySceneKit.run_routine(function() -- def 3 for object OBJECT_P12P01A1_149
    -- SetOutputAttribute(8) [neutre/état moteur]
    -- SetOutputAttribute(4) [neutre/état moteur]
    -- SetAnimation(19) [anim idle native]
    -- @label_2 [étiquette de flux ExplorerScript]
    -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
    -- Move2PositionMark OBJECT_P12P01A1_149 [cible sans placement SSA zone: mouvement non joué]
    -- SetPositionMark OBJECT_P12P01A1_149 [cible sans placement SSA zone: placement non joué]
    -- continue [contrôle de boucle forever NDS: une itération compilée]
    -- may be redundant
  end)
  SkySceneKit.run_routine(function() -- def 4 for object OBJECT_P12P01A1_150
    -- SetOutputAttribute(8) [neutre/état moteur]
    -- SetOutputAttribute(4) [neutre/état moteur]
    -- SetAnimation(19) [anim idle native]
    -- @label_3 [étiquette de flux ExplorerScript]
    -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
    -- Move2PositionMark OBJECT_P12P01A1_150 [cible sans placement SSA zone: mouvement non joué]
    -- SetPositionMark OBJECT_P12P01A1_150 [cible sans placement SSA zone: placement non joué]
    -- continue [contrôle de boucle forever NDS: une itération compilée]
    -- may be redundant
  end)
  SkySceneKit.run_routine(function() -- def 5 for object OBJECT_P12P01A1_151
    -- SetAnimation(19) [anim idle native]
    -- @label_4 [étiquette de flux ExplorerScript]
    -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
    -- Move2PositionMark OBJECT_P12P01A1_151 [cible sans placement SSA zone: mouvement non joué]
    -- SetPositionMark OBJECT_P12P01A1_151 [cible sans placement SSA zone: placement non joué]
    -- continue [contrôle de boucle forever NDS: une itération compilée]
    -- may be redundant
  end)
  SkySceneKit.run_routine(function() -- def 6 for object 65535
    -- SetOutputAttribute(8) [neutre/état moteur]
    -- SetOutputAttribute(4) [neutre/état moteur]
    -- SetAnimation(17) [anim idle native]
    -- @label_5 [étiquette de flux ExplorerScript]
    -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
    -- Move2PositionMark 65535 [cible sans placement SSA zone: mouvement non joué]
    -- SetPositionMark 65535 [cible sans placement SSA zone: placement non joué]
    -- continue [contrôle de boucle forever NDS: une itération compilée]
    -- may be redundant
  end)
  GAME:FadeOut(true, 0) -- screen_WhiteOutAll
  GAME:WaitFrames(1)
  -- bgm2_PlayFadeIn(BGM_ANOTHER_GLOWING_NOISE) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  GAME:FadeIn(0)
  -- back_SetGround(LEVEL_P12P01A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(-240), g.ViewCenter.Y+(-240), 120, false) end) -- back_SetBackScrollSpeed(-2.0,-2.0) px/frame -> caméra continue (pilote scroll)
  -- SetOutputAttribute(8) [neutre/état moteur]
  -- SetOutputAttribute(8) [neutre/état moteur]
  -- SetOutputAttribute(8) [neutre/état moteur]
  -- SetOutputAttribute(2) [neutre/état moteur]
  GAME:FadeIn(60)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(10)
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey!", french=" Eh!", german=" Hey!", italian=" Ehi!", spanish=" ¡Oh!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey!", french=" Eh!", german=" Hey!", italian=" Ehi!", spanish=" ¡Oh!"})
  else
  SkySceneKit.say({english=" Oh!", french=" Eh!", german=" Oh!", italian=" Oh!", spanish=" ¡Oh!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Look at that!", french=" Regarde ça!", german=" Sieh dir das an!", italian=" Guarda!", spanish=" ¡Mira!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Look at that!", french=" Regarde ça!", german=" Sieh dir das an!", italian=" Guarda!", spanish=" ¡Mira!"})
  else
  SkySceneKit.say({english=" Look at that!", french=" Regarde ça!", german=" Sieh dir das an!", italian=" Guarda!", spanish=" ¡Mira!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V25P01A) [décor sub chargé: Sub_v25p01a]
  -- camera2_SetPositionMark(Position<'m0', 22.5, 18.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  SkySubScreen.Show("v25p01a", 30, true) -- screen2_FadeIn: BOTH_FOCUS (timeline ROM)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBGM("Time Gear Remix.ogg", true) end)
  GAME:WaitFrames(5)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" It's [CS:P]Temporal Tower[CR]!", french=" C'est la [CS:P]Tour du Temps[CR]!", german=" Das ist der [CS:P]Zeitturm[CR]!", italian=" È la [CS:P]Torre del Tempo[CR]!", spanish=" ¡Es la [CS:P]Torre del Tiempo[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:P]Temporal Tower[CR]!", french=" C'est la [CS:P]Tour du Temps[CR]!", german=" Der [CS:P]Zeitturm[CR]!", italian=" La [CS:P]Torre del Tempo[CR]!", spanish=" ¡Es la [CS:P]Torre del Tiempo[CR]!"})
  else
  SkySceneKit.say({english=" [CS:P]Temporal Tower[CR]!", french=" C'est la [CS:P]Tour du Temps[CR]!", german=" Der [CS:P]Zeitturm[CR]!", italian=" La [CS:P]Torre del Tempo[CR]!", spanish=" ¡Es la [CS:P]Torre del Tiempo[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(45)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Finally...[K] We're on our way...", french=" Enfin...[K] On tient le bon bout...", german="Endlich...[K] Wir sind auf dem\nWeg...", italian="Finalmente...[K] siamo quasi\nalla meta...", spanish="¡Al fin![K]\nYa estamos de camino."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Finally...[K] We're on our way...", french=" Enfin...[K] On tient le bon bout...", german="Endlich...[K] Wir sind auf dem\nWeg...", italian=" Finalmente...[K] ci siamo quasi...", spanish="¡Al fin![K]\nYa estamos de camino."})
  else
  SkySceneKit.say({english=" Finally...[K] We're on our way...", french=" Enfin...[K] On tient le bon bout...", german="Endlich...[K] Wir sind auf dem\nWeg...", italian="Finalmente...[K] ce l'abbiamo\nquasi fatta...", spanish="¡Al fin![K]\nYa estamos de camino."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We're going there...", french=" C'est là-bas que nous allons...", german=" Da fahren wir jetzt hin...", italian=" Siamo sulla buona strada...", spanish=" ¡Allá vamos!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" We're going there...", french=" C'est là-bas que nous allons...", german=" Da fahren wir jetzt hin...", italian=" Siamo sulla buona strada...", spanish=" ¡Allá vamos!"})
  else
  SkySceneKit.say({english=" We're going there...", french=" C'est là-bas que nous allons...", german=" Da fahren wir jetzt hin...", italian=" Siamo sulla buona strada...", spanish=" ¡Allá vamos!"})
  end
  -- message_Close
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false,  30)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
  SkySceneKit.join_routines()
end
