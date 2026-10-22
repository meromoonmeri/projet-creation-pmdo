--[[ Abords de l'Antre des Sables — ground importe (format RogueEssence natif, vague 4).
     Assignation : RÉSERVE donjon désert
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local antre_sables_dehors = {}

function antre_sables_dehors.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_antre_sables_dehors")
  COMMON.RespawnAllies()
end

function antre_sables_dehors.Enter(map)
  GAME:FadeIn(20)
end

function antre_sables_dehors.Update(map, time)
end

return antre_sables_dehors
