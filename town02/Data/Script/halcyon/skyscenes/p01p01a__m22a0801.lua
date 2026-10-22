-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P01P01A/m22a0801.ssb (ROM sha256 1fa39d35…).
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
  SkySceneKit.say({english=" Let's go down to the beach first.", french=" Allons d'abord à la plage.", german="Lass uns zuerst zum Strand\ngehen.", italian=" Prima scendiamo in spiaggia.", spanish=" Vamos antes a la playa."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We should go down to the\nbeach first.", french=" Allons d'abord à la plage.", german="Wir sollten zuerst zum Strand\ngehen.", italian="Prima dobbiamo andare\nin spiaggia.", spanish=" Deberíamos ir antes a la playa."})
  else
  SkySceneKit.say({english=" Let's go down to the beach first.", french=" Allons d'abord à la plage.", german="Lass uns zuerst zum Strand\ngehen.", italian=" Prima andiamo in spiaggia.", spanish=" Deberíamos ir antes a la playa."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We may see [CS:N]Grovyle[CR] if we go\nto the beach.", french="Si ça se trouve, [CS:N]Massko[CR] nous\ny attend.", german="Wir könnten [CS:N]Reptain[CR] treffen,\nfalls wir zum Strand gehen.", italian="Se andiamo in spiaggia potremmo\nvedere [CS:N]Grovyle[CR].", spanish=" Puede que [CS:N]Grovyle[CR] esté allí."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[CS:N]Grovyle[CR] could be waiting for\nus there.", french="Si ça se trouve, [CS:N]Massko[CR] nous\ny attend.", german="[CS:N]Reptain[CR] könnte dort auf uns\nwarten.", italian="[CS:N]Grovyle[CR] potrebbe essere là\nad aspettarci.", spanish="Puede que [CS:N]Grovyle[CR] nos espere\nallí."})
  else
  SkySceneKit.say({english=" If we do, we may see [CS:N]Grovyle[CR].", french="Si ça se trouve, [CS:N]Massko[CR] nous\ny attend.", german="Wenn wir das tun, könnten wir\nvielleicht [CS:N]Reptain[CR] treffen.", italian="Se ci andiamo, potremmo vedere\n[CS:N]Grovyle[CR].", spanish="Puede que [CS:N]Grovyle[CR] nos esté\nesperando allí."})
  end
  -- message_Close
end
