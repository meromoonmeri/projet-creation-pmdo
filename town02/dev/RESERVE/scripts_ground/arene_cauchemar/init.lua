--[[ Arène du Cauchemar — ground importe (format RogueEssence natif, vague 4).
     Assignation : ch23 Darkrai - cinématique Cour du Clair de Lune
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local arene_cauchemar = {}

function arene_cauchemar.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_arene_cauchemar")
  COMMON.RespawnAllies()
end

function arene_cauchemar.Enter(map)
  GAME:FadeIn(20)
end

function arene_cauchemar.Update(map, time)
end

return arene_cauchemar
