-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D30P41A/m99a0116.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(43, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  -- back_SetGround(LEVEL_D30P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_TEMPORAL_PINNACLE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GROUND:MoveToPosition(partner, 260, 300, false, 2)
  GROUND:MoveToPosition(hero, 292, 300, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  local npc_npc_diaruga = SkySceneKit.spawn_npc("dialga", 280, 240, Direction.Down, "NPC_DIARUGA")
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english="I AM [CS:N]DIALGA[CR]![K] THE PROTECTOR\nOF [CS:P]TEMPORAL TOWER[CR]!", french="MON NOM EST [CS:N]DIALGA[CR]![K]\nJE SUIS LE GARDIEN DE LA [CS:P]TOUR DU TEMPS[CR]!", german="ICH BIN [CS:N]DIALGA[CR]![K]\nDER BESCHÜTZER DES [CS:P]ZEITTURMS[CR]!", italian="IO SONO [CS:N]DIALGA[CR]![K]\nIL PROTETTORE DELLA [CS:P]TORRE DEL TEMPO[CR]!", spanish="¡SOY [CS:N]DIALGA[CR]![K] ¡EL PROTECTOR\nDE LA [CS:P]TORRE DEL TIEMPO[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english="AH, YOU TWO! IT'S BEEN A\nLONG TIME!", french="AH, VOUS DEUX! CELA FAISAIT\nBIEN LONGTEMPS!", german="AH, IHR ZWEI! ES IST LANGE\nHER!", italian="AH, VOI DUE! È PASSATO TANTO\nTEMPO!", spanish="¡AH! ¡HA PASADO MUCHO\nTIEMPO!"})
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english="BUT...[K]THERE CAN BE BUT ONE\nREASON YOU ARE COMPELLED TO RETURN HERE.", french="MAIS...[K] IL NE PEUT Y AVOIR\nQU'UNE RAISON A VOTRE RETOUR ICI.", german="ABER...[K] NUR EIN EINZIGER GRUND\nKANN EUCH ZUR RÜCKKEHR BEWOGEN HABEN.", italian="MA...[K] NON PUÒ ESSERCI CHE\nUNA RAGIONE, SE SIETE DI NUOVO QUI.", spanish="PERO...[K] SOLO PUEDE HABER\nUN MOTIVO PARA ESTA VISITA."})
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english="AND THAT IS TO...[K] CHALLENGE\nME TO A BATTLE!", french=" ET C'EST...[K] POUR ME DEFIER!", german="UND DER IST,[K] MICH ZU EINEM\nKAMPF HERAUSZUFORDERN!", italian=" E LA RAGIONE È...[K] UNA SFIDA!", spanish=" SIN DUDA...[K] ¡ESTO ES UN RETO!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(19) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  -- GAP: se_Play(6930) — id SE NDS sans portage PMDO identifié
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english=" GRRR-OOOOOO...OOOOOH!", french=" GRRR-OOOOOO... OOOOOH!", german=" GRRR-OOOOOO...OOOOOH!", italian=" GRRR-OOOOOO... OOOOOH!", spanish=" ¡GRRRRRRR! ¡GRRRRRRR!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitSe
  -- message_CloseEnforce
  -- camera_SetEffect(0): arrêt d'effet caméra
  -- SetAnimation(2) [anim idle native]
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english=" SO BE IT!", french=" SOIT!", german=" SO SOLL ES SEIN!", italian=" E SIA!", spanish=" ¡PUES QUE ASÍ SEA!"})
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english=" YOUR CHALLENGE...[K]I ACCEPT!", french=" VOTRE DEFI...[K] JE LE RELEVE!", german="EURE HERAUSFORDERUNG...[K]\nICH NEHME SIE AN!", italian="LA VOSTRA SFIDA...[K]\nÈ ACCETTATA!", spanish=" ACEPTO...[K] EL DESAFÍO."})
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english=" HOWEVER!", french=" POURTANT!", german=" ALLERDINGS...", italian=" AD OGNI MODO...", spanish=" ¡SIN EMBARGO...!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english="IF YOU FAIL TO MUSTER ALL\nYOUR POWER AND SKILL...", french="SI VOUS ECHOUEZ A\nRASSEMBLER TOUTES VOS FORCES ET VOTRE\nHABILETE...", german="WENN IHR ES NICHT SCHAFFT,\nMIT ALL EURER KRAFT UND GESCHICKLICHKEIT\nAUFZUWARTEN...", italian="SE NON FARETE APPELLO A\nTUTTA LA VOSTRA FORZA E ALLE VOSTRE\nABILITÀ...", spanish="PARA VENCERME HACE FALTA\nMUCHA FUERZA Y HABILIDAD..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english="THERE WILL BE NO VICTORY\nFOR YOU!", french=" LA VICTOIRE SERA A MOI!", german="DANN WIRD ES KEINEN SIEG\nFÜR EUCH GEBEN!", italian=" NON VINCERETE MAI!", spanish="¡LA VICTORIA SERÁ MÍA!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  GAME:WaitFrames(2) -- join WaitSe
  -- SetAnimation(19) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  -- GAP: se_Play(6930) — id SE NDS sans portage PMDO identifié
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english=" GRRR-OOOOOO!", french=" GRRR-OOOOOO!", german=" GRRR-OOOOOO!", italian=" GRRR-OOOOOO!", spanish=" ¡GRRRRRRR! ¡GRRRRRRR!"})
  GAME:WaitFrames(2) -- join WaitSe
  -- message_CloseEnforce
  -- camera_SetEffect(0): arrêt d'effet caméra
  pcall(function() SOUND:StopBGM() end)
  -- GAP: se_Play(5140) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitSe
  -- CallCommon CORO_BOSS_WIPE_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.cleanup_npcs()
end
