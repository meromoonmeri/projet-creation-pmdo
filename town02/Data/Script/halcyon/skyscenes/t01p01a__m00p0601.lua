-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/m00p0601.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[12] = 1 -- $SCENARIO_MAIN_BIT_FLAG[12] = 1 (ROM)
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[13] = 1 -- $SCENARIO_MAIN_BIT_FLAG[13] = 1 (ROM)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() SOUND:FadeOutBGM(10) end)
  -- bgm2_PlayFadeIn(BGM_EARTHQUAKE3) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(60)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What was that? That tremor...", french="Qu'est-ce que c'était que ça?\nCette secousse...", german=" Was war das? Dieses Beben...", italian=" Cos'è stato? Quella scossa...", spanish=" ¿Y ese temblor?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What was that? That tremor...", french="Qu'est-ce que c'était que ça?\nCette secousse...", german=" Was war das? Dieses Beben...", italian=" Cos'è stato? Quella scossa...", spanish=" ¿Qué ha sido eso? Ese temblor..."})
  else
  SkySceneKit.say({english=" What was that? That tremor...", french="Qu'est-ce que c'était que ça?\nCette secousse...", german=" Was war das? Dieses Beben...", italian=" Cos'è stato? Quella scossa...", spanish=" ¡He notado un temblor!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It sounded like...[K]it came from\ninside the dojo?", french="On dirait que...[K] ça vient\nde l'intérieur du dojo!", german="Das klang wie...[K] Kam es aus dem\nDojo?", italian="Dal suono sembrava...[K]\nprovenire dall'interno del dojo?", spanish="Sonaba como...[K] ¡como si\nviniera del interior del dojo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It sounded as if...[K]it came from\ninside the dojo.", french="On dirait que...[K] ça vient\nde l'intérieur du dojo!", german="Das klang wie...[K] Kam es aus dem\nDojo?", italian="Dal suono sembrava...[K]\nprovenire dall'interno del dojo.", spanish="Sonaba como si...[K] ¡como si\nviniera del interior del dojo!"})
  else
  SkySceneKit.say({english="Did it...[K]sound like it came from\ninside the dojo?", french="On dirait que...[K] ça vient\nde l'intérieur du dojo!", german="Das klang wie...[K] Kam es aus dem\nDojo?", italian="Veniva forse...[K] dall'interno\ndel dojo?", spanish="Sonaba...[K] ¡como si\nviniera del interior del dojo!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's go in and check it out,\n[hero]!", french="Allons voir ce que c'est,\n[hero]!", german="Gehen wir rein und finden es\nheraus, [hero]!", italian="Entriamo a dare un'occhiata,\n[hero]!", spanish="¡Vamos a entrar a ver qué\nhay dentro, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's go in, [hero]!", french="Allons voir ce que c'est,\n[hero]!", german="Lass uns hineingehen,\n[hero]!", italian=" Entriamo, [hero]!", spanish=" ¡Entremos, [hero]!"})
  else
  SkySceneKit.say({english=" Let's go in, [hero]!", french="Allons voir ce que c'est,\n[hero]!", german="Lass uns hineingehen,\n[hero]!", italian=" Entriamo, [hero]!", spanish=" ¡Vamos adentro, [hero]!"})
  end
  -- message_Close
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  GAME:FadeOut(false,  30)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
end
