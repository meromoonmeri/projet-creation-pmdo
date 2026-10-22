-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D01P11A/s22p1104.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Time Gear Remix.ogg", true) end)
  -- back_SetGround(LEVEL_D01P11A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GROUND:EntTurn(hero, Direction.Right)
  -- SetAnimation(76) [anim idle native]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker("Darkrai", true, "darkrai", 0, '', RogueEssence.Data.Gender.Unknown) end) -- message_SetActor(ACTOR_NPC_DAAKURAI) voix hors champ (espèce ROM)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="You were also transformed from\na human into a Pokémon...[K] And you lost your\nmemory as well.", french="Tu as subi une mutation qui a\nfait de toi un Pokémon...[K] et par la même\noccasion, tu as perdu la mémoire.", german="Du warst ein Mensch und\nwurdest in ein Pokémon verwandelt...[K]\nUnd du verlorst auch noch dein Gedächtnis.", italian="Tu hai anche assunto la forma\ndi un Pokémon...[K] E hai perso la memoria.", spanish="Tú te transformaste en un\nPokémon...[K] Y perdiste la memoria."})
  -- message_Close
  GAME:FadeOut(false, 30)
  GAME:FadeIn(0) -- screen_FlushIn
end
