--[[ Haut de la Forge de Vapeur — ground importe (format RogueEssence natif, vague 4).
     Assignation : ch23 Volcanion - accès sommet (tileset source absent, décor à refaire)
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local forge_vapeur_haut = {}

function forge_vapeur_haut.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_forge_vapeur_haut")
  COMMON.RespawnAllies()
end

function forge_vapeur_haut.Enter(map)
  GAME:FadeIn(20)
end

function forge_vapeur_haut.Update(map, time)
end

return forge_vapeur_haut
