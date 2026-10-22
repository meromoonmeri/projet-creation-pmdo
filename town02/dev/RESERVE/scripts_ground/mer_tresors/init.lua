--[[ Mer aux Trésors — Friend Area importee 1:1 (arene/cinematique de boss, vague 6).
     Assignation : réserve arène marine
     Squelette : casting et cinematique a poser au cablage du chapitre. ]]
local mer_tresors = {}

function mer_tresors.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_mer_tresors")
  COMMON.RespawnAllies()
end

function mer_tresors.Enter(map)
  GAME:FadeIn(20)
end

function mer_tresors.Update(map, time)
end

return mer_tresors
