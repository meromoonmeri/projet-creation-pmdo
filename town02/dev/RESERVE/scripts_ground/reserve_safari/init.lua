--[[ Réserve Safari — Friend Area importee 1:1 (arene/cinematique de boss, vague 6).
     Assignation : réserve
     Squelette : casting et cinematique a poser au cablage du chapitre. ]]
local reserve_safari = {}

function reserve_safari.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_reserve_safari")
  COMMON.RespawnAllies()
end

function reserve_safari.Enter(map)
  GAME:FadeIn(20)
end

function reserve_safari.Update(map, time)
end

return reserve_safari
