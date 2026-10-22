--[[ Grève Claire — Friend Area importee 1:1 (arene/cinematique de boss, vague 6).
     Assignation : réserve cinématique plage
     Squelette : casting et cinematique a poser au cablage du chapitre. ]]
local greve_claire = {}

function greve_claire.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_greve_claire")
  COMMON.RespawnAllies()
end

function greve_claire.Enter(map)
  GAME:FadeIn(20)
end

function greve_claire.Update(map, time)
end

return greve_claire
