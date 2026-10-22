-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/S01P02A/conquest.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[40] = 0 -- $SCENARIO_MAIN_BIT_FLAG[40] = 0 (ROM)
  -- debug_Print('CONQUEST_S01P02A') [neutre/état moteur]
  -- back_SetGround(LEVEL_S01P02A) [neutre/état moteur]
  -- switch(message_Menu(MENU_DUNGEON_EXPLORATION_RESULTS)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- switch(message_Menu(MENU_DUNGEON_TEAM_RETURNS_FROM_MAP)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- GAP: BGM BGM_PELIPPER_ISLAND non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- bgm2_PlayFadeIn(BGM_OCEAN1) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- switch(message_Menu(36)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker("Pelipper", true, "pelipper", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_PERIPPAA2 (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Oh, yes.[K] Don't forget to send an\n[CS:E]A-OK Mail[CR] to the friend you rescued!", french="Ah, oui![K] N'oubliez pas d'envoyer\nune [CS:E]Lettre O.K.[CR] à la personne que vous avez\nsecourue!", german="Oh ja.[K] Vergiss nicht, dem von\ndir befreiten Freund einen [CS:E]Okay-Brief[CR]\nzu senden!", italian="Oh, sì.[K] Non dimenticarti di\ninviare l'[CS:E]E-mail di OK[CR] a chi hai soccorso.", spanish="Ah, por cierto...[K] No os olvidéis\nde enviar una [CS:E]carta de misión cumplida[CR] al\namigo que hayas rescatado."})
  pcall(function() UI:SetSpeaker("Pelipper", true, "pelipper", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_PERIPPAA2 (espèce ROM, sans placement zone)
  SkySceneKit.say({english="You can send your [CS:E]A-OK Mail[CR]\nfrom within Friend Rescue on the Top Menu.", french="Vous pouvez envoyer votre\n[CS:E]Lettre O.K.[CR] en sélectionnant Sauvetage Ami\nà partir du menu principal.", german="Du kannst deinen [CS:E]Okay-Brief[CR]\nüber FREUNDRETTUNG im Hauptmenü senden.", italian="Puoi inviare l'[CS:E]E-mail di OK[CR]\nscegliendo Pronto Intervento nel menu\nprincipale.", spanish="Se puede enviar desde el menú\nque aparece al seleccionar la opción Rescate\nde amigos en el menú principal."})
  -- message_Close
  SkySceneKit.unlock(3) -- Unlock(3) NDS
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- supervision_ExecuteStationCommon(LEVEL_S01P02A, 1) [exécution de station sans cible littérale: harnais journey]
  GAME:WaitFrames(1) -- hold
end
