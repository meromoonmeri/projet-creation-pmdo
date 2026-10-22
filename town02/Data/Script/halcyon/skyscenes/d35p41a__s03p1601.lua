-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D35P41A/s03p1601.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(53, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  -- back_SetGround(LEVEL_D35P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Rising Fear.ogg", true) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  local npc_npc_fione4 = SkySceneKit.spawn_npc("phione", 336, 272, Direction.Right, "NPC_FIONE4")
  pcall(function() GROUND:CharSetEmote(npc_npc_fione4, "sweating", 1) end)
  GAME:WaitFrames(15)
  local npc_npc_fione8 = SkySceneKit.spawn_npc("phione", 376, 256, Direction.DownLeft, "NPC_FIONE8")
  pcall(function() GROUND:CharSetEmote(npc_npc_fione8, "sweating", 1) end)
  GROUND:MoveToPosition(hero, 348, 356, false, 2)
  GAME:WaitFrames(5)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 372, 376, false, 2) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 324, 372, false, 2) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then GROUND:MoveToPosition(__slot, 348, 388, false, 2) end end
  GAME:WaitFrames(15)
  local npc_npc_fione3 = SkySceneKit.spawn_npc("phione", 392, 280, Direction.UpLeft, "NPC_FIONE3")
  pcall(function() GROUND:CharSetEmote(npc_npc_fione3, "sweating", 1) end)
  GAME:WaitFrames(15)
  local npc_npc_fione6 = SkySceneKit.spawn_npc("phione", 328, 256, Direction.DownRight, "NPC_FIONE6")
  pcall(function() GROUND:CharSetEmote(npc_npc_fione6, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  local npc_npc_fione1 = SkySceneKit.spawn_npc("phione", 352, 288, Direction.Up, "NPC_FIONE1")
  GROUND:EntTurn(npc_npc_fione1, Direction.Down)
  local npc_npc_fione2 = SkySceneKit.spawn_npc("phione", 312, 280, Direction.Right, "NPC_FIONE2")
  GROUND:EntTurn(npc_npc_fione2, Direction.Down)
  GROUND:EntTurn(npc_npc_fione3, Direction.Down)
  GROUND:EntTurn(npc_npc_fione4, Direction.Down)
  local npc_npc_fione5 = SkySceneKit.spawn_npc("phione", 368, 272, Direction.Left, "NPC_FIONE5")
  GROUND:EntTurn(npc_npc_fione5, Direction.Down)
  GROUND:EntTurn(npc_npc_fione6, Direction.Down)
  local npc_npc_fione7 = SkySceneKit.spawn_npc("phione", 352, 248, Direction.Down, "NPC_FIONE7")
  GROUND:EntTurn(npc_npc_fione7, Direction.Down)
  GROUND:EntTurn(npc_npc_fione8, Direction.Down)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  local npc_npc_gyaradosu = SkySceneKit.spawn_npc("gyarados", 352, 336, Direction.Up, "NPC_GYARADOSU")
  pcall(function() GROUND:CharSetEmote(npc_npc_gyaradosu, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(24), 24, false) end) -- MovePositionOffset performer/caméra
  GROUND:EntTurn(npc_npc_gyaradosu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_gyaradosu) end)
  SkySceneKit.say({english=" OH?[K] WHAT, BACK AGAIN?", french=" OH?[K] VOUS ETES DE RETOUR?", german=" OH?[K] WIE, SCHON ZURÜCK?", italian=" OH?[K] DI NUOVO QUI?", spanish=" ¿EH?[K] ¿OTRA VEZ?"})
  pcall(function() UI:SetSpeaker(npc_npc_gyaradosu) end)
  SkySceneKit.say({english=" NO MERCY FOR MEDDLERS!", french="AINSI, VOUS VOULEZ ENCORE\nME DEFIER EN FACE-A-FACE!", german="DAS EINMISCHEN WIRD\nUNBARMHERZIG BESTRAFT!", italian="NESSUNA PIETÀ PER CHI SI\nINTROMETTE!", spanish=" ¡SIN PIEDAD!"})
  -- message_KeyWait
  pcall(function() SOUND:StopBGM() end)
  -- GAP: se_Play(6930) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  -- SetAnimation(18) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_gyaradosu) end)
  SkySceneKit.say({english=" GRRAAAAHH!", french=" GRRAAAAHH!", german=" GRRAAAAHH!", italian=" GRRAAAAHH!", spanish=" ¡AAAH!"})
  do local p=npc_npc_fione1.Position; GROUND:MoveToPosition(npc_npc_fione1, p.X+(0), p.Y+(-64), false, 2) end -- Move2PositionOffset
  do local p=npc_npc_fione2.Position; GROUND:MoveToPosition(npc_npc_fione2, p.X+(-64), p.Y+(-40), false, 2) end -- Move2PositionOffset
  do local p=npc_npc_fione3.Position; GROUND:MoveToPosition(npc_npc_fione3, p.X+(64), p.Y+(-40), false, 2) end -- Move2PositionOffset
  do local p=npc_npc_fione4.Position; GROUND:MoveToPosition(npc_npc_fione4, p.X+(-64), p.Y+(-40), false, 2) end -- Move2PositionOffset
  do local p=npc_npc_fione5.Position; GROUND:MoveToPosition(npc_npc_fione5, p.X+(64), p.Y+(-40), false, 2) end -- Move2PositionOffset
  do local p=npc_npc_fione6.Position; GROUND:MoveToPosition(npc_npc_fione6, p.X+(-64), p.Y+(-40), false, 2) end -- Move2PositionOffset
  do local p=npc_npc_fione7.Position; GROUND:MoveToPosition(npc_npc_fione7, p.X+(0), p.Y+(-64), false, 2) end -- Move2PositionOffset
  do local p=npc_npc_fione8.Position; GROUND:MoveToPosition(npc_npc_fione8, p.X+(64), p.Y+(-40), false, 2) end -- Move2PositionOffset
  GAME:WaitFrames(2) -- join WaitSe
  -- message_CloseEnforce
  -- camera_SetEffect(0): arrêt d'effet caméra
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitSe
  -- GAP: se_Play(5136) — id SE NDS sans portage PMDO identifié
  -- CallCommon CORO_BOSS_WIPE_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.cleanup_npcs()
end
