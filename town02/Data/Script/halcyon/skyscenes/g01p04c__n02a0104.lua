-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04C/n02a0104.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_G01P04C2) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 176, 256, Direction.Right, "NPC_PERAPPU")
  GROUND:MoveToPosition(npc_npc_perappu, 324, 256, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() GAME:MoveCamera(420, 256, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(npc_npc_perappu, 388, 256, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(npc_npc_perappu, 420, 200, false, 2)
  pcall(function() GAME:MoveCamera(420, 200, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(40)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Psst...psst...whisper...\n(Guildmaster...[K] It's [CS:N]Chatot[CR].)", french="Psst... psst...\n(Maître...[K] C'est [CS:N]Pijako[CR].)", german="Psst... psst... flüster...\n(Gildenmeister...[K] Ich bin es, [CS:N]Plaudagei[CR].)", italian="Pssst pssst... Ehm...\n(Capitano...[K] Sono [CS:N]Chatot[CR].)", spanish="Eh... Eh... ¿Hola?...\nGran Bluff...[K] Soy [CS:N]Chatot[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Psst...psst...whisper...\n(I'm coming in...)", french="Psst... psst...\n(J'entre...)", german="Psst... psst... flüster...\n(Ich komme rein...)", italian="Pssst pssst... Ehm...\n(Sto entrando...)", spanish="Eh... Eh... ¿Hola?...\nVoy a entrar..."})
  -- message_Close
  -- GAP: se_Play(8711) — id SE NDS sans portage PMDO identifié
  -- back_ChangeGround(LEVEL_G01P04C) [décor déjà chargé par EnterZone PMDO]
  GAME:WaitFrames(30)
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(0), p.Y+(-24), false, 2) end
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
end
