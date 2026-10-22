--[[ Plaines Sauvages — Friend Area importee 1:1 (arene/cinematique de boss, vague 6).
     Assignation : réserve plaine
     Squelette : casting et cinematique a poser au cablage du chapitre. ]]
local plaines_sauvages = {}

function plaines_sauvages.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_plaines_sauvages")
  COMMON.RespawnAllies()
end

function plaines_sauvages.Enter(map)
  GAME:FadeIn(20)
end

function plaines_sauvages.Update(map, time)
end

return plaines_sauvages
