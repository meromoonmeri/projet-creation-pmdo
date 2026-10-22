--[[ Orée de la Forêt des Brumes — ground importe (format RogueEssence natif, vague 4).
     Assignation : RÉSERVE (arc Accusation - brume/clandestinité)
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local foret_brumes_oree = {}

function foret_brumes_oree.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_foret_brumes_oree")
  COMMON.RespawnAllies()
end

function foret_brumes_oree.Enter(map)
  GAME:FadeIn(20)
end

function foret_brumes_oree.Update(map, time)
end

return foret_brumes_oree
