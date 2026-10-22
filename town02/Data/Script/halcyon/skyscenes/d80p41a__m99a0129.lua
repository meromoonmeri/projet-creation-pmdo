-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D80P41A/m99a0129.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_D80P41A) [neutre/état moteur]
  if ((SV.SkyPerformanceProgress or {})[7] == 1) then -- if ROM: $PERFORMANCE_PROGRESS_LIST[7]
  -- @label_0 [étiquette de flux ExplorerScript]
  -- supervision_Acting(2) [neutre/état moteur]
  -- @label_1 [étiquette de flux ExplorerScript]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() SOUND:PlayFanfare("Fanfare/LevelUp") end) -- me_Play(1) [jingle ME NDS -> fanfare PMDO]
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][player] defeated [CS:N]Gabite[CR]\n[CN]in an impressive manner![W:100]", french="[CN][player] a vaincu [CS:N]Carmache[CR]\n[CN]avec brio![W:100]", german="[CN][player] besiegte [CS:N]Knarksel[CR]\n[CN]auf beeindruckende Weise![W:100]", italian="[CN][player] ha battuto\n[CN][CS:N]Gabite[CR] alla grande![W:100]", spanish="[CN]¡[player] derrotó a [CS:N]Gabite[CR]\n[CN]de forma impresionante![W:100]"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][player] triumphed over\n[CN][CS:N]Gabite[CR] in a battle!", french="[CN][player] a remporté le combat\n[CN]contre [CS:N]Carmache[CR]!", german="[CN][player] triumphierte in einem Kampf\n[CN]über [CS:N]Knarksel[CR]!", italian="[CN][player] ha trionfato contro\n[CN][CS:N]Gabite[CR]!", spanish="[CN]¡[player] se impuso\n[CN]a [CS:N]Gabite[CR] en el combate!"})
  -- message_Close
  GAME:WaitFrames(30)
  GAME:FadeIn(30)
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  local npc_npc_gabaito = SkySceneKit.spawn_npc("gabite", 336, 208, Direction.Down, "NPC_GABAITO")
  -- SetAnimation(5) [anim idle native]
  GAME:WaitFrames(60)
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Oh?[K]\n[CN][CS:N]Gabite[CR] is saying something.", french="[CN]Tiens![K]\n[CN][CS:N]Carmache[CR] dit quelque chose.", german="[CN]Oh?[K]\n[CN][CS:N]Knarksel[CR] will etwas sagen.", italian="[CN]Oh?[K]\n[CN][CS:N]Gabite[CR] sta dicendo qualcosa.", spanish="[CN]¿Eh?[K]\n[CN][CS:N]Gabite[CR] está diciendo algo."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Apparently, [CS:N]Gabite[CR]\n[CN]was impressed with you.", french="[CN]Apparemment, [CS:N]Carmache[CR]\n[CN]est impressionné par vos talents.", german="[CN]Anscheinend ist [CS:N]Knarksel[CR]\n[CN]sehr beeindruckt von dir.", italian="[CN]Pare che [CS:N]Gabite[CR] sia rimasto\n[CN]molto colpito.", spanish="[CN]Al parecer, [CS:N]Gabite[CR] se ha quedado\n[CN]muy impresionado con tu actuación."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]You're getting loot\n[CN]as proof you battled!", french="[CN]Vous obtenez une récompense\n[CN]pour votre victoire!", german="[CN]Du erhältst einen Beweis\n[CN]für deinen Sieg!", italian="[CN]Ottieni una ricompensa\n[CN]per il coraggio dimostrato!", spanish="[CN]¡Recibirás un botín\n[CN]como prueba de tu valor!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8194) — id SE NDS sans portage PMDO identifié
  -- GAP: SetEffect EFFECT_LIGHT_ENGULFING2 — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- supervision_Acting(3) [neutre/état moteur]
  -- GAP: SetEffect EFFECT_NONE sur PNJ non résolu (v2 cast SSA)
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitSe
  GROUND:MoveToPosition(hero, 332, 236, false, 2)
  GROUND:MoveToPosition(hero, 332, 236, false, 2)
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][player] opened\n[CN]the treasure box.", french="[CN][player] ouvre\n[CN]le Coffre au Trésor.", german="[CN][player] öffnet\n[CN]die Schatzbox.", italian="[CN][player] apre\n[CN]il forziere.", spanish="[CN][player] abrió\n[CN]el cofre del tesoro."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(6411) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_G01P05A1_106) [routine d'objet NDS non simulée - documenté]
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]The treasure box contained...[K]\n[CN]a [CS:I]Gabite Scale[CR]!", french="[CN]Le Coffre au Trésor contient...[K]\n[CN]une [CS:I]Carmachécaille[CR]!", german="[CN]Die Schatzbox enthält[K]\n[CN]eine [CS:I]Kna-Schuppe[CR]!", italian="[CN]Il forziere contiene...[K]\n[CN]una [CS:I]Gabitesquama[CR]!", spanish="[CN]El cofre del tesoro contenía...[K]\n[CN]¡una [CS:I]Gabitescama[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- item_Set(0, 92, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  do local __sw = ((SV.SkyMenuResults or {})["MENU_GIVE_ITEM"] or 0) -- switch(message_Menu(MENU_GIVE_ITEM)) [message_Menu(MENU_GIVE_ITEM): menu moteur NDS (retour par défaut 0, branches préservées)]
  if __sw == 2 then
  -- @label_3 [étiquette de flux ExplorerScript]
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(2) -- join WaitBgm
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][player] cleared [CS:P]Labyrinth Cave[CR]\n[CN]in admirable fashion!", french="[CN][player] a brillamment terminé\n[CN]la [CS:P]Grotte Labyrinthe[CR]!", german="[CN][player] meisterte die [CS:P]Labyrinthhöhle[CR]\n[CN]auf beeindruckende Weise!", italian="[CN][player] ha completato la\n[CN][CS:P]Grotta Labirinto[CR] in modo eccellente!", spanish="[CN]¡[player] logró atravesar\n[CN]la [CS:P]Cueva Laberinto[CR]!"})
  -- message_Close
  elseif true then -- default
  GAME:WaitFrames(10)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() SOUND:PlayFanfare("Fanfare/Treasure") end) -- me_Play(9) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][player] obtained\n[CN]a [CS:I]Gabite Scale[CR]!", french="[CN][player] obtient\n[CN]une [CS:I]Carmachécaille[CR]!", german="[CN][player] erhält\n[CN]eine [CS:I]Kna-Schuppe[CR]!", italian="[CN][player] ottiene\n[CN]una [CS:I]Gabitesquama[CR]!", spanish="[CN]¡[player] obtuvo\n[CN]la [CS:I]Gabitescama[CR]!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN] Thank you, [CS:N]Gabite[CR]!", french="[CN]Merci, [CS:N]Carmache[CR]!", german="[CN] Danke, [CS:N]Knarksel[CR]!", italian="[CN]Grazie, [CS:N]Gabite[CR]!", spanish="[CN]¡Gracias, [CS:N]Gabite[CR]!"})
  -- message_Close
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  else
  -- supervision_Acting(1) [neutre/état moteur]
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
