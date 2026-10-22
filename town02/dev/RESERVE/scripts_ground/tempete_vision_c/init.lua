--[[ Vision de Tempête C — ground importe (format RogueEssence natif, vague 4).
     Assignation : ch12 Kyogre - cinématique 3
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local tempete_vision_c = {}

function tempete_vision_c.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_tempete_vision_c")
  COMMON.RespawnAllies()
end

function tempete_vision_c.Enter(map)
  GAME:FadeIn(20)
end

function tempete_vision_c.Update(map, time)
end

return tempete_vision_c
