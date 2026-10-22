-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P17P02A/n02a0401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Heartwarming.ogg", true) end)
  -- supervision_Acting(0) [neutre/état moteur]
  local npc_npc_pukurin_papa = SkySceneKit.spawn_npc("wigglytuff", 288, 184, Direction.DownLeft, "NPC_PUKURIN_PAPA")
  -- SetAnimation(2) [anim idle native]
  local npc_npc_pukurin_mama = SkySceneKit.spawn_npc("wigglytuff", 256, 208, Direction.UpRight, "NPC_PUKURIN_MAMA")
  -- SetAnimation(2) [anim idle native]
  GROUND:MoveToPosition(hero, 252, 284, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" OK, I'm off! ♪", french=" Bon, je sors! ♪", german=" Okay, ich gehe dann mal! ♪", italian=" Bene, io vado! ♪", spanish=" ¡Bueno, hasta luego! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  -- SetPositionLives(6) [cible objet/id de décor NDS non simulée - trace]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() GAME:MoveCamera(252, 284, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() GAME:MoveCamera(252, 224, 60, false) end) -- performer/caméra
  GAME:WaitFrames(15)
  GROUND:EntTurn(npc_npc_pukurin_papa, Direction.Down)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_pukurin_mama, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin_papa, "happy", 1) end)
  -- message_FacePositionOffset(-1, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_papa) end)
  SkySceneKit.say({english=" See you later!", french=" A plus tard!", german=" Bis später!", italian=" A più tardi!", spanish=" ¡Pásatelo bien!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin_papa, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin_mama, "happy", 1) end)
  -- message_FacePositionOffset(3, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_mama) end)
  SkySceneKit.say({english=" Take care!", french=" Fais attention!", german=" Pass auf dich auf!", italian=" Abbi cura di te!", spanish=" ¡Ve con cuidado!"})
  -- message_Close
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(48), false, 2) end
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin_mama, nil, 0) end) -- EFFECT_NONE
  if (SkyProg.cmp_side(41, 3) == 0) then -- if ROM: scn($SCENARIO_SIDE) == [41, 3]
  -- @label_0 [étiquette de flux ExplorerScript]
  pcall(function() SOUND:FadeOutBGM(60) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(30)
  -- @label_3 [étiquette de flux ExplorerScript]
  elseif (SkyProg.cmp_side(42, 0) == 0) then -- elseif ROM: scn($SCENARIO_SIDE) == [42, 0]
  GAME:FadeOut(false, 30)
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- @label_2 [étiquette de flux ExplorerScript]
  pcall(function() SOUND:FadeOutBGM(30) end)
  GAME:FadeOut(false, 30)
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
