--[[ Porte de la Forge de Vapeur — ground importe (format RogueEssence natif, vague 4).
     Assignation : ch23 Volcanion - entrée
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local forge_vapeur_porte = {}

function forge_vapeur_porte.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_forge_vapeur_porte")
  COMMON.RespawnAllies()
end

function forge_vapeur_porte.Enter(map)
  GAME:FadeIn(20)
end

function forge_vapeur_porte.Update(map, time)
end

return forge_vapeur_porte
