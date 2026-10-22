-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T00P01/m01a05a.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- debug_Print('acting_M01A05A') [neutre/état moteur]
  GAME:WaitFrames(1) -- with(...){hold} NDS
  GAME:WaitFrames(1) -- with(...){hold} NDS
  GAME:FadeOut(false, 30)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Where am I?", french="[CN]Where am I?", german="[CN]Where am I?", italian="[CN]Where am I?", spanish="[CN]Where am I?"})
  -- message_SetWaitMode(120, 60) [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Am I dreaming this?", french="[CN]Am I dreaming this?", german="[CN]Am I dreaming this?", italian="[CN]Am I dreaming this?", spanish="[CN]Am I dreaming this?"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]I feel a pleasant breeze.", french="[CN]I feel a pleasant breeze.", german="[CN]I feel a pleasant breeze.", italian="[CN]I feel a pleasant breeze.", spanish="[CN]I feel a pleasant breeze."})
  GAME:WaitFrames(30)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="It sounds like the natural disasters were\ninterfering with our ability to evolve.", french="It sounds like the natural disasters were\ninterfering with our ability to evolve.", german="It sounds like the natural disasters were\ninterfering with our ability to evolve.", italian="It sounds like the natural disasters were\ninterfering with our ability to evolve.", spanish="It sounds like the natural disasters were\ninterfering with our ability to evolve."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I think the timing's right.[K] I should think about\nevolving...", french="I think the timing's right.[K] I should think about\nevolving...", german="I think the timing's right.[K] I should think about\nevolving...", italian="I think the timing's right.[K] I should think about\nevolving...", spanish="I think the timing's right.[K] I should think about\nevolving..."})
  GAME:FadeIn(30)
  -- message_SetWaitMode(-1, -1) [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="But when I evolve...[K] I become a [CS:L]Ludicolo[CR]...", french="But when I evolve...[K] I become a [CS:L]Ludicolo[CR]...", german="But when I evolve...[K] I become a [CS:L]Ludicolo[CR]...", italian="But when I evolve...[K] I become a [CS:L]Ludicolo[CR]...", spanish="But when I evolve...[K] I become a [CS:L]Ludicolo[CR]..."})
  -- message_Close
  -- supervision_Suspend(-2) [neutre/état moteur]
end
