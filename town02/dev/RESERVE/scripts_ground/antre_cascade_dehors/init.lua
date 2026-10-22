--[[ Abords de l'Antre de la Cascade — ground importe (format RogueEssence natif, vague 4).
     Assignation : RÉSERVE
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local antre_cascade_dehors = {}

function antre_cascade_dehors.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_antre_cascade_dehors")
  COMMON.RespawnAllies()
end

function antre_cascade_dehors.Enter(map)
  GAME:FadeIn(20)
end

function antre_cascade_dehors.Update(map, time)
end

return antre_cascade_dehors
