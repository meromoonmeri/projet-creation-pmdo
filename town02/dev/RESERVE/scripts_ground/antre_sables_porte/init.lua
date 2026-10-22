--[[ Porte de l'Antre des Sables — ground importe (format RogueEssence natif, vague 4).
     Assignation : RÉSERVE donjon désert (Furnace_Desert FA)
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local antre_sables_porte = {}

function antre_sables_porte.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_antre_sables_porte")
  COMMON.RespawnAllies()
end

function antre_sables_porte.Enter(map)
  GAME:FadeIn(20)
end

function antre_sables_porte.Update(map, time)
end

return antre_sables_porte
