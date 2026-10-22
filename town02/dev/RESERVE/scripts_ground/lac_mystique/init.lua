--[[ Lac Mystique — Friend Area importee 1:1 (arene/cinematique de boss, vague 6).
     Assignation : arène trio des lacs ch13 (Créhelf/Créfollet/Créfadet)
     Squelette : casting et cinematique a poser au cablage du chapitre. ]]
local lac_mystique = {}

function lac_mystique.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_lac_mystique")
  COMMON.RespawnAllies()
end

function lac_mystique.Enter(map)
  GAME:FadeIn(20)
end

function lac_mystique.Update(map, time)
end

return lac_mystique
