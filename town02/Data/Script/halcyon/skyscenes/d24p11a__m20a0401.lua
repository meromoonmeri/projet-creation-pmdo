-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D24P11A/m20a0401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D24P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1)
  -- supervision_LoadStation(LEVEL_D24P11A, 'UM20') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 264, 368, Direction.Up, "NPC_JUPUTORU")
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Treeshroud Forest.ogg", true) end)
  GROUND:MoveToPosition(npc_npc_juputoru, 260, 188, false, 2)
  GROUND:MoveToPosition(partner, 244, 220, false, 2)
  GROUND:MoveToPosition(hero, 276, 220, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="This is it.[K] This is the entrance\nto [CS:P]Treeshroud Forest[CR].", french="Nous y voilà.[K] C'est l'entrée de\nla [CS:P]Forêt Linceul[CR].", german="Das ist er.[K] Das ist der Eingang\nzum [CS:P]Schemengehölz[CR].", italian="Eccoci.[K] Siamo all'ingresso della\n[CS:P]Foresta Arcana[CR].", spanish="Aquí está.[K] Esta es la entrada\ndel [CS:P]Bosque Enraizado[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_juputoru, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Oh?", french=" Oh!", german=" Oh?", italian=" Eh?", spanish=" ¡Oh!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What's up, [CS:N]Grovyle[CR]?", french=" Qu'est-ce qui se passe, [CS:N]Massko[CR]?", german=" Was ist los, [CS:N]Reptain[CR]?", italian=" Cos'hai, [CS:N]Grovyle[CR]?", spanish=" ¿Qué pasa, [CS:N]Grovyle[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What is it, [CS:N]Grovyle[CR]?", french=" Qu'est-ce qui se passe, [CS:N]Massko[CR]?", german=" Was ist mit dir, [CS:N]Reptain[CR]?", italian=" Cosa c'è, [CS:N]Grovyle[CR]?", spanish=" ¿Qué pasa, [CS:N]Grovyle[CR]?"})
  else
  SkySceneKit.say({english=" Is something wrong, [CS:N]Grovyle[CR]?", french=" Qu'est-ce qui se passe, [CS:N]Massko[CR]?", german=" Stimmt etwas nicht, [CS:N]Reptain[CR]?", italian=" Qualcosa non va, [CS:N]Grovyle[CR]?", spanish=" ¿Algún problema, [CS:N]Grovyle[CR]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="The atmosphere somehow feels\ndifferent than last time.", french="L'atmosphère est différente\nde la dernière fois.", german="Es liegt, anders als damals,\nirgendetwas in der Luft.", italian="L'atmosfera sembra diversa\nrispetto all'ultima volta.", spanish=" La atmósfera parece distinta."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(20)
  GROUND:EntTurn(npc_npc_juputoru, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" No.[K] I must be imagining it.", french="Non.[K] Ça doit être\nmon imagination.", german=" Nein.[K] Das bilde ich mir nur ein.", italian="No.[K] Dev'essere la mia\nimmaginazione.", spanish="No.[K] Debo de habérmelo\nimaginado."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" We'll go in when you're ready.", french="On y va dès que vous avez fini\nde vous préparer.", german="Wir gehen rein, wenn ihr bereit\nseid.", italian=" Quando siamo pronti entriamo.", spanish=" Entraremos en cuanto digáis."})
  -- message_Close
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  SkySceneKit.cleanup_npcs()
end
