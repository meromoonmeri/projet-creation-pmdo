-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T00P01/m01a01a.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- debug_Print('acting_M01A01A') [neutre/état moteur]
  GAME:WaitFrames(1) -- with(...){hold} NDS
  GAME:WaitFrames(1) -- with(...){hold} NDS
  GAME:FadeOut(false, 30) -- screen_FadeChange vers alpha 128 (assombrissement, adaptation)
  GAME:FadeIn(30) -- screen_FadeChange vers alpha 256 (éclaircissement, adaptation)
  GAME:FadeOut(false, 30)
  -- back_SetGround(LEVEL_T00P01) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_T00P01, 'M01A01') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(3) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1) -- with(...){hold} NDS
  GAME:WaitFrames(1) -- with(...){hold} NDS
  GAME:FadeIn(30)
  -- SetAnimation(76) [anim idle native]
  GAME:WaitFrames(60)
  -- SetAnimation(63) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(30)
  -- SetAnimation(76) [anim idle native]
  GAME:WaitFrames(20)
  pcall(function() GROUND:CharSetEmote(hero, "angry", 1) end)
  GAME:WaitFrames(120)
  -- SetAnimation(5) [anim idle native]
  GAME:WaitFrames(60)
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  GAME:WaitFrames(120)
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  -- SetAnimation(2) [anim idle native]
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="It sounds like the natural disasters were\ninterfering with our ability to evolve.", french="It sounds like the natural disasters were\ninterfering with our ability to evolve.", german="It sounds like the natural disasters were\ninterfering with our ability to evolve.", italian="It sounds like the natural disasters were\ninterfering with our ability to evolve.", spanish="It sounds like the natural disasters were\ninterfering with our ability to evolve."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I think the timing's right.[K]\nI should think about evolving...", french="I think the timing's right.[K]\nI should think about evolving...", german="I think the timing's right.[K]\nI should think about evolving...", italian="I think the timing's right.[K]\nI should think about evolving...", spanish="I think the timing's right.[K]\nI should think about evolving..."})
  -- message_Close
  GAME:FadeOut(false, 30)
  SkySceneKit.play_scene("t00p01__m01a0100", "t00p01__m01a01", hero, partner) -- supervision_ExecuteStation(LEVEL_T00P01, 'M01A01', 0) [chaînage scène ROM]
  GAME:WaitFrames(1) -- hold
end
