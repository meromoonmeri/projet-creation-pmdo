--[[ Dédale Final de l'Ossatueur — ground importe (format RogueEssence natif, vague 4).
     Assignation : RÉSERVE maze final dojo
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local dojo_ossatueur_final = {}

function dojo_ossatueur_final.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_dojo_ossatueur_final")
  COMMON.RespawnAllies()
end

function dojo_ossatueur_final.Enter(map)
  GAME:FadeIn(20)
end

function dojo_ossatueur_final.Update(map, time)
end

return dojo_ossatueur_final
