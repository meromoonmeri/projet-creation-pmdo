-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/S04P01A/n02a0601.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:SetSpeaker("Skorupi", true, "skorupi", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_SUKORUPI (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Ooogh...[K] It's a bit tough...", french=" Aaargh...[K] La raclée...", german="Uuuuff...[K]\nDas ist ganz schön hart...", italian=" Argh...[K] Non è facile...", spanish=" Uf...[K] Es un poco difícil..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Banette", true, "banette", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_JUPETTA (espèce ROM, sans placement zone)
  SkySceneKit.say({english="I've got no choice.[K] I'll just go\nhome for tonight...", french="Pas le choix.[K] Faut que je rentre\nà la maison pour ce soir...", german="Mir bleibt keine andere Wahl.[K]\nIch werde für heute nach Hause gehen...", italian="Non c'è altra scelta.[K] Per oggi\ntorniamo a casa...", spanish="No hay nada que hacer.[K] Ya es\nhora de volver a casa..."})
  pcall(function() UI:SetSpeaker("Banette", true, "banette", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_JUPETTA (espèce ROM, sans placement zone)
  SkySceneKit.say({english="But I'm not giving up![K] I'll try\nagain tomorrow!", french="Mais ça veut pas dire que\nj'abandonne![K] Je réessaierai demain!", german="Aber ich gebe nicht auf![K]\nMorgen ist auch noch ein Tag!", italian="Ma non dobbiamo arrenderci![K] Ci\nriproveremo domani!", spanish="¡Pero no pienso rendirme![K]\nMañana vuelvo a intentarlo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yeah. ♪", french=" Ouais! ♪", german=" Ja, genau. ♪", italian=" Sì. ♪", spanish=" Eso. ♪"})
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
end
