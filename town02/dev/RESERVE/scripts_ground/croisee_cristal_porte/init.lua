--[[ Porte de la Croisée de Cristal — ground importe (format RogueEssence natif, vague 4).
     Assignation : ch20 Meloetta - entrée Amphithéâtre
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local croisee_cristal_porte = {}

function croisee_cristal_porte.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_croisee_cristal_porte")
  COMMON.RespawnAllies()
end

function croisee_cristal_porte.Enter(map)
  GAME:FadeIn(20)
end

function croisee_cristal_porte.Update(map, time)
end

return croisee_cristal_porte
