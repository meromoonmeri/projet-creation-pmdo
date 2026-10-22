-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V26P07A/m26a0804.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Time Restored.ogg", true) end)
  -- back2_SetMode(5) [mode d'affichage sub NDS: géré par SubScreen]
  -- back_SetGround(LEVEL_V26P07A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- screen2_FadeIn(0, 30) [sub révélé en mode système NDS (aucun décor chargé): pas de contenu narratif - documenté]
  pcall(function() SOUND:FadeOutBGM(160) end)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker("Dialga", true, "dialga", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_DIARUGA (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" THIS IS MY THANKS!", french="C'EST MA FAÇON DE TE\nREMERCIER!", german=" DIES IST MEIN DANK!", italian="QUESTO È IL MIO\nRINGRAZIAMENTO!", spanish="¡ESTA ES MI MANERA DE DAR\nLAS GRACIAS!"})
  pcall(function() UI:SetSpeaker("Dialga", true, "dialga", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_DIARUGA (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" PLEASE ACCEPT IT!", french=" ACCEPTE MON CADEAU!", german=" BITTE NEHMT IHN AN!", italian=" VI PREGO DI ACCETTARLO!", spanish="¡APROVECHA ESTA SEGUNDA\nOPORTUNIDAD!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- Destroy() [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_V26P07A1_349) [routine d'objet NDS non simulée - documenté]
  -- Destroy() [neutre/état moteur]
  -- supervision_Acting(2) [neutre/état moteur]
  -- SetAnimation(3) [anim idle native]
  -- GAP: se_Play(6930) — id SE NDS sans portage PMDO identifié
  pcall(function() GAME:MoveCamera(156, 92, 60, false) end) -- performer/caméra
  -- message_ResetActor() [neutre/état moteur]
  SkySceneKit.say({english="GRRR-OOOOOO...OOOOOH!", french="GRRR-OOOOOO... OOOOOH!", german="GRRR-OOOOOO...OOOOOH!", italian="GRRR-OOOOOO... OOOOOH!", spanish="¡GRRRRRRRRR! ¡GRRRRRRRRR!"}) -- message_ImitationSound (onomatopée)
  GAME:WaitFrames(25)
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false,  30)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitSe
end
