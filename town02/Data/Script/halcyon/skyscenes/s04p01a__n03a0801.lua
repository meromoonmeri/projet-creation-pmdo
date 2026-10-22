-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/S04P01A/n03a0801.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Hmm...[K] I think that's as far as\nI can go.", french="Mmh...[K] Je crois que j'irai\npas plus loin.", german="Hmmm...[K] Ich denke, das ist es.\nWeiter komme ich nicht...", italian="Mmm...[K] Non credo di poter\nandare più avanti di così.", spanish="Hum...[K] Por lo visto no voy a\nlograr avanzar yo solo."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Master told me to come today...", french="Le Maître m'avait dit de venir\naujourd'hui...", german="Der Meister wollte eigentlich,\ndass ich heute komme...", italian="Il maestro mi ha detto di venire\noggi...", spanish="El maestro me dijo que fuera\na verlo hoy..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="But I think it's all right. ♪[K]\nTime to head home for the day. ♪", french="Mais tant pis. ♪[K]\nC'est l'heure de rentrer à la\nmaison maintenant. ♪", german="Aber das ist schon in\nOrndung. ♪[K] Für heute ist es Zeit, nach Hause\nzu gehen. ♪", italian="Ma penso che vada bene così. ♪[K]\nÈ ora di tornare a casa. ♪", spanish="Pero se ha hecho algo tarde. ♪[K]\nYa es hora de volver a casa. ♪"})
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
end
