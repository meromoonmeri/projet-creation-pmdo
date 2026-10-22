-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D15P41A/m14d0812.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_D15P41A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_emuritto = SkySceneKit.spawn_npc("mesprit", 304, 224, Direction.Down, "NPC_EMURITTO")
  pcall(function() UI:SetSpeaker(npc_npc_emuritto) end)
  SkySceneKit.say({english=" Don't lie to me!", french=" Epargnez-moi vos mensonges!", german=" Lügt mich nicht an!", italian=" Non mentitemi!", spanish=" ¡Basta de mentiras!"})
  pcall(function() UI:SetSpeaker(npc_npc_emuritto) end)
  SkySceneKit.say({english="[CS:N]Uxie[CR] used his telepathy to tell\nme what happened!", french="Je sais tout! [CS:N]Créhelf[CR] m'a\navertie par télépathie!", german="[CS:N]Selfe[CR] hat mir per Telepathie\nerzählt, was geschehen ist!", italian="[CS:N]Uxie[CR] si è messo in contatto\ntelepatico con me e mi ha raccontato tutto!", spanish="¡[CS:N]Uxie[CR] me ha contado\ntelepáticamente lo que ocurrió!"})
  pcall(function() UI:SetSpeaker(npc_npc_emuritto) end)
  SkySceneKit.say({english="I know that the Time Gear from\n[CS:P]Fogbound Lake[CR] was stolen!", french="Je sais que le Rouage du Temps\ndu [CS:P]Lac des Brumes[CR] a disparu!", german="Ich weiß, dass das Zahnrad der\nZeit vom [CS:P]Nebelsee[CR] gestohlen wurde!", italian="So benissimo che l'Ingranaggio\ndel Tempo del [CS:P]Lago Foschia[CR] è stato rubato!", spanish="¡Sé que robasteis el Engranaje\ndel Tiempo del [CS:P]Lago Velado[CR]!"})
  -- message_Close
  GAME:FadeOut(false, 30)
  GAME:FadeIn(0) -- screen_FlushIn
  SkySceneKit.cleanup_npcs()
end
