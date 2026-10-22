--[[ Cœur du Crépuscule — ground importe (format RogueEssence natif, vague 4).
     Assignation : ch32 Necrozma - mi-parcours
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local coeur_crepuscule = {}

function coeur_crepuscule.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_coeur_crepuscule")
  COMMON.RespawnAllies()
end

function coeur_crepuscule.Enter(map)
  GAME:FadeIn(20)
end

function coeur_crepuscule.Update(map, time)
end

return coeur_crepuscule
