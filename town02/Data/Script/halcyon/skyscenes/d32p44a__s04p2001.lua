-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D32P44A/s04p2001.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D32P44A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  local npc_npc_rejigigasu = SkySceneKit.spawn_npc("regigigas", 304, 216, Direction.Down, "NPC_REJIGIGASU")
  pcall(function() UI:SetSpeaker(npc_npc_rejigigasu) end)
  SkySceneKit.say({english=" I AM [CS:N]REGIGIGAS[CR]...", french=" JE SUIS [CS:N]REGIGIGAS[CR]...", german=" ICH BIN [CS:N]REGIGIGAS[CR]...", italian=" IO SONO [CS:N]REGIGIGAS[CR]...", spanish=" YO SOY [CS:N]REGIGIGAS[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_rejigigasu) end)
  SkySceneKit.say({english=" I PLEDGE...SERVICE TO YOU...", french=" JE VOUS DOIS... ALLEGEANCE...", german="ICH VERSPRECHE, DIR ZU\nDIENEN...", italian=" MI IMPEGNO A... SERVIRTI...", spanish=" PROMETO SERVIROS..."})
  -- @label_2 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- switch(ProcessSpecial(PROCESS_SPECIAL_PREPARE_MENU_ACCEPT_TEAM_MEMBER, 9, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  do local __sw = ((SV.SkyMenuResults or {})["MENU_ACCEPT_TEAM_MEMBER"] or 0) -- switch(message_Menu(MENU_ACCEPT_TEAM_MEMBER)) [message_Menu(MENU_ACCEPT_TEAM_MEMBER): menu moteur NDS (retour par défaut 0, branches préservées)]
  if __sw == 1 then
  -- @label_0 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayFanfare("Fanfare/JoinTeam") end) -- me_Play(5) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_rejigigasu) end)
  SkySceneKit.say({english="[CN][c_name:NPC_NEW_FRIEND] joined the team!", french="[CN][c_name:NPC_NEW_FRIEND] rejoint l'équipe!", german="[CN][c_name:NPC_NEW_FRIEND] gehört nun zum Team.", italian="[CN][c_name:NPC_NEW_FRIEND] si unisce alla squadra!", spanish="[CN]¡[c_name:NPC_NEW_FRIEND] se ha unido al equipo!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(2) -- join WaitBgm
  -- @label_4 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(npc_npc_rejigigasu) end)
  SkySceneKit.say({english="[CN][player] cleared [CS:P]Aegis Cave[CR]\n[CN]in admirable fashion!", french="[CN][player] a terminé la [CS:P]Grotte Egide[CR]\n[CN]de façon admirable!", german="[CN][player] meisterte die [CS:P]Ägishöhle[CR]\n[CN]auf beeindruckende Weise!", italian="[CN][player] ha completato la\n[CN][CS:P]Grotta Egida[CR] in modo eccellente!", spanish="[CN]¡[player] logró atravesar\n[CN]la [CS:P]Cueva Regia[CR] de forma admirable!"})
  -- message_Close
  -- switch(ProcessSpecial(55, 58, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(message_Menu(MENU_DUNGEON_EXPLORATION_RESULTS)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- switch(message_Menu(MENU_DUNGEON_TEAM_RETURNS_FROM_MAP)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  elseif true then -- default
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_rejigigasu) end)
  SkySceneKit.say({english="[CN]Are you sure?[K]\n[CN]You're sure you won't accept\n[CN]this potential new member?", french="[CN]Etes-vous sûr?[K]\n[CN]Vous ne voulez vraiment pas\n[CN]accepter cette nouvelle recrue?", german="[CN]Bist du sicher?[K]\n[CN]Möchtest du dieses potenzielle neue\n[CN]Mitglied wirklich abweisen?", italian="[CN]Davvero?[K]\n[CN]Confermi di non voler accettare\n[CN]questo potenziale nuovo membro?", spanish="[CN]¿Seguro?[K]\n[CN]¿Seguro que prefieres que no\n[CN]se incorpore al equipo?"})
  do local __choice = SkySceneKit.ask({{english="Reconsider", french="Reconsidérer", german="Überdenken", italian="Ripensaci", spanish="Reconsiderar"}, {english="Refuse", french="Refuser", german="Ablehnen", italian="Rifiuta", spanish="Rechazar"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 1 then
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_rejigigasu) end)
  SkySceneKit.say({english="[CN][player] turned down\n[CN][CS:N]Regigigas[CR]'s offer to join.", french="[CN][player] refuse l'offre\n[CN]de [CS:N]Regigigas[CR].", german="[CN][player] lehnt das Beitrittsangebot von\n[CN][CS:N]Regigigas[CR] ab.", italian="[CN][player] rifiuta\n[CN]l'offerta di [CS:N]Regigigas[CR].", spanish="[CN][player] declinó el ofrecimiento de\n[CN][CS:N]Regigigas[CR]."})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(2) -- join WaitBgm
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  SkySceneKit.cleanup_npcs()
end
