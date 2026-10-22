--[[ Fond de la Falaise Trempée — ground importe (format RogueEssence natif, vague 4).
     Assignation : RÉSERVE côte
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local falaise_trempee_fond = {}

function falaise_trempee_fond.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_falaise_trempee_fond")
  COMMON.RespawnAllies()
end

function falaise_trempee_fond.Enter(map)
  GAME:FadeIn(20)
end

function falaise_trempee_fond.Update(map, time)
end

return falaise_trempee_fond
