-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D02P11A/m02a0701.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_D02P11A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Drenched Bluff.ogg", true) end)
  GROUND:MoveToPosition(hero, 276, 156, false, 2)
  GROUND:MoveToPosition(partner, 248, 156, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(45)
  SkySceneKit.say({english="[CS:N]Spoink[CR]'s pearl should be down on\nthe B7F level.", french="La perle de [CS:N]Spoink[CR] devrait être\nà l'étage E. -7.", german="Die Perle von [CS:N]Spoink[CR] sollte auf\nEbene U7 liegen.", italian="La perla di [CS:N]Spoink[CR] dovrebbe\ntrovarsi al P. -7.", spanish="La perla de [CS:N]Spoink[CR]\ntiene que estar en el piso -7."}) -- SwitchTalk: branche default (canon générique)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  SkySceneKit.say({english="Let's hang in there and finish\nthe job this time, [hero]!", french="Viens! Cette fois, il faut qu'on\ns'accroche! Allons accomplir notre mission,\n[hero]!", german="Geben wir uns Mühe und\nerledigen den Job diesmal, [hero]!", italian="Forza! Questa volta dobbiamo\nfarcela, [hero]!", spanish="¡Esta vez tenemos que\ncompletar la misión, [hero]!"}) -- SwitchTalk: branche default (canon générique)
  GROUND:MoveToPosition(hero, 264, 92, false, 2)
  GAME:WaitFrames(20)
  GROUND:MoveToPosition(partner, 264, 92, false, 2)
  GAME:WaitFrames(20)
  GAME:FadeOut(false, 30)
end
