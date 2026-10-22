-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D01P11A/enter11.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  SkySceneKit.turn_to_pos(hero, 268, 164) -- Turn2DirectionMark
  SkySceneKit.turn_to_pos(partner, 268, 164) -- Turn2DirectionMark
  -- switch(ProcessSpecial(PROCESS_SPECIAL_INIT_RANDOM_NPC_JOBS, 1, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(ProcessSpecial(PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_STILL_AVAILABLE, 0, ) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]There's a Bottle here.", french="[CN]Vous trouvez une Bouteille par terre.", german="[CN]Hier ist eine Flasche.", italian="[CN]C'è una bottiglia qui.", spanish="[CN]Ahí hay un frasco."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Huh?[K] It looks like there's something inside.\n[CN]Would you like to try and take it out?", french="[CN]Hein?[K] Il y a quelque chose à l'intérieur...\n[CN]Voulez-vous sortir l'objet de la Bouteille?", german="[CN]Äh?[K] Sieht so aus, als sei etwas darin!\n[CN]Möchtest du versuchen, es herauszuholen?", italian="[CN]Uh?[K] Sembra che ci sia qualcosa dentro.\n[CN]Vuoi provare ad aprirla?", spanish="[CN]¿Eh?[K] Parece contener algo.\n[CN]¿Quieres intentar sacarlo?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(1, 1) ROM
  if __choice == 1 then
  -- @label_0 [étiquette de flux ExplorerScript]
  -- message_Close
  -- back2_SetMode(7) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_TYPE"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_) [ProcessSpecial(PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_TYPE): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 12 then
  -- @label_2 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]There was a Treasure Memo inside!\n[CN]Would you like to add it to your Job List?", french="[CN]La Bouteille contient un Mémo Trésor!\n[CN]L'ajouter à votre Liste de Missions?", german="[CN]Eine Schatznotiz befand sich darin!\n[CN]Möchtest du sie zu der Jobliste hinzufügen?", italian="[CN]Dentro c'è un Memo tesoro!\n[CN]Vuoi aggiungerlo alla tua lista delle missioni?", spanish="[CN]¡Es una nota del tesoro!\n[CN]¿Quieres añadirla a la lista de misiones?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- @label_1 [étiquette de flux ExplorerScript]
  -- message_Close
  -- back2_SetMode(-1) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  GAME:WaitFrames(20)
  -- jump @label_7 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- @label_3 [étiquette de flux ExplorerScript]
  -- message_Close
  -- back2_SetMode(-1) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  GAME:WaitFrames(20)
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_ACCEPT_RANDOM_NPC_JOB"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_ACCEPT_RANDOM_NPC_J) [ProcessSpecial(PROCESS_SPECIAL_ACCEPT_RANDOM_NPC_JOB): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 1 then
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_TYPE"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_) [ProcessSpecial(PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_TYPE): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 12 then
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[92] = 0 -- $SCENARIO_MAIN_BIT_FLAG[92] = 0 (ROM)
  -- supervision_RemoveCommon(5) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]The Treasure Memo was added\n[CN]to your Job List.", french="[CN]Le Mémo Trésor a été ajouté\n[CN]à votre Liste de Missions.", german="[CN]Die Schatznotiz wurde der\n[CN]Jobliste hinzugefügt.", italian="[CN]Il Memo tesoro è stato aggiunto\n[CN]alla tua lista delle missioni.", spanish="[CN]Se ha añadido la nota del tesoro\n[CN]a la lista de misiones."})
  -- message_Close
  -- @label_7 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif true then -- default
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[92] = 0 -- $SCENARIO_MAIN_BIT_FLAG[92] = 0 (ROM)
  -- supervision_RemoveCommon(5) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]The job was added\n[CN]to your Job List.", french="[CN]La mission a été ajoutée\n[CN]à votre Liste de Missions.", german="[CN]Der Job wurde der\n[CN]Jobliste hinzugefügt.", italian="[CN]La missione è stata aggiunta\n[CN]alla tua lista delle missioni.", spanish="[CN]Se ha añadido la misión\n[CN]a la lista de misiones."})
  -- message_Close
  -- jump @label_7 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif true then -- default
  -- @label_5 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Your Job List is full,\n[CN]so you cannot add to it.", french="[CN]Vous ne pouvez pas l'ajouter car\n[CN]votre Liste de Missions est déjà pleine.", german="[CN]Die Jobliste ist voll, daher kannst\n[CN]du diesen Job nicht hinzufügen.", italian="[CN]La tua lista delle missioni è piena,\n[CN]quindi non puoi aggiungerne altre.", spanish="[CN]La lista de misiones está llena,\n[CN]así que no se ha podido añadir."})
  -- message_Close
  -- jump @label_7 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  elseif true then -- default
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]There was a Job Letter inside!\n[CN]Add it to your Job List?", french="[CN]La Bouteille contient une Lettre Mission!\n[CN]Ajouter la mission à votre Liste de Missions?", german="[CN]Ein Job-Brief befand sich darin!\n[CN]Möchtest du ihn zu der Jobliste hinzufügen?", italian="[CN]Dentro c'è una Lettera missione!\n[CN]Vuoi aggiungerla alla tua lista delle missioni?", spanish="[CN]¡Es una carta de misión!\n[CN]¿Quieres añadirla a la lista de misiones?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 1 then
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 2 then
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  elseif __choice == 2 then
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
end
