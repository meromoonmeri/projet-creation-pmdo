--[[ Relique Ancienne — Friend Area importee 1:1 (arene/cinematique de boss, vague 6).
     Assignation : arène Dialga ch28 (Tour des Reliques) - cinématique
     Squelette : casting et cinematique a poser au cablage du chapitre. ]]
local relique_ancienne = {}

function relique_ancienne.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_relique_ancienne")
  COMMON.RespawnAllies()
end

function relique_ancienne.Enter(map)
  GAME:FadeIn(20)
end

function relique_ancienne.Update(map, time)
end

return relique_ancienne
