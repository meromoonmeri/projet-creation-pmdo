-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04C/m24a0109.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_G01P04C) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 504, 280, Direction.Left, "NPC_PUKURIN")
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="When I heard wise old [CS:N]Torkoal[CR]'s\ntale...", french="Quand j'ai entendu l'histoire\ndu vénérable [CS:N]Chartor[CR]...", german="Als ich die Geschichte des\nweisen alten [CS:N]Qurtel[CR] hörte...", italian="Quando ho sentito la storia del\nvecchio saggio [CS:N]Torkoal[CR]...", spanish="Cuando escuché la historia del\nanciano [CS:N]Torkoal[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="And when I saw [partner]'s\nRelic Fragment...[K]I finally understood.", french="Et quand j'ai vu le Fragment\nde Relique de [partner]...[K] j'ai enfin\ncompris.", german="Und als ich das Reliktfragment\nvon [partner] sah...[K] Da verstand ich\nendlich.", italian="E quando ho visto il\nFrammento Antico di [partner]...[K]\nFinalmente ho capito.", spanish="Y vi la Reliquia de Piedra de\n[partner]...[K] por fin lo entendí."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="I realized then that the peculiar\npattern was linked to the [CS:P]Hidden Land[CR].", french="J'ai compris que ce symbole\nétrange était lié aux [CS:P]Terres Illusoires[CR].", german="Ich erkannte, dass das\nReliktfragment mit dem [CS:P]Verborgenen Land[CR] in\nVerbindung stand.", italian="In quel momento ho realizzato\nche quel disegno particolare era collegato\nalla [CS:P]Terra Nascosta[CR].", spanish="Me di cuenta de que ese extraño\ndibujo estaba relacionado con la [CS:P]Tierra Oculta[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="That's why I headed out to [CS:P]Brine\nCave[CR] before everyone else went.", french="Alors je suis parti pour\nla [CS:P]Caverne Saline[CR] avant tout le monde.", german="Darum eilte ich vor allen\nanderen zur [CS:P]Salzwasserhöhle[CR] hinaus.", italian="È per questo che mi sono diretto\nalla [CS:P]Grotta Salmastra[CR] prima degli altri.", spanish="Por eso, me adelanté a los\ndemás y fui a la [CS:P]Cueva Aguamar[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Because I had to see [CS:N]Lapras[CR].", french="Parce qu'il fallait que je voie\n[CS:N]Lokhlass[CR].", german=" Weil ich [CS:N]Lapras[CR] treffen musste.", italian=" Perché dovevo vedere [CS:N]Lapras[CR].", spanish=" Tenía que ver a [CS:N]Lapras[CR]."})
  -- message_Close
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
end
