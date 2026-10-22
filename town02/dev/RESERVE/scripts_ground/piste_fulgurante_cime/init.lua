--[[ Cime de la Piste Fulgurante — ground importe (format RogueEssence natif, vague 4).
     Assignation : ch25 Zeraora - cinématique
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local piste_fulgurante_cime = {}

function piste_fulgurante_cime.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_piste_fulgurante_cime")
  COMMON.RespawnAllies()
end

function piste_fulgurante_cime.Enter(map)
  GAME:FadeIn(20)
end

function piste_fulgurante_cime.Update(map, time)
end

return piste_fulgurante_cime
