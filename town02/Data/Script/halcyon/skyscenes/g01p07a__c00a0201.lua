-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P07A/c00a0201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  if (SkyProg.cmp(4, 0) == 0) then -- if ROM: scn($SCENARIO_MAIN) == [4, 0]
  -- @label_0 [étiquette de flux ExplorerScript]
  -- back_SetBanner2(LEVEL_S21P01A, 0, 128, 96, 3, ) [bannière 2e écran NDS: information dupliquée du menu, hors canvas unique - documenté]
  GAME:FadeIn(45)
  GAME:WaitFrames(160)
  GAME:FadeOut(false, 45)
  GAME:WaitFrames(15)
  -- @label_4 [étiquette de flux ExplorerScript]
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[1] = 1 -- $SCENARIO_MAIN_BIT_FLAG[1] = 1 (ROM)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]The next morning...", french="[CN]Le lendemain matin...", german="[CN]Der nächste Morgen...", italian="[CN]La mattina dopo...", spanish="[CN]A la mañana siguiente..."})
  -- message_Close
  GAME:WaitFrames(30)
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 112, 184, Direction.Right, "NPC_DOGOOMU")
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" UP AND AT 'EM![K] IT'S MORNING!", french="DEBOUT! ET QUE ÇA SAUTE![K]\nC'EST L'HEURE! HOP HOP HOP!", german="AUFGESTANDEN UND AB DAFÜR![K]\nES IST MORGEN!", italian=" SVEGLIA![K] È MATTINA!", spanish="¡ARRIBA, GANDULES![K]\n¡YA ES DE DÍA!"})
  -- message_Close
  -- back_SetGround(LEVEL_G01P07A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
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
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Ugh! Good morning,\n[hero]...", french="Arf... Bonjour,\n[hero]...", german="Umpf! Guten Morgen,\n[hero]...", italian=" Uh! Buongiorno, [hero]...", spanish=" ¡Aah! Buenos días, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Ugh! Good morning,\n[hero]...", french="Arf... Bonjour,\n[hero]...", german="Umpf! Guten Morgen,\n[hero]...", italian=" Uh! Buongiorno, [hero]...", spanish=" ¡Uf! Buenos días, [hero]."})
  else
  SkySceneKit.say({english="Ugh! Good morning,\n[hero]...", french="Arf... Bonjour,\n[hero]...", german="Umpf! Guten Morgen,\n[hero]...", italian=" Uh! Buongiorno, [hero]...", spanish=" ¡Huy! Buenos días, [hero]."})
  end
  -- message_Close
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
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
  -- main_SetGround(LEVEL_G01P07A) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[7] = 1 -- $SCENARIO_MAIN_BIT_FLAG[7] = 1 (ROM)
  -- CallCommon CORO_HANYOU_SAVE_FUNC (fermeture/attente message: géré par say())
  -- CallCommon CORO_EVENT_END_MAPIN (fermeture/attente message: géré par say())
  -- supervision_ExecuteStationCommon(LEVEL_G01P07A, 1) [exécution de station sans cible littérale: harnais journey]
  elseif (SkyProg.cmp(5, 0) == 0) then -- elseif ROM: scn($SCENARIO_MAIN) == [5, 0]
  -- back_SetBanner2(LEVEL_V04P02A, 0, 156, 136, 4,) [bannière 2e écran NDS: information dupliquée du menu, hors canvas unique - documenté]
  GAME:FadeIn(45)
  GAME:WaitFrames(160)
  GAME:FadeOut(false, 45)
  GAME:WaitFrames(15)
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(6, 0) == 0) then -- elseif ROM: scn($SCENARIO_MAIN) == [6, 0]
  -- back_SetBanner2(LEVEL_D04P11A, 0, 252, 180, 5,) [bannière 2e écran NDS: information dupliquée du menu, hors canvas unique - documenté]
  GAME:FadeIn(45)
  GAME:WaitFrames(160)
  GAME:FadeOut(false, 45)
  GAME:WaitFrames(15)
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(7, 0) == 0) then -- elseif ROM: scn($SCENARIO_MAIN) == [7, 0]
  -- back_SetBanner2(LEVEL_D05P31A, 0, 276, 128, 6,) [bannière 2e écran NDS: information dupliquée du menu, hors canvas unique - documenté]
  GAME:FadeIn(45)
  GAME:WaitFrames(160)
  GAME:FadeOut(false, 45)
  GAME:WaitFrames(15)
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
