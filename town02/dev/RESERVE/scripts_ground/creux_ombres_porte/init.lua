--[[ Porte du Creux des Ombres — ground importe (format RogueEssence natif, vague 4).
     Assignation : ch26 Marshadow - entrée
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local creux_ombres_porte = {}

function creux_ombres_porte.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_creux_ombres_porte")
  COMMON.RespawnAllies()
end

function creux_ombres_porte.Enter(map)
  GAME:FadeIn(20)
end

function creux_ombres_porte.Update(map, time)
end

return creux_ombres_porte
