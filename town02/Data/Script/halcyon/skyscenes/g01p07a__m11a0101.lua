-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P07A/m11a0101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.PERFORMANCE_PROGRESS_LIST = SV.SkyVars.PERFORMANCE_PROGRESS_LIST or {}; SV.SkyVars.PERFORMANCE_PROGRESS_LIST[30] = 1 -- $PERFORMANCE_PROGRESS_LIST[30] = 1 (ROM)
  -- back_SetBanner2(LEVEL_V02P02A, 0, 156, 140, 10) [bannière 2e écran NDS: information dupliquée du menu, hors canvas unique - documenté]
  GAME:FadeIn(45)
  GAME:WaitFrames(160)
  GAME:FadeOut(false, 45)
  GAME:WaitFrames(15)
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[1] = 1 -- $SCENARIO_MAIN_BIT_FLAG[1] = 1 (ROM)
  GAME:WaitFrames(30)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]The next morning...", french="[CN]Le lendemain matin...", german="[CN]Am nächsten Morgen...", italian="[CN]La mattina dopo...", spanish="[CN]A la mañana siguiente..."})
  -- message_Close
  GAME:WaitFrames(30)
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 112, 184, Direction.Right, "NPC_DOGOOMU")
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" UP AND AT 'EM![K] IT'S MORNING!", french="DEBOUT![K] C'EST L'HEURE!\nHOP HOP HOP!", german="RAUS AUS DEN BETTEN![K] ES IST\nMORGEN!", italian=" SVEGLIA![K] È MATTINA!", spanish="¡ARRIBA GANDULES![K]\n¡YA ES DE DÍA!"})
  -- message_Close
  -- back_SetGround(LEVEL_G01P07A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(76) [anim idle native]
  -- SetAnimation(76) [anim idle native]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '3', '0')
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(10)
  do local p=npc_npc_dogoomu.Position; GROUND:MoveToPosition(npc_npc_dogoomu, p.X+(-96), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ugh...", french=" Argh...", german=" Ugh...", italian=" Ugh...", spanish=" Ay..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ugh...", french=" Argh...", german=" Ugh...", italian=" Ugh...", spanish=" Ay..."})
  else
  SkySceneKit.say({english=" Ugh...", french=" Argh...", german=" Ugh...", italian=" Ugh...", spanish=" Ay..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Been a while since we've been\nwoken up like that...", french="Ça faisait un moment qu'on\nn'avait pas eu un tel réveil...", german="So wurden wir schon lange nicht\nmehr geweckt...", italian="Era un po' che non ci svegliavano\ncosì...", spanish="Hacía tiempo que no me\ndespertaban de esa forma..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It's been a while since we were\nwoken up like that...", french="Ça faisait un moment qu'on\nn'avait pas eu un tel réveil...", german="So wurden wir schon lange nicht\nmehr geweckt...", italian="È passato un po' di tempo\ndall'ultima volta che ci hanno svegliato così...", spanish="Hacía tiempo que no me\ndespertaban de esa forma..."})
  else
  SkySceneKit.say({english="It's been a while since we were\nwoken up like that...", french="Ça faisait un moment qu'on\nn'avait pas eu un tel réveil...", german="So wurden wir schon lange nicht\nmehr geweckt...", italian="È passato un po' di tempo\ndall'ultima volta che ci hanno svegliato così...", spanish="Hacía tiempo que no me\ndespertaban de esa forma..."})
  end
  -- message_Close
  GAME:WaitFrames(30)
  -- SetAnimation(63) [anim idle native]
  -- SetAnimation(63) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(10)
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(hero, Direction.Down)
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(partner, Direction.Down)
  GAME:WaitFrames(30)
  SkySceneKit.cleanup_npcs()
end
