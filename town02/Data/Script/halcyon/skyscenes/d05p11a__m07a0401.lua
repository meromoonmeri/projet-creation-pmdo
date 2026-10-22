-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D05P11A/m07a0401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D05P11A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1)
  -- camera_SetMyself() [neutre/état moteur]
  GROUND:MoveToPosition(partner, 256, 204, false, 2)
  GROUND:MoveToPosition(hero, 296, 204, false, 2)
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Apple Woods.ogg", true) end)
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="This is the way into\n[CS:P]Apple Woods[CR].", french="Le [CS:P]Bois aux Pommes[CR],\nc'est par là.", german=" Das ist der Weg zum [CS:P]Apfelwald[CR].", italian="Da questa parte si va\nal [CS:P]Giardino dei Meli[CR].", spanish=" Por aquí se va al [CS:P]Manzanar[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="This must be the way into\n[CS:P]Apple Woods[CR].", french="Le [CS:P]Bois aux Pommes[CR],\nc'est par là.", german="Hier muss es zum [CS:P]Apfelwald[CR]\ngehen.", italian="Da questa parte si va\nal [CS:P]Giardino dei Meli[CR].", spanish="Creo que por aquí se va\nal [CS:P]Manzanar[CR]."})
  else
  SkySceneKit.say({english="This must be the entrance to\n[CS:P]Apple Woods[CR].", french="Le [CS:P]Bois aux Pommes[CR],\nc'est par là.", german="Das muss der Eingang zum\n[CS:P]Apfelwald[CR] sein.", italian="Da questa parte si va\nal [CS:P]Giardino dei Meli[CR].", spanish="Este debe de ser el camino\nal [CS:P]Manzanar[CR]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[CS:N]Chatot[CR] said we need to go to the\ndeepest part of these woods.", french="Selon [CS:N]Pijako[CR], on doit aller\nau cœur de la forêt.", german="[CS:N]Plaudagei[CR] hat gesagt, wir\nmüssen in den tiefsten Teil des Waldes.", italian="[CS:N]Chatot[CR] ha detto che dobbiamo\nspingerci ben all'interno di questi boschi.", spanish="[CS:N]Chatot[CR] dijo que tendríamos\nque adentrarnos en ese bosque."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="According to [CS:N]Chatot[CR], we need to\ngo to the deepest part of the woods.", french="Selon [CS:N]Pijako[CR], on doit aller\nau cœur de la forêt.", german="Laut [CS:N]Plaudagei[CR] müssen wir in\nden tiefsten Teil des Waldes.", italian="[CS:N]Chatot[CR] ha detto che dobbiamo\nspingerci ben all'interno di questi boschi.", spanish="[CS:N]Chatot[CR] dijo que tendríamos\nque adentrarnos en ese bosque."})
  else
  SkySceneKit.say({english="According to [CS:N]Chatot[CR]'s story, we\nneed to get to the deepest part of the woods.", french="Selon [CS:N]Pijako[CR], on doit aller\nau cœur de la forêt.", german="Laut dem, was [CS:N]Plaudagei[CR] gesagt\nhat, müssen wir in den tiefsten Teil des\nWaldes.", italian="[CS:N]Chatot[CR] ha detto che dobbiamo\nspingerci ben all'interno di questi boschi.", spanish="[CS:N]Chatot[CR] dijo que tendríamos\nque adentrarnos en ese bosque."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="That's where we'll find the\nPerfect Apples, he said.", french="C'est là qu'on devrait trouver\ndes Pommes Parfaites.", german="Dort finden wir die Perfekten\nÄpfel, hat er gesagt.", italian="Ha detto che è lì che troveremo\nle Mele Perfette.", spanish="Dijo que allí encontraríamos\nManzanas Perfectas."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="That's where the Perfect Apples\nare supposed to be.", french="C'est là qu'on devrait trouver\ndes Pommes Parfaites.", german="Dort sollen die Perfekten Äpfel\nsein.", italian="Ha detto che è lì che troveremo\nle Mele Perfette.", spanish="Se supone que allí\nencontraremos Manzanas Perfectas."})
  else
  SkySceneKit.say({english="That's where the Perfect Apples\nshould be.", french="C'est là qu'on devrait trouver\ndes Pommes Parfaites.", german="Dort müssten die Perfekten\nÄpfel sein.", italian="Ha detto che è lì che troveremo\nle Mele Perfette.", spanish="Allí tiene que haber Manzanas\nPerfectas."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's give it our best,\n[hero]!", french="Donnons le meilleur de\nnous-mêmes, [hero]!", german="Geben wir unser Bestes,\n[hero]!", italian="Facciamo del nostro meglio,\n[hero]!", spanish="¡Hagámoslo lo mejor posible,\n[hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's keep doing our best,\n[hero]!", french="Donnons le meilleur de\nnous-mêmes, [hero]!", german="Geben wir wie immer unser\nBestes, [hero]!", italian="Facciamo del nostro meglio,\n[hero]!", spanish="¡Sigamos esforzándonos,\n[hero]!"})
  else
  SkySceneKit.say({english="Let's keep doing our best,\n[hero]!", french="Donnons le meilleur de\nnous-mêmes, [hero]!", german="Geben wir wie immer unser\nBestes, [hero]!", italian="Facciamo del nostro meglio,\n[hero]!", spanish="¡Sigamos esforzándonos,\n[hero]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  pcall(function() GAME:MoveCamera(276, 124, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(hero, 276, 124, false, 2)
  GAME:WaitFrames(20)
  GROUND:MoveToPosition(partner, 276, 124, false, 2)
  GROUND:MoveToPosition(hero, 276, 4, false, 2)
  GROUND:MoveToPosition(partner, 276, 4, false, 2)
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(30)
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(1)
  pcall(function() GAME:MoveCamera(276, 192, 60, false) end) -- performer/caméra
  local npc_npc_sukatanku = SkySceneKit.spawn_npc("skuntank", 280, 288, Direction.Up, "NPC_SUKATANKU")
  GROUND:MoveToPosition(npc_npc_sukatanku, 276, 180, false, 2)
  local npc_npc_dogaasu = SkySceneKit.spawn_npc("koffing", 272, 320, Direction.Up, "NPC_DOGAASU")
  GROUND:MoveToPosition(npc_npc_dogaasu, 272, 228, false, 2)
  local npc_npc_zubatto = SkySceneKit.spawn_npc("zubat", 272, 352, Direction.Up, "NPC_ZUBATTO")
  GROUND:MoveToPosition(npc_npc_zubatto, 272, 236, false, 2)
  GROUND:MoveToPosition(npc_npc_dogaasu, 240, 196, false, 2)
  GROUND:MoveToPosition(npc_npc_zubatto, 312, 196, false, 2)
  GROUND:EntTurn(npc_npc_zubatto, Direction.Up)
  GROUND:EntTurn(npc_npc_sukatanku, Direction.Up)
  GROUND:EntTurn(npc_npc_dogaasu, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english="Whoa-ho-ho! Looks like they're\noff and running.", french="Mouarf mouarf mouarf! Les\nvoilà qui se mettent en route!", german="Whoahoho! Sie haben sich\nanscheinend auf den Weg gemacht.", italian="Uooh-ho-ho! Guarda come\ncorrono.", spanish="¡Jo, jo, jo! Parece que ya se\nhan marchado."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="Heh-heh. We'll go after them.\nCome on.", french="Hin hin! On va les suivre.\nVenez!", german=" Hehe. Gehen wir ihnen nach. Los.", italian="Eh-eh. Gli staremo alle costole.\nForza.", spanish=" ¡Jue, jue...! Venga, vamos."})
  -- message_Close
  GROUND:MoveToPosition(npc_npc_sukatanku, 276, 124, false, 2)
  GAME:WaitFrames(20)
  GROUND:MoveToPosition(npc_npc_dogaasu, 276, 124, false, 2)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(npc_npc_zubatto, 276, 124, false, 2)
  GROUND:MoveToPosition(npc_npc_sukatanku, 276, 4, false, 2)
  GROUND:MoveToPosition(npc_npc_dogaasu, 276, 4, false, 2)
  GROUND:MoveToPosition(npc_npc_zubatto, 276, 4, false, 2)
  GAME:FadeOut(false, 30)
  SkyProg.set(8, 2) -- $SCENARIO_MAIN = scn[8,2] (ROM)
  -- main_EnterDungeon(7, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterDungeon(-1, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
end
