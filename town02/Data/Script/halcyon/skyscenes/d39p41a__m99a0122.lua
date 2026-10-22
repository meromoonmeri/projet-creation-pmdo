-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D39P41A/m99a0122.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_D39P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  local npc_npc_parukia = SkySceneKit.spawn_npc("palkia", 376, 296, Direction.Down, "NPC_PARUKIA")
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english="...[K]I...[K]I HAVE BEEN DEFEATED...[K]\nGRRR-OOOOOO!", french="...[K] JE...[K] JE SUIS VAINCU...[K]\nGRRR-OOOOOO!", german="...[K]ICH...[K] ICH WURDE\nBESIEGT...[K] GRRR-OOOOOO!", italian="...[K] IO...[K] IO SONO STATO\nSCONFITTO...[K] GRRR-OOOOOO!", spanish="HE...[K] HE...[K] HE SIDO DERROTADO...[K]\n¡GRRRRRRR!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(60)
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english="[CN][CS:N]Palkia[CR] wants to join the team.", french="[CN][CS:N]Palkia[CR] veut se joindre à l'équipe.", german="[CN][CS:N]Palkia[CR] möchte dem Team beitreten.", italian="[CN][CS:N]Palkia[CR] vuole unirsi alla squadra.", spanish="[CN][CS:N]Palkia[CR] quiere unirse al equipo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- @label_5 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- switch(ProcessSpecial(PROCESS_SPECIAL_PREPARE_MENU_ACCEPT_TEAM_MEMBER, 8, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  do local __sw = ((SV.SkyMenuResults or {})["MENU_ACCEPT_TEAM_MEMBER"] or 0) -- switch(message_Menu(MENU_ACCEPT_TEAM_MEMBER)) [message_Menu(MENU_ACCEPT_TEAM_MEMBER): menu moteur NDS (retour par défaut 0, branches préservées)]
  if __sw == 2 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english="[CN]Are you sure?[K]\n[CN]You're sure you won't accept\n[CN]this potential new member?", french="[CN]Vraiment?[K]\n[CN]Vous ne voulez pas de cette\n[CN]nouvelle recrue potentielle?", german="[CN]Bist du sicher?[K]\n[CN]Bist du sicher, dass du dieses\n[CN]potenzielle neue Mitglied ablehnen willst?", italian="[CN]Davvero?[K]\n[CN]Confermi di non voler accettare\n[CN]questo potenziale nuovo membro?", spanish="[CN]¿Seguro?[K]\n[CN]¿Seguro que prefieres que no\n[CN]se incorpore al equipo?"})
  do local __choice = SkySceneKit.ask({{english="Reconsider", french="Reconsidérer", german="Überdenken", italian="Ripensaci", spanish="Reconsiderar"}, {english="Refuse", french="Refuser", german="Ablehnen", italian="Rifiuta", spanish="Rechazar"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english="[CN][player] turned down\n[CN]the Pokémon's offer to join.", french="[CN][player] a décliné la proposition\n[CN]du Pokémon de se joindre à l'équipe.", german="[CN][player] lehnte das Beitrittsangebot\n[CN]des Pokémon ab.", italian="[CN][player] rifiuta\n[CN]l'offerta del Pokémon.", spanish="[CN][player] rechazó la proposición\n[CN]del Pokémon de unirse al equipo."})
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english="[CN][CS:N]Palkia[CR] appears to be\n[CN]a little disappointed...", french="[CN][CS:N]Palkia[CR] a l'air\n[CN]un peu déçu...", german="[CN][CS:N]Palkia[CR] scheint ein\n[CN]wenig enttäuscht zu sein...", italian="[CN]Si legge la delusione nello sguardo di [CS:N]Palkia[CR]...", spanish="[CN][CS:N]Palkia[CR] parece estar\n[CN]un poco decepcionado..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- GAP: se_Play(8200) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(25) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetOutputAttribute(1) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_H02P99C5_120) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(20) [anim idle native]
  GAME:WaitFrames(10)
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_H02P99C5_120) [routine d'objet NDS non simulée - documenté]
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english="[CN][CS:N]Palkia[CR] sadly went away...", french="[CN][CS:N]Palkia[CR] s'en va, la mort dans l'âme...", german="[CN][CS:N]Palkia[CR] geht traurig davon...", italian="[CN][CS:N]Palkia[CR] si allontana triste...", spanish="[CN][CS:N]Palkia[CR] se ha marchado entristecido..."})
  -- message_Close
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(2) -- join WaitBgm
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- jump @label_5 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif true then -- default
  -- @label_0 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" ...[K]YOU DEFEATED ME.", french=" ...[K] VOUS M'AVEZ VAINCU.", german=" ...[K]IHR HABT MICH BESIEGT.", italian=" ...[K] MI AVETE BATTUTO.", spanish=" HE CAÍDO...[K] HE SIDO DERROTADO."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="IT IS NOT THE STRONG\nTHAT WIN.[K] THOSE THAT WIN ARE STRONG.", french="CE N'EST PAS LE PLUS FORT QUI\nGAGNE.[K] MAIS CEUX QUI GAGNENT QUI SONT\nLES PLUS FORTS.", german="ES SIND NICHT DIE STARKEN,\nDIE GEWINNEN.[K] DIEJENIGEN, DIE GEWINNEN,\nSIND STARK.", italian="NON È IL PIÙ FORTE CHE\nVINCE.[K] SONO COLORO CHE VINCONO A\nESSERE I PIÙ FORTI.", spanish="NO SON LOS FUERTES LOS QUE\nGANAN.[K] LOS QUE GANAN DEMUESTRAN QUE\nSON LOS FUERTES."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="AND YOUR STRENGTH...[K]\nI SUBMIT TO IT.", french="ET VOTRE FORCE...[K]\nJE M'Y SOUMETS.", german="UND EURER STÄRKE...[K]\nBEUGE ICH MICH.", italian="E LA VOSTRA FORZA...[K]\nMI HA BATTUTO.", spanish="YO ME SOMETO...[K]\nA DICHA FUERZA."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="FROM NOW ON, I TOO WILL\nWALK...[K]TOGETHER WITH YOU!", french="DESORMAIS, MOI AUSSI\nJE CHEMINERAI...[K] A VOS COTES!", german="VON JETZT AN ZIEHE ICH[K] AN\nEINEM STRANG MIT EUCH!", italian="D'ORA IN AVANTI, ANCH'IO\nCAMMINERÒ...[K] AL VOSTRO FIANCO!", spanish="DESDE AHORA, YO TAMBIÉN\nCAMINARÉ...[K] LA MISMA SENDA DE ESTE\nEQUIPO."})
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
  -- @label_2 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][player] cleared [CS:P]Spacial Rift[CR]\n[CN]in admirable fashion!", french="[CN][player] a brillamment terminé\n[CN]la [CS:P]Faille Spatiale[CR]!", german="[CN][player] meisterte die [CS:P]Raumspalte[CR]\n[CN]auf beeindruckende Weise!", italian="[CN][player] ha completato la\n[CN][CS:P]Valle Dimensionale[CR] in modo eccellente!", spanish="[CN]¡[player] logró atravesar\n[CN]la [CS:P]Grieta Espacial[CR]!"})
  -- message_Close
  end
  end
  SkySceneKit.cleanup_npcs()
end
