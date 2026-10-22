-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T00P01/m01a0707.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  -- ExecuteCommon(CORO_LIVES_REPLY, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="It sounds like the natural disasters were\ninterfering with our ability to evolve.", french="It sounds like the natural disasters were\ninterfering with our ability to evolve.", german="It sounds like the natural disasters were\ninterfering with our ability to evolve.", italian="It sounds like the natural disasters were\ninterfering with our ability to evolve.", spanish="It sounds like the natural disasters were\ninterfering with our ability to evolve."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I think the timing's right.[K] I should think about\nevolving...", french="I think the timing's right.[K] I should think about\nevolving...", german="I think the timing's right.[K] I should think about\nevolving...", italian="I think the timing's right.[K] I should think about\nevolving...", spanish="I think the timing's right.[K] I should think about\nevolving..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="But when I evolve...[K] I become a [CS:L]Ludicolo[CR]...", french="But when I evolve...[K] I become a [CS:L]Ludicolo[CR]...", german="But when I evolve...[K] I become a [CS:L]Ludicolo[CR]...", italian="But when I evolve...[K] I become a [CS:L]Ludicolo[CR]...", spanish="But when I evolve...[K] I become a [CS:L]Ludicolo[CR]..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="You know? [CS:L]Ludicolo[CR] is a carefree Pokémon.", french="You know? [CS:L]Ludicolo[CR] is a carefree Pokémon.", german="You know? [CS:L]Ludicolo[CR] is a carefree Pokémon.", italian="You know? [CS:L]Ludicolo[CR] is a carefree Pokémon.", spanish="You know? [CS:L]Ludicolo[CR] is a carefree Pokémon."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I don't know about having my personality\nbecome carefree...[K] What do you think? Huh?", french="I don't know about having my personality\nbecome carefree...[K] What do you think? Huh?", german="I don't know about having my personality\nbecome carefree...[K] What do you think? Huh?", italian="I don't know about having my personality\nbecome carefree...[K] What do you think? Huh?", spanish="I don't know about having my personality\nbecome carefree...[K] What do you think? Huh?"})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
end
