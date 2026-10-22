-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/S01P02A/return.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- debug_Print('RETURN_S01P02A') [neutre/état moteur]
  -- back_SetGround(LEVEL_S01P02A) [neutre/état moteur]
  -- switch(message_Menu(MENU_DUNGEON_EXPLORATION_RESULTS)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- switch(message_Menu(MENU_DUNGEON_TEAM_RETURNS_FROM_MAP)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- GAP: BGM BGM_PELIPPER_ISLAND non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- bgm2_PlayFadeIn(BGM_OCEAN1) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_GET_S_O_S_MISSION_RETRIES_LEFT"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_GET_S_O_S_MISSION_R) [ProcessSpecial(PROCESS_SPECIAL_GET_S_O_S_MISSION_RETRIES_LEFT): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 0 then
  -- @label_0 [étiquette de flux ExplorerScript]
  local npc_npc_perippaa1 = SkySceneKit.spawn_npc("pelipper", 240, 120, Direction.Down, "NPC_PERIPPAA1")
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english=" Oh! Welcome back!", french=" Oh! Vous revoilà!", german=" Oh! Willkommen zurück!", italian="Oh! Son contento di vederti\ntornare!", spanish=" ¡Hola de nuevo!"})
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="Now, how about that rescue you\nattempted?[K] Oh, you've abandoned that attempt?", french="Alors cette tentative de\nsauvetage?[K] Ah bon, vous avez abandonné?", german="Nun, wie sieht es mit dem\nRettungsversuch aus, den du unternommen\nhast?[K] Oh, du hast ihn abgebrochen?", italian="Ehi, com'è andato il tentativo\ndi soccorso?[K] Oh, hai rinunciato?", spanish="¿Qué pasó con el intento de\nrescate?[K] ¿Abandonasteis?"})
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="And now you're out of chances\nto go on this rescue mission.", french="Mais maintenant, vous ne pouvez\nplus revenir sur cette mission de sauvetage.", german="Und jetzt hast du keine Versuche\nmehr übrig, um dich auf diese Rettungsmission\nzu begeben.", italian="Ora non c'è più verso di\nportare a termine questa missione di soccorso.", spanish="Vaya, pues ya no os quedan más\noportunidades para superar esta misión."})
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="I'm sorry to say it, but please\ninform your friend that you failed the rescue.", french="Quel dommage! Veuillez informer\nvotre ami que la mission de sauvetage s'est\nsoldée par un échec.", german="Ich bin traurig, das zu sagen,\naber bitte informiere deinen Freund, dass du\nbei der Rettung erfolglos geblieben bist.", italian="Mi dispiace, ma ti prego di\ninformare il tuo amico che il tuo tentativo\ndi soccorso è fallito.", spanish="Siento decirlo, pero tendréis que\ninformar a vuestro amigo de que no habéis\nlogrado rescatarlo."})
  -- message_Close
  -- @label_1 [étiquette de flux ExplorerScript]
  SkySceneKit.unlock(3) -- Unlock(3) NDS
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- supervision_ExecuteStationCommon(LEVEL_S01P02A, 1) [exécution de station sans cible littérale: harnais journey]
  GAME:WaitFrames(1) -- hold
  elseif true then -- default
  pcall(function() UI:SetSpeaker("Pelipper", true, "pelipper", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_PERIPPAA2 (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Oh! Welcome back!", french=" Oh! Vous revoilà!", german=" Oh! Willkommen zurück!", italian=" Oh! Che bello rivederti!", spanish=" ¡Hola de nuevo!"})
  pcall(function() UI:SetSpeaker("Pelipper", true, "pelipper", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_PERIPPAA2 (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Now, how about that rescue you\nattempted?[K] Oh, you've abandoned that attempt?", french="Alors cette tentative de\nsauvetage?[K] Ah bon, vous avez abandonné?", german="Nun, wie sieht es mit dem\nRettungsversuch aus, den du unternommen\nhast?[K] Oh, du hast ihn abgebrochen?", italian="Ehi, com'è andato il tentativo\ndi soccorso?[K] Oh, hai rinunciato?", spanish="¿Qué pasó con el intento de\nrescate?[K] ¿Abandonasteis?"})
  pcall(function() UI:SetSpeaker("Pelipper", true, "pelipper", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_PERIPPAA2 (espèce ROM, sans placement zone)
  SkySceneKit.say({english="But you're not out of chances\nyet! There's no need to give up!", french="Mais vous n'avez pas encore\nutilisé toutes vos chances! Rien ne vous oblige\nà laisser tomber!", german="Aber du hast noch weitere\nVersuche übrig! Kein Grund aufzugeben!", italian="Ma non è ancora detta l'ultima\nparola! Non mollare proprio adesso!", spanish="¡Aún tenéis oportunidades!\n¡No os rindáis!"})
  -- message_Close
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  SkySceneKit.cleanup_npcs()
end
