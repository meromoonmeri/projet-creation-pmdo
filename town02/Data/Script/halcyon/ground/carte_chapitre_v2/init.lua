--[[ Carte de Chapitre II — ground importe (format RogueEssence natif, vague 4).
     Assignation : RÉSERVE outil narratif (cartes de chapitre Livre II)
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local carte_chapitre_v2 = {}

function carte_chapitre_v2.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_carte_chapitre_v2")
  COMMON.RespawnAllies()
end

function carte_chapitre_v2.Enter(map)
  GAME:FadeIn(20)
end

function carte_chapitre_v2.Update(map, time)
end

return carte_chapitre_v2
