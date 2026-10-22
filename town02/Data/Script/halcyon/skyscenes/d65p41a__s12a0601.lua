-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D65P41A/s12a0601.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(80, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  -- back_SetGround(LEVEL_D65P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GROUND:MoveToPosition(hero, 300, 244, false, 2)
  GAME:WaitFrames(10)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 324, 260, false, 2) end end
  GAME:WaitFrames(10)
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 276, 260, false, 2) end end
  GAME:WaitFrames(10)
  do local __slot = SkySceneKit.team_member(3); if __slot then GROUND:MoveToPosition(__slot, 300, 276, false, 2) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- GAP: se_Play(8194) — id SE NDS sans portage PMDO identifié
  -- GAP: SetEffect EFFECT_LIGHT_ENGULFING2 — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- supervision_Acting(1) [neutre/état moteur]
  -- GAP: SetEffect EFFECT_NONE sur PNJ non résolu (v2 cast SSA)
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(5)
  do local __slot = SkySceneKit.team_member(1); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "exclaim", 1) end) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "exclaim", 1) end) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "exclaim", 1) end) end end
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(45)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-40), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(6410) — id SE NDS sans portage PMDO identifié
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(30)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]The treasure box contained...[K]\n[CN]a [CS:I]Fiery Drum[CR]!", french="[CN]Le Coffre au Trésor contient...[K]\n[CN]un [CS:I]Tamtam Ardent[CR]!", german="[CN]Die Schatzbox enthält[K]\n[CN]eine [CS:I]Feuertrommel[CR]!", italian="[CN]Il forziere contiene...[K]\n[CN]il [CS:I]Tamburovente[CR]!", spanish="[CN]El cofre del tesoro contenía...[K]\n[CN]¡Un [CS:I]Tambor Fuego[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- item_Set(0, 60, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  do local __sw = ((SV.SkyMenuResults or {})["MENU_GIVE_ITEM"] or 0) -- switch(message_Menu(MENU_GIVE_ITEM)) [message_Menu(MENU_GIVE_ITEM): menu moteur NDS (retour par défaut 0, branches préservées)]
  if __sw == 2 then
  -- @label_1 [étiquette de flux ExplorerScript]
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(30)
  elseif true then -- default
  GAME:WaitFrames(10)
  pcall(function() SOUND:PlayFanfare("Fanfare/Treasure") end) -- me_Play(9) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][player] obtained\n[CN]a [CS:I]Fiery Drum[CR], one of\n[CN]the seven treasures!", french="[CN][player] obtient\n[CN]un [CS:I]Tamtam Ardent[CR],\n[CN]un des sept trésors!", german="[CN][player] erhält die\n[CN][CS:I]Feuertrommel[CR], einen der\n[CN]sieben Schätze!", italian="[CN][player] ottiene\n[CN]il [CS:I]Tamburovente[CR], uno dei\n[CN]sette tesori!", spanish="[CN][player] ha obtenido\n[CN]el [CS:I]Tambor Fuego[CR],\n[CN]¡uno de los siete tesoros!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- message_Close
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
end
