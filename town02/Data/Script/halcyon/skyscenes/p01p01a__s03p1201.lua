-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P01P01A/s03p1201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I don't think [CS:N]Manaphy[CR] could have\ngone all that far, [hero].", french="Je ne pense pas que [CS:N]Manaphy[CR]\nait pu aller si loin, [hero].", german="Ich glaube nicht, dass [CS:N]Manaphy[CR]\nsehr weit kommen konnte, [hero].", italian="Non penso che [CS:N]Manaphy[CR] si sia\nallontanato tanto, [hero].", spanish="No creo que [CS:N]Manaphy[CR] haya ido\ntan lejos, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I doubt that [CS:N]Manaphy[CR] could have\ngone very far, [hero].", french="Je ne pense pas que [CS:N]Manaphy[CR]\nait pu aller si loin, [hero].", german="Ich glaube nicht, dass [CS:N]Manaphy[CR]\nallzu weit kommen konnte, [hero].", italian="Non penso che [CS:N]Manaphy[CR] si sia\nallontanato tanto, [hero].", spanish="Dudo que [CS:N]Manaphy[CR] haya ido\ntan lejos, [hero]."})
  else
  SkySceneKit.say({english="I don't think [CS:N]Manaphy[CR] could have\ngotten very far, [hero].", french="Je ne pense pas que [CS:N]Manaphy[CR]\nait pu aller si loin, [hero].", german="Ich glaube nicht, dass [CS:N]Manaphy[CR]\nallzu weit kommen konnte, [hero].", italian="Non penso che [CS:N]Manaphy[CR] si sia\nallontanato tanto, [hero].", spanish="No creo que [CS:N]Manaphy[CR] haya ido\ntan lejos, [hero]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's look around here first!", french="Regardons d'abord dans les\nparages!", german="Lass uns zuerst im näheren\nUmkreis suchen!", italian="Prima diamo un'occhiata\nqui in giro!", spanish=" ¡Busquemos por aquí primero!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We should look around\nhere first!", french="Regardons d'abord dans les\nparages!", german="Wir sollten uns erst einmal hier\numsehen!", italian="Prima diamo un'occhiata\nqui in giro!", spanish=" ¡Busquemos por aquí primero!"})
  else
  SkySceneKit.say({english="We should look around\nhere first!", french="Regardons d'abord dans les\nparages!", german="Wir sollten uns erst einmal hier\numsehen!", italian="Prima diamo un'occhiata\nqui in giro!", spanish=" ¡Busquemos por aquí primero!"})
  end
  -- message_Close
end
