-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D41P41A/mus01.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_nyorotono = SkySceneKit.spawn_npc("politoed", 360, 240, Direction.Down, "NPC_NYOROTONO")
  pcall(function() UI:SetSpeaker(npc_npc_nyorotono) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_nyorotono) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  do local __choice = SkySceneKit.ask({{english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"}, {english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"}, {english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  pcall(function() UI:SetSpeaker(npc_npc_nyorotono) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- @label_4 [étiquette de flux ExplorerScript]
  GAME:FadeOut(false, 255) -- screen_FlushOut
  GAME:WaitFrames(100)
  GAME:FadeIn(0) -- screen_FlushIn
  -- message_CloseEnforce
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 3 then
  pcall(function() UI:SetSpeaker(npc_npc_nyorotono) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- @label_5 [étiquette de flux ExplorerScript]
  GROUND:EntTurn(npc_npc_nyorotono, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  -- SetAnimation(3) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- MoveHeight(2, 10) [élévation d'objet NDS non simulée - documenté]
  GAME:WaitFrames(1)
  -- MoveHeight(2, 0) [élévation d'objet NDS non simulée - documenté]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(3) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- MoveHeight(2, 10) [élévation d'objet NDS non simulée - documenté]
  GAME:WaitFrames(1)
  -- MoveHeight(2, 0) [élévation d'objet NDS non simulée - documenté]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- @label_0 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(npc_npc_nyorotono) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- @label_3 [étiquette de flux ExplorerScript]
  GROUND:EntTurn(npc_npc_nyorotono, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_nyorotono, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_nyorotono, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_nyorotono, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_nyorotono, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_nyorotono, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_nyorotono, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_nyorotono, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_nyorotono, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_nyorotono, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_nyorotono, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_nyorotono, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_nyorotono, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_nyorotono, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_nyorotono, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_nyorotono, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_nyorotono, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_nyorotono, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_nyorotono, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_nyorotono, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_nyorotono, Direction.Down)
  -- @label_6 [étiquette de flux ExplorerScript]
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_nyorotono, hero, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_nyorotono) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- message_Close
  -- @label_7 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  end
  end
  SkySceneKit.cleanup_npcs()
end
