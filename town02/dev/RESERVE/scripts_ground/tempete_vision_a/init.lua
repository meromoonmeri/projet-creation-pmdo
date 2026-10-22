--[[ Vision de Tempête A — ground importe (format RogueEssence natif, vague 4).
     Assignation : ch12 Kyogre - cinématique tempête
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local tempete_vision_a = {}

function tempete_vision_a.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_tempete_vision_a")
  COMMON.RespawnAllies()
end

function tempete_vision_a.Enter(map)
  GAME:FadeIn(20)
end

function tempete_vision_a.Update(map, time)
end

return tempete_vision_a
