-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P08P01A/m19d0612.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_P08P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_serebii = SkySceneKit.spawn_npc("celebi", 280, 208, Direction.Down, "NPC_SEREBII")
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="Besides, if you would be so kind\nas to prevent the planet's paralysis...", french="Par ailleurs, si tu pouvais faire\nen sorte que la planète ne soit pas paralysée...", german="Wenn ihr dann so nett wärt, die\nLähmung des Planeten aufzuhalten...", italian="Inoltre, se vorrete essere così\ngentili da prevenire la paralisi del pianeta...", spanish="Si lograras evitar la parálisis\ndel planeta..."})
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="We'll finally be spared the agony\nof this world of darkness.", french="Ça nous épargnerait les\nsouffrances de ce monde envahi par\nl'ombre.", german="Das würde uns das Elend dieser\nWelt der Dunkelheit ersparen.", italian="... finalmente potrete\nrisparmiarci l'agonia di questo mondo\ndi oscurità.", spanish="Escaparíamos, por fin, de\nla angustia de este mundo de oscuridad."})
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="My dear [CS:N]Grovyle[CR], I will devote\nmy whole life to achieve that end!", french="Mon cher [CS:N]Massko[CR], je serais\nprête à donner ma vie pour que cela n'arrive\npas!", german="Mein lieber [CS:N]Reptain[CR], diesem Ziel\nwerde ich mein ganzes Leben widmen!", italian="Mio caro [CS:N]Grovyle[CR], darei la mia\nvita per raggiungere questo obiettivo!", spanish="Mi querido [CS:N]Grovyle[CR],\n¡daría mi vida por cumplir ese objetivo!"})
  -- message_Close
  GAME:FadeOut(false, 30)
  GAME:FadeIn(0) -- screen_FlushIn
  SkySceneKit.cleanup_npcs()
end
