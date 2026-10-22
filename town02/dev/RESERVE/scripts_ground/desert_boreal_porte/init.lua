--[[ Porte du Désert Boréal — ground importe (format RogueEssence natif, vague 4).
     Assignation : RÉSERVE donjon désert 2
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local desert_boreal_porte = {}

function desert_boreal_porte.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_desert_boreal_porte")
  COMMON.RespawnAllies()
end

function desert_boreal_porte.Enter(map)
  GAME:FadeIn(20)
end

function desert_boreal_porte.Update(map, time)
end

return desert_boreal_porte
