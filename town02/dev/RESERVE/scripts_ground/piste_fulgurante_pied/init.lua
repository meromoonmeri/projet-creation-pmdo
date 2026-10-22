--[[ Pied de la Piste Fulgurante — ground importe (format RogueEssence natif, vague 4).
     Assignation : ch25 Zeraora - entrée
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local piste_fulgurante_pied = {}

function piste_fulgurante_pied.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_piste_fulgurante_pied")
  COMMON.RespawnAllies()
end

function piste_fulgurante_pied.Enter(map)
  GAME:FadeIn(20)
end

function piste_fulgurante_pied.Update(map, time)
end

return piste_fulgurante_pied
