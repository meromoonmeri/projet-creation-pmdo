--[[ Pic Arc-en-Ciel — Friend Area importee 1:1 (arene/cinematique de boss, vague 6).
     Assignation : arène Ho-Oh ch18 (alt.) - écho visuel arène Lugia ch10
     Squelette : casting et cinematique a poser au cablage du chapitre. ]]
local pic_arc_en_ciel = {}

function pic_arc_en_ciel.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_pic_arc_en_ciel")
  COMMON.RespawnAllies()
end

function pic_arc_en_ciel.Enter(map)
  GAME:FadeIn(20)
end

function pic_arc_en_ciel.Update(map, time)
end

return pic_arc_en_ciel
