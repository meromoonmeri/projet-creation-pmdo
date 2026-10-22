-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/m12a0302.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We've got to get back the [CS:Z]Water\nFloat[CR] this time!", french="Cette fois-ci, il faut absolument\nqu'on mette la main sur l'[CS:Z]Hydroflotteur[CR]!", german="Diesmal müssen wir den\n[CS:Z]Schwimmreif[CR] zurückholen!", italian="Questa volta dobbiamo\nassolutamente recuperare l'[CS:Z]Acquaboa[CR]!", spanish="¡Esta vez tenemos que recuperar\nel [CS:Z]Flotarill[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We can't fail at getting back the\n[CS:Z]Water Float[CR] this time!", french="Cette fois-ci, il faut absolument\nqu'on mette la main sur l'[CS:Z]Hydroflotteur[CR]!", german="Diesmal müssen wir es\nschaffen, den [CS:Z]Schwimmreif[CR] zurückzuholen!", italian="Questa volta dobbiamo\nassolutamente recuperare l'[CS:Z]Acquaboa[CR]!", spanish="¡Esta vez tenemos que recuperar\nel [CS:Z]Flotarill[CR]!"})
  else
  SkySceneKit.say({english="We have to get the [CS:Z]Water\nFloat[CR] back this time!", french="Cette fois-ci, il faut absolument\nqu'on mette la main sur l'[CS:Z]Hydroflotteur[CR]!", german="Diesmal müssen wir den\n[CS:Z]Schwimmreif[CR] zurückholen!", italian="Questa volta dobbiamo\nassolutamente recuperare l'[CS:Z]Acquaboa[CR]!", spanish="¡Esta vez tenemos que recuperar\nel [CS:Z]Flotarill[CR]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's head out to [CS:P]Amp Plains[CR]!", french=" En route pour les [CS:P]Plaines Elek[CR]!", german="Machen wir uns auf den Weg zur\n[CS:P]Ampere-Ebene[CR]!", italian=" Torniamo alle [CS:P]Pianure Saetta[CR]!", spanish=" ¡Vamos a la [CS:P]Pradera Destello[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's go back to [CS:P]Amp Plains[CR]!", french=" En route pour les [CS:P]Plaines Elek[CR]!", german="Machen wir uns auf den Weg zur\n[CS:P]Ampere-Ebene[CR]!", italian=" Torniamo alle [CS:P]Pianure Saetta[CR]!", spanish=" ¡Vamos a la [CS:P]Pradera Destello[CR]!"})
  else
  SkySceneKit.say({english=" Let's head back to [CS:P]Amp Plains[CR]!", french=" En route pour les [CS:P]Plaines Elek[CR]!", german="Machen wir uns auf den Weg zur\n[CS:P]Ampere-Ebene[CR]!", italian=" Torniamo alle [CS:P]Pianure Saetta[CR]!", spanish=" ¡Vamos a la [CS:P]Pradera Destello[CR]!"})
  end
  -- message_Close
end
