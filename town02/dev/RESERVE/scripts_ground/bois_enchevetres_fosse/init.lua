--[[ Fosse des Bois Enchevêtrés — ground importe (format RogueEssence natif, vague 4).
     Assignation : ch26 Mew - mi-parcours
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local bois_enchevetres_fosse = {}

function bois_enchevetres_fosse.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_bois_enchevetres_fosse")
  COMMON.RespawnAllies()
end

function bois_enchevetres_fosse.Enter(map)
  GAME:FadeIn(20)
end

function bois_enchevetres_fosse.Update(map, time)
end

return bois_enchevetres_fosse
