-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V26P01A/s22p1107.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Hidden Highland.ogg", true) end)
  -- back_SetGround(LEVEL_V26P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker("Darkrai", true, "darkrai", 0, '', RogueEssence.Data.Gender.Unknown) end) -- message_SetActor(ACTOR_NPC_DAAKURAI) voix hors champ (espèce ROM)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" I sabotaged [CS:P]Temporal Tower[CR].", french="C'est moi qui ai saboté la [CS:P]Tour\ndu Temps[CR].", german=" Ich habe den [CS:P]Zeitturm[CR] sabotiert.", italian=" L'ho sabotata.", spanish=" Así que la saboteé."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="That would have eventually led\nto the destruction of time.[K] And ultimately, the\nplanet's paralysis.", french="Cela aurait dû conduire à\nla destruction du temps.[K] Et à terme,\nà la Paralysie de la Planète.", german="Irgendwann hätte das zur\nZerstörung der Zeit geführt.[K] Und letztendlich\nzur Lähmung des Planeten.", italian="Questo avrebbe causato la\ndistruzione del tempo.[K] E, alla fine, la paralisi\ndel pianeta.", spanish="Eso debería haber provocado\nla destrucción del tiempo.[K] Y, finalmente,\nla parálisis del planeta."})
  -- message_Close
  GAME:FadeOut(false, 30)
end
