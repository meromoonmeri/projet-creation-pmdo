-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D01P11A/enter01.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  do local __sw = ((SV.SkyVars or {}).EXECUTE_SPECIAL_EPISODE_TYPE or 0) -- switch($EXECUTE_SPECIAL_EPISODE_TYPE) [GameVar EXECUTE_SPECIAL_EPISODE_TYPE: épisode spécial actif]
  if __sw == 0 or __sw == 1 or __sw == 2 or __sw == 4 or __sw == 3 then
  -- @label_0 [étiquette de flux ExplorerScript]
  do local __sw = ((SV.SkyVars or {}).GROUND_ENTER or -1) -- switch($GROUND_ENTER) [GameVar GROUND_ENTER: point d'entrée du ground]
  if __sw == 224 then
  -- @label_3 [étiquette de flux ExplorerScript]
  -- main_EnterGround(LEVEL_P01P02A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif true then -- default
  -- debug_Print('BGM_FADEOUT') [neutre/état moteur]
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif true then -- default
  if (SkyProg.cmp(29, 1) == 0) then -- if ROM: scn($SCENARIO_MAIN) == [29, 1]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We have to get equipped for\nexploration first, [hero].", french="On doit d'abord faire nos\npréparatifs pour l'expédition, [hero].", german="Wir müssen uns erst für die\nErkundung ausstatten, [hero].", italian="Prima dobbiamo prepararci\nper l'esplorazione, [hero].", spanish="Tenemos que equiparnos bien\nantes de ir a explorar, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We have to get ready for\nexploration first, [hero].", french="On doit d'abord faire nos\npréparatifs pour l'expédition, [hero].", german="Wir müssen uns erst auf die\nErkundung vorbereiten, [hero].", italian="Prima dobbiamo prepararci\nper l'esplorazione, [hero].", spanish="Mejor nos equipamos bien\nantes de ir a explorar, [hero]."})
  else
  SkySceneKit.say({english="We have to get ready for\nexploration first, [hero].", french="On doit d'abord faire nos\npréparatifs pour l'expédition, [hero].", german="Wir müssen uns erst auf die\nErkundung vorbereiten, [hero].", italian="Prima dobbiamo prepararci\nper l'esplorazione, [hero].", spanish="Será mejor que nos equipemos\nbien antes de ir a explorar, [hero]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We have to go by Treasure\nTown.", french=" Passons par Bourg-Trésor.", german="Wir müssen in Schatzstadt\nvorbeigehen.", italian=" Dobbiamo andare a Borgo Tesoro.", spanish="Tenemos que pasarnos por\nAldea Tesoro."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We have to go by Treasure\nTown.", french=" Passons par Bourg-Trésor.", german="Wir müssen in Schatzstadt\nvorbeigehen.", italian=" Dobbiamo andare a Borgo Tesoro.", spanish="Tenemos que pasarnos por\nAldea Tesoro."})
  else
  SkySceneKit.say({english="We have to go by Treasure\nTown.", french=" Passons par Bourg-Trésor.", german="Wir müssen in Schatzstadt\nvorbeigehen.", italian=" Dobbiamo andare a Borgo Tesoro.", spanish="Tenemos que pasarnos por\nAldea Tesoro."})
  end
  -- @label_4 [étiquette de flux ExplorerScript]
  -- message_Close
  -- supervision_Suspend(-2) [neutre/état moteur]
  elseif (SkyProg.cmp(4, 5) < 0) or ((SV.SkyScenarioBitFlags or {})[96] == 1) then -- elseif ROM: scn($SCENARIO_MAIN) < [4, 5] || $SCENARIO_MAIN_BIT_FLAG[96]
  -- jump @label_0 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[96] = 1 -- $SCENARIO_MAIN_BIT_FLAG[96] = 1 (ROM)
  -- @label_2 [étiquette de flux ExplorerScript]
  GAME:FadeOut(false,  30)
  -- screen2_FadeOut [sub déjà caché]
  GAME:WaitFrames(2) -- join WaitScreenFade
  GAME:WaitFrames(2) -- join WaitScreenFadeAll
  GAME:FadeOut(false, 0)
  GAME:FadeIn(0)
  -- supervision_ExecuteCommon(CORO_EVENT_M00_12) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(1) -- hold
  end
  end
  end
end
