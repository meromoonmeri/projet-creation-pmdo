--[[ Vision de Tempête B — ground importe (format RogueEssence natif, vague 4).
     Assignation : ch12 Kyogre - cinématique 2
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local tempete_vision_b = {}

function tempete_vision_b.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_tempete_vision_b")
  COMMON.RespawnAllies()
end

function tempete_vision_b.Enter(map)
  GAME:FadeIn(20)
end

function tempete_vision_b.Update(map, time)
end

return tempete_vision_b
