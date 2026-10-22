-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/us0310.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Treasure Town.ogg", true) end)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="The beach isn't that way,\n[hero].", french="Ce n'est pas la direction de la\nplage, [hero].", german="Zum Strand geht es nicht dort\nlang, [hero].", italian="La spiaggia non è da quella\nparte, [hero].", spanish="La playa no está por ahí,\n[hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="The beach isn't that way,\n[hero].", french="Ce n'est pas la direction de la\nplage, [hero].", german="Zum Strand geht es nicht dort\nlang, [hero].", italian="La spiaggia non è da quella\nparte, [hero].", spanish="La playa no está por ahí,\n[hero]."})
  else
  SkySceneKit.say({english="The beach isn't that way,\n[hero].", french="Ce n'est pas la direction de la\nplage, [hero].", german="Zum Strand geht es nicht dort\nlang, [hero].", italian="La spiaggia non è da quella\nparte, [hero].", spanish="La playa no está por ahí,\n[hero]."})
  end
  -- message_Close
  -- supervision_Suspend(-2) [neutre/état moteur]
end
