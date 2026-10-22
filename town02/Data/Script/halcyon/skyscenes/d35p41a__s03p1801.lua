-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D35P41A/s03p1801.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(53, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  -- back_SetGround(LEVEL_D35P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_fione1 = SkySceneKit.spawn_npc("phione", 352, 288, Direction.Up, "NPC_FIONE1")
  pcall(function() GROUND:CharSetEmote(npc_npc_fione1, "happy", 1) end)
  local npc_npc_fione4 = SkySceneKit.spawn_npc("phione", 328, 264, Direction.Right, "NPC_FIONE4")
  pcall(function() GROUND:CharSetEmote(npc_npc_fione4, "happy", 1) end)
  local npc_npc_fione7 = SkySceneKit.spawn_npc("phione", 352, 240, Direction.Down, "NPC_FIONE7")
  pcall(function() GROUND:CharSetEmote(npc_npc_fione7, "happy", 1) end)
  local npc_npc_fione8 = SkySceneKit.spawn_npc("phione", 392, 248, Direction.DownLeft, "NPC_FIONE8")
  pcall(function() GROUND:CharSetEmote(npc_npc_fione8, "happy", 1) end)
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Mystifying Forest.ogg", true) end)
  GROUND:MoveToPosition(hero, 348, 324, false, 2)
  GAME:WaitFrames(5)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 372, 344, false, 2) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 324, 340, false, 2) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then GROUND:MoveToPosition(__slot, 348, 356, false, 2) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_fione1, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_fione4, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_fione7, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_fione8, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_fione7, "exclaim", 1) end)
  GAME:WaitFrames(5)
  local npc_npc_fione2 = SkySceneKit.spawn_npc("phione", 320, 280, Direction.Right, "NPC_FIONE2")
  pcall(function() GROUND:CharSetEmote(npc_npc_fione2, "exclaim", 1) end)
  local npc_npc_fione6 = SkySceneKit.spawn_npc("phione", 312, 248, Direction.DownRight, "NPC_FIONE6")
  pcall(function() GROUND:CharSetEmote(npc_npc_fione6, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_fione1, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_fione8, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_fione1, Direction.Down)
  GROUND:EntTurn(npc_npc_fione2, Direction.Down)
  GAME:WaitFrames(5)
  local npc_npc_fione3 = SkySceneKit.spawn_npc("phione", 384, 280, Direction.UpLeft, "NPC_FIONE3")
  GROUND:EntTurn(npc_npc_fione3, Direction.Down)
  GROUND:EntTurn(npc_npc_fione4, Direction.Down)
  GAME:WaitFrames(5)
  local npc_npc_fione5 = SkySceneKit.spawn_npc("phione", 376, 264, Direction.Left, "NPC_FIONE5")
  GROUND:EntTurn(npc_npc_fione5, Direction.Down)
  GROUND:EntTurn(npc_npc_fione6, Direction.Down)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_fione7, Direction.Down)
  GROUND:EntTurn(npc_npc_fione8, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(45)
  do local p=npc_npc_fione1.Position; GROUND:MoveToPosition(npc_npc_fione1, p.X+(0), p.Y+(24), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]This [CS:N]Phione[CR] appears\n[CN]eager to join the team.", french="[CN]Ce [CS:N]Phione[CR]\n[CN]veut se joindre à vous.", german="[CN][CS:N]Phione[CR] scheint gerne\n[CN]dem Team beitreten zu wollen.", italian="[CN]Questo esemplare di [CS:N]Phione[CR]\n[CN]desidera unirsi alla squadra.", spanish="[CN]Esta [CS:N]Phione[CR] parece\n[CN]con ganas de unirse al equipo."})
  -- @label_2 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- switch(ProcessSpecial(PROCESS_SPECIAL_PREPARE_MENU_ACCEPT_TEAM_MEMBER, 17, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  do local __sw = ((SV.SkyMenuResults or {})["MENU_ACCEPT_TEAM_MEMBER"] or 0) -- switch(message_Menu(MENU_ACCEPT_TEAM_MEMBER)) [message_Menu(MENU_ACCEPT_TEAM_MEMBER): menu moteur NDS (retour par défaut 0, branches préservées)]
  if __sw == 1 then
  -- @label_0 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:StopBGM() end)
  pcall(function() SOUND:PlayFanfare("Fanfare/JoinTeam") end) -- me_Play(5) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][c_name:NPC_NEW_FRIEND] joined the team!", french="[CN][c_name:NPC_NEW_FRIEND] rejoint l'équipe!", german="[CN][c_name:NPC_NEW_FRIEND] gehört nun zum Team.", italian="[CN][c_name:NPC_NEW_FRIEND] si unisce alla squadra!", spanish="[CN]¡[c_name:NPC_NEW_FRIEND] se ha unido al equipo!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitBgm
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][player] cleared the [CS:P]Miracle Sea[CR]\n[CN]in admirable fashion!", french="[CN][player] a terminé la [CS:P]Mer Prodige[CR]\n[CN]de manière admirable!", german="[CN][player] meisterte das [CS:P]Mirakelmeer[CR]\n[CN]auf beeindruckende Weise!", italian="[CN][player] ha completato il\n[CN][CS:P]Mar dei Miracoli[CR] in modo eccellente!", spanish="[CN]¡[player] logró atravesar\n[CN]el [CS:P]Mar Milagro[CR]!"})
  -- message_Close
  elseif true then -- default
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Are you sure?[K]\n[CN]You're sure you won't accept\n[CN]this potential new member?", french="[CN]Etes-vous sûr?[K]\n[CN]Vous ne voulez vraiment pas\n[CN]accepter cette nouvelle recrue?", german="[CN]Bist du sicher?[K]\n[CN]Möchtest du dieses potenzielle neue\n[CN]Mitglied wirklich abweisen?", italian="[CN]Davvero?[K]\n[CN]Confermi di non voler accettare\n[CN]questo potenziale nuovo membro?", spanish="[CN]¿Seguro?[K]\n[CN]¿Seguro que prefieres que no\n[CN]se incorpore al equipo?"})
  do local __choice = SkySceneKit.ask({{english="Reconsider", french="Reconsidérer", german="Überdenken", italian="Ripensaci", spanish="Reconsiderar"}, {english="Refuse", french="Refuser", german="Ablehnen", italian="Rifiuta", spanish="Rechazar"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 1 then
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][player] turned down\n[CN][CS:N]Phione[CR]'s offer to join.", french="[CN][player] refuse l'offre de\n[CN][CS:N]Phione[CR].", german="[CN][player] hat Beitrittsgesuch von\n[CN][CS:N]Phione[CR] abgelehnt.", italian="[CN][player] rifiuta\n[CN]l'offerta di [CS:N]Phione[CR].", spanish="[CN][player] declinó el ofrecimiento de\n[CN][CS:N]Phione[CR]."})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitBgm
  end
  end
  end
  end
  SkySceneKit.cleanup_npcs()
end
