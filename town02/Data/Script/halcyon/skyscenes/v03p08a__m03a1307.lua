-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V03P08A/m03a1307.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Time Gear Remix.ogg", true) end)
  -- back_SetGround(LEVEL_V03P08A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  pcall(function() GAME:MoveCamera(156, 148, 1, false) end)
  -- SetAnimation(3) [anim idle native]
  -- SetAnimation(3) [anim idle native]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(partner) end) -- message_SetActor(ACTOR_ATTENDANT1)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I've even heard that there is\na hidden altar inside a volcano.", french="J'ai même entendu dire qu'il y\navait un autel caché à l'intérieur d'un volcan.", german="Ich habe sogar von einem\ngeheimen Altar in einem Vulkan gehört.", italian="Ho persino sentito dire che c'è\nun altare nascosto all'interno di un vulcano.", spanish="Incluso he oído decir que hasta\ndentro de un volcán."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I've even heard that there is\na hidden altar inside a volcano.", french="J'ai même entendu dire qu'il y\navait un autel caché à l'intérieur d'un volcan.", german="Ich habe sogar von einem\ngeheimen Altar in einem Vulkan gehört.", italian="Ho persino sentito dire che c'è\nun altare nascosto all'interno di un vulcano.", spanish="Incluso he oído decir que hasta\ndentro de un volcán."})
  else
  SkySceneKit.say({english="I've even heard that there is\na hidden altar inside a volcano.", french="J'ai même entendu dire qu'il y\navait un autel caché à l'intérieur d'un volcan.", german="Ich habe sogar von einem\ngeheimen Altar in einem Vulkan gehört.", italian="Ho persino sentito dire che c'è\nun altare nascosto all'interno di un vulcano.", spanish="Incluso he oído decir que hasta\ndentro de un volcán."})
  end
  -- message_Close
  GAME:FadeOut(false, 30)
end
