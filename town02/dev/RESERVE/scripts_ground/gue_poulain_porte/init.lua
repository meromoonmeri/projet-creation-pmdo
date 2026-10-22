--[[ Porte du Gué du Poulain — ground importe (format RogueEssence natif, vague 4).
     Assignation : ch18 Keldeo - entrée
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local gue_poulain_porte = {}

function gue_poulain_porte.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_gue_poulain_porte")
  COMMON.RespawnAllies()
end

function gue_poulain_porte.Enter(map)
  GAME:FadeIn(20)
end

function gue_poulain_porte.Update(map, time)
end

return gue_poulain_porte
