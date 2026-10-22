-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D17P45A/m99a0112.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_D17P45A) [neutre/état moteur]
  if ((SV.SkyPerformanceProgress or {})[7] == 1) then -- if ROM: $PERFORMANCE_PROGRESS_LIST[7]
  -- @label_0 [étiquette de flux ExplorerScript]
  -- supervision_Acting(2) [neutre/état moteur]
  -- @label_1 [étiquette de flux ExplorerScript]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  local npc_npc_agunomu = SkySceneKit.spawn_npc("azelf", 352, 200, Direction.Down, "NPC_AGUNOMU")
  pcall(function() UI:SetSpeaker(npc_npc_agunomu) end)
  SkySceneKit.say({english=" ..................", french=" ..................", german=" ..................", italian=" ..................", spanish=" ..."})
  pcall(function() UI:SetSpeaker(npc_npc_agunomu) end)
  SkySceneKit.say({english="The day I'd lose like this...[K]\nI think I've been looking forward to it.", french="Il me semble avoir longtemps\nattendu...[K] le jour où je serais vaincu\nde la sorte.", german="Der Tag, an dem ich so verlieren\nwürde...[K] Ich glaube, ich habe ihn herbeigesehnt.", italian="Perdere in questo modo...[K]\nSapevo che un giorno o l'altro questo\nmomento sarebbe venuto.", spanish="Nunca había perdido así...[K]\nCreo que estaba esperando este día."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(60)
  pcall(function() UI:SetSpeaker(npc_npc_agunomu) end)
  SkySceneKit.say({english="[CN][CS:N]Azelf[CR] wants to join the team.", french="[CN][CS:N]Créfadet[CR] veut se joindre à votre équipe.", german="[CN][CS:N]Tobutz[CR] möchte dem Team beitreten.", italian="[CN][CS:N]Azelf[CR] vuole unirsi alla squadra.", spanish="[CN][CS:N]Azelf[CR] quiere unirse al equipo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- @label_7 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- switch(ProcessSpecial(PROCESS_SPECIAL_PREPARE_MENU_ACCEPT_TEAM_MEMBER, 6, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  do local __sw = ((SV.SkyMenuResults or {})["MENU_ACCEPT_TEAM_MEMBER"] or 0) -- switch(message_Menu(MENU_ACCEPT_TEAM_MEMBER)) [message_Menu(MENU_ACCEPT_TEAM_MEMBER): menu moteur NDS (retour par défaut 0, branches préservées)]
  if __sw == 2 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_agunomu) end)
  SkySceneKit.say({english="[CN]Are you sure?[K]\n[CN]You're sure you won't accept\n[CN]this potential new member?", french="[CN]Vraiment?[K]\n[CN]Vous ne voulez pas de cette\n[CN]nouvelle recrue potentielle?", german="[CN]Bist du sicher?[K]\n[CN]Bist du sicher, dass du dieses\n[CN]potenzielle neue Mitglied ablehnen willst?", italian="[CN]Davvero?[K]\n[CN]Confermi di non voler accettare\n[CN]questo potenziale nuovo membro?", spanish="[CN]¿Seguro?[K]\n[CN]¿Seguro que prefieres que no\n[CN]se incorpore al equipo?"})
  do local __choice = SkySceneKit.ask({{english="Reconsider", french="Reconsidérer", german="Überdenken", italian="Ripensaci", spanish="Reconsiderar"}, {english="Refuse", french="Refuser", german="Ablehnen", italian="Rifiuta", spanish="Rechazar"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_agunomu) end)
  SkySceneKit.say({english="[CN][player] turned down\n[CN]the Pokémon's offer to join.", french="[CN][player] a décliné la proposition\n[CN]du Pokémon de se joindre à l'équipe.", german="[CN][player] lehnte das Beitrittsangebot\n[CN]des Pokémon ab.", italian="[CN][player] non accetta il Pokémon\n[CN]nella squadra.", spanish="[CN][player] rechazó la proposición\n[CN]del Pokémon de unirse al equipo."})
  pcall(function() UI:SetSpeaker(npc_npc_agunomu) end)
  SkySceneKit.say({english="[CN][CS:N]Azelf[CR] appears to be\n[CN]a little disappointed...", french="[CN][CS:N]Créfadet[CR] a l'air\n[CN]un peu déçu...", german="[CN][CS:N]Tobutz[CR] scheint ein\n[CN]wenig enttäuscht zu sein...", italian="[CN]Si legge la delusione nello sguardo di [CS:N]Azelf[CR]...", spanish="[CN][CS:N]Azelf[CR] parece estar\n[CN]un poco decepcionado..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_agunomu, 348, 124, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_agunomu) end)
  SkySceneKit.say({english="[CN][CS:N]Azelf[CR] sadly went away...", french="[CN][CS:N]Créfadet[CR] s'en va, la mort dans l'âme...", german="[CN][CS:N]Tobutz[CR] geht traurig davon...", italian="[CN][CS:N]Azelf[CR] si allontana triste...", spanish="[CN][CS:N]Azelf[CR] se ha marchado entristecido..."})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(2) -- join WaitBgm
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- jump @label_7 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif true then -- default
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" I'll go with you!", french=" Je vous accompagne!", german=" Ich gehe mit euch!", italian=" La mia strada sarà questa!", spanish=" ¡Podéis contar conmigo!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" We'll all go together!", french=" Cheminons ensemble!", german=" Wir gehen alle zusammen!", italian=" Proseguiamo insieme!", spanish=" ¡Iremos todos juntos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:StopBGM() end)
  pcall(function() SOUND:PlayFanfare("Fanfare/JoinTeam") end) -- me_Play(5) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][c_name:NPC_NEW_FRIEND] joined the team!", french="[CN][c_name:NPC_NEW_FRIEND] a rejoint l'équipe!", german="[CN][c_name:NPC_NEW_FRIEND] gehört nun zum Team.", italian="[CN][c_name:NPC_NEW_FRIEND] si unisce alla squadra!", spanish="[CN]¡[c_name:NPC_NEW_FRIEND] se unió al equipo!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(2) -- join WaitBgm
  -- @label_4 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][player] cleared [CS:P]Crystal Crossing[CR]\n[CN]in admirable fashion!", french="[CN][player] a brillamment terminé\n[CN]le [CS:P]Croisement Cristal[CR]!", german="[CN][player] meisterte die [CS:P]Kristallstraße[CR]\n[CN]auf beeindruckende Weise!", italian="[CN][player] ha completato il\n[CN][CS:P]Bivio di Cristallo[CR] in modo eccellente!", spanish="[CN]¡[player] logró atravesar\n[CN]la [CS:P]Vía Cristalina[CR]!"})
  -- message_Close
  -- switch(ProcessSpecial(55, 25, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  end
  end
  else
  -- supervision_Acting(1) [neutre/état moteur]
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
