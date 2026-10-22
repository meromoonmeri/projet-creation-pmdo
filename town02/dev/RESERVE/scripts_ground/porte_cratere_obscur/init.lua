--[[ Porte du Cratère Obscur — ground importe (format RogueEssence natif, vague 4).
     Assignation : ch11 Groudon - entrée alt.
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local porte_cratere_obscur = {}

function porte_cratere_obscur.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_porte_cratere_obscur")
  COMMON.RespawnAllies()
end

function porte_cratere_obscur.Enter(map)
  GAME:FadeIn(20)
end

function porte_cratere_obscur.Update(map, time)
end

return porte_cratere_obscur
