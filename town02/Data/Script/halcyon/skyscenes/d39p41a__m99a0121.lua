-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D39P41A/m99a0121.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(66, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  -- back_SetGround(LEVEL_D39P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GROUND:MoveToPosition(hero, 372, 344, false, 2)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 396, 360, false, 2) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 348, 360, false, 2) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then GROUND:MoveToPosition(__slot, 372, 376, false, 2) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  local npc_npc_parukia = SkySceneKit.spawn_npc("palkia", 376, 296, Direction.Down, "NPC_PARUKIA")
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english="I AM [CS:N]PALKIA[CR]![K] I CONTROL THE\nFABRIC OF SPACE ITSELF!", french="MON NOM EST [CS:N]PALKIA[CR]![K]\nJE CONTROLE L'ESPACE LUI-MEME!", german="ICH BIN [CS:N]PALKIA[CR]![K] ICH\nKONTROLLIERE DAS RAUMGEFÜGE AN SICH!", italian="IO SONO [CS:N]PALKIA[CR]![K] CONTROLLO\nLA STRUTTURA DELLO SPAZIO!", spanish="¡SOY [CS:N]PALKIA[CR]![K] ¡Y EL ESPACIO\nES MI DOMINIO!"})
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english="AND THIS IS MY SPACE![K]\nMY TERRITORY!", french="ET CECI EST MON ESPACE![K]\nMON TERRITOIRE!", german="UND DIES IST MEIN RAUM![K]\nMEIN TERRITORIUM!", italian="E QUESTO È IL MIO SPAZIO![K]\nIL MIO TERRITORIO!", spanish="¡ESTE ES MI ESPACIO![K]\n¡MI TERRITORIO!"})
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english="ALL THOSE WHO VIOLATE\n[CS:P]SPACIAL RIFT[CR]...", french="QUICONQUE S'INTRODUIT\nDANS LA [CS:P]FAILLE SPATIALE[CR]...", german="ALLE, DIE DIE [CS:P]RAUMSPALTE[CR]\nIN GEFAHR BRINGEN...", italian="TUTTI QUELLI CHE VIOLANO LA\n[CS:P]VALLE DIMENSIONALE[CR]...", spanish="TODOS LOS QUE PENETRAN\nEN LA [CS:P]GRIETA ESPACIAL[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english="I WILL DESTROY! NO MATTER\nWHO IT IS!", french="... S'EXPOSE A MA COLERE!\nJE VOUS ANEANTIRAI!", german="ICH WERDE SIE ZERSTÖREN!\nOHNE UNTERSCHIED!", italian="... SARANNO DISTRUTTI!\nCHIUNQUE ESSI SIANO!", spanish="¡HAN DE SER DESTRUIDOS!\n¡SEAN QUIENES SEAN!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english="BUT...[K]YOUR REGRET COMES TOO\nLATE!", french="MAIS...[K] IL EST TROP TARD\nPOUR LES REGRETS!", german="EUER BEDAUERN[K] KOMMT ZU\nSPÄT!", italian="MA...[K] LE VOSTRE SCUSE SONO\nTARDIVE!", spanish="NO HAY ARREPENTIMIENTOS QUE\nVALGAN...[K] ¡ES DEMASIADO TARDE PARA ESO!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english="THERE IS NO ESCAPING![K]\nYOU MUST FACE ME IN BATTLE!", french="PAS D'ECHAPPATOIRE![K]\nVOUS DEVEZ M'AFFRONTER!", german="ES GIBT KEIN ENTKOMMEN![K]\nIHR MÜSST EUCH MIR IM KAMPF STELLEN!", italian="NON AVETE VIA DI SCAMPO![K]\nDOVRETE AFFRONTARMI IN UNA LOTTA!", spanish="¡NO HAY ESCAPATORIA![K]\n¡NADIE PUEDE CONMIGO EN COMBATE!"})
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
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english="PREPARE TO FALL![K]\nGRRR-OOOOOO!", french="PREPAREZ-VOUS A MOURIR![K]\nGRRR-OOOOOO!", german="ERWARTET EUREN NIEDERGANG![K]\nGRRR-OOOOOO!", italian="PREPARATEVI AD ESSERE\nSCONFITTI![K] GRRR-OOOOOO!", spanish="¡LA VICTORIA SERÁ MÍA![K]\n¡GRRRRRRR! ¡GRRRRRRR! ¡GRRRRRRR!"})
  GROUND:EntTurn(npc_npc_parukia, Direction.DownRight)
  -- SetAnimation(44) [anim idle native]
  GAME:WaitFrames(30)
  -- message_CloseEnforce
  pcall(function() SOUND:StopBGM() end)
  -- CallCommon CORO_BOSS_WIPE_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.cleanup_npcs()
end
