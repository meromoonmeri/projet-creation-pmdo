--[[ Mont de la Discipline — Friend Area importee 1:1 (arene/cinematique de boss, vague 6).
     Assignation : arène Keldeo/Kubfu (dojo) - réserve
     Squelette : casting et cinematique a poser au cablage du chapitre. ]]
local mont_discipline = {}

function mont_discipline.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_mont_discipline")
  COMMON.RespawnAllies()
end

function mont_discipline.Enter(map)
  GAME:FadeIn(20)
end

function mont_discipline.Update(map, time)
end

return mont_discipline
