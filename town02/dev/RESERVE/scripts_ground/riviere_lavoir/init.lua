--[[ Rivière du Lavoir — Friend Area importee 1:1 (arene/cinematique de boss, vague 6).
     Assignation : réserve rivière
     Squelette : casting et cinematique a poser au cablage du chapitre. ]]
local riviere_lavoir = {}

function riviere_lavoir.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_riviere_lavoir")
  COMMON.RespawnAllies()
end

function riviere_lavoir.Enter(map)
  GAME:FadeIn(20)
end

function riviere_lavoir.Update(map, time)
end

return riviere_lavoir
