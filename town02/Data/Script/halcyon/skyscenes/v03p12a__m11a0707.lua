-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V03P12A/m11a0707.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Time Gear Remix.ogg", true) end)
  -- back_SetGround(LEVEL_V03P12A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  pcall(function() GAME:MoveCamera(480, 132, 1, false) end)
  GAME:FadeIn(15)
  GAME:WaitFrames(30)
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I have no quarrel with you. But I am\ntaking it with me.", french="Je n'ai rien contre toi. Mais je l'emporte\navec moi.", german="Ich will keinen Streit mit dir. Aber ich\nwerde es mitnehmen.", italian="Non ho niente contro di te, ma quello viene\ncon me.", spanish="No quiero enfrentarme a ti.\nPero voy a llevármelo, quieras o no."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" The third Time Gear!", french=" Le troisième Rouage du Temps!", german=" Das dritte Zahnrad der Zeit!", italian=" Il terzo Ingranaggio del Tempo!", spanish=" ¡El tercer Engranaje del Tiempo!"})
  -- message_Close
  GAME:WaitFrames(30)
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 90)
  GAME:WaitFrames(60)
  SkyProg.set(13, 0) -- $SCENARIO_MAIN = scn[13,0] (ROM)
end
