-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D01P11A/n04a0401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Huh?[K] It's not this way.", french=" Hein?[K] Ce n'est pas par là.", german=" Wie?[K] Doch nicht hier lang!", italian="Eh?[K] Questa è la direzione\nsbagliata.", spanish=" ¿Eh?[K] Por ahí no es."})
  -- message_Close
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="What in the world... [K]What am I\ndoing, anyway...", french="Ça alors... [K]Mais qu'est-ce que\nje fais, moi...?", german="Was um alles in der Welt...[K]\nWas mach ich denn nur...", italian="Ma insomma... [K] Che cosa sto\nfacendo...?", spanish="O sea, pero...[K] ¿Qué estoy\nhaciendo? En fin..."})
  -- message_Close
end
