--[[ Désert de la Fournaise — Friend Area importee 1:1 (arene/cinematique de boss, vague 6).
     Assignation : réserve désert (tileset FA déjà là)
     Squelette : casting et cinematique a poser au cablage du chapitre. ]]
local desert_fournaise = {}

function desert_fournaise.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_desert_fournaise")
  COMMON.RespawnAllies()
end

function desert_fournaise.Enter(map)
  GAME:FadeIn(20)
end

function desert_fournaise.Update(map, time)
end

return desert_fournaise
