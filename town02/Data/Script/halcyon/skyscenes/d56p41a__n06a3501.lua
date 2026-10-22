-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D56P41A/n06a3501.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D56P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- bgm2_PlayFadeIn(BGM_CAVE_AMBIANCE) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  GAME:FadeIn(30)
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  local npc_npc_dorapion = SkySceneKit.spawn_npc("drapion", 264, 304, Direction.Up, "NPC_DORAPION")
  pcall(function() GROUND:CharSetEmote(npc_npc_dorapion, "shock", 1) end)
  GAME:WaitFrames(3)
  local npc_npc_manyuura = SkySceneKit.spawn_npc("weavile", 232, 280, Direction.Up, "NPC_MANYUURA")
  pcall(function() GROUND:CharSetEmote(npc_npc_manyuura, "shock", 1) end)
  GAME:WaitFrames(3)
  local npc_npc_aabokku = SkySceneKit.spawn_npc("arbok", 192, 304, Direction.Up, "NPC_AABOKKU")
  pcall(function() GROUND:CharSetEmote(npc_npc_aabokku, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(12)
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(7)
  -- ExecuteCommon(CORO_LOOK_AROUND_DOWN_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_aabokku) end)
  SkySceneKit.say({english=" Th-they're...[K]not here!", french=" Elles ont...[K] disparu!", german=" Ssss-sssie sssind...[K] weg!", italian=" S-Sono...[K] scomparse!", spanish="No... No essstán...[K] ¡No essstán\naquí!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dorapion) end)
  SkySceneKit.say({english=" Wh-where'd they go?!", french=" Où sont-elles passées?!", german=" W-wo sind sie hin?!?", italian=" D-Dove sono finite?!", spanish=" ¡¿Adónde han ido?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english=" Team [CS:X]Charm[CR]![K] They ran away!", french="L'Equipe [CS:X]Charme[CR]![K] Elles se sont\nenfuies!", german="Team [CS:X]Charme[CR]![K]\nSie sind geflohen!", italian="Quel Team [CS:X]Malia[CR]![K] Se la sono\ndata a gambe!", spanish=" ¡El [CS:X]Equipo Carisma[CR]...[K] ha huido!"})
  -- message_Close
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_manyuura, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_dorapion, Direction.UpLeft)
  GAME:WaitFrames(6)
  GROUND:EntTurn(npc_npc_aabokku, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english="Look for them![K] They should be\nclose by!", french="Cherchez-les![K] Elles ne peuvent\npas être bien loin!", german="Nun sucht sie schon![K] Sie müssen\nhier irgendwo sein!", italian="Cerchiamole![K] Non possono essere\nlontane!", spanish="¡Buscadlas![K] No pueden andar\nmuy lejos."})
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english=" Get the treasure from them!", french=" Emparez-vous du trésor!", german=" Nehmt ihnen den Schatz ab!", italian=" Recuperate il tesoro!", spanish=" ¡Hay que quitarles el tesoro!"})
  -- message_Close
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(3)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english="[CS:N]Arbok[CR] & [CS:N]Drapion[CR]: YEAH!", french="[CS:N]Arbok[CR] & [CS:N]Drascore[CR]: OUAIS!", german="[CS:N]Arbok[CR] und [CS:N]Piondragi[CR]: JUCHHU!", italian="[CS:N]Arbok[CR] e [CS:N]Drapion[CR]: SÌ!", spanish="[CS:N]Arbok[CR] y [CS:N]Drapion[CR]: ¡Sí!"})
  -- message_Close
  GROUND:MoveToPosition(npc_npc_dorapion, 264, 448, false, 2)
  GAME:WaitFrames(12)
  GROUND:MoveToPosition(npc_npc_aabokku, 192, 452, false, 2)
  GAME:WaitFrames(12)
  GROUND:MoveToPosition(npc_npc_manyuura, 228, 448, false, 2)
  GAME:WaitFrames(24)
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(60)
  SkySceneKit.cleanup_npcs()
end
