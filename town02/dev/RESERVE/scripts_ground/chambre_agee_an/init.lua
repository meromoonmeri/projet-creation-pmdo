--[[ Chambre des Âges I — Friend Area importee 1:1 (arene/cinematique de boss, vague 6).
     Assignation : arène Registeel/Unown - réserve reliques
     Squelette : casting et cinematique a poser au cablage du chapitre. ]]
local chambre_agee_an = {}

function chambre_agee_an.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_chambre_agee_an")
  COMMON.RespawnAllies()
end

function chambre_agee_an.Enter(map)
  GAME:FadeIn(20)
end

function chambre_agee_an.Update(map, time)
end

return chambre_agee_an
