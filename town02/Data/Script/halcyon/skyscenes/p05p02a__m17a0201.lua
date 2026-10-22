-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P05P02A/m17a0201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  -- GAP: BGM BGM_IN_THE_FUTURE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  SkyProg.set(18, 2) -- $SCENARIO_MAIN = scn[18,2] (ROM)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][hero] tested the doors.", french="[CN][hero] essaie d'ouvrir la porte.", german="[CN][hero] versucht, die Türen zu öffnen.", italian="[CN][hero] controlla la porta.", spanish="[CN][hero] comprobó la reja."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]The doors failed to open.", french="[CN]La porte ne s'ouvre pas.", german="[CN]Die Türen lassen sich nicht öffnen.", italian="[CN]La porta non si apre.", spanish="[CN]Pero no se abrió."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(It's no good.[K] Like [partner] said, these\ndoors won't open.)", french="(Ça ne sert à rien.[K] [partner] a raison,\nla porte ne s'ouvre pas.)", german="(Das bringt nichts.[K] [partner] hat recht,\ndie Türen gehen nicht auf.)", italian="(È inutile.[K] Come ha detto [partner], la\nporta è bloccata.)", spanish="(Es inútil.[K] Tal y como dijo [partner],\nla reja está cerrada a cal y canto.)"})
  else
  SkySceneKit.say({english="(It's no good.[K] Like [partner] said, these\ndoors won't open.)", french="(Ça ne sert à rien.[K] [partner] a raison,\nla porte ne s'ouvre pas.)", german="(Das bringt nichts.[K] [partner] hat recht,\ndie Türen gehen nicht auf.)", italian="(È inutile.[K] Come ha detto [partner], la\nporta è bloccata.)", spanish="(Es inútil.[K] Tal y como dijo [partner],\nla reja está cerrada a cal y canto.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(It sure looks like we've been locked up!)", french="(Pas de doute, on est sous les verrous!)", german="(Es sieht wirklich so aus, als seien wir\neingesperrt!)", italian="(Non c'è via d'uscita!)", spanish="(¡Desde luego parece que nos han encerrado!)"})
  else
  SkySceneKit.say({english="(It sure looks like we've been locked up!)", french="(Pas de doute, on est sous les verrous!)", german="(Es sieht wirklich so aus, als seien wir\neingesperrt!)", italian="(Non c'è via d'uscita!)", spanish="(¡Desde luego parece que nos han encerrado!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
end
