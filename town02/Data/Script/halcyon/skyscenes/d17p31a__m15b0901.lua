-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D17P31A/m15b0901.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(26, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  -- back_SetGround(LEVEL_D17P31A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(45)
  GROUND:MoveToPosition(partner, 216, 196, false, 2)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(hero, 240, 220, false, 2)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 268, 196, false, 2) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 288, 220, false, 2) end end
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  GROUND:EntTurn(partner, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey!", french=" Eh!", german=" Hey!", italian=" Ehi!", spanish=" ¡Oye!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey!", french=" Eh!", german=" Hey!", italian=" Ehi!", spanish=" ¡Oye!"})
  else
  SkySceneKit.say({english=" Oh!", french=" Eh!", german=" Oh!", italian=" Oh!", spanish=" ¡Hala!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Left)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(-40), g.ViewCenter.Y+(0), 40, false) end) -- MovePositionOffset performer/caméra
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-64), p.Y+(0), false, 2) end
  GAME:WaitFrames(20)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-48), p.Y+(0), false, 2) end
  GAME:WaitFrames(10)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 188, 196, false, 2) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 204, 220, false, 2) end end
  pcall(function() GAME:MoveCamera(144, 172, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(partner, 120, 164, false, 2)
  GROUND:MoveToPosition(hero, 160, 188, false, 2)
  GROUND:EntTurn(partner, Direction.UpLeft)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:EntTurn(__slot, Direction.UpLeft) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:EntTurn(__slot, Direction.UpLeft) end end
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Look, [hero]!\nIt's the lake!", french="Regarde, [hero]! Voilà\nle lac!", german="Sieh mal, [hero]! Da ist\nder See!", italian=" Guarda, [hero]! Il lago!", spanish="¡Mira, [hero]!\n¡Es el lago!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Look, [hero]!\nIt's the lake!", french="Regarde, [hero]! Voilà\nle lac!", german="Sieh mal, [hero]! Da ist\nder See!", italian=" Guarda, [hero]! Il lago!", spanish="¡Mira, [hero]!\n¡Es el lago!"})
  else
  SkySceneKit.say({english="Look, [hero]!\nIt's the lake!", french="Regarde, [hero]! Voilà\nle lac!", german="Sieh mal, [hero]! Da ist\nder See!", italian=" Guarda, [hero]! Il lago!", spanish="¡Mira, [hero]!\n¡Es el lago!"})
  end
  -- message_Close
  GAME:FadeOut(false, 30)
end
