--[[ Orée des Bois Enchevêtrés — ground importe (format RogueEssence natif, vague 4).
     Assignation : ch26 Mew - entrée
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local bois_enchevetres_oree = {}

function bois_enchevetres_oree.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_bois_enchevetres_oree")
  COMMON.RespawnAllies()
end

function bois_enchevetres_oree.Enter(map)
  GAME:FadeIn(20)
end

function bois_enchevetres_oree.Update(map, time)
end

return bois_enchevetres_oree
