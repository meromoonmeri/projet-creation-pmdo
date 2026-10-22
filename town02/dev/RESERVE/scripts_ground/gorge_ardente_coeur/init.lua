--[[ Cœur de la Gorge Ardente — arene de cinematique importee 1:1 de pmd-red (reserve, non branchee).
     Casting du boss d'origine CONSERVE (regle Partie 6). Decor material-layer GBA :
     compenser par Background anime / retiling biome au branchement (cf. arene Lugia). ]]
local gorge_ardente_coeur = {}

function gorge_ardente_coeur.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_gorge_ardente_coeur")
  COMMON.RespawnAllies()
end

function gorge_ardente_coeur.Enter(map)
  GAME:FadeIn(20)
end

function gorge_ardente_coeur.Update(map, time)
end

return gorge_ardente_coeur
