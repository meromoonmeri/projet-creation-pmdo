--[[ Mont Vert-Profond — Friend Area importee 1:1 (arene/cinematique de boss, vague 6).
     Assignation : réserve montagne
     Squelette : casting et cinematique a poser au cablage du chapitre. ]]
local mont_vertprofond = {}

function mont_vertprofond.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_mont_vertprofond")
  COMMON.RespawnAllies()
end

function mont_vertprofond.Enter(map)
  GAME:FadeIn(20)
end

function mont_vertprofond.Update(map, time)
end

return mont_vertprofond
