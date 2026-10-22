--[[ Porte de la Falaise Trempée — ground importe (format RogueEssence natif, vague 4).
     Assignation : RÉSERVE côte
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local falaise_trempee_porte = {}

function falaise_trempee_porte.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_falaise_trempee_porte")
  COMMON.RespawnAllies()
end

function falaise_trempee_porte.Enter(map)
  GAME:FadeIn(20)
end

function falaise_trempee_porte.Update(map, time)
end

return falaise_trempee_porte
