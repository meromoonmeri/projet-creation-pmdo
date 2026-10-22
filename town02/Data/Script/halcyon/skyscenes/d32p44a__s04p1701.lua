-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D32P44A/s04p1701.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(61, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  -- back_SetGround(LEVEL_D32P44A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_LOWER_BRINE_CAVE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GROUND:MoveToPosition(hero, 300, 420, false, 2)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 324, 436, false, 2) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 276, 436, false, 2) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then GROUND:MoveToPosition(__slot, 300, 452, false, 2) end end
  GROUND:EntTurn(hero, Direction.UpLeft)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:EntTurn(__slot, Direction.UpLeft) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:EntTurn(__slot, Direction.UpLeft) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then GROUND:EntTurn(__slot, Direction.UpLeft) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -3) [neutre/état moteur]
  local npc_npc_mimiroppu = SkySceneKit.spawn_npc("lopunny", 232, 408, Direction.DownRight, "NPC_MIMIROPPU")
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english="Hello again. We've been waiting\nfor your arrival.", french="Vous voilà. Nous vous\nattendions.", german="Hallo! Wir haben eure Ankunft\nbereits erwartet.", italian="Eccovi qui. Vi stavamo\naspettando.", spanish="Así que estabais aquí.\nOs estábamos esperando."})
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english="Didn't we promise?[K] We said that\nwe'd back you up, Team [team:].", french="Nous tenons notre promesse![K]\nNous vous avions bien dit que nous serions\nvos renforts, Equipe [team:].", german="Haben wir es etwa nicht\nversprochen?[K] Wir sagten, wir verstärken\neuch, Team [team:].", italian="Non ve l'avevamo forse\npromesso?[K] Avevamo detto che vi avremmo\ndato una mano, Team [team:].", spanish="¿No os lo prometimos?[K]\nYa os dijimos que os cubriríamos las espaldas,\n[CS:X]Equipo[CR] [team:]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(300, 276, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(npc_npc_mimiroppu, 228, 276, false, 2)
  local npc_npc_chaaremu = SkySceneKit.spawn_npc("medicham", 208, 416, Direction.DownRight, "NPC_CHAAREMU")
  GROUND:MoveToPosition(npc_npc_chaaremu, 204, 284, false, 2)
  local npc_npc_saanaito = SkySceneKit.spawn_npc("gardevoir", 256, 416, Direction.DownRight, "NPC_SAANAITO")
  GROUND:MoveToPosition(npc_npc_saanaito, 252, 284, false, 2)
  GROUND:MoveToPosition(hero, 300, 276, false, 2)
  GAME:WaitFrames(10)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 324, 292, false, 2) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 276, 292, false, 2) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then GROUND:MoveToPosition(__slot, 300, 308, false, 2) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(30)
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- GAP: se_Play(6925) — id SE NDS sans portage PMDO identifié
  GAME:FadeIn(30) -- screen_FadeChange vers alpha 192 (éclaircissement, adaptation)
  GAME:WaitFrames(2) -- join WaitSe
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english=" ........................", french=" ........................", german=" ........................", italian=" ........................", spanish=" ..."})
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english="THOSE WHO SEEK THE TREASURES\nSLEEPING IN THE GROUND...", french="QUICONQUE CHERCHE LES TRESORS QUI\nSOMMEILLENT DANS LE VENTRE DE LA TERRE...", german="ALLE, DIE IHR SCHÄTZE IM BODEN\nSUCHT...", italian="O VOI CHE CERCATE I TESORI CHE\nRIPOSANO SOTTOTERRA...", spanish="AQUELLOS QUE BUSCAN LOS TESOROS\nQUE YACEN AQUÍ..."})
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english=" SHOW ALL OF YOUR POWER!", french=" DOIT MONTRER TOUT SON POUVOIR!", german=" DEMONSTRIERT ALL EURE KRAFT!", italian=" DIMOSTRATE TUTTA LA VOSTRA FORZA!", spanish=" ¡QUE DEMUESTREN SU PODER!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:StopBGM() end)
  -- GAP: se_Play(7952) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(5)
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  GAME:FadeOut(true, 15) -- screen_WhiteOut
  GAME:WaitFrames(90)
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(2) [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english=" We'll get it done this time!", french=" Nous allons y arriver cette fois!", german=" Diesmal schaffen wir es!", italian=" Questa volta ce la faremo!", spanish=" ¡Esta vez lo conseguiremos!"})
  -- message_Close
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitSe
  -- GAP: se_Play(5136) — id SE NDS sans portage PMDO identifié
  -- CallCommon CORO_BOSS_WIPE_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.cleanup_npcs()
end
