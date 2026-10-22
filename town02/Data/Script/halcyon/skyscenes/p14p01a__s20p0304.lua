-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P14P01A/s20p0304.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_P14P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(2) [anim idle native]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Why can you not evolve...?", french="[CN]Pourquoi ne peux-tu pas évoluer...?", german="[CN]Warum du dich nicht entwickeln kannst?", italian="[CN]Perché non puoi evolverti?", spanish="[CN]¿Que por qué no puedes evolucionar tú?"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]It may be influenced by a distortion\n[CN]in the fabric of space...", french="[CN]Peut-être est-ce dû à une distorsion\n[CN]dans la trame de l'espace...", german="[CN]Vielleicht hat die Verzerrung des\n[CN]Raumgefüges etwas damit zu tun...", italian="[CN]Potrebbe essere dovuto a una\n[CN]distorsione della struttura dello spazio...", spanish="[CN]Podría deberse a\n[CN]una deformación del espacio..."})
  -- message_Close
  GAME:FadeOut(false, 30)
  GAME:FadeIn(0) -- screen_FlushIn
end
