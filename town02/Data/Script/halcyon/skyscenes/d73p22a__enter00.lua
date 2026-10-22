-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P22A/enter00.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- debug_Print('START') [neutre/état moteur]
  do local __sw = 1 -- switch(sector()) [sector(): acting principal (kit PMDO)]
  if __sw == 1 then
  -- @label_0 [étiquette de flux ExplorerScript]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  SkySceneKit.play_scene("d73p22a__us3100", "d73p22a__us31", hero, partner) -- supervision_ExecuteStationSub(LEVEL_D73P22A, 'US31', 0) [chaînage scène ROM]
  -- @label_1 [étiquette de flux ExplorerScript]
  -- supervision_StationCommon(7) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- debug_Print('LABEL_TEAM_SET') [neutre/état moteur]
  -- supervision_StationCommon(9) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- @label_2 [étiquette de flux ExplorerScript]
  do local __sw = 1 -- switch(sector()) [sector(): acting principal (kit PMDO)]
  if __sw == 1 then
  -- @label_3 [étiquette de flux ExplorerScript]
  -- debug_Print('LABEL_END') [neutre/état moteur]
  -- JumpCommon(CORO_COMMON_ENTER) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif true then -- default
  -- debug_Print('LABEL_PLAYER_SET') [neutre/état moteur]
  if ((SV.SkyScenarioBitFlags or {})[4] == 1) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[4]
  -- debug_Print('LABEL_REBIRTH') [neutre/état moteur]
  -- supervision_StationCommon(6) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- @label_6 [étiquette de flux ExplorerScript]
  -- debug_Print('SET_BGM') [neutre/état moteur]
  pcall(function() SOUND:PlayBGM("Sky Peak Cave.ogg", true) end)
  -- debug_Print('LABEL_ENTER_END') [neutre/état moteur]
  if ((SV.SkyScenarioBitFlags or {})[4] == 1) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[4]
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[4] = 0 -- $SCENARIO_MAIN_BIT_FLAG[4] = 0 (ROM)
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif ((SV.SkyScenarioBitFlags or {})[46] == 1) then -- elseif ROM: $SCENARIO_MAIN_BIT_FLAG[46]
  GAME:FadeIn(30)
  GAME:FadeIn(30)
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[46] = 0 -- $SCENARIO_MAIN_BIT_FLAG[46] = 0 (ROM)
  local npc_npc_fuwaraido = SkySceneKit.spawn_npc("drifblim", 144, 232, Direction.Down, "NPC_FUWARAIDO")
  pcall(function() UI:SetSpeaker(npc_npc_fuwaraido) end)
  SkySceneKit.say({english="[CS:P]Sky Peak[CR] 2nd Station Clearing.\n2nd Station Clearing.", french="[CS:P]Pic Céleste[CR], trouée du 2[F:E] Relais,\ntrouée du 2[F:E] Relais!", german="Nächster Halt [CS:P]Himmelsgipfel[CR]\n2. Zwischenlagerlichtung.\n2. Zwischenlagerlichtung.", italian="Bivacco 2 [CS:P]Picco del Cielo[CR]!\nBivacco 2!", spanish="Base del Segundo Puerto de la\n[CS:P]Cumbre del Cielo[CR].\nHemos llegado a la Base del Segundo Puerto."})
  pcall(function() UI:SetSpeaker(npc_npc_fuwaraido) end)
  SkySceneKit.say({english=" Thank you for your patronage.", french="Merci d'avoir utilisé\nnos services.", german="Es ist mir immer ein Vergnügen,\ndich als Kunden begrüßen zu dürfen.", italian=" Grazie per averci scelto.", spanish=" Esperamos verte pronto, gracias."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- JumpCommon(CORO_COMMON_ENTER) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  end
  else
  -- @label_5 [étiquette de flux ExplorerScript]
  -- debug_Print('LABEL_PLAYER_SET_RESUME') [neutre/état moteur]
  if ((SV.SkyScenarioBitFlags or {})[7] == 1) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[7]
  -- debug_Print('LABEL_RESUME') [neutre/état moteur]
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[7] = 0 -- $SCENARIO_MAIN_BIT_FLAG[7] = 0 (ROM)
  -- supervision_StationCommon(4) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif ((SV.SkyScenarioBitFlags or {})[46] == 1) then -- elseif ROM: $SCENARIO_MAIN_BIT_FLAG[46]
  -- supervision_StationCommon(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- @label_9 [étiquette de flux ExplorerScript]
  -- debug_Print('LABEL_PLAYER_SET_NORMAL') [neutre/état moteur]
  -- supervision_StationCommon(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  elseif true then -- default
  GAME:FadeOut(false,  0)
  -- debug_Print('LABEL_BACK_SET') [neutre/état moteur]
  -- back_SetGround(LEVEL_D73P22A) [neutre/état moteur]
  -- supervision_StationCommon(10) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_0 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  SkySceneKit.cleanup_npcs()
end
