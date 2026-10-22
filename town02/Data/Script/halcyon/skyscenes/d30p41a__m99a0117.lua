-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D30P41A/m99a0117.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D30P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_TEMPORAL_PINNACLE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  local npc_npc_diaruga = SkySceneKit.spawn_npc("dialga", 280, 240, Direction.Down, "NPC_DIARUGA")
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english=" ..................", french=" ..................", german=" ..................", italian=" ..................", spanish=" ..."})
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english="I...[K] I HAVE BEEN DEFEATED...[K]\nGRRR...", french="JE SUIS...[K] JE SUIS VAINCU...[K]\nGRRR...", german="ICH...[K] WURDE BESIEGT...[K]\nGRRR...", italian="IO...[K] SONO STATO\nSCONFITTO...[K] GRRR...", spanish="HE...[K] HE SIDO DERROTADO...[K]\nGRRR..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(60)
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english="[CN][CS:N]Dialga[CR] wants to join the team.", french="[CN][CS:N]Dialga[CR] veut se joindre à l'équipe.", german="[CN][CS:N]Dialga[CR] möchte dem Team beitreten.", italian="[CN][CS:N]Dialga[CR] vuole unirsi alla squadra.", spanish="[CN][CS:N]Dialga[CR] quiere unirse al equipo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- @label_5 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- switch(ProcessSpecial(PROCESS_SPECIAL_PREPARE_MENU_ACCEPT_TEAM_MEMBER, 7, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  do local __sw = ((SV.SkyMenuResults or {})["MENU_ACCEPT_TEAM_MEMBER"] or 0) -- switch(message_Menu(MENU_ACCEPT_TEAM_MEMBER)) [message_Menu(MENU_ACCEPT_TEAM_MEMBER): menu moteur NDS (retour par défaut 0, branches préservées)]
  if __sw == 2 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english="[CN]Are you sure?[K]\n[CN]You're sure you won't accept\n[CN]this potential new member?", french="[CN]Vraiment?[K]\n[CN]Vous ne voulez pas de cette\n[CN]nouvelle recrue potentielle?", german="[CN]Bist du sicher?[K]\n[CN]Bist du sicher, dass du dieses\n[CN]potenzielle neue Mitglied ablehnen willst?", italian="[CN]Davvero?[K]\n[CN]Confermi di non voler accettare\n[CN]questo potenziale nuovo membro?", spanish="[CN]¿Seguro?[K]\n[CN]¿Seguro que prefieres que no\n[CN]se incorpore al equipo?"})
  do local __choice = SkySceneKit.ask({{english="Reconsider", french="Reconsidérer", german="Überdenken", italian="Ripensaci", spanish="Reconsiderar"}, {english="Refuse", french="Refuser", german="Ablehnen", italian="Rifiuta", spanish="Rechazar"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english="[CN][player] turned down\n[CN]the Pokémon's offer to join.", french="[CN][player] a décliné la proposition\n[CN]du Pokémon de se joindre à l'équipe.", german="[CN][player] lehnte das Beitrittsangebot\n[CN]des Pokémon ab.", italian="[CN][player] non accetta il Pokémon\n[CN]nella squadra.", spanish="[CN][player] rechazó la proposición\n[CN]del Pokémon de unirse al equipo."})
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english="[CN][CS:N]Dialga[CR] appears to be\n[CN]a little disappointed...", french="[CN][CS:N]Dialga[CR] a l'air\n[CN]un peu déçu...", german="[CN][CS:N]Dialga[CR] scheint ein\n[CN]wenig enttäuscht zu sein...", italian="[CN]Si legge la delusione nello sguardo di [CS:N]Dialga[CR]...", spanish="[CN][CS:N]Dialga[CR] parece estar\n[CN]un poco decepcionado..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_diaruga, 276, 156, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english="[CN][CS:N]Dialga[CR] sadly went away...", french="[CN][CS:N]Dialga[CR] s'en va, la mort dans l'âme...", german="[CN][CS:N]Dialga[CR] geht traurig davon...", italian="[CN][CS:N]Dialga[CR] si allontana triste...", spanish="[CN][CS:N]Dialga[CR] se ha marchado entristecido..."})
  -- message_Close
  GAME:FadeOut(false, 60)
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:WaitFrames(2) -- join WaitBgm
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- jump @label_5 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif true then -- default
  -- @label_0 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="TO THE VICTOR...[K]GO THE\nSPOILS! I ACCEPT THAT!", french="SOIT...[K] MALHEUR\nAUX VAINCUS!", german="DER SIEGER[K] ERHÄLT ALLES!\nICH AKZEPTIERE DAS!", italian="AL VINCITORE...[K] GLI ONORI!\nACCETTO!", spanish="LOS VENCEDORES...[K] HAN DE\nDISPONER DE LOS VENCIDOS."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I WOULD BE HONORED...[K]\nTO WALK BY YOUR SIDE!", french="JE SERAIS HONORE...[K]\nDE CHEMINER A VOS COTES!", german="ES WÄRE EINE EHRE FÜR\nMICH...[K] AN EURER SEITE ZU SEIN!", italian="SARÒ ONORATO...[K] DI\nCAMMINARE AL VOSTRO FIANCO!", spanish="ME HONRARÍA...[K] SER ACEPTADO\nEN EL EQUIPO."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:StopBGM() end)
  pcall(function() SOUND:PlayFanfare("Fanfare/JoinTeam") end) -- me_Play(5) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][c_name:NPC_NEW_FRIEND] joined the team!", french="[CN][c_name:NPC_NEW_FRIEND] a rejoint l'équipe!", german="[CN][c_name:NPC_NEW_FRIEND] gehört nun zum Team!", italian="[CN][c_name:NPC_NEW_FRIEND] si unisce alla squadra!", spanish="[CN]¡[c_name:NPC_NEW_FRIEND] se unió al equipo!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- message_Close
  GAME:FadeOut(false, 60)
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:WaitFrames(2) -- join WaitBgm
  -- @label_2 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][player] cleared [CS:P]Temporal Tower[CR]\n[CN]in admirable fashion!", french="[CN][player] a brillamment terminé\n[CN]la [CS:P]Tour du Temps[CR]!", german="[CN][player] meisterte den [CS:P]Zeitturm[CR]\n[CN]auf beeindruckende Weise!", italian="[CN][player] ha completato la\n[CN][CS:P]Torre del Tempo[CR] in modo eccellente!", spanish="[CN]¡[player] logró atravesar\n[CN]la [CS:P]Torre del Tiempo[CR]!"})
  -- message_Close
  end
  end
  SkySceneKit.cleanup_npcs()
end
