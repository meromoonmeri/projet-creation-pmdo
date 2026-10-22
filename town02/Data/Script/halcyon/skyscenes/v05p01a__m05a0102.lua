-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V05P01A/m05a0102.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_V05P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Time Gear Remix.ogg", true) end)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker("Chatot", true, "chatot", 0, '', RogueEssence.Data.Gender.Unknown) end) -- message_SetActor(ACTOR_NPC_PERAPPU) voix hors champ (espèce ROM)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Time has come to a standstill in\n[CS:P]Treeshroud Forest[CR]...[K] The wind has stopped...\nThe clouds are motionless...", french="Le temps s'est arrêté dans la\n[CS:P]Forêt Linceul[CR]...[K] Le vent ne souffle plus...\nLes nuages sont devenus immobiles...", german="Die Zeit im [CS:P]Schemengehölz[CR]\nbefindet sich im Stillstand...[K] Der Wind hat auf-\ngehört zu wehen, die Wolken sind erstarrt...", italian="Il tempo si è fermato nella\n[CS:P]Foresta Arcana[CR]...[K] Il vento non soffia più...\nLe nuvole sono immobili...", spanish="El tiempo no parece fluir en el\n[CS:P]Bosque Enraizado[CR].[K] El viento no sopla.\nLas nubes no se mueven..."})
  -- message_Close
  GAME:FadeOut(false, 30)
end
