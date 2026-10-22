-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P04P01C/m10a1210.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Time Restored.ogg", true) end)
  -- back_SetGround(LEVEL_P04P01C) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(60)
  GAME:WaitFrames(30)
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 160, 408, Direction.Up, "NPC_CHIRIIN")
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" Oh, my! So shimmering!", french=" Oh là là, c'est éblouissant!", german=" Ooooh! Wie er schimmert!", italian=" Oh, wow! Guardate come brilla!", spanish=" ¡Vaya! ¡Qué brillo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 136, 400, Direction.Up, "NPC_BIPPA")
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Yup yup! Some kind of pretty!", french="Ouaip ouaip! C'est vachement\nbeau, pour sûr!", german=" Jawollja! Das hat was!", italian=" Già, già! È proprio bello!", spanish=" ¡Sí, señor! ¡Sí que es bonito!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_yukushii = SkySceneKit.spawn_npc("uxie", 168, 352, Direction.Up, "NPC_YUKUSHII")
  pcall(function() UI:SetSpeaker(npc_npc_yukushii) end)
  SkySceneKit.say({english="Yes, the lake geyser erupts\nevery now and then.", french="Oui, le geyser du lac jaillit\nde temps à autre.", german="Ja, der Geysir in dem See bricht\nhin und wieder aus.", italian="Sì, il geyser del lago talvolta\nsi attiva.", spanish="Sí, el géiser del lago entra en erupción\nde vez en cuando."})
  pcall(function() UI:SetSpeaker(npc_npc_yukushii) end)
  SkySceneKit.say({english="It sends up water, just like a\nfountain...", french="Il envoie une colonne d'eau\nen l'air, comme une fontaine...", german="Er sprudelt Wasser nach oben,\nwie ein Springbrunnen...", italian="Emette acqua verso il cielo,\ncome in un sogno...", spanish=" El agua brota como si fuera una fuente."})
  pcall(function() UI:SetSpeaker(npc_npc_yukushii) end)
  SkySceneKit.say({english="And the Time Gear sends up\nillumination from below...", french="Et la lumière vient du Rouage\ndu Temps, au fond du lac...", german="Und das Zahnrad der Zeit\nstrahlt von unten herauf.", italian="... mentre l'Ingranaggio del\nTempo emette dal basso la sua luce...", spanish="Y el Engranaje del Tiempo la ilumina\ndesde abajo..."})
  pcall(function() UI:SetSpeaker(npc_npc_yukushii) end)
  SkySceneKit.say({english="While many [CS:N]Illumise[CR] and [CS:N]Volbeat[CR]\nglow upon the fountain of water...", french="Pendant que les [CS:N]Lumivole[CR]\net les [CS:N]Muciole[CR] volètent autour\ndu geyser en l'illuminant...", german="Und gleichzeitig leuchten zahllose\n[CS:N]Illumise[CR] und [CS:N]Volbeat[CR]\nauf der Wasserfontäne...", italian="... e gli [CS:N]Illumise[CR] e i [CS:N]Volbeat[CR]\nbrillano nei pressi della colonna d'acqua...", spanish="Mientras decenas de [CS:N]Illumise[CR]\ny [CS:N]Volbeat[CR] resplandecen sobre la fuente..."})
  pcall(function() UI:SetSpeaker(npc_npc_yukushii) end)
  SkySceneKit.say({english="In harmony, they are the very\nvision of beauty!", french="Tout cela réuni, c'est la beauté\nà l'état pur!", german="In ihrer Harmonie sind sie die\nEssenz der Schönheit!", italian="In questa armonia risiede una\nbellezza senza pari!", spanish="En conjunto, es un cuadro inolvidable;\nlleno de armonía."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 200, 360, Direction.Up, "NPC_PUKURIN")
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" The treasure!", french=" Le trésor!", german=" Der Schatz!", italian=" Il tesoro!", spanish=" ¡Eso es el tesoro!"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="The treasure...[K]must be the view\nof [CS:P]Fogbound Lake[CR]!", french="Le trésor...[K] ça doit être\nle spectacle du [CS:P]Lac des Brumes[CR]!", german="Der Schatz...[K] Der Anblick des\n[CS:P]Nebelsees[CR] muss der Schatz sein!", italian="Il tesoro...[K] dev'essere questa\nvista sul [CS:P]Lago Foschia[CR]!", spanish="El tesoro...[K] ¡ha de ser esta vista\ndel [CS:P]Lago Velado[CR]!"})
  -- message_Close
  GAME:FadeOut(false, 60)
  SkySceneKit.cleanup_npcs()
end
