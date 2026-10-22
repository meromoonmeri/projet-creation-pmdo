-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D39P41A/s21p1201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- GAP: se_Play(8198) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 30) -- screen_WhiteOut
  -- back_SetGround(LEVEL_D39P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(45)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  local npc_npc_parukia = SkySceneKit.spawn_npc("palkia", 376, 304, Direction.Down, "NPC_PARUKIA")
  pcall(function() GROUND:CharSetEmote(npc_npc_parukia, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english=" THEY...DISAPPEARED?", french="LES PROFANATEURS ONT...\nDISPARU?", german=" SIE... SIND VERSCHWUNDEN?", italian=" DOVE... SONO?", spanish=" HAN... ¿DESAPARECIDO?"})
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english=" NO! THEY HAVE MERELY FLED!", french="NON! SIMPLEMENT PRIS\nLA FUITE!", german=" NEIN! SIE SIND NUR GEFLOHEN!", italian=" NO! SE LA SONO SVIGNATA!", spanish=" ¡NO! ¡HAN HUIDO!"})
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english="I HAD ALMOST DISPOSED OF\nTHEM FOREVER...[K] SO BE IT.", french="ET J'ETAIS SUR LE POINT DE\nLES ELIMINER POUR TOUJOURS...[K] SOIT.", german="ICH HATTE SIE BEINAHE FÜR\nIMMER BESEITIGT...[K] SO SEI ES.", italian="ERO QUASI RIUSCITO A\nLIBERARMENE PER SEMPRE...[K] E SIA.", spanish="CASI HABÍA TERMINADO DE\nUNA VEZ POR TODAS...[K] PUES QUE ASÍ\nSEA."})
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english="BUT THEY CAN NEVER ESCAPE\n[CS:P]SPACIAL RIFT[CR]!", french="MAIS LA [CS:P]FAILLE SPATIALE[CR] SERA\nLEUR TOMBEAU!", german="ABER SIE KÖNNEN NIEMALS AUS\nDER [CS:P]RAUMSPALTE[CR] ENTKOMMEN!", italian="MA NON RIUSCIRANNO MAI A\nLASCIARE LA [CS:P]VALLE DIMENSIONALE[CR]!", spanish="¡NUNCA LOGRARÁN ESCAPAR\nDE LA [CS:P]GRIETA ESPACIAL[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english="I WILL HUNT THEM DOWN...[K]\nAND BE DONE WITH THEM! ONCE AND FOR ALL!", french="JE LES TRAQUERAI...[K]\nET JE LES ANEANTIRAI! UNE FOIS POUR\nTOUTES!", german="ICH WERDE SIE ZUR STRECKE\nBRINGEN...[K] UND SIE EIN FÜR ALLE MAL FERTIG\nMACHEN!", italian="DARÒ LORO LA CACCIA...[K]\nE MI SBARAZZERÒ DI LORO! UNA VOLTA PER\nTUTTE!", spanish="NO SE ME ESCAPARÁN...[K]\n¡Y ACABARÉ CON ESTO PARA SIEMPRE!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(25) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- GAP: se_Play(8200) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetOutputAttribute(1) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end) -- message_SetActor(ACTOR_NPC_PARUKIA)
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english=" GRRR-OOOOOOOO!", french=" GRRR-OOOOOOOO!", german=" GRRR-OOOOOOOO!", italian=" GRRR-OOOOOOOO!", spanish=" ¡GRRR!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_H02P99C5_120) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(4) [anim idle native]
  GAME:WaitFrames(10)
  -- message_CloseEnforce
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_H02P99C5_120) [routine d'objet NDS non simulée - documenté]
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(30)
  GAME:FadeOut(false, 30)
  GAME:WaitFrames(60)
  GAME:WaitFrames(2) -- join WaitSe
  SkySceneKit.cleanup_npcs()
end
