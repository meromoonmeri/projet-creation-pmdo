--[[ Cratère Fumant — Friend Area importee 1:1 (arene/cinematique de boss, vague 6).
     Assignation : arène Heatran (réservé fiches_boss - SON arène attitrée)
     Squelette : casting et cinematique a poser au cablage du chapitre. ]]
local cratere_fumant = {}

function cratere_fumant.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_cratere_fumant")
  COMMON.RespawnAllies()
end

function cratere_fumant.Enter(map)
  GAME:FadeIn(20)
end

function cratere_fumant.Update(map, time)
end

return cratere_fumant
