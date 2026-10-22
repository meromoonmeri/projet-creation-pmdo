--[[ Plaines d'Azur — Friend Area importee 1:1 (arene/cinematique de boss, vague 6).
     Assignation : réserve plaine
     Squelette : casting et cinematique a poser au cablage du chapitre. ]]
local plaines_azur = {}

function plaines_azur.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_plaines_azur")
  COMMON.RespawnAllies()
end

function plaines_azur.Enter(map)
  GAME:FadeIn(20)
end

function plaines_azur.Update(map, time)
end

return plaines_azur
