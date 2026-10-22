--[[ Orée du Bois d'Antan — ground importe (format RogueEssence natif, vague 4).
     Assignation : ch20 Celebi - entrée
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local purity_forest_oree = {}

function purity_forest_oree.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_purity_forest_oree")
  COMMON.RespawnAllies()
end

function purity_forest_oree.Enter(map)
  GAME:FadeIn(20)
end

function purity_forest_oree.Update(map, time)
end

return purity_forest_oree
