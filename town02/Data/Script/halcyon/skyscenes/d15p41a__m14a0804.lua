-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D15P41A/m14a0804.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_D15P41A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  -- GAP: BGM BGM_EARTHQUAKE3 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  do local __slot = SkySceneKit.team_member(1); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "shock", 1) end) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "shock", 1) end) end end
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Waah! What's going on?", french=" Ouaaah! Qu'est-ce qui se passe?", german=" Waah! Was geschieht?", italian=" Aaah! C-Che sta succedendo?", spanish=" ¿Eh? ¿Qué ocurre?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Waah! What's happening?", french=" Ouaaah! Qu'est-ce qui se passe?", german=" Waah! Was geschieht?", italian=" Aaah! C-Che sta succedendo?", spanish=" ¿Eh? ¿Qué ocurre?"})
  else
  SkySceneKit.say({english=" Waah! What's happening?", french=" Ouaaah! Qu'est-ce qui se passe?", german=" Waah! Was geschieht?", italian=" Aaah! C-Che sta succedendo?", spanish=" ¿Eh? ¿Qué ocurre?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_emuritto = SkySceneKit.spawn_npc("mesprit", 320, 224, Direction.Up, "NPC_EMURITTO")
  pcall(function() UI:SetSpeaker(npc_npc_emuritto) end)
  SkySceneKit.say({english="It's happening because the thief\ntook the Time Gear!", french="C'est à cause de ce voleur\nqui a pris le Rouage du Temps!", german="Ich kann dir zumindest sagen,\nwarum es geschieht. Und zwar, weil der Dieb\ndas Zahnrad der Zeit mitgenommen hat!", italian="L'Ingranaggio del Tempo è stato\nrubato!", spanish="El robo del Engranaje del Tiempo\nha desencadenado esta reacción."})
  pcall(function() UI:SetSpeaker(npc_npc_emuritto) end)
  SkySceneKit.say({english=" So time in this whole area...", french="A cause de lui, dans toute\nla région, le temps...", german="Deshalb wird die Zeit in dieser\nGegend...", italian=" Ora che non c'è più...", spanish="Y ahora, el tiempo de toda\nesta zona..."})
  pcall(function() UI:SetSpeaker(npc_npc_emuritto) end)
  SkySceneKit.say({english="Time will stop all around the\n[CS:P]Underground Lake[CR]!", french="Le temps va s'arrêter partout\nautour du [CS:P]Lac Souterrain[CR]!", german="Die Zeit wird überall um den\n[CS:P]Untergrundsee[CR] herum stehenbleiben!", italian="... il tempo si fermerà, qui al\n[CS:P]Lago Sotterraneo[CR]!", spanish="¡El tiempo se detendrá en\nlas inmediaciones del [CS:P]Lago Subterráneo[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  do local __slot = SkySceneKit.team_member(1); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "shock", 1) end) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "shock", 1) end) end end
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What?!", french=" Quoi?!", german=" Was?!?", italian=" Cosa?!", spanish=" ¡¿Qué?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?!", french=" Quoi?!", german=" Was?!?", italian=" Cosa?!", spanish=" ¡¿Qué?!"})
  else
  SkySceneKit.say({english=" Excuse me?!", french=" Quoi?!", german=" Wie bitte?!?", italian=" Cosa?!", spanish=" ¡¿Qué?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_emuritto) end)
  SkySceneKit.say({english="If we don't hurry, we'll be\ntrapped in time!", french="Il faut faire vite, sinon le piège\ntemporel va se refermer sur nous!", german="Wenn wir uns nicht beeilen,\nwerden wir in der Zeit gefangen sein!", italian="Se non ci sbrighiamo, resteremo\nintrappolati!", spanish="Si no nos damos prisa, ¡nos\nveremos atrapados en el tiempo!"})
  pcall(function() UI:SetSpeaker(npc_npc_emuritto) end)
  SkySceneKit.say({english=" Hurry! Run with all your might!", french="Vite! Courez aussi vite\nque vous pouvez!", german="Schnell! Rennt, so schnell ihr\nkönnt!", italian="Sbrigatevi! Correte più che\npotete!", spanish="¡Rápido! ¡Corred con todas\nvuestras fuerzas!"})
  -- message_Close
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(5)
  GROUND:EntTurn(partner, Direction.Down)
  GROUND:EntTurn(npc_npc_emuritto, Direction.Down)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(160), false, 1) end
  GAME:WaitFrames(15)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(160), false, 1) end
  GAME:WaitFrames(30)
  do local p=npc_npc_emuritto.Position; GROUND:MoveToPosition(npc_npc_emuritto, p.X+(0), p.Y+(160), false, 1) end
  do local p=SkySceneKit.team_member(1).Position; GROUND:MoveToPosition(SkySceneKit.team_member(1), p.X+(0), p.Y+(160), false, 1) end
  GAME:WaitFrames(5)
  do local p=SkySceneKit.team_member(2).Position; GROUND:MoveToPosition(SkySceneKit.team_member(2), p.X+(0), p.Y+(160), false, 1) end
  GAME:WaitFrames(45)
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(2) -- join WaitBgm
  -- camera_SetEffect(0): arrêt d'effet caméra
  -- worldmap_SetMode(3) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetLevel(3) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- back2_SetMode(3) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  -- worldmap_ChangeLevel(4) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetCamera(22) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  pcall(function() UI:SetSpeaker(npc_npc_emuritto) end)
  SkySceneKit.say({english="[CN]The clouds lifted over\n[CN][CS:P]Quicksand Cave[CR] and the\n[CN]vicinities of the [CS:P]Arid Area[CR]!", french="[CN]Les nuages se sont dissipés au-dessus\n[CN]de la [CS:P]Grotte Sables Mouvants[CR] et dans\n[CN]les environs de la [CS:P]Région Aride[CR]!", german="[CN]Die Wolken über der [CS:P]Treibsandhöhle[CR]\n[CN]und dem [CS:P]Trockengebiet[CR] haben sich verzogen!", italian="[CN]Le nuvole si sollevano dalla\n[CN][CS:P]Grotta delle Sabbie Mobili[CR]\n[CN]e da tutta la [CS:P]Zona Arida[CR]!", spanish="[CN]¡Las nubes que cubrían la [CS:P]Cueva Arenas[CR]\n[CN]y las inmediaciones de la [CS:P]zona árida[CR]\n[CN]se disiparon!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- screen2_FadeOut [sub déjà caché]
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  -- switch(message_Menu(MENU_DUNGEON_TEAM_RETURNS_FROM_MAP)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[8] = 1 -- $SCENARIO_MAIN_BIT_FLAG[8] = 1 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.COMPULSORY_SAVE_POINT = 12 -- $COMPULSORY_SAVE_POINT = 12 (ROM)
  -- CallCommon CORO_HANYOU_SAVE_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.cleanup_npcs()
end
