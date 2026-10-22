-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D35P41A/s03p1701.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SkyProg.set(29, 52) -- $SCENARIO_MAIN = scn[29,52] (ROM)
  -- back_SetGround(LEVEL_D35P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_gyaradosu = SkySceneKit.spawn_npc("gyarados", 352, 264, Direction.Down, "NPC_GYARADOSU")
  -- SetAnimation(22) [anim idle native]
  GAME:FadeIn(30)
  pcall(function() GROUND:CharSetEmote(npc_npc_gyaradosu, "shock", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_gyaradosu) end)
  SkySceneKit.say({english=" GRR...rahhhh...", french=" GRR... aaaah...", german=" GRR...rahhhh...", italian=" GRR... rahhhh...", spanish=" AAAH... AAAH..."})
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
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
  -- message_CloseEnforce
  GAME:WaitFrames(15)
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_gyaradosu, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_gyaradosu) end)
  SkySceneKit.say({english="GAH![K] DON'T...![K] DON'T YOU EVER\nFORGET THIS!", french="GAH![K] VOUS...[K] VOUS NE PERDEZ\nRIEN POUR ATTENDRE!", german="GAH![K] VERGESST...[K] VERGESST\nDAS NIEMALS!", italian="GAH![K] NON...![K] NON\nDIMENTICATEVI MAI COSA È SUCCESSO!", spanish="¡GRRR![K] NO...\n¡NO OLVIDARÉ ESTO!"})
  -- message_Close
  do local p=npc_npc_gyaradosu.Position; GROUND:MoveToPosition(npc_npc_gyaradosu, p.X+(200), p.Y+(0), false, 2) end
  GAME:WaitFrames(15)
  GROUND:EntTurn(hero, Direction.Right)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:EntTurn(__slot, Direction.Right) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:EntTurn(__slot, Direction.Right) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then GROUND:EntTurn(__slot, Direction.Right) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(90)
  pcall(function() SOUND:PlayBGM("Mystifying Forest.ogg", true) end)
  local npc_npc_fione1 = SkySceneKit.spawn_npc("phione", 352, 184, Direction.Up, "NPC_FIONE1")
  GROUND:MoveToPosition(npc_npc_fione1, 348, 260, false, 2)
  local npc_npc_fione2 = SkySceneKit.spawn_npc("phione", 264, 176, Direction.Right, "NPC_FIONE2")
  GROUND:MoveToPosition(npc_npc_fione2, 308, 252, false, 2)
  local npc_npc_fione3 = SkySceneKit.spawn_npc("phione", 448, 176, Direction.UpLeft, "NPC_FIONE3")
  GROUND:MoveToPosition(npc_npc_fione3, 388, 252, false, 2)
  local npc_npc_fione4 = SkySceneKit.spawn_npc("phione", 288, 168, Direction.Right, "NPC_FIONE4")
  GROUND:MoveToPosition(npc_npc_fione4, 332, 244, false, 2)
  local npc_npc_fione5 = SkySceneKit.spawn_npc("phione", 424, 168, Direction.Left, "NPC_FIONE5")
  GROUND:MoveToPosition(npc_npc_fione5, 364, 244, false, 2)
  local npc_npc_fione6 = SkySceneKit.spawn_npc("phione", 288, 152, Direction.DownRight, "NPC_FIONE6")
  GROUND:MoveToPosition(npc_npc_fione6, 324, 228, false, 2)
  local npc_npc_fione7 = SkySceneKit.spawn_npc("phione", 352, 144, Direction.Down, "NPC_FIONE7")
  GROUND:MoveToPosition(npc_npc_fione7, 348, 220, false, 2)
  local npc_npc_fione8 = SkySceneKit.spawn_npc("phione", 424, 152, Direction.DownLeft, "NPC_FIONE8")
  GROUND:MoveToPosition(npc_npc_fione8, 372, 228, false, 2)
  GAME:WaitFrames(20)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(5)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:EntTurn(__slot, Direction.Up) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:EntTurn(__slot, Direction.Up) end end
  GAME:WaitFrames(5)
  do local __slot = SkySceneKit.team_member(3); if __slot then GROUND:EntTurn(__slot, Direction.Up) end end
  GROUND:EntTurn(npc_npc_fione1, Direction.Down)
  GROUND:EntTurn(npc_npc_fione2, Direction.Down)
  GROUND:EntTurn(npc_npc_fione3, Direction.Down)
  GROUND:EntTurn(npc_npc_fione4, Direction.Down)
  GROUND:EntTurn(npc_npc_fione5, Direction.Down)
  GROUND:EntTurn(npc_npc_fione6, Direction.Down)
  GROUND:EntTurn(npc_npc_fione7, Direction.Down)
  GROUND:EntTurn(npc_npc_fione8, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_fione1, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_fione4, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_fione7, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_fione8, "happy", 1) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(5)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(5)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(5)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(5)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_fione1) end)
  SkySceneKit.say({english=" Oh! Very good!", french=" Oh! Très bien!", german=" Oh! Sehr gut!", italian=" Oh! Molto bene!", spanish=" ¡Gracias!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_fione1) end)
  SkySceneKit.say({english=" Very good! Very good!", french=" Très bien! Très bien!", german=" Sehr gut! Sehr gut!", italian=" Molto bene! Molto bene!", spanish=" ¡Gracias! ¡Gracias!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_fione1, nil, 0) end) -- EFFECT_NONE
  do local p=npc_npc_fione1.Position; GROUND:MoveToPosition(npc_npc_fione1, p.X+(0), p.Y+(16), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_fione1) end)
  SkySceneKit.say({english=" This is our thank-you! ♪", french=" Voici pour vous remercier! ♪", german=" Das ist unser Dankeschön! ♪", italian="Questo è il nostro\nringraziamento! ♪", spanish="¡Y como muestra de\nagradecimiento...! ♪"})
  GAME:WaitFrames(15)
  -- GAP: se_Play(6410) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitSe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_fione1.Position; GROUND:MoveToPosition(npc_npc_fione1, p.X+(0), p.Y+(-16), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(45)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-16), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(30)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() SOUND:PlayFanfare("Fanfare/Treasure") end) -- me_Play(9) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_fione1) end)
  SkySceneKit.say({english="[CN][player] obtained\n[CN]a Phione Dew!", french="[CN][player] obtient une\n[CN]Rosée Phione!", german="[CN][player] erhält\n[CN]Phione-Tau!", italian="[CN][player] ottiene\n[CN]la Brina Phione!", spanish="[CN]¡[player] ha obtenido\n[CN]un Rocío Phione!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- message_Close
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(30)
  -- switch(message_Menu(MENU_DUNGEON_TEAM_RETURNS_FROM_MAP)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  SkySceneKit.cleanup_npcs()
end
