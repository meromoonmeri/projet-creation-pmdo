-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P17P01A/n02a0201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Heartwarming.ogg", true) end)
  SV.SkyScenarioSide = {main=41, sub=2} -- $SCENARIO_SIDE = scn[41,2] (ROM)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V24P08A) [décor sub chargé: Sub_v24p08a]
  -- back_SetGround(LEVEL_P17P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 19, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  SkySubScreen.Show("v24p08a", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- supervision_Acting(1) [neutre/état moteur]
  -- GAP: se_Play(9729) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_P17P01A1_397) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_P17P01A1_397) [routine d'objet NDS non simulée - documenté]
  GAME:WaitFrames(20)
  -- supervision_Acting(2) [neutre/état moteur]
  -- SetAnimation(2) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(8), false, 1) end
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  local npc_npc_upaa = SkySceneKit.spawn_npc("wooper", 136, 160, Direction.UpRight, "NPC_UPAA")
  pcall(function() GROUND:CharSetEmote(npc_npc_upaa, "exclaim", 1) end)
  GAME:WaitFrames(4)
  local npc_npc_muchuuru = SkySceneKit.spawn_npc("smoochum", 160, 168, Direction.Up, "NPC_MUCHUURU")
  pcall(function() GROUND:CharSetEmote(npc_npc_muchuuru, "exclaim", 1) end)
  GAME:WaitFrames(4)
  local npc_npc_subomii = SkySceneKit.spawn_npc("budew", 184, 160, Direction.UpLeft, "NPC_SUBOMII")
  pcall(function() GROUND:CharSetEmote(npc_npc_subomii, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_upaa, "happy", 1) end)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharSetEmote(npc_npc_muchuuru, "happy", 1) end)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharSetEmote(npc_npc_subomii, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_upaa) end)
  SkySceneKit.say({english=" Oh! [CS:Y]Igglybuff[CR]!", french=" Oh! [CS:Y]Toudoudou[CR]!", german=" Oh! [CS:Y]Fluffeluff[CR]!", italian=" Oh! [CS:Y]Igglybuff[CR]!", spanish=" ¡Hola, [CS:Y]Igglybuff[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(npc_npc_upaa, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_muchuuru, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_subomii, nil, 0) end) -- EFFECT_NONE
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Hi, everyone! ♪", french=" Coucou, copains de moi! ♪", german=" Hallo, alle miteinander! ♪", italian=" Ciao a tutti! ♪", spanish=" ¡Hola a todos! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_muchuuru) end)
  SkySceneKit.say({english=" Yay! ♪ Let's go! Let's go! ♪", french=" Youpi! ♪ On y va! On y va! ♪", german="Juchhu! ♪\nLos geht's! Los geht's! ♪", italian="Evviva! ♪ Andiamo!\nAndiamo! ♪", spanish=" ¡Yupi! ♪ ¡Vamos, vamos! ♪"})
  -- message_Close
  GROUND:MoveToPosition(hero, 156, 148, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharSetEmote(npc_npc_upaa, "happy", 1) end)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharSetEmote(npc_npc_subomii, "happy", 1) end)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharSetEmote(npc_npc_muchuuru, "happy", 1) end)
  GROUND:MoveToPosition(hero, 404, 148, false, 2)
  GROUND:MoveToPosition(npc_npc_upaa, 380, 160, false, 2)
  GROUND:MoveToPosition(npc_npc_subomii, 428, 160, false, 2)
  GROUND:MoveToPosition(npc_npc_muchuuru, 404, 168, false, 2)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
