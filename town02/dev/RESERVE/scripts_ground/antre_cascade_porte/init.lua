--[[ Porte de l'Antre de la Cascade — ground importe (format RogueEssence natif, vague 4).
     Assignation : RÉSERVE ch7 secondaire (plan EoSO)
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local antre_cascade_porte = {}

function antre_cascade_porte.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_antre_cascade_porte")
  COMMON.RespawnAllies()
end

function antre_cascade_porte.Enter(map)
  GAME:FadeIn(20)
end

function antre_cascade_porte.Update(map, time)
end

return antre_cascade_porte
