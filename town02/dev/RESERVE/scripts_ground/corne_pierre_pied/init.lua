--[[ Pied de la Corne de Pierre — ground importe (format RogueEssence natif, vague 4).
     Assignation : RÉSERVE entrée montagne (secondaires ch11+)
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local corne_pierre_pied = {}

function corne_pierre_pied.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_corne_pierre_pied")
  COMMON.RespawnAllies()
end

function corne_pierre_pied.Enter(map)
  GAME:FadeIn(20)
end

function corne_pierre_pied.Update(map, time)
end

return corne_pierre_pied
