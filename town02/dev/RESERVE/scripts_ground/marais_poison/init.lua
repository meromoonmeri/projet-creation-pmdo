--[[ Marais Poison — Friend Area importee 1:1 (arene/cinematique de boss, vague 6).
     Assignation : réserve marais toxique
     Squelette : casting et cinematique a poser au cablage du chapitre. ]]
local marais_poison = {}

function marais_poison.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_marais_poison")
  COMMON.RespawnAllies()
end

function marais_poison.Enter(map)
  GAME:FadeIn(20)
end

function marais_poison.Update(map, time)
end

return marais_poison
