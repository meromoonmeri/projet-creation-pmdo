--[[ Courant Profond — Friend Area importee 1:1 (arene/cinematique de boss, vague 6).
     Assignation : réserve marine
     Squelette : casting et cinematique a poser au cablage du chapitre. ]]
local courant_profond = {}

function courant_profond.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_courant_profond")
  COMMON.RespawnAllies()
end

function courant_profond.Enter(map)
  GAME:FadeIn(20)
end

function courant_profond.Update(map, time)
end

return courant_profond
