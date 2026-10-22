--[[ Caverne Frigide — Friend Area importee 1:1 (arene/cinematique de boss, vague 6).
     Assignation : arène Glastrier/Calyrex (futur) - réserve glace
     Squelette : casting et cinematique a poser au cablage du chapitre. ]]
local caverne_frigide = {}

function caverne_frigide.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_caverne_frigide")
  COMMON.RespawnAllies()
end

function caverne_frigide.Enter(map)
  GAME:FadeIn(20)
end

function caverne_frigide.Update(map, time)
end

return caverne_frigide
