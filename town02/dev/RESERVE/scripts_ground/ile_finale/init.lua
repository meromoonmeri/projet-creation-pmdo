--[[ Île Finale — Friend Area importee 1:1 (arene/cinematique de boss, vague 6).
     Assignation : arène Eternatus/Arceus ch32 - cinématique finale
     Squelette : casting et cinematique a poser au cablage du chapitre. ]]
local ile_finale = {}

function ile_finale.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_ile_finale")
  COMMON.RespawnAllies()
end

function ile_finale.Enter(map)
  GAME:FadeIn(20)
end

function ile_finale.Update(map, time)
end

return ile_finale
