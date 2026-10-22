-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/m13a0502.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="All right, let's get moving to the\n[CS:P]Northern Desert[CR].", french="Allez, partons pour le [CS:P]Désert\ndu Nord[CR].", german="Okay, machen wir uns auf den\nWeg zur [CS:P]Nordwüste[CR].", italian="Ok. Diamoci una mossa e\nandiamo al [CS:P]Deserto del Nord[CR].", spanish="Bueno, pongámonos en marcha\nhacia el [CS:P]Desierto Norte[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="OK! We should head on out to\nthe [CS:P]Northern Desert[CR].", french="Allez, partons pour le [CS:P]Désert\ndu Nord[CR].", german="Okay! Machen wir uns auf zur\n[CS:P]Nordwüste[CR].", italian="Pronti! Andiamo subito al\n[CS:P]Deserto del Nord[CR].", spanish="Bueno, pongámonos en marcha\nhacia el [CS:P]Desierto Norte[CR]."})
  else
  SkySceneKit.say({english="OK! We should get moving to\nthe [CS:P]Northern Desert[CR].", french="Allez, partons pour le [CS:P]Désert\ndu Nord[CR].", german="Okay! Wir sollten uns auf den\nWeg zur [CS:P]Nordwüste[CR] machen.", italian="Bene! Dovremmo andare subito\nal [CS:P]Deserto del Nord[CR].", spanish="Bueno, pongámonos en marcha\nhacia el [CS:P]Desierto Norte[CR]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's go to the [CS:P]Northern Desert[CR]\nand find that Time Gear!", french="Allons dans le [CS:P]Désert du Nord[CR]\npour trouver ce Rouage du Temps!", german="Gehen wir zur [CS:P]Nordwüste[CR]\nund finden das Zahnrad der Zeit!", italian="Andiamo al [CS:P]Deserto del Nord[CR] e\ntroviamo quell'Ingranaggio del Tempo!", spanish="¡Vamos al [CS:P]Desierto Norte[CR]\na encontrar ese Engranaje del Tiempo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's go to the [CS:P]Northern Desert[CR]\nand find a Time Gear.", french="Allons dans le [CS:P]Désert du Nord[CR]\npour trouver ce Rouage du Temps!", german="Gehen wir zur [CS:P]Nordwüste[CR]\nund finden das Zahnrad der Zeit!", italian="Andiamo al [CS:P]Deserto del Nord[CR] e\ntroviamo quell'Ingranaggio del Tempo!", spanish="¡Vamos al [CS:P]Desierto Norte[CR]\na encontrar ese Engranaje del Tiempo!"})
  else
  SkySceneKit.say({english="Let's go to the [CS:P]Northern Desert[CR]\nand find that Time Gear.", french="Allons dans le [CS:P]Désert du Nord[CR]\npour trouver ce Rouage du Temps!", german="Gehen wir zur [CS:P]Nordwüste[CR]\nund finden das Zahnrad der Zeit!", italian="Andiamo al [CS:P]Deserto del Nord[CR] e\ntroviamo quell'Ingranaggio del Tempo!", spanish="Vamos al [CS:P]Desierto Norte[CR]\na encontrar ese Engranaje del Tiempo."})
  end
  -- message_Close
end
