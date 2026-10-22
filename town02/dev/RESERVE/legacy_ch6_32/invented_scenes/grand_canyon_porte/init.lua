--[[ Porte du Grand Canyon — ground importé (format RogueEssence natif, vague 4).
     Assignation : Réserve entrée de donjon / cinématique d'approche du Canyon
     Squelette standard : à compléter lors du câblage de l'introduction du Canyon. ]]
local grand_canyon_porte = {}

function grand_canyon_porte.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_grand_canyon_porte")
  COMMON.RespawnAllies()
end

function grand_canyon_porte.Enter(map)
  GAME:FadeIn(20)
end

function grand_canyon_porte.Update(map, time)
end

return grand_canyon_porte
