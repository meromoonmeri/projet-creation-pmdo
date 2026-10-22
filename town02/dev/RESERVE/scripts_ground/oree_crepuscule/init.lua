--[[ Orée du Crépuscule — ground importe (format RogueEssence natif, vague 4).
     Assignation : ch32 Necrozma - entrée Sentier Éteint
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local oree_crepuscule = {}

function oree_crepuscule.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_oree_crepuscule")
  COMMON.RespawnAllies()
end

function oree_crepuscule.Enter(map)
  GAME:FadeIn(20)
end

function oree_crepuscule.Update(map, time)
end

return oree_crepuscule
