--[[ Belles Plaines — Friend Area importee 1:1 (arene/cinematique de boss, vague 6).
     Assignation : réserve plaine
     Squelette : casting et cinematique a poser au cablage du chapitre. ]]
local belles_plaines = {}

function belles_plaines.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_belles_plaines")
  COMMON.RespawnAllies()
end

function belles_plaines.Enter(map)
  GAME:FadeIn(20)
end

function belles_plaines.Update(map, time)
end

return belles_plaines
