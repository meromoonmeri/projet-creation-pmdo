-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D31P41A/s01p0802.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D31P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_THE_POWER_OF_DARKNESS non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  pcall(function() UI:ResetSpeaker() end)
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CS:N]Grand Master[CR]: Muah-hahahaha![K] Welcome...[K]\nto the world of darkness.", french="[CS:N]Grand maître[CR]: Mouah ha ha ha ha![K] Je vous\nsouhaite la bienvenue...[K] dans le monde\nde l'ombre.", german="[CS:N]Großmeister[CR]: Mua-hahahaha![K] Willkommen...[K]\nin der Welt der Dunkelheit.", italian="[CS:N]Sua Malvagità[CR]: Muah-ahahahah![K] I miei\nsaluti...[K] dal mondo dell'oscurità.", spanish="[CS:N]Gran malo[CR]: ¡Jia, jia, jia![K] Os doy la\nbienvenida...[K] al mundo de la oscuridad."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CS:N]Grand Master[CR]: Coming to our lair is the last\nmistake you will ever make.[K] You're not\nwalking out of here.", french="[CS:N]Grand maître[CR]: Pénétrer dans notre repaire\nsera votre dernière erreur.[K] Vous ne quitterez\njamais ces lieux.", german="[CS:N]Großmeister[CR]: In unsere Höhle zu kommen, war\neuer letzter Fehler.[K] Hier kommt ihr nicht\nmehr heraus.", italian="[CS:N]Sua Malvagità[CR]: Venire qui è stato il vostro\nultimo errore.[K] Non uscirete mai di qui.", spanish="[CS:N]Gran malo[CR]: Venir a nuestra guarida ha sido un\ncraso error.[K] No saldréis de aquí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CS:N]Grand Master[CR]: Prepare to face the terror that\nis the grand master of all things bad!", french="[CS:N]Grand maître[CR]: Préparez-vous à faire face à la\nterreur qu'on appelle le grand maître de tous\nles maux!", german="[CS:N]Großmeister[CR]: Bereitet euch darauf vor, das\nGrauen zu erleben, das vom Großmeister allen\nÜbels ausgeht!", italian="[CS:N]Sua Malvagità[CR]: Preparatevi ad affrontare\nSua Malvagità!", spanish="[CS:N]Gran malo[CR]: ¡Preparaos para luchar contra el\ngran malo requetemalo!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CS:N]Grand Master[CR]: YOOM...TAH!", french="[CS:N]Grand maître[CR]: TA-DAAA!!", german="[CS:N]Großmeister[CR]: LUUUU... FIIII!", italian="[CS:N]Sua Malvagità[CR]: BADABUM!", spanish="[CS:N]Gran malo[CR]: ¡Ami...! Ejem... Secuaces..."})
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 280, 176, Direction.Down, "NPC_PUKURIN")
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() SOUND:FadeOutBGM(10) end)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(5)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  -- message_CloseEnforce
  GAME:WaitFrames(2) -- join WaitSe
  -- GAP: se_Play(5136) — id SE NDS sans portage PMDO identifié
  -- CallCommon CORO_BOSS_WIPE_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.cleanup_npcs()
end
