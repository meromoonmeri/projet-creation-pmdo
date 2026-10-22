--[[ Grève de la Banquise — Friend Area importee 1:1 (arene/cinematique de boss, vague 6).
     Assignation : réserve glace
     Squelette : casting et cinematique a poser au cablage du chapitre. ]]
local greve_banquise = {}

function greve_banquise.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_greve_banquise")
  COMMON.RespawnAllies()
end

function greve_banquise.Enter(map)
  GAME:FadeIn(20)
end

function greve_banquise.Update(map, time)
end

return greve_banquise
