--[[ Forêt de la Mue — Friend Area importee 1:1 (arene/cinematique de boss, vague 6).
     Assignation : arène Mew ch26 (alt. Ditto lore)
     Squelette : casting et cinematique a poser au cablage du chapitre. ]]
local foret_mue = {}

function foret_mue.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_foret_mue")
  COMMON.RespawnAllies()
end

function foret_mue.Enter(map)
  GAME:FadeIn(20)
end

function foret_mue.Update(map, time)
end

return foret_mue
