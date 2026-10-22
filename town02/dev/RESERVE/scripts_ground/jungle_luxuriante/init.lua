--[[ Jungle Luxuriante — Friend Area importee 1:1 (arene/cinematique de boss, vague 6).
     Assignation : arène Hoopa ch26 (Cache du Porteur d'Anneaux)
     Squelette : casting et cinematique a poser au cablage du chapitre. ]]
local jungle_luxuriante = {}

function jungle_luxuriante.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_jungle_luxuriante")
  COMMON.RespawnAllies()
end

function jungle_luxuriante.Enter(map)
  GAME:FadeIn(20)
end

function jungle_luxuriante.Update(map, time)
end

return jungle_luxuriante
