-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P28P01A/n06a3905.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_P28P01A) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(3) [anim idle native]
  -- SetOutputAttribute(1024) [neutre/état moteur]
  -- SetAnimation(3) [anim idle native]
  -- bgm2_PlayFadeIn(BGM_CAVE_AMBIANCE) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  GAME:FadeIn(30)
  local npc_npc_metamon = SkySceneKit.spawn_npc("ditto", 160, 352, Direction.Down, "NPC_METAMON")
  GROUND:MoveToPosition(npc_npc_metamon, 156, 160, false, 2)
  GAME:WaitFrames(8)
  GROUND:MoveToPosition(hero, 156, 180, false, 2)
  GAME:WaitFrames(6)
  local npc_npc_chaaremu = SkySceneKit.spawn_npc("medicham", 160, 400, Direction.Down, "NPC_CHAAREMU")
  GROUND:MoveToPosition(npc_npc_chaaremu, 156, 220, false, 2)
  GAME:WaitFrames(4)
  local npc_npc_saanaito = SkySceneKit.spawn_npc("gardevoir", 160, 416, Direction.Down, "NPC_SAANAITO")
  GROUND:MoveToPosition(npc_npc_saanaito, 156, 220, false, 2)
  GAME:WaitFrames(60)
  local npc_npc_manyuura = SkySceneKit.spawn_npc("weavile", 160, 384, Direction.Down, "NPC_MANYUURA")
  GROUND:MoveToPosition(npc_npc_manyuura, 156, 204, false, 2)
  GAME:WaitFrames(9)
  local npc_npc_aabokku = SkySceneKit.spawn_npc("arbok", 160, 400, Direction.Down, "NPC_AABOKKU")
  GROUND:MoveToPosition(npc_npc_aabokku, 156, 228, false, 2)
  GAME:WaitFrames(8)
  local npc_npc_dorapion = SkySceneKit.spawn_npc("drapion", 160, 416, Direction.Down, "NPC_DORAPION")
  GROUND:MoveToPosition(npc_npc_dorapion, 156, 228, false, 2)
  GAME:WaitFrames(15)
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 160, 424, Direction.Down, "NPC_PUKURIN")
  GROUND:MoveToPosition(npc_npc_pukurin, 156, 224, false, 2)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chaaremu, npc_npc_metamon, 4) end)
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_saanaito, npc_npc_metamon, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_aabokku, npc_npc_metamon, 4) end)
  GROUND:EntTurn(npc_npc_metamon, Direction.Down)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dorapion, npc_npc_metamon, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_metamon) end)
  SkySceneKit.say({english=" We've arrived.", french=" Nous y voilà.", german=" Da sind wir auch schon.", italian=" Siamo arrivati.", spanish=" Ya hemos llegado."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(156, 196, 60, false) end) -- performer/caméra
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_dorapion, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, "exclaim", 1) end)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharSetEmote(npc_npc_manyuura, "shock", 1) end)
  GAME:WaitFrames(6)
  pcall(function() GROUND:CharSetEmote(npc_npc_aabokku, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() SOUND:PlayBGM("Time Gear Remix.ogg", true) end)
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english=" Huh?!", french=" Hein?!", german=" Huch!", italian=" Uh?!", spanish=" ¡¿Eh?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dorapion) end)
  SkySceneKit.say({english=" Waaah!", french=" Ouaaah!", german=" Waaah!", italian=" Uaaah!", spanish=" ¡Ooooh!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_aabokku) end)
  SkySceneKit.say({english="Wh-what'ssssss...[K]thisssssss?\nWhat'sss thisssss light?!", french="Sssette...[K] lumière!\nD'où vient-elle?", german="W-wasss issst dassss?[K]\nDiesssesss Licht?!?", italian="C-Cossssss'è...[K] quessssssta?\nChe cosss'è quessssssta luce?!", spanish="¿Qué...[K] esss esssto?\n¡¿Qué esss esssa luz?!"})
  -- message_Close
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
end
