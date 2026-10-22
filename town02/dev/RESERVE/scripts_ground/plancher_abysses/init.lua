--[[ Plancher des Abysses — Friend Area importee 1:1 (arene/cinematique de boss, vague 6).
     Assignation : arène Kyogre ch12 (alt. cinématique)
     Squelette : casting et cinematique a poser au cablage du chapitre. ]]
local plancher_abysses = {}

function plancher_abysses.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_plancher_abysses")
  COMMON.RespawnAllies()
end

function plancher_abysses.Enter(map)
  GAME:FadeIn(20)
end

function plancher_abysses.Update(map, time)
end

return plancher_abysses
