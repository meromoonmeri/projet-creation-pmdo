--[[ Fosse du Gué du Poulain — ground importe (format RogueEssence natif, vague 4).
     Assignation : ch18 Keldeo - mi-parcours
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local gue_poulain_fosse = {}

function gue_poulain_fosse.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_gue_poulain_fosse")
  COMMON.RespawnAllies()
end

function gue_poulain_fosse.Enter(map)
  GAME:FadeIn(20)
end

function gue_poulain_fosse.Update(map, time)
end

return gue_poulain_fosse
