-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D51P41A/n09a0901.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D51P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- message_FacePositionOffset(0, -3) [neutre/état moteur]
  local npc_npc_onigoori = SkySceneKit.spawn_npc("glalie", 184, 192, Direction.Down, "NPC_ONIGOORI")
  pcall(function() UI:SetSpeaker(npc_npc_onigoori) end)
  SkySceneKit.say({english=" GOGIGI...", french=" GOGNIGNI...", german=" GOGIGI...", italian=" GOGIGI...", spanish=" GOGUIGUÍ..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_manmuu = SkySceneKit.spawn_npc("mamoswine", 256, 200, Direction.Down, "NPC_MANMUU")
  pcall(function() UI:SetSpeaker(npc_npc_manmuu) end)
  SkySceneKit.say({english=" BUAOOOOOOO...", french=" ROAAAAA...", german=" BUAOOOOOOO...", italian=" BUAOOOOOOO...", spanish=" BUAOOOOOOO..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_manmuu, "sweating", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_onigoori, "sweating", 1) end)
  GAME:WaitFrames(2)
  local npc_npc_onigoori3 = SkySceneKit.spawn_npc("glalie", 288, 168, Direction.Down, "NPC_ONIGOORI3")
  pcall(function() GROUND:CharSetEmote(npc_npc_onigoori3, "sweating", 1) end)
  GAME:WaitFrames(7)
  local npc_npc_onigoori2 = SkySceneKit.spawn_npc("glalie", 224, 168, Direction.Down, "NPC_ONIGOORI2")
  pcall(function() GROUND:CharSetEmote(npc_npc_onigoori2, "sweating", 1) end)
  GAME:WaitFrames(4)
  local npc_npc_onigoori4 = SkySceneKit.spawn_npc("glalie", 328, 192, Direction.Down, "NPC_ONIGOORI4")
  pcall(function() GROUND:CharSetEmote(npc_npc_onigoori4, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(8963) — id SE NDS sans portage PMDO identifié
  GROUND:EntTurn(npc_npc_manmuu, Direction.UpLeft)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_onigoori, Direction.Right)
  GAME:WaitFrames(2)
  GROUND:EntTurn(npc_npc_onigoori2, Direction.DownRight)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_onigoori3, Direction.Right)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_onigoori4, Direction.UpLeft)
  GAME:WaitFrames(20)
  GROUND:EntTurn(npc_npc_manmuu, Direction.UpRight)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_onigoori, Direction.UpRight)
  GAME:WaitFrames(2)
  GROUND:EntTurn(npc_npc_onigoori2, Direction.DownLeft)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_onigoori3, Direction.DownLeft)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_onigoori4, Direction.Left)
  GAME:WaitFrames(45)
  pcall(function() GROUND:CharSetEmote(npc_npc_manmuu, "sweating", 1) end)
  -- GAP: se_Play(7430) — id SE NDS sans portage PMDO identifié
  GROUND:MoveToPosition(npc_npc_manmuu, 120, 196, false, 2)
  pcall(function() UI:SetSpeaker(npc_npc_manmuu) end)
  SkySceneKit.say({english=" BUAAAAAAAAAAAA!", french=" RHAAAAAA!", german=" BUAAAAAAAAAAAA!", italian=" BUAAAAAAAAAAAA!", spanish=" ¡BUAAO!"})
  GROUND:EntTurn(npc_npc_onigoori, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_onigoori2, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_onigoori3, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_onigoori4, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(npc_npc_manmuu, 40, 228, false, 2) -- Slide2PositionMark (glissement)
  -- message_CloseEnforce
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_onigoori, Direction.Down)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_onigoori2, Direction.Down)
  GAME:WaitFrames(3)
  GROUND:EntTurn(npc_npc_onigoori3, Direction.Down)
  GAME:WaitFrames(2)
  GROUND:EntTurn(npc_npc_onigoori4, Direction.Down)
  GAME:WaitFrames(30)
  -- GAP: se_Play(7430) — id SE NDS sans portage PMDO identifié
  GROUND:MoveToPosition(npc_npc_onigoori, 120, 196, false, 2)
  GROUND:MoveToPosition(npc_npc_onigoori4, 400, 196, false, 2)
  pcall(function() UI:SetSpeaker(npc_npc_onigoori) end)
  SkySceneKit.say({english=" GOGIIII!!", french=" GOGNIIII!!", german=" GOGIIII!!!", italian=" GOGIIII!!", spanish=" ¡¡GOGUÍ!!"})
  GAME:WaitFrames(15)
  GROUND:MoveToPosition(npc_npc_onigoori2, 120, 196, false, 2)
  GROUND:MoveToPosition(npc_npc_onigoori3, 400, 196, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(npc_npc_onigoori, 40, 228, false, 2) -- Slide2PositionMark (glissement)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(npc_npc_onigoori4, 472, 228, false, 2) -- Slide2PositionMark (glissement)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(npc_npc_onigoori2, 40, 228, false, 2) -- Slide2PositionMark (glissement)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(npc_npc_onigoori3, 472, 228, false, 2) -- Slide2PositionMark (glissement)
  -- message_CloseEnforce
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(45)
  GROUND:MoveToPosition(hero, 228, 200, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Looks like we've driven\nthem away.", french=" Bon débarras.", german="Sieht aus, als ob wir sie\nvertreiben konnten.", italian="A quanto pare, siamo riusciti\na liberarcene!", spanish=" Parece que los hemos espantado."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5121) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  local npc_npc_yonowaaru_n9 = SkySceneKit.spawn_npc("dusknoir", 272, 240, Direction.Up, "NPC_YONOWAARU_N9")
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru_n9, "shock", 1) end)
  -- SetAnimation(25) [anim idle native]
  GROUND:EntTurn(npc_npc_yonowaaru_n9, Direction.Down)
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Gah!", french=" Argh!", german=" Gah!", italian=" Gah!", spanish=" ¡Ay!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_yonowaaru_n9, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Oof...[K] I think I was injured\nby that chunk of ice...", french="Ouille...[K] J'ai été touché par\nce bloc de glace.", german="Uff...[K] Ich glaube, ich wurde von\ndem Eisbrocken verletzt...", italian="Oooh...[K] Temo che quel pezzo\ndi ghiaccio mi abbia ferito più gravemente\ndi quel che pensassi...", spanish="Ay...[K] Creo que aquel trozo de hielo\nme ha herido..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" [CS:N]Dusknoir[CR]...", french=" [CS:N]Noctunoir[CR]...", german=" [CS:N]Zwirrfinst[CR]...", italian=" [CS:N]Dusknoir[CR]...", spanish=" [CS:N]Dusknoir[CR]..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="...[K]I think it would be smart\nif we hid for now.", french="...[K] Nous ferions mieux de nous\ncacher pour l'instant.", german="...[K]Ich glaube, es wäre schlau,\nwenn wir uns erst mal verstecken würden.", italian="...[K] Forse è meglio se\nci nascondiamo per un po'.", spanish="Creo que...[K] será mejor que nos\nescondamos por ahora."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(45)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_yonowaaru_n9, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="There's a crack in that ridge\nover there.[K] Let's go.", french="Il y a une faille dans cette paroi.\n[K]Profitons-en.", german="Da ist ein Spalt in dem\nKamm.[K] Rein dort.", italian="C'è una fessura in quella parete\nrocciosa laggiù.[K] Andiamo.", spanish="Hay una grieta en aquella\ncolina.[K] Vamos allá."})
  -- message_Close
  GAME:FadeOut(false, 90)
  GAME:WaitFrames(60)
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[8] = 1 -- $SCENARIO_MAIN_BIT_FLAG[8] = 1 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.COMPULSORY_SAVE_POINT_SIDE = 1 -- $COMPULSORY_SAVE_POINT_SIDE = 1 (ROM)
  -- CallCommon CORO_HANYOU_SAVE_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.cleanup_npcs()
end
