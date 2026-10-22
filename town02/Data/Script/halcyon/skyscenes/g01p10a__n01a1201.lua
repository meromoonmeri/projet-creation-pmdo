-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P10A/n01a1201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]The next morning...", french="[CN]Le lendemain matin...", german="[CN]Am nächsten Morgen...", italian="[CN]Il giorno dopo...", spanish="[CN]A la mañana siguiente..."})
  -- message_Close
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 216, 168, Direction.Down, "NPC_DOGOOMU")
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="HEY![K]\nHEEEEEEEEEYYYYYYYYYYY!!!", french="OH!![K]\nOHEEEEEEEEEEEEEEE!!", german="HEY!!![K]\nHEEEEEEEEEYYYYYYYYYYY!!!", italian="EHI!![K]\nEEEEEEHIIIIIIIII!!!", spanish="¡¡Oye!![K]\n¡¡Eeeh!!"})
  -- message_KeyWait
  -- GAP: se_Play(8970) — id SE NDS sans portage PMDO identifié
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="GET UUUUUUUUUUUUUUPPPPPP![K]\nIT'S MOOOOOOOOORNNNIIIIIIIIIINNNNNNGGGG!", french="DEBOUUUUUUUUUT LA-DEDANS![K]\nC'EST L'HEUUUUUUUUUUUUURE!", german="AUUUFSTEEEHEN![K]\nES IST MMMMOOOORRRRGGGGEEEENNNN!", italian="SVEEEEEEEEEGLIAAAAAA![K]\nÈ MAAATTIIIIIINAAAAAAAAAAAA!", spanish="¡ARRIBA![K]\n¡QUE YA ES DE DÍA!"})
  GAME:WaitFrames(2) -- join WaitSe
  -- message_Close
  -- back_SetGround(LEVEL_G01P10A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(27) [anim idle native]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '3', '0')
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="IT'S MOOOOOORNIIIIIIINNNNGGG!\nHURRY AND GET UUUUUUUUUUUUUUUUPPPPP!", french="C'EST LE MAAAAAATIIIIIIIIIIIIN!\nDEBOUT ET AU TROOOOOOOOOOOOOOOOOOT!", german="ES IST MMOOORRRGGGGEENNN!\nMACH SCHON UND STEEEEH AAAUUUUUUFF!", italian="È MAAATTIIIIIINAAAAAAAAAAA!\nSBRIGATI E AAAAAALZAAAAAATIIIIIIIIIIII!", spanish="¡HE DICHO QUE YA ES DE DÍA!\n¡LEVÁNTATE, GANDUL!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_dogoomu, 216, 124, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Hu-uuh...?", french=" Que... quoi?", german=" W-was...", italian=" Eh, cosa...?", spanish=" ¿Eh...?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Left)
  -- SetAnimation(28) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(10)
  -- ExecuteCommon(CORO_HEAD_SHAKE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[1] = 1 -- $SCENARIO_MAIN_BIT_FLAG[1] = 1 (ROM)
  -- main_SetGround(LEVEL_G01P10A) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[7] = 1 -- $SCENARIO_MAIN_BIT_FLAG[7] = 1 (ROM)
  -- CallCommon CORO_HANYOU_SAVE_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.cleanup_npcs()
end
