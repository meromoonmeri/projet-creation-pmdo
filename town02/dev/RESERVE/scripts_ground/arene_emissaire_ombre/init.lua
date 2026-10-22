--[[ Arène de l'Émissaire de l'Ombre — ground importe (format RogueEssence natif, vague 4).
     Assignation : RÉSERVE arc Cercle du Suaire (Accusation ch14-15)
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local arene_emissaire_ombre = {}

function arene_emissaire_ombre.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_arene_emissaire_ombre")
  COMMON.RespawnAllies()
end

function arene_emissaire_ombre.Enter(map)
  GAME:FadeIn(20)
end

function arene_emissaire_ombre.Update(map, time)
end

return arene_emissaire_ombre
