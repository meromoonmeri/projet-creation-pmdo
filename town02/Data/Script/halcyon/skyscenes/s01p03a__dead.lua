-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/S01P03A/dead.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- debug_Print('DEAD_S01P03A') [neutre/état moteur]
  -- back_SetGround(LEVEL_S01P03A) [neutre/état moteur]
  do local __sw = ((SV.SkyVars or {}).GROUND_START_MODE or 0) -- switch($GROUND_START_MODE) [GameVar GROUND_START_MODE]
  if __sw == 10 then
  -- @label_0 [étiquette de flux ExplorerScript]
  -- switch(message_Menu(MENU_DUNGEON_TEAM_RETURNS_FROM_MAP)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- GAP: BGM BGM_PELIPPER_ISLAND non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- bgm2_PlayFadeIn(BGM_OCEAN1) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  local npc_npc_perippaa1 = SkySceneKit.spawn_npc("pelipper", 240, 120, Direction.Down, "NPC_PERIPPAA1")
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english=" Oh! Welcome back!", french=" Oh! Vous revoilà!", german=" Oh! Willkommen zurück!", italian=" Oh! Che bello rivederti!", spanish=" ¡Hola de nuevo!"})
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english=" ...[K]Ouch! You got wiped out?!", french="...[K] Aïe aïe aïe!\nÇa s'est mal passé pour vous?!", german="...[K]Oh! Ist es nicht gut\ngelaufen?!?", italian="...[K] Ohiohi! Non avete completato\nla vostra esplorazione?", spanish="¡Vaya![K] ¿Un reto demasiado\ngrande?"})
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="Please let me know if you would\nlike to go on another exploration.", french="N'hésitez pas à m'appeler\nsi vous souhaitez repartir en exploration.", german="Bitte lass es mich wissen, wenn\ndu auf eine weitere Erkundung gehen möchtest.", italian="Ehi, fammi sapere quando vuoi\navventurarti in un'altra esplorazione!", spanish="Avisadme cuando queráis ir a\nexplorar."})
  -- message_Close
  SkySceneKit.unlock(3) -- Unlock(3) NDS
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- supervision_ExecuteStationCommon(LEVEL_S01P03A, 1) [exécution de station sans cible littérale: harnais journey]
  GAME:WaitFrames(1) -- hold
  elseif true then -- default
  -- switch(message_Menu(MENU_DUNGEON_EXPLORATION_RESULTS)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- jump @label_0 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  SkySceneKit.cleanup_npcs()
end
