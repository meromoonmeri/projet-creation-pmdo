--[[ Porte de la Gorge Ardente — ground importe 1:1 (reserve, non branche a une zone pour l'instant).
     Squelette standard : a completer lors du branchement (cf. document maitre). ]]
local gorge_ardente_porte = {}

function gorge_ardente_porte.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_gorge_ardente_porte")
  COMMON.RespawnAllies()
end

function gorge_ardente_porte.Enter(map)
  GAME:FadeIn(20)
end

function gorge_ardente_porte.Update(map, time)
end

return gorge_ardente_porte
