-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D17P32A/m15b0903.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Time Gear Remix.ogg", true) end)
  -- back_SetGround(LEVEL_D17P32A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() SOUND:FadeOutBGM(180) end)
  GAME:FadeIn(30)
  GROUND:MoveToPosition(partner, 184, 204, false, 2)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey! What's going on?!", french=" Eh! Qu'est-ce qui se passe?!", german=" Hey! Was ist da los?!?", italian=" Ehi! Cosa sta succedendo?", spanish=" ¡Oye! ¡¿Qué está pasando?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey! What's happening there?!", french=" Eh! Qu'est-ce qui se passe?!", german=" Hey! Was passiert denn da?!?", italian=" Ehi! Cosa sta succedendo?", spanish=" ¡Oye! ¡¿Qué está pasando?!"})
  else
  SkySceneKit.say({english=" Oh! What's happening there?!", french=" Eh! Qu'est-ce qui se passe?!", german=" Oh! Was passiert denn da?!?", italian=" Ehi! Cosa sta succedendo?", spanish=" ¡Oye! ¡¿Qué está pasando?!"})
  end
  -- message_Close
  GROUND:MoveToPosition(hero, 224, 204, false, 2)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 204, 248, false, 2) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 240, 236, false, 2) end end
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:EntTurn(__slot, Direction.Up) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:EntTurn(__slot, Direction.Up) end end
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(That's...)", french="(C'est...)", german="(Das ist...)", italian="(Quello è...)", spanish="(Ese es...)"})
  else
  SkySceneKit.say({english="(That's...)", french="(C'est...)", german="(Das ist...)", italian="(Quello è...)", spanish="(Ese es...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(That's [CS:N]Grovyle[CR]!)", french="([CS:N]Massko[CR]!)", german="(Das ist [CS:N]Reptain[CR]!)", italian="(... [CS:N]Grovyle[CR]!)", spanish="(¡Es [CS:N]Grovyle[CR]!)"})
  else
  SkySceneKit.say({english="(That's [CS:N]Grovyle[CR]!)", french="([CS:N]Massko[CR]!)", german="(Das ist [CS:N]Reptain[CR]!)", italian="(... [CS:N]Grovyle[CR]!)", spanish="(¡Es [CS:N]Grovyle[CR]!)"})
  end
  -- message_Close
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(-180), 60, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(15)
  GAME:FadeOut(false, 15)
end
