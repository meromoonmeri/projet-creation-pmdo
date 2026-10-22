--[[ Marécage Brun — Friend Area importee 1:1 (arene/cinematique de boss, vague 6).
     Assignation : réserve marais (déjà FA_Peanut tileset)
     Squelette : casting et cinematique a poser au cablage du chapitre. ]]
local marecage_cacahuete = {}

function marecage_cacahuete.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_marecage_cacahuete")
  COMMON.RespawnAllies()
end

function marecage_cacahuete.Enter(map)
  GAME:FadeIn(20)
end

function marecage_cacahuete.Update(map, time)
end

return marecage_cacahuete
