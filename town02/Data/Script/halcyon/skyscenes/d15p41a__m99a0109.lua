-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D15P41A/m99a0109.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_D15P41A) [neutre/état moteur]
  if ((SV.SkyPerformanceProgress or {})[7] == 1) then -- if ROM: $PERFORMANCE_PROGRESS_LIST[7]
  -- @label_0 [étiquette de flux ExplorerScript]
  -- supervision_Acting(2) [neutre/état moteur]
  -- @label_1 [étiquette de flux ExplorerScript]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  local npc_npc_emuritto = SkySceneKit.spawn_npc("mesprit", 304, 160, Direction.Down, "NPC_EMURITTO")
  pcall(function() UI:SetSpeaker(npc_npc_emuritto) end)
  SkySceneKit.say({english=" ...[K]I...I lost.", french=" ...[K] J'ai... j'ai perdu.", german=" ...[K]Ich... Ich habe verloren.", italian=" ...[K] Ho... perso.", spanish=" He...[K] he perdido."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(60)
  pcall(function() UI:SetSpeaker(npc_npc_emuritto) end)
  SkySceneKit.say({english="[CN][CS:N]Mesprit[CR] wants to join the team.", french="[CN][CS:N]Créfollet[CR] veut se joindre à votre équipe.", german="[CN][CS:N]Vesprit[CR] möchte dem Team beitreten.", italian="[CN][CS:N]Mesprit[CR] vuole unirsi alla squadra.", spanish="[CN][CS:N]Mesprit[CR] quiere unirse al equipo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- @label_7 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- switch(ProcessSpecial(PROCESS_SPECIAL_PREPARE_MENU_ACCEPT_TEAM_MEMBER, 5, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  do local __sw = ((SV.SkyMenuResults or {})["MENU_ACCEPT_TEAM_MEMBER"] or 0) -- switch(message_Menu(MENU_ACCEPT_TEAM_MEMBER)) [message_Menu(MENU_ACCEPT_TEAM_MEMBER): menu moteur NDS (retour par défaut 0, branches préservées)]
  if __sw == 2 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_emuritto) end)
  SkySceneKit.say({english="[CN]Are you sure?[K]\n[CN]You're sure you won't accept\n[CN]this potential new member?", french="[CN]Vraiment?[K]\n[CN]Vous ne voulez pas de cette\n[CN]nouvelle recrue potentielle?", german="[CN]Bist du sicher?[K]\n[CN]Bist du sicher, dass du dieses\n[CN]potenzielle neue Mitglied ablehnen willst?", italian="[CN]Davvero?[K]\n[CN]Confermi di non voler accettare\n[CN]questo potenziale nuovo membro?", spanish="[CN]¿Seguro?[K]\n[CN]¿Seguro que prefieres que no\n[CN]se incorpore al equipo?"})
  do local __choice = SkySceneKit.ask({{english="Reconsider", french="Reconsidérer", german="Überdenken", italian="Ripensaci", spanish="Reconsiderar"}, {english="Refuse", french="Refuser", german="Ablehnen", italian="Rifiuta", spanish="Rechazar"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_emuritto) end)
  SkySceneKit.say({english="[CN][player] turned down\n[CN]the Pokémon's offer to join.", french="[CN][player] a décliné la proposition\n[CN]du Pokémon de se joindre à l'équipe.", german="[CN][player] lehnte das Beitrittsangebot\n[CN]des Pokémon ab.", italian="[CN][player] non accetta il Pokémon\n[CN]nella squadra.", spanish="[CN][player] rechazó la proposición\n[CN]del Pokémon de unirse al equipo."})
  pcall(function() UI:SetSpeaker(npc_npc_emuritto) end)
  SkySceneKit.say({english="[CN][CS:N]Mesprit[CR] appears to be\n[CN]a little disappointed...", french="[CN][CS:N]Créfollet[CR] a l'air\n[CN]un peu déçu...", german="[CN][CS:N]Vesprit[CR] scheint ein\n[CN]wenig enttäuscht zu sein...", italian="[CN]Si legge la delusione nello sguardo di [CS:N]Mesprit[CR]...", spanish="[CN][CS:N]Mesprit[CR] parece estar\n[CN]un poco decepcionada..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_emuritto, 300, 84, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_emuritto) end)
  SkySceneKit.say({english="[CN][CS:N]Mesprit[CR] sadly went away...", french="[CN][CS:N]Créfollet[CR] s'en va, la mort dans l'âme...", german="[CN][CS:N]Vesprit[CR] geht traurig davon...", italian="[CN][CS:N]Mesprit[CR] si allontana triste...", spanish="[CN][CS:N]Mesprit[CR] se ha marchado entristecida..."})
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
  SkySceneKit.say({english=" Oh, all right...[K] I'll go too.", french="Oh, c'est d'accord...[K] Je viens\navec vous.", german=" Oh, alles klar...[K] Ich gehe auch.", italian=" Oh, bene...[K] Vengo anch'io.", spanish="Vaya, de acuerdo...[K]\nYo también iré."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" I'll go with you!", french=" Je vous accompagne!", german=" Ich gehe mit dir!", italian=" Sarà questo il mio futuro!", spanish="¡Considérame como una más del\nequipo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:StopBGM() end)
  pcall(function() SOUND:PlayFanfare("Fanfare/JoinTeam") end) -- me_Play(5) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][c_name:NPC_NEW_FRIEND] joined the team!", french="[CN][c_name:NPC_NEW_FRIEND] a rejoint l'équipe!", german="[CN][c_name:NPC_NEW_FRIEND] gehört nun zum Team!", italian="[CN][c_name:NPC_NEW_FRIEND] si unisce alla squadra!", spanish="[CN]¡[c_name:NPC_NEW_FRIEND] se unió al equipo!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(2) -- join WaitBgm
  -- @label_4 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][player] cleared [CS:P]Quicksand Cave[CR]\n[CN]in admirable fashion!", french="[CN][player] a brillamment terminé\n[CN]la [CS:P]Grotte Sables Mouvants[CR]!", german="[CN][player] meisterte die [CS:P]Treibsandhöhle[CR]\n[CN]auf beeindruckende Weise!", italian="[CN][player] ha completato la\n[CN][CS:P]Grotta delle Sabbie Mobili[CR] in modo eccellente!", spanish="[CN]¡[player] logró atravesar\n[CN]la [CS:P]Cueva Arenas[CR]!"})
  -- message_Close
  -- switch(ProcessSpecial(55, 22, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  end
  end
  else
  -- supervision_Acting(1) [neutre/état moteur]
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
