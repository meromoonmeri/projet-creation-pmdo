--[[ Lac de la Cascade — Friend Area importee 1:1 (arene/cinematique de boss, vague 6).
     Assignation : arène Keldeo ch18 (alt.)
     Squelette : casting et cinematique a poser au cablage du chapitre. ]]
local lac_cascade = {}

function lac_cascade.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_lac_cascade")
  COMMON.RespawnAllies()
end

function lac_cascade.Enter(map)
  GAME:FadeIn(20)
end

function lac_cascade.Update(map, time)
end

return lac_cascade
