--[[ Mare aux Têtards — Friend Area importee 1:1 (arene/cinematique de boss, vague 6).
     Assignation : réserve
     Squelette : casting et cinematique a poser au cablage du chapitre. ]]
local mare_tetards = {}

function mare_tetards.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_mare_tetards")
  COMMON.RespawnAllies()
end

function mare_tetards.Enter(map)
  GAME:FadeIn(20)
end

function mare_tetards.Update(map, time)
end

return mare_tetards
