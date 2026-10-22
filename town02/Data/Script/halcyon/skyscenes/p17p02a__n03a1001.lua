-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P17P02A/n03a1001.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  GAME:WaitFrames(90)
  SV.SkyScenarioSide = {main=42, sub=6} -- $SCENARIO_SIDE = scn[42,6] (ROM)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Just then...", french="[CN]Au même moment...", german="[CN]In diesem Augenblick...", italian="[CN]In quel momento...", spanish="[CN]Justo en ese momento..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]At [CS:Y]Igglybuff[CR]'s house on the prairie...", french="[CN]A la maison de [CS:Y]Toudoudou[CR] dans la prairie...", german="[CN]Im Haus von [CS:Y]Fluffeluff[CR] auf der Ebene...", italian="[CN]A casa di [CS:Y]Igglybuff[CR]...", spanish="[CN]En la casita de [CS:Y]Igglybuff[CR], en la pradera..."})
  -- message_Close
  -- back_SetGround(LEVEL_P17P02A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_pukurin_mama = SkySceneKit.spawn_npc("wigglytuff", 256, 208, Direction.UpRight, "NPC_PUKURIN_MAMA")
  -- SetAnimation(2) [anim idle native]
  local npc_npc_pukurin_papa = SkySceneKit.spawn_npc("wigglytuff", 288, 184, Direction.DownLeft, "NPC_PUKURIN_PAPA")
  -- SetAnimation(5) [anim idle native]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Heartwarming.ogg", true) end)
  GAME:WaitFrames(10)
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  -- SetAnimation(5) [anim idle native]
  GAME:WaitFrames(35)
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin_mama, "happy", 1) end)
  GAME:WaitFrames(8)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin_papa, "happy", 1) end)
  GAME:WaitFrames(60)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin_mama, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin_papa, nil, 0) end) -- EFFECT_NONE
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" [CS:Y]Igglybuff[CR]! ♪[K] Let's play! ♪", french=" [CS:Y]Toudoudou[CR]! ♪[K] Tu viens jouer? ♪", german="[CS:Y]Fluffeluff[CR]! ♪[K]\nLass uns gemeinsam spielen! ♪", italian=" [CS:Y]Igglybuff[CR]! ♪[K] Vieni a giocare! ♪", spanish=" ¡[CS:Y]Igglybuff[CR]! ♪[K] ¡Vamos a jugar! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin_papa, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin_mama, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_pukurin_papa, Direction.Down)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_pukurin_mama, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_mama) end)
  SkySceneKit.say({english=" Oh![K] It's [CS:N]Smoochum[CR] and everyone.", french=" Oh![K] Voilà [CS:N]Lippouti[CR] et les autres.", german="Oh![K]\nDa sind [CS:N]Kussilla[CR] und die anderen!", italian=" Oh![K] Sono [CS:N]Smoochum[CR] e gli altri.", spanish=" ¡Anda![K] Si son [CS:N]Smoochum[CR] y los demás."})
  -- message_Close
  GROUND:EntTurn(npc_npc_pukurin_papa, Direction.DownLeft)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_pukurin_mama, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  GROUND:MoveToPosition(npc_npc_pukurin_mama, 256, 296, false, 2)
  GAME:WaitFrames(4)
  GROUND:MoveToPosition(npc_npc_pukurin_papa, 256, 180, false, 2)
  GROUND:MoveToPosition(npc_npc_pukurin_papa, 256, 280, false, 2)
  GAME:WaitFrames(20)
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
end
